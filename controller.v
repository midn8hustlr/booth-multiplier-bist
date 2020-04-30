module controller(
    input clk,
    input test, busy,
    output reg seed_b, reset_b, shift,
    output reg start_test, done,
	output reg [7:0] count
    );
     
    parameter IDLE  = 2'b00, // not testing
			  TEST  = 2'b01, // multiplier ready 
			  HALT  = 2'b10, // multiplier not ready 
			  DONE  = 2'b11; // testing finished
				  
    reg [1:0] state, next_state;
    
    always @(posedge clk, negedge test) begin
        if (~test) begin  // disable testing on test signal low
            state <= IDLE;
            count <= 255; // 2^8-1 = 255 combinations of pattern to be checked
        end
        else begin
            state <= next_state;
            if(state == TEST) count <= count - 1'b1; // decrease count on every sucessful compaction
        end
    end
    
    // next-state combinational logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE : if(test) next_state = TEST; 
            TEST : begin
				    if(count==0) next_state = DONE; // finish testing when all 255 combinatons of pattern are checked
					else next_state = HALT; // halt and wait for multiplier to get ready
				   end
			HALT : if(busy==0) next_state = TEST; // resume testing when multiplier is ready
        endcase
    end
      
	// output combinational logic	
    always @(*) begin
        reset_b    = 1'b1;  // default value for all control signals
        seed_b     = 1'b1;
        done       = 1'b0;
		start_test = 1'b0;
		shift      = 1'b0;
    
        case (state)  
            IDLE  : begin
                        reset_b = 1'b0;
                        seed_b  = 1'b0;
                    end
            TEST  :	start_test = 1'b1;  // start testing as multilpier is ready
			HALT  : if(busy==0) shift = 1'b1; // shift LFSR & MISR when multiplier operation is finished
            DONE  : done = 1'b1; // indicates testing is finished
        endcase
    end
    
endmodule
