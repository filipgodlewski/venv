#! /usr/bin/env zsh

function _venv::new {
  local retval=($(_venv::_get_venv_info))
  local project_path=$retval[1]
  local name=$retval[2]
  local venv_path=$retval[3]
  local is_linked=$retval[4]

  [[ $is_linked == true ]] && {echo "'$project_path' is already assigned to venv named '$name'"; return 2}
  if [[ -d $venv_path ]]; then
    echo "Venv '$name' already exists."
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
  else
    python3 -m venv $venv_path --system-site-packages --upgrade-deps
    echo "$project_path" > $venv_path/.venv_paths
    echo "\nNew venv created under: '$venv_path'"
  fi

  echo "Linked to '$project_path'"
  source $venv_path/bin/activate
}
