// -----------------------------------------------------------------------------
// inv_aes_sbox_aig.sv  --  inverse AES S-box (InvSubBytes) as an AND-inverter graph
//
// Purely combinational and unclocked: every node is a two-input AND with
// optional input inversions. Derived from an ABC-generated AIG of the inverse
// S-box truth table, rewritten with packed vector ports.
//
//   Cost: 1082 two-input AND nodes + 8 output inversions.
//
// Port mapping. ABC named its nets MSB-first, following the PLA column order,
// so the original scalars map as:
//
//   x0 x1 x2 x3 x4 x5 x6 x7  ->  x[7] x[6] x[5] x[4] x[3] x[2] x[1] x[0]
//   z0 z1 z2 z3 z4 z5 z6 z7  ->  y[7] y[6] y[5] y[4] y[3] y[2] y[1] y[0]
//
// i.e. x[7] is the MSB of the input byte and y[7] the MSB of the output.
// Verified: y == INV_AES_SBOX[x] for all 256 values of x, checked against the
// algebraic definition s = (A^-1 * (b + 0x63))^-1 over GF(2^8), modulus 0x11B.
//
// The internal nodes are kept as individual scalar nets rather than bits of a
// packed vector. Bit-select continuous assignments onto one wide net make some
// event-driven simulators re-evaluate the whole vector per node, which turns
// this into a quadratic-event netlist and is very slow to simulate.
//
// Note: the source netlist declared its module as `inv_aes_sbox` while the file
// was named aes_inv_sbox_aig.v. This file uses `inv_aes_sbox_aig` for both.
// -----------------------------------------------------------------------------

