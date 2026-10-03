# Miscellaneous Profile

## coder

[![](https://img.shields.io/static/v1?message=codercom/coder&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/codercom/coder)
[![](https://img.shields.io/static/v1?message=coder/coder&logo=github&label=github)](https://github.com/coder/coder)
[![](https://img.shields.io/static/v1?message=coder.com&logo=google+chrome&label=website&color=teal)](https://coder.com)

<img src="https://i.imgur.com/S0fGmKE.png" width="250" alt="Coder Logo">

Coder is a cloud-based development environment that allows you to code from anywhere.
It provides a consistent, secure development environment that can be accessed from any device.

## camply

[![](https://img.shields.io/static/v1?message=juftin/camply&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/juftin/camply)
[![](https://img.shields.io/static/v1?message=juftin/camply&logo=github&label=github)](https://github.com/juftin/camply)

<img src="https://raw.githubusercontent.com/juftin/camply/main/docs/static/camply.svg" width="250" alt="Camply Logo">

Camply is a camping search and notification tool that helps you find available campsites
at popular recreation areas. It monitors availability and sends notifications when
campsites become available.

## libreoffice

[![](https://img.shields.io/static/v1?message=linuxserver/libreoffice&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/libreoffice)
[![](https://img.shields.io/static/v1?message=libreoffice.org&logo=google+chrome&label=website&color=teal)](https://libreoffice.org)

<img src="https://i.imgur.com/NRFdFVt.png" width="250" alt="LibreOffice Logo">

> [!NOTE] LibreOffice is not enabled by default

LibreOffice is a free and powerful office suite, and a successor to OpenOffice.org
(commonly known as OpenOffice). Its clean interface and feature-rich tools help you
unleash your creativity and enhance your productivity.

## umami

[![](https://img.shields.io/static/v1?message=umami-software/umami-postgresql&logo=docker&label=docker&color=blue)](https://github.com/umami-software/umami/pkgs/container/umami)
[![](https://img.shields.io/static/v1?message=umami-software/umami&logo=github&label=github)](https://github.com/umami-software/umami)
[![](https://img.shields.io/static/v1?message=umami.is&logo=google+chrome&label=website&color=teal)](https://umami.is)

> [!NOTE] Umami is not enabled by default

<img src="https://i.imgur.com/4iJcXk0.png" width="250" alt="Umami Logo">

Umami is a simple, fast, privacy-focused alternative to Google Analytics.

> [!WARNING] Important
>
> Umami needs a PostgreSQL database to work, the `apps/postgres.yaml` service
> is a dependency of Umami. You must also add "umami" to the `POSTGRES_MULTIPLE_DATABASES`
> variable in your `.env` file or manually create the database yourself before starting:
>
> ```sql
> CREATE USER umami WITH PASSWORD '$POSTGRES_PASSWORD';
> CREATE DATABASE umami;
> GRANT SET ON PARAMETER session_replication_role TO umami;
> ALTER DATABASE umami OWNER TO umami;
> ```

> [!WARNING] Important
>
> The default username is `admin` and the default password
> is `umami`. You should change this as soon as you log in the first time.

## homeassistant

[![](https://img.shields.io/static/v1?message=homeassistant/home-assistant&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/homeassistant/home-assistant)
[![](https://img.shields.io/static/v1?message=home-assistant.io&logo=google+chrome&label=website&color=teal)](https://home-assistant.io)

> [!NOTE] Home Assistant is not enabled by default

<img src="https://i.imgur.com/Q6id8yF.png" width="250" alt="Home Assistant Logo">

Home Assistant is an open-source home automation platform that focuses on privacy and local control.
It's a great way to automate your home and make it smarter.

## healthchecks

[![](https://img.shields.io/static/v1?message=linuxserver/healthchecks&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/healthchecks)
[![](https://img.shields.io/static/v1?message=healthchecks/healthchecks&logo=github&label=github)](https://github.com/healthchecks/healthchecks)

> [!NOTE] Healthchecks is not enabled by default
