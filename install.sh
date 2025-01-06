#!/usr/bin/env bash
set -euo pipefail

# make sure we have pulled in and updated any submodules
git submodule init
git submodule update

# folders that should, or only need to be installed for a local user
useronly=(
    git
	zsh
)

brew_installs=(
	stow
	powerlevel10k
	fzf
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

if ! command -v brew 2>&1 > /dev/null
then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo ""
echo "Installing apps"

brew install $brew_installs

echo "### DONE"

echo ""
echo "Stowing apps for user: $(whoami)"

for app in ${useronly[@]}; do
    if [[ "$(whoami)" != *"root"* ]]; then
        stowit "${HOME}" $app 
    fi
done

echo ""
echo "##### ALL DONE"