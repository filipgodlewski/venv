#! /usr/bin/env zsh

function +venv::activate {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#+}} [VENV]

Activate a venv regardless of being inside the linked project.

OPTIONS:
    -n, --name                        Venv name.
    -h, --help                        Show this message.
EOF
  return 0
}
function .venv::activate {
  local opt_help opt_name
  zparseopts -D -F -K -- {h,-help}=opt_help {n,-name}:=opt_name

  (( $#opt_help )) && {+${0#.}; return 0}

  local retval=($(.venv::_get_venv_info --name "$opt_name[-1]"))
  local project_path=$retval[1]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ -d $venv_path ]] || {echo "Err: Venv under path '$venv_path' does not exist"; return 1}
  [[ $is_linked == true ]] || echo "Warn: Project under path '$project_path' is not linked to venv under path '$venv_path'"

  source $venv_path/bin/activate
}
