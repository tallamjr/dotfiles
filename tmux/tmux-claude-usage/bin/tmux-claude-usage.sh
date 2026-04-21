#!/usr/bin/env bash
# Tmux status renderer for Claude Code's current (5-hour) usage window.
# Reads ~/.cache/claude-usage.json produced by ~/.claude/statusline.sh and
# prints "PCT% · HhMMm" — the used percentage of the 5-hour rate-limit
# window and the time remaining until it resets.
set -euo pipefail

cache="$HOME/.cache/claude-usage.json"

if [[ ! -f "$cache" ]]; then
  printf ' ✽ no data'
  exit 0
fi

now=$(date +%s)

# Prefer five_hour_observed_at: the moment the producer last accepted a
# real rate_limits reading. File mtime also advances on timer-tick writes
# that replay stale data, so mtime-based staleness hides a silent producer.
# Fall back to mtime for legacy caches written before observation tracking.
observed=$(jq -r '.five_hour_observed_at // empty' "$cache")
if [[ -z "$observed" ]]; then
  # Portable mtime: GNU stat (-c %Y) first, BSD/macOS stat (-f %m) fallback.
  # The probe relies on BSD stat rejecting -c, so the chosen branch matches
  # the actual implementation on PATH rather than the host OS.
  if stat -c %Y "$cache" >/dev/null 2>&1; then
    observed=$(stat -c %Y "$cache")
  else
    observed=$(stat -f %m "$cache")
  fi
fi
# Defensive: tolerate fractional seconds from older producer caches (jq "now"
# historically emitted floats like 1776720740.58). Bash arithmetic is integer
# only, so strip any trailing ".xxx" — integer inputs are unchanged.
observed=${observed%.*}
age=$(( now - observed ))

pct=$(jq -r '.five_hour.used_percentage // empty' "$cache")
reset=$(jq -r '.five_hour.resets_at       // empty' "$cache")

# rate_limits only appears in the JSON after the first API response of a
# Pro/Max session — absence is expected, not an error.
if [[ -z "$pct" ]]; then
  printf ' ✽ awaiting first API call'
  exit 0
fi

if [[ -z "$reset" ]]; then
  left='-'
else
  secs=$(( reset - now ))
  if (( secs < 0 )); then
    left='reset'
  else
    left=$(printf '%dh%02dm' $(( secs / 3600 )) $(( (secs % 3600) / 60 )))
  fi
fi

# 180s = three missed 60s refreshInterval ticks — a clear silence signal
# rather than jitter. Surface the concrete age so the reader can calibrate
# their trust instead of getting a binary (stale) badge.
stale=''
if (( age > 180 )); then
  mins=$(( age / 60 ))
  stale=$(printf ' (%dm old)' "$mins")
fi

# jq emits percentages like "23.5" — strip trailing decimal for a tight string.
printf ' ✽ %s%% · %s%s' "${pct%.*}" "$left" "$stale"
