# Migrations

When larger changes are made this project there are occasionally migrations that
need to be run. These are mostly for updating the directory structure and
will be minimized as much as possible.

## 1.11.0

The 1.11.0 release moved everything under the `stacks` directory to the top level
of a new `apps` directory. It also moved everything under the `appdata` directory
to the top level.

<details><summary>1.10.0 to 1.11.0 Migration</summary>
<p>

```shell
#!/usr/bin/env bash

sudo mv appdata/media/* appdata/
rm -r appdata/media

sudo mv appdata/core/* appdata/
rm -r appdata/core

sudo mv appdata/utilities/* appdata/
rm -r appdata/utilities

sudo mv appdata/miscellaneous/* appdata/
rm -r appdata/miscellaneous
```

</p>
</details>

## 1.9.0

The 1.9.0 release renames the `media-center`stack to `media`,
renames `traefik` stack to `core`,
and creates a new `utilities` stack for services like
`sftpgo`, `portainer`, and `pihole`.

<details><summary>1.8.0 to 1.9.0 Migration</summary>
<p>

During the upgrade the stack should be shut down,
the below commands should be run, and then the
git commands should be run to pull in the
latest changes.

```shell
#!/usr/bin/env bash

mv appdata/media-center appdata/media
mv appdata/traefik appdata/core

mkdir -p appdata/utilities

mv appdata/miscellaneous/pihole/ appdata/utilities/
sudo mv appdata/media/portainer/ appdata/utilities/
mv appdata/media/sftpgo/ appdata/utilities/
```

</p>
</details>

## 1.6.0

The 1.6.0 release moves all of the `config` directories where docker
settings and data is persisted locally and moves them to a top level `appdata`
directory.

<details><summary>1.5.0 to 1.6.0 Migration</summary>
<p>

```shell
#!/usr/bin/env bash

mkdir -p appdata/traefik
mkdir -p appdata/media-center
mkdir -p appdata/miscellaneous

mv stacks/core/traefik/config appdata/traefik/traefik

mv stacks/media-center/calibre/config appdata/media-center/calibre
mv stacks/media-center/calibre-web/config appdata/media-center/calibre-web
mv stacks/media-center/heimdall/config appdata/media-center/heimdall
mv stacks/media-center/nzbget/config appdata/media-center/nzbget
mv stacks/media-center/ombi/config appdata/media-center/ombi
mv stacks/media-center/plex/config appdata/media-center/plex
mv stacks/media-center/prowlarr/config appdata/media-center/prowlarr
mv stacks/media-center/radarr/config appdata/media-center/radarr
mv stacks/media-center/readarr/config appdata/media-center/readarr
mv stacks/media-center/sftpgo/config appdata/media-center/sftpgo
mv stacks/media-center/sonarr/config appdata/media-center/sonarr
mv stacks/media-center/tautulli/config appdata/media-center/tautulli
mv stacks/media-center/transmission/config appdata/media-center/transmission

mv stacks/miscellaneous/pihole/config appdata/miscellaneous/pihole

sudo mv stacks/media-center/portainer/config appdata/media-center/portainer
```

</p>
</details>

## 1.5.0

The 1.5.0 release moves all docker compose stacks under a `stacks` directory.

<details><summary>1.4.0 to 1.5.0 Migration</summary>
<p>

```shell
#!/usr/bin/env bash

mkdir -p stacks
mv traefik stacks/traefik
mv media-center stacks/media-center
mv miscellaneous stacks/miscellaneous
```

</p>
</details>

## 1.0.0

The `1.0.0` release introduces a pivotal update for existing users of the homelab project.
This update mandates the creation of a new config directory within each service directory,
deviating from the previous approach of directly mounting the service directory into the container.
This change is designed to enhance organization and management of service configurations.

<details><summary>0.5.2 to 1.0.0 Migration</summary>
<p>

