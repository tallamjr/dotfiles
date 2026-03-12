---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(mkdir:*), Bash(ls:*), Bash(/Users/tallam/.venv/bin/python:*)
argument-hint: <module-path>
description: Generate comprehensive course notes from materials in a folder
---

# Course Notes Generator

Create detailed, comprehensive notes from course materials (transcripts, slides, PDFs) found in the specified folder.

## Arguments

- `$1` = Path to module folder (e.g., "02-comms/module-2")

The course prefix is automatically extracted from the folder path:
- `01-custom/module-X` -> course prefix `c1`
- `02-comms/module-X` -> course prefix `c2`
- `03-sensors/module-X` -> course prefix `c3`
- `04-design/module-X` -> course prefix `c4`

## Instructions

1. **Parse the module path** `$1`:
   - Extract course number from folder name (e.g., "02-comms" -> "c2")
   - Extract module number (e.g., "module-2" -> "m2")
   - Figure naming will use pattern: `c{course}-m{module}-{description}.png`

2. **Explore the module folder** at `$1`:
   - Find all transcript files (subtitle*.txt or similar)
   - Find any PDF slides
   - Read all materials to understand the content

3. **Create a comprehensive README.md** in the module folder with:
   - Title and course metadata
   - Full table of contents with anchor links
   - Detailed sections covering all topics from the transcripts
   - **MathJax equations** for any mathematical content using `$...$` for inline and `$$...$$` for display
   - **GitHub alert admonitions** for insights (see reference below):
     - `> [!NOTE]` for general information
     - `> [!TIP]` for helpful suggestions
     - `> [!IMPORTANT]` for key concepts
     - `> [!WARNING]` for cautions
     - `> [!CAUTION]` for critical warnings
   - Tables for structured data
   - Mermaid diagrams for block diagrams, flowcharts, and conceptual illustrations (```mermaid code blocks)
   - ASCII diagrams for circuit schematics only (Mermaid does not support circuits)
   - Quick reference section at the end

4. **For signal plots, waveforms, and diagrams**, add functions to the central figure generation file:
   - **IMPORTANT**: All figures MUST be added to `figures/generate_figures.py` - do NOT create standalone scripts
   - Add new functions following the existing pattern (e.g., `generate_c3_m2_*()`)
   - Add function calls to the `main()` function
   - Run the script to generate all figures: `/Users/tallam/.venv/bin/python figures/generate_figures.py`
   - Use naming convention: `c{course}-m{module}-{description}.png`
   - Update the README to reference figures with relative paths: `../../figures/`

5. **Figure generation file structure** (`figures/generate_figures.py`):
   ```python
   # Add your function following this pattern:
   def generate_c3_m2_your_figure():
       """
       Course 3 Module 2: Description of what this figure shows.
       """
       fig, ax = plt.subplots(figsize=(10, 6))
       # ... your plotting code ...
       plt.savefig(OUTPUT_DIR / 'c3-m2-your-figure.png')
       plt.close()
       print("Created: c3-m2-your-figure.png")

   # Then add to main():
   def main():
       # ... existing calls ...
       # Course 3 Module 2 figures
       generate_c3_m2_your_figure()
   ```

6. **For diagrams**:
   - Use Mermaid for block diagrams, flowcharts, and system architecture (include as ```mermaid code blocks in README)
   - Use ASCII art for circuit schematics directly in the README (Mermaid does not support circuit diagrams)

7. **Figure styling requirements** (already configured in generate_figures.py):
   - Uses `plt.style.use('default')` for light theme
   - Figure DPI set to 150
   - Include proper axis labels and titles
   - Add annotations where helpful
   - Use consistent colours across related figures

## Example Usage

```
/coursera-notes 02-comms/module-3
```

This will:
- Parse path to determine course=2, module=3
- Read all materials in `02-comms/module-3/`
- Create `02-comms/module-3/README.md` with comprehensive notes
- Generate figures named `c2-m3-*.png` in `figures/`

## Quality Checklist

- [ ] All transcript content covered
- [ ] Equations formatted with MathJax
- [ ] GitHub admonitions used for insights
- [ ] Signal plots rendered with matplotlib (not ASCII)
- [ ] Block diagrams and flowcharts use Mermaid
- [ ] Circuit schematics use ASCII art
- [ ] Figure naming follows convention
- [ ] README has working anchor links
- [ ] Quick reference section included

## References

- GitHub Alerts syntax: https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax#alerts
- Mermaid documentation: https://mermaid.js.org/intro/
