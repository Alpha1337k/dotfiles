
ai_replace_command() {
    # Match either "| q" or standalone "q" at the beginning
    if [[ $BUFFER =~ '(^|.* \|\s*)q "([^"]*)"' ]]; then
        local base_cmd="${BUFFER%% | q *}"  # This will be empty for standalone q
        local query="$match[2]"  # Note: now match[2] since we have more capture groups
        local original_buffer="$BUFFER"

        # Show processing feedback
        echo "\n🤖"
        
        local system_prompt="You are a shell command generator. Your job is to convert natural language requests into executable shell commands.

RULES:
1. Output ONLY the shell command, nothing else
2. No explanations, no markdown, no backticks
3. No 'Here is the command:' or similar phrases
4. The command must be ready to execute as-is
5. For piped commands, replace the entire '| q \"...\"' part with the appropriate command

INPUT FORMAT:
- Standalone: 'q \"description\"' → output the complete command
- Piped: 'command | q \"description\"' → output 'command | replacement'

EXAMPLES:
Input: q \"list files sorted by date\"
Output: ls -lt

Input: ls -la | q \"sort by size\"
Output: ls -la | sort -k5 -n

Input: q \"start nginx docker container\"
Output: docker run -d -p 80:80 nginx

Now process this input:"

        local ai_cmd=$(echo $BUFFER | openrouter-cli run mistralai/devstral-small --system=$system_prompt --no-thinking-stdout)
                
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
bindkey '^M' ai_replace_command  # Bind to Enter key