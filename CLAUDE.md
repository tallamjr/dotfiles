# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for configuring \*NIX systems (macOS and Linux) with personalised development environment settings. The repository uses GNU Stow for symlinking configuration files and includes setup for various development tools and applications.

## Installation and Setup Commands

### Full System Provisioning
```bash
# Clone and install on a new machine
git clone git@github.com:tallamjr/dotfiles.git $HOME && bash install.sh
```

### Temporary Configuration Install
```bash
# For temporary setup on another machine
bash temp/temp-install.sh

# To uninstall temporary configuration
./temp/temp-uninstall.sh
```

### Package Management
```bash
# Install all brew packages from Brewfile
brew bundle --file $HOME/dotfiles/brew/Brewfile

# Install Rust toolchain and crates
cd rust && source install-rust-with-crates.sh
```

### Configuration Management
```bash
# Use stow to symlink configurations
stow -v --target=$HOME --no-folding [folder_name]

# Example: symlink vim configuration
stow -v --target=$HOME --no-folding vim
```

## Architecture and Structure

### Configuration Organization
- Each application/tool has its own directory (bash/, vim/, git/, etc.)
- Configuration files are organised to be symlinked via GNU Stow
- The `install.sh` script handles OS detection and appropriate package manager setup

### Key Directories
- `config/` - Contains Neovim and other application configs
- `brew/` - Homebrew package definitions and Brewfile
- `rust/` - Rust toolchain setup and crate installations
- `playbook/` - Ansible playbooks for system provisioning
- `temp/` - Temporary installation scripts for quick setup

### Installation Flow
1. OS detection (Darwin/Linux)
2. Package manager installation (Homebrew/Linuxbrew)
3. Essential tool installation (stow, xquartz, java)
4. Configuration symlinking via stow
5. Language toolchain setup (Rust, Conda)
6. Editor setup (Vim/Neovim with plugins)

### Stow Configuration Patterns
- Use `--no-folding` for most configurations to prevent deep directory creation
- Target `$HOME` for most symlinks
- Some packages like `conda` use default stow behaviour for proper directory structure

## Development Environment

### Shell Configuration
- Bash and Zsh configurations with custom PS1 themes
- Git configuration with aliases and formatting
- Tmux configuration with custom themes and plugins

### Editor Setup
- Vim and Neovim configurations with plugin management
- Custom snippets and abbreviations
- LaTeX support with minted package

### Language Support
- Rust: Managed via rustup with additional components (clippy, rust-analyzer, rustfmt)
- Python: Conda environment management
- Scala, Java, Go: Configured via Homebrew packages

## Testing and Verification

The repository includes GitHub Actions with smoke tests to verify installation processes work correctly across different environments.
