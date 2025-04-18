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

module bit_slipper(
    input  wire clk_1x_in,
    input  wire reset_in,
    input  wire error_in,
    output reg slip_bit,
    output reg sync_done
    );
    
    reg [15:0] error_counter = 16'b0;
    reg [15:0] no_error_cnt = 16'b0;
    always @(posedge clk_1x_in or posedge reset_in) begin
        if (reset_in) begin
            error_counter <= 16'b0;
            no_error_cnt <= 16'b0;
            sync_done <= 0;
            slip_bit <= 0;
        end else begin
            sync_done <= 0;
            slip_bit <= 0;
            // err counter
            if (error_in) begin
                error_counter <= error_counter + 1;
            end
            if (error_counter > 16'h1F) begin
                slip_bit <= 1;
                error_counter <= 16'b0;
                no_error_cnt <= 16'b0;
            end
            if (no_error_cnt < 16'hFFFF) begin
                no_error_cnt <= no_error_cnt + 1;
            end else begin
                sync_done <= 1;
            end
        end
    end
      
endmodule
