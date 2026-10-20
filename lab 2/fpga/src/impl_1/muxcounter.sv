module muxcounter
		#(parameter maxcount = 250000,
		parameter width = 18)
		(input   logic reset,
		input logic int_osc,
		input logic enable,
		output logic select);
		
		logic [width-1:0] counter;
		
   always_ff @(posedge int_osc) begin
     if(reset == 0)  begin 
		counter <= 0;
		select <= 0;
		end
	 else if (enable) begin
		if (counter == maxcount) begin
			select <= ~select;
			counter <= 0;
			end
     else counter <= counter + 1'b1;
     end
   end
endmodule