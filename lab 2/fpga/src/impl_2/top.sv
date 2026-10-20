

module top 
		(//input logic [3:0] switch1,
		//input logic [3:0] switch2,
		input logic reset,
		input logic [3:0] col,
		output logic [1:0] y,
		output logic [6:0] seg,
		output logic [3:0] rows,
		output logic [3:0] led);
		
		logic int_osc;
		logic select;
		logic [3:0] x;

	
	// instantiation of HSOCS
	HSOSC #(.CLKHF_DIV(2'b00))
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

	// TEST 2 - SCANNING MODULE AND KEYPAD
	// instantiation of scanning counter module
	scanning #(.width(25), .maxcount(24000000)) scanning_module(.reset(reset), .enable(1'b1), .int_osc(int_osc), .rows(rows));
	
	// assign statements to implement scanning passthrough
	assign led = ~col;

endmodule
	
	