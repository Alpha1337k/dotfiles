#!/usr/bin/env bash
set -euo pipefail


# Assure brew is loaded
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

# folders that should, or only need to be installed for a local user
apps=(
    git
	zsh
	plugins
	commands
	env
	config
)

# run the stow command for the passed in directory ($2) in location $1
stowit() {
    usr=$1
    app=$2
    # -v verbose
    # -R recursive
    # -t target
    stow -v -R -t ${usr} ${app}
}

echo ""
echo "Stowing apps for user: $(whoami)"

for app in ${apps[@]}; do
    stowit "${HOME}" $app 
done

echo "### DONE"
