<div align="center">
 <h1>homelab</h1>
  <img src="static/homelab.png" alt="homelab" width="350" />
  <p align="center">
    homelab deployment via docker compose <i>(made easy)</i>
  </p>
  <a href="https://github.com/juftin/homelab/"><img src="https://img.shields.io/github/v/release/juftin/homelab?color=blue&label=%F0%9F%A4%96%20homelab" alt="docs"></a>
  <a href="https://juftin.com/homelab/"><img src="https://img.shields.io/static/v1?message=docs&color=526CFE&logo=Material+for+MkDocs&logoColor=FFFFFF&label=" alt="docs"></a>
  <a href="https://github.com/pre-commit/pre-commit"><img src="https://img.shields.io/badge/pre--commit-enabled-lightgreen?logo=pre-commit" alt="pre-commit"></a>
  <a href="https://github.com/semantic-release/semantic-release"><img src="https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg" alt="semantic-release"></a>
  <a href="https://gitmoji.dev"><img src="https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg" alt="Gitmoji"></a>
</div>

## What is homelab?

`homelab` is a collection of services that can be deployed from your home server and accessed
securely from anywhere in the world. This project deploys multiple "stacks" of services:

-   **`traefik`**: The [traefik] stack is the core of this project, it includes a reverse proxy
    and [OAuth] service that allows you to access all of your services via a single domain name
    securely behind HTTPS and protected with Google OAuth.
-   **`media-center`**: The `media-center` stack includes services like [Plex], [Sonarr], [Radarr], and
    [Ombi] that allow you to request, download, organize, and stream media to your devices. This stack
    is perfect for those who want to have a media server in their homelab.
-   **`miscellaneous`**: The `miscellaneous` stack includes services like [pi-hole],
    [ChatGPT Next Web], and others that don't fit into the `media-center` stack.
    These services are great for improving your home network and adding some fun
    to your homelab - they also give you an established pattern for easily adding
    new services to your homelab.

## How does it work?

This repository is a large [docker compose](https://docs.docker.com/compose/)
project that allows you to deploy a variety of services to your homelab.

At the root of this repository is a `docker-compose.yaml` file that defines
the entire homelab project - it uses the `include` directive to pull in
individual service docker compose files from the `stacks` directory.
Ultimately a single docker compose stack is created that deploys everything.

```text
.
├── docker-compose.yaml                         # Main Docker Compose File
├── .env                                        # Environment Variables and Configuration
├── Makefile                                    # Makefile for common tasks and docker compose wrappers
├── secrets                                     # Secret Files
│   ├── cloudflare_api_key.secret               # Cloudflare API Key
│   └── google_oauth.secret                     # Google OAuth Credentials and Whitelist
├── stacks
│   ├── media-center
│   │   ├── plex.yaml                           # Each individual service has its own docker compose file
│   │   ├── radarr.yaml
│   |   ├── ombi.yaml
│   │   └── sonarr.yaml
│   ├── traefik                                 # Traefik Reverse Proxy and OAuth
│   │   ├── oauth                               # OAuth Service
│   │   └── traefik                             # Traefik Reverse Proxy
│   │       ├── docker-compose.yaml             # Traefik Docker Compose File (Traefik Only)
│   │       └── rules                           # Traefik Middlewares and Rules
│   │           ├── middlewares-chains.yml
│   │           ├── middlewares.yml
│   │           └── tls-opts.yml
│   └── miscellaneous                           # Non Media Center Services (pihole, chat-gpt-next-web, etc.)
│       └── chat-gpt-next-web.yaml
└── appdata                                     # Application Data Persistent Volumes
    ├── media-center
    │   ├── plex                                # Each individual service has its own subdirectory
    │   └── sonarr
    ├── traefik
    │   ├── oauth
    │   └── traefik
    └── miscellaneous
        └── chat-gpt-next-web
```

[traefik]: https://github.com/traefik/traefik
[OAuth]: https://github.com/thomseddon/traefik-forward-auth
[Plex]: https://www.plex.tv/
[Sonarr]: https://github.com/sonarr/sonarr
[Radarr]: https://github.com/Radarr/Radarr
[Ombi]: https://github.com/Ombi-app/Ombi
[ChatGPT Next Web]: https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web
[pi-hole]: https://github.com/pi-hole/pi-hole
