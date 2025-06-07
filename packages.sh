#!/usr/bin/env bash
set -euo pipefail

brew_installs=(
	stow
	oh-my-posh
	zsh-autosuggestions
	zsh-syntax-highlighting
	fzf
	fnm
	uv
	tlrc
	fd
	gh
	zellij
	zoxide
	eza
	bat
)

uv_tool_installs=(
	openrouter-cli
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

echo ""
echo "Installing python tools"

uv tool install ${uv_tool_installs[*]// /|}

echo "### DONE"