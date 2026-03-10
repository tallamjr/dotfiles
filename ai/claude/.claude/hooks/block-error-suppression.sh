#!/bin/bash
# block-error-suppression.sh
# PreToolUse hook: denies Bash commands that use error-suppression patterns.
# Patterns caught: || true, || :, set +e
#
# If a command legitimately needs one of these patterns, the user should
# approve it manually rather than having Claude generate it silently.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# Check for || true or || : (with optional whitespace)
if echo "$COMMAND" | grep -qE '\|\|\s*(true|:)\s*(;|$|&&|\|)'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Error suppression pattern detected (|| true or || :). Handle errors explicitly instead of silencing them."
    }
  }'
  exit 0
fi

# Check for set +e used to disable errexit
if echo "$COMMAND" | grep -qE '(^|\s|;)set\s+\+e(\s|;|$)'; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "Error suppression pattern detected (set +e). Do not disable errexit; handle errors explicitly."
    }
  }'
  exit 0
fi

exit 0
