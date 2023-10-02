#!/bin/bash

# Variables (adjust these if needed)
PRINTER_NAME="YourPrinterName"
DEVICE_URI="ipp://192.168.180.23/ipp/print" # something like ipp://Printer_IP/ipp/ or similar
GITHUB_PPD_URL="https://github.com/YourGitHubPath/YourPrinterName.ppd" # Replace with the actual URL
PPD_DOWNLOAD_PATH="/tmp/YourPrinterName.ppd" # Temporary path for downloaded PPD #

# Fetch the PPD from GitHub using curl
curl -L "$GITHUB_PPD_URL" -o "$PPD_DOWNLOAD_PATH"

# Use lpadmin to add or modify the printer
sudo lpadmin -p "$PRINTER_NAME" -v "$DEVICE_URI" -P "$PPD_DOWNLOAD_PATH" -E