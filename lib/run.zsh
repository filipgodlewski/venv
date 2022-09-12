#! /usr/bin/env zsh

function _venv::run {
  zparseopts -D -E -A opts -name:=name n:=name
  [[ $VIRTUAL_ENV == "" && $name == "" ]] && {echo "Neither venv currently active, nor '--name' provided."; return 1}
  [[ $name == "" ]] && {$VIRTUAL_ENV/bin/python3 "$@"; return $?}

  local retval=($(_venv::_get_venv_info --name "$name[2]"))
  local venv_path=$retval[3]

  [[ -d $venv_path ]] || {echo "Err: Venv under path '$venv_path' does not exist"; return 1}
  
  $venv_path/bin/python3 "$@"
}
