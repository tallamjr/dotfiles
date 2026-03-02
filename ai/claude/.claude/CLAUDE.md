# Dotfiles Development Guidelines

This file provides development standards and workflows for managing dotfiles configurations across *NIX systems using GNU Stow.

## Code Quality Standards

- Always use descriptive variable names
- Do not use emojis at all
- Never use or set up mock data. Always only use real data that is usually found in a data directory
- Never include placeholders or workarounds just to allow for tests to pass, all code should be real and not be a fake implementation
- Work in a test-driven development mindset when tests are carefully considered for any new feature implementation. Aim for greater than 80% test coverage when implementing new items
- When implementing features there is no middle ground, no "good enough" compromises and no elaborate failure handling. Things should work as intended otherwise it's a failure and should be treated as incomplete
- Please avoid bending to keep backwards compatibility or legacy code
- When you believe you have completed a task, you should deploy a separate subagent to verify and validate your work.

## Git Workflow

- Use British English when writing git commit messages or documentation
- Follow https://www.conventionalcommits.org/en/v1.0.0-beta.4/ guidance when writing git commit messages
- When writing a commit message include references sections when a GitHub issue, Stack Overflow or other useful information found online was used to solve a problem but it should be a weblink to that source
- When adding a references section to the commit message it should only be web links and does not need to be a sentence
- Do not include "🤖 Generated with [Claude Code](https://claude.ai/code)" or "Co-Authored-By: Claude <noreply@anthropic.com>" in commit messages
