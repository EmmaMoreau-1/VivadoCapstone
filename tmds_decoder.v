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

module tmds_decoder(
    input wire clk_1x_in, 
    input wire [9:0] deser_data,     
    output reg [7:0] tmds_data_out,
    output reg hsync_tmds,
    output reg vsync_tmds
    );

    parameter CRTPAR0 =10'b1101010100;
    parameter CRTPAR1 =10'b0010101011;
    parameter CRTPAR2 =10'b0101010100;
    parameter CRTPAR3 =10'b1010101011;
    
    wire [7:0] data;
    assign data = (deser_data[9]) ? ~deser_data[7:0] : deser_data[7:0]; 
    
    always @ (posedge clk_1x_in) begin
        if(deser_data==CRTPAR0) begin
            hsync_tmds <= 1'b0;
            vsync_tmds <= 1'b0;
        end else if (deser_data==CRTPAR1) begin
            hsync_tmds <= 1'b1;
            vsync_tmds <= 1'b0;
        end else if (deser_data==CRTPAR2) begin
            hsync_tmds <= 1'b0;
            vsync_tmds <= 1'b1;
        end else if (deser_data==CRTPAR3) begin
            hsync_tmds <= 1'b1;
            vsync_tmds <= 1'b1;
        end else begin 
            tmds_data_out[0] <= data[0];
            tmds_data_out[1] <= (deser_data[8]) ? (data[1] ^ data[0]) : (data[1] ~^ data[0]);
            tmds_data_out[2] <= (deser_data[8]) ? (data[2] ^ data[1]) : (data[2] ~^ data[1]);
            tmds_data_out[3] <= (deser_data[8]) ? (data[3] ^ data[2]) : (data[3] ~^ data[2]);
            tmds_data_out[4] <= (deser_data[8]) ? (data[4] ^ data[3]) : (data[4] ~^ data[3]);
            tmds_data_out[5] <= (deser_data[8]) ? (data[5] ^ data[4]) : (data[5] ~^ data[4]);
            tmds_data_out[6] <= (deser_data[8]) ? (data[6] ^ data[5]) : (data[6] ~^ data[5]);
            tmds_data_out[7] <= (deser_data[8]) ? (data[7] ^ data[6]) : (data[7] ~^ data[6]);
            hsync_tmds <= 1'b0;
            vsync_tmds <= 1'b0;
        end  
    end
    
endmodule 