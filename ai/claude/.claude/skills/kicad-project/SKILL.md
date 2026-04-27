---
user-invocable: false
description: Query and modify KiCad 10+ project text variables and net classes via kicad-ctlrs
---

# KiCad Project Operations

Auto-loaded when working with KiCad project settings — text variables,
net classes, and the title block.

## Prerequisites

- KiCad 10 or later is running with the project open
- `kicad-ctlrs` is on PATH

## Commands

All operations go through `kicad-ctlrs project …`. Run
`kicad-ctlrs project --help` for the authoritative flag reference.

### Text variables

- List all variables:        `kicad-ctlrs project variables list`
- Get one variable:          `kicad-ctlrs project variables get COMPANY`
- Set one variable:          `kicad-ctlrs project variables set COMPANY "Acme"`

`set` uses KiCad's merge semantics — only the named variable is changed,
others are preserved. The mutation appears in KiCad's undo stack as
`kicad-ctlrs: set text variable COMPANY = \`Acme\``.

### Net classes

- List all net classes:      `kicad-ctlrs project netclasses list`
- Get one net class:         `kicad-ctlrs project netclasses get Default`

### Title block

- Read the title block:      `kicad-ctlrs project title get`

## Subcommands deliberately not in v0

- `project rules list` — KiCad's IPC API has no method to read DRC rules
  at v0.4.3; rules live in `.kicad_pro` and `.kicad_dru` files.
- `project title set` — KiCad's IPC API has no `SetTitleBlockInfo` method
  at v0.4.3. Use `title get` to read; modifications must currently be done
  in the KiCad GUI.

## Error handling

- `kicad-not-running` (exit 2): ask the user to launch KiCad 10+.
- `kicad-no-document` (exit 3): project not open.
- `not-found` (exit 5): the named variable or net class does not exist.
