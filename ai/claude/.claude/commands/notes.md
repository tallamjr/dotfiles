---
allowed-tools: Task, Read, Write, Edit, Glob, Grep, Bash(mkdir:*), Bash(ls:*), Bash(rm:*), Bash(yt-transcript:*), Bash(/Users/tallam/.venv/bin/python:*)
argument-hint: <source> [output-directory] [--single-file] [--no-verify]
description: Generate comprehensive notes from YouTube videos, playlists, or local learning materials
---

# Unified Notes Generator

Create detailed, comprehensive notes from various learning materials:
- YouTube videos or playlists (auto-fetches transcripts)
- Local folders containing transcripts, slides, or PDFs

## Arguments

- `$1` = Source (required): YouTube URL or path to folder containing materials
- `$2` = Output directory (optional): defaults to current directory for YouTube, source folder for local materials

## Flags (parsed from arguments)

- `--single-file` = Generate a single consolidated README.md instead of multiple lecture files
- `--no-verify` = Skip the verification agent step

## Input Auto-Detection

The command automatically determines the input type:

1. **YouTube mode**: If source contains `youtube.com`, `youtu.be`, or starts with `http`
2. **Folder mode**: All other inputs are treated as local folder paths

## Instructions

### Phase 1: Parse Arguments and Detect Input Type

1. **Parse all arguments** from `$ARGUMENTS`:
   - Extract source (first non-flag argument)
   - Extract output directory (second non-flag argument, if present)
   - Detect `--single-file` flag
   - Detect `--no-verify` flag

2. **Determine input type**:
   - If source matches URL pattern (contains `youtube.com`, `youtu.be`, or starts with `http`) -> **YouTube mode**
   - Otherwise -> **Folder mode**

3. **Set output directory defaults**:
   - YouTube mode: current directory if not specified
   - Folder mode: source folder if not specified

4. **Create output directory** if it doesn't exist

### Phase 2: Acquire Transcripts

#### YouTube Mode

1. Create `<output-dir>/transcripts/` directory
2. Run: `yt-transcript --no-timestamps -o <output-dir>/transcripts "$SOURCE"`
3. Parse output to determine success/failure counts
4. If all videos fail, report error and exit

#### Folder Mode

1. **Auto-detect transcripts** in source folder:
   - Check for `transcripts/` subdirectory
   - Check for `*.txt` files in source folder
   - Check for `subtitle*.txt` pattern (Coursera-style)
   - Check for PDF files that may contain slides/content

2. **Set transcript location**:
   - If `transcripts/` exists, use that
   - Otherwise, use source folder directly

3. Read all transcript files and any PDF content

### Phase 3: Process Materials

For each transcript/material file:

1. **Extract metadata**:
   - YouTube mode: Extract video ID from filename (`XX-{video_id}.txt`)
   - Folder mode: Extract section number from filename or order

2. **Generate notes content** following the structure below

### Phase 4: Generate Output

#### Multi-file Mode (default)

Generate `<output-dir>/notes-XX-{identifier}.md` for each source:

**Structure**:
- **Header**: Title (derived from content or filename), source link if available
- **Table of Contents**: Anchor links to all major sections
- **Main Content**: Detailed sections organised by topic from transcript
- **Quick Reference**: Summary of key points at the end

Generate `<output-dir>/index.md` when there are 2+ sources:
- Overview title and description
- Table linking to all note files with brief descriptions
- Summary of topics covered

#### Single-file Mode (`--single-file`)

Generate `<output-dir>/README.md`:
- Combined table of contents for all materials
- All content consolidated with clear section separators
- Single quick reference section at the end

### Phase 5: Figure Generation

When content discusses visualisable concepts, create `<output-dir>/figures/generate_figures.py`:

```python
#!/usr/bin/env python3
"""Generate figures for notes."""
from pathlib import Path
import matplotlib.pyplot as plt
import numpy as np

OUTPUT_DIR = Path(__file__).parent
plt.style.use('default')

def generate_notes_XX_description():
    """
    Notes XX: Description of what this figure shows.
    """
    fig, ax = plt.subplots(figsize=(10, 6))
    # ... plotting code ...
    plt.savefig(OUTPUT_DIR / 'notes-XX-description.png', dpi=150, bbox_inches='tight')
    plt.close()
    print("Created: notes-XX-description.png")

def main():
    OUTPUT_DIR.mkdir(exist_ok=True)
    generate_notes_XX_description()

if __name__ == '__main__':
    main()
```

