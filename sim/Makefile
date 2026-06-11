# ============================================================================
# SRAM Top — Simulation Makefile
#
# Tool support:
#   make sim            — compile and run with iverilog
#   make lint           — run lint check with Verilator
#   make sim-vcd        — run and open waveform
#   make clean          — clean temporary files
# ============================================================================

IVERILOG     = iverilog
VVP          = vvp
VERILATOR    = verilator
GTKWAVE      = gtkwave

TOP          = top_tb
TOP_MODULE   = top
SRC_DIR      = ../rtl
TB_DIR       = ../tb
BUILD_DIR    = build

RTL_FILES    = $(SRC_DIR)/sram.sv $(SRC_DIR)/top.sv
TB_FILES     = $(TB_DIR)/top_tb.sv
VCD_FILE     = $(TOP).vcd

all: sim

# ------------------------------------------------------------------
# iverilog simulation
# ------------------------------------------------------------------
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

sim: $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -o $(BUILD_DIR)/$(TOP).vvp $(RTL_FILES) $(TB_FILES)
	$(VVP) $(BUILD_DIR)/$(TOP).vvp

sim-vcd: sim
	$(GTKWAVE) $(VCD_FILE)

# ------------------------------------------------------------------
# Verilator lint (no simulation code generation)
# ------------------------------------------------------------------
lint:
	$(VERILATOR) --lint-only --sv $(RTL_FILES)

# ------------------------------------------------------------------
# Clean
# ------------------------------------------------------------------
clean:
	rm -rf $(BUILD_DIR)
	rm -f $(VCD_FILE)

.PHONY: all sim sim-vcd lint clean
