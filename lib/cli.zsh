#! /usr/bin/env zsh

function _venv::help {
  cat >&2 <<EOF
venv -- A simple Python virtual environment wrapper.

USAGE:
  ${(j: :)${(s.::.)0#_}% help} <SUBCOMMAND>

OPTIONS:
    -h, --help                        Show this message.

SUBCOMMANDS:
    activate                          Activate the virtual environment for the current project.
    auto                              Automate activating venv on chpwd. Use only within chpwd()!
    cleanup                           Clean up all unreachable projects from venv paths.
    delete                            Delete given virtual environment.
                                      Requires '--force' if venv is assigned to multiple projects.
    list                              List all available venvs.
    new                               Create new venv.
    run (unimplemented)               Run either a script or an executable.
    update                            Update packages in the selected venv.
    upgrade (unimplemented)           Upgrade Python version for the selected venv.
EOF
  return 0
}
function venv {
  trap "unset help" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -F -K -- {h,-help}=help || return

  (( ${#@} == 0 && $#help )) && {_$0::help; return 0}

  (($# > 0 && $+functions[_$0::$1])) || { _$0::help; return 1 }
  local cmd="$1"; shift
  _venv::$cmd "$@"
}
