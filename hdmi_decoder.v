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

module hdmi_decoder(
    input  wire clk_1x_in,
    input  wire [9:0] deser_data_b,
    input  wire [9:0] deser_data_g,
    input  wire [9:0] deser_data_r,
    input  wire reset_in,
    output wire error_b,
    output wire error_g,
    output wire error_r,
    output reg [7:0] pixel_data_b,
    output reg [7:0] pixel_data_g,
    output reg [7:0] pixel_data_r,
    output reg hsync,
    output reg vsync,
    output reg blanking,
    output wire de
    );
    
    assign de = ~blanking;
    wire [9:0] blue_out, green_out, red_out;
    wire [7:0] tmds_data_b, tmds_data_g, tmds_data_r;
    wire tmds_hsync, tmds_vsync, terc4_hsync, terc4_vsync;
    tmds_decoder decode_b (
        .clk_1x_in(clk_1x_in),
        .deser_data(blue_out),
        .tmds_data_out(tmds_data_b),
        .hsync_tmds(tmds_hsync),
        .vsync_tmds(tmds_vsync)
    );
    
    tmds_decoder decode_g (
        .clk_1x_in(clk_1x_in),
        .deser_data(green_out),
        .tmds_data_out(tmds_data_g),
        .hsync_tmds(),
        .vsync_tmds()
    );
    
    tmds_decoder decode_r (
        .clk_1x_in(clk_1x_in),
        .deser_data(red_out),
        .tmds_data_out(tmds_data_r),
        .hsync_tmds(),
        .vsync_tmds()
    );
    
    terc4_decoder decode_b_terc4 (
        .clk_1x_in(clk_1x_in),
        .deser_data(blue_out),
        .hsync_terc4(terc4_hsync),
        .vsync_terc4(terc4_vsync)
    );
    
    reg [3:0] counter = 0;
    reg data_pre;
    wire blank_b, ctlp_b, ctlp_g, ctlp_r, terc4p_b;
    always @(posedge clk_1x_in) begin
        if (deser_data_g == 10'b0010101011 && deser_data_r == 10'b0010101011) begin
            counter = counter + 1;
        end else if (counter > 7) begin
            counter = counter + 1;
            data_pre <= 1'b1;
        end
        hsync <= 1'b0;
        vsync <= 1'b0;
        blanking <= blank_b;
        pixel_data_b  <= 8'b00000000;
        pixel_data_g  <= 8'b00000000;
        pixel_data_r  <= 8'b00000000;
    
        if (blank_b == 1'b0) begin
            pixel_data_b  <= tmds_data_b;
            pixel_data_g  <= tmds_data_g;
            pixel_data_r  <= tmds_data_r;
        
        end else if (ctlp_b == 1'b1 && data_pre == 1'b0) begin
            hsync <= tmds_hsync;
            vsync <= tmds_vsync;
        
        end else if (terc4p_b == 1'b1) begin
            hsync <= terc4_hsync;
            vsync <= terc4_vsync;
            data_pre <= 1'b0;
        end
    end

    error_detector error_blue (
        .clk_1x_in(clk_1x_in),
        .reset_in(1'b0),
        .data_in(deser_data_b),
        .data_pre(data_pre),
        .blank(blank_b),
        .CTL_period(ctlp_b),
        .TERC4_period(terc4p_b),
        .DATA_out(blue_out),
        .error(error_b)
    );
    
    error_detector error_green (
        .clk_1x_in(clk_1x_in),
        .reset_in(1'b0),
        .data_in(deser_data_g),
        .data_pre(data_pre),
        .blank(),
        .CTL_period(),
        .TERC4_period(),
        .DATA_out(green_out),
        .error(error_g)
    );
    
    error_detector error_red (
        .clk_1x_in(clk_1x_in),
        .reset_in(1'b0),
        .data_in(deser_data_r),
        .data_pre(data_pre),
        .blank(),
        .CTL_period(),
        .TERC4_period(),
        .DATA_out(red_out),
        .error(error_r)
    );
    
endmodule
