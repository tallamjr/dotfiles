#!/usr/bin/env bash
# Silent data bridge: reads Claude Code's statusLine JSON on stdin and
# writes the subset we care about to ~/.cache/claude-usage.json so that
# tmux (and other consumers) can render it independently. Prints nothing,
# so Claude Code's own bottom bar stays empty — display lives in tmux.
#
# Claude Code invokes this script once per turn (debounced ~300ms) and,
# with refreshInterval set in settings.json, additionally on a timer.
#
# Consumer: ~/tmux-claude-usage/bin/tmux-claude-usage.sh
set -euo pipefail

input=$(cat)

if ! command -v jq >/dev/null 2>&1; then
  # Without jq we cannot parse the JSON. Exit cleanly so Claude Code shows
  # nothing; a missing cache file is an explicit, detectable signal for the
  # tmux consumer, which is preferable to writing malformed data.
  exit 0
fi

mkdir -p "$HOME/.cache"
cache_tmp="$HOME/.cache/claude-usage.json.tmp.$$"
cache_final="$HOME/.cache/claude-usage.json"

if [[ -f "$cache_final" ]]; then
  prev=$(cat "$cache_final")
else
  prev='{}'
fi

# Merge rules (see tests/ai/claude/test_statusline.sh):
#   - Payloads without rate_limits must not wipe prior values (timer ticks).
#   - used_percentage is monotonic within a window; a lower value with the
#     same resets_at is a stale session and is rejected.
#   - A new window (resets_at advanced) is always accepted.
#   - *_observed_at advance only when the bucket is accepted, so consumers
#     can render honest freshness.
if echo "$input" | jq --argjson prev "$prev" '
  def pick($new; $old):
    if $new == null then
      { value: $old, accepted: false }
    elif $old == null
         or (($new.resets_at // 0) > ($old.resets_at // 0))
         or ((($new.resets_at // 0) == ($old.resets_at // 0))
             and (($new.used_percentage // 0) >= ($old.used_percentage // 0))) then
      { value: $new, accepted: true }
    else
      { value: $old, accepted: false }
    end;

  # Epoch timestamps are written as integers (jq "now" returns a float);
  # consumers do bash integer arithmetic on these fields.
  (now | floor) as $nowi
  | . as $new
  | pick($new.rate_limits.five_hour // null; $prev.five_hour // null) as $five
  | pick($new.rate_limits.seven_day // null; $prev.seven_day // null) as $seven
  | {
      ts:                    $nowi,
      five_hour:             $five.value,
      seven_day:             $seven.value,
      five_hour_observed_at: (if $five.accepted  then $nowi else ($prev.five_hour_observed_at  // null) end),
      seven_day_observed_at: (if $seven.accepted then $nowi else ($prev.seven_day_observed_at // null) end),
      cost_usd:              ($new.cost.total_cost_usd            // 0),
      ctx_pct:               ($new.context_window.used_percentage // 0),
      model:                 ($new.model.display_name             // "claude")
    }
' > "$cache_tmp"; then
  # Atomic swap so the reader never sees a torn file.
  mv "$cache_tmp" "$cache_final"
else
  # jq failed — do not leave a half-written temp file around, and keep
  # the previous cache intact. This is conditional cleanup, not error
  # suppression: the failure mode is surfaced via a stale `ts` field.
  rm -f "$cache_tmp"
fi

# ── Visible status line for Claude Code's bottom bar ─────────────────────────
# 1. Current working directory (basename only; the full path is rarely
#    needed and would crowd out the other fields).
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
dir_name=$(basename "$cwd" 2>/dev/null || true)
if [ -z "$dir_name" ]; then
  dir_name="~"
fi

# 2. Model name
model=$(echo "$input" | jq -r '.model.display_name // "claude"')

# 3. Context remaining: use pre-calculated field, fall back to 100 - used_pct,
#    fall back to "--" when neither is available (no messages yet).
ctx_remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
if [ -z "$ctx_remaining" ]; then
  ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
  if [ -n "$ctx_used" ]; then
    ctx_remaining=$(printf '%.0f' "$(echo "$ctx_used" | awk '{print 100 - $1}')")
  else
    ctx_remaining="--"
  fi
else
  ctx_remaining=$(printf '%.0f' "$ctx_remaining")
fi

# 4. Rate limits (Pro/Max only; each bucket may be independently absent).
five_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

rate_parts=""
if [ -n "$five_used" ]; then
  five_left=$(printf '%.0f' "$(echo "$five_used" | awk '{print 100 - $1}')")
  rate_parts="5h: ${five_left}% left"
fi
if [ -n "$week_used" ]; then
  week_left=$(printf '%.0f' "$(echo "$week_used" | awk '{print 100 - $1}')")
  if [ -n "$rate_parts" ]; then
    rate_parts="${rate_parts} | wk: ${week_left}% left"
  else
    rate_parts="wk: ${week_left}% left"
  fi
fi

# Assemble the line: always show dir + model + context; append rate limits when present.
if [ -n "$rate_parts" ]; then
  printf '%s  |  %s  |  %s%% ctx left  |  %s\n' "$dir_name" "$model" "$ctx_remaining" "$rate_parts"
else
  printf '%s  |  %s  |  %s%% ctx left\n' "$dir_name" "$model" "$ctx_remaining"
fi
