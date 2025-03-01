#!/bin/bash

info() {
  echo "$(date '+[%H:%M:%S]') INFO: $*"
}

REPO_ROOT=$(git rev-parse --show-toplevel)
ACME_FILE="${REPO_ROOT}/appdata/traefik/acme/acme.json"

mkdir -p "${REPO_ROOT}/appdata/traefik/acme/"

if [[ -f "$ACME_FILE" ]]; then
    read -p "acme.json already exists. Do you want to recreate it? [y/N]: " confirm
    confirm=${confirm,,}  # Convert to lowercase
    if [[ "$confirm" != "y" ]]; then
        info "Skipping file creation."
        exit 0
    fi
fi

rm -f "$ACME_FILE"
touch "$ACME_FILE"
chmod 600 "$ACME_FILE"

info "appdata/traefik/acme/acme.json created."
