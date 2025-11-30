#!/usr/bin/env bash

set -Eeuo pipefail
trap 'echo "[ERROR] Script failed at line $LINENO"; exit 1' ERR

: "${LITELLM_MASTER_KEY:?LITELLM_MASTER_KEY is required}"
: "${LITELLM_OPEN_WEBUI_KEY:?LITELLM_OPEN_WEBUI_KEY is required}"

LITELLM_HOST="${LITELLM_HOST:-litellm}"
READINESS_URL="http://${LITELLM_HOST}:4001/health/readiness"
API_BASE="http://${LITELLM_HOST}:4000"

MAX_ATTEMPTS=30
SLEEP_SECONDS=2

# --- Wait for DNS ---
attempt=1
while (( attempt <= MAX_ATTEMPTS )); do
    if getent hosts "$LITELLM_HOST" >/dev/null 2>&1; then
        echo "[INFO] Host '$LITELLM_HOST' resolved. Proceeding to readiness check."
        break
    fi
    echo "[INFO] Waiting for DNS resolution of '$LITELLM_HOST' (attempt $attempt/$MAX_ATTEMPTS)..."
    sleep "$SLEEP_SECONDS"
    ((attempt++))
done
if (( attempt > MAX_ATTEMPTS )); then
    echo "[ERROR] Host '$LITELLM_HOST' could not be resolved in time."
    exit 1
fi

# --- Wait for Readiness ---
attempt=1
while (( attempt <= MAX_ATTEMPTS )); do
    if response="$(curl -sSf --max-time 5 "$READINESS_URL" 2>/dev/null)" && [[ $response == *"healthy"* ]]; then
        echo "[INFO] litellm health endpoint is healthy."
        break
    fi
    echo "[INFO] Waiting for litellm readiness (attempt $attempt/$MAX_ATTEMPTS)..."
    sleep "$SLEEP_SECONDS"
    ((attempt++))
done
if (( attempt > MAX_ATTEMPTS )); then
    echo "[ERROR] litellm did not become healthy in time."
    exit 1
fi

# --- Wait for API ---
attempt=1
while (( attempt <= MAX_ATTEMPTS )); do
    if curl -sSf --max-time 5 "${API_BASE}/team/list" -H "x-litellm-api-key: ${LITELLM_MASTER_KEY}" >/dev/null 2>&1; then
        echo "[INFO] litellm API is up and responding."
        break
    fi
    echo "[INFO] Waiting for litellm API to accept requests (attempt $attempt/$MAX_ATTEMPTS)..."
    sleep "$SLEEP_SECONDS"
    ((attempt++))
done
if (( attempt > MAX_ATTEMPTS )); then
    echo "[ERROR] litellm API (port 4000) did not become ready in time."
    exit 1
fi

# --- Make API Requests ---
request() {
  local method=$1 endpoint=$2 data=${3:-}
  local -a curl_args=(
    -sSfL
    -X "$method"
    -H "Content-Type: application/json"
    -H "Accept: application/json"
    -H "x-litellm-api-key: $LITELLM_MASTER_KEY"
    --max-time 10
  )
  [[ -n $data ]] && curl_args+=(-d "$data")
  curl_args+=("${API_BASE}${endpoint}")
  curl "${curl_args[@]}"
}

# --- Check for Existing Team ---
AVAILABLE_TEAMS_JSON="$(request GET /team/list || true)"

if ! echo "$AVAILABLE_TEAMS_JSON" | jq empty >/dev/null 2>&1; then
    echo "[ERROR] Invalid JSON received from /team/list"
    exit 1
fi


CHAT_APP="openwebui"
if echo "$AVAILABLE_TEAMS_JSON" | jq -e --arg name "$CHAT_APP" '.[] | select(.team_alias==$name)' >/dev/null; then
    echo "[INFO] Team '$CHAT_APP' already exists. Skipping creation."
else
    # --- Create Team if Not Exists ---
    TEAM_DATA=$(jq -n --arg alias "$CHAT_APP" '{team_alias:$alias}')
    TEAM_RESPONSE="$(request POST /team/new "$TEAM_DATA")"
    if ! echo "$TEAM_RESPONSE" | jq empty >/dev/null 2>&1; then
        echo "[ERROR] Invalid JSON returned from /team/new"
        exit 1
    fi
    TEAM_ID="$(echo "$TEAM_RESPONSE" | jq -er '.team_id')"
    # --- Generate API Key for Team ---
    API_KEY_DATA=$(jq -n \
      --arg team_id "$TEAM_ID" \
      --arg alias "$CHAT_APP" \
      --arg key "$LITELLM_OPEN_WEBUI_KEY" \
      '{team_id:$team_id, key_alias:$alias, key:$key}')
    request POST /key/service-account/generate "$API_KEY_DATA" >/dev/null
    echo "[INFO] Team '$CHAT_APP' created and API key generated."
fi
