#! /usr/bin/env zsh

function +venv::delete {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [options] [VENV]...

Delete venv(s).

ARGS:
    <VENV>...    Name of the venv(s) you are willing to delete.

OPTIONS:
    -f, --force                       Force deletion in case venv is linked
                                      to multiple projects.
    -h, --help                        Show this message.
EOF
  return 0
}
function .venv::delete {
  local opt_help opt_force
  zparseopts -D -F -K -- {h,-help}=opt_help {f,-force}=opt_force

  (( $#opt_help )) && {+${0#.}; return 0}

  zmodload zsh/mapfile
  (( ${#@} == 0 )) && {echo "Err: No venvs provided."; return 1}

  local venv
  for venv in $@; do
    local retval=($(.venv::_get_venv_info --name "$venv"))
    local venv_path=$retval[3]
    [[ -d $venv_path ]] || {echo "Err: venv named '$venv' does not exist."; return 2}
    local lines=("${(f@)${mapfile[$venv_path/.venv_paths]%$'\n'}}")
    if (( ${#lines:#} > 1 && $#opt_force )); then
      echo "Err: The venv you want to delete is used by more than 1 project:"
      echo ${(F@)lines:#}
      echo
      echo "Run again with '--force' flag if you're totally sure you want to delete this venv."
      return 3
    fi

    [[ $VIRTUAL_ENV == $venv_path ]] && deactivate
    rm -rf $venv_path
    echo "Info: Deleted venv named '$venv' which was stored under '$venv_path'"
  done
}
