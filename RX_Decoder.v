`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2024 03:32:42 PM
// Design Name: 
// Module Name: RX_Decoder
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


module RX_Decoder(
    input wire i_clk,
    input wire [7:0] RX,
    input wire pix_en,
    input wire data_valid,
    output wire [1:0] Img_Select,
    output wire [1:0] Res_Select,
    output wire Out_Select,
    output wire reset,
    output wire [7:0] hres,
    output wire [7:0] vres
    );
    
    // need old vals
    reg [1:0] i_select;
    reg [1:0] r_select;
    reg o_select;
    reg o_reset;
    reg res_count;
    
    always@(posedge i_clk) 
    begin
        if(~pix_en && data_valid)
        begin 
            case(RX) 
                8'b01100001:  //a  //tp 1, 640, out1
                begin
                    i_select <= 2'b01;
                    r_select <= 2'b00;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01100010:  //b  //tp 1, 800, out1
                begin
                    i_select <= 2'b01;
                    r_select <= 2'b01;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01100011:  //c  //tp 1, 1280, out1
                 begin
                    i_select <= 2'b01;
                    r_select <= 2'b10;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01100100:  //d  //tp 1, 1920, out1
                 begin
                    i_select <= 2'b01;
                    r_select <= 2'b11;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01100101:  //e  //tp 1, 640, out2
                 begin
                    i_select <= 2'b01;
                    r_select <= 2'b00;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01100110:  //f  //tp 1, 800, out2
                begin
                    i_select <= 2'b01;
                    r_select <= 2'b01;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01100111:  //g  //tp 1, 1280, out2
                begin
                    i_select <= 2'b01;
                    r_select <= 2'b10;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01101000:  //h  //tp 1, 1920, out2
                begin
                    i_select <= 2'b01;
                    r_select <= 2'b11;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01101001:  //i  //tp 2, 640, out1
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b00;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01101010:  //j  //tp 2, 800, out1
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b01;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01101011:  //k  //tp 2, 1280, out1
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b10;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01101100:  //l  //tp 2, 1920, out1
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b11;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01101101:  //m  //tp 2, 640, out2
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b00;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01101110:  //n  //tp 2, 800, out2
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b01;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01101111:  //o  //tp 2, 1280, out2
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b10;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01110000:  //p  //tp 2, 1920, out2
                begin
                    i_select <= 2'b10;
                    r_select <= 2'b11;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01110001:  //q  //live, 640, out1
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b00;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01110010:  //r  //live, 800, out1
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b01;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01110011:  //s  //live, 1280, out1
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b10;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01110100:  //t  //live, 1920, out1
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b11;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
                8'b01110101:  //u  //live, 640, out2
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b00;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01110110:  //v  //live, 800, out2
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b01;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01110111:  //w  //live, 1280, out2
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b10;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01111000:  //x  //live, 1920, out2
                begin
                    i_select <= 2'b11;
                    r_select <= 2'b11;
                    o_select <= 1'b1;
                    o_reset  <= 1'b0;
                end
                8'b01111001:  //y  // reset 
                begin
                    i_select <= 2'b00;
                    r_select <= 2'b00;
                    o_select <= 1'b0;
                    o_reset  <= 1'b1;
                end
                8'b00000000:
                begin   
                    o_reset <= 1'b1;
                end
                
                default: // just test pattern
                begin
                    i_select <= 2'b00;
                    r_select <= 2'b00;
                    o_select <= 1'b0;
                    o_reset  <= 1'b0;
                end
            endcase
        end
    end
    
    assign Img_Select = i_select;
    assign Res_Select = r_select;
    assign Out_Select = o_select;
    assign reset = o_reset;
    
endmodule
