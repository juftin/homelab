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

TRAEFIK_PROJECT="traefik"
MEDIA_CENTER_PROJECT="media-center"
MISCELLANEOUS_PROJECT="miscellaneous"

DOCKER_COMPOSE_FILE="docker-compose.yaml"
TRAEFIK_FILE="${PROJECT_ROOT_DIRECTORY}/${TRAEFIK_PROJECT}/${DOCKER_COMPOSE_FILE}"
MEDIA_CENTER_FILE="${PROJECT_ROOT_DIRECTORY}/${MEDIA_CENTER_PROJECT}/${DOCKER_COMPOSE_FILE}"
MISCELLANEOUS_FILE="${PROJECT_ROOT_DIRECTORY}/${MISCELLANEOUS_PROJECT}/${DOCKER_COMPOSE_FILE}"

function docker-compose-command() {
  PROJECT_NAME="${1}"
  FILE="${2}"
  shift 2
  docker-compose \
    --project-name "${PROJECT_NAME}" \
    --file "${FILE}" \
    --env-file "${PROJECT_ROOT_DIRECTORY}/.env" \
    ${@}
}

function docker-pull-stack() {
  PROJECT_NAME="${1}"
  FILE="${2}"
  shift 2
  docker-compose-command "${PROJECT_NAME}" "${FILE}" pull ${@}
}

function docker-build-stack() {
  PROJECT_NAME="${1}"
  FILE="${2}"
  shift 2
  docker-compose-command "${PROJECT_NAME}" "${FILE}" build ${@}
}

function docker-deploy-stack() {
  docker-compose-command "${1}" "${2}" up -d
}

function docker-destroy-stack() {
  docker-compose-command "${1}" "${2}" down
}

ARGUMENT_1="${1}"
ARGUMENT_2="${2}"
shift 2

if [[ "${ARGUMENT_1}" == "${TRAEFIK_PROJECT}" ]]; then
  PROJECT="${TRAEFIK_PROJECT}"
  FILE="${TRAEFIK_FILE}"
elif [[ "${ARGUMENT_1}" == "${MEDIA_CENTER_PROJECT}" ]]; then
  PROJECT="${MEDIA_CENTER_PROJECT}"
  FILE="${MEDIA_CENTER_FILE}"
elif [[ "${ARGUMENT_1}" == "${MISCELLANEOUS_PROJECT}" ]]; then
  PROJECT="${MISCELLANEOUS_PROJECT}"
  FILE="${MISCELLANEOUS_FILE}"
fi

if [[ "${ARGUMENT_2}" == "build" ]]; then
  log_event info "Preparing ${PROJECT} Services"
  docker-pull-stack "${PROJECT}" "${FILE}"
elif [[ "${ARGUMENT_2}" == "deploy" ]]; then
  log_event info "Deploying ${PROJECT} Services"
  docker-deploy-stack "${PROJECT}" "${FILE}"
elif [[ "${ARGUMENT_2}" == "destroy" ]]; then
  log_event info "Destroying ${PROJECT} Services"
  docker-destroy-stack "${PROJECT}" "${FILE}"
elif [[ "${ARGUMENT_2}" == "docker" ]]; then
  log_event info "Executing Docker Command"
  docker-compose-command "${PROJECT_NAME}" "${FILE}" ${@}
fi
