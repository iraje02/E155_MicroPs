`timescale 1ns/1ps
module top #(parameter SCAN_MAXCOUNT = 1280000,
			 parameter MUX_MAXCOUNT= 250000,
			 parameter DEBOUNCE_WIDTH = 20)

		   (input  logic reset,  // active-low
			input  logic [3:0] cols, 
			output logic [3:0] rows, 
			output logic [1:0] y,  
			output logic [6:0] seg);

	logic int_osc, select;
	logic [3:0] scan_rows;
	logic [3:0] cols_sync;
	logic scan_en, run_debounce, debounce_done, capture;
	logic [3:0] key, d0, d1, x;

	// internal oscillator
	HSOSC #(.CLKHF_DIV(2'b00)) hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

	// scanning
	scanning #(.WIDTH(21), .MAXCOUNT(SCAN_MAXCOUNT)) scanning_module (.reset(reset), .enable(scan_en), .int_osc(int_osc), .rows(scan_rows));

	assign rows = ~scan_rows; // active-low rows

	//synchronize the async column inputs
	sync #(.WIDTH(4)) col_sync (.clk(int_osc), .d(cols), .q(cols_sync));

	// press detection
	keypad_fsm fsm (.clk(int_osc), .reset(reset), .cols(cols_sync), .debounce_done(debounce_done), .scan_en(scan_en), .run_debounce(run_debounce), .capture(capture));

	// debounce
	debounce_counter #(.WIDTH(DEBOUNCE_WIDTH)) debounce (.clk(int_osc), .reset(reset), .run(run_debounce), .done(debounce_done));

	// decode and remember the last two keys
	decoder key_decoder (.rows(rows), .cols(cols_sync), .key(key));

	keyreg keys (.clk(int_osc), .reset(reset), .load(capture), .key(key), .d0(d0), .d1(d1));

	// display multiplexing
	counter #(.WIDTH(18), .MAXCOUNT(MUX_MAXCOUNT)) mux_counter (.reset(reset), .int_osc(int_osc), .enable(1'b1), .select(select), .count());

	assign y[0] = ~select;
	assign y[1] = select;
	assign x = select ? d1 : d0; // d0 (newest) on the y[0] digit, d1 on the y[1] digit

	// seven seg
	sevensegment sevensegment_instantiation (.s(x), .seg(seg));

endmodule