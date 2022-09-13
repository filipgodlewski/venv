#! /usr/bin/env zsh

#######################################
# Get information about the given venv.
# Globals:
#   VENVS_BASE_PATH
# Arguments:
#   name - venv name, project path to
#   the venv is potentially linked to.
# Outputs:
#   parsed project path,
#   parsed venv name,
#   venv path,
#   whether the venv is linked to the project path
#######################################
function _venv::_get_venv_info {
  zparseopts -D -F -K -- {n,-name}:=name {p,-project-path}:=ppath || return

  local project_path=${ppath[-1]:-${$(git rev-parse --show-toplevel 2> /dev/null):-$PWD}}
  local name=${name[-1]:-$(echo ${project_path##*/} | sed 's/ /_/g')}
  local venv_path=$VENVS_BASE_PATH/$name
  [[ $(grep -x $project_path $venv_path/.venv_paths 2> /dev/null) ]] && local is_linked=true || local is_linked=false

  echo $project_path $name $venv_path $is_linked
}
