// Define Time Unit
`timescale 1ns/1ps

module lab1_led1and2_testbench();
		logic clk;
		logic reset;
		logic [3:0] s;
		logic [6:0] segment;
		
		// instantiate device under test
		sevensegment dut(.s(s), .seg(segment));	
		
		// generate clock
		always
			begin
				clk = 1; #5;
				clk = 0; #5;
			end
		
		// apply inputs
		initial begin
			reset = 0; #10
			reset = 1;
			
			// test 1 - input 0 and outputs 0
			s = 4'b0000; #10;
			assert (segment == 7'b0000001)	else $display ("FAILED! LED did not work as intended for 0");
				
			// test 2 - inputs 1 and outputs 1 
			s = 4'b0001; #10;
			assert (segment == 7'b1001111)	else $display ("FAILED! LED did not work as intended for 1");

			// test 3 - inputs 2 and outputs 2 
			s = 4'b0010; #10;
			assert (segment == 7'b0010010)	else $display ("FAILED! LED did not work as intended for 2");
				
			// test 4 - inputs 3 and outputs 3
			s = 4'b0011; #10;
			assert (segment == 7'b0000110)	else $display ("FAILED! LED did not work as intended for 3");
			
			// test 5 - inputs 4 and outputs 4
			s = 4'b0100; #10;
			assert (segment == 7'b1001100)	else $display ("FAILED! LED did not work as intended for 4");

			// test 6 - inputs 5 and outputs 5 
			s = 4'b0101; #10;
			assert (segment == 7'b0100100)	else $display ("FAILED! LED did not work as intended for 5");
				
			// test 7 - inputs 6 and outputs 6
			s = 4'b0110; #10;
			assert (segment == 7'b0100000)	else $display ("FAILED! LED did not work as intended for 6");
				
			// test 8 - inputs 7 and outputs 7
			s = 4'b0111; #10;
			assert (segment == 7'b0001111)	else $display ("FAILED! LED did not work as intended for 7");
				
			// test 9 - inputs 8 and outputs 8
			s = 4'b1000; #10;
			assert (segment == 7'b0000000)	else $display ("FAILED! LED did not work as intended for 8");
				
			// test 10 - inputs 9 and outputs 9
			s = 4'b1001; #10;
			assert (segment == 7'b0001100)	else $display ("FAILED! LED did not work as intended for 9");

			// test 11 - inputs 10 and outputs A
			s = 4'b1010; #10;
			assert (segment == 7'b0001000)	else $display ("FAILED! LED did not work as intended for A");

			// test 12 - inputs 11 and outputs b 
			s = 4'b1011; #10;
			assert (segment == 7'b1100000)	else $display ("FAILED! LED did not work as intended for b");

			// test 13 - inputs 12 and outputs C
			s = 4'b1100; #10;
			assert (segment == 7'b0110001)	else $display ("FAILED! LED did not work as intended for C");
				
			// test 14 - inputs 13 and outputs D
			s = 4'b1101; #10;
			assert (segment == 7'b1000010)	else $display ("FAILED! LED did not work as intended for D");

			// test 15 - inputs 14 and outputs E
			s = 4'b1110; #10;
			assert (segment == 7'b0110000)	else $display ("FAILED! LED did not work as intended for E");

			// test 16 - inputs 15 and outputs F
			s = 4'b1111; #10;
			assert (segment == 7'b0111000)	else $display ("FAILED! LED did not work as intended for F    ");
				
			#20 $stop;
		end
endmodule