`timescale 1ns / 1ps

module multiplier_tb;

	// Inputs
	reg clk;
	reg [3:0] a;
	reg [3:0] b;
	reg start;
	reg test;

	// Outputs
	wire [7:0] product;
	wire busy;
	wire pass;

	// Instantiate the Unit Under Test (UUT)
	multiplier uut (
		.clk(clk), 
		.a(a), 
		.b(b), 
		.start(start), 
		.test(test), 
		.product(product), 
		.busy(busy), 
		.pass(pass)
	);
	
	always #5 clk = ~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		a = 0;
		b = 0;
		start = 0;
		test = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

