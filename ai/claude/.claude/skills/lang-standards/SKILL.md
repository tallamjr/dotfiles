---
user-invocable: false
description: Language-specific formatting, linting, and testing standards for Python, Rust, and Shell
---

# Language-Specific Standards

Auto-loaded when working with Python, Rust, or Shell files.

## Python

- Format code using Black
- When creating a Jupyter notebook do not use emojis
- Verify new code with `pytest`
- Verify notebook code with `pytest --nbmake`

## Rust

- Format code using `rustfmt`
- Verify new code with `cargo check` and `cargo test`

## Shell Scripts

- Use bash for shell scripts unless specific shell features are required
- Include proper error handling and exit codes
- Use shellcheck for linting shell scripts
