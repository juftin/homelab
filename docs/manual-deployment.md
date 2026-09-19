# Manual Deployment

This page documents how to run the homelab **without** GitOps automation (Komodo) and automated dependency updates (Renovate).

!!! info "Alternative Deployment Strategy"
This approach is suitable if you prefer:

    - Direct control over deployments
    - Manual updates on your own schedule
    - No automated pull requests or merge workflows
    - Simpler setup without Komodo infrastructure

## Overview

The standard homelab setup uses:

- **Komodo**: GitOps platform that auto-deploys the `homelab` stack
- **Renovate**: Creates automated PRs with SHA256-pinned image updates

For manual deployment, you will:

- Deploy services directly using `make` commands
- Update services manually when you choose
- Use unpinned image tags (e.g., `latest`) for easier updates

## Image Tag Strategy

### Renovate Approach (Default)

The default configuration pins all Docker images to **SHA256 digests**:

```yaml
services:
    sonarr:
        image: lscr.io/linuxserver/sonarr:latest@sha256:60e5edcac39172294ad22d55d1b08c2c0a9fe658cad2f2c4d742ae017d7874de
```

This ensures reproducibility but requires Renovate to update the digest when new versions are released.

### Manual Approach (Unpinned Tags)

For manual deployment, **unpin images to use tag-based updates**:

```yaml
services:
    sonarr:
        image: lscr.io/linuxserver/sonarr:latest
```

Common tag strategies:

| Tag       | Description            | Use Case                            |
| --------- | ---------------------- | ----------------------------------- |
| `latest`  | Most recent release    | Most services, auto-updates on pull |
| `stable`  | Stable release channel | Production deployments              |
| `v1.2.3`  | Specific version       | Pinning to known-good versions      |
| `develop` | Development branch     | Testing new features                |

!!! warning "Tag vs Digest Trade-offs" - **Unpinned tags** (`latest`): Easier updates, less control over exact versions - **Pinned digests** (`@sha256:...`): Exact reproducibility, manual tracking required

### Updating Service Images

To unpin an image, edit the service's YAML file in `apps/` or `core/`:

```shell
# Example: Unpin Sonarr
vim apps/sonarr.yaml
```

Change from:

```yaml
image: lscr.io/linuxserver/sonarr:latest@sha256:60e5edcac39172294ad22d55d1b08c2c0a9fe658cad2f2c4d742ae017d7874de
```

To:

```yaml
image: lscr.io/linuxserver/sonarr:latest
```

Repeat for any services you want to manage manually.

## Manual Update Workflow

### Updating Application Services

Update all application services:

```shell
make update      # Pull latest images and restart all services
```

Update a specific service:

```shell
make update APP=sonarr
```

Step-by-step process:

```shell
make pull APP=sonarr    # 1. Pull latest image
make up APP=sonarr      # 2. Recreate container with new image
make logs APP=sonarr    # 3. Verify successful startup
```

### Updating Core Infrastructure

Update all core services:

```shell
make core-update
```

Update a specific core service:

```shell
make core-update APP=traefik
```

!!! warning "Core Service Updates"
Core infrastructure services (Traefik, OAuth, etc.) are critical. Always update these carefully:

    ```shell
    make core-pull APP=traefik    # Pull new image
    make core-logs APP=traefik    # Check current logs for issues
    make core-update APP=traefik  # Update service
    make core-logs APP=traefik    # Verify successful restart
    ```

### Checking for Updates

You'll need to manually check for new images:

**Check Docker Hub/Registry**:

