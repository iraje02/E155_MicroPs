`timescale 1ns/1ps
module keyreg_tb();
  logic clk;
	logic reset;
	logic load;
	logic [3:0] key;
	logic [3:0] d0;
	logic [3:0] d1;

  // dut instance here
  keyreg dut(.clk(clk), .reset(reset), .load(load), .key(key), .d0(d0), .d1(d1));

  always begin
    clk = 1; #5;
    clk = 0; #5;
  end

  initial begin
    reset = 0; 
    load = 0; 
    key = 4'h7; #22;

		reset = 1; 
    key = 4'h5;
		assert ({d1, d0} == 8'h00) $display ("PASSED! reset cleared both digits");
			else $display ("FAILED!");

		// load is low so the key is ignored
		#20;
		assert ({d1, d0} == 8'h00) $display ("PASSED! key is ignored while load is low");
			else $display ("FAILED!");

		// load the 5 for one clock edge 
		load = 1; #10;
    load = 0;
		assert ({d1, d0} == 8'h05) $display ("PASSED! d0 = 5, d1 = 0");
			else $display ("FAILED!");

		// key changes but load is low so nothing happens
		key = 4'hA; #20;
		assert ({d1, d0} == 8'h05) $display ("PASSED! digits held while load is low");
			else $display ("FAILED!");

		// load the A and the 5 moves to d1
		load = 1; #10; 
    load = 0;
		assert ({d1, d0} == 8'h5A) $display ("PASSED! d0 = A, d1 = 5");
			else $display ("FAILED!");

		// load the F and the A moves over to d1
		key = 4'hF; 
    load = 1; #10;
		assert ({d1, d0} == 8'hAF) $display ("PASSED! d0 = F, d1 = A");
			else $display ("FAILED!");

    // load the 9 and the F moves over to d1
		key = 4'h9; #10;
		assert ({d1, d0} == 8'hF9) $display ("PASSED! d0 = 9, d1 = F");
			else $display ("FAILED!");
    load = 0;

		// reset clears both digits again
		reset = 0; #10;
		assert ({d1, d0} == 8'h00) $display ("PASSED! reset clears both digits");
			else $display ("FAILED!");
		reset = 1;

    #100;
    $finish;
  end
endmodule