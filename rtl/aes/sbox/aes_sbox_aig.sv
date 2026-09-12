// -----------------------------------------------------------------------------
// aes_sbox_aig.sv  --  AES SubBytes S-box as an AND-inverter graph (AIG)
//
// Purely combinational and unclocked: every node is a two-input AND with
// optional input inversions. Derived from an ABC-generated AIG of the S-box
// truth table, rewritten with packed vector ports.
//
//   Cost: 1118 two-input AND nodes + 8 output inversions.
//
// Port mapping. ABC named its nets MSB-first, following the PLA column order,
// so the original scalars map as:
//
//   x0 x1 x2 x3 x4 x5 x6 x7  ->  x[7] x[6] x[5] x[4] x[3] x[2] x[1] x[0]
//   z0 z1 z2 z3 z4 z5 z6 z7  ->  y[7] y[6] y[5] y[4] y[3] y[2] y[1] y[0]
//
// i.e. x[7] is the MSB of the S-box input byte and y[7] the MSB of the output.
// Verified: y == AES_SBOX[x] for all 256 values of x, checked against the
// algebraic definition s = A*a^-1 + 0x63 over GF(2^8) with modulus 0x11B.
//
// The internal nodes are kept as individual scalar nets rather than bits of a
// packed vector. Bit-select continuous assignments onto one wide net make some
// event-driven simulators re-evaluate the whole vector per node, which turns
// this into a quadratic-event netlist and is very slow to simulate.
// -----------------------------------------------------------------------------

