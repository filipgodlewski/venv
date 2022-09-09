#! /usr/bin/env zsh

function _venv::_get_venv_info {
    zparseopts -D -E -A opts -venv:
    local git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    local project_path=$([[ $git_dir ]] && echo $git_dir || echo $PWD)
    local name=${opts[--venv]:-$(echo ${project_path##*/} | sed 's/ /_/g')}
    local venv_path=$VENVSBASEPATH/$name
    [[ $(grep -x $project_path $venv_path/.venv_paths 2> /dev/null) ]] && local is_linked=true || local is_linked=false
    
    echo $project_path $name $venv_path $is_linked
}
