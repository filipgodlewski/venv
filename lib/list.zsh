#! /usr/bin/env zsh

function +venv::list {
  cat >&2 <<EOF
USAGE:
    ${(j: :)${(s.::.)0#+}} [options]

List venvs in a nice form. By default names in similar fashion to `ls` command.

OPTIONS:
    -t, --tree                        Show names and linked projects in tree form.
    -h, --help                        Show this message.
EOF
  return 0
}
function .venv::list {
  local opt_help opt_tree
  zparseopts -D -F -K -- {h,-help}=opt_help {t,-tree}=opt_tree
  zmodload zsh/mapfile

  (( $#opt_help )) && {+${0#.}; return 0}

  if (( $#opt_tree )); then
    .venv::list::_tree
  else
    local venvs=("$VENVS_BASE_DIR"/*(N))
    local no_of_venvs=$#venvs
    (( ! $no_of_venvs )) && return 0

    echo ${venvs##*/}
  fi
}

function .venv::list::_tree {
  local venvs=("$VENVS_BASE_DIR"/*(N))
  local no_of_venvs=$#venvs
  (( ! $no_of_venvs )) && return 0

  echo "."
  local i
  for i in {1..$no_of_venvs}; do
    local venv=$venvs[$i]
    (($i == $no_of_venvs)) && echo "└── ${venv##*/}" || echo "├── ${venv##*/}"

    local lines=("${(f@)${mapfile[$venv/.venv_paths]%$'\n'}}")
    local no_of_lines=$#lines
    unset j; local j
    for j in {1..$no_of_lines}; do
      local line=$lines[$j]
      [[ $line == "" ]] && continue
      [[ -d $line ]] && local project_path="$line" || local project_path="$line (UNREACHABLE)"
      (($i == $no_of_venvs)) && local line_start="  " || local line_start="│ "
      (($j == $no_of_lines)) && echo "$line_start └── $project_path" || echo "$line_start ├── $project_path"
    done
  done
}
