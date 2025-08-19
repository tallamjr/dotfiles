#!/bin/bash

# Todo completion tracker for Claude Code
# Runs after TodoWrite tool usage to track completed todos

set -euo pipefail

# Read JSON input from stdin
input_data=$(cat)

# Extract session info
session_id=$(echo "$input_data" | jq -r '.session_id // ""')
tool_name=$(echo "$input_data" | jq -r '.tool_name // ""')

# Only process TodoWrite tool usage
if [ "$tool_name" != "TodoWrite" ]; then
    exit 0
fi

# Create tracking file based on session ID (or fallback to process ID)
if [ -n "$session_id" ]; then
    tracking_file="/tmp/claude_todo_completions_${session_id}"
else
    tracking_file="/tmp/claude_todo_completions_$$"
fi

# Analyze completed todos and assign weighted scores
completed_todos=$(echo "$input_data" | jq -r '.tool_parameters.todos[]? | select(.status == "completed") | .content' 2>/dev/null || echo "")

if [ -n "$completed_todos" ]; then
    # Calculate weighted score based on todo significance
    weighted_score=0
    completion_count=0

    while IFS= read -r todo_content; do
        if [ -n "$todo_content" ]; then
            completion_count=$((completion_count + 1))

            # Major todo indicators (weight: 5 points each)
            if echo "$todo_content" | grep -qiE "(implement|create|build|design|refactor|optimize|fix.*bug|add.*feature|complete.*integration|deploy|release)"; then
                weighted_score=$((weighted_score + 5))
            # Medium significance indicators (weight: 3 points each)
            elif echo "$todo_content" | grep -qiE "(update|modify|enhance|improve|configure|setup|install|test.*integration|validate)"; then
                weighted_score=$((weighted_score + 3))
            # Minor tasks (weight: 1 point each)
            else
                weighted_score=$((weighted_score + 1))
            fi

            # Bonus for lengthy/detailed todos (likely more significant)
            if [ ${#todo_content} -gt 80 ]; then
                weighted_score=$((weighted_score + 2))
            fi
        fi
    done <<< "$completed_todos"

    if [ "$weighted_score" -gt 0 ]; then
        # Read existing score
        existing_score=0
        if [ -f "$tracking_file" ]; then
            existing_score=$(cat "$tracking_file" 2>/dev/null || echo "0")
        fi

        # Add new weighted score
        total_score=$((existing_score + weighted_score))
        echo "$total_score" > "$tracking_file"

        # Log significant completions
        if [ "$weighted_score" -ge 5 ]; then
            echo "Significant todo completion detected (score: $weighted_score, total: $total_score)" >&2
        fi
    fi
fi

exit 0
