---
user-invocable: true
argument-hint: [project-path] [--languages=python,rust,systemverilog,go,js,ts,shell,cpp] [--no-install]
description: Generate a .pre-commit-config.yaml with base and language-specific hooks, then install pre-commit
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(pre-commit:*), Bash(uv:*), Bash(pip:*), Bash(brew:*), Bash(ls:*), Bash(which:*), Bash(python:*), Bash(python3:*), Bash(git:*), Agent
---

# Pre-commit Configuration Setup

Generate a `.pre-commit-config.yaml` file tailored to a project's languages, then install and activate pre-commit hooks.

## Arguments

- `$1` = Project path (optional): directory to set up pre-commit in; defaults to current working directory
- `--languages=<list>` = Comma-separated list of languages to include hooks for (optional; auto-detected if omitted)
- `--no-install` = Only generate the config file; do not install pre-commit or run `pre-commit install`

## Instructions

### Phase 1: Detect Project Languages

If `--languages` is not provided, scan the project directory for source files to determine which language-specific hook sets to include:

| File Extensions | Language |
|----------------|----------|
| `*.py`, `*.pyi`, `*.ipynb` | Python |
| `*.rs`, `Cargo.toml` | Rust |
| `*.sv`, `*.svh`, `*.v`, `*.vh`, `*.vhd`, `*.vhdl` | SystemVerilog |
| `*.go`, `go.mod` | Go |
| `*.js`, `*.jsx`, `*.mjs` | JavaScript |
| `*.ts`, `*.tsx` | TypeScript |
| `*.sh`, `*.bash`, `*.zsh` | Shell |
| `*.c`, `*.h`, `*.cpp`, `*.hpp`, `*.cc` | C/C++ |
| `*.yaml`, `*.yml`, `*.json`, `*.toml` | Config (always included via base hooks) |

Report which languages were detected before proceeding.

### Phase 2: Check for Existing Configuration

Before generating, check the project for:
- Existing `.pre-commit-config.yaml` -- if found, read it and ask the user whether to overwrite or merge
- Existing `pyproject.toml` with `[tool.ruff]` section -- use this to inform Ruff hook configuration
- Existing `rustfmt.toml` or `.rustfmt.toml` -- Rust formatting config is respected automatically by the hook
- Existing `requirements.in` or `requirements-*.in` -- include uv pip-compile hooks if found

### Phase 3: Generate `.pre-commit-config.yaml`

#### Base Hooks (always included)

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v6.0.0
    hooks:
      - id: check-added-large-files
        args: ["--maxkb=1000000"]
      - id: check-case-conflict
      - id: check-executables-have-shebangs
      - id: check-merge-conflict
      - id: check-symlinks
      - id: check-toml
      - id: check-yaml
      - id: detect-private-key
      - id: end-of-file-fixer
      - id: mixed-line-ending
        args: ["--fix=lf"]
      - id: trailing-whitespace
```

#### Python Hooks

```yaml
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.14.0
    hooks:
      - id: ruff-check
        args:
          [
            --fix,
            "--ignore=A001,A002,B007,B008,B017,B020,B028,B904,C411,C419,E402,E711,E721,E722,E731,E501,F401,F811,F821,F841,N,PT,UP008,UP036",
          ]
      - id: ruff-format
```

If `requirements.in` or `requirements-*.in` files are found, also include:

```yaml
  - repo: https://github.com/astral-sh/uv-pre-commit
    rev: 0.10.2
    hooks:
      - id: pip-compile
        args: [requirements.in, -o, requirements.txt]
```

Adjust the `args` and add additional `pip-compile` hook entries for each `requirements-*.in` file found.

#### Rust Hooks

```yaml
  - repo: https://github.com/doublify/pre-commit-rust
    rev: v1.0
    hooks:
      - id: fmt
      - id: cargo-check
      - id: clippy
```

#### SystemVerilog Hooks

```yaml
  - repo: https://github.com/chipsalliance/verible
    rev: v0.0-3956-g0e4b833d
    hooks:
      - id: verible-verilog-lint
        args: ["--rules_config_search"]
      - id: verible-verilog-format
        args: ["--inplace"]
```

**Important**: The Verible rev tag must be checked for the latest release. Use `git ls-remote --tags https://github.com/chipsalliance/verible.git` to find the most recent tag, or fall back to the version above.

