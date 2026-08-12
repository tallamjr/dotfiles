---
disable-model-invocation: true
description: Use when sweeping a repo, docs, or prose for filler and self-characterising stance words (honest, genuinely, faithful, truly, to be clear) and the habitual "X, not Y" / "it's not A, it's B" antithesis construction, or when prose reads as machine-drafted and you want to scrub those tics in place.
---

# Command: Sweep Filler Language

## Purpose
Remove two machine-drafted prose tics that the user's global style rules forbid:

1. **Self-characterising stance words** that tell the reader how to regard the work instead of letting facts carry it.
2. **The antithesis / "not-but" construction** used as a habitual device.

These are different failures and get treated differently. Stance words get cut wholesale. The antithesis only gets rewritten where it is a reflex; an occasional one that carries real information stays.

## Parameters
Optional argument: a path (file or directory) to scope the sweep. With no argument, ask the user for scope before starting (which files; markdown only, or code comments too). Do not guess scope on a large repo.

## Scope
Sweep prose, never executable code:
- Markdown and text docs (`.md`, `.txt`, `.rst`)
- Code comments and docstrings (Rust `//` `///` `//!`, Python `#` and `"""`, JS/TS `//`), when the user includes code in scope
- README, CHANGELOG, and other project prose

**Never touch:** identifiers, string literals, test assertions, code logic, CLI flags, file paths, or any dash/word inside quoted external material. A stance word that is a literal value (e.g. a variable named `is_honest`, or the phrase "true noise level" meaning a numeric input) is not prose; leave it.

## Failure 1: stance words (cut wholesale)
Target list: `honest`, `honestly`, `faithful`, `faithfully`, `truly`, `genuinely`, `candidly`, `to be clear`.

Detect with grep:
```bash
grep -rnIiE '\b(honest|honestly|faithful|faithfully|truly|genuinely|candidly)\b|to be clear' <scope>
```

Rule: **cut the word.** Do not replace it with another stance word (`true`, `real`, `actual` used as reassurance are the same move). Two outcomes only:
- The word added nothing: delete it. "an honest 2-sigma ellipse" -> "a 2-sigma ellipse".
- The word stood in for a concrete technical property: name that property. "the covariance is honest" -> "the covariance is calibrated"; "the render is honest" -> "the render is corrected"; "the honest denominator" (counts every opportunity) -> "the full denominator". Never delete and leave a grammatical gap.

`genuinely`/`truly` modifying a noun ("genuinely different stars") often means *physically distinct* vs *noise-apparent*; replace with the precise word (`physically distinct`, `separate`) rather than dropping it if the distinction is the point.

## Failure 2: the antithesis (rewrite only the reflex)
Shapes to scan for (grep is unreliable here; read candidates by eye):
- "X, not Y" / "..., not Z." at the end of a clause
- "it's not A, it's B" / "it is not A; it is B"
- "not just / not merely / not only X, but/it/they Y"
- "the point is not that ..., but that ..."

Decision:
- **Keep** an occasional one that carries real information ("reads go to the replica, not the primary" names two real targets; "a biased measurement is worse than none" is a genuine comparison, not a not-but pivot). One per section reads as deliberate.
- **Rewrite** when they cluster (two or more in a paragraph) or when the negated foil adds nothing ("a deliberate choice, not an accident" -> "a deliberate choice").

**The critical rule when rewriting: do not relocate the foil.** Restructure to a plain statement. A "fix" that still contains "not ... but ..." has not been fixed.

```
BAD  original: The point is not that LRU is optimal in general, but that it is the right fit here.
BAD  "fix":    LRU is not optimal in general, but it is the right fit here.   <- same device, moved
GOOD fix:      LRU is the right fit here, though it is not the general optimum.
```

When you must keep a real contrast, prefer a colon or a plain sentence over the rhetorical pivot.

## Leave alone
- Genuine comparisons: "slower than", "worse than", "more accurate than".
- Plain negatives that are not a not-but pivot: "It is not an obvious choice" (a statement, no Y foil).
- Technical distinctions stated once: "the centre of the disc, not its limb".
- Anything inside a quotation.

## Verification
After editing:
```bash
# stance words must be zero (or every remaining hit explained as a literal/identifier)
grep -rnIiE '\b(honest|honestly|faithful|faithfully|truly|genuinely|candidly)\b|to be clear' <scope>
```
Then re-read each file: confirm surviving `, not` / `rather than` instances each carry information, no rewrite reintroduced a not-but, and no replacement left a grammatical gap. If code comments were touched, the change is prose-only so the build is unaffected; do not run the test suite for this sweep.

## Completion report
- Files scanned and files changed
- Stance words cut, with any concrete-property replacements listed
- Antithesis instances rewritten vs deliberately kept, with one-line reasoning for the kept ones
- Final grep output (should be empty) with any remaining hit explained
