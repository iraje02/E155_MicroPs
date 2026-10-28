////////////////// ADD ROUND KEYS /////////////////////

module addroundkeys(input logic [127:0] roundkey,
					input logic [127:0] state,
					output logic [127:0] arkoutput);
	assign arkoutput = roundkey ^ state;
endmodule