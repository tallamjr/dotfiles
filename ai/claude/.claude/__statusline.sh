#!/bin/bash

# Message-based Claude Code statusline tracking
# Focuses on message count and usage patterns rather than time-based estimates
# Format: 💻 Model | 💬 X/225 msgs | ⏳ Xh XXm until reset | 💾 XXk ctx | ✔ directory (branch) ::

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

# Format model name
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
    model_name=$(echo "$model_display" | sed 's/Claude //')
fi

model_str="💻 $model_name"

# Session and timing
session_id=$(echo "$input" | jq -r '.session_id')
current_time=$(date +%s)

# Message-based tracking
if command -v sqlite3 >/dev/null 2>&1 && [ -f "$DB_PATH" ]; then
    # Get or create rate limit window
    rate_limit_info=$(sqlite3 "$DB_PATH" "SELECT usage_start_time, last_reset_time FROM rate_limit_state WHERE id = 1;" 2>/dev/null)

    if [ -z "$rate_limit_info" ]; then
        sqlite3 "$DB_PATH" "INSERT OR REPLACE INTO rate_limit_state (id, usage_start_time, last_reset_time, is_active) VALUES (1, $current_time, $current_time, 1);" 2>/dev/null
        usage_start=$current_time
    else
        usage_start=$(echo "$rate_limit_info" | cut -d'|' -f1)

        # Check if 5-hour window has passed (reset counter)
        time_since_start=$((current_time - usage_start))
        if [ $time_since_start -ge 18000 ]; then
            # Reset the window and message counter
            sqlite3 "$DB_PATH" "
                UPDATE rate_limit_state SET usage_start_time = $current_time, last_reset_time = $current_time WHERE id = 1;
                DELETE FROM message_tracking WHERE window_start < $current_time - 18000;
            " 2>/dev/null
            usage_start=$current_time
            time_since_start=0
        fi
    fi

    # Count messages in current 5-hour window
    message_count=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM message_tracking WHERE timestamp >= $usage_start;" 2>/dev/null || echo "0")

    # Increment message count for this interaction
    sqlite3 "$DB_PATH" "INSERT INTO message_tracking (session_id, window_start, timestamp, message_type) VALUES ('$session_id', $usage_start, $current_time, 'user_prompt');" 2>/dev/null

    message_count=$((message_count + 1))
else
    # Fallback without database
    message_count="?"
    time_since_start=0
fi

# Estimate message limit based on plan (rough approximation)
# Most users are on 5x plan (225 messages per 5 hours)
message_limit=225
if [ "$message_count" != "?" ]; then
    if [ $message_count -ge 900 ]; then
        # Likely 20x plan
        message_limit=900
    fi
fi

# Message usage indicator
if [ "$message_count" = "?" ]; then
    message_str="💬 ? msgs"
else
    usage_pct=$((message_count * 100 / message_limit))
    if [ $usage_pct -ge 90 ]; then
        message_str="💬 ${message_count}/${message_limit} msgs ⚠️"
    elif [ $usage_pct -ge 75 ]; then
        message_str="💬 ${message_count}/${message_limit} msgs ⚡"
    else
        message_str="💬 ${message_count}/${message_limit} msgs"
    fi
fi

# Time until reset (still useful information)
remaining_seconds=$((18000 - time_since_start))
if [ $remaining_seconds -lt 0 ]; then
    remaining_seconds=0
fi

remaining_hours=$((remaining_seconds / 3600))
remaining_minutes=$(((remaining_seconds % 3600) / 60))

if [ $remaining_seconds -eq 0 ]; then
    timer_str="⏳ Reset now"
else
    if [ $remaining_hours -gt 0 ]; then
        timer_str="⏳ ${remaining_hours}h ${remaining_minutes}m until reset"
    else
        timer_str="⏳ ${remaining_minutes}m until reset"
    fi
fi

# Context information - show actual usage instead of remaining
context_used=$(echo "$input" | jq -r '.context.usage.input_tokens // 0' 2>/dev/null || echo "0")
context_limit=$(echo "$input" | jq -r '.context.limit // 200000' 2>/dev/null || echo "200000")

# If context data isn't available, show a simpler indicator
if [ "$context_used" = "0" ] && [ "$context_limit" = "200000" ]; then
    # No real context data available, use message count as proxy
    if [ "$message_count" != "?" ]; then
        context_usage_pct=$((message_count * 100 / message_limit))
        context_str="💾 ~${context_usage_pct}% ctx"
    else
        context_str="💾 ctx"
    fi
else
    # Real context data available
    context_used_k=$((context_used / 1000))
    context_limit_k=$((context_limit / 1000))
    context_usage_pct=$((context_used * 100 / context_limit))
    context_str="💾 ${context_used_k}k/${context_limit_k}k ctx (${context_usage_pct}%)"
fi

# Directory and git info
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
dir_name=$(basename "$cwd")

git_info=""
if command -v git >/dev/null 2>&1 && git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    git_status=$(git -C "$cwd" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    branch_name=$(git -C "$cwd" branch --show-current 2>/dev/null)

    if [ "$git_status" -eq 0 ]; then
        git_info=" ($branch_name)"
    else
        git_info=" ($branch_name*)"
    fi
fi

status="✔"

# Message-focused statusline
printf "%s | %s | %s | %s | %s %s%s ::" "$model_str" "$message_str" "$timer_str" "$context_str" "$status" "$dir_name" "$git_info"
