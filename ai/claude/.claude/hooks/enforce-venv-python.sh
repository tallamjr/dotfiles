#!/bin/bash
# enforce-venv-python.sh
# PreToolUse hook: denies Bash commands that use bare python/python3/pip/pytest
# when a .venv directory exists in the project root.
#
# This ensures Claude always uses the project-local virtual environment
# rather than system Python. Commands using `uv run` are exempt since
# uv handles virtualenv resolution itself.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Skip if using uv run (uv manages its own venv resolution)
if echo "$COMMAND" | grep -qE '(^|\s|;|&&|\|)uv\s+run\s'; then
  exit 0
fi

# Skip if the command already references .venv explicitly
if echo "$COMMAND" | grep -qF '.venv/'; then
  exit 0
fi

# Determine the project directory from the hook environment
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Check if .venv exists in the project root
if [ ! -d "$PROJECT_DIR/.venv" ]; then
  exit 0
fi

# Check for bare python/python3/pip/pip3/pytest commands
# Match at start of command, after semicolons, after && or ||, after pipes, or after $()
if echo "$COMMAND" | grep -qE '(^|;|&&|\|\||\||\$\()\s*(python3?|pip3?|pytest|mypy|ruff|black|isort)\s'; then
  VENV_PATH="$PROJECT_DIR/.venv/bin"
  jq -n --arg venv_path "$VENV_PATH" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: ("A .venv directory exists in this project. Use " + $venv_path + "/python (or the appropriate .venv/bin/ binary) instead of bare python/pip/pytest commands.")
    }
  }'
  exit 0
fi

exit 0
