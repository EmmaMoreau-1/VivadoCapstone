`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Author: Leila Eddahmani - 101169903
// Project Name: FPGA Video Processing System
// Target Devices: Nexys Video Artix-7
//
// Description: 
// 
//////////////////////////////////////////////////////////////////////////////////

module serializer(
    input  wire pix_1x_clk,          // parallel clock
    input  wire pix_5x_clk,       // high-speed clock (5 x i_clk when using DDR)
    input  wire i_rst_oserdes,  // reset from async reset (active high)
    input  wire [9:0] i_data,   // input parallel data
    output wire o_data          // output serial data
    );

    // use two OSERDES2 to serialize 10-bit TMDS data
    wire shift1;
    wire shift2;  // wires between oserdes master and slave
    reg [9:0] data_in;
    
    always @ (posedge pix_1x_clk) begin
        data_in <= i_data; 
    end

    OSERDESE2 #(
        .DATA_RATE_OQ("DDR"),   // DDR, SDR
        .DATA_RATE_TQ("SDR"),   // DDR, BUF, SDR
        .DATA_WIDTH(10),        // Parallel data width (2-8,10,14)
        .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE("MASTER"), // MASTER, SLAVE
        .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
    )
    master10 (
        /* verilator lint_off PINCONNECTEMPTY */
        .OFB(),                 // 1-bit output: Feedback path for data
        .OQ(o_data),            // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(),
        .SHIFTOUT2(),
        .TBYTEOUT(),           // 1-bit output: Byte group tristate
        .TFB(),                // 1-bit output: 3-state control
        .TQ(),                 // 1-bit output: 3-state control
        .CLK(pix_5x_clk),        // 1-bit input: High speed clock
        .CLKDIV(pix_1x_clk),        // 1-bit input: Divided clock
        /* verilator lint_on PINCONNECTEMPTY */
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1(data_in[0]),
        .D2(data_in[1]),
        .D3(data_in[2]),
        .D4(data_in[3]),
        .D5(data_in[4]),
        .D6(data_in[5]),
        .D7(data_in[6]),
        .D8(data_in[7]),
        .OCE(1'b1),             // 1-bit input: Output data clock enable
        .RST(i_rst_oserdes),    // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1(shift1),
        .SHIFTIN2(shift2),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1(1'b0),
        .T2(1'b0),
        .T3(1'b0),
        .T4(1'b0),
        .TBYTEIN(1'b0),         // 1-bit input: Byte group tristate
        .TCE(1'b0)              // 1-bit input: 3-state clock enable
    );

    OSERDESE2 #(
        .DATA_RATE_OQ("DDR"),   // DDR, SDR
        .DATA_RATE_TQ("SDR"),   // DDR, BUF, SDR
        .DATA_WIDTH(10),        // Parallel data width (2-8,10,14)
        .INIT_OQ(1'b0),         // Initial value of OQ output (1'b0,1'b1)
        .INIT_TQ(1'b0),         // Initial value of TQ output (1'b0,1'b1)
        .SERDES_MODE("SLAVE"),  // MASTER, SLAVE
        .SRVAL_OQ(1'b0),        // OQ output value when SR is used (1'b0,1'b1)
        .SRVAL_TQ(1'b0),        // TQ output value when SR is used (1'b0,1'b1)
        .TBYTE_CTL("FALSE"),    // Enable tristate byte operation (FALSE, TRUE)
        .TBYTE_SRC("FALSE"),    // Tristate byte source (FALSE, TRUE)
        .TRISTATE_WIDTH(1)      // 3-state converter width (1,4)
    )
    slave10 (
        /* verilator lint_off PINCONNECTEMPTY */
        .OFB(),                 // 1-bit output: Feedback path for data
        .OQ(),                  // 1-bit output: Data path output
        // SHIFTOUT1 / SHIFTOUT2: 1-bit (each) output: Data output expansion (1-bit each)
        .SHIFTOUT1(shift1),
        .SHIFTOUT2(shift2),
        .TBYTEOUT(),           // 1-bit output: Byte group tristate
        .TFB(),                // 1-bit output: 3-state control
        .TQ(),                 // 1-bit output: 3-state control
        .CLK(pix_5x_clk),        // 1-bit input: High speed clock
        .CLKDIV(pix_1x_clk),        // 1-bit input: Divided clock
        /* verilator lint_on PINCONNECTEMPTY */
        // D1 - D8: 1-bit (each) input: Parallel data inputs (1-bit each)
        .D1(1'b0),
        .D2(1'b0),
        .D3(data_in[8]),
        .D4(data_in[9]),
        .D5(1'b0),
        .D6(1'b0),
        .D7(1'b0),
        .D8(1'b0),
        .OCE(1'b1),             // 1-bit input: Output data clock enable
        .RST(i_rst_oserdes),    // 1-bit input: Reset
        // SHIFTIN1 / SHIFTIN2: 1-bit (each) input: Data input expansion (1-bit each)
        .SHIFTIN1(1'b0),
        .SHIFTIN2(1'b0),
        // T1 - T4: 1-bit (each) input: Parallel 3-state inputs
        .T1(1'b0),
        .T2(1'b0),
        .T3(1'b0),
        .T4(1'b0),
        .TBYTEIN(1'b0),         // 1-bit input: Byte group tristate
        .TCE(1'b0)              // 1-bit input: 3-state clock enable
    );

endmodule
