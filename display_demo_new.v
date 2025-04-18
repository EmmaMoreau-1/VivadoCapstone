`timescale 1ns / 1ps
`default_nettype none

/////////////////////////////////////////////////////////////////////////////////////////
/*
    Test pattern Generator Module
*/
////////////////////////////////////////////////////////////////////////////////////////

module test_pattern_generator(
    input wire pix_clk,                // pixel clock based off resolution
    input wire [1:0] Img_Select,       // Test pattern selection
    input  wire clk_lock,               // Used just for timing signals
    input wire [11:0] h_res,           // Horizontal Resolutionn
    input wire [11:0] v_res,           // Vertical Resolution
    input wire [7:0] h_fp,             // Blanking signals
    input wire [7:0] h_sync,
    input wire [7:0] h_bp,
    input wire [5:0] v_fp,
    input wire [5:0] v_sync,
    input wire [5:0] v_bp,
    input wire Out_Select,            // Output monitor selection
    input wire h_pol,
    input wire v_pol,
    output reg [7:0] redh,            // HDMI Pixel
    output reg [7:0] greenh,
    output reg [7:0] blueh,
    output reg [7:0] redv,            // VGA pixel
    output reg [7:0] greenv,
    output reg [7:0] bluev,
    output wire de,                   // Data Enable, high for active monitor area
    output wire HSYNC,                // HSYNC for both
    output wire VSYNC                 // VSYNC for both
    );
    
    // Mapping signals
    wire signed [15:0] sx;          // horizontal screen position 
    wire signed [15:0] sy;          // vertical screen position 
    wire frame;                     // frame start

    // Generate timing signals based on resolution, keep track of pixel writing areas throughout frame
    display_timings1 display_timings_inst(              
            .H_RES(h_res),                             
            .V_RES(v_res),                           
            .H_FP(h_fp),                               
            .H_SYNC(h_sync),                          
            .H_BP(h_bp),                                
            .V_FP(v_fp),                                
            .V_SYNC(v_sync),                            
            .V_BP(v_bp),                                
            .H_POL(h_pol),                              
            .V_POL(v_pol),                              
            .i_pix_clk(pix_clk),
            .i_rst(!clk_lock),
            .o_hs(HSYNC),
            .o_vs(VSYNC),
            .o_de(de),
            .o_frame(frame),
            .o_sx(sx),
            .o_sy(sy)
        );

     wire [7:0] red_a, green_a, blue_a; // Outputs from test_card_squares
     wire [7:0] red_b, green_b, blue_b; // Outputs from moving geometry pattern
     

    
    car_race_test test5 (
        .H_RES(h_res),
        .V_RES(v_res),
        .i_x(sx),
        .i_y(sy),
        .CLK(pix_clk),
        .o_red(red_b),
        .o_green(green_b),
        .o_blue(blue_b));
        
    // Test pattern 2
    simple_hitomezashi_pattern test4 (
        .i_x(sx),
        .i_y(sy),
        .CLK(pix_clk),
        .o_red(red_a),
        .o_green(green_a),
        .o_blue(blue_a));
    
    // Test pattern and output monitor switch
    // Check for each pixel
    always @(posedge pix_clk) begin
                case (Img_Select) // Base the case off of Img_Select
                2'b01: begin // Test pattern 1
                    if(Out_Select) begin // Go to VGA monitor
                        redv   <= red_a;
                        greenv <= green_a;
                        bluev  <= blue_a;
                        
                        redh   <= 8'b0; // HDMI turned off
                        greenh <= 8'b0;
                        blueh  <= 8'b0;
                   end
                   
                   else begin // Go to HDMI monitor
                        redh   <= red_a;
                        greenh <= green_a;
                        blueh  <= blue_a;
                        
                        redv   <= 8'b0; // VGA turned off
                        greenv <= 8'b0;
                        bluev  <= 8'b0;
                   end
                end
                
               2'b10: begin // Test pattern 2
                    if(Out_Select) begin // Go to VGA monitor
                        redv   <= red_b;
                        greenv <= green_b;
                        bluev  <= blue_b;
                        
                        redh   <= 8'b0; // HDMI is turned off
                        greenh <= 8'b0;
                        blueh  <= 8'b0;
                   end
                   
                   else begin
                        redh   <= red_b; // Go to HDMI monitor
                        greenh <= green_b;
                        blueh  <= blue_b;
                        
                        redv   <= 8'b0; // VGA is turned off
                        greenv <= 8'b0;
                        bluev  <= 8'b0;
                   end
                end
                
                // Live here?
                2'b11: begin
                   if(Out_Select) begin
                        redv   <= red_b;
                        greenv <= green_b;
                        bluev  <= blue_b;
                        redh   <= 8'b0;
                        greenh <= 8'b0;
                        blueh  <= 8'b0;
                   end
                   else begin
                        redh   <= red_b;
                        greenh <= green_b;
                        blueh  <= blue_b;
                        redv   <= 8'b0;
                        greenv <= 8'b0;
                        bluev  <= 8'b0;
                   end
                end
                default: begin
                // Select outputs from Test pattern 1
                    redh   <= 8'b0;
                    greenh <= 8'b0;
                    blueh  <= 8'b0;
                    redv   <= 8'b0;
                    greenv <= 8'b0;
                    bluev  <= 8'b0;
                end
             endcase
         end
     endmodule
 
 