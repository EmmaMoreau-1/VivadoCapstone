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

module hdmi_inout(
    input  wire CLK,                // Board Clock: 100 MHz Nexys Video
    input  wire RST_BTN,            // Reset Button
    
    //HDMI IN
    inout  wire hdmi_rx_cec,        
    inout  wire hdmi_rx_sda,
    input  wire hdmi_rx_scl,
    output wire hdmi_rx_hpa,
    output wire hdmi_rx_txen,
    
    input  wire hdmi_rx_clk_p,      // HDMI clock differential positive
    input  wire hdmi_rx_clk_n,      // HDMI clock differential negative
    //input wire i_buf_pix_clk,
    input  wire [2:0] hdmi_rx_p,    // Three HDMI channels differential positive
    input  wire [2:0] hdmi_rx_n,    // Three HDMI channels differential negative
    
    output wire [7:0] pix_blue, 
    output wire [7:0] pix_green, 
    output wire [7:0] pix_red,
    output wire pixel_clk, 
    output wire pixel_clk_5x, 
    output wire hsync, 
    output wire vsync, 
    output wire de
    //output wire i_buf_pix_clk
//HDMI OUT
//    inout  wire hdmi_tx_cec,    
//    input  wire hdmi_tx_hpd,        
//    inout  wire hdmi_tx_rscl,       
//    inout  wire hdmi_tx_rsda,      
    
//    output wire hdmi_tx_clk_p,      // HDMI clock differential positive
//    output wire hdmi_tx_clk_n,      // HDMI clock differential negative
//    output wire [2:0] hdmi_tx_p,    // Three HDMI channels differential positive
//    output wire [2:0] hdmi_tx_n     // Three HDMI channels differential negative

    
    );

    // EDID Instance (handshake between sink and source devices)
    wire [2:0] edid_debug_o;
    edid_rom edid (
        .clk(CLK),
        .sclk_raw(hdmi_rx_scl),
        .sdat_raw(hdmi_rx_sda),
        .edid_debug(edid_debug_o)
    );

    // Input Buffers Instances (for differential signals)
    wire i_buf_blue, i_buf_green, i_buf_red, i_buf_pix_clk;
    IBUFDS #(.DIFF_TERM("FALSE"), .IBUF_LOW_PWR("FALSE"), .IOSTANDARD("TMDS_33"))
        i_buf_ch0 (.I(hdmi_rx_p[0]), .IB(hdmi_rx_n[0]), .O(i_buf_blue));
    IBUFDS #(.DIFF_TERM("FALSE"), .IBUF_LOW_PWR("FALSE"), .IOSTANDARD("TMDS_33"))
        i_buf_ch1 (.I(hdmi_rx_p[1]), .IB(hdmi_rx_n[1]), .O(i_buf_green));
    IBUFDS #(.DIFF_TERM("FALSE"), .IBUF_LOW_PWR("FALSE"), .IOSTANDARD("TMDS_33"))
        i_buf_ch2 (.I(hdmi_rx_p[2]), .IB(hdmi_rx_n[2]), .O(i_buf_red));
    IBUFDS #(.DIFF_TERM("FALSE"), .IBUF_LOW_PWR("FALSE"), .IOSTANDARD("TMDS_33"))
        i_buf_clk (.I(hdmi_rx_clk_p), .IB(hdmi_rx_clk_n), .O(i_buf_pix_clk));

    // HDMI Input 
//    wire [7:0] pix_blue, pix_green, pix_red;
//    wire pixel_clk, pixel_clk_5x, hsync, vsync, de, blank;
    
    wire blank;
    hdmi_in hdmi_input (
        .hdmi_clk(i_buf_pix_clk),
        .reset_in(1'b0),
        .serial_data_ch0(i_buf_blue),
        .serial_data_ch1(i_buf_green),
        .serial_data_ch2(i_buf_red),
        .pix_1x_clk(pixel_clk),
        .pix_5x_clk(pixel_clk_5x),
        .tmds_data_ch0(pix_blue),
        .tmds_data_ch1(pix_green),
        .tmds_data_ch2(pix_red),
        .hsync(hsync),
        .vsync(vsync),
        .blanking(blank),
        .de(de)
    );

//    //Pixel/Frame Manipulation
//    wire [7:0] blue_out, green_out, red_out;
//    horizontalFlip hFlip(
//        .pix_1x_clk(pixel_clk),
//        .reset_in(!RST_BTN),
//        .de(de),
//        .blue_in(pix_blue),
//        .green_in(pix_green),
//        .red_in(pix_red),
//        .blue_out(blue_out),
//        .green_out(green_out),
//        .red_out(red_out)
//    );

    // HDMI Output 
//    wire tmds_ch0_serial, tmds_ch1_serial, tmds_ch2_serial, tmds_chc_serial;
//    hdmi_out hdmi_output (
//        .i_pix_clk(pixel_clk),
//        .reset_in(1'b0),
//        .hsync(hsync),
//        .vsync(vsync),
//        .blanking(blank),
//        .i_data_ch0(pix_blue),    
//        .i_data_ch1(pix_green),    
//        .i_data_ch2(pix_red),     
//        .o_tmds_ch0_serial(tmds_ch0_serial),
//        .o_tmds_ch1_serial(tmds_ch1_serial),
//        .o_tmds_ch2_serial(tmds_ch2_serial),
//        .pix_1x_clk(tmds_chc_serial)
//    );
 
//    // Output Buffers Instances (for differential signals)
//    OBUFDS #(.IOSTANDARD("TMDS_33"), .SLEW("FAST"))
//        tmds_buf_ch0 (.O(hdmi_tx_p[0]), .OB(hdmi_tx_n[0]), .I(tmds_ch0_serial));
//    OBUFDS #(.IOSTANDARD("TMDS_33"), .SLEW("FAST"))
//        tmds_buf_ch1 (.O(hdmi_tx_p[1]), .OB(hdmi_tx_n[1]), .I(tmds_ch1_serial));
//    OBUFDS #(.IOSTANDARD("TMDS_33"), .SLEW("FAST"))
//        tmds_buf_ch2 (.O(hdmi_tx_p[2]), .OB(hdmi_tx_n[2]), .I(tmds_ch2_serial));
//    OBUFDS #(.IOSTANDARD("TMDS_33"), .SLEW("FAST"))
//        tmds_buf_chc (.O(hdmi_tx_clk_p), .OB(hdmi_tx_clk_n), .I(tmds_chc_serial));

//    assign hdmi_tx_cec   = 1'b0;
//    assign hdmi_tx_rsda  = 1'b0;
//    assign hdmi_tx_rscl  = 1'b0;
    assign hdmi_rx_hpa   = 1'b1;
    assign hdmi_rx_cec   = 1'b0;
    assign hdmi_rx_txen  = 1'b1;

endmodule