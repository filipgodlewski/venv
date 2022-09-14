#! /usr/bin/env zsh

function _venv::auto::help {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help}

Automatically de/activate venv based on the dir you cd into.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function _venv::auto {
  trap "unset help" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -F -K -- {h,-help}=help || return

  (( $#help )) && {$0::help; return 0}

  local retval=($(_venv::_get_venv_info))
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ $VIRTUAL_ENV == $venv_path ]] && return 0
  deactivate 2> /dev/null
  [[ $is_linked == true ]] && source $venv_path/bin/activate
}
