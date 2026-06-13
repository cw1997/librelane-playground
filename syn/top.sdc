# ============================================================================
# Top Traffic Light — Timing Constraints (Synopsys Design Constraints)
#
# Applicable flow: LibreLane / Yosys + OpenSTA
# ============================================================================

# Master clock: 50 MHz -> 20 ns period
create_clock -name clk -period 20.000 [get_ports clk]

set_clock_uncertainty -setup 0.500 [get_clocks clk]
set_clock_uncertainty -hold  0.300 [get_clocks clk]

# Input delay (asynchronous key input, no strict timing)
set_input_delay -clock clk -max 4.000 [get_ports key]
set_input_delay -clock clk -min 1.000 [get_ports key]

# Output delays (LEDs are combinatorial from registered state)
set_output_delay -clock clk -max 4.000 [get_ports {led_g led_y led_r}]
set_output_delay -clock clk -min 1.000 [get_ports {led_g led_y led_r}]

# Asynchronous reset (false path)
set_false_path -setup -hold [get_ports rst_n]

# Load and transition
set_load -wire_load 0.05 [get_ports {led_g led_y led_r key}]
set_input_transition -max 0.500 [get_ports key]
