# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="mm/dd/yyyy"

_source_if_exists() {
	if [ -f "$1" ]; then
		source "$1"
	fi
}

_eval_if_exists() {
	if command -v "$1" >/dev/null 2>&1; then
		eval "$("$1" ${@:2})"
	fi
}

_add_to_path_if_exists() {
	if [ -d "$1" ]; then
		export PATH="$PATH:$1"
		return 0
	fi

	return 1
}

# fnm
if _add_to_path_if_exists "/home/$(whoami)/.local/share/fnm"; then
	eval "$(fnm env)"
fi

# Add laravel bins
if _add_to_path_if_exists "/home/alpha/.config/herd-lite/bin"; then
	export PHP_INI_SCAN_DIR="/home/alpha/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
fi

_add_to_path_if_exists "/usr/local/go/bin"
_add_to_path_if_exists "/home/$(whoami)/go/bin"
_add_to_path_if_exists "/home/$(whoami)/.local/bin"
_add_to_path_if_exists "/home/$(whoami)/bin"

# Add deno completions to search path
if [[ ":$FPATH:" != *":/home/$(whoami)/.zsh/completions:"* ]]; then
	export FPATH="/home/$(whoami)/.zsh/completions:$FPATH"
fi

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

plugins=(git eza git-auto-fetch)

zstyle ':omz:plugins:*' aliases no
zstyle ':omz:lib:directories' aliases no

# ---
# Load Oh-My-Zsh
# ---
source $ZSH/oh-my-zsh.sh

if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
	export BROWSER="/mnt/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe"
fi

_eval_if_exists zoxide init zsh --cmd cd
_eval_if_exists oh-my-posh init zsh --config ~/plugins/oh-my-posh/theme.omp.json

# source ~/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/plugins/q/q.plugin.zsh
source ~/plugins/dotfiles-update-check/dotfiles-update-check.plugin.zsh
source ~/plugins/windows-path-fallback/windows-path-fallback.plugin.zsh
source ~/.config/zshrc/fzf-tab.zsh
source ~/.config/zshrc/eza.zsh
source ~/.zsh/extend/aliases.zsh
source ~/.zsh/extend/functions.zsh

_source_if_exists ~/.env
_source_if_exists "/home/$(whoami)/.deno/env"

eval "$(atuin init zsh)"

ZSH_AUTOSUGGEST_STRATEGY=(atuin)

_source_if_exists $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

bindkey '^[[Z' autosuggest-accept

# Tab completer. First, expand aliases, then complete commands, then ignore
zstyle ':completion:*' completer _expand_alias _complete _ignored
zstyle ':completion:*:*:*:*:*' ignored-patterns '*.so' '*.so.*' '*.dylib' '*.a' '_*' '-*'

zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' sort false
zstyle ':completion:*' group-order aliases functions commands builtins

export SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color? [y/n/a/e] "
