////////////////////////////////////////////////////////////////

/*
    For the UART Reciever, baud rate needs to be set to 115200, 8 bits data, no parity. 
    Implements with the MATLAB GUI.
*/

module uart_rx 
  #(parameter CLK_BAUD = 870) // Constant defined for baud rate of 115200 at 10 MHz clock
  (
   input wire CLK, //100MHz board clock
   input wire RX, //Recieved from MATLAB
   output wire [7:0] out_bits //output, corresponds to binary ASCII code that was sent
   );
    
  // States:
  // Five state machine
  // 1. Waiting for the start bit, do nothing
  // 2. Recived start bit, begin processing data
  // 3. Recieving data bits, shift
  // 4. Recieved stop bit, stop processing and output data byte
  // 5. Clear the machine, return to idle
  
  parameter IDLE      = 3'b000;
  parameter START_BIT = 3'b001;
  parameter DATA_BITS = 3'b010;
  parameter STOP_BIT  = 3'b011;
  parameter CLEAR     = 3'b100;
  
  // New clk which is 10MHz
 // wire clk_10;
   
  // Define when the data is ready to be recieved and processed
  reg rx_dataready = 1'b1;
  reg rx_data = 1'b1;
   
  // Counter to divide clock
  reg [12:0] count = 0;
  // Keep track of bit index to reach stop bit
  reg [2:0] bit_num = 0; //8 bits total
  // Hold the data byte
  reg [7:0] data_byte = 0;
  // Has all data been recieved?
  reg data_valid = 0;
  // State for FSM
  reg [2:0] state = 0;
   
  // Recived RX, set variables 
  always @(posedge CLK)
    begin
      rx_dataready <= RX; // Set the data_ready to the input signal 
      rx_data   <= rx_dataready;
    end
   
  // FSM
  always @(posedge CLK)
    begin
      case (state)
        IDLE : // Do nothing
          begin
            data_valid <= 1'b0; // No data recieved
            count <= 0; // Reset counter
            bit_num   <= 0; // No bits
            if (rx_data == 1'b0) // Start bit is 1'b0
              state <= START_BIT; // move to the next state
            else
              state <= IDLE; // Stay IDLE
          end
         
        // Process the start bit
        START_BIT :
          begin
            if (count == (CLK_BAUD-1)/2) // Reached the first bit on time with the baud rate, sample mid way to avoid errors
              begin
                if (rx_data == 1'b0) // start
                  begin
                    count <= 0;  // reset for the next bit
                    state <= DATA_BITS; // Move to next state
                  end
                else
                  state <= IDLE; // The start bit isn't reached, go back to waiting
              end
            else
              begin
                count <= count + 1; // count up
                state <= START_BIT; // Keep looking for start bit
              end
          end 
        
        // Process the data
        DATA_BITS :
          begin
            if (count < CLK_BAUD-1) // syncronize with baud rate
              begin
                count <= count + 1; // count up
                state <= DATA_BITS; // stay counting up to syncronization
              end
            else
              begin // Syncronized, get the databit
                count <= 0; // reset the counter
                data_byte[bit_num] <= rx_data; // add this bit of data to the output bytes
                if (bit_num < 7) // wanna get up to 8 bits to finish data processing
                  begin
                    bit_num <= bit_num + 1;
                    state <= DATA_BITS; // still more data to process
                  end
                else
                  begin // full data recieved
                    bit_num <= 0; // reset bit_num
                    state <= STOP_BIT; // move to next state
                  end
              end
          end 
     
        //Process stop bit
        STOP_BIT :
          begin
            if (count < CLK_BAUD-1) // syncronize
              begin
                count <= count + 1; // count up
                state <= STOP_BIT; // wait to syncronize
              end
            else
              begin // syncronized
                data_valid <= 1'b1; // all data was recieved
                count <= 0; // reset counter
                state <= CLEAR; // move to reset everything
              end
          end 
         
        // Reset everything to wait for new information from GUI
        CLEAR :
          begin
            state <= IDLE;
            data_valid   <= 1'b0; //no more data to output
          end
         
        default :
          state <= IDLE; // just stay waiting for data  
      endcase
  end
   
  assign out_bits = data_byte;

//    // Clock wizard to divide the 100MHz clock to 10MHz
//    clk_wiz_0 clk1
//  (
//  // Clock out ports  
//  .clk_out1(clk_10),
// // Clock in ports
//  .clk_in1(clk_100)
//  );
   
endmodule 
