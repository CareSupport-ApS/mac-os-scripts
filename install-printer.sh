#!/bin/bash

# Variables (adjust these if needed)
PRINTER_NAME="Nimbus_dfsdf"
ESCAPED_PRINTER_NAME=$(echo "$PRINTER_NAME" | sed 's/ /\\ /g')
DEVICE_URI="ipp://192.168.180.23/ipp/print" # something like ipp://Printer_IP/ipp/ or similar
GITHUB_PPD_URL="https://raw.githubusercontent.com/CareSupport-ApS/mac-os-scripts/main/ppds/Nimbus%20-%20BW.ppd" # Replace with the actual URL
PPD_DOWNLOAD_PATH="/tmp/YourPrinterName.ppd" # Temporary path for downloaded PPD #

# Check if printer exists and delete it
if lpstat -p "$ESCAPED_PRINTER_NAME" &>/dev/null; then
    sudo lpadmin -x "$ESCAPED_PRINTER_NAME"
fi


# Fetch the PPD from GitHub using curl
curl -L "$GITHUB_PPD_URL" -o "$PPD_DOWNLOAD_PATH"

# Use lpadmin to add or modify the printer
sudo lpadmin -p "$ESCAPED_PRINTER_NAME" -v "$DEVICE_URI" -P "$PPD_DOWNLOAD_PATH" -E

# Delete the downloaded PPD
rm "$PPD_DOWNLOAD_PATH"