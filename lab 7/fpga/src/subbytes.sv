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