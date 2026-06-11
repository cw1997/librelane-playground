# AGENTS.md — Project Rules

## Language

- All comments, docstrings, and commit messages in source files **must** be English only.

## SystemVerilog

- Use `logic`; prefer `always_ff` / `always_comb` / `always_latch` over generic `always`.
- Active-low signals use `_n` suffix (e.g. `rst_n`).
- Single clock domain; no gated clocks (use clock enables).
- No tri-state inside modules; no internal oscillators unless specified.
- Do not instantiate RAM/ROM unless part of the design spec (this project includes SRAM by spec).
- Every port and non-obvious parameter needs an end-of-line English comment.

## Parameters & Reset

- Use `parameter` / `localparam`; avoid magic numbers. Use `generate` for replication.
- Prefer elaboration-time functions for lookup tables over external scripts.
- Asynchronous active-low reset when applicable; no reset synchronizers unless required.
- Reset initializes control/state only; avoid resetting large datapath arrays.

## Synthesis & Constraints

- Provide SDC for all clock domains: `set_false_path` on async reset, I/O delays, clock uncertainty.
- RTL must pass Verilator `--lint-only`.

## Testbenches

- Self-checking with PASS/FAIL; use `$error()` on failure.
- Cover reset, basic ops, overwrite, boundary addresses, and idle behavior.

## Simulation

- Support iverilog (`sim`) and Verilator lint (`lint`). Makefile targets: `sim`, `lint`, `clean`.
- All tests must pass before committing.

## ASIC (LibreLane)

- Config under `syn/librelane/`; SDC under `syn/`.
- Verify synthesis through signoff (DRC, LVS, XOR); aim for zero DRC violations.

## FPGA (Future)

- Use vendor-recommended reset style; block RAM for large tables; add `.xdc` / `.qsf` as needed.

## Scripts

- Python scripts in `scripts/` must be standalone with `-h`/`--help` and English comments.
