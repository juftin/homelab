#!/usr/bin/env bash
#
# Tab-completed commands for jdc
# to enable tab-completion add the following to your .bashrc or .zshrc
# (make sure to set jdc_completion_path according to your machine)

# [[ -f "${HOME}/path/to/homelab/jdc/bin/_jdc_completion.sh" ]] && source "${HOME}/path/to/homelab/jdc/bin/_jdc_completion.sh"

_jdc() {
  if [[ $COMP_CWORD -gt 1 ]]; then
    return # only coplete to a depth of 1
  fi
  
  # Check if jdc exists
  if command -v jdc &>/dev/null; then
    local cur jdc_commands
    cur="${COMP_WORDS[COMP_CWORD]}"

    jdc_commands="$(jdc -l)"
    COMPREPLY=( $(compgen -W "$jdc_commands" -- "$cur") )
  fi
}

complete -F _jdc jdc