# Configuration

## Architecture Overview

This homelab uses two separate Docker Compose stacks:

- **`homelab-core`** ([docker-compose.core.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.core.yaml)): Infrastructure layer
- **`homelab`** ([docker-compose.apps.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.apps.yaml)): Application services

Deployments and updates are automated via GitOps. See [GitOps & Automated Updates](gitops.md) for details.

!!! tip "Manual Deployment Alternative"

    This guide assumes you're using the automated GitOps deployment workflow. If you prefer manual control over deployments and updates, see [Manual Deployment](manual-deployment.md) instead.

## Getting Started

This section walks through the complete setup process from prerequisites to deployment.

### Step 1: Install Prerequisites

#### Install mise

Install [mise](https://github.com/jdx/mise) for managing development tools and secrets encryption:

```shell
curl https://mise.run | sh
```

Or use your package manager:

```shell
# macOS
brew install mise

# Linux
curl https://mise.run | sh
```

### Step 2: Configure GitHub Repository

> [!NOTE]
> For automated updates via Renovate, see [GitOps & Automated Updates](gitops.md#renovate-configuration).

#### Add GitHub Actions Secrets

Add these secrets to your repository (`Settings` → `Secrets and variables` → `Actions`):

| Secret Name       | Description                                                         |
| ----------------- | ------------------------------------------------------------------- |
| `DOCKER_USERNAME` | Docker Hub username                                                 |
| `DOCKER_TOKEN`    | [Docker Hub access token](https://hub.docker.com/settings/security) |
| `RENOVATE_TOKEN`  | [GitHub PAT](https://github.com/settings/tokens) with `repo` scope  |

#### Enable Auto-Merge

`Settings` → `General` → `Pull Requests` → ✅ `Allow auto-merge`

### Step 3: Configure Secrets and Environment

#### Generate Age Encryption Key

Generate an Age keypair for encrypting secrets:

```shell
mise run keygen
```

This creates `.age/key.txt` (private key) which is used to encrypt/decrypt secrets in the `secrets/` directory.

> [!WARNING]
> Keep the `.age/key.txt` file secure and backed up. You'll need it to decrypt secrets
> in production and for local development.

#### Set Up Environment Files

Copy and configure the example files:

```shell
cp docs/example.env .env
cp docs/example-secrets/google_oauth.secret secrets/
cp docs/example-secrets/cloudflare_api_key.secret secrets/
```

Edit the files with your configuration:

- `.env` - Domain name, directories, API keys, etc.
- `secrets/google_oauth.secret` - Google OAuth credentials and whitelisted users
- `secrets/cloudflare_api_key.secret` - Cloudflare API key for DNS challenges

#### Encrypt Secrets

After configuring the files, encrypt them for storage in git:

```shell
make encrypt
```

This creates encrypted versions (`.env.yaml`, `secrets/*.secret.yaml`) that are safe to commit.

**Secret Files**:

- `.env.yaml` - Encrypted environment variables (committed to git)
- `.env` - Decrypted environment variables (git-ignored, used by docker compose)
- `secrets/google_oauth.secret.yaml` - Encrypted Google OAuth credentials
- `secrets/cloudflare_api_key.secret.yaml` - Encrypted Cloudflare API key

**Secrets Workflow**:

```shell
make decrypt  # Decrypt for local development
make encrypt  # Re-encrypt after changes
make keygen   # Generate new Age keypair (first-time only)
```

<details><summary>📄 .env Example</summary>
<p>

```shell
--8<-- "docs/example.env"
```

</p>
</details>

<details><summary>📄 secrets/google_oauth.secret Example</summary>
<p>

```shell
--8<-- "docs/example-secrets/google_oauth.secret"
```

</p>

</details>

</details>

<details><summary>📄 secrets/cloudflare_api_key.secret Example</summary>
<p>

```shell
--8<-- "docs/example-secrets/cloudflare_api_key.secret"
```

</p>
</details>

### Step 4: Configure Infrastructure Services

> [!WARNING]
> Before deploying, you must set up your router, Google OAuth, and Cloudflare DNS.
> See the [Traefik 🚦](traefik.md) section for detailed infrastructure setup instructions.

The core infrastructure provides:

- **Traefik**: Reverse proxy with automatic HTTPS
- **OAuth**: Google authentication for all services
- **Cloudflare DDNS**: Dynamic DNS updates
- **Docker Socket Proxy**: Security layer for Docker API
- **Komodo**: Deployment automation

### Step 5: Deploy Core Infrastructure

Deploy the core infrastructure stack:

```shell
make core-up
```

Monitor the logs to ensure services start correctly:

```shell
make core-logs
```

### Step 6: Configure Komodo

After core infrastructure is running:

1. Open Komodo UI at `https://komodo.yourdomain.com`
2. Create a Resource Sync pointing to your repository
3. Execute the sync

Detailed instructions: [GitOps & Automated Updates](gitops.md#initial-komodo-setup)

### Step 7: Wait for Komodo Deployment

Once Komodo is configured, it will automatically deploy the application services stack within 1 hour (you can, of cou)

Monitor deployment status in the Komodo UI at `https://komodo.yourdomain.com`.

## Service Deployment

Services are organized into two Docker Compose stacks:

### Core Infrastructure Stack

Defined in [docker-compose.core.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.core.yaml):

- Traefik (reverse proxy)
- OAuth (Google authentication)
- Cloudflare DDNS (dynamic DNS)
- Docker Socket Proxy (security)
- Komodo (deployment platform)

**Deployment**: Requires **manual updates** to prevent unintended downtime.

```shell
make core-up      # Start core services
```

### Application Stack

Defined in [docker-compose.apps.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.apps.yaml):

- Media services (Plex, Sonarr, Radarr, etc.)
- Utilities (Portainer, SFTPGo, Pi-hole, etc.)
- Miscellaneous (Home Assistant, Coder, Camply, etc.)
- LLM services (Open WebUI, LiteLLM, ChatGPT Next Web, etc.)

**Deployment**: Auto-deployed by Komodo every hour when changes are pushed to the repository.

### Enabling/Disabling Services

To enable or disable specific services, edit the `include` directive in the appropriate
Docker Compose file:

**For application services** ([docker-compose.apps.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.apps.yaml)):

```yaml
# Disable by commenting out the include line
include:
    - apps/plex.yaml
    # - apps/jellyfin.yaml  # Disabled
    - apps/sonarr.yaml
```

**For core services** ([docker-compose.core.yaml](https://github.com/juftin/homelab/blob/main/docker-compose.core.yaml)):

```yaml
include:
    - core/traefik/docker-compose.yaml
    - core/oauth.yaml
    # Core services should generally remain enabled
```

## Service Configuration

Each service has its own configuration process - see the `Applications` documentation
for more information about a specific app.

### Inter-Service Communication

All services in both stacks share common Docker networks. When connecting services together,
use the container name as the hostname. For example:

- To connect to Sonarr from Overseerr: `http://sonarr:8989`
- To connect to Radarr from Overseerr: `http://radarr:7878`
- To connect to Transmission from Sonarr: `http://transmission:9091`

The `homelab` stack references networks from `homelab-core` as external networks,
allowing seamless communication between infrastructure and application services.

For details on the GitOps workflow and automated dependency updates, see [GitOps & Automated Updates](gitops.md).
