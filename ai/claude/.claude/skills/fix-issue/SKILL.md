---
disable-model-invocation: true
argument-hint: "[issue-number]"
description: Fetch a GitHub issue, implement the fix, test, and commit
---

# Fix Issue

Fetch a GitHub issue, implement the required changes, verify with tests, and commit.

## Arguments

- `$1` = GitHub issue number (required)

## Process

1. **Fetch issue details**:
   - Run: `gh issue view $1`
   - Parse the title, description, labels, and acceptance criteria
   - Understand the scope and requirements

2. **Plan the implementation**:
   - Identify which files need modification
   - Determine the approach and any dependencies
   - Enter plan mode if the change is non-trivial

3. **Implement the fix**:
   - Make the necessary code changes
   - Follow project coding standards (Black for Python, rustfmt for Rust, shellcheck for shell)
   - Use British English in any documentation or comments

4. **Test the changes**:
   - Run `pytest` for Python changes
   - Run `pytest --nbmake` for notebook changes
   - Run `cargo check` and `cargo test` for Rust changes
   - Run `shellcheck` for shell script changes
   - Ensure test coverage exceeds 80% for new code

5. **Format the code**:
   - Python: `black`
   - Rust: `rustfmt`

6. **Commit the changes**:
   - Use conventional commit format: `fix(scope): description`
   - Reference the issue: `Fixes #$1`
   - Use British English
   - Include References section if external sources were used

## Success Criteria

- Issue requirements fully addressed
- All tests pass
- Code formatted correctly
- Commit message references the issue
- No emojis in any output