- LinuxServer.io images: [https://fleet.linuxserver.io/](https://fleet.linuxserver.io/)
- Docker Hub: Search for your image
- GitHub Container Registry: Check repository releases

**Compare running version**:

```shell
# Show currently running images
make ps

# Show available updates (requires docker-compose pull first)
make pull APP=sonarr
make config APP=sonarr | grep image
```

## Deployment Commands

### Initial Deployment

Deploy the complete homelab:

```shell
# 1. Deploy core infrastructure
make core-up

# 2. Verify core services are running
make core-ps
make core-logs

# 3. Deploy application services
make up

# 4. Verify application services
make ps
make logs
```

### Managing Services

Start specific services:

```shell
make up APP=plex
make core-up APP=traefik
```

Stop services:

```shell
make stop APP=sonarr
make core-stop APP=oauth
```

Restart services:

```shell
make restart APP=radarr
make core-restart APP=traefik
```

View logs:

```shell
make logs APP=overseerr ARGS="-f --tail=100"
make core-logs APP=traefik ARGS="-f"
```

See the full [Command Line Usage](cli.md) documentation for all available commands.

## Disabling Renovate

If you're using the manual deployment approach, you may want to disable Renovate:

### Option 1: Disable GitHub Actions Workflow

Delete or disable the Renovate workflow:

```shell
# Delete the workflow file
rm .github/workflows/renovate.yaml

# Or disable in GitHub UI:
# Settings → Actions → Workflows → renovate → Disable workflow
```

### Option 2: Configure Renovate to Skip Updates

Add to [.renovaterc.json5](https://github.com/juftin/homelab/blob/main/.renovaterc.json5):

```json5
{
    enabled: false,
}
```

### Option 3: Remove Renovate Entirely

Remove Renovate configuration files:

```shell
rm .renovaterc.json5
rm .github/renovate-config.js
rm .github/workflows/renovate.yaml
```

## Disabling Komodo

If you don't want GitOps automation, you can skip deploying Komodo:

### Remove Komodo from Core Stack

Edit [docker-compose.core.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.core.yaml):

```yaml
include:
    - core/traefik/docker-compose.yaml
    - core/cloudflare-ddns.yaml
    - core/oauth.yaml
    - core/socket-proxy.yaml
    # - core/komodo/docker-compose.yaml  # Commented out
```

Or delete the Komodo configuration entirely:

```shell
rm -rf core/komodo/
```

## Update Schedule Recommendations

Without automation, establish a manual update schedule:

**Weekly**: Check for critical security updates

```shell
make core-update APP=traefik
make update APP=sonarr APP=radarr APP=overseerr
```

**Monthly**: Update all services

```shell
make core-update
make update
```

**As Needed**: Update specific services when issues arise

```shell
make update APP=plex
make core-logs APP=traefik
```

## Monitoring for Updates

Set up notifications for new releases:

- **GitHub**: Watch repositories for releases (e.g., [linuxserver/docker-plex](https://github.com/linuxserver/docker-plex))
- **Discord/Slack**: Join community channels for update announcements
- **RSS Feeds**: Subscribe to Docker Hub tag feeds
- **Manual Checks**: Regularly visit [LinuxServer.io Fleet](https://fleet.linuxserver.io/)

## Backup Before Updates

Always backup configuration before major updates:

```shell
make backup BACKUP_DIR=/path/to/backups
```

This creates a timestamped archive of the `appdata/` directory.

See [Scripts Documentation](scripts.md#backupsh) for backup details.

## Comparison: GitOps vs Manual

| Aspect             | GitOps (Default)          | Manual Deployment              |
| ------------------ | ------------------------- | ------------------------------ |
| **Deployment**     | Auto-deploy every hour    | Manual `make up` commands      |
| **Updates**        | Renovate PRs every 15 min | Manual `make update` as needed |
| **Image Tags**     | SHA256 digest pinned      | Unpinned tags (`latest`, etc.) |
| **Infrastructure** | Komodo required           | No additional services         |
| **Control**        | Automated, hands-off      | Full manual control            |
| **Complexity**     | Higher initial setup      | Simpler, more direct           |
| **Best For**       | Set-and-forget automation | Hands-on management            |

Choose the approach that best fits your workflow and comfort level.

## Further Reading

- [Command Line Usage](cli.md) - All available `make` commands
- [GitOps & Automated Updates](gitops.md) - How the automated approach works
- [Configuration](config.md) - Initial setup guide
