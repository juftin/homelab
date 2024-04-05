<div align="center">
 <h1>homelab</h1>
  <a href="https://github.com/juftin/homelab">
    <img src="docs/static/homelab.png" alt="homelab" width="350" />
  </a>
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
all of the services that are included in this project - collections of services
are broken out into their own subdirectories and individual
`docker-compose.yaml` files (`media-center/docker-compose.yaml`). Below that,
each service gets its own subdirectory and a singular `docker-compose.yaml` file
(`media-center/plex/docker-compose.yaml`). Using the `include` directive in the
docker compose files, we create a single stack from the top level that deploys
everything.

```text
.
├── .env                                    # Environment Variables and Configuration
├── docker-compose.yaml                     # Main Docker Compose File
├── Makefile                                # Makefile for common tasks and docker compose wrappers
├── secrets                                 # Secret Files
│   ├── cloudflare_api_key.secret           # Cloudflare API Key
│   └── google_oauth.secret                 # Google OAuth Credentials and Whitelist
├── media-center
│   ├── docker-compose.yaml                 # Media-Center Stack Docker Compose File (Plex, Sonarr, etc.)
│   ├── plex                                # Each individual service has its own subdirectory
│   │   ├── docker-compose.yaml             # Each service has its own docker-compose.yaml file
│   │   └── config                          # Each service has its own config directory where data is persisted
│   └── sonarr
│       └── docker-compose.yaml
├── traefik                                 # Traefik Reverse Proxy and OAuth
│   ├── docker-compose.yaml                 # Traefik Stack Docker Compose File (Traefik, OAuth, etc.)
│   ├── oauth                               # OAuth Configuration
│   │   └── docker-compose.yaml
│   └── traefik                             # Traefik Configuration
│       ├── docker-compose.yaml             # Traefik Docker Compose File (Traefik Only)
│       └── rules
│           ├── middlewares-chains.yml      # Traefik Middlewares Chains
│           ├── middlewares.yml             # Traefik Middlewares
│           └── tls-opts.yml                # Traefik TLS Options
└── miscellaneous                           # Non Media Center Services (pihole, chat-gpt-next-web, etc.)
    ├── chat-gpt-next-web
    │   └── docker-compose.yaml
    └── docker-compose.yaml                 # Miscellaneous Stack Docker Compose File
```

### Configuration

All services are configured via a `.env` file at the root of the project and a few secret
files in the `secrets` directory. These files are used to define settings and credentials
for all services that are deployed. You can copy the example files to get started:

```shell
cp docs/example.env .env
cp -r docs/example-secrets/ secrets/
```

See the [docs](https://juftin.github.io/homelab/) for more information on configuration and
getting started.

[traefik]: https://github.com/traefik/traefik
[OAuth]: https://github.com/thomseddon/traefik-forward-auth
[Plex]: https://www.plex.tv/
[Sonarr]: https://github.com/sonarr/sonarr
[Radarr]: https://github.com/Radarr/Radarr
[Ombi]: https://github.com/Ombi-app/Ombi
[ChatGPT Next Web]: https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web
[pi-hole]: https://github.com/pi-hole/pi-hole
