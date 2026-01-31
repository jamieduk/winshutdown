#!/bin/bash
# (c) J~Net 2026
#
# ./winshutdown.sh "192.168.1.50" "PasswordHere"
#

#=============================
# CONFIG / INPUT
#=============================
WIN_IP="$1"
WIN_PASS="$2"
WIN_USER="Administrator"
DELAY=5
MSG="System will shut down!...."

#=============================
# ASK FOR MISSING ARGS
#=============================
if [ -z "$WIN_IP" ]; then
    read -rp "Enter Windows IP: " WIN_IP
fi

if [ -z "$WIN_PASS" ]; then
    read -rsp "Enter Windows Password (leave blank for empty): " WIN_PASS
    echo ""
fi

#=============================
# DO NOT EDIT BELOW
#=============================

if ! command -v net >/dev/null 2>&1; then
    echo "Installing required libraries... sudo password maybe required..."
    sudo apt update -y
    sudo apt install -y samba-common-bin
fi

echo "[INFO] Sending shutdown request to $WIN_IP ..."

net rpc shutdown \
    -I "$WIN_IP" \
    -U "${WIN_USER}%${WIN_PASS}" \
    -t "$DELAY" \
    -C "$MSG"

if [ $? -eq 0 ]; then
    echo "[OK] Shutdown command sent successfully."
else
    echo "[FAIL] Shutdown failed (wrong creds, firewall, or permissions)."
fi

