`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2025 12:47:17 PM
// Design Name: 
// Module Name: handling
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


module handle_pix(
    input wire CLK, // Board clock
    input wire [7:0] rx_out, // output from uart
    input wire pix_en_in, // old pix_en
    input wire data_valid,
    output wire pix_en_out, // new pix_en
    output wire done,
    output wire [7:0] cmd_out, // output command
    output reg [7:0] img_hres,
    output reg [7:0] img_vres
    );
    
    reg [7:0] cmd;
    reg en_adj;
    reg pix_en_reg;
    reg done_reg;
    reg [1:0] res_count;
  
    always@(posedge CLK) 
    begin
        done_reg <= 0;
        if (rx_out == 8'b00000000 && data_valid) 
        begin
            if (res_count == 2'b10 || pix_en_in == 1'b1) begin
                done_reg <= 1'b1;
                pix_en_reg <= ~pix_en_in;
                res_count <= 2'b00;
                cmd <= 8'b00000000; // set the command to just 0 (ignore)
            end
            else if (res_count == 2'b01 && pix_en_in == 1'b0) begin
                img_hres <= rx_out;
                pix_en_reg <= pix_en_in;
                cmd <= 8'b00000000; // set the command to just 0 (ignore)
                res_count <= 2'b10;
            end
            else if (pix_en_in == 1'b0)begin
                img_vres <= rx_out;
                pix_en_reg <= pix_en_in;
                cmd <= 8'b00000000; // set the command to just 0 (ignore)
                res_count <= 2'b01;
            end
        end
        else
        begin
            done_reg <= 1'b1;
            pix_en_reg <= pix_en_in;
            cmd <= rx_out; // output the command
        end
    end
    
    assign cmd_out = cmd;
    assign pix_en_out = pix_en_reg;
    assign done = done_reg;

endmodule
