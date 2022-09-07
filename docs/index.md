# Homelab

Media and home server stack. It's a docker-compose project built around Plex, including schedulers/orchestrators for TV
/ Movie downloads, an always behind VPN torrenting webserver, and a site for users to request new downloads. SSL and a
GoogleOAuth whitelist are built in as well.


## Installation

Clone the repo locally

```shell
git clone https://github.com/juftin/homelab.git
cd homelab
```

Install the accompanying Python CLI

```shell
pipx install git+https://github.com/juftin/homelab.git@main
```

or

```shell
pipx install ../homelab/
```

## Command Line Usage

### backup

```shell
sudo homelab.py --debug \
    backup all \
    /media/storage_128/backup/homelab/ \
    --cleanup --num-backups 1 \
    --additional /media/nas/documents/backup/homelab/ \
    --additional-cleanup --additional-num-backups 3
```
