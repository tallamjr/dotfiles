---
user-invocable: false
description: Export KiCad 10+ PCB manufacturing files (Gerbers, drill, STEP, pick-and-place, PDF/SVG/DXF/ODB++) via kicad-ctlrs
---

# KiCad Export Operations

Auto-loaded when the user wants to generate manufacturing or documentation
outputs from a `.kicad_pcb` file. Unlike the other KiCad skills, export
operations are file-based and **do not require a running KiCad instance**
— they shell out to KiCad's bundled `kicad-cli`.

## Prerequisites

- KiCad 10 or later installed (provides `kicad-cli`). On macOS, kicad-ctlrs
  also looks under `/Applications/KiCad/KiCad.app/Contents/MacOS/kicad-cli`
  if `kicad-cli` is not on PATH.
- `kicad-ctlrs` is on PATH
- A `.kicad_pcb` file path the caller provides

## Commands

All operations go through `kicad-ctlrs export …`. Run
`kicad-ctlrs export --help` for the authoritative flag reference.

### Operations

- Export Gerbers:             `kicad-ctlrs export gerbers --board board.kicad_pcb --out out/`
  - Optional `--layers F.Cu,B.Cu,F.SilkS,B.SilkS` etc.
- Export drill files:         `kicad-ctlrs export drill --board board.kicad_pcb --out out/`
  - Optional `--format excellon|gerber` (default `excellon`)
- Export 3D STEP model:       `kicad-ctlrs export step --board board.kicad_pcb --out board.step`
  - Optional `--force` to overwrite an existing file
- Export pick-and-place CSV:  `kicad-ctlrs export pos --board board.kicad_pcb --out pos.csv`
  - Optional `--format csv|ascii|gerber` (default `csv`)
  - Optional `--side front|back|both` (default `both`) — uses KiCad's `front`/`back` terminology, not `top`/`bottom`
- Export PDF:                 `kicad-ctlrs export pdf --board board.kicad_pcb --out out/`
- Export SVG:                 `kicad-ctlrs export svg --board board.kicad_pcb --out svg/`
- Export DXF:                 `kicad-ctlrs export dxf --board board.kicad_pcb --out dxf/`
- Export ODB++ archive:       `kicad-ctlrs export odb --board board.kicad_pcb --out odb/`

## Error handling

- `io-error` (exit 9): the `--board` path does not exist, or the output
  directory cannot be created. The error envelope's `details.path` shows
  exactly which path failed.
- `kicad-cli-failed` (exit 8): `kicad-cli` exited non-zero. The error
  envelope's `details.stderr` and `details.stdout` contain the subprocess
  output — use those to diagnose.

## Non-guarantees

Partial outputs are NOT rolled back. If `kicad-cli` writes two Gerber
files and then fails, those two files remain on disk. The error envelope
is authoritative; the user decides whether to clean up.
