---
disable-model-invocation: true
description: Use when tightening the prose of an academic paper (LaTeX or markdown draft) to read like a top-tier conference accept, or when the user asks for an "academic prose sweep", to align an abstract/intro/method/results/limitations with venue conventions (ICRA, RA-L, NeurIPS, ICML, CVPR) while preserving the author's voice.
---

# Command: Academic Prose Sweep

## Purpose
Revise a paper draft so its language and structure match top-tier conference conventions, weighted to the target venue, while keeping the author's voice. This is a prose and structure pass, never a change to technical content, numbers, claims, or citations. If a claim is unsupported, flag it; do not invent evidence to prop it up.

This command subsumes the narrow `filler-language-sweep` (stance words + antithesis reflex) and adds the full academic-structure layer. Run the checks in section 6 as part of this sweep; you do not need to run `filler-language-sweep` separately.

## Parameters
- Optional path (file or directory) to scope the sweep. With no argument, ask which file(s).
- Optional target venue. If not given, infer from the file (document class, `\bibliographystyle`, comments) or ask. Default profile weighting is ICRA/RA-L for robotics, NeurIPS/ICML for ML, CVPR for vision. When venue and author voice conflict, ask the user which wins, or default to a venue-weighted blend.
- Optional aggressiveness: conservative (fix clear weak-prose only), moderate (tighten throughout), assertive (rework phrasing section by section). Ask if unstated; default moderate.

## Hard constraints (never violate)
- Do not change any number, unit, result, equation, claim strength beyond what the evidence supports, citation, or label. Preserve `\ref`, `\label`, `\cite`, math, and figure/table content exactly.
- Preserve the author's spelling convention (British by default for this author: whilst, minimise, optimise, parametrise, generalise).
- No em-dashes or en-dashes as punctuation; no spaced `--` as an em-dash in prose. Replace with a comma, colon, semicolon, brackets, or a sentence break.
- No self-characterising stance words (honest, honestly, faithful, faithfully, truly, genuinely, candidly, "to be clear"). Cut them or name the concrete property.
- No antithesis reflex ("X, not Y" / "it's not A, it's B") as a habit. One informative instance per section is fine; rewrite clusters to plain statements without relocating the foil.
- Keep every sentence readable: split any sentence past ~40 words unless it is a genuinely necessary enumeration.

## 1. Abstract (venue-shaped)
Robotics (ICRA/RA-L) abstract in five moves, one sentence each where possible: (1) why the problem matters, field-level, not "In this paper we...", (2) the shortcoming of the closest prior work, one sentence, (3) the approach with the system named at this move, (4) the headline result with a number, unit, and dataset, (5) the real-world validation. ML/vision: sentence 1 is a flat problem statement or "We present X"; no background throat-clearing; still land the headline number and a scope or caveat.
- Name the system once, glossed in one line, then reuse verbatim. No citations or undefined acronyms in the abstract.
- The abstract must advance verifiable claims, not adjectives. Every sentence should be checkable against a table, figure, or theorem.

## 2. Introduction
Funnel: problem and why it matters -> what standard approaches do badly -> the insight -> an explicit contribution list. State the gap as a specific missing capability tied only to what the paper needs, without being needlessly negative. End with a parallel contribution list: each item a noun phrase of the same grammatical shape, stated in verbs not novelty adjectives, at least one carrying a number, and (for a systems/integrity paper) one naming the integrity or safety capability.

## 3. Method (staged pipeline)
Open with a one-paragraph overview that names every stage as a noun, keyed to the system figure, then one subsection per stage. Describe each stage as input -> operation -> output in present tense, with at least one equation or a precisely named operation. Never motivation-only: a stage paragraph must say what it computes, not only what it is for. Kill vague verbs ("handles", "deals with", "is responsible for"). Gloss every symbol in-line immediately after it appears, via a "where ..." clause.

