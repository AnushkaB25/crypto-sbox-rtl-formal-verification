// -----------------------------------------------------------------------------
// ascon_sbox_aig.sv
//
// SystemVerilog conversion of the ABC-generated AIG netlist
// ("ascon_sbox" written by ABC on Wed Aug 05 13:20:17 2026).
//
// Pure combinational AND-inverter graph: 29 internal AND nodes, 5 outputs.
// Functionally verified against the reference ASCON 5-bit S-box with
// x[4] as MSB and x[0] as LSB (all 32 input patterns match).
// -----------------------------------------------------------------------------
module ascon_sbox_aig (
    input wire logic [4:0] x,
    output logic [4:0] y
);

  // Internal AIG nodes
  logic n10, n11, n12, n13, n14, n15, n16, n17, n18, n19;
  logic n20, n22, n23, n24, n25, n26, n27, n28, n29;
  logic n30, n31, n33, n34, n35, n37, n38, n39, n41, n42;

  // ---- y[4] ----
  assign n10 = x[4] & ~x[1];
  assign n11 = ~x[4] & x[1];
  assign n12 = ~n10 & ~n11;
  assign n13 = x[2] & ~n12;
  assign n14 = ~x[2] & n12;
  assign n15 = ~n13 & ~n14;
  assign n16 = ~x[3] & ~n15;
  assign n17 = ~x[1] & x[0];
  assign n18 = x[1] & ~x[0];
  assign n19 = ~n17 & ~n18;
  assign n20 = x[3] & ~n19;
  assign y[4]  = ~n16 & ~n20;

  // ---- y[3] ----
  assign n22 = ~x[4] & ~x[0];
  assign n23 = x[4] & x[0];
  assign n24 = ~n22 & ~n23;
  assign n25 = x[3] & x[2];
  assign n26 = x[1] & ~n25;
  assign n27 = ~x[3] & ~x[2];
  assign n28 = ~x[1] & ~n27;
  assign n29 = ~n26 & ~n28;
  assign n30 = n24 & ~n29;
  assign n31 = ~n24 & n29;
  assign y[3]  = ~n30 & ~n31;

  // ---- y[2] ----
  assign n33 = ~n25 & ~n27;
  assign n34 = ~n17 & n33;
  assign n35 = n17 & ~n33;
  assign y[2]  = ~n34 & ~n35;

  // ---- y[1] (reuses y[2]) ----
  assign n37 = ~x[4] & ~n18;
  assign n38 = y[2] & n37;
  assign n39 = n33 & ~n37;
  assign y[1]  = ~n38 & ~n39;

  // ---- y[0] ----
  assign n41 = x[3] & ~n12;
  assign n42 = ~x[3] & n19;
  assign y[0]  = ~n41 & ~n42;

endmodule

//`default_nettype wire
