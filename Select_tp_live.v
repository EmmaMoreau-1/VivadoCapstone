`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2025 01:54:43 PM
// Design Name: 
// Module Name: Select_tp_live
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Select_tp_live(
    input wire [7:0] pix_b_live,
    input wire [7:0] pix_g_live,
    input wire [7:0] pix_r_live,
    input wire [7:0] redh,
    input wire [7:0] greenh,
    input wire [7:0] blueh,
    input wire hsync_live,
    input wire vsync_live,
    input wire de_live,
    input wire pix_clk_live,
    input wire pix_clk_5x_live,
    input wire hsync_tp,
    input wire vsync_tp,
    input wire de_tp,
    input wire pix_clk_tp,
    input wire pix_clk_5x_tp,
//    input wire [7:0] redv,
//    input wire [7:0] greenv,
//    input wire [7:0] bluev,
    input wire [1:0] Img_Select,
    output wire [7:0] red_hout,
    output wire [7:0] green_hout,
    output wire [7:0] blue_hout,
    output wire pix_clk_out,
    output wire pix_clk_5x_out,
    output wire HSYNC,
    output wire VSYNC,
    output wire de,
    output wire [7:0] red_vout,
    output wire [7:0] green_vout,
    output wire [7:0] blue_vout
    );
    
    assign red_hout = (Img_Select == 2'b11) ? pix_r_live : redh;
    assign green_hout = (Img_Select == 2'b11) ? pix_g_live : greenh;
    assign blue_hout = (Img_Select == 2'b11) ? pix_b_live : blueh;
    
    assign pix_clk_out = (Img_Select == 2'b11) ? pix_clk_live : pix_clk_tp;
    assign pix_clk_5x_out = (Img_Select == 2'b11) ? pix_clk_5x_live : pix_clk_5x_tp;
    assign HSYNC = (Img_Select == 2'b11) ? hsync_live : hsync_tp;
    assign VSYNC = (Img_Select == 2'b11) ? vsync_live : vsync_tp;
    assign de = (Img_Select == 2'b11) ? de_live : de_tp;
    
endmodule
