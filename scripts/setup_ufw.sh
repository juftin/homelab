#!/usr/bin/env bash

# Setup UFW to correctly handle traffic via traefik
# enabling comms with minecraft, and plex
# Note: you will also need to setup router port forwarding for:
# 80, 443, 25565 (minecraft), 32400 (plex) to the ip 
# of this server (ip route get 1 | awk '{print $7}')
# Note: to navigate to http://service.domain from your
# local network, you will need to setup router hairpin nat rules

sudo ufw default deny incoming
sudo ufw default allow outgoing

# HTTP
sudo ufw allow 80

# HTTPS
sudo ufw allow 443

# SSH  - using tcp explicitly
sudo ufw allow 22/tcp

# Allow all traffic from the 192.168.1.0/24 subnet (aka: local network as defined in your router)
sudo ufw allow from 192.168.1.0/24

# minecraft
sudo ufw allow 25565

# Allow Samba for the 192.168.1.0/24 subnet (using the Samba app profile)
sudo ufw allow from 192.168.1.0/24 to any app Samba

# Allow port 32400 (Plex) from 192.168.90.0/24
# Note 192.168.90.0/24 is specified in traefik docker-compose.yml
# This is needed for tautulli and other docker network containers to see plex
sudo ufw allow from 192.168.90.0/24 to any port 32400

sudo ufw enable
