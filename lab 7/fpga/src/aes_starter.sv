/////////////////////////////////////////////
`timescale 10ns/1ns
// aes
//   Top level module with SPI interface and SPI core
/////////////////////////////////////////////

module aes(input  logic clk,
           input  logic sck, 
           input  logic sdi,
           output logic sdo,
           input  logic load,
           output logic done);
                    
    logic [127:0] key, plaintext, cyphertext;
            
    aes_spi spi(sck, sdi, sdo, done, key, plaintext, cyphertext);   
    aes_core core(clk, load, key, plaintext, done, cyphertext);
endmodule

/////////////////////////////////////////////
// aes_spi
//   SPI interface.  Shifts in key and plaintext
//   Captures ciphertext when done, then shifts it out
//   Tricky cases to properly change sdo on negedge clk
/////////////////////////////////////////////

module aes_spi(input  logic sck, 
               input  logic sdi,
               output logic sdo,
               input  logic done,
               output logic [127:0] key, plaintext,
               input  logic [127:0] cyphertext);

    logic         sdodelayed, wasdone;
    logic [127:0] cyphertextcaptured;
               
    // assert load
    // apply 256 sclks to shift in key and plaintext, starting with plaintext[127]
    // then deassert load, wait until done
    // then apply 128 sclks to shift out cyphertext, starting with cyphertext[127]
    // SPI mode is equivalent to cpol = 0, cpha = 0 since data is sampled on first edge and the first
    // edge is a rising edge (clock going from low in the idle state to high).
    always_ff @(posedge sck)
        if (!wasdone)  {cyphertextcaptured, plaintext, key} = {cyphertext, plaintext[126:0], key, sdi};
        else           {cyphertextcaptured, plaintext, key} = {cyphertextcaptured[126:0], plaintext, key, sdi}; 
    
    // sdo should change on the negative edge of sck
    always_ff @(negedge sck) begin
        wasdone = done;
        sdodelayed = cyphertextcaptured[126];
    end
    
    // when done is first asserted, shift out msb before clock edge
    assign sdo = (done & !wasdone) ? cyphertext[127] : sdodelayed;
endmodule

/////////////////////////////////////////////
// aes_core
//   top level AES encryption module
//   when load is asserted, takes the current key and plaintext
//   generates cyphertext and asserts done when complete 11 cycles later
// 
//   See FIPS-197 with Nk = 4, Nb = 4, Nr = 10
//
//   The key and message are 128-bit values packed into an array of 16 bytes as
//   shown below
//        [127:120] [95:88] [63:56] [31:24]     S0,0    S0,1    S0,2    S0,3
//        [119:112] [87:80] [55:48] [23:16]     S1,0    S1,1    S1,2    S1,3
//        [111:104] [79:72] [47:40] [15:8]      S2,0    S2,1    S2,2    S2,3
//        [103:96]  [71:64] [39:32] [7:0]       S3,0    S3,1    S3,2    S3,3
//
//   Equivalently, the values are packed into four words as given
//        [127:96]  [95:64] [63:32] [31:0]      w[0]    w[1]    w[2]    w[3]
/////////////////////////////////////////////

module aes_core(input  logic         clk, 
                input  logic         load,
                input  logic [127:0] key, 
                input  logic [127:0] plaintext, 
                output logic         done, 
                output logic [127:0] cyphertext);

	logic enable, lastround;
	logic [3:0] round;
	logic [127:0] newkey, newstate, keymuxoutput, statemuxoutput, statereg, keyreg, subbytesoutput, shiftrowsoutput, mixcolumnsoutput, bypassmuxoutput;

	//instantiate controller
	aes_controller aes_ctrl(clk, load, enable, done, round, lastround);

	//mux prior to state register
	assign statemuxoutput = load ? (key ^ plaintext) : newstate;
	
	//state register
	always_ff @(posedge clk)
		if (enable) statereg <= statemuxoutput;

	//cyphertext = output of state register
	assign cyphertext = statereg;
	
	//mux prior to key register
	assign keymuxoutput = load ? key : newkey;
	
	//key register
	always_ff @(posedge clk)
		if (enable) keyreg <= keymuxoutput;
			
	//instantiate key expansion
	keyexpansion aes_keyexp(clk, round, keyreg, newkey);

	//instantiate subbytes
	subbytes aes_subbytes(statereg, clk, subbytesoutput);

	//instantiate shiftrows
	shiftrows aes_shiftrows(subbytesoutput, shiftrowsoutput);

	//instantiate mixcolumns
	mixcolumns aes_mixcolumn(shiftrowsoutput, mixcolumnsoutput);

	//mux before addroundkeys to bypass mixcolumn
	assign bypassmuxoutput = lastround ? shiftrowsoutput : mixcolumnsoutput;

	//instantiate addroundkeys
	addroundkeys aes_ark(newkey, bypassmuxoutput, newstate);
    
endmodule


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

////////////////// ADD ROUND KEYS /////////////////////

module addroundkeys(input logic [127:0] roundkey,
					input logic [127:0] state,
					output logic [127:0] arkoutput);
	assign arkoutput = roundkey ^ state;
endmodule

////////////////// SHIFT ROWS /////////////////////

module shiftrows(input  logic [127:0] a,
                 output logic [127:0] y);
    always_comb
        for (int r = 0; r < 4; r++)
            for (int c = 0; c < 4; c++)
                y[127 - 8*(4*c + r) -: 8] = a[127 - 8*(4*((c + r) % 4) + r) -: 8];
endmodule

////////////////// SUB BYTES /////////////////////

module subbytes(input  logic [127:0] a,
				input logic clk,
                output logic [127:0] y);

	sbox_sync sbs0(a[127:120], clk, y[127:120]);
	sbox_sync sbs1(a[119:112], clk, y[119:112]);
	sbox_sync sbs2(a[111:104], clk, y[111:104]);
	sbox_sync sbs3(a[103:96], clk, y[103:96]);
	sbox_sync sbs4(a[95:88], clk, y[95:88]);
	sbox_sync sbs5(a[87:80], clk, y[87:80]);
	sbox_sync sbs6(a[79:72], clk, y[79:72]);
	sbox_sync sbs7(a[71:64], clk, y[71:64]);
	sbox_sync sbs8(a[63:56], clk, y[63:56]);
	sbox_sync sbs9(a[55:48], clk, y[55:48]);
	sbox_sync sbs10(a[47:40], clk, y[47:40]);
	sbox_sync sbs11(a[39:32], clk, y[39:32]);
	sbox_sync sbs12(a[31:24], clk, y[31:24]);
	sbox_sync sbs13(a[23:16], clk, y[23:16]);
	sbox_sync sbs14(a[15:8], clk, y[15:8]);
	sbox_sync sbs15(a[7:0], clk, y[7:0]);
endmodule

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

/////////////////////////////////////////////
// sbox
//   Infamous AES byte substitutions with magic numbers
//   Combinational version which is mapped to LUTs (logic cells)
//   Section 5.1.1, Figure 7
/////////////////////////////////////////////

module sbox(input  logic [7:0] a,
            output logic [7:0] y);
            
  // sbox implemented as a ROM
  // This module is combinational and will be inferred using LUTs (logic cells)
  logic [7:0] sbox[0:255];

  initial   $readmemh("sbox.txt", sbox);
  assign y = sbox[a];
endmodule

/////////////////////////////////////////////
// sbox
//   Infamous AES byte substitutions with magic numbers
//   Synchronous version which is mapped to embedded block RAMs (EBR)
//   Section 5.1.1, Figure 7
/////////////////////////////////////////////
module sbox_sync(
	input		logic [7:0] a,
	input	 	logic 			clk,
	output 	logic [7:0] y);
            
  // sbox implemented as a ROM
  // This module is synchronous and will be inferred using BRAMs (Block RAMs)
  logic [7:0] sbox [0:255];

  initial   $readmemh("sbox.txt", sbox);
	
	// Synchronous version
	always_ff @(posedge clk) begin
		y <= sbox[a];
	end
endmodule

/////////////////////////////////////////////
// mixcolumns
//   Even funkier action on columns
//   Section 5.1.3, Figure 9
//   Same operation performed on each of four columns
/////////////////////////////////////////////

module mixcolumns(input  logic [127:0] a,
                  output logic [127:0] y);

  mixcolumn mc0(a[127:96], y[127:96]);
  mixcolumn mc1(a[95:64],  y[95:64]);
  mixcolumn mc2(a[63:32],  y[63:32]);
  mixcolumn mc3(a[31:0],   y[31:0]);
endmodule

/////////////////////////////////////////////
// mixcolumn
//   Perform Galois field operations on bytes in a column
//   See EQ(4) from E. Ahmed et al, Lightweight Mix Columns Implementation for AES, AIC09
//   for this hardware implementation
/////////////////////////////////////////////

module mixcolumn(input  logic [31:0] a,
                 output logic [31:0] y);
                      
        logic [7:0] a0, a1, a2, a3, y0, y1, y2, y3, t0, t1, t2, t3, tmp;
        
        assign {a0, a1, a2, a3} = a;
        assign tmp = a0 ^ a1 ^ a2 ^ a3;
    
        galoismult gm0(a0^a1, t0);
        galoismult gm1(a1^a2, t1);
        galoismult gm2(a2^a3, t2);
        galoismult gm3(a3^a0, t3);
        
        assign y0 = a0 ^ tmp ^ t0;
        assign y1 = a1 ^ tmp ^ t1;
        assign y2 = a2 ^ tmp ^ t2;
        assign y3 = a3 ^ tmp ^ t3;
        assign y = {y0, y1, y2, y3};    
endmodule

/////////////////////////////////////////////
// galoismult
//   Multiply by x in GF(2^8) is a left shift
//   followed by an XOR if the result overflows
//   Uses irreducible polynomial x^8+x^4+x^3+x+1 = 00011011
/////////////////////////////////////////////

module galoismult(input  logic [7:0] a,
                  output logic [7:0] y);

    logic [7:0] ashift;
    
    assign ashift = {a[6:0], 1'b0};
    assign y = a[7] ? (ashift ^ 8'b00011011) : ashift;
endmodule
