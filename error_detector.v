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

module error_detector(
    input  wire clk_1x_in,
    input  wire reset_in,
    input  wire [9:0] data_in,
    input  wire data_pre,
    output reg blank,
    output reg CTL_period,
    output reg TERC4_period,
    output reg [9:0] DATA_out,
    output reg error
    );

    localparam ST_CTL  = 2'b00;
    localparam ST_TERC = 2'b01;
    localparam ST_VID  = 2'b10;

    // State registers
    reg [1:0] state, next_state;

    // Registers for counter logic
    reg [15:0] vid_cnt, nxt_vid_cnt;
    reg [4:0] nxt_terc4_cnt;
    reg error_i;
    reg [9:0] last_data;
    reg [1:0] vid_guard_cnt, nxt_vid_guard_cnt;
    reg [4:0] terc4_cnt;

    // Synchronous State Update
    always @(posedge clk_1x_in) begin
        if (reset_in) begin
            state <= ST_VID;
            error <= 1'b0;
        end else begin
            state <= next_state;
            error <= error_i;
            last_data <= data_in;
        end
    end

    wire is_terc4;
    terc4_detect terc4_ctrl (
        .clk_1x_in(clk_1x_in),
        .deser_data(data_in),
        .is_terc4(is_terc4)
    );

    wire is_CTL;
    tmds_detect tmds_ctrl (
        .clk_1x_in(clk_1x_in),
        .deser_data(data_in),
        .is_tmds(is_CTL)
    );
    
    // Next State Logic
    always @(state or data_in or is_terc4 or is_CTL) begin
        // Default values
        next_state = state;
        nxt_vid_cnt = 16'b0;
        nxt_terc4_cnt = 5'b0;
        nxt_vid_guard_cnt = 2'b0;
        error_i = 1'b0;
        case (state)
            ST_CTL: begin
                if (is_terc4) begin
                    next_state = ST_TERC;
                    if (data_in == 10'b1011001100 || data_in == 10'b0100110011) begin
                        nxt_vid_guard_cnt = vid_guard_cnt + 1;
                    end
                end else if (!is_CTL) begin
                    next_state = ST_VID;
                end

                // Error check: incorrect number of TERC4 packets
                if (terc4_cnt != 5'b00000 && terc4_cnt != 5'b00100) begin
                    error_i = 1'b1;
                end
            end
            
            ST_TERC: begin
                nxt_terc4_cnt = terc4_cnt + 1;

                if (is_CTL) begin
                    next_state = ST_CTL;
                end

                // Check for video guard characters
                if (data_in == 10'b1011001100 || data_in == 10'b0100110011) begin
                    nxt_vid_guard_cnt = vid_guard_cnt + 1;
                end

                if (!is_CTL && (!is_terc4 || !data_pre) && terc4_cnt == 5'b00001 && vid_guard_cnt == 2'b10) begin
                    next_state = ST_VID;
                end
            end

            ST_VID: begin
                if (is_CTL) begin
                    next_state = ST_CTL;
                end
                nxt_vid_cnt = vid_cnt + 1;

                // Error: No sync packet detected
                if (vid_cnt == 16'h1FFF) begin
                    error_i = 1'b1;
                    nxt_vid_cnt = 16'b0;
                end
            end

            default: begin
                next_state = ST_VID;
            end
        endcase
    end

    // Counter Update
    always @(posedge clk_1x_in) begin
        if (reset_in) begin
            vid_cnt <= 16'b0;
            terc4_cnt <= 5'b0;
            vid_guard_cnt <= 2'b0;
        end else begin
            vid_cnt <= nxt_vid_cnt;
            terc4_cnt <= nxt_terc4_cnt;
            vid_guard_cnt <= nxt_vid_guard_cnt;
        end
    end

    // Output Logic
    always @(*) begin
        blank = (state == ST_VID) ? 1'b0 : 1'b1;
        CTL_period = (state == ST_CTL) ? 1'b1 : 1'b0;
        TERC4_period = (state == ST_TERC) ? 1'b1 : 1'b0;
        DATA_out = last_data;
    end
    
endmodule
