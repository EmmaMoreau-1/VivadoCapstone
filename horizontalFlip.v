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

module horizontalFlip(
    input  wire pix_1x_clk,
    input  wire reset_in,
    input  wire de,
    input  wire [7:0] blue_in,
    input  wire [7:0] green_in,
    input  wire [7:0] red_in,
    
    output wire [7:0] blue_out,
    output wire [7:0] green_out,
    output wire [7:0] red_out
    );
    
    localparam HR = 1920;              //horizontal pixel resolution
    //Combine separate RGB inputs/outputs into single 24-bit signals
    wire [23:0] pixel_in;
    reg [23:0] pixel_out;
    assign pixel_in = {red_in, green_in, blue_in};
    
    //Memory array for storing one line of pixel data
    reg [23:0] line_buffer [0:HR];      //Size adjusted to HR (pixel width)
    reg [24:0] h_count;                 //Internal counter for pixel position in the line
    
    always @(posedge pix_1x_clk or posedge reset_in) begin
        if (reset_in) begin
            h_count <= 0;
        end else if (de) begin
            //Store the current pixel into the line buffer
            line_buffer[h_count] <= pixel_in;
            //Increment the counter during active data periods
            if (h_count < HR - 1) begin
                h_count = h_count + 1;
            end else begin
                h_count <= 0; // Reset at the end of the line
            end
        end
    end

    always @(posedge pix_1x_clk) begin
        if (de) begin
            // Output the horizontally flipped frame (mirror the data)
            pixel_out <= line_buffer[HR - 1 - h_count];
        end
    end
    
    // Split pixel_out into separate 8-bit R, G, and B components
    assign red_out = pixel_out[23:16];
    assign green_out = pixel_out[15:8];
    assign blue_out = pixel_out[7:0];
    
endmodule

    
    
