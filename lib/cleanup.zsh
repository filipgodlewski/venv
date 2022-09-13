#! /usr/bin/env zsh

function _venv::cleanup::help {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [options]

Clean up all project references in venv paths files that are unreachable.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function _venv::cleanup {
  zparseopts -D -F -K -- {h,-help}=help || return
  zmodload zsh/mapfile

  (( $#help )) && {$0::help; return 0}

  local files=("$VENVS_BASE_PATH"/*/.venv_paths(N))
  (($#files == 0)) && return 0

  for file in $files; do
    local lines=("${(f@)${mapfile[$file]%$'\n'}}")
    for line in $lines; do
      [[ -d "$line" ]] || echo "$(grep -v $line $file)" > $file
    done
  done
}
