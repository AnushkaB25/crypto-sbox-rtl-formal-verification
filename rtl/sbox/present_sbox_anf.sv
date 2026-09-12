
// 1b. Algebraic-normal-form (gate-level) implementation
//
//
//   y0 = x0 + x2 + x1x2 + x3
//   y1 = x1 + x3 + x1x3 + x2x3 + x0x1x2 + x0x1x3 + x0x2x3
//   y2 = 1 + x2 + x3 + x0x1 + x0x3 + x1x3 + x0x1x3 + x0x2x3
//   y3 = 1 + x0 + x1 + x3 + x1x2 + x0x1x2 + x0x1x3 + x0x2x3
//
// ('+' is XOR.)  Algebraic degree 3, as expected for the PRESENT S-box.
// Common product terms are factored out so the synthesiser sees the sharing.
//------------------------------------------------------------------------------
module present_sbox_anf (
    input  wire  [3:0] x,
    output logic [3:0] y
);

    // shared product terms (degree 2)
    logic p01, p03, p12, p13, p23;
    assign p01 = x[0] & x[1];
    assign p03 = x[0] & x[3];
    assign p12 = x[1] & x[2];
    assign p13 = x[1] & x[3];
    assign p23 = x[2] & x[3];

    // shared product terms (degree 3)
    logic q012, q013, q023;
    assign q012 = p01 & x[2];
    assign q013 = p01 & x[3];
    assign q023 = p03 & x[2];

    assign y[0] =   x[0] ^ x[2] ^ x[3] ^ p12;
    assign y[1] =   x[1] ^ x[3] ^ p13 ^ p23 ^ q012 ^ q013 ^ q023;
    assign y[2] = ~(x[2] ^ x[3] ^ p01 ^ p03 ^ p13 ^ q013 ^ q023);
    assign y[3] = ~(x[0] ^ x[1] ^ x[3] ^ p12 ^ q012 ^ q013 ^ q023);

endmodule
