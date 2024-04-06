# Utilities Stack

## pi-hole

[![](https://img.shields.io/static/v1?message=pi-hole/pi-hole&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/pihole/pihole)
[![](https://img.shields.io/static/v1?message=pi-hole/pi-hole&logo=github&label=github)](https://github.com/pi-hole/pi-hole)
[![](https://img.shields.io/static/v1?message=pi-hole.net&logo=google+chrome&label=website&color=teal)](https://pi-hole.net)

<img src="https://i.imgur.com/br5HOpz.png" width="150" alt="Pi-hole Logo">

The Pi-hole is a DNS sinkhole that protects your devices from unwanted content without
installing any client-side software.

!!! info "Admin Password"

    The default admin password for pi-hole must be set manually:

    ```shell
    docker compose exec pihole /bin/bash -c "sudo pihole -a -p YourNewPassword"
    ```

## sftpgo

[![](https://img.shields.io/static/v1?message=drakkan/sftpgo&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/drakkan/sftpgo)
[![](https://img.shields.io/static/v1?message=drakkan/sftpgo&logo=github&label=github)](https://github.com/drakkan/sftpgo)
[![](https://img.shields.io/static/v1?message=sftpgo.com&logo=google+chrome&label=website&color=teal)](https://sftpgo.com)

<img src="https://i.imgur.com/wgtgGWr.png" width="250" alt="SFTPGo Logo">

SFTPGo is a fully featured and highly configurable SFTP server with optional HTTP/S, FTP/S and WebDAV support.
It's a fast and reliable solution to access your files with a WebUI, SFTP, and more.

## portainer

[![](https://img.shields.io/static/v1?message=portainer/portainer-ce&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/portainer/portainer-ce)
[![](https://img.shields.io/static/v1?message=portainer/portainer&logo=github&label=github)](https://github.com/portainer/portainer)
[![](https://img.shields.io/static/v1?message=portainer.io&logo=google+chrome&label=website&color=teal)](https://www.portainer.io)

<img src="https://i.imgur.com/CybNVn6.png" width="350" alt="Portainer Logo">

Portainer Community Edition is a lightweight service delivery platform for containerized applications
that can be used to manage Docker, Swarm, Kubernetes and ACI environments. It is designed to be as
simple to deploy as it is to use. The application allows you to manage all your orchestrator
resources (containers, images, volumes, networks and more) through a ‘smart’ GUI and/or
an extensive API.
