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

**`homelab`** is a collection of services that can be deployed from your home server and accessed
securely from anywhere in the world. Ultimately everything is deployed into a single
docker compose application. Each service belongs to a [docker compose profile] - and the
`Makefile` contains everything you need to get started and manage your homelab.

- **`core`**: The `core` profile is the base of this project, it includes a [traefik] reverse proxy
  and [OAuth] service that allows you to access all of your services via a single domain name
  securely behind HTTPS and protected with Google OAuth.
- **`media`**: The `media` profile includes services like [Plex], [Sonarr], [Radarr], and
  [Ombi] that allow you to request, download, organize, and stream media to your devices. This profile
  is perfect for those who want to have a media server in their homelab.
- **`utilities`**: The `utilities` profile includes services like [Watchtower] and [Portainer] that
  are designed to help you manage your homelab, monitor your services,
  and keep your containers up-to-date.
- **`miscellaneous`**: The `miscellaneous` profile is disabled by default.
  It includes services like [ChatGPT Next Web] and [LibreOffice Online]
  that don't fit into the other profiles. These services are great for improving your
  productivity and adding some fun to your homelab.
- **`llm`**: The `llm` profile is disabled by default.
  It includes services like [ChatGPT Next Web] that allow you to run a local instance of
  ChatGPT and other LLMs. This profile is perfect for those who want to experiment with
  LLMs and AI in their homelab.

## How does it work?

This repository is a large [docker compose](https://docs.docker.com/compose/)
project that allows you to deploy a variety of services to your homelab.

At the root of this repository is a `docker-compose.yaml` file that defines
the entire homelab project - it uses the `include` directive to pull in
individual service docker compose files from the `apps` directory.

```text
.
├── docker-compose.yaml                     # Main Docker Compose File
├── .env                                    # Environment Variables and Configuration
├── Makefile                                # Makefile for common tasks and docker compose wrappers
├── secrets                                 # Secret Files
│   ├── cloudflare_api_key.secret           # Cloudflare API Key
│   └── google_oauth.secret                 # Google OAuth Credentials and Whitelist
├── apps                                    # Individual Service Docker Compose Files
│   ├── plex.yaml
│   ├── radarr.yaml
│   ├── ombi.yaml
│   ├── sonarr.yaml
│   ├── oauth.yaml
│   ├── chat-gpt-next-web.yaml
│   ├── watchtower.yaml
│   └── traefik                             # Traefik Reverse Proxy
│       ├── docker-compose.yaml             # Traefik Docker Compose File
│       └── rules                           # Traefik Middlewares and Rules
│           ├── middlewares-chains.yml
│           ├── middlewares.yml
│           └── tls-opts.yml
└── appdata                                 # Application Data Persistent Volumes
    ├── plex                                # Each individual service has its own subdirectory
    ├── sonarr
    ├── oauth
    ├── traefik
    ├── chat-gpt-next-web
    ├── utilities
    └── watchtower
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
[Watchtower]: https://github.com/containrrr/watchtower
[LibreOffice Online]: https://www.libreoffice.org/
[Portainer]: https://github.com/portainer/portainer
[docker compose profile]: https://docs.docker.com/compose/profiles/
