---
user-invocable: false
description: Inspect a running KiCad 10+ board (footprints, nets, tracks, vias, zones, pads, selection) and inject DRC markers via kicad-ctlrs
---

# KiCad PCB Operations

Auto-loaded when working with a `.kicad_pcb` file and the user wants to
inspect board content interactively (requires a running KiCad instance
with the board open) or inject a DRC marker.

## Prerequisites

- KiCad 10 or later is running with the target board open in the PCB editor
- `kicad-ctlrs` is on PATH

## Commands

All operations go through `kicad-ctlrs pcb …`. Run
`kicad-ctlrs pcb --help` for the full, authoritative flag reference.

### Read operations

- Board metadata:                `kicad-ctlrs pcb info`
- List footprints:               `kicad-ctlrs pcb footprints list`
- Filter footprints (glob):      `kicad-ctlrs pcb footprints list --filter 'U*'`
- Get one footprint detail:      `kicad-ctlrs pcb footprints get U1`
- List nets:                     `kicad-ctlrs pcb nets list`
- Get one net detail:            `kicad-ctlrs pcb nets get GND`
- List tracks:                   `kicad-ctlrs pcb tracks list`
- Filter tracks by net:          `kicad-ctlrs pcb tracks list --net GND`
- List vias:                     `kicad-ctlrs pcb vias list`
- List zones:                    `kicad-ctlrs pcb zones list`
- List pads:                     `kicad-ctlrs pcb pads list`
- Filter pads by footprint:      `kicad-ctlrs pcb pads list --footprint U1`
- Inspect the GUI selection:     `kicad-ctlrs pcb selection get`

### Mutations

Only one mutation is supported in v0:

- Inject a DRC marker:
  `kicad-ctlrs pcb drc inject --message "manual marker" --at 5,5 --severity warning`
  - `--severity` accepts `warning`, `error`, or `exclusion` (default `error`)
  - `--at` is `X,Y` in millimetres; pass `--units nm` globally for nanometres

## Why footprint and track mutations are unavailable

The kicad-ipc-rs crate at v0.4.3 keeps the proto types needed for
`update_items` / `create_items` in `pub(crate)` modules, so footprint
move/rotate/flip and track/via creation are not implementable from
outside the crate. This is documented in the kicad-ctlrs design spec.
The commands return cleanly to v1 if upstream exposes ergonomic helpers.

## Error handling

- `kicad-not-running` (exit 2): ask the user to launch KiCad 10+ and open
  the board; do not retry blindly.
- `kicad-no-document` (exit 3): KiCad is running but no board is open.
- `not-found` (exit 5): the referenced footprint or net is not present.
  Re-query `kicad-ctlrs pcb footprints list` to confirm available references.
