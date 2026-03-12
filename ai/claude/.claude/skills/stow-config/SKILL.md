---
user-invocable: false
description: GNU Stow configuration patterns, commands, and dotfiles architecture
---

# Stow Configuration and Dotfiles Architecture

Auto-loaded when working with stow, symlinks, or dotfiles structure.

## Stow Commands

```bash
# Symlink configurations using stow
stow -v --target=$HOME --no-folding [folder_name]

# Example: symlink vim configuration
stow -v --target=$HOME --no-folding vim
```

## System Provisioning

```bash
# Full system setup on new machine
git clone git@github.com:tallamjr/dotfiles.git $HOME && bash install.sh

# Temporary configuration install
bash temp/temp-install.sh
```

## Stow Configuration Patterns

- Use `--no-folding` for most configurations to prevent deep directory creation
- Target `$HOME` for most symlinks
- Some packages like `conda` use default stow behaviour for proper directory structure

## Directory Organisation

- Each application/tool has its own directory (bash/, vim/, git/, etc.)
- Configuration files are organised to be symlinked via GNU Stow
- The `install.sh` script handles OS detection and appropriate package manager setup

## Key Directories

- `config/` - Contains Neovim and other application configs
- `brew/` - Homebrew package definitions and Brewfile
- `rust/` - Rust toolchain setup and crate installations
- `playbook/` - Ansible playbooks for system provisioning
- `temp/` - Temporary installation scripts for quick setup
