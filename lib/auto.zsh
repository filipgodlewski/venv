#! /usr/bin/env zsh

function .venv::auto {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#+}}

Automatically de/activate venv based on the dir you cd into.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function .venv::auto {
  local opt_help
  zparseopts -D -F -K -- {h,-help}=opt_help

  (( $#opt_help )) && {+${0#.}; return 0}

  local retval=($(.venv::_get_venv_info))
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ $VIRTUAL_ENV == $venv_path ]] && return 0
  deactivate 2> /dev/null
  [[ $is_linked == true ]] && source $venv_path/bin/activate
  return 0
}
