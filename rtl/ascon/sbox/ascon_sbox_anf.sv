//====================================================================
//  ascon_sbox_anf.sv
//
//  ASCON 5-bit S-box written in Algebraic Normal Form.
//
//  Every output bit is a GF(2) polynomial of degree 2:
//
//    y0 = x0 + x1 + x2 + x3 + x0.x1 + x1.x2 + x1.x4
//    y1 = x0 + x1 + x2 + x3 + x4 + x1.x2 + x1.x3 + x2.x3
//    y2 =  1 + x1 + x2 + x4 + x3.x4
//    y3 = x0 + x1 + x2 + x3 + x4 + x0.x3 + x0.x4
//    y4 = x1 + x3 + x4 + x0.x1 + x1.x4
//
//  ('+' is XOR, '.' is AND)
//
//  Only 8 DISTINCT quadratic monomials appear across the five
//  outputs, so the AND-plane is shared:
//
//    x0.x1  x0.x3  x0.x4  x1.x2  x1.x3  x1.x4  x2.x3  x3.x4
//
//  Cost : 8 AND, 27 XOR, 1 NOT.  Algebraic degree 2,
//         multiplicative depth 1 (all ANDs are on primary inputs).
//
//  Bit order: x[4] is state row x0 (MSB of the S-box index),
//             x[0] is state row x4, so y == SBOX[x].
//====================================================================
`timescale 1ns/1ps
`default_nettype none

module ascon_sbox_anf (
    input  wire [4:0] x,
    output wire [4:0] y
);

    
    //----------------------------------------------------------------
    // AND-plane : the 8 shared degree-2 monomials.
    // Each is a function of primary inputs only, hence the whole
    // S-box has multiplicative depth 1.
    //----------------------------------------------------------------
    wire w1 = x[4] & x[3];
    wire w2 = x[4] & x[1];
    wire w3 = x[4] & x[0];
    wire w4 = x[3] & x[2];
    wire w5 = x[3] & x[1];
    wire w6 = x[3] & x[0];
    wire w7 = x[2] & x[1];
    wire w8 = x[1] & x[0];
	
    //----------------------------------------------------------------
    // XOR-plane : one polynomial per output bit
    //----------------------------------------------------------------
	
	wire w9 = x[4] ^ x[3];
	wire w10 = x[2] ^ x[1];
	wire w11 = x[2] ^ x[0];
	wire w12 = x[3] ^ x[1];
	wire w13 = w9 ^ w10;
	wire w14 = w13 ^ x[0];
	wire w15 = w13 ^ w1;
	wire w16 = w14 ^ w4;
	wire w17 = x[3] ^ w11;
	wire w18 = w14 ^ w2;
	wire w19 = w12 ^ x[0];
	wire w20 = w15 ^ w4;
	wire w21 = w16 ^ w5;
	wire w22 = w19 ^ w1;
    
    assign y[4] =  w20 ^ w6;
    assign y[3] =  w21 ^ w7;
    assign y[2] = ~(w17 ^ w8);   // the leading '1'
    assign y[1] =  w18 ^ w3;
    assign y[0] = w22 ^ w6;

endmodule
