#!/bin/bash

# Initialize variables
PRINTER_NAME=""
DEVICE_URI=""
GITHUB_PPD_URL=""

# Process named parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --printer-name)
        PRINTER_NAME="$2"
        shift # past argument
        shift # past value
        ;;
        --device-uri)
        DEVICE_URI="$2"
        shift # past argument
        shift # past value
        ;;
        --github-ppd-url)
        GITHUB_PPD_URL="$2"
        shift # past argument
        shift # past value
        ;;
        *)
        echo "Invalid argument: $1"
        echo "Usage: $0 --printer-name <Printer Name> --device-uri <Device URI> --github-ppd-url <GitHub PPD URL>"
        exit 1
        ;;
    esac
done

# Check for necessary parameters
if [[ -z $PRINTER_NAME ]] || [[ -z $DEVICE_URI ]] || [[ -z $GITHUB_PPD_URL ]]; then
    echo "Missing arguments."
    echo "Usage: $0 --printer-name <Printer Name> --device-uri <Device URI> --github-ppd-url <GitHub PPD URL>"
    exit 1
fi

PPD_DOWNLOAD_PATH="/tmp/$(basename $GITHUB_PPD_URL)"
# Check if printer exists and delete it
if lpstat -p | grep -q "^$PRINTER_NAME "; then
    sudo lpadmin -x "$PRINTER_NAME"
fi

# Fetch the PPD from GitHub using curl
curl -L "$GITHUB_PPD_URL" -o "$PPD_DOWNLOAD_PATH"

# Use lpadmin to add or modify the printer
sudo lpadmin -p "$PRINTER_NAME" -v "$DEVICE_URI" -P "$PPD_DOWNLOAD_PATH" -E

# Delete the downloaded PPD
rm "$PPD_DOWNLOAD_PATH"