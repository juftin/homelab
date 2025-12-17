# GitOps & Automated Updates

This homelab uses a fully automated GitOps workflow with [Komodo] for deployments and [Renovate] for dependency updates.

!!! tip "Prefer Manual Deployment?"
If you don't want automated deployments and updates, see [Manual Deployment](manual-deployment.md) for an alternative approach using direct `make` commands.

## GitOps Deployment with Komodo

Changes pushed to the repository are automatically deployed via [Komodo](https://github.com/mbecker20/komodo):

1. Push changes to the repository
2. Komodo syncs repo configuration every 12 hours
3. Komodo pulls repo and deploys stack every hour
4. Pre-deploy hook decrypts secrets using `mise run decrypt`
5. Stack updates with `docker compose up -d --remove-orphans`

### Deployment Scope

> [!IMPORTANT]
> **Auto-Deployment Scope**: Only the **`homelab`** (application) stack is auto-deployed by Komodo.
> The **`homelab-core`** (infrastructure) stack requires **manual updates** via `make core-update`
> to prevent unintended downtime of critical services like Traefik and OAuth.

**Application Stack** ([docker-compose.apps.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.apps.yaml)):

- Auto-deployed every hour by Komodo
- Includes: Media, Utilities, Miscellaneous, and LLM services
- Safe for automated updates

**Core Infrastructure Stack** ([docker-compose.core.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.core.yaml)):

- Requires manual updates: `make core-update`
- Includes: Traefik, OAuth, Cloudflare DDNS, Socket Proxy, Komodo
- Critical services that need controlled updates

### Komodo Components

The Komodo deployment platform consists of:

- **komodo-core**: Web UI for stack management (accessible at `komodo.DOMAIN_NAME`)
- **komodo-periphery**: Deployment agent that executes docker compose commands
- **komodo-mongo**: Configuration and state database

Configuration is defined in [core/komodo/komodo.toml](https://github.com/juftin/homelab/blob/main/core/komodo/komodo.toml) which includes:

- Repository sync configuration
- Server definitions
- Stack definitions
- Automated procedures (Auto Sync, Auto Deploy)

### Initial Komodo Setup

After deploying the core infrastructure (`make core-up`), manually create the initial Komodo resource sync:

1. Open Komodo UI at `https://komodo.yourdomain.com`
2. Navigate to `Syncs` → `New Resource Sync (+)`
3. Configure the sync:
    - **Name**: `homelab`
    - **Config** → **Choose Mode**: `Git Repo`
    - **Source** → **Repo**: `<userName>/<repoName>` (e.g., `juftin/homelab`)
    - **General** → **Resource Paths** → **Add Path**: `core/komodo/komodo.toml`
4. Click `Save`
5. Click `Update` → `Confirm`
6. Click `Refresh` → `Execute` → `Execute Sync` → `Confirm`

This sync will automatically keep Komodo's configuration up-to-date with the repository.

Once configured, Komodo will:

- Sync repository configuration every 12 hours
- Auto-deploy the `homelab` stack every hour
- Execute the pre-deploy hook to decrypt secrets

### Local Development

For local development and testing, use `make` commands for immediate changes:

```shell
make up APP=service-name      # Start/update a service
make core-up APP=traefik      # Update core service
make logs APP=service-name    # View logs
make ps                       # Show status
```

See the [Command Line Usage](cli.md) documentation for all available commands.

## Automated Dependency Updates with Renovate

All Docker images are pinned to **SHA256 digests** for reproducibility and controlled updates:

```yaml
image: lscr.io/linuxserver/plex:latest@sha256:7cc7874ad35b105fe1fe4d99ef27be9c5eb2f4115ccf91af5a7283cae0024599
```

!!! note "LinuxServer.io `latest` Tag Strategy"

    Most images in this homelab use [LinuxServer.io](https://www.linuxserver.io/) containers, which follow a different versioning strategy than typical Docker images. LinuxServer.io doesn't use semantic versioning (like `v1.2.3`), so the `latest` tag is their recommended and most stable release channel. This is why you'll see `latest@sha256:...` throughout the configuration - the `latest` tag is intentional and represents the production-ready version, while the SHA256 digest ensures reproducibility.

[Renovate](https://github.com/renovatebot/renovate) automatically manages these updates:

- **Frequency**: Runs every 15 minutes via [GitHub Actions](https://github.com/juftin/homelab/blob/main/.github/workflows/renovate.yaml)
- **Auto-merge**: Minor and patch updates are automatically merged
- **Manual review**: Major version updates create PRs labeled `type/major` for review
- **Scope**: Updates Docker images, GitHub Actions, and mise tools
- **Semantic commits**: Uses emoji prefixes (💥 major, ✨ minor, 🐛 patch, 📌 digest)

### How Renovate Works

1. Renovate detects new image digests from Docker registries
2. Creates a pull request with updated SHA256 digest
3. For minor/patch updates: Auto-merges to production
4. Komodo auto-deploys the `homelab` stack (within 1 hour)
5. For major updates: Awaits manual review and merge

This ensures services stay updated while maintaining stability and security.

### Renovate Configuration

Renovate is configured via [.renovaterc.json5](https://github.com/juftin/homelab/blob/main/.renovaterc.json5):

- **Schedule**: Runs during off-peak hours (0-4 AM)
- **Auto-merge**: Enabled for minor/patch updates on stable releases (not 0.x)
- **Digest pinning**: All Docker images and GitHub Actions are pinned
- **Labels**: Automatic categorization by update type
- **Dependency Dashboard**: Available in GitHub Issues for manual control

**Required GitHub Setup**:

To enable Renovate automation, configure your repository:

1. **GitHub Actions Secrets** (`Settings` → `Secrets and variables` → `Actions`):
    - `RENOVATE_TOKEN`: GitHub Personal Access Token with `repo` scope
    - `DOCKER_USERNAME`: Docker Hub username
    - `DOCKER_TOKEN`: Docker Hub access token

2. **Enable Auto-Merge** (`Settings` → `General` → `Pull Requests`):
    - Check ✅ `Allow auto-merge`
    - This allows Renovate to automatically merge approved updates

See [Configuration](config.md#step-2-configure-github-repository) for step-by-step setup instructions.

### Manual Intervention

While Renovate handles most updates automatically, you can:

- **Pause updates**: Close the Renovate Dependency Dashboard issue
- **Manual updates**: Create PRs yourself with updated digests
- **Skip specific updates**: Use `ignoreDeps` in `.renovaterc.json5`
- **Force updates**: Re-run the Renovate workflow in GitHub Actions

## Monitoring Deployments

### Komodo UI

Access the Komodo web interface at `https://komodo.DOMAIN_NAME` to:

- View deployment logs and history
- Manually trigger deployments
- Monitor service status
- Manage stacks and resources

### GitHub Actions

Monitor automated updates in GitHub:

- **Actions tab**: View Renovate workflow runs
- **Pull Requests**: Review pending updates
- **Dependency Dashboard**: Track all available updates

### Docker Compose

Check local service status:

```shell
make ps              # Application services
make core-ps         # Core infrastructure
make logs APP=name   # View service logs
```

[Komodo]: https://github.com/mbecker20/komodo
[Renovate]: https://github.com/renovatebot/renovate
