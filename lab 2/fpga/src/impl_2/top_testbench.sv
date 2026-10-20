`timescale 1ns/1ps

module top_testbench();

		logic [3:0] switch1;
		logic [3:0] switch2;
		logic reset;
		logic [1:0] y;
		logic [6:0] seg;
		logic [3:0] led;
		
		// instantiate device under test
		top #(.width(4), .maxcount(4)) dut(.switch1(switch1), .switch2(switch2), .reset(reset), .y(y), .seg(seg), .led(led));
		
		// apply inputs
		initial begin
			switch1 = 4'b0000; #5;
			switch2 = 4'b1100; #5;
			reset = 0; #50
			reset = 1;
	
			// check MUX functionality has worked and the first digit has been turned on, and is showing the right number/letter
			assert (y == 2'b10) $display ("PASSED! Correct digit selection using multiplexer");
				else $display ("FAILED! Incorrect digit selection using multiplexer for switch ");
			assert (seg == 7'b0110001) $display ("PASSED! Digit 1 showed 'C' as intended");
				else $display ("FAILED! Digit 1 did not show C as intended"); 
					
			// check if LED is in state 0001 as intended
			assert (led == 4'b0001) $display ("PASSED! LED is in state 0001");
				else $display ("FAILED! LED is not in state 0001");
					
			#25;
			
			// check if LED is in state 0010 as intended
			assert (led == 4'b0010) $display ("PASSED! LED is in state 0010");
			else $display ("FAILED! LED is in not state 0010");
			
			#10;
			// check if LED is in state 0100 as intended
			assert (led == 4'b0100) $display ("PASSED! LED is in state 0100");
				else $display ("FAILED! LED is in not state 0100");
			
			#10;
			// check if LED is in state 1000 as intended
			assert (led == 4'b1000) $display ("PASSED! LED is in state");
				else $display ("FAILED! LED is in not state 1000");
			
			#50;
			// check if MUX funcationality has worked and the second digit has been turned on, and is showing the right number/letter
			assert (y == 2'b01) $display ("PASSED! Correct digit selection using multiplexer");
				else $display ("FAILED! Incorrect digit selection using multiplexer for switch ");
			assert (seg == 7'b0000001) $display ("PASSED! Digit 1 showed '0' as intended");
				else $display ("FAILED! Digit1 did not show 0 as intended");
			
			
			#500; $stop;

		end
endmodule
			
