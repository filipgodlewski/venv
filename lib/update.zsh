#! /usr/bin/env zsh

function _venv::update {
  [[ ${#@} -eq 0 ]] && {echo "Err: No venvs provided."; return 1}

  for venv in $@; do
    local retval=($(_venv::_get_venv_info --venv $venv))
    local venv_path=$retval[3]
    [[ -d $venv_path ]] || {echo "Err: venv named '$venv' does not exist."; return 2}
    local python_binary=$venv_path/bin/python3
    local outdated_packages=($($python_binary -m pip list --outdated --format freeze | sed 's/==.*//'))
    [[ ${#outdated_packages} -eq 0 ]] && {echo "All up to date!"; return 0}
    
    for package in $outdated_packages; do
      $python_binary -m pip install -U $package
    done
  done
}
