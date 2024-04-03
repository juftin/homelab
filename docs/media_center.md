# Media Center

Media and home server stack. This is s a docker-compose project built
around Plex, including schedulers/orchestrators for TV / Movie downloads,
an always behind VPN torrenting webserver, and a site for users to request
new downloads.

## Application Setup + Container Info

Most application set up and configuration is straightforward.
Please review the information of the various containers and applications.
Helpful descriptions, screenshots are available to assist in initial configuration.
Important links to the source code, documentation,
and more are available for review as well.

## Containers

-   [plex](#plex)
-   [sonarr](#sonarr)
-   [jackett](#jackett)
-   [radarr](#radarr)
-   [ombi](#ombi)
-   [heimdall](#heimdall)
-   [portainer](#portainer)
-   [tautulli](#tautulli)
-   [transmission](#transmission)
-   [watchtower](#watchtower)

### plex

[Docker Hub](https://hub.docker.com/r/linuxserver/plex/) \|\|
[GitHub](https://github.com/linuxserver/docker-plex) \|\|
[Website](https://plex.tv) \|\|
[Documentation](https://support.plex.tv/articles/)

<img src="../static/plex_logo.png" width="290" alt="Plex Logo">

Plex organizes video, music and photos from personal media libraries
and streams them to smart TVs, streaming boxes and mobile devices. This
container is packaged as a standalone Plex Media Server. Straightforward
design and bulk actions mean getting things done faster.

#### Configuration

Plex setup is fairly intuitive and straightforward. When setting up libraries you will
use the root directories, `/tv/` and `/movies/`

### sonarr

[Docker Hub](https://hub.docker.com/r/linuxserver/sonarr/) \|\|
[GitHub](https://github.com/linuxserver/docker-sonarr) \|\|
[Documentation](https://github.com/Sonarr/Sonarr/wiki)

<img src="../static/sonarr_logo.png" width="250" alt="Sonarr Logo">

Sonarr (formerly NZBdrone) is a PVR for usenet and bittorrent users.
It can monitor multiple RSS feeds for new episodes of your
favorite shows and will grab, sort and rename them. It can also be
configured to automatically upgrade the quality of files already
downloaded when a better quality format becomes available.

#### Configuration

For security, I like to set up a basic authorization form on the `General Settings` to
exclude non-admin users from accessing the application using the `ADMIN_USER` and
`ADMIN_PASSWORD` variables.

##### Download Client Configuration

<img src="../static/sonarr_download_client_config.png" width="600" alt="sonarr_download_client_config">

##### Indexer Client Configuration

<img src="../static/sonarr_indexer_config.png" width="600" alt="sonarr_indexer_config">

### jackett

[Docker Hub](https://hub.docker.com/r/linuxserver/jackett/) \|\|
[GitHub](https://github.com/linuxserver/docker-jackett) |\|
[Documentation](https://github.com/Jackett/Jackett/wiki)

<img src="../static/jackett_logo.png" width="200" alt="Jackett Logo">

Jackett works as a proxy server: it translates queries from apps
(Sonarr, SickRage, CouchPotato, Mylar, etc) into tracker-site-specific
http queries, parses the html response, then sends results back to the
requesting software. This allows for getting recent uploads (like RSS)
and performing searches. Jackett is a single repository of maintained
indexer scraping & translation logic - removing the burden from other apps.

#### Configuration

Jackett's configuration is fairly simple. The API Key is fisplayed in the
top right of the page. To track a new indexer, click `+Add Indexer` and search for
it by name. These entries will be added as TORZNAB feeds on applications like
Sonarr and Radarr.

<img src="../static/jackett_add_indexer.png" width="500" alt="jackett_add_indexer">

#### Recommended Indexers

-   TV

    -   The Pirate Bay
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/thepiratebay/results/torznab/
        -   Categories: 5000,5040,5050,100208,100205
    -   1337x
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/1337x/results/torznab/
        -   Categories: 5000,5030,5040,5070,5080,100074,100006,100009,100004,100041,100071,100075,100007
    -   RARBG
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/thepiratebay/results/torznab/
        -   Categories: 5030,5030,5040,5045,100018,100041,100049
    -   kickasstorrents
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/thepiratebay/results/torznab/
        -   Categories: 5000,5070,5080,103583

-   Movies
    -   The Pirate Bay
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/thepiratebay/results/torznab/
        -   Categories: 2000,2020,2040,2060,100207,100505,100201,100202,100501,100502
    -   1337x
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/1337x/results/torznab/
        -   Categories: 2000,2010,2030,2040,2045,2060,2070,100066,100073,100002,100004,100001,100054,100042,100070,100055,100003,100076
    -   RARBG
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/thepiratebay/results/torznab/
        -   Categories: 2000,2030,2040,2045,2050,2060,100046,100042,100049,100017,100044,100047,100050,100045,100054,100051,100014,100048,100052
    -   kickasstorrents
        -   Endpoint: http://jackett:9117/api/v2.0/indexers/thepiratebay/results/torznab/
        -   Categories: 2000,112696,105134

> [!NOTE]
> Jackett's default endpoint will be populated with your custom domain, it can be contacted
> internally at http://jackett:9117
>
> Make sure to pay close attention to the category codes relating to your particular download type.

### radarr

[Docker Hub](https://hub.docker.com/r/linuxserver/radarr/) \|\|
[GitHub](https://github.com/linuxserver/docker-radarr) \|\|
[Documentation](https://github.com/Radarr/Radarr/wiki)

<img src="../static/radarr_logo.png" width="250" alt="Radarr Logo">

Radarr is an independent fork of Sonarr reworked for automatically
downloading movies via Usenet and BitTorrent.

#### Configuration

See the [jackett](#jackett) and [sonarr](#sonarr) sections for more detailed
instructions around setting up Indexers and Download clients with radarr. For
security, I like to set up a basic authorization form on the `General Settings` to
exclude non-admin users from accessing the application using the `ADMIN_USER` and
`ADMIN_PASSWORD` variables.

### ombi

[Docker Hub](https://hub.docker.com/r/linuxserver/ombi/) \|\|
[GitHub](https://github.com/linuxserver/docker-ombi) \|\|
[Website](https://ombi.io/) \|\|
[Documentation](https://github.com/tidusjar/Ombi/wiki)

<img src="../static/ombi_logo.png" width="300" alt="ombi_logo">

Ombi allows you to host your own Plex Request and user management system.
If you are sharing your Plex server with other users, allow
them to request new content using an easy to manage interface!
Manage all your requests for Movies and TV with ease, leave notes
for the user and get notification when a user requests something.
Allow your users to post issues against their requests so you know there
is a problem with the audio etc. Even automatically send them weekly newsletters
of new content that has been added to your Plex server!

#### Configuration

Ombi has a few different notification settings, personally I use its
Pushover (push notifications) and email integrations to notify users.
Please refer to the documentation link for further details.

##### Media Server (Plex) Config

<img src="../static/ombi_plex_config.png" width="600" alt="ombi_plex_config">

##### TV (Sonarr) Config

<img src="../static/ombi_sonarr_config.png" width="600" alt="ombi_sonarr_config">

##### Movies (Radarr) Config

<img src="../static/ombi_radarr_config.png" width="600" alt="ombi_radarr_config">

### heimdall

[Docker Hub](https://hub.docker.com/r/linuxserver/heimdall/) \|\|
[GitHub](https://github.com/linuxserver/docker-heimdall) \|\|
[Website](https://www.heimdall.site)

<img src="../static/heimdall_logo.svg" width="220" alt="Heimdall Logo">

Heimdall is a way to organise all those links to your most used web sites and
web applications in a simple way. Simplicity is the key to Heimdall.
Why not use it as your browser start page? It even has the ability to
include a search bar using either Google, Bing or DuckDuckGo.

<img src="../static/heimdall.png" width="600" alt="Heimdall">

> [!NOTE]
> enter the full url path of the domain in new tabs
> for a redirect. (ie. `https://app.example.com`)

### portainer

[Docker Hub](https://hub.docker.com/r/portainer/portainer/) \|\|
[GitHub](https://github.com/portainer/portainer) \|\|
[Website](https://www.portainer.io/) \|\|
[Documentation](https://portainer.readthedocs.io/en/stable/)

<img src="../static/portainer_logo.png" width="250" alt="Portainer Logo">

Portainer is a lightweight management UI which allows you to
easily manage your different Docker environments (Docker hosts or Swarm clusters).
Portainer is meant to be as simple to deploy as it is to use. It consists of
a single container that can run on any Docker engine (can be deployed as
Linux container or a Windows native container, supports other platforms too).
Portainer allows you to manage all your Docker resources (containers, images, volumes,
networks and more) ! It is compatible with the standalone Docker engine and
with Docker Swarm mode.

#### Configuration

The administration password is set using the `ADMIN_HTPASSWD` on the [`.env` file](../example.env).
By default the username is `admin`. I prefer to create a new admin user using both `ADMIN_USER` and
`ADMIN_PASSWORD` variables.

### tautulli

[Docker Hub](https://hub.docker.com/r/linuxserver/tautulli/) \|\|
[GitHub](https://github.com/linuxserver/docker-tautulli) \|\|
[Website](https://tautulli.com/)

<img src="../static/tautulli_logo.png" width="250" alt="tautulli Logo">

Tautulli is a 3rd party application that you can run alongside
your Plex Media Server to monitor activity and track various statistics.
Most importantly, these statistics include what has been watched,
who watched it, when and where they watched it, and how it was watched.
The only thing missing is "why they watched it", but who am I to question
your 42 plays of Frozen. All statistics are presented in a nice and clean
interface with many tables and graphs, which makes it easy to brag about
your server to everyone else.

#### Configuration

Tautulli configuration is simple, and automated upon first launch of the
application.

### transmission

[Docker Hub](https://hub.docker.com/r/haugene/transmission-openvpn) \|\|
[GitHub](https://github.com/haugene/docker-transmission-openvpn)

<img src="../static/transmission_logo.png" width="250" alt="traefik Logo">

This container contains OpenVPN and Transmission with a configuration
where Transmission is running only when OpenVPN has an active tunnel.
It bundles configuration files for many popular VPN providers to
make the setup easier.

> [!NOTE]
> Currently, transmission is available to any user whitelisted by Google OAuth.
> There should be future work to add an extra layer of protection.
>
> This container has a health check that pings google.com with data
> to verify a stable connection. Trafficker takes roughly
> 5 minutes to recognize this container as healthy before making it available.
>
> As a sanity check I like to use the torrent magnet
> IP tool at <https://ipleak.net> to verfiy a stable VPN connection.
