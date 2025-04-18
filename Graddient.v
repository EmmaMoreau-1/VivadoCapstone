module car_race_test (
    input wire [11:0] H_RES ,  // Horizontal resolution
    input wire [11:0] V_RES,  // Vertical resolution
    input wire signed [15:0] i_x,      // X-coordinate of pixel
    input wire signed [15:0] i_y,      // Y-coordinate of pixel
    input wire CLK,                   // Clock
    output wire [7:0] o_red,          // Output red color
    output wire [7:0] o_green,        // Output green color
    output wire [7:0] o_blue          // Output blue color
);
    // Car dimensions (approximated from the image, scaled for simplicity)
    localparam CAR_WIDTH = 60;        // Car width in pixels
    localparam CAR_HEIGHT = 30;       // Car height in pixels
    reg [CAR_HEIGHT-1:0] car_shape [0:CAR_WIDTH-1];

    // Car positions (one per lane)
    reg [15:0] car1_x_pos = 0;        // Lane 1
    reg [15:0] car2_x_pos = 50;       // Lane 2
    reg [15:0] car3_x_pos = 100;      // Lane 3
    reg [15:0] car4_x_pos = 150;      // Lane 4
    reg [15:0] car5_x_pos = 200;      // Lane 5
    reg [15:0] car6_x_pos = 250;      // Lane 6

    // Y positions for each lane (centered)
    wire [11:0] lane_spacing = V_RES / 6;
    wire [11:0] CAR1_Y_POS = lane_spacing / 2;              // Lane 1 (center)
    wire [11:0] CAR2_Y_POS = lane_spacing * 3 / 2;          // Lane 2
    wire [11:0] CAR3_Y_POS = lane_spacing * 5 / 2;          // Lane 3
    wire [11:0] CAR4_Y_POS = lane_spacing * 7 / 2;          // Lane 4
    wire [11:0] CAR5_Y_POS = lane_spacing * 9 / 2;          // Lane 5
    wire [11:0] CAR6_Y_POS = lane_spacing * 11 / 2;         // Lane 6

    // PulseGenerator instances for each car with different speeds
    wire enable1, enable2, enable3, enable4, enable5, enable6;
    PulseGenerator #(
        .DELAY_COUNT(1000000)  // Faster
    ) pulse_gen1 (
        .clk(CLK),
        .enable(enable1)
    );
    PulseGenerator #(
        .DELAY_COUNT(1200000)
    ) pulse_gen2 (
        .clk(CLK),
        .enable(enable2)
    );
    PulseGenerator #(
        .DELAY_COUNT(800000)   // Fastest
    ) pulse_gen3 (
        .clk(CLK),
        .enable(enable3)
    );
    PulseGenerator #(
        .DELAY_COUNT(1500000)  // Slowest
    ) pulse_gen4 (
        .clk(CLK),
        .enable(enable4)
    );
    PulseGenerator #(
        .DELAY_COUNT(900000)
    ) pulse_gen5 (
        .clk(CLK),
        .enable(enable5)
    );
    PulseGenerator #(
        .DELAY_COUNT(1300000)
    ) pulse_gen6 (
        .clk(CLK),
        .enable(enable6)
    );

    // Define the car shape (simplified representation of the car in the image)
    initial begin
        car_shape[0] = 30'b000000000000000000000000000000;
        car_shape[1] = 30'b000000000000000000000000000000;
        car_shape[2] = 30'b000000000000000000000000000000;
        car_shape[3] = 30'b000000000000000000000000000000;
        car_shape[4] = 30'b000000000000000000000000000000;
        car_shape[5] = 30'b000000000000000000000000000000;
        car_shape[6] = 30'b000000000000000000000000000000;
        car_shape[7] = 30'b000000000000000000000000000000;
        car_shape[8] = 30'b000000000000000000000000000000;
        car_shape[9] =  30'b000000000111111111000000000000;
        car_shape[10] = 30'b000000000111111111000000000000;
        car_shape[11] = 30'b000000000111111111000000000000;
        car_shape[12] = 30'b000000000111111111000000000000;
        car_shape[13] = 30'b000000000111111111000000000000;
        car_shape[14] = 30'b001111111111111111000000000000;
        car_shape[15] = 30'b001111111111111111000000000000;
        car_shape[16] = 30'b001111111111111111000000000000;
        car_shape[17] = 30'b001111111111111111000000000000;
        car_shape[18] = 30'b001111111111111111000000000000;
        car_shape[19] = 30'b000000000111111111000000000000;
        car_shape[20] = 30'b000000000111111111000000000000;
        car_shape[21] = 30'b000000000111111111000000000000;
        car_shape[22] = 30'b000000000111111111000000000000;
        car_shape[23] = 30'b000000000111111111000000000000;
        car_shape[24] = 30'b000000000111111111111000000000;
        car_shape[25] = 30'b000000000111111111111000000000;
        car_shape[26] = 30'b000000000111111111111000000000;
        car_shape[27] = 30'b000000000111111111111000000000;
        car_shape[28] = 30'b000000000111111111111000000000;
        car_shape[29] = 30'b000000000111111111111000000000;
        car_shape[30] = 30'b000000000111111111111000000000;
        car_shape[31] = 30'b000000000111111111111000000000;
        car_shape[32] = 30'b000000000111111111111000000000;
        car_shape[33] = 30'b000000000111111111111000000000;
        car_shape[34] = 30'b000000000111111111111000000000;
        car_shape[35] = 30'b000000000111111111111000000000;
        car_shape[36] = 30'b000000000111111111111000000000;
        car_shape[37] = 30'b000000000111111111111000000000;
        car_shape[38] = 30'b000000000111111111111000000000;
        car_shape[39] = 30'b000000000111111111000000000000;
        car_shape[40] = 30'b000000000111111111000000000000;
        car_shape[41] = 30'b000000000111111111000000000000;
        car_shape[42] = 30'b000000000111111111000000000000;
        car_shape[43] = 30'b001111111111111111000000000000;
        car_shape[44] = 30'b001111111111111111000000000000;
        car_shape[45] = 30'b001111111111111111000000000000;
        car_shape[46] = 30'b001111111111111111000000000000;
        car_shape[47] = 30'b001111111111111111000000000000;
        car_shape[48] = 30'b001111111111111111000000000000;
        car_shape[49] = 30'b000000000111111111000000000000;
        car_shape[50] = 30'b000000000111111111000000000000;
        car_shape[51] = 30'b000000000111111111000000000000;
        car_shape[52] = 30'b000000000111111111000000000000;
        car_shape[53] = 30'b000000000111111111000000000000;
        car_shape[54] = 30'b000000000000000000000000000000;
        car_shape[55] = 30'b000000000000000000000000000000;
        car_shape[56] = 30'b000000000000000000000000000000;
        car_shape[57] = 30'b000000000000000000000000000000;
        car_shape[58] = 30'b000000000000000000000000000000;
        car_shape[59] = 30'b000000000000000000000000000000;
    end

    // Animate each car using its own enable signal
    always @(posedge CLK) begin
        // Car 1
        if (enable1) begin
            if (car1_x_pos < H_RES) begin
                car1_x_pos <= car1_x_pos + 1;
            end else begin
                car1_x_pos <= 0;
            end
        end
        // Car 2
        if (enable2) begin
            if (car2_x_pos < H_RES) begin
                car2_x_pos <= car2_x_pos + 1;
            end else begin
                car2_x_pos <= 0;
            end
        end
        // Car 3
        if (enable3) begin
            if (car3_x_pos < H_RES) begin
                car3_x_pos <= car3_x_pos + 1;
            end else begin
                car3_x_pos <= 0;
            end
        end
        // Car 4
        if (enable4) begin
            if (car4_x_pos < H_RES) begin
                car4_x_pos <= car4_x_pos + 1;
            end else begin
                car4_x_pos <= 0;
            end
        end
        // Car 5
        if (enable5) begin
            if (car5_x_pos < H_RES) begin
                car5_x_pos <= car5_x_pos + 1;
            end else begin
                car5_x_pos <= 0;
            end
        end
        // Car 6
        if (enable6) begin
            if (car6_x_pos < H_RES) begin
                car6_x_pos <= car6_x_pos + 1;
            end else begin
                car6_x_pos <= 0;
            end
        end
    end

    // Lane logic (5 dashed lanes like in the image)
    wire is_lane;
    wire lane1 = (i_y >= lane_spacing - 1 && i_y <= lane_spacing + 1);
    wire lane2 = (i_y >= 2 * lane_spacing - 1 && i_y <= 2 * lane_spacing + 1);
    wire lane3 = (i_y >= 3 * lane_spacing - 1 && i_y <= 3 * lane_spacing + 1);
    wire lane4 = (i_y >= 4 * lane_spacing - 1 && i_y <= 4 * lane_spacing + 1);
    wire lane5 = (i_y >= 5 * lane_spacing - 1 && i_y <= 5 * lane_spacing + 1);
    wire lane6 = (i_y >= 6 * lane_spacing - 1 && i_y <= 6 * lane_spacing + 1);
    wire lane_on = lane1 || lane2 || lane3 || lane4 || lane5 || lane6;
    wire dash_on = (i_x % 20 < 10); // Dashed pattern: 10 pixels on, 10 pixels off
    assign is_lane = lane_on && dash_on;

    // Car pixel logic for each car
    wire is_car1_pixel, is_car2_pixel, is_car3_pixel, is_car4_pixel, is_car5_pixel, is_car6_pixel;
    wire [15:0] car1_pixel_x = i_x - car1_x_pos;
    wire [15:0] car1_pixel_y = i_y - CAR1_Y_POS;
    assign is_car1_pixel = (car1_pixel_x >= 0 && car1_pixel_x < CAR_WIDTH && car1_pixel_y >= 0 && car1_pixel_y < CAR_HEIGHT) ?
                          car_shape[car1_pixel_x][car1_pixel_y] : 1'b0;

    wire [15:0] car2_pixel_x = i_x - car2_x_pos;
    wire [15:0] car2_pixel_y = i_y - CAR2_Y_POS;
    assign is_car2_pixel = (car2_pixel_x >= 0 && car2_pixel_x < CAR_WIDTH && car2_pixel_y >= 0 && car2_pixel_y < CAR_HEIGHT) ?
                          car_shape[car2_pixel_x][car2_pixel_y] : 1'b0;

    wire [15:0] car3_pixel_x = i_x - car3_x_pos;
    wire [15:0] car3_pixel_y = i_y - CAR3_Y_POS;
    assign is_car3_pixel = (car3_pixel_x >= 0 && car3_pixel_x < CAR_WIDTH && car3_pixel_y >= 0 && car3_pixel_y < CAR_HEIGHT) ?
                          car_shape[car3_pixel_x][car3_pixel_y] : 1'b0;

    wire [15:0] car4_pixel_x = i_x - car4_x_pos;
    wire [15:0] car4_pixel_y = i_y - CAR4_Y_POS;
    assign is_car4_pixel = (car4_pixel_x >= 0 && car4_pixel_x < CAR_WIDTH && car4_pixel_y >= 0 && car4_pixel_y < CAR_HEIGHT) ?
                          car_shape[car4_pixel_x][car4_pixel_y] : 1'b0;

    wire [15:0] car5_pixel_x = i_x - car5_x_pos;
    wire [15:0] car5_pixel_y = i_y - CAR5_Y_POS;
    assign is_car5_pixel = (car5_pixel_x >= 0 && car5_pixel_x < CAR_WIDTH && car5_pixel_y >= 0 && car5_pixel_y < CAR_HEIGHT) ?
                          car_shape[car5_pixel_x][car5_pixel_y] : 1'b0;

    wire [15:0] car6_pixel_x = i_x - car6_x_pos;
    wire [15:0] car6_pixel_y = i_y - CAR6_Y_POS;
    assign is_car6_pixel = (car6_pixel_x >= 0 && car6_pixel_x < CAR_WIDTH && car6_pixel_y >= 0 && car6_pixel_y < CAR_HEIGHT) ?
                          car_shape[car6_pixel_x][car6_pixel_y] : 1'b0;

    // Output colors
    reg [7:0] outred, outgreen, outblue;
    always @* begin
        if (is_lane) begin
            outred = 8'b00000000;   // Black lanes
            outgreen = 8'b00000000;
            outblue = 8'b00000000;
        end else if (is_car1_pixel) begin
            outred = 8'b11111111;   // Red
            outgreen = 8'b00000000;
            outblue = 8'b00000000;
        end else if (is_car2_pixel) begin
            outred = 8'b00000000;   // Green
            outgreen = 8'b11111111;
            outblue = 8'b00000000;
        end else if (is_car3_pixel) begin
            outred = 8'b00000000;   // Blue
            outgreen = 8'b00000000;
            outblue = 8'b11111111;
        end else if (is_car4_pixel) begin
            outred = 8'b11111111;   // Yellow
            outgreen = 8'b11111111;
            outblue = 8'b00000000;
        end else if (is_car5_pixel) begin
            outred = 8'b11111111;   // Magenta
            outgreen = 8'b00000000;
            outblue = 8'b11111111;
        end else if (is_car6_pixel) begin
            outred = 8'b00000000;   // Cyan
            outgreen = 8'b11111111;
            outblue = 8'b11111111;
        end else begin
            outred = 8'b11111111;   // White background
            outgreen = 8'b11111111;
            outblue = 8'b11111111;
        end
    end

    // Assign output colors
    assign o_red = outred;
    assign o_green = outgreen;
    assign o_blue = outblue;

endmodule