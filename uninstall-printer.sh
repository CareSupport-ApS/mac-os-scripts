#!/bin/bash

# List of printer names
declare -a PRINTER_NAMES=(
    "Nimbus gang"
    "Nimbus gangen"
    "Nimbus kopirum"
    "Nimbus gangen farve"
    "Nimbus gangen sort hvid"
    "Nimbus kopirum farve"
    "Nimbus kopirum sort hvid"
    "Nimbus_Gang_BW"
    "Nimbus_Kopirum_BW"
    "Nimbus_Kopirum_Farve"
    "Nimbus_Gang_Farve"
    "Nimbus gang"
)

# Loop through each printer name
for PRINTER_NAME in "${PRINTER_NAMES[@]}"; do
    # Check if the printer exists
    if lpstat -p | grep -q "^$PRINTER_NAME "; then
        # Remove the printer
        sudo lpadmin -x "$PRINTER_NAME"
        echo "Removed $PRINTER_NAME"
    else
        echo "$PRINTER_NAME not found."
    fi
done

