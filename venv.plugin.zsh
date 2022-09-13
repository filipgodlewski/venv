[[ -z "$VENV_PLUG" ]] && export VENV_PLUG="${${(%):-%x}:a:h}"
[[ -z "$VENVS_BASE_PATH" ]] && export VENVS_BASE_PATH="$XDG_DATA_HOME/venvs"
[[ -z "$VENV_PLUG_NO_AUTO" ]] && export VENV_PLUG_NO_AUTO=true

if [[ $VENV_PLUG_NO_AUTO == true ]]; then
  function chpwd() { venv auto }
fi

for config_file ("$VENV_PLUG"/lib/**/*.zsh); do
  source "$config_file"
done
unset config_file

