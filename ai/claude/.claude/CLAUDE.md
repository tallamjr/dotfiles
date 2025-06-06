<!-- General -->

# Always use descriptive variable names

# Never use or set up mock data. Always only use real data that is usually found in a data directory.

# Never include placeholders or workarounds just to allow for tests to pass, all code should be real and not be a fake implementation

# Work in a test-driven development mindset when tests are carefully considered for any new feature implementation. You should aim for greater than 80% test coverage when implementing new items.

# When implementing features there is no middle ground, no "good enough" compromises and no elaborate failure handling. Things should work as intended otherwise its a failure and should be treated as incomplete.

<!-- Git -->

# Use British English when writing git commit messages or documentation

# Follow https://www.conventionalcommits.org/en/v1.0.0-beta.4/ guidance when writing git commit messages and include where appropriate a references sections when a github issue, stackoverflow or other useful information found online was used to solve a problem.

# When adding a references section to the commit message it should only be web links and does not need to be a sentence.

# At the end of a git commit message should be a references section in bullet point form that points to any web links that would be helpful explain the rational for the code changes

# Do not include "🤖 Generated with [Claude Code](https://claude.ai/code)" or "Co-Authored-By: Claude <noreply@anthropic.com>" in commit messages

<!-- Python -->

# Format python code using Black

# When creating a Jupyter notebook please do not use emojis

# Verify new python code with `pytest`

# Verify new python code with `pytest --nbmake`

<!-- Rust -->

# Format rust code using `rustfmt`

# Verify new rust code with `cargo check` and `cargo test`
