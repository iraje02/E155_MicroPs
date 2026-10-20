module counter
		#(parameter maxcount = 250000,
		parameter width = 18)
		(input   logic reset,
		input logic int_osc,
		input logic enable,
		output logic select,
		output logic [width-1:0] count);
				
   always_ff @(posedge int_osc) begin
     if(reset == 0)  begin 
		count <= 0;
		select <= 0;
		end
	 else if (enable) begin
		if (count == maxcount) begin
			select <= ~select;
			count <= 0;
			end
     else count <= count + 1'b01;
     end
   end
endmodule