# Windows PATH Fallback Plugin
# Separates Windows paths from main PATH and provides fallback mechanism

# Function to separate Windows paths from main PATH
setup_windows_path_fallback() {
    WINDOWS_PATH=""
    CLEAN_PATH=""

    IFS=':' read -rA PATHS <<< "$PATH"

    for path_entry in $PATHS; do
        if [[ "$path_entry" == /mnt/c/* ]]; then
            if [[ -n "$WINDOWS_PATH" ]]; then
                WINDOWS_PATH="$WINDOWS_PATH:$path_entry"
            else
                WINDOWS_PATH="$path_entry"
            fi
        else
            if [[ -n "$CLEAN_PATH" ]]; then
                CLEAN_PATH="$CLEAN_PATH:$path_entry"
            else
                CLEAN_PATH="$path_entry"
            fi
        fi
    done

    # Set clean PATH without Windows paths
    export PATH="$CLEAN_PATH"
}

# Function to try Windows paths as fallback
command_not_found_handler() {
    local cmd="$1"
    if [[ -n "$WINDOWS_PATH" ]]; then
        local old_path="$PATH"
        export PATH="$PATH:$WINDOWS_PATH"
        if command -v "$cmd" >/dev/null 2>&1; then
            "$@"
            local exit_code=$?
            export PATH="$old_path"
            return $exit_code
        else
            export PATH="$old_path"
        fi
    fi
    echo "zsh: command not found: $cmd" >&2
    return 127
}

# Setup the Windows path fallback system
setup_windows_path_fallback