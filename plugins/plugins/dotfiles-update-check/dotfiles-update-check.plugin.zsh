# Dotfiles update checker
# Checks for updates on shell startup, with week-long cache

_osh_check_for_updates() {
    local cache_file="$HOME/.cache/osh-update-check"
    local cache_dir="$(dirname "$cache_file")"
    
    # Create cache directory if it doesn't exist
    [[ ! -d "$cache_dir" ]] && mkdir -p "$cache_dir"
    
    # Check if we should skip (cache exists and is less than 7 days old)
    if [[ -f "$cache_file" ]]; then
        local cache_age=$(( $(date +%s) - $(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0) ))
        local week_in_seconds=604800  # 7 days * 24 hours * 60 minutes * 60 seconds
        
        if (( cache_age < week_in_seconds )); then
            return 0  # Skip check, cache is fresh
        fi
    fi
    
    # Check for updates silently
    if osh check-updates 2>/dev/null; then
        echo "🔄 Dotfiles updates are available!"
        echo -n "Would you like to update now? (y/N): "
        read -r response
        
        case "$response" in
            [yY]|[yY][eE][sS])
                echo "Updating dotfiles..."
                osh update
                ;;
            *)
                echo "Skipping update. You can run 'osh update' later."
                ;;
        esac
    fi
    
    # Update cache file regardless of whether updates were found
    touch "$cache_file"
}

# Run the check in background to avoid blocking shell startup
_osh_check_for_updates &!