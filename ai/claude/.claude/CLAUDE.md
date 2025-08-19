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

## Language-Specific Standards

### Python
- Format python code using Black
- When creating a Jupyter notebook please do not use emojis
- Verify new python code with `pytest`
- Verify new python code with `pytest --nbmake`

### Rust
- Format rust code using `rustfmt`
- Verify new rust code with `cargo check` and `cargo test`

### Shell Scripts
- Use bash for shell scripts unless specific shell features are required
- Include proper error handling and exit codes
- Use shellcheck for linting shell scripts

## Common Commands

### Configuration Management
```bash
# Symlink configurations using stow
stow -v --target=$HOME --no-folding [folder_name]

# Example: symlink vim configuration
stow -v --target=$HOME --no-folding vim
```

### Package Management
```bash
# Install all brew packages from Brewfile
brew bundle --file $HOME/dotfiles/brew/Brewfile

# Install Rust toolchain and crates
cd rust && source install-rust-with-crates.sh
```

### System Provisioning
```bash
# Full system setup on new machine
git clone git@github.com:tallamjr/dotfiles.git $HOME && bash install.sh

# Temporary configuration install
bash temp/temp-install.sh
```

## Dotfiles Architecture

### Stow Configuration Patterns
- Use `--no-folding` for most configurations to prevent deep directory creation
- Target `$HOME` for most symlinks
- Some packages like `conda` use default stow behaviour for proper directory structure

### Directory Organisation
- Each application/tool has its own directory (bash/, vim/, git/, etc.)
- Configuration files are organised to be symlinked via GNU Stow
- The `install.sh` script handles OS detection and appropriate package manager setup

### Key Directories
- `config/` - Contains Neovim and other application configs
- `brew/` - Homebrew package definitions and Brewfile
- `rust/` - Rust toolchain setup and crate installations
- `playbook/` - Ansible playbooks for system provisioning
- `temp/` - Temporary installation scripts for quick setup
