// -----------------------------------------------------------------------------
// aes_sbox_anf.sv  --  AES SubBytes S-box in Algebraic Normal Form (ANF)
// -----------------------------------------------------------------------------

`default_nettype none

module aes_sbox_anf (
    input  logic [7:0] x,
    output logic [7:0] y
);

  // ---- monomial products ----
  logic m_03, m_05, m_06, m_07, m_09, m_0a, m_0b, m_0c, m_0d, m_0e, m_0f,
        m_11, m_12, m_13, m_14, m_15, m_16, m_17, m_18, m_19, m_1a, m_1b,
        m_1c, m_1d, m_1e, m_1f, m_21, m_22, m_23, m_24, m_25, m_26, m_27,
        m_28, m_29, m_2a, m_2b, m_2c, m_2d, m_2e, m_2f, m_30, m_31, m_32,
        m_33, m_34, m_35, m_36, m_37, m_38, m_39, m_3a, m_3b, m_3c, m_3d,
        m_3e, m_3f, m_41, m_42, m_43, m_44, m_45, m_46, m_47, m_48, m_49,
        m_4a, m_4b, m_4c, m_4d, m_4e, m_4f, m_50, m_51, m_52, m_53, m_54,
        m_55, m_56, m_57, m_58, m_59, m_5a, m_5b, m_5c, m_5d, m_5e, m_5f,
        m_60, m_61, m_62, m_63, m_64, m_65, m_66, m_67, m_68, m_69, m_6a,
        m_6b, m_6c, m_6d, m_6e, m_6f, m_70, m_71, m_72, m_73, m_74, m_75,
        m_76, m_77, m_78, m_79, m_7a, m_7b, m_7c, m_7d, m_7e, m_7f, m_81,
        m_82, m_83, m_84, m_85, m_86, m_87, m_88, m_89, m_8a, m_8b, m_8c,
        m_8d, m_8e, m_8f, m_90, m_91, m_92, m_93, m_94, m_95, m_96, m_97,
        m_98, m_99, m_9a, m_9b, m_9c, m_9d, m_9e, m_9f, m_a0, m_a1, m_a2,
        m_a3, m_a4, m_a5, m_a6, m_a7, m_a8, m_a9, m_aa, m_ab, m_ac, m_ad,
        m_ae, m_af, m_b0, m_b1, m_b2, m_b3, m_b4, m_b5, m_b6, m_b7, m_b8,
        m_b9, m_ba, m_bb, m_bc, m_bd, m_be, m_bf, m_c0, m_c1, m_c2, m_c3,
        m_c4, m_c5, m_c6, m_c7, m_c8, m_c9, m_ca, m_cb, m_cc, m_cd, m_ce,
        m_cf, m_d0, m_d1, m_d2, m_d3, m_d4, m_d5, m_d6, m_d7, m_d8, m_d9,
        m_da, m_db, m_dc, m_dd, m_de, m_df, m_e0, m_e1, m_e2, m_e3, m_e4,
        m_e5, m_e6, m_e7, m_e8, m_e9, m_ea, m_eb, m_ec, m_ed, m_ee, m_ef,
        m_f0, m_f1, m_f2, m_f3, m_f4, m_f5, m_f6, m_f7, m_f8, m_f9, m_fa,
        m_fb, m_fc, m_fd, m_fe;

  // ---- XOR tree nodes ----
  logic t0_0_0, t0_0_1, t0_0_2, t0_0_3, t0_0_4, t0_0_5, t0_0_6, t0_0_7,
        t0_0_8, t0_0_9, t0_0_10, t0_0_11, t0_0_12, t0_0_13, t0_0_14,
        t0_0_15, t0_0_16, t0_0_17, t0_0_18, t0_0_19, t0_0_20, t0_0_21,
        t0_0_22, t0_0_23, t0_0_24, t0_0_25, t0_0_26, t0_0_27, t0_0_28,
        t0_0_29, t0_0_30, t0_0_31, t0_0_32, t0_0_33, t0_0_34, t0_0_35,
        t0_0_36, t0_0_37, t0_0_38, t0_0_39, t0_0_40, t0_0_41, t0_0_42,
        t0_0_43, t0_0_44, t0_0_45, t0_0_46, t0_0_47, t0_0_48, t0_0_49,
        t0_0_50, t0_0_51, t0_0_52, t0_0_53, t0_0_54, t0_0_55, t0_0_56,
        t0_0_57, t0_0_58, t0_0_59, t0_0_60, t0_0_61, t0_0_62, t0_0_63,
        t0_0_64, t0_1_0, t0_1_1, t0_1_2, t0_1_3, t0_1_4, t0_1_5, t0_1_6,
        t0_1_7, t0_1_8, t0_1_9, t0_1_10, t0_1_11, t0_1_12, t0_1_13, t0_1_14,
        t0_1_15, t0_1_16, t0_1_17, t0_1_18, t0_1_19, t0_1_20, t0_1_21,
        t0_1_22, t0_1_23, t0_1_24, t0_1_25, t0_1_26, t0_1_27, t0_1_28,
        t0_1_29, t0_1_30, t0_1_31, t0_1_32, t0_2_0, t0_2_1, t0_2_2, t0_2_3,
        t0_2_4, t0_2_5, t0_2_6, t0_2_7, t0_2_8, t0_2_9, t0_2_10, t0_2_11,
        t0_2_12, t0_2_13, t0_2_14, t0_2_15, t0_3_0, t0_3_1, t0_3_2, t0_3_3,
        t0_3_4, t0_3_5, t0_3_6, t0_3_7, t0_4_0, t0_4_1, t0_4_2, t0_4_3,
        t0_5_0, t0_5_1, t0_6_0, t0_7_0, t1_0_0, t1_0_1, t1_0_2, t1_0_3,
        t1_0_4, t1_0_5, t1_0_6, t1_0_7, t1_0_8, t1_0_9, t1_0_10, t1_0_11,
        t1_0_12, t1_0_13, t1_0_14, t1_0_15, t1_0_16, t1_0_17, t1_0_18,
        t1_0_19, t1_0_20, t1_0_21, t1_0_22, t1_0_23, t1_0_24, t1_0_25,
        t1_0_26, t1_0_27, t1_0_28, t1_0_29, t1_0_30, t1_0_31, t1_0_32,
        t1_0_33, t1_0_34, t1_0_35, t1_0_36, t1_0_37, t1_0_38, t1_0_39,
        t1_0_40, t1_0_41, t1_0_42, t1_0_43, t1_0_44, t1_0_45, t1_0_46,
        t1_0_47, t1_0_48, t1_0_49, t1_0_50, t1_0_51, t1_0_52, t1_0_53,
        t1_0_54, t1_0_55, t1_0_56, t1_0_57, t1_0_58, t1_0_59, t1_0_60,
        t1_0_61, t1_0_62, t1_0_63, t1_0_64, t1_0_65, t1_1_0, t1_1_1, t1_1_2,
        t1_1_3, t1_1_4, t1_1_5, t1_1_6, t1_1_7, t1_1_8, t1_1_9, t1_1_10,
        t1_1_11, t1_1_12, t1_1_13, t1_1_14, t1_1_15, t1_1_16, t1_1_17,
        t1_1_18, t1_1_19, t1_1_20, t1_1_21, t1_1_22, t1_1_23, t1_1_24,
        t1_1_25, t1_1_26, t1_1_27, t1_1_28, t1_1_29, t1_1_30, t1_1_31,
        t1_1_32, t1_2_0, t1_2_1, t1_2_2, t1_2_3, t1_2_4, t1_2_5, t1_2_6,
        t1_2_7, t1_2_8, t1_2_9, t1_2_10, t1_2_11, t1_2_12, t1_2_13, t1_2_14,
        t1_2_15, t1_3_0, t1_3_1, t1_3_2, t1_3_3, t1_3_4, t1_3_5, t1_3_6,
        t1_3_7, t1_4_0, t1_4_1, t1_4_2, t1_4_3, t1_5_0, t1_5_1, t1_6_0,
        t1_7_0, t2_0_0, t2_0_1, t2_0_2, t2_0_3, t2_0_4, t2_0_5, t2_0_6,
        t2_0_7, t2_0_8, t2_0_9, t2_0_10, t2_0_11, t2_0_12, t2_0_13, t2_0_14,
        t2_0_15, t2_0_16, t2_0_17, t2_0_18, t2_0_19, t2_0_20, t2_0_21,
        t2_0_22, t2_0_23, t2_0_24, t2_0_25, t2_0_26, t2_0_27, t2_0_28,
        t2_0_29, t2_0_30, t2_0_31, t2_0_32, t2_0_33, t2_0_34, t2_0_35,
        t2_0_36, t2_0_37, t2_0_38, t2_0_39, t2_0_40, t2_0_41, t2_0_42,
        t2_0_43, t2_0_44, t2_0_45, t2_0_46, t2_0_47, t2_0_48, t2_0_49,
        t2_0_50, t2_0_51, t2_0_52, t2_0_53, t2_0_54, t2_0_55, t2_0_56,
        t2_0_57, t2_0_58, t2_0_59, t2_0_60, t2_0_61, t2_0_62, t2_0_63,
        t2_0_64, t2_0_65, t2_0_66, t2_0_67, t2_0_68, t2_0_69, t2_0_70,
        t2_0_71, t2_1_0, t2_1_1, t2_1_2, t2_1_3, t2_1_4, t2_1_5, t2_1_6,
        t2_1_7, t2_1_8, t2_1_9, t2_1_10, t2_1_11, t2_1_12, t2_1_13, t2_1_14,
        t2_1_15, t2_1_16, t2_1_17, t2_1_18, t2_1_19, t2_1_20, t2_1_21,
        t2_1_22, t2_1_23, t2_1_24, t2_1_25, t2_1_26, t2_1_27, t2_1_28,
        t2_1_29, t2_1_30, t2_1_31, t2_1_32, t2_1_33, t2_1_34, t2_1_35,
        t2_2_0, t2_2_1, t2_2_2, t2_2_3, t2_2_4, t2_2_5, t2_2_6, t2_2_7,
        t2_2_8, t2_2_9, t2_2_10, t2_2_11, t2_2_12, t2_2_13, t2_2_14,
        t2_2_15, t2_2_16, t2_2_17, t2_3_0, t2_3_1, t2_3_2, t2_3_3, t2_3_4,
        t2_3_5, t2_3_6, t2_3_7, t2_3_8, t2_4_0, t2_4_1, t2_4_2, t2_4_3,
        t2_4_4, t2_5_0, t2_5_1, t2_6_0, t2_7_0, t3_0_0, t3_0_1, t3_0_2,
        t3_0_3, t3_0_4, t3_0_5, t3_0_6, t3_0_7, t3_0_8, t3_0_9, t3_0_10,
        t3_0_11, t3_0_12, t3_0_13, t3_0_14, t3_0_15, t3_0_16, t3_0_17,
        t3_0_18, t3_0_19, t3_0_20, t3_0_21, t3_0_22, t3_0_23, t3_0_24,
        t3_0_25, t3_0_26, t3_0_27, t3_0_28, t3_0_29, t3_0_30, t3_0_31,
        t3_0_32, t3_0_33, t3_0_34, t3_0_35, t3_0_36, t3_0_37, t3_0_38,
        t3_0_39, t3_0_40, t3_0_41, t3_0_42, t3_0_43, t3_0_44, t3_0_45,
        t3_0_46, t3_0_47, t3_0_48, t3_0_49, t3_0_50, t3_0_51, t3_0_52,
        t3_0_53, t3_0_54, t3_0_55, t3_0_56, t3_0_57, t3_0_58, t3_0_59,
        t3_0_60, t3_0_61, t3_0_62, t3_0_63, t3_0_64, t3_0_65, t3_0_66,
        t3_0_67, t3_1_0, t3_1_1, t3_1_2, t3_1_3, t3_1_4, t3_1_5, t3_1_6,
        t3_1_7, t3_1_8, t3_1_9, t3_1_10, t3_1_11, t3_1_12, t3_1_13, t3_1_14,
        t3_1_15, t3_1_16, t3_1_17, t3_1_18, t3_1_19, t3_1_20, t3_1_21,
        t3_1_22, t3_1_23, t3_1_24, t3_1_25, t3_1_26, t3_1_27, t3_1_28,
        t3_1_29, t3_1_30, t3_1_31, t3_1_32, t3_1_33, t3_2_0, t3_2_1, t3_2_2,
        t3_2_3, t3_2_4, t3_2_5, t3_2_6, t3_2_7, t3_2_8, t3_2_9, t3_2_10,
        t3_2_11, t3_2_12, t3_2_13, t3_2_14, t3_2_15, t3_2_16, t3_3_0,
        t3_3_1, t3_3_2, t3_3_3, t3_3_4, t3_3_5, t3_3_6, t3_3_7, t3_4_0,
        t3_4_1, t3_4_2, t3_4_3, t3_5_0, t3_5_1, t3_6_0, t3_7_0, t4_0_0,
        t4_0_1, t4_0_2, t4_0_3, t4_0_4, t4_0_5, t4_0_6, t4_0_7, t4_0_8,
        t4_0_9, t4_0_10, t4_0_11, t4_0_12, t4_0_13, t4_0_14, t4_0_15,
        t4_0_16, t4_0_17, t4_0_18, t4_0_19, t4_0_20, t4_0_21, t4_0_22,
        t4_0_23, t4_0_24, t4_0_25, t4_0_26, t4_0_27, t4_0_28, t4_0_29,
        t4_0_30, t4_0_31, t4_0_32, t4_0_33, t4_0_34, t4_0_35, t4_0_36,
        t4_0_37, t4_0_38, t4_0_39, t4_0_40, t4_0_41, t4_0_42, t4_0_43,
        t4_0_44, t4_0_45, t4_0_46, t4_0_47, t4_0_48, t4_0_49, t4_0_50,
        t4_0_51, t4_0_52, t4_0_53, t4_0_54, t4_0_55, t4_0_56, t4_0_57,
        t4_0_58, t4_0_59, t4_0_60, t4_0_61, t4_0_62, t4_0_63, t4_0_64,
        t4_1_0, t4_1_1, t4_1_2, t4_1_3, t4_1_4, t4_1_5, t4_1_6, t4_1_7,
        t4_1_8, t4_1_9, t4_1_10, t4_1_11, t4_1_12, t4_1_13, t4_1_14,
        t4_1_15, t4_1_16, t4_1_17, t4_1_18, t4_1_19, t4_1_20, t4_1_21,
        t4_1_22, t4_1_23, t4_1_24, t4_1_25, t4_1_26, t4_1_27, t4_1_28,
        t4_1_29, t4_1_30, t4_1_31, t4_1_32, t4_2_0, t4_2_1, t4_2_2, t4_2_3,
        t4_2_4, t4_2_5, t4_2_6, t4_2_7, t4_2_8, t4_2_9, t4_2_10, t4_2_11,
        t4_2_12, t4_2_13, t4_2_14, t4_2_15, t4_3_0, t4_3_1, t4_3_2, t4_3_3,
        t4_3_4, t4_3_5, t4_3_6, t4_3_7, t4_4_0, t4_4_1, t4_4_2, t4_4_3,
        t4_5_0, t4_5_1, t4_6_0, t4_7_0, t5_0_0, t5_0_1, t5_0_2, t5_0_3,
        t5_0_4, t5_0_5, t5_0_6, t5_0_7, t5_0_8, t5_0_9, t5_0_10, t5_0_11,
        t5_0_12, t5_0_13, t5_0_14, t5_0_15, t5_0_16, t5_0_17, t5_0_18,
        t5_0_19, t5_0_20, t5_0_21, t5_0_22, t5_0_23, t5_0_24, t5_0_25,
        t5_0_26, t5_0_27, t5_0_28, t5_0_29, t5_0_30, t5_0_31, t5_0_32,
        t5_0_33, t5_0_34, t5_0_35, t5_0_36, t5_0_37, t5_0_38, t5_0_39,
        t5_0_40, t5_0_41, t5_0_42, t5_0_43, t5_0_44, t5_0_45, t5_0_46,
        t5_0_47, t5_0_48, t5_0_49, t5_0_50, t5_0_51, t5_0_52, t5_0_53,
        t5_0_54, t5_0_55, t5_1_0, t5_1_1, t5_1_2, t5_1_3, t5_1_4, t5_1_5,
        t5_1_6, t5_1_7, t5_1_8, t5_1_9, t5_1_10, t5_1_11, t5_1_12, t5_1_13,
        t5_1_14, t5_1_15, t5_1_16, t5_1_17, t5_1_18, t5_1_19, t5_1_20,
        t5_1_21, t5_1_22, t5_1_23, t5_1_24, t5_1_25, t5_1_26, t5_1_27,
        t5_2_0, t5_2_1, t5_2_2, t5_2_3, t5_2_4, t5_2_5, t5_2_6, t5_2_7,
        t5_2_8, t5_2_9, t5_2_10, t5_2_11, t5_2_12, t5_2_13, t5_3_0, t5_3_1,
        t5_3_2, t5_3_3, t5_3_4, t5_3_5, t5_3_6, t5_4_0, t5_4_1, t5_4_2,
        t5_4_3, t5_5_0, t5_5_1, t5_6_0, t6_0_0, t6_0_1, t6_0_2, t6_0_3,
        t6_0_4, t6_0_5, t6_0_6, t6_0_7, t6_0_8, t6_0_9, t6_0_10, t6_0_11,
        t6_0_12, t6_0_13, t6_0_14, t6_0_15, t6_0_16, t6_0_17, t6_0_18,
        t6_0_19, t6_0_20, t6_0_21, t6_0_22, t6_0_23, t6_0_24, t6_0_25,
        t6_0_26, t6_0_27, t6_0_28, t6_0_29, t6_0_30, t6_0_31, t6_0_32,
        t6_0_33, t6_0_34, t6_0_35, t6_0_36, t6_0_37, t6_0_38, t6_0_39,
        t6_0_40, t6_0_41, t6_0_42, t6_0_43, t6_0_44, t6_0_45, t6_0_46,
        t6_0_47, t6_0_48, t6_0_49, t6_0_50, t6_0_51, t6_0_52, t6_0_53,
        t6_0_54, t6_1_0, t6_1_1, t6_1_2, t6_1_3, t6_1_4, t6_1_5, t6_1_6,
        t6_1_7, t6_1_8, t6_1_9, t6_1_10, t6_1_11, t6_1_12, t6_1_13, t6_1_14,
        t6_1_15, t6_1_16, t6_1_17, t6_1_18, t6_1_19, t6_1_20, t6_1_21,
        t6_1_22, t6_1_23, t6_1_24, t6_1_25, t6_1_26, t6_1_27, t6_2_0,
        t6_2_1, t6_2_2, t6_2_3, t6_2_4, t6_2_5, t6_2_6, t6_2_7, t6_2_8,
        t6_2_9, t6_2_10, t6_2_11, t6_2_12, t6_2_13, t6_3_0, t6_3_1, t6_3_2,
        t6_3_3, t6_3_4, t6_3_5, t6_3_6, t6_4_0, t6_4_1, t6_4_2, t6_5_0,
        t6_5_1, t6_6_0, t7_0_0, t7_0_1, t7_0_2, t7_0_3, t7_0_4, t7_0_5,
        t7_0_6, t7_0_7, t7_0_8, t7_0_9, t7_0_10, t7_0_11, t7_0_12, t7_0_13,
        t7_0_14, t7_0_15, t7_0_16, t7_0_17, t7_0_18, t7_0_19, t7_0_20,
        t7_0_21, t7_0_22, t7_0_23, t7_0_24, t7_0_25, t7_0_26, t7_0_27,
        t7_0_28, t7_0_29, t7_0_30, t7_0_31, t7_0_32, t7_0_33, t7_0_34,
        t7_0_35, t7_0_36, t7_0_37, t7_0_38, t7_0_39, t7_0_40, t7_0_41,
        t7_0_42, t7_0_43, t7_0_44, t7_0_45, t7_0_46, t7_0_47, t7_0_48,
        t7_0_49, t7_0_50, t7_0_51, t7_0_52, t7_0_53, t7_0_54, t7_1_0,
        t7_1_1, t7_1_2, t7_1_3, t7_1_4, t7_1_5, t7_1_6, t7_1_7, t7_1_8,
        t7_1_9, t7_1_10, t7_1_11, t7_1_12, t7_1_13, t7_1_14, t7_1_15,
        t7_1_16, t7_1_17, t7_1_18, t7_1_19, t7_1_20, t7_1_21, t7_1_22,
        t7_1_23, t7_1_24, t7_1_25, t7_1_26, t7_2_0, t7_2_1, t7_2_2, t7_2_3,
        t7_2_4, t7_2_5, t7_2_6, t7_2_7, t7_2_8, t7_2_9, t7_2_10, t7_2_11,
        t7_2_12, t7_2_13, t7_3_0, t7_3_1, t7_3_2, t7_3_3, t7_3_4, t7_3_5,
        t7_3_6, t7_4_0, t7_4_1, t7_4_2, t7_5_0, t7_5_1, t7_6_0;

  // ---- monomials: m_S = m_(S \ lsb) & x[lsb] ----
  assign m_03    = x[1] & x[0];                  // x1 x0
  assign m_05    = x[2] & x[0];                  // x2 x0
  assign m_06    = x[2] & x[1];                  // x2 x1
  assign m_07    = m_06 & x[0];                  // x2 x1 x0
  assign m_09    = x[3] & x[0];                  // x3 x0
  assign m_0a    = x[3] & x[1];                  // x3 x1
  assign m_0b    = m_0a & x[0];                  // x3 x1 x0
  assign m_0c    = x[3] & x[2];                  // x3 x2
  assign m_0d    = m_0c & x[0];                  // x3 x2 x0
  assign m_0e    = m_0c & x[1];                  // x3 x2 x1
  assign m_0f    = m_0e & x[0];                  // x3 x2 x1 x0
  assign m_11    = x[4] & x[0];                  // x4 x0
  assign m_12    = x[4] & x[1];                  // x4 x1
  assign m_13    = m_12 & x[0];                  // x4 x1 x0
  assign m_14    = x[4] & x[2];                  // x4 x2
  assign m_15    = m_14 & x[0];                  // x4 x2 x0
  assign m_16    = m_14 & x[1];                  // x4 x2 x1
  assign m_17    = m_16 & x[0];                  // x4 x2 x1 x0
  assign m_18    = x[4] & x[3];                  // x4 x3
  assign m_19    = m_18 & x[0];                  // x4 x3 x0
  assign m_1a    = m_18 & x[1];                  // x4 x3 x1
  assign m_1b    = m_1a & x[0];                  // x4 x3 x1 x0
  assign m_1c    = m_18 & x[2];                  // x4 x3 x2
  assign m_1d    = m_1c & x[0];                  // x4 x3 x2 x0
  assign m_1e    = m_1c & x[1];                  // x4 x3 x2 x1
  assign m_1f    = m_1e & x[0];                  // x4 x3 x2 x1 x0
  assign m_21    = x[5] & x[0];                  // x5 x0
  assign m_22    = x[5] & x[1];                  // x5 x1
  assign m_23    = m_22 & x[0];                  // x5 x1 x0
  assign m_24    = x[5] & x[2];                  // x5 x2
  assign m_25    = m_24 & x[0];                  // x5 x2 x0
  assign m_26    = m_24 & x[1];                  // x5 x2 x1
  assign m_27    = m_26 & x[0];                  // x5 x2 x1 x0
  assign m_28    = x[5] & x[3];                  // x5 x3
  assign m_29    = m_28 & x[0];                  // x5 x3 x0
  assign m_2a    = m_28 & x[1];                  // x5 x3 x1
  assign m_2b    = m_2a & x[0];                  // x5 x3 x1 x0
  assign m_2c    = m_28 & x[2];                  // x5 x3 x2
  assign m_2d    = m_2c & x[0];                  // x5 x3 x2 x0
  assign m_2e    = m_2c & x[1];                  // x5 x3 x2 x1
  assign m_2f    = m_2e & x[0];                  // x5 x3 x2 x1 x0
  assign m_30    = x[5] & x[4];                  // x5 x4
  assign m_31    = m_30 & x[0];                  // x5 x4 x0
  assign m_32    = m_30 & x[1];                  // x5 x4 x1
  assign m_33    = m_32 & x[0];                  // x5 x4 x1 x0
  assign m_34    = m_30 & x[2];                  // x5 x4 x2
  assign m_35    = m_34 & x[0];                  // x5 x4 x2 x0
  assign m_36    = m_34 & x[1];                  // x5 x4 x2 x1
  assign m_37    = m_36 & x[0];                  // x5 x4 x2 x1 x0
  assign m_38    = m_30 & x[3];                  // x5 x4 x3
  assign m_39    = m_38 & x[0];                  // x5 x4 x3 x0
  assign m_3a    = m_38 & x[1];                  // x5 x4 x3 x1
  assign m_3b    = m_3a & x[0];                  // x5 x4 x3 x1 x0
  assign m_3c    = m_38 & x[2];                  // x5 x4 x3 x2
  assign m_3d    = m_3c & x[0];                  // x5 x4 x3 x2 x0
  assign m_3e    = m_3c & x[1];                  // x5 x4 x3 x2 x1
  assign m_3f    = m_3e & x[0];                  // x5 x4 x3 x2 x1 x0
  assign m_41    = x[6] & x[0];                  // x6 x0
  assign m_42    = x[6] & x[1];                  // x6 x1
  assign m_43    = m_42 & x[0];                  // x6 x1 x0
  assign m_44    = x[6] & x[2];                  // x6 x2
  assign m_45    = m_44 & x[0];                  // x6 x2 x0
  assign m_46    = m_44 & x[1];                  // x6 x2 x1
  assign m_47    = m_46 & x[0];                  // x6 x2 x1 x0
  assign m_48    = x[6] & x[3];                  // x6 x3
  assign m_49    = m_48 & x[0];                  // x6 x3 x0
  assign m_4a    = m_48 & x[1];                  // x6 x3 x1
  assign m_4b    = m_4a & x[0];                  // x6 x3 x1 x0
  assign m_4c    = m_48 & x[2];                  // x6 x3 x2
  assign m_4d    = m_4c & x[0];                  // x6 x3 x2 x0
  assign m_4e    = m_4c & x[1];                  // x6 x3 x2 x1
  assign m_4f    = m_4e & x[0];                  // x6 x3 x2 x1 x0
  assign m_50    = x[6] & x[4];                  // x6 x4
  assign m_51    = m_50 & x[0];                  // x6 x4 x0
  assign m_52    = m_50 & x[1];                  // x6 x4 x1
  assign m_53    = m_52 & x[0];                  // x6 x4 x1 x0
  assign m_54    = m_50 & x[2];                  // x6 x4 x2
  assign m_55    = m_54 & x[0];                  // x6 x4 x2 x0
  assign m_56    = m_54 & x[1];                  // x6 x4 x2 x1
  assign m_57    = m_56 & x[0];                  // x6 x4 x2 x1 x0
  assign m_58    = m_50 & x[3];                  // x6 x4 x3
  assign m_59    = m_58 & x[0];                  // x6 x4 x3 x0
  assign m_5a    = m_58 & x[1];                  // x6 x4 x3 x1
  assign m_5b    = m_5a & x[0];                  // x6 x4 x3 x1 x0
  assign m_5c    = m_58 & x[2];                  // x6 x4 x3 x2
  assign m_5d    = m_5c & x[0];                  // x6 x4 x3 x2 x0
  assign m_5e    = m_5c & x[1];                  // x6 x4 x3 x2 x1
  assign m_5f    = m_5e & x[0];                  // x6 x4 x3 x2 x1 x0
  assign m_60    = x[6] & x[5];                  // x6 x5
  assign m_61    = m_60 & x[0];                  // x6 x5 x0
  assign m_62    = m_60 & x[1];                  // x6 x5 x1
  assign m_63    = m_62 & x[0];                  // x6 x5 x1 x0
  assign m_64    = m_60 & x[2];                  // x6 x5 x2
  assign m_65    = m_64 & x[0];                  // x6 x5 x2 x0
  assign m_66    = m_64 & x[1];                  // x6 x5 x2 x1
  assign m_67    = m_66 & x[0];                  // x6 x5 x2 x1 x0
  assign m_68    = m_60 & x[3];                  // x6 x5 x3
  assign m_69    = m_68 & x[0];                  // x6 x5 x3 x0
  assign m_6a    = m_68 & x[1];                  // x6 x5 x3 x1
  assign m_6b    = m_6a & x[0];                  // x6 x5 x3 x1 x0
  assign m_6c    = m_68 & x[2];                  // x6 x5 x3 x2
  assign m_6d    = m_6c & x[0];                  // x6 x5 x3 x2 x0
  assign m_6e    = m_6c & x[1];                  // x6 x5 x3 x2 x1
  assign m_6f    = m_6e & x[0];                  // x6 x5 x3 x2 x1 x0
  assign m_70    = m_60 & x[4];                  // x6 x5 x4
  assign m_71    = m_70 & x[0];                  // x6 x5 x4 x0
  assign m_72    = m_70 & x[1];                  // x6 x5 x4 x1
  assign m_73    = m_72 & x[0];                  // x6 x5 x4 x1 x0
  assign m_74    = m_70 & x[2];                  // x6 x5 x4 x2
  assign m_75    = m_74 & x[0];                  // x6 x5 x4 x2 x0
  assign m_76    = m_74 & x[1];                  // x6 x5 x4 x2 x1
  assign m_77    = m_76 & x[0];                  // x6 x5 x4 x2 x1 x0
  assign m_78    = m_70 & x[3];                  // x6 x5 x4 x3
  assign m_79    = m_78 & x[0];                  // x6 x5 x4 x3 x0
  assign m_7a    = m_78 & x[1];                  // x6 x5 x4 x3 x1
  assign m_7b    = m_7a & x[0];                  // x6 x5 x4 x3 x1 x0
  assign m_7c    = m_78 & x[2];                  // x6 x5 x4 x3 x2
  assign m_7d    = m_7c & x[0];                  // x6 x5 x4 x3 x2 x0
  assign m_7e    = m_7c & x[1];                  // x6 x5 x4 x3 x2 x1
  assign m_7f    = m_7e & x[0];                  // x6 x5 x4 x3 x2 x1 x0
  assign m_81    = x[7] & x[0];                  // x7 x0
  assign m_82    = x[7] & x[1];                  // x7 x1
  assign m_83    = m_82 & x[0];                  // x7 x1 x0
  assign m_84    = x[7] & x[2];                  // x7 x2
  assign m_85    = m_84 & x[0];                  // x7 x2 x0
  assign m_86    = m_84 & x[1];                  // x7 x2 x1
  assign m_87    = m_86 & x[0];                  // x7 x2 x1 x0
  assign m_88    = x[7] & x[3];                  // x7 x3
  assign m_89    = m_88 & x[0];                  // x7 x3 x0
  assign m_8a    = m_88 & x[1];                  // x7 x3 x1
  assign m_8b    = m_8a & x[0];                  // x7 x3 x1 x0
  assign m_8c    = m_88 & x[2];                  // x7 x3 x2
  assign m_8d    = m_8c & x[0];                  // x7 x3 x2 x0
  assign m_8e    = m_8c & x[1];                  // x7 x3 x2 x1
  assign m_8f    = m_8e & x[0];                  // x7 x3 x2 x1 x0
  assign m_90    = x[7] & x[4];                  // x7 x4
  assign m_91    = m_90 & x[0];                  // x7 x4 x0
  assign m_92    = m_90 & x[1];                  // x7 x4 x1
  assign m_93    = m_92 & x[0];                  // x7 x4 x1 x0
  assign m_94    = m_90 & x[2];                  // x7 x4 x2
  assign m_95    = m_94 & x[0];                  // x7 x4 x2 x0
  assign m_96    = m_94 & x[1];                  // x7 x4 x2 x1
  assign m_97    = m_96 & x[0];                  // x7 x4 x2 x1 x0
  assign m_98    = m_90 & x[3];                  // x7 x4 x3
  assign m_99    = m_98 & x[0];                  // x7 x4 x3 x0
  assign m_9a    = m_98 & x[1];                  // x7 x4 x3 x1
  assign m_9b    = m_9a & x[0];                  // x7 x4 x3 x1 x0
  assign m_9c    = m_98 & x[2];                  // x7 x4 x3 x2
  assign m_9d    = m_9c & x[0];                  // x7 x4 x3 x2 x0
  assign m_9e    = m_9c & x[1];                  // x7 x4 x3 x2 x1
  assign m_9f    = m_9e & x[0];                  // x7 x4 x3 x2 x1 x0
  assign m_a0    = x[7] & x[5];                  // x7 x5
  assign m_a1    = m_a0 & x[0];                  // x7 x5 x0
  assign m_a2    = m_a0 & x[1];                  // x7 x5 x1
  assign m_a3    = m_a2 & x[0];                  // x7 x5 x1 x0
  assign m_a4    = m_a0 & x[2];                  // x7 x5 x2
  assign m_a5    = m_a4 & x[0];                  // x7 x5 x2 x0
  assign m_a6    = m_a4 & x[1];                  // x7 x5 x2 x1
  assign m_a7    = m_a6 & x[0];                  // x7 x5 x2 x1 x0
  assign m_a8    = m_a0 & x[3];                  // x7 x5 x3
  assign m_a9    = m_a8 & x[0];                  // x7 x5 x3 x0
  assign m_aa    = m_a8 & x[1];                  // x7 x5 x3 x1
  assign m_ab    = m_aa & x[0];                  // x7 x5 x3 x1 x0
  assign m_ac    = m_a8 & x[2];                  // x7 x5 x3 x2
  assign m_ad    = m_ac & x[0];                  // x7 x5 x3 x2 x0
  assign m_ae    = m_ac & x[1];                  // x7 x5 x3 x2 x1
  assign m_af    = m_ae & x[0];                  // x7 x5 x3 x2 x1 x0
  assign m_b0    = m_a0 & x[4];                  // x7 x5 x4
  assign m_b1    = m_b0 & x[0];                  // x7 x5 x4 x0
  assign m_b2    = m_b0 & x[1];                  // x7 x5 x4 x1
  assign m_b3    = m_b2 & x[0];                  // x7 x5 x4 x1 x0
  assign m_b4    = m_b0 & x[2];                  // x7 x5 x4 x2
  assign m_b5    = m_b4 & x[0];                  // x7 x5 x4 x2 x0
  assign m_b6    = m_b4 & x[1];                  // x7 x5 x4 x2 x1
  assign m_b7    = m_b6 & x[0];                  // x7 x5 x4 x2 x1 x0
  assign m_b8    = m_b0 & x[3];                  // x7 x5 x4 x3
  assign m_b9    = m_b8 & x[0];                  // x7 x5 x4 x3 x0
  assign m_ba    = m_b8 & x[1];                  // x7 x5 x4 x3 x1
  assign m_bb    = m_ba & x[0];                  // x7 x5 x4 x3 x1 x0
  assign m_bc    = m_b8 & x[2];                  // x7 x5 x4 x3 x2
  assign m_bd    = m_bc & x[0];                  // x7 x5 x4 x3 x2 x0
  assign m_be    = m_bc & x[1];                  // x7 x5 x4 x3 x2 x1
  assign m_bf    = m_be & x[0];                  // x7 x5 x4 x3 x2 x1 x0
  assign m_c0    = x[7] & x[6];                  // x7 x6
  assign m_c1    = m_c0 & x[0];                  // x7 x6 x0
  assign m_c2    = m_c0 & x[1];                  // x7 x6 x1
  assign m_c3    = m_c2 & x[0];                  // x7 x6 x1 x0
  assign m_c4    = m_c0 & x[2];                  // x7 x6 x2
  assign m_c5    = m_c4 & x[0];                  // x7 x6 x2 x0
  assign m_c6    = m_c4 & x[1];                  // x7 x6 x2 x1
  assign m_c7    = m_c6 & x[0];                  // x7 x6 x2 x1 x0
  assign m_c8    = m_c0 & x[3];                  // x7 x6 x3
  assign m_c9    = m_c8 & x[0];                  // x7 x6 x3 x0
  assign m_ca    = m_c8 & x[1];                  // x7 x6 x3 x1
  assign m_cb    = m_ca & x[0];                  // x7 x6 x3 x1 x0
  assign m_cc    = m_c8 & x[2];                  // x7 x6 x3 x2
  assign m_cd    = m_cc & x[0];                  // x7 x6 x3 x2 x0
  assign m_ce    = m_cc & x[1];                  // x7 x6 x3 x2 x1
  assign m_cf    = m_ce & x[0];                  // x7 x6 x3 x2 x1 x0
  assign m_d0    = m_c0 & x[4];                  // x7 x6 x4
  assign m_d1    = m_d0 & x[0];                  // x7 x6 x4 x0
  assign m_d2    = m_d0 & x[1];                  // x7 x6 x4 x1
  assign m_d3    = m_d2 & x[0];                  // x7 x6 x4 x1 x0
  assign m_d4    = m_d0 & x[2];                  // x7 x6 x4 x2
  assign m_d5    = m_d4 & x[0];                  // x7 x6 x4 x2 x0
  assign m_d6    = m_d4 & x[1];                  // x7 x6 x4 x2 x1
  assign m_d7    = m_d6 & x[0];                  // x7 x6 x4 x2 x1 x0
  assign m_d8    = m_d0 & x[3];                  // x7 x6 x4 x3
  assign m_d9    = m_d8 & x[0];                  // x7 x6 x4 x3 x0
  assign m_da    = m_d8 & x[1];                  // x7 x6 x4 x3 x1
  assign m_db    = m_da & x[0];                  // x7 x6 x4 x3 x1 x0
  assign m_dc    = m_d8 & x[2];                  // x7 x6 x4 x3 x2
  assign m_dd    = m_dc & x[0];                  // x7 x6 x4 x3 x2 x0
  assign m_de    = m_dc & x[1];                  // x7 x6 x4 x3 x2 x1
  assign m_df    = m_de & x[0];                  // x7 x6 x4 x3 x2 x1 x0
  assign m_e0    = m_c0 & x[5];                  // x7 x6 x5
  assign m_e1    = m_e0 & x[0];                  // x7 x6 x5 x0
  assign m_e2    = m_e0 & x[1];                  // x7 x6 x5 x1
  assign m_e3    = m_e2 & x[0];                  // x7 x6 x5 x1 x0
  assign m_e4    = m_e0 & x[2];                  // x7 x6 x5 x2
  assign m_e5    = m_e4 & x[0];                  // x7 x6 x5 x2 x0
  assign m_e6    = m_e4 & x[1];                  // x7 x6 x5 x2 x1
  assign m_e7    = m_e6 & x[0];                  // x7 x6 x5 x2 x1 x0
  assign m_e8    = m_e0 & x[3];                  // x7 x6 x5 x3
  assign m_e9    = m_e8 & x[0];                  // x7 x6 x5 x3 x0
  assign m_ea    = m_e8 & x[1];                  // x7 x6 x5 x3 x1
  assign m_eb    = m_ea & x[0];                  // x7 x6 x5 x3 x1 x0
  assign m_ec    = m_e8 & x[2];                  // x7 x6 x5 x3 x2
  assign m_ed    = m_ec & x[0];                  // x7 x6 x5 x3 x2 x0
  assign m_ee    = m_ec & x[1];                  // x7 x6 x5 x3 x2 x1
  assign m_ef    = m_ee & x[0];                  // x7 x6 x5 x3 x2 x1 x0
  assign m_f0    = m_e0 & x[4];                  // x7 x6 x5 x4
  assign m_f1    = m_f0 & x[0];                  // x7 x6 x5 x4 x0
  assign m_f2    = m_f0 & x[1];                  // x7 x6 x5 x4 x1
  assign m_f3    = m_f2 & x[0];                  // x7 x6 x5 x4 x1 x0
  assign m_f4    = m_f0 & x[2];                  // x7 x6 x5 x4 x2
  assign m_f5    = m_f4 & x[0];                  // x7 x6 x5 x4 x2 x0
  assign m_f6    = m_f4 & x[1];                  // x7 x6 x5 x4 x2 x1
  assign m_f7    = m_f6 & x[0];                  // x7 x6 x5 x4 x2 x1 x0
  assign m_f8    = m_f0 & x[3];                  // x7 x6 x5 x4 x3
  assign m_f9    = m_f8 & x[0];                  // x7 x6 x5 x4 x3 x0
  assign m_fa    = m_f8 & x[1];                  // x7 x6 x5 x4 x3 x1
  assign m_fb    = m_fa & x[0];                  // x7 x6 x5 x4 x3 x1 x0
  assign m_fc    = m_f8 & x[2];                  // x7 x6 x5 x4 x3 x2
  assign m_fd    = m_fc & x[0];                  // x7 x6 x5 x4 x3 x2 x0
  assign m_fe    = m_fc & x[1];                  // x7 x6 x5 x4 x3 x2 x1

  // ---- XOR trees ----
  // ---- y[0] : 131 monomials, constant term 1, XOR tree depth 8 ----
  assign t0_0_0    = x[0] ^ m_03;
  assign t0_0_1    = x[2] ^ m_06;
  assign t0_0_2    = x[3] ^ m_0a;
  assign t0_0_3    = m_0c ^ m_0e;
  assign t0_0_4    = m_0f ^ x[4];
  assign t0_0_5    = m_11 ^ m_12;
  assign t0_0_6    = m_13 ^ m_14;
  assign t0_0_7    = m_15 ^ m_16;
  assign t0_0_8    = m_19 ^ m_1a;
  assign t0_0_9    = m_1f ^ m_21;
  assign t0_0_10   = m_25 ^ m_27;
  assign t0_0_11   = m_29 ^ m_2c;
  assign t0_0_12   = m_2d ^ m_2e;
  assign t0_0_13   = m_33 ^ m_35;
  assign t0_0_14   = m_37 ^ m_3d;
  assign t0_0_15   = m_41 ^ m_42;
  assign t0_0_16   = m_43 ^ m_44;
  assign t0_0_17   = m_45 ^ m_46;
  assign t0_0_18   = m_47 ^ m_49;
  assign t0_0_19   = m_4e ^ m_4f;
  assign t0_0_20   = m_50 ^ m_51;
  assign t0_0_21   = m_52 ^ m_56;
  assign t0_0_22   = m_59 ^ m_5a;
  assign t0_0_23   = m_5b ^ m_5d;
  assign t0_0_24   = m_5f ^ m_60;
  assign t0_0_25   = m_62 ^ m_64;
  assign t0_0_26   = m_65 ^ m_69;
  assign t0_0_27   = m_6b ^ m_6e;
  assign t0_0_28   = m_70 ^ m_71;
  assign t0_0_29   = m_72 ^ m_73;
  assign t0_0_30   = m_74 ^ m_76;
  assign t0_0_31   = m_79 ^ m_7c;
  assign t0_0_32   = m_7d ^ m_83;
  assign t0_0_33   = m_84 ^ m_85;
  assign t0_0_34   = m_87 ^ m_8a;
  assign t0_0_35   = m_8c ^ m_8d;
  assign t0_0_36   = m_8e ^ m_8f;
  assign t0_0_37   = m_91 ^ m_93;
  assign t0_0_38   = m_94 ^ m_95;
  assign t0_0_39   = m_96 ^ m_97;
  assign t0_0_40   = m_98 ^ m_9f;
  assign t0_0_41   = m_a0 ^ m_a4;
  assign t0_0_42   = m_a5 ^ m_a7;
  assign t0_0_43   = m_a8 ^ m_ab;
  assign t0_0_44   = m_ac ^ m_ae;
  assign t0_0_45   = m_af ^ m_b1;
  assign t0_0_46   = m_b2 ^ m_b4;
  assign t0_0_47   = m_b5 ^ m_b7;
  assign t0_0_48   = m_b9 ^ m_ba;
  assign t0_0_49   = m_bc ^ m_bd;
  assign t0_0_50   = m_c0 ^ m_c4;
  assign t0_0_51   = m_c6 ^ m_c7;
  assign t0_0_52   = m_c8 ^ m_ca;
  assign t0_0_53   = m_cb ^ m_cc;
  assign t0_0_54   = m_cf ^ m_d1;
  assign t0_0_55   = m_d5 ^ m_d6;
  assign t0_0_56   = m_d9 ^ m_db;
  assign t0_0_57   = m_de ^ m_df;
  assign t0_0_58   = m_e0 ^ m_e2;
  assign t0_0_59   = m_e3 ^ m_e6;
  assign t0_0_60   = m_e7 ^ m_e8;
  assign t0_0_61   = m_e9 ^ m_ed;
  assign t0_0_62   = m_f3 ^ m_f4;
  assign t0_0_63   = m_f6 ^ m_f7;
  assign t0_0_64   = m_fa ^ m_fc;
  assign t0_1_0    = t0_0_0 ^ t0_0_1;
  assign t0_1_1    = t0_0_2 ^ t0_0_3;
  assign t0_1_2    = t0_0_4 ^ t0_0_5;
  assign t0_1_3    = t0_0_6 ^ t0_0_7;
  assign t0_1_4    = t0_0_8 ^ t0_0_9;
  assign t0_1_5    = t0_0_10 ^ t0_0_11;
  assign t0_1_6    = t0_0_12 ^ t0_0_13;
  assign t0_1_7    = t0_0_14 ^ t0_0_15;
  assign t0_1_8    = t0_0_16 ^ t0_0_17;
  assign t0_1_9    = t0_0_18 ^ t0_0_19;
  assign t0_1_10   = t0_0_20 ^ t0_0_21;
  assign t0_1_11   = t0_0_22 ^ t0_0_23;
  assign t0_1_12   = t0_0_24 ^ t0_0_25;
  assign t0_1_13   = t0_0_26 ^ t0_0_27;
  assign t0_1_14   = t0_0_28 ^ t0_0_29;
  assign t0_1_15   = t0_0_30 ^ t0_0_31;
  assign t0_1_16   = t0_0_32 ^ t0_0_33;
  assign t0_1_17   = t0_0_34 ^ t0_0_35;
  assign t0_1_18   = t0_0_36 ^ t0_0_37;
  assign t0_1_19   = t0_0_38 ^ t0_0_39;
  assign t0_1_20   = t0_0_40 ^ t0_0_41;
  assign t0_1_21   = t0_0_42 ^ t0_0_43;
  assign t0_1_22   = t0_0_44 ^ t0_0_45;
  assign t0_1_23   = t0_0_46 ^ t0_0_47;
  assign t0_1_24   = t0_0_48 ^ t0_0_49;
  assign t0_1_25   = t0_0_50 ^ t0_0_51;
  assign t0_1_26   = t0_0_52 ^ t0_0_53;
  assign t0_1_27   = t0_0_54 ^ t0_0_55;
  assign t0_1_28   = t0_0_56 ^ t0_0_57;
  assign t0_1_29   = t0_0_58 ^ t0_0_59;
  assign t0_1_30   = t0_0_60 ^ t0_0_61;
  assign t0_1_31   = t0_0_62 ^ t0_0_63;
  assign t0_1_32   = t0_0_64 ^ m_fd;
  assign t0_2_0    = t0_1_0 ^ t0_1_1;
  assign t0_2_1    = t0_1_2 ^ t0_1_3;
  assign t0_2_2    = t0_1_4 ^ t0_1_5;
  assign t0_2_3    = t0_1_6 ^ t0_1_7;
  assign t0_2_4    = t0_1_8 ^ t0_1_9;
  assign t0_2_5    = t0_1_10 ^ t0_1_11;
  assign t0_2_6    = t0_1_12 ^ t0_1_13;
  assign t0_2_7    = t0_1_14 ^ t0_1_15;
  assign t0_2_8    = t0_1_16 ^ t0_1_17;
  assign t0_2_9    = t0_1_18 ^ t0_1_19;
  assign t0_2_10   = t0_1_20 ^ t0_1_21;
  assign t0_2_11   = t0_1_22 ^ t0_1_23;
  assign t0_2_12   = t0_1_24 ^ t0_1_25;
  assign t0_2_13   = t0_1_26 ^ t0_1_27;
  assign t0_2_14   = t0_1_28 ^ t0_1_29;
  assign t0_2_15   = t0_1_30 ^ t0_1_31;
  assign t0_3_0    = t0_2_0 ^ t0_2_1;
  assign t0_3_1    = t0_2_2 ^ t0_2_3;
  assign t0_3_2    = t0_2_4 ^ t0_2_5;
  assign t0_3_3    = t0_2_6 ^ t0_2_7;
  assign t0_3_4    = t0_2_8 ^ t0_2_9;
  assign t0_3_5    = t0_2_10 ^ t0_2_11;
  assign t0_3_6    = t0_2_12 ^ t0_2_13;
  assign t0_3_7    = t0_2_14 ^ t0_2_15;
  assign t0_4_0    = t0_3_0 ^ t0_3_1;
  assign t0_4_1    = t0_3_2 ^ t0_3_3;
  assign t0_4_2    = t0_3_4 ^ t0_3_5;
  assign t0_4_3    = t0_3_6 ^ t0_3_7;
  assign t0_5_0    = t0_4_0 ^ t0_4_1;
  assign t0_5_1    = t0_4_2 ^ t0_4_3;
  assign t0_6_0    = t0_5_0 ^ t0_5_1;
  assign t0_7_0    = t0_6_0 ^ t0_1_32;

  // ---- y[1] : 132 monomials, constant term 1, XOR tree depth 8 ----
  assign t1_0_0    = x[0] ^ m_03;
  assign t1_0_1    = m_05 ^ x[3];
  assign t1_0_2    = m_09 ^ m_0a;
  assign t1_0_3    = m_0b ^ m_0c;
  assign t1_0_4    = m_0d ^ m_0e;
  assign t1_0_5    = m_11 ^ m_12;
  assign t1_0_6    = m_13 ^ m_16;
  assign t1_0_7    = m_19 ^ m_1a;
  assign t1_0_8    = m_1b ^ m_1c;
  assign t1_0_9    = m_1f ^ m_2a;
  assign t1_0_10   = m_2c ^ m_2e;
  assign t1_0_11   = m_30 ^ m_31;
  assign t1_0_12   = m_33 ^ m_35;
  assign t1_0_13   = m_37 ^ m_39;
  assign t1_0_14   = m_3a ^ m_3c;
  assign t1_0_15   = m_3d ^ x[6];
  assign t1_0_16   = m_43 ^ m_44;
  assign t1_0_17   = m_47 ^ m_4a;
  assign t1_0_18   = m_4b ^ m_4c;
  assign t1_0_19   = m_4d ^ m_4f;
  assign t1_0_20   = m_50 ^ m_51;
  assign t1_0_21   = m_57 ^ m_58;
  assign t1_0_22   = m_59 ^ m_5b;
  assign t1_0_23   = m_5e ^ m_5f;
  assign t1_0_24   = m_62 ^ m_63;
  assign t1_0_25   = m_65 ^ m_66;
  assign t1_0_26   = m_68 ^ m_6a;
  assign t1_0_27   = m_6b ^ m_6e;
  assign t1_0_28   = m_6f ^ m_71;
  assign t1_0_29   = m_73 ^ m_75;
  assign t1_0_30   = m_76 ^ m_78;
  assign t1_0_31   = m_7a ^ m_7b;
  assign t1_0_32   = m_7d ^ m_7e;
  assign t1_0_33   = x[7] ^ m_81;
  assign t1_0_34   = m_82 ^ m_84;
  assign t1_0_35   = m_85 ^ m_88;
  assign t1_0_36   = m_8a ^ m_8f;
  assign t1_0_37   = m_91 ^ m_92;
  assign t1_0_38   = m_93 ^ m_96;
  assign t1_0_39   = m_97 ^ m_98;
  assign t1_0_40   = m_9a ^ m_9b;
  assign t1_0_41   = m_9c ^ m_9d;
  assign t1_0_42   = m_9f ^ m_a1;
  assign t1_0_43   = m_a4 ^ m_a6;
  assign t1_0_44   = m_a8 ^ m_aa;
  assign t1_0_45   = m_ab ^ m_ac;
  assign t1_0_46   = m_ad ^ m_b1;
  assign t1_0_47   = m_b2 ^ m_b4;
  assign t1_0_48   = m_b7 ^ m_b8;
  assign t1_0_49   = m_b9 ^ m_ba;
  assign t1_0_50   = m_bc ^ m_bd;
  assign t1_0_51   = m_c1 ^ m_c4;
  assign t1_0_52   = m_c6 ^ m_c7;
  assign t1_0_53   = m_c8 ^ m_cb;
  assign t1_0_54   = m_cd ^ m_d1;
  assign t1_0_55   = m_d2 ^ m_d4;
  assign t1_0_56   = m_d7 ^ m_d8;
  assign t1_0_57   = m_db ^ m_dc;
  assign t1_0_58   = m_dd ^ m_de;
  assign t1_0_59   = m_df ^ m_e0;
  assign t1_0_60   = m_e3 ^ m_e5;
  assign t1_0_61   = m_e7 ^ m_e9;
  assign t1_0_62   = m_ed ^ m_ee;
  assign t1_0_63   = m_ef ^ m_f1;
  assign t1_0_64   = m_f4 ^ m_f7;
  assign t1_0_65   = m_fa ^ m_fb;
  assign t1_1_0    = t1_0_0 ^ t1_0_1;
  assign t1_1_1    = t1_0_2 ^ t1_0_3;
  assign t1_1_2    = t1_0_4 ^ t1_0_5;
  assign t1_1_3    = t1_0_6 ^ t1_0_7;
  assign t1_1_4    = t1_0_8 ^ t1_0_9;
  assign t1_1_5    = t1_0_10 ^ t1_0_11;
  assign t1_1_6    = t1_0_12 ^ t1_0_13;
  assign t1_1_7    = t1_0_14 ^ t1_0_15;
  assign t1_1_8    = t1_0_16 ^ t1_0_17;
  assign t1_1_9    = t1_0_18 ^ t1_0_19;
  assign t1_1_10   = t1_0_20 ^ t1_0_21;
  assign t1_1_11   = t1_0_22 ^ t1_0_23;
  assign t1_1_12   = t1_0_24 ^ t1_0_25;
  assign t1_1_13   = t1_0_26 ^ t1_0_27;
  assign t1_1_14   = t1_0_28 ^ t1_0_29;
  assign t1_1_15   = t1_0_30 ^ t1_0_31;
  assign t1_1_16   = t1_0_32 ^ t1_0_33;
  assign t1_1_17   = t1_0_34 ^ t1_0_35;
  assign t1_1_18   = t1_0_36 ^ t1_0_37;
  assign t1_1_19   = t1_0_38 ^ t1_0_39;
  assign t1_1_20   = t1_0_40 ^ t1_0_41;
  assign t1_1_21   = t1_0_42 ^ t1_0_43;
  assign t1_1_22   = t1_0_44 ^ t1_0_45;
  assign t1_1_23   = t1_0_46 ^ t1_0_47;
  assign t1_1_24   = t1_0_48 ^ t1_0_49;
  assign t1_1_25   = t1_0_50 ^ t1_0_51;
  assign t1_1_26   = t1_0_52 ^ t1_0_53;
  assign t1_1_27   = t1_0_54 ^ t1_0_55;
  assign t1_1_28   = t1_0_56 ^ t1_0_57;
  assign t1_1_29   = t1_0_58 ^ t1_0_59;
  assign t1_1_30   = t1_0_60 ^ t1_0_61;
  assign t1_1_31   = t1_0_62 ^ t1_0_63;
  assign t1_1_32   = t1_0_64 ^ t1_0_65;
  assign t1_2_0    = t1_1_0 ^ t1_1_1;
  assign t1_2_1    = t1_1_2 ^ t1_1_3;
  assign t1_2_2    = t1_1_4 ^ t1_1_5;
  assign t1_2_3    = t1_1_6 ^ t1_1_7;
  assign t1_2_4    = t1_1_8 ^ t1_1_9;
  assign t1_2_5    = t1_1_10 ^ t1_1_11;
  assign t1_2_6    = t1_1_12 ^ t1_1_13;
  assign t1_2_7    = t1_1_14 ^ t1_1_15;
  assign t1_2_8    = t1_1_16 ^ t1_1_17;
  assign t1_2_9    = t1_1_18 ^ t1_1_19;
  assign t1_2_10   = t1_1_20 ^ t1_1_21;
  assign t1_2_11   = t1_1_22 ^ t1_1_23;
  assign t1_2_12   = t1_1_24 ^ t1_1_25;
  assign t1_2_13   = t1_1_26 ^ t1_1_27;
  assign t1_2_14   = t1_1_28 ^ t1_1_29;
  assign t1_2_15   = t1_1_30 ^ t1_1_31;
  assign t1_3_0    = t1_2_0 ^ t1_2_1;
  assign t1_3_1    = t1_2_2 ^ t1_2_3;
  assign t1_3_2    = t1_2_4 ^ t1_2_5;
  assign t1_3_3    = t1_2_6 ^ t1_2_7;
  assign t1_3_4    = t1_2_8 ^ t1_2_9;
  assign t1_3_5    = t1_2_10 ^ t1_2_11;
  assign t1_3_6    = t1_2_12 ^ t1_2_13;
  assign t1_3_7    = t1_2_14 ^ t1_2_15;
  assign t1_4_0    = t1_3_0 ^ t1_3_1;
  assign t1_4_1    = t1_3_2 ^ t1_3_3;
  assign t1_4_2    = t1_3_4 ^ t1_3_5;
  assign t1_4_3    = t1_3_6 ^ t1_3_7;
  assign t1_5_0    = t1_4_0 ^ t1_4_1;
  assign t1_5_1    = t1_4_2 ^ t1_4_3;
  assign t1_6_0    = t1_5_0 ^ t1_5_1;
  assign t1_7_0    = t1_6_0 ^ t1_1_32;

  // ---- y[2] : 145 monomials, constant term 0, XOR tree depth 8 ----
  assign t2_0_0    = x[0] ^ x[1];
  assign t2_0_1    = m_05 ^ m_09;
  assign t2_0_2    = m_0b ^ m_0c;
  assign t2_0_3    = m_0d ^ m_11;
  assign t2_0_4    = m_12 ^ m_13;
  assign t2_0_5    = m_15 ^ m_16;
  assign t2_0_6    = m_18 ^ m_19;
  assign t2_0_7    = m_1a ^ m_1b;
  assign t2_0_8    = m_1c ^ m_1d;
  assign t2_0_9    = m_1e ^ m_1f;
  assign t2_0_10   = x[5] ^ m_21;
  assign t2_0_11   = m_23 ^ m_25;
  assign t2_0_12   = m_26 ^ m_27;
  assign t2_0_13   = m_29 ^ m_2a;
  assign t2_0_14   = m_2b ^ m_2d;
  assign t2_0_15   = m_2e ^ m_2f;
  assign t2_0_16   = m_31 ^ m_32;
  assign t2_0_17   = m_34 ^ m_37;
  assign t2_0_18   = m_38 ^ m_3e;
  assign t2_0_19   = m_3f ^ m_41;
  assign t2_0_20   = m_43 ^ m_46;
  assign t2_0_21   = m_49 ^ m_4b;
  assign t2_0_22   = m_4c ^ m_4e;
  assign t2_0_23   = m_4f ^ m_51;
  assign t2_0_24   = m_53 ^ m_55;
  assign t2_0_25   = m_58 ^ m_59;
  assign t2_0_26   = m_5b ^ m_5c;
  assign t2_0_27   = m_5e ^ m_5f;
  assign t2_0_28   = m_60 ^ m_62;
  assign t2_0_29   = m_63 ^ m_68;
  assign t2_0_30   = m_69 ^ m_6c;
  assign t2_0_31   = m_6f ^ m_74;
  assign t2_0_32   = m_75 ^ m_76;
  assign t2_0_33   = m_77 ^ m_78;
  assign t2_0_34   = m_7a ^ m_7d;
  assign t2_0_35   = x[7] ^ m_81;
  assign t2_0_36   = m_83 ^ m_85;
  assign t2_0_37   = m_86 ^ m_87;
  assign t2_0_38   = m_89 ^ m_8a;
  assign t2_0_39   = m_8c ^ m_8d;
  assign t2_0_40   = m_8f ^ m_90;
  assign t2_0_41   = m_91 ^ m_92;
  assign t2_0_42   = m_95 ^ m_96;
  assign t2_0_43   = m_97 ^ m_99;
  assign t2_0_44   = m_9b ^ m_9c;
  assign t2_0_45   = m_9d ^ m_9f;
  assign t2_0_46   = m_a1 ^ m_a2;
  assign t2_0_47   = m_a6 ^ m_a7;
  assign t2_0_48   = m_a9 ^ m_aa;
  assign t2_0_49   = m_ab ^ m_ad;
  assign t2_0_50   = m_b2 ^ m_b4;
  assign t2_0_51   = m_b6 ^ m_b7;
  assign t2_0_52   = m_b9 ^ m_bb;
  assign t2_0_53   = m_be ^ m_c0;
  assign t2_0_54   = m_c1 ^ m_c4;
  assign t2_0_55   = m_c6 ^ m_c7;
  assign t2_0_56   = m_ca ^ m_cb;
  assign t2_0_57   = m_ce ^ m_d0;
  assign t2_0_58   = m_d3 ^ m_d4;
  assign t2_0_59   = m_d6 ^ m_da;
  assign t2_0_60   = m_db ^ m_dc;
  assign t2_0_61   = m_dd ^ m_de;
  assign t2_0_62   = m_df ^ m_e2;
  assign t2_0_63   = m_e4 ^ m_e5;
  assign t2_0_64   = m_e8 ^ m_e9;
  assign t2_0_65   = m_ea ^ m_eb;
  assign t2_0_66   = m_ec ^ m_ed;
  assign t2_0_67   = m_ef ^ m_f0;
  assign t2_0_68   = m_f1 ^ m_f2;
  assign t2_0_69   = m_f3 ^ m_f5;
  assign t2_0_70   = m_f8 ^ m_fb;
  assign t2_0_71   = m_fc ^ m_fd;
  assign t2_1_0    = t2_0_0 ^ t2_0_1;
  assign t2_1_1    = t2_0_2 ^ t2_0_3;
  assign t2_1_2    = t2_0_4 ^ t2_0_5;
  assign t2_1_3    = t2_0_6 ^ t2_0_7;
  assign t2_1_4    = t2_0_8 ^ t2_0_9;
  assign t2_1_5    = t2_0_10 ^ t2_0_11;
  assign t2_1_6    = t2_0_12 ^ t2_0_13;
  assign t2_1_7    = t2_0_14 ^ t2_0_15;
  assign t2_1_8    = t2_0_16 ^ t2_0_17;
  assign t2_1_9    = t2_0_18 ^ t2_0_19;
  assign t2_1_10   = t2_0_20 ^ t2_0_21;
  assign t2_1_11   = t2_0_22 ^ t2_0_23;
  assign t2_1_12   = t2_0_24 ^ t2_0_25;
  assign t2_1_13   = t2_0_26 ^ t2_0_27;
  assign t2_1_14   = t2_0_28 ^ t2_0_29;
  assign t2_1_15   = t2_0_30 ^ t2_0_31;
  assign t2_1_16   = t2_0_32 ^ t2_0_33;
  assign t2_1_17   = t2_0_34 ^ t2_0_35;
  assign t2_1_18   = t2_0_36 ^ t2_0_37;
  assign t2_1_19   = t2_0_38 ^ t2_0_39;
  assign t2_1_20   = t2_0_40 ^ t2_0_41;
  assign t2_1_21   = t2_0_42 ^ t2_0_43;
  assign t2_1_22   = t2_0_44 ^ t2_0_45;
  assign t2_1_23   = t2_0_46 ^ t2_0_47;
  assign t2_1_24   = t2_0_48 ^ t2_0_49;
  assign t2_1_25   = t2_0_50 ^ t2_0_51;
  assign t2_1_26   = t2_0_52 ^ t2_0_53;
  assign t2_1_27   = t2_0_54 ^ t2_0_55;
  assign t2_1_28   = t2_0_56 ^ t2_0_57;
  assign t2_1_29   = t2_0_58 ^ t2_0_59;
  assign t2_1_30   = t2_0_60 ^ t2_0_61;
  assign t2_1_31   = t2_0_62 ^ t2_0_63;
  assign t2_1_32   = t2_0_64 ^ t2_0_65;
  assign t2_1_33   = t2_0_66 ^ t2_0_67;
  assign t2_1_34   = t2_0_68 ^ t2_0_69;
  assign t2_1_35   = t2_0_70 ^ t2_0_71;
  assign t2_2_0    = t2_1_0 ^ t2_1_1;
  assign t2_2_1    = t2_1_2 ^ t2_1_3;
  assign t2_2_2    = t2_1_4 ^ t2_1_5;
  assign t2_2_3    = t2_1_6 ^ t2_1_7;
  assign t2_2_4    = t2_1_8 ^ t2_1_9;
  assign t2_2_5    = t2_1_10 ^ t2_1_11;
  assign t2_2_6    = t2_1_12 ^ t2_1_13;
  assign t2_2_7    = t2_1_14 ^ t2_1_15;
  assign t2_2_8    = t2_1_16 ^ t2_1_17;
  assign t2_2_9    = t2_1_18 ^ t2_1_19;
  assign t2_2_10   = t2_1_20 ^ t2_1_21;
  assign t2_2_11   = t2_1_22 ^ t2_1_23;
  assign t2_2_12   = t2_1_24 ^ t2_1_25;
  assign t2_2_13   = t2_1_26 ^ t2_1_27;
  assign t2_2_14   = t2_1_28 ^ t2_1_29;
  assign t2_2_15   = t2_1_30 ^ t2_1_31;
  assign t2_2_16   = t2_1_32 ^ t2_1_33;
  assign t2_2_17   = t2_1_34 ^ t2_1_35;
  assign t2_3_0    = t2_2_0 ^ t2_2_1;
  assign t2_3_1    = t2_2_2 ^ t2_2_3;
  assign t2_3_2    = t2_2_4 ^ t2_2_5;
  assign t2_3_3    = t2_2_6 ^ t2_2_7;
  assign t2_3_4    = t2_2_8 ^ t2_2_9;
  assign t2_3_5    = t2_2_10 ^ t2_2_11;
  assign t2_3_6    = t2_2_12 ^ t2_2_13;
  assign t2_3_7    = t2_2_14 ^ t2_2_15;
  assign t2_3_8    = t2_2_16 ^ t2_2_17;
  assign t2_4_0    = t2_3_0 ^ t2_3_1;
  assign t2_4_1    = t2_3_2 ^ t2_3_3;
  assign t2_4_2    = t2_3_4 ^ t2_3_5;
  assign t2_4_3    = t2_3_6 ^ t2_3_7;
  assign t2_4_4    = t2_3_8 ^ m_fe;
  assign t2_5_0    = t2_4_0 ^ t2_4_1;
  assign t2_5_1    = t2_4_2 ^ t2_4_3;
  assign t2_6_0    = t2_5_0 ^ t2_5_1;
  assign t2_7_0    = t2_6_0 ^ t2_4_4;

  // ---- y[3] : 136 monomials, constant term 0, XOR tree depth 8 ----
  assign t3_0_0    = x[0] ^ m_06;
  assign t3_0_1    = m_09 ^ m_0b;
  assign t3_0_2    = m_0c ^ m_0d;
  assign t3_0_3    = m_0e ^ m_0f;
  assign t3_0_4    = x[4] ^ m_13;
  assign t3_0_5    = m_15 ^ m_17;
  assign t3_0_6    = m_19 ^ m_1a;
  assign t3_0_7    = m_1c ^ m_1f;
  assign t3_0_8    = m_23 ^ m_26;
  assign t3_0_9    = m_27 ^ m_2c;
  assign t3_0_10   = m_2e ^ m_2f;
  assign t3_0_11   = m_30 ^ m_31;
  assign t3_0_12   = m_34 ^ m_36;
  assign t3_0_13   = m_3a ^ m_3b;
  assign t3_0_14   = m_3c ^ m_3d;
  assign t3_0_15   = x[6] ^ m_43;
  assign t3_0_16   = m_45 ^ m_46;
  assign t3_0_17   = m_48 ^ m_49;
  assign t3_0_18   = m_4b ^ m_4e;
  assign t3_0_19   = m_51 ^ m_53;
  assign t3_0_20   = m_55 ^ m_59;
  assign t3_0_21   = m_5a ^ m_5b;
  assign t3_0_22   = m_5f ^ m_60;
  assign t3_0_23   = m_62 ^ m_63;
  assign t3_0_24   = m_65 ^ m_67;
  assign t3_0_25   = m_68 ^ m_6a;
  assign t3_0_26   = m_6b ^ m_6d;
  assign t3_0_27   = m_6e ^ m_6f;
  assign t3_0_28   = m_71 ^ m_72;
  assign t3_0_29   = m_74 ^ m_75;
  assign t3_0_30   = m_76 ^ m_78;
  assign t3_0_31   = m_79 ^ m_7c;
  assign t3_0_32   = m_7e ^ m_7f;
  assign t3_0_33   = x[7] ^ m_81;
  assign t3_0_34   = m_82 ^ m_83;
  assign t3_0_35   = m_85 ^ m_86;
  assign t3_0_36   = m_88 ^ m_89;
  assign t3_0_37   = m_8c ^ m_8d;
  assign t3_0_38   = m_8e ^ m_8f;
  assign t3_0_39   = m_95 ^ m_96;
  assign t3_0_40   = m_97 ^ m_98;
  assign t3_0_41   = m_9a ^ m_9b;
  assign t3_0_42   = m_9f ^ m_a0;
  assign t3_0_43   = m_a4 ^ m_a6;
  assign t3_0_44   = m_a7 ^ m_a8;
  assign t3_0_45   = m_ad ^ m_af;
  assign t3_0_46   = m_b2 ^ m_b3;
  assign t3_0_47   = m_b4 ^ m_b5;
  assign t3_0_48   = m_b7 ^ m_b9;
  assign t3_0_49   = m_bb ^ m_bc;
  assign t3_0_50   = m_be ^ m_c0;
  assign t3_0_51   = m_c3 ^ m_c5;
  assign t3_0_52   = m_c6 ^ m_c9;
  assign t3_0_53   = m_cd ^ m_cf;
  assign t3_0_54   = m_d2 ^ m_d4;
  assign t3_0_55   = m_d7 ^ m_d8;
  assign t3_0_56   = m_d9 ^ m_da;
  assign t3_0_57   = m_dd ^ m_de;
  assign t3_0_58   = m_e0 ^ m_e1;
  assign t3_0_59   = m_e2 ^ m_e3;
  assign t3_0_60   = m_e5 ^ m_e6;
  assign t3_0_61   = m_e8 ^ m_e9;
  assign t3_0_62   = m_ea ^ m_ed;
  assign t3_0_63   = m_ee ^ m_ef;
  assign t3_0_64   = m_f0 ^ m_f1;
  assign t3_0_65   = m_f4 ^ m_f6;
  assign t3_0_66   = m_f8 ^ m_fb;
  assign t3_0_67   = m_fc ^ m_fd;
  assign t3_1_0    = t3_0_0 ^ t3_0_1;
  assign t3_1_1    = t3_0_2 ^ t3_0_3;
  assign t3_1_2    = t3_0_4 ^ t3_0_5;
  assign t3_1_3    = t3_0_6 ^ t3_0_7;
  assign t3_1_4    = t3_0_8 ^ t3_0_9;
  assign t3_1_5    = t3_0_10 ^ t3_0_11;
  assign t3_1_6    = t3_0_12 ^ t3_0_13;
  assign t3_1_7    = t3_0_14 ^ t3_0_15;
  assign t3_1_8    = t3_0_16 ^ t3_0_17;
  assign t3_1_9    = t3_0_18 ^ t3_0_19;
  assign t3_1_10   = t3_0_20 ^ t3_0_21;
  assign t3_1_11   = t3_0_22 ^ t3_0_23;
  assign t3_1_12   = t3_0_24 ^ t3_0_25;
  assign t3_1_13   = t3_0_26 ^ t3_0_27;
  assign t3_1_14   = t3_0_28 ^ t3_0_29;
  assign t3_1_15   = t3_0_30 ^ t3_0_31;
  assign t3_1_16   = t3_0_32 ^ t3_0_33;
  assign t3_1_17   = t3_0_34 ^ t3_0_35;
  assign t3_1_18   = t3_0_36 ^ t3_0_37;
  assign t3_1_19   = t3_0_38 ^ t3_0_39;
  assign t3_1_20   = t3_0_40 ^ t3_0_41;
  assign t3_1_21   = t3_0_42 ^ t3_0_43;
  assign t3_1_22   = t3_0_44 ^ t3_0_45;
  assign t3_1_23   = t3_0_46 ^ t3_0_47;
  assign t3_1_24   = t3_0_48 ^ t3_0_49;
  assign t3_1_25   = t3_0_50 ^ t3_0_51;
  assign t3_1_26   = t3_0_52 ^ t3_0_53;
  assign t3_1_27   = t3_0_54 ^ t3_0_55;
  assign t3_1_28   = t3_0_56 ^ t3_0_57;
  assign t3_1_29   = t3_0_58 ^ t3_0_59;
  assign t3_1_30   = t3_0_60 ^ t3_0_61;
  assign t3_1_31   = t3_0_62 ^ t3_0_63;
  assign t3_1_32   = t3_0_64 ^ t3_0_65;
  assign t3_1_33   = t3_0_66 ^ t3_0_67;
  assign t3_2_0    = t3_1_0 ^ t3_1_1;
  assign t3_2_1    = t3_1_2 ^ t3_1_3;
  assign t3_2_2    = t3_1_4 ^ t3_1_5;
  assign t3_2_3    = t3_1_6 ^ t3_1_7;
  assign t3_2_4    = t3_1_8 ^ t3_1_9;
  assign t3_2_5    = t3_1_10 ^ t3_1_11;
  assign t3_2_6    = t3_1_12 ^ t3_1_13;
  assign t3_2_7    = t3_1_14 ^ t3_1_15;
  assign t3_2_8    = t3_1_16 ^ t3_1_17;
  assign t3_2_9    = t3_1_18 ^ t3_1_19;
  assign t3_2_10   = t3_1_20 ^ t3_1_21;
  assign t3_2_11   = t3_1_22 ^ t3_1_23;
  assign t3_2_12   = t3_1_24 ^ t3_1_25;
  assign t3_2_13   = t3_1_26 ^ t3_1_27;
  assign t3_2_14   = t3_1_28 ^ t3_1_29;
  assign t3_2_15   = t3_1_30 ^ t3_1_31;
  assign t3_2_16   = t3_1_32 ^ t3_1_33;
  assign t3_3_0    = t3_2_0 ^ t3_2_1;
  assign t3_3_1    = t3_2_2 ^ t3_2_3;
  assign t3_3_2    = t3_2_4 ^ t3_2_5;
  assign t3_3_3    = t3_2_6 ^ t3_2_7;
  assign t3_3_4    = t3_2_8 ^ t3_2_9;
  assign t3_3_5    = t3_2_10 ^ t3_2_11;
  assign t3_3_6    = t3_2_12 ^ t3_2_13;
  assign t3_3_7    = t3_2_14 ^ t3_2_15;
  assign t3_4_0    = t3_3_0 ^ t3_3_1;
  assign t3_4_1    = t3_3_2 ^ t3_3_3;
  assign t3_4_2    = t3_3_4 ^ t3_3_5;
  assign t3_4_3    = t3_3_6 ^ t3_3_7;
  assign t3_5_0    = t3_4_0 ^ t3_4_1;
  assign t3_5_1    = t3_4_2 ^ t3_4_3;
  assign t3_6_0    = t3_5_0 ^ t3_5_1;
  assign t3_7_0    = t3_6_0 ^ t3_2_16;

  // ---- y[4] : 131 monomials, constant term 0, XOR tree depth 8 ----
  assign t4_0_0    = x[0] ^ x[1];
  assign t4_0_1    = m_03 ^ x[2];
  assign t4_0_2    = x[3] ^ m_0c;
  assign t4_0_3    = m_0d ^ m_11;
  assign t4_0_4    = m_12 ^ m_16;
  assign t4_0_5    = m_18 ^ m_19;
  assign t4_0_6    = m_1c ^ m_1d;
  assign t4_0_7    = m_1e ^ m_1f;
  assign t4_0_8    = x[5] ^ m_21;
  assign t4_0_9    = m_22 ^ m_24;
  assign t4_0_10   = m_28 ^ m_29;
  assign t4_0_11   = m_2a ^ m_2b;
  assign t4_0_12   = m_2c ^ m_2e;
  assign t4_0_13   = m_30 ^ m_31;
  assign t4_0_14   = m_32 ^ m_33;
  assign t4_0_15   = m_34 ^ m_37;
  assign t4_0_16   = m_38 ^ m_39;
  assign t4_0_17   = m_3a ^ m_3d;
  assign t4_0_18   = m_3f ^ m_41;
  assign t4_0_19   = m_42 ^ m_45;
  assign t4_0_20   = m_47 ^ m_4b;
  assign t4_0_21   = m_4c ^ m_4f;
  assign t4_0_22   = m_50 ^ m_51;
  assign t4_0_23   = m_53 ^ m_56;
  assign t4_0_24   = m_58 ^ m_59;
  assign t4_0_25   = m_5b ^ m_5d;
  assign t4_0_26   = m_5e ^ m_63;
  assign t4_0_27   = m_64 ^ m_68;
  assign t4_0_28   = m_69 ^ m_6c;
  assign t4_0_29   = m_6d ^ m_6e;
  assign t4_0_30   = m_6f ^ m_71;
  assign t4_0_31   = m_73 ^ m_76;
  assign t4_0_32   = m_77 ^ m_7a;
  assign t4_0_33   = m_7b ^ m_7c;
  assign t4_0_34   = m_7e ^ m_81;
  assign t4_0_35   = m_88 ^ m_8b;
  assign t4_0_36   = m_8f ^ m_91;
  assign t4_0_37   = m_94 ^ m_98;
  assign t4_0_38   = m_99 ^ m_9a;
  assign t4_0_39   = m_9c ^ m_9f;
  assign t4_0_40   = m_a0 ^ m_a2;
  assign t4_0_41   = m_a3 ^ m_a5;
  assign t4_0_42   = m_a6 ^ m_a7;
  assign t4_0_43   = m_a8 ^ m_a9;
  assign t4_0_44   = m_ab ^ m_ac;
  assign t4_0_45   = m_ad ^ m_ae;
  assign t4_0_46   = m_b0 ^ m_b6;
  assign t4_0_47   = m_b8 ^ m_ba;
  assign t4_0_48   = m_bc ^ m_bd;
  assign t4_0_49   = m_be ^ m_bf;
  assign t4_0_50   = m_c0 ^ m_c1;
  assign t4_0_51   = m_c2 ^ m_c3;
  assign t4_0_52   = m_c4 ^ m_c6;
  assign t4_0_53   = m_c7 ^ m_c8;
  assign t4_0_54   = m_c9 ^ m_cb;
  assign t4_0_55   = m_d0 ^ m_d1;
  assign t4_0_56   = m_d5 ^ m_d8;
  assign t4_0_57   = m_d9 ^ m_dc;
  assign t4_0_58   = m_de ^ m_df;
  assign t4_0_59   = m_e0 ^ m_e3;
  assign t4_0_60   = m_e6 ^ m_e8;
  assign t4_0_61   = m_e9 ^ m_ea;
  assign t4_0_62   = m_ee ^ m_f1;
  assign t4_0_63   = m_f2 ^ m_f4;
  assign t4_0_64   = m_f8 ^ m_f9;
  assign t4_1_0    = t4_0_0 ^ t4_0_1;
  assign t4_1_1    = t4_0_2 ^ t4_0_3;
  assign t4_1_2    = t4_0_4 ^ t4_0_5;
  assign t4_1_3    = t4_0_6 ^ t4_0_7;
  assign t4_1_4    = t4_0_8 ^ t4_0_9;
  assign t4_1_5    = t4_0_10 ^ t4_0_11;
  assign t4_1_6    = t4_0_12 ^ t4_0_13;
  assign t4_1_7    = t4_0_14 ^ t4_0_15;
  assign t4_1_8    = t4_0_16 ^ t4_0_17;
  assign t4_1_9    = t4_0_18 ^ t4_0_19;
  assign t4_1_10   = t4_0_20 ^ t4_0_21;
  assign t4_1_11   = t4_0_22 ^ t4_0_23;
  assign t4_1_12   = t4_0_24 ^ t4_0_25;
  assign t4_1_13   = t4_0_26 ^ t4_0_27;
  assign t4_1_14   = t4_0_28 ^ t4_0_29;
  assign t4_1_15   = t4_0_30 ^ t4_0_31;
  assign t4_1_16   = t4_0_32 ^ t4_0_33;
  assign t4_1_17   = t4_0_34 ^ t4_0_35;
  assign t4_1_18   = t4_0_36 ^ t4_0_37;
  assign t4_1_19   = t4_0_38 ^ t4_0_39;
  assign t4_1_20   = t4_0_40 ^ t4_0_41;
  assign t4_1_21   = t4_0_42 ^ t4_0_43;
  assign t4_1_22   = t4_0_44 ^ t4_0_45;
  assign t4_1_23   = t4_0_46 ^ t4_0_47;
  assign t4_1_24   = t4_0_48 ^ t4_0_49;
  assign t4_1_25   = t4_0_50 ^ t4_0_51;
  assign t4_1_26   = t4_0_52 ^ t4_0_53;
  assign t4_1_27   = t4_0_54 ^ t4_0_55;
  assign t4_1_28   = t4_0_56 ^ t4_0_57;
  assign t4_1_29   = t4_0_58 ^ t4_0_59;
  assign t4_1_30   = t4_0_60 ^ t4_0_61;
  assign t4_1_31   = t4_0_62 ^ t4_0_63;
  assign t4_1_32   = t4_0_64 ^ m_fd;
  assign t4_2_0    = t4_1_0 ^ t4_1_1;
  assign t4_2_1    = t4_1_2 ^ t4_1_3;
  assign t4_2_2    = t4_1_4 ^ t4_1_5;
  assign t4_2_3    = t4_1_6 ^ t4_1_7;
  assign t4_2_4    = t4_1_8 ^ t4_1_9;
  assign t4_2_5    = t4_1_10 ^ t4_1_11;
  assign t4_2_6    = t4_1_12 ^ t4_1_13;
  assign t4_2_7    = t4_1_14 ^ t4_1_15;
  assign t4_2_8    = t4_1_16 ^ t4_1_17;
  assign t4_2_9    = t4_1_18 ^ t4_1_19;
  assign t4_2_10   = t4_1_20 ^ t4_1_21;
  assign t4_2_11   = t4_1_22 ^ t4_1_23;
  assign t4_2_12   = t4_1_24 ^ t4_1_25;
  assign t4_2_13   = t4_1_26 ^ t4_1_27;
  assign t4_2_14   = t4_1_28 ^ t4_1_29;
  assign t4_2_15   = t4_1_30 ^ t4_1_31;
  assign t4_3_0    = t4_2_0 ^ t4_2_1;
  assign t4_3_1    = t4_2_2 ^ t4_2_3;
  assign t4_3_2    = t4_2_4 ^ t4_2_5;
  assign t4_3_3    = t4_2_6 ^ t4_2_7;
  assign t4_3_4    = t4_2_8 ^ t4_2_9;
  assign t4_3_5    = t4_2_10 ^ t4_2_11;
  assign t4_3_6    = t4_2_12 ^ t4_2_13;
  assign t4_3_7    = t4_2_14 ^ t4_2_15;
  assign t4_4_0    = t4_3_0 ^ t4_3_1;
  assign t4_4_1    = t4_3_2 ^ t4_3_3;
  assign t4_4_2    = t4_3_4 ^ t4_3_5;
  assign t4_4_3    = t4_3_6 ^ t4_3_7;
  assign t4_5_0    = t4_4_0 ^ t4_4_1;
  assign t4_5_1    = t4_4_2 ^ t4_4_3;
  assign t4_6_0    = t4_5_0 ^ t4_5_1;
  assign t4_7_0    = t4_6_0 ^ t4_1_32;

  // ---- y[5] : 113 monomials, constant term 1, XOR tree depth 7 ----
  assign t5_0_0    = m_07 ^ m_09;
  assign t5_0_1    = m_0b ^ m_0f;
  assign t5_0_2    = x[4] ^ m_13;
  assign t5_0_3    = m_14 ^ m_15;
  assign t5_0_4    = m_16 ^ m_18;
  assign t5_0_5    = m_1b ^ m_1d;
  assign t5_0_6    = m_1f ^ m_22;
  assign t5_0_7    = m_23 ^ m_26;
  assign t5_0_8    = m_27 ^ m_29;
  assign t5_0_9    = m_2a ^ m_2d;
  assign t5_0_10   = m_2e ^ m_2f;
  assign t5_0_11   = m_33 ^ m_34;
  assign t5_0_12   = m_35 ^ m_36;
  assign t5_0_13   = m_37 ^ m_38;
  assign t5_0_14   = m_3c ^ m_3f;
  assign t5_0_15   = x[6] ^ m_42;
  assign t5_0_16   = m_43 ^ m_45;
  assign t5_0_17   = m_46 ^ m_4a;
  assign t5_0_18   = m_4c ^ m_4e;
  assign t5_0_19   = m_4f ^ m_50;
  assign t5_0_20   = m_52 ^ m_53;
  assign t5_0_21   = m_57 ^ m_5a;
  assign t5_0_22   = m_5c ^ m_5e;
  assign t5_0_23   = m_61 ^ m_62;
  assign t5_0_24   = m_63 ^ m_6a;
  assign t5_0_25   = m_6c ^ m_6f;
  assign t5_0_26   = m_73 ^ m_76;
  assign t5_0_27   = m_77 ^ m_78;
  assign t5_0_28   = m_79 ^ m_7a;
  assign t5_0_29   = m_7c ^ x[7];
  assign t5_0_30   = m_83 ^ m_8a;
  assign t5_0_31   = m_8b ^ m_8c;
  assign t5_0_32   = m_8f ^ m_91;
  assign t5_0_33   = m_92 ^ m_93;
  assign t5_0_34   = m_94 ^ m_96;
  assign t5_0_35   = m_99 ^ m_9a;
  assign t5_0_36   = m_9c ^ m_9d;
  assign t5_0_37   = m_9e ^ m_a0;
  assign t5_0_38   = m_a2 ^ m_a3;
  assign t5_0_39   = m_a4 ^ m_a8;
  assign t5_0_40   = m_aa ^ m_ab;
  assign t5_0_41   = m_ad ^ m_af;
  assign t5_0_42   = m_b0 ^ m_b2;
  assign t5_0_43   = m_b3 ^ m_b4;
  assign t5_0_44   = m_b5 ^ m_b7;
  assign t5_0_45   = m_b8 ^ m_b9;
  assign t5_0_46   = m_c2 ^ m_c4;
  assign t5_0_47   = m_c7 ^ m_cd;
  assign t5_0_48   = m_d1 ^ m_d3;
  assign t5_0_49   = m_d8 ^ m_da;
  assign t5_0_50   = m_dd ^ m_de;
  assign t5_0_51   = m_e0 ^ m_e1;
  assign t5_0_52   = m_e3 ^ m_ec;
  assign t5_0_53   = m_ee ^ m_ef;
  assign t5_0_54   = m_f1 ^ m_f4;
  assign t5_0_55   = m_f5 ^ m_f6;
  assign t5_1_0    = t5_0_0 ^ t5_0_1;
  assign t5_1_1    = t5_0_2 ^ t5_0_3;
  assign t5_1_2    = t5_0_4 ^ t5_0_5;
  assign t5_1_3    = t5_0_6 ^ t5_0_7;
  assign t5_1_4    = t5_0_8 ^ t5_0_9;
  assign t5_1_5    = t5_0_10 ^ t5_0_11;
  assign t5_1_6    = t5_0_12 ^ t5_0_13;
  assign t5_1_7    = t5_0_14 ^ t5_0_15;
  assign t5_1_8    = t5_0_16 ^ t5_0_17;
  assign t5_1_9    = t5_0_18 ^ t5_0_19;
  assign t5_1_10   = t5_0_20 ^ t5_0_21;
  assign t5_1_11   = t5_0_22 ^ t5_0_23;
  assign t5_1_12   = t5_0_24 ^ t5_0_25;
  assign t5_1_13   = t5_0_26 ^ t5_0_27;
  assign t5_1_14   = t5_0_28 ^ t5_0_29;
  assign t5_1_15   = t5_0_30 ^ t5_0_31;
  assign t5_1_16   = t5_0_32 ^ t5_0_33;
  assign t5_1_17   = t5_0_34 ^ t5_0_35;
  assign t5_1_18   = t5_0_36 ^ t5_0_37;
  assign t5_1_19   = t5_0_38 ^ t5_0_39;
  assign t5_1_20   = t5_0_40 ^ t5_0_41;
  assign t5_1_21   = t5_0_42 ^ t5_0_43;
  assign t5_1_22   = t5_0_44 ^ t5_0_45;
  assign t5_1_23   = t5_0_46 ^ t5_0_47;
  assign t5_1_24   = t5_0_48 ^ t5_0_49;
  assign t5_1_25   = t5_0_50 ^ t5_0_51;
  assign t5_1_26   = t5_0_52 ^ t5_0_53;
  assign t5_1_27   = t5_0_54 ^ t5_0_55;
  assign t5_2_0    = t5_1_0 ^ t5_1_1;
  assign t5_2_1    = t5_1_2 ^ t5_1_3;
  assign t5_2_2    = t5_1_4 ^ t5_1_5;
  assign t5_2_3    = t5_1_6 ^ t5_1_7;
  assign t5_2_4    = t5_1_8 ^ t5_1_9;
  assign t5_2_5    = t5_1_10 ^ t5_1_11;
  assign t5_2_6    = t5_1_12 ^ t5_1_13;
  assign t5_2_7    = t5_1_14 ^ t5_1_15;
  assign t5_2_8    = t5_1_16 ^ t5_1_17;
  assign t5_2_9    = t5_1_18 ^ t5_1_19;
  assign t5_2_10   = t5_1_20 ^ t5_1_21;
  assign t5_2_11   = t5_1_22 ^ t5_1_23;
  assign t5_2_12   = t5_1_24 ^ t5_1_25;
  assign t5_2_13   = t5_1_26 ^ t5_1_27;
  assign t5_3_0    = t5_2_0 ^ t5_2_1;
  assign t5_3_1    = t5_2_2 ^ t5_2_3;
  assign t5_3_2    = t5_2_4 ^ t5_2_5;
  assign t5_3_3    = t5_2_6 ^ t5_2_7;
  assign t5_3_4    = t5_2_8 ^ t5_2_9;
  assign t5_3_5    = t5_2_10 ^ t5_2_11;
  assign t5_3_6    = t5_2_12 ^ t5_2_13;
  assign t5_4_0    = t5_3_0 ^ t5_3_1;
  assign t5_4_1    = t5_3_2 ^ t5_3_3;
  assign t5_4_2    = t5_3_4 ^ t5_3_5;
  assign t5_4_3    = t5_3_6 ^ m_f7;
  assign t5_5_0    = t5_4_0 ^ t5_4_1;
  assign t5_5_1    = t5_4_2 ^ t5_4_3;
  assign t5_6_0    = t5_5_0 ^ t5_5_1;

  // ---- y[6] : 111 monomials, constant term 1, XOR tree depth 7 ----
  assign t6_0_0    = x[3] ^ m_0a;
  assign t6_0_1    = m_0b ^ m_0c;
  assign t6_0_2    = m_11 ^ m_13;
  assign t6_0_3    = m_15 ^ m_17;
  assign t6_0_4    = m_1a ^ m_1b;
  assign t6_0_5    = m_1c ^ m_1e;
  assign t6_0_6    = x[5] ^ m_21;
  assign t6_0_7    = m_23 ^ m_25;
  assign t6_0_8    = m_26 ^ m_27;
  assign t6_0_9    = m_28 ^ m_29;
  assign t6_0_10   = m_2d ^ m_2e;
  assign t6_0_11   = m_2f ^ m_31;
  assign t6_0_12   = m_35 ^ m_36;
  assign t6_0_13   = m_3b ^ m_3c;
  assign t6_0_14   = m_3d ^ m_3e;
  assign t6_0_15   = x[6] ^ m_45;
  assign t6_0_16   = m_46 ^ m_49;
  assign t6_0_17   = m_4a ^ m_4b;
  assign t6_0_18   = m_4d ^ m_4e;
  assign t6_0_19   = m_4f ^ m_50;
  assign t6_0_20   = m_51 ^ m_52;
  assign t6_0_21   = m_54 ^ m_55;
  assign t6_0_22   = m_58 ^ m_59;
  assign t6_0_23   = m_5a ^ m_5c;
  assign t6_0_24   = m_61 ^ m_62;
  assign t6_0_25   = m_6c ^ m_6d;
  assign t6_0_26   = m_6f ^ m_70;
  assign t6_0_27   = m_76 ^ m_77;
  assign t6_0_28   = m_7a ^ m_7b;
  assign t6_0_29   = m_81 ^ m_82;
  assign t6_0_30   = m_86 ^ m_88;
  assign t6_0_31   = m_8b ^ m_8c;
  assign t6_0_32   = m_8d ^ m_8f;
  assign t6_0_33   = m_91 ^ m_92;
  assign t6_0_34   = m_94 ^ m_96;
  assign t6_0_35   = m_99 ^ m_9a;
  assign t6_0_36   = m_9e ^ m_9f;
  assign t6_0_37   = m_a0 ^ m_a1;
  assign t6_0_38   = m_a5 ^ m_a8;
  assign t6_0_39   = m_aa ^ m_ac;
  assign t6_0_40   = m_ae ^ m_b2;
  assign t6_0_41   = m_b3 ^ m_b5;
  assign t6_0_42   = m_b7 ^ m_ba;
  assign t6_0_43   = m_bb ^ m_c2;
  assign t6_0_44   = m_c3 ^ m_c8;
  assign t6_0_45   = m_cb ^ m_d1;
  assign t6_0_46   = m_d2 ^ m_d5;
  assign t6_0_47   = m_d7 ^ m_d9;
  assign t6_0_48   = m_db ^ m_dc;
  assign t6_0_49   = m_e0 ^ m_e5;
  assign t6_0_50   = m_e6 ^ m_e7;
  assign t6_0_51   = m_eb ^ m_ec;
  assign t6_0_52   = m_f0 ^ m_f1;
  assign t6_0_53   = m_f2 ^ m_f7;
  assign t6_0_54   = m_f8 ^ m_fa;
  assign t6_1_0    = t6_0_0 ^ t6_0_1;
  assign t6_1_1    = t6_0_2 ^ t6_0_3;
  assign t6_1_2    = t6_0_4 ^ t6_0_5;
  assign t6_1_3    = t6_0_6 ^ t6_0_7;
  assign t6_1_4    = t6_0_8 ^ t6_0_9;
  assign t6_1_5    = t6_0_10 ^ t6_0_11;
  assign t6_1_6    = t6_0_12 ^ t6_0_13;
  assign t6_1_7    = t6_0_14 ^ t6_0_15;
  assign t6_1_8    = t6_0_16 ^ t6_0_17;
  assign t6_1_9    = t6_0_18 ^ t6_0_19;
  assign t6_1_10   = t6_0_20 ^ t6_0_21;
  assign t6_1_11   = t6_0_22 ^ t6_0_23;
  assign t6_1_12   = t6_0_24 ^ t6_0_25;
  assign t6_1_13   = t6_0_26 ^ t6_0_27;
  assign t6_1_14   = t6_0_28 ^ t6_0_29;
  assign t6_1_15   = t6_0_30 ^ t6_0_31;
  assign t6_1_16   = t6_0_32 ^ t6_0_33;
  assign t6_1_17   = t6_0_34 ^ t6_0_35;
  assign t6_1_18   = t6_0_36 ^ t6_0_37;
  assign t6_1_19   = t6_0_38 ^ t6_0_39;
  assign t6_1_20   = t6_0_40 ^ t6_0_41;
  assign t6_1_21   = t6_0_42 ^ t6_0_43;
  assign t6_1_22   = t6_0_44 ^ t6_0_45;
  assign t6_1_23   = t6_0_46 ^ t6_0_47;
  assign t6_1_24   = t6_0_48 ^ t6_0_49;
  assign t6_1_25   = t6_0_50 ^ t6_0_51;
  assign t6_1_26   = t6_0_52 ^ t6_0_53;
  assign t6_1_27   = t6_0_54 ^ m_fb;
  assign t6_2_0    = t6_1_0 ^ t6_1_1;
  assign t6_2_1    = t6_1_2 ^ t6_1_3;
  assign t6_2_2    = t6_1_4 ^ t6_1_5;
  assign t6_2_3    = t6_1_6 ^ t6_1_7;
  assign t6_2_4    = t6_1_8 ^ t6_1_9;
  assign t6_2_5    = t6_1_10 ^ t6_1_11;
  assign t6_2_6    = t6_1_12 ^ t6_1_13;
  assign t6_2_7    = t6_1_14 ^ t6_1_15;
  assign t6_2_8    = t6_1_16 ^ t6_1_17;
  assign t6_2_9    = t6_1_18 ^ t6_1_19;
  assign t6_2_10   = t6_1_20 ^ t6_1_21;
  assign t6_2_11   = t6_1_22 ^ t6_1_23;
  assign t6_2_12   = t6_1_24 ^ t6_1_25;
  assign t6_2_13   = t6_1_26 ^ t6_1_27;
  assign t6_3_0    = t6_2_0 ^ t6_2_1;
  assign t6_3_1    = t6_2_2 ^ t6_2_3;
  assign t6_3_2    = t6_2_4 ^ t6_2_5;
  assign t6_3_3    = t6_2_6 ^ t6_2_7;
  assign t6_3_4    = t6_2_8 ^ t6_2_9;
  assign t6_3_5    = t6_2_10 ^ t6_2_11;
  assign t6_3_6    = t6_2_12 ^ t6_2_13;
  assign t6_4_0    = t6_3_0 ^ t6_3_1;
  assign t6_4_1    = t6_3_2 ^ t6_3_3;
  assign t6_4_2    = t6_3_4 ^ t6_3_5;
  assign t6_5_0    = t6_4_0 ^ t6_4_1;
  assign t6_5_1    = t6_4_2 ^ t6_3_6;
  assign t6_6_0    = t6_5_0 ^ t6_5_1;

  // ---- y[7] : 110 monomials, constant term 0, XOR tree depth 7 ----
  assign t7_0_0    = x[2] ^ m_05;
  assign t7_0_1    = m_06 ^ m_0d;
  assign t7_0_2    = m_0e ^ m_0f;
  assign t7_0_3    = x[4] ^ m_13;
  assign t7_0_4    = m_14 ^ m_17;
  assign t7_0_5    = m_1b ^ m_1e;
  assign t7_0_6    = m_1f ^ x[5];
  assign t7_0_7    = m_23 ^ m_25;
  assign t7_0_8    = m_27 ^ m_28;
  assign t7_0_9    = m_29 ^ m_2a;
  assign t7_0_10   = m_2c ^ m_2d;
  assign t7_0_11   = m_2e ^ m_31;
  assign t7_0_12   = m_36 ^ m_38;
  assign t7_0_13   = m_3b ^ m_3d;
  assign t7_0_14   = m_41 ^ m_43;
  assign t7_0_15   = m_44 ^ m_46;
  assign t7_0_16   = m_49 ^ m_4a;
  assign t7_0_17   = m_4b ^ m_4d;
  assign t7_0_18   = m_4f ^ m_50;
  assign t7_0_19   = m_54 ^ m_55;
  assign t7_0_20   = m_56 ^ m_57;
  assign t7_0_21   = m_59 ^ m_5d;
  assign t7_0_22   = m_61 ^ m_64;
  assign t7_0_23   = m_69 ^ m_6e;
  assign t7_0_24   = m_70 ^ m_73;
  assign t7_0_25   = m_76 ^ m_78;
  assign t7_0_26   = m_79 ^ m_7c;
  assign t7_0_27   = m_7d ^ x[7];
  assign t7_0_28   = m_81 ^ m_82;
  assign t7_0_29   = m_85 ^ m_87;
  assign t7_0_30   = m_89 ^ m_8d;
  assign t7_0_31   = m_8e ^ m_92;
  assign t7_0_32   = m_93 ^ m_95;
  assign t7_0_33   = m_99 ^ m_9a;
  assign t7_0_34   = m_9b ^ m_9c;
  assign t7_0_35   = m_9d ^ m_a0;
  assign t7_0_36   = m_a7 ^ m_a8;
  assign t7_0_37   = m_a9 ^ m_b0;
  assign t7_0_38   = m_b2 ^ m_b3;
  assign t7_0_39   = m_b7 ^ m_bb;
  assign t7_0_40   = m_bd ^ m_c1;
  assign t7_0_41   = m_c4 ^ m_c7;
  assign t7_0_42   = m_c9 ^ m_ca;
  assign t7_0_43   = m_cf ^ m_d0;
  assign t7_0_44   = m_d1 ^ m_d2;
  assign t7_0_45   = m_d4 ^ m_d6;
  assign t7_0_46   = m_d9 ^ m_db;
  assign t7_0_47   = m_dd ^ m_e2;
  assign t7_0_48   = m_e3 ^ m_e4;
  assign t7_0_49   = m_e6 ^ m_e9;
  assign t7_0_50   = m_ea ^ m_eb;
  assign t7_0_51   = m_ed ^ m_f0;
  assign t7_0_52   = m_f2 ^ m_f5;
  assign t7_0_53   = m_f8 ^ m_fa;
  assign t7_0_54   = m_fb ^ m_fd;
  assign t7_1_0    = t7_0_0 ^ t7_0_1;
  assign t7_1_1    = t7_0_2 ^ t7_0_3;
  assign t7_1_2    = t7_0_4 ^ t7_0_5;
  assign t7_1_3    = t7_0_6 ^ t7_0_7;
  assign t7_1_4    = t7_0_8 ^ t7_0_9;
  assign t7_1_5    = t7_0_10 ^ t7_0_11;
  assign t7_1_6    = t7_0_12 ^ t7_0_13;
  assign t7_1_7    = t7_0_14 ^ t7_0_15;
  assign t7_1_8    = t7_0_16 ^ t7_0_17;
  assign t7_1_9    = t7_0_18 ^ t7_0_19;
  assign t7_1_10   = t7_0_20 ^ t7_0_21;
  assign t7_1_11   = t7_0_22 ^ t7_0_23;
  assign t7_1_12   = t7_0_24 ^ t7_0_25;
  assign t7_1_13   = t7_0_26 ^ t7_0_27;
  assign t7_1_14   = t7_0_28 ^ t7_0_29;
  assign t7_1_15   = t7_0_30 ^ t7_0_31;
  assign t7_1_16   = t7_0_32 ^ t7_0_33;
  assign t7_1_17   = t7_0_34 ^ t7_0_35;
  assign t7_1_18   = t7_0_36 ^ t7_0_37;
  assign t7_1_19   = t7_0_38 ^ t7_0_39;
  assign t7_1_20   = t7_0_40 ^ t7_0_41;
  assign t7_1_21   = t7_0_42 ^ t7_0_43;
  assign t7_1_22   = t7_0_44 ^ t7_0_45;
  assign t7_1_23   = t7_0_46 ^ t7_0_47;
  assign t7_1_24   = t7_0_48 ^ t7_0_49;
  assign t7_1_25   = t7_0_50 ^ t7_0_51;
  assign t7_1_26   = t7_0_52 ^ t7_0_53;
  assign t7_2_0    = t7_1_0 ^ t7_1_1;
  assign t7_2_1    = t7_1_2 ^ t7_1_3;
  assign t7_2_2    = t7_1_4 ^ t7_1_5;
  assign t7_2_3    = t7_1_6 ^ t7_1_7;
  assign t7_2_4    = t7_1_8 ^ t7_1_9;
  assign t7_2_5    = t7_1_10 ^ t7_1_11;
  assign t7_2_6    = t7_1_12 ^ t7_1_13;
  assign t7_2_7    = t7_1_14 ^ t7_1_15;
  assign t7_2_8    = t7_1_16 ^ t7_1_17;
  assign t7_2_9    = t7_1_18 ^ t7_1_19;
  assign t7_2_10   = t7_1_20 ^ t7_1_21;
  assign t7_2_11   = t7_1_22 ^ t7_1_23;
  assign t7_2_12   = t7_1_24 ^ t7_1_25;
  assign t7_2_13   = t7_1_26 ^ t7_0_54;
  assign t7_3_0    = t7_2_0 ^ t7_2_1;
  assign t7_3_1    = t7_2_2 ^ t7_2_3;
  assign t7_3_2    = t7_2_4 ^ t7_2_5;
  assign t7_3_3    = t7_2_6 ^ t7_2_7;
  assign t7_3_4    = t7_2_8 ^ t7_2_9;
  assign t7_3_5    = t7_2_10 ^ t7_2_11;
  assign t7_3_6    = t7_2_12 ^ t7_2_13;
  assign t7_4_0    = t7_3_0 ^ t7_3_1;
  assign t7_4_1    = t7_3_2 ^ t7_3_3;
  assign t7_4_2    = t7_3_4 ^ t7_3_5;
  assign t7_5_0    = t7_4_0 ^ t7_4_1;
  assign t7_5_1    = t7_4_2 ^ t7_3_6;
  assign t7_6_0    = t7_5_0 ^ t7_5_1;

  // ---- outputs ----
  assign y[0] = ~t0_7_0;   // constant term 1 folded into an inversion
  assign y[1] = ~t1_7_0;   // constant term 1 folded into an inversion
  assign y[2] =  t2_7_0;
  assign y[3] =  t3_7_0;
  assign y[4] =  t4_7_0;
  assign y[5] = ~t5_6_0;   // constant term 1 folded into an inversion
  assign y[6] = ~t6_6_0;   // constant term 1 folded into an inversion
  assign y[7] =  t7_6_0;

endmodule

`default_nettype wire
