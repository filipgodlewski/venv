#! /usr/bin/env zsh

function _venv::activate {
  (($# == 0)) && {echo "Err: Did not provide venv name"; return 1}
  
  local -A info=()
  local retval=($(_venv::_get_venv_info --venv $1))
  local project_path=$retval[1]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ -d $venv_path ]] || {echo "Err: Venv under path '$venv_path' does not exist"; return 1}
  [[ $is_linked == true ]] || echo "Warn: Project under path '$project_path' is not linked to venv under path '$venv_path'"

  source $venv_path/bin/activate
}