`default_nettype none

module aes_sbox_aig (
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
        n1088, n1089, n1090, n1091, n1092, n1093, n1094, n1095, n1096,
        n1097, n1098, n1099, n1100, n1101, n1102, n1103, n1104, n1105,
        n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113, n1114,
        n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
        n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133;

  // ---- AND-inverter nodes ----
  assign n16     = x[3] & x[2];
  assign n17     = ~x[5] & x[4];
  assign n18     = ~x[7] & x[0];
  assign n19     = x[5] & ~x[4];
  assign n20     = ~n17 & ~n19;
  assign n21     = n18 & n20;
  assign n22     = x[1] & ~x[0];
  assign n23     = ~x[4] & n22;
  assign n24     = ~x[7] & x[5];
  assign n25     = n23 & n24;
  assign n26     = ~x[5] & x[0];
  assign n27     = x[7] & ~x[1];
  assign n28     = x[4] & x[1];
  assign n29     = ~x[7] & n28;
  assign n30     = ~n27 & ~n29;
  assign n31     = n26 & ~n30;
  assign n32     = x[7] & ~x[0];
  assign n33     = x[5] & x[4];
  assign n34     = n32 & n33;
  assign n35     = ~n21 & ~n34;
  assign n36     = ~n25 & n35;
  assign n37     = ~n31 & n36;
  assign n38     = x[6] & ~n37;
  assign n39     = ~x[7] & ~x[6];
  assign n40     = ~x[4] & ~x[0];
  assign n41     = ~x[5] & n40;
  assign n42     = x[5] & ~x[0];
  assign n43     = ~n26 & ~n42;
  assign n44     = ~x[4] & x[0];
  assign n45     = x[4] & ~x[0];
  assign n46     = ~n44 & ~n45;
  assign n47     = ~x[1] & ~n43;
  assign n48     = ~n46 & n47;
  assign n49     = ~n41 & ~n48;
  assign n50     = n39 & ~n49;
  assign n51     = ~n38 & ~n50;
  assign n52     = n16 & ~n51;
  assign n53     = x[4] & n22;
  assign n54     = n39 & n53;
  assign n55     = x[6] & ~x[4];
  assign n56     = ~x[6] & x[4];
  assign n57     = ~n55 & ~n56;
  assign n58     = n27 & ~n57;
  assign n59     = n46 & n58;
  assign n60     = ~n54 & ~n59;
  assign n61     = ~x[2] & ~n60;
  assign n62     = x[2] & x[1];
  assign n63     = x[7] & ~x[4];
  assign n64     = x[6] & n63;
  assign n65     = n62 & n64;
  assign n66     = ~n61 & ~n65;
  assign n67     = ~x[5] & ~n66;
  assign n68     = x[6] & x[0];
  assign n69     = ~x[6] & ~x[0];
  assign n70     = ~n68 & ~n69;
  assign n71     = ~x[5] & x[1];
  assign n72     = x[7] & n71;
  assign n73     = n70 & n72;
  assign n74     = ~n18 & ~n27;
  assign n75     = x[6] & x[1];
  assign n76     = ~x[6] & ~x[1];
  assign n77     = ~n75 & ~n76;
  assign n78     = x[0] & n77;
  assign n79     = x[5] & ~n74;
  assign n80     = ~n78 & n79;
  assign n81     = ~x[3] & ~n73;
  assign n82     = ~n80 & n81;
  assign n83     = x[7] & ~x[6];
  assign n84     = x[5] & n22;
  assign n85     = n83 & n84;
  assign n86     = x[6] & ~x[1];
  assign n87     = ~x[1] & x[0];
  assign n88     = ~n22 & ~n87;
  assign n89     = x[5] & ~x[1];
  assign n90     = ~n71 & ~n89;
  assign n91     = ~x[7] & ~n86;
  assign n92     = n90 & n91;
  assign n93     = ~n88 & n92;
  assign n94     = x[3] & ~n85;
  assign n95     = ~n93 & n94;
  assign n96     = x[4] & ~n95;
  assign n97     = ~n82 & n96;
  assign n98     = x[3] & n87;
  assign n99     = n39 & n98;
  assign n100    = x[1] & x[0];
  assign n101    = ~x[6] & x[3];
  assign n102    = ~x[3] & x[0];
  assign n103    = x[6] & n102;
  assign n104    = ~n101 & ~n103;
  assign n105    = x[7] & ~n100;
  assign n106    = ~n104 & n105;
  assign n107    = ~n99 & ~n106;
  assign n108    = n19 & ~n107;
  assign n109    = ~x[1] & ~x[0];
  assign n110    = x[7] & ~n109;
  assign n111    = x[6] & x[5];
  assign n112    = ~x[7] & ~x[0];
  assign n113    = ~x[4] & ~n112;
  assign n114    = ~x[2] & x[1];
  assign n115    = x[2] & ~x[1];
  assign n116    = ~n114 & ~n115;
  assign n117    = ~n110 & n111;
  assign n118    = n113 & n116;
  assign n119    = n117 & n118;
  assign n120    = ~x[7] & ~x[3];
  assign n121    = ~x[5] & ~x[2];
  assign n122    = x[5] & x[2];
  assign n123    = ~n121 & ~n122;
  assign n124    = n120 & n123;
  assign n125    = x[6] & x[2];
  assign n126    = ~x[6] & ~x[2];
  assign n127    = ~n125 & ~n126;
  assign n128    = x[6] & ~x[3];
  assign n129    = ~n101 & ~n128;
  assign n130    = ~n127 & n129;
  assign n131    = x[7] & n130;
  assign n132    = ~n124 & ~n131;
  assign n133    = ~x[6] & x[5];
  assign n134    = x[6] & ~x[5];
  assign n135    = ~n133 & ~n134;
  assign n136    = ~x[4] & n135;
  assign n137    = ~n132 & n136;
  assign n138    = ~x[7] & x[6];
  assign n139    = n16 & ~n138;
  assign n140    = n17 & n139;
  assign n141    = ~n137 & ~n140;
  assign n142    = n88 & ~n141;
  assign n143    = n23 & n138;
  assign n144    = ~x[6] & x[1];
  assign n145    = ~n86 & ~n144;
  assign n146    = x[7] & n145;
  assign n147    = n57 & ~n70;
  assign n148    = n146 & n147;
  assign n149    = ~n143 & ~n148;
  assign n150    = x[3] & ~n149;
  assign n151    = ~n68 & ~n76;
  assign n152    = ~x[4] & ~n86;
  assign n153    = n120 & ~n151;
  assign n154    = ~n152 & n153;
  assign n155    = ~n150 & ~n154;
  assign n156    = ~x[5] & ~n155;
  assign n157    = x[5] & ~x[3];
  assign n158    = n40 & ~n77;
  assign n159    = x[6] & x[4];
  assign n160    = x[7] & n159;
  assign n161    = ~x[6] & ~x[4];
  assign n162    = ~x[7] & n161;
  assign n163    = ~n160 & ~n162;
  assign n164    = ~n88 & ~n163;
  assign n165    = ~x[7] & x[4];
  assign n166    = x[0] & n165;
  assign n167    = ~n145 & n166;
  assign n168    = ~n158 & ~n167;
  assign n169    = ~n164 & n168;
  assign n170    = n157 & ~n169;
  assign n171    = ~n156 & ~n170;
  assign n172    = ~x[2] & ~n171;
  assign n173    = ~x[3] & ~x[2];
  assign n174    = ~n16 & ~n173;
  assign n175    = x[5] & ~n32;
  assign n176    = ~n18 & ~n175;
  assign n177    = x[6] & ~n176;
  assign n178    = ~x[6] & ~x[5];
  assign n179    = ~x[7] & n178;
  assign n180    = ~x[0] & n179;
  assign n181    = ~n177 & ~n180;
  assign n182    = x[4] & ~n181;
  assign n183    = x[7] & ~x[5];
  assign n184    = n44 & n183;
  assign n185    = ~n182 & ~n184;
  assign n186    = ~x[1] & ~n185;
  assign n187    = x[7] & x[6];
  assign n188    = ~n39 & ~n187;
  assign n189    = ~x[4] & ~n188;
  assign n190    = x[4] & x[0];
  assign n191    = ~x[6] & n190;
  assign n192    = x[5] & ~n191;
  assign n193    = ~n189 & n192;
  assign n194    = x[7] & n56;
  assign n195    = ~x[0] & n194;
  assign n196    = x[6] & ~n46;
  assign n197    = ~n191 & ~n196;
  assign n198    = ~x[7] & ~n197;
  assign n199    = ~x[5] & ~n195;
  assign n200    = ~n198 & n199;
  assign n201    = x[1] & ~n193;
  assign n202    = ~n200 & n201;
  assign n203    = ~n186 & ~n202;
  assign n204    = n174 & ~n203;
  assign n205    = ~n108 & ~n119;
  assign n206    = ~n97 & n205;
  assign n207    = ~n67 & n206;
  assign n208    = ~n142 & n207;
  assign n209    = ~n52 & n208;
  assign n210    = ~n172 & ~n204;
  assign n211    = n209 & n210;
  assign n212    = x[3] & ~x[2];
  assign n213    = ~x[4] & n212;
  assign n214    = n138 & n213;
  assign n215    = n115 & ~n188;
  assign n216    = n114 & ~n138;
  assign n217    = ~n215 & ~n216;
  assign n218    = x[3] & ~n217;
  assign n219    = ~x[3] & x[2];
  assign n220    = n144 & n219;
  assign n221    = ~n218 & ~n220;
  assign n222    = ~x[4] & ~n221;
  assign n223    = ~x[6] & x[2];
  assign n224    = x[6] & ~x[2];
  assign n225    = ~n223 & ~n224;
  assign n226    = x[7] & ~x[3];
  assign n227    = ~x[7] & x[3];
  assign n228    = ~n226 & ~n227;
  assign n229    = x[4] & ~n228;
  assign n230    = ~n39 & n225;
  assign n231    = n229 & n230;
  assign n232    = ~n214 & ~n231;
  assign n233    = ~n222 & n232;
  assign n234    = n43 & ~n233;
  assign n235    = ~x[5] & x[2];
  assign n236    = n101 & n235;
  assign n237    = ~x[5] & n114;
  assign n238    = ~n86 & ~n237;
  assign n239    = ~x[3] & ~n134;
  assign n240    = ~n238 & n239;
  assign n241    = ~n236 & ~n240;
  assign n242    = ~x[4] & ~n241;
  assign n243    = x[3] & ~n115;
  assign n244    = ~x[3] & ~n114;
  assign n245    = ~n243 & ~n244;
  assign n246    = x[6] & n245;
  assign n247    = n101 & n116;
  assign n248    = ~n246 & ~n247;
  assign n249    = n17 & ~n248;
  assign n250    = ~n242 & ~n249;
  assign n251    = x[0] & ~n250;
  assign n252    = n55 & n157;
  assign n253    = n57 & ~n121;
  assign n254    = ~n122 & ~n159;
  assign n255    = x[3] & ~n254;
  assign n256    = ~n253 & n255;
  assign n257    = ~n252 & ~n256;
  assign n258    = n109 & ~n257;
  assign n259    = ~x[2] & x[0];
  assign n260    = x[2] & ~x[0];
  assign n261    = ~n259 & ~n260;
  assign n262    = n43 & ~n261;
  assign n263    = ~x[1] & n228;
  assign n264    = ~n29 & ~n263;
  assign n265    = ~x[6] & ~n264;
  assign n266    = ~x[3] & x[1];
  assign n267    = ~x[4] & n138;
  assign n268    = n266 & n267;
  assign n269    = ~n265 & ~n268;
  assign n270    = n262 & ~n269;
  assign n271    = ~x[3] & ~x[1];
  assign n272    = ~x[2] & n271;
  assign n273    = n179 & n272;
  assign n274    = x[7] & x[3];
  assign n275    = n90 & n274;
  assign n276    = n116 & ~n145;
  assign n277    = n275 & n276;
  assign n278    = ~n273 & ~n277;
  assign n279    = ~x[4] & ~n278;
  assign n280    = x[4] & ~x[2];
  assign n281    = ~x[7] & ~x[5];
  assign n282    = ~x[3] & n280;
  assign n283    = n281 & n282;
  assign n284    = ~n145 & n283;
  assign n285    = ~x[4] & ~x[3];
  assign n286    = ~x[6] & n285;
  assign n287    = n109 & n286;
  assign n288    = ~n100 & ~n109;
  assign n289    = x[3] & ~x[0];
  assign n290    = x[4] & ~n289;
  assign n291    = n288 & n290;
  assign n292    = ~n103 & n291;
  assign n293    = ~n287 & ~n292;
  assign n294    = x[5] & ~n293;
  assign n295    = ~x[1] & n178;
  assign n296    = ~n40 & ~n190;
  assign n297    = x[4] & x[3];
  assign n298    = ~n285 & ~n297;
  assign n299    = n295 & ~n298;
  assign n300    = ~n296 & n299;
  assign n301    = ~n294 & ~n300;
  assign n302    = x[7] & ~n301;
  assign n303    = ~n102 & ~n289;
  assign n304    = x[5] & ~n303;
  assign n305    = ~n26 & ~n304;
  assign n306    = ~x[5] & ~x[3];
  assign n307    = ~x[1] & ~n306;
  assign n308    = ~n144 & ~n307;
  assign n309    = ~n305 & n308;
  assign n310    = x[4] & ~n309;
  assign n311    = x[3] & ~x[1];
  assign n312    = ~n266 & ~n311;
  assign n313    = x[5] & n69;
  assign n314    = ~n312 & n313;
  assign n315    = ~x[5] & ~n75;
  assign n316    = x[0] & ~n101;
  assign n317    = n315 & n316;
  assign n318    = ~x[4] & ~n314;
  assign n319    = ~n317 & n318;
  assign n320    = ~x[7] & ~n319;
  assign n321    = ~n310 & n320;
  assign n322    = ~n302 & ~n321;
  assign n323    = x[2] & ~n322;
  assign n324    = n129 & n165;
  assign n325    = ~n70 & n324;
  assign n326    = x[0] & ~n285;
  assign n327    = ~n68 & ~n101;
  assign n328    = x[7] & ~n327;
  assign n329    = ~n326 & n328;
  assign n330    = ~n325 & ~n329;
  assign n331    = ~x[5] & ~n330;
  assign n332    = ~x[4] & x[3];
  assign n333    = ~x[6] & n332;
  assign n334    = x[6] & ~n298;
  assign n335    = n42 & ~n333;
  assign n336    = n188 & n335;
  assign n337    = ~n334 & n336;
  assign n338    = ~n331 & ~n337;
  assign n339    = ~x[1] & ~n338;
  assign n340    = x[7] & n135;
  assign n341    = ~n111 & ~n274;
  assign n342    = n53 & ~n341;
  assign n343    = ~n340 & n342;
  assign n344    = ~n339 & ~n343;
  assign n345    = ~x[2] & ~n344;
  assign n346    = ~x[4] & x[1];
  assign n347    = n112 & n346;
  assign n348    = x[7] & ~n288;
  assign n349    = n46 & n348;
  assign n350    = ~n347 & ~n349;
  assign n351    = ~x[2] & ~n350;
  assign n352    = x[2] & n165;
  assign n353    = n100 & n352;
  assign n354    = ~n351 & ~n353;
  assign n355    = ~x[6] & ~n354;
  assign n356    = ~x[4] & x[2];
  assign n357    = n100 & n356;
  assign n358    = n109 & n280;
  assign n359    = ~n357 & ~n358;
  assign n360    = n187 & ~n359;
  assign n361    = ~n355 & ~n360;
  assign n362    = ~x[5] & x[3];
  assign n363    = ~n157 & ~n362;
  assign n364    = ~n361 & n363;
  assign n365    = ~n279 & ~n284;
  assign n366    = ~n258 & n365;
  assign n367    = ~n270 & n366;
  assign n368    = ~n251 & n367;
  assign n369    = ~n234 & n368;
  assign n370    = ~n323 & ~n345;
  assign n371    = ~n364 & n370;
  assign n372    = n369 & n371;
  assign n373    = x[6] & n296;
  assign n374    = ~x[6] & ~n45;
  assign n375    = ~x[2] & ~n374;
  assign n376    = ~n373 & n375;
  assign n377    = n44 & n223;
  assign n378    = ~n376 & ~n377;
  assign n379    = x[1] & ~n378;
  assign n380    = n86 & n261;
  assign n381    = ~x[4] & n380;
  assign n382    = ~n379 & ~n381;
  assign n383    = x[3] & ~n382;
  assign n384    = ~x[3] & n22;
  assign n385    = n125 & n384;
  assign n386    = ~x[2] & n100;
  assign n387    = n286 & n386;
  assign n388    = n98 & n126;
  assign n389    = ~n385 & ~n388;
  assign n390    = ~n387 & n389;
  assign n391    = ~n383 & n390;
  assign n392    = ~x[5] & ~n391;
  assign n393    = x[6] & n297;
  assign n394    = ~x[1] & n260;
  assign n395    = n393 & n394;
  assign n396    = ~n225 & n298;
  assign n397    = n129 & n396;
  assign n398    = x[0] & ~n397;
  assign n399    = ~n286 & ~n393;
  assign n400    = ~x[0] & n399;
  assign n401    = x[1] & ~n400;
  assign n402    = ~n398 & n401;
  assign n403    = ~n395 & ~n402;
  assign n404    = x[5] & ~n403;
  assign n405    = ~x[5] & ~x[4];
  assign n406    = n115 & n405;
  assign n407    = n33 & n116;
  assign n408    = ~n406 & ~n407;
  assign n409    = ~n129 & ~n303;
  assign n410    = ~n408 & n409;
  assign n411    = ~n404 & ~n410;
  assign n412    = ~n392 & n411;
  assign n413    = x[7] & ~n412;
  assign n414    = x[4] & n114;
  assign n415    = ~n135 & n414;
  assign n416    = ~x[6] & ~n123;
  assign n417    = ~n280 & ~n356;
  assign n418    = x[2] & n134;
  assign n419    = ~x[1] & ~n418;
  assign n420    = n417 & n419;
  assign n421    = ~n416 & n420;
  assign n422    = ~n415 & ~n421;
  assign n423    = ~x[3] & ~n422;
  assign n424    = x[4] & ~x[1];
  assign n425    = ~n346 & ~n424;
  assign n426    = ~n135 & ~n174;
  assign n427    = ~n123 & ~n425;
  assign n428    = n426 & n427;
  assign n429    = ~x[1] & n17;
  assign n430    = x[1] & ~n17;
  assign n431    = ~n429 & ~n430;
  assign n432    = ~n145 & n212;
  assign n433    = ~n431 & n432;
  assign n434    = ~n428 & ~n433;
  assign n435    = ~n423 & n434;
  assign n436    = x[7] & ~n435;
  assign n437    = x[0] & n224;
  assign n438    = ~x[6] & n394;
  assign n439    = ~n437 & ~n438;
  assign n440    = x[3] & ~n439;
  assign n441    = x[2] & n384;
  assign n442    = ~x[2] & n363;
  assign n443    = x[5] & x[3];
  assign n444    = n312 & ~n443;
  assign n445    = ~n441 & ~n444;
  assign n446    = ~n442 & n445;
  assign n447    = ~x[6] & ~n446;
  assign n448    = x[6] & ~n363;
  assign n449    = n123 & ~n312;
  assign n450    = n448 & n449;
  assign n451    = ~x[4] & ~n450;
  assign n452    = ~n440 & n451;
  assign n453    = ~n447 & n452;
  assign n454    = ~n122 & ~n237;
  assign n455    = n101 & ~n454;
  assign n456    = ~n90 & ~n212;
  assign n457    = n90 & ~n219;
  assign n458    = x[6] & ~n456;
  assign n459    = ~n457 & n458;
  assign n460    = x[4] & ~n455;
  assign n461    = ~n459 & n460;
  assign n462    = ~x[7] & ~n461;
  assign n463    = ~n453 & n462;
  assign n464    = n135 & n165;
  assign n465    = n262 & n464;
  assign n466    = x[7] & n111;
  assign n467    = ~x[0] & n356;
  assign n468    = n466 & n467;
  assign n469    = ~n465 & ~n468;
  assign n470    = n312 & ~n469;
  assign n471    = n109 & n173;
  assign n472    = n194 & n471;
  assign n473    = ~n174 & n346;
  assign n474    = x[4] & ~n312;
  assign n475    = n116 & n474;
  assign n476    = ~n473 & ~n475;
  assign n477    = ~x[0] & ~n476;
  assign n478    = ~n356 & ~n414;
  assign n479    = n102 & ~n478;
  assign n480    = ~x[5] & ~n479;
  assign n481    = ~n477 & n480;
  assign n482    = x[2] & ~n271;
  assign n483    = n303 & n482;
  assign n484    = ~x[3] & n259;
  assign n485    = ~x[1] & n484;
  assign n486    = ~n483 & ~n485;
  assign n487    = ~x[4] & ~n486;
  assign n488    = n16 & ~n40;
  assign n489    = n288 & n488;
  assign n490    = x[5] & ~n489;
  assign n491    = ~n487 & n490;
  assign n492    = ~n481 & ~n491;
  assign n493    = x[6] & ~n492;
  assign n494    = x[3] & n260;
  assign n495    = ~n484 & ~n494;
  assign n496    = n19 & ~n495;
  assign n497    = x[5] & ~x[2];
  assign n498    = ~n102 & ~n497;
  assign n499    = x[4] & ~n498;
  assign n500    = ~n304 & n499;
  assign n501    = ~n496 & ~n500;
  assign n502    = x[1] & ~n501;
  assign n503    = ~x[1] & n362;
  assign n504    = ~n44 & n503;
  assign n505    = n261 & n504;
  assign n506    = ~x[6] & ~n505;
  assign n507    = ~n502 & n506;
  assign n508    = ~x[7] & ~n507;
  assign n509    = ~n493 & n508;
  assign n510    = ~n470 & ~n472;
  assign n511    = ~n463 & n510;
  assign n512    = ~n436 & n511;
  assign n513    = ~n509 & n512;
  assign n514    = ~n413 & n513;
  assign n515    = n178 & n386;
  assign n516    = ~n43 & n380;
  assign n517    = ~n515 & ~n516;
  assign n518    = ~x[3] & ~n517;
  assign n519    = n247 & n262;
  assign n520    = ~n518 & ~n519;
  assign n521    = ~x[7] & ~n520;
  assign n522    = ~n306 & ~n443;
  assign n523    = x[2] & n39;
  assign n524    = ~n522 & n523;
  assign n525    = n312 & n524;
  assign n526    = n272 & n281;
  assign n527    = x[5] & x[1];
  assign n528    = x[7] & n16;
  assign n529    = n527 & n528;
  assign n530    = ~n526 & ~n529;
  assign n531    = x[6] & ~n530;
  assign n532    = ~x[5] & n187;
  assign n533    = n471 & n532;
  assign n534    = ~n525 & ~n533;
  assign n535    = ~n531 & n534;
  assign n536    = ~n521 & n535;
  assign n537    = x[4] & ~n536;
  assign n538    = x[5] & ~n399;
  assign n539    = ~x[7] & ~n538;
  assign n540    = x[7] & x[5];
  assign n541    = x[6] & n285;
  assign n542    = ~n56 & n540;
  assign n543    = ~n541 & n542;
  assign n544    = x[2] & n87;
  assign n545    = ~x[2] & n22;
  assign n546    = ~n544 & ~n545;
  assign n547    = x[3] & ~n159;
  assign n548    = ~x[5] & ~n161;
  assign n549    = ~n547 & n548;
  assign n550    = ~n543 & ~n549;
  assign n551    = ~n546 & n550;
  assign n552    = ~n539 & n551;
  assign n553    = n357 & n540;
  assign n554    = n24 & n62;
  assign n555    = x[7] & n121;
  assign n556    = ~n88 & n555;
  assign n557    = ~n554 & ~n556;
  assign n558    = n159 & ~n557;
  assign n559    = x[7] & n212;
  assign n560    = ~n57 & n559;
  assign n561    = x[4] & n120;
  assign n562    = x[3] & ~n165;
  assign n563    = n57 & n562;
  assign n564    = ~n561 & ~n563;
  assign n565    = x[2] & ~n564;
  assign n566    = x[0] & ~n560;
  assign n567    = ~n565 & n566;
  assign n568    = n162 & n173;
  assign n569    = x[7] & ~x[2];
  assign n570    = n159 & ~n569;
  assign n571    = n174 & n570;
  assign n572    = ~x[0] & ~n568;
  assign n573    = ~n571 & n572;
  assign n574    = ~n90 & ~n573;
  assign n575    = ~n567 & n574;
  assign n576    = n19 & ~n76;
  assign n577    = x[4] & n295;
  assign n578    = ~n576 & ~n577;
  assign n579    = ~x[7] & ~n578;
  assign n580    = ~n39 & ~n90;
  assign n581    = n57 & n580;
  assign n582    = x[3] & ~n581;
  assign n583    = ~n579 & n582;
  assign n584    = n183 & n425;
  assign n585    = ~n145 & n584;
  assign n586    = ~x[4] & ~n77;
  assign n587    = ~x[7] & n586;
  assign n588    = ~x[3] & ~n585;
  assign n589    = ~n587 & n588;
  assign n590    = ~n261 & ~n589;
  assign n591    = ~n583 & n590;
  assign n592    = ~n183 & ~n298;
  assign n593    = ~n24 & n298;
  assign n594    = n223 & ~n592;
  assign n595    = ~n593 & n594;
  assign n596    = ~x[5] & n138;
  assign n597    = n213 & n596;
  assign n598    = ~n595 & ~n597;
  assign n599    = n88 & ~n598;
  assign n600    = ~n179 & ~n466;
  assign n601    = n245 & ~n600;
  assign n602    = n157 & n569;
  assign n603    = x[2] & ~n24;
  assign n604    = x[6] & x[3];
  assign n605    = ~n497 & n604;
  assign n606    = ~n603 & n605;
  assign n607    = ~n602 & ~n606;
  assign n608    = ~x[1] & ~n607;
  assign n609    = ~n601 & ~n608;
  assign n610    = x[0] & ~n609;
  assign n611    = ~n138 & ~n604;
  assign n612    = ~n134 & ~n227;
  assign n613    = ~n611 & ~n612;
  assign n614    = n611 & n612;
  assign n615    = ~x[1] & ~n614;
  assign n616    = ~n613 & n615;
  assign n617    = x[1] & ~n39;
  assign n618    = ~n306 & n617;
  assign n619    = n341 & n618;
  assign n620    = ~x[2] & ~n619;
  assign n621    = ~n616 & n620;
  assign n622    = ~x[3] & n39;
  assign n623    = n527 & n622;
  assign n624    = x[1] & ~n187;
  assign n625    = ~x[5] & ~n27;
  assign n626    = ~n129 & n625;
  assign n627    = ~n624 & n626;
  assign n628    = x[2] & ~n623;
  assign n629    = ~n627 & n628;
  assign n630    = ~x[0] & ~n629;
  assign n631    = ~n621 & n630;
  assign n632    = ~n610 & ~n631;
  assign n633    = ~x[4] & ~n632;
  assign n634    = ~n553 & ~n558;
  assign n635    = ~n552 & n634;
  assign n636    = ~n599 & n635;
  assign n637    = ~n575 & n636;
  assign n638    = ~n591 & n637;
  assign n639    = ~n633 & n638;
  assign n640    = ~n537 & n639;
  assign n641    = ~x[6] & n326;
  assign n642    = ~n334 & ~n641;
  assign n643    = ~x[5] & ~n642;
  assign n644    = n46 & n128;
  assign n645    = ~n643 & ~n644;
  assign n646    = x[1] & ~n645;
  assign n647    = n289 & n577;
  assign n648    = ~n646 & ~n647;
  assign n649    = ~x[7] & ~n648;
  assign n650    = ~x[6] & ~n362;
  assign n651    = ~n448 & ~n650;
  assign n652    = x[0] & ~n651;
  assign n653    = n42 & n128;
  assign n654    = ~n652 & ~n653;
  assign n655    = x[1] & ~n654;
  assign n656    = x[3] & n109;
  assign n657    = n133 & n656;
  assign n658    = x[4] & ~n657;
  assign n659    = ~n655 & n658;
  assign n660    = x[3] & x[0];
  assign n661    = n144 & ~n660;
  assign n662    = x[6] & ~n88;
  assign n663    = ~n312 & n662;
  assign n664    = ~n661 & ~n663;
  assign n665    = x[5] & ~n664;
  assign n666    = x[0] & ~n76;
  assign n667    = n312 & ~n666;
  assign n668    = n315 & n667;
  assign n669    = ~x[4] & ~n668;
  assign n670    = ~n665 & n669;
  assign n671    = x[7] & ~n670;
  assign n672    = ~n659 & n671;
  assign n673    = ~n649 & ~n672;
  assign n674    = ~x[2] & ~n673;
  assign n675    = ~x[4] & n540;
  assign n676    = n289 & n675;
  assign n677    = ~x[4] & n228;
  assign n678    = ~n229 & ~n677;
  assign n679    = ~x[5] & ~n296;
  assign n680    = ~n678 & n679;
  assign n681    = ~n676 & ~n680;
  assign n682    = x[6] & ~n681;
  assign n683    = ~n63 & ~n165;
  assign n684    = ~x[6] & x[0];
  assign n685    = ~n281 & n684;
  assign n686    = n683 & n685;
  assign n687    = ~n363 & n686;
  assign n688    = ~n682 & ~n687;
  assign n689    = n116 & ~n688;
  assign n690    = x[7] & n405;
  assign n691    = x[5] & n683;
  assign n692    = n228 & n691;
  assign n693    = ~n690 & ~n692;
  assign n694    = n437 & ~n693;
  assign n695    = ~n42 & ~n227;
  assign n696    = ~n43 & ~n226;
  assign n697    = x[6] & ~n695;
  assign n698    = ~n696 & n697;
  assign n699    = x[3] & n180;
  assign n700    = ~x[4] & ~n698;
  assign n701    = ~n699 & n700;
  assign n702    = n289 & n596;
  assign n703    = n120 & n134;
  assign n704    = n83 & n363;
  assign n705    = ~n703 & ~n704;
  assign n706    = x[0] & ~n705;
  assign n707    = x[4] & ~n702;
  assign n708    = ~n706 & n707;
  assign n709    = x[2] & ~n708;
  assign n710    = ~n701 & n709;
  assign n711    = n187 & ~n306;
  assign n712    = n312 & n711;
  assign n713    = ~x[1] & ~n362;
  assign n714    = ~x[7] & n713;
  assign n715    = x[7] & ~n713;
  assign n716    = ~n714 & ~n715;
  assign n717    = ~x[6] & ~n72;
  assign n718    = ~n716 & n717;
  assign n719    = x[2] & ~n712;
  assign n720    = ~n718 & n719;
  assign n721    = ~n27 & ~n227;
  assign n722    = n178 & n721;
  assign n723    = ~n71 & n227;
  assign n724    = n312 & n540;
  assign n725    = ~n723 & ~n724;
  assign n726    = x[6] & ~n725;
  assign n727    = ~x[2] & ~n722;
  assign n728    = ~n726 & n727;
  assign n729    = ~n46 & ~n720;
  assign n730    = ~n728 & n729;
  assign n731    = ~n71 & n522;
  assign n732    = n662 & n731;
  assign n733    = x[5] & n100;
  assign n734    = ~n656 & ~n733;
  assign n735    = ~x[6] & ~n443;
  assign n736    = ~n734 & n735;
  assign n737    = ~x[7] & ~n736;
  assign n738    = ~n732 & n737;
  assign n739    = x[6] & n100;
  assign n740    = ~x[6] & ~n88;
  assign n741    = ~n739 & ~n740;
  assign n742    = n362 & ~n741;
  assign n743    = n135 & ~n733;
  assign n744    = ~n109 & ~n111;
  assign n745    = ~x[3] & ~n744;
  assign n746    = ~n743 & n745;
  assign n747    = x[7] & ~n746;
  assign n748    = ~n742 & n747;
  assign n749    = x[4] & ~n748;
  assign n750    = ~n738 & n749;
  assign n751    = n76 & n157;
  assign n752    = ~x[6] & ~x[3];
  assign n753    = ~x[5] & ~n752;
  assign n754    = n77 & n753;
  assign n755    = ~n751 & ~n754;
  assign n756    = ~x[0] & ~n755;
  assign n757    = n98 & n134;
  assign n758    = ~n756 & ~n757;
  assign n759    = x[7] & ~n758;
  assign n760    = n86 & n120;
  assign n761    = ~n42 & n760;
  assign n762    = ~n759 & ~n761;
  assign n763    = ~x[4] & ~n762;
  assign n764    = n63 & n109;
  assign n765    = ~x[7] & ~n88;
  assign n766    = n46 & n765;
  assign n767    = ~n764 & ~n766;
  assign n768    = n135 & ~n522;
  assign n769    = ~n767 & n768;
  assign n770    = ~n750 & ~n769;
  assign n771    = ~n763 & n770;
  assign n772    = x[2] & ~n771;
  assign n773    = ~n694 & ~n710;
  assign n774    = ~n730 & n773;
  assign n775    = ~n689 & n774;
  assign n776    = ~n674 & n775;
  assign n777    = ~n772 & n776;
  assign n778    = ~n115 & ~n298;
  assign n779    = x[4] & ~n116;
  assign n780    = n298 & ~n779;
  assign n781    = ~x[5] & ~n778;
  assign n782    = ~n780 & n781;
  assign n783    = ~n212 & ~n219;
  assign n784    = x[5] & ~n783;
  assign n785    = ~n425 & n784;
  assign n786    = ~n782 & ~n785;
  assign n787    = x[0] & ~n786;
  assign n788    = n122 & n332;
  assign n789    = n22 & n788;
  assign n790    = ~x[7] & ~n789;
  assign n791    = ~n787 & n790;
  assign n792    = ~n312 & n356;
  assign n793    = n28 & n212;
  assign n794    = ~n792 & ~n793;
  assign n795    = x[5] & ~n794;
  assign n796    = ~n261 & n429;
  assign n797    = ~n235 & n346;
  assign n798    = n261 & n797;
  assign n799    = x[3] & ~n798;
  assign n800    = ~n796 & n799;
  assign n801    = n26 & n280;
  assign n802    = ~x[3] & ~n406;
  assign n803    = ~n801 & n802;
  assign n804    = ~n800 & ~n803;
  assign n805    = x[7] & ~n795;
  assign n806    = ~n804 & n805;
  assign n807    = x[6] & ~n806;
  assign n808    = ~n791 & n807;
  assign n809    = x[3] & n127;
  assign n810    = ~x[7] & ~n128;
  assign n811    = n261 & n810;
  assign n812    = ~n809 & n811;
  assign n813    = ~n18 & ~n32;
  assign n814    = n129 & n813;
  assign n815    = ~n783 & n814;
  assign n816    = ~x[4] & ~n815;
  assign n817    = ~n812 & n816;
  assign n818    = x[6] & n261;
  assign n819    = ~n228 & n818;
  assign n820    = n39 & n484;
  assign n821    = x[7] & n303;
  assign n822    = ~n127 & n821;
  assign n823    = x[4] & ~n820;
  assign n824    = ~n822 & n823;
  assign n825    = ~n819 & n824;
  assign n826    = ~n90 & ~n825;
  assign n827    = ~n817 & n826;
  assign n828    = n24 & n87;
  assign n829    = ~n72 & ~n828;
  assign n830    = ~x[4] & ~n829;
  assign n831    = n165 & n733;
  assign n832    = ~n830 & ~n831;
  assign n833    = ~x[3] & ~n832;
  assign n834    = x[3] & n425;
  assign n835    = ~n46 & n183;
  assign n836    = n834 & n835;
  assign n837    = ~n833 & ~n836;
  assign n838    = x[6] & ~n837;
  assign n839    = ~n175 & n424;
  assign n840    = n23 & n540;
  assign n841    = ~n839 & ~n840;
  assign n842    = n101 & ~n841;
  assign n843    = n39 & n44;
  assign n844    = x[7] & x[4];
  assign n845    = ~n70 & n844;
  assign n846    = ~n843 & ~n845;
  assign n847    = x[5] & ~n846;
  assign n848    = n41 & n138;
  assign n849    = ~n847 & ~n848;
  assign n850    = x[1] & ~n849;
  assign n851    = n113 & n295;
  assign n852    = ~n850 & ~n851;
  assign n853    = n783 & ~n852;
  assign n854    = ~x[4] & ~n109;
  assign n855    = n116 & n854;
  assign n856    = ~n358 & ~n855;
  assign n857    = ~x[3] & ~n856;
  assign n858    = n298 & n417;
  assign n859    = ~n88 & n858;
  assign n860    = ~n114 & n297;
  assign n861    = n261 & n860;
  assign n862    = ~x[7] & ~n861;
  assign n863    = ~n859 & n862;
  assign n864    = ~n857 & n863;
  assign n865    = ~n116 & n261;
  assign n866    = n834 & n865;
  assign n867    = ~n22 & n425;
  assign n868    = x[2] & ~n867;
  assign n869    = x[4] & n386;
  assign n870    = ~n868 & ~n869;
  assign n871    = ~x[3] & ~n870;
  assign n872    = x[7] & ~n866;
  assign n873    = ~n871 & n872;
  assign n874    = ~n864 & ~n873;
  assign n875    = x[5] & ~n874;
  assign n876    = ~x[0] & n569;
  assign n877    = ~x[7] & x[2];
  assign n878    = ~n288 & n877;
  assign n879    = ~n876 & ~n878;
  assign n880    = x[3] & ~n879;
  assign n881    = x[7] & n102;
  assign n882    = ~n116 & n881;
  assign n883    = ~n880 & ~n882;
  assign n884    = ~x[4] & ~n883;
  assign n885    = ~n29 & ~n63;
  assign n886    = n303 & ~n783;
  assign n887    = ~n885 & n886;
  assign n888    = x[4] & ~x[3];
  assign n889    = n569 & n888;
  assign n890    = n100 & n889;
  assign n891    = ~x[5] & ~n890;
  assign n892    = ~n887 & n891;
  assign n893    = ~n884 & n892;
  assign n894    = ~x[6] & ~n893;
  assign n895    = ~n875 & n894;
  assign n896    = ~n827 & ~n842;
  assign n897    = ~n838 & n896;
  assign n898    = ~n808 & ~n853;
  assign n899    = n897 & n898;
  assign n900    = ~n895 & n899;
  assign n901    = ~x[2] & ~x[0];
  assign n902    = ~x[6] & n901;
  assign n903    = x[6] & ~n261;
  assign n904    = ~n902 & ~n903;
  assign n905    = x[3] & ~n904;
  assign n906    = n102 & n223;
  assign n907    = ~n905 & ~n906;
  assign n908    = x[7] & ~n907;
  assign n909    = n622 & n901;
  assign n910    = ~n908 & ~n909;
  assign n911    = ~n90 & ~n910;
  assign n912    = ~n116 & n316;
  assign n913    = ~x[6] & ~n311;
  assign n914    = x[6] & ~n312;
  assign n915    = n260 & ~n913;
  assign n916    = ~n914 & n915;
  assign n917    = ~n912 & ~n916;
  assign n918    = ~x[5] & ~n917;
  assign n919    = x[1] & n111;
  assign n920    = ~n16 & n919;
  assign n921    = n303 & n920;
  assign n922    = ~n918 & ~n921;
  assign n923    = ~x[7] & ~n922;
  assign n924    = x[2] & x[0];
  assign n925    = n362 & n924;
  assign n926    = n39 & n925;
  assign n927    = n260 & n622;
  assign n928    = ~n303 & n569;
  assign n929    = n129 & n928;
  assign n930    = ~n927 & ~n929;
  assign n931    = x[5] & ~n930;
  assign n932    = ~n533 & ~n926;
  assign n933    = ~n931 & n932;
  assign n934    = ~n923 & n933;
  assign n935    = ~n911 & n934;
  assign n936    = ~x[4] & ~n935;
  assign n937    = ~n70 & n130;
  assign n938    = x[3] & ~n223;
  assign n939    = n753 & ~n938;
  assign n940    = n133 & n212;
  assign n941    = ~n939 & ~n940;
  assign n942    = x[0] & ~n941;
  assign n943    = x[2] & n653;
  assign n944    = x[1] & ~n943;
  assign n945    = ~n937 & n944;
  assign n946    = ~n942 & n945;
  assign n947    = n126 & n660;
  assign n948    = x[6] & n303;
  assign n949    = ~n101 & n235;
  assign n950    = ~n948 & n949;
  assign n951    = ~x[1] & ~n947;
  assign n952    = ~n950 & n951;
  assign n953    = x[7] & ~n952;
  assign n954    = ~n946 & n953;
  assign n955    = x[6] & n888;
  assign n956    = n183 & n955;
  assign n957    = ~x[7] & ~n522;
  assign n958    = ~n129 & ~n298;
  assign n959    = n957 & n958;
  assign n960    = ~n956 & ~n959;
  assign n961    = n116 & ~n261;
  assign n962    = ~n960 & n961;
  assign n963    = ~n89 & n604;
  assign n964    = ~n235 & n963;
  assign n965    = n178 & n312;
  assign n966    = ~x[1] & ~n122;
  assign n967    = ~x[3] & ~n966;
  assign n968    = ~n145 & n967;
  assign n969    = ~n416 & n968;
  assign n970    = ~x[0] & ~n964;
  assign n971    = ~n965 & n970;
  assign n972    = ~n969 & n971;
  assign n973    = ~n145 & ~n363;
  assign n974    = x[5] & n128;
  assign n975    = x[1] & n974;
  assign n976    = ~n973 & ~n975;
  assign n977    = ~x[2] & ~n976;
  assign n978    = ~x[3] & n133;
  assign n979    = n115 & n978;
  assign n980    = x[0] & ~n979;
  assign n981    = ~n977 & n980;
  assign n982    = ~x[7] & ~n981;
  assign n983    = ~n972 & n982;
  assign n984    = n125 & ~n157;
  assign n985    = n133 & n174;
  assign n986    = ~n984 & ~n985;
  assign n987    = n100 & ~n986;
  assign n988    = ~n70 & n443;
  assign n989    = n43 & n426;
  assign n990    = n178 & n484;
  assign n991    = ~n988 & ~n990;
  assign n992    = ~n989 & n991;
  assign n993    = ~x[1] & ~n992;
  assign n994    = ~n987 & ~n993;
  assign n995    = ~x[7] & ~n994;
  assign n996    = x[5] & n752;
  assign n997    = n109 & n996;
  assign n998    = x[3] & ~n133;
  assign n999    = ~n77 & n998;
  assign n1000   = n43 & n999;
  assign n1001   = ~x[2] & ~n997;
  assign n1002   = ~n1000 & n1001;
  assign n1003   = ~n42 & n101;
  assign n1004   = ~n974 & ~n1003;
  assign n1005   = ~x[1] & ~n1004;
  assign n1006   = x[6] & ~n443;
  assign n1007   = n22 & ~n306;
  assign n1008   = ~n1006 & n1007;
  assign n1009   = x[2] & ~n1008;
  assign n1010   = ~n1005 & n1009;
  assign n1011   = x[7] & ~n1010;
  assign n1012   = ~n1002 & n1011;
  assign n1013   = ~n995 & ~n1012;
  assign n1014   = x[4] & ~n1013;
  assign n1015   = ~n954 & ~n962;
  assign n1016   = ~n983 & n1015;
  assign n1017   = ~n1014 & n1016;
  assign n1018   = ~n936 & n1017;
  assign n1019   = n165 & n259;
  assign n1020   = ~x[4] & ~n18;
  assign n1021   = ~n261 & n1020;
  assign n1022   = ~n1019 & ~n1021;
  assign n1023   = ~x[1] & ~n1022;
  assign n1024   = ~n353 & ~n1023;
  assign n1025   = ~x[5] & ~n1024;
  assign n1026   = n24 & n259;
  assign n1027   = n425 & n1026;
  assign n1028   = ~n1025 & ~n1027;
  assign n1029   = x[3] & ~n1028;
  assign n1030   = n545 & n690;
  assign n1031   = n115 & n675;
  assign n1032   = n281 & n417;
  assign n1033   = n425 & n1032;
  assign n1034   = ~x[1] & n40;
  assign n1035   = ~n733 & ~n1034;
  assign n1036   = ~n19 & n877;
  assign n1037   = ~n1035 & n1036;
  assign n1038   = ~n1030 & ~n1031;
  assign n1039   = ~n1037 & n1038;
  assign n1040   = ~n1033 & n1039;
  assign n1041   = ~x[3] & ~n1040;
  assign n1042   = ~n495 & n527;
  assign n1043   = n98 & n121;
  assign n1044   = ~n1042 & ~n1043;
  assign n1045   = n683 & ~n1044;
  assign n1046   = ~n40 & ~n261;
  assign n1047   = n312 & ~n813;
  assign n1048   = ~n90 & n1047;
  assign n1049   = n1046 & n1048;
  assign n1050   = ~n1045 & ~n1049;
  assign n1051   = ~n1041 & n1050;
  assign n1052   = ~n1029 & n1051;
  assign n1053   = x[6] & ~n1052;
  assign n1054   = n28 & ~n261;
  assign n1055   = ~x[4] & ~n121;
  assign n1056   = ~n733 & n1055;
  assign n1057   = n116 & n1056;
  assign n1058   = ~n1054 & ~n1057;
  assign n1059   = ~x[7] & ~n1058;
  assign n1060   = ~x[3] & ~n1059;
  assign n1061   = ~n90 & n417;
  assign n1062   = ~n46 & n1061;
  assign n1063   = n26 & n62;
  assign n1064   = x[7] & ~n1063;
  assign n1065   = ~n1062 & n1064;
  assign n1066   = x[5] & n424;
  assign n1067   = n261 & n1066;
  assign n1068   = ~x[1] & ~n26;
  assign n1069   = ~x[4] & ~n1068;
  assign n1070   = ~n261 & n1069;
  assign n1071   = n227 & ~n1067;
  assign n1072   = ~n1070 & n1071;
  assign n1073   = ~x[6] & ~n1072;
  assign n1074   = ~n1065 & n1073;
  assign n1075   = ~n1060 & n1074;
  assign n1076   = ~n683 & n752;
  assign n1077   = n163 & ~n1076;
  assign n1078   = ~x[5] & ~n1077;
  assign n1079   = ~n64 & ~n752;
  assign n1080   = ~x[3] & ~n683;
  assign n1081   = x[5] & ~n1079;
  assign n1082   = ~n1080 & n1081;
  assign n1083   = ~n1078 & ~n1082;
  assign n1084   = n865 & ~n1083;
  assign n1085   = n274 & n586;
  assign n1086   = ~x[7] & n271;
  assign n1087   = n159 & n1086;
  assign n1088   = ~n1085 & ~n1087;
  assign n1089   = x[0] & ~n1088;
  assign n1090   = x[7] & n287;
  assign n1091   = ~n1089 & ~n1090;
  assign n1092   = ~n123 & ~n1091;
  assign n1093   = x[6] & n405;
  assign n1094   = n16 & n1093;
  assign n1095   = ~x[6] & n298;
  assign n1096   = ~n334 & ~n1095;
  assign n1097   = x[5] & ~n127;
  assign n1098   = ~n1096 & n1097;
  assign n1099   = ~x[7] & ~n1094;
  assign n1100   = ~n1098 & n1099;
  assign n1101   = n159 & n497;
  assign n1102   = ~x[5] & ~n224;
  assign n1103   = n298 & n1102;
  assign n1104   = ~n174 & n1103;
  assign n1105   = x[7] & ~n1101;
  assign n1106   = ~n1104 & n1105;
  assign n1107   = ~n88 & ~n1106;
  assign n1108   = ~n1100 & n1107;
  assign n1109   = ~x[6] & ~n298;
  assign n1110   = ~n955 & ~n1109;
  assign n1111   = ~x[5] & ~n1110;
  assign n1112   = n111 & n298;
  assign n1113   = ~n1111 & ~n1112;
  assign n1114   = ~x[2] & ~n1113;
  assign n1115   = ~n101 & ~n541;
  assign n1116   = n122 & ~n1115;
  assign n1117   = ~x[7] & ~n1116;
  assign n1118   = ~n1114 & n1117;
  assign n1119   = ~x[2] & n604;
  assign n1120   = ~n978 & ~n1119;
  assign n1121   = x[4] & ~n1120;
  assign n1122   = ~x[4] & ~n753;
  assign n1123   = n127 & ~n996;
  assign n1124   = n1122 & n1123;
  assign n1125   = x[7] & ~n1124;
  assign n1126   = ~n1121 & n1125;
  assign n1127   = n88 & ~n1126;
  assign n1128   = ~n1118 & n1127;
  assign n1129   = ~n1084 & ~n1108;
  assign n1130   = ~n1075 & n1129;
  assign n1131   = ~n1092 & n1130;
  assign n1132   = ~n1128 & n1131;
  assign n1133   = ~n1053 & n1132;

  // ---- Output inversions ----
  assign y[7]  = ~n211;
  assign y[6]  = ~n372;
  assign y[5]  = ~n514;
  assign y[4]  = ~n640;
  assign y[3]  = ~n777;
  assign y[2]  = ~n900;
  assign y[1]  = ~n1018;
  assign y[0]  = ~n1133;

endmodule

`default_nettype wire
