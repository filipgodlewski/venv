#! /usr/bin/env zsh

function _venv::_get_venv_info {
    zparseopts -D -E -A opts -venv_name:
    local git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    local project_path=$([[ $git_dir ]] && echo $git_dir || echo $PWD)
    local name=${opts[--venv_name]:-$(echo ${project_path##*/} | sd ' ' '_')}
    local path=$VENVSBASEPATH/$name
    [[ $(grep $project_path $path/.venv_paths 2> /dev/null) ]] && local is_linked=true || local is_linked=false
    
    echo $project_path $name $path $is_linked
}
