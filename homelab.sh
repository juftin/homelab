#!/usr/bin/env bash

set -e

function log_event() {
  LOGGING_TIMESTAMP=$(date +"%F %T,000")
  if [[ ${1} == "info" ]]; then
    echo "${LOGGING_TIMESTAMP} [    INFO]: ${2}"
  elif [[ ${1} == "error" ]]; then
    echo "${LOGGING_TIMESTAMP} [   ERROR]: ${2}"
  elif [[ ${2} == "" ]]; then
    echo "${LOGGING_TIMESTAMP} [    INFO]: ${1}"
  else
    echo "${LOGGING_TIMESTAMP} [   ${1}]: ${2}"
  fi
}

PROJECT_ROOT_DIRECTORY="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

TRAEFIK_FILE="${PROJECT_ROOT_DIRECTORY}/traefik/docker-compose.yaml"
MEDIA_CENTER_FILE="${PROJECT_ROOT_DIRECTORY}/media-center/docker-compose.yaml"
MISCELLANEOUS_FILE="${PROJECT_ROOT_DIRECTORY}/miscellaneous/docker-compose.yaml"

ARGUMENT_1="${1}"
ARGUMENT_2="${2}"

function docker-pull-stack {
  docker-compose \
    --file "${1}" \
    --env-file "${PROJECT_ROOT_DIRECTORY}/.env" \
    pull ${2}
}

function docker-build-stack {
  docker-compose \
    --file "${1}" \
    --env-file "${PROJECT_ROOT_DIRECTORY}/.env" \
    build ${2}
}

function docker-deploy-stack {
  docker-compose \
    --file "${1}" \
    --env-file "${PROJECT_ROOT_DIRECTORY}/.env" \
    up -d
}

function docker-destroy-stack {
  docker-compose \
    --file "${1}" \
    --env-file "${PROJECT_ROOT_DIRECTORY}/.env" \
    down
}

if [[ "${ARGUMENT_1}" == "traefik" ]]; then
  if [[ "${ARGUMENT_2}" == "build" ]]; then
    log_event info "Preparing Traefik and Proxy Services"
    docker-pull-stack "${TRAEFIK_FILE}"
  elif [[ "${ARGUMENT_2}" == "deploy" ]]; then
    log_event info "Deploying Traefik and Proxy Services"
    docker-deploy-stack "${TRAEFIK_FILE}"
  elif [[ "${ARGUMENT_2}" == "destroy" ]]; then
    log_event info "Destroying Traefik and Proxy Services"
    docker-destroy-stack "${TRAEFIK_FILE}"
  fi
elif [[ "${ARGUMENT_1}" == "media-center" ]]; then
  if [[ "${ARGUMENT_2}" == "build" ]]; then
    log_event info "Preparing Media Center Services"
    docker-pull-stack "${MEDIA_CENTER_FILE}"
  elif [[ "${ARGUMENT_2}" == "deploy" ]]; then
    log_event info "Deploying Media Center Services"
    docker-deploy-stack "${MEDIA_CENTER_FILE}"
  elif [[ "${ARGUMENT_2}" == "destroy" ]]; then
    log_event info "Destroying Media Center Services"
    docker-destroy-stack "${MEDIA_CENTER_FILE}"
  fi
elif [[ "${ARGUMENT_1}" == "miscellaneous" ]]; then
  if [[ "${ARGUMENT_2}" == "build" ]]; then
    log_event info "Preparing Miscellaneous Services"
    docker-pull-stack "${MISCELLANEOUS_FILE}"
  elif [[ "${ARGUMENT_2}" == "deploy" ]]; then
    log_event info "Deploying Miscellaneous Services"
    docker-deploy-stack "${MISCELLANEOUS_FILE}"
  elif [[ "${ARGUMENT_2}" == "destroy" ]]; then
    log_event info "Destroying Miscellaneous Services"
    docker-destroy-stack "${MISCELLANEOUS_FILE}"
  fi
fi
