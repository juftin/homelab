#!/usr/bin/env bash
#
# Tab-completed commands for jdc
# to enable tab-completion add the following to your .bashrc or .zshrc
# (make sure to set jdc_completion_path according to your machine)

# [[ -f "${HOME}/path/to/homelab/jdc/bin/_jdc_completion.sh" ]] && source "${HOME}/path/to/homelab/jdc/bin/_jdc_completion.sh"


# developer testing:
# source ./jdc/bin/_jdc_completion.sh && COMP_WORDS=("jdc" "setup") COMP_CWORD=2 _jdc; echo "COMPREPLY: ${COMPREPLY[*]}"


_jdc() {
  local cur prev
  
  # Set up the completion variables manually
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  
  # echo "DEBUG: cur='$cur' prev='$prev' COMP_CWORD=$COMP_CWORD COMP_WORDS=${COMP_WORDS[*]}"
  # echo "DEBUG: COMP_WORDS[0]=${COMP_WORDS[0]} COMP_WORDS[1]=${COMP_WORDS[1]}"
  
  # First level completion - jdc commands
  if [[ $COMP_CWORD -eq 1 ]]; then
    # echo "DEBUG: Completing first level commands"
    COMPREPLY=( $(compgen -W "$(jdc -l)" -- "$cur") )
    # echo "DEBUG: COMPREPLY=${COMPREPLY[*]}"
    return 0
  fi
  
  # Second level completion - setup commands
  if [[ $COMP_CWORD -eq 2 && "${COMP_WORDS[1]}" == "setup" ]]; then
    # echo "DEBUG: Completing setup commands"
    # local setup_commands="init-acme setup-ufw copy-env check-env check-space all"
    # local setup_commands="jdc setup -l"
    COMPREPLY=( $(compgen -W "$(jdc setup -l)" -- "$cur") )
    # echo "DEBUG: COMPREPLY=${COMPREPLY[*]}"
    return 0
  fi

  local container_commands="up down logs stop restart config pull update remove get-ip"
  if [[ $COMP_CWORD -eq 2 && " $container_commands " =~ " ${COMP_WORDS[1]} " ]]; then
    COMPREPLY=( $(compgen -W "$(jdc containers)" -- "$cur") )
    return 0
  fi
  
  return 0
}

complete -F _jdc jdc