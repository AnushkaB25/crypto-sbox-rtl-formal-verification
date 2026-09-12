module present_sbox_lut (
    input  logic [3:0] x,      // 4-bit input word
    output logic [3:0] s_out   // 4-bit substituted output
);

    always_comb begin
        case (x)
            4'h0: s_out = 4'hC;
            4'h1: s_out = 4'h5;
            4'h2: s_out = 4'h6;
            4'h3: s_out = 4'hB;
            4'h4: s_out = 4'h9;
            4'h5: s_out = 4'h0;
            4'h6: s_out = 4'hA;
            4'h7: s_out = 4'hD;
            4'h8: s_out = 4'h3;
            4'h9: s_out = 4'hE;
            4'hA: s_out = 4'hF;
            4'hB: s_out = 4'h8;
            4'hC: s_out = 4'h4;
            4'hD: s_out = 4'h7;
            4'hE: s_out = 4'h1;
            4'hF: s_out = 4'h2;
            default: s_out = 4'h0; // safety default
        endcase
    end

endmodule
