#!/usr/bin/env bash

# Remove UFW rules that were set up by setup_ufw.sh
# Note: This script assumes the rules exist. If they don't, UFW will show error messages
# but will continue processing the remaining commands.

# Disable UFW first
sudo ufw disable

# Remove the rules in reverse order of how they were added
sudo ufw delete allow from 192.168.90.0/24 to any port 32400
sudo ufw delete allow from 192.168.1.0/24 to any app Samba
sudo ufw delete allow 25565
sudo ufw delete allow from 192.168.1.0/24
sudo ufw delete allow 22/tcp
sudo ufw delete allow 443
sudo ufw delete allow 80

# Reset default policies to their original state
sudo ufw default allow incoming
sudo ufw default allow outgoing

echo "UFW rules have been removed and defaults reset."
echo "UFW is currently disabled. To re-enable UFW with different rules, use:"
echo "sudo ufw enable"