#!/bin/bash

# Initialize SQLite database for Claude Code metrics persistence
# Creates database and tables if they don't exist

DB_PATH="$HOME/.claude/metrics.db"

# Create .claude directory if it doesn't exist
mkdir -p "$HOME/.claude"

# Initialize database with required tables
sqlite3 "$DB_PATH" <<'EOF'
-- Sessions tracking table
CREATE TABLE IF NOT EXISTS sessions (
    session_id TEXT PRIMARY KEY,
    model_id TEXT,
    model_name TEXT,
    start_time INTEGER,
    last_seen INTEGER,
    estimated_cost REAL DEFAULT 0,
    rate_limit_start INTEGER,
    context_used INTEGER DEFAULT 0,
    context_limit INTEGER DEFAULT 200000
);

-- Daily aggregated metrics
CREATE TABLE IF NOT EXISTS daily_metrics (
    date TEXT PRIMARY KEY,
    total_cost REAL DEFAULT 0,
    total_minutes INTEGER DEFAULT 0,
    session_count INTEGER DEFAULT 0
);

-- Rate limit timer persistence (global across all sessions)
CREATE TABLE IF NOT EXISTS rate_limit_state (
    id INTEGER PRIMARY KEY DEFAULT 1,
    last_reset_time INTEGER,
    usage_start_time INTEGER,
    is_active BOOLEAN DEFAULT 1
);

-- Message tracking for rate limits (based on actual message count)
CREATE TABLE IF NOT EXISTS message_tracking (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id TEXT,
    window_start INTEGER,
    timestamp INTEGER,
    message_type TEXT DEFAULT 'user_prompt'
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_sessions_last_seen ON sessions(last_seen);
CREATE INDEX IF NOT EXISTS idx_daily_date ON daily_metrics(date);
CREATE INDEX IF NOT EXISTS idx_message_tracking_window ON message_tracking(window_start);

-- Initialize today's entry if it doesn't exist
INSERT OR IGNORE INTO daily_metrics (date, total_cost, total_minutes, session_count)
VALUES (date('now'), 0.0, 0, 0);

-- Initialize rate limit state if it doesn't exist
INSERT OR IGNORE INTO rate_limit_state (id, last_reset_time, usage_start_time, is_active)
VALUES (1, strftime('%s', 'now'), strftime('%s', 'now'), 1);
EOF

echo "Claude metrics database initialized at: $DB_PATH"
