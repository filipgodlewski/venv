#! /usr/bin/env zsh

function _venv::auto {
  local retval=($(_venv::_get_venv_info))
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ $VIRTUAL_ENV == $venv_path ]] && return 0
  deactivate 2> /dev/null
  [[ $is_linked == true ]] && source $venv_path/bin/activate
}
