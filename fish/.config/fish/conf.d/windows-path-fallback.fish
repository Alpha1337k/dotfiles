# Windows PATH Fallback Plugin
# Separates Windows paths from main PATH and provides fallback mechanism

# Function to separate Windows paths from main PATH
function setup_windows_path_fallback
    set -gx WINDOWS_PATH ""
    set CLEAN_PATH

    # Split PATH into array
    set PATHS (string split : $PATH)

    for path_entry in $PATHS
        if string match -q "/mnt/c/*" $path_entry
            if test -n "$WINDOWS_PATH"
                set -gx WINDOWS_PATH "$WINDOWS_PATH:$path_entry"
            else
                set -gx WINDOWS_PATH "$path_entry"
            end
        else
            set -a CLEAN_PATH $path_entry
        end
    end

    # Set clean PATH without Windows paths
    set -gx PATH $CLEAN_PATH
end

# Function to try Windows paths as fallback
function fish_command_not_found
    set cmd $argv[1]

    if test -n "$WINDOWS_PATH"
        set old_path $PATH
        set -gx PATH $PATH (string split : $WINDOWS_PATH)

        if command -v $cmd >/dev/null 2>&1
            $argv
            set exit_code $status
            set -gx PATH $old_path
            return $exit_code
        else
            set -gx PATH $old_path
        end
    end

    echo "fish: Unknown command: $cmd" >&2
    return 127
end

# Setup the Windows path fallback system
setup_windows_path_fallback
