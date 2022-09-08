#! /usr/bin/env zsh

function _venv::help {
    cat >&2 <<EOF
venv -- A simple Python virtual environment wrapper.

Usage:
  ${(j: :)${(s.::.)0#_}% help} <command> [options]

Commands:
  activate                    Activate the virtual environment for the current project.
  auto                        Automate activating venv on chpwd. Use only within chpwd()!
  delete                      Delete given virtual environment.
  go (unimplemented)          Change directory to the base directory of the project 
                                that utilizes given virtual environment.
  list                        List all available virtual environments.
  new                         Create new virtual environment.
  update                      Update packages in the given virtual environment.
  upgrade (unimplemented)     Upgrade Python version.
EOF
    return 0
}
function venv {
    (($# > 0 && $+functions[_$0::$1])) || { _$0::help; return 1 }
    local cmd="$1"; shift
    _venv::$cmd "$@"
}
