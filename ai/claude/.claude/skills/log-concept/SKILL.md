---
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(mkdir:*), Bash(ls:*), Bash(git:*)
argument-hint: [topic-slug]
description: Capture concept-level understanding from the current conversation into a structured concept note in the user's personal knowledge base at ~/github/tallamjr/origin/learn/kb/. Asks one structured clarifying question (topic, folder, sources, emphasis), drafts the note using the KB's fixed template, presents the draft for approval, and writes the approved note plus updates _quarto.yml. Never modifies existing notes, never runs git or quarto commands, never writes notes without at least one source entry. For notes produced from external source material (lectures, videos, courses), use the notes / coursera-notes / youtube-notes skills instead -- this skill is specifically for conversation-derived synthesis.
---

# log-concept

Capture concept-level understanding from the current conversation into the user's personal knowledge base at `/Users/tallam/github/tallamjr/origin/learn/kb/`, as a structured concept note conforming to the KB's fixed template.

This skill is fundamentally a **scribe**. The understanding already exists in the conversation -- your job is to extract it, distil it into the template, get user approval on the draft, and write it to disk after the user says yes. You are not a teacher, researcher, or content generator; you have no creative latitude beyond faithfully transcribing the discussion into the template structure.

## When to use

Invoke when the user says `/log-concept` (optionally with a topic slug argument, e.g. `/log-concept rise-time`) at any point in a conversation where concept-level understanding has emerged and the user wants it captured.

**Do not use this skill for:**

- Notes derived from external source material (a lecture, video, or course). Use `notes`, `coursera-notes`, or `youtube-notes` for that -- those skills work source-in, notes-out; this one works conversation-in, notes-out.
- Rendering an existing folder of notes as a Quarto book. Use `quarto-book` for that -- the KB is already a Quarto book and does not need to be re-scaffolded.
- Updating an existing note. The skill refuses to silently overwrite and will ask the user whether to update the existing file or create a new slug.

## Preconditions

The user's KB is expected to live at `/Users/tallam/github/tallamjr/origin/learn/kb/` with this layout:

```
learn/kb/
├── README.md
├── _quarto.yml
├── Makefile
├── index.qmd
├── .template.md
├── .gitignore
├── figures/
│   └── generate_figures.py
└── <topic-folder>/
    └── <concept-slug>.md
```

If `learn/kb/` does not exist, the skill bootstraps it (see Edge Cases).

## The note template

Every note produced by this skill conforms to the template below. The frontmatter fields are exactly these -- no extras, no omissions.

````markdown
---
title: "Human-readable concept title"
tags: [topic, subtopic, more-tags]
sources:
  - label: "Source Label"
    local: /absolute/filesystem/path/to/source.md
    github: https://github.com/user/repo/blob/main/path/to/source.md
    lines: "253-399"
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

(Opening paragraph: a one-sentence thesis followed by why this concept is
worth remembering.)

## 1. First facet of the concept

Prose, math with `$$...$$` blocks, tables where they help.

> **Reference:** [Source Label][src-1], lines 253-399

## 2. Second facet

...

## N. Final facet or synthesis

...

## Physical intuition

(Longer prose capturing the *feel* of the concept.)

## Conceptual chain

```
idea 1
  |
  +--- connects to idea 2
           |
           +--- which implies idea 3
```

## Quick reference

| Topic | Source | Lines |
|---|---|---|
| First facet | [Source][src-1] | 253-399 |

[src-1]: https://github.com/user/repo/blob/main/path/to/source.md#L253-L399
````

Key rules for the template:

1. **No H1 in the body.** Quarto renders the title from frontmatter. Section headers are H2 (`##`).
2. **Numbered facets** use `## 1. Name`, `## 2. Name`, etc.
3. **Reference-style links** are defined at the bottom of the file. Prose cites them as `[Source Label][src-1]`.
4. **All `sources[].github` URLs** must use line anchors (`#L<start>-L<end>`) when `lines` is specified.
5. **British English** throughout. Use *organise*, *behaviour*, *recognise*, *synthesise*, *formalise*.
6. **No emojis** anywhere.

## Workflow

When the user invokes `/log-concept [topic-hint]`, execute these steps in order.

### Step 1: Scan the conversation for the concept

