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

module deserializer(
    input wire clk_5x_in,              // High Speed clock
    input wire clk_1x_in,              // Divided clock
    input wire reset_in,
    input wire clk_locked,
    input wire serial_data_in,         // Serial TMDS input data
    input wire bit_slip,  
    output wire [9:0] deser_data_out   // Parallel pixel output data
    );

    wire shift1;
    wire shift2;
    
    ISERDESE2 #(
        .DATA_RATE("DDR"),          
        .DATA_WIDTH(10),            
        .DYN_CLKDIV_INV_EN("FALSE"),
        .DYN_CLK_INV_EN("FALSE"),
        .INIT_Q1(1'b0),
        .INIT_Q2(1'b0),
        .INIT_Q3(1'b0),
        .INIT_Q4(1'b0),        
        .INTERFACE_TYPE("NETWORKING"), 
        .IOBDELAY("NONE"),
        .NUM_CE(1'b1),                 
        .OFB_USED("FALSE"),         
        .SERDES_MODE("MASTER"),         // MASTER or SLAVE
        .SRVAL_Q1(1'b0),
        .SRVAL_Q2(1'b0),
        .SRVAL_Q3(1'b0),
        .SRVAL_Q4(1'b0)
    )
    iserdes_master (
        .O(),
        .Q1(),             
        .Q2(deser_data_out[9]),
        .Q3(deser_data_out[8]),
        .Q4(deser_data_out[7]),
        .Q5(deser_data_out[6]),
        .Q6(deser_data_out[5]),
        .Q7(deser_data_out[4]),
        .Q8(deser_data_out[3]),
        .SHIFTOUT1(shift1),      
        .SHIFTOUT2(shift2),
        .BITSLIP(bit_slip),             
        .CE1(clk_locked),                 
        .CE2(1'b1),                 
        .CLKDIVP(1'b0),
        .CLK(clk_5x_in),             // High Speed clock
        .CLKB(!clk_5x_in),           // Inverted High Speed clock
        .CLKDIV(clk_1x_in),          // Divided clock
        .OCLK(1'b0),
        .DYNCLKDIVSEL(1'b0),        
        .DYNCLKSEL(1'b0),            
        .D(serial_data_in),          // Serial input data 
        .DDLY(1'b0),                  
        .OFB(1'b0),                  
        .OCLKB(1'b0),
        .RST(reset_in),              // Reset
        .SHIFTIN1(1'b0),            
        .SHIFTIN2(1'b0)
    );

    ISERDESE2 #(
        .DATA_RATE("DDR"),          
        .DATA_WIDTH(10),            
        .DYN_CLKDIV_INV_EN("FALSE"),
        .DYN_CLK_INV_EN("FALSE"),
        .INIT_Q1(1'b0),
        .INIT_Q2(1'b0),
        .INIT_Q3(1'b0),
        .INIT_Q4(1'b0),        
        .INTERFACE_TYPE("NETWORKING"), 
        .IOBDELAY("NONE"),
        .NUM_CE(1'b1),                 
        .OFB_USED("FALSE"),         
        .SERDES_MODE("SLAVE"),          // MASTER or SLAVE
        .SRVAL_Q1(1'b0),
        .SRVAL_Q2(1'b0),
        .SRVAL_Q3(1'b0),
        .SRVAL_Q4(1'b0)
    )
    iserdes_slave (
        .O(),
        .Q1(),
        .Q2(),
        .Q3(deser_data_out[2]),                      
        .Q4(deser_data_out[1]),
        .Q5(deser_data_out[0]),
        .Q6(),
        .Q7(),
        .Q8(),
        .SHIFTOUT1(),               
        .SHIFTOUT2(),
        .BITSLIP(bit_slip),
        .CE1(clk_locked),
        .CE2(1'b1),
        .CLKDIVP(1'b0),
        .CLK(clk_5x_in),
        .CLKB(!clk_5x_in),
        .CLKDIV(clk_1x_in),
        .OCLK(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .D(1'b0),                   
        .DDLY(1'b0),
        .OFB(1'b0),
        .OCLKB(1'b0),
        .RST(reset_in),
        .SHIFTIN1(shift1),       
        .SHIFTIN2(shift2)
    );

endmodule