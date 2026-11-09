`timescale 1ns/1ps
// rows is one-hot LOW, cols is LOW for a pressed column
// Layout:  1 2 3 A   
//          4 5 6 B      
//          7 8 9 C
//          E 0 F D
module decoder (input  logic [3:0] rows,
				input  logic [3:0] cols,
				output logic [3:0] key);

	always_comb
		case ({rows, cols})
			8'b1110_1110: key = 4'h1;
			8'b1110_1101: key = 4'h2;
			8'b1110_1011: key = 4'h3;
			8'b1110_0111: key = 4'hA;
			8'b1101_1110: key = 4'h4;
			8'b1101_1101: key = 4'h5;
			8'b1101_1011: key = 4'h6;
			8'b1101_0111: key = 4'hB;
			8'b1011_1110: key = 4'h7;
			8'b1011_1101: key = 4'h8;
			8'b1011_1011: key = 4'h9;
			8'b1011_0111: key = 4'hC;
			8'b0111_1110: key = 4'hE;   
			8'b0111_1101: key = 4'h0;
			8'b0111_1011: key = 4'hF;   
			8'b0111_0111: key = 4'hD;
			default:      key = 4'h0; 
		endcase

endmodule