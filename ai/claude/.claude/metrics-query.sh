#!/bin/bash

# Query Claude Code metrics from SQLite database
# Usage: ./metrics-query.sh [today|week|month|sessions|all]

DB_PATH="$HOME/.claude/metrics.db"

if [ ! -f "$DB_PATH" ]; then
    echo "Metrics database not found. Run a Claude Code session first to initialize."
    exit 1
fi

command=${1:-today}

case "$command" in
    "today")
        echo "=== Today's Usage ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                date,
                PRINTF('\$%.2f', total_cost) as cost,
                total_minutes as minutes,
                session_count as sessions
            FROM daily_metrics
            WHERE date = date('now');
        "

        echo -e "\n=== Active Sessions Today ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                session_id,
                model_name,
                datetime(start_time, 'unixepoch', 'localtime') as started,
                PRINTF('%.2f', estimated_cost) as cost,
                PRINTF('%.0fk/%.0fk', COALESCE(context_used,0)/1000.0, COALESCE(context_limit,200000)/1000.0) as context
            FROM sessions
            WHERE date(last_seen, 'unixepoch') = date('now')
            ORDER BY start_time DESC;
        "
        ;;

    "week")
        echo "=== Last 7 Days ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                date,
                PRINTF('\$%.2f', total_cost) as cost,
                total_minutes as minutes,
                session_count as sessions
            FROM daily_metrics
            WHERE date >= date('now', '-7 days')
            ORDER BY date DESC;
        "
        ;;

    "month")
        echo "=== Last 30 Days ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                date,
                PRINTF('\$%.2f', total_cost) as cost,
                total_minutes as minutes,
                session_count as sessions
            FROM daily_metrics
            WHERE date >= date('now', '-30 days')
            ORDER BY date DESC;
        "

        echo -e "\n=== Monthly Summary ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                COUNT(*) as days_active,
                PRINTF('\$%.2f', SUM(total_cost)) as total_cost,
                SUM(total_minutes) as total_minutes,
                SUM(session_count) as total_sessions
            FROM daily_metrics
            WHERE date >= date('now', '-30 days') AND total_cost > 0;
        "
        ;;

    "sessions")
        echo "=== Recent Sessions (Last 10) ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                session_id,
                model_name,
                datetime(start_time, 'unixepoch', 'localtime') as started,
                datetime(last_seen, 'unixepoch', 'localtime') as last_active,
                PRINTF('%.2f', estimated_cost) as cost,
                PRINTF('%.0fk/%.0fk', COALESCE(context_used,0)/1000.0, COALESCE(context_limit,200000)/1000.0) as context
            FROM sessions
            ORDER BY last_seen DESC
            LIMIT 10;
        "
        ;;

    "all")
        echo "=== All-Time Summary ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                COUNT(*) as total_days,
                PRINTF('\$%.2f', SUM(total_cost)) as total_cost,
                SUM(total_minutes) as total_minutes,
                SUM(session_count) as total_sessions
            FROM daily_metrics
            WHERE total_cost > 0;
        "

        echo -e "\n=== Model Usage ==="
        sqlite3 "$DB_PATH" -header -column "
            SELECT
                model_name,
                COUNT(*) as sessions,
                PRINTF('\$%.2f', SUM(estimated_cost)) as total_cost
            FROM sessions
            GROUP BY model_name
            ORDER BY SUM(estimated_cost) DESC;
        "
        ;;

    *)
        echo "Usage: $0 [today|week|month|sessions|all]"
        echo ""
        echo "Commands:"
        echo "  today    - Show today's usage and active sessions"
        echo "  week     - Show last 7 days of usage"
        echo "  month    - Show last 30 days and monthly summary"
        echo "  sessions - Show recent sessions"
        echo "  all      - Show all-time summary and model usage"
        exit 1
        ;;
esac
