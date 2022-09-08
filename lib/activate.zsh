#! /usr/bin/env zsh

function _venv::activate {
  if [[ -z ${NAME} && -d ${VENV_PATH} && -n $(grep ${FULL_VENV} ${PATHS_CFG_FILE} 2> /dev/null) ]]; then
    source ${VENV_PATH}/bin/activate
    return 0
  elif [[ -n ${NAME} ]]; then
    if [[ -d ${ALL_VENVS}/${NAME[2]} ]]; then
      source ${ALL_VENVS}/${NAME[2]}/bin/activate
      return 0
    else
      echo "Venv '${ALL_VENVS}/${NAME[2]}' does not exist."
      return 2
    fi
  fi

  if [[ -z ${QUIET} ]]; then
    echo "Your project '${FULL_VENV}' does not have related venv."
    echo
  fi

  return 2
}
