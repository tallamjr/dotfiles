# Personal Development Guidelines

Global preferences and standards loaded into every Claude Code session. These apply across all projects regardless of working directory; project-specific guidance lives in each project's own CLAUDE.md.

## Execution Preferences

- When executing implementation plans, always use the subagent-driven approach (superpowers:subagent-driven-development). Never ask to choose between subagent-driven and inline execution -- subagents are always preferred.
- Do not use git worktrees for feature, fix, or issue work. Work on a branch in the current checkout instead (`git checkout -b <branch>`). Worktrees are hard to track across a long session and I find them confusing to follow. This overrides any skill default that calls for creating a worktree, including superpowers:using-git-worktrees and the isolation step in superpowers:subagent-driven-development. Only use a worktree when I explicitly ask for one by name.
- Before telling me that a Claude Code product feature (a slash command, dynamic workflow, setting, or tool such as `/deep-research`) does not exist or is not enabled, check the `docs` skill (`claude-docs-helper.sh`) or dispatch the `claude-code-guide` agent first. A search of `.claude/skills/`, `.claude/commands/`, or `.claude/workflows/` coming back empty only rules out a project-defined skill; bundled Claude Code features live in the product itself, not on disk, so an empty filesystem search is not evidence they are missing. Only report "not found" after the docs check also comes back empty.
- Never write specs, plans, design docs, brainstorming notes or any similar working artifacts into a tracked `docs/` directory. These always live in an untracked folder under `lib/` (e.g. `lib/specs/`). Ensure that folder is listed in `.gitignore`. This overrides any skill default (such as the brainstorming skill's `docs/superpowers/specs/` path).
- The `lib/` working-docs folder follows a fixed taxonomy; scaffold it in a new repo with the `lib-init` script (creates the subfolders, writes `lib/STRUCTURE.md`, and gitignores `lib/`). The subfolders: `lib/research/` (deep-research and prior-art reports), `lib/roadmap/` (living project state: sub-projects log, assumptions register, accuracy or error budget, validation roadmap; read these first when resuming and keep them current), `lib/specs/` (design specs, one per sub-project), `lib/plans/` (implementation plans), `lib/reviews/` (review findings), `lib/issues/` and `lib/pr/` (GitHub issue and PR body drafts staged before publishing), `lib/notes/`, `lib/prompts/`, `lib/handoff/`. Durable published docs still live in `docs/` or the README; `lib/` is the workshop. Do not gitignore `lib/` in a repository that uses `lib/` for source code (the `lib-init` script refuses this automatically).

## Communication Preferences

- Keep explanations short and digestible by default. Lead with the answer, use brief paragraphs, and avoid long preambles or exhaustive breakdowns. The user is dyslexic and finds walls of text harder to process -- they will ask follow-up questions for more depth when they want it. This applies to all explanatory output, including educational insight blocks in explanatory mode (keep these to 2-3 tight bullets).
- Use plain language; avoid jargon and invented shorthand. Before outputting text, ask: is this simple, and does it avoid jargon? Never coin colourful stand-ins for ordinary facts ("the full battery was green" for "all tests passed" is the canonical offender; likewise "landed", "rode along", "seam", "gate" as unexplained nouns). "Gate" in particular is overused and confusing: say "blocker", "required step", or "a check that must pass" instead. Say the plain thing: "all tests passed", "I committed the change", "the fix is included in that commit". Technical terms the project itself uses (commit, branch, PR, checkpoint) are fine; project-internal codenames and metaphors are not, unless defined right where they are used.
- Write all chat replies to me in ASD-STE100 Simplified Technical English. Keep sentences short (max 20 words for instructions, max 25 for descriptions). Use the active voice. Give one instruction per sentence. Use one term for one thing; do not vary words for style. Use simple verbs ("do", not "perform"). Domain technical terms are allowed.
- The STE rule also applies to code comments, docstrings, and git commit messages. No verbose text anywhere. Comments state one fact in one or two short sentences. Commit message bodies use short, active sentences; keep the conventional-commit format and British English rules below.

## Writing Style

- Never use typographic em-dashes (`—`, U+2014) or en-dashes used as punctuation (`–`, U+2013) in prose you write or edit for me. They read as machine-written and are not my voice. Replace each with the punctuation the sentence actually calls for: a comma for a light pause, a colon to introduce, a semicolon to join two independent clauses, brackets for an aside, or a full stop to split into two sentences.
- The ban is on the em-dash as a *device*, not merely on the character. The spaced double-hyphen used as a sentence interruption in prose (`word -- word`, or a `-- aside --` pair) is the same thing in ASCII clothing and is equally unwanted; replace it the same way. Density is the tell: a paragraph peppered with `--` interruptions reads as machine-drafted even though no `—` is present.
- The spaced `--` remains legitimate and must be left alone in technical contexts: code, code fences, code comments, command output, file paths, CLI flags and flag examples (`--release`), ASCII art and diagrams, and numeric/date ranges. Only rewrite `--` when it is acting as an em-dash inside ordinary prose sentences.
- Other characters to leave alone: any `—`/`–`/`--` inside quoted external material. Only touch dashes in prose I am authoring or editing for you.
- Avoid the antithesis / "not-but" construction as a habitual device: the "X, not Y" or "it's not A, it's B" shape (e.g. "the deliverable is the harness, not a verdict"). Used occasionally it is fine; used as a reflex it reads as machine-drafted and inflates plain statements. Default to stating the thing directly and dropping the negated foil. If the contrast genuinely carries information, prefer a plain sentence or a colon over the rhetorical pivot.
- Do not editorialise with self-characterising stance words. Words like "honest", "honestly", "faithful", "faithfully", "truly", "genuinely", "candidly", "to be clear" tell the reader how to regard the work instead of letting the facts carry it, and repetition dilutes the message and invites the very doubt they try to forestall. Show with specifics (numbers, the actual caveat, the exact gap) rather than labelling the prose as trustworthy. Cut these words rather than reaching for them; if accuracy matters, state the limitation plainly.

## Python Environment Preferences

- Before running any Python command (`python`, `python3`, `pip`, `pytest`, etc.), always check if a `.venv` directory exists in the current project root
- If `.venv/bin/python` exists, use it instead of bare `python` or `python3` -- e.g. `.venv/bin/python script.py` instead of `python3 script.py`
- Similarly, prefer `.venv/bin/pip`, `.venv/bin/pytest`, etc. over system-installed versions
- If using `uv run`, this is fine as-is since uv manages its own virtualenv resolution
- This applies to all projects, not just this dotfiles repo

## Code Quality Standards

- Code comments, docstrings and test descriptions follow the same ADHD-friendly shape as explanations: lead with the fact, keep it to one or two lines, no narrative build-up. A comment exists only to state a constraint the code cannot show (a why, a measured number, a non-obvious equivalence); delete anything that restates the code, the assert, or the surrounding names. Module docstrings cover what it does, how to run it, and the acceptance bar in roughly ten lines or fewer. Apply this when writing new code and when editing existing files.
- Always use descriptive variable names
- Do not use emojis at all
- Never use or set up mock data. Always only use real data that is usually found in a data directory
- Never include placeholders or workarounds just to allow for tests to pass, all code should be real and not be a fake implementation
- Work in a test-driven development mindset when tests are carefully considered for any new feature implementation. Aim for greater than 80% test coverage when implementing new items
- When implementing features there is no middle ground, no "good enough" compromises and no elaborate failure handling. Things should work as intended otherwise it's a failure and should be treated as incomplete
- Please avoid bending to keep backwards compatibility or legacy code
- When you believe you have completed a task, you should deploy a separate subagent to verify and validate your work.

### Bug Fix Workflow

When a bug is reported, do not start by trying to fix it. Instead:

1. Analyse the bug report and understand the expected vs actual behaviour
2. Write a test that reproduces the bug -- this test must fail, confirming the bug exists
3. Verify the test fails for the correct reason (the bug, not a typo or setup error)
4. Dispatch a subagent to fix the bug, providing it with the failing test as the acceptance criterion
5. The subagent must prove the fix by demonstrating the test passes along with all other existing tests

### Error Suppression is Forbidden

Never use patterns that silently suppress errors. If a command or expression can fail, handle the failure explicitly or let it propagate. The following patterns are banned in all languages:

- **Bash**: `command || true`, `command || :`, `set +e` (to disable errexit around specific commands), `command 2>/dev/null || true`
- **Python**: bare `except: pass`, `except Exception: pass` without logging or re-raising
- **Rust**: `.unwrap_or_default()` used to hide meaningful errors, `let _ = fallible_call()`
- **JavaScript/TypeScript**: empty `catch {}` blocks, `.catch(() => {})`
- **Any language**: any construct whose sole purpose is to force a success status when the underlying operation has failed

If an error is genuinely expected and safe to ignore, add an explicit comment explaining **why** it is safe, and use the narrowest possible exception or error type.

## Git Workflow

- Use British English when writing git commit messages or documentation
- Follow https://www.conventionalcommits.org/en/v1.0.0-beta.4/ guidance when writing git commit messages
- Never use em-dashes or en-dashes in commit messages (subject or body); the Writing Style dash rules apply there too. Replace with a colon, comma, brackets, or a sentence break. Use plain "-" for bullet lists in commit bodies
- When writing a commit message include references sections when a GitHub issue, Stack Overflow or other useful information found online was used to solve a problem but it should be a weblink to that source
- When adding a references section to the commit message it should only be web links and does not need to be a sentence
- Do not include "Generated with Claude Code" or any "Co-Authored-By:" lines referencing Claude or Anthropic in commit messages
- Before publishing any GitHub issue or PR, always draft its body as a markdown file in an untracked `lib/` folder (`lib/pr/` for PRs, `lib/issues/` for issues, date-prefixed) and present it for review FIRST. Never run `gh pr create` / `gh issue create` until I have approved the draft. Approval is a required step; "reviewable in principle" does not count. After approval, publish with `--body-file <path>` (never an inline heredoc, which corrupts backtick code spans). When I later edit the draft file, push my version to the live item with `gh pr edit N --body-file <path>` or `gh issue edit N --body-file <path>`
- Format issue and PR draft markdown with each paragraph and each bullet on a SINGLE line, with NO hard line wrapping (do not break prose at ~80 columns). This is the opposite of my usual wrapped-prose preference and applies ONLY to issue/PR bodies; keep wrapping for specs, plans, docs, and other prose
- Issue and PR bodies must NOT open with an H1 repeating the title or a `## Summary` heading. GitHub already renders the title above the body, so line 1 of the body is the first sentence of the summary prose itself. Later section headings (`## Results`, `## Verification`, etc.) are fine

## Personal Knowledge Base

Durable concept notes live in `~/github/tallamjr/origin/learn/kb/`, rendered
as a Quarto book. See `~/github/tallamjr/origin/learn/kb/README.md` for the
layout and conventions. To add a note during a conversation, invoke the
`/log-concept` skill. Notes follow the template in `kb/.template.md`.
