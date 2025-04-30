# Function to prepend instructions and call the llm command
_ai_bash_helper_func() {
  # Check if a query was provided
  if [ $# -eq 0 ]; then
    # Print usage instructions to standard error
    echo "Usage: ai <your query about a bash command or task>" >&2
    return 1 # Return a non-zero status to indicate an error
  fi

  # Define the base prompt with instructions for the LLM
  local base_prompt="You are a bash expert on Ubuntu. Help with troubleshooting when given an error. Give concise commands only. Don't explain unless asked. For explanations, use brief bullet points. One command solution when possible. No pleasantries."

  # Use the llm with a system prompt and pass all arguments as the prompt
  # The system prompt is set using -s flag, and the actual prompt is everything the user typed
  llm -s "$base_prompt" "$*"
}

# Create the alias 'ai' that calls the function defined above
alias ai='_ai_bash_helper_func'

# Function to handle various history modifications
function h() {
    case "$1" in
        ai)
            # This line uses your existing auto_llm function instead of ai
            auto_llm $(history -p !!)
            ;;
        fix)
            llm -s "You are a bash expert on Ubuntu. Give concise commands only. Don't explain unless asked. For explanations, use brief bullet points. One command solution when possible. No pleasantries." "Fix this failed command: '$(history -p !!)'"
            ;;
        *)
            echo "Usage: h ai (add auto_llm to last command) | h fix (get suggestion to fix last command)"
            ;;
    esac
}
