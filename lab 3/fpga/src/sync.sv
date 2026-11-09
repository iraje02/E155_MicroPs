`timescale 1ns/1ps

module sync #(parameter WIDTH = 4)
        (input  logic clk,
        input  logic [WIDTH-1:0] d,
        output logic [WIDTH-1:0] q);

  logic [WIDTH-1:0] temp;

  // two flops to prevents metastability
  always_ff @(posedge clk) begin
                temp <= d;
	        q  <= temp;
        end

endmodule
