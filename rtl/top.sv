// ============================================================================
// Top Level — SRAM wrapper
//
// Exposes a parameterized synchronous SRAM interface for simulation and
// ASIC/FPGA flows. Single clock domain, asynchronous active-low reset.
// ============================================================================

`timescale 1ns / 1ps

module top #(
    parameter int DATA_WIDTH = 8,                    // SRAM data width (bits)
    parameter int DEPTH      = 4,                    // SRAM depth (entries)
    parameter int ADDR_WIDTH  = $clog2(DEPTH)        // SRAM address width
) (
    input  logic                   clk,              // System clock
    input  logic                   rst_n,            // Asynchronous reset, active low
    input  logic                   we,               // Write enable (high = write)
    input  logic [ADDR_WIDTH-1:0]  addr,             // Address bus
    input  logic [DATA_WIDTH-1:0]  wdata,            // Write data bus
    output logic [DATA_WIDTH-1:0]  rdata             // Read data bus
);

    sram #(
        .DATA_WIDTH (DATA_WIDTH),
        .DEPTH      (DEPTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) u_sram (
        .clk   (clk),
        .rst_n (rst_n),
        .we    (we),
        .addr  (addr),
        .wdata (wdata),
        .rdata (rdata)
    );

endmodule
