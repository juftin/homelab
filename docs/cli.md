# Command Line Usage

This project includes a `Makefile` that provides commands to manage the two Docker Compose stacks:

- **`homelab-core`** stack: Infrastructure services (Traefik, OAuth, Komodo, etc.)
- **`homelab`** stack: Application services (Plex, Sonarr, Radarr, etc.)

!!! info "**`homelab`** alias"

    You will see the **`make`** command and **`homelab`** used interchangeably
    in this documentation. The **`homelab`** command is a convenience wrapper
    around **`make`** so you can easily run the Makefile from anywhere.

    Add this to your `.bashrc` / `.zshrc` to use the **`homelab`** command:

    ```shell
    alias homelab="make --no-print-directory --directory /path/to/this/repo"
    ```

!!! quote "`homelab help`"

    ```bash exec="1" result="text"
    make help | sed 's/\x1b\[[0-9;]*m//g'
    ```

## Commands

!!! tip "The `APP` flag"

    Notice that some commands accept an `APP` flag. This flag is used to specify
    which docker compose service to run on. If not specified these commands default
    to **all** services.

    === "Show logs for a specific service"

        ```
        homelab logs APP=sonarr
        ```

    === "Show logs for all services"

        ```
        homelab logs
        ```

!!! tip "The `ARGS` flag"

    Some commands accept an `ARGS` flag to pass additional flags to docker compose.
    If not specified these arguments default to **empty**.

    === "Pruning Orphaned Containers"

        ```
        homelab up ARGS="--remove-orphans"
        ```

### Homelab 🐳

#### update

Update the application service(s) to the latest versions.

\* _Defaults to all, accepts the `APP` flag_

=== "homelab"

    ```shell
    homelab update APP=sonarr
    ```

=== "make"

    ```shell
    make update APP=sonarr
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml pull sonarr
    docker compose -f docker-compose.apps.yaml up -d sonarr
    ```

#### pull

Pull the latest images for the application service(s).

\* _Defaults to all, accepts the `APP` flag_

=== "homelab"

    ```shell
    homelab pull APP=sonarr
    ```

=== "make"

    ```shell
    make pull APP=sonarr
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml pull sonarr
    ```

#### up

Start the application service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab up APP=sonarr
    ```

=== "make"

    ```shell
    make up APP=sonarr
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml up -d sonarr
    ```

#### down

Stop the application service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab down APP=sonarr
    ```

=== "make"

    ```shell
    make down APP=sonarr
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml down sonarr
    ```

#### stop

Stop the application service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab stop APP=sonarr
    ```

=== "make"

    ```shell
    make stop APP=sonarr
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml stop sonarr
    ```

#### logs

Show the logs for the application service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab logs APP=sonarr ARGS="-f --tail=100"
    ```

=== "make"

    ```shell
    make logs APP=sonarr ARGS="-f --tail=100"
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml logs -ft sonarr
    ```

#### restart

Restart the application service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab restart APP=sonarr
    ```

=== "make"

    ```shell
    make restart APP=sonarr
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml restart sonarr
    ```

#### ps

Show the status of the application service(s).

=== "homelab"

    ```shell
    homelab ps
    ```

=== "make"

    ```shell
    make ps
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"
    ```

#### config

Show the configuration of the application service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab config APP=sonarr
    ```

=== "make"

    ```shell
    make config APP=sonarr
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.apps.yaml config sonarr
    ```

### Core Services 🧠

#### core-update

Update the core infrastructure service(s) to the latest versions.

\* _Defaults to all, accepts the `APP` flag_

=== "homelab"

    ```shell
    homelab core-update APP=traefik
    ```

=== "make"

    ```shell
    make core-update APP=traefik
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml pull traefik
    docker compose -f docker-compose.core.yaml up -d traefik
    ```

#### core-pull

Pull the latest images for the core infrastructure service(s).

\* _Defaults to all, accepts the `APP` flag_

=== "homelab"

    ```shell
    homelab core-pull APP=traefik
    ```

=== "make"

    ```shell
    make core-pull APP=traefik
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml pull traefik
    ```

#### core-up

Start the core infrastructure service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab core-up APP=traefik
    ```

=== "make"

    ```shell
    make core-up APP=traefik
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml up -d traefik
    ```

#### core-down

Stop the core infrastructure service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab core-down APP=traefik
    ```

=== "make"

    ```shell
    make core-down APP=traefik
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml down traefik
    ```

#### core-stop

Stop the core infrastructure service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab core-stop APP=traefik
    ```

=== "make"

    ```shell
    make core-stop APP=traefik
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml stop traefik
    ```

#### core-logs

Show the logs for the core infrastructure service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab core-logs APP=traefik ARGS="-f --tail=100"
    ```

