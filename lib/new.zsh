#! /usr/bin/env zsh

function _venv::new::help {
    cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [--no-activate; --project-path=PATH]
EOF
    return 0
}
function _venv::new {
  zparseopts -D -E -a flags h -help -activate -no-link
  zparseopts -D -E -A opts -project-path:

  ((${flags[(Ie)-h]} > 0 || ${flags[(Ie)--help]} > 0)) && {$0::help; return 0}

  local retval=($(_venv::_get_venv_info --project-path "$opts[--project-path]"))
  local project_path=$retval[1]
  local name=$retval[2]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ $is_linked == true ]] && {echo "'$project_path' is already assigned to venv named '$name'"; return 2}
  if [[ -d $venv_path ]]; then
    echo "Venv '$name' already exists and is assigned to another project(s)."
    ((${flags[(Ie)--no-link]} > 0)) && return 1
    echo "Do you want to reuse it for the current project? [Y/n] \c"
    read answer

    case $answer in
      [yY]|"")
        unset answer
        ;;
      *)
        unset answer
        return 0
        ;;
    esac
    echo "$project_path" >> $venv_path/.venv_paths
    echo "Linked to '$project_path'"
  else
    python3 -m venv $venv_path --system-site-packages --upgrade-deps
    echo "\nNew venv created under: '$venv_path'"
    ((${flags[(Ie)--no-link]} > 0)) && {echo "$project_path" > $venv_path/.venv_paths; echo "Linked to '$project_path'"}
  fi

  ((${flags[(Ie)--activate]} > 0)) && source $venv_path/bin/activate
}
