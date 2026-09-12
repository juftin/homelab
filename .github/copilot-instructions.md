# Homelab AI Agent Instructions

## Project Overview

This is a **GitOps-managed** Docker Compose homelab deployment running 20+ self-hosted services (media servers, automation tools, utilities). The architecture uses **Komodo** for automated Git-to-production deployments and **Renovate** for dependency updates.

The stack is organized into two independent Docker Compose projects:

- **homelab-core** ([docker-compose.core.yaml](../docker-compose.core.yaml)): Infrastructure layer with Traefik reverse proxy, OAuth authentication, Cloudflare DDNS, Docker socket proxy, and Komodo management platform
- **homelab** ([docker-compose.apps.yaml](../docker-compose.apps.yaml)): Application services categorized as media, utilities, miscellaneous, and LLM services

All web services share a unified Traefik ingress with automatic HTTPS (Let's Encrypt via Cloudflare DNS challenge) and Google OAuth protection.

## Architecture Fundamentals

### GitOps Deployment with Komodo

**Critical**: This homelab uses a GitOps workflow. Changes pushed to the `gitops` branch are automatically deployed via Komodo. The deployment flow:

1. Push changes to `gitops` branch (this repository's default branch for deployments)
2. Komodo syncs repo configuration every 12 hours ([komodo.toml](../core/komodo/komodo.toml) `Auto Sync` procedure)
3. Komodo pulls repo and deploys stack every hour ([komodo.toml](../core/komodo/komodo.toml) `Auto Deploy` procedure)
4. Pre-deploy hook decrypts secrets using `mise run decrypt`
5. Stack updates with `docker compose up -d --remove-orphans`

**Komodo components** ([core/komodo/](../core/komodo/)):

- `komodo-core`: Web UI for stack management (accessible at `komodo.DOMAIN_NAME`)
- `komodo-periphery`: Deployment agent that executes docker compose commands
- `komodo-mongo`: Configuration and state database

**Local development**: Use `make` commands for immediate testing, but remember production deploys via GitOps.

### Docker Compose Structure

The project uses TWO separate Docker Compose stacks (not profiles):

- [docker-compose.core.yaml](../docker-compose.core.yaml): Homelab infrastructure (`homelab-core` stack)
- [docker-compose.apps.yaml](../docker-compose.apps.yaml): Application services (`homelab` stack)

Both use the `include` directive to compose individual YAML files:

```yaml
# docker-compose.apps.yaml
name: homelab
include:
    - apps/plex.yaml
    - apps/sonarr.yaml
    - apps/radarr.yaml
```

**To add a new service**:

1. Create `apps/your-service.yaml` or `core/your-service.yaml`
2. Add `- apps/your-service.yaml` to the appropriate `include` section in `docker-compose.apps.yaml` or `docker-compose.core.yaml`
3. Test locally: `make config APP=your-service` then `make up APP=your-service`
4. Commit and push to `gitops` branch for production deployment via Komodo

### Networking

Three Docker networks defined in [docker-compose.core.yaml](../docker-compose.core.yaml):

- `traefik` (192.168.90.0/24): Services exposed via Traefik reverse proxy
- `docker` (192.168.91.0/24): Socket proxy isolation
- `internal` (192.168.92.0/24): Internal-only services

**Inter-service communication**: Use container names as hostnames (e.g., `http://sonarr:8989` from another service).

**Critical**: The `homelab` stack references these networks as external:

```yaml
networks:
    traefik:
        external: true
        name: homelab-core_traefik
```

This allows services in `docker-compose.apps.yaml` to connect to the core infrastructure.

### Traefik Integration Pattern

All web services follow this label convention (see [apps/sonarr.yaml](../apps/sonarr.yaml)):

```yaml
networks:
    traefik:
labels:
    traefik.enable: true
    traefik.http.routers.SERVICE-rtr.rule: Host(`${SERVICE_SUBDOMAIN:-service}.${DOMAIN_NAME}`)
    traefik.http.routers.SERVICE-rtr.entrypoints: websecure
    traefik.http.routers.SERVICE-rtr.service: SERVICE-svc
    traefik.http.services.SERVICE-svc.loadbalancer.server.port: PORT
    traefik.http.routers.SERVICE-rtr.middlewares: chain-oauth-google@file
```

**Middleware chains** are defined in [core/traefik/rules/middlewares-chains.yml](../core/traefik/rules/middlewares-chains.yml):

- `chain-oauth-google@file`: Rate limiting + secure headers + OAuth
- `chain-no-auth@file`: Rate limiting + secure headers (no auth)

### Image Pinning & Renovate

All images are pinned with SHA256 digests to ensure reproducibility and controlled updates:

```yaml
image: lscr.io/linuxserver/plex:latest@sha256:7cc7874ad35b105fe1fe4d99ef27be9c5eb2f4115ccf91af5a7283cae0024599
```

**Renovate** ([.renovaterc.json5](../.renovaterc.json5)) automatically updates these digests:

- Runs every 15 minutes via GitHub Actions ([.github/workflows/renovate.yaml](../.github/workflows/renovate.yaml))
- Auto-merges minor/patch updates
- Creates PRs for major updates with `type/major` label
- Pins digests for Docker images, GitHub Actions, and mise tools
- Uses semantic commit prefixes: `💥` (major), `✨` (minor), `🐛` (patch), `📌` (digest)

**When adding services**:

- Include the `@sha256:...` digest (Renovate will manage updates going forward)
- Or use `latest` tag initially - Renovate will pin the digest on first run

### Secrets Management

Secrets use SOPS + Age encryption (see [.mise.toml](../.mise.toml)):

- `.env.yaml` → `.env` (environment variables)
- `secrets/*.secret.yaml` → `secrets/*.secret` (API keys, OAuth configs)

**Workflow**:

```bash
make decrypt  # Decrypt for local development
make encrypt  # Re-encrypt after changes
make keygen   # Generate new Age keypair
```

**Komodo integration**: The [core/komodo/entrypoint.sh](../core/komodo/entrypoint.sh) script installs mise and decrypts secrets automatically during deployments. The Age key is mounted from `.age/key.txt` into the komodo-periphery container.

Docker Compose references secrets via `secrets:` blocks (see [core/traefik/docker-compose.yaml](../core/traefik/docker-compose.yaml)):

```yaml
secrets:
    cloudflare_api_key:
        file: ${DOCKER_DIRECTORY}/secrets/cloudflare_api_key.secret
```

## Essential Workflows

### Service Management (Makefile)

The [Makefile](../Makefile) provides wrappers around docker compose commands:

**Core services** (prefix: `core-`):

```bash
make core-up APP=traefik      # Start specific core service
make core-logs APP=oauth      # View logs
make core-restart APP=komodo  # Restart service
```

**Application services**:

```bash
make up APP=plex              # Start service
make logs APP=sonarr ARGS="-f --tail=100"  # Live logs with args
make update APP=radarr        # Pull + restart
make ps                       # Show all container status
```

**Profiles** (not used in this project, but supported):

```bash
make up ARGS="--profile media"
```

### Configuration

**Environment variables** ([docs/example.env](../docs/example.env)):

- `DOMAIN_NAME`: Base domain for all services
- `DOCKER_DIRECTORY`: Absolute path to this repo
- `PUID`/`PGID`: User/group IDs for file permissions (from `id -u` / `id -g`)
- `TZ`: Timezone
- Directory mounts: `TV_DIR`, `MOVIE_DIR`, `BOOKS_DIR`, `COMPLETED_DOWNLOADS`

**Override subdomains**:

```bash
OVERSEERR_SUBDOMAIN="requests"  # Instead of overseerr.example.com
```

### Adding a New Service

1. Create `apps/your-service.yaml` with standard structure:

    ```yaml
    services:
        your-service:
            container_name: your-service
            image: vendor/image:tag@sha256:...
            volumes:
                - ${DOCKER_DIRECTORY}/appdata/your-service:/config
            environment:
                PUID: ${PUID}
                PGID: ${PGID}
                TZ: ${TZ}
            networks:
                traefik:
            restart: ${UNIVERSAL_RESTART_POLICY:-unless-stopped}
            labels:
                # Traefik labels here
    ```

2. Add include to [docker-compose.apps.yaml](../docker-compose.apps.yaml)
3. Test: `make config APP=your-service` then `make up APP=your-service`
4. Commit and push to `gitops` branch - Komodo will deploy in production within 1 hour

### Production Deployment (GitOps)

**Production changes flow**:

1. Make changes to service YAML, `.env.yaml`, or configuration
2. If secrets changed: `make encrypt` to update encrypted files
3. Commit and push to `gitops` branch
4. Komodo automatically deploys via hourly procedure
5. Monitor deployment via `komodo.DOMAIN_NAME` web UI

**Manual deployment trigger**: Update resources in Komodo UI or wait for scheduled deployment

**Branch strategy**:

- `gitops` branch: Production deployment target (default branch)
- `main` branch: Development/documentation branch
- Komodo only watches `gitops` branch

### Development

**Documentation**: MkDocs site in [docs/](../docs/) with live reload:

```bash
make docs  # http://localhost:8000
```

**Validation**:

```bash
make validate  # Lint all docker-compose files
make lint      # pre-commit hooks
```

**Testing**: GitHub Actions validates docker-compose files on PRs to `gitops` branch ([.github/workflows/test.yaml](../.github/workflows/test.yaml)):

- Copies example.env and runs `make validate`
- Ensures configuration is valid before merge

**Pre-commit hooks** ([.pre-commit-config.yaml](../.pre-commit-config.yaml)):

- YAML validation, trailing whitespace, end-of-file fixes
- TOML formatting (excludes komodo.toml)
- uv lock file updates when pyproject.toml changes
- Prettier formatting for markdown/JSON/YAML

## Critical Patterns

### LinuxServer.io Images

Most services use [linuxserver.io](https://linuxserver.io) images with consistent environment variables:

- `PUID`/`PGID`: Match host user for volume permissions
- `TZ`: Timezone configuration
- Standard config path: `/config` → `${DOCKER_DIRECTORY}/appdata/SERVICE`

### Host Network Mode

Plex uses `network_mode: host` for local network discovery (see [apps/plex.yaml](../apps/plex.yaml)). This service doesn't use Traefik routing.

### VPN and Privileged Capabilities

**Transmission** ([apps/transmission.yaml](../apps/transmission.yaml)) runs behind a VPN with special capabilities:

```yaml
cap_add:
    - NET_ADMIN
devices:
    - /dev/net/tun
```

This pattern is used for services requiring network tunneling (VPN) or DNS management (Pi-hole).

### Persistent Data

All application data lives in `appdata/SERVICE/` (NOT committed to git). Critical directories:

- `appdata/traefik/acme/acme.json`: Let's Encrypt certificates (chmod 600)
- `appdata/*/config`: Service configurations

**Backup**: Use `make backup BACKUP_DIR=/path/to/target` (excludes acme.json and portainer per [scripts/backup.sh](../scripts/backup.sh))

### Mise Tasks

[.mise.toml](../.mise.toml) manages secrets encryption tooling. Tasks run via `mise run TASK` or `make TASK`:

- `decrypt`: SOPS decrypt all secrets
- `encrypt`: SOPS encrypt all secrets
- `keygen`: Generate Age keypair

**SOPS configuration** ([.sops.yaml](../.sops.yaml)):

- Uses Age encryption with specific public key
- YAML output indentation: 2 spaces
- Ignores files matching `**/*.sops.*` in Renovate

### Traefik Middleware Details

[core/traefik/rules/middlewares.yml](../core/traefik/rules/middlewares.yml) defines:

- **Rate limiting**: 100 average requests, 50 burst
- **Security headers**: STS (2 years), frame options, CSP, XSS protection
- **OAuth forward auth**: Points to `http://oauth:4181` with trusted headers

## Troubleshooting

**Container networking issues**: Verify network attachment in `make ps` and check subnet conflicts in [docker-compose.core.yaml](../docker-compose.core.yaml)

**Traefik routing**: Check `make core-logs APP=traefik` for middleware chain errors. Verify labels with `make config APP=SERVICE`

**Permission errors**: Ensure `PUID`/`PGID` in `.env` match the user owning `appdata/` directories

**Certificate issues**: Reinitialize `acme.json` with `make config-acme`, then restart Traefik
