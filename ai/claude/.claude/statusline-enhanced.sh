#!/bin/bash

# Enhanced Claude Code statusline matching screenshot format with SQLite persistence
# Format: 💻 Model | 💰 $X.XX today | ⏳ Xh XXm left | 💾 XXk ctx | ✔ directory (branch) ::
# Rate limits reset every 5 hours based on usage, not arbitrary time intervals
# Persistent metrics stored in ~/.claude/metrics.db across all sessions
# Timer persistence ensures consistent countdown across sessions
# Context display shows remaining context window capacity
# Make script executable: chmod +x ~/.claude/statusline-enhanced.sh

# Database configuration
DB_PATH="$HOME/.claude/metrics.db"

# Initialize database if it doesn't exist
if [ ! -f "$DB_PATH" ]; then
    "$HOME/.claude/metrics-init.sh" >/dev/null 2>&1
fi

# Read JSON input
input=$(cat)

# Get model information
model_display=$(echo "$input" | jq -r '.model.display_name // "Claude"')
model_id=$(echo "$input" | jq -r '.model.id // ""')

# Format model name for display
if [[ "$model_id" == *"sonnet"* ]]; then
    if [[ "$model_id" == *"claude-sonnet-4"* ]]; then
        model_name="Sonnet 4"
    else
        model_name="Sonnet 3.5"
    fi
elif [[ "$model_id" == *"opus"* ]]; then
    model_name="Opus 4.1"
elif [[ "$model_id" == *"haiku"* ]]; then
    model_name="Haiku 3.5"
else
    # Fallback to display name
    model_name=$(echo "$model_display" | sed 's/Claude //')
fi

# Model indicator with computer emoji
model_str="💻 $model_name"

# Persistent timer logic using database
session_id=$(echo "$input" | jq -r '.session_id')
current_time=$(date +%s)

# Initialize and manage persistent rate limit timer
if command -v sqlite3 >/dev/null 2>&1 && [ -f "$DB_PATH" ]; then
    # Get current rate limit state
    rate_limit_info=$(sqlite3 "$DB_PATH" "SELECT usage_start_time, last_reset_time FROM rate_limit_state WHERE id = 1;" 2>/dev/null)

    if [ -z "$rate_limit_info" ]; then
        # Initialize if doesn't exist
        sqlite3 "$DB_PATH" "INSERT OR REPLACE INTO rate_limit_state (id, usage_start_time, last_reset_time, is_active) VALUES (1, $current_time, $current_time, 1);" 2>/dev/null
        usage_start=$current_time
    else
        usage_start=$(echo "$rate_limit_info" | cut -d'|' -f1)
        last_reset=$(echo "$rate_limit_info" | cut -d'|' -f2)

        # Check if we need to reset the timer (5 hour window passed)
        time_since_start=$((current_time - usage_start))
        if [ $time_since_start -ge 18000 ]; then
            # Reset the timer
            sqlite3 "$DB_PATH" "UPDATE rate_limit_state SET usage_start_time = $current_time, last_reset_time = $current_time WHERE id = 1;" 2>/dev/null
            usage_start=$current_time
        fi
    fi

    # Update last activity time
    sqlite3 "$DB_PATH" "UPDATE rate_limit_state SET last_reset_time = $current_time WHERE id = 1;" 2>/dev/null
else
    # Fallback to file-based method
    usage_start_file="/tmp/claude_usage_start_global"
    if [ ! -f "$usage_start_file" ]; then
        echo $current_time > "$usage_start_file"
    fi
    usage_start=$(cat "$usage_start_file" 2>/dev/null || echo $current_time)
fi

usage_duration=$((current_time - usage_start))

# Calculate remaining time in 5-hour window (18000 seconds)
remaining_seconds=$((18000 - usage_duration))
if [ $remaining_seconds -lt 0 ]; then
    remaining_seconds=0
fi

remaining_hours=$((remaining_seconds / 3600))
remaining_minutes=$(((remaining_seconds % 3600) / 60))

# Format countdown timer
if [ $remaining_seconds -eq 0 ]; then
    timer_str="⏳ Reset available"
else
    if [ $remaining_hours -gt 0 ]; then
        timer_str="⏳ ${remaining_hours}h ${remaining_minutes}m left"
    else
        timer_str="⏳ ${remaining_minutes}m left"
    fi
