#!/usr/bin/env bash
#
# setup.sh - A command-line tool to manage homelab setup tasks.
#
# Usage:
#   jdc setup <command> [options]
#
# Commands:
#   traefik-acme  - Initialize Traefik ACME configuration
#   ufw-setup     - Configure UFW firewall rules
#   ufw-remove    - Remove UFW firewall rules configured by ufw-setup
#   copy-env      - Copy .env-example to .env if it doesn't exist
#   check-env     - Validate the .env file
#   check-space   - Check free space on MEDIA_DIRECTORY
#
# Options:
#   -y, --yes                 Automatically answer yes to all prompts
#   --args "<extra arguments>"  Additional arguments for the command
#   -h, --help                Show usage information
#   -l, --list-commands       List available commands
#

set -euo pipefail

# ------------------------------------------------------------------------------
# Global Constants & Logging
# ------------------------------------------------------------------------------

REPO_ROOT=$(git rev-parse --show-toplevel)
AUTO_YES=0

info() {
  echo "$(date '+[%H:%M:%S]') INFO: $*"
}

warn() {
  echo "$(date '+[%H:%M:%S]') WARN: $*" >&2
}

error() {
  echo "$(date '+[%H:%M:%S]') ERROR: $*" >&2
  exit 1
}

confirm() {
  local message="$1"
  local default="${2:-n}"
  
  if [[ $AUTO_YES -eq 1 ]]; then
    return 0
  fi
  
  local prompt
  if [[ "$default" == "y" ]]; then
    prompt="$message [Y/n]: "
  else
    prompt="$message [y/N]: "
  fi
  
  read -r -p "$prompt" response
  response=${response,,}  # Convert to lowercase
  
  if [[ -z "$response" ]]; then
    response=$default
  fi
  
  if [[ "$response" =~ ^(yes|y)$ ]]; then
    return 0
  else
    return 1
  fi
}

# ------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------

list_commands() {
  local commands=(
    "traefik-acme"
    "ufw-setup"
    "ufw-remove"
    "copy-env"
    "check-env"
    "check-space"
    "all"
  )
  echo "${commands[*]}"
  exit 0
}

# ------------------------------------------------------------------------------
# Usage Function
# ------------------------------------------------------------------------------

usage() {
  cat <<EOF
Usage:
  jdc setup <command> [options]

Commands:
  traefik-acme     Initialize Traefik ACME configuration
  ufw-setup     Configure UFW firewall rules
  ufw-remove    Remove UFW firewall rules configured by ufw-setup
  copy-env      Copy .env-example to .env if it doesn't exist
  check-env     Validate the .env file
  check-space   Check free space on MEDIA_DIRECTORY
  all           Run all setup tasks in sequence

Options:
  -y, --yes                 Automatically answer yes to all prompts
  --args "<extra arguments>"  Additional arguments for the command
  -h, --help                Show usage information
  -l, --list-commands       List available commands

Examples:
  jdc setup traefik-acme
  jdc setup ufw-setup -y
  jdc setup ufw-remove
  jdc setup copy-env
  jdc setup check-env
  jdc setup check-space
  jdc setup all -y
EOF
}

# ------------------------------------------------------------------------------
# Command Functions
# ------------------------------------------------------------------------------

cmd_init_acme() {
  info "Initializing Traefik ACME configuration..."
  
  if ! confirm "This will initialize the Traefik ACME configuration. Continue?"; then
    info "Operation cancelled."
    return
  fi
  
  "$REPO_ROOT/jdc/scripts/initialise-traefik-acme.sh" "${ARGS[@]}"
}

cmd_ufw_setup() {
  info "Setting up UFW firewall rules..."
  
  if ! confirm "This will configure UFW firewall rules. This may temporarily disrupt network connectivity. Continue?"; then
    info "Operation cancelled."
    return
  fi
  
  "$REPO_ROOT/jdc/scripts/ufw_rules_setup.sh" "${ARGS[@]}"
}

cmd_ufw_remove() {
  info "Setting up UFW firewall rules..."
  
  if ! confirm "This will remove configured UFW firewall rules. This may temporarily disrupt network connectivity. Continue?"; then
    info "Operation cancelled."
    return
  fi
  
  "$REPO_ROOT/jdc/scripts/ufw_rules_remove.sh" "${ARGS[@]}"
}

cmd_copy_env() {
  info "Checking for .env file..."
  
  if [[ -f "$REPO_ROOT/.env" ]]; then
    info ".env file already exists."
    if ! confirm "Do you want to overwrite the existing .env file?"; then
      info "Operation cancelled."
      return
    fi
  fi
  
  info "Copying .env-example to .env..."
  cp "$REPO_ROOT/.env-example" "$REPO_ROOT/.env"
  info "Done. Please edit .env to customize your configuration."
}

