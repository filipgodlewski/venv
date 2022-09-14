#! /usr/bin/env zsh

function _venv::new::help {
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
function _venv::new {
  trap "unset help activate link no_link ppath" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -F -K -- \
    {a,-activate}=activate \
    -no-link=no_link \
    -link=link \
    {p,-project-path}:=ppath \
    {h,-help}=help || return

  (( $#help )) && {$0::help; return 0}

  local retval=($(_venv::_get_venv_info --project-path "$ppath[-1]"))
  local project_path=$retval[1]
  local name=$retval[2]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ $is_linked == true ]] && {echo "'$project_path' is already assigned to venv named '$name'"; return 2}
  if [[ -d $venv_path ]]; then
    echo "Venv '$name' already exists and is assigned to another project(s)."
    (( $#no_link )) && return 1
    if (( ! $#link )); then
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
    (( $#no_link )) || {echo "$project_path" > $venv_path/.venv_paths; echo "Linked to '$project_path'"}
  fi

  (( $#activate )) && source $venv_path/bin/activate
}
