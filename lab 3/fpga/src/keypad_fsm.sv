`timescale 1ns/1ps
module keypad_fsm (input  logic clk,
				   input  logic reset,
				   input  logic [3:0] cols,
				   input  logic debounce_done,
				   output logic scan_en,
				   output logic run_debounce,
				   output logic capture);

	typedef enum logic [1:0] {SCAN, DEBOUNCE, HOLD} statetype;
		statetype state, nextstate;

	logic any_key;

	assign any_key = ~&cols;   // a 0 on any column means some key is down

	// state register
	always_ff @(posedge clk)
		if (reset == 0) state <= SCAN;
		else state <= nextstate;

	// next-state logic
	always_comb
		case (state)
			SCAN: if (any_key) nextstate = DEBOUNCE;
					  else nextstate = SCAN;
			DEBOUNCE: if (!any_key) nextstate = SCAN; // just a bounce
					  else if (debounce_done) nextstate = HOLD; // confirmed press
					  else nextstate = DEBOUNCE;
			HOLD: if (any_key) nextstate = HOLD; // wait for release
					  else nextstate = SCAN;
			default: nextstate = SCAN;
		endcase

	// output logic
	assign scan_en      = (state == SCAN);
	assign run_debounce = (state == DEBOUNCE);
	assign capture      = (state == DEBOUNCE) & (nextstate == HOLD);

endmodule
