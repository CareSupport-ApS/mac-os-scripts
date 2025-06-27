#!/bin/bash

if [ -d "/Applications/ServerConnect.app" ]; then
  osascript -e 'quit app "ServerConnect"'
  rm -rf "/Applications/ServerConnect.app"
  rm -rf ~/ServerConnect
  rm -rf ~/.serverconnect
  rm -rf ~/.ServerConnect-master
  rm -rf ~/Library/Logs/ServerConnect*
  rm -rf ~/Library/Caches/ServerConnect*
  rm -rf ~/Library/Application\ Support/ServerConnect*
  rm -rf ~/Library/Preferences/com.getserverconnect.serverconnect.plist
  rm -rf ~/Library/LaunchAgents/com.getserverconnect.serverconnect.plist

  echo "ServerConnect has been uninstalled."
else
  echo "ServerConnect is not installed on this computer."
fi
