#compdef osh

_osh() {
	local context state line

	_arguments \
		'1:command:->commands' \
		'*::arg:->args'

	case $state in
	commands)
		local commands=(
			'add:Add a package to dotfiles'
			'update:Update dotfiles (git pull, packages, stow)'
			'install:Install packages from Brew and uv'
			'stow:Stow dotfiles configurations'
			'check-updates:Check if updates are available (silent)'
			'help:Show help message'
		)
		_describe 'osh commands' commands
		;;
	args)
		case $line[1] in
		add)
			if [[ $CURRENT -eq 2 ]]; then
				# First argument after 'add' - repository type
				local repo_types=(
					'brew:Install via Homebrew'
					# 'node:Install via npm globally'
					'python:Install via uv tool'
					'uv:Install via uv tool'
				)
				_describe 'repository types' repo_types
				# Also allow direct package names for interactive mode
				_message 'package name (for interactive mode)'
			elif [[ $CURRENT -eq 3 ]]; then
				# Second argument - package name
				_message 'package name'
			fi
			;;
		help | check-updates)
			# No arguments for help or check-updates
			;;
		update)
			# No arguments for update
			;;
		install)
			# No arguments for update
			;;
		stow)
			# No arguments for update
			;;
		esac
		;;
	esac
}

_osh
