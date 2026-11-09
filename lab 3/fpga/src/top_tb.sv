`timescale 1ns/1ps
module top_testbench();
	logic reset;
	logic [3:0] cols;
	logic [3:0] rows;
	logic [1:0] y;
	logic [6:0] seg;
	logic key1, key5; // 1 = that key is being held down

	// instantiate device under test (slow counters shrunk so the simulation is short)
	top #(.SCAN_MAXCOUNT(400), .MUX_MAXCOUNT(20), .DEBOUNCE_WIDTH(6)) dut(.reset(reset), .cols(cols), .rows(rows), .y(y), .seg(seg));

	// key 1 = row 0, column 0     key 5 = row 1, column 1
	assign cols = {2'b11, ~(key5 & ~rows[1]), ~(key1 & ~rows[0])};

	// apply inputs and check outputs
	initial begin
		key1 = 0; key5 = 0;
		reset = 0; #200;
		reset = 1; #100;

		// the display starts at 0 0
		assert ({dut.d1, dut.d0} == 8'h00) $display ("PASSED! both digits are 0 after reset");
			else $display ("FAILED! both digits should be 0 after reset");

		// key 1 tapped for less time than the debounce time: nothing registers
		key1 = 1; #200;
		key1 = 0; #300;
		assert ({dut.d1, dut.d0} == 8'h00) $display ("PASSED! a short tap was ignored");
			else $display ("FAILED!");

		// key 1 pressed with bounce, then held
		key1 = 1; #50;
		key1 = 0; #50;
		key1 = 1; #50;
		key1 = 0; #50;
		key1 = 1; #2000;
		assert ({dut.d1, dut.d0} == 8'h01) $display ("PASSED! key 1 registered (d0 = 1, d1 = 0)");
			else $display ("FAILED!");

		// still held for a long time but not registered a second time
		#2000;
		assert ({dut.d1, dut.d0} == 8'h01) $display ("PASSED! holding key 1 did not register it twice");
			else $display ("FAILED!");

		// release
		key1 = 0; #2000;
		assert ({dut.d1, dut.d0} == 8'h01) $display ("PASSED! releasing key 1 did not change display");
			else $display ("FAILED!");

		// key 5 is pressed so it becomes d0 and the 1 moves to d1
		key5 = 1; #2000;
		assert ({dut.d1, dut.d0} == 8'h15) $display ("PASSED! key 5 registered (d0 = 5, d1 = 1)");
			else $display ("FAILED!");

		// the display shows 5 on one digit and 1 on the other
		assert ((y == 2'b01 && seg == 7'b0100100) || (y == 2'b10 && seg == 7'b1001111))
			$display ("PASSED! the seven segment display shows 5 and 1");
			else $display ("FAILED");

		// release key 5 so nothing new is registered
		key5 = 0; #2000;
		assert ({dut.d1, dut.d0} == 8'h15) $display ("PASSED! releasing key 5 changed nothing");
			else $display ("FAILED!");

    // reset at the end to clear display
    reset = 0; #200;
    assert ({dut.d1, dut.d0} == 8'h00) $display ("PASSED! reset cleared d0 and d1");
      else $display ("FAILED!");
    assert (seg == 7'b0000001) $display ("PASSED! the display shows 0 after reset");
      else $display ("FAILED!");
    reset = 1;

		#500; 
    $finish;
	end
endmodule