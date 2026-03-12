---
user-invocable: false
description: Neovim configuration structure, plugin layout, and conventions
---

# Neovim Configuration

Auto-loaded when editing Neovim configuration files under `config/.config/nvim/`.

## Base Framework

Built on AstroNvim with lazy.nvim for plugin management.

## Directory Structure

```
config/.config/nvim/
  init.lua                  # Entry point
  lua/
    lazy_setup.lua          # lazy.nvim bootstrap
    community.lua           # AstroNvim community plugins
    polish.lua              # Post-setup tweaks
    plugins/                # 39 plugin configuration files
      astrocore.lua         # AstroNvim core settings
      astrolsp.lua          # AstroNvim LSP settings
      astroui.lua           # AstroNvim UI settings
      auto-session.lua      # Session management
      autolist.lua          # Auto-list continuation
      autopairs.lua         # Bracket auto-pairing
      chatgpt.lua           # ChatGPT integration
      claudecode.lua        # Claude Code integration
      cmp-pandoc-references.lua
      colorscheme-tokyo.lua # Tokyo Night theme
      copilot.lua           # GitHub Copilot
      dap.lua               # Debug Adapter Protocol
      formatting.lua        # Code formatting (conform.nvim)
      iron.lua              # REPL integration
      kiwi.lua              # Wiki/notes
      lazygit.lua           # Git UI
      lazylist.lua          # List utilities
      linting.lua           # Linting (nvim-lint)
      lsp-zero.lua          # LSP zero-config
      lualine.lua           # Status line
      luasnip.lua           # Snippet engine
      markdown-preview.lua  # Markdown preview
      mason.lua             # LSP/DAP installer
      molten.lua            # Jupyter in Neovim
      none-ls.lua           # Null-ls successor
      nvim-tree.lua         # File explorer
      peek.lua              # Markdown preview (Deno)
      quarto.lua            # Quarto documents
      surround.lua          # Surround text objects
      telescope.lua         # Fuzzy finder
      todo-comments.lua     # TODO highlighting
      treesitter.lua        # Syntax parsing
      trouble.lua           # Diagnostics list
      undotree.lua          # Undo history
      urlopen.lua           # URL opener
      user.lua              # Custom user plugins
      vimtex.lua            # LaTeX support
      which-key.lua         # Keybinding hints
      whitespace.lua        # Trailing whitespace
    meu/                    # Personal configuration (5 files)
      keys.lua              # Custom keybindings
      kickstart.lua         # Kickstart-derived settings
      opts.lua              # Vim options
      abbs.lua              # Abbreviations
      misc.lua              # Miscellaneous settings
  after/
    ftplugin/
      rust.lua              # Rust filetype settings
```

## Conventions

- Plugin configs return a table with lazy.nvim spec format: `return { "author/plugin", opts = { ... } }`
- AstroNvim overrides use `AstroNvim/astrocore`, `AstroNvim/astrolsp`, `AstroNvim/astroui` specs
- Personal keybindings and options live in `lua/meu/` (Portuguese for "my")
- Formatting is handled by conform.nvim via `formatting.lua`
- Linting is handled by nvim-lint via `linting.lua`
