#!/usr/bin/env bash
# Build one TikZ figure and check label placement.
# Writes PDF and 600 dpi PNG next to the source. Prints a review image path.
# The review image marks words that a line crosses (magenta) or that overlap (orange).
# Usage: bash build.sh path/to/figure.tex [dpi]
set -euo pipefail

source_file="${1:?usage: build.sh figure.tex [dpi]}"
dpi="${2:-600}"
skill_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
figure_dir="$(cd "$(dirname "$source_file")" && pwd)"
figure_name="$(basename "$source_file" .tex)"
review_width=1600

cd "$figure_dir"
export TEXINPUTS="${skill_dir}//:"
if ! lualatex -interaction=nonstopmode -halt-on-error "$figure_name.tex" \
    > "$figure_name.build.log"; then
  tail -30 "$figure_name.build.log" >&2
  echo "build.sh: lualatex failed; logs kept in $figure_dir" >&2
  exit 1
fi
pdftoppm -r "$dpi" -png -singlefile "$figure_name.pdf" "$figure_name"

work_dir="$(mktemp -d)"
if ! lualatex -interaction=nonstopmode -halt-on-error -output-directory "$work_dir" \
    -jobname "$figure_name.lines" "\\def\\hsLinesOnly{1}\\input{$figure_name.tex}" \
    > "$work_dir/lines.build.log"; then
  tail -30 "$work_dir/lines.build.log" >&2
  echo "build.sh: lines-only build failed" >&2
  exit 1
fi
pdftoppm -png -singlefile -scale-to-x "$review_width" -scale-to-y -1 \
  "$figure_name.pdf" "$work_dir/$figure_name.review"
pdftoppm -png -singlefile -scale-to-x "$review_width" -scale-to-y -1 \
  "$work_dir/$figure_name.lines.pdf" "$work_dir/$figure_name.lines"
pdftotext -bbox "$figure_name.pdf" "$work_dir/$figure_name.words.xml"

target_dir="${CARGO_TARGET_DIR:-$HOME/.cargo/target}"
cargo build --release --quiet --target-dir "$target_dir" \
  --manifest-path "$skill_dir/tools/label-check/Cargo.toml"
placement_status=0
"$target_dir/release/label-check" "$work_dir/$figure_name.words.xml" \
  "$work_dir/$figure_name.lines.png" "$work_dir/$figure_name.review.png" \
  "$work_dir/$figure_name.placement.png" || placement_status=$?
if [ "$placement_status" -eq 1 ]; then
  echo "build.sh: label-check failed to run" >&2
  exit 1
fi

if grep -E "Overfull|Underfull|Warning" "$figure_name.log"; then
  echo "build.sh: warnings above; read them before you accept the figure" >&2
fi
if [ "$placement_status" -eq 2 ]; then
  echo "build.sh: label-check found placement problems; judge each one on the review image" >&2
fi
rm -f "$figure_name.aux" "$figure_name.log" "$figure_name.build.log"
echo "wrote $figure_dir/$figure_name.pdf and $figure_dir/$figure_name.png (${dpi} dpi)"
echo "review image: $work_dir/$figure_name.placement.png"
