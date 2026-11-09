`timescale 1ns/1ps
module scanning #(parameter MAXCOUNT = 24000000,
				parameter WIDTH = 25)
				
				(input logic reset,
				input logic enable,
				input logic int_osc,
				output logic [3:0] rows);
				
				logic [WIDTH-1:0] count;
	
	// instantiate scanning counter
	counter #(.WIDTH(WIDTH),.MAXCOUNT(MAXCOUNT)) scanning_counter(.reset(reset),.int_osc(int_osc),.enable(enable), .select(), .count(count));
	
	// assign logic to convert from counter output to output values
	assign rows =	(count < (MAXCOUNT/4)) ? 4'b0001 :
					(count < (MAXCOUNT/2)) ? 4'b0010 :
					(count < ((3*MAXCOUNT)/4)) ? 4'b0100 :
										4'b1000;

endmodule