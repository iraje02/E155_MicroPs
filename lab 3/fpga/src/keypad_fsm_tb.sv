`timescale 1ns/1ps
// outputs are checked as {scan_en, run_debounce, capture}
// SCAN = 100    
// DEBOUNCE = 010
// HOLD = 000
// capture pulse = 011
module keypad_fsm_tb();
  logic clk;
	logic reset;
	logic [3:0] cols;
	logic debounce_done;
	logic scan_en;
	logic run_debounce;
	logic capture;

  // dut instance here
  	keypad_fsm dut(.clk(clk), .reset(reset), .cols(cols), .debounce_done(debounce_done), .scan_en(scan_en), .run_debounce(run_debounce), .capture(capture));

  always begin
    clk = 1; #5;
    clk = 0; #5;
  end

  initial begin
    reset = 0; 
    cols = 4'b1111; 
    debounce_done = 0; #18;
		reset = 1; #1;
 
		// SCAN, no key so stay in SCAN
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! SCAN with no key");
			else $display ("FAILED!"); #9;
 
		// SCAN ignores debounce_done
		debounce_done = 1; #1;
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! SCAN ignores debounce_done");
			else $display ("FAILED!"); #9;
 
		// SCAN sees a key but still SCAN this cycle and will go to DEBOUNCE next
		debounce_done = 0; 
    cols = 4'b1110; #1;
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! SCAN sees a key");
			else $display ("FAILED!"); #10;
 
		// DEBOUNCE with the key held and not done so stay in DEBOUNCE
		assert ({scan_en, run_debounce, capture} == 3'b010) $display ("PASSED! DEBOUNCE counting");
			else $display ("FAILED!"); #9;
 
		// the key bounces away so still DEBOUNCE this cycle, no capture goes to SCAN next
		cols = 4'b1111; #1;
		assert ({scan_en, run_debounce, capture} == 3'b010) $display ("PASSED! DEBOUNCE sees the key go away, no capture");
			else $display ("FAILED!"); #10;
 
		// back in SCAN
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! back to SCAN after a bounce");
			else $display ("FAILED!"); #9;
 
		// a key appears then debounce_done arrives after the key is already gone no capture
		cols = 4'b1101; #1;
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! SCAN sees a key");
			else $display ("FAILED!"); #9;

		cols = 4'b1111; 
    debounce_done = 1; #1;
		assert ({scan_en, run_debounce, capture} == 3'b010) $display ("PASSED! done but key gone, no capture");
			else $display ("FAILED!"); #9;
    
		debounce_done = 0; #1;
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! back to SCAN");
			else $display ("FAILED!"); #9;
 
		// a full clean press so SCAN then DEBOUNCE and finally HOLD
		cols = 4'b1011; #1;
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! SCAN sees a key");
			else $display ("FAILED!"); #10;

		assert ({scan_en, run_debounce, capture} == 3'b010) $display ("PASSED! DEBOUNCE");
			else $display ("FAILED!"); #9;

		debounce_done = 1; #1;
		assert ({scan_en, run_debounce, capture} == 3'b011) $display ("PASSED! capture pulse on DEBOUNCE to HOLD");
			else $display ("FAILED!"); #10;

		assert ({scan_en, run_debounce, capture} == 3'b000) $display ("PASSED! HOLD, capture is only one cycle");
			else $display ("FAILED!"); #9;

		debounce_done = 0; #1;
		assert ({scan_en, run_debounce, capture} == 3'b000) $display ("PASSED! HOLD while the key is down");
			else $display ("FAILED!"); #9;
 
		// release so HOLD this cycle and goes to SCAN next
		cols = 4'b1111; 
    debounce_done = 0; #1;
		assert ({scan_en, run_debounce, capture} == 3'b000) $display ("PASSED! HOLD sees the release");
			else $display ("FAILED!"); #10;

		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! SCAN after the release");
			else $display ("FAILED!"); #9;
 
		// reset in the middle of DEBOUNCE
		cols = 4'b0111; #1;
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! SCAN sees a key");
			else $display ("FAILED!"); #10;
    
		assert ({scan_en, run_debounce, capture} == 3'b010) $display ("PASSED! in DEBOUNCE before reset");
			else $display ("FAILED!"); #9;

		reset = 0; #10;
		assert ({scan_en, run_debounce, capture} == 3'b100) $display ("PASSED! reset forces SCAN");
			else $display ("FAILED!");
		reset = 1;

    #20;
    $finish;
  end
endmodule