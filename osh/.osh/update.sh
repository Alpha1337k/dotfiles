#!/usr/bin/env bash
set -euo pipefail

update_dotfiles() {
	echo "🔄 Updating dotfiles..."

	cd "$DOTFILES_DIR"

	echo "📥 Pulling latest changes..."
	git pull

	echo "🔗 Applying stow configurations..."
	stow_folders

	echo "📦 Installing/updating packages..."
	install_packages

	echo "✅ Dotfiles updated successfully!"
}
