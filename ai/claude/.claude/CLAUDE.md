# Personal Development Guidelines

Global preferences and standards loaded into every Claude Code session. These apply across all projects regardless of working directory; project-specific guidance lives in each project's own CLAUDE.md.

## Execution Preferences

- When executing implementation plans, always use the subagent-driven approach (superpowers:subagent-driven-development). Never ask to choose between subagent-driven and inline execution -- subagents are always preferred.

## Python Environment Preferences

- Before running any Python command (`python`, `python3`, `pip`, `pytest`, etc.), always check if a `.venv` directory exists in the current project root
- If `.venv/bin/python` exists, use it instead of bare `python` or `python3` -- e.g. `.venv/bin/python script.py` instead of `python3 script.py`
- Similarly, prefer `.venv/bin/pip`, `.venv/bin/pytest`, etc. over system-installed versions
- If using `uv run`, this is fine as-is since uv manages its own virtualenv resolution
- This applies to all projects, not just this dotfiles repo

## Code Quality Standards

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
- When writing a commit message include references sections when a GitHub issue, Stack Overflow or other useful information found online was used to solve a problem but it should be a weblink to that source
- When adding a references section to the commit message it should only be web links and does not need to be a sentence
- Do not include "Generated with Claude Code" or any "Co-Authored-By:" lines referencing Claude or Anthropic in commit messages

## Personal Knowledge Base

Durable concept notes live in `~/github/tallamjr/origin/learn/kb/`, rendered
as a Quarto book. See `~/github/tallamjr/origin/learn/kb/README.md` for the
layout and conventions. To add a note during a conversation, invoke the
`/log-concept` skill. Notes follow the template in `kb/.template.md`.
