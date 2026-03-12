---
user-invocable: true
argument-hint: <source-path> [target-path] [--lint-only] [--synth-only] [--no-verify]
description: Migrate RTL code to SystemVerilog with open-source tooling (Yosys, Verilator, Surfer)
allowed-tools: Task, Read, Write, Edit, Glob, Grep, Bash(mkdir:*), Bash(ls:*), Bash(verilator:*), Bash(yosys:*), Bash(surfer:*), Bash(make:*), Bash(sv2v:*), Bash(cat:*), Bash(find:*)
---

# RTL Migration to SystemVerilog

Migrate RTL designs (VHDL, Verilog-2001/2005) to modern SystemVerilog, with synthesis verification via Yosys, linting and simulation via Verilator, and waveform viewing via Surfer.

## Arguments

- `$1` = Source path (required): directory or file containing RTL source code to migrate
- `$2` = Target path (optional): output directory for migrated SystemVerilog; defaults to `<source-path>/sv_output/`

## Flags (parsed from arguments)

- `--lint-only` = Only run Verilator lint on existing SystemVerilog (skip migration)
- `--synth-only` = Only run Yosys synthesis check (skip migration)
- `--no-verify` = Skip the verification subagent step

## Required Tools

The following open-source tools must be installed. If any are missing, report which ones and how to install them before proceeding:

| Tool       | Purpose                         | Install (macOS)                | Install (Linux)                      |
|------------|--------------------------------|-------------------------------|--------------------------------------|
| Yosys      | Synthesis and formal checks    | `brew install yosys`          | `apt install yosys`                  |
| Verilator  | Linting and simulation         | `brew install verilator`      | `apt install verilator`              |
| Surfer     | Waveform viewer (VCD/FST)      | `brew install surfer`         | `cargo install surfer` or from repo  |
| sv2v       | SV to Verilog (optional, for backwards compat checks) | `brew install sv2v` | `cabal install sv2v`    |

## Instructions

### Phase 1: Discover and Analyse Source RTL

1. **Parse arguments** from `$ARGUMENTS`:
   - Extract source path (first non-flag argument)
   - Extract target path (second non-flag argument, or default)
   - Detect flags: `--lint-only`, `--synth-only`, `--no-verify`

2. **Scan source directory** for RTL files:
   - VHDL: `*.vhd`, `*.vhdl`
   - Verilog: `*.v`, `*.vh`
   - SystemVerilog (already migrated): `*.sv`, `*.svh`
   - Constraints: `*.sdc`, `*.xdc`
   - Testbenches: files matching `*_tb.*`, `*_test.*`, `tb_*.*`

3. **Build dependency graph**:
   - Parse `include` directives and module instantiations
   - Identify top-level modules (not instantiated by anything else)
   - Identify shared packages and type definitions
   - Map out the hierarchy

4. **Create output directory structure**:
   ```
   <target-path>/
     rtl/              # Migrated design files
     tb/               # Migrated testbenches
     pkg/              # SystemVerilog packages (extracted types/constants)
     sim/              # Simulation scripts and Makefiles
     synth/            # Synthesis scripts
     waves/            # Waveform output directory
     Makefile           # Unified build system
   ```

### Phase 2: Migrate to SystemVerilog

For each source file, apply the following migration rules. Process packages and shared types first, then leaf modules, then higher-level modules, then testbenches.

#### VHDL to SystemVerilog

- Convert `entity`/`architecture` pairs to `module` with ANSI-style port declarations
- Convert `signal` to `logic`; convert `std_logic_vector` to `logic [N-1:0]`
- Convert `process` blocks to `always_comb`, `always_ff @(posedge clk)`, or `always_latch` as appropriate
- Convert `generate` statements to SystemVerilog `generate`/`endgenerate`
- Convert `record` types to `struct packed`
- Convert `package` to `package`/`endpackage`
- Convert `component` instantiations to direct module instantiation with `.port(signal)` syntax
- Convert `generic` to `parameter`
- Convert `assert` to SystemVerilog assertions (`assert property`)

#### Verilog to SystemVerilog

- Convert `reg`/`wire` to `logic` (use `logic` everywhere unless driving multiple sources)
- Convert `always @(*)` to `always_comb`
- Convert `always @(posedge clk)` to `always_ff @(posedge clk)`
- Convert non-ANSI port declarations to ANSI style
- Extract `parameter` blocks into packages where shared across modules
- Convert `integer` to `int` where appropriate
- Add `unique case` / `priority case` where applicable
- Use `typedef enum logic [N-1:0]` for FSM state encoding
- Add `default` to all `case` statements

#### General SystemVerilog Best Practices

- Use `logic` instead of `reg`/`wire` for all signals
- Use ANSI-style module port declarations
- Use `always_comb`, `always_ff`, `always_latch` (never plain `always`)
- Use `typedef` for custom types
- Use `enum` for FSM states with explicit encoding
- Use `struct packed` for grouped signals
- Use `interface` for complex bus protocols
- Use `modport` within interfaces to define directionality
- Add `timeunit 1ns; timeprecision 1ps;` to testbenches
- Use `$display` / `$error` / `$fatal` for test messages

