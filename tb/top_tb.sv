// ============================================================================
// Top — Self-checking testbench for parameterized SRAM wrapper
// ============================================================================

`timescale 1ns / 1ps

module top_tb;

    localparam int DATA_WIDTH = 8;
    localparam int DEPTH      = 256;
    localparam int ADDR_WIDTH = $clog2(DEPTH);
    localparam time CLK_PERIOD = 20ns;

    logic                   clk;
    logic                   rst_n;
    logic                   we;
    logic [ADDR_WIDTH-1:0]  addr;
    logic [DATA_WIDTH-1:0]  wdata;
    logic [DATA_WIDTH-1:0]  rdata;

    int passed = 0;
    int failed = 0;

    top #(
        .DATA_WIDTH (DATA_WIDTH),
        .DEPTH      (DEPTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) dut (
        .clk   (clk),
        .rst_n (rst_n),
        .we    (we),
        .addr  (addr),
        .wdata (wdata),
        .rdata (rdata)
    );

    initial clk = 1'b0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    task automatic tick();
        @(posedge clk);
    endtask

    task automatic write_mem(
        input logic [ADDR_WIDTH-1:0] a,
        input logic [DATA_WIDTH-1:0] d
    );
        we    = 1'b1;
        addr  = a;
        wdata = d;
        tick();
        we    = 1'b0;
    endtask

    task automatic read_mem(
        input  logic [ADDR_WIDTH-1:0] a,
        output logic [DATA_WIDTH-1:0] d
    );
        we   = 1'b0;
        addr = a;
        tick();
        d = rdata;
    endtask

    task automatic check_eq(
        input logic [DATA_WIDTH-1:0] actual,
        input logic [DATA_WIDTH-1:0] expected,
        input string               desc
    );
        if (actual === expected) begin
            $display("  PASS: %s (0x%0h)", desc, actual);
            passed++;
        end else begin
            $error("  FAIL: %s - got 0x%0h, expected 0x%0h", desc, actual, expected);
            failed++;
        end
    endtask

    logic [DATA_WIDTH-1:0] read_data;

    initial begin
        $display("=== Top SRAM Testbench ===\n");

        rst_n = 1'b0;
        we    = 1'b0;
        addr  = '0;
        wdata = '0;

        repeat (3) tick();
        rst_n = 1'b1;
        tick();

        check_eq(rdata, '0, "Read data zero after reset");

        write_mem(8'd10, 8'hA5);
        read_mem(8'd10, read_data);
        check_eq(read_data, 8'hA5, "Single-address write/read");

        write_mem(8'd0,   8'h11);
        write_mem(8'd1,   8'h22);
        write_mem(8'd255, 8'hFF);

        read_mem(8'd0,   read_data);
        check_eq(read_data, 8'h11, "Address 0 readback");

        read_mem(8'd1,   read_data);
        check_eq(read_data, 8'h22, "Address 1 readback");

        read_mem(8'd255, read_data);
        check_eq(read_data, 8'hFF, "Boundary address 255 readback");

        write_mem(8'd10, 8'h5A);
        read_mem(8'd10, read_data);
        check_eq(read_data, 8'h5A, "Overwrite existing location");

        write_mem(8'd20, 8'hCD);
        read_mem(8'd20, read_data);
        check_eq(read_data, 8'hCD, "New location after overwrite");

        read_mem(8'd10, read_data);
        check_eq(read_data, 8'h5A, "Unrelated location unchanged");

        write_mem(8'd30, 8'hCD);
        read_mem(8'd30, read_data);
        check_eq(read_data, 8'hCD, "Address 30 write/read");
        addr = 8'd30;
        we   = 1'b0;
        repeat (2) tick();
        check_eq(rdata, 8'hCD, "Read data holds during idle cycles at same address");

        $display("\n=== Results: %0d passed, %0d failed ===", passed, failed);
        if (failed == 0) begin
            $display("PASS");
        end else begin
            $display("FAIL");
        end
        $finish;
    end

endmodule