fi

# Cost estimation based on model and usage duration
# Rough approximation for demonstration (would need actual API data for precision)
usage_minutes=$((usage_duration / 60))
if [[ "$model_name" == "Opus"* ]]; then
    # Opus is more expensive
    session_cost=$(echo "scale=2; $usage_minutes * 0.05" | bc 2>/dev/null || echo "0.50")
elif [[ "$model_name" == "Sonnet"* ]]; then
    # Sonnet mid-tier pricing
    session_cost=$(echo "scale=2; $usage_minutes * 0.02" | bc 2>/dev/null || echo "0.20")
else
    # Haiku or other models
    session_cost=$(echo "scale=2; $usage_minutes * 0.01" | bc 2>/dev/null || echo "0.10")
fi

# Ensure we have a reasonable minimum
if (( $(echo "$session_cost < 0.01" | bc -l 2>/dev/null || echo "1") )); then
    session_cost="0.01"
fi

# Extract context information from input
context_used=$(echo "$input" | jq -r '.context.usage.input_tokens // 0' 2>/dev/null || echo "0")
context_limit=$(echo "$input" | jq -r '.context.limit // 200000' 2>/dev/null || echo "200000")

# Calculate remaining context in a readable format
context_remaining=$((context_limit - context_used))
if [ $context_remaining -lt 0 ]; then
    context_remaining=0
fi

# Format context display (show in thousands for readability)
context_remaining_k=$((context_remaining / 1000))
if [ $context_remaining_k -gt 999 ]; then
    context_display="${context_remaining_k}k"
elif [ $context_remaining_k -gt 0 ]; then
    context_display="${context_remaining_k}k"
else
    context_display="0k"
fi

context_str="💾 ${context_display} ctx"

# Database operations for persistent metrics
daily_total_cost="$session_cost"  # fallback if database fails
if command -v sqlite3 >/dev/null 2>&1 && [ -f "$DB_PATH" ]; then
    # Update session record with context information
    sqlite3 "$DB_PATH" "
        INSERT OR REPLACE INTO sessions (session_id, model_id, model_name, start_time, last_seen, estimated_cost, rate_limit_start, context_used, context_limit)
        VALUES ('$session_id', '$model_id', '$model_name', $usage_start, $current_time, $session_cost, $usage_start, $context_used, $context_limit);

        -- Update daily metrics
        INSERT OR IGNORE INTO daily_metrics (date, total_cost, total_minutes, session_count)
        VALUES (date('now'), 0.0, 0, 0);

        -- Calculate totals for today from all sessions
        UPDATE daily_metrics SET
            total_cost = (SELECT COALESCE(SUM(estimated_cost), 0) FROM sessions
                         WHERE date(last_seen, 'unixepoch') = date('now')),
            total_minutes = (SELECT COALESCE(SUM((last_seen - start_time)/60), 0) FROM sessions
                           WHERE date(last_seen, 'unixepoch') = date('now')),
            session_count = (SELECT COUNT(DISTINCT session_id) FROM sessions
                           WHERE date(last_seen, 'unixepoch') = date('now'))
        WHERE date = date('now');
    " 2>/dev/null

    # Get daily total cost from database
    daily_total_cost=$(sqlite3 "$DB_PATH" "SELECT PRINTF('%.2f', total_cost) FROM daily_metrics WHERE date = date('now');" 2>/dev/null || echo "$session_cost")
fi

# Format cost with money bag emoji showing daily total across all sessions
cost_str="💰 \$${daily_total_cost} today"

# Success indicator in green
status="✔"

# Get current working directory
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
dir_name=$(basename "$cwd")

# Git information
git_info=""
if command -v git >/dev/null 2>&1 && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_status=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    branch_name=$(git -C "$cwd" branch --show-current 2>/dev/null)

    if [ "$git_status" -eq 0 ]; then
        # Clean repo
        git_info=" ($branch_name)"
    else
        # Dirty repo - add indicator
        git_info=" ($branch_name*)"
    fi
fi

# Combine all elements in screenshot format with context display
printf "%s | %s | %s | %s | %s %s%s ::" "$model_str" "$cost_str" "$timer_str" "$context_str" "$status" "$dir_name" "$git_info"