### Phase 3: Generate Build Infrastructure

#### Makefile

Generate `<target-path>/Makefile`:

```makefile
# RTL Migration Build System
# Tools: Verilator (lint/sim), Yosys (synthesis), Surfer (waves)

VERILATOR    ?= verilator
YOSYS        ?= yosys
SURFER       ?= surfer

TOP_MODULE   ?= <detected-top-module>
RTL_SOURCES  := $(wildcard rtl/*.sv) $(wildcard pkg/*.sv)
TB_SOURCES   := $(wildcard tb/*.sv)

.PHONY: lint sim synth waves clean

# Lint all RTL with Verilator
lint:
	$(VERILATOR) --lint-only -Wall --timing \
		$(addprefix -I,rtl pkg) \
		$(RTL_SOURCES)

# Simulate with Verilator and generate VCD waveform
sim: lint
	$(VERILATOR) --binary --timing --trace \
		$(addprefix -I,rtl pkg) \
		$(RTL_SOURCES) $(TB_SOURCES) \
		--top-module $(TOP_MODULE)_tb \
		-o sim_$(TOP_MODULE)
	./obj_dir/sim_$(TOP_MODULE)

# Synthesise with Yosys (target: generic gates)
synth:
	$(YOSYS) -p "read_verilog -sv $(RTL_SOURCES); \
		hierarchy -top $(TOP_MODULE); \
		proc; opt; techmap; opt; \
		stat; write_json synth/$(TOP_MODULE).json" \
		2>&1 | tee synth/$(TOP_MODULE)_synth.log

# Open waveforms in Surfer
waves:
	$(SURFER) waves/$(TOP_MODULE).vcd

clean:
	rm -rf obj_dir waves/*.vcd synth/*.json synth/*.log
```

#### Yosys Synthesis Script

Generate `<target-path>/synth/synth.ys`:

```
# Yosys synthesis script for <top-module>
read_verilog -sv rtl/*.sv pkg/*.sv
hierarchy -check -top <top-module>
proc
flatten
opt -full
techmap
opt -full
stat
check
write_json <top-module>.json
```

#### Verilator Simulation Wrapper

For each testbench, ensure it has a proper `initial begin ... end` block with:
- `$dumpfile("waves/<module>.vcd");`
- `$dumpvars(0, <module>_tb);`
- Simulation termination via `$finish;`

### Phase 4: Lint and Verify

1. **Verilator lint**: Run `make lint` on all migrated files
   - Fix all lint warnings and errors
   - Iterate until clean

2. **Yosys synthesis check**: Run `make synth`
   - Verify synthesis completes without errors
   - Review gate count and resource statistics
   - Check for latches (should be zero unless explicitly intended)

3. **Simulation (if testbenches exist)**: Run `make sim`
   - Verify simulation runs to completion
   - Check waveform output is generated in `waves/`

4. **Waveform review**: Report that waveforms can be viewed with `make waves` or `surfer waves/<module>.vcd`

### Phase 5: Verification (unless `--no-verify`)

Use the Task tool to spawn a verification subagent that checks:
- All source modules have corresponding migrated SystemVerilog files
- No Verilog-2001 patterns remain (`reg`, `wire`, plain `always @(*)`)
- All `case` statements have `default` clauses
- No latches inferred unintentionally (check Yosys synthesis log)
- Verilator lint passes cleanly with `-Wall`
- Module hierarchy is preserved (same instantiation structure)
- Port widths and directions match the original design
- Testbench VCD dump paths are correct

### Phase 6: Report Summary

Report:
- Number of files migrated (by source language)
- Module hierarchy (tree view)
- Verilator lint status (PASS/FAIL with details)
- Yosys synthesis status (PASS/FAIL, gate count)
- Simulation status (if testbenches exist)
- Any manual intervention required
- Instructions for viewing waveforms with Surfer

## Example Usage

```bash
# Migrate a VHDL project to SystemVerilog
/rtl-migrate ~/projects/uart-controller

# Migrate Verilog to SystemVerilog with custom output directory
/rtl-migrate ~/projects/spi-master ~/projects/spi-master-sv

# Just lint existing SystemVerilog
/rtl-migrate ~/projects/my-design --lint-only

# Just run synthesis check
/rtl-migrate ~/projects/my-design --synth-only

# Migrate without running verification subagent
/rtl-migrate ~/projects/fifo-design --no-verify
```

## Migration Checklist

- [ ] All source files discovered and dependency graph built
- [ ] Packages and shared types migrated first
- [ ] All modules migrated with ANSI port style and `logic` types
- [ ] FSMs use `typedef enum` with explicit encoding
- [ ] `always_comb` / `always_ff` / `always_latch` used (no plain `always`)
- [ ] All `case` statements have `default` clause
- [ ] Testbenches include VCD dump and `$finish`
- [ ] Makefile generated with lint, sim, synth, waves targets
- [ ] Yosys synthesis script generated
- [ ] Verilator lint passes with `-Wall`
- [ ] Yosys synthesis completes without errors
- [ ] No unintended latches in synthesis output
- [ ] Module hierarchy preserved from original design
- [ ] Verification subagent passed (unless --no-verify)
