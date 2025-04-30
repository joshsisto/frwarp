# frwarp

# frwarp

A command-line AI helper that brings LLM-powered assistance directly to your terminal.

[![asciicast](https://asciinema.org/a/717384.svg)](https://asciinema.org/a/717384)

## Overview

frwarp (free warp) is a command-line utility that integrates AI assistance into your bash workflow. Inspired by [Warp](https://www.warp.dev/), it leverages [Simon Willison's LLM tool](https://github.com/simonw/llm) to provide intelligent bash command suggestions, error troubleshooting, and command fixes directly in your terminal.

## Features

- **AI Command Helper (`ai`)**: Get concise bash commands for any task
- **Command Fix Helper (`h fix`)**: Troubleshoot and fix failed commands
- **Command AI Enhancement (`h ai`)**: Enhance your last command with AI assistance

## Requirements

- Ubuntu or compatible Linux distribution
- [Simon Willison's LLM tool](https://github.com/simonw/llm)
- An API key from [OpenRouter](https://openrouter.ai/)

## Installation

1. Install the LLM tool:

```bash
pip install llm
```

2. Set up your OpenRouter API key:

```bash
llm keys set openrouter
# Enter your API key when prompted
```

3. Copy the functions from the provided `.bashrc` file into your own `.bashrc`:

```bash
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

# Create the alias 'ai' that calls the function defined above
alias ai='_ai_bash_helper_func'

# Function to handle various history modifications
function h() {
    case "$1" in
        ai)
            # This uses your existing auto_llm function instead of ai
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
```

4. Source your `.bashrc` to activate the functions:

```bash
source ~/.bashrc
```

## Usage

### AI Command Helper

Get AI-powered bash command suggestions:

```bash
ai 'find all large files in the current directory'
```

### Fix Failed Commands

When a command fails, use the fix helper to get suggestions:

```bash
ls -la /nonexistent_directory
# Command fails
h fix
# AI will suggest a fix
```

### Enhance Last Command with AI

Use the AI to enhance or modify your last command:

```bash
grep "error" log.txt
h ai
# AI will enhance the last command
```

## How It Works

The script operates by:

1. **Defining a Base Prompt**: Each function includes a carefully crafted instruction prompt that tells the LLM to respond as a bash expert, providing concise commands and minimal explanations.

2. **Capturing User Input**: The `ai` command takes your query and combines it with the instruction prompt.

3. **Accessing Command History**: The `h` function accesses your command history using `history -p !!` to retrieve the last executed command.

4. **LLM Integration**: Commands are sent to the configured LLM using Simon Willison's `llm` CLI tool.

## Customization

You can customize the base prompts in the functions to tailor the AI's responses to your needs.

## Credits

- Inspired by [Warp](https://www.warp.dev/)
- Built using [Simon Willison's LLM tool](https://github.com/simonw/llm)
- Powered by [OpenRouter](https://openrouter.ai/)
