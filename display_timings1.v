`timescale 1ns / 1ps
`default_nettype none

// UPDATED from original Project F to dynamicaly update resolution

module display_timings1 (
    input  wire [11:0] H_RES,                    // horizontal resolution (pixels)
    input  wire [11:0] V_RES,                  // vertical resolution (lines)
    input  wire [7:0] H_FP,                       // horizontal front porch
    input  wire [7:0] H_SYNC,                      // horizontal sync
    input  wire [7:0] H_BP,                        // horizontal back porch
    input  wire [5:0] V_FP,                        // vertical front porch
    input  wire [5:0] V_SYNC,                       // vertical sync
    input  wire [5:0] V_BP,                       // vertical back porch
    input  wire  H_POL,                       // horizontal sync polarity (0:neg, 1:pos)
    input  wire  V_POL,                       // vertical sync polarity (0:neg, 1:pos)
    input  wire i_pix_clk,          // pixel clock
    input  wire i_rst,              // reset: restarts frame (active high)
    output wire o_hs,               // horizontal sync
    output wire o_vs,               // vertical sync
    output wire o_de,               // display enable: high during active video
    output wire o_frame,            // high for one tick at the start of each frame
    output reg signed [15:0] o_sx,  // horizontal beam position (including blanking)
    output reg signed [15:0] o_sy   // vertical beam position (including blanking)
    );

    // Horizontal: sync, active, and pixels
    wire signed [23:0] H_STA  = 0 - H_FP - H_SYNC - H_BP;    // horizontal start
    wire signed [23:0] HS_STA = H_STA + H_FP;                // sync start
    wire signed [23:0] HS_END = HS_STA + H_SYNC;             // sync end
    wire signed [23:0] HA_STA = 0;                           // active start
    wire signed [23:0] HA_END = H_RES - 1;                   // active end

    // Vertical: sync, active, and pixels
    wire signed [23:0] V_STA  = 0 - V_FP - V_SYNC - V_BP;    // vertical start
    wire signed [23:0] VS_STA = V_STA + V_FP;                // sync start
    wire signed [23:0] VS_END = VS_STA + V_SYNC;             // sync end
    wire signed [23:0] VA_STA = 0;                           // active start
    wire signed [23:0] VA_END = V_RES - 1;                   // active end

    // generate sync signals with correct polarity
    assign o_hs = H_POL ? (o_sx > HS_STA && o_sx <= HS_END)
        : ~(o_sx > HS_STA && o_sx <= HS_END);
    assign o_vs = V_POL ? (o_sy > VS_STA && o_sy <= VS_END)
        : ~(o_sy > VS_STA && o_sy <= VS_END);

    // display enable: high during active period
    assign o_de = (o_sx >= 0 && o_sy >= 0);

    // o_frame: high for one tick at the start of each frame
    assign o_frame = (o_sy == V_STA && o_sx == H_STA);

    always @ (posedge i_pix_clk)
    begin
        if (i_rst)  // reset to start of frame
        begin
            o_sx <= H_STA;
            o_sy <= V_STA;
        end
        else
        begin
            if (o_sx == HA_END)  // end of line
            begin
                o_sx <= H_STA;
                if (o_sy == VA_END)  // end of frame
                    o_sy <= V_STA;
                else
                    o_sy <= o_sy + 16'sh1;
            end
            else
                o_sx <= o_sx + 16'sh1;
        end
    end
endmodule
