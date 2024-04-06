# Media Stack

## Table of Contents

-   [plex](#plex)
-   [sonarr](#sonarr)
-   [radarr](#radarr)
-   [prowlarr](#prowlarr)
-   [ombi](#ombi)
-   [tautulli](#tautulli)
-   [transmission](#transmission)
-   [sabnzbd](#sabnzbd)
-   [heimdall](#heimdall)
-   [readarr](#readarr)
-   [calibre](#calibre)
-   [calibre-web](#calibre-web)

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

## prowlarr

[![](https://img.shields.io/static/v1?message=linuxserver/prowlarr&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/prowlarr)
[![](https://img.shields.io/static/v1?message=Prowlarr/Prowlarr&logo=github&label=github)](https://github.com/Prowlarr/Prowlarr)
[![](https://img.shields.io/static/v1?message=prowlarr.com&logo=google+chrome&label=website&color=teal)](https://prowlarr.com)

<img src="https://i.imgur.com/qOqJIRd.png" width="250" alt="Radarr Logo">

Prowlarr is an indexer manager/proxy built on the popular `*arr` .net/reactjs base stack
to integrate with your various PVR apps. Prowlarr supports management of both Torrent
Trackers and Usenet Indexers. It integrates seamlessly with Lidarr, Mylar3, Radarr, Readarr,
and Sonarr offering complete management of your indexers with no per app Indexer setup required

## ombi

[![](https://img.shields.io/static/v1?message=linuxserver/ombi&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/ombi)
[![](https://img.shields.io/static/v1?message=Ombi-app/Ombi&logo=github&label=github)](https://github.com/Ombi-app/Ombi)
[![](https://img.shields.io/static/v1?message=ombi.io&logo=google+chrome&label=website&color=teal)](https://ombi.io)

<img src="https://i.imgur.com/AD78HMw.png" width="300" alt="ombi_logo">

Ombi is your friendly media request tool, automatically syncs with your media servers (Sonarr, Radarr). It's
dead simple to use and is a nice way for your friends to request media and have it automatically added to your
Plex server.

### Configuration

Ombi has a few different notification settings, personally I use its
Pushover (push notifications) and email integrations to notify users.
Please refer to the documentation link for further details.

#### Media Server (Plex) Config

<img src="https://i.imgur.com/hvOGexA.png" width="600" alt="ombi_plex_config">

#### TV (Sonarr) Config

<img src="https://i.imgur.com/bgx2tKl.png" width="600" alt="ombi_sonarr_config">

#### Movies (Radarr) Config

<img src="https://i.imgur.com/fdr3HK4.png" width="600" alt="ombi_radarr_config">

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

The files at `appdata/media/sabnzbd/sabnzbd.ini` needs to be modified
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
