module multiplier(
    input clk,
    input [3:0] a, b,
	input start, test,
    output [7:0] product,
    output busy, pass
    );
	 
	 wire [3:0] mc_mux, mp_mux;
	 wire [7:0] pattern, count, prod;
	 
	 // Booth's Multiplier Module
	 mult BOOTH (
		.clk(clk), 
		.start(start_mux), 
		.mc(mc_mux), 
		.mp(mp_mux), 
		.prod(prod), 
		.busy(busy)
	 );
	 
	 // Built-in Self-Test Module
	 tester BIST (
		.clk(clk_g), 
		.test(test), 
		.busy(busy), 
		.prod(prod), 
		.start_test(start_test), 
		.pass(pass), 
		.pattern(pattern), 
		.count(count)
	 );
	 
	 // If test=1, connect the tester module to the mult module	 
	 assign mc_mux    = (test) ? pattern[3:0] : a,
            mp_mux    = (test) ? pattern[7:4] : b,
            start_mux = (test) ? start_test   : start,
		    product   = (test) ? count        : prod;
			  
	 assign clk_g = clk && test;  //clock gating to reduce dynamic power dissipation when tester is not in use
       
endmodule
