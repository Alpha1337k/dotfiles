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
fi

"$TARGET_DIR/packages.sh"
"$TARGET_DIR/stow.sh"

echo "Dotfiles installation complete."