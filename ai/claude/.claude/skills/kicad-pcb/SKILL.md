---
user-invocable: false
description: Inspect and modify a running KiCad 10+ board (footprints, nets, tracks, vias, zones, pads, selection) via kicad-ctlrs. Includes footprint move/rotate/flip, track + via creation, and DRC marker injection.
---

# KiCad PCB Operations

Auto-loaded when working with a `.kicad_pcb` file and the user wants to
inspect or modify board content interactively. Requires a running KiCad 10+
instance with the target board open in the PCB editor.

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

### Footprint mutations

Each mutation appears as a single named entry in KiCad's undo stack
(`kicad-ctlrs: <op> <ref> …`) so the user can review and undo individually.

- Move a footprint:
  `kicad-ctlrs pcb footprints move U1 --x 10 --y 20`
  - Optional `--layer F.Cu` or `--layer B.Cu` to also place on a specific layer
- Rotate a footprint to an absolute angle:
  `kicad-ctlrs pcb footprints rotate U1 --angle 90`
- Flip a footprint between top and bottom copper:
  `kicad-ctlrs pcb footprints flip U1`
  (Only defined for footprints currently on F.Cu or B.Cu.)

### Track and via creation

Both create operations require the named net and named layers to already
exist on the board. We do NOT auto-create nets — pass an existing one.

- Create a track segment:
  `kicad-ctlrs pcb tracks create --start 0,0 --end 10,0 --layer F.Cu --width 0.2 --net GND`
- Create a via:
  `kicad-ctlrs pcb vias create --at 5,5 --from-layer F.Cu --to-layer B.Cu --net GND`
  - Optional `--size 0.6 --drill 0.3` (defaults shown)

Coordinates and lengths are millimetres by default. Pass `--units nm`
globally for raw nanometres.

### DRC marker injection

- Inject a DRC marker:
  `kicad-ctlrs pcb drc inject --message "manual marker" --at 5,5 --severity warning`
  - `--severity` accepts `warning`, `error`, or `exclusion` (default `error`)

### Custom undo-stack messages

Pass `--commit-msg "your text"` globally on any mutation to override the
auto-generated KiCad undo entry text.

## Error handling

- `kicad-not-running` (exit 2): ask the user to launch KiCad 10+ and open
  the board; do not retry blindly.
- `kicad-no-document` (exit 3): KiCad is running but no board is open.
- `not-found` (exit 5): the referenced footprint, net, or layer is not
  present. For mutations, the error envelope `details` shows what was
  requested. Re-query the corresponding `list` command to confirm what
  is available.
- `invalid-argument` (exit 6): malformed coordinates or an unsupported
  flip target (e.g. flipping a footprint that is not on F.Cu or B.Cu).
