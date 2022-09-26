#! /usr/bin/env zsh

function +venv {
  cat >&2 <<EOF
venv -- A simple Python virtual environment wrapper.

USAGE:
    ${(j: :)${(s.::.)0#+}} <SUBCOMMAND>

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
    run                               Run either a script or an executable.
    update                            Update packages in the selected venv.
    upgrade (unimplemented)           Upgrade Python version for the selected venv.
EOF
  return 0
}
function venv {
  local opt_help
  zparseopts -D -F -K -- {h,-help}=opt_help || return

  (( ${#@} == 0 && $#opt_help )) && {+$0; return 0}

  (($# > 0 && $+functions[.$0::$1])) || { +$0; return 1 }
  local cmd="$1"; shift
  .venv::$cmd "$@"
}
