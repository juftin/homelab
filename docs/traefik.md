# Traefik

<img src="../static/traefik_logo.png" width="400" alt="traefik logo">

Hosted Reverse Proxy with Google OAuth for operating a webserver
from home. This reverse-proxy automatically picks up new docker services
given the proper labels are applied.

-   [Configuration](#configuration)
    -   [Port Forwarding](#port-forwarding)
    -   [CloudFlare](#cloudflare)
    -   [Google OAuth 2.0](#google-oauth-20)
    -   [DuckDNS](#duckdns)
    -   [File Configuration](#file-configuration)
        -   [.env](#env)
        -   [acme.json](#acmejson)
-   [Usage](#usage)
    -   [Jupyter Example](#jupyter-example)
    -   [Local Usage](#local-usage)

## Configuration

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
[https://smarthomebeginner.com](https://www.smarthomebeginner.com/traefik-2-docker-tutorial).

[Here](https://github.com/htpcBeginner/docker-traefik)
is their massive home server setup on GitHub, and the accompanying
[docker-compose](https://github.com/htpcBeginner/docker-traefik/blob/master/docker-compose-t2.yml)
file.

### Port Forwarding

In order to reach the outside world, you must forward ports
`80` and `443` from your server IP address through your router.
See your router's manual for Instructions.

### CloudFlare

This guide leverages [CloudFlare](https://dash.cloudflare.com/) for free
DNS services. The CloudFlare section of the article can be found
[here](https://www.smarthomebeginner.com/traefik-reverse-proxy-tutorial-for-docker/#Dynamic_DNS_or_Your_Own_Domain_Name).

### Google OAuth 2.0

The Google Oauth 2.0 configuration can be
found [here](https://www.smarthomebeginner.com/google-oauth-with-traefik-docker/#How_do_I_setup_OAuth).
This configuration requires Google Authentication to access any services published on the web.

### DuckDNS

A free DuckDNS dynamic DNS subdomain can be set up [here](https://www.duckdns.org).

### File Configuration

#### `.env`

The [`example.env`](example.env) file can be modified and renamed `.env` in order
for the containers to be build properly. This is the entire configuration file for
all applications. All relevant hints can be found within.

```shell
cp docs/example.env .env
```

<details><summary>📄 .env</summary>
<p>

```shell
--8<-- "docs/example.env"
```

</p>
</details>

#### `acme.json`

You will need to create an empty `acme.json` file for the
application to work and generate an SSL Certificate through LetsEncrypt.
However, while initially setting up it will be useful to remove and recreate the file to force
certificate recreation. Keep in mind that certificate creation and registration can take some tie.
uncomment
the `certificatesResolvers.dns-cloudflare.acme.caServer=https://acme-staging-v02.api.letsencrypt.org/directory`
command on the traefik service in the `docker-compose` file while testing.
The instructions are below:

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

## Usage

### Jupyter Example:

The below example allows the jupyter container to speak to the `traefik_reverse-proxy` (the
external network created by this _compose_ configuration - notice the docker-compose
project name added before the network name). Apart from the networking, everything
else is performed with the labels.

```yaml
version: "3.7"
networks:
    traefik:
        external:
            name: traefik_reverse-proxy
services:
    jupyter:
        container_name: jupyter
        image: jupyter/all-spark-notebook:latest
        networks:
            traefik: null
        command: start.sh jupyter lab
        labels:
            traefik.enable: true
            traefik.http.routers.jupyter-rtr.rule: Host(`jupyter.${DOMAIN_NAME}`)
            traefik.http.routers.jupyter-rtr.service: jupyter-svc
            traefik.http.services.jupyter-svc.loadbalancer.server.port: 8888
            traefik.http.routers.jupyter-rtr.entrypoints: https
            traefik.http.routers.jupyter-rtr.middlewares: chain-oauth-google@file
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
    -   Instructs the router to use the "https" entrypoint (https://jupyter.example.com)
-   `traefik.http.routers.jupyter-rtr.middlewares:`
    -   Instructs the router to use the middleware service, `chain-oauth-google@file`
        which requires Google OAuth for access

# Containers

-   [traefik](#traefik)
-   [oauth](#oauth)
-   [duckdns](#duckdns)
-   [docker-socket-proxy](#docker-socket-proxy)

## traefik

[Docker Hub](https://hub.docker.com/_/traefik) \|\|
[GitHub](https://github.com/containous/traefik) \|\|
[Website](https://traefik.io/) \|\|
[Documentation](https://docs.traefik.io/)

<img src="../static/traefik_logo.png" width="300" alt="traefik Logo">

Traefik (pronounced traffic) is a modern HTTP reverse proxy
and load balancer that makes deploying microservices easy.
Traefik integrates with your existing infrastructure components
(Docker, Swarm mode, Kubernetes, Marathon, Consul, Etcd, Rancher, Amazon ECS, ...)
and configures itself automatically and dynamically. Pointing Traefik
at your orchestrator should be the only configuration step you need.

## oauth

[Docker Hub](https://hub.docker.com/r/thomseddon/traefik-forward-auth) \|\|
[GitHub](https://github.com/thomseddon/traefik-forward-auth)

<img src="../static/oauth2.png" width="250" alt="oauth">

A minimal forward authentication service that provides Google oauth based
login and authentication for the traefik reverse proxy/load balancer.

## duckdns

[Docker Hub](https://hub.docker.com/r/linuxserver/duckdns/) \|\|
[GitHub](https://github.com/linuxserver/docker-duckdns) \|\|
[Website](https://www.duckdns.org)

<img src="../static/duckdns.jpg" width="250" alt="duckdns">

Duckdns is a free service which will point a DNS (sub domains of duckdns.org)
to an IP of your choice. The service is completely free, and doesn't
require reactivation or forum posts to maintain its existence.

## docker-socket-proxy

[Docker Hub](https://hub.docker.com/r/tecnativa/docker-socket-proxy) \|\|
[GitHub](https://github.com/Tecnativa/docker-socket-proxy)

`docker-socket-proxy` is a security-enhanced proxy for the Docker Socket.
It blocks access to the Docker socket API according to the environment
variables you set. It returns a HTTP 403 Forbidden status for those
dangerous requests that should never happen.

---

---
