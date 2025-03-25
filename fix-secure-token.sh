#!/bin/bash

# Ask for admin username
read -p "Enter admin username: " admin_username

# Ask for the admin password securely (will not echo the password to the screen)
read -s -p "Enter admin password: " admin_password
echo

# Ask for the username of the user to add the secure token to
read -p "Enter the username of the user to add the secure token to: " target_username

# Ask for the password of the user to add the secure token to
read -s -p "Enter password for $target_username: " target_password
echo

# Run the sysadminctl command to add the secure token
sudo sysadminctl -secureTokenOn "$target_username" -password "$target_password" -adminUser "$admin_username" -adminPassword "$admin_password"

echo "Secure token has been added to $target_username successfully."
