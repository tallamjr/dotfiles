#!/bin/bash

# Cleanup old Claude Code metrics data
# Usage: ./metrics-cleanup.sh [days_to_keep]

DB_PATH="$HOME/.claude/metrics.db"
DAYS_TO_KEEP=${1:-90}  # Default: keep 90 days

if [ ! -f "$DB_PATH" ]; then
    echo "Metrics database not found."
    exit 1
fi

echo "Cleaning up metrics older than $DAYS_TO_KEEP days..."

# Count records before cleanup
old_sessions=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM sessions WHERE date(last_seen, 'unixepoch') < date('now', '-$DAYS_TO_KEEP days');")
old_daily=$(sqlite3 "$DB_PATH" "SELECT COUNT(*) FROM daily_metrics WHERE date < date('now', '-$DAYS_TO_KEEP days');")

if [ "$old_sessions" -eq 0 ] && [ "$old_daily" -eq 0 ]; then
    echo "No old records found to clean up."
    exit 0
fi

echo "Found $old_sessions old session records and $old_daily old daily records to remove."

# Perform cleanup
sqlite3 "$DB_PATH" "
    DELETE FROM sessions WHERE date(last_seen, 'unixepoch') < date('now', '-$DAYS_TO_KEEP days');
    DELETE FROM daily_metrics WHERE date < date('now', '-$DAYS_TO_KEEP days');
    VACUUM;
"

echo "Cleanup completed. Database optimized."
