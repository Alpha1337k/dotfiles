#!/usr/bin/env bash
set -euo pipefail

install_packages() {
	cd "$DOTFILES_DIR"

	git submodule update --init --recursive
	
	set +e
	
	local brew_result=$(brew bundle)
	local brew_exit_code=$?

	set -e

	local uv_tools=( $(cat Uvfile) )

	set +e

	for tool in $uv_tools;
	do
		local uv_result=$(uv tool install -q $tool)
		local uv_exit_code=$?

		if [ $uv_exit_code -ne 0 ]; then
			echo "❌ Error installing uv tool $tool: $uv_result"
		fi
	done

	set -e

	if [ $brew_exit_code -ne 0 ]; then
		echo "❌ Error installing brew packages: $brew_result"
	fi

	if [ $uv_exit_code -eq 0 ] && [ $brew_exit_code -eq 0 ]; then
		echo "✅ All packages installed/updated successfully!"
	else
		echo "⚠️ Some packages failed to install. Check the output above."
	fi
}