#! /usr/bin/env zsh

function _venv::_get_venv_info {
    local name=$1; shift
    local git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
    
    declare -A info
    info[project_path]=$([[ $git_dir ]] && echo $git_dir || echo $PWD)
    info[name]=${name:-$(echo ${project_path##*/} | sd ' ' '_')}
    info[path]=$VENVSBASEPATH/$info[name]
    local is_in_venv_paths_file=$(grep $info[project_path] $info[path]/.venv_paths 2> /dev/null)
    [[ $is_in_venv_paths_file ]] && info[is_linked]=true || info[is_linked]=false
    echo info
}
