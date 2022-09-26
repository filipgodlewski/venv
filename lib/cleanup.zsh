#! /usr/bin/env zsh

function +venv::cleanup {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [options]

Clean up all project references in venv paths files that are unreachable.

OPTIONS:
    -h, --help                        Show this message.
EOF
  return 0
}
function .venv::cleanup {
  local opt_help
  zparseopts -D -F -K -- {h,-help}=opt_help
  zmodload zsh/mapfile

  (( $#opt_help )) && {+${0#.}; return 0}

  local files=("$VENVS_BASE_DIR"/*/.venv_paths(N))
  (($#files == 0)) && return 0

  local file
  for file in $files; do
    local lines=("${(f@)${mapfile[$file]%$'\n'}}")
    for line in $lines; do
      [[ -d "$line" ]] || echo "$(grep -v $line $file)" > $file
    done
  done
}