cmd_check_env() {
  info "Validating .env file..."
  
  if [[ ! -f "$REPO_ROOT/.env" ]]; then
    error ".env file not found. Run 'jdc setup copy-env' first."
  fi
  
  # Source the .env file
  # shellcheck disable=SC1090
  source "$REPO_ROOT/.env"
  
  # Check required variables
  local required_vars=(
    "DOMAIN_NAME"
    "ADMIN_USER"
    "TZ"
    "PUID"
    "PGID"
    "UNIVERSAL_RESTART_POLICY"
    "MEDIA_DIRECTORY"
    "DOCKER_DIRECTORY"
  )
  
  local missing_vars=()
  for var in "${required_vars[@]}"; do
    if [[ -z "${!var:-}" ]]; then
      missing_vars+=("$var")
    fi
  done
  
  if [[ ${#missing_vars[@]} -gt 0 ]]; then
    error "Missing required variables in .env: ${missing_vars[*]}"
  fi
  
  # Check if directories exist
  if [[ ! -d "$MEDIA_DIRECTORY" ]]; then
    warn "MEDIA_DIRECTORY ($MEDIA_DIRECTORY) does not exist or is not accessible."
  fi
  
  if [[ ! -d "$DOCKER_DIRECTORY" ]]; then
    warn "DOCKER_DIRECTORY ($DOCKER_DIRECTORY) does not exist or is not accessible."
  fi
  
  info ".env validation completed successfully."
}

cmd_check_space() {
  info "Checking free space on MEDIA_DIRECTORY..."
  
  if [[ ! -f "$REPO_ROOT/.env" ]]; then
    error ".env file not found. Run 'jdc setup copy-env' first."
  fi
  
  # Source the .env file
  # shellcheck disable=SC1090
  source "$REPO_ROOT/.env"
  
  if [[ -z "${MEDIA_DIRECTORY:-}" ]]; then
    error "MEDIA_DIRECTORY not defined in .env file."
  fi
  
  if [[ ! -d "$MEDIA_DIRECTORY" ]]; then
    error "MEDIA_DIRECTORY ($MEDIA_DIRECTORY) does not exist or is not accessible."
  fi
  
  # Get disk usage information
  local disk_info
  disk_info=$(df -h "$MEDIA_DIRECTORY" | tail -n 1)
  
  local size
  local used
  local avail
  local use_percent
  local mount_point
  
  # Parse the output
  read -r _ size used avail use_percent mount_point <<< "$disk_info"
  
  info "Disk space information for $MEDIA_DIRECTORY (mounted at $mount_point):"
  info "Total size: $size"
  info "Used: $used ($use_percent)"
  info "Available: $avail"
  
  # Check if available space is less than 10GB (approximate)
  local avail_bytes
  if [[ "$avail" == *G* ]]; then
    avail_bytes=$(echo "$avail" | sed 's/G//')
    if (( $(echo "$avail_bytes < 10" | bc -l) )); then
      warn "Low disk space: Less than 10GB available on $MEDIA_DIRECTORY."
    fi
  elif [[ "$avail" == *M* || "$avail" == *K* ]]; then
    warn "Very low disk space on $MEDIA_DIRECTORY: $avail"
  fi
}

cmd_all() {
  info "Running all setup tasks..."
  
  cmd_copy_env
  cmd_check_env
  cmd_check_space
  cmd_init_acme
  cmd_ufw_setup
  
  info "All setup tasks completed."
}

# ------------------------------------------------------------------------------
# Argument Parsing & Command Dispatching
# ------------------------------------------------------------------------------

# Global variables for options and arguments
ARGS=()      # Array to hold extra arguments
COMMAND=""

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      init-acme|ufw-setup|ufw-remove|copy-env|check-env|check-space|all)
        if [[ -n "$COMMAND" ]]; then
          error "Multiple commands specified: '$COMMAND' and '$1'"
        fi
        COMMAND="$1"
        shift
        ;;
      -y|--yes)
        AUTO_YES=1
        shift
        ;;
      --args)
        if [[ $# -lt 2 ]]; then
          error "--args requires a value"
        fi
        # Convert the provided string into an array
        read -r -a ARGS <<< "$2"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      -l|--list-commands)
        list_commands
        exit 0
        ;;
      *)
        ARGS+=("$1")
        shift
        ;;
    esac
  done

  if [[ -z "$COMMAND" ]]; then
    usage
    exit 1
  fi
}

main() {
  if [[ "$#" -eq 0 ]]; then
    usage
    exit 1
  fi

  parse_args "$@"

  case "$COMMAND" in
    traefik-acme) cmd_init_acme ;;
    ufw-setup) cmd_ufw_setup ;;
    ufw-remove) cmd_ufw_remove ;;
    copy-env) cmd_copy_env ;;
    check-env) cmd_check_env ;;
    check-space) cmd_check_space ;;
    *) error "Unknown command '$COMMAND'" ;;
  esac
}

main "$@" 