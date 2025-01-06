#!/usr/bin/env bash
set -euo pipefail

brew_installs=(
	stow
	powerlevel10k
	zsh-autosuggestions
	zsh-syntax-highlighting
	fzf
)

if ! command -v brew 2>&1 > /dev/null
then
	echo "# Installing brew"
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

echo ""
echo "Installing apps"

brew install ${brew_installs[*]// /|}

echo "### DONE"