Read back over the conversation context to identify:

- The main thesis (the one-sentence version of the concept)
- Numbered facets -- discrete sub-ideas or claims
- Math expressions used in the discussion (keep LaTeX as-is)
- Source materials cited, referenced, or discussed (files, URLs, book titles)
- Analogies, physical intuitions, mental models the user resonated with
- Any ASCII diagrams, tables, or structured summaries produced

If a `topic-hint` argument was supplied, focus on that concept. If not, identify the most substantive concept discussed.

### Step 2: Present the structured clarifying question

Show the user one structured question with pre-filled guesses. The user can accept all defaults ("yes to all") or override any field.

Template (substitute your best guesses):

```
Ready to log. Check these inputs -- press through defaults if they look right,
or correct any field:

  Topic slug   : <your-guess-slug>
  Folder       : kb/<your-guess-folder>/ (existing | new)
  Sources      : [<list of inferred sources with labels and line ranges>]
                 -- add/remove?
  Emphasis     : none -- anything to weight more heavily in the note?
```

For each source, include the label and, if known, the approximate line range. The user may add sources not discussed in the conversation.

Wait for the user's response before proceeding.

### Step 3: Resolve sources to the full structured form

For each source the user confirms or adds, determine the full structured form:

```yaml
- label: "Human-readable label"
  local: /absolute/filesystem/path/to/source
  github: https://github.com/user/repo/blob/<branch>/path/to/source
  lines: "253-399"
```

- **`local`** is the absolute filesystem path. Resolve relative paths discussed in the chat to absolute ones using the current working directory context. Never use `~` -- expand to `/Users/tallam/...`.
- **`github`** is the stable GitHub URL. If the source lives in a git repo, use `git remote get-url origin` to determine the owner/repo, and the current default branch (usually `master` or `main`) to construct the URL. If the repo has no GitHub remote or is not pushed, leave `github` as an empty string (`""`) and warn the user.
- **`lines`** is an optional string (not a number or range) specifying the relevant line range, e.g. `"253-399"`.

If the user confirms sources that resolve cleanly, proceed. If any source is ambiguous or cannot be resolved, ask for clarification before drafting.

### Step 4: Draft the note

Construct the full note as a single markdown document. Frontmatter first, then body in the template rhythm:

1. **Thesis paragraph** -- one sentence stating the concept, one sentence explaining why it matters. Distil from the conversation; do not invent claims not discussed.
2. **Numbered facets (`## 1.`, `## 2.`, ...)** -- one facet per discrete sub-idea. Include math, tables, and the inline reference blockquote pattern (`> **Reference:** [Label][key], lines X-Y`) where appropriate.
3. **Physical intuition** -- a longer prose section capturing the feel of the concept in words alone, no equations. Use the analogies and mental models from the conversation.
4. **Conceptual chain** -- an ASCII diagram or nested list showing how the facets connect. If the conversation already produced such a summary, reuse it.
5. **Quick reference** -- a small table of topics, sources, and line ranges.
6. **Reference-style link manifest at the bottom** -- `[src-1]: https://github.com/...#L1-L100` for each source, auto-generated from the `sources:` frontmatter.

Use British English. No emojis.

### Step 5: Present the draft for approval

Show the full draft to the user as a single markdown block. Ask:

```
Draft ready. Full content above. Approve, request edits, or cancel?
  - "yes" / "approve"  -> I write the file and update _quarto.yml
  - "edit <section>: <change>"  -> I revise and show you the new draft
  - "cancel"  -> nothing is written
```

Wait for the user's response.

### Step 6: Handle the approval response

- **On "yes" / "approve"**: proceed to Step 7.
- **On "edit <section>: <change>"**: revise the draft per the requested edit and return to Step 5 with the revised draft.
- **On "cancel"**: stop. Do not write anything. Reply: `Cancelled. Nothing written.`

### Step 7: Write the note to disk

Write the approved note to `/Users/tallam/github/tallamjr/origin/learn/kb/<folder>/<slug>.md`.

If `<folder>` does not already exist under `kb/`, create it first:

```bash
mkdir -p /Users/tallam/github/tallamjr/origin/learn/kb/<folder>
```

Use the Write tool to create the note file.

### Step 8: Update `_quarto.yml`

