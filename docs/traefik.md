# Traefik

![](https://i.imgur.com/JVARxB6.png)

The Traefik reverse proxy is a powerful tool for managing web traffic to your
Docker containers. It can automatically generate SSL certificates, route traffic
to the correct container, and provide a secure way to access your services from
anywhere in the world.

> [!WARNING]
>
> You must set up your router, custom domain, Google OAuth, CloudFlare, 
> DuckDNS, and Traefik before you can start any other services. Setting 
> up Traefik with everything requires a bit of time. Please follow the
> instructions in this section carefully to get started.
>
> Once you have each of the pre-requisites set up, you can use the
> [core-up](cli.md#core-up) command to start just the Traefik services
> and confirm that everything is working at https://traefik.yourdomain.com.
> Initial DNS propagation and certificate generation can take some time, so
> be patient on the first run.
> 
> See the [Command Line](cli.md) documentation for more information on how to 
> operate the stack

> [!INFO] "Acknowledgements"
> This configuration was inspired by, and
> immensely helped by the article at
> [smarthomebeginner.com](https://www.smarthomebeginner.com/traefik-docker-compose-guide-2024/).
> Their massive [home server setup on GitHub](https://github.com/htpcBeginner/docker-traefik)
> and amazing blog series inspired much of this project.

## Prerequisites

### Personal Domain

This guide assumes you have a personal domain name that you can use to
access your services. You can purchase a domain name from a registrar
like [Cloudflare](https://www.cloudflare.com/products/registrar/).

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

A helpful blog post on the Google Oauth 2.0 configuration can be
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

All services are configured via a `.env` file at the root of the project and a few secret
files in the `secrets` directory. These files are used to define settings and credentials
for all services that are deployed. You can copy the example files to get started:

```shell
cp docs/example.env .env
cp -r docs/example-secrets/ secrets/
```

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
CLOUDFLARE_EMAIL=example@gmail.com
```

And you should also update the secrets files:

=== "secrets/google_oauth.secret"

    ```text
    --8<-- "docs/example-secrets/google_oauth.secret"
    ```

=== "secrets/cloudflare_api_key.secret"

    ```text
    --8<-- "docs/example-secrets/cloudflare_api_key.secret"
    ```

=== "secrets/admin_password"

    ```text
    --8<-- "docs/example-secrets/admin_password.secret"
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
mkdir -p appdata/traefik/traefik/acme/ && \
  rm -f appdata/traefik/traefik/acme/acme.json && \
  touch appdata/traefik/traefik/acme/acme.json && \
  chmod 600 appdata/traefik/traefik/acme/acme.json
```

> [!NOTE]
> If you're comfortable with the `Makefile` at the root of the project, you can run
> `make config-acme` to create the `acme.json` as described above.

## Containers in Traefik Stack

-   [traefik](applications/traefik.md#traefik)
-   [oauth](applications/traefik.md#oauth)
-   [duckdns](applications/traefik.md#duckdns)
-   [docker-socket-proxy](applications/traefik.md#docker-socket-proxy)

## Creating New Services

The below example (which has already been done) shows you how to create a
new service in the docker compose stack and make it accessible via Traefik.
In this example, we are creating a LibreOffice service that can be accessed
at `https://libreoffice.example.com`. If possible, I recommend using a
[LinuxServer](https://github.com/linuxserver) image as they are well
maintained and have a common configuration. Once the `libreoffice.yaml` file
is created, you can reference it in the root `docker-compose.yaml` (by uncommenting
the reference to `stacks/miscellaneous/libreoffice.yaml` line) and then run
`docker-compose up -d`.

=== "stacks/miscellaneous/libreoffice.yaml"

    ```yaml
    --8<-- "stacks/miscellaneous/libreoffice.yaml"
    ```

=== "docker-compose.yaml"

    ```yaml
    --8<-- "docker-compose.yaml"
    ```

-   `traefik.enable`
    -   Allows Traefik to interact with this application
-   `traefik.http.routers.libreoffice-rtr.rule`
    -   Creates a router, "libreoffice-rtr", that can be accessed @ libreoffice.example.com
-   `traefik.http.routers.libreoffice-rtr.service`
    -   Attaches a load balancing service, "libreoffice-svc",to the router
-   `traefik.http.services.libreoffice-svc.loadbalancer.server.port`
    -   Instructs the load balancer to operate on port 8888 (the exposed port of the application)
-   `traefik.http.routers.libreoffice-rtr.entrypoints`
    -   Instructs the router to use the "websecure" entrypoint (https://libreoffice.example.com)
-   `traefik.http.routers.libreoffice-rtr.middlewares:`
    -   Instructs the router to use the middleware service, `chain-oauth-google@file`
        which requires Google OAuth for access
