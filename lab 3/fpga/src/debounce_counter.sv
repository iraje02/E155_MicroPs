`timescale 1ns/1ps
module debounce_counter #(parameter WIDTH = 20)
						(input  logic clk,
						 input  logic reset,   // active-low
						 input  logic run,
						 output logic done);

	logic [WIDTH-1:0] count;

	always_ff @(posedge clk)
		if (reset == 0 || !run) count <= 0; // count goes to 0 if reset or run is low
		else count <= count + 1'b1;

	assign done = count[WIDTH-1]; /// done is the MSB of the count thus rises after 2^(WIDTH-1) cycles

endmodule