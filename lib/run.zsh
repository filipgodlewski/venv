#! /usr/bin/env zsh

function _venv::run::help {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [options] <COMMAND>

Run command inside a specified venv, like if it was active.

OPTIONS:
    -n, --name <name>                 Venv name.
    -h, --help                        Show this message.

COMMAND:
    The typical body of a command.
    Examples:
        venv run -V  <-- Will output python3 version for currently active venv.
        venv run -n venv -m pip list  <-- Will list python packages for venv
          called 'venv'.
        venv run --name rambo my_script.py  <-- will run my_script.py inside
          venv called 'rambo'.
EOF
  return 0
}
function _venv::run {
  trap "unset help name" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -E -K -- {h,-help}=help {n,-name}:=name || return

  if [[ -n $VIRTUAL_ENV ]]; then
    (( ${#@} )) || {$0::help; return 0}
    (( $#name )) || {$VIRTUAL_ENV/bin/python3 "$@"; return $?}
  fi
  (( $#help )) && {$0::help; return 0}
  (( $#name )) || {echo "Neither venv currently active, nor '--name' provided."; return 1}

  local retval=($(_venv::_get_venv_info --name "$name[-1]"))
  local venv_path=$retval[3]

  [[ -d $venv_path ]] || {echo "Err: Venv under path '$venv_path' does not exist"; return 1}
  
  $venv_path/bin/python3 "$@"
}
