#! /usr/bin/env zsh

function _venv::activate {
    zparseopts -D -E -A opts n:

    if [[ "$opts[-n]" == "" ]]; then
        local git_dir=$(git rev-parse --show-toplevel 2> /dev/null)
        [[ $git_dir ]] && local project_path=$git_dir || local project_path=$PWD
        local venv_name=$(echo ${project_path##*/} | sd ' ' '_')
    else
        local venv_name=$opts[-n]
    fi
    local venv_path=$VENVSBASEPATH/$venv_name

    [[ -d $venv_path ]] || {echo "Venv under path '$venv_path' does not exist"; return 1}
    [[ -n $(grep $project_path $venv_path/.venv_paths 2> /dev/null ) ]] || \
      {echo "Project under path '$project_path' is not linked to venv under path '$venv_path'"}

    source $venv_path/bin/activate
}
