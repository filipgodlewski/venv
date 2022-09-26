#! /usr/bin/env zsh

function +venv::new {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [options]

Create new venv.

OPTIONS:
    -a, --activate                    Activate the venv once it is created.
        --[no-]link                   Do [not] link the venv to the project.
                                      Note that the venv auto will not work
                                      for this project.
    -p, --project-path <path>         Relative or absulute path to the project
                                      you want to create a venv for.
    -h, --help                        Show this message.
EOF
  return 0
}
function .venv::new {
  local opt_help opt_activate opt_no_link opt_link opt_ppath
  zparseopts -D -F -K -- \
    {a,-activate}=opt_activate \
    -no-link=opt_no_link \
    -link=opt_link \
    {p,-project-path}:=opt_ppath \
    {h,-help}=opt_help

  (( $#opt_help )) && {+${0#.}; return 0}

  local retval=($(.venv::_get_venv_info --project-path "$opt_ppath[-1]"))
  local project_path=$retval[1]
  local name=$retval[2]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ $is_linked == true ]] && {echo "'$project_path' is already assigned to venv named '$name'"; return 2}
  if [[ -d $venv_path ]]; then
    echo "Venv '$name' already exists and is assigned to another project(s)."
    (( $#opt_no_link )) && return 1
    if (( ! $#opt_link )); then
      read answer"?Do you want to reuse it for project under '$project_path'? [Y/n] "

      case $answer in
        [yY]|"")
          unset answer
          ;;
        *)
          unset answer
          return 0
          ;;
      esac
    fi
    echo "$project_path" >> $venv_path/.venv_paths
    echo "Linked to '$project_path'"
  else
    python3 -m venv $venv_path --system-site-packages --upgrade-deps
    echo "\nNew venv created under: '$venv_path'"
    (( $#opt_no_link )) || {echo "$project_path" > $venv_path/.venv_paths; echo "Linked to '$project_path'"}
  fi

  (( $#opt_activate )) && source $venv_path/bin/activate
}
