# Configuration

## traefik

Traefik (pronounced traffic) is a modern HTTP reverse proxy and load balancer that
makes deploying microservices easy.

It is the core of the entire `homelab` stack as it routes all incoming traffic to the
correct service. It is the first service that you should start with:

> [!WARNING]
>
> You must set up your router, Google OAuth, CloudFlare, DuckDNS, and Traefik
> before you can start any other services. Setting up Traefik with everything
> requires a bit of time. Please follow the instructions in the
> [Traefik 🚦](traefik.md) section to get started.
>
> Once you have all of the pre-requisites set up, you can use the
> [up-traefik](cli.md#up-traefik) command to start just the Traefik services.

## Apps

Which apps to deploy are defined in the `docker-compose.yaml` files. For example,
to disable all apps from the `miscellaneous` stack, you would comment out the `include` directive
in the root `docker-compose.yaml` file.

<details><summary>📄 docker-compose.yaml</summary>
<p>

```yaml
--8<-- "docker-compose.yaml"
```

</p>
</details>

To disable specific apps in the `media-center` stack, you would comment out the `include` directive
in the `media-center/docker-compose.yaml` file.

<details><summary>📄 media-center/docker-compose.yaml</summary>
<p>

```yaml
--8<-- "media-center/docker-compose.yaml"
```

</p>
</details>

## App Configuration

These project makes use of a few configuration files to make it easier to manage:

```shell
cp docs/example.env .env
cp -r docs/example-secrets/ secrets/
```

-   `.env` - Environment variables that are used by the `docker-compose.yaml` files
-   `secrets/google_oauth.secret` - The Google OAuth API credentials and user whitelist
-   `secrets/cloudflare_api_key.secret` - The CloudFlare API key (singular, plaintext key)
-   `secrets/admin_password.secret` - The password for the `admin` user in the `pi-hole` service (singular, plaintext key)

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

</p>
</details>

<details><summary>📄 secrets/admin_password.secret</summary>
<p>

```shell
--8<-- "docs/example-secrets/admin_password.secret"
```

</p>
</details>
