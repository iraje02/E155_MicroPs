`timescale 1ns/1ps
module sync_tb();
  logic clk;
	logic [3:0] d;
	logic [3:0] q;

  // dut instance here
  sync #(.WIDTH(4)) dut(.clk(clk), .d(d), .q(q));

  always begin
    clk = 1; #5;
    clk = 0; #5;
  end

  initial begin
    d = 4'b1111; #18;
		assert (q == 4'b1111) $display ("PASSED! q is the same as d after two clock edges");
			else $display ("FAILED!");

		// change d between clock edges so q must wait two edges
		d = 4'b1110; #10;
		assert (q == 4'b1111) $display ("PASSED! q did not changed after one clock edge");
			else $display ("FAILED!");
		#10;
		assert (q == 4'b1110) $display ("PASSED! q changed after two clock edges");
			else $display ("FAILED!");

    // test agan
		d = 4'b0101; #10;
		assert (q == 4'b1110) $display ("PASSED! q has not changed after one clock edge");
			else $display ("FAILED!");
		#10;
		assert (q == 4'b0101) $display ("PASSED! q changed after two clock edges");
			else $display ("FAILED!");
		#20; 
    $finish;
  end
endmodule
