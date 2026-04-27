---
user-invocable: false
description: Verify a KiCad 10+ IPC connection and list open documents via kicad-ctlrs
---

# KiCad Connect

Auto-loaded when working with KiCad and the user wants to verify the IPC
connection or inspect which documents KiCad has open.

## Prerequisites

- KiCad 10 or later is running
- `kicad-ctlrs` is on PATH (installed via `rust/install-rust-with-crates.sh`)

## Commands

All operations go through `kicad-ctlrs connect …`. Run
`kicad-ctlrs connect --help` for the authoritative flag reference.

### Operations

- Report KiCad version, API version, and connection status:
  `kicad-ctlrs connect info`
- List currently open documents in KiCad:
  `kicad-ctlrs connect docs`

JSON output is the default; pipe through `jq` or pass `--output human` for
a formatted rendering.

## Error handling

- `kicad-not-running` (exit 2): instruct the user to launch KiCad 10+;
  do not retry blindly. The error envelope includes `details.socket_uri`,
  which is useful when the user has set `KICAD_API_SOCKET` to a non-default
  path.
- `kicad-version-mismatch` (exit 4): KiCad is running but its IPC API
  version does not match what `kicad-ctlrs` was built against. Ask the
  user to upgrade KiCad or rebuild `kicad-ctlrs`.
