////////////////// KEY EXPANSION /////////////////////

module keyexpansion (input logic clk, 
					 input logic [3:0] round,
					 input logic [127:0] key,
					 output logic [127:0] newkey);
	logic [7:0] rcon;
	logic [31:0] w0, w1, w2, w3;
	logic [31:0] rotatedword3;
	logic [31:0] subword;
	logic [31:0] temp;
	logic [31:0] w0new, w1new, w2new, w3new;

	// RCON
	always_comb
		case (round)
			4'd1: rcon = 8'h01;
			4'd2: rcon = 8'h02;
			4'd3: rcon = 8'h04;
			4'd4: rcon = 8'h08;
			4'd5: rcon = 8'h10;
			4'd6: rcon = 8'h20;
			4'd7: rcon = 8'h40;
			4'd8: rcon = 8'h80;
			4'd9: rcon = 8'h1b;
			4'd10: rcon = 8'h36;
			default: rcon = 8'h00;
		endcase

	// ROT WORD
	assign w0 = key[127:96];
	assign w1 = key[95:64];
	assign w2 = key[63:32];
	assign w3 = key[31:0];
	assign rotatedword3 = {w3[23:0], w3[31:24]};

	// SUB WORD - runs each byte of rotatedword3 through sbox
	sbox_sync sbs16(rotatedword3[31:24], clk, subword[31:24]);
	sbox_sync sbs17(rotatedword3[23:16], clk, subword[23:16]);
	sbox_sync sbs18(rotatedword3[15:8], clk, subword[15:8]);
	sbox_sync sbs19(rotatedword3[7:0], clk, subword[7:0]);

	// XOR
	assign temp = { subword[31:24]^rcon, subword[23:0] };
	assign w0new = w0 ^ temp;
	assign w1new = w1 ^ w0new;
	assign w2new = w2 ^ w1new;
	assign w3new = w3 ^ w2new;
	assign newkey = {w0new, w1new, w2new, w3new};
	
endmodule