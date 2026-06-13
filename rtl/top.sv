// ============================================================================
// Top Level — Traffic Light Controller with Button Input
//
// Cycles through GREEN -> YELLOW -> RED on each button press.
// Includes on-chip debounce and edge detection.
// ============================================================================

`timescale 1ns / 1ps

module top #(
    parameter int DEBOUNCE_MS = 10            // Debounce time in milliseconds
) (
    input  logic clk,                         // System clock
    input  logic rst_n,                       // Asynchronous reset, active low
    input  logic key,                         // Button input
    output logic led_g,                       // Green LED (active high)
    output logic led_y,                       // Yellow LED (active high)
    output logic led_r                        // Red LED (active high)
);

    typedef enum logic [1:0] {
        GREEN  = 2'b00,
        YELLOW = 2'b01,
        RED    = 2'b10
    } state_t;

    state_t state, next;                      // Current and next state

    logic key_deb;                            // Debounced key
    logic key_press;                          // Key press edge pulse

    // Debounce the raw button input
    debounce #(
        .CLK_FREQ    (50_000_000),
        .DEBOUNCE_MS (DEBOUNCE_MS)
    ) u_debounce (
        .clk    (clk),
        .rst_n  (rst_n),
        .btn_in (key),
        .btn_out(key_deb)
    );

    // Detect rising edge of debounced key
    edge_detect u_edge_detect (
        .clk        (clk),
        .rst_n      (rst_n),
        .sig_in     (key_deb),
        .posedge_out(key_press)
    );

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= GREEN;
        end else begin
            state <= next;
        end
    end

    // Next-state logic
    always_comb begin
        next = state;
        unique case (state)
            GREEN:  if (key_press) next = YELLOW;
            YELLOW: if (key_press) next = RED;
            RED:    if (key_press) next = GREEN;
            default: next = GREEN;
        endcase
    end

    // Output logic
    always_comb begin
        led_g = 1'b0;
        led_y = 1'b0;
        led_r = 1'b0;
        unique case (state)
            GREEN:  led_g = 1'b1;
            YELLOW: led_y = 1'b1;
            RED:    led_r = 1'b1;
            default: led_g = 1'b1;
        endcase
    end

endmodule
