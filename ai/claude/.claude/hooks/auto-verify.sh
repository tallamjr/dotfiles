#!/bin/bash

# Auto-verification hook for Claude Code
# Triggers verification agent when meaningful work has been completed

set -euo pipefail

# Read JSON input from stdin
input_data=$(cat)

# Extract session info (optional, for logging/debugging)
session_id=$(echo "$input_data" | jq -r '.session_id // ""')
hook_event=$(echo "$input_data" | jq -r '.hook_event_name // ""')
stop_hook_active=$(echo "$input_data" | jq -r '.stop_hook_active // false')

# Prevent infinite loops - if verification is already running, allow stopping
if [ "$stop_hook_active" = "true" ]; then
    exit 0
fi

# Check if meaningful work with todo completion was done by looking for:
# 1. Weighted todo completion scores via session tracking file
# 2. Minimum threshold of weighted completion score before triggering verification

work_completed=false
todo_completion_file="/tmp/claude_todo_completions_$$"

# Check for existing completion tracking file with weighted scores
completion_score=0
if [ -f "$todo_completion_file" ]; then
    completion_score=$(cat "$todo_completion_file" 2>/dev/null || echo "0")
fi

# Trigger verification based on weighted score thresholds:
# - Score 10+: Major feature/implementation completed
# - Score 8+: Multiple medium tasks or one major + minor tasks
# - Score 6+: Several minor tasks completed
if [ "$completion_score" -ge 8 ]; then
    work_completed=true
    echo "Todo completion score: $completion_score (threshold: 8+)" >&2
    # Clean up the tracking file
    rm -f "$todo_completion_file" 2>/dev/null
fi

# Fallback: if we can't detect todo completions from session data,
# check for substantial recent commits as backup
if [ "$work_completed" = "false" ] && [ "$completion_score" -eq 0 ]; then
    if command -v git >/dev/null 2>&1 && git rev-parse --git-dir >/dev/null 2>&1; then
        recent_commit_msg=$(git log -1 --pretty=format:"%s" 2>/dev/null || echo "")
        if [[ "$recent_commit_msg" =~ ^(feat|fix|refactor|perf).*: ]] && [[ ${#recent_commit_msg} -gt 50 ]]; then
            # Check if it's a substantial commit (more than 20 lines changed)
            changed_lines=$(git diff HEAD~1 --numstat 2>/dev/null | awk '{sum += $1 + $2} END {print sum+0}')
            if [ "$changed_lines" -gt 20 ]; then
                work_completed=true
            fi
        fi
    fi
fi

# If meaningful work was completed, trigger verification
if [ "$work_completed" = "true" ]; then
    echo "Detected completed work. Verification required before stopping." >&2
    echo "Use the verification-agent to validate the completed implementation against all requirements. Ensure all stated requirements are fully met, code follows project standards, tests pass, and no regressions were introduced." >&2

    # Exit code 2 blocks stopping and feeds stderr to Claude
    exit 2
fi

# No meaningful work detected, allow normal stopping
exit 0
