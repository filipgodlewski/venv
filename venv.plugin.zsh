[[ -z "$VENVPLUG" ]] && export VENVPLUG="${${(%):-%x}:a:h}"
[[ -z "$VENVSBASEPATH" ]] && export VENVSBASEPATH="$XDG_DATA_HOME/venvs"
[[ -z "$VENVPLUGNOAUTO" ]] && export VENVPLUGNOAUTO=true

if [[ $VENVPLUGNOAUTO == true ]]; then
  function chpwd() { venv auto }
fi

for config_file ("$VENVPLUG"/lib/**/*.zsh); do
  source "$config_file"
done
unset config_file

