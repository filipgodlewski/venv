#! /usr/bin/env zsh

function _venv::list {
  zmodload zsh/mapfile
  local venvs=("$VENVSBASEPATH"/*(N))
  local no_of_venvs=$#venvs
  (($no_of_venvs == 0)) && {zmodload -u zsh/mapfile; return 0}

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
  zmodload -u zsh/mapfile
}
