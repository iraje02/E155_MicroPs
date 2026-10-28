////////////////// SHIFT ROWS /////////////////////

module shiftrows(input  logic [127:0] a,
                 output logic [127:0] y);
    always_comb
        for (int r = 0; r < 4; r++)
            for (int c = 0; c < 4; c++)
                y[127 - 8*(4*c + r) -: 8] = a[127 - 8*(4*((c + r) % 4) + r) -: 8];
endmodule