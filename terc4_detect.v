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

module terc4_detect(
    input  wire clk_1x_in,
    input  wire [9:0] deser_data,
    output reg is_terc4
    );
    
    parameter CRTPAR0 =10'b1010011100;
    parameter CRTPAR1 =10'b1001100011;
    parameter CRTPAR2 =10'b1011100100;
    parameter CRTPAR3 =10'b1011100010;
    parameter CRTPAR4 =10'b0101110001;
    parameter CRTPAR5 =10'b0100011110;
    parameter CRTPAR6 =10'b0110001110;
    parameter CRTPAR7 =10'b0100111100;
    parameter CRTPAR8 =10'b1011001100;
    parameter CRTPAR9 =10'b0100111001;
    parameter CRTPAR10 =10'b0110011100;
    parameter CRTPAR11 =10'b1011000110;
    parameter CRTPAR12 =10'b1010001110;
    parameter CRTPAR13 =10'b1001110001;
    parameter CRTPAR14 =10'b0101100011;
    parameter CRTPAR15 =10'b1011000011;
    parameter CRTPAR16 =10'b0100110011;
    
    always @ (posedge clk_1x_in) begin
        if(deser_data==CRTPAR0) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR1) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR2) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR3) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR4) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR5) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR6) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR7) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR8) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR9) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR10) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR11) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR12) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR13) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR14) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR15) begin
            is_terc4 <= 1'b1;
        end else if (deser_data==CRTPAR15) begin
            is_terc4 <= 1'b1;
        end else begin
            is_terc4 <= 1'b0;
        end 
    end
endmodule