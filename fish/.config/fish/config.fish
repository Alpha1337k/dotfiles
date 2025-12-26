
# Check Fish version
if test (printf '%s\n' $FISH_VERSION "4.2.1" | sort -V | head -n1) != "4.2.1"
	echo "Warning: Fish shell version $FISH_VERSION is below 4.2.1"
end


function _add_to_path_if_exists
	if test -d "$argv[1]"
		set -gx PATH $PATH $argv[1]
		return 0
	end

	return 1
end

function _source_if_exists
	if test -f "$argv[1]"
		source "$argv[1]"
	end
end

function _eval_if_exists
	if type -q "$argv[1]"
		eval ("$argv[1]" $argv[2..-1])
	end
end

_add_to_path_if_exists "/usr/local/go/bin"
_add_to_path_if_exists "/home/"(whoami)"/go/bin"
_add_to_path_if_exists "/home/"(whoami)"/.local/bin"
_add_to_path_if_exists "/home/"(whoami)"/bin"

# _source_if_exists ~/.env

# fnm
if _add_to_path_if_exists "/home/"(whoami)"/.local/share/fnm"
	eval (fnm env)
end

# Add laravel bins
if _add_to_path_if_exists "/home/alpha/.config/herd-lite/bin"
	export PHP_INI_SCAN_DIR="/home/alpha/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
end

if test -f /proc/sys/fs/binfmt_misc/WSLInterop
	set -gx BROWSER '/mnt/c/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe'
end

set fish_greeting ""

# /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
function _setup_brew
	set --global --export HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew";
	set --global --export HOMEBREW_CELLAR "/home/linuxbrew/.linuxbrew/Cellar";
	set --global --export HOMEBREW_REPOSITORY "/home/linuxbrew/.linuxbrew/Homebrew";
	fish_add_path --global --append --path "/home/linuxbrew/.linuxbrew/bin" "/home/linuxbrew/.linuxbrew/sbin";
	if test -n "$MANPATH[1]"; set --global --export MANPATH '' $MANPATH; end;
	if not contains "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH; set --global --export INFOPATH "/home/linuxbrew/.linuxbrew/share/info" $INFOPATH; end;

	if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
	end

	if test -d (brew --prefix)"/share/fish/vendor_completions.d"
		set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
	end
end

_setup_brew

if status is-interactive
	zoxide init fish --cmd cd | source
	oh-my-posh init fish --config ~/.config/oh-my-posh/theme.omp.json | source
	atuin init fish | source
end

function fish_user_key_bindings
	bind \cr 'commandline -r -- $history[1]'
end