=== "make"

    ```shell
    make core-logs APP=traefik ARGS="-f --tail=100"
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml logs -ft traefik
    ```

#### core-restart

Restart the core infrastructure service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab core-restart APP=traefik
    ```

=== "make"

    ```shell
    make core-restart APP=traefik
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml restart traefik
    ```

#### core-ps

Show the status of the core infrastructure service(s).

=== "homelab"

    ```shell
    homelab core-ps
    ```

=== "make"

    ```shell
    make core-ps
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"
    ```

#### core-config

Show the configuration of the core infrastructure service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab core-config APP=traefik
    ```

=== "make"

    ```shell
    make core-config APP=traefik
    ```

=== "docker"

    ```shell
    docker compose -f docker-compose.core.yaml config traefik
    ```

### Secrets Management 🔐

#### keygen

Generate an Age keypair for secrets encryption.

=== "homelab"

    ```shell
    homelab keygen
    ```

=== "make"

    ```shell
    make keygen
    ```

=== "bash"

    ```shell
    mise run keygen
    ```

#### decrypt

Decrypt the secrets files for local development.

=== "homelab"

    ```shell
    homelab decrypt
    ```

=== "make"

    ```shell
    make decrypt
    ```

=== "bash"

    ```shell
    mise run decrypt
    ```

#### encrypt

Encrypt the secrets files after making changes.

=== "homelab"

    ```shell
    homelab encrypt
    ```

=== "make"

    ```shell
    make encrypt
    ```

=== "bash"

    ```shell
    mise run encrypt
    ```

### Configuration 🪛

#### config-acme

Initialize the `acme.json` file for traefik.

=== "homelab"

    ```shell
    homelab config-acme
    ```

=== "make"

    ```shell
    make config-acme
    ```

=== "bash"

    ```shell
    mkdir -p appdata/traefik/acme/ && \
    rm -f appdata/traefik/acme/acme.json && \
    touch appdata/traefik/acme/acme.json && \
    chmod 600 appdata/traefik/acme/acme.json
    ```

### Backup 🗂️

#### backup

Backup the `appdata` directory with a timestamp (`appdata_YYYYMMDDHHMM.tar.gz`).

\* _You must provide the `BACKUP_DIR` variable_

See the [backup script documentation](scripts.md#backupsh)

=== "homelab"

    ```shell
    homelab backup BACKUP_DIR=/backup/dir
    ```

=== "make"

    ```shell
    make backup BACKUP_DIR=/backup/dir
    ```

=== "bash"

    ```shell
    bash ./scripts/backup.sh appdata /backup/dir
    ```

#### backup-no-timestamp

Backup the `appdata` directory without a timestamp. This
overwrites the previous backup (`appdata.tar.gz`)

\* _You must provide the `BACKUP_DIR` variable_

See the [backup script documentation](scripts.md#backupsh)

=== "homelab"

    ```shell
    homelab backup-no-timestamp BACKUP_DIR=/backup/dir
    ```

=== "make"

    ```shell
    make backup-no-timestamp BACKUP_DIR=/backup/dir
    ```

=== "bash"

    ```shell
    bash ./scripts/backup.sh appdata /backup/dir --no-timestamp
    ```

### Development 🛠

#### docs

Build the documentation.

=== "homelab"

    ```shell
    homelab docs
    ```

=== "make"

    ```shell
    make docs
    ```

=== "bash"

    ```shell
    uv run mkdocs serve --livereload --dev-addr localhost:8000
    ```

#### lint

Lint the code with pre-commit.

=== "homelab"

    ```shell
    homelab lint
    ```

=== "make"

    ```shell
    make lint
    ```

=== "bash"

    ```shell
    pre-commit run --all-files
    ```

#### validate

Validate the docker-compose files.

=== "homelab"

    ```shell
    homelab validate
    ```

=== "make"

    ```shell
    make validate
    ```

=== "bash"

    ```shell
    docker compose -f docker-compose.core.yaml config
    docker compose -f docker-compose.apps.yaml config
    ```

### General 🌐

#### version

Show the version of the project.

=== "homelab"

    ```shell
    homelab version
    ```

=== "make"

    ```shell
    make version
    ```

=== "bash"

    ```shell
    git fetch --unshallow 2>/dev/null || true
    git fetch --tags 2>/dev/null || true
    echo "homelab $$(git describe --tags --abbrev=0)"
    ```

#### help

Show this help message and exit.

=== "homelab"

    ```shell
    homelab help
    ```

=== "make"

    ```shell
    make help
    ```
