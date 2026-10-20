

module top 
		(input logic [3:0] switch1,
		input logic [3:0] switch2,
		input logic reset,
		output logic [1:0] y,
		output logic [6:0] seg,
		output logic [3:0] led);
		
		logic int_osc;
		logic select;
		logic [3:0] x;
		logic [3:0] rows;

	
	// instantiation of HSOCS
	HSOSC #(.CLKHF_DIV(2'b00))
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		
		
	// TEST 1 - SEVEN SEGMENT DISPLAY
	// instantiation of multiplexing counter module
	counter #(.width(18), .maxcount(250000)) mux_counter(.reset(reset),.int_osc(int_osc),.enable(1'b1), .select(select));
	
	//// assign statements to implement multiplexing
	assign y[0] = ~select;
	assign y[1] = select;
	assign x[3:0] = select ? switch1[3:0] : switch2[3:0];
	
	//// instantiation of seven-segment module
	sevensegment sevensegment_instantiation(.s(x),.seg(seg));

endmodule
	
	