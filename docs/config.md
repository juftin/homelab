# Configuration

## traefik

[Traefik] (pronounced traffic) is a modern HTTP reverse proxy and load balancer that
makes deploying microservices easy.

It is the core of the entire `homelab` stack as it routes all incoming traffic to the
correct service. It is the first service that you should start with:

## Infrastructure Configuration

> [!WARNING]
>
> You must set up your router, Google OAuth, CloudFlare, DuckDNS, and Traefik
> before you can start any other services. Setting up Traefik with everything
> requires a bit of time. See the instructions in the
> [Traefik 🚦](traefik.md) section for more details.
>
> Once you have all of the pre-requisites set up, you can use the
> [core-up](cli.md#core-up) command to start just the Traefik services.
> See the [Command Line documentation](#cli.md) for more info.

All services are configured via a `.env` file at the root of the project and a few secret
files in the `secrets` directory. These files are used to define settings and credentials
for all services that are deployed. You can copy the example files to get started:

```shell
cp docs/example.env .env
cp -r docs/example-secrets/ secrets/
```

-   `.env` - Environment variables that are used by the `docker-compose.yaml` files
-   `secrets/google_oauth.secret` - The Google OAuth API credentials and user whitelist
-   `secrets/cloudflare_api_key.secret` - The CloudFlare API key (singular, plaintext key)

<details><summary>📄 .env</summary>
<p>

```shell
--8<-- "docs/example.env"
```

</p>
</details>

<details><summary>📄 secrets/google_oauth.secret</summary>
<p>

```shell
--8<-- "docs/example-secrets/google_oauth.secret"
```

</p>

</details>

<details><summary>📄 secrets/cloudflare_api_key.secret</summary>
<p>

```shell
--8<-- "docs/example-secrets/cloudflare_api_key.secret"
```

## App Deployment

Which apps to deploy are defined in the `docker-compose.yaml` files. For example,
To disable specific apps in the `media` stack, you would comment out the `include` directive
in the root `docker-compose.yaml` file.

<details><summary>📄 docker-compose.yaml</summary>
<p>

```yaml
--8<-- "docker-compose.yaml"
```

</p>
</details>

## App Configuration

Each app has its own configuration process - see the `Applications` documentation
for more information about a specific app.

When connecting these applications together, it is important to note that they
all share a common docker network. This means that when you're trying to connect
to a service you can simply use a service name as the hostname. For example,
if you're trying to connect to the sonarr service from the ombi service
you can simply use http://sonarr:8989 as the hostname.

[Traefik]: https://github.com/traefik/traefik
