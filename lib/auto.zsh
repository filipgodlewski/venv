#! /usr/bin/env zsh

function _venv::auto {
  local retval=($(_venv::_get_venv_info))
  local venv_path=$retval[3]  # info[path]

  [[ $VIRTUAL_ENV == $venv_path ]] && return 0
  deactivate 2> /dev/null
  source $venv_path/bin/activate 2> /dev/null
  return 0
}
