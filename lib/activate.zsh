#! /usr/bin/env zsh

function _venv::activate {
    zparseopts -D -E -A opts n:

    local -A info=()
    local retval=($(_venv::_get_venv_info $opts[-n]))
    info=([project_path]=$retval[1] [name]=$retval[2] [path]=$retval[3] [is_linked]=$retval[4])

    [[ -d $info[path] ]] || {echo "Venv under path '$info[path]' does not exist"; return 1}
    [[ $info[is_linked] == true ]] || \
      {echo "Project under path '$info[project_path]' is not linked to venv under path '$info[path]'"}

    source $info[path]/bin/activate
}
