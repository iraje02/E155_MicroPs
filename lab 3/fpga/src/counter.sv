`timescale 1ns/1ps
module counter #(parameter MAXCOUNT = 250000, parameter WIDTH = 18)
								(input   logic reset,
								input logic int_osc,
								input logic enable,
								output logic select,
								output logic [WIDTH-1:0] count);
				
   always_ff @(posedge int_osc) begin
  		if(reset == 0)  begin 
					count <= 0;
					select <= 0;
				end
	 		else if (enable) begin
				if (count == MAXCOUNT) begin
					select <= ~select;
					count <= 0;
				end
     		else count <= count + 1'b01;
    	end
  	end
endmodule