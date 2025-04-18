`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
    Top module for UART signal processing
*/
//////////////////////////////////////////////////////////////////////////////////


module top_uart(
    input wire CLK, // 100MHZ
    input wire RX,  // Input serial from GUI
    output wire [1:0] Img_Select, // Decoded test pattern selection signal
    output wire [1:0] Res_Select, // Decoded resolution selection signal
    output wire Out_Select,       // Decoded output monitor selection signal
    output wire o_reset,          // Decoded reset signal (set both monitors to black [off])
    output wire pix_en_out,       // Decoded pixel enable for downloaded image processing
    output wire [7:0] cmd_out,    // Debounced UART data
    output wire data_valid        // Used one the UART data is deboounced
    );
    
    // First two are resolution, try for constant 640x480 first
    // combine with full project
    
    wire pix_rx;
    wire [7:0] out_bits;
    reg pix_en_in = 1'b0;
    reg read_write = 0;
    reg [7:0] data_in = 0;
    integer i = 0;
    wire done;
    wire ena = 1;
    reg [18:0] address = 0;
    wire [7:0] img_hres;
    wire [7:0] img_vres;
    
    parameter const = 17'd65536;
    
    // UART Reciever
    uart_rx #(870) uart1 (.clk_100(CLK), .RX(RX), .data_valid(data_valid), .out_bits(out_bits));

    // Command decoder
    RX_Decoder decode1 (.i_clk(CLK), .RX(cmd_out), .pix_en(pix_en_out), .data_valid(data_valid), .Img_Select(Img_Select), .Res_Select(Res_Select), .Out_Select(Out_Select), .reset(o_reset));
    
    always@(posedge CLK)
    begin 
        if(done) pix_en_in = pix_en_out;
        
        if (pix_en_out && data_valid) // recieved data
        begin
            data_in <= cmd_out;
        end
        else
            read_write <= 0;
    end    
  
    // handle pixel en
    handle_pix handle1 (.CLK(CLK), .rx_out(out_bits), .pix_en_in(pix_en_in), .data_valid(data_valid), .pix_en_out(pix_en_out), .done(done), .cmd_out(cmd_out), .img_hres(img_hres), .img_vres(img_vres));
    
endmodule
