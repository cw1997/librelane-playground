# ============================================================================
# LibreLane Configuration — top (Traffic Light Controller)
# ============================================================================

set ::env(DESIGN_NAME) "top"

set ::env(VERILOG_FILES) "\
    $::env(DESIGN_DIR)/../../rtl/debounce.sv \
    $::env(DESIGN_DIR)/../../rtl/edge_detect.sv \
    $::env(DESIGN_DIR)/../../rtl/top.sv"

set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "20.0"

set ::env(SDC_FILE) "$::env(DESIGN_DIR)/../top.sdc"

set ::env(DIE_AREA) "0 0 300 300"
set ::env(FP_SIZING) "absolute"
set ::env(FP_CORE_UTIL) 45
set ::env(FP_ASPECT_RATIO) 1

set ::env(SYNTH_STRATEGY) "AREA 0"
set ::env(VERILOG_INCLUDE_DIRS) ""

set ::env(FP_IO_HMETAL) "4"
set ::env(FP_IO_VMETAL) "3"

set ::env(VDD_NETS) "VDD"
set ::env(GND_NETS) "VSS"
set ::env(FP_PDN_VPITCH) 100
set ::env(FP_PDN_HPITCH) 100

set ::env(ROUTING_STRATEGY) 0
set ::env(GLB_RT_MAXLAYER) 6

set ::env(MAGIC_ZEROIZE_ORIGIN) 0
set ::env(FP_PDN_ENABLE_RAILS) 1

set ::env(RUN_KLAYOUT_XOR) 1
set ::env(RUN_KLAYOUT_DRC) 1
set ::env(RUN_MAGIC_DRC) 1
set ::env(RUN_MAGIC_LVS) 1
