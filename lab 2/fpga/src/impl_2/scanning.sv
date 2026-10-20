module scanning #(parameter maxcount = 24000000,
				parameter width = 25)
				
				(input logic reset,
				input logic enable,
				input logic int_osc,
				output logic [3:0] rows);
				
				logic [width-1:0] count;
	
	// instantiate the scanning counter
	counter #(.width(width),.maxcount(maxcount)) scanning_counter(.reset(reset),.int_osc(int_osc),.enable(enable), .select(select), .count(count));
	
	// use assign logic to convert from counter output to output values
	
	assign rows =	(count < (maxcount/4)) ? 4'b0001 :
					(count < (maxcount/2)) ? 4'b0010 :
					(count < ((3*maxcount)/4)) ? 4'b0100 :
										4'b1000;

endmodule