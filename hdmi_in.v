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

module hdmi_in(
    input  wire hdmi_clk,            // HDMI pixel clock
    input  wire reset_in,
    input  wire serial_data_ch0,
    input  wire serial_data_ch1,
    input  wire serial_data_ch2,
    output wire pix_1x_clk, 
    output wire pix_5x_clk,
    output wire [7:0] tmds_data_ch0,
    output wire [7:0] tmds_data_ch1,
    output wire [7:0] tmds_data_ch2,
    output wire hsync,
    output wire vsync,
    output wire blanking,
    output wire de
    );
    
    wire [9:0] deser_data_ch0;
    wire [9:0] deser_data_ch1;
    wire [9:0] deser_data_ch2;
    
    // Pixel and High Speed Clocks for Deserialization and Decoding
    wire clk_locked;
    
    deserializer_clk deser_clk (
        .clk_1x(pix_1x_clk), 
        .clk_5x(pix_5x_clk),
        .reset(reset_in),
        .locked(clk_locked),
        .clk_in(hdmi_clk) //1920x1080 148.5MHz
    );  
    
    // Blue Channel Deserializer
    deserializer deserialize_ch0 (
        .clk_5x_in(pix_5x_clk),
        .clk_1x_in(pix_1x_clk),
        .reset_in(!clk_locked),
        .clk_locked(clk_locked),
        .serial_data_in(serial_data_ch0),
        .bit_slip(bit_slip_b),
        .deser_data_out(deser_data_ch0)
    );
    // Green Channel Deserializer
    deserializer deserialize_ch1 (
        .clk_5x_in(pix_5x_clk),
        .clk_1x_in(pix_1x_clk),
        .reset_in(!clk_locked),
        .clk_locked(clk_locked),
        .serial_data_in(serial_data_ch1),
        .bit_slip(bit_slip_g),
        .deser_data_out(deser_data_ch1)
    );
    // Red Channel Deserializer
    deserializer deserialize_ch2 (
        .clk_5x_in(pix_5x_clk),
        .clk_1x_in(pix_1x_clk),
        .reset_in(!clk_locked),
        .clk_locked(clk_locked),
        .serial_data_in(serial_data_ch2),
        .bit_slip(bit_slip_r),
        .deser_data_out(deser_data_ch2)
    );
    
    // Bit Slipper Instances (for alignment)
    wire bit_slip_b, bit_slip_g, bit_slip_r;
    wire sync_done_b, sync_done_g, sync_done_r;
    wire [2:0] errors; 
    bit_slipper bit_slip_blue (
        .clk_1x_in(pix_1x_clk),
        .reset_in(!clk_locked),
        .error_in(errors[0]),
        .slip_bit(bit_slip_b),
        .sync_done(sync_done_b)        
    );
    bit_slipper bit_slip_green (
        .clk_1x_in(pix_1x_clk),
        .reset_in(!clk_locked),
        .error_in(errors[1]),
        .slip_bit(bit_slip_g),
        .sync_done(sync_done_g)        
    );
    bit_slipper bit_slip_red (
        .clk_1x_in(pix_1x_clk),
        .reset_in(!clk_locked),
        .error_in(errors[2]),
        .slip_bit(bit_slip_r),
        .sync_done(sync_done_r)        
    );

    // HDMI Decoder Instance
    wire sync_done;
    assign sync_done = ~(sync_done_b & sync_done_g & sync_done_r); 
    hdmi_decoder decode_hdmi (
        .clk_1x_in(pix_1x_clk),
        .deser_data_b(deser_data_ch0),
        .deser_data_g(deser_data_ch1),
        .deser_data_r(deser_data_ch2),
        .reset_in(sync_done),
        .error_b(errors[0]),
        .error_g(errors[1]),
        .error_r(errors[2]),
        .pixel_data_b(tmds_data_ch0),
        .pixel_data_g(tmds_data_ch1),
        .pixel_data_r(tmds_data_ch2),
        .hsync(hsync),
        .vsync(vsync),
        .blanking(blanking),
        .de(de)
    );
     
endmodule
