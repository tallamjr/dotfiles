---
name: svg-restyle
description: Apply the user's standard SVG style preferences (transparent background + Tahoma font), and optionally generate a paired dark-mode variant so the diagram tracks Material's in-page colour-scheme toggle on Material-themed sites. Triggers include "make this svg transparent", "remove the background from this svg", "use Tahoma in this svg", "restyle this svg", or "make this svg work in dark mode".
---

# SVG Restyle

Two related workflows:

1. **Basic restyle** (the `restyle.py` script) -- transparent background + Tahoma font, applied in place to one or more existing `.svg` files.
2. **Dual-variant workflow** (manual edits) -- generate a paired dark-mode `*-dark.svg` so the diagram reads correctly in both Material colour schemes. Use this when adding an SVG to a Material-themed site whose palette assumes a light surface (dark text on pastel fills).

## When to Use Basic Restyle

- The user asks to "make this SVG transparent" or "remove the background"
- The user asks to switch SVG fonts to Tahoma
- The user asks to "apply my SVG style" or otherwise refers to these two preferences together
- After generating a new SVG diagram, if it ships with an opaque background or a non-Tahoma font, run this to bring it into line with the user's style

Do **not** use this skill for SVGs the user explicitly wants to keep with a coloured background or a different font.

## How to Invoke Basic Restyle

```
python3 ~/.claude/skills/svg-restyle/restyle.py path/to/diagram.svg [more.svg ...]
```

The script edits each file in place and prints `updated: <path>` or `unchanged: <path>`. Non-SVG paths are skipped with a non-zero exit code.

## What the Script Does

- Reads the SVG `viewBox` to learn the canvas dimensions.
- Removes every direct `<rect>` child of `<svg>` whose `x`/`y` are `0`, whose `width`/`height` match the canvas (or are `100%`), and whose effective fill (attribute or inline `style`) is not `none`/`transparent`/empty. Both self-closing (`<rect ... />`) and paired (`<rect ...></rect>`) forms are handled.
- Rewrites every `font-family:...` value inside `style="..."` to `Tahoma, sans-serif`. Handles HTML-encoded quoted font names like `&quot;Anthropic Sans&quot;` atomically (they don't trip the `;` terminator the way naive regexes do), and includes a cleanup pass that removes residue left by older versions of the script.
- Rewrites every `font-family="..."` attribute to `Tahoma, sans-serif`.

## When to Use the Dual-Variant Workflow

When adding an SVG to a Material-themed site (such as the user's MkDocs Material blog) where the SVG has dark text -- axis labels, tick marks, outcome annotations -- sitting *outside* any opaque coloured region. On Material's slate (dark) colour scheme that text would render dark-on-dark and become unreadable.

The reason this requires two files: `<img>`-embedded SVGs run in an isolated document context and cannot read the parent page's `data-md-color-scheme` attribute. CSS inside the SVG that uses `prefers-color-scheme` only tracks the OS preference, not Material's in-page toggle. The only way to follow the toggle precisely is to ship two SVG assets and let Material's image-switching CSS hide one based on the active scheme.

## Dual-Variant Workflow

### Step 1: Add the image-switching CSS once per site

Append to the site's custom stylesheet (e.g. `src/stylesheets/extra.css`) if not already present:

```css
/* Image swap for light/dark SVG variants -- Material #only-light / #only-dark pattern */
[data-md-color-scheme="default"] img[src$="#only-dark"] { display: none; }
[data-md-color-scheme="slate"] img[src$="#only-light"] { display: none; }
```

Grep the existing CSS files first to avoid duplicating the rules.

### Step 2: Generate the dark variant of each SVG

For each `<name>.svg`, copy it to `<name>-dark.svg` alongside the original, then edit the dark copy. Use the basic restyle (transparent background + Tahoma) on both files. The dark variant additionally needs targeted text/stroke recolouring:

| Category | Light variant | Dark variant |
|---|---|---|
| Background rect | transparent (removed) | transparent (removed) |
| Axis label text (e.g. `rgb(61, 61, 58)` dark grey) | unchanged | `rgb(225, 225, 222)` |
| Tick line stroke (e.g. `rgb(115, 114, 108)`) | unchanged | `rgb(180, 180, 178)` |
| Off-region warning text (dark reds like `rgb(121, 31, 31)`, `rgb(163, 45, 45)`) | unchanged | `rgb(255, 145, 145)` |
| Off-region success text (dark greens like `rgb(8, 80, 65)`, `rgb(15, 110, 86)`) | unchanged | `rgb(140, 220, 175)` |
| Pastel region rect fills | unchanged | unchanged |
| Text *inside* pastel regions | unchanged | unchanged |
| Hatch pattern strokes (e.g. `#A32D2D` crosshatch, dashed unmapped) | unchanged | unchanged |

The discriminator for in-region vs off-region text: check whether the `<text>` element's `x`, `y` falls inside the bounds of any pastel `<rect>`. If yes, the text sits on an opaque light surface in both schemes and stays unchanged. If no, it sits directly on the page background and needs recolouring for the dark variant.

Hatch-pattern rectangles are a subtle case: they draw stroked lines but have no opaque fill, so text "inside" them actually sits on the page background. Treat those labels as off-region.

### Step 3: Reference both variants in markdown

Replace the original single-image figure with paired image references:

```markdown
<figure markdown="span">
    ![alt text](./<name>.svg#only-light){ width=...% }
    ![alt text](./<name>-dark.svg#only-dark){ width=...% }
    <figcaption>caption</figcaption>
</figure>
```

Use the same alt text, width attribute, and any other image attributes on both lines. The `#only-light` / `#only-dark` anchor fragments are what the CSS rules from Step 1 target.

### Step 4: Verify

With a local dev server running, force-reload the rendered page and toggle Material's theme using the sun/moon icon in the header (no need to change the OS scheme). The diagram should swap variants without a page reload. Check both:

- Axis labels and off-region annotations are readable in both schemes.
- Pastel region fills and their internal labels look identical in both schemes (these should not change visually -- they're shared content).

## Limitations

- CSS inside `<style>` blocks is not parsed by the script -- only inline `style` attributes and `font-family` attributes.
- Background detection only matches rects covering the *full* canvas. A coloured rect that serves as a real diagram element (not a background) is left alone by design, even if it happens to fill the canvas, as long as it is not a direct child of the root `<svg>`.
- The script is idempotent -- running it twice on the same file produces the same output as running it once.
- The dual-variant workflow's text-category discrimination (in-region vs off-region) cannot be automated reliably without a layout-aware SVG parser; manual judgement per text element is expected.
