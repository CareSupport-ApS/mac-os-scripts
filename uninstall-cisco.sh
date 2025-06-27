#!/bin/bash
# This script will uninstall the full install of Cisco AnyConnect with all the modules
# It will first look for the existence of the dart installer. If it is there, it will run.
# Then it will run the full anyconnect uninstaller. After that is completed, then we can install
# the new version of Cisco Anywhere that only installs the VPN component.

if [ -e "/opt/cisco/anyconnect/bin/dart_uninstall.sh" ]; then
    sh /opt/cisco/anyconnect/bin/dart_uninstall.sh
elif [ -e "/opt/cisco/secureclient/bin/vpn_uninstall.sh" ]; then
    sh /opt/cisco/secureclient/bin/vpn_uninstall.sh
elif [ -e "/opt/cisco/anyconnect/bin/anyconnect_uninstall.sh" ]; then
    sh /opt/cisco/anyconnect/bin/anyconnect_uninstall.sh
else
    echo 'No uninstaller found'
fi

exit 0

