# librelane-playground

A minimal SystemVerilog SRAM wrapper project for **ASIC** (LibreLane) and future **FPGA** flows. The design exposes a parameterized synchronous SRAM interface at the top level and uses a behavioral memory model suitable for simulation and synthesis.

## Features

- Parameterized SRAM: configurable `DATA_WIDTH` (default 8 bit) and `DEPTH` (default 256 entries)
- Single clock domain, asynchronous active-low reset
- Self-checking Icarus Verilog testbench
- Verilator lint target
- LibreLane synthesis configuration with SDC timing constraints

## Directory Layout

```
rtl/          SystemVerilog RTL (top.sv, sram.sv)
tb/           Simulation testbenches
sim/          Simulation Makefile (iverilog, Verilator lint)
syn/          Timing constraints (top.sdc)
syn/librelane/  LibreLane config and build scripts
scripts/      Utility scripts (optional)
```

## Design Interface

Top module: `top`

| Port    | Direction | Width           | Description                    |
|---------|-----------|-----------------|--------------------------------|
| `clk`   | input     | 1               | System clock                   |
| `rst_n` | input     | 1               | Asynchronous reset, active low |
| `we`    | input     | 1               | Write enable (high = write)    |
| `addr`  | input     | ADDR_WIDTH      | Address bus                    |
| `wdata` | input     | DATA_WIDTH      | Write data                     |
| `rdata` | output    | DATA_WIDTH      | Registered read data           |

Default parameters: `DATA_WIDTH = 8`, `DEPTH = 256`, `ADDR_WIDTH = $clog2(DEPTH)`.

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

Pin constraints (`.xdc` / `.qsf`) are not included yet. When targeting an FPGA board, add vendor constraints under `fpga/` and map the SRAM bus to board I/O or internal block RAM as needed.

## License

Apache License 2.0 — see [LICENSE](LICENSE).
