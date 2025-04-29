# Function to prepend instructions and call the llm command
_ai_bash_helper_func() {
  # Check if a query was provided
  if [ $# -eq 0 ]; then
    # Print usage instructions to standard error
    echo "Usage: ai_bash_helper <your query about a bash command or task>" >&2
    return 1 # Return a non-zero status to indicate an error
  fi

  # Combine all arguments provided by the user into a single string
  local user_query="$*"

  # Define the base prompt with instructions for the LLM
  local base_prompt="You are a bash expert on Ubuntu. Help with troubleshooting when given an error. Give concise commands only. Don't explain unless asked. For explanations, use brief bullet points. One command solution when possible. No pleasantries."

  # Construct the full prompt by combining the base prompt and the user's query
  local full_prompt="${base_prompt} ${user_query}"

  # Execute the existing 'llm' command with the full, combined prompt
  # Ensure the full prompt is quoted to handle spaces and special characters correctly
  llm "${full_prompt}"
}

# Create the alias 'ai_bash_helper' that calls the function defined above
alias ai='_ai_bash_helper_func'

# Function to handle various history modifications
function h() {
    case "$1" in
        ai)
            # This line uses your existing auto_llm function instead of ai
            auto_llm $(history -p !!)
            ;;
        fix)
            llm "You are a bash expert on Ubuntu. Give concise commands only. Don't explain unless asked. For explanations, use brief bullet points. One command solution when possible. No pleasantries. Fix this failed command: '$(history -p !!)'"
            ;;
        *)
            echo "Usage: h ai (add auto_llm to last command) | h fix (get suggestion to fix last command)"
            ;;
    esac
}
