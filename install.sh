#!/bin/bash

set -e

REPO_URL="git@github.com:Alpha1337k/dotfiles.git"
HTTP_REPO_URL="https://github.com/Alpha1337k/dotfiles.git"
TARGET_DIR="$HOME/dotfiles"

# Clone or update the dotfiles repository
if [ -d "$TARGET_DIR/.git" ]; then
	echo "Updating existing dotfiles repository..."
	git -C "$TARGET_DIR" pull
else
	if [ "$DOTFILES_USE_HTTP" = "1" ]; then
		echo "Cloning dotfiles repository via HTTPS..."
		git clone "$HTTP_REPO_URL" "$TARGET_DIR"
	else
		echo "Cloning dotfiles repository via SSH..."
		git clone "$REPO_URL" "$TARGET_DIR"
	fi
fi

# Check for zsh
if ! command -v zsh >/dev/null 2>&1; then
	echo "Error: zsh is not installed. Please install zsh and rerun this script."
	exit 1
fi

# Install oh-my-zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "Installing oh-my-zsh..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	mv ~/.zshrc ~/.zshrc.bak
	echo "Zsh configuration file backed up to ~/.zshrc.bak"
else
	echo "oh-my-zsh is already installed."
fi

# Install brew if not present
if ! command -v brew 2>&1 >/dev/null; then
	echo "# Installing brew"
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

$TARGET_DIR/commands/osh update

echo "Dotfiles installation complete."
