#! /usr/bin/env zsh

function _venv::list::help {
  cat >&2 <<EOF
Usage: ${(j: :)${(s.::.)0#_}% help} [options]

List venvs in a nice form. By default names in similar fashion to `ls` command.

OPTIONS:
        --tree                        Show names and linked projects in tree form.
    -h, --help                        Show this message.
EOF
  return 0
}
function _venv::list {
  trap "unset help tree" EXIT ERR INT QUIT STOP CONT
  zparseopts -D -F -K -- {h,-help}=help -tree=tree  || return
  zmodload zsh/mapfile

  (( $#help )) && {$0::help; return 0}

  if (( $#tree )); then
    _venv::list::_tree
  else
    local venvs=("$VENVS_BASE_PATH"/*(N))
    local no_of_venvs=$#venvs
    (( ! $no_of_venvs )) && return 0

    echo ${venvs##*/}
  fi
}

function _venv::list::_tree {
  local venvs=("$VENVS_BASE_PATH"/*(N))
  local no_of_venvs=$#venvs
  (( ! $no_of_venvs )) && return 0

  echo "."
  for i in {1..$no_of_venvs}; do
    local venv=$venvs[$i]
    (($i == $no_of_venvs)) && echo "└── ${venv##*/}" || echo "├── ${venv##*/}"

    local lines=("${(f@)${mapfile[$venv/.venv_paths]%$'\n'}}")
    local no_of_lines=$#lines
    for j in {1..$no_of_lines}; do
      local line=$lines[$j]
      [[ $line == "" ]] && continue
      [[ -d $line ]] && local project_path="$line" || local project_path="$line (UNREACHABLE)"
      (($i == $no_of_venvs)) && local line_start="  " || local line_start="│ "
      (($j == $no_of_lines)) && echo "$line_start └── $project_path" || echo "$line_start ├── $project_path"
    done
  done
}
