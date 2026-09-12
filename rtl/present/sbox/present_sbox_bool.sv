module present_sbox_bool(
    input  wire  [3:0] x,
    output logic [3:0] y
 );
 
    wire w1,  w2,  w3,  w4,  w5,  w6,  w7,  w8;
    wire w9,  w10, w11, w12, w13, w14, w15, w16;
    wire w17, w18, w19, w20, w21, w22, w23, w24;
    wire w25, w26, w27, w28, w29, w30, w31, w32;
    
    
    assign w1 = ~(x[1] ^ x[0]);
    assign w2 = x[3] ^ x[2];
    assign w3 = x[3] & ~x[2];
    assign w4 = x[0] & w3;
    assign w5 = ~x[3] & w1;
    assign w6 = x[1] & w2;
    assign w7 = w5 | w6;
    assign y[3] = w7 | w4;
    
   // assign y[3] = (~x[3] & (x[1] ~^ x[0])) | (x[1] & (x[3] ^ x[2])) | (x[3] & ~x[2] & x[0]);
    
    assign w8  = ~x[3] & ~x[2];
    assign w9  = w8 & ~x[1];
    assign w10 = ~x[2] & x[1];
    assign w11 = w10 & ~x[0];
    assign w12 = ~x[3] & x[2];
    assign w13 = x[1] & x[0];
    assign w14 = w12 & w13;
    assign w15 = x[3] & ~x[1];
    assign w16 = x[2] | x[0];
    assign w17 = w15 & w16;
    assign w18 = w9 | w11;
    assign w19 = w14 | w17;
    assign y[2] = w18 | w19;
    
   // assign y[2] = (~x[3] & ~x[2] & ~x[1]) | (~x[2] & x[1] & ~x[0]) | (~x[3] & x[2] & x[1] & x[0]) | (x[3] & ~x[1] & (x[2] | x[0]));
   

    assign w20 = ~x[1] | ~x[0];
    assign w21 = w3 & w20;
    assign w22 = x[3] & x[2];
    assign w23 = w22 & x[0];
    assign w24 = ~x[3] & x[1];
    assign w25 = ~x[2] | ~x[0];
    assign w26 = w24 & w25;
    assign w27 = w21 | w23;
    assign y[1] = w27 | w26;
    
    // assign y[1] = (x[3] & ~x[2] & (~x[1] | ~x[0])) | (x[3] & x[2] & x[0]) | (~x[3] & x[1] & (~x[2] | ~x[0]));
     
    assign w28 = ~x[2] | x[1];
    assign w29 = x[3] ^ x[0];
    assign w30 = w28 & w29;
    assign w31 = x[2] & ~x[1];
    assign w32 = w31 & ~w29;
    assign y[0] = w30 | w32;
       
    // assign y[0] = ((~x[2] | x[1]) &  (x[3] ^ x[0])) | (x[2] & ~x[1] & (x[3] ~^ x[0]));
        
endmodule
