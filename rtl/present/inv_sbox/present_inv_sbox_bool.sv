module present_inv_sbox_bool (
    input  wire  [3:0] x,
    output logic [3:0] y
);
    
    
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10;
    wire w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21;
    wire w22, w23, w24, w25, w26, w27, w28;
    wire w29, w30, w31, w32, w33;

    assign w1  = ~x[3] & ~x[2];
    assign w2  =  x[0] |  x[1];
    assign w3  =  w1 & w2;
    assign w4  = ~x[1] & ~x[0];
    assign w5  =  x[3] ^ x[2];
    assign w6  =  w4 & w5;
    assign w7  =  x[2] & x[1];
    assign w8  =  x[0] | x[3];
    assign w9  =  w7 & w8;
    assign w10 =  w3 | w6;
    assign y[3] = w10 | w9;

    // assign y[3] = ((~x[2] & ~x[3]) & (x[0] | x[1])) | (x[2] & x[1] & (x[0] | x[3])) | (~x[0] & ~x[1] & (x[2] ^ x[3]));

    assign w11 = ~x[3] & ~x[1];
    assign w12 = ~x[2] | ~x[0];
    assign w13 =  w11 & w12;
    assign w14 = ~x[3] &  x[2];
    assign w15 =  w14 &  x[1];
    assign w16 =  x[3] & ~x[1];
    assign w17 =  w15 | w16;
    assign w18 =  x[0] & w17; 
    assign w19 = ~x[2] &  x[1];
    assign w20 =  w19 & ~x[0];
    assign w21 =  w13 | w18; 
    assign y[2] = w21 | w20;
   
   // assign y[2] = (~x[3] & ~x[1] & (~x[2] | ~x[0])) | (x[0] & ((~x[3] & x[2] & x[1] )| (x[3] & ~x[1]) )) | (~x[2] & x[1] & ~x[0]) ;
   
    assign w22 = ~(x[2] ^ x[0]);
    assign w23 =  x[3] & w22;
    assign w24 = ~(x[3] ^ x[0]);
    assign w25 =  x[1] & w24;
    assign w26 =  ~x[1] & x[0];
    assign w27 =  w1 & w26;     
    assign w28 =  w23 | w25;
    assign y[1] = w28 | w27;
    
   // assign y[1] = (x[3] & (x[2] ~^ x[0])) | (x[1] & (x[3] ~^ x[0])) | (~x[3] & ~x[2] & ~x[1] & x[0]);
   
    assign w29 = ~x[3] | ~x[1];
    assign w30 = w29 & w22;      
    assign w31 = x[2] ^ x[0];
    assign w32 = x[3] & x[1];
    assign w33 = w31 & w32;
    assign y[0] = w30 | w33;
   
   // assign y[0] = (x[2] ~^ x[0]) & (~x[3] | ~x[1]) | (x[3] & x[1] & (x[2] ^ x[0]));
   
endmodule
