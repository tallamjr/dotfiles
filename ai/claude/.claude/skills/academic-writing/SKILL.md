---
name: academic-writing
description: Use when drafting or editing academic prose in any repository: papers, thesis chapters, abstracts, introduction/methods/results/related-work sections, journal or conference submissions (TMLR, NeurIPS, ICML, ICRA, arXiv), camera-ready or rebuttal text, whether in LaTeX, Quarto, or markdown. Not for documents that merely use LaTeX or Quarto without being academic content (CV, cover letter, beamer talk slides, invoices, personal notes).
---

# Academic Writing (author's voice)

## Overview

All academic prose written for this author must match their PhD-thesis voice.
The canonical, evidence-backed style guide lives at
`~/.claude/guides/academic-writing-style.md`.

## Workflow

1. Read `~/.claude/guides/academic-writing-style.md` in full before drafting
   or rewriting a single sentence.
2. Draft following its 10-rule voice checklist, TMLR title conventions, and
   ML-venue prose rules.
3. For a venue-convention revision pass over an existing draft, the
   `academic-prose-sweep` command exists as a separate manual step; this
   skill governs prose as it is drafted.

## When NOT to apply

- The document is not academic content. A CV, cover letter, beamer slide
  deck, reference letter, or invoice may be written in LaTeX; the file
  extension does not make it academic. State in one line that the academic
  voice guide is not being applied and why, then follow only the general
  writing rules in the user's CLAUDE.md.
- The user says to skip the academic style for this document or session
  (e.g. "don't use the academic voice here"). Respect it immediately and do
  not re-ask for the rest of the session.
- Genuinely ambiguous cases (e.g. a technical blog post or grant proposal):
  ask one short question, "Apply your academic thesis voice to this, or keep
  it informal?", rather than guessing.
