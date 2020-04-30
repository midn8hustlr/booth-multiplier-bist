module mult(
	 input clk, start,   
	 input [3:0] mc, mp,  //multiplicand and multiplier
	 output [7:0] prod,   //product
	 output busy          //when busy=1, result is not ready
	 );
	
	reg [3:0] A, Q, M;
	reg Q_1;
	reg [2:0] count;
	wire [3:0] sum, difference;
	
	always @(posedge clk) begin
		if(start) begin   //reset all registers and initilise M and Q on start
			A <= 4'b0;
			M <= mc;
			Q <= mp;
			Q_1 <= 1'b0;
			count <= 3'b0;
		end
		
		else begin  
			case({Q[0], Q_1})  //Booth's Algorithm
				2'b0_1 : {A, Q, Q_1} <= {sum[3], sum, Q};  //arithmetic shift left {A, Q, Q_1}
				2'b1_0 : {A, Q, Q_1} <= {difference[3], difference, Q};
				default: {A, Q, Q_1} <= {A[3], A, Q};
			endcase
			count <= count + 1'b1;
		end	
	end
	
	// Instantiation of alu as adder and subtractor
	alu ADDER (A, M, 1'b0, sum);
	alu SUBTRACTOR (A, ~M, 1'b1, difference);
	
	assign prod = {A, Q};
	assign busy = (count < 4);  //4-bit multiplier completes the opearation on 4th count, make busy low on 4th count
	
endmodule

/* ALU as an adder, but capable of subtraction:
   Subtraction means adding the two's complement,
   a - b = a + (-b) = a + (inverted b + 1)
   The 1 will be coming in as cin (carry-in) */

module alu(
	input [3:0] a, b,
	input cin,
	output [3:0] out
	);
	
	assign out = a + b + cin;
	
endmodule