#### Go Hooks

```yaml
  - repo: https://github.com/dnephin/pre-commit-golang
    rev: v0.5.1
    hooks:
      - id: go-fmt
      - id: go-vet
      - id: go-build
```

#### JavaScript/TypeScript Hooks

```yaml
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v9.27.0
    hooks:
      - id: eslint
        files: \.(js|jsx|ts|tsx)$
        additional_dependencies:
          - eslint
```

If the project uses Prettier (check for `.prettierrc`, `prettier.config.*`, or `prettier` in `package.json`):

```yaml
  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0-alpha.8
    hooks:
      - id: prettier
        types_or: [javascript, jsx, ts, tsx, css, json, yaml, markdown]
```

#### Shell Hooks

```yaml
  - repo: https://github.com/shellcheck-py/shellcheck-py
    rev: v0.10.0.1
    hooks:
      - id: shellcheck
```

#### C/C++ Hooks

```yaml
  - repo: https://github.com/pocc/pre-commit-hooks
    rev: v1.3.5
    hooks:
      - id: clang-format
      - id: clang-tidy
        args: [--fix-errors]
```

### Phase 4: Write the Configuration

1. Assemble the full YAML from the base hooks plus detected language hooks
2. Write to `<project-path>/.pre-commit-config.yaml`
3. Display the generated configuration to the user

### Phase 5: Install Pre-commit (unless `--no-install`)

#### Installation Order

1. Check if `pre-commit` is already available: `which pre-commit`
2. If not installed, use the following priority:
   - **Preferred**: `uv tool install pre-commit` -- installs into an isolated uv-managed environment, available on PATH
   - **Fallback on macOS**: `brew install pre-commit`
   - **Last resort**: `pip install pre-commit`

#### Virtual Environment Awareness

Before running `pre-commit install` or `pre-commit run`, check for a local virtual environment:

1. Check if `.venv/` exists in the project directory
2. If it does, activate it first: `source .venv/bin/activate`
3. If the project uses `uv` (check for `uv.lock` or `pyproject.toml` with `[tool.uv]`), prefer running via `uv run pre-commit` instead of activating the venv manually

#### Hook Installation

1. Run `pre-commit install` in the project directory to set up the git hook
2. Run `pre-commit run --all-files` to validate the configuration works against the current codebase
3. Report results to the user, including any hooks that failed (these indicate existing code that does not pass the new checks)

### Phase 6: Verification

Use a verification subagent to confirm:
- `.pre-commit-config.yaml` exists and is valid YAML
- All hook configurations use correct hook IDs for their respective repos
- The git hook was installed (`.git/hooks/pre-commit` exists and references pre-commit)
- No syntax errors in the generated configuration
- `pre-commit run --all-files` completes (failures on existing code are acceptable but should be reported)

## Example Usage

```bash
# Auto-detect languages and set up pre-commit in current project
/pre-commit-setup

# Set up for a specific project directory
/pre-commit-setup ~/projects/my-app

# Only generate config for Python and Rust, skip install
/pre-commit-setup --languages=python,rust --no-install

# Set up for a SystemVerilog project
/pre-commit-setup ~/projects/fpga-design --languages=systemverilog

# Set up for a full-stack project
/pre-commit-setup --languages=python,typescript,shell
```

## Version Pinning

When generating the config, use the exact revisions specified above as defaults. Before writing the file, attempt to verify the latest stable tags for each repo using `git ls-remote --tags` for the language-specific repos. If the check fails, use the default revisions above and add a YAML comment noting the revision should be updated.

## Notes

- The base hooks from `pre-commit/pre-commit-hooks` are always included regardless of language detection
- Ruff ignore rules match the user's preferred configuration for linting flexibility
- Verible is the recommended SystemVerilog tool, consistent with the user's Neovim LSP setup which uses Verible via Mason
- The `--rules_config_search` flag for Verible lint tells it to search for a `.rules.verible_lint` config file in parent directories, allowing per-project rule customisation
- `uv tool install` is the preferred installation method for pre-commit as it provides isolated environment management without polluting the system Python
- When a local `.venv` exists, respect it -- this avoids conflicts with project-specific Python environments
- The `astral-sh/uv-pre-commit` repo provides `pip-compile` hooks for projects using `requirements.in` files, keeping dependency pins up to date on each commit
