#! /usr/bin/env zsh

function _venv::new {
  # TODO: Support custom venv names

  if [[ -d ${VENV_PATH} && -n ${IS_IN_VENV_PATHS} ]]; then
    echo "'${FULL_VENV}' is already assigned to '${VENV}' venv."
    return 2
  elif [[ -d ${VENV_PATH} && -z ${IS_IN_VENV_PATHS} ]]; then
    echo "Venv '${VENV}' already exists."
    echo "You can still append this project '${FULL_VENV}' to reuse the existing venv."
    echo
    echo -n "Would you like to do it [Y/n]? "
    read ANSWER

    case ${ANSWER} in
      [yY]|"") unset ANSWER;;
      *) unset ANSWER; return 0;;
    esac

    __append
    [[ $? -eq 0 ]] && venv-activate || return 2
    return $?
  fi

  ${PYTHON3_PATH} -m venv ${VENV_PATH} --system-site-packages --upgrade-deps

  if [[ -z ${QUIET} ]]; then
    echo "New venv created under:"
    echo ${VENV_PATH}
  fi

  _venv::activate

  return 0
}
