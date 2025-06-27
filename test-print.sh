# Define path
SCRIPT_PATH="/tmp/caresupport/printer_setup_script.sh"

# If the script doesn't exist, download it
if [ ! -f "$SCRIPT_PATH" ]; then
    mkdir -p "$(dirname "$SCRIPT_PATH")"
    curl -L "https://raw.githubusercontent.com/CareSupport-ApS/mac-os-scripts/main/install-printer.sh" -o "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"
fi

# Run the script
"$SCRIPT_PATH" --printer-name "Nimbus_ny" --device-uri "ipp://192.168.180.23/ipp/print" --github-ppd-url "https://raw.githubusercontent.com/CareSupport-ApS/mac-os-scripts/main/ppds/Nimbus%20-%20BW.ppd"

"$SCRIPT_PATH" --printer-name "Nimbus_ny_24" --device-uri "ipp://192.168.180.24/ipp/print" --github-ppd-url "https://raw.githubusercontent.com/CareSupport-ApS/mac-os-scripts/main/ppds/Nimbus%20-%20BW.ppd"

"$SCRIPT_PATH" --printer-name "Nimbus_ny_farve_23" --device-uri "ipp://192.168.180.23/ipp/print" --github-ppd-url "https://raw.githubusercontent.com/CareSupport-ApS/mac-os-scripts/main/ppds/Nimbus%20-%20Farve.ppd"

"$SCRIPT_PATH" --printer-name "Nimbus_ny_farve_24" --device-uri "ipp://192.168.180.24/ipp/print" --github-ppd-url "https://raw.githubusercontent.com/CareSupport-ApS/mac-os-scripts/main/ppds/Nimbus%20-%20Farve.ppd"
