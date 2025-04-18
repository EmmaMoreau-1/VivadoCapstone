`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
    Top Module, performs all selections based off GUI choices
*/ 
//////////////////////////////////////////////////////////////////////////////////


module Selection(
    input  wire i_RX,                // input serial from UART, 115200bps
    input  wire CLK,                // 100Mz Master Clock
    input  wire RST_BTN,            // EXTRA reset used in the clock dividers, not from the GUI
    inout  wire hdmi_tx_cec,        // HDMI CE, high impedence
    input  wire hdmi_tx_hpd,        // hot-plug detect from HDMI, not used
    inout  wire hdmi_tx_rscl,       // HDMI DDC bidirectional, always on
    inout  wire hdmi_tx_rsda,       // HDMI DDC bidirectional, high impedence
    //HDMI IN
    inout  wire hdmi_rx_cec,        
    inout  wire hdmi_rx_sda,
    input  wire hdmi_rx_scl,
    output wire hdmi_rx_hpa,
    output wire hdmi_rx_txen,
    
    input  wire hdmi_rx_clk_p,      // HDMI clock differential positive
    input  wire hdmi_rx_clk_n,      // HDMI clock differential negative
    input  wire [2:0] hdmi_rx_p,    // Three HDMI channels differential positive
    input  wire [2:0] hdmi_rx_n,    // Three HDMI channels differential negative
    
    output wire hdmi_tx_clk_n,      // HDMI clock n
    output wire hdmi_tx_clk_p,      // HDMI clock p
    output wire [2:0] hdmi_tx_n,    // HDMI data channels n
    output wire [2:0] hdmi_tx_p,    // HDMI data channels p
    output wire VGA_HS,             // VGA H_SYNC
    output wire VGA_VS,             // VGA V_SYNC
    output wire [3:0] VGA_R,        // VGA red digital
    output wire [3:0] VGA_G,        // VGA green digital
    output wire [3:0] VGA_B         // VGA blue digital
    );
    
    wire clk_lock;       // clock locked for dividers
    wire clk_lock1; 
    wire clk_lock2;
    wire clk_lock3;
    wire pix_clk640;    // Pixel clocks for each resolution
    wire pix_clk640_5x; // 5x pixel clock for DDR serializing
    wire pix_clk800;
    wire pix_clk800_5x;
    wire pix_clk1280;
    wire pix_clk1280_5x;
    wire pix_clk1920;
    wire pix_clk1920_5x;
   
    wire [7:0] data_out; // data_out from UART, not deboounced
    wire [7:0] Process_Select; // Encoded 8-bit selection signal
    wire [1:0] Img_Select;     // Decoded selection for test-pattern/live
    wire [1:0] Res_Select;     // Decoded selection for resolution
    wire Out_Select;           // Decoded selection for output monitor
    wire reset;                // reset from the GUI
    wire pix_en_out;           // Pixel enable used when an image is being downloaded
    wire data_valid;           // used for the debouncing data_out
    
    wire de_tp;                   // Data enable, when high, the active monitor area is being written to           
    wire [7:0] redh;           // Red channel for HDMI
    wire [7:0] greenh;         // Green channel for HDMI
    wire [7:0] blueh;          // Blue channel for HDMI
    wire [7:0] redv;           // Red channel for VGA
    wire [7:0] greenv;         // Green channel for VGA
    wire [7:0] bluev;          // Blue channel for VGA
    wire hsync_tp;                // HSYNC for both 
    wire vsync_tp;                // VSYNC for both
    
    wire tmds_ch0_serial;      // Serialized HDMI Blue channel
    wire tmds_ch1_serial;      // Serialized HDMI Green channel
    wire tmds_ch2_serial;      // Serialized HDMI Red channel
    wire tmds_chc_serial;      // Serialized HDMI Clock channel
    
    // Calling UART top for full decoding of UART signal
    top_uart uart_1 (.CLK(CLK), .RX(i_RX), .Img_Select(Img_Select), .Res_Select(Res_Select), .Out_Select(Out_Select), .o_reset(reset), .pix_en_out(pix_en_out), .data_valid(data_valid), .cmd_out(data_out));
    
    // Creating all pixel clocks for each resolution
    // Try using hdmi_pix_p clock
    // Try with test patterns alone
      
  wire [7:0] pix_b_live, pix_g_live, pix_r_live;
  wire pix_clk_live, pixel_clk_5x_live, hsync_live, vsync_live, de_live;
  
  wire HSYNC, VSYNC, de;
  wire [7:0] red_vout, green_vout, blue_vout;
  wire [7:0] red_hout, green_hout, blue_hout;
  wire pix_clk_out, pix_clk_5x_out;
  wire i_buf_pix_clk;
          
  hdmi_inout LIVE1(
    .CLK(CLK),                // Board Clock: 100 MHz Nexys Video
    .RST_BTN(RST_BTN),            // Reset Button
    .hdmi_rx_cec(hdmi_rx_cec),        
    .hdmi_rx_sda(hdmi_rx_sda),
    .hdmi_rx_scl(hdmi_rx_scl),
    .hdmi_rx_hpa(hdmi_rx_hpa),
    .hdmi_rx_txen(hdmi_rx_txen),
    
    .hdmi_rx_clk_p(hdmi_rx_clk_p),      // HDMI clock differential positive
    .hdmi_rx_clk_n(hdmi_rx_clk_n),      // HDMI clock differential negative
    .hdmi_rx_p(hdmi_rx_p),    // Three HDMI channels differential positive
    .hdmi_rx_n(hdmi_rx_n),    // Three HDMI channels differential negative
    
    //.i_buf_pix_clk(i_buf_pix_clk),
    .pix_blue(pix_b_live), 
    .pix_green(pix_g_live), 
    .pix_red(pix_r_live),
    .pixel_clk(pix_clk_live), 
    .pixel_clk_5x(pixel_clk_5x_live), 
    .hsync(hsync_live), 
    .vsync(vsync_live), 
    .de(de_live)
    );
  
      clk_wiz_0 inst1
      (
      .clk_out1(pix_clk640),
      .clk_out2(pix_clk640_5x),          
      .reset(~RST_BTN), 
      .locked(clk_lock),
      .clk_in1(CLK)
      );
      
      // try multiple in one ip
      
  clk_wiz_2 inst2
      (
      .clk_out1(pix_clk1280),
      .clk_out2(pix_clk1280_5x),            
      .reset(~RST_BTN), 
      .locked(clk_lock1),
      .clk_in1(CLK)
      );
      
//  clk_wiz_3 inst3
//      (
//      .clk_out1(pix_clk800),
//      .clk_out2(pix_clk800_5x),            
//      .reset(~RST_BTN), 
//      .locked(clk_lock2),
//      .clk_in1(CLK)
//      );
      
//clk_wiz_4 inst4
//  (
//  .clk_out1(pix_clk1920),
//  .clk_out2(pix_clk1920_5x),            
//  .reset(~RST_BTN), 
//  .locked(clk_lock3),
//  .clk_in1(CLK)
//  );
      
      
      // Master signals, change based on GUI resolution selection
      wire pixel_clock;
      wire pixel_clock_5x;
      wire [11:0] h_res; // = 12'd1280;
      wire [11:0] v_res; // = 12'd720;
      wire [7:0] h_fp; // = 8'd110;
      wire [7:0] h_sync; // = 8'd40;
      wire [7:0] h_bp; // = 8'd220;
      wire [5:0] v_fp; // = 6'd5;
      wire [5:0] v_sync; // = 6'd5;
      wire [5:0] v_bp; // = 6'd20;
      wire h_pol; // = 1'd1;
      wire v_pol; // = 1'd1;
       
                                      
      assign pixel_clock = (Res_Select == 2'b00) ? pix_clk640 :
                                      (Res_Select == 2'b01) ? pix_clk800 :
                                      (Res_Select == 2'b10) ? pix_clk1280 : pix_clk1920;
                                      
      assign pixel_clock_5x = (Res_Select == 2'b00) ? pix_clk640_5x :
                                      (Res_Select == 2'b01) ? pix_clk800_5x :
                                      (Res_Select == 2'b10) ? pix_clk1280_5x : pix_clk1920_5x;
                                    
      // Resolution signal MUXs
      assign h_res = (Res_Select == 2'b00) ? 12'd640 :
                                      (Res_Select == 2'b01) ? 12'd800 :
                                      (Res_Select == 2'b10) ? 12'd1280 : 12'd1920;
                                      
      assign v_res = (Res_Select == 2'b00) ? 12'd480 :
                                      (Res_Select == 2'b01) ? 12'd600 :
                                      (Res_Select == 2'b10) ? 12'd720 : 12'd1080;   
                                      
      assign h_fp = (Res_Select == 2'b00) ? 8'd16 :
                                      (Res_Select == 2'b01) ? 8'd40 :
                                      (Res_Select == 2'b10) ? 8'd110 : 8'd88;
                                      
      assign h_sync = (Res_Select == 2'b00) ? 8'd96 :
                                      (Res_Select == 2'b01) ? 8'd128 :
                                      (Res_Select == 2'b10) ? 8'd40 : 8'd44;
                                      
      assign h_bp = (Res_Select == 2'b00) ? 8'd48 :
                                      (Res_Select == 2'b01) ? 8'd88 :
                                      (Res_Select == 2'b10) ? 8'd220 : 8'd148;      
                                     
      assign v_fp = (Res_Select == 2'b00) ? 6'd10 :
                                      (Res_Select == 2'b01) ? 6'd1 :
                                      (Res_Select == 2'b10) ? 6'd5 : 6'd4;
                                      
      assign v_sync = (Res_Select == 2'b00) ? 6'd2 :
                                      (Res_Select == 2'b01) ? 6'd4 :
                                      (Res_Select == 2'b10) ? 6'd5 : 6'd5;
                                      
      assign v_bp = (Res_Select == 2'b00) ? 6'd33 :
                                      (Res_Select == 2'b01) ? 6'd23 :
                                      (Res_Select == 2'b10) ? 6'd20 : 6'd36;   
      
      assign h_pol = (Res_Select == 2'b00) ? 1'd0 :
                                      (Res_Select == 2'b01) ? 1'd1 :
                                      (Res_Select == 2'b10) ? 1'd1 : 1'd1;
                                      
      assign v_pol = (Res_Select == 2'b00) ? 1'd1 :
                                      (Res_Select == 2'b01) ? 1'd1 :
                                      (Res_Select == 2'b10) ? 1'd1 : 1'd1;                                                                                                                                                              
                             
  // Call the test pattern generator
  // Creates selected test pattern based on Img_Select
  // Maps according to selected resolution
  // Outputs both selections for monitor (HDMI and VGA), but one will be black (off) based on the Out_Select switch  
       
//  wire [7:0] pix_b_live, pix_g_live, pix_r_live;
//  wire pix_clk_live, pixel_clk_5x_live, hsync_live, vsync_live, de_live;
  
//  wire HSYNC, VSYNC, de;
//  wire [7:0] red_hout, green_hout, blue_hout;
//  wire pix_clk_out, pix_clk_5x_out;
          
//  hdmi_inout LIVE1(
//    .CLK(CLK),                // Board Clock: 100 MHz Nexys Video
//    .RST_BTN(RST_BTN),            // Reset Button
//    .hdmi_rx_cec(hdmi_rx_cec),        
//    .hdmi_rx_sda(hdmi_rx_sda),
//    .hdmi_rx_scl(hdmi_rx_scl),
//    .hdmi_rx_hpa(hdmi_rx_hpa),
//    .hdmi_rx_txen(hdmi_rx_txen),
    
//    .hdmi_rx_clk_p(hdmi_rx_clk_p),      // HDMI clock differential positive
//    .hdmi_rx_clk_n(hdmi_rx_clk_n),      // HDMI clock differential negative
//    .hdmi_rx_p(hdmi_rx_p),    // Three HDMI channels differential positive
//    .hdmi_rx_n(hdmi_rx_n),    // Three HDMI channels differential negative
    
//    .pix_blue(pix_b_live), 
//    .pix_green(pix_g_live), 
//    .pix_red(pix_r_live),
//    .pixel_clk(pix_clk_live), 
//    .pixel_clk_5x(pixel_clk_5x_live), 
//    .hsync(hsync_live), 
//    .vsync(vsync_live), 
//    .de(de_live)
//    );
                     
  test_pattern_generator TP1(
    .pix_clk(pixel_clock),   // Pixel clock for selected resolution  
    .Img_Select(Img_Select), // Test pattern selection signal
    .clk_lock(clk_lock),       // reset used just for timings, not from GUI
    .h_res(h_res),           // Horizontal resolution
    .v_res(v_res),           // Vertical resolution
    .Out_Select(Out_Select), // Output monitor selection
    .h_fp(h_fp),             // Blanking signals
    .h_sync(h_sync),
    .h_bp(h_bp),
    .v_fp(v_fp),
    .v_sync(v_sync),
    .v_bp(v_bp),
    .h_pol(h_pol),           
    .v_pol(v_pol),
    .redh(redh),             // HDMI pixel
    .greenh(greenh),
    .blueh(blueh),
    .redv(redv),             // VGA pixel
    .greenv(greenv),
    .bluev(bluev),
    .de(de_tp),                 // Data enable, high in the active monitor area
    .HSYNC(hsync_tp),           // HSYNC for both HDMI and VGA
    .VSYNC(vsync_tp)            // VSYNC for both HDMI and VGA
    );
    
    wire [7:0] pix_blive_out, pix_glive_out, pix_rlive_out;
    
    assign pix_blive_out = (Out_Select) ? 8'b0 : pix_b_live;
    assign pix_glive_out = (Out_Select) ? 8'b0 : pix_g_live;  
    assign pix_rlive_out = (Out_Select) ? 8'b0 : pix_r_live; 
    
    Select_tp_live(
    .pix_b_live(pix_blive_out),
    .pix_g_live(pix_glive_out),
    .pix_r_live(pix_rlive_out),
    .redh(redh),
    .greenh(greenh),
    .blueh(blueh),
    .hsync_live(hsync_live),
    .vsync_live(vsync_live),
    .de_live(de_live),
    .pix_clk_live(pix_clk_live),
    .pix_clk_5x_live(pixel_clk_5x_live),
    .hsync_tp(hsync_tp),
    .vsync_tp(vsync_tp),
    .de_tp(de_tp),
    .pix_clk_tp(pixel_clock),
    .pix_clk_5x_tp(pixel_clock_5x),
    .Img_Select(Img_Select),
    .red_hout(red_hout),
    .green_hout(green_hout),
    .blue_hout(blue_hout),
    .pix_clk_out(pix_clk_out),
    .pix_clk_5x_out(pix_clk_5x_out),
    .HSYNC(HSYNC),
    .VSYNC(VSYNC),
    .de(de));
                                                
    // TMDS Encoding and Serialize
    dvi_generator dvi_out (
        .i_pix_clk(pix_clk_out),
        .i_pix_clk_5x(pix_clk_5x_out),
        .i_rst(!clk_lock),
        .i_de(de),
        .i_data_ch0(blue_hout),
        .i_data_ch1(green_hout),
        .i_data_ch2(red_hout),
        .i_ctrl_ch0({VSYNC, HSYNC}),
        .i_ctrl_ch2(2'b00),
        .o_tmds_ch0_serial(tmds_ch0_serial),
        .o_tmds_ch1_serial(tmds_ch1_serial),
        .o_tmds_ch2_serial(tmds_ch2_serial),
        .o_tmds_chc_serial(tmds_chc_serial)  // encode pixel clock via same path
    );

    // HDMI Outputs from Differential Buffer
    OBUFDS #(.IOSTANDARD("TMDS_33"))
        tmds_buf_ch0 (.I(tmds_ch0_serial), .O(hdmi_tx_p[0]), .OB(hdmi_tx_n[0])); // Blue channel
    OBUFDS #(.IOSTANDARD("TMDS_33"))
        tmds_buf_ch1 (.I(tmds_ch1_serial), .O(hdmi_tx_p[1]), .OB(hdmi_tx_n[1])); // Green channel
    OBUFDS #(.IOSTANDARD("TMDS_33"))
        tmds_buf_ch2 (.I(tmds_ch2_serial), .O(hdmi_tx_p[2]), .OB(hdmi_tx_n[2])); // red channel
    OBUFDS #(.IOSTANDARD("TMDS_33"))
        tmds_buf_chclk (.I(tmds_chc_serial), .O(hdmi_tx_clk_p), .OB(hdmi_tx_clk_n)); // clock channel

    assign VGA_HS   = hsync_tp; //HSYNC for the test patterns
    assign VGA_VS   = vsync_tp; //VSYNC for the test patterns
    assign VGA_R    = de_tp ? redv[7:4] : 4'b0; //RED 
    assign VGA_G    = de_tp ? greenv[7:4] : 4'b0; //GREEN
    assign VGA_B    = de_tp ? bluev[7:4] : 4'b0; //BLUE
    
    assign hdmi_tx_cec   = 1'bz;
    assign hdmi_tx_rsda  = 1'bz;
    assign hdmi_tx_rscl  = 1'b1;
    
endmodule