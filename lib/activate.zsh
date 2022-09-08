#! /usr/bin/env zsh

function _venv::activate {
    zparseopts -D -E -A opts n:

    local info=$(_venv::_get_venv_info $opts[-n])

    [[ -d $info[path] ]] || {echo "Venv under path '$info[path]' does not exist"; return 1}
    [[ $info[is_linkedin] == true ]] || \
      {echo "Project under path '$info[project_path]' is not linked to venv under path '$info[path]'"}

    source $venv_path/bin/activate
}
