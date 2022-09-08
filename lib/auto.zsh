#! /usr/bin/env zsh

function _venv::auto {
    local info=$(_venv::_get_venv_info)
    [[ $VIRTUAL_ENV == $info[path] ]] && return 0
    deactivate 2> /dev/null
    source $info[path]/bin/activate 2> /dev/null
}
