// Ishita Raje LAB 1
// 9/5/2026
// Fall 2026

// Define Time Unit
`timescale 1ns/1ps

module top #(parameter countermaxcount = 10000000,
		parameter counterwidth = 25)
		(input logic [3:0] s,
		input logic reset,
		output logic [2:0] led,
		output logic [6:0] seg);

		logic int_osc;
		
	assign led[0] = s[0]^s[1];
	assign led[1] = s[3]&s[2];
	
	//instantiate HSOC
	HSOSC #(.CLKHF_DIV(2'b00))
		hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
	//instantiate seven seg
	sevensegment sevensegment_instantiation(.s(s),.seg(seg));
	
	//instantiate counter
	counter #(.width(counterwidth), .maxcount(countermaxcount)) counter_instantiation(.int_osc(int_osc),.reset(reset),.enable(1'b1),.led(led[2]));
		
endmodule