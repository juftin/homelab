<div align="center">
<img src="docs/static/homelab.png" align="center" width="300px"/>

## <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/2604_fe0f/512.gif" alt="⚙️" width="20" height="20"> homelab <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f680/512.gif" alt="🚀" width="20" height="20">

_... Homelab managed with Komodo, Renovate, and GitHub
Actions_ <img src="https://fonts.gstatic.com/s/e/notoemoji/latest/1f916/512.gif" alt="🤖" width="16" height="16">

<a href="https://github.com/juftin/homelab/"><img src="https://img.shields.io/github/v/release/juftin/homelab?color=blue&label=%F0%9F%A4%96%20homelab" alt="docs"></a>
<a href="https://juftin.com/homelab/"><img src="https://img.shields.io/static/v1?message=docs&color=526CFE&logo=Material+for+MkDocs&logoColor=FFFFFF&label=" alt="docs"></a>
<a href="https://github.com/pre-commit/pre-commit"><img src="https://img.shields.io/badge/pre--commit-enabled-lightgreen?logo=pre-commit" alt="pre-commit"></a>
<a href="https://github.com/semantic-release/semantic-release"><img src="https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg" alt="semantic-release"></a>
<a href="https://gitmoji.dev"><img src="https://img.shields.io/badge/gitmoji-%20😜%20😍-FFDD67.svg" alt="Gitmoji"></a>

</div>

## What is homelab?

**`homelab`** is a collection of 20+ self-hosted services that can be deployed from your home server and accessed
securely from anywhere in the world. The deployment uses a **GitOps workflow** with automated deployments via [Komodo]
and dependency updates via [Renovate].

The architecture consists of two separate Docker Compose stacks:

- **`homelab-core`**: Infrastructure layer with [Traefik] reverse proxy, [OAuth] authentication,
  Cloudflare DDNS, Docker socket proxy, and [Komodo] management platform. This is the foundation
  that all application services depend on.
- **`homelab`**: Application services organized into categories:
    - **Media**: [Plex], [Sonarr], [Radarr], [Overseerr], [Jellyfin], and more for media management and streaming
    - **Utilities**: [Portainer], [SFTPGo], [Pi-hole] for system management and utilities
    - **Miscellaneous**: [Home Assistant], [Coder], [Camply] and other specialized services
    - **LLM**: [Open WebUI], [LiteLLM], [ChatGPT Next Web] for AI/language model interactions

All web services share a unified Traefik ingress with automatic HTTPS (Let's Encrypt via Cloudflare DNS challenge)
and Google OAuth protection.

### Automated Updates with Renovate

All Docker images are **pinned to SHA256 digests** and automatically updated by [Renovate]:

- Runs every 15 minutes via GitHub Actions
- Auto-merges minor/patch updates
- Major updates require manual review
- Only the **`homelab`** stack is auto-deployed by Komodo
- The **`homelab-core`** stack requires manual updates (`make core-update`)

## How does it work?

This repository is a large [docker compose](https://docs.docker.com/compose/)
project that allows you to deploy a variety of services to your homelab.

At the root of this repository are two main Docker Compose files that define
the entire homelab project - they use the `include` directive to pull in
individual service files from the `apps/` and `core/` directories.

```text
.
├── docker-compose.core.yaml                # Core Infrastructure Stack
├── docker-compose.apps.yaml                # Application Services Stack
├── .env.yaml                               # Encrypted Environment Variables (SOPS)
├── .env                                    # Decrypted Environment Variables (git-ignored)
├── Makefile                                # Docker Compose wrappers and management commands
├── secrets/                                # Encrypted Secret Files (SOPS)
│   ├── cloudflare_api_key.secret.yaml      # Cloudflare API Key (encrypted)
│   └── google_oauth.secret.yaml            # Google OAuth Credentials (encrypted)
├── core/                                   # Core Infrastructure Services
│   ├── traefik/                            # Traefik Reverse Proxy
│   │   ├── docker-compose.yaml
│   │   └── rules/                          # Traefik Middlewares and Rules
│   ├── oauth.yaml                          # Google OAuth Forward Auth
│   ├── cloudflare-ddns.yaml                # Dynamic DNS Updates
│   ├── socket-proxy.yaml                   # Docker Socket Proxy
│   └── komodo/                             # GitOps Deployment Platform
│       ├── docker-compose.yaml
│       └── komodo.toml                     # Deployment Configuration
├── apps/                                   # Application Service Files
│   ├── plex.yaml
│   ├── sonarr.yaml
│   ├── radarr.yaml
│   ├── overseerr.yaml
│   ├── jellyfin.yaml
│   ├── open-webui.yaml
│   ├── litellm/
│   └── ... (20+ services)
└── appdata/                                # Application Persistent Data (git-ignored)
    ├── plex/
    ├── sonarr/
    ├── traefik/
    └── ... (per-service subdirectories)
```

### Configuration

All services are configured via environment variables and secrets managed with
[SOPS](https://github.com/getsops/sops) and [Age](https://github.com/FiloSottile/age) encryption.

**Initial setup**:

1. Install [mise](https://github.com/jdx/mise): `curl https://mise.run | sh`
2. Configure GitHub Actions secrets (Docker Hub, Renovate token)
3. Enable repository auto-merge setting
4. Generate Age encryption key: `make keygen`
5. Set up Komodo resource sync (post-deployment)

**Quick start**:

```shell
make keygen   # Generate Age keypair
cp docs/example.env .env
cp docs/example-secrets/* secrets/
# Edit .env and secrets/ with your configuration
make encrypt  # Encrypt secrets for git
```

See the [docs](https://juftin.com/homelab/) for detailed configuration and getting started guides.

[Traefik]: https://github.com/traefik/traefik
[OAuth]: https://github.com/thomseddon/traefik-forward-auth
[Komodo]: https://github.com/mbecker20/komodo
[Renovate]: https://github.com/renovatebot/renovate
[Plex]: https://www.plex.tv/
[Jellyfin]: https://jellyfin.org/
[Sonarr]: https://github.com/sonarr/sonarr
[Radarr]: https://github.com/Radarr/Radarr
[Overseerr]: https://overseerr.dev/
[Open WebUI]: https://github.com/open-webui/open-webui
[LiteLLM]: https://github.com/BerriAI/litellm
[ChatGPT Next Web]: https://github.com/ChatGPTNextWeb/ChatGPT-Next-Web
[Portainer]: https://github.com/portainer/portainer
[SFTPGo]: https://github.com/drakkan/sftpgo
[Pi-hole]: https://pi-hole.net/
[Home Assistant]: https://www.home-assistant.io/
[Coder]: https://github.com/coder/coder
[Camply]: https://github.com/juftin/camply
