// Define Time Unit
`timescale 1ns/1ps

module lab1_top_testbench();

		logic [3:0] s;
		logic [2:0] led;
		logic [6:0] seg;
		logic reset;
		
		// instantiate device under test
		top #(.counterwidth(3),.countermaxcount(3)) dut(.s(s),.reset(reset),.led(led), .seg(seg));
		
		// apply inputs
		initial begin
			reset = 0; #30
			reset = 1;
			
			// test 1 - LED0 OFF
				s = 4'b0000; #30;
				assert (led[0] == 1'b0)	else $display ("FAILED! LED did not work as intended on 0000");
				
			// test 2 - LED0 ON
				s = 4'b0001; #30;
				assert (led[0] == 1'b1)	else $display ("FAILED! LED did not work as intended on 0001");

			// test 3 - LED0 ON
				s = 4'b0010; #30;
				assert (led[0] == 1'b1)	else $display ("FAILED! LED did not work as intended on 0010");
				
			// test 4 - LED0 OFF
				s = 4'b0011; #30;
				assert (led[0] == 1'b0)	else $display ("FAILED! LED did not work as intended on 0011");
			
			// test 5 - LED1 OFF
				s = 4'b0100; #30;
				assert (led[1] == 1'b0)	else $display ("FAILED! LED did not work as intended on 0100");
				
			// test 6 - LED1 OFF
				s = 4'b1000; #30;
				assert (led[1] == 1'b0)	else $display ("FAILED! LED did not work as intended on 1000");

			// test 7 - LED1 ON
				s = 4'b1100; #30;
				assert (led[1] == 1'b1)	else $display ("FAILED! LED did not work as intended on 1100");
			
			#50 $stop;
		end
endmodule