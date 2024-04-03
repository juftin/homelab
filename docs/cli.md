# Command Line Usage

This project includes a Makefile that provides a variety of
commands to manage your deployment.

As a convenience wrapper, I like to add an alias to accessing
the Makefile as a `homelab` command:

```shell
alias homelab="make -s -C /path/to/this/repo"
```

If you prefer to use the `docker compose` command directly, you can
do so with the following alias:

```shell
alias homelab-compose="docker compose --project-directory /path/to/this/repo"
```

```bash exec="on" result="text" title="homelab"
make | sed 's/\x1b\[[0-9;]*m//g'
```

### Commands

#### update

Update the homelab services to the latest versions

=== "homelab"

    ```shell
    homelab update
    ```

=== "docker"

    ```shell
    docker compose pull
    docker compose up -d
    ```

=== "make"

    ```shell
    make update
    ```

#### pull

Pull the latest images for the homelab services.

=== "homelab"

    ```shell
    homelab pull
    ```

=== "docker"

    ```shell
    docker compose pull
    ```

=== "make"

    ```shell
    make pull
    ```

#### up

Start the homelab services.

=== "homelab"

    ```shell
    homelab up
    ```

=== "docker"

    ```shell
    docker compose up -d
    ```

=== "make"

    ```shell
    make up
    ```

#### down

Stop the homelab services.

=== "homelab"

    ```shell
    homelab down
    ```

=== "docker"

    ```shell
    docker compose down
    ```

=== "make"

    ```shell
    make down
    ```

#### stop

Stop the homelab services.

=== "homelab"

    ```shell
    homelab stop
    ```

=== "docker"

    ```shell
    docker compose stop
    ```

=== "make"

    ```shell
    make stop
    ```

#### logs

Show the logs for the homelab services.

=== "homelab"

    ```shell
    homelab logs
    ```

=== "docker"

    ```shell
    docker compose logs -f
    ```

=== "make"

    ```shell
    make logs
    ```

#### restart

Restart the homelab services.

=== "homelab"

    ```shell
    homelab restart
    ```

=== "docker"

    ```shell
    docker compose restart
    ```

=== "make"

    ```shell
    make restart
    ```

#### ps

Show the status of the homelab services.

=== "homelab"

    ```shell
    homelab ps
    ```

=== "docker"

    ```shell
    docker compose ps --format "table {{.Image}}\t{{.Status}}\t{{.Ports}}\t{{.Name}}"
    ```

=== "make"

    ```shell
    make ps
    ```

#### up-traefik

Start just the traefik services.

=== "homelab"

    ```shell
    homelab up-traefik
    ```

=== "docker"

    ```shell
    docker compose up -d traefik oauth socket-proxy duckdns
    ```

=== "make"

    ```shell
    make up-traefik
    ```

#### acme-init

Initialize the `acme.json` file for traefik.

=== "homelab"

    ```shell
    homelab acme-init
    ```

=== "bash"

    ```shell
    mkdir -p traefik/traefik/config/acme/ && \
    rm -f traefik/traefik/config/acme/acme.json && \
    touch traefik/traefik/config/acme/acme.json && \
    chmod 600 traefik/traefik/config/acme/acme.json
    ```

=== "make"

    ```shell
    make acme-init
    ```