Read `/Users/tallam/github/tallamjr/origin/learn/kb/_quarto.yml`. Determine whether the topic folder already has a `part:` entry under `book.chapters:`.

**Case A -- the topic folder already has a part:** append the new note to the existing part's `chapters:` list. Use Edit to insert the new line in alphabetical order (or at the end if alphabetical is ambiguous).

**Case B -- the topic folder is new:** append a new part entry to `book.chapters:`. The part title is the folder name title-cased (e.g., `electronics` -> `Electronics`). Example addition:

```yaml
    - part: "Electronics"
      chapters:
        - electronics/rc-and-rise-time.md
```

Preserve existing YAML formatting, indentation, and ordering. Do not reflow the file.

### Step 9: Report completion

Reply to the user with a concise confirmation:

```
Written to kb/<folder>/<slug>.md.
Added to _quarto.yml under <part name> (new part | existing part).
Run `make` in learn/kb/ to render the book and see the new note.
```

Do not run `make` or `quarto render` yourself. Do not run any `git` command. The user owns the build and commit workflow.

## Edge cases

| Situation | What to do |
|---|---|
| `learn/kb/` does not exist | Announce the one-time bootstrap: *"`learn/kb/` does not exist yet -- bootstrapping the full Quarto book skeleton before writing this note."* Then scaffold the files listed in the spec with the exact contents. After the scaffold is in place, resume at Step 2. |
| Topic folder does not exist under `kb/` | Create the folder in Step 7. Add a new `part:` entry in Step 8 (Case B). Announce the new part in Step 9. |
| A note with the same slug already exists | Stop in Step 2 and ask: *"`kb/<folder>/<slug>.md` already exists (created YYYY-MM-DD). Do you want to (a) update it -- merge new material into the existing note, bumping `updated:` -- or (b) pick a different slug for a separate note?"* Never silently overwrite. Updating is only allowed if the user explicitly opts in. |
| No sources can be found in the conversation | Ask in Step 2: *"I couldn't find sources in our discussion. Where did this understanding come from? Give me at least one -- a file path, a URL, or a book title."* Never write a note with an empty `sources:` list. |
| User says "no sources, this is pure reflection" | Allow it explicitly, using a single source entry: `- label: "Personal synthesis"` with `local: ""`, `github: ""`, `lines: ""`. Confirm the user's intent before writing: *"I'll mark the source as 'Personal synthesis' -- confirm?"* |
| A source is in a repo not pushed to GitHub | Fill `local` with the absolute path and leave `github` as `""`. Warn the user: *"Source X has no GitHub URL -- the prose link will not be clickable in the rendered book. Push the repo to GitHub if you want clickable source links."* The reference-style link at the bottom of the file still appears but has no target. |
| The conversation covered multiple concepts | Capture only one per invocation. If the topic argument is ambiguous or missing, ask in Step 2: *"I see two concepts we've discussed: (a) X, (b) Y. Which one should I capture now? The other can be captured with a second `/log-concept` invocation."* |
| Conversation context is too sparse for a good note | Refuse the capture: *"I don't have enough from the conversation to write a good note -- we've only touched the topic briefly. Want to discuss it a bit more first, or write the note by hand from `kb/.template.md`?"* Better to refuse than ship a shallow note. |

## Invariants -- things this skill must never do

1. **Never** write a note with an empty or missing `sources:` list. The "Personal synthesis" escape hatch is the only allowed source-less case, and it must be explicitly confirmed.
2. **Never** modify existing notes. Updates require explicit user opt-in via the "update vs new slug" question.
3. **Never** rename or delete files.
4. **Never** run `make`, `quarto render`, `quarto preview`, or any `quarto` CLI command.
5. **Never** run any `git` command -- no `git add`, no `git commit`, no `git push`.
6. **Never** edit files outside `/Users/tallam/github/tallamjr/origin/learn/kb/`. The one exception is the bootstrap case, where the skill creates new files inside `kb/` as part of first-time setup.
7. **Never** generate figures automatically. Figures are added only by explicit user request during the draft step.
8. **Never** auto-link to other notes (`related:` frontmatter is not used in this version).
9. **Never** invent claims, equations, or references that were not present in the conversation. If a source is needed and the conversation doesn't have it, ask.
