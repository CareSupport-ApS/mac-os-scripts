#!/bin/bash

if [ -d "/Applications/Support.app" ]; then
  osascript -e 'quit app "Support"'

  rm -rf "/Applications/Support.app"
  rm -f /usr/local/bin/SupportHelper
  rm -f /Library/LaunchAgents/nl.root3.support.plist
  rm -f /Library/LaunchDaemons/nl.root3.support.helper.plist

  rm -rf ~/Support
  rm -rf ~/.support
  rm -rf ~/.Support-master
  rm -rf ~/Library/Logs/Support*
  rm -rf ~/Library/Caches/Support*
  rm -rf ~/Library/Application\ Support/Support*
  rm -rf ~/Library/Preferences/nl.root3.support.plist
  rm -rf ~/Library/LaunchAgents/nl.root3.support.plist

  echo "Support has been uninstalled."
else
  echo "Support is not installed on this computer."
fi