#!/usr/bin/env python3
"""Apply opinionated style preferences to one or more SVG files in place.

Transforms applied:
  1. Transparent background -- removes any direct child <rect> of <svg> that
     covers the full canvas (per the viewBox) and has a non-transparent fill.
  2. Tahoma font -- replaces every font-family declaration (both inline
     style="..." and font-family="..." attributes) with `Tahoma, sans-serif`.

Usage:
    restyle.py <svg-file> [<svg-file> ...]

The script edits files in place and prints a per-file status line.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

TAHOMA_STACK = "Tahoma, sans-serif"

# Match font-family in an inline style attribute. Treats &quot;...&quot;
# pairs (HTML-encoded quoted font names, common in SVGs exported from web
# tools) as atomic units so the regex doesn't terminate at the `;` inside
# the encoded entity name itself.
FONT_FAMILY_IN_STYLE = re.compile(
    r"""font-family\s*:\s*(?:&quot;[^"]*?&quot;|[^;"'])+"""
)
# Cleanup pass: strip residue left by older versions of this script that
# mis-parsed &quot;-encoded font names. Those runs wrote
# `font-family:Tahoma, sans-serif;<orphan-stack>` — this pattern detects
# the orphan by looking for well-known font-stack keywords immediately
# after the replaced declaration and removes the leftover up to the next
# CSS separator.
FONT_FAMILY_RESIDUE = re.compile(
    r"font-family\s*:\s*Tahoma,\s*sans-serif\s*;"
    r"\s*(?:Anthropic Sans|-apple-system|system-ui|Segoe UI)"
    r"(?:&quot;|[^;\"])*"
    r"(?=;|\")"
)
FONT_FAMILY_ATTR = re.compile(r'font-family\s*=\s*"[^"]*"')
VIEWBOX_RE = re.compile(r'viewBox\s*=\s*"([^"]+)"')
RECT_SELF_CLOSING = re.compile(r"<rect\b[^/>]*/>")
RECT_PAIRED = re.compile(r"<rect\b[^>]*></rect>")
ATTR_RE = re.compile(r'([\w:-]+)\s*=\s*"([^"]*)"')
STYLE_FILL_RE = re.compile(r"fill\s*:\s*([^;]+)")


def _canvas_dims(svg: str) -> tuple[str | None, str | None]:
    match = VIEWBOX_RE.search(svg)
    if not match:
        return None, None
    parts = match.group(1).split()
    if len(parts) != 4:
        return None, None
    return parts[2], parts[3]


def _is_full_canvas_background(
    tag: str, canvas_w: str | None, canvas_h: str | None
) -> bool:
    attrs = dict(ATTR_RE.findall(tag))
    if attrs.get("x", "0").strip() not in ("0", "0px"):
        return False
    if attrs.get("y", "0").strip() not in ("0", "0px"):
        return False

    width = attrs.get("width", "").strip()
    height = attrs.get("height", "").strip()
    full_w = width == "100%" or (canvas_w is not None and width == canvas_w)
    full_h = height == "100%" or (canvas_h is not None and height == canvas_h)
    if not (full_w and full_h):
        return False

    fill = attrs.get("fill", "").strip().lower()
    style_fill = STYLE_FILL_RE.search(attrs.get("style", ""))
    if style_fill:
        fill = style_fill.group(1).strip().lower()
    return fill not in ("", "none", "transparent")


def restyle(svg: str) -> str:
    svg = FONT_FAMILY_IN_STYLE.sub(f"font-family:{TAHOMA_STACK}", svg)
    svg = FONT_FAMILY_RESIDUE.sub(f"font-family:{TAHOMA_STACK}", svg)
    svg = FONT_FAMILY_ATTR.sub(f'font-family="{TAHOMA_STACK}"', svg)

    canvas_w, canvas_h = _canvas_dims(svg)

    def drop_if_background(match: re.Match[str]) -> str:
        tag = match.group(0)
        return "" if _is_full_canvas_background(tag, canvas_w, canvas_h) else tag

    svg = RECT_SELF_CLOSING.sub(drop_if_background, svg)
    svg = RECT_PAIRED.sub(drop_if_background, svg)

    svg = re.sub(r"\n[ \t]*\n+", "\n", svg)
    return svg


def main(argv: list[str]) -> int:
    if not argv:
        print("Usage: restyle.py <svg-file> [<svg-file> ...]", file=sys.stderr)
        return 1
    exit_code = 0
    for arg in argv:
        path = Path(arg)
        if not path.is_file():
            print(f"skip: {path} is not a file", file=sys.stderr)
            exit_code = 1
            continue
        if path.suffix.lower() != ".svg":
            print(f"skip: {path} is not an .svg file", file=sys.stderr)
            exit_code = 1
            continue
        original = path.read_text()
        updated = restyle(original)
        if original == updated:
            print(f"unchanged: {path}")
        else:
            path.write_text(updated)
            print(f"updated:   {path}")
    return exit_code


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
