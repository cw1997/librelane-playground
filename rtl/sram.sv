// ============================================================================
// Parameterized synchronous SRAM (behavioral model)
//
// Single-clock, synchronous write and read. Memory array is not reset to
// avoid large reset fanout during synthesis.
// ============================================================================

`timescale 1ns / 1ps

module sram #(
    parameter int DATA_WIDTH = 8,                    // Data bus width (bits)
    parameter int DEPTH      = 256,                  // Number of storage locations
    parameter int ADDR_WIDTH  = $clog2(DEPTH)        // Address bus width (derived from DEPTH)
) (
    input  logic                   clk,              // System clock
    input  logic                   rst_n,            // Asynchronous reset, active low
    input  logic                   we,               // Write enable (high = write)
    input  logic [ADDR_WIDTH-1:0]  addr,             // Address bus
    input  logic [DATA_WIDTH-1:0]  wdata,            // Write data bus
    output logic [DATA_WIDTH-1:0]  rdata             // Registered read data bus
);

    logic [DATA_WIDTH-1:0] mem [DEPTH];
    logic                  read_valid;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rdata      <= '0;
            read_valid <= 1'b0;
        end else begin
            if (we) begin
                mem[addr] <= wdata;
            end
            if (read_valid) begin
                rdata <= mem[addr];
            end else begin
                rdata      <= '0;
                read_valid <= 1'b1;
            end
        end
    end

endmodule
