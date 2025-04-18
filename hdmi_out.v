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

module hdmi_out(
    input  wire i_pix_clk,            
    input  wire reset_in,              
    input  wire hsync,
    input  wire vsync,
    input  wire blanking,
    input  wire [7:0] i_data_ch0,   
    input  wire [7:0] i_data_ch1,   
    input  wire [7:0] i_data_ch2,   
    output wire o_tmds_ch0_serial,  // Serial data channel 0
    output wire o_tmds_ch1_serial,  // Serial data channel 1
    output wire o_tmds_ch2_serial,  // Serial data channel 2
    output wire pix_1x_clk   // channel clock - serial TMDS
    );

    wire [9:0] tmds_ch0, tmds_ch1, tmds_ch2;

    wire pix_5x_clk;
    wire clk_locked;
    serializer_clk ser_clk (
        .clk_1x(pix_1x_clk),
        .clk_5x(pix_5x_clk),
        .reset(reset_in),
        .locked(clk_locked),
        .clk_in(i_pix_clk)
    );
    
//    //FIFO instance
//    wire fifo_empty;
//    wire fifo_blanking;
//    wire [1:0] fifo_hvsync;
//    wire [7:0] fifo_blue, fifo_green, fifo_red;
//    reg not_fifo_empty;
//    reg [26:0] fifo_data_out;
//    wire [26:0] fifo_data_in, fifo_data_buffer;
//    assign fifo_data_in = {vsync, hsync, blanking, i_data_ch0, i_data_ch1, i_data_ch2};
//    assign fifo_hvsync = fifo_data_out[26:25];
//    assign fifo_blanking = fifo_data_out[24];
//    assign fifo_blue = fifo_data_out[23:16];
//    assign fifo_green = fifo_data_out[15:8];
//    assign fifo_red = fifo_data_out[7:0];
//    always @ (posedge pix_1x_clk) begin
//        not_fifo_empty <= ~fifo_empty;
//        fifo_data_out <= fifo_data_buffer;
//    end

//    fifo_generator fifo_change_clk_domain (
//        .rst(reset_in),
//        .wr_clk(i_pix_clk),
//        .rd_clk(pix_1x_clk),
//        .din(fifo_data_in),
//        .wr_en(clk_locked),
//        .rd_en(not_fifo_empty),
//        .dout(fifo_data_buffer),
//        .full(),
//        .empty(fifo_empty)
//    );

    tmds_encoder encode_ch0 (
        .clk_1x_in(pix_1x_clk),
        .pixel_data(i_data_ch0), //was "fifo_blue"
        .ctrl_signals({vsync, hsync}), //was "fifo_hvsync"
        .blanking(blanking),
        .tmds_data_out(tmds_ch0)
    );

    tmds_encoder encode_ch1 (
        .clk_1x_in(pix_1x_clk),
        .pixel_data(i_data_ch1),
        .ctrl_signals(2'b00),
        .blanking(blanking),
        .tmds_data_out(tmds_ch1)
    );

    tmds_encoder encode_ch2 (
        .clk_1x_in(pix_1x_clk),
        .pixel_data(i_data_ch2),
        .ctrl_signals(2'b00),
        .blanking(blanking),
        .tmds_data_out(tmds_ch2)
    );

    serializer serialize_ch0 (
        .pix_1x_clk(pix_1x_clk),
        .pix_5x_clk(pix_5x_clk),
        .i_rst_oserdes(!clk_locked),
        .i_data(tmds_ch0),
        .o_data(o_tmds_ch0_serial)
    );

    serializer serialize_ch1 (
        .pix_1x_clk(pix_1x_clk),
        .pix_5x_clk(pix_5x_clk),
        .i_rst_oserdes(!clk_locked),
        .i_data(tmds_ch1),
        .o_data(o_tmds_ch1_serial)
    );

    serializer serialize_ch2 (
        .pix_1x_clk(pix_1x_clk),
        .pix_5x_clk(pix_5x_clk),
        .i_rst_oserdes(!clk_locked),
        .i_data(tmds_ch2),
        .o_data(o_tmds_ch2_serial)
    );

endmodule
