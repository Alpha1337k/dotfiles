# Dotfiles update checker
# Non-blocking approach: check in background, cache results, prompt on next startup

_osh_check_for_updates() {
    local cache_file="$HOME/.cache/osh-update-check"
    local update_available_file="$HOME/.cache/osh-update-available"
    local cache_dir="$(dirname "$cache_file")"
    
    # Create cache directory if it doesn't exist
    [[ ! -d "$cache_dir" ]] && mkdir -p "$cache_dir"
    
    # First, check if we have a pending update notification
    if [[ -f "$update_available_file" ]]; then
        echo "🔄 Dotfiles updates are available!"
        echo -n "Would you like to update now? (y/N): "
        read -r response
        
        case "${response:-n}" in
            [yY]|[yY][eE][sS])
                echo "Updating dotfiles..."
                osh update
                rm -f "$update_available_file"
                touch "$cache_file"
                return 0
                ;;
            *)
                echo "Skipping update. You can run 'osh update' later."
                rm -f "$update_available_file"
                touch "$cache_file"
                return 0
                ;;
        esac
    fi
    
    # Check if we should skip background check (cache exists and is less than 7 days old)
    if [[ -f "$cache_file" ]]; then
        local cache_age=$(( $(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0) ))
        local day_in_seconds=86400  # 1 day * 24 hours * 60 minutes * 60 seconds

        if (( cache_age < day_in_seconds )); then
            return 0  # Skip check, cache is fresh
        fi
    fi
    
    # Run background check for updates (non-blocking)
    (
        if osh check-updates 2>/dev/null; then
            touch "$update_available_file"
        else
            rm -f "$update_available_file"
        fi
        touch "$cache_file"
    ) &!
}

# Run the check
_osh_check_for_updates