`timescale 1ns/1ps
module keyreg (input  logic clk,
			   input  logic reset,   // active low 
			   input  logic  load,
			   input  logic [3:0] key,
			   output logic [3:0] d0,
			   output logic [3:0] d1);

	always_ff @(posedge clk)
		if (reset == 0) begin
			d0 <= 4'h0; // most recent key
			d1 <= 4'h0; // key before that
		end 
		else if (load) begin  //only when load is high does the register load values
			d1 <= d0;
			d0 <= key;
		end

endmodule
