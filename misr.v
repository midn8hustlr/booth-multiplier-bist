module misr(
    input clk, reset_b, shift,
	input [7:0] d,
    output reg [7:0] q
    );	 
    
	 //Characteristic Eqn: x^8 + x^4 + x^3 + x^2 + 1
	 always @(posedge clk, negedge reset_b) begin
		if(~reset_b)
			q <= 8'b0;  //initial seed = 0
		else if(shift) begin
			q[0] <= q[7]^d[0];
			q[1] <= q[0]^d[1];
			q[2] <= q[1]^q[7]^d[2];
			q[3] <= q[2]^q[7]^d[3];
			q[4] <= q[3]^q[7]^d[4];
			q[5] <= q[4]^d[5];
			q[6] <= q[5]^d[6];
			q[7] <= q[6]^d[7];
		end
	 end
	 
	  
endmodule
