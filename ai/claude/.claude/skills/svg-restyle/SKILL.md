---
name: svg-restyle
description: Use when the user asks to apply their personal SVG style to an .svg file -- specifically removing the opaque background (making it transparent) and switching all fonts to Tahoma. Triggers include "make this svg transparent", "remove the background from this svg", "use Tahoma in this svg", or "restyle this svg".
---

# SVG Restyle

Apply the user's standard SVG style preferences to an existing `.svg` file in place:

1. **Transparent background** -- removes any direct child `<rect>` of `<svg>` that covers the full canvas (per the `viewBox`) and has a non-transparent fill.
2. **Tahoma font** -- replaces every `font-family` declaration (both inline `style="..."` and `font-family="..."` attributes) with `Tahoma, sans-serif`.

## When to Use

- The user asks to "make this SVG transparent" or "remove the background"
- The user asks to switch SVG fonts to Tahoma
- The user asks to "apply my SVG style" or otherwise refers to these two preferences together
- After generating a new SVG diagram, if it ships with an opaque background or a non-Tahoma font, run this to bring it into line with the user's style

Do **not** use this skill for SVGs the user explicitly wants to keep with a coloured background or a different font.

## How to Invoke

```
python3 ~/.claude/skills/svg-restyle/restyle.py path/to/diagram.svg [more.svg ...]
```

The script edits each file in place and prints `updated: <path>` or `unchanged: <path>`. Non-SVG paths are skipped with a non-zero exit code.

## What the script does

- Reads the SVG `viewBox` to learn the canvas dimensions.
- Removes every direct `<rect>` child of `<svg>` whose `x`/`y` are `0`, whose `width`/`height` match the canvas (or are `100%`), and whose effective fill (attribute or inline `style`) is not `none`/`transparent`/empty. Both self-closing (`<rect ... />`) and paired (`<rect ...></rect>`) forms are handled.
- Rewrites every `font-family:...` value inside `style="..."` to `Tahoma, sans-serif`.
- Rewrites every `font-family="..."` attribute to `Tahoma, sans-serif`.

## Limitations

- CSS inside `<style>` blocks is not parsed -- only inline `style` attributes and `font-family` attributes.
- Background detection only matches rects covering the *full* canvas. A coloured rect that serves as a real diagram element (not a background) is left alone by design, even if it happens to fill the canvas, as long as it is not a direct child of the root `<svg>`.
- The script is idempotent -- running it twice on the same file produces the same output as running it once.
