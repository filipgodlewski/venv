#! /usr/bin/env zsh

function _venv::activate {
  zparseopts -D -E -A opts n:

  local -A info=()
  local retval=($(_venv::_get_venv_info --venv $opts[-n]))
  local project_path=$retval[1]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ -d $venv_path ]] || {echo "Err: Venv under path '$venv_path' does not exist"; return 1}
  [[ $is_linked == true ]] || echo "Warn: Project under path '$project_path' is not linked to venv under path '$venv_path'"

  source $venv_path/bin/activate
}
