---
name: dark-matplotlib-style
description: Use when creating, restyling, or being asked to match a dark technical matplotlib chart, especially a request for the Tahoma dark plot style (near-black background, light text, role-based accent colours) or "make this plot look like the zenith/project figures".
---

# Dark Tahoma matplotlib style

## Overview

A reusable dark-background matplotlib look for technical figures: a near-black
canvas, light off-white text, muted grey ticks, a faint dotted grid, and a small
role-based accent palette where each colour means something (green is a win, red
is the failure). The point is legibility on a dark page and a consistent visual
vocabulary across a set of figures.

## When to use

- The user asks for "that plot style", "the dark style", "the Tahoma style", or
  to match an existing project figure.
- You are generating any matplotlib chart for a report or repo that already uses
  this look and the new figure must sit alongside the others.
- Not for light-background or publication-journal figures, and not for
  non-matplotlib plotting (the rcParams are matplotlib-specific).

## Quick reference

| Element | Value |
|---|---|
| Font | Tahoma (fallback DejaVu Sans) |
| Figure background | `#121212` |
| Axes background | `#0a0a0a` |
| Body text | `#e0e0e0`; labels `#cfcfcf`; titles `#e8e8e8` |
| Ticks | `#9aa0aa` |
| Grid | dotted `:` in `#2a2a2a`, usually `axis="y"` |
| Good / win | `#00ff66` |
| Regression / degraded | `#ffb000` (amber) |
| Neutral / ideal reference | `#7aa2ff` (blue) |
| Failure / baseline | `#ff5566` (red) |
| Legend | facecolor `#1a1a1a`, labelcolor `#e0e0e0`, edgecolor `#333` |

## Implementation

Use the helper module beside this skill ([style.py](style.py)): copy it next to
the plot script, or inline `DARK_RC` / `PALETTE` directly. It exposes
`apply_dark_style()`, `PALETTE`, `LEGEND_KW`, `GRID_KW`, and `footer()`.

```python
import matplotlib.pyplot as plt
from style import apply_dark_style, PALETTE, LEGEND_KW, GRID_KW, footer

apply_dark_style()  # set the dark Tahoma rcParams first

fig, ax = plt.subplots(figsize=(8, 5))
ax.bar(["baseline", "fixed"], [214.0, 0.13],
       color=[PALETTE["fail"], PALETTE["good"]])
ax.set_ylabel("position error (nm)")
ax.set_title("Stabilised mount recovers the fix")
ax.grid(True, axis="y", **GRID_KW)
ax.legend(["error"], **LEGEND_KW)
footer(fig, "lower is better")
fig.savefig("out.png", dpi=150)  # savefig.facecolor keeps the dark border
```

## Conventions that make it cohesive

- Assign colours by ROLE, not by what looks nice: reuse the same colour for the
  same meaning across every panel so the reader learns the code once.
- Keep the grid on one axis only (usually `y`) so it guides without clutter.
- Put the "lower/higher is better" or units note in a muted `footer()`, not the
  title.
- Use `fig.suptitle(..., fontsize=13)` for a multi-panel figure's headline.

## Common mistakes

- Forgetting `savefig.facecolor`: the saved PNG gets a white border around the
  dark axes. `apply_dark_style()` sets it; do not override it on `savefig`.
- Assuming Tahoma exists everywhere: on a bare Linux box it may be missing and
  matplotlib silently falls back. If the rendered font matters, install Tahoma or
  set an installed sans family in `DARK_RC`.
- Using more than the four palette roles: extra ad-hoc colours break the visual
  vocabulary. If you need more series, vary line style or marker, not hue.
