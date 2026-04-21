#!/usr/bin/env bash
# Integration tests for tmux/tmux-battery/bin/battery on Darwin.
#
# The script's Darwin branch greps ioreg(8) output for battery state. At
# 100% charge macOS reports "FullyCharged" = "Yes", and the production
# code had an early `exit` in that branch that aborted before printing
# the percentage. These tests pin down the two behaviours that matter:
#
#   1. A normal partial charge with ExternalConnected=Yes prints "NN%".
#   2. A full charge with FullyCharged=Yes STILL prints "100%" — the
#      regression the user observed was an empty string in this case.
#
# ioreg is stubbed via a PATH shim so the test is deterministic and
# independent of the real battery state.
set -euo pipefail

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
repo_root="$( cd "$script_dir/../.." && pwd )"
battery="$repo_root/tmux/tmux-battery/bin/battery"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "SKIP: this test targets the Darwin branch of battery"
  exit 0
fi

if [[ ! -x "$battery" ]]; then
  echo "battery script not found or not executable at $battery" >&2
  exit 1
fi

sandbox="$(mktemp -d)"
trap 'rm -rf "$sandbox"' EXIT

write_ioreg_stub() {
  # $1 = body to emit when ioreg is invoked
  local body="$1"
  cat > "$sandbox/ioreg" <<EOF
#!/bin/sh
cat <<'IOREG_EOF'
$body
IOREG_EOF
EOF
  chmod +x "$sandbox/ioreg"
}

run_battery() {
  # Prepend sandbox to PATH so our stub ioreg wins over /usr/sbin/ioreg.
  PATH="$sandbox:$PATH" "$battery" "$1"
}

assert_eq() {
  local got="$1" expected="$2" msg="$3"
  if [[ "$got" != "$expected" ]]; then
    echo "FAIL: $msg"
    echo "  expected: <$expected>"
    echo "  got:      <$got>"
    exit 1
  fi
  echo "PASS: $msg"
}

echo "--- Scenario 1: partial charge (73%), plugged in — prints 73% ---"
write_ioreg_stub '    "CurrentCapacity" = 73
    "MaxCapacity" = 100
    "ExternalConnected" = Yes
    "FullyCharged" = No'
out="$(run_battery Charging)"
assert_eq "$out" "73%" "partial charge prints percentage"

echo
echo "--- Scenario 2: fully charged (100%), plugged in — must still print 100% ---"
write_ioreg_stub '    "CurrentCapacity" = 100
    "MaxCapacity" = 100
    "ExternalConnected" = Yes
    "FullyCharged" = Yes'
out="$(run_battery Charging)"
assert_eq "$out" "100%" "fully-charged battery prints 100% (was empty before fix)"

echo
echo "--- Scenario 3: discharging (62%), unplugged — prints 62% for Discharging ---"
write_ioreg_stub '    "CurrentCapacity" = 62
    "MaxCapacity" = 100
    "ExternalConnected" = No
    "FullyCharged" = No'
out="$(run_battery Discharging)"
assert_eq "$out" "62%" "discharging battery prints percentage"

echo
echo "--- Scenario 4: mismatched state (asking Discharging while plugged in) — silent ---"
write_ioreg_stub '    "CurrentCapacity" = 55
    "MaxCapacity" = 100
    "ExternalConnected" = Yes
    "FullyCharged" = No'
out="$(run_battery Discharging)"
assert_eq "$out" "" "mismatched state prints nothing"

echo
echo "All tests passed."
