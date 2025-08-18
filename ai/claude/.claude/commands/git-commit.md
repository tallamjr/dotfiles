# Command: Git Commit

## Purpose
Review changes and create a properly formatted git commit following project standards.

## Parameters
None required - operates on current git working directory

## Process
1. Run `git status` to review staged and unstaged changes
2. Run `git diff` to examine specific changes being committed
3. Review recent commit history with `git log --oneline -10` to understand commit message style
4. Stage appropriate files with `git add`
5. Create commit following conventional commits specification
6. Resolve any pre-commit hook issues without using `--no-verify`

## Commit Message Requirements
- Use British English spelling and grammar
- Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0-beta.4/) specification
- Format: `type(scope): description`
- Types: feat, fix, docs, style, refactor, test, chore
- Include References section for external sources (web links only)
- Do not include Claude Code generation footers

## Example Commit Messages
```
feat(auth): add user authentication with JWT tokens

fix(api): resolve timeout issues in data fetching

docs(readme): update installation instructions

References:
https://stackoverflow.com/questions/12345/jwt-implementation
```

## Pre-commit Resolution
- Address formatting issues (Black for Python, rustfmt for Rust)
- Fix linting errors
- Resolve test failures
- Do not use `git restore` without explicit user permission
- Never use `--no-verify` flag

## Success Criteria
- All changes are properly staged
- Commit message follows conventional commits format
- Pre-commit hooks pass successfully
- British English used throughout
- No generation footers included
