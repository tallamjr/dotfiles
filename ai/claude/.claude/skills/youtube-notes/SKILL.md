---
allowed-tools: Task, Read, Write, Edit, Glob, Grep, Bash(mkdir:*), Bash(ls:*), Bash(rm:*), Bash(yt-dlp:*), Bash(mlx_whisper:*), Bash(ffmpeg:*), Bash(ffprobe:*), Bash(yt-transcript:*), Bash(/Users/tallam/.venv/bin/python:*)
argument-hint: <youtube-url> [output-directory]
description: Generate comprehensive lecture notes from YouTube videos or playlists
---

# YouTube Lecture Notes Generator

Create detailed, comprehensive lecture notes from YouTube videos or playlists using transcripts.

## Execution Strategy

- **Single video**: Process directly
- **Playlist (2+ videos)**: Use the Task tool to spawn parallel subagents (one per video) for concurrent processing. This provides near-linear speedup.

## Arguments

- `$1` = YouTube video or playlist URL (required)
- `$2` = Output directory path (optional, defaults to current directory)

## Instructions

1. **Parse and validate inputs**:
   - Validate YouTube URL format (accepts video URLs, playlist URLs, and youtu.be short links)
   - If `$2` is provided, create the output directory if it doesn't exist
   - Create `<output-dir>/transcripts/` directory for transcript storage

2. **Fetch transcripts (audio download + local transcription is the default)**:

   YouTube frequently bot-blocks transcript API requests ("Sign in to confirm you're not a bot"). The reliable default is to download the audio with `yt-dlp` (using browser cookies) and transcribe locally with `mlx_whisper` using Metal acceleration on Apple Silicon. Do not start with `yt-transcript` — it is kept only as a last-resort fallback.

   **Step 2a - Extract video/playlist IDs and fetch metadata** (for titles, indices, durations):
   ```bash
   yt-dlp --cookies-from-browser chrome --skip-download \
     --print "%(playlist_index|1)s|%(id)s|%(title)s|%(duration)s|%(uploader)s|%(upload_date)s" \
     "$1"
   ```
   Parse output to determine single video vs. playlist and build the filename index `XX`.

   **Step 2b - Download audio as mp3** (one invocation per video; parallelise via subagents for playlists):
   ```bash
   yt-dlp --cookies-from-browser chrome \
     -f 'bestaudio[ext=m4a]/bestaudio' \
     --extract-audio --audio-format mp3 --audio-quality 5 \
     -o '<output-dir>/transcripts/%(id)s.%(ext)s' \
     "<single-video-url>"
   ```
   - If cookie extraction fails (Chrome not running / locked keychain), retry with `--cookies-from-browser firefox` or `--cookies-from-browser safari`, then without cookies.
   - The `.mp3` files land in `<output-dir>/transcripts/{video_id}.mp3`.

   **Step 2c - Transcribe with mlx_whisper (Metal accelerated)**:
   ```bash
   mlx_whisper <output-dir>/transcripts/{video_id}.mp3 \
     --model mlx-community/whisper-large-v3-turbo \
     --output-dir <output-dir>/transcripts \
     --output-format txt
   ```
   - `mlx_whisper` uses the Apple Silicon GPU via Metal by default — do not pass CPU flags.
   - `whisper-large-v3-turbo` gives the best quality/speed trade-off. Downgrade to `mlx-community/whisper-medium` only if disk/memory is tight.
   - The timeout for a 2+ hour video should be generous: set Bash `timeout` to 600000 ms (10 min).
   - Output file is `<output-dir>/transcripts/{video_id}.txt`.

   **Step 2d - Rename to index format** so downstream steps match the expected `XX-{video_id}.txt`:
   ```bash
   mv <output-dir>/transcripts/{video_id}.txt <output-dir>/transcripts/XX-{video_id}.txt
   ```

   **Step 2e - Fallback only if audio pipeline fails entirely**:
   `yt-transcript --no-timestamps -o <output-dir>/transcripts "$1"`

   If every video fails both pipelines, report the error and exit.

3. **Process each transcript file**:
   - Read each `XX-{video_id}.txt` file from the transcripts directory
   - Extract video ID from filename
   - Construct YouTube URL: `https://www.youtube.com/watch?v={video_id}`
   - Use the transcript content to generate comprehensive notes

