#!/usr/bin/env bash
# Integration tests for ai/claude/.claude/statusline.sh.
#
# The producer receives Claude Code's statusLine JSON on stdin and maintains
# ~/.cache/claude-usage.json for tmux to display. These tests pin down the
# merge semantics that protect the cache from three real failure modes:
#
#   1. Timer-tick invocations carrying no rate_limits must not wipe the
#      previously-observed five_hour/seven_day values.
#   2. Concurrent sessions can deliver older rate_limits after newer ones;
#      a lower used_percentage within the same window must be rejected so
#      the cache is monotonic per-window.
#   3. A genuine window rollover (resets_at advances) must be accepted even
#      when the new used_percentage is lower.
#
# Tests sandbox HOME via mktemp so the real user cache is never touched.
set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
repo_root="$( cd "$script_dir/../../.." && pwd )"
statusline="$repo_root/ai/claude/.claude/statusline.sh"

if [[ ! -x "$statusline" ]]; then
  echo "statusline.sh not found or not executable at $statusline" >&2
  exit 1
fi

sandbox="$(mktemp -d)"
trap 'rm -rf "$sandbox"' EXIT
cache="$sandbox/.cache/claude-usage.json"

invoke() {
  printf '%s' "$1" | env HOME="$sandbox" "$statusline"
}

read_field() {
  jq -r "$1" "$cache"
}

assert_eq() {
  local got="$1" expected="$2" msg="$3"
  if [[ "$got" != "$expected" ]]; then
    echo "FAIL: $msg"
    echo "  expected: $expected"
    echo "  got:      $got"
    exit 1
  fi
  echo "PASS: $msg"
}

assert_nonempty() {
  local got="$1" msg="$2"
  if [[ -z "$got" || "$got" == "null" ]]; then
    echo "FAIL: $msg"
    echo "  got: <$got>"
    exit 1
  fi
  echo "PASS: $msg"
}

json_full='{
  "rate_limits": {
    "five_hour": { "used_percentage": 23, "resets_at": 1800000000 },
    "seven_day": { "used_percentage": 8,  "resets_at": 1800500000 }
  },
  "cost":           { "total_cost_usd": 1.23 },
  "context_window": { "used_percentage": 45 },
  "model":          { "display_name": "Opus 4.7" }
}'

json_no_rate_limits='{
  "cost":           { "total_cost_usd": 1.50 },
  "context_window": { "used_percentage": 52 },
  "model":          { "display_name": "Opus 4.7" }
}'

json_lower_pct_same_window='{
  "rate_limits": {
    "five_hour": { "used_percentage": 19, "resets_at": 1800000000 }
  },
  "cost":           { "total_cost_usd": 1.40 },
  "context_window": { "used_percentage": 48 },
  "model":          { "display_name": "Opus 4.7" }
}'

json_higher_pct_same_window='{
  "rate_limits": {
    "five_hour": { "used_percentage": 41, "resets_at": 1800000000 }
  },
  "cost":           { "total_cost_usd": 2.10 },
  "context_window": { "used_percentage": 60 },
  "model":          { "display_name": "Opus 4.7" }
}'

json_new_window='{
  "rate_limits": {
    "five_hour": { "used_percentage": 5, "resets_at": 1800018000 }
  },
  "cost":           { "total_cost_usd": 0.05 },
  "context_window": { "used_percentage": 12 },
  "model":          { "display_name": "Opus 4.7" }
}'

echo "--- Scenario 1: initial full payload populates cache ---"
invoke "$json_full"
assert_eq "$(read_field '.five_hour.used_percentage')" "23" \
  "initial payload writes five_hour.used_percentage"
assert_eq "$(read_field '.five_hour.resets_at')" "1800000000" \
  "initial payload writes five_hour.resets_at"
assert_eq "$(read_field '.seven_day.used_percentage')" "8" \
  "initial payload writes seven_day.used_percentage"
cost_initial="$(read_field '.cost_usd')"
if [[ "$cost_initial" != "1.23" ]]; then
  echo "FAIL: initial payload writes cost_usd"
  echo "  expected: 1.23"
  echo "  got:      $cost_initial"
  exit 1
fi
echo "PASS: initial payload writes cost_usd"
first_observed="$(read_field '.five_hour_observed_at')"
assert_nonempty "$first_observed" \
  "initial payload sets five_hour_observed_at"

echo
echo "--- Scenario 2: timer tick without rate_limits preserves previous values ---"
sleep 1
invoke "$json_no_rate_limits"
assert_eq "$(read_field '.five_hour.used_percentage')" "23" \
  "null rate_limits does NOT wipe five_hour.used_percentage"
assert_eq "$(read_field '.five_hour.resets_at')" "1800000000" \
  "null rate_limits does NOT wipe five_hour.resets_at"
assert_eq "$(read_field '.seven_day.used_percentage')" "8" \
  "null rate_limits does NOT wipe seven_day"
assert_eq "$(read_field '.cost_usd')" "1.50" \
  "null rate_limits DOES refresh cost_usd"
assert_eq "$(read_field '.ctx_pct')" "52" \
  "null rate_limits DOES refresh ctx_pct"
assert_eq "$(read_field '.five_hour_observed_at')" "$first_observed" \
  "null rate_limits does NOT advance five_hour_observed_at"

echo
echo "--- Scenario 3: stale session delivering lower pct in same window is rejected ---"
sleep 1
invoke "$json_lower_pct_same_window"
assert_eq "$(read_field '.five_hour.used_percentage')" "23" \
  "lower pct in same window is rejected"
assert_eq "$(read_field '.five_hour_observed_at')" "$first_observed" \
  "rejected payload does NOT advance five_hour_observed_at"

echo
echo "--- Scenario 4: higher pct in same window is accepted and advances observed_at ---"
sleep 1
invoke "$json_higher_pct_same_window"
assert_eq "$(read_field '.five_hour.used_percentage')" "41" \
  "higher pct in same window is accepted"
second_observed="$(read_field '.five_hour_observed_at')"
if [[ "$second_observed" == "$first_observed" ]]; then
  echo "FAIL: accepted payload must advance five_hour_observed_at"
  echo "  first:  $first_observed"
  echo "  second: $second_observed"
  exit 1
fi
echo "PASS: accepted payload advances five_hour_observed_at"

echo
echo "--- Scenario 5: new window (advanced resets_at) accepts any pct ---"
sleep 1
invoke "$json_new_window"
assert_eq "$(read_field '.five_hour.used_percentage')" "5" \
  "new window accepts lower pct"
assert_eq "$(read_field '.five_hour.resets_at')" "1800018000" \
  "new window updates resets_at"
third_observed="$(read_field '.five_hour_observed_at')"
if [[ "$third_observed" == "$second_observed" ]]; then
  echo "FAIL: new-window acceptance must advance five_hour_observed_at"
  exit 1
fi
echo "PASS: new window advances five_hour_observed_at"

echo
echo "All tests passed."
