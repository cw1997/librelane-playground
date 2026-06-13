// ============================================================================
// Top — Self-checking testbench for traffic light controller
// ============================================================================

`timescale 1ns / 1ps

module top_tb;

    localparam time CLK_PERIOD = 20ns;          // 50 MHz clock
    localparam int  DEBOUNCE_MS = 1;            // Use 1ms debounce for simulation speed

    logic clk;
    logic rst_n;
    logic key;
    logic led_g;
    logic led_y;
    logic led_r;

    int passed = 0;
    int failed = 0;

    top #(
        .DEBOUNCE_MS (DEBOUNCE_MS)
    ) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .key   (key),
        .led_g (led_g),
        .led_y (led_y),
        .led_r (led_r)
    );

    initial clk = 1'b0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Wait for the debounce circuit to settle after a key change
    // CNT_MAX = 50 MHz * DEBOUNCE_MS / 1000; add margin for reset + sync
    task automatic wait_debounce();
        repeat (50_000 * DEBOUNCE_MS + 100) @(posedge clk);
    endtask

    // Simulate a full button press-and-release cycle
    task automatic press_key();
        key = 1'b1;
        wait_debounce();
        key = 1'b0;
        wait_debounce();
    endtask

    task automatic check_leds(
        input string desc,
        input logic exp_g,
        input logic exp_y,
        input logic exp_r
    );
        if (led_g === exp_g && led_y === exp_y && led_r === exp_r) begin
            $display("  PASS: %s (G=%b Y=%b R=%b)", desc, led_g, led_y, led_r);
            passed++;
        end else begin
            $error("  FAIL: %s - got G=%b Y=%b R=%b, expected G=%b Y=%b R=%b",
                   desc, led_g, led_y, led_r, exp_g, exp_y, exp_r);
            failed++;
        end
    endtask

    initial begin
        $display("=== Traffic Light Controller Testbench ===\n");

        key = 1'b0;

        // Reset: should default to GREEN
        rst_n = 1'b0;
        repeat (3) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
        check_leds("Reset -> GREEN", 1'b1, 1'b0, 1'b0);

        // Press key once -> YELLOW
        press_key();
        check_leds("Press 1 -> YELLOW", 1'b0, 1'b1, 1'b0);

        // Press key again -> RED
        press_key();
        check_leds("Press 2 -> RED", 1'b0, 1'b0, 1'b1);

        // Press key again -> GREEN
        press_key();
        check_leds("Press 3 -> GREEN", 1'b1, 1'b0, 1'b0);

        // Press two more times to verify full cycle
        press_key();
        check_leds("Press 4 -> YELLOW", 1'b0, 1'b1, 1'b0);

        press_key();
        check_leds("Press 5 -> RED", 1'b0, 1'b0, 1'b1);

        // Hold key low and verify state stays in RED
        repeat (100) @(posedge clk);
        check_leds("Idle RED (no press)", 1'b0, 1'b0, 1'b1);

        // One more press back to GREEN
        press_key();
        check_leds("Press 6 -> GREEN", 1'b1, 1'b0, 1'b0);

        $display("\n=== Results: %0d passed, %0d failed ===", passed, failed);
        if (failed == 0) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        $finish;
    end

endmodule
