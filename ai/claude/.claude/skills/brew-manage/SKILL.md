---
user-invocable: false
description: Homebrew package management, Brewfile conventions, and bundle commands
---

# Homebrew Package Management

Auto-loaded when working with Homebrew, Brewfile, or package installation.

## Brewfile Location

```
$HOME/dotfiles/brew/Brewfile
```

## Commands

```bash
# Install all packages from Brewfile
brew bundle --file $HOME/dotfiles/brew/Brewfile

# Check what would be installed
brew bundle check --file $HOME/dotfiles/brew/Brewfile

# Clean up packages not in Brewfile
brew bundle cleanup --file $HOME/dotfiles/brew/Brewfile

# Dump current packages to Brewfile
brew bundle dump --file $HOME/dotfiles/brew/Brewfile --force
```

## Rust Toolchain

```bash
# Install Rust toolchain and crates
cd rust && source install-rust-with-crates.sh
```

## Conventions

- All Homebrew packages should be declared in the Brewfile
- Use `brew` for formulae, `cask` for GUI applications, `mas` for Mac App Store
- Keep the Brewfile sorted alphabetically within each section
- After adding a new package, run `brew bundle` to verify
