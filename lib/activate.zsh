#! /usr/bin/env zsh

function _venv::activate::help {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [VENV]

Activate a venv regardless of being inside the linked project.

OPTIONS:
    -n, --name                        Venv name.
    -h, --help                        Show this message.
EOF
  return 0
}
function _venv::activate {
  trap "unset help name" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -F -K -- {n,-name}:=name {h,-help}=help || return

  (( $#help )) && {$0::help; return 0}

  local retval=($(_venv::_get_venv_info --name "$name[-1]"))
  local project_path=$retval[1]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ -d $venv_path ]] || {echo "Err: Venv under path '$venv_path' does not exist"; return 1}
  [[ $is_linked == true ]] || echo "Warn: Project under path '$project_path' is not linked to venv under path '$venv_path'"

  source $venv_path/bin/activate
}
