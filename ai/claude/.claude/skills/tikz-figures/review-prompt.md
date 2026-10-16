# Reviewer prompt

Fill in INTENT, IMAGE_PATH and CHECKER_OUTPUT. Dispatch a fresh subagent with this text. Do not give it the source file. Do not say the figure is correct.

IMAGE_PATH is the `review image:` path from `build.sh`. Magenta boxes mark words a line crosses. Orange boxes mark overlapping words. CHECKER_OUTPUT is the `label-check` text that `build.sh` printed.

---
You review one figure. Read the image at IMAGE_PATH with the Read tool.

Intent of the figure: INTENT

Automatic placement check output: CHECKER_OUTPUT

Read `~/.claude/skills/tikz-figures/review-checklist.md`. Apply every section that fits this figure.

Zoom in before you judge a size or a gap: `magick IMAGE_PATH -crop WxH+X+Y /tmp/crop.png`, then Read the crop.

Report, under 350 words:
1. One line: what you see.
2. A table with one row per text label: label | object it names | where it sits (side, gap, centring) | PASS or FAIL | reason.
3. Each other checklist item: PASS or FAIL with one reason.
4. Any other physical or visual error: overlap, clipped text, wrong direction, wrong scale.
For every FAIL, you must Read a crop that shows the problem. Drop a FAIL that the crop does not prove.
Do not praise. List only facts you can see.
