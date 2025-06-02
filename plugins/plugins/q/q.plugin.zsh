# First, create a real 'q' function as a fallback
q() {
    echo "Error: 'q' should be used with the AI command replacement system."
    echo "Usage: q \"your request\" or command | q \"your request\""
    return 1
}

# Enhanced ZLE widget that handles more complex cases
ai_replace_command() {
    # More comprehensive regex to catch q anywhere in the command
    if [[ $BUFFER =~ "(^|[[:space:]|&;])q[[:space:]]+(['\"])[^'\"]*\2" ]]; then
		echo $query > ~/dotfiles/debug.log

        # Show processing feedback
        echo "\n🤖"
        
        local system_prompt="You are a shell command generator. Your job is to convert natural language requests into executable shell commands.

RULES:
1. Output ONLY the shell command, nothing else
2. No explanations, no markdown, no backticks
3. No 'Here is the command:' or similar phrases
4. The command must be ready to execute as-is
5. Replace the entire 'q \"...\"' part with the appropriate command
6. Preserve any other parts of the command line (like variable assignments, pipes, etc.)

CONTEXT: The input may contain complex shell syntax like variable assignments, pipes, or command chaining. Your job is to replace just the 'q \"...\"' part while keeping everything else intact.

EXAMPLES:
Input: q \"list files sorted by date\"
Output: ls -lt

Input: ls -la | q \"sort by size\"
Output: ls -la | sort -k5 -n

Input: export A=\"hello\"; q \"echo the A variable\"
Output: export A=\"hello\"; echo \$A

Input: q \"start nginx docker container\" && echo \"done\"
Output: docker run -d -p 80:80 nginx && echo \"done\"

Now process this input:"

        local ai_cmd=$(echo $BUFFER | openrouter-cli run mistralai/devstral-small --system="$system_prompt" --no-thinking-stdout)
        
        # Add original command to history for reference
        print -s "$original_buffer"
        
        # Replace the buffer with the AI-generated command
        BUFFER="$ai_cmd"
        CURSOR=$#BUFFER
        
        # Redraw the line with new prompt
        zle reset-prompt
    else
        # If no q command, execute normally
        zle accept-line
    fi
}

# Create ZLE widget and bind to Enter
zle -N ai_replace_command
bindkey '^M' ai_replace_command