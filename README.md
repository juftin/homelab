## What is homelab?

A fork of [juftin/homelab](https://github.com/juftin/homelab) with some additional features and improvements.

**`homelab`** is a collection of services that can be deployed from your home server and accessed
securely from anywhere in the world. Everything is deployed into a single docker compose application
and managed through the convenient `jdc` command-line tool.

### Quick Start

1. Clone this repository
2. Enable tab completion for the `jdc` command by adding the following to your `.bashrc` or `.zshrc`: !Remember to replace `path/to/homelab` with the actual path to the repository.
```bash
[[ -f "${HOME}/path/to/homelab/jdc/bin/_jdc_completion.sh" ]] && source "${HOME}/path/to/homelab/jdc/bin/_jdc_completion.sh"
```

Walk through the setup process (i need to populate this section fully, but in a nutshell)
1. Setup traefik, duckdns, cloudflare by following this guide https://www.simplehomelab.com/traefik-v3-docker-compose-guide-2024/
  - This guide is a little frustrating, but it works.

2. In your `.env` file add your domain_name, duckdns, and cloudflare detials.

3. !important: uncomment the `LETS_ENCRYPT_ENV` line so that failed letsencrypt attempts hit the staging servers and don't get you timed out.

4. Spin up the traefik related services, and monitor the traefik logs to ensure the certificates are being issued.

```bash
jdc up -p traefik
jdc logs traefik
```

5. Once the certificates are being issued correctly, you can comment out the `LETS_ENCRYPT_ENV` line again.

6. Spin up the rest of the services.

```bash
jdc up -p all
```

or target specific services

```bash
jdc up sonarr radarr prowlarr plex
```

7. Run through setup of these services following guides on those services easily found elsewhere.

Note: typically if you are referencing a service from inside another container (e.g., connecting prowlarr to sonarr), the host & port is simply something like
```
host: sonarr # or sometimes host: http://sonarr
port: 8989 # found in the sonarr.yaml file -> loadbalancer.server.port: 8989
```

### Service Profiles

Each service belongs to a [docker compose profile] that can be managed independently:

- **`core`**: Base infrastructure including [traefik] reverse proxy and [OAuth] service for secure HTTPS access
- **`media`**: Media services like [Plex], [Sonarr], [Radarr], and [Ombi] for streaming and content management
- **`utilities`**: Management tools like [Watchtower] and [Portainer] for monitoring and updates
- **`miscellaneous`**: Optional services like [ChatGPT Next Web] and [LibreOffice Online]

### Common Commands

```bash
# Start all services
jdc up

# Start just core services
jdc up -p core

# View logs for a specific service
jdc logs sonarr

# Update all containers
jdc update -p all

# List available containers
jdc containers

# Show help
jdc --help
```

[traefik]: https://github.com/traefik/traefik
[OAuth]: https://github.com/thomseddon/traefik-forward-auth
[Plex]: https://www.plex.tv/
[Sonarr]: https://github.com/sonarr/sonarr
[Radarr]: https://github.com/Radarr/Radarr
[Ombi]: https://github.com/Ombi-app/Ombi
[ChatGPT Next Web]: https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web
[Watchtower]: https://github.com/containrrr/watchtower
[LibreOffice Online]: https://www.libreoffice.org/
[Portainer]: https://github.com/portainer/portainer
[docker compose profile]: https://docs.docker.com/compose/profiles/
