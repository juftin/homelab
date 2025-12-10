# Command Line Usage

This project includes a `Makefile` that provides a variety of
commands to manage your deployment.

!!! info "**`homelab`** and **`homelab-compose`**"

    You will see the **`make`** command and **`homelab`** used interchangeably
    in this documentation. The **`homelab`** command is a convenience wrapper
    around **`make`** so you can easily run the Makefile from anywhere.

    Add this to your `.bashrc` / `.zshrc` to use the **`homelab`** command:

    ```shell
    alias homelab="make --no-print-directory --directory /path/to/this/repo"
    ```

    If you'd like to use the **`docker compose`** command from anywhere, you can
    do so with the following alias:

    ```shell
    alias homelab-compose="docker compose --project-directory /path/to/this/repo"
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

Update the homelab service(s) to the latest versions.

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab update
    ```

=== "make"

    ```shell
    make update
    ```

=== "docker"

    ```shell
    docker compose --profile all pull
    docker compose --profile all up -d
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all pull
    homelab-compose --profile all up -d
    ```

#### pull

Pull the latest images for the homelab service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab pull
    ```

=== "make"

    ```shell
    make pull
    ```

=== "docker"

    ```shell
    docker compose --profile all pull
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all pull
    ```

#### up

Start the homelab service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab up
    ```

=== "make"

    ```shell
    make up
    ```

=== "docker"

    ```shell
    docker compose --profile all up -d
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all up -d
    ```

#### down

Stop the homelab service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab down
    ```

=== "make"

    ```shell
    make down
    ```

=== "docker"

    ```shell
    docker compose --profile all down
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all down
    ```

#### stop

Stop the homelab service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab stop
    ```

=== "make"

    ```shell
    make stop
    ```

=== "docker"

    ```shell
    docker compose --profile all stop
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all stop
    ```

#### logs

Show the logs for the homelab service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab logs
    ```

=== "make"

    ```shell
    make logs
    ```

=== "docker"

    ```shell
    docker compose --profile all logs -ft
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all logs -ft
    ```

#### restart

Restart the homelab service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab restart
    ```

=== "make"

    ```shell
    make restart
    ```

=== "docker"

    ```shell
    docker compose --profile all restart
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all restart
    ```

#### ps

Show the status of the homelab service(s).

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
    docker compose --profile all ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"
    ```

#### config

Show the configuration of the homelab service(s).

\* _Defaults to all, accepts the `APP` flag_ \* _Accepts the `ARGS` flag_

=== "homelab"

    ```shell
    homelab config
    ```

=== "make"

    ```shell
    make config
    ```

=== "docker"

    ```shell
    docker compose --profile all config
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile all config
    ```

### Core Services 🧠

#### core-up

Start just the core services (traefik, oauth2, etc).

=== "homelab"

    ```shell
    homelab core-up
    ```

=== "make"

    ```shell
    make core-up
    ```

=== "docker"

    ```shell
    docker compose --profile core up -d
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile core up -d
    ```

#### core-down

Stop just the core services (traefik, oauth2, etc).

=== "homelab"

    ```shell
    homelab core-down
    ```

=== "make"

    ```shell
    make core-down
    ```

=== "docker"

    ```shell
    docker compose --profile core down
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile core down
    ```

#### core-logs

Show the logs for the core services (traefik, oauth2, etc).

=== "homelab"

    ```shell
    homelab core-logs
    ```

=== "make"

    ```shell
    make core-logs
    ```

=== "docker"

    ```shell
    docker compose --profile core logs -ft
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile core logs -ft
    ```

### Media Services 📺

#### media-up

Start just the media services (plex, sonarr, radarr, etc).

=== "homelab"

    ```shell
    homelab media-up
    ```

=== "make"

    ```shell
    make media-up
    ```

=== "docker"

    ```shell
    docker compose --profile media up -d
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile media up -d
    ```

#### media-down

Stop just the media services (plex, sonarr, radarr, etc).

=== "homelab"

    ```shell
    homelab media-down
    ```

=== "make"

    ```shell
    make media-down
    ```

=== "docker"

    ```shell
    docker compose --profile media down
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile media down
    ```

#### media-logs

Show the logs for the media services (plex, sonarr, radarr, etc).

=== "homelab"

    ```shell
    homelab media-logs
    ```

=== "make"

    ```shell
    make media-logs
    ```

=== "docker"

    ```shell
    docker compose --profile media logs -ft
    ```

=== "homelab-compose"

    ```shell
    homelab-compose --profile media logs -ft
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
