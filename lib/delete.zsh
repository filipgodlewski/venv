#! /usr/bin/env zsh

function _venv::delete {
  zparseopts -D -E -a flags -force
  zmodload zsh/mapfile
  [[ ${#@} -eq 0 ]] && {echo "Err: No venvs provided."; return 1}

  for venv in $@; do
    local retval=($(_venv::_get_venv_info --venv $venv))
    local venv_path=$retval[3]
    [[ -d $venv_path ]] || {echo "Err: venv named '$venv' does not exist."; return 2}
    local lines=("${(f@)${mapfile[$venv_path/.venv_paths]%$'\n'}}")
    if [[ ${#lines:#} -gt 1 && ${flags[(Ie)--force]} -eq 0 ]]; then
      echo "Err: The venv you want to delete is used by more than 1 project:"
      echo ${(F@)lines:#}
      echo
      echo "Run again with '--force' flag if you're totally sure you want to delete this venv."
      return 3
    fi

    [[ $VIRTUAL_ENV == $venv_path ]] && deactivate
    rm -rf $venv_path
    echo "Info: Deleted venv named '$venv' which was stored under '$venv_path'"
  done
}
