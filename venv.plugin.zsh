#! /usr/bin/env zsh

0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

typeset -g VENV_BASE_DIR="${0:h}"

[[ -z "$VENVS_BASE_DIR" ]] && export VENVS_BASE_DIR="$XDG_DATA_HOME/venvs"
[[ -z "$VENV_PLUG_NO_AUTO" ]] && export VENV_PLUG_NO_AUTO=true

if [[ $VENV_PLUG_NO_AUTO == true ]]; then
  function chpwd() { venv auto }
fi

local config_file
for config_file ($VENV_BASE_DIR/lib/**/*.zsh); do
  source "$config_file"
done
unset config_file

