`timescale 1ns/1ps
module debounce_counter_tb();
	logic clk;
	logic reset;
	logic run;
	logic done;

  // dut instance here
	debounce_counter #(.WIDTH(4)) dut(.clk(clk), .reset(reset), .run(run), .done(done));

  always begin
    clk = 1; #5;
    clk = 0; #5;
  end

  initial begin
    reset = 0; 
    run = 0; #17;
		reset = 1;
		assert (done == 0) $display ("PASSED! done is low after reset");
			else $display ("FAILED!");

		// run for 7 clock edges so not done yet
		run = 1; #66;
		assert (done == 0) $display ("PASSED! done is still low after 7 clock cycles");
			else $display ("FAILED!");

		// the 8th clock edge: done
		#10;
		assert (done == 1) $display ("PASSED! done is high after 8 clock cycles");
			else $display ("FAILED!");

		// run goes low: the counter clears
		run = 0; #10;
		assert (done == 0) $display ("PASSED! done clears when run goes low");
			else $display ("FAILED!");

		// run for only 5 cycles, then stop for a cycle
		run = 1; #50;
		run = 0; #10;

		// start again it must need a full 8 cycles again
		run = 1; #70;
		assert (done == 0) $display ("PASSED! the count restarted after run was interrupted");
			else $display ("FAILED!");
		#10;
		assert (done == 1) $display ("PASSED! done is high after a full 8 cycles again");
			else $display ("FAILED!");

		// reset clears the counter even while run is high
		reset = 0; #10;
		assert (done == 0) $display ("PASSED! reset clears the counter");
			else $display ("FAILED!");

    #100;
    $finish;
  end
endmodule