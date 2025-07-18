#!/usr/bin/env bash
set -euo pipefail

add_to_uvfile() {
	local package_name="$1"
	local uvfile="$DOTFILES_DIR/Uvfile"

	if ! grep -q "^$package_name\$" "$uvfile"; then
		echo "$package_name" >> "$uvfile"
		echo "" >> "$uvfile"
		echo "✅ Added $package_name to Uvfile"
	else
		echo "⚠️ $package_name already exists in Uvfile"
	fi
}


add_package() {
	local repo_type="$1"
	local package_name="$2"

	cd "$DOTFILES_DIR"

	case "$repo_type" in
	brew)
		echo "📦 Adding brew package: $package_name"
		brew bundle add "$package_name"
		brew bundle
		;;
	# node)
	#     echo "📦 Adding node package: $package_name"
	#     npm install -g "$package_name"
	#     ;;
	python | uv)
		echo "📦 Adding python tool: $package_name"
		uv tool install "$package_name"
		add_to_uvfile "$package_name"
		;;
	*)
		echo "❌ Error: Unknown repository type '$repo_type'"
		echo "Supported types: brew, node, python, uv"
		exit 1
		;;
	esac

	echo "✅ Package $package_name added successfully!"
}

select_repo_type() {
	local prompt="\
Select package repository
1) brew
2) node
3) python/uv

Enter choice (1-3): "

	read -p "$prompt" choice

	case "$choice" in
	1) echo "brew" ;;
	2) echo "node" ;;
	3) echo "uv" ;;
	*)
		echo "❌ Invalid choice"
		exit 1
		;;
	esac
}

add() {
	if [ -z "${2:-}" ]; then
		echo "❌ Error: Package name required"
		echo "Usage: osh add [brew|node|python|uv] <package>"
		echo "   or: osh add <package> (interactive mode)"
		exit 1
	fi

	if [ -z "${3:-}" ]; then
		# Interactive mode - package name provided but no repo type
		repo_type=$(select_repo_type)
		add_package "$repo_type" "$2"
	else
		# Both repo type and package name provided
		add_package "$2" "$3"
	fi
}