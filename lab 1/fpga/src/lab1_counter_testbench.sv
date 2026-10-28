// Define Time Unit
`timescale 1ns/1ps

module lab1_counter_testbench();
		logic reset;
		logic int_osc;
		logic enable;
		logic led;
		
		// instantiate device under test
		counter #(.maxcount(3), .width(3)) dut(.reset(reset), .int_osc(int_osc), .enable(enable), .led(led));
		
		// generate clock
		always
			begin
				int_osc = 0; #5;
				int_osc = 1; #5;
			end
		
		// check if reset worked as intended
		initial begin
			reset = 1; #5
			reset = 0;
			enable = 0; #20
			
			assert (led == 0) 
				else $display ("FAILED! RESET did not work as intended");
		
			// release reset
			reset = 1;
		
			// check if enable worked as intended
			enable = 0; #10
		
			assert (led == 0)
				else $display ("FAILED! ENABLE did not work as intended");
			
			// check if enable worked as intended
			enable = 1; #40
			
			assert (led == 1)
				else $display ("FAILED! LED did not toggle back");
			$stop;
		end
endmodule