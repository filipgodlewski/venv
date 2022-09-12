#! /usr/bin/env zsh

function _venv::run {
  zparseopts -D -E -A opts -name:=name n:=name
  local retval=($(_venv::_get_venv_info --name "$name"))
  local venv_path=$retval[3]

  [[ -d $venv_path ]] || {echo "Err: Venv under path '$venv_path' does not exist"; return 1}
  
  $venv_path/bin/python3 "$@"
}
