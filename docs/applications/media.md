# Media Profile

## Table of Contents

- [plex](#plex)
- [jellyfin](#jellyfin)
- [sonarr](#sonarr)
- [radarr](#radarr)
- [prowlarr](#prowlarr)
- [bazarr](#bazarr)
- [recyclarr](#recyclarr)
- [seerr](#seerr)
- [tautulli](#tautulli)
- [transmission](#transmission)
- [sabnzbd](#sabnzbd)
- [nzbhydra](#nzbhydra)
- [heimdall](#heimdall)
- [readarr](#readarr)
- [calibre](#calibre)
- [calibre-web](#calibre-web)

## plex

[![](https://img.shields.io/static/v1?message=linuxserver/plex&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/plex)
[![](https://img.shields.io/static/v1?message=linuxserver/docker-plex&logo=github&label=github)](https://github.com/linuxserver/docker-plex)
[![](https://img.shields.io/static/v1?message=plex.tv&logo=google+chrome&label=website&color=teal)](https://plex.tv)

<img src="https://i.imgur.com/4BpXWw5.png" width="290" alt="Plex Logo">

Plex organizes video, music and photos from personal media libraries
and streams them to smart TVs, streaming boxes and mobile devices. This
container is packaged as a standalone Plex Media Server. Straightforward
design and bulk actions mean getting things done faster.

### Configuration

Plex setup is fairly intuitive and straightforward. When setting up libraries you will
use the root directories, `/tv/` and `/movies/`

Following [TRaSH Guides Plex recommendations](https://trash-guides.info/Plex/Plex-recommended-settings/):

- **Enable** _Run a partial scan when changes are detected_ under **Settings → Library** so new imports appear immediately.
- **Disable** _Empty trash automatically after every scan_ when media lives on a NAS mount so a temporary mount drop does not wipe library metadata.

## jellyfin

[![](https://img.shields.io/static/v1?message=linuxserver/jellyfin&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/jellyfin)
[![](https://img.shields.io/static/v1?message=jellyfin/jellyfin&logo=github&label=github)](https://github.com/jellyfin/jellyfin)
[![](https://img.shields.io/static/v1?message=jellyfin.org&logo=google+chrome&label=website&color=teal)](https://jellyfin.org)

<img src="https://i.imgur.com/BjIOz1v.png" width="250" alt="Jellyfin Logo">

Jellyfin is a free and open-source media server and suite of multimedia applications designed
to organize, manage, and share digital media files to networked devices. It's an alternative
to proprietary media servers like Plex and Emby.

### Configuration

Jellyfin setup is similar to Plex. When setting up libraries you will use the
root directories, `/data/tvshows/` and `/data/movies/`

## sonarr

[![](https://img.shields.io/static/v1?message=linuxserver/sonarr&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/sonarr)
[![](https://img.shields.io/static/v1?message=Sonarr/Sonarr&logo=github&label=github)](https://github.com/Sonarr/Sonarr)
[![](https://img.shields.io/static/v1?message=sonarr.tv&logo=google+chrome&label=website&color=teal)](https://www.sonarr.tv)

<img src="https://i.imgur.com/niYuq42.png" width="250" alt="Sonarr Logo">

Sonarr (formerly NZBdrone) is a PVR for usenet and bittorrent users.
It can monitor multiple RSS feeds for new episodes of your
favorite shows and will grab, sort and rename them. It can also be
configured to automatically upgrade the quality of files already
downloaded when a better quality format becomes available.

### Configuration

For security, I like to set up a basic authorization form on the `General Settings` to
exclude non-admin users from accessing the application using the `ADMIN_USER` and
`ADMIN_PASSWORD` variables.

#### Download Client Configuration

<img src="https://i.imgur.com/ylgvH5r.png" width="600" alt="sonarr_download_client_config">

#### Indexer Client Configuration

<img src="https://i.imgur.com/VwfD0wl.png" width="600" alt="sonarr_indexer_config">

## radarr

[![](https://img.shields.io/static/v1?message=linuxserver/radarr&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/radarr)
[![](https://img.shields.io/static/v1?message=Radarr/Radarr&logo=github&label=github)](https://github.com/Radarr/Radarr)
[![](https://img.shields.io/static/v1?message=radarr.video&logo=google+chrome&label=website&color=teal)](https://radarr.video)

<img src="https://i.imgur.com/0vmLnzy.png" width="250" alt="Radarr Logo">

Radarr is an independent fork of Sonarr reworked for automatically
downloading movies via Usenet and BitTorrent.

### Configuration

See the [sonarr](#sonarr) sections for more detailed
instructions around setting up Indexers and Download clients with radarr.
The use of Prowlarr makes this process easy. For security, I like to set
up a basic authorization form on the `General Settings` to exclude non-admin
users from accessing the application using the `ADMIN_USER` and `ADMIN_PASSWORD`
variables.

### Hardlinks and atomic imports

Set `MEDIA_ROOT` to an existing host directory that contains
`COMPLETED_DOWNLOADS`, `TV_DIR`, and `MOVIE_DIR` on one filesystem.
Sonarr and Radarr mount this parent at `/storage`. For example, with
`MEDIA_ROOT=/media/storage` and the paths from the example environment file,
the download directory is visible to both apps at `/storage/downloads`,
with the TV and movie libraries at `/storage/tv` and `/storage/movies`.
Use this option only with a parent directory whose contents Sonarr and Radarr
can access. With `MEDIA_ROOT` unset, existing app paths still work and
`/storage` is an alias for the completed-download directory.

1. Recreate Sonarr, Radarr, Bazarr, SABnzbd, Prowlarr, and Transmission so `/storage` and `UMASK` (`002` by default) are applied:
   `docker compose --file docker-compose.apps.yaml up -d --no-deps sonarr radarr bazarr sabnzbd prowlarr transmission`.
2. In Sonarr and Radarr under **Settings → Media Management**, ensure **Use Hardlinks instead of Copy** is enabled.
3. In each app, open **Settings → Download Clients → Remote Path Mappings**.
   Add a mapping for each downloader using its configured host name (normally
   `sabnzbd` and `transmission`), with remote path `/downloads/` and local path
   `/storage/downloads/`. Use the actual path under `/storage` if your
   completed-download directory has a different name. The downloaders can keep
   their current paths and existing torrent locations.
4. Add the new library roots under `/storage`. Update the existing series and
   movies to their equivalent paths and decline the prompt to move files. The
   two paths to each library point to the same files on the host. After all
   items have been updated, remove the old root entries from the apps.
5. Update Seerr's Sonarr and Radarr request roots to the new paths if you
   use Seerr. Plex and Jellyfin can keep their current library paths,
   since their bind mounts still point to the same host directories.
6. Check a completed import through each downloader. For a torrent that still
   has its source file, compare its inode and the library file's inode on the
   host with `stat`. A matching device and inode confirms a hardlink.

> [!NOTE]
> Keep `INCOMPLETE_DOWNLOADS` on fast NVMe/SSD storage when `COMPLETED_DOWNLOADS` is on an HDD array.
> High-IOPS Usenet verification/unpacking and active torrent piece writes stay off the HDD, the download
> client performs one sequential move to `COMPLETED_DOWNLOADS` upon completion, and Sonarr/Radarr still
> hardlink or atomically move from `/storage/downloads` into `/storage/tv` and `/storage/movies`.

See the [Servarr Docker guide](https://wiki.servarr.com/docker-guide) for
filesystem and permissions requirements.

## prowlarr

[![](https://img.shields.io/static/v1?message=linuxserver/prowlarr&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/prowlarr)
[![](https://img.shields.io/static/v1?message=Prowlarr/Prowlarr&logo=github&label=github)](https://github.com/Prowlarr/Prowlarr)
[![](https://img.shields.io/static/v1?message=prowlarr.com&logo=google+chrome&label=website&color=teal)](https://prowlarr.com)

<img src="https://i.imgur.com/qOqJIRd.png" width="250" alt="Radarr Logo">

Prowlarr is an indexer manager/proxy built on the popular `*arr` .net/reactjs base stack
to integrate with your various PVR apps. Prowlarr supports management of both Torrent
Trackers and Usenet Indexers. It integrates seamlessly with Lidarr, Mylar3, Radarr, Readarr,
and Sonarr offering complete management of your indexers with no per app Indexer setup required

## bazarr

[![](https://img.shields.io/static/v1?message=linuxserver/bazarr&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/bazarr)
[![](https://img.shields.io/static/v1?message=morpheus65535/bazarr&logo=github&label=github)](https://github.com/morpheus65535/bazarr)
[![](https://img.shields.io/static/v1?message=bazarr.media&logo=google+chrome&label=website&color=teal)](https://www.bazarr.media)

Bazarr is a companion application to Sonarr and Radarr that manages and downloads subtitles based on your requirements.

### Configuration

In the Bazarr UI, connect to Sonarr (`http://sonarr:8989`) and Radarr (`http://radarr:7878`) using their API keys.
Bazarr mounts `/tv`, `/movies`, and `/storage` (when `MEDIA_ROOT` is configured) identically to Sonarr and Radarr so library paths align without extra path mappings.

## recyclarr

[![](https://img.shields.io/static/v1?message=ghcr.io/recyclarr/recyclarr&logo=docker&label=docker&color=blue)](https://github.com/recyclarr/recyclarr/pkgs/container/recyclarr)
[![](https://img.shields.io/static/v1?message=recyclarr/recyclarr&logo=github&label=github)](https://github.com/recyclarr/recyclarr)
[![](https://img.shields.io/static/v1?message=recyclarr.dev&logo=google+chrome&label=website&color=teal)](https://recyclarr.dev)

Recyclarr automatically synchronizes [TRaSH Guides](https://trash-guides.info/) custom formats, quality profiles, quality definitions, and naming schemes to Sonarr and Radarr on a schedule.

### Configuration

Recyclarr's configuration lives in `apps/recyclarr/recyclarr.yml` (mounted read-only into `/config/recyclarr.yml`) and uses `!env_var` references for `SONARR_API_KEY` and `RADARR_API_KEY` so API keys can stay encrypted in `.env.yaml`. It also manages TRaSH-recommended `media_naming` (`plex-tvdb` / `plex-tmdb`) and `media_management` (`propers_and_repacks: do_not_prefer`) so Proper/Repack upgrades are driven by Custom Format scores.

Because Recyclarr runs rootless (`PUID:PGID`, default `1000:1000`), create and chown its state directory before starting if it does not already exist:

```shell
mkdir -p appdata/recyclarr
sudo chown -R "${PUID:-1000}:${PGID:-1000}" appdata/recyclarr
```

Add `SONARR_API_KEY` and `RADARR_API_KEY` to `.env` (and re-encrypt with `make encrypt`), customize `apps/recyclarr/recyclarr.yml`, and preview or run a sync:

```shell
docker compose --file docker-compose.apps.yaml exec recyclarr recyclarr sync --preview
docker compose --file docker-compose.apps.yaml exec recyclarr recyclarr sync
```

## seerr

[![](https://img.shields.io/static/v1?message=ghcr.io/seerr-team/seerr&logo=docker&label=docker&color=blue)](https://github.com/seerr-team/seerr/pkgs/container/seerr)
[![](https://img.shields.io/static/v1?message=seerr-team/seerr&logo=github&label=github)](https://github.com/seerr-team/seerr)
[![](https://img.shields.io/static/v1?message=seerr.dev&logo=google+chrome&label=website&color=teal)](https://seerr.dev)

Seerr is the unified successor to Overseerr and Jellyseerr for managing requests for your media library. It integrates with Sonarr, Radarr, Plex, and Jellyfin.

> [!NOTE]
> Upgrading from Overseerr? See the [Overseerr to Seerr migration guide](../migrations.md#overseerr-to-seerr) before starting Seerr so your existing `appdata/overseerr` data and permissions carry over automatically.

## tautulli

[![](https://img.shields.io/static/v1?message=linuxserver/tautulli&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/tautulli)
[![](https://img.shields.io/static/v1?message=linuxserver/docker-tautulli&logo=github&label=github)](https://github.com/Tautulli/Tautulli)
[![](https://img.shields.io/static/v1?message=tautulli.com&logo=google+chrome&label=website&color=teal)](https://tautulli.com)

<img src="https://i.imgur.com/Wv8SVPi.png" width="250" alt="Tautulli Logo">

Tautulli is a 3rd party application that you can run alongside your Plex Media Server to monitor
activity and track various statistics. Most importantly, these statistics include what has been watched,
who watched it, when and where they watched it, and how it was watched. The only thing missing is
"why they watched it", but who am I to question your 42 plays of Frozen. All statistics are presented in
a nice and clean interface with many tables and graphs, which makes it easy to brag about your
server to everyone else.

## transmission

[![](https://img.shields.io/static/v1?message=haugene/transmission-openvpn&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/haugene/transmission-openvpn)
[![](https://img.shields.io/static/v1?message=haugene/docker-transmission-openvpn&logo=github&label=github)](https://github.com/haugene/docker-transmission-openvpn)

`transmission` . This service runs in a container with OpenVPN and Transmission with a configuration
where Transmission is running only when OpenVPN has an active tunnel. It has built-in support
for many popular VPN providers to make the setup easier.

## sabnzbd

[![](https://img.shields.io/static/v1?message=linuxserver/sabnzbd&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/sabnzbd)
[![](https://img.shields.io/static/v1?message=sabnzbd/sabnzbd&logo=github&label=github)](https://github.com/sabnzbd/sabnzbd)
[![](https://img.shields.io/static/v1?message=sabnzbd.org&logo=google+chrome&label=website&color=teal)](https://sabnzbd.org)

SABnzbd is an Open Source Binary Newsreader written in Python, it downloads files from Usenet
based on information given in nzb-files.

<img src="https://i.imgur.com/rt7Pbj9.png" width="220" alt="SABnzbd Logo">

### Configuration

Following [TRaSH Guides SABnzbd recommendations](https://trash-guides.info/Downloaders/SABnzbd/Basic-Setup/):

- Set **Temporary Download Folder** to `/incomplete-downloads` (NVMe/SSD) and **Completed Download Folder** to `/downloads` (HDD).
- Configure `movies` and `tv` categories pointing to `/downloads/movies` and `/downloads/tv` (or relative `movies` / `tv` under `/downloads`).
- Enable **Direct Unpack** and **Abort jobs that cannot be completed** under **Settings → Switches**.

## nzbhydra

[![](https://img.shields.io/static/v1?message=linuxserver/nzbhydra2&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/nzbhydra2)
[![](https://img.shields.io/static/v1?message=theotherp/nzbhydra2&logo=github&label=github)](https://github.com/theotherp/nzbhydra2)

<img src="https://i.imgur.com/1OGtKxA.png" width="300" alt="SABnzbd Logo">

NZBHydra 2 is a meta search for newznab indexers and torznab trackers.
It provides easy access to newznab indexers and many torznab trackers via Jackett.
You can search all your indexers and trackers from one place and use it as an indexer
source for tools like Sonarr, Radarr, Lidarr or CouchPotato.

### Configuration

The files at `appdata/sabnzbd/sabnzbd.ini` needs to be modified
to allow access from the internet and internally.

```text
host_whitelist = sabnzbd, sabnzbd.example.com
```

Once you're done, restart the container and in the UI see that the
completed downloads are mapped to `/downloads` and imcomplete downloads
are mapped to `/incomplete-downloads`

## heimdall

[![](https://img.shields.io/static/v1?message=linuxserver/heimdall&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/heimdall)
[![](https://img.shields.io/static/v1?message=linuxserver/heimdall&logo=github&label=github)](https://github.com/linuxserver/heimdall)
[![](https://img.shields.io/static/v1?message=heimdall.site&logo=google+chrome&label=website&color=teal)](https://www.heimdall.site)

<img src="https://i.imgur.com/iQrzXLK.png" width="220" alt="Heimdall Logo">

Heimdall is a way to organise all those links to your most used web sites and
web applications in a simple way. Simplicity is the key to Heimdall.
Why not use it as your browser start page? It even has the ability to
include a search bar using either Google, Bing or DuckDuckGo.

<img src="https://i.imgur.com/eCaSaLn.png" width="600" alt="Heimdall">

> [!NOTE]
> enter the full url path of the domain in new tabs
> for a redirect. (ie. `https://app.example.com`)

## readarr

[![](https://img.shields.io/static/v1?message=linuxserver/readarr&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/readarr)
[![](https://img.shields.io/static/v1?message=Readarr/Readarr&logo=github&label=github)](https://github.com/Readarr/Readarr)
[![](https://img.shields.io/static/v1?message=readarr.com&logo=google+chrome&label=website&color=teal)](https://readarr.com)

Readarr is an ebook and audiobook collection manager for Usenet and BitTorrent users. It can monitor multiple
RSS feeds for new books from your favorite authors and will grab, sort, and rename them.

<img src="https://i.imgur.com/C711M59.png" width="250" alt="Readarr Logo">

> [!NOTE] readarr is not enabled by default

## calibre

[![](https://img.shields.io/static/v1?message=linuxserver/calibre&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/calibre)
[![](https://img.shields.io/static/v1?message=kovidgoyal/calibre&logo=github&label=github)](https://github.com/kovidgoyal/calibre)
[![](https://img.shields.io/static/v1?message=calibre-ebook.com&logo=google+chrome&label=website&color=teal)](https://calibre-ebook.com)

<img src="https://i.imgur.com/OLnWJN5.png" width="250" alt="Calibre Logo">

> [!NOTE] calibre is not enabled by default

calibre is an e-book manager. It can view, convert, edit and catalog e-books in
all of the major e-book formats. It can also talk to e-book reader devices.
It can go out to the internet and fetch metadata for your books. It can download
newspapers and convert them into e-books for convenient reading.

## calibre-web

[![](https://img.shields.io/static/v1?message=linuxserver/calibre-web&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/calibre-web)
[![](https://img.shields.io/static/v1?message=janeczku/calibre-web&logo=github&label=github)](https://github.com/janeczku/calibre-web)

<img src="https://i.imgur.com/LVnUuXK.png" width="250" alt="Calibre Logo">

> [!NOTE] calibre-web is not enabled by default

Calibre-Web is a web app that offers a clean and intuitive interface for browsing, reading, and
downloading eBooks using a valid Calibre database.
