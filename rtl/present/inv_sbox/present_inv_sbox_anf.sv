// 2b. Inverse S-box in algebraic normal form.
//
//   z0 = 1 + x0 + x2 + x1x3
//   z1 = x0 + x1 + x3 + x0x2 + x1x3 + x2x3 + x0x1x2 + x0x1x3 + x0x2x3
//   z2 = 1 + x3 + x0x1 + x0x2 + x1x2 + x0x3 + x1x3 + x0x1x2 + x0x1x3 + x0x2x3
//   z3 = x0 + x1 + x2 + x3 + x0x1 + x0x1x2 + x0x2x3
//
// Also degree 3 - PRESENT's S-box and its inverse are equally strong, which is
// why the cipher has no "weak direction" for a chosen-ciphertext attacker.
//------------------------------------------------------------------------------
module present_inv_sbox_anf (
    input  wire  [3:0] x,
    output wire  [3:0] y
);

    wire p01 = x[0] & x[1];
    wire p02 = x[0] & x[2];
    wire p03 = x[0] & x[3];
    wire p12 = x[1] & x[2];
    wire p13 = x[1] & x[3];
    wire p23 = x[2] & x[3];

    wire q012 = p01 & x[2];
    wire q013 = p01 & x[3];
    wire q023 = p02 & x[3];

	wire w1 = x[0] ^ x[2];
	wire w2 = x[1] ^ x[3];
	wire w3 = q012 ^ q023;
	wire w4 = p02 ^ p13;
	wire w5 = p01 ^ w3 ;
	wire w6 = w4 ^ q013;
	wire w7 = p23 ^ w3;
	wire w8 = x[0] ^ w2;
	wire w9 = w6 ^ w7;
	wire w10 = x[3] ^ p12;
	wire w11 = w6 ^ w5;
	wire w12 = p03 ^ w11;
	wire w13 = w2 ^ w5;

    assign y[0] = ~( w1 ^ p13);
    assign y[1] =   w8 ^ w9;
    assign y[2] = ~(w10 ^ w12);
    assign y[3] =   w1 ^ w13;

endmodule
