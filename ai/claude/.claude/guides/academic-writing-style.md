# Academic writing style guide (Tarek's voice)

Date: 2026-08-06. Sources: style-extraction pass over the author's PhD thesis
(`~/github/tallamjr/origin/phd-thesis`, abstract + atx/deploy/conclusions
chapters, with verbatim evidence and grep counts) and a TMLR/arXiv
title-convention research pass (verbatim title collections from
jmlr.org/tmlr/papers and OpenReview MLRC reports). Apply to every academic
paper, thesis chapter, or similar scholarly prose drafted for this author,
in any repository.

## Title conventions (TMLR)

- Full declarative-sentence titles ("X Surfaces Y in Z") do not appear in the
  sampled TMLR corpus; they are a punchy-subgenre thing ("ResNet Strikes
  Back"), not a journal convention. Avoid.
- The reproducibility-study convention is near-universal:
  `Reproducibility Study of "<original title>"` or
  `<Method>: A Reproducibility Study [with <what is added>]`
  (e.g. "ModernTCN Revisited: A Reproducibility Study with Extended
  Benchmarks and an Architectural Improvement").
- Other dominant TMLR shapes: noun phrase ("Realistic Evaluation of ..."),
  "On the X of Y", "Revisiting X", occasional question titles.
- The author's own thesis headline style is long, colon-structured,
  descriptive ("Deep Learning Deployment: Scaling Inference for Real-time
  Classification using Deep Model Compression"), which composes well with
  the TMLR subtitle convention.

## The author's voice (10-rule imitation checklist, evidence-backed)

1. Open results-bearing sentences with "We" + a strong verb (achieve, show,
   find, present, introduce). Never "It was found that". ("we achieve a
   logarithmic-loss of 0.739", thesis abstract.)
2. Build sentences toward the claim: context and setup first, the quantified
   result lands at the end. Average thesis sentence runs 30-45 words; one
   short blunt sentence is permitted as a paragraph-closing punch.
3. Attach a number to every claim and pair it with an explicit baseline
   ("$18\times$ reduction in model size", "0.450 compared to 0.468").
4. British spelling throughout (-ise, colour, optimisation, artefact).
5. Cite parenthetically (`\citep`) at the end of a clause by default; promote
   to `\citet` only when crediting the idea itself ("As put forward
   by~\citet{chollet2017xception}...").
6. Introduce every acronym as "Full Term (ACRONYM)" at first use.
7. Hedges (may, could, suggests, indicates, "It is suspected that") belong in
   discussion/limitations/future-work passages only, never inside a headline
   results sentence. Negative results are stated plainly, then a firm
   conclusion is drawn ("...proved to be detrimental to performance.").
8. No em-dashes, no rhetorical questions in the author's own voice, and no
   reflexive "not X but Y" antithesis. (Thesis corpus: zero em-dashes; every
   question mark is inside quoted material.)
9. Paragraphs of 4-7 sentences with topic-sentence discipline.
10. Default transitions: However, Therefore, Furthermore, As such,
    Consequently, Moreover. "novel" and "state-of-the-art" are part of the
    register but capped at once or twice per section.

Vocabulary fingerprint worth reusing where natural: "at a fraction of the
computational cost", "coupled with", "leverage", "robust", "showcase",
"lightweight", "It is worth noting", "goes beyond". Figures are the agent of
showing: "Figure X shows...", occasionally "as shown in Figure X".

## ML-venue prose rules (from TMLR guidelines and respected guides)

- TMLR's first review criterion is that claims are supported by accurate,
  convincing, clear evidence; every quantitative claim in title/abstract must
  have a matching number in the results (jmlr.org/tmlr/reviewer-guide.html).
- TMLR's second criterion is audience interest, explicitly not novelty; a
  reproduction/audit is a first-class contribution type there.
- One paper, one idea: pick the single most load-bearing claim for the title;
  the rest live in the abstract (Peyton Jones, "How to Write a Great Research
  Paper").
- If the first sentence could be prepended to any ML paper, delete it
  (Lipton and Steinhardt, "Troubling Trends in Machine Learning Scholarship").
- Attribute empirical gains to their true source; do not credit "the
  reimplementation" vaguely when the mechanism is the training loop
  (Lipton and Steinhardt).
- No mathiness: an equation earns its place only when it is more precise than
  the sentence it replaces (Lipton and Steinhardt). Corollary adopted by the
  author: equations go only where a finding literally lives in a term of the
  formula (e.g. a floor-vs-truncate distinction inside a kernel), and
  nowhere else.
- Centre the paper on 1-3 precise, falsifiable claims (Foerster).
- Most readers stop at title + abstract; spend effort there proportionally
  (Farquhar).
