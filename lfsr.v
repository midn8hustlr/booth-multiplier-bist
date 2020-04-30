module lfsr(
    input clk, seed_b, shift,
    output reg [7:0] q
    );	 
	 
	 //Characteristic Eqn: x^8 + x^4 + x^3 + x^2 + 1
	 always @(posedge clk, negedge seed_b) begin
		if(~seed_b)
			q <= 8'b1111_1111;  //initial seed != 0
		else if(shift) begin
			q[0] <= q[7];
			q[1] <= q[0];
			q[2] <= q[1]^q[7];
			q[3] <= q[2]^q[7];
			q[4] <= q[3]^q[7];
			q[5] <= q[4];
			q[6] <= q[5];
			q[7] <= q[6];
		end
	 end
	 
endmodule
