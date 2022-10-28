#! /usr/bin/env zsh

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

[[ -z "$AUTO_VENV" ]] && export AUTO_VENV=true
[[ -z "$WORKON_HOME" ]] && export WORKON_HOME="$XDG_DATA_HOME/venvs"

local _bin_path="${PIPX_HOME:-$HOME/.local/pipx}/venvs/virtualenvwrapper/bin"
[[ -z "$VIRTUALENVWRAPPER_VIRTUALENV" ]] && export VIRTUALENVWRAPPER_VIRTUALENV="$_bin_path/virtualenv"
[[ -z "$VIRTUALENVWRAPPER_PYTHON" ]] && export VIRTUALENVWRAPPER_PYTHON="$_bin_path/python"
unset _bin_path

[[ -z "$PROJECT_HOME" ]] && export PROJECT_HOME=$HOME/projects
[[ -z "$VIRTUALENVWRAPPER_VIRTUALENV_ARGS" ]] && export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--download'
[[ -z "$VIRTUALENVWRAPPER_HOOK_DIR" ]] && export VIRTUALENVWRAPPER_HOOK_DIR="${0:h}/hooks"


source virtualenvwrapper.sh
[[ $? == 127 ]] && { echo "virtualenvwrapper is not installed through pipx!"; return 1 }

if [[ $AUTO_VENV == true ]]; then
  export VIRTUALENVWRAPPER_WORKON_CD=0
  function chpwd() { .venv::auto }
fi


function .venv::auto {
  deactivate 2> /dev/null
  local project_path=${$(git rev-parse --show-toplevel 2> /dev/null):-$PWD}
  workon ${project_path##*/} &> /dev/null
}

function +rmdeadrefs {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#+}} [options]

Clean up all project references in venv paths files that are unreachable.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function rmdeadrefs {
  local opt_help
  zparseopts -D -F -K -- {h,-help}=opt_help
  zmodload zsh/mapfile

  (( $#opt_help )) && {+$0; return 0}

  local files=($WORKON_HOME/*/$VIRTUALENVWRAPPER_PROJECT_FILENAME(N))
  (($#files == 0)) && return 0

  local file
  for file in $files; do
    local lines=("${(f@)${mapfile[$file]%$'\n'}}")
    for line in $lines; do
      [[ -d "$line" ]] || { echo "$(grep -v $line $file)" > $file; echo "Removed ref: '$line' from $file" }
    done
  done

  zmodload -ui zsh/mapfile
}
