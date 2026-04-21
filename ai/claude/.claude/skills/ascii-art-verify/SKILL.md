---
name: ascii-art-verify
description: Verify and fix ASCII art box-drawing diagrams in documentation files. Use after editing any markdown or text file that contains box-drawing characters (lines with U+250x drawing chars).
---

# ASCII Art Box Verification

Verify that all box-drawing diagrams in a file have consistent alignment.

## When to Use

Use this after:
- Editing any markdown file that contains box-drawing characters (`┌`, `└`, `│`, `├`, `─`)
- Creating new documentation with ASCII art diagrams
- Reviewing documentation changes that include diagrams

## The Problem

Box-drawing diagrams break when:
1. Content lines have inconsistent padding before the closing `│`
2. Multi-byte UTF-8 characters (`×`, `→`, `↓`, `←`) take 1 display column but 2-3 bytes, causing byte-counting tools to misalign
3. The bottom border (`└───┘`) width doesn't match the top border (`┌───┐`)
4. Arrow annotations outside boxes (`← explanation`) shift the closing `│`

## Verification Rules

For every box in the file:

1. **Measure the inner width** from the top border: count the `─` characters between `┌` and `┐`.

2. **Every content line** must be exactly: `│` + (inner_width characters of visible content, padded with spaces) + `│`
   - Multi-byte UTF-8 characters count as 1 display column each (not their byte length)
   - The closing `│` must appear in the same column as the `┐` above it

3. **The bottom border** must be: `└` + (same number of `─` as the top border) + `┘`

4. **Arrow annotations** outside the box (e.g. `← Most sensitive`) must come AFTER the closing `│`, separated by a space.

5. **Centred arrows** (`↓`) between stacked boxes: use `(inner_width / 2)` leading spaces.

## Common Multi-Byte Characters (1 display column, multiple bytes)

- `×` (multiplication sign, 2 bytes) -- e.g. "640×480"
- `→` (right arrow, 3 bytes) -- e.g. "RGB → GRAY8"
- `←` (left arrow, 3 bytes) -- e.g. annotations
- `↓` (down arrow, 3 bytes) -- between boxes
- `≈` (approximately, 3 bytes) -- e.g. "≈ 158"

## Fix Strategy

When a content line has fewer display columns than the inner width:
- The box border is too wide for the content. Either:
  - (a) Shrink the border to match the longest content line, then re-pad shorter lines
  - (b) Add trailing spaces to short lines to match the border width

When a content line has more display columns than the inner width:
- The content is too wide for the box. Either:
  - (a) Widen the border (top + bottom + re-pad ALL other content lines)
  - (b) Abbreviate the overlong content

**Key rule:** never add spaces that push the closing `│` past the border. The border defines the width, and all content must fit within it.

## Example

Wrong -- the `×` is multi-byte so byte-counting makes the closing `│` appear to align but it actually falls 1 column short visually:
```
┌──────────────────────┐
│ Resolution: 640×480  │   <-- looks aligned in bytes but × is 2 bytes/1 column
└──────────────────────┘       so visual width is only 21 chars, border is 22
```

Correct -- widen the border to account for actual content, or ensure padding matches display width:
```
┌──────────────────────┐
│ Resolution: 640×480   │   <-- 22 display columns of content matches 22-wide border
└──────────────────────┘
```

## How to Invoke

```
/ascii-art-verify path/to/file.md
```

Or use the verification-agent with this skill after editing documentation.
