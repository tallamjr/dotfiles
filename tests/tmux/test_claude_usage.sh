#!/usr/bin/env bash
# Integration tests for tmux/tmux-claude-usage/bin/tmux-claude-usage.sh.
#
# The renderer reads ~/.cache/claude-usage.json (produced by statusline.sh)
# and prints a single line for the tmux status bar. These tests pin down:
#
#   1. The "no data" path when the cache is absent.
#   2. Percentage + time-remaining formatting from a realistic cache.
#   3. Honest freshness: staleness is derived from five_hour_observed_at,
#      not the file mtime, so timer-tick writes do not mask a silent
#      producer. Stale output surfaces the age in minutes.
#   4. Cache without five_hour_observed_at (legacy format) falls back to
#      file mtime so the renderer still works against old producers.
#   5. Window-reset rendering: when resets_at has passed, show "reset".
set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
repo_root="$( cd "$script_dir/../.." && pwd )"
renderer="$repo_root/tmux/tmux-claude-usage/bin/tmux-claude-usage.sh"

if [[ ! -x "$renderer" ]]; then
  echo "tmux-claude-usage.sh not found or not executable at $renderer" >&2
  exit 1
fi

sandbox="$(mktemp -d)"
trap 'rm -rf "$sandbox"' EXIT
mkdir -p "$sandbox/.cache"
cache="$sandbox/.cache/claude-usage.json"

render() {
  env HOME="$sandbox" "$renderer"
}

assert_contains() {
  local haystack="$1" needle="$2" msg="$3"
  if [[ "$haystack" != *"$needle"* ]]; then
    echo "FAIL: $msg"
    echo "  needle:   <$needle>"
    echo "  haystack: <$haystack>"
    exit 1
  fi
  echo "PASS: $msg"
}

assert_not_contains() {
  local haystack="$1" needle="$2" msg="$3"
  if [[ "$haystack" == *"$needle"* ]]; then
    echo "FAIL: $msg"
    echo "  unwanted needle found: <$needle>"
    echo "  haystack:              <$haystack>"
    exit 1
  fi
  echo "PASS: $msg"
}

touch_mtime() {
  # $1 = path, $2 = epoch seconds
  local ts="$2"
  if command -v gtouch >/dev/null 2>&1; then
    gtouch -d "@$ts" "$1"
  elif touch -d "@$ts" "$1" >/dev/null 2>&1; then
    :
  else
    # BSD touch: -t takes [[CC]YY]MMDDhhmm[.SS] local time
    local stamp
    stamp=$(date -r "$ts" +%Y%m%d%H%M.%S)
    touch -t "$stamp" "$1"
  fi
}

echo "--- Scenario 1: missing cache renders no-data placeholder ---"
out="$(render)"
assert_contains "$out" "no data" "missing cache shows no-data"

echo
echo "--- Scenario 2: fresh cache renders pct + time remaining without stale marker ---"
now=$(date +%s)
reset_future=$(( now + 2 * 3600 + 15 * 60 ))
cat > "$cache" <<EOF
{
  "ts": $now,
  "five_hour": { "used_percentage": 23, "resets_at": $reset_future },
  "five_hour_observed_at": $now,
  "cost_usd": 1.23, "ctx_pct": 45, "model": "Opus 4.7"
}
EOF
out="$(render)"
assert_contains "$out" "23%" "fresh cache shows pct"
assert_contains "$out" "2h15m" "fresh cache shows time remaining"
assert_not_contains "$out" "old" "fresh cache does NOT show stale marker"

echo
echo "--- Scenario 3: stale observed_at (file touched recently) still flagged stale ---"
now=$(date +%s)
observed=$(( now - 600 ))  # 10 minutes ago
reset_future=$(( now + 3600 ))
cat > "$cache" <<EOF
{
  "ts": $now,
  "five_hour": { "used_percentage": 23, "resets_at": $reset_future },
  "five_hour_observed_at": $observed,
  "cost_usd": 1.23, "ctx_pct": 45, "model": "Opus 4.7"
}
EOF
# Touch the file to "now" to simulate a timer-tick write that did not
# actually refresh rate_limits. The old behaviour (mtime-based) would
# treat this as fresh; the new behaviour must detect staleness from
# five_hour_observed_at.
touch_mtime "$cache" "$now"
out="$(render)"
assert_contains "$out" "23%" "stale cache still shows last-known pct"
assert_contains "$out" "10m old" "stale cache surfaces age in minutes"

echo
echo "--- Scenario 4: legacy cache without five_hour_observed_at falls back to file mtime ---"
now=$(date +%s)
old_mtime=$(( now - 400 ))  # ~6-7 minutes ago
reset_future=$(( now + 3600 ))
cat > "$cache" <<EOF
{
  "ts": $old_mtime,
  "five_hour": { "used_percentage": 23, "resets_at": $reset_future },
  "cost_usd": 1.23, "ctx_pct": 45, "model": "Opus 4.7"
}
EOF
touch_mtime "$cache" "$old_mtime"
out="$(render)"
assert_contains "$out" "23%" "legacy cache still renders pct"
assert_contains "$out" "m old" "legacy cache falls back to mtime for age"

echo
echo "--- Scenario 5b: float observed_at (jq 'now' output) does not crash renderer ---"
# Regression: jq's now() returns a float like 1776720740.584486, and the
# renderer must not try to subtract that in bash arithmetic. Reproduces
# the "blank statusline" bug seen when observed_at came through as a float.
now=$(date +%s)
reset_future=$(( now + 3600 ))
observed_float="${now}.584486"
cat > "$cache" <<EOF
{
  "ts": ${now}.123456,
  "five_hour": { "used_percentage": 16, "resets_at": $reset_future },
  "five_hour_observed_at": $observed_float,
  "cost_usd": 3.48, "ctx_pct": 9, "model": "Opus 4.7"
}
EOF
out="$(render 2>&1)"
rc=$?
if (( rc != 0 )); then
  echo "FAIL: float observed_at caused renderer to exit $rc"
  echo "  output: <$out>"
  exit 1
fi
echo "PASS: float observed_at does not crash renderer"
assert_contains "$out" "16%" "float observed_at still renders pct"
assert_not_contains "$out" "error" "float observed_at produces no error"

echo
echo "--- Scenario 6: resets_at in the past shows 'reset' ---"
now=$(date +%s)
reset_past=$(( now - 300 ))
cat > "$cache" <<EOF
{
  "ts": $now,
  "five_hour": { "used_percentage": 23, "resets_at": $reset_past },
  "five_hour_observed_at": $now,
  "cost_usd": 1.23, "ctx_pct": 45, "model": "Opus 4.7"
}
EOF
out="$(render)"
assert_contains "$out" "reset" "passed resets_at shows reset marker"

echo
echo "All tests passed."