```shell
#!/usr/bin/env bash

######################################################################
# NOTE:
#
# Traefik, Portainer, and Pi-Hole have unique migrations compared to
# the other services:
# - Traefik - The configuration files are moved to the `traefik/config`
# - Portainer - sudo is required to move the portainer directory
# - Pi-Hole - The configuration files are moved to the `miscellaneous/pihole/config`
######################################################################

# portainer - media-center/portainer becomes media-center/portainer/config
mv media-center/portainer media-center/portainer_temp
mkdir -p media-center/portainer
sudo mv media-center/portainer_temp media-center/portainer/config

# pi-hole - config directories consolidated to miscellaneous/pi-hole/config
mkdir -p miscellaneous/pihole/config
mv miscellaneous/pihole/etc-pihole miscellaneous/pihole/config/pihole
mv miscellaneous/config/etc-dnsmasq.d miscellaneous/pihole/config/dnsmasq.d
rm -r miscellaneous/config/

# traefik - traefik/traefik becomes traefik/traefik/config, rules moved to traefik/traefik/rules
mv traefik/traefik/ traefik_temp
mkdir -p traefik/traefik/config
mv traefik_temp/rules traefik/traefik/rules
mv traefik_temp/config traefik/traefik/config/traefik
mv traefik_temp/logs traefik/traefik/config/logs
mv traefik_temp/acme traefik/traefik/config/acme
rm -r traefik_temp

######################################################################

# heimdall - media-center/heimdall becomes media-center/heimdall/config
mv media-center/heimdall media-center/heimdall_temp
mkdir -p media-center/heimdall
mv media-center/heimdall_temp media-center/heimdall/config

# ombi - media-center/ombi becomes media-center/ombi/config
mv media-center/ombi media-center/ombi_temp
mkdir -p media-center/ombi
mv media-center/ombi_temp media-center/ombi/config

# plex - media-center/plex becomes media-center/plex/config
mv media-center/plex media-center/plex_temp
mkdir -p media-center/plex
mv media-center/plex_temp media-center/plex/config

# tautulli - media-center/tautulli becomes media-center/tautulli/config
mv media-center/tautulli media-center/tautulli_temp
mkdir -p media-center/tautulli
mv media-center/tautulli_temp media-center/tautulli/config

# sonarr - media-center/sonarr becomes media-center/sonarr/config
mv media-center/sonarr media-center/sonarr_temp
mkdir -p media-center/sonarr
mv media-center/sonarr_temp media-center/sonarr/config

# radarr - media-center/radarr becomes media-center/radarr/config
mv media-center/radarr media-center/radarr_temp
mkdir -p media-center/radarr
mv media-center/radarr_temp media-center/radarr/config

# prowlarr - media-center/prowlarr becomes media-center/prowlarr/config
mv media-center/prowlarr media-center/prowlarr_temp
mkdir -p media-center/prowlarr
mv media-center/prowlarr_temp media-center/prowlarr/config

# readarr - media-center/readarr becomes media-center/readarr/config
mv media-center/readarr media-center/readarr_temp
mkdir -p media-center/readarr
mv media-center/readarr_temp media-center/readarr/config

# calibre - media-center/calibre becomes media-center/calibre/config
mv media-center/calibre media-center/calibre_temp
mkdir -p media-center/calibre
mv media-center/calibre_temp media-center/calibre/config

# calibre-web - media-center/calibre-web becomes media-center/calibre-web/config
mv media-center/calibre-web media-center/calibre-web_temp
mkdir -p media-center/calibre-web
mv media-center/calibre-web_temp media-center/calibre-web/config

# transmission - media-center/transmission becomes media-center/transmission/config
mv media-center/transmission media-center/transmission_temp
mkdir -p media-center/transmission
mv media-center/transmission_temp media-center/transmission/config

# nzbget - media-center/nzbget becomes media-center/nzbget/config
mv media-center/nzbget media-center/nzbget_temp
mkdir -p media-center/nzbget
mv media-center/nzbget_temp media-center/nzbget/config
```

</p>
</details>
