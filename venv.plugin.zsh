[[ -z "$VENVPLUG" ]] && export VENVPLUG="${${(%):-%x}:a:h}"
[[ -z "$VENVSBASEPATH" ]] && export VENVSBASEPATH="$XDG_DATA_HOME/venvs"
if [[ -z "$VENVPLUGNOAUTO" -o "$VENVPLUGNOAUTO" == true ]]; then 
  export VENVPLUGNOAUTO=true
  function chpwd() { venv auto }
fi

for config_file ("$VENVPLUG"/lib/**/*.zsh); do
  source "$config_file"
done
unset config_file

