[[ -z "$VENVPLUG" ]] && export VENVPLUG="${${(%):-%x}:a:h}"

for config_file ("$VENVPLUG"/lib/**/*.zsh); do
  source "$config_file"
done
unset config_file

