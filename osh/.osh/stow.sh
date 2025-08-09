#!/usr/bin/env bash
set -euo pipefail

stow_folders() {
	local apps=(
		osh
		git
		zsh
		plugins
		commands
		env
		config
		completions
	)

	for app in ${apps[@]}; do
		echo "🔗 Stowing ${app}..."
		
		# First, try stow with simulation to detect conflicts
		if ! stow -n -v -R -t "$HOME" "${app}" 2>/dev/null; then
			set +e

			conflicts=$(stow -n -v -R -t "$HOME" "${app}" 2>&1)

			set -e

			echo "❌  Conflicts detected for ${app}:"
			echo "$conflicts"
			echo "❌  Resolve these conflicts before proceeding."

			exit 1
		else
			# No conflicts detected, proceed normally
			stow -v -R -t "$HOME" "${app}" 2>/dev/null
		fi
	done

	echo "✅ Stowing completed successfully!"
}