`default_nettype none

module aes_inv_sbox_aig (
    input  logic [7:0] x,
    output logic [7:0] y
);

  // Internal AIG nodes, retaining the original ABC numbering.
  logic n16, n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28,
        n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41,
        n42, n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54,
        n55, n56, n57, n58, n59, n60, n61, n62, n63, n64, n65, n66, n67,
        n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80,
        n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93,
        n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105,
        n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
        n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
        n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
        n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
        n150, n151, n152, n153, n154, n155, n156, n157, n158, n159, n160,
        n161, n162, n163, n164, n165, n166, n167, n168, n169, n170, n171,
        n172, n173, n174, n175, n176, n177, n178, n179, n180, n181, n182,
        n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193,
        n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204,
        n205, n206, n207, n208, n209, n210, n211, n212, n213, n214, n215,
        n216, n217, n218, n219, n220, n221, n222, n223, n224, n225, n226,
        n227, n228, n229, n230, n231, n232, n233, n234, n235, n236, n237,
        n238, n239, n240, n241, n242, n243, n244, n245, n246, n247, n248,
        n249, n250, n251, n252, n253, n254, n255, n256, n257, n258, n259,
        n260, n261, n262, n263, n264, n265, n266, n267, n268, n269, n270,
        n271, n272, n273, n274, n275, n276, n277, n278, n279, n280, n281,
        n282, n283, n284, n285, n286, n287, n288, n289, n290, n291, n292,
        n293, n294, n295, n296, n297, n298, n299, n300, n301, n302, n303,
        n304, n305, n306, n307, n308, n309, n310, n311, n312, n313, n314,
        n315, n316, n317, n318, n319, n320, n321, n322, n323, n324, n325,
        n326, n327, n328, n329, n330, n331, n332, n333, n334, n335, n336,
        n337, n338, n339, n340, n341, n342, n343, n344, n345, n346, n347,
        n348, n349, n350, n351, n352, n353, n354, n355, n356, n357, n358,
        n359, n360, n361, n362, n363, n364, n365, n366, n367, n368, n369,
        n370, n371, n372, n373, n374, n375, n376, n377, n378, n379, n380,
        n381, n382, n383, n384, n385, n386, n387, n388, n389, n390, n391,
        n392, n393, n394, n395, n396, n397, n398, n399, n400, n401, n402,
        n403, n404, n405, n406, n407, n408, n409, n410, n411, n412, n413,
        n414, n415, n416, n417, n418, n419, n420, n421, n422, n423, n424,
        n425, n426, n427, n428, n429, n430, n431, n432, n433, n434, n435,
        n436, n437, n438, n439, n440, n441, n442, n443, n444, n445, n446,
        n447, n448, n449, n450, n451, n452, n453, n454, n455, n456, n457,
        n458, n459, n460, n461, n462, n463, n464, n465, n466, n467, n468,
        n469, n470, n471, n472, n473, n474, n475, n476, n477, n478, n479,
        n480, n481, n482, n483, n484, n485, n486, n487, n488, n489, n490,
        n491, n492, n493, n494, n495, n496, n497, n498, n499, n500, n501,
        n502, n503, n504, n505, n506, n507, n508, n509, n510, n511, n512,
        n513, n514, n515, n516, n517, n518, n519, n520, n521, n522, n523,
        n524, n525, n526, n527, n528, n529, n530, n531, n532, n533, n534,
        n535, n536, n537, n538, n539, n540, n541, n542, n543, n544, n545,
        n546, n547, n548, n549, n550, n551, n552, n553, n554, n555, n556,
        n557, n558, n559, n560, n561, n562, n563, n564, n565, n566, n567,
        n568, n569, n570, n571, n572, n573, n574, n575, n576, n577, n578,
        n579, n580, n581, n582, n583, n584, n585, n586, n587, n588, n589,
        n590, n591, n592, n593, n594, n595, n596, n597, n598, n599, n600,
        n601, n602, n603, n604, n605, n606, n607, n608, n609, n610, n611,
        n612, n613, n614, n615, n616, n617, n618, n619, n620, n621, n622,
        n623, n624, n625, n626, n627, n628, n629, n630, n631, n632, n633,
        n634, n635, n636, n637, n638, n639, n640, n641, n642, n643, n644,
        n645, n646, n647, n648, n649, n650, n651, n652, n653, n654, n655,
        n656, n657, n658, n659, n660, n661, n662, n663, n664, n665, n666,
        n667, n668, n669, n670, n671, n672, n673, n674, n675, n676, n677,
        n678, n679, n680, n681, n682, n683, n684, n685, n686, n687, n688,
        n689, n690, n691, n692, n693, n694, n695, n696, n697, n698, n699,
        n700, n701, n702, n703, n704, n705, n706, n707, n708, n709, n710,
        n711, n712, n713, n714, n715, n716, n717, n718, n719, n720, n721,
        n722, n723, n724, n725, n726, n727, n728, n729, n730, n731, n732,
        n733, n734, n735, n736, n737, n738, n739, n740, n741, n742, n743,
        n744, n745, n746, n747, n748, n749, n750, n751, n752, n753, n754,
        n755, n756, n757, n758, n759, n760, n761, n762, n763, n764, n765,
        n766, n767, n768, n769, n770, n771, n772, n773, n774, n775, n776,
        n777, n778, n779, n780, n781, n782, n783, n784, n785, n786, n787,
        n788, n789, n790, n791, n792, n793, n794, n795, n796, n797, n798,
        n799, n800, n801, n802, n803, n804, n805, n806, n807, n808, n809,
        n810, n811, n812, n813, n814, n815, n816, n817, n818, n819, n820,
        n821, n822, n823, n824, n825, n826, n827, n828, n829, n830, n831,
        n832, n833, n834, n835, n836, n837, n838, n839, n840, n841, n842,
        n843, n844, n845, n846, n847, n848, n849, n850, n851, n852, n853,
        n854, n855, n856, n857, n858, n859, n860, n861, n862, n863, n864,
        n865, n866, n867, n868, n869, n870, n871, n872, n873, n874, n875,
        n876, n877, n878, n879, n880, n881, n882, n883, n884, n885, n886,
        n887, n888, n889, n890, n891, n892, n893, n894, n895, n896, n897,
        n898, n899, n900, n901, n902, n903, n904, n905, n906, n907, n908,
        n909, n910, n911, n912, n913, n914, n915, n916, n917, n918, n919,
        n920, n921, n922, n923, n924, n925, n926, n927, n928, n929, n930,
        n931, n932, n933, n934, n935, n936, n937, n938, n939, n940, n941,
        n942, n943, n944, n945, n946, n947, n948, n949, n950, n951, n952,
        n953, n954, n955, n956, n957, n958, n959, n960, n961, n962, n963,
        n964, n965, n966, n967, n968, n969, n970, n971, n972, n973, n974,
        n975, n976, n977, n978, n979, n980, n981, n982, n983, n984, n985,
        n986, n987, n988, n989, n990, n991, n992, n993, n994, n995, n996,
        n997, n998, n999, n1000, n1001, n1002, n1003, n1004, n1005, n1006,
        n1007, n1008, n1009, n1010, n1011, n1012, n1013, n1014, n1015,
        n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023, n1024,
        n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032, n1033,
        n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042,
        n1043, n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051,
        n1052, n1053, n1054, n1055, n1056, n1057, n1058, n1059, n1060,
        n1061, n1062, n1063, n1064, n1065, n1066, n1067, n1068, n1069,
        n1070, n1071, n1072, n1073, n1074, n1075, n1076, n1077, n1078,
        n1079, n1080, n1081, n1082, n1083, n1084, n1085, n1086, n1087,
        n1088, n1089, n1090, n1091, n1092, n1093, n1094, n1095, n1096, n1097;

  // ---- AND-inverter nodes ----
  assign n16     = ~x[6] & x[5];
  assign n17     = x[6] & ~x[5];
  assign n18     = ~n16 & ~n17;
  assign n19     = ~x[6] & x[2];
  assign n20     = x[6] & ~x[2];
  assign n21     = ~n19 & ~n20;
  assign n22     = x[7] & n21;
  assign n23     = ~n18 & n22;
  assign n24     = x[5] & x[2];
  assign n25     = ~x[5] & ~x[2];
  assign n26     = ~n24 & ~n25;
  assign n27     = x[6] & n26;
  assign n28     = ~n19 & ~n27;
  assign n29     = ~x[7] & ~n28;
  assign n30     = ~n23 & ~n29;
  assign n31     = x[3] & ~n30;
  assign n32     = ~x[7] & x[6];
  assign n33     = ~x[3] & x[2];
  assign n34     = ~x[5] & n33;
  assign n35     = n32 & n34;
  assign n36     = x[4] & ~n35;
  assign n37     = ~n31 & n36;
  assign n38     = ~x[7] & n19;
  assign n39     = x[7] & x[6];
  assign n40     = n26 & n39;
  assign n41     = ~n38 & ~n40;
  assign n42     = x[3] & ~n41;
  assign n43     = ~x[7] & ~x[3];
  assign n44     = x[7] & x[3];
  assign n45     = ~n43 & ~n44;
  assign n46     = x[7] & ~x[6];
  assign n47     = ~n32 & ~n46;
  assign n48     = n18 & ~n47;
  assign n49     = ~n45 & n48;
  assign n50     = x[6] & ~x[3];
  assign n51     = n25 & n50;
  assign n52     = ~x[4] & ~n51;
  assign n53     = ~n49 & n52;
  assign n54     = ~n42 & n53;
  assign n55     = ~x[1] & x[0];
  assign n56     = x[1] & ~x[0];
  assign n57     = ~n55 & ~n56;
  assign n58     = ~n54 & ~n57;
  assign n59     = ~n37 & n58;
  assign n60     = x[5] & x[4];
  assign n61     = ~x[5] & ~x[4];
  assign n62     = ~x[6] & ~n61;
  assign n63     = n55 & ~n60;
  assign n64     = n62 & n63;
  assign n65     = ~x[4] & x[0];
  assign n66     = x[4] & ~x[0];
  assign n67     = ~n65 & ~n66;
  assign n68     = x[6] & n67;
  assign n69     = x[5] & ~x[1];
  assign n70     = ~x[5] & x[1];
  assign n71     = ~n69 & ~n70;
  assign n72     = n57 & ~n71;
  assign n73     = n68 & n72;
  assign n74     = x[7] & ~n64;
  assign n75     = ~n73 & n74;
  assign n76     = x[5] & x[0];
  assign n77     = ~x[5] & ~x[0];
  assign n78     = ~n76 & ~n77;
  assign n79     = n71 & n78;
  assign n80     = n62 & n79;
  assign n81     = ~x[1] & ~x[0];
  assign n82     = x[5] & ~x[4];
  assign n83     = x[6] & n82;
  assign n84     = n81 & n83;
  assign n85     = ~x[7] & ~n84;
  assign n86     = ~n80 & n85;
  assign n87     = ~n75 & ~n86;
  assign n88     = ~x[2] & ~n87;
  assign n89     = x[7] & n16;
  assign n90     = x[4] & ~x[1];
  assign n91     = x[0] & n90;
  assign n92     = n89 & n91;
  assign n93     = ~x[4] & ~x[0];
  assign n94     = ~x[7] & n71;
  assign n95     = x[5] & x[1];
  assign n96     = ~n32 & ~n95;
  assign n97     = n93 & ~n96;
  assign n98     = ~n94 & n97;
  assign n99     = x[2] & ~n92;
  assign n100    = ~n98 & n99;
  assign n101    = ~n88 & ~n100;
  assign n102    = x[1] & x[0];
  assign n103    = ~n81 & ~n102;
  assign n104    = ~x[4] & ~x[3];
  assign n105    = ~x[5] & ~n104;
  assign n106    = x[4] & x[2];
  assign n107    = ~x[4] & ~x[2];
  assign n108    = ~n106 & ~n107;
  assign n109    = ~x[6] & ~x[4];
  assign n110    = n108 & ~n109;
  assign n111    = n105 & ~n110;
  assign n112    = x[6] & x[5];
  assign n113    = ~x[3] & ~x[2];
  assign n114    = x[4] & n113;
  assign n115    = n112 & n114;
  assign n116    = ~x[7] & ~n115;
  assign n117    = ~n111 & n116;
  assign n118    = ~x[6] & ~x[5];
  assign n119    = x[4] & ~x[3];
  assign n120    = n118 & n119;
  assign n121    = x[4] & x[3];
  assign n122    = ~n104 & ~n121;
  assign n123    = ~x[5] & ~x[3];
  assign n124    = x[5] & x[3];
  assign n125    = ~n123 & ~n124;
  assign n126    = x[6] & n125;
  assign n127    = ~n122 & n126;
  assign n128    = ~n120 & ~n127;
  assign n129    = x[2] & ~n128;
  assign n130    = ~x[6] & x[3];
  assign n131    = ~x[2] & n130;
  assign n132    = ~n82 & n131;
  assign n133    = x[7] & ~n132;
  assign n134    = ~n129 & n133;
  assign n135    = ~n103 & ~n117;
  assign n136    = ~n134 & n135;
  assign n137    = ~x[7] & x[4];
  assign n138    = x[2] & ~x[1];
  assign n139    = ~n137 & ~n138;
  assign n140    = ~x[2] & x[1];
  assign n141    = ~n138 & ~n140;
  assign n142    = x[7] & ~x[4];
  assign n143    = ~n141 & ~n142;
  assign n144    = n124 & ~n139;
  assign n145    = ~n143 & n144;
  assign n146    = ~x[7] & ~x[2];
  assign n147    = ~n60 & ~n61;
  assign n148    = x[3] & x[2];
  assign n149    = ~n113 & ~n148;
  assign n150    = x[7] & x[2];
  assign n151    = x[1] & ~n150;
  assign n152    = ~n146 & ~n151;
  assign n153    = ~n147 & n149;
  assign n154    = n152 & n153;
  assign n155    = ~x[0] & ~n154;
  assign n156    = ~n145 & n155;
  assign n157    = x[5] & n113;
  assign n158    = x[3] & ~x[2];
  assign n159    = ~n33 & ~n158;
  assign n160    = x[4] & ~n159;
  assign n161    = ~n157 & ~n160;
  assign n162    = x[7] & ~n60;
  assign n163    = ~n161 & n162;
  assign n164    = ~x[7] & ~x[4];
  assign n165    = ~x[5] & x[2];
  assign n166    = x[3] & n164;
  assign n167    = ~n165 & n166;
  assign n168    = ~n163 & ~n167;
  assign n169    = ~x[1] & ~n168;
  assign n170    = n61 & n148;
  assign n171    = ~x[7] & x[1];
  assign n172    = n170 & n171;
  assign n173    = x[0] & ~n172;
  assign n174    = ~n169 & n173;
  assign n175    = x[6] & ~n156;
  assign n176    = ~n174 & n175;
  assign n177    = x[3] & ~x[1];
  assign n178    = ~x[3] & x[1];
  assign n179    = ~n177 & ~n178;
  assign n180    = x[7] & ~n179;
  assign n181    = ~n70 & n103;
  assign n182    = n180 & ~n181;
  assign n183    = ~x[5] & n56;
  assign n184    = ~n69 & ~n183;
  assign n185    = n43 & ~n184;
  assign n186    = x[2] & ~n182;
  assign n187    = ~n185 & n186;
  assign n188    = x[5] & n177;
  assign n189    = ~n70 & ~n188;
  assign n190    = x[3] & x[0];
  assign n191    = ~x[3] & ~x[0];
  assign n192    = ~n190 & ~n191;
  assign n193    = ~x[7] & n192;
  assign n194    = ~n189 & n193;
  assign n195    = x[7] & ~x[5];
  assign n196    = ~x[3] & n195;
  assign n197    = n55 & n196;
  assign n198    = ~x[2] & ~n197;
  assign n199    = ~n194 & n198;
  assign n200    = ~n187 & ~n199;
  assign n201    = ~x[4] & ~n200;
  assign n202    = x[1] & ~n78;
  assign n203    = ~n45 & n202;
  assign n204    = ~x[3] & ~x[1];
  assign n205    = ~x[7] & ~n76;
  assign n206    = x[7] & ~n78;
  assign n207    = n204 & ~n205;
  assign n208    = ~n206 & n207;
  assign n209    = ~n203 & ~n208;
  assign n210    = x[2] & ~n209;
  assign n211    = ~x[7] & x[5];
  assign n212    = x[7] & x[1];
  assign n213    = ~x[7] & ~x[1];
  assign n214    = ~n212 & ~n213;
  assign n215    = n113 & ~n211;
  assign n216    = n214 & n215;
  assign n217    = ~n103 & n216;
  assign n218    = x[4] & ~n217;
  assign n219    = ~n210 & n218;
  assign n220    = ~x[6] & ~n219;
  assign n221    = ~n201 & n220;
  assign n222    = ~n101 & ~n136;
  assign n223    = ~n59 & n222;
  assign n224    = ~n176 & ~n221;
  assign n225    = n223 & n224;
  assign n226    = ~x[6] & x[0];
  assign n227    = x[6] & ~x[0];
  assign n228    = ~n226 & ~n227;
  assign n229    = n67 & ~n228;
  assign n230    = n202 & n229;
  assign n231    = x[0] & n112;
  assign n232    = ~n77 & ~n231;
  assign n233    = x[4] & ~n232;
  assign n234    = n18 & ~n78;
  assign n235    = ~x[4] & ~n234;
  assign n236    = ~x[1] & ~n233;
  assign n237    = ~n235 & n236;
  assign n238    = x[3] & ~n230;
  assign n239    = ~n237 & n238;
  assign n240    = n61 & ~n81;
  assign n241    = x[5] & n90;
  assign n242    = ~n240 & ~n241;
  assign n243    = ~x[6] & ~n242;
  assign n244    = n90 & n231;
  assign n245    = ~x[3] & ~n244;
  assign n246    = ~n243 & n245;
  assign n247    = x[7] & ~n246;
  assign n248    = ~n239 & n247;
  assign n249    = x[6] & ~x[1];
  assign n250    = ~x[6] & x[1];
  assign n251    = x[4] & ~n250;
  assign n252    = ~n249 & n251;
  assign n253    = n234 & n252;
  assign n254    = ~n76 & ~n249;
  assign n255    = ~x[4] & ~n112;
  assign n256    = ~n254 & n255;
  assign n257    = ~n253 & ~n256;
  assign n258    = x[3] & ~n257;
  assign n259    = x[6] & n119;
  assign n260    = ~n76 & n259;
  assign n261    = ~n103 & n260;
  assign n262    = ~n258 & ~n261;
  assign n263    = ~x[7] & ~n262;
  assign n264    = ~n248 & ~n263;
  assign n265    = x[2] & ~n264;
  assign n266    = n19 & n190;
  assign n267    = x[2] & ~x[0];
  assign n268    = ~x[2] & x[0];
  assign n269    = ~n267 & ~n268;
  assign n270    = ~x[3] & ~n19;
  assign n271    = n269 & n270;
  assign n272    = ~n266 & ~n271;
  assign n273    = ~x[5] & ~n272;
  assign n274    = ~n26 & n192;
  assign n275    = ~n21 & n274;
  assign n276    = x[6] & x[0];
  assign n277    = ~x[2] & n124;
  assign n278    = ~n276 & n277;
  assign n279    = ~x[7] & ~n278;
  assign n280    = ~n275 & n279;
  assign n281    = ~n273 & n280;
  assign n282    = ~x[3] & n267;
  assign n283    = n118 & n282;
  assign n284    = x[6] & ~n125;
  assign n285    = ~x[6] & n125;
  assign n286    = ~n284 & ~n285;
  assign n287    = ~x[2] & ~n77;
  assign n288    = ~n286 & n287;
  assign n289    = x[7] & ~n283;
  assign n290    = ~n288 & n289;
  assign n291    = ~x[1] & ~n290;
  assign n292    = ~n281 & n291;
  assign n293    = ~x[3] & ~n269;
  assign n294    = x[3] & n21;
  assign n295    = n228 & n294;
  assign n296    = ~n293 & ~n295;
  assign n297    = x[7] & ~n296;
  assign n298    = ~x[7] & ~x[6];
  assign n299    = x[3] & n267;
  assign n300    = n298 & n299;
  assign n301    = x[5] & ~n300;
  assign n302    = ~n297 & n301;
  assign n303    = x[7] & ~x[2];
  assign n304    = ~n33 & ~n303;
  assign n305    = ~n21 & n304;
  assign n306    = ~x[6] & ~x[3];
  assign n307    = ~n192 & ~n306;
  assign n308    = n22 & n307;
  assign n309    = ~x[5] & ~n305;
  assign n310    = ~n308 & n309;
  assign n311    = x[1] & ~n310;
  assign n312    = ~n302 & n311;
  assign n313    = ~n83 & ~n120;
  assign n314    = ~x[7] & ~n313;
  assign n315    = n89 & n121;
  assign n316    = ~n314 & ~n315;
  assign n317    = n141 & ~n269;
  assign n318    = ~n316 & n317;
  assign n319    = x[3] & x[1];
  assign n320    = ~x[4] & n319;
  assign n321    = x[4] & ~n179;
  assign n322    = ~n320 & ~n321;
  assign n323    = ~x[5] & ~n322;
  assign n324    = ~x[4] & ~x[1];
  assign n325    = n124 & n324;
  assign n326    = ~n323 & ~n325;
  assign n327    = ~x[6] & ~n326;
  assign n328    = ~x[5] & x[4];
  assign n329    = x[6] & n328;
  assign n330    = ~n177 & n329;
  assign n331    = x[7] & ~n330;
  assign n332    = ~n327 & n331;
  assign n333    = ~x[6] & n70;
  assign n334    = ~n122 & n333;
  assign n335    = x[6] & x[4];
  assign n336    = ~n109 & ~n335;
  assign n337    = ~n319 & n336;
  assign n338    = x[6] & ~x[4];
  assign n339    = ~n204 & ~n338;
  assign n340    = x[5] & ~n339;
  assign n341    = ~n337 & n340;
  assign n342    = ~x[7] & ~n334;
  assign n343    = ~n341 & n342;
  assign n344    = ~x[0] & ~n343;
  assign n345    = ~n332 & n344;
  assign n346    = n109 & n178;
  assign n347    = ~x[4] & x[1];
  assign n348    = ~n90 & ~n347;
  assign n349    = ~n39 & ~n348;
  assign n350    = ~n298 & n348;
  assign n351    = x[3] & ~n349;
  assign n352    = ~n350 & n351;
  assign n353    = ~x[5] & ~n346;
  assign n354    = ~n352 & n353;
  assign n355    = x[4] & ~n45;
  assign n356    = n250 & n355;
  assign n357    = ~n39 & ~n298;
  assign n358    = ~n121 & ~n204;
  assign n359    = ~n90 & ~n358;
  assign n360    = ~n357 & n359;
  assign n361    = x[5] & ~n360;
  assign n362    = ~n356 & n361;
  assign n363    = x[0] & ~n362;
  assign n364    = ~n354 & n363;
  assign n365    = ~n345 & ~n364;
  assign n366    = ~x[2] & ~n365;
  assign n367    = ~n292 & ~n318;
  assign n368    = ~n312 & n367;
  assign n369    = ~n265 & n368;
  assign n370    = ~n366 & n369;
  assign n371    = ~x[7] & n204;
  assign n372    = n61 & n371;
  assign n373    = x[5] & n121;
  assign n374    = ~n61 & ~n373;
  assign n375    = n212 & ~n374;
  assign n376    = x[2] & ~n372;
  assign n377    = ~n375 & n376;
  assign n378    = n125 & n355;
  assign n379    = ~n180 & ~n371;
  assign n380    = n82 & ~n379;
  assign n381    = ~x[2] & ~n378;
  assign n382    = ~n380 & n381;
  assign n383    = x[0] & ~n377;
  assign n384    = ~n382 & n383;
  assign n385    = x[5] & ~n149;
  assign n386    = ~n34 & ~n385;
  assign n387    = n90 & ~n386;
  assign n388    = x[7] & ~n170;
  assign n389    = ~n387 & n388;
  assign n390    = n160 & ~n179;
  assign n391    = x[4] & ~n69;
  assign n392    = n33 & ~n391;
  assign n393    = ~x[7] & ~n392;
  assign n394    = ~n390 & n393;
  assign n395    = ~x[0] & ~n394;
  assign n396    = ~n389 & n395;
  assign n397    = ~n384 & ~n396;
  assign n398    = ~x[6] & ~n397;
  assign n399    = ~x[5] & ~n122;
  assign n400    = x[5] & ~n104;
  assign n401    = n46 & ~n400;
  assign n402    = ~n399 & n401;
  assign n403    = x[6] & n122;
  assign n404    = n125 & ~n142;
  assign n405    = n403 & n404;
  assign n406    = ~n402 & ~n405;
  assign n407    = ~x[1] & ~n406;
  assign n408    = ~n137 & ~n142;
  assign n409    = n95 & ~n130;
  assign n410    = n408 & n409;
  assign n411    = n47 & n410;
  assign n412    = ~n407 & ~n411;
  assign n413    = x[0] & ~n412;
  assign n414    = x[7] & ~x[0];
  assign n415    = ~x[5] & n338;
  assign n416    = n177 & n415;
  assign n417    = x[5] & ~x[3];
  assign n418    = n358 & ~n417;
  assign n419    = n62 & n418;
  assign n420    = ~n416 & ~n419;
  assign n421    = n414 & ~n420;
  assign n422    = n25 & n204;
  assign n423    = x[0] & n422;
  assign n424    = ~x[0] & ~n149;
  assign n425    = ~n189 & n424;
  assign n426    = ~n423 & ~n425;
  assign n427    = ~x[7] & ~n426;
  assign n428    = ~n125 & n268;
  assign n429    = x[5] & n282;
  assign n430    = ~n428 & ~n429;
  assign n431    = n212 & ~n430;
  assign n432    = ~n427 & ~n431;
  assign n433    = n336 & ~n432;
  assign n434    = x[7] & n319;
  assign n435    = n112 & n434;
  assign n436    = ~n50 & ~n130;
  assign n437    = n18 & ~n436;
  assign n438    = ~n357 & n437;
  assign n439    = ~x[1] & ~n357;
  assign n440    = x[1] & n357;
  assign n441    = n123 & ~n439;
  assign n442    = ~n440 & n441;
  assign n443    = ~x[4] & ~n435;
  assign n444    = ~n438 & n443;
  assign n445    = ~n442 & n444;
  assign n446    = n16 & n178;
  assign n447    = ~x[5] & x[3];
  assign n448    = ~x[6] & n447;
  assign n449    = ~n284 & ~n448;
  assign n450    = x[7] & ~x[1];
  assign n451    = ~n449 & n450;
  assign n452    = x[4] & ~n446;
  assign n453    = ~n451 & n452;
  assign n454    = ~n445 & ~n453;
  assign n455    = n328 & n434;
  assign n456    = n124 & n348;
  assign n457    = n204 & n328;
  assign n458    = ~n456 & ~n457;
  assign n459    = ~x[7] & ~n458;
  assign n460    = ~n455 & ~n459;
  assign n461    = ~n454 & n460;
  assign n462    = n269 & ~n461;
  assign n463    = ~x[7] & n267;
  assign n464    = ~n303 & ~n463;
  assign n465    = x[4] & ~n464;
  assign n466    = n164 & n268;
  assign n467    = ~n465 & ~n466;
  assign n468    = ~x[3] & ~n467;
  assign n469    = n142 & n299;
  assign n470    = ~n468 & ~n469;
  assign n471    = x[1] & ~n470;
  assign n472    = x[3] & ~n464;
  assign n473    = ~x[7] & n293;
  assign n474    = ~n472 & ~n473;
  assign n475    = n90 & ~n474;
  assign n476    = ~x[5] & ~n475;
  assign n477    = ~n471 & n476;
  assign n478    = n56 & n104;
  assign n479    = n146 & n478;
  assign n480    = ~x[7] & x[2];
  assign n481    = ~n303 & ~n480;
  assign n482    = ~x[3] & x[0];
  assign n483    = ~x[4] & n482;
  assign n484    = ~n481 & n483;
  assign n485    = n146 & n190;
  assign n486    = x[7] & ~n269;
  assign n487    = ~n159 & n486;
  assign n488    = ~n484 & ~n485;
  assign n489    = ~n487 & n488;
  assign n490    = ~x[1] & ~n489;
  assign n491    = x[5] & ~n479;
  assign n492    = ~n490 & n491;
  assign n493    = x[6] & ~n492;
  assign n494    = ~n477 & n493;
  assign n495    = ~n413 & ~n421;
  assign n496    = ~n433 & n495;
  assign n497    = ~n398 & ~n462;
  assign n498    = n496 & n497;
  assign n499    = ~n494 & n498;
  assign n500    = x[1] & ~n67;
  assign n501    = x[4] & n191;
  assign n502    = ~n500 & ~n501;
  assign n503    = n480 & ~n502;
  assign n504    = ~x[7] & x[0];
  assign n505    = n108 & ~n504;
  assign n506    = x[4] & ~x[2];
  assign n507    = ~n414 & ~n506;
  assign n508    = ~x[1] & ~n507;
  assign n509    = ~n505 & n508;
  assign n510    = n66 & n212;
  assign n511    = n65 & n213;
  assign n512    = ~x[3] & ~n511;
  assign n513    = ~n510 & n512;
  assign n514    = x[4] & ~n450;
  assign n515    = n57 & n514;
  assign n516    = n103 & n142;
  assign n517    = x[3] & ~n516;
  assign n518    = ~n515 & n517;
  assign n519    = ~x[2] & ~n513;
  assign n520    = ~n518 & n519;
  assign n521    = ~n503 & ~n509;
  assign n522    = ~n520 & n521;
  assign n523    = x[6] & ~n522;
  assign n524    = ~x[3] & n303;
  assign n525    = ~n480 & ~n524;
  assign n526    = ~n119 & ~n525;
  assign n527    = x[0] & ~n526;
  assign n528    = ~x[2] & n45;
  assign n529    = n44 & n106;
  assign n530    = ~x[0] & ~n529;
  assign n531    = ~n528 & n530;
  assign n532    = ~x[6] & ~x[1];
  assign n533    = ~n531 & n532;
  assign n534    = ~n527 & n533;
  assign n535    = ~n523 & ~n534;
  assign n536    = ~x[5] & ~n535;
  assign n537    = ~x[0] & n347;
  assign n538    = ~n191 & ~n347;
  assign n539    = ~x[6] & ~n537;
  assign n540    = ~n538 & n539;
  assign n541    = n67 & ~n103;
  assign n542    = n403 & n541;
  assign n543    = ~n540 & ~n542;
  assign n544    = ~x[5] & ~n543;
  assign n545    = n102 & n306;
  assign n546    = n82 & n545;
  assign n547    = ~n544 & ~n546;
  assign n548    = ~x[7] & ~n547;
  assign n549    = ~n414 & ~n504;
  assign n550    = x[6] & n159;
  assign n551    = x[6] & x[1];
  assign n552    = ~n113 & ~n551;
  assign n553    = x[5] & ~n552;
  assign n554    = ~n550 & n553;
  assign n555    = ~x[5] & n179;
  assign n556    = ~n21 & n141;
  assign n557    = n555 & n556;
  assign n558    = ~n554 & ~n557;
  assign n559    = ~x[4] & ~n558;
  assign n560    = x[5] & ~x[2];
  assign n561    = ~n249 & ~n250;
  assign n562    = x[4] & ~n436;
  assign n563    = n560 & n561;
  assign n564    = n562 & n563;
  assign n565    = ~n559 & ~n564;
  assign n566    = n549 & ~n565;
  assign n567    = ~x[6] & x[4];
  assign n568    = ~n338 & ~n567;
  assign n569    = n69 & n192;
  assign n570    = ~n183 & ~n569;
  assign n571    = n408 & ~n568;
  assign n572    = ~n570 & n571;
  assign n573    = n190 & n567;
  assign n574    = ~x[0] & ~n130;
  assign n575    = n336 & n574;
  assign n576    = ~n573 & ~n575;
  assign n577    = x[1] & ~n576;
  assign n578    = ~x[1] & ~n228;
  assign n579    = n122 & ~n336;
  assign n580    = n578 & n579;
  assign n581    = ~n577 & ~n580;
  assign n582    = x[5] & ~n581;
  assign n583    = ~n66 & n177;
  assign n584    = ~x[6] & ~n583;
  assign n585    = ~n478 & n584;
  assign n586    = ~x[4] & n102;
  assign n587    = x[4] & n192;
  assign n588    = ~n57 & n587;
  assign n589    = x[6] & ~n586;
  assign n590    = ~n588 & n589;
  assign n591    = ~x[5] & ~n585;
  assign n592    = ~n590 & n591;
  assign n593    = ~n582 & ~n592;
  assign n594    = x[7] & ~n593;
  assign n595    = n109 & ~n149;
  assign n596    = ~x[6] & ~n148;
  assign n597    = x[4] & ~n596;
  assign n598    = ~n550 & n597;
  assign n599    = x[7] & ~n595;
  assign n600    = ~n598 & n599;
  assign n601    = x[6] & ~n506;
  assign n602    = ~x[6] & n108;
  assign n603    = x[3] & ~n601;
  assign n604    = ~n602 & n603;
  assign n605    = ~x[7] & ~n604;
  assign n606    = ~x[0] & ~n600;
  assign n607    = ~n605 & n606;
  assign n608    = n119 & n298;
  assign n609    = n44 & n568;
  assign n610    = ~n608 & ~n609;
  assign n611    = x[2] & x[0];
  assign n612    = ~n610 & n611;
  assign n613    = ~n607 & ~n612;
  assign n614    = x[1] & ~n613;
  assign n615    = ~x[7] & n482;
  assign n616    = ~n108 & n615;
  assign n617    = n45 & n108;
  assign n618    = ~n192 & n617;
  assign n619    = ~x[6] & ~n616;
  assign n620    = ~n618 & n619;
  assign n621    = ~x[7] & ~n158;
  assign n622    = n269 & n621;
  assign n623    = ~n483 & n622;
  assign n624    = x[4] & ~n192;
  assign n625    = ~x[4] & ~n190;
  assign n626    = n150 & ~n625;
  assign n627    = ~n624 & n626;
  assign n628    = x[6] & ~n627;
  assign n629    = ~n623 & n628;
  assign n630    = ~x[1] & ~n620;
  assign n631    = ~n629 & n630;
  assign n632    = ~n614 & ~n631;
  assign n633    = x[5] & ~n632;
  assign n634    = ~n548 & ~n572;
  assign n635    = ~n566 & n634;
  assign n636    = ~n594 & n635;
  assign n637    = ~n536 & n636;
  assign n638    = ~n633 & n637;
  assign n639    = n45 & ~n55;
  assign n640    = n624 & ~n639;
  assign n641    = ~x[7] & ~n179;
  assign n642    = ~n434 & ~n641;
  assign n643    = ~x[0] & ~n642;
  assign n644    = n43 & n55;
  assign n645    = ~n643 & ~n644;
  assign n646    = ~x[4] & ~n645;
  assign n647    = ~n640 & ~n646;
  assign n648    = ~x[5] & ~n647;
  assign n649    = ~x[7] & ~n66;
  assign n650    = n569 & n649;
  assign n651    = ~n164 & ~n328;
  assign n652    = ~n82 & n651;
  assign n653    = ~n103 & n179;
  assign n654    = n652 & n653;
  assign n655    = ~n650 & ~n654;
  assign n656    = ~n648 & n655;
  assign n657    = n21 & ~n656;
  assign n658    = ~n500 & ~n567;
  assign n659    = ~x[7] & ~n250;
  assign n660    = ~n658 & n659;
  assign n661    = x[7] & n348;
  assign n662    = x[4] & x[0];
  assign n663    = ~n227 & ~n662;
  assign n664    = n661 & n663;
  assign n665    = ~n660 & ~n664;
  assign n666    = ~x[3] & ~n665;
  assign n667    = ~x[0] & n44;
  assign n668    = ~n249 & n667;
  assign n669    = ~n251 & n668;
  assign n670    = x[2] & ~n669;
  assign n671    = ~n666 & n670;
  assign n672    = x[0] & n408;
  assign n673    = n348 & n672;
  assign n674    = ~n414 & ~n673;
  assign n675    = ~x[6] & ~n179;
  assign n676    = ~n674 & n675;
  assign n677    = ~n44 & ~n615;
  assign n678    = n324 & ~n677;
  assign n679    = n500 & n549;
  assign n680    = ~n678 & ~n679;
  assign n681    = x[6] & ~n680;
  assign n682    = ~x[2] & ~n676;
  assign n683    = ~n681 & n682;
  assign n684    = x[5] & ~n683;
  assign n685    = ~n671 & n684;
  assign n686    = x[2] & ~n71;
  assign n687    = x[5] & n55;
  assign n688    = ~n686 & ~n687;
  assign n689    = x[3] & ~n688;
  assign n690    = n34 & n55;
  assign n691    = ~x[6] & ~n690;
  assign n692    = ~n689 & n691;
  assign n693    = ~x[2] & ~x[1];
  assign n694    = ~n123 & n693;
  assign n695    = ~n78 & n694;
  assign n696    = ~n33 & ~n191;
  assign n697    = ~n267 & ~n417;
  assign n698    = ~n696 & ~n697;
  assign n699    = n696 & n697;
  assign n700    = x[1] & ~n699;
  assign n701    = ~n698 & n700;
  assign n702    = x[6] & ~n695;
  assign n703    = ~n701 & n702;
  assign n704    = ~n692 & ~n703;
  assign n705    = x[4] & ~n704;
  assign n706    = ~x[3] & n138;
  assign n707    = ~n140 & ~n706;
  assign n708    = x[5] & n227;
  assign n709    = ~n707 & n708;
  assign n710    = n124 & ~n693;
  assign n711    = x[1] & n33;
  assign n712    = ~n710 & ~n711;
  assign n713    = ~x[6] & ~n712;
  assign n714    = n20 & n555;
  assign n715    = ~n713 & ~n714;
  assign n716    = x[0] & ~n715;
  assign n717    = ~x[4] & ~n709;
  assign n718    = ~n716 & n717;
  assign n719    = ~n705 & ~n718;
  assign n720    = x[1] & n268;
  assign n721    = ~n267 & ~n720;
  assign n722    = x[6] & ~n721;
  assign n723    = n226 & n693;
  assign n724    = ~n722 & ~n723;
  assign n725    = x[4] & ~n724;
  assign n726    = ~n21 & n93;
  assign n727    = ~n725 & ~n726;
  assign n728    = x[7] & ~n727;
  assign n729    = ~n249 & ~n267;
  assign n730    = x[6] & ~n269;
  assign n731    = n137 & ~n729;
  assign n732    = ~n730 & n731;
  assign n733    = ~n728 & ~n732;
  assign n734    = ~x[3] & ~n733;
  assign n735    = x[7] & x[4];
  assign n736    = ~x[7] & n93;
  assign n737    = ~n735 & ~n736;
  assign n738    = n140 & ~n737;
  assign n739    = x[6] & ~n738;
  assign n740    = n146 & n586;
  assign n741    = x[7] & n66;
  assign n742    = ~n504 & ~n741;
  assign n743    = x[2] & ~n348;
  assign n744    = ~n742 & n743;
  assign n745    = ~x[6] & ~n740;
  assign n746    = ~n744 & n745;
  assign n747    = x[3] & ~n739;
  assign n748    = ~n746 & n747;
  assign n749    = ~n734 & ~n748;
  assign n750    = ~x[5] & ~n749;
  assign n751    = ~n685 & ~n719;
  assign n752    = ~n657 & n751;
  assign n753    = ~n750 & n752;
  assign n754    = n122 & ~n298;
  assign n755    = ~n39 & ~n122;
  assign n756    = ~x[0] & ~n754;
  assign n757    = ~n755 & n756;
  assign n758    = x[0] & n119;
  assign n759    = n46 & n758;
  assign n760    = ~n757 & ~n759;
  assign n761    = ~x[2] & ~n760;
  assign n762    = n39 & n483;
  assign n763    = ~x[7] & ~x[0];
  assign n764    = n562 & n763;
  assign n765    = ~x[6] & n65;
  assign n766    = ~n68 & ~n765;
  assign n767    = x[2] & n43;
  assign n768    = ~n766 & n767;
  assign n769    = ~n762 & ~n764;
  assign n770    = ~n768 & n769;
  assign n771    = ~n761 & n770;
  assign n772    = ~x[5] & ~n771;
  assign n773    = x[6] & ~n107;
  assign n774    = n149 & n773;
  assign n775    = ~x[4] & n158;
  assign n776    = ~x[6] & n775;
  assign n777    = ~n774 & ~n776;
  assign n778    = x[0] & ~n777;
  assign n779    = n267 & ~n335;
  assign n780    = ~n122 & n779;
  assign n781    = ~n778 & ~n780;
  assign n782    = n211 & ~n781;
  assign n783    = ~n772 & ~n782;
  assign n784    = ~x[1] & ~n783;
  assign n785    = ~x[5] & ~n159;
  assign n786    = ~n157 & ~n785;
  assign n787    = n137 & ~n786;
  assign n788    = x[7] & n122;
  assign n789    = ~n108 & n147;
  assign n790    = n788 & n789;
  assign n791    = ~n787 & ~n790;
  assign n792    = ~x[6] & ~n791;
  assign n793    = x[7] & ~n158;
  assign n794    = ~n33 & n335;
  assign n795    = n125 & n794;
  assign n796    = ~n793 & n795;
  assign n797    = ~n792 & ~n796;
  assign n798    = x[0] & ~n797;
  assign n799    = n125 & n617;
  assign n800    = n25 & n164;
  assign n801    = ~x[7] & ~n328;
  assign n802    = x[7] & n147;
  assign n803    = x[2] & ~n801;
  assign n804    = ~n802 & n803;
  assign n805    = ~n800 & ~n804;
  assign n806    = x[3] & ~n805;
  assign n807    = x[6] & ~n799;
  assign n808    = ~n806 & n807;
  assign n809    = n195 & n775;
  assign n810    = n408 & n481;
  assign n811    = n26 & n810;
  assign n812    = ~x[6] & ~n809;
  assign n813    = ~n811 & n812;
  assign n814    = ~x[0] & ~n813;
  assign n815    = ~n808 & n814;
  assign n816    = n61 & n171;
  assign n817    = ~n71 & n179;
  assign n818    = n788 & n817;
  assign n819    = ~n816 & ~n818;
  assign n820    = ~x[6] & ~n819;
  assign n821    = n60 & n212;
  assign n822    = n50 & n821;
  assign n823    = ~n820 & ~n822;
  assign n824    = ~n269 & ~n823;
  assign n825    = n32 & n775;
  assign n826    = n150 & n562;
  assign n827    = ~n825 & ~n826;
  assign n828    = x[0] & ~n827;
  assign n829    = n46 & n191;
  assign n830    = n108 & n829;
  assign n831    = n561 & n661;
  assign n832    = n213 & n336;
  assign n833    = ~n831 & ~n832;
  assign n834    = x[3] & ~n833;
  assign n835    = ~x[1] & n104;
  assign n836    = n46 & n835;
  assign n837    = ~n834 & ~n836;
  assign n838    = n78 & n269;
  assign n839    = ~n837 & n838;
  assign n840    = ~n50 & n480;
  assign n841    = x[7] & n20;
  assign n842    = ~n840 & ~n841;
  assign n843    = x[5] & ~n842;
  assign n844    = n17 & ~n303;
  assign n845    = ~n45 & n844;
  assign n846    = ~n843 & ~n845;
  assign n847    = ~x[4] & ~n846;
  assign n848    = ~n22 & ~n38;
  assign n849    = n373 & ~n848;
  assign n850    = ~n847 & ~n849;
  assign n851    = x[0] & ~n850;
  assign n852    = ~x[4] & ~n149;
  assign n853    = n284 & n852;
  assign n854    = ~n19 & ~n112;
  assign n855    = x[4] & ~n148;
  assign n856    = ~n854 & n855;
  assign n857    = ~x[7] & ~n856;
  assign n858    = ~n853 & n857;
  assign n859    = ~n19 & ~n328;
  assign n860    = ~n21 & ~n82;
  assign n861    = x[3] & ~n859;
  assign n862    = ~n860 & n861;
  assign n863    = ~x[5] & n50;
  assign n864    = n108 & n863;
  assign n865    = x[7] & ~n864;
  assign n866    = ~n862 & n865;
  assign n867    = ~x[0] & ~n866;
  assign n868    = ~n858 & n867;
  assign n869    = ~n851 & ~n868;
  assign n870    = x[1] & ~n869;
  assign n871    = ~n828 & ~n830;
  assign n872    = ~n815 & n871;
  assign n873    = ~n824 & ~n839;
  assign n874    = n872 & n873;
  assign n875    = ~n798 & n874;
  assign n876    = ~n870 & n875;
  assign n877    = ~n784 & n876;
  assign n878    = n211 & n775;
  assign n879    = ~n25 & ~n45;
  assign n880    = ~n408 & n879;
  assign n881    = ~n878 & ~n880;
  assign n882    = x[1] & ~n881;
  assign n883    = ~x[7] & n121;
  assign n884    = ~n788 & ~n883;
  assign n885    = x[5] & n693;
  assign n886    = ~n884 & n885;
  assign n887    = ~n882 & ~n886;
  assign n888    = x[0] & ~n887;
  assign n889    = x[5] & n107;
  assign n890    = ~n70 & ~n889;
  assign n891    = x[3] & ~n890;
  assign n892    = x[7] & ~n422;
  assign n893    = ~n891 & n892;
  assign n894    = n108 & n124;
  assign n895    = ~x[2] & n347;
  assign n896    = ~n706 & ~n895;
  assign n897    = n105 & ~n896;
  assign n898    = ~x[7] & ~n894;
  assign n899    = ~n897 & n898;
  assign n900    = ~x[0] & ~n893;
  assign n901    = ~n899 & n900;
  assign n902    = ~n888 & ~n901;
  assign n903    = ~x[6] & ~n902;
  assign n904    = n183 & n735;
  assign n905    = n214 & ~n348;
  assign n906    = ~n60 & ~n214;
  assign n907    = x[0] & ~n905;
  assign n908    = ~n906 & n907;
  assign n909    = x[6] & ~n904;
  assign n910    = ~n908 & n909;
  assign n911    = n69 & ~n737;
  assign n912    = x[7] & ~n662;
  assign n913    = ~n56 & n912;
  assign n914    = n103 & n137;
  assign n915    = ~n913 & ~n914;
  assign n916    = ~x[5] & ~n915;
  assign n917    = ~x[6] & ~n911;
  assign n918    = ~n916 & n917;
  assign n919    = ~n159 & ~n910;
  assign n920    = ~n918 & n919;
  assign n921    = n102 & n447;
  assign n922    = x[2] & n417;
  assign n923    = n103 & n922;
  assign n924    = ~n921 & ~n923;
  assign n925    = ~n336 & ~n357;
  assign n926    = ~n924 & n925;
  assign n927    = n32 & n95;
  assign n928    = ~n212 & ~n504;
  assign n929    = ~x[6] & ~n928;
  assign n930    = ~n202 & n929;
  assign n931    = ~n927 & ~n930;
  assign n932    = x[4] & ~n149;
  assign n933    = ~n931 & n932;
  assign n934    = n102 & n480;
  assign n935    = x[5] & n414;
  assign n936    = ~n141 & n935;
  assign n937    = ~n934 & ~n936;
  assign n938    = x[6] & ~n937;
  assign n939    = n118 & n213;
  assign n940    = n269 & n939;
  assign n941    = ~x[0] & n16;
  assign n942    = n17 & n57;
  assign n943    = ~n941 & ~n942;
  assign n944    = x[7] & ~n943;
  assign n945    = ~x[7] & ~n276;
  assign n946    = ~n81 & n945;
  assign n947    = ~n78 & n946;
  assign n948    = ~n944 & ~n947;
  assign n949    = n159 & ~n948;
  assign n950    = ~n938 & ~n940;
  assign n951    = ~n949 & n950;
  assign n952    = ~x[4] & ~n951;
  assign n953    = n102 & n506;
  assign n954    = n89 & n953;
  assign n955    = ~x[4] & n179;
  assign n956    = ~x[0] & ~n506;
  assign n957    = ~n148 & n956;
  assign n958    = ~n955 & n957;
  assign n959    = n55 & n148;
  assign n960    = ~n958 & ~n959;
  assign n961    = x[5] & ~n960;
  assign n962    = x[1] & ~n506;
  assign n963    = n77 & ~n962;
  assign n964    = ~n122 & n963;
  assign n965    = ~x[7] & ~n964;
  assign n966    = ~n961 & n965;
  assign n967    = ~n66 & ~n124;
  assign n968    = ~n65 & ~n125;
  assign n969    = ~x[1] & ~n967;
  assign n970    = ~n968 & n969;
  assign n971    = n104 & n183;
  assign n972    = ~n970 & ~n971;
  assign n973    = x[2] & ~n972;
  assign n974    = ~n69 & ~n202;
  assign n975    = n114 & ~n974;
  assign n976    = x[7] & ~n975;
  assign n977    = ~n973 & n976;
  assign n978    = x[6] & ~n977;
  assign n979    = ~n966 & n978;
  assign n980    = ~n926 & ~n954;
  assign n981    = ~n933 & n980;
  assign n982    = ~n920 & n981;
  assign n983    = ~n952 & n982;
  assign n984    = ~n979 & n983;
  assign n985    = ~n903 & n984;
  assign n986    = n20 & n121;
  assign n987    = ~n595 & ~n986;
  assign n988    = x[0] & ~n987;
  assign n989    = n267 & n335;
  assign n990    = ~n988 & ~n989;
  assign n991    = ~x[5] & ~n990;
  assign n992    = ~x[6] & n60;
  assign n993    = n299 & n992;
  assign n994    = ~n991 & ~n993;
  assign n995    = ~x[7] & ~n994;
  assign n996    = n211 & ~n338;
  assign n997    = n436 & n996;
  assign n998    = ~n348 & n997;
  assign n999    = ~n213 & ~n333;
  assign n1000   = n754 & ~n999;
  assign n1001   = n71 & n284;
  assign n1002   = x[3] & n62;
  assign n1003   = ~n1001 & ~n1002;
  assign n1004   = x[7] & ~n348;
  assign n1005   = ~n1003 & n1004;
  assign n1006   = x[2] & ~n998;
  assign n1007   = ~n1000 & n1006;
  assign n1008   = ~n1005 & n1007;
  assign n1009   = n109 & n213;
  assign n1010   = n212 & n336;
  assign n1011   = ~n1009 & ~n1010;
  assign n1012   = ~x[3] & ~n1011;
  assign n1013   = n32 & n320;
  assign n1014   = ~n1012 & ~n1013;
  assign n1015   = x[5] & ~n1014;
  assign n1016   = n211 & n319;
  assign n1017   = ~n180 & ~n1016;
  assign n1018   = ~n125 & ~n336;
  assign n1019   = ~n1017 & n1018;
  assign n1020   = ~x[2] & ~n1019;
  assign n1021   = ~n1015 & n1020;
  assign n1022   = x[0] & ~n1008;
  assign n1023   = ~n1021 & n1022;
  assign n1024   = ~n21 & n196;
  assign n1025   = ~x[6] & ~n303;
  assign n1026   = n26 & ~n39;
  assign n1027   = x[7] & ~n560;
  assign n1028   = ~n1026 & ~n1027;
  assign n1029   = x[3] & ~n1025;
  assign n1030   = ~n1028 & n1029;
  assign n1031   = ~x[1] & ~n1024;
  assign n1032   = ~n1030 & n1031;
  assign n1033   = ~n25 & ~n357;
  assign n1034   = ~n125 & n1033;
  assign n1035   = ~x[7] & ~n25;
  assign n1036   = n18 & n1035;
  assign n1037   = n159 & n1036;
  assign n1038   = x[1] & ~n1037;
  assign n1039   = ~n1034 & n1038;
  assign n1040   = n67 & ~n1039;
  assign n1041   = ~n1032 & n1040;
  assign n1042   = n192 & n335;
  assign n1043   = ~x[4] & ~n227;
  assign n1044   = n436 & n1043;
  assign n1045   = ~n1042 & ~n1044;
  assign n1046   = n450 & ~n1045;
  assign n1047   = n45 & ~n214;
  assign n1048   = ~n122 & ~n228;
  assign n1049   = n1047 & n1048;
  assign n1050   = ~n1046 & ~n1049;
  assign n1051   = x[5] & ~n1050;
  assign n1052   = ~x[0] & ~n204;
  assign n1053   = n348 & n1052;
  assign n1054   = ~x[1] & n119;
  assign n1055   = x[0] & n1054;
  assign n1056   = ~n1053 & ~n1055;
  assign n1057   = ~x[6] & ~n1056;
  assign n1058   = ~x[7] & ~n1057;
  assign n1059   = x[3] & n103;
  assign n1060   = ~n93 & ~n119;
  assign n1061   = ~n1059 & n1060;
  assign n1062   = x[6] & ~n1061;
  assign n1063   = x[0] & n835;
  assign n1064   = n56 & n121;
  assign n1065   = n46 & ~n1064;
  assign n1066   = ~n1063 & n1065;
  assign n1067   = ~x[5] & ~n1066;
  assign n1068   = ~n1062 & n1067;
  assign n1069   = ~n1058 & n1068;
  assign n1070   = x[7] & n267;
  assign n1071   = n120 & n1070;
  assign n1072   = ~x[6] & ~n328;
  assign n1073   = ~n124 & n1072;
  assign n1074   = ~n26 & n1073;
  assign n1075   = n17 & n114;
  assign n1076   = x[7] & ~n1075;
  assign n1077   = ~n1074 & n1076;
  assign n1078   = ~n567 & n922;
  assign n1079   = ~n104 & n1073;
  assign n1080   = x[6] & n373;
  assign n1081   = ~n1079 & ~n1080;
  assign n1082   = ~x[2] & ~n1081;
  assign n1083   = ~x[7] & ~n1078;
  assign n1084   = ~n1082 & n1083;
  assign n1085   = x[1] & ~n1077;
  assign n1086   = ~n1084 & n1085;
  assign n1087   = n47 & ~n146;
  assign n1088   = n26 & n1054;
  assign n1089   = n1087 & n1088;
  assign n1090   = ~n1086 & ~n1089;
  assign n1091   = ~x[0] & ~n1090;
  assign n1092   = ~n1051 & ~n1071;
  assign n1093   = ~n1069 & n1092;
  assign n1094   = ~n1041 & n1093;
  assign n1095   = ~n995 & ~n1023;
  assign n1096   = n1094 & n1095;
  assign n1097   = ~n1091 & n1096;

  // ---- Output inversions ----
  assign y[7]  = ~n225;
  assign y[6]  = ~n370;
  assign y[5]  = ~n499;
  assign y[4]  = ~n638;
  assign y[3]  = ~n753;
  assign y[2]  = ~n877;
  assign y[1]  = ~n985;
  assign y[0]  = ~n1097;

endmodule

`default_nettype wire
