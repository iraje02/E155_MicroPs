`timescale 1ns/1ps
module decoder_tb();
  logic [3:0] rows;
	logic [3:0] cols;
	logic [3:0] key;

  // dut instance here
  decoder dut(.rows(rows), .cols(cols), .key(key));

  initial begin
    rows = 4'b1110; cols = 4'b1110; #10;
		assert (key == 4'h1) $display ("PASSED! key 1 outputs 1");
			else $display ("FAILED!");

		rows = 4'b1110; cols = 4'b1101; #10;
		assert (key == 4'h2) $display ("PASSED! key 2 outputs 2");
			else $display ("FAILED!");

		rows = 4'b1110; cols = 4'b1011; #10;
		assert (key == 4'h3) $display ("PASSED! key 3 outputs 3");
			else $display ("FAILED!");

		rows = 4'b1101; cols = 4'b1110; #10;
		assert (key == 4'h4) $display ("PASSED! key 4 outputs 4");
			else $display ("FAILED!");

		rows = 4'b1101; cols = 4'b1101; #10;
		assert (key == 4'h5) $display ("PASSED! key 5 outputs 5");
			else $display ("FAILED!");

		rows = 4'b1101; cols = 4'b1011; #10;
		assert (key == 4'h6) $display ("PASSED! key 6 outputs 6");
			else $display ("FAILED!");
    
    rows = 4'b1011; cols = 4'b1110; #10;
		assert (key == 4'h7) $display ("PASSED! key 7 outputs 7");
			else $display ("FAILED!");

		rows = 4'b1011; cols = 4'b1101; #10;
		assert (key == 4'h8) $display ("PASSED! key 8 outputs 8");
			else $display ("FAILED!");

		rows = 4'b1011; cols = 4'b1011; #10;
		assert (key == 4'h9) $display ("PASSED! key 9 outputs 9");
			else $display ("FAILED!");

    rows = 4'b1110; cols = 4'b0111; #10;
		assert (key == 4'hA) $display ("PASSED! key A outputs A");
			else $display ("FAILED!");

		rows = 4'b1101; cols = 4'b0111; #10;
		assert (key == 4'hB) $display ("PASSED! key B outputs B");
			else $display ("FAILED!");

		rows = 4'b1011; cols = 4'b0111; #10;
		assert (key == 4'hC) $display ("PASSED! key C outputs C");
			else $display ("FAILED!");

    rows = 4'b0111; cols = 4'b0111; #10;
		assert (key == 4'hD) $display ("PASSED! key D outputs D");
			else $display ("FAILED!");

		rows = 4'b0111; cols = 4'b1110; #10;
		assert (key == 4'hE) $display ("PASSED! key E outputs E");
			else $display ("FAILED!");

		rows = 4'b0111; cols = 4'b1011; #10;
		assert (key == 4'hF) $display ("PASSED! key F outputs F");
			else $display ("FAILED!");

    rows = 4'b0111; cols = 4'b1101; #10;
		assert (key == 4'h0) $display ("PASSED! key 0 outputs 0");
			else $display ("FAILED!");

		// no key pressed
		rows = 4'b1110; cols = 4'b1111; #10;

		#20;
    $finish;
  end
endmodule