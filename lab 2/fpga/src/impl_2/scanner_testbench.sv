
`timescale 1ns/1ps

module scanner_testbench();
			logic reset;			
			logic enable;
			logic int_osc;

			logic [3:0] rows;
			
			// instatantiate device under test
			scanning #(.maxcount(4), .width(4)) dut(.reset(reset), .enable(enable), .int_osc(int_osc), .rows(rows));
			
			// generate clock
			always
				begin
					int_osc = 0; #5;
					int_osc = 1; #5;
				end
				
			initial begin
				reset = 1; #5;
				reset = 0; #5;
				enable = 0; #20;
				
				// check if reset works
				assert (rows == 4'b0001) $display("PASSED! Reset works as intended");
					else $display ("FAILED! Reset did not work as intended");
				
				//release reset
				reset = 1;
				
				// check if enable works
				enable = 0; #5;
				assert (rows == 4'b0001) $display("PASSED! Enable works as intended");
					else $display ("FAILED! Enable did not work as intended");
				
				//release enable
				enable = 1; #5;
			
				// check if LED is in state 0010 as intended
				assert (rows == 4'b0010) $display ("PASSED! LED is in state 0010");
					else $display ("FAILED! LED is in not state 0010");
			
				#10;
				// check if LED is in state 0100 as intended
				assert (rows == 4'b0100) $display ("PASSED! LED is in state 0100");
					else $display ("FAILED! LED is in not state 0100");
			
				#10;
				// check if LED is in state 1000 as intended
				assert (rows == 4'b1000) $display ("PASSED! LED is in state");
					else $display ("FAILED! LED is in not state 1000");
						
				#50; $stop;
			end
endmodule