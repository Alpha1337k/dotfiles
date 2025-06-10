#!/usr/bin/env bash
set -euo pipefail

cd "$HOME/dotfiles"

files=(
	$(find . -type f \( -name "*.sh" -o -name "*.zsh" -o -name ".zshrc" \))
	$(find ./commands/bin -type f)
)

for file in "${files[@]}"; do
	if [[ -f "$file" ]]; then
		echo "Formatting $file..."

		set +e
		result=$(shfmt -w "$file")
		set -e

		if [[ $? -ne 0 ]]; then
			echo "Error formatting $file: $result"
		fi
	fi
done
echo "All files formatted successfully!"
