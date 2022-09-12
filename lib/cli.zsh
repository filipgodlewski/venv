#! /usr/bin/env zsh

function _venv::help {
  cat >&2 <<EOF
venv -- A simple Python virtual environment wrapper.

Usage:
  ${(j: :)${(s.::.)0#_}% help} <command> [options]

Commands:
  activate                    Activate the virtual environment for the current project.
  auto                        Automate activating venv on chpwd. Use only within chpwd()!
  cleanup                     Clean up all unreachable projects from venv paths.
  delete                      Delete given virtual environment.
                                Requires '--force' if venv is assigned to multiple projects.
  list                        List all available venvs.
  new                         Create new venv.
  run (unimplemented)         Run either a script or an executable.
  update                      Update packages in the selected venv.
  upgrade (unimplemented)     Upgrade Python version for the selected venv.
EOF
  return 0
}
function venv {
  (($# > 0 && $+functions[_$0::$1])) || { _$0::help; return 1 }
  local cmd="$1"; shift
  _venv::$cmd "$@"
}
