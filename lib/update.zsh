#! /usr/bin/env zsh

function +venv::update {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#+}} [VENV]...

Update all outdated python packages for provided venvs (names).

ARGS:
    <VENV>...    Name of the venv(s) you are willing to clean up.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function .venv::update {
  local opt_help
  zparseopts -D -F -K -- {h,-help}=opt_help

  (( $#opt_help )) && {+${0#.}; return 0}

  [[ ${#@} -eq 0 ]] && {echo "Err: No venvs provided."; return 1}

  local venv
  for venv in $@; do
    local retval=($(.venv::_get_venv_info --name "$venv"))
    local venv_path=$retval[3]
    [[ -d $venv_path ]] || {echo "Err: venv named '$venv' does not exist."; return 2}
    local python_binary=$venv_path/bin/python3
    local outdated_packages=($($python_binary -m pip list --outdated --format freeze | sed 's/==.*//'))
    [[ ${#outdated_packages} -eq 0 ]] && {echo "All up to date!"; return 0}
    
    local package
    for package in $outdated_packages; do
      $python_binary -m pip install -U $package
    done
  done
}