## 4. Results and claims (rigour)
- Every performance claim carries a number, a unit, and the condition it was measured under; bind it to a threshold or error budget where one exists.
- State deltas as a signed comparison against a named baseline. Report where the method loses, at the same granularity as where it wins.
- Graded claim verbs matched to effect size: can improve < improves < consistently improves < substantially improves < significantly improves (only with a stated statistical test) < state-of-the-art (only against named competitors on a named benchmark).
- Report central tendency with variance over a stated number of runs/seeds where applicable.
- Declare simulation-vs-real scope explicitly. Never let a simulation number read as a field number; label sim-only magnitudes as such in prose and captions.
- Reference every table/figure actively and state its takeaway ("Table 2 shows X beats Y by Z"), not "results are shown in Table 2".
- Reserve a "first" claim for a scoped, defended version.

## 5. Limitations and integrity wording
- Keep a dedicated Limitations paragraph or section; show weaknesses on purpose; word them as factual boundaries, not apologies or hype-recovery.
- Name the strong assumptions and what breaks if they fail, in the same sentence as the claim they gate.
- For integrity/safety claims, use the standard vocabulary (integrity risk, protection level, alert limit, hazardously misleading information, calibration) only where the paper actually computes those quantities. Do not adopt formal terms the results do not support. Frame refusal-to-answer as a conditioned decision with a consequence, not a failure. Report correct-refusal, false-refusal, and undetected-error rates and ellipse calibration separately from accuracy. Never write "guaranteed safe".

## 6. Weak-prose scrub (mechanical checks)
- Stance words: `grep -nIiE '\b(honest|honestly|faithful|faithfully|truly|genuinely|candidly)\b|to be clear' <scope>` must be empty (or every hit explained as a literal/identifier).
- Dashes: no `\x{2014}`/`\x{2013}` and no prose `--`. On macOS BSD grep, use python: read the file and flag lines containing the em/en dash characters.
- Antithesis: scan by eye for ", not Y" / "it's not A, it's B" / "not just ... but"; keep one informative instance per section, rewrite clusters to plain statements.
- Hype adjectives with no number (novel, powerful, robust, seamless, highly accurate, state-of-the-art as a bare boast): replace with the measured quantity.
- Empty intensifiers (very, highly, extremely, clearly, obviously) and "we believe / we think / arguably": cut or replace with evidence.
- System-name consistency: the system is named once and reused verbatim; normalise stray casing. Leave literal package names, code identifiers, and domain terms (e.g. the astronomical "the zenith") untouched.
- Tense: present for what the paper and system do; past for experiments performed.
- Voice: active "we" for what the authors did; passive only where the actor is the system or irrelevant. "We present/propose" for the artifact; "we show/demonstrate" for evidence.

## 7. Author voice to preserve
- British spelling; funnel-in openers; one short evocative opening sentence is allowed before technical content.
- Active first-person plural default; explicit generalisation hedges ("It should be noted that ...", "one may expect ...", "We acknowledge ...").
- Transitions: "Furthermore,", "Moreover,", "However,", "To this end,"; concessive "whilst". Do not over-apply; density of the same connective reads as machine-drafted.
- Do not flatten the voice into generic conference boilerplate. When a vivid, accurate phrase is in the author's register, keep it.

## Workflow
1. Confirm scope, venue, and aggressiveness (ask only what you cannot infer).
2. Read the whole file first. Never edit before reading.
3. Sweep section by section in document order, applying sections 1-7 above. Prefer many small exact-string edits; match the file's line wrapping when replacing multi-line prose.
4. For LaTeX, rebuild after the edits (`make pdf` or `latexmk`) and confirm it compiles and the page count is sane.
5. Run the section 6 mechanical checks; every stance-word/dash hit must be zero or explained.
6. Deploy a verification subagent to re-read the changed sections against this skill and confirm no number, claim, or citation was altered and no banned pattern was introduced.

## Completion report
- Files scanned and changed; venue profile and aggressiveness used.
- Per-section summary of what changed (abstract structure, contribution list, method overview, claim scoping, limitations, name consistency), each as a one-line before/after.
- What was deliberately not changed and why (e.g. a formal integrity term the results do not yet support).
- Final mechanical-check output (stance words, dashes) with any remaining hit explained.
- Confirmation the LaTeX still builds and the page count.