- Run with: `/Users/tallam/.venv/bin/python <output-dir>/figures/generate_figures.py`
- Use naming convention: `notes-XX-{description}.png`
- Reference in notes with relative paths: `figures/notes-XX-description.png`

### Phase 6: Verification (unless `--no-verify`)

Use the Task tool to spawn a `verification-agent` subagent to verify:
- All generated files have valid structure
- MathJax syntax is balanced (`$...$` and `$$...$$`)
- Anchor links in table of contents are valid
- Figure references point to existing files
- No placeholder text remains
- All transcript content has been covered

### Phase 7: Report Summary

Report:
- "Generated X note files in <output-dir>"
- Verification status (PASSED/FAILED) unless `--no-verify`
- Location of transcripts (if fetched)
- Any issues encountered

## Formatting Requirements

**MathJax equations**:
- Use `$...$` for inline equations
- Use `$$...$$` for display equations

**GitHub alert admonitions**:
- `> [!NOTE]` - general information and context
- `> [!TIP]` - helpful suggestions and best practices
- `> [!IMPORTANT]` - key concepts that must be understood
- `> [!WARNING]` - cautions and potential pitfalls
- `> [!CAUTION]` - critical warnings about dangerous mistakes

**Diagrams**:
- **Mermaid**: For block diagrams, flowcharts, and conceptual illustrations (```mermaid code blocks)
- **ASCII art**: For circuit diagrams only (Mermaid does not support circuit schematics)
- **Matplotlib figures**: For plots, waveforms, graphs, and data visualisations

**Tables**: Use for comparisons, specifications, and structured data

**Code blocks**: For any code examples mentioned in the materials

## Output Structure

### Multi-file Mode
```
<output-dir>/
  index.md                      (when 2+ sources)
  notes-01-{identifier}.md
  notes-02-{identifier}.md
  ...
  transcripts/                  (YouTube mode only)
    01-{video_id}.txt
    02-{video_id}.txt
    ...
  figures/                      (if figures generated)
    generate_figures.py
    notes-01-*.png
    notes-02-*.png
```

### Single-file Mode
```
<output-dir>/
  README.md
  transcripts/                  (YouTube mode only)
    01-{video_id}.txt
    ...
  figures/                      (if figures generated)
    generate_figures.py
    *.png
```

## Execution Strategy

- **Single source**: Process directly
- **Multiple sources (2+ videos or files)**: Use the Task tool to spawn parallel subagents (one per source) for concurrent processing

## Example Usage

```bash
# YouTube video to current directory
/notes https://www.youtube.com/watch?v=dQw4w9WgXcQ

# YouTube playlist to specified directory
/notes https://www.youtube.com/playlist?list=PLrAXtmErZgOeiKm4sgNOknGvNjby9efdf ./rust-lectures

# Local folder with transcripts
/notes ~/courses/machine-learning/week-3

# Local folder with single consolidated output
/notes ~/courses/dsp/module-4 --single-file

# YouTube without verification
/notes https://youtu.be/VIDEO_ID ~/lectures/topic --no-verify

# Local folder, custom output, single file
/notes ./course-materials ./output --single-file --no-verify
```

## Quality Checklist

- [ ] All source content covered comprehensively
- [ ] Input type correctly auto-detected
- [ ] Transcripts found/fetched successfully
- [ ] Equations formatted with MathJax where applicable
- [ ] GitHub admonitions used for key insights
- [ ] Diagrams rendered appropriately (Mermaid/ASCII/matplotlib)
- [ ] Source links included where available
- [ ] Table of contents with working anchor links
- [ ] Quick reference section included
- [ ] Index file created (multi-file mode with 2+ sources)
- [ ] Verification passed (unless --no-verify)

## Notes on Content Extraction

- Identify natural topic transitions in transcripts
- Look for phrases like "let's talk about", "moving on to", "now we'll cover"
- Extract any mentioned URLs, references, or resources
- Identify and highlight key terminology and definitions
- Convert spoken explanations of formulas into proper MathJax notation
- For PDF slides, extract key bullet points and diagrams
- Cross-reference between transcript and slides for complete coverage

## Figure Styling Requirements

When generating figures:
- Use `plt.style.use('default')` for light theme
- Set DPI to 150
- Include proper axis labels and titles
- Add annotations where helpful
- Use consistent colours across related figures
- Use `bbox_inches='tight'` to avoid clipping
