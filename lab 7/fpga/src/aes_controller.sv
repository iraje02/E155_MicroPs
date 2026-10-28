////////////////// AES CONTROLLER /////////////////////

module aes_controller(input logic clk,
					  input logic load,
					  output logic enable,
					  output logic done,
					  output logic [3:0] round,
					  output logic lastround);
					  
	typedef enum logic [1:0] {LOAD, WAIT, SAVE, DONE} statetype;
	statetype state, nextstate;

	// state register
	always_ff @(posedge clk)
		if (load) state <= LOAD;
		else state <= nextstate;

	// next state logic
	always_comb
		case (state)
			LOAD: nextstate = WAIT;
			WAIT: nextstate = SAVE;
			SAVE: if(round == 10) nextstate = DONE;
				else nextstate = WAIT;
			DONE: nextstate = DONE;
			default: nextstate = LOAD;
		endcase

	// round counter
    always_ff @(posedge clk)
        if (state == LOAD)      round <= 1;
        else if (state == SAVE) round <= round + 1;
        else                    round <= round;

    // outputs
    assign enable    = load | (state == SAVE);
    assign done      = (state == DONE);
    assign lastround = (round == 10);
endmodule