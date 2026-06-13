// ============================================================================
// Positive Edge Detection Module
//
// Generates a single-cycle pulse on the rising edge of the input signal.
// ============================================================================

`timescale 1ns / 1ps

module edge_detect (
    input  logic clk,                         // System clock
    input  logic rst_n,                       // Asynchronous reset, active low
    input  logic sig_in,                      // Signal to detect edge on
    output logic posedge_out                  // Single-cycle positive edge pulse
);

    logic sig_d1;                             // Delayed signal (1 cycle)

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sig_d1 <= 1'b0;
        end else begin
            sig_d1 <= sig_in;
        end
    end

    assign posedge_out = sig_in & ~sig_d1;

endmodule
