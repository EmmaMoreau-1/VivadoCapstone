module PulseGenerator(
    input wire clk,      // Input clock signal
    output reg enable   // Output pulse signal (enable)
    );

    // Parameters for delay (e.g., 10 clock cycles)
    parameter DELAY_COUNT = 150000000; 

    // Counter to create the delay
    reg [23:0] counter;
    reg pulse;

    // Initialize registers
    initial begin
        counter = 0;
        pulse = 1'b0;
        enable = 0;
    end
    
    // Main always block (synchronous)
    always @(posedge clk) begin
        if (counter == DELAY_COUNT - 1) begin
            // When delay is completed, toggle the enable signal
            enable <= 1;
            counter <= 0;  // Reset counter
            pulse <= ~pulse;  // Toggle the pulse
        end else begin
            // If the delay is not yet done, increment the counter
            counter <= counter + 1;
            enable <= 0;   // Keep enable low during delay
        end
    end

endmodule
