# librelane-playground

A minimal SystemVerilog traffic light controller for **ASIC** (LibreLane) and future **FPGA** flows. The design cycles through GREEN → YELLOW → RED on each button press, with on-chip debounce and edge detection.

## Features

- Button-controlled traffic light state machine (three LEDs)
- On-chip debounce (configurable, default 10 ms) and positive edge detection
- Single clock domain, asynchronous active-low reset
- Self-checking Icarus Verilog testbench
- Verilator lint target
- LibreLane synthesis configuration with SDC timing constraints

## Directory Layout

```
rtl/          SystemVerilog RTL (top.sv, debounce.sv, edge_detect.sv)
tb/           Simulation testbenches
sim/          Simulation Makefile (iverilog, Verilator lint)
syn/          Timing constraints (top.sdc)
syn/librelane/  LibreLane config and build scripts
scripts/      Utility scripts (optional)
```

## Design Interface

Top module: `top`

| Port    | Direction | Width | Description                    |
|---------|-----------|-------|--------------------------------|
| `clk`   | input     | 1     | System clock                   |
| `rst_n` | input     | 1     | Asynchronous reset, active low |
| `key`   | input     | 1     | Button input                   |
| `led_g` | output    | 1     | Green LED (active high)        |
| `led_y` | output    | 1     | Yellow LED (active high)       |
| `led_r` | output    | 1     | Red LED (active high)          |

Default parameter: `DEBOUNCE_MS = 10`.

State transitions: GREEN → (key press) → YELLOW → (key press) → RED → (key press) → GREEN

## Prerequisites

- [Icarus Verilog](http://iverilog.icarus.com/) (`iverilog`, `vvp`) for simulation
- [Verilator](https://www.veripool.org/verilator/) for lint
- [LibreLane](https://github.com/librelane/librelane) for ASIC flow (optional)
- [GTKWave](https://gtkwave.sourceforge.net/) for waveform viewing (optional)

## Simulation

```bash
cd sim
make sim      # compile and run testbench
make lint     # Verilator lint on RTL
make clean    # remove build artifacts
```

Expected output ends with `PASS` and zero failures.

## ASIC Flow (LibreLane)

```bash
cd syn/librelane
./build.sh              # run full LibreLane flow
./view_klayout.sh       # view last run in KLayout
./view_openroad.sh    # view last run in OpenROAD
```

Configuration files:

- `config.json` — minimal overrides
- `config.tcl` — full flow parameters
- `../top.sdc` — clock, I/O delay, and reset constraints

## FPGA Flow (Future)

Pin constraints (`.xdc` / `.qsf`) are not included yet. When targeting an FPGA board, add vendor constraints under `fpga/` and map the button/LED I/O as needed.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
