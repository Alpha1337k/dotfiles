#compdef osh

_osh() {
    local context state line
    
    _arguments \
        '1:command:->commands' \
        '*::arg:->args'
    
    case $state in
        commands)
            local commands=(
                'update:Update dotfiles (git pull, packages, stow)'
                'check-updates:Check if updates are available (silent)'
                'help:Show help message'
            )
            _describe 'osh commands' commands
            ;;
        args)
            case $line[1] in
                help|check-updates)
                    # No arguments for help or check-updates
                    ;;
                update)
                    # No arguments for update
                    ;;
            esac
            ;;
    esac
}

_osh