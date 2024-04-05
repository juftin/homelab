# Traefik

![](https://i.imgur.com/JVARxB6.png)

The Traefik reverse proxy is a powerful tool for managing web traffic to your
Docker containers. It can automatically generate SSL certificates, route traffic
to the correct container, and provide a secure way to access your services from
anywhere in the world.

> [!WARNING]
>
> You must set up your router, Google OAuth, CloudFlare, DuckDNS, and Traefik
> before you can start any other services. Setting up Traefik with everything
> requires a bit of time. Please follow the instructions in this section carefully
> to get started.
>
> Once you have all of the pre-requisites set up, you can use the
> [up-traefik](cli.md#up-traefik) command to start just the Traefik services.

## Special Thank You

This configuration was inspired by, and
immensely helped by the article at
[smarthomebeginner.com](https://smarthomebeginner.com/traefik-2-docker-tutorial).

[Here](https://github.com/htpcBeginner/docker-traefik)
is their massive home server setup on GitHub which this project is based on.

## Prerequisites

### Port Forwarding

In order to reach the outside world, you must forward ports `80` and `443`
from your server IP address through your router. See your router's manual
for Instructions. See this [blog post](https://nordvpn.com/blog/open-ports-on-router/)
for more information on port forwarding

### CloudFlare

This guide leverages [CloudFlare](https://cloudflare.com/) for free
DNS services. SmartHomeBeginner has a great guide on setting up CloudFlare
[here](https://www.smarthomebeginner.com/cloudflare-settings-for-traefik-docker/).

### Google OAuth 2.0

The Google Oauth 2.0 configuration can be
found [here](https://www.smarthomebeginner.com/traefik-forward-auth-google-oauth-2022/).
Essentially you must create a project in the Google Developer Console to enable
the Google OAuth 2.0 service. You will share credentials with the `oauth` service
in the `.env` file and manually whitelist users per email address.

### DuckDNS

A free DuckDNS dynamic DNS subdomain can be set up [here](https://www.duckdns.org).
DuckDNS will provide you with a token that you will use in the `.env` file.
Behind the scenes, the `duckdns` service will update your IP address with DuckDNS
every 5 minutes which makes it possible to reach your server from anywhere. You will
provide CloudFlare with the DuckDNS subdomain to point to your server.

### File Configuration

#### .env

The `.env` needs to be modified in order for the containers to be build
properly. This is the entire configuration file for all applications.
All relevant hints can be found within.

<details><summary>📄 .env</summary>
<p>

```shell
--8<-- "docs/example.env"
```

</p>
</details>

Once you're done with all of the steps in this process you should have the following
fields filled out in the `.env` file:

```text
DUCKDNS_TOKEN=XXXXXX-XXX-XXXXX-XXXXX
DUCKDNS_SUBDOMAIN=example

GOOGLE_CLIENT_ID=XXXXXXXXXXXXX-XXXXXXXXXXXXXXXXX.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=XXXXXXXXXXXXXX
OAUTH_SECRET=RANDOM_STRING_OF_CHARACTERS
OAUTH_WHITELIST=example@gmail.com,user_1@gmail.com,user_2@gmail.com

CLOUDFLARE_EMAIL=example@gmail.com
CLOUDFLARE_API_KEY=XXXXXXXXXXXXX
```

#### acme.json

You will need to create an empty `acme.json` file for the
application to work and generate an SSL Certificate through LetsEncrypt.
However, while initially setting up it will be useful to remove and recreate the file to force
certificate recreation. Keep in mind that certificate creation and registration can take some tie.
uncomment the `certificatesResolvers.dns-cloudflare.acme.caServer=https://acme-staging-v02.api.letsencrypt.org/directory`
command on the traefik service in the `docker-compose` file while testing.

-   file location: `traefik/traefik/config/acme/acme.json`
-   file permissions (chmod): `600`

```shell
mkdir -p traefik/traefik/config/acme/ && \
  rm -f traefik/traefik/config/acme/acme.json && \
  touch traefik/traefik/config/acme/acme.json && \
  chmod 600 traefik/traefik/config/acme/acme.json
```

> [!NOTE]
> If you're comfortable with the `Makefile` at the root of the project, you can run
> `make acme-init` to create the `acme.json` as described above.

## Containers in Traefik Stack

-   [traefik](applications/traefik.md#traefik)
-   [oauth](applications/traefik.md#oauth)
-   [duckdns](applications/traefik.md#duckdns)
-   [docker-socket-proxy](applications/traefik.md#docker-socket-proxy)

## Creating New Services

The below example shows you how to create a new service in the docker compose
stack and make it accessible via Traefik. In this example, we are creating a
Jupyter notebook service that can be accessed at `jupyter.example.com`.

=== "miscellaneous/jupyter/docker-compose.yaml"

    ```yaml
    ####################################
    # JUPYTER LAB
    ####################################

    services:
        jupyter:
            container_name: jupyter
            image: jupyter/all-spark-notebook:latest
            security_opt:
                - no-new-privileges:true
            networks:
                traefik:
            command: start.sh jupyter lab
            labels:
                traefik.enable: true
                traefik.http.routers.jupyter-rtr.rule: Host(`jupyter.${DOMAIN_NAME}`)
                traefik.http.routers.jupyter-rtr.service: jupyter-svc
                traefik.http.services.jupyter-svc.loadbalancer.server.port: 8888
                traefik.http.routers.jupyter-rtr.entrypoints: websecure
                traefik.http.routers.jupyter-rtr.middlewares: chain-oauth-google@file
    ```

=== "miscellaneous/docker-compose.yaml"

    ```yaml
    ################################################################################
    # DOCKER COMPOSE - MISCELLANEOUS
    ################################################################################

    ####################################
    # INCLUDED APPLICATIONS
    ####################################

    include:
    - jupyter/docker-compose.yaml # Jupyter Lab
    ```

=== "docker-compose.yaml"

    ```yaml
    --8<-- "docker-compose.yaml"
    ```

-   `traefik.enable`
    -   Allows Traefik to interact with this application
-   `traefik.http.routers.jupyter-rtr.rule`
    -   Creates a router, "jupyter-rtr", that can be accessed @ jupyter.example.com
-   `traefik.http.routers.jupyter-rtr.service`
    -   Attaches a load balancing service, "jupyter-svc",to the router
-   `traefik.http.services.jupyter-svc.loadbalancer.server.port`
    -   Instructs the load balancer to operate on port 8888 (the exposed port of the application)
-   `traefik.http.routers.jupyter-rtr.entrypoints`
    -   Instructs the router to use the "websecure" entrypoint (https://jupyter.example.com)
-   `traefik.http.routers.jupyter-rtr.middlewares:`
    -   Instructs the router to use the middleware service, `chain-oauth-google@file`
        which requires Google OAuth for access
