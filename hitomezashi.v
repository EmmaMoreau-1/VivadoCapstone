module simple_hitomezashi_pattern 
(
    input wire signed [15:0] i_x,      // X-coordinate of pixel
    input wire signed [15:0] i_y,      // Y-coordinate of pixel
    input wire CLK,                   // Clock
    output wire [7:0] o_red,          // Output red color
    output wire [7:0] o_green,        // Output green color
    output wire [7:0] o_blue          // Output blue color
);

    wire enable;        
   
    PulseGenerator #(
        .DELAY_COUNT(15000000)  // Set the delay count to 70 for testing
    ) pulse_gen (
        .clk(CLK),        // Input clock to PulseGenerator
        .enable(enable)   // Output enable from PulseGenerator
    );
    
    // Vertical and horizontal start values for the Hitomezashi pattern
    reg [39:0] v_start;  // Vertical start pattern for 40 vertical lines
    reg [21:0] h_start;  // Horizontal start pattern for 22 horizontal lines

    initial begin
        v_start = 40'b01100_00101_00110_10011_10101_10101_01111_01101;
        h_start = 22'b10111_01001_00001_10100_00;
    end

    // Shift the vertical pattern on enable
    always @(posedge CLK) begin
        if (enable) begin
            v_start <= {v_start[38:0], v_start[39]};  // Shift right by 1 bit
        end
    end

    // Calculate the coordinates in the grid for the Hitomezashi pattern
    wire v_line = (i_x[4:0] == 5'b00000); // Check if pixel is on a vertical line
    wire h_line = (i_y[4:0] == 5'b00000); // Check if pixel is on a horizontal line

    wire v_on = i_y[5] ^ v_start[i_x[10:5]];  // Updated to use the dynamically shifted v_start
    wire h_on = i_x[5] ^ h_start[i_y[9:5]];  // Horizontal line pattern logic

    wire stitch = (v_line && v_on) || (h_line && h_on);  // Combine to form the pattern
    
    reg [7:0] outred, outgreen, outblue;
    
    always @* begin
        if (stitch) begin
            outred = 8'b11111111;  // red
            outgreen = 8'b11111111;  // green
            outblue = 8'b00000000;  // Blue remains zero for yellow lines
        end else begin
            // Background is blue
            outred = 8'b00000000;
            outgreen = 8'b00000000;
            outblue = 8'b11111111;  // Blue background
        end
    end

    // Assign output colors
    assign o_red = outred;
    assign o_green = outgreen;
    assign o_blue = outblue;

endmodule
