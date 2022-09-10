#! /usr/bin/env zsh

function _venv::cleanup {
  zmodload zsh/mapfile
  local files=("$VENVSBASEPATH"/*/.venv_paths(N))
  (($#files == 0)) && return 0

  for file in $files; do
    local lines=("${(f@)${mapfile[$file]%$'\n'}}")
    for line in $lines; do
      [[ -d "$line" ]] || echo "$(grep -v $line $file)" > $file
    done
  done
}
