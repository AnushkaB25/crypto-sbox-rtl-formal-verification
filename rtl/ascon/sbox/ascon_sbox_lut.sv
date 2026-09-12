module ascon_sbox_lut (
    input  logic [4:0] x,
    output logic [4:0] y
);
    always_comb begin
         case (x)
            5'h00: y = 5'h04;  5'h01: y = 5'h0B;  5'h02: y = 5'h1F;  5'h03: y = 5'h14;
            5'h04: y = 5'h1A;  5'h05: y = 5'h15;  5'h06: y = 5'h09;  5'h07: y = 5'h02;
            5'h08: y = 5'h1B;  5'h09: y = 5'h05;  5'h0A: y = 5'h08;  5'h0B: y = 5'h12;
            5'h0C: y = 5'h1D;  5'h0D: y = 5'h03;  5'h0E: y = 5'h06;  5'h0F: y = 5'h1C;
            5'h10: y = 5'h1E;  5'h11: y = 5'h13;  5'h12: y = 5'h07;  5'h13: y = 5'h0E;
            5'h14: y = 5'h00;  5'h15: y = 5'h0D;  5'h16: y = 5'h11;  5'h17: y = 5'h18;
            5'h18: y = 5'h10;  5'h19: y = 5'h0C;  5'h1A: y = 5'h01;  5'h1B: y = 5'h19;
            5'h1C: y = 5'h16;  5'h1D: y = 5'h0A;  5'h1E: y = 5'h0F;  5'h1F: y = 5'h17;
        endcase
    end
endmodule