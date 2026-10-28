module counter
		#(parameter maxcount = 10000000,
		parameter width = 25)
		(input   logic reset,
		input logic int_osc,
		input logic enable,
		output  logic led);
		
		logic [width-1:0] counter;
		
   always_ff @(posedge int_osc) begin
     if(reset == 0)  begin 
		 counter <= 0;
		 led <= 0;
		 end
	 else if (enable) begin
		if (counter == maxcount) begin
		 led <= ~led;
		 counter <= 0;
		end
     	 else counter <= counter + 1'b1;
     end
   end
endmodule