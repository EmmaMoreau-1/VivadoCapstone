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

module tmds_detect(
    input wire clk_1x_in, 
    input wire [9:0] deser_data,
    output reg is_tmds
    );

    parameter CRTPAR0 =10'b1101010100;
    parameter CRTPAR1 =10'b0010101011;
    parameter CRTPAR2 =10'b0101010100;
    parameter CRTPAR3 =10'b1010101011;
    
    always @ (posedge clk_1x_in) begin
        if(deser_data==CRTPAR0) begin
            is_tmds <= 1'b1;
        end else if (deser_data==CRTPAR1) begin
            is_tmds <= 1'b1;
        end else if (deser_data==CRTPAR2) begin
            is_tmds <= 1'b1;
        end else if (deser_data==CRTPAR3) begin
            is_tmds <= 1'b1;
        end else begin 
            is_tmds <= 1'b0;
        end  
    end
    
endmodule 