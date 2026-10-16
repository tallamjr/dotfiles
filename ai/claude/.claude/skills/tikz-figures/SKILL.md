---
name: tikz-figures
description: Use when creating or editing TikZ or pgfplots figures for slides, papers or docs: block diagrams, optics and signal sketches, response plots, or any figure that must match the EE259 Beamer slide look.
---

# TikZ figures

One shared style file and four tested templates. Every figure uses the same palette, font and arrow style.

Files, all in `~/.claude/skills/tikz-figures/`:
- `tikz-house.sty`: palette, fonts, node and arrow styles, `house axis` plot style, `\thinlens`, `\gaussradius`, `\spring`, `\damper`, `\hatchedwall`.
- `templates/block-diagram.tex`: signal chain with labelled arrows.
- `templates/optics.tex`: beam, lens, dimension arrows, computed envelope.
- `templates/plot.tex`: pgfplots curves with legend.
- `templates/mechanical.tex`: mass, spring, damper, wall.
- `scripts/build.sh`: builds PDF and 600 dpi PNG next to the source, plus a small review image in a temp folder. It deletes `.aux` and `.log` files on success.
- `review-checklist.md` and `review-prompt.md`: the physics and label placement review.
- `tools/label-check/`: Rust tool that `build.sh` builds and runs. Run `cargo test` there after any change.

## Workflow

0. If a reference image holds more than one figure, state which part you redraw. Leave out the rest.
1. Copy the closest template into the figure folder. Edit it. Do not start from a blank file.
2. Build: `bash ~/.claude/skills/tikz-figures/scripts/build.sh figure.tex`. It writes a PDF and a 600 dpi PNG. It runs `label-check` and prints a `review image:` path. Magenta boxes on that image mark words that a line crosses.
3. Read the review image with the Read tool. Do not accept a figure you have not looked at.
4. Review as a physicist. Dispatch a fresh subagent with `review-prompt.md`. Give it the review image path, the `label-check` output and a one-sentence intent. Do not give it the source. It must give a reason for every label.
5. Check each FAIL on a zoomed crop or in the source. Reviewers can be wrong. Fix every real FAIL. Rebuild. Review again until all items pass. Read every warning the script prints.

## Style rules

- Use only `hs*` colours and the styles in the `.sty`. Add a new colour to the `.sty`, not to one figure.
- Place nodes with `positioning` (`right=26mm of a`). Never type absolute coordinates for boxes.
- Size every gap from the label on it. A gap must be wider than its label plus 4 mm.
- For a part with no helper (a new symbol), write a small `\newcommand` that takes start, angle and length. Add it to the `.sty` if you use it twice.
- Compute geometry from the physics or the data (`\gaussradius`, `plot` expressions). Do not draw curves by eye.
- Write maths in real LaTeX maths. Write label text in plain short words (STE).
- Put text for code, paths and hex values in `\texttt` (Menlo).
- Centre each label on the object it names (or on that object's guide line). Keep 1 to 4 mm between text and any line. Give a long label its own row.
- Keep a label inside its container: raise the container height, not the label.
- Compile with `lualatex` only. The `.sty` needs `fontspec`.

## Quick checks before the review

- No label touches a box edge or another label.
- Multi-line node text breaks where you wrote `\\` (nodes default to `align=center`).
- A beam, curve or bar has no step where two parts meet. A change of slope at a lens is correct.
- Legend text shows the real symbols, and curves have different colours.
- Text size matches the slide: build at final size, include at `\includegraphics[width=...]` without heavy scaling.

## Gotchas found in testing

| Problem | Fix |
|---|---|
| All plot lines black | Use `\addplot+[...]`. Plain `\addplot[...]` replaces the colour cycle. |
| `\foreach \zeta` prints `0.2 = 0.2` | A loop variable shadowed `\zeta`. Name loop variables `\dampingratio`, not Greek macro names. |
| Label collides with box | Raise the gap. Move vertical-arrow labels to `right=2pt`. |
| Beam width jumps at lens | Derive the second Rayleigh range from the radius at the lens (see `optics.tex`). |
| Glow looks flat or banded | Stack many `opacity=0.07` envelopes. Avoid one flat band. |
| Container border cuts a label | `label-check` flags it. Raise the container height. |
| Arrowheads of a short mark merge into a star | Use `radius arrow` (one head). |
| Mass moves the wrong way in a mechanics sketch | A mass lags its case: input left gives displacement right. |
| Long label sits nearer to other objects than to its own | Centre it on its guide line and name the side in the text. |
| Missing glyph or wrong font | Tahoma exists on macOS only. The `.sty` falls back to the default sans font. |

## Use in another repo

Run `build.sh` from this skill. It sets `TEXINPUTS` so `\usepackage{tikz-house}` resolves. To build without the script, copy `tikz-house.sty` next to the figure.
