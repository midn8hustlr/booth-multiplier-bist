module tester(
	 input clk,
	 input test, busy,
     input [7:0] prod,
     output start_test, pass,
	 output [7:0] pattern, count
    );
    
    wire [7:0] sign;
   
    //Input Pattern Genarator
    lfsr GENERATOR (  
		.clk(clk), 
		.seed_b(seed_b), 
		.shift(shift),  
		.q(pattern)
	 );
  
    //Output Response Compactor
    misr COMPACTOR (
		.clk(clk), 
		.reset_b(reset_b), 
		.shift(shift), 
		.d(prod), 
		.q(sign)
	 );
            
    controller CONTROL (
		.clk(clk), 
		.test(test), 
		.busy(busy), 
		.seed_b(seed_b), 
		.reset_b(reset_b), 
		.shift(shift), 
		.start_test(start_test), 
		.done(done), 
		.count(count)
	 );
	
	assign pass = (sign == 8'b0101_1111) && done;
	//Signature is compared with the valid one when the testing is complete.

endmodule
