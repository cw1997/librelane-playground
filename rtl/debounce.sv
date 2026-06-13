// ============================================================================
// Button Debounce Module
//
// Synchronizes and debounces a mechanical button press. The output is asserted
// only after the input has remained stable for DEBOUNCE_MS milliseconds.
// ============================================================================

`timescale 1ns / 1ps

module debounce #(
    parameter int CLK_FREQ    = 50_000_000,  // System clock frequency (Hz)
    parameter int DEBOUNCE_MS = 10           // Debounce time (milliseconds)
) (
    input  logic clk,                         // System clock
    input  logic rst_n,                       // Asynchronous reset, active low
    input  logic btn_in,                      // Raw button input
    output logic btn_out                      // Debounced button output
);

    localparam int CNT_MAX = CLK_FREQ * DEBOUNCE_MS / 1000;
    localparam int CNT_W   = $clog2(CNT_MAX + 1);

    logic [1:0] sync;                         // Synchronizer flip-flops

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync <= '0;
        end else begin
            sync <= {sync[0], btn_in};
        end
    end

    logic [CNT_W-1:0] cnt;                    // Debounce counter

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= '0;
            btn_out <= 1'b0;
        end else if (cnt == CNT_MAX) begin
            // Stable for long enough: latch output and restart
            btn_out <= sync[1];
            cnt     <= '0;
        end else if (sync[1] != btn_out) begin
            // Input differs from output: keep counting
            cnt <= cnt + 1'b1;
        end else begin
            // Input matches output: keep idle
            cnt <= '0;
        end
    end

endmodule