4. **Generate lecture notes** for each video at `<output-dir>/lecture-XX-{video_id}.md`:

   **Structure**:
   - **Header**: Title (derived from first substantive line or "Lecture XX"), YouTube link
   - **Table of Contents**: Anchor links to all major sections
   - **Main Content**: Detailed sections organised by topic from transcript
   - **Quick Reference**: Summary of key points at the end

   **Formatting Requirements**:
   - **MathJax equations**: Use `$...$` for inline, `$$...$$` for display equations
   - **GitHub alert admonitions**:
     - `> [!NOTE]` - general information and context
     - `> [!TIP]` - helpful suggestions and best practices
     - `> [!IMPORTANT]` - key concepts that must be understood
     - `> [!WARNING]` - cautions and potential pitfalls
     - `> [!CAUTION]` - critical warnings about dangerous mistakes
   - **Tables**: Use for comparisons, specifications, structured data
   - **Mermaid diagrams**: For block diagrams, flowcharts, and conceptual illustrations using ```mermaid code blocks
   - **ASCII diagrams**: For circuit diagrams only (Mermaid does not support circuit schematics)
   - **Code blocks**: For any code examples mentioned in the lecture

5. **Figure generation** (when transcript discusses visualisable concepts):

   Create `<output-dir>/figures/generate_figures.py` if diagrams are needed:

   ```python
   #!/usr/bin/env python3
   """Generate figures for YouTube lecture notes."""
   from pathlib import Path
   import matplotlib.pyplot as plt

   OUTPUT_DIR = Path(__file__).parent
   plt.style.use('default')

   def generate_lecture_XX_description():
       """
       Lecture XX: Description of what this figure shows.
       """
       fig, ax = plt.subplots(figsize=(10, 6))
       # ... plotting code ...
       plt.savefig(OUTPUT_DIR / 'lecture-XX-description.png', dpi=150, bbox_inches='tight')
       plt.close()
       print("Created: lecture-XX-description.png")

   def main():
       OUTPUT_DIR.mkdir(exist_ok=True)
       # Add function calls here
       generate_lecture_XX_description()

   if __name__ == '__main__':
       main()
   ```

   - Run with: `/Users/tallam/.venv/bin/python <output-dir>/figures/generate_figures.py`
   - Use naming convention: `lecture-XX-{description}.png`
   - Use matplotlib for plots, waveforms, graphs, and data visualisations
   - Use Mermaid for block diagrams and flowcharts (include in lecture notes as ```mermaid code blocks)
   - Use ASCII art for circuit diagrams only (include in lecture notes directly)
   - Reference figures in notes with relative paths: `figures/lecture-XX-description.png`

6. **Index generation** (playlists only):
   - For playlists with 2+ videos, create `<output-dir>/index.md`
   - Include: playlist title, link to original playlist, table linking to all lectures, summary of topics covered

7. **Verification**:
   - Use the Task tool to spawn a `verification-agent` subagent
   - Verify all generated files: structure validation, MathJax syntax balanced, anchor links valid, figure references exist, no placeholder text
   - Report any issues found

8. **Report summary**:
   - Report: "Generated X lecture notes in <output-dir>"
   - Include verification status (PASSED/FAILED)
   - Note: Transcripts are preserved in `<output-dir>/transcripts/`

## Output Structure

```
<output-dir>/
  index.md                      (playlists only)
  lecture-01-{video_id}.md
  lecture-02-{video_id}.md
  ...
  transcripts/
    01-{video_id}.txt           (mlx_whisper transcript)
    01-{video_id}.mp3           (cached audio — keep for re-transcription)
    02-{video_id}.txt
    02-{video_id}.mp3
    ...
  figures/                      (if figures generated)
    generate_figures.py
    lecture-01-*.png
    lecture-02-*.png
```

Keep the `.mp3` audio files alongside the `.txt` transcripts so the lecture can be re-transcribed with a different Whisper model without a second download (YouTube rate-limits and cookies can become invalid).

## Example Usage

```bash
# Single video to current directory
/youtube-notes https://www.youtube.com/watch?v=dQw4w9WgXcQ

# Playlist to specified directory
/youtube-notes https://www.youtube.com/playlist?list=PLrAXtmErZgOeiKm4sgNOknGvNjby9efdf ./rust-lectures

# Short URL to specific path
/youtube-notes https://youtu.be/VIDEO_ID ~/lectures/topic-name
```

## Quality Checklist

- [ ] All transcript content covered comprehensively
- [ ] Equations formatted with MathJax where applicable
- [ ] GitHub admonitions used for key insights
- [ ] Signal plots/diagrams rendered when transcript discusses visualisable concepts
- [ ] Mermaid diagrams for block diagrams and flowcharts
- [ ] ASCII diagrams for circuit schematics only
- [ ] Link to original YouTube video included
- [ ] Table of contents with working anchor links
- [ ] Quick reference section included
- [ ] Index file created (playlists only)
- [ ] Verification subagent run and passed
- [ ] Transcripts preserved in transcripts/ folder

## Figure Styling Requirements

When generating figures:
- Use `plt.style.use('default')` for light theme
- Set DPI to 150
- Include proper axis labels and titles
- Add annotations where helpful
- Use consistent colours across related figures
- Use `bbox_inches='tight'` to avoid clipping

## Notes on Content Extraction

- The transcript may not have explicit section breaks; identify natural topic transitions
- Look for phrases like "let's talk about", "moving on to", "now we'll cover" to identify sections
- Extract any mentioned URLs, references, or resources
- Identify and highlight key terminology and definitions
- Convert spoken explanations of formulas into proper MathJax notation
