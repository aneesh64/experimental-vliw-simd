// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : BankedScratchMemory
// Git hash  : 2b1c34e10fcfebdb7017c9a507f6d279f35a00fa

`timescale 1ns/1ps

module BankedScratchMemory (
  input  wire [10:0]   io_valuReadAddr_0_0,
  input  wire [10:0]   io_valuReadAddr_0_1,
  input  wire [10:0]   io_valuReadAddr_0_2,
  input  wire [10:0]   io_valuReadAddr_0_3,
  input  wire [10:0]   io_valuReadAddr_0_4,
  input  wire [10:0]   io_valuReadAddr_0_5,
  input  wire [10:0]   io_valuReadAddr_0_6,
  input  wire [10:0]   io_valuReadAddr_0_7,
  input  wire [10:0]   io_valuReadAddr_1_0,
  input  wire [10:0]   io_valuReadAddr_1_1,
  input  wire [10:0]   io_valuReadAddr_1_2,
  input  wire [10:0]   io_valuReadAddr_1_3,
  input  wire [10:0]   io_valuReadAddr_1_4,
  input  wire [10:0]   io_valuReadAddr_1_5,
  input  wire [10:0]   io_valuReadAddr_1_6,
  input  wire [10:0]   io_valuReadAddr_1_7,
  input  wire          io_valuReadEn_0_0,
  input  wire          io_valuReadEn_0_1,
  input  wire          io_valuReadEn_0_2,
  input  wire          io_valuReadEn_0_3,
  input  wire          io_valuReadEn_0_4,
  input  wire          io_valuReadEn_0_5,
  input  wire          io_valuReadEn_0_6,
  input  wire          io_valuReadEn_0_7,
  input  wire          io_valuReadEn_1_0,
  input  wire          io_valuReadEn_1_1,
  input  wire          io_valuReadEn_1_2,
  input  wire          io_valuReadEn_1_3,
  input  wire          io_valuReadEn_1_4,
  input  wire          io_valuReadEn_1_5,
  input  wire          io_valuReadEn_1_6,
  input  wire          io_valuReadEn_1_7,
  output reg  [31:0]   io_valuReadData_0_0,
  output reg  [31:0]   io_valuReadData_0_1,
  output reg  [31:0]   io_valuReadData_0_2,
  output reg  [31:0]   io_valuReadData_0_3,
  output reg  [31:0]   io_valuReadData_0_4,
  output reg  [31:0]   io_valuReadData_0_5,
  output reg  [31:0]   io_valuReadData_0_6,
  output reg  [31:0]   io_valuReadData_0_7,
  output reg  [31:0]   io_valuReadData_1_0,
  output reg  [31:0]   io_valuReadData_1_1,
  output reg  [31:0]   io_valuReadData_1_2,
  output reg  [31:0]   io_valuReadData_1_3,
  output reg  [31:0]   io_valuReadData_1_4,
  output reg  [31:0]   io_valuReadData_1_5,
  output reg  [31:0]   io_valuReadData_1_6,
  output reg  [31:0]   io_valuReadData_1_7,
  input  wire [10:0]   io_scalarReadAddr_0,
  input  wire [10:0]   io_scalarReadAddr_1,
  input  wire [10:0]   io_scalarReadAddr_2,
  input  wire [10:0]   io_scalarReadAddr_3,
  input  wire [10:0]   io_scalarReadAddr_4,
  input  wire [10:0]   io_scalarReadAddr_5,
  input  wire [10:0]   io_scalarReadAddr_6,
  input  wire [10:0]   io_scalarReadAddr_7,
  input  wire [10:0]   io_scalarReadAddr_8,
  input  wire          io_scalarReadEn_0,
  input  wire          io_scalarReadEn_1,
  input  wire          io_scalarReadEn_2,
  input  wire          io_scalarReadEn_3,
  input  wire          io_scalarReadEn_4,
  input  wire          io_scalarReadEn_5,
  input  wire          io_scalarReadEn_6,
  input  wire          io_scalarReadEn_7,
  input  wire          io_scalarReadEn_8,
  output reg  [31:0]   io_scalarReadData_0,
  output reg  [31:0]   io_scalarReadData_1,
  output reg  [31:0]   io_scalarReadData_2,
  output reg  [31:0]   io_scalarReadData_3,
  output reg  [31:0]   io_scalarReadData_4,
  output reg  [31:0]   io_scalarReadData_5,
  output reg  [31:0]   io_scalarReadData_6,
  output reg  [31:0]   io_scalarReadData_7,
  output reg  [31:0]   io_scalarReadData_8,
  input  wire [10:0]   io_writeAddr_0,
  input  wire [10:0]   io_writeAddr_1,
  input  wire [10:0]   io_writeAddr_2,
  input  wire [10:0]   io_writeAddr_3,
  input  wire [10:0]   io_writeAddr_4,
  input  wire [10:0]   io_writeAddr_5,
  input  wire [10:0]   io_writeAddr_6,
  input  wire [10:0]   io_writeAddr_7,
  input  wire [10:0]   io_writeAddr_8,
  input  wire [10:0]   io_writeAddr_9,
  input  wire [10:0]   io_writeAddr_10,
  input  wire [10:0]   io_writeAddr_11,
  input  wire [10:0]   io_writeAddr_12,
  input  wire [10:0]   io_writeAddr_13,
  input  wire [10:0]   io_writeAddr_14,
  input  wire [10:0]   io_writeAddr_15,
  input  wire [10:0]   io_writeAddr_16,
  input  wire [10:0]   io_writeAddr_17,
  input  wire [10:0]   io_writeAddr_18,
  input  wire [10:0]   io_writeAddr_19,
  input  wire [10:0]   io_writeAddr_20,
  input  wire [10:0]   io_writeAddr_21,
  input  wire [10:0]   io_writeAddr_22,
  input  wire [10:0]   io_writeAddr_23,
  input  wire [10:0]   io_writeAddr_24,
  input  wire [10:0]   io_writeAddr_25,
  input  wire [10:0]   io_writeAddr_26,
  input  wire [10:0]   io_writeAddr_27,
  input  wire [31:0]   io_writeData_0,
  input  wire [31:0]   io_writeData_1,
  input  wire [31:0]   io_writeData_2,
  input  wire [31:0]   io_writeData_3,
  input  wire [31:0]   io_writeData_4,
  input  wire [31:0]   io_writeData_5,
  input  wire [31:0]   io_writeData_6,
  input  wire [31:0]   io_writeData_7,
  input  wire [31:0]   io_writeData_8,
  input  wire [31:0]   io_writeData_9,
  input  wire [31:0]   io_writeData_10,
  input  wire [31:0]   io_writeData_11,
  input  wire [31:0]   io_writeData_12,
  input  wire [31:0]   io_writeData_13,
  input  wire [31:0]   io_writeData_14,
  input  wire [31:0]   io_writeData_15,
  input  wire [31:0]   io_writeData_16,
  input  wire [31:0]   io_writeData_17,
  input  wire [31:0]   io_writeData_18,
  input  wire [31:0]   io_writeData_19,
  input  wire [31:0]   io_writeData_20,
  input  wire [31:0]   io_writeData_21,
  input  wire [31:0]   io_writeData_22,
  input  wire [31:0]   io_writeData_23,
  input  wire [31:0]   io_writeData_24,
  input  wire [31:0]   io_writeData_25,
  input  wire [31:0]   io_writeData_26,
  input  wire [31:0]   io_writeData_27,
  input  wire          io_writeEn_0,
  input  wire          io_writeEn_1,
  input  wire          io_writeEn_2,
  input  wire          io_writeEn_3,
  input  wire          io_writeEn_4,
  input  wire          io_writeEn_5,
  input  wire          io_writeEn_6,
  input  wire          io_writeEn_7,
  input  wire          io_writeEn_8,
  input  wire          io_writeEn_9,
  input  wire          io_writeEn_10,
  input  wire          io_writeEn_11,
  input  wire          io_writeEn_12,
  input  wire          io_writeEn_13,
  input  wire          io_writeEn_14,
  input  wire          io_writeEn_15,
  input  wire          io_writeEn_16,
  input  wire          io_writeEn_17,
  input  wire          io_writeEn_18,
  input  wire          io_writeEn_19,
  input  wire          io_writeEn_20,
  input  wire          io_writeEn_21,
  input  wire          io_writeEn_22,
  input  wire          io_writeEn_23,
  input  wire          io_writeEn_24,
  input  wire          io_writeEn_25,
  input  wire          io_writeEn_26,
  input  wire          io_writeEn_27,
  input  wire          io_valuActive,
  input  wire          io_vectorReadActive,
  input  wire          io_blockScalarReads,
  output reg           io_conflict,
  input  wire          clk,
  input  wire          reset
);

  reg        [7:0]    banks_0_io_aAddr;
  reg                 banks_0_io_aEn;
  reg        [7:0]    banks_0_io_bAddr;
  reg                 banks_0_io_bEn;
  reg                 banks_0_io_bWe;
  reg        [31:0]   banks_0_io_bWrData;
  reg        [7:0]    banks_1_io_aAddr;
  reg                 banks_1_io_aEn;
  reg        [7:0]    banks_1_io_bAddr;
  reg                 banks_1_io_bEn;
  reg                 banks_1_io_bWe;
  reg        [31:0]   banks_1_io_bWrData;
  reg        [7:0]    banks_2_io_aAddr;
  reg                 banks_2_io_aEn;
  reg        [7:0]    banks_2_io_bAddr;
  reg                 banks_2_io_bEn;
  reg                 banks_2_io_bWe;
  reg        [31:0]   banks_2_io_bWrData;
  reg        [7:0]    banks_3_io_aAddr;
  reg                 banks_3_io_aEn;
  reg        [7:0]    banks_3_io_bAddr;
  reg                 banks_3_io_bEn;
  reg                 banks_3_io_bWe;
  reg        [31:0]   banks_3_io_bWrData;
  reg        [7:0]    banks_4_io_aAddr;
  reg                 banks_4_io_aEn;
  reg        [7:0]    banks_4_io_bAddr;
  reg                 banks_4_io_bEn;
  reg                 banks_4_io_bWe;
  reg        [31:0]   banks_4_io_bWrData;
  reg        [7:0]    banks_5_io_aAddr;
  reg                 banks_5_io_aEn;
  reg        [7:0]    banks_5_io_bAddr;
  reg                 banks_5_io_bEn;
  reg                 banks_5_io_bWe;
  reg        [31:0]   banks_5_io_bWrData;
  reg        [7:0]    banks_6_io_aAddr;
  reg                 banks_6_io_aEn;
  reg        [7:0]    banks_6_io_bAddr;
  reg                 banks_6_io_bEn;
  reg                 banks_6_io_bWe;
  reg        [31:0]   banks_6_io_bWrData;
  reg        [7:0]    banks_7_io_aAddr;
  reg                 banks_7_io_aEn;
  reg        [7:0]    banks_7_io_bAddr;
  reg                 banks_7_io_bEn;
  reg                 banks_7_io_bWe;
  reg        [31:0]   banks_7_io_bWrData;
  wire       [31:0]   banks_0_io_aRdData;
  wire       [31:0]   banks_0_io_bRdData;
  wire       [31:0]   banks_1_io_aRdData;
  wire       [31:0]   banks_1_io_bRdData;
  wire       [31:0]   banks_2_io_aRdData;
  wire       [31:0]   banks_2_io_bRdData;
  wire       [31:0]   banks_3_io_aRdData;
  wire       [31:0]   banks_3_io_bRdData;
  wire       [31:0]   banks_4_io_aRdData;
  wire       [31:0]   banks_4_io_bRdData;
  wire       [31:0]   banks_5_io_aRdData;
  wire       [31:0]   banks_5_io_bRdData;
  wire       [31:0]   banks_6_io_aRdData;
  wire       [31:0]   banks_6_io_bRdData;
  wire       [31:0]   banks_7_io_aRdData;
  wire       [31:0]   banks_7_io_bRdData;
  wire                _zz_fwdGap2Valid_0;
  wire                _zz_fwdGap2Valid_1;
  wire                _zz_fwdGap2Valid_2;
  wire                _zz_fwdGap2Valid_3;
  wire                _zz_fwdGap2Valid_4;
  wire                _zz_fwdGap2Valid_5;
  wire                _zz_fwdGap2Valid_6;
  wire                _zz_fwdGap2Valid_7;
  wire                _zz_fwdGap2Valid_8;
  wire                _zz_fwdValuGap2Valid_0_0;
  wire                _zz_fwdValuGap2Valid_0_1;
  wire                _zz_fwdValuGap2Valid_0_2;
  wire                _zz_fwdValuGap2Valid_0_3;
  wire                _zz_fwdValuGap2Valid_0_4;
  wire                _zz_fwdValuGap2Valid_0_5;
  wire                _zz_fwdValuGap2Valid_0_6;
  wire                _zz_fwdValuGap2Valid_0_7;
  wire                _zz_fwdValuGap2Valid_1_0;
  wire                _zz_fwdValuGap2Valid_1_1;
  wire                _zz_fwdValuGap2Valid_1_2;
  wire                _zz_fwdValuGap2Valid_1_3;
  wire                _zz_fwdValuGap2Valid_1_4;
  wire                _zz_fwdValuGap2Valid_1_5;
  wire                _zz_fwdValuGap2Valid_1_6;
  wire                _zz_fwdValuGap2Valid_1_7;
  reg                 bankWriteActive_0;
  reg                 bankWriteActive_1;
  reg                 bankWriteActive_2;
  reg                 bankWriteActive_3;
  reg                 bankWriteActive_4;
  reg                 bankWriteActive_5;
  reg                 bankWriteActive_6;
  reg                 bankWriteActive_7;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171;
  wire       [7:0]    _zz_io_bAddr;
  wire                when_BankedScratchMemory_l171;
  wire                when_BankedScratchMemory_l171_1;
  wire                when_BankedScratchMemory_l171_2;
  wire                when_BankedScratchMemory_l171_3;
  wire                when_BankedScratchMemory_l171_4;
  wire                when_BankedScratchMemory_l171_5;
  wire                when_BankedScratchMemory_l171_6;
  wire                when_BankedScratchMemory_l171_7;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_1;
  wire       [7:0]    _zz_io_bAddr_1;
  wire                when_BankedScratchMemory_l171_8;
  wire                when_BankedScratchMemory_l171_9;
  wire                when_BankedScratchMemory_l171_10;
  wire                when_BankedScratchMemory_l171_11;
  wire                when_BankedScratchMemory_l171_12;
  wire                when_BankedScratchMemory_l171_13;
  wire                when_BankedScratchMemory_l171_14;
  wire                when_BankedScratchMemory_l171_15;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_2;
  wire       [7:0]    _zz_io_bAddr_2;
  wire                when_BankedScratchMemory_l171_16;
  wire                when_BankedScratchMemory_l171_17;
  wire                when_BankedScratchMemory_l171_18;
  wire                when_BankedScratchMemory_l171_19;
  wire                when_BankedScratchMemory_l171_20;
  wire                when_BankedScratchMemory_l171_21;
  wire                when_BankedScratchMemory_l171_22;
  wire                when_BankedScratchMemory_l171_23;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_3;
  wire       [7:0]    _zz_io_bAddr_3;
  wire                when_BankedScratchMemory_l171_24;
  wire                when_BankedScratchMemory_l171_25;
  wire                when_BankedScratchMemory_l171_26;
  wire                when_BankedScratchMemory_l171_27;
  wire                when_BankedScratchMemory_l171_28;
  wire                when_BankedScratchMemory_l171_29;
  wire                when_BankedScratchMemory_l171_30;
  wire                when_BankedScratchMemory_l171_31;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_4;
  wire       [7:0]    _zz_io_bAddr_4;
  wire                when_BankedScratchMemory_l171_32;
  wire                when_BankedScratchMemory_l171_33;
  wire                when_BankedScratchMemory_l171_34;
  wire                when_BankedScratchMemory_l171_35;
  wire                when_BankedScratchMemory_l171_36;
  wire                when_BankedScratchMemory_l171_37;
  wire                when_BankedScratchMemory_l171_38;
  wire                when_BankedScratchMemory_l171_39;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_5;
  wire       [7:0]    _zz_io_bAddr_5;
  wire                when_BankedScratchMemory_l171_40;
  wire                when_BankedScratchMemory_l171_41;
  wire                when_BankedScratchMemory_l171_42;
  wire                when_BankedScratchMemory_l171_43;
  wire                when_BankedScratchMemory_l171_44;
  wire                when_BankedScratchMemory_l171_45;
  wire                when_BankedScratchMemory_l171_46;
  wire                when_BankedScratchMemory_l171_47;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_6;
  wire       [7:0]    _zz_io_bAddr_6;
  wire                when_BankedScratchMemory_l171_48;
  wire                when_BankedScratchMemory_l171_49;
  wire                when_BankedScratchMemory_l171_50;
  wire                when_BankedScratchMemory_l171_51;
  wire                when_BankedScratchMemory_l171_52;
  wire                when_BankedScratchMemory_l171_53;
  wire                when_BankedScratchMemory_l171_54;
  wire                when_BankedScratchMemory_l171_55;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_7;
  wire       [7:0]    _zz_io_bAddr_7;
  wire                when_BankedScratchMemory_l171_56;
  wire                when_BankedScratchMemory_l171_57;
  wire                when_BankedScratchMemory_l171_58;
  wire                when_BankedScratchMemory_l171_59;
  wire                when_BankedScratchMemory_l171_60;
  wire                when_BankedScratchMemory_l171_61;
  wire                when_BankedScratchMemory_l171_62;
  wire                when_BankedScratchMemory_l171_63;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_8;
  wire       [7:0]    _zz_io_bAddr_8;
  wire                when_BankedScratchMemory_l171_64;
  wire                when_BankedScratchMemory_l171_65;
  wire                when_BankedScratchMemory_l171_66;
  wire                when_BankedScratchMemory_l171_67;
  wire                when_BankedScratchMemory_l171_68;
  wire                when_BankedScratchMemory_l171_69;
  wire                when_BankedScratchMemory_l171_70;
  wire                when_BankedScratchMemory_l171_71;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_9;
  wire       [7:0]    _zz_io_bAddr_9;
  wire                when_BankedScratchMemory_l171_72;
  wire                when_BankedScratchMemory_l171_73;
  wire                when_BankedScratchMemory_l171_74;
  wire                when_BankedScratchMemory_l171_75;
  wire                when_BankedScratchMemory_l171_76;
  wire                when_BankedScratchMemory_l171_77;
  wire                when_BankedScratchMemory_l171_78;
  wire                when_BankedScratchMemory_l171_79;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_10;
  wire       [7:0]    _zz_io_bAddr_10;
  wire                when_BankedScratchMemory_l171_80;
  wire                when_BankedScratchMemory_l171_81;
  wire                when_BankedScratchMemory_l171_82;
  wire                when_BankedScratchMemory_l171_83;
  wire                when_BankedScratchMemory_l171_84;
  wire                when_BankedScratchMemory_l171_85;
  wire                when_BankedScratchMemory_l171_86;
  wire                when_BankedScratchMemory_l171_87;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_11;
  wire       [7:0]    _zz_io_bAddr_11;
  wire                when_BankedScratchMemory_l171_88;
  wire                when_BankedScratchMemory_l171_89;
  wire                when_BankedScratchMemory_l171_90;
  wire                when_BankedScratchMemory_l171_91;
  wire                when_BankedScratchMemory_l171_92;
  wire                when_BankedScratchMemory_l171_93;
  wire                when_BankedScratchMemory_l171_94;
  wire                when_BankedScratchMemory_l171_95;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_12;
  wire       [7:0]    _zz_io_bAddr_12;
  wire                when_BankedScratchMemory_l171_96;
  wire                when_BankedScratchMemory_l171_97;
  wire                when_BankedScratchMemory_l171_98;
  wire                when_BankedScratchMemory_l171_99;
  wire                when_BankedScratchMemory_l171_100;
  wire                when_BankedScratchMemory_l171_101;
  wire                when_BankedScratchMemory_l171_102;
  wire                when_BankedScratchMemory_l171_103;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_13;
  wire       [7:0]    _zz_io_bAddr_13;
  wire                when_BankedScratchMemory_l171_104;
  wire                when_BankedScratchMemory_l171_105;
  wire                when_BankedScratchMemory_l171_106;
  wire                when_BankedScratchMemory_l171_107;
  wire                when_BankedScratchMemory_l171_108;
  wire                when_BankedScratchMemory_l171_109;
  wire                when_BankedScratchMemory_l171_110;
  wire                when_BankedScratchMemory_l171_111;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_14;
  wire       [7:0]    _zz_io_bAddr_14;
  wire                when_BankedScratchMemory_l171_112;
  wire                when_BankedScratchMemory_l171_113;
  wire                when_BankedScratchMemory_l171_114;
  wire                when_BankedScratchMemory_l171_115;
  wire                when_BankedScratchMemory_l171_116;
  wire                when_BankedScratchMemory_l171_117;
  wire                when_BankedScratchMemory_l171_118;
  wire                when_BankedScratchMemory_l171_119;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_15;
  wire       [7:0]    _zz_io_bAddr_15;
  wire                when_BankedScratchMemory_l171_120;
  wire                when_BankedScratchMemory_l171_121;
  wire                when_BankedScratchMemory_l171_122;
  wire                when_BankedScratchMemory_l171_123;
  wire                when_BankedScratchMemory_l171_124;
  wire                when_BankedScratchMemory_l171_125;
  wire                when_BankedScratchMemory_l171_126;
  wire                when_BankedScratchMemory_l171_127;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_16;
  wire       [7:0]    _zz_io_bAddr_16;
  wire                when_BankedScratchMemory_l171_128;
  wire                when_BankedScratchMemory_l171_129;
  wire                when_BankedScratchMemory_l171_130;
  wire                when_BankedScratchMemory_l171_131;
  wire                when_BankedScratchMemory_l171_132;
  wire                when_BankedScratchMemory_l171_133;
  wire                when_BankedScratchMemory_l171_134;
  wire                when_BankedScratchMemory_l171_135;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_17;
  wire       [7:0]    _zz_io_bAddr_17;
  wire                when_BankedScratchMemory_l171_136;
  wire                when_BankedScratchMemory_l171_137;
  wire                when_BankedScratchMemory_l171_138;
  wire                when_BankedScratchMemory_l171_139;
  wire                when_BankedScratchMemory_l171_140;
  wire                when_BankedScratchMemory_l171_141;
  wire                when_BankedScratchMemory_l171_142;
  wire                when_BankedScratchMemory_l171_143;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_18;
  wire       [7:0]    _zz_io_bAddr_18;
  wire                when_BankedScratchMemory_l171_144;
  wire                when_BankedScratchMemory_l171_145;
  wire                when_BankedScratchMemory_l171_146;
  wire                when_BankedScratchMemory_l171_147;
  wire                when_BankedScratchMemory_l171_148;
  wire                when_BankedScratchMemory_l171_149;
  wire                when_BankedScratchMemory_l171_150;
  wire                when_BankedScratchMemory_l171_151;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_19;
  wire       [7:0]    _zz_io_bAddr_19;
  wire                when_BankedScratchMemory_l171_152;
  wire                when_BankedScratchMemory_l171_153;
  wire                when_BankedScratchMemory_l171_154;
  wire                when_BankedScratchMemory_l171_155;
  wire                when_BankedScratchMemory_l171_156;
  wire                when_BankedScratchMemory_l171_157;
  wire                when_BankedScratchMemory_l171_158;
  wire                when_BankedScratchMemory_l171_159;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_20;
  wire       [7:0]    _zz_io_bAddr_20;
  wire                when_BankedScratchMemory_l171_160;
  wire                when_BankedScratchMemory_l171_161;
  wire                when_BankedScratchMemory_l171_162;
  wire                when_BankedScratchMemory_l171_163;
  wire                when_BankedScratchMemory_l171_164;
  wire                when_BankedScratchMemory_l171_165;
  wire                when_BankedScratchMemory_l171_166;
  wire                when_BankedScratchMemory_l171_167;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_21;
  wire       [7:0]    _zz_io_bAddr_21;
  wire                when_BankedScratchMemory_l171_168;
  wire                when_BankedScratchMemory_l171_169;
  wire                when_BankedScratchMemory_l171_170;
  wire                when_BankedScratchMemory_l171_171;
  wire                when_BankedScratchMemory_l171_172;
  wire                when_BankedScratchMemory_l171_173;
  wire                when_BankedScratchMemory_l171_174;
  wire                when_BankedScratchMemory_l171_175;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_22;
  wire       [7:0]    _zz_io_bAddr_22;
  wire                when_BankedScratchMemory_l171_176;
  wire                when_BankedScratchMemory_l171_177;
  wire                when_BankedScratchMemory_l171_178;
  wire                when_BankedScratchMemory_l171_179;
  wire                when_BankedScratchMemory_l171_180;
  wire                when_BankedScratchMemory_l171_181;
  wire                when_BankedScratchMemory_l171_182;
  wire                when_BankedScratchMemory_l171_183;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_23;
  wire       [7:0]    _zz_io_bAddr_23;
  wire                when_BankedScratchMemory_l171_184;
  wire                when_BankedScratchMemory_l171_185;
  wire                when_BankedScratchMemory_l171_186;
  wire                when_BankedScratchMemory_l171_187;
  wire                when_BankedScratchMemory_l171_188;
  wire                when_BankedScratchMemory_l171_189;
  wire                when_BankedScratchMemory_l171_190;
  wire                when_BankedScratchMemory_l171_191;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_24;
  wire       [7:0]    _zz_io_bAddr_24;
  wire                when_BankedScratchMemory_l171_192;
  wire                when_BankedScratchMemory_l171_193;
  wire                when_BankedScratchMemory_l171_194;
  wire                when_BankedScratchMemory_l171_195;
  wire                when_BankedScratchMemory_l171_196;
  wire                when_BankedScratchMemory_l171_197;
  wire                when_BankedScratchMemory_l171_198;
  wire                when_BankedScratchMemory_l171_199;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_25;
  wire       [7:0]    _zz_io_bAddr_25;
  wire                when_BankedScratchMemory_l171_200;
  wire                when_BankedScratchMemory_l171_201;
  wire                when_BankedScratchMemory_l171_202;
  wire                when_BankedScratchMemory_l171_203;
  wire                when_BankedScratchMemory_l171_204;
  wire                when_BankedScratchMemory_l171_205;
  wire                when_BankedScratchMemory_l171_206;
  wire                when_BankedScratchMemory_l171_207;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_26;
  wire       [7:0]    _zz_io_bAddr_26;
  wire                when_BankedScratchMemory_l171_208;
  wire                when_BankedScratchMemory_l171_209;
  wire                when_BankedScratchMemory_l171_210;
  wire                when_BankedScratchMemory_l171_211;
  wire                when_BankedScratchMemory_l171_212;
  wire                when_BankedScratchMemory_l171_213;
  wire                when_BankedScratchMemory_l171_214;
  wire                when_BankedScratchMemory_l171_215;
  wire       [2:0]    _zz_when_BankedScratchMemory_l171_27;
  wire       [7:0]    _zz_io_bAddr_27;
  wire                when_BankedScratchMemory_l171_216;
  wire                when_BankedScratchMemory_l171_217;
  wire                when_BankedScratchMemory_l171_218;
  wire                when_BankedScratchMemory_l171_219;
  wire                when_BankedScratchMemory_l171_220;
  wire                when_BankedScratchMemory_l171_221;
  wire                when_BankedScratchMemory_l171_222;
  wire                when_BankedScratchMemory_l171_223;
  wire       [2:0]    scalarBankReq_0;
  wire       [2:0]    scalarBankReq_1;
  wire       [2:0]    scalarBankReq_2;
  wire       [2:0]    scalarBankReq_3;
  wire       [2:0]    scalarBankReq_4;
  wire       [2:0]    scalarBankReq_5;
  wire       [2:0]    scalarBankReq_6;
  wire       [2:0]    scalarBankReq_7;
  wire       [2:0]    scalarBankReq_8;
  wire       [7:0]    scalarBankRow_0;
  wire       [7:0]    scalarBankRow_1;
  wire       [7:0]    scalarBankRow_2;
  wire       [7:0]    scalarBankRow_3;
  wire       [7:0]    scalarBankRow_4;
  wire       [7:0]    scalarBankRow_5;
  wire       [7:0]    scalarBankRow_6;
  wire       [7:0]    scalarBankRow_7;
  wire       [7:0]    scalarBankRow_8;
  reg                 scalarUsedPortB_0;
  reg                 scalarUsedPortB_1;
  reg                 scalarUsedPortB_2;
  reg                 scalarUsedPortB_3;
  reg                 scalarUsedPortB_4;
  reg                 scalarUsedPortB_5;
  reg                 scalarUsedPortB_6;
  reg                 scalarUsedPortB_7;
  reg                 scalarUsedPortB_8;
  wire                _zz_when_BankedScratchMemory_l228;
  wire                _zz_when_BankedScratchMemory_l245;
  wire                _zz_when_BankedScratchMemory_l228_1;
  wire                when_BankedScratchMemory_l228;
  wire                _zz_when_BankedScratchMemory_l234;
  wire                when_BankedScratchMemory_l245;
  wire                _zz_when_BankedScratchMemory_l245_1;
  wire                _zz_when_BankedScratchMemory_l228_2;
  wire                when_BankedScratchMemory_l234;
  wire                when_BankedScratchMemory_l242;
  wire                _zz_when_BankedScratchMemory_l228_3;
  wire                when_BankedScratchMemory_l228_1;
  wire                _zz_when_BankedScratchMemory_l234_1;
  wire                when_BankedScratchMemory_l245_1;
  wire                _zz_when_BankedScratchMemory_l245_2;
  wire                _zz_when_BankedScratchMemory_l228_4;
  wire                when_BankedScratchMemory_l234_1;
  wire                when_BankedScratchMemory_l242_1;
  wire                _zz_when_BankedScratchMemory_l228_5;
  wire                when_BankedScratchMemory_l228_2;
  wire                _zz_when_BankedScratchMemory_l234_2;
  wire                when_BankedScratchMemory_l245_2;
  wire                _zz_when_BankedScratchMemory_l245_3;
  wire                _zz_when_BankedScratchMemory_l228_6;
  wire                when_BankedScratchMemory_l234_2;
  wire                when_BankedScratchMemory_l242_2;
  wire                _zz_when_BankedScratchMemory_l228_7;
  wire                when_BankedScratchMemory_l228_3;
  wire                _zz_when_BankedScratchMemory_l234_3;
  wire                when_BankedScratchMemory_l245_3;
  wire                _zz_when_BankedScratchMemory_l245_4;
  wire                _zz_when_BankedScratchMemory_l228_8;
  wire                when_BankedScratchMemory_l234_3;
  wire                when_BankedScratchMemory_l242_3;
  wire                _zz_when_BankedScratchMemory_l228_9;
  wire                when_BankedScratchMemory_l228_4;
  wire                _zz_when_BankedScratchMemory_l234_4;
  wire                when_BankedScratchMemory_l245_4;
  wire                _zz_when_BankedScratchMemory_l245_5;
  wire                _zz_when_BankedScratchMemory_l228_10;
  wire                when_BankedScratchMemory_l234_4;
  wire                when_BankedScratchMemory_l242_4;
  wire                _zz_when_BankedScratchMemory_l228_11;
  wire                when_BankedScratchMemory_l228_5;
  wire                _zz_when_BankedScratchMemory_l234_5;
  wire                when_BankedScratchMemory_l245_5;
  wire                _zz_when_BankedScratchMemory_l245_6;
  wire                _zz_when_BankedScratchMemory_l228_12;
  wire                when_BankedScratchMemory_l234_5;
  wire                when_BankedScratchMemory_l242_5;
  wire                _zz_when_BankedScratchMemory_l228_13;
  wire                when_BankedScratchMemory_l228_6;
  wire                _zz_when_BankedScratchMemory_l234_6;
  wire                when_BankedScratchMemory_l245_6;
  wire                _zz_when_BankedScratchMemory_l245_7;
  wire                _zz_when_BankedScratchMemory_l228_14;
  wire                when_BankedScratchMemory_l234_6;
  wire                when_BankedScratchMemory_l242_6;
  wire                _zz_when_BankedScratchMemory_l228_15;
  wire                when_BankedScratchMemory_l228_7;
  wire                _zz_when_BankedScratchMemory_l234_7;
  wire                when_BankedScratchMemory_l245_7;
  wire                _zz_when_BankedScratchMemory_l245_8;
  wire                _zz_when_BankedScratchMemory_l228_16;
  wire                when_BankedScratchMemory_l234_7;
  wire                when_BankedScratchMemory_l242_7;
  wire                _zz_when_BankedScratchMemory_l228_17;
  wire                when_BankedScratchMemory_l228_8;
  wire                _zz_when_BankedScratchMemory_l234_8;
  wire                when_BankedScratchMemory_l245_8;
  wire                when_BankedScratchMemory_l234_8;
  wire                when_BankedScratchMemory_l242_8;
  wire                _zz_when_BankedScratchMemory_l228_18;
  wire                _zz_when_BankedScratchMemory_l245_9;
  wire                _zz_when_BankedScratchMemory_l228_19;
  wire                when_BankedScratchMemory_l228_9;
  wire                _zz_when_BankedScratchMemory_l234_9;
  wire                when_BankedScratchMemory_l245_9;
  wire                _zz_when_BankedScratchMemory_l245_10;
  wire                _zz_when_BankedScratchMemory_l228_20;
  wire                when_BankedScratchMemory_l234_9;
  wire                when_BankedScratchMemory_l242_9;
  wire                _zz_when_BankedScratchMemory_l228_21;
  wire                when_BankedScratchMemory_l228_10;
  wire                _zz_when_BankedScratchMemory_l234_10;
  wire                when_BankedScratchMemory_l245_10;
  wire                _zz_when_BankedScratchMemory_l245_11;
  wire                _zz_when_BankedScratchMemory_l228_22;
  wire                when_BankedScratchMemory_l234_10;
  wire                when_BankedScratchMemory_l242_10;
  wire                _zz_when_BankedScratchMemory_l228_23;
  wire                when_BankedScratchMemory_l228_11;
  wire                _zz_when_BankedScratchMemory_l234_11;
  wire                when_BankedScratchMemory_l245_11;
  wire                _zz_when_BankedScratchMemory_l245_12;
  wire                _zz_when_BankedScratchMemory_l228_24;
  wire                when_BankedScratchMemory_l234_11;
  wire                when_BankedScratchMemory_l242_11;
  wire                _zz_when_BankedScratchMemory_l228_25;
  wire                when_BankedScratchMemory_l228_12;
  wire                _zz_when_BankedScratchMemory_l234_12;
  wire                when_BankedScratchMemory_l245_12;
  wire                _zz_when_BankedScratchMemory_l245_13;
  wire                _zz_when_BankedScratchMemory_l228_26;
  wire                when_BankedScratchMemory_l234_12;
  wire                when_BankedScratchMemory_l242_12;
  wire                _zz_when_BankedScratchMemory_l228_27;
  wire                when_BankedScratchMemory_l228_13;
  wire                _zz_when_BankedScratchMemory_l234_13;
  wire                when_BankedScratchMemory_l245_13;
  wire                _zz_when_BankedScratchMemory_l245_14;
  wire                _zz_when_BankedScratchMemory_l228_28;
  wire                when_BankedScratchMemory_l234_13;
  wire                when_BankedScratchMemory_l242_13;
  wire                _zz_when_BankedScratchMemory_l228_29;
  wire                when_BankedScratchMemory_l228_14;
  wire                _zz_when_BankedScratchMemory_l234_14;
  wire                when_BankedScratchMemory_l245_14;
  wire                _zz_when_BankedScratchMemory_l245_15;
  wire                _zz_when_BankedScratchMemory_l228_30;
  wire                when_BankedScratchMemory_l234_14;
  wire                when_BankedScratchMemory_l242_14;
  wire                _zz_when_BankedScratchMemory_l228_31;
  wire                when_BankedScratchMemory_l228_15;
  wire                _zz_when_BankedScratchMemory_l234_15;
  wire                when_BankedScratchMemory_l245_15;
  wire                _zz_when_BankedScratchMemory_l245_16;
  wire                _zz_when_BankedScratchMemory_l228_32;
  wire                when_BankedScratchMemory_l234_15;
  wire                when_BankedScratchMemory_l242_15;
  wire                _zz_when_BankedScratchMemory_l228_33;
  wire                when_BankedScratchMemory_l228_16;
  wire                _zz_when_BankedScratchMemory_l234_16;
  wire                when_BankedScratchMemory_l245_16;
  wire                _zz_when_BankedScratchMemory_l245_17;
  wire                _zz_when_BankedScratchMemory_l228_34;
  wire                when_BankedScratchMemory_l234_16;
  wire                when_BankedScratchMemory_l242_16;
  wire                _zz_when_BankedScratchMemory_l228_35;
  wire                when_BankedScratchMemory_l228_17;
  wire                _zz_when_BankedScratchMemory_l234_17;
  wire                when_BankedScratchMemory_l245_17;
  wire                when_BankedScratchMemory_l234_17;
  wire                when_BankedScratchMemory_l242_17;
  wire                _zz_when_BankedScratchMemory_l228_36;
  wire                _zz_when_BankedScratchMemory_l245_18;
  wire                _zz_when_BankedScratchMemory_l228_37;
  wire                when_BankedScratchMemory_l228_18;
  wire                _zz_when_BankedScratchMemory_l234_18;
  wire                when_BankedScratchMemory_l245_18;
  wire                _zz_when_BankedScratchMemory_l245_19;
  wire                _zz_when_BankedScratchMemory_l228_38;
  wire                when_BankedScratchMemory_l234_18;
  wire                when_BankedScratchMemory_l242_18;
  wire                _zz_when_BankedScratchMemory_l228_39;
  wire                when_BankedScratchMemory_l228_19;
  wire                _zz_when_BankedScratchMemory_l234_19;
  wire                when_BankedScratchMemory_l245_19;
  wire                _zz_when_BankedScratchMemory_l245_20;
  wire                _zz_when_BankedScratchMemory_l228_40;
  wire                when_BankedScratchMemory_l234_19;
  wire                when_BankedScratchMemory_l242_19;
  wire                _zz_when_BankedScratchMemory_l228_41;
  wire                when_BankedScratchMemory_l228_20;
  wire                _zz_when_BankedScratchMemory_l234_20;
  wire                when_BankedScratchMemory_l245_20;
  wire                _zz_when_BankedScratchMemory_l245_21;
  wire                _zz_when_BankedScratchMemory_l228_42;
  wire                when_BankedScratchMemory_l234_20;
  wire                when_BankedScratchMemory_l242_20;
  wire                _zz_when_BankedScratchMemory_l228_43;
  wire                when_BankedScratchMemory_l228_21;
  wire                _zz_when_BankedScratchMemory_l234_21;
  wire                when_BankedScratchMemory_l245_21;
  wire                _zz_when_BankedScratchMemory_l245_22;
  wire                _zz_when_BankedScratchMemory_l228_44;
  wire                when_BankedScratchMemory_l234_21;
  wire                when_BankedScratchMemory_l242_21;
  wire                _zz_when_BankedScratchMemory_l228_45;
  wire                when_BankedScratchMemory_l228_22;
  wire                _zz_when_BankedScratchMemory_l234_22;
  wire                when_BankedScratchMemory_l245_22;
  wire                _zz_when_BankedScratchMemory_l245_23;
  wire                _zz_when_BankedScratchMemory_l228_46;
  wire                when_BankedScratchMemory_l234_22;
  wire                when_BankedScratchMemory_l242_22;
  wire                _zz_when_BankedScratchMemory_l228_47;
  wire                when_BankedScratchMemory_l228_23;
  wire                _zz_when_BankedScratchMemory_l234_23;
  wire                when_BankedScratchMemory_l245_23;
  wire                _zz_when_BankedScratchMemory_l245_24;
  wire                _zz_when_BankedScratchMemory_l228_48;
  wire                when_BankedScratchMemory_l234_23;
  wire                when_BankedScratchMemory_l242_23;
  wire                _zz_when_BankedScratchMemory_l228_49;
  wire                when_BankedScratchMemory_l228_24;
  wire                _zz_when_BankedScratchMemory_l234_24;
  wire                when_BankedScratchMemory_l245_24;
  wire                _zz_when_BankedScratchMemory_l245_25;
  wire                _zz_when_BankedScratchMemory_l228_50;
  wire                when_BankedScratchMemory_l234_24;
  wire                when_BankedScratchMemory_l242_24;
  wire                _zz_when_BankedScratchMemory_l228_51;
  wire                when_BankedScratchMemory_l228_25;
  wire                _zz_when_BankedScratchMemory_l234_25;
  wire                when_BankedScratchMemory_l245_25;
  wire                _zz_when_BankedScratchMemory_l245_26;
  wire                _zz_when_BankedScratchMemory_l228_52;
  wire                when_BankedScratchMemory_l234_25;
  wire                when_BankedScratchMemory_l242_25;
  wire                _zz_when_BankedScratchMemory_l228_53;
  wire                when_BankedScratchMemory_l228_26;
  wire                _zz_when_BankedScratchMemory_l234_26;
  wire                when_BankedScratchMemory_l245_26;
  wire                when_BankedScratchMemory_l234_26;
  wire                when_BankedScratchMemory_l242_26;
  wire                _zz_when_BankedScratchMemory_l228_54;
  wire                _zz_when_BankedScratchMemory_l245_27;
  wire                _zz_when_BankedScratchMemory_l228_55;
  wire                when_BankedScratchMemory_l228_27;
  wire                _zz_when_BankedScratchMemory_l234_27;
  wire                when_BankedScratchMemory_l245_27;
  wire                _zz_when_BankedScratchMemory_l245_28;
  wire                _zz_when_BankedScratchMemory_l228_56;
  wire                when_BankedScratchMemory_l234_27;
  wire                when_BankedScratchMemory_l242_27;
  wire                _zz_when_BankedScratchMemory_l228_57;
  wire                when_BankedScratchMemory_l228_28;
  wire                _zz_when_BankedScratchMemory_l234_28;
  wire                when_BankedScratchMemory_l245_28;
  wire                _zz_when_BankedScratchMemory_l245_29;
  wire                _zz_when_BankedScratchMemory_l228_58;
  wire                when_BankedScratchMemory_l234_28;
  wire                when_BankedScratchMemory_l242_28;
  wire                _zz_when_BankedScratchMemory_l228_59;
  wire                when_BankedScratchMemory_l228_29;
  wire                _zz_when_BankedScratchMemory_l234_29;
  wire                when_BankedScratchMemory_l245_29;
  wire                _zz_when_BankedScratchMemory_l245_30;
  wire                _zz_when_BankedScratchMemory_l228_60;
  wire                when_BankedScratchMemory_l234_29;
  wire                when_BankedScratchMemory_l242_29;
  wire                _zz_when_BankedScratchMemory_l228_61;
  wire                when_BankedScratchMemory_l228_30;
  wire                _zz_when_BankedScratchMemory_l234_30;
  wire                when_BankedScratchMemory_l245_30;
  wire                _zz_when_BankedScratchMemory_l245_31;
  wire                _zz_when_BankedScratchMemory_l228_62;
  wire                when_BankedScratchMemory_l234_30;
  wire                when_BankedScratchMemory_l242_30;
  wire                _zz_when_BankedScratchMemory_l228_63;
  wire                when_BankedScratchMemory_l228_31;
  wire                _zz_when_BankedScratchMemory_l234_31;
  wire                when_BankedScratchMemory_l245_31;
  wire                _zz_when_BankedScratchMemory_l245_32;
  wire                _zz_when_BankedScratchMemory_l228_64;
  wire                when_BankedScratchMemory_l234_31;
  wire                when_BankedScratchMemory_l242_31;
  wire                _zz_when_BankedScratchMemory_l228_65;
  wire                when_BankedScratchMemory_l228_32;
  wire                _zz_when_BankedScratchMemory_l234_32;
  wire                when_BankedScratchMemory_l245_32;
  wire                _zz_when_BankedScratchMemory_l245_33;
  wire                _zz_when_BankedScratchMemory_l228_66;
  wire                when_BankedScratchMemory_l234_32;
  wire                when_BankedScratchMemory_l242_32;
  wire                _zz_when_BankedScratchMemory_l228_67;
  wire                when_BankedScratchMemory_l228_33;
  wire                _zz_when_BankedScratchMemory_l234_33;
  wire                when_BankedScratchMemory_l245_33;
  wire                _zz_when_BankedScratchMemory_l245_34;
  wire                _zz_when_BankedScratchMemory_l228_68;
  wire                when_BankedScratchMemory_l234_33;
  wire                when_BankedScratchMemory_l242_33;
  wire                _zz_when_BankedScratchMemory_l228_69;
  wire                when_BankedScratchMemory_l228_34;
  wire                _zz_when_BankedScratchMemory_l234_34;
  wire                when_BankedScratchMemory_l245_34;
  wire                _zz_when_BankedScratchMemory_l245_35;
  wire                _zz_when_BankedScratchMemory_l228_70;
  wire                when_BankedScratchMemory_l234_34;
  wire                when_BankedScratchMemory_l242_34;
  wire                _zz_when_BankedScratchMemory_l228_71;
  wire                when_BankedScratchMemory_l228_35;
  wire                _zz_when_BankedScratchMemory_l234_35;
  wire                when_BankedScratchMemory_l245_35;
  wire                when_BankedScratchMemory_l234_35;
  wire                when_BankedScratchMemory_l242_35;
  wire                _zz_when_BankedScratchMemory_l228_72;
  wire                _zz_when_BankedScratchMemory_l245_36;
  wire                _zz_when_BankedScratchMemory_l228_73;
  wire                when_BankedScratchMemory_l228_36;
  wire                _zz_when_BankedScratchMemory_l234_36;
  wire                when_BankedScratchMemory_l245_36;
  wire                _zz_when_BankedScratchMemory_l245_37;
  wire                _zz_when_BankedScratchMemory_l228_74;
  wire                when_BankedScratchMemory_l234_36;
  wire                when_BankedScratchMemory_l242_36;
  wire                _zz_when_BankedScratchMemory_l228_75;
  wire                when_BankedScratchMemory_l228_37;
  wire                _zz_when_BankedScratchMemory_l234_37;
  wire                when_BankedScratchMemory_l245_37;
  wire                _zz_when_BankedScratchMemory_l245_38;
  wire                _zz_when_BankedScratchMemory_l228_76;
  wire                when_BankedScratchMemory_l234_37;
  wire                when_BankedScratchMemory_l242_37;
  wire                _zz_when_BankedScratchMemory_l228_77;
  wire                when_BankedScratchMemory_l228_38;
  wire                _zz_when_BankedScratchMemory_l234_38;
  wire                when_BankedScratchMemory_l245_38;
  wire                _zz_when_BankedScratchMemory_l245_39;
  wire                _zz_when_BankedScratchMemory_l228_78;
  wire                when_BankedScratchMemory_l234_38;
  wire                when_BankedScratchMemory_l242_38;
  wire                _zz_when_BankedScratchMemory_l228_79;
  wire                when_BankedScratchMemory_l228_39;
  wire                _zz_when_BankedScratchMemory_l234_39;
  wire                when_BankedScratchMemory_l245_39;
  wire                _zz_when_BankedScratchMemory_l245_40;
  wire                _zz_when_BankedScratchMemory_l228_80;
  wire                when_BankedScratchMemory_l234_39;
  wire                when_BankedScratchMemory_l242_39;
  wire                _zz_when_BankedScratchMemory_l228_81;
  wire                when_BankedScratchMemory_l228_40;
  wire                _zz_when_BankedScratchMemory_l234_40;
  wire                when_BankedScratchMemory_l245_40;
  wire                _zz_when_BankedScratchMemory_l245_41;
  wire                _zz_when_BankedScratchMemory_l228_82;
  wire                when_BankedScratchMemory_l234_40;
  wire                when_BankedScratchMemory_l242_40;
  wire                _zz_when_BankedScratchMemory_l228_83;
  wire                when_BankedScratchMemory_l228_41;
  wire                _zz_when_BankedScratchMemory_l234_41;
  wire                when_BankedScratchMemory_l245_41;
  wire                _zz_when_BankedScratchMemory_l245_42;
  wire                _zz_when_BankedScratchMemory_l228_84;
  wire                when_BankedScratchMemory_l234_41;
  wire                when_BankedScratchMemory_l242_41;
  wire                _zz_when_BankedScratchMemory_l228_85;
  wire                when_BankedScratchMemory_l228_42;
  wire                _zz_when_BankedScratchMemory_l234_42;
  wire                when_BankedScratchMemory_l245_42;
  wire                _zz_when_BankedScratchMemory_l245_43;
  wire                _zz_when_BankedScratchMemory_l228_86;
  wire                when_BankedScratchMemory_l234_42;
  wire                when_BankedScratchMemory_l242_42;
  wire                _zz_when_BankedScratchMemory_l228_87;
  wire                when_BankedScratchMemory_l228_43;
  wire                _zz_when_BankedScratchMemory_l234_43;
  wire                when_BankedScratchMemory_l245_43;
  wire                _zz_when_BankedScratchMemory_l245_44;
  wire                _zz_when_BankedScratchMemory_l228_88;
  wire                when_BankedScratchMemory_l234_43;
  wire                when_BankedScratchMemory_l242_43;
  wire                _zz_when_BankedScratchMemory_l228_89;
  wire                when_BankedScratchMemory_l228_44;
  wire                _zz_when_BankedScratchMemory_l234_44;
  wire                when_BankedScratchMemory_l245_44;
  wire                when_BankedScratchMemory_l234_44;
  wire                when_BankedScratchMemory_l242_44;
  wire                _zz_when_BankedScratchMemory_l228_90;
  wire                _zz_when_BankedScratchMemory_l245_45;
  wire                _zz_when_BankedScratchMemory_l228_91;
  wire                when_BankedScratchMemory_l228_45;
  wire                _zz_when_BankedScratchMemory_l234_45;
  wire                when_BankedScratchMemory_l245_45;
  wire                _zz_when_BankedScratchMemory_l245_46;
  wire                _zz_when_BankedScratchMemory_l228_92;
  wire                when_BankedScratchMemory_l234_45;
  wire                when_BankedScratchMemory_l242_45;
  wire                _zz_when_BankedScratchMemory_l228_93;
  wire                when_BankedScratchMemory_l228_46;
  wire                _zz_when_BankedScratchMemory_l234_46;
  wire                when_BankedScratchMemory_l245_46;
  wire                _zz_when_BankedScratchMemory_l245_47;
  wire                _zz_when_BankedScratchMemory_l228_94;
  wire                when_BankedScratchMemory_l234_46;
  wire                when_BankedScratchMemory_l242_46;
  wire                _zz_when_BankedScratchMemory_l228_95;
  wire                when_BankedScratchMemory_l228_47;
  wire                _zz_when_BankedScratchMemory_l234_47;
  wire                when_BankedScratchMemory_l245_47;
  wire                _zz_when_BankedScratchMemory_l245_48;
  wire                _zz_when_BankedScratchMemory_l228_96;
  wire                when_BankedScratchMemory_l234_47;
  wire                when_BankedScratchMemory_l242_47;
  wire                _zz_when_BankedScratchMemory_l228_97;
  wire                when_BankedScratchMemory_l228_48;
  wire                _zz_when_BankedScratchMemory_l234_48;
  wire                when_BankedScratchMemory_l245_48;
  wire                _zz_when_BankedScratchMemory_l245_49;
  wire                _zz_when_BankedScratchMemory_l228_98;
  wire                when_BankedScratchMemory_l234_48;
  wire                when_BankedScratchMemory_l242_48;
  wire                _zz_when_BankedScratchMemory_l228_99;
  wire                when_BankedScratchMemory_l228_49;
  wire                _zz_when_BankedScratchMemory_l234_49;
  wire                when_BankedScratchMemory_l245_49;
  wire                _zz_when_BankedScratchMemory_l245_50;
  wire                _zz_when_BankedScratchMemory_l228_100;
  wire                when_BankedScratchMemory_l234_49;
  wire                when_BankedScratchMemory_l242_49;
  wire                _zz_when_BankedScratchMemory_l228_101;
  wire                when_BankedScratchMemory_l228_50;
  wire                _zz_when_BankedScratchMemory_l234_50;
  wire                when_BankedScratchMemory_l245_50;
  wire                _zz_when_BankedScratchMemory_l245_51;
  wire                _zz_when_BankedScratchMemory_l228_102;
  wire                when_BankedScratchMemory_l234_50;
  wire                when_BankedScratchMemory_l242_50;
  wire                _zz_when_BankedScratchMemory_l228_103;
  wire                when_BankedScratchMemory_l228_51;
  wire                _zz_when_BankedScratchMemory_l234_51;
  wire                when_BankedScratchMemory_l245_51;
  wire                _zz_when_BankedScratchMemory_l245_52;
  wire                _zz_when_BankedScratchMemory_l228_104;
  wire                when_BankedScratchMemory_l234_51;
  wire                when_BankedScratchMemory_l242_51;
  wire                _zz_when_BankedScratchMemory_l228_105;
  wire                when_BankedScratchMemory_l228_52;
  wire                _zz_when_BankedScratchMemory_l234_52;
  wire                when_BankedScratchMemory_l245_52;
  wire                _zz_when_BankedScratchMemory_l245_53;
  wire                _zz_when_BankedScratchMemory_l228_106;
  wire                when_BankedScratchMemory_l234_52;
  wire                when_BankedScratchMemory_l242_52;
  wire                _zz_when_BankedScratchMemory_l228_107;
  wire                when_BankedScratchMemory_l228_53;
  wire                _zz_when_BankedScratchMemory_l234_53;
  wire                when_BankedScratchMemory_l245_53;
  wire                when_BankedScratchMemory_l234_53;
  wire                when_BankedScratchMemory_l242_53;
  wire                _zz_when_BankedScratchMemory_l228_108;
  wire                _zz_when_BankedScratchMemory_l245_54;
  wire                _zz_when_BankedScratchMemory_l228_109;
  wire                when_BankedScratchMemory_l228_54;
  wire                _zz_when_BankedScratchMemory_l234_54;
  wire                when_BankedScratchMemory_l245_54;
  wire                _zz_when_BankedScratchMemory_l245_55;
  wire                _zz_when_BankedScratchMemory_l228_110;
  wire                when_BankedScratchMemory_l234_54;
  wire                when_BankedScratchMemory_l242_54;
  wire                _zz_when_BankedScratchMemory_l228_111;
  wire                when_BankedScratchMemory_l228_55;
  wire                _zz_when_BankedScratchMemory_l234_55;
  wire                when_BankedScratchMemory_l245_55;
  wire                _zz_when_BankedScratchMemory_l245_56;
  wire                _zz_when_BankedScratchMemory_l228_112;
  wire                when_BankedScratchMemory_l234_55;
  wire                when_BankedScratchMemory_l242_55;
  wire                _zz_when_BankedScratchMemory_l228_113;
  wire                when_BankedScratchMemory_l228_56;
  wire                _zz_when_BankedScratchMemory_l234_56;
  wire                when_BankedScratchMemory_l245_56;
  wire                _zz_when_BankedScratchMemory_l245_57;
  wire                _zz_when_BankedScratchMemory_l228_114;
  wire                when_BankedScratchMemory_l234_56;
  wire                when_BankedScratchMemory_l242_56;
  wire                _zz_when_BankedScratchMemory_l228_115;
  wire                when_BankedScratchMemory_l228_57;
  wire                _zz_when_BankedScratchMemory_l234_57;
  wire                when_BankedScratchMemory_l245_57;
  wire                _zz_when_BankedScratchMemory_l245_58;
  wire                _zz_when_BankedScratchMemory_l228_116;
  wire                when_BankedScratchMemory_l234_57;
  wire                when_BankedScratchMemory_l242_57;
  wire                _zz_when_BankedScratchMemory_l228_117;
  wire                when_BankedScratchMemory_l228_58;
  wire                _zz_when_BankedScratchMemory_l234_58;
  wire                when_BankedScratchMemory_l245_58;
  wire                _zz_when_BankedScratchMemory_l245_59;
  wire                _zz_when_BankedScratchMemory_l228_118;
  wire                when_BankedScratchMemory_l234_58;
  wire                when_BankedScratchMemory_l242_58;
  wire                _zz_when_BankedScratchMemory_l228_119;
  wire                when_BankedScratchMemory_l228_59;
  wire                _zz_when_BankedScratchMemory_l234_59;
  wire                when_BankedScratchMemory_l245_59;
  wire                _zz_when_BankedScratchMemory_l245_60;
  wire                _zz_when_BankedScratchMemory_l228_120;
  wire                when_BankedScratchMemory_l234_59;
  wire                when_BankedScratchMemory_l242_59;
  wire                _zz_when_BankedScratchMemory_l228_121;
  wire                when_BankedScratchMemory_l228_60;
  wire                _zz_when_BankedScratchMemory_l234_60;
  wire                when_BankedScratchMemory_l245_60;
  wire                _zz_when_BankedScratchMemory_l245_61;
  wire                _zz_when_BankedScratchMemory_l228_122;
  wire                when_BankedScratchMemory_l234_60;
  wire                when_BankedScratchMemory_l242_60;
  wire                _zz_when_BankedScratchMemory_l228_123;
  wire                when_BankedScratchMemory_l228_61;
  wire                _zz_when_BankedScratchMemory_l234_61;
  wire                when_BankedScratchMemory_l245_61;
  wire                _zz_when_BankedScratchMemory_l245_62;
  wire                _zz_when_BankedScratchMemory_l228_124;
  wire                when_BankedScratchMemory_l234_61;
  wire                when_BankedScratchMemory_l242_61;
  wire                _zz_when_BankedScratchMemory_l228_125;
  wire                when_BankedScratchMemory_l228_62;
  wire                _zz_when_BankedScratchMemory_l234_62;
  wire                when_BankedScratchMemory_l245_62;
  wire                when_BankedScratchMemory_l234_62;
  wire                when_BankedScratchMemory_l242_62;
  wire                _zz_when_BankedScratchMemory_l228_126;
  wire                _zz_when_BankedScratchMemory_l245_63;
  wire                _zz_when_BankedScratchMemory_l228_127;
  wire                when_BankedScratchMemory_l228_63;
  wire                _zz_when_BankedScratchMemory_l234_63;
  wire                when_BankedScratchMemory_l245_63;
  wire                _zz_when_BankedScratchMemory_l245_64;
  wire                _zz_when_BankedScratchMemory_l228_128;
  wire                when_BankedScratchMemory_l234_63;
  wire                when_BankedScratchMemory_l242_63;
  wire                _zz_when_BankedScratchMemory_l228_129;
  wire                when_BankedScratchMemory_l228_64;
  wire                _zz_when_BankedScratchMemory_l234_64;
  wire                when_BankedScratchMemory_l245_64;
  wire                _zz_when_BankedScratchMemory_l245_65;
  wire                _zz_when_BankedScratchMemory_l228_130;
  wire                when_BankedScratchMemory_l234_64;
  wire                when_BankedScratchMemory_l242_64;
  wire                _zz_when_BankedScratchMemory_l228_131;
  wire                when_BankedScratchMemory_l228_65;
  wire                _zz_when_BankedScratchMemory_l234_65;
  wire                when_BankedScratchMemory_l245_65;
  wire                _zz_when_BankedScratchMemory_l245_66;
  wire                _zz_when_BankedScratchMemory_l228_132;
  wire                when_BankedScratchMemory_l234_65;
  wire                when_BankedScratchMemory_l242_65;
  wire                _zz_when_BankedScratchMemory_l228_133;
  wire                when_BankedScratchMemory_l228_66;
  wire                _zz_when_BankedScratchMemory_l234_66;
  wire                when_BankedScratchMemory_l245_66;
  wire                _zz_when_BankedScratchMemory_l245_67;
  wire                _zz_when_BankedScratchMemory_l228_134;
  wire                when_BankedScratchMemory_l234_66;
  wire                when_BankedScratchMemory_l242_66;
  wire                _zz_when_BankedScratchMemory_l228_135;
  wire                when_BankedScratchMemory_l228_67;
  wire                _zz_when_BankedScratchMemory_l234_67;
  wire                when_BankedScratchMemory_l245_67;
  wire                _zz_when_BankedScratchMemory_l245_68;
  wire                _zz_when_BankedScratchMemory_l228_136;
  wire                when_BankedScratchMemory_l234_67;
  wire                when_BankedScratchMemory_l242_67;
  wire                _zz_when_BankedScratchMemory_l228_137;
  wire                when_BankedScratchMemory_l228_68;
  wire                _zz_when_BankedScratchMemory_l234_68;
  wire                when_BankedScratchMemory_l245_68;
  wire                _zz_when_BankedScratchMemory_l245_69;
  wire                _zz_when_BankedScratchMemory_l228_138;
  wire                when_BankedScratchMemory_l234_68;
  wire                when_BankedScratchMemory_l242_68;
  wire                _zz_when_BankedScratchMemory_l228_139;
  wire                when_BankedScratchMemory_l228_69;
  wire                _zz_when_BankedScratchMemory_l234_69;
  wire                when_BankedScratchMemory_l245_69;
  wire                _zz_when_BankedScratchMemory_l245_70;
  wire                _zz_when_BankedScratchMemory_l228_140;
  wire                when_BankedScratchMemory_l234_69;
  wire                when_BankedScratchMemory_l242_69;
  wire                _zz_when_BankedScratchMemory_l228_141;
  wire                when_BankedScratchMemory_l228_70;
  wire                _zz_when_BankedScratchMemory_l234_70;
  wire                when_BankedScratchMemory_l245_70;
  wire                _zz_when_BankedScratchMemory_l245_71;
  wire                _zz_when_BankedScratchMemory_l228_142;
  wire                when_BankedScratchMemory_l234_70;
  wire                when_BankedScratchMemory_l242_70;
  wire                _zz_when_BankedScratchMemory_l228_143;
  wire                when_BankedScratchMemory_l228_71;
  wire                _zz_when_BankedScratchMemory_l234_71;
  wire                when_BankedScratchMemory_l245_71;
  wire                when_BankedScratchMemory_l234_71;
  wire                when_BankedScratchMemory_l242_71;
  reg        [2:0]    scalarBankReqReg_0;
  reg        [2:0]    scalarBankReqReg_1;
  reg        [2:0]    scalarBankReqReg_2;
  reg        [2:0]    scalarBankReqReg_3;
  reg        [2:0]    scalarBankReqReg_4;
  reg        [2:0]    scalarBankReqReg_5;
  reg        [2:0]    scalarBankReqReg_6;
  reg        [2:0]    scalarBankReqReg_7;
  reg        [2:0]    scalarBankReqReg_8;
  reg                 scalarUsedPortBReg_0;
  reg                 scalarUsedPortBReg_1;
  reg                 scalarUsedPortBReg_2;
  reg                 scalarUsedPortBReg_3;
  reg                 scalarUsedPortBReg_4;
  reg                 scalarUsedPortBReg_5;
  reg                 scalarUsedPortBReg_6;
  reg                 scalarUsedPortBReg_7;
  reg                 scalarUsedPortBReg_8;
  wire                when_BankedScratchMemory_l262;
  wire                when_BankedScratchMemory_l262_1;
  wire                when_BankedScratchMemory_l262_2;
  wire                when_BankedScratchMemory_l262_3;
  wire                when_BankedScratchMemory_l262_4;
  wire                when_BankedScratchMemory_l262_5;
  wire                when_BankedScratchMemory_l262_6;
  wire                when_BankedScratchMemory_l262_7;
  wire                when_BankedScratchMemory_l262_8;
  wire                when_BankedScratchMemory_l262_9;
  wire                when_BankedScratchMemory_l262_10;
  wire                when_BankedScratchMemory_l262_11;
  wire                when_BankedScratchMemory_l262_12;
  wire                when_BankedScratchMemory_l262_13;
  wire                when_BankedScratchMemory_l262_14;
  wire                when_BankedScratchMemory_l262_15;
  wire                when_BankedScratchMemory_l262_16;
  wire                when_BankedScratchMemory_l262_17;
  wire                when_BankedScratchMemory_l262_18;
  wire                when_BankedScratchMemory_l262_19;
  wire                when_BankedScratchMemory_l262_20;
  wire                when_BankedScratchMemory_l262_21;
  wire                when_BankedScratchMemory_l262_22;
  wire                when_BankedScratchMemory_l262_23;
  wire                when_BankedScratchMemory_l262_24;
  wire                when_BankedScratchMemory_l262_25;
  wire                when_BankedScratchMemory_l262_26;
  wire                when_BankedScratchMemory_l262_27;
  wire                when_BankedScratchMemory_l262_28;
  wire                when_BankedScratchMemory_l262_29;
  wire                when_BankedScratchMemory_l262_30;
  wire                when_BankedScratchMemory_l262_31;
  wire                when_BankedScratchMemory_l262_32;
  wire                when_BankedScratchMemory_l262_33;
  wire                when_BankedScratchMemory_l262_34;
  wire                when_BankedScratchMemory_l262_35;
  wire                when_BankedScratchMemory_l262_36;
  wire                when_BankedScratchMemory_l262_37;
  wire                when_BankedScratchMemory_l262_38;
  wire                when_BankedScratchMemory_l262_39;
  wire                when_BankedScratchMemory_l262_40;
  wire                when_BankedScratchMemory_l262_41;
  wire                when_BankedScratchMemory_l262_42;
  wire                when_BankedScratchMemory_l262_43;
  wire                when_BankedScratchMemory_l262_44;
  wire                when_BankedScratchMemory_l262_45;
  wire                when_BankedScratchMemory_l262_46;
  wire                when_BankedScratchMemory_l262_47;
  wire                when_BankedScratchMemory_l262_48;
  wire                when_BankedScratchMemory_l262_49;
  wire                when_BankedScratchMemory_l262_50;
  wire                when_BankedScratchMemory_l262_51;
  wire                when_BankedScratchMemory_l262_52;
  wire                when_BankedScratchMemory_l262_53;
  wire                when_BankedScratchMemory_l262_54;
  wire                when_BankedScratchMemory_l262_55;
  wire                when_BankedScratchMemory_l262_56;
  wire                when_BankedScratchMemory_l262_57;
  wire                when_BankedScratchMemory_l262_58;
  wire                when_BankedScratchMemory_l262_59;
  wire                when_BankedScratchMemory_l262_60;
  wire                when_BankedScratchMemory_l262_61;
  wire                when_BankedScratchMemory_l262_62;
  wire                when_BankedScratchMemory_l262_63;
  wire                when_BankedScratchMemory_l262_64;
  wire                when_BankedScratchMemory_l262_65;
  wire                when_BankedScratchMemory_l262_66;
  wire                when_BankedScratchMemory_l262_67;
  wire                when_BankedScratchMemory_l262_68;
  wire                when_BankedScratchMemory_l262_69;
  wire                when_BankedScratchMemory_l262_70;
  wire                when_BankedScratchMemory_l262_71;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286;
  wire       [7:0]    _zz_io_aAddr;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308;
  wire                when_BankedScratchMemory_l286;
  wire                when_BankedScratchMemory_l286_1;
  wire                when_BankedScratchMemory_l286_2;
  wire                when_BankedScratchMemory_l286_3;
  wire                when_BankedScratchMemory_l286_4;
  wire                when_BankedScratchMemory_l286_5;
  wire                when_BankedScratchMemory_l286_6;
  wire                when_BankedScratchMemory_l286_7;
  reg        [31:0]   _zz_io_valuReadData_0_0;
  wire                when_BankedScratchMemory_l308;
  wire                when_BankedScratchMemory_l308_1;
  wire                when_BankedScratchMemory_l308_2;
  wire                when_BankedScratchMemory_l308_3;
  wire                when_BankedScratchMemory_l308_4;
  wire                when_BankedScratchMemory_l308_5;
  wire                when_BankedScratchMemory_l308_6;
  wire                when_BankedScratchMemory_l308_7;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_1;
  wire       [7:0]    _zz_io_aAddr_1;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_1;
  wire                when_BankedScratchMemory_l286_8;
  wire                when_BankedScratchMemory_l286_9;
  wire                when_BankedScratchMemory_l286_10;
  wire                when_BankedScratchMemory_l286_11;
  wire                when_BankedScratchMemory_l286_12;
  wire                when_BankedScratchMemory_l286_13;
  wire                when_BankedScratchMemory_l286_14;
  wire                when_BankedScratchMemory_l286_15;
  reg        [31:0]   _zz_io_valuReadData_0_1;
  wire                when_BankedScratchMemory_l308_8;
  wire                when_BankedScratchMemory_l308_9;
  wire                when_BankedScratchMemory_l308_10;
  wire                when_BankedScratchMemory_l308_11;
  wire                when_BankedScratchMemory_l308_12;
  wire                when_BankedScratchMemory_l308_13;
  wire                when_BankedScratchMemory_l308_14;
  wire                when_BankedScratchMemory_l308_15;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_2;
  wire       [7:0]    _zz_io_aAddr_2;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_2;
  wire                when_BankedScratchMemory_l286_16;
  wire                when_BankedScratchMemory_l286_17;
  wire                when_BankedScratchMemory_l286_18;
  wire                when_BankedScratchMemory_l286_19;
  wire                when_BankedScratchMemory_l286_20;
  wire                when_BankedScratchMemory_l286_21;
  wire                when_BankedScratchMemory_l286_22;
  wire                when_BankedScratchMemory_l286_23;
  reg        [31:0]   _zz_io_valuReadData_0_2;
  wire                when_BankedScratchMemory_l308_16;
  wire                when_BankedScratchMemory_l308_17;
  wire                when_BankedScratchMemory_l308_18;
  wire                when_BankedScratchMemory_l308_19;
  wire                when_BankedScratchMemory_l308_20;
  wire                when_BankedScratchMemory_l308_21;
  wire                when_BankedScratchMemory_l308_22;
  wire                when_BankedScratchMemory_l308_23;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_3;
  wire       [7:0]    _zz_io_aAddr_3;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_3;
  wire                when_BankedScratchMemory_l286_24;
  wire                when_BankedScratchMemory_l286_25;
  wire                when_BankedScratchMemory_l286_26;
  wire                when_BankedScratchMemory_l286_27;
  wire                when_BankedScratchMemory_l286_28;
  wire                when_BankedScratchMemory_l286_29;
  wire                when_BankedScratchMemory_l286_30;
  wire                when_BankedScratchMemory_l286_31;
  reg        [31:0]   _zz_io_valuReadData_0_3;
  wire                when_BankedScratchMemory_l308_24;
  wire                when_BankedScratchMemory_l308_25;
  wire                when_BankedScratchMemory_l308_26;
  wire                when_BankedScratchMemory_l308_27;
  wire                when_BankedScratchMemory_l308_28;
  wire                when_BankedScratchMemory_l308_29;
  wire                when_BankedScratchMemory_l308_30;
  wire                when_BankedScratchMemory_l308_31;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_4;
  wire       [7:0]    _zz_io_aAddr_4;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_4;
  wire                when_BankedScratchMemory_l286_32;
  wire                when_BankedScratchMemory_l286_33;
  wire                when_BankedScratchMemory_l286_34;
  wire                when_BankedScratchMemory_l286_35;
  wire                when_BankedScratchMemory_l286_36;
  wire                when_BankedScratchMemory_l286_37;
  wire                when_BankedScratchMemory_l286_38;
  wire                when_BankedScratchMemory_l286_39;
  reg        [31:0]   _zz_io_valuReadData_0_4;
  wire                when_BankedScratchMemory_l308_32;
  wire                when_BankedScratchMemory_l308_33;
  wire                when_BankedScratchMemory_l308_34;
  wire                when_BankedScratchMemory_l308_35;
  wire                when_BankedScratchMemory_l308_36;
  wire                when_BankedScratchMemory_l308_37;
  wire                when_BankedScratchMemory_l308_38;
  wire                when_BankedScratchMemory_l308_39;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_5;
  wire       [7:0]    _zz_io_aAddr_5;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_5;
  wire                when_BankedScratchMemory_l286_40;
  wire                when_BankedScratchMemory_l286_41;
  wire                when_BankedScratchMemory_l286_42;
  wire                when_BankedScratchMemory_l286_43;
  wire                when_BankedScratchMemory_l286_44;
  wire                when_BankedScratchMemory_l286_45;
  wire                when_BankedScratchMemory_l286_46;
  wire                when_BankedScratchMemory_l286_47;
  reg        [31:0]   _zz_io_valuReadData_0_5;
  wire                when_BankedScratchMemory_l308_40;
  wire                when_BankedScratchMemory_l308_41;
  wire                when_BankedScratchMemory_l308_42;
  wire                when_BankedScratchMemory_l308_43;
  wire                when_BankedScratchMemory_l308_44;
  wire                when_BankedScratchMemory_l308_45;
  wire                when_BankedScratchMemory_l308_46;
  wire                when_BankedScratchMemory_l308_47;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_6;
  wire       [7:0]    _zz_io_aAddr_6;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_6;
  wire                when_BankedScratchMemory_l286_48;
  wire                when_BankedScratchMemory_l286_49;
  wire                when_BankedScratchMemory_l286_50;
  wire                when_BankedScratchMemory_l286_51;
  wire                when_BankedScratchMemory_l286_52;
  wire                when_BankedScratchMemory_l286_53;
  wire                when_BankedScratchMemory_l286_54;
  wire                when_BankedScratchMemory_l286_55;
  reg        [31:0]   _zz_io_valuReadData_0_6;
  wire                when_BankedScratchMemory_l308_48;
  wire                when_BankedScratchMemory_l308_49;
  wire                when_BankedScratchMemory_l308_50;
  wire                when_BankedScratchMemory_l308_51;
  wire                when_BankedScratchMemory_l308_52;
  wire                when_BankedScratchMemory_l308_53;
  wire                when_BankedScratchMemory_l308_54;
  wire                when_BankedScratchMemory_l308_55;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_7;
  wire       [7:0]    _zz_io_aAddr_7;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_7;
  wire                when_BankedScratchMemory_l286_56;
  wire                when_BankedScratchMemory_l286_57;
  wire                when_BankedScratchMemory_l286_58;
  wire                when_BankedScratchMemory_l286_59;
  wire                when_BankedScratchMemory_l286_60;
  wire                when_BankedScratchMemory_l286_61;
  wire                when_BankedScratchMemory_l286_62;
  wire                when_BankedScratchMemory_l286_63;
  reg        [31:0]   _zz_io_valuReadData_0_7;
  wire                when_BankedScratchMemory_l308_56;
  wire                when_BankedScratchMemory_l308_57;
  wire                when_BankedScratchMemory_l308_58;
  wire                when_BankedScratchMemory_l308_59;
  wire                when_BankedScratchMemory_l308_60;
  wire                when_BankedScratchMemory_l308_61;
  wire                when_BankedScratchMemory_l308_62;
  wire                when_BankedScratchMemory_l308_63;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_8;
  wire       [7:0]    _zz_io_bAddr_28;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_8;
  wire                when_BankedScratchMemory_l286_64;
  wire                when_BankedScratchMemory_l295;
  wire                when_BankedScratchMemory_l286_65;
  wire                when_BankedScratchMemory_l295_1;
  wire                when_BankedScratchMemory_l286_66;
  wire                when_BankedScratchMemory_l295_2;
  wire                when_BankedScratchMemory_l286_67;
  wire                when_BankedScratchMemory_l295_3;
  wire                when_BankedScratchMemory_l286_68;
  wire                when_BankedScratchMemory_l295_4;
  wire                when_BankedScratchMemory_l286_69;
  wire                when_BankedScratchMemory_l295_5;
  wire                when_BankedScratchMemory_l286_70;
  wire                when_BankedScratchMemory_l295_6;
  wire                when_BankedScratchMemory_l286_71;
  wire                when_BankedScratchMemory_l295_7;
  reg        [31:0]   _zz_io_valuReadData_1_0;
  wire                when_BankedScratchMemory_l308_64;
  wire                when_BankedScratchMemory_l308_65;
  wire                when_BankedScratchMemory_l308_66;
  wire                when_BankedScratchMemory_l308_67;
  wire                when_BankedScratchMemory_l308_68;
  wire                when_BankedScratchMemory_l308_69;
  wire                when_BankedScratchMemory_l308_70;
  wire                when_BankedScratchMemory_l308_71;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_9;
  wire       [7:0]    _zz_io_bAddr_29;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_9;
  wire                when_BankedScratchMemory_l286_72;
  wire                when_BankedScratchMemory_l295_8;
  wire                when_BankedScratchMemory_l286_73;
  wire                when_BankedScratchMemory_l295_9;
  wire                when_BankedScratchMemory_l286_74;
  wire                when_BankedScratchMemory_l295_10;
  wire                when_BankedScratchMemory_l286_75;
  wire                when_BankedScratchMemory_l295_11;
  wire                when_BankedScratchMemory_l286_76;
  wire                when_BankedScratchMemory_l295_12;
  wire                when_BankedScratchMemory_l286_77;
  wire                when_BankedScratchMemory_l295_13;
  wire                when_BankedScratchMemory_l286_78;
  wire                when_BankedScratchMemory_l295_14;
  wire                when_BankedScratchMemory_l286_79;
  wire                when_BankedScratchMemory_l295_15;
  reg        [31:0]   _zz_io_valuReadData_1_1;
  wire                when_BankedScratchMemory_l308_72;
  wire                when_BankedScratchMemory_l308_73;
  wire                when_BankedScratchMemory_l308_74;
  wire                when_BankedScratchMemory_l308_75;
  wire                when_BankedScratchMemory_l308_76;
  wire                when_BankedScratchMemory_l308_77;
  wire                when_BankedScratchMemory_l308_78;
  wire                when_BankedScratchMemory_l308_79;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_10;
  wire       [7:0]    _zz_io_bAddr_30;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_10;
  wire                when_BankedScratchMemory_l286_80;
  wire                when_BankedScratchMemory_l295_16;
  wire                when_BankedScratchMemory_l286_81;
  wire                when_BankedScratchMemory_l295_17;
  wire                when_BankedScratchMemory_l286_82;
  wire                when_BankedScratchMemory_l295_18;
  wire                when_BankedScratchMemory_l286_83;
  wire                when_BankedScratchMemory_l295_19;
  wire                when_BankedScratchMemory_l286_84;
  wire                when_BankedScratchMemory_l295_20;
  wire                when_BankedScratchMemory_l286_85;
  wire                when_BankedScratchMemory_l295_21;
  wire                when_BankedScratchMemory_l286_86;
  wire                when_BankedScratchMemory_l295_22;
  wire                when_BankedScratchMemory_l286_87;
  wire                when_BankedScratchMemory_l295_23;
  reg        [31:0]   _zz_io_valuReadData_1_2;
  wire                when_BankedScratchMemory_l308_80;
  wire                when_BankedScratchMemory_l308_81;
  wire                when_BankedScratchMemory_l308_82;
  wire                when_BankedScratchMemory_l308_83;
  wire                when_BankedScratchMemory_l308_84;
  wire                when_BankedScratchMemory_l308_85;
  wire                when_BankedScratchMemory_l308_86;
  wire                when_BankedScratchMemory_l308_87;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_11;
  wire       [7:0]    _zz_io_bAddr_31;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_11;
  wire                when_BankedScratchMemory_l286_88;
  wire                when_BankedScratchMemory_l295_24;
  wire                when_BankedScratchMemory_l286_89;
  wire                when_BankedScratchMemory_l295_25;
  wire                when_BankedScratchMemory_l286_90;
  wire                when_BankedScratchMemory_l295_26;
  wire                when_BankedScratchMemory_l286_91;
  wire                when_BankedScratchMemory_l295_27;
  wire                when_BankedScratchMemory_l286_92;
  wire                when_BankedScratchMemory_l295_28;
  wire                when_BankedScratchMemory_l286_93;
  wire                when_BankedScratchMemory_l295_29;
  wire                when_BankedScratchMemory_l286_94;
  wire                when_BankedScratchMemory_l295_30;
  wire                when_BankedScratchMemory_l286_95;
  wire                when_BankedScratchMemory_l295_31;
  reg        [31:0]   _zz_io_valuReadData_1_3;
  wire                when_BankedScratchMemory_l308_88;
  wire                when_BankedScratchMemory_l308_89;
  wire                when_BankedScratchMemory_l308_90;
  wire                when_BankedScratchMemory_l308_91;
  wire                when_BankedScratchMemory_l308_92;
  wire                when_BankedScratchMemory_l308_93;
  wire                when_BankedScratchMemory_l308_94;
  wire                when_BankedScratchMemory_l308_95;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_12;
  wire       [7:0]    _zz_io_bAddr_32;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_12;
  wire                when_BankedScratchMemory_l286_96;
  wire                when_BankedScratchMemory_l295_32;
  wire                when_BankedScratchMemory_l286_97;
  wire                when_BankedScratchMemory_l295_33;
  wire                when_BankedScratchMemory_l286_98;
  wire                when_BankedScratchMemory_l295_34;
  wire                when_BankedScratchMemory_l286_99;
  wire                when_BankedScratchMemory_l295_35;
  wire                when_BankedScratchMemory_l286_100;
  wire                when_BankedScratchMemory_l295_36;
  wire                when_BankedScratchMemory_l286_101;
  wire                when_BankedScratchMemory_l295_37;
  wire                when_BankedScratchMemory_l286_102;
  wire                when_BankedScratchMemory_l295_38;
  wire                when_BankedScratchMemory_l286_103;
  wire                when_BankedScratchMemory_l295_39;
  reg        [31:0]   _zz_io_valuReadData_1_4;
  wire                when_BankedScratchMemory_l308_96;
  wire                when_BankedScratchMemory_l308_97;
  wire                when_BankedScratchMemory_l308_98;
  wire                when_BankedScratchMemory_l308_99;
  wire                when_BankedScratchMemory_l308_100;
  wire                when_BankedScratchMemory_l308_101;
  wire                when_BankedScratchMemory_l308_102;
  wire                when_BankedScratchMemory_l308_103;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_13;
  wire       [7:0]    _zz_io_bAddr_33;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_13;
  wire                when_BankedScratchMemory_l286_104;
  wire                when_BankedScratchMemory_l295_40;
  wire                when_BankedScratchMemory_l286_105;
  wire                when_BankedScratchMemory_l295_41;
  wire                when_BankedScratchMemory_l286_106;
  wire                when_BankedScratchMemory_l295_42;
  wire                when_BankedScratchMemory_l286_107;
  wire                when_BankedScratchMemory_l295_43;
  wire                when_BankedScratchMemory_l286_108;
  wire                when_BankedScratchMemory_l295_44;
  wire                when_BankedScratchMemory_l286_109;
  wire                when_BankedScratchMemory_l295_45;
  wire                when_BankedScratchMemory_l286_110;
  wire                when_BankedScratchMemory_l295_46;
  wire                when_BankedScratchMemory_l286_111;
  wire                when_BankedScratchMemory_l295_47;
  reg        [31:0]   _zz_io_valuReadData_1_5;
  wire                when_BankedScratchMemory_l308_104;
  wire                when_BankedScratchMemory_l308_105;
  wire                when_BankedScratchMemory_l308_106;
  wire                when_BankedScratchMemory_l308_107;
  wire                when_BankedScratchMemory_l308_108;
  wire                when_BankedScratchMemory_l308_109;
  wire                when_BankedScratchMemory_l308_110;
  wire                when_BankedScratchMemory_l308_111;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_14;
  wire       [7:0]    _zz_io_bAddr_34;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_14;
  wire                when_BankedScratchMemory_l286_112;
  wire                when_BankedScratchMemory_l295_48;
  wire                when_BankedScratchMemory_l286_113;
  wire                when_BankedScratchMemory_l295_49;
  wire                when_BankedScratchMemory_l286_114;
  wire                when_BankedScratchMemory_l295_50;
  wire                when_BankedScratchMemory_l286_115;
  wire                when_BankedScratchMemory_l295_51;
  wire                when_BankedScratchMemory_l286_116;
  wire                when_BankedScratchMemory_l295_52;
  wire                when_BankedScratchMemory_l286_117;
  wire                when_BankedScratchMemory_l295_53;
  wire                when_BankedScratchMemory_l286_118;
  wire                when_BankedScratchMemory_l295_54;
  wire                when_BankedScratchMemory_l286_119;
  wire                when_BankedScratchMemory_l295_55;
  reg        [31:0]   _zz_io_valuReadData_1_6;
  wire                when_BankedScratchMemory_l308_112;
  wire                when_BankedScratchMemory_l308_113;
  wire                when_BankedScratchMemory_l308_114;
  wire                when_BankedScratchMemory_l308_115;
  wire                when_BankedScratchMemory_l308_116;
  wire                when_BankedScratchMemory_l308_117;
  wire                when_BankedScratchMemory_l308_118;
  wire                when_BankedScratchMemory_l308_119;
  wire       [2:0]    _zz_when_BankedScratchMemory_l286_15;
  wire       [7:0]    _zz_io_bAddr_35;
  reg        [2:0]    _zz_when_BankedScratchMemory_l308_15;
  wire                when_BankedScratchMemory_l286_120;
  wire                when_BankedScratchMemory_l295_56;
  wire                when_BankedScratchMemory_l286_121;
  wire                when_BankedScratchMemory_l295_57;
  wire                when_BankedScratchMemory_l286_122;
  wire                when_BankedScratchMemory_l295_58;
  wire                when_BankedScratchMemory_l286_123;
  wire                when_BankedScratchMemory_l295_59;
  wire                when_BankedScratchMemory_l286_124;
  wire                when_BankedScratchMemory_l295_60;
  wire                when_BankedScratchMemory_l286_125;
  wire                when_BankedScratchMemory_l295_61;
  wire                when_BankedScratchMemory_l286_126;
  wire                when_BankedScratchMemory_l295_62;
  wire                when_BankedScratchMemory_l286_127;
  wire                when_BankedScratchMemory_l295_63;
  reg        [31:0]   _zz_io_valuReadData_1_7;
  wire                when_BankedScratchMemory_l308_120;
  wire                when_BankedScratchMemory_l308_121;
  wire                when_BankedScratchMemory_l308_122;
  wire                when_BankedScratchMemory_l308_123;
  wire                when_BankedScratchMemory_l308_124;
  wire                when_BankedScratchMemory_l308_125;
  wire                when_BankedScratchMemory_l308_126;
  wire                when_BankedScratchMemory_l308_127;
  reg                 fwdGap2Valid_0;
  reg                 fwdGap2Valid_1;
  reg                 fwdGap2Valid_2;
  reg                 fwdGap2Valid_3;
  reg                 fwdGap2Valid_4;
  reg                 fwdGap2Valid_5;
  reg                 fwdGap2Valid_6;
  reg                 fwdGap2Valid_7;
  reg                 fwdGap2Valid_8;
  reg        [31:0]   fwdGap2Data_0;
  reg        [31:0]   fwdGap2Data_1;
  reg        [31:0]   fwdGap2Data_2;
  reg        [31:0]   fwdGap2Data_3;
  reg        [31:0]   fwdGap2Data_4;
  reg        [31:0]   fwdGap2Data_5;
  reg        [31:0]   fwdGap2Data_6;
  reg        [31:0]   fwdGap2Data_7;
  reg        [31:0]   fwdGap2Data_8;
  reg        [31:0]   _zz_fwdGap2Data_0;
  wire                when_BankedScratchMemory_l360;
  wire                when_BankedScratchMemory_l360_1;
  wire                when_BankedScratchMemory_l360_2;
  wire                when_BankedScratchMemory_l360_3;
  wire                when_BankedScratchMemory_l360_4;
  wire                when_BankedScratchMemory_l360_5;
  wire                when_BankedScratchMemory_l360_6;
  wire                when_BankedScratchMemory_l360_7;
  wire                when_BankedScratchMemory_l360_8;
  wire                when_BankedScratchMemory_l360_9;
  wire                when_BankedScratchMemory_l360_10;
  wire                when_BankedScratchMemory_l360_11;
  wire                when_BankedScratchMemory_l360_12;
  wire                when_BankedScratchMemory_l360_13;
  wire                when_BankedScratchMemory_l360_14;
  wire                when_BankedScratchMemory_l360_15;
  wire                when_BankedScratchMemory_l360_16;
  wire                when_BankedScratchMemory_l360_17;
  wire                when_BankedScratchMemory_l360_18;
  wire                when_BankedScratchMemory_l360_19;
  wire                when_BankedScratchMemory_l360_20;
  wire                when_BankedScratchMemory_l360_21;
  wire                when_BankedScratchMemory_l360_22;
  wire                when_BankedScratchMemory_l360_23;
  wire                when_BankedScratchMemory_l360_24;
  wire                when_BankedScratchMemory_l360_25;
  wire                when_BankedScratchMemory_l360_26;
  wire                when_BankedScratchMemory_l360_27;
  reg        [31:0]   _zz_fwdGap2Data_1;
  wire                when_BankedScratchMemory_l360_28;
  wire                when_BankedScratchMemory_l360_29;
  wire                when_BankedScratchMemory_l360_30;
  wire                when_BankedScratchMemory_l360_31;
  wire                when_BankedScratchMemory_l360_32;
  wire                when_BankedScratchMemory_l360_33;
  wire                when_BankedScratchMemory_l360_34;
  wire                when_BankedScratchMemory_l360_35;
  wire                when_BankedScratchMemory_l360_36;
  wire                when_BankedScratchMemory_l360_37;
  wire                when_BankedScratchMemory_l360_38;
  wire                when_BankedScratchMemory_l360_39;
  wire                when_BankedScratchMemory_l360_40;
  wire                when_BankedScratchMemory_l360_41;
  wire                when_BankedScratchMemory_l360_42;
  wire                when_BankedScratchMemory_l360_43;
  wire                when_BankedScratchMemory_l360_44;
  wire                when_BankedScratchMemory_l360_45;
  wire                when_BankedScratchMemory_l360_46;
  wire                when_BankedScratchMemory_l360_47;
  wire                when_BankedScratchMemory_l360_48;
  wire                when_BankedScratchMemory_l360_49;
  wire                when_BankedScratchMemory_l360_50;
  wire                when_BankedScratchMemory_l360_51;
  wire                when_BankedScratchMemory_l360_52;
  wire                when_BankedScratchMemory_l360_53;
  wire                when_BankedScratchMemory_l360_54;
  wire                when_BankedScratchMemory_l360_55;
  reg        [31:0]   _zz_fwdGap2Data_2;
  wire                when_BankedScratchMemory_l360_56;
  wire                when_BankedScratchMemory_l360_57;
  wire                when_BankedScratchMemory_l360_58;
  wire                when_BankedScratchMemory_l360_59;
  wire                when_BankedScratchMemory_l360_60;
  wire                when_BankedScratchMemory_l360_61;
  wire                when_BankedScratchMemory_l360_62;
  wire                when_BankedScratchMemory_l360_63;
  wire                when_BankedScratchMemory_l360_64;
  wire                when_BankedScratchMemory_l360_65;
  wire                when_BankedScratchMemory_l360_66;
  wire                when_BankedScratchMemory_l360_67;
  wire                when_BankedScratchMemory_l360_68;
  wire                when_BankedScratchMemory_l360_69;
  wire                when_BankedScratchMemory_l360_70;
  wire                when_BankedScratchMemory_l360_71;
  wire                when_BankedScratchMemory_l360_72;
  wire                when_BankedScratchMemory_l360_73;
  wire                when_BankedScratchMemory_l360_74;
  wire                when_BankedScratchMemory_l360_75;
  wire                when_BankedScratchMemory_l360_76;
  wire                when_BankedScratchMemory_l360_77;
  wire                when_BankedScratchMemory_l360_78;
  wire                when_BankedScratchMemory_l360_79;
  wire                when_BankedScratchMemory_l360_80;
  wire                when_BankedScratchMemory_l360_81;
  wire                when_BankedScratchMemory_l360_82;
  wire                when_BankedScratchMemory_l360_83;
  reg        [31:0]   _zz_fwdGap2Data_3;
  wire                when_BankedScratchMemory_l360_84;
  wire                when_BankedScratchMemory_l360_85;
  wire                when_BankedScratchMemory_l360_86;
  wire                when_BankedScratchMemory_l360_87;
  wire                when_BankedScratchMemory_l360_88;
  wire                when_BankedScratchMemory_l360_89;
  wire                when_BankedScratchMemory_l360_90;
  wire                when_BankedScratchMemory_l360_91;
  wire                when_BankedScratchMemory_l360_92;
  wire                when_BankedScratchMemory_l360_93;
  wire                when_BankedScratchMemory_l360_94;
  wire                when_BankedScratchMemory_l360_95;
  wire                when_BankedScratchMemory_l360_96;
  wire                when_BankedScratchMemory_l360_97;
  wire                when_BankedScratchMemory_l360_98;
  wire                when_BankedScratchMemory_l360_99;
  wire                when_BankedScratchMemory_l360_100;
  wire                when_BankedScratchMemory_l360_101;
  wire                when_BankedScratchMemory_l360_102;
  wire                when_BankedScratchMemory_l360_103;
  wire                when_BankedScratchMemory_l360_104;
  wire                when_BankedScratchMemory_l360_105;
  wire                when_BankedScratchMemory_l360_106;
  wire                when_BankedScratchMemory_l360_107;
  wire                when_BankedScratchMemory_l360_108;
  wire                when_BankedScratchMemory_l360_109;
  wire                when_BankedScratchMemory_l360_110;
  wire                when_BankedScratchMemory_l360_111;
  reg        [31:0]   _zz_fwdGap2Data_4;
  wire                when_BankedScratchMemory_l360_112;
  wire                when_BankedScratchMemory_l360_113;
  wire                when_BankedScratchMemory_l360_114;
  wire                when_BankedScratchMemory_l360_115;
  wire                when_BankedScratchMemory_l360_116;
  wire                when_BankedScratchMemory_l360_117;
  wire                when_BankedScratchMemory_l360_118;
  wire                when_BankedScratchMemory_l360_119;
  wire                when_BankedScratchMemory_l360_120;
  wire                when_BankedScratchMemory_l360_121;
  wire                when_BankedScratchMemory_l360_122;
  wire                when_BankedScratchMemory_l360_123;
  wire                when_BankedScratchMemory_l360_124;
  wire                when_BankedScratchMemory_l360_125;
  wire                when_BankedScratchMemory_l360_126;
  wire                when_BankedScratchMemory_l360_127;
  wire                when_BankedScratchMemory_l360_128;
  wire                when_BankedScratchMemory_l360_129;
  wire                when_BankedScratchMemory_l360_130;
  wire                when_BankedScratchMemory_l360_131;
  wire                when_BankedScratchMemory_l360_132;
  wire                when_BankedScratchMemory_l360_133;
  wire                when_BankedScratchMemory_l360_134;
  wire                when_BankedScratchMemory_l360_135;
  wire                when_BankedScratchMemory_l360_136;
  wire                when_BankedScratchMemory_l360_137;
  wire                when_BankedScratchMemory_l360_138;
  wire                when_BankedScratchMemory_l360_139;
  reg        [31:0]   _zz_fwdGap2Data_5;
  wire                when_BankedScratchMemory_l360_140;
  wire                when_BankedScratchMemory_l360_141;
  wire                when_BankedScratchMemory_l360_142;
  wire                when_BankedScratchMemory_l360_143;
  wire                when_BankedScratchMemory_l360_144;
  wire                when_BankedScratchMemory_l360_145;
  wire                when_BankedScratchMemory_l360_146;
  wire                when_BankedScratchMemory_l360_147;
  wire                when_BankedScratchMemory_l360_148;
  wire                when_BankedScratchMemory_l360_149;
  wire                when_BankedScratchMemory_l360_150;
  wire                when_BankedScratchMemory_l360_151;
  wire                when_BankedScratchMemory_l360_152;
  wire                when_BankedScratchMemory_l360_153;
  wire                when_BankedScratchMemory_l360_154;
  wire                when_BankedScratchMemory_l360_155;
  wire                when_BankedScratchMemory_l360_156;
  wire                when_BankedScratchMemory_l360_157;
  wire                when_BankedScratchMemory_l360_158;
  wire                when_BankedScratchMemory_l360_159;
  wire                when_BankedScratchMemory_l360_160;
  wire                when_BankedScratchMemory_l360_161;
  wire                when_BankedScratchMemory_l360_162;
  wire                when_BankedScratchMemory_l360_163;
  wire                when_BankedScratchMemory_l360_164;
  wire                when_BankedScratchMemory_l360_165;
  wire                when_BankedScratchMemory_l360_166;
  wire                when_BankedScratchMemory_l360_167;
  reg        [31:0]   _zz_fwdGap2Data_6;
  wire                when_BankedScratchMemory_l360_168;
  wire                when_BankedScratchMemory_l360_169;
  wire                when_BankedScratchMemory_l360_170;
  wire                when_BankedScratchMemory_l360_171;
  wire                when_BankedScratchMemory_l360_172;
  wire                when_BankedScratchMemory_l360_173;
  wire                when_BankedScratchMemory_l360_174;
  wire                when_BankedScratchMemory_l360_175;
  wire                when_BankedScratchMemory_l360_176;
  wire                when_BankedScratchMemory_l360_177;
  wire                when_BankedScratchMemory_l360_178;
  wire                when_BankedScratchMemory_l360_179;
  wire                when_BankedScratchMemory_l360_180;
  wire                when_BankedScratchMemory_l360_181;
  wire                when_BankedScratchMemory_l360_182;
  wire                when_BankedScratchMemory_l360_183;
  wire                when_BankedScratchMemory_l360_184;
  wire                when_BankedScratchMemory_l360_185;
  wire                when_BankedScratchMemory_l360_186;
  wire                when_BankedScratchMemory_l360_187;
  wire                when_BankedScratchMemory_l360_188;
  wire                when_BankedScratchMemory_l360_189;
  wire                when_BankedScratchMemory_l360_190;
  wire                when_BankedScratchMemory_l360_191;
  wire                when_BankedScratchMemory_l360_192;
  wire                when_BankedScratchMemory_l360_193;
  wire                when_BankedScratchMemory_l360_194;
  wire                when_BankedScratchMemory_l360_195;
  reg        [31:0]   _zz_fwdGap2Data_7;
  wire                when_BankedScratchMemory_l360_196;
  wire                when_BankedScratchMemory_l360_197;
  wire                when_BankedScratchMemory_l360_198;
  wire                when_BankedScratchMemory_l360_199;
  wire                when_BankedScratchMemory_l360_200;
  wire                when_BankedScratchMemory_l360_201;
  wire                when_BankedScratchMemory_l360_202;
  wire                when_BankedScratchMemory_l360_203;
  wire                when_BankedScratchMemory_l360_204;
  wire                when_BankedScratchMemory_l360_205;
  wire                when_BankedScratchMemory_l360_206;
  wire                when_BankedScratchMemory_l360_207;
  wire                when_BankedScratchMemory_l360_208;
  wire                when_BankedScratchMemory_l360_209;
  wire                when_BankedScratchMemory_l360_210;
  wire                when_BankedScratchMemory_l360_211;
  wire                when_BankedScratchMemory_l360_212;
  wire                when_BankedScratchMemory_l360_213;
  wire                when_BankedScratchMemory_l360_214;
  wire                when_BankedScratchMemory_l360_215;
  wire                when_BankedScratchMemory_l360_216;
  wire                when_BankedScratchMemory_l360_217;
  wire                when_BankedScratchMemory_l360_218;
  wire                when_BankedScratchMemory_l360_219;
  wire                when_BankedScratchMemory_l360_220;
  wire                when_BankedScratchMemory_l360_221;
  wire                when_BankedScratchMemory_l360_222;
  wire                when_BankedScratchMemory_l360_223;
  reg        [31:0]   _zz_fwdGap2Data_8;
  wire                when_BankedScratchMemory_l360_224;
  wire                when_BankedScratchMemory_l360_225;
  wire                when_BankedScratchMemory_l360_226;
  wire                when_BankedScratchMemory_l360_227;
  wire                when_BankedScratchMemory_l360_228;
  wire                when_BankedScratchMemory_l360_229;
  wire                when_BankedScratchMemory_l360_230;
  wire                when_BankedScratchMemory_l360_231;
  wire                when_BankedScratchMemory_l360_232;
  wire                when_BankedScratchMemory_l360_233;
  wire                when_BankedScratchMemory_l360_234;
  wire                when_BankedScratchMemory_l360_235;
  wire                when_BankedScratchMemory_l360_236;
  wire                when_BankedScratchMemory_l360_237;
  wire                when_BankedScratchMemory_l360_238;
  wire                when_BankedScratchMemory_l360_239;
  wire                when_BankedScratchMemory_l360_240;
  wire                when_BankedScratchMemory_l360_241;
  wire                when_BankedScratchMemory_l360_242;
  wire                when_BankedScratchMemory_l360_243;
  wire                when_BankedScratchMemory_l360_244;
  wire                when_BankedScratchMemory_l360_245;
  wire                when_BankedScratchMemory_l360_246;
  wire                when_BankedScratchMemory_l360_247;
  wire                when_BankedScratchMemory_l360_248;
  wire                when_BankedScratchMemory_l360_249;
  wire                when_BankedScratchMemory_l360_250;
  wire                when_BankedScratchMemory_l360_251;
  reg                 prevScalarReadEn_0;
  reg                 prevScalarReadEn_1;
  reg                 prevScalarReadEn_2;
  reg                 prevScalarReadEn_3;
  reg                 prevScalarReadEn_4;
  reg                 prevScalarReadEn_5;
  reg                 prevScalarReadEn_6;
  reg                 prevScalarReadEn_7;
  reg                 prevScalarReadEn_8;
  reg        [10:0]   prevScalarReadAddr_0;
  reg        [10:0]   prevScalarReadAddr_1;
  reg        [10:0]   prevScalarReadAddr_2;
  reg        [10:0]   prevScalarReadAddr_3;
  reg        [10:0]   prevScalarReadAddr_4;
  reg        [10:0]   prevScalarReadAddr_5;
  reg        [10:0]   prevScalarReadAddr_6;
  reg        [10:0]   prevScalarReadAddr_7;
  reg        [10:0]   prevScalarReadAddr_8;
  wire                when_BankedScratchMemory_l390;
  wire                when_BankedScratchMemory_l390_1;
  wire                when_BankedScratchMemory_l390_2;
  wire                when_BankedScratchMemory_l390_3;
  wire                when_BankedScratchMemory_l390_4;
  wire                when_BankedScratchMemory_l390_5;
  wire                when_BankedScratchMemory_l390_6;
  wire                when_BankedScratchMemory_l390_7;
  wire                when_BankedScratchMemory_l390_8;
  wire                when_BankedScratchMemory_l390_9;
  wire                when_BankedScratchMemory_l390_10;
  wire                when_BankedScratchMemory_l390_11;
  wire                when_BankedScratchMemory_l390_12;
  wire                when_BankedScratchMemory_l390_13;
  wire                when_BankedScratchMemory_l390_14;
  wire                when_BankedScratchMemory_l390_15;
  wire                when_BankedScratchMemory_l390_16;
  wire                when_BankedScratchMemory_l390_17;
  wire                when_BankedScratchMemory_l390_18;
  wire                when_BankedScratchMemory_l390_19;
  wire                when_BankedScratchMemory_l390_20;
  wire                when_BankedScratchMemory_l390_21;
  wire                when_BankedScratchMemory_l390_22;
  wire                when_BankedScratchMemory_l390_23;
  wire                when_BankedScratchMemory_l390_24;
  wire                when_BankedScratchMemory_l390_25;
  wire                when_BankedScratchMemory_l390_26;
  wire                when_BankedScratchMemory_l390_27;
  wire                when_BankedScratchMemory_l390_28;
  wire                when_BankedScratchMemory_l390_29;
  wire                when_BankedScratchMemory_l390_30;
  wire                when_BankedScratchMemory_l390_31;
  wire                when_BankedScratchMemory_l390_32;
  wire                when_BankedScratchMemory_l390_33;
  wire                when_BankedScratchMemory_l390_34;
  wire                when_BankedScratchMemory_l390_35;
  wire                when_BankedScratchMemory_l390_36;
  wire                when_BankedScratchMemory_l390_37;
  wire                when_BankedScratchMemory_l390_38;
  wire                when_BankedScratchMemory_l390_39;
  wire                when_BankedScratchMemory_l390_40;
  wire                when_BankedScratchMemory_l390_41;
  wire                when_BankedScratchMemory_l390_42;
  wire                when_BankedScratchMemory_l390_43;
  wire                when_BankedScratchMemory_l390_44;
  wire                when_BankedScratchMemory_l390_45;
  wire                when_BankedScratchMemory_l390_46;
  wire                when_BankedScratchMemory_l390_47;
  wire                when_BankedScratchMemory_l390_48;
  wire                when_BankedScratchMemory_l390_49;
  wire                when_BankedScratchMemory_l390_50;
  wire                when_BankedScratchMemory_l390_51;
  wire                when_BankedScratchMemory_l390_52;
  wire                when_BankedScratchMemory_l390_53;
  wire                when_BankedScratchMemory_l390_54;
  wire                when_BankedScratchMemory_l390_55;
  wire                when_BankedScratchMemory_l390_56;
  wire                when_BankedScratchMemory_l390_57;
  wire                when_BankedScratchMemory_l390_58;
  wire                when_BankedScratchMemory_l390_59;
  wire                when_BankedScratchMemory_l390_60;
  wire                when_BankedScratchMemory_l390_61;
  wire                when_BankedScratchMemory_l390_62;
  wire                when_BankedScratchMemory_l390_63;
  wire                when_BankedScratchMemory_l390_64;
  wire                when_BankedScratchMemory_l390_65;
  wire                when_BankedScratchMemory_l390_66;
  wire                when_BankedScratchMemory_l390_67;
  wire                when_BankedScratchMemory_l390_68;
  wire                when_BankedScratchMemory_l390_69;
  wire                when_BankedScratchMemory_l390_70;
  wire                when_BankedScratchMemory_l390_71;
  wire                when_BankedScratchMemory_l390_72;
  wire                when_BankedScratchMemory_l390_73;
  wire                when_BankedScratchMemory_l390_74;
  wire                when_BankedScratchMemory_l390_75;
  wire                when_BankedScratchMemory_l390_76;
  wire                when_BankedScratchMemory_l390_77;
  wire                when_BankedScratchMemory_l390_78;
  wire                when_BankedScratchMemory_l390_79;
  wire                when_BankedScratchMemory_l390_80;
  wire                when_BankedScratchMemory_l390_81;
  wire                when_BankedScratchMemory_l390_82;
  wire                when_BankedScratchMemory_l390_83;
  wire                when_BankedScratchMemory_l390_84;
  wire                when_BankedScratchMemory_l390_85;
  wire                when_BankedScratchMemory_l390_86;
  wire                when_BankedScratchMemory_l390_87;
  wire                when_BankedScratchMemory_l390_88;
  wire                when_BankedScratchMemory_l390_89;
  wire                when_BankedScratchMemory_l390_90;
  wire                when_BankedScratchMemory_l390_91;
  wire                when_BankedScratchMemory_l390_92;
  wire                when_BankedScratchMemory_l390_93;
  wire                when_BankedScratchMemory_l390_94;
  wire                when_BankedScratchMemory_l390_95;
  wire                when_BankedScratchMemory_l390_96;
  wire                when_BankedScratchMemory_l390_97;
  wire                when_BankedScratchMemory_l390_98;
  wire                when_BankedScratchMemory_l390_99;
  wire                when_BankedScratchMemory_l390_100;
  wire                when_BankedScratchMemory_l390_101;
  wire                when_BankedScratchMemory_l390_102;
  wire                when_BankedScratchMemory_l390_103;
  wire                when_BankedScratchMemory_l390_104;
  wire                when_BankedScratchMemory_l390_105;
  wire                when_BankedScratchMemory_l390_106;
  wire                when_BankedScratchMemory_l390_107;
  wire                when_BankedScratchMemory_l390_108;
  wire                when_BankedScratchMemory_l390_109;
  wire                when_BankedScratchMemory_l390_110;
  wire                when_BankedScratchMemory_l390_111;
  wire                when_BankedScratchMemory_l390_112;
  wire                when_BankedScratchMemory_l390_113;
  wire                when_BankedScratchMemory_l390_114;
  wire                when_BankedScratchMemory_l390_115;
  wire                when_BankedScratchMemory_l390_116;
  wire                when_BankedScratchMemory_l390_117;
  wire                when_BankedScratchMemory_l390_118;
  wire                when_BankedScratchMemory_l390_119;
  wire                when_BankedScratchMemory_l390_120;
  wire                when_BankedScratchMemory_l390_121;
  wire                when_BankedScratchMemory_l390_122;
  wire                when_BankedScratchMemory_l390_123;
  wire                when_BankedScratchMemory_l390_124;
  wire                when_BankedScratchMemory_l390_125;
  wire                when_BankedScratchMemory_l390_126;
  wire                when_BankedScratchMemory_l390_127;
  wire                when_BankedScratchMemory_l390_128;
  wire                when_BankedScratchMemory_l390_129;
  wire                when_BankedScratchMemory_l390_130;
  wire                when_BankedScratchMemory_l390_131;
  wire                when_BankedScratchMemory_l390_132;
  wire                when_BankedScratchMemory_l390_133;
  wire                when_BankedScratchMemory_l390_134;
  wire                when_BankedScratchMemory_l390_135;
  wire                when_BankedScratchMemory_l390_136;
  wire                when_BankedScratchMemory_l390_137;
  wire                when_BankedScratchMemory_l390_138;
  wire                when_BankedScratchMemory_l390_139;
  wire                when_BankedScratchMemory_l390_140;
  wire                when_BankedScratchMemory_l390_141;
  wire                when_BankedScratchMemory_l390_142;
  wire                when_BankedScratchMemory_l390_143;
  wire                when_BankedScratchMemory_l390_144;
  wire                when_BankedScratchMemory_l390_145;
  wire                when_BankedScratchMemory_l390_146;
  wire                when_BankedScratchMemory_l390_147;
  wire                when_BankedScratchMemory_l390_148;
  wire                when_BankedScratchMemory_l390_149;
  wire                when_BankedScratchMemory_l390_150;
  wire                when_BankedScratchMemory_l390_151;
  wire                when_BankedScratchMemory_l390_152;
  wire                when_BankedScratchMemory_l390_153;
  wire                when_BankedScratchMemory_l390_154;
  wire                when_BankedScratchMemory_l390_155;
  wire                when_BankedScratchMemory_l390_156;
  wire                when_BankedScratchMemory_l390_157;
  wire                when_BankedScratchMemory_l390_158;
  wire                when_BankedScratchMemory_l390_159;
  wire                when_BankedScratchMemory_l390_160;
  wire                when_BankedScratchMemory_l390_161;
  wire                when_BankedScratchMemory_l390_162;
  wire                when_BankedScratchMemory_l390_163;
  wire                when_BankedScratchMemory_l390_164;
  wire                when_BankedScratchMemory_l390_165;
  wire                when_BankedScratchMemory_l390_166;
  wire                when_BankedScratchMemory_l390_167;
  wire                when_BankedScratchMemory_l390_168;
  wire                when_BankedScratchMemory_l390_169;
  wire                when_BankedScratchMemory_l390_170;
  wire                when_BankedScratchMemory_l390_171;
  wire                when_BankedScratchMemory_l390_172;
  wire                when_BankedScratchMemory_l390_173;
  wire                when_BankedScratchMemory_l390_174;
  wire                when_BankedScratchMemory_l390_175;
  wire                when_BankedScratchMemory_l390_176;
  wire                when_BankedScratchMemory_l390_177;
  wire                when_BankedScratchMemory_l390_178;
  wire                when_BankedScratchMemory_l390_179;
  wire                when_BankedScratchMemory_l390_180;
  wire                when_BankedScratchMemory_l390_181;
  wire                when_BankedScratchMemory_l390_182;
  wire                when_BankedScratchMemory_l390_183;
  wire                when_BankedScratchMemory_l390_184;
  wire                when_BankedScratchMemory_l390_185;
  wire                when_BankedScratchMemory_l390_186;
  wire                when_BankedScratchMemory_l390_187;
  wire                when_BankedScratchMemory_l390_188;
  wire                when_BankedScratchMemory_l390_189;
  wire                when_BankedScratchMemory_l390_190;
  wire                when_BankedScratchMemory_l390_191;
  wire                when_BankedScratchMemory_l390_192;
  wire                when_BankedScratchMemory_l390_193;
  wire                when_BankedScratchMemory_l390_194;
  wire                when_BankedScratchMemory_l390_195;
  wire                when_BankedScratchMemory_l390_196;
  wire                when_BankedScratchMemory_l390_197;
  wire                when_BankedScratchMemory_l390_198;
  wire                when_BankedScratchMemory_l390_199;
  wire                when_BankedScratchMemory_l390_200;
  wire                when_BankedScratchMemory_l390_201;
  wire                when_BankedScratchMemory_l390_202;
  wire                when_BankedScratchMemory_l390_203;
  wire                when_BankedScratchMemory_l390_204;
  wire                when_BankedScratchMemory_l390_205;
  wire                when_BankedScratchMemory_l390_206;
  wire                when_BankedScratchMemory_l390_207;
  wire                when_BankedScratchMemory_l390_208;
  wire                when_BankedScratchMemory_l390_209;
  wire                when_BankedScratchMemory_l390_210;
  wire                when_BankedScratchMemory_l390_211;
  wire                when_BankedScratchMemory_l390_212;
  wire                when_BankedScratchMemory_l390_213;
  wire                when_BankedScratchMemory_l390_214;
  wire                when_BankedScratchMemory_l390_215;
  wire                when_BankedScratchMemory_l390_216;
  wire                when_BankedScratchMemory_l390_217;
  wire                when_BankedScratchMemory_l390_218;
  wire                when_BankedScratchMemory_l390_219;
  wire                when_BankedScratchMemory_l390_220;
  wire                when_BankedScratchMemory_l390_221;
  wire                when_BankedScratchMemory_l390_222;
  wire                when_BankedScratchMemory_l390_223;
  wire                when_BankedScratchMemory_l390_224;
  wire                when_BankedScratchMemory_l390_225;
  wire                when_BankedScratchMemory_l390_226;
  wire                when_BankedScratchMemory_l390_227;
  wire                when_BankedScratchMemory_l390_228;
  wire                when_BankedScratchMemory_l390_229;
  wire                when_BankedScratchMemory_l390_230;
  wire                when_BankedScratchMemory_l390_231;
  wire                when_BankedScratchMemory_l390_232;
  wire                when_BankedScratchMemory_l390_233;
  wire                when_BankedScratchMemory_l390_234;
  wire                when_BankedScratchMemory_l390_235;
  wire                when_BankedScratchMemory_l390_236;
  wire                when_BankedScratchMemory_l390_237;
  wire                when_BankedScratchMemory_l390_238;
  wire                when_BankedScratchMemory_l390_239;
  wire                when_BankedScratchMemory_l390_240;
  wire                when_BankedScratchMemory_l390_241;
  wire                when_BankedScratchMemory_l390_242;
  wire                when_BankedScratchMemory_l390_243;
  wire                when_BankedScratchMemory_l390_244;
  wire                when_BankedScratchMemory_l390_245;
  wire                when_BankedScratchMemory_l390_246;
  wire                when_BankedScratchMemory_l390_247;
  wire                when_BankedScratchMemory_l390_248;
  wire                when_BankedScratchMemory_l390_249;
  wire                when_BankedScratchMemory_l390_250;
  wire                when_BankedScratchMemory_l390_251;
  reg                 fwdValuGap2Valid_0_0;
  reg                 fwdValuGap2Valid_0_1;
  reg                 fwdValuGap2Valid_0_2;
  reg                 fwdValuGap2Valid_0_3;
  reg                 fwdValuGap2Valid_0_4;
  reg                 fwdValuGap2Valid_0_5;
  reg                 fwdValuGap2Valid_0_6;
  reg                 fwdValuGap2Valid_0_7;
  reg                 fwdValuGap2Valid_1_0;
  reg                 fwdValuGap2Valid_1_1;
  reg                 fwdValuGap2Valid_1_2;
  reg                 fwdValuGap2Valid_1_3;
  reg                 fwdValuGap2Valid_1_4;
  reg                 fwdValuGap2Valid_1_5;
  reg                 fwdValuGap2Valid_1_6;
  reg                 fwdValuGap2Valid_1_7;
  reg        [31:0]   fwdValuGap2Data_0_0;
  reg        [31:0]   fwdValuGap2Data_0_1;
  reg        [31:0]   fwdValuGap2Data_0_2;
  reg        [31:0]   fwdValuGap2Data_0_3;
  reg        [31:0]   fwdValuGap2Data_0_4;
  reg        [31:0]   fwdValuGap2Data_0_5;
  reg        [31:0]   fwdValuGap2Data_0_6;
  reg        [31:0]   fwdValuGap2Data_0_7;
  reg        [31:0]   fwdValuGap2Data_1_0;
  reg        [31:0]   fwdValuGap2Data_1_1;
  reg        [31:0]   fwdValuGap2Data_1_2;
  reg        [31:0]   fwdValuGap2Data_1_3;
  reg        [31:0]   fwdValuGap2Data_1_4;
  reg        [31:0]   fwdValuGap2Data_1_5;
  reg        [31:0]   fwdValuGap2Data_1_6;
  reg        [31:0]   fwdValuGap2Data_1_7;
  reg        [31:0]   _zz_fwdValuGap2Data_0_0;
  wire                when_BankedScratchMemory_l412;
  wire                when_BankedScratchMemory_l412_1;
  wire                when_BankedScratchMemory_l412_2;
  wire                when_BankedScratchMemory_l412_3;
  wire                when_BankedScratchMemory_l412_4;
  wire                when_BankedScratchMemory_l412_5;
  wire                when_BankedScratchMemory_l412_6;
  wire                when_BankedScratchMemory_l412_7;
  wire                when_BankedScratchMemory_l412_8;
  wire                when_BankedScratchMemory_l412_9;
  wire                when_BankedScratchMemory_l412_10;
  wire                when_BankedScratchMemory_l412_11;
  wire                when_BankedScratchMemory_l412_12;
  wire                when_BankedScratchMemory_l412_13;
  wire                when_BankedScratchMemory_l412_14;
  wire                when_BankedScratchMemory_l412_15;
  wire                when_BankedScratchMemory_l412_16;
  wire                when_BankedScratchMemory_l412_17;
  wire                when_BankedScratchMemory_l412_18;
  wire                when_BankedScratchMemory_l412_19;
  wire                when_BankedScratchMemory_l412_20;
  wire                when_BankedScratchMemory_l412_21;
  wire                when_BankedScratchMemory_l412_22;
  wire                when_BankedScratchMemory_l412_23;
  wire                when_BankedScratchMemory_l412_24;
  wire                when_BankedScratchMemory_l412_25;
  wire                when_BankedScratchMemory_l412_26;
  wire                when_BankedScratchMemory_l412_27;
  reg        [31:0]   _zz_fwdValuGap2Data_0_1;
  wire                when_BankedScratchMemory_l412_28;
  wire                when_BankedScratchMemory_l412_29;
  wire                when_BankedScratchMemory_l412_30;
  wire                when_BankedScratchMemory_l412_31;
  wire                when_BankedScratchMemory_l412_32;
  wire                when_BankedScratchMemory_l412_33;
  wire                when_BankedScratchMemory_l412_34;
  wire                when_BankedScratchMemory_l412_35;
  wire                when_BankedScratchMemory_l412_36;
  wire                when_BankedScratchMemory_l412_37;
  wire                when_BankedScratchMemory_l412_38;
  wire                when_BankedScratchMemory_l412_39;
  wire                when_BankedScratchMemory_l412_40;
  wire                when_BankedScratchMemory_l412_41;
  wire                when_BankedScratchMemory_l412_42;
  wire                when_BankedScratchMemory_l412_43;
  wire                when_BankedScratchMemory_l412_44;
  wire                when_BankedScratchMemory_l412_45;
  wire                when_BankedScratchMemory_l412_46;
  wire                when_BankedScratchMemory_l412_47;
  wire                when_BankedScratchMemory_l412_48;
  wire                when_BankedScratchMemory_l412_49;
  wire                when_BankedScratchMemory_l412_50;
  wire                when_BankedScratchMemory_l412_51;
  wire                when_BankedScratchMemory_l412_52;
  wire                when_BankedScratchMemory_l412_53;
  wire                when_BankedScratchMemory_l412_54;
  wire                when_BankedScratchMemory_l412_55;
  reg        [31:0]   _zz_fwdValuGap2Data_0_2;
  wire                when_BankedScratchMemory_l412_56;
  wire                when_BankedScratchMemory_l412_57;
  wire                when_BankedScratchMemory_l412_58;
  wire                when_BankedScratchMemory_l412_59;
  wire                when_BankedScratchMemory_l412_60;
  wire                when_BankedScratchMemory_l412_61;
  wire                when_BankedScratchMemory_l412_62;
  wire                when_BankedScratchMemory_l412_63;
  wire                when_BankedScratchMemory_l412_64;
  wire                when_BankedScratchMemory_l412_65;
  wire                when_BankedScratchMemory_l412_66;
  wire                when_BankedScratchMemory_l412_67;
  wire                when_BankedScratchMemory_l412_68;
  wire                when_BankedScratchMemory_l412_69;
  wire                when_BankedScratchMemory_l412_70;
  wire                when_BankedScratchMemory_l412_71;
  wire                when_BankedScratchMemory_l412_72;
  wire                when_BankedScratchMemory_l412_73;
  wire                when_BankedScratchMemory_l412_74;
  wire                when_BankedScratchMemory_l412_75;
  wire                when_BankedScratchMemory_l412_76;
  wire                when_BankedScratchMemory_l412_77;
  wire                when_BankedScratchMemory_l412_78;
  wire                when_BankedScratchMemory_l412_79;
  wire                when_BankedScratchMemory_l412_80;
  wire                when_BankedScratchMemory_l412_81;
  wire                when_BankedScratchMemory_l412_82;
  wire                when_BankedScratchMemory_l412_83;
  reg        [31:0]   _zz_fwdValuGap2Data_0_3;
  wire                when_BankedScratchMemory_l412_84;
  wire                when_BankedScratchMemory_l412_85;
  wire                when_BankedScratchMemory_l412_86;
  wire                when_BankedScratchMemory_l412_87;
  wire                when_BankedScratchMemory_l412_88;
  wire                when_BankedScratchMemory_l412_89;
  wire                when_BankedScratchMemory_l412_90;
  wire                when_BankedScratchMemory_l412_91;
  wire                when_BankedScratchMemory_l412_92;
  wire                when_BankedScratchMemory_l412_93;
  wire                when_BankedScratchMemory_l412_94;
  wire                when_BankedScratchMemory_l412_95;
  wire                when_BankedScratchMemory_l412_96;
  wire                when_BankedScratchMemory_l412_97;
  wire                when_BankedScratchMemory_l412_98;
  wire                when_BankedScratchMemory_l412_99;
  wire                when_BankedScratchMemory_l412_100;
  wire                when_BankedScratchMemory_l412_101;
  wire                when_BankedScratchMemory_l412_102;
  wire                when_BankedScratchMemory_l412_103;
  wire                when_BankedScratchMemory_l412_104;
  wire                when_BankedScratchMemory_l412_105;
  wire                when_BankedScratchMemory_l412_106;
  wire                when_BankedScratchMemory_l412_107;
  wire                when_BankedScratchMemory_l412_108;
  wire                when_BankedScratchMemory_l412_109;
  wire                when_BankedScratchMemory_l412_110;
  wire                when_BankedScratchMemory_l412_111;
  reg        [31:0]   _zz_fwdValuGap2Data_0_4;
  wire                when_BankedScratchMemory_l412_112;
  wire                when_BankedScratchMemory_l412_113;
  wire                when_BankedScratchMemory_l412_114;
  wire                when_BankedScratchMemory_l412_115;
  wire                when_BankedScratchMemory_l412_116;
  wire                when_BankedScratchMemory_l412_117;
  wire                when_BankedScratchMemory_l412_118;
  wire                when_BankedScratchMemory_l412_119;
  wire                when_BankedScratchMemory_l412_120;
  wire                when_BankedScratchMemory_l412_121;
  wire                when_BankedScratchMemory_l412_122;
  wire                when_BankedScratchMemory_l412_123;
  wire                when_BankedScratchMemory_l412_124;
  wire                when_BankedScratchMemory_l412_125;
  wire                when_BankedScratchMemory_l412_126;
  wire                when_BankedScratchMemory_l412_127;
  wire                when_BankedScratchMemory_l412_128;
  wire                when_BankedScratchMemory_l412_129;
  wire                when_BankedScratchMemory_l412_130;
  wire                when_BankedScratchMemory_l412_131;
  wire                when_BankedScratchMemory_l412_132;
  wire                when_BankedScratchMemory_l412_133;
  wire                when_BankedScratchMemory_l412_134;
  wire                when_BankedScratchMemory_l412_135;
  wire                when_BankedScratchMemory_l412_136;
  wire                when_BankedScratchMemory_l412_137;
  wire                when_BankedScratchMemory_l412_138;
  wire                when_BankedScratchMemory_l412_139;
  reg        [31:0]   _zz_fwdValuGap2Data_0_5;
  wire                when_BankedScratchMemory_l412_140;
  wire                when_BankedScratchMemory_l412_141;
  wire                when_BankedScratchMemory_l412_142;
  wire                when_BankedScratchMemory_l412_143;
  wire                when_BankedScratchMemory_l412_144;
  wire                when_BankedScratchMemory_l412_145;
  wire                when_BankedScratchMemory_l412_146;
  wire                when_BankedScratchMemory_l412_147;
  wire                when_BankedScratchMemory_l412_148;
  wire                when_BankedScratchMemory_l412_149;
  wire                when_BankedScratchMemory_l412_150;
  wire                when_BankedScratchMemory_l412_151;
  wire                when_BankedScratchMemory_l412_152;
  wire                when_BankedScratchMemory_l412_153;
  wire                when_BankedScratchMemory_l412_154;
  wire                when_BankedScratchMemory_l412_155;
  wire                when_BankedScratchMemory_l412_156;
  wire                when_BankedScratchMemory_l412_157;
  wire                when_BankedScratchMemory_l412_158;
  wire                when_BankedScratchMemory_l412_159;
  wire                when_BankedScratchMemory_l412_160;
  wire                when_BankedScratchMemory_l412_161;
  wire                when_BankedScratchMemory_l412_162;
  wire                when_BankedScratchMemory_l412_163;
  wire                when_BankedScratchMemory_l412_164;
  wire                when_BankedScratchMemory_l412_165;
  wire                when_BankedScratchMemory_l412_166;
  wire                when_BankedScratchMemory_l412_167;
  reg        [31:0]   _zz_fwdValuGap2Data_0_6;
  wire                when_BankedScratchMemory_l412_168;
  wire                when_BankedScratchMemory_l412_169;
  wire                when_BankedScratchMemory_l412_170;
  wire                when_BankedScratchMemory_l412_171;
  wire                when_BankedScratchMemory_l412_172;
  wire                when_BankedScratchMemory_l412_173;
  wire                when_BankedScratchMemory_l412_174;
  wire                when_BankedScratchMemory_l412_175;
  wire                when_BankedScratchMemory_l412_176;
  wire                when_BankedScratchMemory_l412_177;
  wire                when_BankedScratchMemory_l412_178;
  wire                when_BankedScratchMemory_l412_179;
  wire                when_BankedScratchMemory_l412_180;
  wire                when_BankedScratchMemory_l412_181;
  wire                when_BankedScratchMemory_l412_182;
  wire                when_BankedScratchMemory_l412_183;
  wire                when_BankedScratchMemory_l412_184;
  wire                when_BankedScratchMemory_l412_185;
  wire                when_BankedScratchMemory_l412_186;
  wire                when_BankedScratchMemory_l412_187;
  wire                when_BankedScratchMemory_l412_188;
  wire                when_BankedScratchMemory_l412_189;
  wire                when_BankedScratchMemory_l412_190;
  wire                when_BankedScratchMemory_l412_191;
  wire                when_BankedScratchMemory_l412_192;
  wire                when_BankedScratchMemory_l412_193;
  wire                when_BankedScratchMemory_l412_194;
  wire                when_BankedScratchMemory_l412_195;
  reg        [31:0]   _zz_fwdValuGap2Data_0_7;
  wire                when_BankedScratchMemory_l412_196;
  wire                when_BankedScratchMemory_l412_197;
  wire                when_BankedScratchMemory_l412_198;
  wire                when_BankedScratchMemory_l412_199;
  wire                when_BankedScratchMemory_l412_200;
  wire                when_BankedScratchMemory_l412_201;
  wire                when_BankedScratchMemory_l412_202;
  wire                when_BankedScratchMemory_l412_203;
  wire                when_BankedScratchMemory_l412_204;
  wire                when_BankedScratchMemory_l412_205;
  wire                when_BankedScratchMemory_l412_206;
  wire                when_BankedScratchMemory_l412_207;
  wire                when_BankedScratchMemory_l412_208;
  wire                when_BankedScratchMemory_l412_209;
  wire                when_BankedScratchMemory_l412_210;
  wire                when_BankedScratchMemory_l412_211;
  wire                when_BankedScratchMemory_l412_212;
  wire                when_BankedScratchMemory_l412_213;
  wire                when_BankedScratchMemory_l412_214;
  wire                when_BankedScratchMemory_l412_215;
  wire                when_BankedScratchMemory_l412_216;
  wire                when_BankedScratchMemory_l412_217;
  wire                when_BankedScratchMemory_l412_218;
  wire                when_BankedScratchMemory_l412_219;
  wire                when_BankedScratchMemory_l412_220;
  wire                when_BankedScratchMemory_l412_221;
  wire                when_BankedScratchMemory_l412_222;
  wire                when_BankedScratchMemory_l412_223;
  reg        [31:0]   _zz_fwdValuGap2Data_1_0;
  wire                when_BankedScratchMemory_l412_224;
  wire                when_BankedScratchMemory_l412_225;
  wire                when_BankedScratchMemory_l412_226;
  wire                when_BankedScratchMemory_l412_227;
  wire                when_BankedScratchMemory_l412_228;
  wire                when_BankedScratchMemory_l412_229;
  wire                when_BankedScratchMemory_l412_230;
  wire                when_BankedScratchMemory_l412_231;
  wire                when_BankedScratchMemory_l412_232;
  wire                when_BankedScratchMemory_l412_233;
  wire                when_BankedScratchMemory_l412_234;
  wire                when_BankedScratchMemory_l412_235;
  wire                when_BankedScratchMemory_l412_236;
  wire                when_BankedScratchMemory_l412_237;
  wire                when_BankedScratchMemory_l412_238;
  wire                when_BankedScratchMemory_l412_239;
  wire                when_BankedScratchMemory_l412_240;
  wire                when_BankedScratchMemory_l412_241;
  wire                when_BankedScratchMemory_l412_242;
  wire                when_BankedScratchMemory_l412_243;
  wire                when_BankedScratchMemory_l412_244;
  wire                when_BankedScratchMemory_l412_245;
  wire                when_BankedScratchMemory_l412_246;
  wire                when_BankedScratchMemory_l412_247;
  wire                when_BankedScratchMemory_l412_248;
  wire                when_BankedScratchMemory_l412_249;
  wire                when_BankedScratchMemory_l412_250;
  wire                when_BankedScratchMemory_l412_251;
  reg        [31:0]   _zz_fwdValuGap2Data_1_1;
  wire                when_BankedScratchMemory_l412_252;
  wire                when_BankedScratchMemory_l412_253;
  wire                when_BankedScratchMemory_l412_254;
  wire                when_BankedScratchMemory_l412_255;
  wire                when_BankedScratchMemory_l412_256;
  wire                when_BankedScratchMemory_l412_257;
  wire                when_BankedScratchMemory_l412_258;
  wire                when_BankedScratchMemory_l412_259;
  wire                when_BankedScratchMemory_l412_260;
  wire                when_BankedScratchMemory_l412_261;
  wire                when_BankedScratchMemory_l412_262;
  wire                when_BankedScratchMemory_l412_263;
  wire                when_BankedScratchMemory_l412_264;
  wire                when_BankedScratchMemory_l412_265;
  wire                when_BankedScratchMemory_l412_266;
  wire                when_BankedScratchMemory_l412_267;
  wire                when_BankedScratchMemory_l412_268;
  wire                when_BankedScratchMemory_l412_269;
  wire                when_BankedScratchMemory_l412_270;
  wire                when_BankedScratchMemory_l412_271;
  wire                when_BankedScratchMemory_l412_272;
  wire                when_BankedScratchMemory_l412_273;
  wire                when_BankedScratchMemory_l412_274;
  wire                when_BankedScratchMemory_l412_275;
  wire                when_BankedScratchMemory_l412_276;
  wire                when_BankedScratchMemory_l412_277;
  wire                when_BankedScratchMemory_l412_278;
  wire                when_BankedScratchMemory_l412_279;
  reg        [31:0]   _zz_fwdValuGap2Data_1_2;
  wire                when_BankedScratchMemory_l412_280;
  wire                when_BankedScratchMemory_l412_281;
  wire                when_BankedScratchMemory_l412_282;
  wire                when_BankedScratchMemory_l412_283;
  wire                when_BankedScratchMemory_l412_284;
  wire                when_BankedScratchMemory_l412_285;
  wire                when_BankedScratchMemory_l412_286;
  wire                when_BankedScratchMemory_l412_287;
  wire                when_BankedScratchMemory_l412_288;
  wire                when_BankedScratchMemory_l412_289;
  wire                when_BankedScratchMemory_l412_290;
  wire                when_BankedScratchMemory_l412_291;
  wire                when_BankedScratchMemory_l412_292;
  wire                when_BankedScratchMemory_l412_293;
  wire                when_BankedScratchMemory_l412_294;
  wire                when_BankedScratchMemory_l412_295;
  wire                when_BankedScratchMemory_l412_296;
  wire                when_BankedScratchMemory_l412_297;
  wire                when_BankedScratchMemory_l412_298;
  wire                when_BankedScratchMemory_l412_299;
  wire                when_BankedScratchMemory_l412_300;
  wire                when_BankedScratchMemory_l412_301;
  wire                when_BankedScratchMemory_l412_302;
  wire                when_BankedScratchMemory_l412_303;
  wire                when_BankedScratchMemory_l412_304;
  wire                when_BankedScratchMemory_l412_305;
  wire                when_BankedScratchMemory_l412_306;
  wire                when_BankedScratchMemory_l412_307;
  reg        [31:0]   _zz_fwdValuGap2Data_1_3;
  wire                when_BankedScratchMemory_l412_308;
  wire                when_BankedScratchMemory_l412_309;
  wire                when_BankedScratchMemory_l412_310;
  wire                when_BankedScratchMemory_l412_311;
  wire                when_BankedScratchMemory_l412_312;
  wire                when_BankedScratchMemory_l412_313;
  wire                when_BankedScratchMemory_l412_314;
  wire                when_BankedScratchMemory_l412_315;
  wire                when_BankedScratchMemory_l412_316;
  wire                when_BankedScratchMemory_l412_317;
  wire                when_BankedScratchMemory_l412_318;
  wire                when_BankedScratchMemory_l412_319;
  wire                when_BankedScratchMemory_l412_320;
  wire                when_BankedScratchMemory_l412_321;
  wire                when_BankedScratchMemory_l412_322;
  wire                when_BankedScratchMemory_l412_323;
  wire                when_BankedScratchMemory_l412_324;
  wire                when_BankedScratchMemory_l412_325;
  wire                when_BankedScratchMemory_l412_326;
  wire                when_BankedScratchMemory_l412_327;
  wire                when_BankedScratchMemory_l412_328;
  wire                when_BankedScratchMemory_l412_329;
  wire                when_BankedScratchMemory_l412_330;
  wire                when_BankedScratchMemory_l412_331;
  wire                when_BankedScratchMemory_l412_332;
  wire                when_BankedScratchMemory_l412_333;
  wire                when_BankedScratchMemory_l412_334;
  wire                when_BankedScratchMemory_l412_335;
  reg        [31:0]   _zz_fwdValuGap2Data_1_4;
  wire                when_BankedScratchMemory_l412_336;
  wire                when_BankedScratchMemory_l412_337;
  wire                when_BankedScratchMemory_l412_338;
  wire                when_BankedScratchMemory_l412_339;
  wire                when_BankedScratchMemory_l412_340;
  wire                when_BankedScratchMemory_l412_341;
  wire                when_BankedScratchMemory_l412_342;
  wire                when_BankedScratchMemory_l412_343;
  wire                when_BankedScratchMemory_l412_344;
  wire                when_BankedScratchMemory_l412_345;
  wire                when_BankedScratchMemory_l412_346;
  wire                when_BankedScratchMemory_l412_347;
  wire                when_BankedScratchMemory_l412_348;
  wire                when_BankedScratchMemory_l412_349;
  wire                when_BankedScratchMemory_l412_350;
  wire                when_BankedScratchMemory_l412_351;
  wire                when_BankedScratchMemory_l412_352;
  wire                when_BankedScratchMemory_l412_353;
  wire                when_BankedScratchMemory_l412_354;
  wire                when_BankedScratchMemory_l412_355;
  wire                when_BankedScratchMemory_l412_356;
  wire                when_BankedScratchMemory_l412_357;
  wire                when_BankedScratchMemory_l412_358;
  wire                when_BankedScratchMemory_l412_359;
  wire                when_BankedScratchMemory_l412_360;
  wire                when_BankedScratchMemory_l412_361;
  wire                when_BankedScratchMemory_l412_362;
  wire                when_BankedScratchMemory_l412_363;
  reg        [31:0]   _zz_fwdValuGap2Data_1_5;
  wire                when_BankedScratchMemory_l412_364;
  wire                when_BankedScratchMemory_l412_365;
  wire                when_BankedScratchMemory_l412_366;
  wire                when_BankedScratchMemory_l412_367;
  wire                when_BankedScratchMemory_l412_368;
  wire                when_BankedScratchMemory_l412_369;
  wire                when_BankedScratchMemory_l412_370;
  wire                when_BankedScratchMemory_l412_371;
  wire                when_BankedScratchMemory_l412_372;
  wire                when_BankedScratchMemory_l412_373;
  wire                when_BankedScratchMemory_l412_374;
  wire                when_BankedScratchMemory_l412_375;
  wire                when_BankedScratchMemory_l412_376;
  wire                when_BankedScratchMemory_l412_377;
  wire                when_BankedScratchMemory_l412_378;
  wire                when_BankedScratchMemory_l412_379;
  wire                when_BankedScratchMemory_l412_380;
  wire                when_BankedScratchMemory_l412_381;
  wire                when_BankedScratchMemory_l412_382;
  wire                when_BankedScratchMemory_l412_383;
  wire                when_BankedScratchMemory_l412_384;
  wire                when_BankedScratchMemory_l412_385;
  wire                when_BankedScratchMemory_l412_386;
  wire                when_BankedScratchMemory_l412_387;
  wire                when_BankedScratchMemory_l412_388;
  wire                when_BankedScratchMemory_l412_389;
  wire                when_BankedScratchMemory_l412_390;
  wire                when_BankedScratchMemory_l412_391;
  reg        [31:0]   _zz_fwdValuGap2Data_1_6;
  wire                when_BankedScratchMemory_l412_392;
  wire                when_BankedScratchMemory_l412_393;
  wire                when_BankedScratchMemory_l412_394;
  wire                when_BankedScratchMemory_l412_395;
  wire                when_BankedScratchMemory_l412_396;
  wire                when_BankedScratchMemory_l412_397;
  wire                when_BankedScratchMemory_l412_398;
  wire                when_BankedScratchMemory_l412_399;
  wire                when_BankedScratchMemory_l412_400;
  wire                when_BankedScratchMemory_l412_401;
  wire                when_BankedScratchMemory_l412_402;
  wire                when_BankedScratchMemory_l412_403;
  wire                when_BankedScratchMemory_l412_404;
  wire                when_BankedScratchMemory_l412_405;
  wire                when_BankedScratchMemory_l412_406;
  wire                when_BankedScratchMemory_l412_407;
  wire                when_BankedScratchMemory_l412_408;
  wire                when_BankedScratchMemory_l412_409;
  wire                when_BankedScratchMemory_l412_410;
  wire                when_BankedScratchMemory_l412_411;
  wire                when_BankedScratchMemory_l412_412;
  wire                when_BankedScratchMemory_l412_413;
  wire                when_BankedScratchMemory_l412_414;
  wire                when_BankedScratchMemory_l412_415;
  wire                when_BankedScratchMemory_l412_416;
  wire                when_BankedScratchMemory_l412_417;
  wire                when_BankedScratchMemory_l412_418;
  wire                when_BankedScratchMemory_l412_419;
  reg        [31:0]   _zz_fwdValuGap2Data_1_7;
  wire                when_BankedScratchMemory_l412_420;
  wire                when_BankedScratchMemory_l412_421;
  wire                when_BankedScratchMemory_l412_422;
  wire                when_BankedScratchMemory_l412_423;
  wire                when_BankedScratchMemory_l412_424;
  wire                when_BankedScratchMemory_l412_425;
  wire                when_BankedScratchMemory_l412_426;
  wire                when_BankedScratchMemory_l412_427;
  wire                when_BankedScratchMemory_l412_428;
  wire                when_BankedScratchMemory_l412_429;
  wire                when_BankedScratchMemory_l412_430;
  wire                when_BankedScratchMemory_l412_431;
  wire                when_BankedScratchMemory_l412_432;
  wire                when_BankedScratchMemory_l412_433;
  wire                when_BankedScratchMemory_l412_434;
  wire                when_BankedScratchMemory_l412_435;
  wire                when_BankedScratchMemory_l412_436;
  wire                when_BankedScratchMemory_l412_437;
  wire                when_BankedScratchMemory_l412_438;
  wire                when_BankedScratchMemory_l412_439;
  wire                when_BankedScratchMemory_l412_440;
  wire                when_BankedScratchMemory_l412_441;
  wire                when_BankedScratchMemory_l412_442;
  wire                when_BankedScratchMemory_l412_443;
  wire                when_BankedScratchMemory_l412_444;
  wire                when_BankedScratchMemory_l412_445;
  wire                when_BankedScratchMemory_l412_446;
  wire                when_BankedScratchMemory_l412_447;
  reg                 prevValuReadEn_0_0;
  reg                 prevValuReadEn_0_1;
  reg                 prevValuReadEn_0_2;
  reg                 prevValuReadEn_0_3;
  reg                 prevValuReadEn_0_4;
  reg                 prevValuReadEn_0_5;
  reg                 prevValuReadEn_0_6;
  reg                 prevValuReadEn_0_7;
  reg                 prevValuReadEn_1_0;
  reg                 prevValuReadEn_1_1;
  reg                 prevValuReadEn_1_2;
  reg                 prevValuReadEn_1_3;
  reg                 prevValuReadEn_1_4;
  reg                 prevValuReadEn_1_5;
  reg                 prevValuReadEn_1_6;
  reg                 prevValuReadEn_1_7;
  reg        [10:0]   prevValuReadAddr_0_0;
  reg        [10:0]   prevValuReadAddr_0_1;
  reg        [10:0]   prevValuReadAddr_0_2;
  reg        [10:0]   prevValuReadAddr_0_3;
  reg        [10:0]   prevValuReadAddr_0_4;
  reg        [10:0]   prevValuReadAddr_0_5;
  reg        [10:0]   prevValuReadAddr_0_6;
  reg        [10:0]   prevValuReadAddr_0_7;
  reg        [10:0]   prevValuReadAddr_1_0;
  reg        [10:0]   prevValuReadAddr_1_1;
  reg        [10:0]   prevValuReadAddr_1_2;
  reg        [10:0]   prevValuReadAddr_1_3;
  reg        [10:0]   prevValuReadAddr_1_4;
  reg        [10:0]   prevValuReadAddr_1_5;
  reg        [10:0]   prevValuReadAddr_1_6;
  reg        [10:0]   prevValuReadAddr_1_7;
  wire                when_BankedScratchMemory_l448;
  wire                when_BankedScratchMemory_l448_1;
  wire                when_BankedScratchMemory_l448_2;
  wire                when_BankedScratchMemory_l448_3;
  wire                when_BankedScratchMemory_l448_4;
  wire                when_BankedScratchMemory_l448_5;
  wire                when_BankedScratchMemory_l448_6;
  wire                when_BankedScratchMemory_l448_7;
  wire                when_BankedScratchMemory_l448_8;
  wire                when_BankedScratchMemory_l448_9;
  wire                when_BankedScratchMemory_l448_10;
  wire                when_BankedScratchMemory_l448_11;
  wire                when_BankedScratchMemory_l448_12;
  wire                when_BankedScratchMemory_l448_13;
  wire                when_BankedScratchMemory_l448_14;
  wire                when_BankedScratchMemory_l448_15;
  wire                when_BankedScratchMemory_l448_16;
  wire                when_BankedScratchMemory_l448_17;
  wire                when_BankedScratchMemory_l448_18;
  wire                when_BankedScratchMemory_l448_19;
  wire                when_BankedScratchMemory_l448_20;
  wire                when_BankedScratchMemory_l448_21;
  wire                when_BankedScratchMemory_l448_22;
  wire                when_BankedScratchMemory_l448_23;
  wire                when_BankedScratchMemory_l448_24;
  wire                when_BankedScratchMemory_l448_25;
  wire                when_BankedScratchMemory_l448_26;
  wire                when_BankedScratchMemory_l448_27;
  wire                when_BankedScratchMemory_l448_28;
  wire                when_BankedScratchMemory_l448_29;
  wire                when_BankedScratchMemory_l448_30;
  wire                when_BankedScratchMemory_l448_31;
  wire                when_BankedScratchMemory_l448_32;
  wire                when_BankedScratchMemory_l448_33;
  wire                when_BankedScratchMemory_l448_34;
  wire                when_BankedScratchMemory_l448_35;
  wire                when_BankedScratchMemory_l448_36;
  wire                when_BankedScratchMemory_l448_37;
  wire                when_BankedScratchMemory_l448_38;
  wire                when_BankedScratchMemory_l448_39;
  wire                when_BankedScratchMemory_l448_40;
  wire                when_BankedScratchMemory_l448_41;
  wire                when_BankedScratchMemory_l448_42;
  wire                when_BankedScratchMemory_l448_43;
  wire                when_BankedScratchMemory_l448_44;
  wire                when_BankedScratchMemory_l448_45;
  wire                when_BankedScratchMemory_l448_46;
  wire                when_BankedScratchMemory_l448_47;
  wire                when_BankedScratchMemory_l448_48;
  wire                when_BankedScratchMemory_l448_49;
  wire                when_BankedScratchMemory_l448_50;
  wire                when_BankedScratchMemory_l448_51;
  wire                when_BankedScratchMemory_l448_52;
  wire                when_BankedScratchMemory_l448_53;
  wire                when_BankedScratchMemory_l448_54;
  wire                when_BankedScratchMemory_l448_55;
  wire                when_BankedScratchMemory_l448_56;
  wire                when_BankedScratchMemory_l448_57;
  wire                when_BankedScratchMemory_l448_58;
  wire                when_BankedScratchMemory_l448_59;
  wire                when_BankedScratchMemory_l448_60;
  wire                when_BankedScratchMemory_l448_61;
  wire                when_BankedScratchMemory_l448_62;
  wire                when_BankedScratchMemory_l448_63;
  wire                when_BankedScratchMemory_l448_64;
  wire                when_BankedScratchMemory_l448_65;
  wire                when_BankedScratchMemory_l448_66;
  wire                when_BankedScratchMemory_l448_67;
  wire                when_BankedScratchMemory_l448_68;
  wire                when_BankedScratchMemory_l448_69;
  wire                when_BankedScratchMemory_l448_70;
  wire                when_BankedScratchMemory_l448_71;
  wire                when_BankedScratchMemory_l448_72;
  wire                when_BankedScratchMemory_l448_73;
  wire                when_BankedScratchMemory_l448_74;
  wire                when_BankedScratchMemory_l448_75;
  wire                when_BankedScratchMemory_l448_76;
  wire                when_BankedScratchMemory_l448_77;
  wire                when_BankedScratchMemory_l448_78;
  wire                when_BankedScratchMemory_l448_79;
  wire                when_BankedScratchMemory_l448_80;
  wire                when_BankedScratchMemory_l448_81;
  wire                when_BankedScratchMemory_l448_82;
  wire                when_BankedScratchMemory_l448_83;
  wire                when_BankedScratchMemory_l448_84;
  wire                when_BankedScratchMemory_l448_85;
  wire                when_BankedScratchMemory_l448_86;
  wire                when_BankedScratchMemory_l448_87;
  wire                when_BankedScratchMemory_l448_88;
  wire                when_BankedScratchMemory_l448_89;
  wire                when_BankedScratchMemory_l448_90;
  wire                when_BankedScratchMemory_l448_91;
  wire                when_BankedScratchMemory_l448_92;
  wire                when_BankedScratchMemory_l448_93;
  wire                when_BankedScratchMemory_l448_94;
  wire                when_BankedScratchMemory_l448_95;
  wire                when_BankedScratchMemory_l448_96;
  wire                when_BankedScratchMemory_l448_97;
  wire                when_BankedScratchMemory_l448_98;
  wire                when_BankedScratchMemory_l448_99;
  wire                when_BankedScratchMemory_l448_100;
  wire                when_BankedScratchMemory_l448_101;
  wire                when_BankedScratchMemory_l448_102;
  wire                when_BankedScratchMemory_l448_103;
  wire                when_BankedScratchMemory_l448_104;
  wire                when_BankedScratchMemory_l448_105;
  wire                when_BankedScratchMemory_l448_106;
  wire                when_BankedScratchMemory_l448_107;
  wire                when_BankedScratchMemory_l448_108;
  wire                when_BankedScratchMemory_l448_109;
  wire                when_BankedScratchMemory_l448_110;
  wire                when_BankedScratchMemory_l448_111;
  wire                when_BankedScratchMemory_l448_112;
  wire                when_BankedScratchMemory_l448_113;
  wire                when_BankedScratchMemory_l448_114;
  wire                when_BankedScratchMemory_l448_115;
  wire                when_BankedScratchMemory_l448_116;
  wire                when_BankedScratchMemory_l448_117;
  wire                when_BankedScratchMemory_l448_118;
  wire                when_BankedScratchMemory_l448_119;
  wire                when_BankedScratchMemory_l448_120;
  wire                when_BankedScratchMemory_l448_121;
  wire                when_BankedScratchMemory_l448_122;
  wire                when_BankedScratchMemory_l448_123;
  wire                when_BankedScratchMemory_l448_124;
  wire                when_BankedScratchMemory_l448_125;
  wire                when_BankedScratchMemory_l448_126;
  wire                when_BankedScratchMemory_l448_127;
  wire                when_BankedScratchMemory_l448_128;
  wire                when_BankedScratchMemory_l448_129;
  wire                when_BankedScratchMemory_l448_130;
  wire                when_BankedScratchMemory_l448_131;
  wire                when_BankedScratchMemory_l448_132;
  wire                when_BankedScratchMemory_l448_133;
  wire                when_BankedScratchMemory_l448_134;
  wire                when_BankedScratchMemory_l448_135;
  wire                when_BankedScratchMemory_l448_136;
  wire                when_BankedScratchMemory_l448_137;
  wire                when_BankedScratchMemory_l448_138;
  wire                when_BankedScratchMemory_l448_139;
  wire                when_BankedScratchMemory_l448_140;
  wire                when_BankedScratchMemory_l448_141;
  wire                when_BankedScratchMemory_l448_142;
  wire                when_BankedScratchMemory_l448_143;
  wire                when_BankedScratchMemory_l448_144;
  wire                when_BankedScratchMemory_l448_145;
  wire                when_BankedScratchMemory_l448_146;
  wire                when_BankedScratchMemory_l448_147;
  wire                when_BankedScratchMemory_l448_148;
  wire                when_BankedScratchMemory_l448_149;
  wire                when_BankedScratchMemory_l448_150;
  wire                when_BankedScratchMemory_l448_151;
  wire                when_BankedScratchMemory_l448_152;
  wire                when_BankedScratchMemory_l448_153;
  wire                when_BankedScratchMemory_l448_154;
  wire                when_BankedScratchMemory_l448_155;
  wire                when_BankedScratchMemory_l448_156;
  wire                when_BankedScratchMemory_l448_157;
  wire                when_BankedScratchMemory_l448_158;
  wire                when_BankedScratchMemory_l448_159;
  wire                when_BankedScratchMemory_l448_160;
  wire                when_BankedScratchMemory_l448_161;
  wire                when_BankedScratchMemory_l448_162;
  wire                when_BankedScratchMemory_l448_163;
  wire                when_BankedScratchMemory_l448_164;
  wire                when_BankedScratchMemory_l448_165;
  wire                when_BankedScratchMemory_l448_166;
  wire                when_BankedScratchMemory_l448_167;
  wire                when_BankedScratchMemory_l448_168;
  wire                when_BankedScratchMemory_l448_169;
  wire                when_BankedScratchMemory_l448_170;
  wire                when_BankedScratchMemory_l448_171;
  wire                when_BankedScratchMemory_l448_172;
  wire                when_BankedScratchMemory_l448_173;
  wire                when_BankedScratchMemory_l448_174;
  wire                when_BankedScratchMemory_l448_175;
  wire                when_BankedScratchMemory_l448_176;
  wire                when_BankedScratchMemory_l448_177;
  wire                when_BankedScratchMemory_l448_178;
  wire                when_BankedScratchMemory_l448_179;
  wire                when_BankedScratchMemory_l448_180;
  wire                when_BankedScratchMemory_l448_181;
  wire                when_BankedScratchMemory_l448_182;
  wire                when_BankedScratchMemory_l448_183;
  wire                when_BankedScratchMemory_l448_184;
  wire                when_BankedScratchMemory_l448_185;
  wire                when_BankedScratchMemory_l448_186;
  wire                when_BankedScratchMemory_l448_187;
  wire                when_BankedScratchMemory_l448_188;
  wire                when_BankedScratchMemory_l448_189;
  wire                when_BankedScratchMemory_l448_190;
  wire                when_BankedScratchMemory_l448_191;
  wire                when_BankedScratchMemory_l448_192;
  wire                when_BankedScratchMemory_l448_193;
  wire                when_BankedScratchMemory_l448_194;
  wire                when_BankedScratchMemory_l448_195;
  wire                when_BankedScratchMemory_l448_196;
  wire                when_BankedScratchMemory_l448_197;
  wire                when_BankedScratchMemory_l448_198;
  wire                when_BankedScratchMemory_l448_199;
  wire                when_BankedScratchMemory_l448_200;
  wire                when_BankedScratchMemory_l448_201;
  wire                when_BankedScratchMemory_l448_202;
  wire                when_BankedScratchMemory_l448_203;
  wire                when_BankedScratchMemory_l448_204;
  wire                when_BankedScratchMemory_l448_205;
  wire                when_BankedScratchMemory_l448_206;
  wire                when_BankedScratchMemory_l448_207;
  wire                when_BankedScratchMemory_l448_208;
  wire                when_BankedScratchMemory_l448_209;
  wire                when_BankedScratchMemory_l448_210;
  wire                when_BankedScratchMemory_l448_211;
  wire                when_BankedScratchMemory_l448_212;
  wire                when_BankedScratchMemory_l448_213;
  wire                when_BankedScratchMemory_l448_214;
  wire                when_BankedScratchMemory_l448_215;
  wire                when_BankedScratchMemory_l448_216;
  wire                when_BankedScratchMemory_l448_217;
  wire                when_BankedScratchMemory_l448_218;
  wire                when_BankedScratchMemory_l448_219;
  wire                when_BankedScratchMemory_l448_220;
  wire                when_BankedScratchMemory_l448_221;
  wire                when_BankedScratchMemory_l448_222;
  wire                when_BankedScratchMemory_l448_223;
  wire                when_BankedScratchMemory_l448_224;
  wire                when_BankedScratchMemory_l448_225;
  wire                when_BankedScratchMemory_l448_226;
  wire                when_BankedScratchMemory_l448_227;
  wire                when_BankedScratchMemory_l448_228;
  wire                when_BankedScratchMemory_l448_229;
  wire                when_BankedScratchMemory_l448_230;
  wire                when_BankedScratchMemory_l448_231;
  wire                when_BankedScratchMemory_l448_232;
  wire                when_BankedScratchMemory_l448_233;
  wire                when_BankedScratchMemory_l448_234;
  wire                when_BankedScratchMemory_l448_235;
  wire                when_BankedScratchMemory_l448_236;
  wire                when_BankedScratchMemory_l448_237;
  wire                when_BankedScratchMemory_l448_238;
  wire                when_BankedScratchMemory_l448_239;
  wire                when_BankedScratchMemory_l448_240;
  wire                when_BankedScratchMemory_l448_241;
  wire                when_BankedScratchMemory_l448_242;
  wire                when_BankedScratchMemory_l448_243;
  wire                when_BankedScratchMemory_l448_244;
  wire                when_BankedScratchMemory_l448_245;
  wire                when_BankedScratchMemory_l448_246;
  wire                when_BankedScratchMemory_l448_247;
  wire                when_BankedScratchMemory_l448_248;
  wire                when_BankedScratchMemory_l448_249;
  wire                when_BankedScratchMemory_l448_250;
  wire                when_BankedScratchMemory_l448_251;
  wire                when_BankedScratchMemory_l448_252;
  wire                when_BankedScratchMemory_l448_253;
  wire                when_BankedScratchMemory_l448_254;
  wire                when_BankedScratchMemory_l448_255;
  wire                when_BankedScratchMemory_l448_256;
  wire                when_BankedScratchMemory_l448_257;
  wire                when_BankedScratchMemory_l448_258;
  wire                when_BankedScratchMemory_l448_259;
  wire                when_BankedScratchMemory_l448_260;
  wire                when_BankedScratchMemory_l448_261;
  wire                when_BankedScratchMemory_l448_262;
  wire                when_BankedScratchMemory_l448_263;
  wire                when_BankedScratchMemory_l448_264;
  wire                when_BankedScratchMemory_l448_265;
  wire                when_BankedScratchMemory_l448_266;
  wire                when_BankedScratchMemory_l448_267;
  wire                when_BankedScratchMemory_l448_268;
  wire                when_BankedScratchMemory_l448_269;
  wire                when_BankedScratchMemory_l448_270;
  wire                when_BankedScratchMemory_l448_271;
  wire                when_BankedScratchMemory_l448_272;
  wire                when_BankedScratchMemory_l448_273;
  wire                when_BankedScratchMemory_l448_274;
  wire                when_BankedScratchMemory_l448_275;
  wire                when_BankedScratchMemory_l448_276;
  wire                when_BankedScratchMemory_l448_277;
  wire                when_BankedScratchMemory_l448_278;
  wire                when_BankedScratchMemory_l448_279;
  wire                when_BankedScratchMemory_l448_280;
  wire                when_BankedScratchMemory_l448_281;
  wire                when_BankedScratchMemory_l448_282;
  wire                when_BankedScratchMemory_l448_283;
  wire                when_BankedScratchMemory_l448_284;
  wire                when_BankedScratchMemory_l448_285;
  wire                when_BankedScratchMemory_l448_286;
  wire                when_BankedScratchMemory_l448_287;
  wire                when_BankedScratchMemory_l448_288;
  wire                when_BankedScratchMemory_l448_289;
  wire                when_BankedScratchMemory_l448_290;
  wire                when_BankedScratchMemory_l448_291;
  wire                when_BankedScratchMemory_l448_292;
  wire                when_BankedScratchMemory_l448_293;
  wire                when_BankedScratchMemory_l448_294;
  wire                when_BankedScratchMemory_l448_295;
  wire                when_BankedScratchMemory_l448_296;
  wire                when_BankedScratchMemory_l448_297;
  wire                when_BankedScratchMemory_l448_298;
  wire                when_BankedScratchMemory_l448_299;
  wire                when_BankedScratchMemory_l448_300;
  wire                when_BankedScratchMemory_l448_301;
  wire                when_BankedScratchMemory_l448_302;
  wire                when_BankedScratchMemory_l448_303;
  wire                when_BankedScratchMemory_l448_304;
  wire                when_BankedScratchMemory_l448_305;
  wire                when_BankedScratchMemory_l448_306;
  wire                when_BankedScratchMemory_l448_307;
  wire                when_BankedScratchMemory_l448_308;
  wire                when_BankedScratchMemory_l448_309;
  wire                when_BankedScratchMemory_l448_310;
  wire                when_BankedScratchMemory_l448_311;
  wire                when_BankedScratchMemory_l448_312;
  wire                when_BankedScratchMemory_l448_313;
  wire                when_BankedScratchMemory_l448_314;
  wire                when_BankedScratchMemory_l448_315;
  wire                when_BankedScratchMemory_l448_316;
  wire                when_BankedScratchMemory_l448_317;
  wire                when_BankedScratchMemory_l448_318;
  wire                when_BankedScratchMemory_l448_319;
  wire                when_BankedScratchMemory_l448_320;
  wire                when_BankedScratchMemory_l448_321;
  wire                when_BankedScratchMemory_l448_322;
  wire                when_BankedScratchMemory_l448_323;
  wire                when_BankedScratchMemory_l448_324;
  wire                when_BankedScratchMemory_l448_325;
  wire                when_BankedScratchMemory_l448_326;
  wire                when_BankedScratchMemory_l448_327;
  wire                when_BankedScratchMemory_l448_328;
  wire                when_BankedScratchMemory_l448_329;
  wire                when_BankedScratchMemory_l448_330;
  wire                when_BankedScratchMemory_l448_331;
  wire                when_BankedScratchMemory_l448_332;
  wire                when_BankedScratchMemory_l448_333;
  wire                when_BankedScratchMemory_l448_334;
  wire                when_BankedScratchMemory_l448_335;
  wire                when_BankedScratchMemory_l448_336;
  wire                when_BankedScratchMemory_l448_337;
  wire                when_BankedScratchMemory_l448_338;
  wire                when_BankedScratchMemory_l448_339;
  wire                when_BankedScratchMemory_l448_340;
  wire                when_BankedScratchMemory_l448_341;
  wire                when_BankedScratchMemory_l448_342;
  wire                when_BankedScratchMemory_l448_343;
  wire                when_BankedScratchMemory_l448_344;
  wire                when_BankedScratchMemory_l448_345;
  wire                when_BankedScratchMemory_l448_346;
  wire                when_BankedScratchMemory_l448_347;
  wire                when_BankedScratchMemory_l448_348;
  wire                when_BankedScratchMemory_l448_349;
  wire                when_BankedScratchMemory_l448_350;
  wire                when_BankedScratchMemory_l448_351;
  wire                when_BankedScratchMemory_l448_352;
  wire                when_BankedScratchMemory_l448_353;
  wire                when_BankedScratchMemory_l448_354;
  wire                when_BankedScratchMemory_l448_355;
  wire                when_BankedScratchMemory_l448_356;
  wire                when_BankedScratchMemory_l448_357;
  wire                when_BankedScratchMemory_l448_358;
  wire                when_BankedScratchMemory_l448_359;
  wire                when_BankedScratchMemory_l448_360;
  wire                when_BankedScratchMemory_l448_361;
  wire                when_BankedScratchMemory_l448_362;
  wire                when_BankedScratchMemory_l448_363;
  wire                when_BankedScratchMemory_l448_364;
  wire                when_BankedScratchMemory_l448_365;
  wire                when_BankedScratchMemory_l448_366;
  wire                when_BankedScratchMemory_l448_367;
  wire                when_BankedScratchMemory_l448_368;
  wire                when_BankedScratchMemory_l448_369;
  wire                when_BankedScratchMemory_l448_370;
  wire                when_BankedScratchMemory_l448_371;
  wire                when_BankedScratchMemory_l448_372;
  wire                when_BankedScratchMemory_l448_373;
  wire                when_BankedScratchMemory_l448_374;
  wire                when_BankedScratchMemory_l448_375;
  wire                when_BankedScratchMemory_l448_376;
  wire                when_BankedScratchMemory_l448_377;
  wire                when_BankedScratchMemory_l448_378;
  wire                when_BankedScratchMemory_l448_379;
  wire                when_BankedScratchMemory_l448_380;
  wire                when_BankedScratchMemory_l448_381;
  wire                when_BankedScratchMemory_l448_382;
  wire                when_BankedScratchMemory_l448_383;
  wire                when_BankedScratchMemory_l448_384;
  wire                when_BankedScratchMemory_l448_385;
  wire                when_BankedScratchMemory_l448_386;
  wire                when_BankedScratchMemory_l448_387;
  wire                when_BankedScratchMemory_l448_388;
  wire                when_BankedScratchMemory_l448_389;
  wire                when_BankedScratchMemory_l448_390;
  wire                when_BankedScratchMemory_l448_391;
  wire                when_BankedScratchMemory_l448_392;
  wire                when_BankedScratchMemory_l448_393;
  wire                when_BankedScratchMemory_l448_394;
  wire                when_BankedScratchMemory_l448_395;
  wire                when_BankedScratchMemory_l448_396;
  wire                when_BankedScratchMemory_l448_397;
  wire                when_BankedScratchMemory_l448_398;
  wire                when_BankedScratchMemory_l448_399;
  wire                when_BankedScratchMemory_l448_400;
  wire                when_BankedScratchMemory_l448_401;
  wire                when_BankedScratchMemory_l448_402;
  wire                when_BankedScratchMemory_l448_403;
  wire                when_BankedScratchMemory_l448_404;
  wire                when_BankedScratchMemory_l448_405;
  wire                when_BankedScratchMemory_l448_406;
  wire                when_BankedScratchMemory_l448_407;
  wire                when_BankedScratchMemory_l448_408;
  wire                when_BankedScratchMemory_l448_409;
  wire                when_BankedScratchMemory_l448_410;
  wire                when_BankedScratchMemory_l448_411;
  wire                when_BankedScratchMemory_l448_412;
  wire                when_BankedScratchMemory_l448_413;
  wire                when_BankedScratchMemory_l448_414;
  wire                when_BankedScratchMemory_l448_415;
  wire                when_BankedScratchMemory_l448_416;
  wire                when_BankedScratchMemory_l448_417;
  wire                when_BankedScratchMemory_l448_418;
  wire                when_BankedScratchMemory_l448_419;
  wire                when_BankedScratchMemory_l448_420;
  wire                when_BankedScratchMemory_l448_421;
  wire                when_BankedScratchMemory_l448_422;
  wire                when_BankedScratchMemory_l448_423;
  wire                when_BankedScratchMemory_l448_424;
  wire                when_BankedScratchMemory_l448_425;
  wire                when_BankedScratchMemory_l448_426;
  wire                when_BankedScratchMemory_l448_427;
  wire                when_BankedScratchMemory_l448_428;
  wire                when_BankedScratchMemory_l448_429;
  wire                when_BankedScratchMemory_l448_430;
  wire                when_BankedScratchMemory_l448_431;
  wire                when_BankedScratchMemory_l448_432;
  wire                when_BankedScratchMemory_l448_433;
  wire                when_BankedScratchMemory_l448_434;
  wire                when_BankedScratchMemory_l448_435;
  wire                when_BankedScratchMemory_l448_436;
  wire                when_BankedScratchMemory_l448_437;
  wire                when_BankedScratchMemory_l448_438;
  wire                when_BankedScratchMemory_l448_439;
  wire                when_BankedScratchMemory_l448_440;
  wire                when_BankedScratchMemory_l448_441;
  wire                when_BankedScratchMemory_l448_442;
  wire                when_BankedScratchMemory_l448_443;
  wire                when_BankedScratchMemory_l448_444;
  wire                when_BankedScratchMemory_l448_445;
  wire                when_BankedScratchMemory_l448_446;
  wire                when_BankedScratchMemory_l448_447;

  assign _zz_fwdGap2Valid_0 = ((((((((((((1'b0 || when_BankedScratchMemory_l360) || when_BankedScratchMemory_l360_1) || when_BankedScratchMemory_l360_2) || when_BankedScratchMemory_l360_3) || when_BankedScratchMemory_l360_4) || when_BankedScratchMemory_l360_5) || when_BankedScratchMemory_l360_6) || when_BankedScratchMemory_l360_7) || when_BankedScratchMemory_l360_8) || when_BankedScratchMemory_l360_9) || when_BankedScratchMemory_l360_10) || when_BankedScratchMemory_l360_11);
  assign _zz_fwdGap2Valid_1 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_28) || when_BankedScratchMemory_l360_29) || when_BankedScratchMemory_l360_30) || when_BankedScratchMemory_l360_31) || when_BankedScratchMemory_l360_32) || when_BankedScratchMemory_l360_33) || when_BankedScratchMemory_l360_34) || when_BankedScratchMemory_l360_35) || when_BankedScratchMemory_l360_36) || when_BankedScratchMemory_l360_37) || when_BankedScratchMemory_l360_38) || when_BankedScratchMemory_l360_39);
  assign _zz_fwdGap2Valid_2 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_56) || when_BankedScratchMemory_l360_57) || when_BankedScratchMemory_l360_58) || when_BankedScratchMemory_l360_59) || when_BankedScratchMemory_l360_60) || when_BankedScratchMemory_l360_61) || when_BankedScratchMemory_l360_62) || when_BankedScratchMemory_l360_63) || when_BankedScratchMemory_l360_64) || when_BankedScratchMemory_l360_65) || when_BankedScratchMemory_l360_66) || when_BankedScratchMemory_l360_67);
  assign _zz_fwdGap2Valid_3 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_84) || when_BankedScratchMemory_l360_85) || when_BankedScratchMemory_l360_86) || when_BankedScratchMemory_l360_87) || when_BankedScratchMemory_l360_88) || when_BankedScratchMemory_l360_89) || when_BankedScratchMemory_l360_90) || when_BankedScratchMemory_l360_91) || when_BankedScratchMemory_l360_92) || when_BankedScratchMemory_l360_93) || when_BankedScratchMemory_l360_94) || when_BankedScratchMemory_l360_95);
  assign _zz_fwdGap2Valid_4 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_112) || when_BankedScratchMemory_l360_113) || when_BankedScratchMemory_l360_114) || when_BankedScratchMemory_l360_115) || when_BankedScratchMemory_l360_116) || when_BankedScratchMemory_l360_117) || when_BankedScratchMemory_l360_118) || when_BankedScratchMemory_l360_119) || when_BankedScratchMemory_l360_120) || when_BankedScratchMemory_l360_121) || when_BankedScratchMemory_l360_122) || when_BankedScratchMemory_l360_123);
  assign _zz_fwdGap2Valid_5 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_140) || when_BankedScratchMemory_l360_141) || when_BankedScratchMemory_l360_142) || when_BankedScratchMemory_l360_143) || when_BankedScratchMemory_l360_144) || when_BankedScratchMemory_l360_145) || when_BankedScratchMemory_l360_146) || when_BankedScratchMemory_l360_147) || when_BankedScratchMemory_l360_148) || when_BankedScratchMemory_l360_149) || when_BankedScratchMemory_l360_150) || when_BankedScratchMemory_l360_151);
  assign _zz_fwdGap2Valid_6 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_168) || when_BankedScratchMemory_l360_169) || when_BankedScratchMemory_l360_170) || when_BankedScratchMemory_l360_171) || when_BankedScratchMemory_l360_172) || when_BankedScratchMemory_l360_173) || when_BankedScratchMemory_l360_174) || when_BankedScratchMemory_l360_175) || when_BankedScratchMemory_l360_176) || when_BankedScratchMemory_l360_177) || when_BankedScratchMemory_l360_178) || when_BankedScratchMemory_l360_179);
  assign _zz_fwdGap2Valid_7 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_196) || when_BankedScratchMemory_l360_197) || when_BankedScratchMemory_l360_198) || when_BankedScratchMemory_l360_199) || when_BankedScratchMemory_l360_200) || when_BankedScratchMemory_l360_201) || when_BankedScratchMemory_l360_202) || when_BankedScratchMemory_l360_203) || when_BankedScratchMemory_l360_204) || when_BankedScratchMemory_l360_205) || when_BankedScratchMemory_l360_206) || when_BankedScratchMemory_l360_207);
  assign _zz_fwdGap2Valid_8 = ((((((((((((1'b0 || when_BankedScratchMemory_l360_224) || when_BankedScratchMemory_l360_225) || when_BankedScratchMemory_l360_226) || when_BankedScratchMemory_l360_227) || when_BankedScratchMemory_l360_228) || when_BankedScratchMemory_l360_229) || when_BankedScratchMemory_l360_230) || when_BankedScratchMemory_l360_231) || when_BankedScratchMemory_l360_232) || when_BankedScratchMemory_l360_233) || when_BankedScratchMemory_l360_234) || when_BankedScratchMemory_l360_235);
  assign _zz_fwdValuGap2Valid_0_0 = ((((((((((((1'b0 || when_BankedScratchMemory_l412) || when_BankedScratchMemory_l412_1) || when_BankedScratchMemory_l412_2) || when_BankedScratchMemory_l412_3) || when_BankedScratchMemory_l412_4) || when_BankedScratchMemory_l412_5) || when_BankedScratchMemory_l412_6) || when_BankedScratchMemory_l412_7) || when_BankedScratchMemory_l412_8) || when_BankedScratchMemory_l412_9) || when_BankedScratchMemory_l412_10) || when_BankedScratchMemory_l412_11);
  assign _zz_fwdValuGap2Valid_0_1 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_28) || when_BankedScratchMemory_l412_29) || when_BankedScratchMemory_l412_30) || when_BankedScratchMemory_l412_31) || when_BankedScratchMemory_l412_32) || when_BankedScratchMemory_l412_33) || when_BankedScratchMemory_l412_34) || when_BankedScratchMemory_l412_35) || when_BankedScratchMemory_l412_36) || when_BankedScratchMemory_l412_37) || when_BankedScratchMemory_l412_38) || when_BankedScratchMemory_l412_39);
  assign _zz_fwdValuGap2Valid_0_2 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_56) || when_BankedScratchMemory_l412_57) || when_BankedScratchMemory_l412_58) || when_BankedScratchMemory_l412_59) || when_BankedScratchMemory_l412_60) || when_BankedScratchMemory_l412_61) || when_BankedScratchMemory_l412_62) || when_BankedScratchMemory_l412_63) || when_BankedScratchMemory_l412_64) || when_BankedScratchMemory_l412_65) || when_BankedScratchMemory_l412_66) || when_BankedScratchMemory_l412_67);
  assign _zz_fwdValuGap2Valid_0_3 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_84) || when_BankedScratchMemory_l412_85) || when_BankedScratchMemory_l412_86) || when_BankedScratchMemory_l412_87) || when_BankedScratchMemory_l412_88) || when_BankedScratchMemory_l412_89) || when_BankedScratchMemory_l412_90) || when_BankedScratchMemory_l412_91) || when_BankedScratchMemory_l412_92) || when_BankedScratchMemory_l412_93) || when_BankedScratchMemory_l412_94) || when_BankedScratchMemory_l412_95);
  assign _zz_fwdValuGap2Valid_0_4 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_112) || when_BankedScratchMemory_l412_113) || when_BankedScratchMemory_l412_114) || when_BankedScratchMemory_l412_115) || when_BankedScratchMemory_l412_116) || when_BankedScratchMemory_l412_117) || when_BankedScratchMemory_l412_118) || when_BankedScratchMemory_l412_119) || when_BankedScratchMemory_l412_120) || when_BankedScratchMemory_l412_121) || when_BankedScratchMemory_l412_122) || when_BankedScratchMemory_l412_123);
  assign _zz_fwdValuGap2Valid_0_5 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_140) || when_BankedScratchMemory_l412_141) || when_BankedScratchMemory_l412_142) || when_BankedScratchMemory_l412_143) || when_BankedScratchMemory_l412_144) || when_BankedScratchMemory_l412_145) || when_BankedScratchMemory_l412_146) || when_BankedScratchMemory_l412_147) || when_BankedScratchMemory_l412_148) || when_BankedScratchMemory_l412_149) || when_BankedScratchMemory_l412_150) || when_BankedScratchMemory_l412_151);
  assign _zz_fwdValuGap2Valid_0_6 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_168) || when_BankedScratchMemory_l412_169) || when_BankedScratchMemory_l412_170) || when_BankedScratchMemory_l412_171) || when_BankedScratchMemory_l412_172) || when_BankedScratchMemory_l412_173) || when_BankedScratchMemory_l412_174) || when_BankedScratchMemory_l412_175) || when_BankedScratchMemory_l412_176) || when_BankedScratchMemory_l412_177) || when_BankedScratchMemory_l412_178) || when_BankedScratchMemory_l412_179);
  assign _zz_fwdValuGap2Valid_0_7 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_196) || when_BankedScratchMemory_l412_197) || when_BankedScratchMemory_l412_198) || when_BankedScratchMemory_l412_199) || when_BankedScratchMemory_l412_200) || when_BankedScratchMemory_l412_201) || when_BankedScratchMemory_l412_202) || when_BankedScratchMemory_l412_203) || when_BankedScratchMemory_l412_204) || when_BankedScratchMemory_l412_205) || when_BankedScratchMemory_l412_206) || when_BankedScratchMemory_l412_207);
  assign _zz_fwdValuGap2Valid_1_0 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_224) || when_BankedScratchMemory_l412_225) || when_BankedScratchMemory_l412_226) || when_BankedScratchMemory_l412_227) || when_BankedScratchMemory_l412_228) || when_BankedScratchMemory_l412_229) || when_BankedScratchMemory_l412_230) || when_BankedScratchMemory_l412_231) || when_BankedScratchMemory_l412_232) || when_BankedScratchMemory_l412_233) || when_BankedScratchMemory_l412_234) || when_BankedScratchMemory_l412_235);
  assign _zz_fwdValuGap2Valid_1_1 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_252) || when_BankedScratchMemory_l412_253) || when_BankedScratchMemory_l412_254) || when_BankedScratchMemory_l412_255) || when_BankedScratchMemory_l412_256) || when_BankedScratchMemory_l412_257) || when_BankedScratchMemory_l412_258) || when_BankedScratchMemory_l412_259) || when_BankedScratchMemory_l412_260) || when_BankedScratchMemory_l412_261) || when_BankedScratchMemory_l412_262) || when_BankedScratchMemory_l412_263);
  assign _zz_fwdValuGap2Valid_1_2 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_280) || when_BankedScratchMemory_l412_281) || when_BankedScratchMemory_l412_282) || when_BankedScratchMemory_l412_283) || when_BankedScratchMemory_l412_284) || when_BankedScratchMemory_l412_285) || when_BankedScratchMemory_l412_286) || when_BankedScratchMemory_l412_287) || when_BankedScratchMemory_l412_288) || when_BankedScratchMemory_l412_289) || when_BankedScratchMemory_l412_290) || when_BankedScratchMemory_l412_291);
  assign _zz_fwdValuGap2Valid_1_3 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_308) || when_BankedScratchMemory_l412_309) || when_BankedScratchMemory_l412_310) || when_BankedScratchMemory_l412_311) || when_BankedScratchMemory_l412_312) || when_BankedScratchMemory_l412_313) || when_BankedScratchMemory_l412_314) || when_BankedScratchMemory_l412_315) || when_BankedScratchMemory_l412_316) || when_BankedScratchMemory_l412_317) || when_BankedScratchMemory_l412_318) || when_BankedScratchMemory_l412_319);
  assign _zz_fwdValuGap2Valid_1_4 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_336) || when_BankedScratchMemory_l412_337) || when_BankedScratchMemory_l412_338) || when_BankedScratchMemory_l412_339) || when_BankedScratchMemory_l412_340) || when_BankedScratchMemory_l412_341) || when_BankedScratchMemory_l412_342) || when_BankedScratchMemory_l412_343) || when_BankedScratchMemory_l412_344) || when_BankedScratchMemory_l412_345) || when_BankedScratchMemory_l412_346) || when_BankedScratchMemory_l412_347);
  assign _zz_fwdValuGap2Valid_1_5 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_364) || when_BankedScratchMemory_l412_365) || when_BankedScratchMemory_l412_366) || when_BankedScratchMemory_l412_367) || when_BankedScratchMemory_l412_368) || when_BankedScratchMemory_l412_369) || when_BankedScratchMemory_l412_370) || when_BankedScratchMemory_l412_371) || when_BankedScratchMemory_l412_372) || when_BankedScratchMemory_l412_373) || when_BankedScratchMemory_l412_374) || when_BankedScratchMemory_l412_375);
  assign _zz_fwdValuGap2Valid_1_6 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_392) || when_BankedScratchMemory_l412_393) || when_BankedScratchMemory_l412_394) || when_BankedScratchMemory_l412_395) || when_BankedScratchMemory_l412_396) || when_BankedScratchMemory_l412_397) || when_BankedScratchMemory_l412_398) || when_BankedScratchMemory_l412_399) || when_BankedScratchMemory_l412_400) || when_BankedScratchMemory_l412_401) || when_BankedScratchMemory_l412_402) || when_BankedScratchMemory_l412_403);
  assign _zz_fwdValuGap2Valid_1_7 = ((((((((((((1'b0 || when_BankedScratchMemory_l412_420) || when_BankedScratchMemory_l412_421) || when_BankedScratchMemory_l412_422) || when_BankedScratchMemory_l412_423) || when_BankedScratchMemory_l412_424) || when_BankedScratchMemory_l412_425) || when_BankedScratchMemory_l412_426) || when_BankedScratchMemory_l412_427) || when_BankedScratchMemory_l412_428) || when_BankedScratchMemory_l412_429) || when_BankedScratchMemory_l412_430) || when_BankedScratchMemory_l412_431);
  TdpBank banks_0 (
    .io_aAddr   (banks_0_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_0_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_0_io_aRdData[31:0]), //o
    .io_bAddr   (banks_0_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_0_io_bEn          ), //i
    .io_bWe     (banks_0_io_bWe          ), //i
    .io_bWrData (banks_0_io_bWrData[31:0]), //i
    .io_bRdData (banks_0_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  TdpBank banks_1 (
    .io_aAddr   (banks_1_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_1_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_1_io_aRdData[31:0]), //o
    .io_bAddr   (banks_1_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_1_io_bEn          ), //i
    .io_bWe     (banks_1_io_bWe          ), //i
    .io_bWrData (banks_1_io_bWrData[31:0]), //i
    .io_bRdData (banks_1_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  TdpBank banks_2 (
    .io_aAddr   (banks_2_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_2_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_2_io_aRdData[31:0]), //o
    .io_bAddr   (banks_2_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_2_io_bEn          ), //i
    .io_bWe     (banks_2_io_bWe          ), //i
    .io_bWrData (banks_2_io_bWrData[31:0]), //i
    .io_bRdData (banks_2_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  TdpBank banks_3 (
    .io_aAddr   (banks_3_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_3_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_3_io_aRdData[31:0]), //o
    .io_bAddr   (banks_3_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_3_io_bEn          ), //i
    .io_bWe     (banks_3_io_bWe          ), //i
    .io_bWrData (banks_3_io_bWrData[31:0]), //i
    .io_bRdData (banks_3_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  TdpBank banks_4 (
    .io_aAddr   (banks_4_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_4_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_4_io_aRdData[31:0]), //o
    .io_bAddr   (banks_4_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_4_io_bEn          ), //i
    .io_bWe     (banks_4_io_bWe          ), //i
    .io_bWrData (banks_4_io_bWrData[31:0]), //i
    .io_bRdData (banks_4_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  TdpBank banks_5 (
    .io_aAddr   (banks_5_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_5_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_5_io_aRdData[31:0]), //o
    .io_bAddr   (banks_5_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_5_io_bEn          ), //i
    .io_bWe     (banks_5_io_bWe          ), //i
    .io_bWrData (banks_5_io_bWrData[31:0]), //i
    .io_bRdData (banks_5_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  TdpBank banks_6 (
    .io_aAddr   (banks_6_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_6_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_6_io_aRdData[31:0]), //o
    .io_bAddr   (banks_6_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_6_io_bEn          ), //i
    .io_bWe     (banks_6_io_bWe          ), //i
    .io_bWrData (banks_6_io_bWrData[31:0]), //i
    .io_bRdData (banks_6_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  TdpBank banks_7 (
    .io_aAddr   (banks_7_io_aAddr[7:0]   ), //i
    .io_aEn     (banks_7_io_aEn          ), //i
    .io_aWe     (1'b0                    ), //i
    .io_aWrData (32'h0                   ), //i
    .io_aRdData (banks_7_io_aRdData[31:0]), //o
    .io_bAddr   (banks_7_io_bAddr[7:0]   ), //i
    .io_bEn     (banks_7_io_bEn          ), //i
    .io_bWe     (banks_7_io_bWe          ), //i
    .io_bWrData (banks_7_io_bWrData[31:0]), //i
    .io_bRdData (banks_7_io_bRdData[31:0]), //o
    .clk        (clk                     ), //i
    .reset      (reset                   )  //i
  );
  always @(*) begin
    banks_0_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228) begin
      banks_0_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_1) begin
      banks_0_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_2) begin
      banks_0_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_3) begin
      banks_0_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_4) begin
      banks_0_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_5) begin
      banks_0_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_6) begin
      banks_0_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_7) begin
      banks_0_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_8) begin
      banks_0_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_8) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_16) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_24) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_32) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_40) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_48) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_56) begin
      if(io_vectorReadActive) begin
        banks_0_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_0_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_1) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_2) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_3) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_4) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_5) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_6) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_7) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_8) begin
      banks_0_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_8) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_16) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_24) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_32) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_40) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_48) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_56) begin
      if(io_vectorReadActive) begin
        banks_0_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_0_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171) begin
        banks_0_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_8) begin
        banks_0_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_16) begin
        banks_0_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_24) begin
        banks_0_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_32) begin
        banks_0_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_40) begin
        banks_0_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_48) begin
        banks_0_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_56) begin
        banks_0_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_64) begin
        banks_0_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_72) begin
        banks_0_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_80) begin
        banks_0_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_88) begin
        banks_0_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_96) begin
        banks_0_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_104) begin
        banks_0_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_112) begin
        banks_0_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_120) begin
        banks_0_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_128) begin
        banks_0_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_136) begin
        banks_0_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_144) begin
        banks_0_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_152) begin
        banks_0_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_160) begin
        banks_0_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_168) begin
        banks_0_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_176) begin
        banks_0_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_184) begin
        banks_0_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_192) begin
        banks_0_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_200) begin
        banks_0_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_208) begin
        banks_0_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_216) begin
        banks_0_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234) begin
      banks_0_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_1) begin
      banks_0_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_2) begin
      banks_0_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_3) begin
      banks_0_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_4) begin
      banks_0_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_5) begin
      banks_0_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_6) begin
      banks_0_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_7) begin
      banks_0_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_8) begin
      banks_0_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_64) begin
      if(when_BankedScratchMemory_l295) begin
        banks_0_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_72) begin
      if(when_BankedScratchMemory_l295_8) begin
        banks_0_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_80) begin
      if(when_BankedScratchMemory_l295_16) begin
        banks_0_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_88) begin
      if(when_BankedScratchMemory_l295_24) begin
        banks_0_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_96) begin
      if(when_BankedScratchMemory_l295_32) begin
        banks_0_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_104) begin
      if(when_BankedScratchMemory_l295_40) begin
        banks_0_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_112) begin
      if(when_BankedScratchMemory_l295_48) begin
        banks_0_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_120) begin
      if(when_BankedScratchMemory_l295_56) begin
        banks_0_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_0_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_8) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_16) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_24) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_32) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_40) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_48) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_56) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_64) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_72) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_80) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_88) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_96) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_104) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_112) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_120) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_128) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_136) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_144) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_152) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_160) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_168) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_176) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_184) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_192) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_200) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_208) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_216) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_1) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_2) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_3) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_4) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_5) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_6) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_7) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_8) begin
      banks_0_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_64) begin
      if(when_BankedScratchMemory_l295) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_72) begin
      if(when_BankedScratchMemory_l295_8) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_80) begin
      if(when_BankedScratchMemory_l295_16) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_88) begin
      if(when_BankedScratchMemory_l295_24) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_96) begin
      if(when_BankedScratchMemory_l295_32) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_104) begin
      if(when_BankedScratchMemory_l295_40) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_112) begin
      if(when_BankedScratchMemory_l295_48) begin
        banks_0_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_120) begin
      if(when_BankedScratchMemory_l295_56) begin
        banks_0_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_0_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_8) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_16) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_24) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_32) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_40) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_48) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_56) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_64) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_72) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_80) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_88) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_96) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_104) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_112) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_120) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_128) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_136) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_144) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_152) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_160) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_168) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_176) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_184) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_192) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_200) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_208) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_216) begin
        banks_0_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_1) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_2) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_3) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_4) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_5) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_6) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_7) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_8) begin
      banks_0_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_64) begin
      if(when_BankedScratchMemory_l295) begin
        banks_0_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_72) begin
      if(when_BankedScratchMemory_l295_8) begin
        banks_0_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_80) begin
      if(when_BankedScratchMemory_l295_16) begin
        banks_0_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_88) begin
      if(when_BankedScratchMemory_l295_24) begin
        banks_0_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_96) begin
      if(when_BankedScratchMemory_l295_32) begin
        banks_0_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_104) begin
      if(when_BankedScratchMemory_l295_40) begin
        banks_0_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_112) begin
      if(when_BankedScratchMemory_l295_48) begin
        banks_0_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_120) begin
      if(when_BankedScratchMemory_l295_56) begin
        banks_0_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_0_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171) begin
        banks_0_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_8) begin
        banks_0_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_16) begin
        banks_0_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_24) begin
        banks_0_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_32) begin
        banks_0_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_40) begin
        banks_0_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_48) begin
        banks_0_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_56) begin
        banks_0_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_64) begin
        banks_0_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_72) begin
        banks_0_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_80) begin
        banks_0_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_88) begin
        banks_0_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_96) begin
        banks_0_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_104) begin
        banks_0_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_112) begin
        banks_0_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_120) begin
        banks_0_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_128) begin
        banks_0_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_136) begin
        banks_0_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_144) begin
        banks_0_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_152) begin
        banks_0_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_160) begin
        banks_0_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_168) begin
        banks_0_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_176) begin
        banks_0_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_184) begin
        banks_0_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_192) begin
        banks_0_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_200) begin
        banks_0_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_208) begin
        banks_0_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_216) begin
        banks_0_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    banks_1_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228_9) begin
      banks_1_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_10) begin
      banks_1_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_11) begin
      banks_1_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_12) begin
      banks_1_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_13) begin
      banks_1_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_14) begin
      banks_1_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_15) begin
      banks_1_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_16) begin
      banks_1_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_17) begin
      banks_1_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_1) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_9) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_17) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_25) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_33) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_41) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_49) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_57) begin
      if(io_vectorReadActive) begin
        banks_1_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_1_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228_9) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_10) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_11) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_12) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_13) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_14) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_15) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_16) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_17) begin
      banks_1_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_1) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_9) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_17) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_25) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_33) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_41) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_49) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_57) begin
      if(io_vectorReadActive) begin
        banks_1_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_1_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_1) begin
        banks_1_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_9) begin
        banks_1_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_17) begin
        banks_1_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_25) begin
        banks_1_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_33) begin
        banks_1_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_41) begin
        banks_1_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_49) begin
        banks_1_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_57) begin
        banks_1_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_65) begin
        banks_1_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_73) begin
        banks_1_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_81) begin
        banks_1_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_89) begin
        banks_1_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_97) begin
        banks_1_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_105) begin
        banks_1_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_113) begin
        banks_1_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_121) begin
        banks_1_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_129) begin
        banks_1_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_137) begin
        banks_1_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_145) begin
        banks_1_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_153) begin
        banks_1_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_161) begin
        banks_1_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_169) begin
        banks_1_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_177) begin
        banks_1_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_185) begin
        banks_1_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_193) begin
        banks_1_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_201) begin
        banks_1_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_209) begin
        banks_1_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_217) begin
        banks_1_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234_9) begin
      banks_1_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_10) begin
      banks_1_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_11) begin
      banks_1_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_12) begin
      banks_1_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_13) begin
      banks_1_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_14) begin
      banks_1_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_15) begin
      banks_1_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_16) begin
      banks_1_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_17) begin
      banks_1_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_65) begin
      if(when_BankedScratchMemory_l295_1) begin
        banks_1_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_73) begin
      if(when_BankedScratchMemory_l295_9) begin
        banks_1_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_81) begin
      if(when_BankedScratchMemory_l295_17) begin
        banks_1_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_89) begin
      if(when_BankedScratchMemory_l295_25) begin
        banks_1_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_97) begin
      if(when_BankedScratchMemory_l295_33) begin
        banks_1_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_105) begin
      if(when_BankedScratchMemory_l295_41) begin
        banks_1_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_113) begin
      if(when_BankedScratchMemory_l295_49) begin
        banks_1_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_121) begin
      if(when_BankedScratchMemory_l295_57) begin
        banks_1_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_1_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_1) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_9) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_17) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_25) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_33) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_41) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_49) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_57) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_65) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_73) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_81) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_89) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_97) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_105) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_113) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_121) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_129) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_137) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_145) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_153) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_161) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_169) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_177) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_185) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_193) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_201) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_209) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_217) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_9) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_10) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_11) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_12) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_13) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_14) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_15) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_16) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_17) begin
      banks_1_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_65) begin
      if(when_BankedScratchMemory_l295_1) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_73) begin
      if(when_BankedScratchMemory_l295_9) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_81) begin
      if(when_BankedScratchMemory_l295_17) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_89) begin
      if(when_BankedScratchMemory_l295_25) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_97) begin
      if(when_BankedScratchMemory_l295_33) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_105) begin
      if(when_BankedScratchMemory_l295_41) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_113) begin
      if(when_BankedScratchMemory_l295_49) begin
        banks_1_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_121) begin
      if(when_BankedScratchMemory_l295_57) begin
        banks_1_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_1_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_1) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_9) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_17) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_25) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_33) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_41) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_49) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_57) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_65) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_73) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_81) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_89) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_97) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_105) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_113) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_121) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_129) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_137) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_145) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_153) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_161) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_169) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_177) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_185) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_193) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_201) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_209) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_217) begin
        banks_1_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_9) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_10) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_11) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_12) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_13) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_14) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_15) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_16) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_17) begin
      banks_1_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_65) begin
      if(when_BankedScratchMemory_l295_1) begin
        banks_1_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_73) begin
      if(when_BankedScratchMemory_l295_9) begin
        banks_1_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_81) begin
      if(when_BankedScratchMemory_l295_17) begin
        banks_1_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_89) begin
      if(when_BankedScratchMemory_l295_25) begin
        banks_1_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_97) begin
      if(when_BankedScratchMemory_l295_33) begin
        banks_1_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_105) begin
      if(when_BankedScratchMemory_l295_41) begin
        banks_1_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_113) begin
      if(when_BankedScratchMemory_l295_49) begin
        banks_1_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_121) begin
      if(when_BankedScratchMemory_l295_57) begin
        banks_1_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_1_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_1) begin
        banks_1_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_9) begin
        banks_1_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_17) begin
        banks_1_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_25) begin
        banks_1_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_33) begin
        banks_1_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_41) begin
        banks_1_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_49) begin
        banks_1_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_57) begin
        banks_1_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_65) begin
        banks_1_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_73) begin
        banks_1_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_81) begin
        banks_1_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_89) begin
        banks_1_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_97) begin
        banks_1_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_105) begin
        banks_1_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_113) begin
        banks_1_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_121) begin
        banks_1_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_129) begin
        banks_1_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_137) begin
        banks_1_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_145) begin
        banks_1_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_153) begin
        banks_1_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_161) begin
        banks_1_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_169) begin
        banks_1_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_177) begin
        banks_1_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_185) begin
        banks_1_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_193) begin
        banks_1_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_201) begin
        banks_1_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_209) begin
        banks_1_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_217) begin
        banks_1_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    banks_2_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228_18) begin
      banks_2_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_19) begin
      banks_2_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_20) begin
      banks_2_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_21) begin
      banks_2_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_22) begin
      banks_2_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_23) begin
      banks_2_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_24) begin
      banks_2_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_25) begin
      banks_2_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_26) begin
      banks_2_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_2) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_10) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_18) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_26) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_34) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_42) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_50) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_58) begin
      if(io_vectorReadActive) begin
        banks_2_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_2_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228_18) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_19) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_20) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_21) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_22) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_23) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_24) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_25) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_26) begin
      banks_2_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_2) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_10) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_18) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_26) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_34) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_42) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_50) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_58) begin
      if(io_vectorReadActive) begin
        banks_2_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_2_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_2) begin
        banks_2_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_10) begin
        banks_2_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_18) begin
        banks_2_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_26) begin
        banks_2_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_34) begin
        banks_2_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_42) begin
        banks_2_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_50) begin
        banks_2_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_58) begin
        banks_2_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_66) begin
        banks_2_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_74) begin
        banks_2_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_82) begin
        banks_2_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_90) begin
        banks_2_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_98) begin
        banks_2_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_106) begin
        banks_2_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_114) begin
        banks_2_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_122) begin
        banks_2_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_130) begin
        banks_2_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_138) begin
        banks_2_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_146) begin
        banks_2_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_154) begin
        banks_2_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_162) begin
        banks_2_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_170) begin
        banks_2_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_178) begin
        banks_2_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_186) begin
        banks_2_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_194) begin
        banks_2_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_202) begin
        banks_2_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_210) begin
        banks_2_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_218) begin
        banks_2_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234_18) begin
      banks_2_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_19) begin
      banks_2_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_20) begin
      banks_2_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_21) begin
      banks_2_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_22) begin
      banks_2_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_23) begin
      banks_2_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_24) begin
      banks_2_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_25) begin
      banks_2_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_26) begin
      banks_2_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_66) begin
      if(when_BankedScratchMemory_l295_2) begin
        banks_2_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_74) begin
      if(when_BankedScratchMemory_l295_10) begin
        banks_2_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_82) begin
      if(when_BankedScratchMemory_l295_18) begin
        banks_2_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_90) begin
      if(when_BankedScratchMemory_l295_26) begin
        banks_2_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_98) begin
      if(when_BankedScratchMemory_l295_34) begin
        banks_2_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_106) begin
      if(when_BankedScratchMemory_l295_42) begin
        banks_2_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_114) begin
      if(when_BankedScratchMemory_l295_50) begin
        banks_2_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_122) begin
      if(when_BankedScratchMemory_l295_58) begin
        banks_2_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_2_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_2) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_10) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_18) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_26) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_34) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_42) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_50) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_58) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_66) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_74) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_82) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_90) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_98) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_106) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_114) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_122) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_130) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_138) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_146) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_154) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_162) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_170) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_178) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_186) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_194) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_202) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_210) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_218) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_18) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_19) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_20) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_21) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_22) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_23) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_24) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_25) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_26) begin
      banks_2_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_66) begin
      if(when_BankedScratchMemory_l295_2) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_74) begin
      if(when_BankedScratchMemory_l295_10) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_82) begin
      if(when_BankedScratchMemory_l295_18) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_90) begin
      if(when_BankedScratchMemory_l295_26) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_98) begin
      if(when_BankedScratchMemory_l295_34) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_106) begin
      if(when_BankedScratchMemory_l295_42) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_114) begin
      if(when_BankedScratchMemory_l295_50) begin
        banks_2_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_122) begin
      if(when_BankedScratchMemory_l295_58) begin
        banks_2_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_2_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_2) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_10) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_18) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_26) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_34) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_42) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_50) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_58) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_66) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_74) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_82) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_90) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_98) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_106) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_114) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_122) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_130) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_138) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_146) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_154) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_162) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_170) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_178) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_186) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_194) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_202) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_210) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_218) begin
        banks_2_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_18) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_19) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_20) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_21) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_22) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_23) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_24) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_25) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_26) begin
      banks_2_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_66) begin
      if(when_BankedScratchMemory_l295_2) begin
        banks_2_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_74) begin
      if(when_BankedScratchMemory_l295_10) begin
        banks_2_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_82) begin
      if(when_BankedScratchMemory_l295_18) begin
        banks_2_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_90) begin
      if(when_BankedScratchMemory_l295_26) begin
        banks_2_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_98) begin
      if(when_BankedScratchMemory_l295_34) begin
        banks_2_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_106) begin
      if(when_BankedScratchMemory_l295_42) begin
        banks_2_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_114) begin
      if(when_BankedScratchMemory_l295_50) begin
        banks_2_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_122) begin
      if(when_BankedScratchMemory_l295_58) begin
        banks_2_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_2_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_2) begin
        banks_2_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_10) begin
        banks_2_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_18) begin
        banks_2_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_26) begin
        banks_2_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_34) begin
        banks_2_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_42) begin
        banks_2_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_50) begin
        banks_2_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_58) begin
        banks_2_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_66) begin
        banks_2_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_74) begin
        banks_2_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_82) begin
        banks_2_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_90) begin
        banks_2_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_98) begin
        banks_2_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_106) begin
        banks_2_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_114) begin
        banks_2_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_122) begin
        banks_2_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_130) begin
        banks_2_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_138) begin
        banks_2_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_146) begin
        banks_2_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_154) begin
        banks_2_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_162) begin
        banks_2_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_170) begin
        banks_2_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_178) begin
        banks_2_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_186) begin
        banks_2_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_194) begin
        banks_2_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_202) begin
        banks_2_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_210) begin
        banks_2_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_218) begin
        banks_2_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    banks_3_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228_27) begin
      banks_3_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_28) begin
      banks_3_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_29) begin
      banks_3_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_30) begin
      banks_3_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_31) begin
      banks_3_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_32) begin
      banks_3_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_33) begin
      banks_3_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_34) begin
      banks_3_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_35) begin
      banks_3_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_3) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_11) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_19) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_27) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_35) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_43) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_51) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_59) begin
      if(io_vectorReadActive) begin
        banks_3_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_3_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228_27) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_28) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_29) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_30) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_31) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_32) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_33) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_34) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_35) begin
      banks_3_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_3) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_11) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_19) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_27) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_35) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_43) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_51) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_59) begin
      if(io_vectorReadActive) begin
        banks_3_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_3_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_3) begin
        banks_3_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_11) begin
        banks_3_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_19) begin
        banks_3_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_27) begin
        banks_3_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_35) begin
        banks_3_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_43) begin
        banks_3_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_51) begin
        banks_3_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_59) begin
        banks_3_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_67) begin
        banks_3_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_75) begin
        banks_3_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_83) begin
        banks_3_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_91) begin
        banks_3_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_99) begin
        banks_3_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_107) begin
        banks_3_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_115) begin
        banks_3_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_123) begin
        banks_3_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_131) begin
        banks_3_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_139) begin
        banks_3_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_147) begin
        banks_3_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_155) begin
        banks_3_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_163) begin
        banks_3_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_171) begin
        banks_3_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_179) begin
        banks_3_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_187) begin
        banks_3_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_195) begin
        banks_3_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_203) begin
        banks_3_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_211) begin
        banks_3_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_219) begin
        banks_3_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234_27) begin
      banks_3_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_28) begin
      banks_3_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_29) begin
      banks_3_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_30) begin
      banks_3_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_31) begin
      banks_3_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_32) begin
      banks_3_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_33) begin
      banks_3_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_34) begin
      banks_3_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_35) begin
      banks_3_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_67) begin
      if(when_BankedScratchMemory_l295_3) begin
        banks_3_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_75) begin
      if(when_BankedScratchMemory_l295_11) begin
        banks_3_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_83) begin
      if(when_BankedScratchMemory_l295_19) begin
        banks_3_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_91) begin
      if(when_BankedScratchMemory_l295_27) begin
        banks_3_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_99) begin
      if(when_BankedScratchMemory_l295_35) begin
        banks_3_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_107) begin
      if(when_BankedScratchMemory_l295_43) begin
        banks_3_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_115) begin
      if(when_BankedScratchMemory_l295_51) begin
        banks_3_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_123) begin
      if(when_BankedScratchMemory_l295_59) begin
        banks_3_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_3_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_3) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_11) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_19) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_27) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_35) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_43) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_51) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_59) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_67) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_75) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_83) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_91) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_99) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_107) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_115) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_123) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_131) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_139) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_147) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_155) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_163) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_171) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_179) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_187) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_195) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_203) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_211) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_219) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_27) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_28) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_29) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_30) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_31) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_32) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_33) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_34) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_35) begin
      banks_3_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_67) begin
      if(when_BankedScratchMemory_l295_3) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_75) begin
      if(when_BankedScratchMemory_l295_11) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_83) begin
      if(when_BankedScratchMemory_l295_19) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_91) begin
      if(when_BankedScratchMemory_l295_27) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_99) begin
      if(when_BankedScratchMemory_l295_35) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_107) begin
      if(when_BankedScratchMemory_l295_43) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_115) begin
      if(when_BankedScratchMemory_l295_51) begin
        banks_3_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_123) begin
      if(when_BankedScratchMemory_l295_59) begin
        banks_3_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_3_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_3) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_11) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_19) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_27) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_35) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_43) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_51) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_59) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_67) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_75) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_83) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_91) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_99) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_107) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_115) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_123) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_131) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_139) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_147) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_155) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_163) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_171) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_179) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_187) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_195) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_203) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_211) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_219) begin
        banks_3_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_27) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_28) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_29) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_30) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_31) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_32) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_33) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_34) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_35) begin
      banks_3_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_67) begin
      if(when_BankedScratchMemory_l295_3) begin
        banks_3_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_75) begin
      if(when_BankedScratchMemory_l295_11) begin
        banks_3_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_83) begin
      if(when_BankedScratchMemory_l295_19) begin
        banks_3_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_91) begin
      if(when_BankedScratchMemory_l295_27) begin
        banks_3_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_99) begin
      if(when_BankedScratchMemory_l295_35) begin
        banks_3_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_107) begin
      if(when_BankedScratchMemory_l295_43) begin
        banks_3_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_115) begin
      if(when_BankedScratchMemory_l295_51) begin
        banks_3_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_123) begin
      if(when_BankedScratchMemory_l295_59) begin
        banks_3_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_3_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_3) begin
        banks_3_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_11) begin
        banks_3_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_19) begin
        banks_3_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_27) begin
        banks_3_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_35) begin
        banks_3_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_43) begin
        banks_3_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_51) begin
        banks_3_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_59) begin
        banks_3_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_67) begin
        banks_3_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_75) begin
        banks_3_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_83) begin
        banks_3_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_91) begin
        banks_3_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_99) begin
        banks_3_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_107) begin
        banks_3_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_115) begin
        banks_3_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_123) begin
        banks_3_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_131) begin
        banks_3_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_139) begin
        banks_3_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_147) begin
        banks_3_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_155) begin
        banks_3_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_163) begin
        banks_3_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_171) begin
        banks_3_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_179) begin
        banks_3_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_187) begin
        banks_3_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_195) begin
        banks_3_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_203) begin
        banks_3_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_211) begin
        banks_3_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_219) begin
        banks_3_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    banks_4_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228_36) begin
      banks_4_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_37) begin
      banks_4_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_38) begin
      banks_4_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_39) begin
      banks_4_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_40) begin
      banks_4_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_41) begin
      banks_4_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_42) begin
      banks_4_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_43) begin
      banks_4_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_44) begin
      banks_4_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_4) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_12) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_20) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_28) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_36) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_44) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_52) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_60) begin
      if(io_vectorReadActive) begin
        banks_4_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_4_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228_36) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_37) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_38) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_39) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_40) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_41) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_42) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_43) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_44) begin
      banks_4_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_4) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_12) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_20) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_28) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_36) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_44) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_52) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_60) begin
      if(io_vectorReadActive) begin
        banks_4_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_4_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_4) begin
        banks_4_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_12) begin
        banks_4_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_20) begin
        banks_4_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_28) begin
        banks_4_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_36) begin
        banks_4_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_44) begin
        banks_4_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_52) begin
        banks_4_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_60) begin
        banks_4_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_68) begin
        banks_4_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_76) begin
        banks_4_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_84) begin
        banks_4_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_92) begin
        banks_4_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_100) begin
        banks_4_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_108) begin
        banks_4_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_116) begin
        banks_4_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_124) begin
        banks_4_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_132) begin
        banks_4_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_140) begin
        banks_4_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_148) begin
        banks_4_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_156) begin
        banks_4_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_164) begin
        banks_4_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_172) begin
        banks_4_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_180) begin
        banks_4_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_188) begin
        banks_4_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_196) begin
        banks_4_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_204) begin
        banks_4_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_212) begin
        banks_4_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_220) begin
        banks_4_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234_36) begin
      banks_4_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_37) begin
      banks_4_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_38) begin
      banks_4_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_39) begin
      banks_4_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_40) begin
      banks_4_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_41) begin
      banks_4_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_42) begin
      banks_4_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_43) begin
      banks_4_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_44) begin
      banks_4_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_68) begin
      if(when_BankedScratchMemory_l295_4) begin
        banks_4_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_76) begin
      if(when_BankedScratchMemory_l295_12) begin
        banks_4_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_84) begin
      if(when_BankedScratchMemory_l295_20) begin
        banks_4_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_92) begin
      if(when_BankedScratchMemory_l295_28) begin
        banks_4_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_100) begin
      if(when_BankedScratchMemory_l295_36) begin
        banks_4_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_108) begin
      if(when_BankedScratchMemory_l295_44) begin
        banks_4_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_116) begin
      if(when_BankedScratchMemory_l295_52) begin
        banks_4_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_124) begin
      if(when_BankedScratchMemory_l295_60) begin
        banks_4_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_4_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_4) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_12) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_20) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_28) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_36) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_44) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_52) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_60) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_68) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_76) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_84) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_92) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_100) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_108) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_116) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_124) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_132) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_140) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_148) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_156) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_164) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_172) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_180) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_188) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_196) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_204) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_212) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_220) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_36) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_37) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_38) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_39) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_40) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_41) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_42) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_43) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_44) begin
      banks_4_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_68) begin
      if(when_BankedScratchMemory_l295_4) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_76) begin
      if(when_BankedScratchMemory_l295_12) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_84) begin
      if(when_BankedScratchMemory_l295_20) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_92) begin
      if(when_BankedScratchMemory_l295_28) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_100) begin
      if(when_BankedScratchMemory_l295_36) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_108) begin
      if(when_BankedScratchMemory_l295_44) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_116) begin
      if(when_BankedScratchMemory_l295_52) begin
        banks_4_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_124) begin
      if(when_BankedScratchMemory_l295_60) begin
        banks_4_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_4_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_4) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_12) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_20) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_28) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_36) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_44) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_52) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_60) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_68) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_76) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_84) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_92) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_100) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_108) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_116) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_124) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_132) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_140) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_148) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_156) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_164) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_172) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_180) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_188) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_196) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_204) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_212) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_220) begin
        banks_4_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_36) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_37) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_38) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_39) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_40) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_41) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_42) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_43) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_44) begin
      banks_4_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_68) begin
      if(when_BankedScratchMemory_l295_4) begin
        banks_4_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_76) begin
      if(when_BankedScratchMemory_l295_12) begin
        banks_4_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_84) begin
      if(when_BankedScratchMemory_l295_20) begin
        banks_4_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_92) begin
      if(when_BankedScratchMemory_l295_28) begin
        banks_4_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_100) begin
      if(when_BankedScratchMemory_l295_36) begin
        banks_4_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_108) begin
      if(when_BankedScratchMemory_l295_44) begin
        banks_4_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_116) begin
      if(when_BankedScratchMemory_l295_52) begin
        banks_4_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_124) begin
      if(when_BankedScratchMemory_l295_60) begin
        banks_4_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_4_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_4) begin
        banks_4_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_12) begin
        banks_4_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_20) begin
        banks_4_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_28) begin
        banks_4_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_36) begin
        banks_4_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_44) begin
        banks_4_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_52) begin
        banks_4_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_60) begin
        banks_4_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_68) begin
        banks_4_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_76) begin
        banks_4_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_84) begin
        banks_4_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_92) begin
        banks_4_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_100) begin
        banks_4_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_108) begin
        banks_4_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_116) begin
        banks_4_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_124) begin
        banks_4_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_132) begin
        banks_4_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_140) begin
        banks_4_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_148) begin
        banks_4_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_156) begin
        banks_4_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_164) begin
        banks_4_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_172) begin
        banks_4_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_180) begin
        banks_4_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_188) begin
        banks_4_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_196) begin
        banks_4_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_204) begin
        banks_4_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_212) begin
        banks_4_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_220) begin
        banks_4_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    banks_5_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228_45) begin
      banks_5_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_46) begin
      banks_5_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_47) begin
      banks_5_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_48) begin
      banks_5_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_49) begin
      banks_5_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_50) begin
      banks_5_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_51) begin
      banks_5_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_52) begin
      banks_5_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_53) begin
      banks_5_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_5) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_13) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_21) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_29) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_37) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_45) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_53) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_61) begin
      if(io_vectorReadActive) begin
        banks_5_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_5_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228_45) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_46) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_47) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_48) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_49) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_50) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_51) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_52) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_53) begin
      banks_5_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_5) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_13) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_21) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_29) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_37) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_45) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_53) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_61) begin
      if(io_vectorReadActive) begin
        banks_5_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_5_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_5) begin
        banks_5_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_13) begin
        banks_5_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_21) begin
        banks_5_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_29) begin
        banks_5_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_37) begin
        banks_5_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_45) begin
        banks_5_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_53) begin
        banks_5_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_61) begin
        banks_5_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_69) begin
        banks_5_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_77) begin
        banks_5_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_85) begin
        banks_5_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_93) begin
        banks_5_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_101) begin
        banks_5_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_109) begin
        banks_5_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_117) begin
        banks_5_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_125) begin
        banks_5_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_133) begin
        banks_5_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_141) begin
        banks_5_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_149) begin
        banks_5_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_157) begin
        banks_5_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_165) begin
        banks_5_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_173) begin
        banks_5_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_181) begin
        banks_5_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_189) begin
        banks_5_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_197) begin
        banks_5_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_205) begin
        banks_5_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_213) begin
        banks_5_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_221) begin
        banks_5_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234_45) begin
      banks_5_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_46) begin
      banks_5_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_47) begin
      banks_5_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_48) begin
      banks_5_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_49) begin
      banks_5_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_50) begin
      banks_5_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_51) begin
      banks_5_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_52) begin
      banks_5_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_53) begin
      banks_5_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_69) begin
      if(when_BankedScratchMemory_l295_5) begin
        banks_5_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_77) begin
      if(when_BankedScratchMemory_l295_13) begin
        banks_5_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_85) begin
      if(when_BankedScratchMemory_l295_21) begin
        banks_5_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_93) begin
      if(when_BankedScratchMemory_l295_29) begin
        banks_5_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_101) begin
      if(when_BankedScratchMemory_l295_37) begin
        banks_5_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_109) begin
      if(when_BankedScratchMemory_l295_45) begin
        banks_5_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_117) begin
      if(when_BankedScratchMemory_l295_53) begin
        banks_5_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_125) begin
      if(when_BankedScratchMemory_l295_61) begin
        banks_5_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_5_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_5) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_13) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_21) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_29) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_37) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_45) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_53) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_61) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_69) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_77) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_85) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_93) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_101) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_109) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_117) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_125) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_133) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_141) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_149) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_157) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_165) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_173) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_181) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_189) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_197) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_205) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_213) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_221) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_45) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_46) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_47) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_48) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_49) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_50) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_51) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_52) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_53) begin
      banks_5_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_69) begin
      if(when_BankedScratchMemory_l295_5) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_77) begin
      if(when_BankedScratchMemory_l295_13) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_85) begin
      if(when_BankedScratchMemory_l295_21) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_93) begin
      if(when_BankedScratchMemory_l295_29) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_101) begin
      if(when_BankedScratchMemory_l295_37) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_109) begin
      if(when_BankedScratchMemory_l295_45) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_117) begin
      if(when_BankedScratchMemory_l295_53) begin
        banks_5_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_125) begin
      if(when_BankedScratchMemory_l295_61) begin
        banks_5_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_5_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_5) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_13) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_21) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_29) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_37) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_45) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_53) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_61) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_69) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_77) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_85) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_93) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_101) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_109) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_117) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_125) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_133) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_141) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_149) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_157) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_165) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_173) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_181) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_189) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_197) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_205) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_213) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_221) begin
        banks_5_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_45) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_46) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_47) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_48) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_49) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_50) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_51) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_52) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_53) begin
      banks_5_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_69) begin
      if(when_BankedScratchMemory_l295_5) begin
        banks_5_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_77) begin
      if(when_BankedScratchMemory_l295_13) begin
        banks_5_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_85) begin
      if(when_BankedScratchMemory_l295_21) begin
        banks_5_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_93) begin
      if(when_BankedScratchMemory_l295_29) begin
        banks_5_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_101) begin
      if(when_BankedScratchMemory_l295_37) begin
        banks_5_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_109) begin
      if(when_BankedScratchMemory_l295_45) begin
        banks_5_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_117) begin
      if(when_BankedScratchMemory_l295_53) begin
        banks_5_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_125) begin
      if(when_BankedScratchMemory_l295_61) begin
        banks_5_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_5_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_5) begin
        banks_5_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_13) begin
        banks_5_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_21) begin
        banks_5_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_29) begin
        banks_5_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_37) begin
        banks_5_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_45) begin
        banks_5_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_53) begin
        banks_5_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_61) begin
        banks_5_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_69) begin
        banks_5_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_77) begin
        banks_5_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_85) begin
        banks_5_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_93) begin
        banks_5_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_101) begin
        banks_5_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_109) begin
        banks_5_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_117) begin
        banks_5_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_125) begin
        banks_5_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_133) begin
        banks_5_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_141) begin
        banks_5_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_149) begin
        banks_5_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_157) begin
        banks_5_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_165) begin
        banks_5_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_173) begin
        banks_5_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_181) begin
        banks_5_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_189) begin
        banks_5_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_197) begin
        banks_5_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_205) begin
        banks_5_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_213) begin
        banks_5_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_221) begin
        banks_5_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    banks_6_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228_54) begin
      banks_6_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_55) begin
      banks_6_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_56) begin
      banks_6_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_57) begin
      banks_6_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_58) begin
      banks_6_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_59) begin
      banks_6_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_60) begin
      banks_6_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_61) begin
      banks_6_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_62) begin
      banks_6_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_6) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_14) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_22) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_30) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_38) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_46) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_54) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_62) begin
      if(io_vectorReadActive) begin
        banks_6_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_6_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228_54) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_55) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_56) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_57) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_58) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_59) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_60) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_61) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_62) begin
      banks_6_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_6) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_14) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_22) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_30) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_38) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_46) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_54) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_62) begin
      if(io_vectorReadActive) begin
        banks_6_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_6_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_6) begin
        banks_6_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_14) begin
        banks_6_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_22) begin
        banks_6_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_30) begin
        banks_6_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_38) begin
        banks_6_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_46) begin
        banks_6_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_54) begin
        banks_6_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_62) begin
        banks_6_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_70) begin
        banks_6_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_78) begin
        banks_6_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_86) begin
        banks_6_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_94) begin
        banks_6_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_102) begin
        banks_6_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_110) begin
        banks_6_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_118) begin
        banks_6_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_126) begin
        banks_6_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_134) begin
        banks_6_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_142) begin
        banks_6_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_150) begin
        banks_6_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_158) begin
        banks_6_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_166) begin
        banks_6_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_174) begin
        banks_6_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_182) begin
        banks_6_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_190) begin
        banks_6_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_198) begin
        banks_6_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_206) begin
        banks_6_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_214) begin
        banks_6_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_222) begin
        banks_6_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234_54) begin
      banks_6_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_55) begin
      banks_6_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_56) begin
      banks_6_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_57) begin
      banks_6_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_58) begin
      banks_6_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_59) begin
      banks_6_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_60) begin
      banks_6_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_61) begin
      banks_6_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_62) begin
      banks_6_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_70) begin
      if(when_BankedScratchMemory_l295_6) begin
        banks_6_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_78) begin
      if(when_BankedScratchMemory_l295_14) begin
        banks_6_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_86) begin
      if(when_BankedScratchMemory_l295_22) begin
        banks_6_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_94) begin
      if(when_BankedScratchMemory_l295_30) begin
        banks_6_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_102) begin
      if(when_BankedScratchMemory_l295_38) begin
        banks_6_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_110) begin
      if(when_BankedScratchMemory_l295_46) begin
        banks_6_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_118) begin
      if(when_BankedScratchMemory_l295_54) begin
        banks_6_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_126) begin
      if(when_BankedScratchMemory_l295_62) begin
        banks_6_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_6_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_6) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_14) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_22) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_30) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_38) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_46) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_54) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_62) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_70) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_78) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_86) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_94) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_102) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_110) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_118) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_126) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_134) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_142) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_150) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_158) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_166) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_174) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_182) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_190) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_198) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_206) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_214) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_222) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_54) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_55) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_56) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_57) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_58) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_59) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_60) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_61) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_62) begin
      banks_6_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_70) begin
      if(when_BankedScratchMemory_l295_6) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_78) begin
      if(when_BankedScratchMemory_l295_14) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_86) begin
      if(when_BankedScratchMemory_l295_22) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_94) begin
      if(when_BankedScratchMemory_l295_30) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_102) begin
      if(when_BankedScratchMemory_l295_38) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_110) begin
      if(when_BankedScratchMemory_l295_46) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_118) begin
      if(when_BankedScratchMemory_l295_54) begin
        banks_6_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_126) begin
      if(when_BankedScratchMemory_l295_62) begin
        banks_6_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_6_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_6) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_14) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_22) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_30) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_38) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_46) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_54) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_62) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_70) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_78) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_86) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_94) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_102) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_110) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_118) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_126) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_134) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_142) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_150) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_158) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_166) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_174) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_182) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_190) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_198) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_206) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_214) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_222) begin
        banks_6_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_54) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_55) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_56) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_57) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_58) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_59) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_60) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_61) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_62) begin
      banks_6_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_70) begin
      if(when_BankedScratchMemory_l295_6) begin
        banks_6_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_78) begin
      if(when_BankedScratchMemory_l295_14) begin
        banks_6_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_86) begin
      if(when_BankedScratchMemory_l295_22) begin
        banks_6_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_94) begin
      if(when_BankedScratchMemory_l295_30) begin
        banks_6_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_102) begin
      if(when_BankedScratchMemory_l295_38) begin
        banks_6_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_110) begin
      if(when_BankedScratchMemory_l295_46) begin
        banks_6_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_118) begin
      if(when_BankedScratchMemory_l295_54) begin
        banks_6_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_126) begin
      if(when_BankedScratchMemory_l295_62) begin
        banks_6_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_6_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_6) begin
        banks_6_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_14) begin
        banks_6_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_22) begin
        banks_6_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_30) begin
        banks_6_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_38) begin
        banks_6_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_46) begin
        banks_6_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_54) begin
        banks_6_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_62) begin
        banks_6_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_70) begin
        banks_6_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_78) begin
        banks_6_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_86) begin
        banks_6_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_94) begin
        banks_6_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_102) begin
        banks_6_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_110) begin
        banks_6_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_118) begin
        banks_6_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_126) begin
        banks_6_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_134) begin
        banks_6_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_142) begin
        banks_6_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_150) begin
        banks_6_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_158) begin
        banks_6_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_166) begin
        banks_6_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_174) begin
        banks_6_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_182) begin
        banks_6_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_190) begin
        banks_6_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_198) begin
        banks_6_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_206) begin
        banks_6_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_214) begin
        banks_6_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_222) begin
        banks_6_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    banks_7_io_aAddr = 8'h0;
    if(when_BankedScratchMemory_l228_63) begin
      banks_7_io_aAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l228_64) begin
      banks_7_io_aAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l228_65) begin
      banks_7_io_aAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l228_66) begin
      banks_7_io_aAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l228_67) begin
      banks_7_io_aAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l228_68) begin
      banks_7_io_aAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l228_69) begin
      banks_7_io_aAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l228_70) begin
      banks_7_io_aAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l228_71) begin
      banks_7_io_aAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_7) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr;
      end
    end
    if(when_BankedScratchMemory_l286_15) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr_1;
      end
    end
    if(when_BankedScratchMemory_l286_23) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr_2;
      end
    end
    if(when_BankedScratchMemory_l286_31) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr_3;
      end
    end
    if(when_BankedScratchMemory_l286_39) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr_4;
      end
    end
    if(when_BankedScratchMemory_l286_47) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr_5;
      end
    end
    if(when_BankedScratchMemory_l286_55) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr_6;
      end
    end
    if(when_BankedScratchMemory_l286_63) begin
      if(io_vectorReadActive) begin
        banks_7_io_aAddr = _zz_io_aAddr_7;
      end
    end
  end

  always @(*) begin
    banks_7_io_aEn = 1'b0;
    if(when_BankedScratchMemory_l228_63) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_64) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_65) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_66) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_67) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_68) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_69) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_70) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l228_71) begin
      banks_7_io_aEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_7) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_15) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_23) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_31) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_39) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_47) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_55) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_63) begin
      if(io_vectorReadActive) begin
        banks_7_io_aEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_7_io_bAddr = 8'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_7) begin
        banks_7_io_bAddr = _zz_io_bAddr;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_15) begin
        banks_7_io_bAddr = _zz_io_bAddr_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_23) begin
        banks_7_io_bAddr = _zz_io_bAddr_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_31) begin
        banks_7_io_bAddr = _zz_io_bAddr_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_39) begin
        banks_7_io_bAddr = _zz_io_bAddr_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_47) begin
        banks_7_io_bAddr = _zz_io_bAddr_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_55) begin
        banks_7_io_bAddr = _zz_io_bAddr_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_63) begin
        banks_7_io_bAddr = _zz_io_bAddr_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_71) begin
        banks_7_io_bAddr = _zz_io_bAddr_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_79) begin
        banks_7_io_bAddr = _zz_io_bAddr_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_87) begin
        banks_7_io_bAddr = _zz_io_bAddr_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_95) begin
        banks_7_io_bAddr = _zz_io_bAddr_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_103) begin
        banks_7_io_bAddr = _zz_io_bAddr_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_111) begin
        banks_7_io_bAddr = _zz_io_bAddr_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_119) begin
        banks_7_io_bAddr = _zz_io_bAddr_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_127) begin
        banks_7_io_bAddr = _zz_io_bAddr_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_135) begin
        banks_7_io_bAddr = _zz_io_bAddr_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_143) begin
        banks_7_io_bAddr = _zz_io_bAddr_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_151) begin
        banks_7_io_bAddr = _zz_io_bAddr_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_159) begin
        banks_7_io_bAddr = _zz_io_bAddr_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_167) begin
        banks_7_io_bAddr = _zz_io_bAddr_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_175) begin
        banks_7_io_bAddr = _zz_io_bAddr_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_183) begin
        banks_7_io_bAddr = _zz_io_bAddr_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_191) begin
        banks_7_io_bAddr = _zz_io_bAddr_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_199) begin
        banks_7_io_bAddr = _zz_io_bAddr_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_207) begin
        banks_7_io_bAddr = _zz_io_bAddr_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_215) begin
        banks_7_io_bAddr = _zz_io_bAddr_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_223) begin
        banks_7_io_bAddr = _zz_io_bAddr_27;
      end
    end
    if(when_BankedScratchMemory_l234_63) begin
      banks_7_io_bAddr = scalarBankRow_0;
    end
    if(when_BankedScratchMemory_l234_64) begin
      banks_7_io_bAddr = scalarBankRow_1;
    end
    if(when_BankedScratchMemory_l234_65) begin
      banks_7_io_bAddr = scalarBankRow_2;
    end
    if(when_BankedScratchMemory_l234_66) begin
      banks_7_io_bAddr = scalarBankRow_3;
    end
    if(when_BankedScratchMemory_l234_67) begin
      banks_7_io_bAddr = scalarBankRow_4;
    end
    if(when_BankedScratchMemory_l234_68) begin
      banks_7_io_bAddr = scalarBankRow_5;
    end
    if(when_BankedScratchMemory_l234_69) begin
      banks_7_io_bAddr = scalarBankRow_6;
    end
    if(when_BankedScratchMemory_l234_70) begin
      banks_7_io_bAddr = scalarBankRow_7;
    end
    if(when_BankedScratchMemory_l234_71) begin
      banks_7_io_bAddr = scalarBankRow_8;
    end
    if(when_BankedScratchMemory_l286_71) begin
      if(when_BankedScratchMemory_l295_7) begin
        banks_7_io_bAddr = _zz_io_bAddr_28;
      end
    end
    if(when_BankedScratchMemory_l286_79) begin
      if(when_BankedScratchMemory_l295_15) begin
        banks_7_io_bAddr = _zz_io_bAddr_29;
      end
    end
    if(when_BankedScratchMemory_l286_87) begin
      if(when_BankedScratchMemory_l295_23) begin
        banks_7_io_bAddr = _zz_io_bAddr_30;
      end
    end
    if(when_BankedScratchMemory_l286_95) begin
      if(when_BankedScratchMemory_l295_31) begin
        banks_7_io_bAddr = _zz_io_bAddr_31;
      end
    end
    if(when_BankedScratchMemory_l286_103) begin
      if(when_BankedScratchMemory_l295_39) begin
        banks_7_io_bAddr = _zz_io_bAddr_32;
      end
    end
    if(when_BankedScratchMemory_l286_111) begin
      if(when_BankedScratchMemory_l295_47) begin
        banks_7_io_bAddr = _zz_io_bAddr_33;
      end
    end
    if(when_BankedScratchMemory_l286_119) begin
      if(when_BankedScratchMemory_l295_55) begin
        banks_7_io_bAddr = _zz_io_bAddr_34;
      end
    end
    if(when_BankedScratchMemory_l286_127) begin
      if(when_BankedScratchMemory_l295_63) begin
        banks_7_io_bAddr = _zz_io_bAddr_35;
      end
    end
  end

  always @(*) begin
    banks_7_io_bEn = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_7) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_15) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_23) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_31) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_39) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_47) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_55) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_63) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_71) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_79) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_87) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_95) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_103) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_111) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_119) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_127) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_135) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_143) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_151) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_159) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_167) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_175) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_183) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_191) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_199) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_207) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_215) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_223) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_63) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_64) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_65) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_66) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_67) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_68) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_69) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_70) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l234_71) begin
      banks_7_io_bEn = 1'b1;
    end
    if(when_BankedScratchMemory_l286_71) begin
      if(when_BankedScratchMemory_l295_7) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_79) begin
      if(when_BankedScratchMemory_l295_15) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_87) begin
      if(when_BankedScratchMemory_l295_23) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_95) begin
      if(when_BankedScratchMemory_l295_31) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_103) begin
      if(when_BankedScratchMemory_l295_39) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_111) begin
      if(when_BankedScratchMemory_l295_47) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_119) begin
      if(when_BankedScratchMemory_l295_55) begin
        banks_7_io_bEn = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l286_127) begin
      if(when_BankedScratchMemory_l295_63) begin
        banks_7_io_bEn = 1'b1;
      end
    end
  end

  always @(*) begin
    banks_7_io_bWe = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_7) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_15) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_23) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_31) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_39) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_47) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_55) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_63) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_71) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_79) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_87) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_95) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_103) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_111) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_119) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_127) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_135) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_143) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_151) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_159) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_167) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_175) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_183) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_191) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_199) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_207) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_215) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_223) begin
        banks_7_io_bWe = 1'b1;
      end
    end
    if(when_BankedScratchMemory_l234_63) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_64) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_65) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_66) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_67) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_68) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_69) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_70) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l234_71) begin
      banks_7_io_bWe = 1'b0;
    end
    if(when_BankedScratchMemory_l286_71) begin
      if(when_BankedScratchMemory_l295_7) begin
        banks_7_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_79) begin
      if(when_BankedScratchMemory_l295_15) begin
        banks_7_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_87) begin
      if(when_BankedScratchMemory_l295_23) begin
        banks_7_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_95) begin
      if(when_BankedScratchMemory_l295_31) begin
        banks_7_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_103) begin
      if(when_BankedScratchMemory_l295_39) begin
        banks_7_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_111) begin
      if(when_BankedScratchMemory_l295_47) begin
        banks_7_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_119) begin
      if(when_BankedScratchMemory_l295_55) begin
        banks_7_io_bWe = 1'b0;
      end
    end
    if(when_BankedScratchMemory_l286_127) begin
      if(when_BankedScratchMemory_l295_63) begin
        banks_7_io_bWe = 1'b0;
      end
    end
  end

  always @(*) begin
    banks_7_io_bWrData = 32'h0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_7) begin
        banks_7_io_bWrData = io_writeData_0;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_15) begin
        banks_7_io_bWrData = io_writeData_1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_23) begin
        banks_7_io_bWrData = io_writeData_2;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_31) begin
        banks_7_io_bWrData = io_writeData_3;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_39) begin
        banks_7_io_bWrData = io_writeData_4;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_47) begin
        banks_7_io_bWrData = io_writeData_5;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_55) begin
        banks_7_io_bWrData = io_writeData_6;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_63) begin
        banks_7_io_bWrData = io_writeData_7;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_71) begin
        banks_7_io_bWrData = io_writeData_8;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_79) begin
        banks_7_io_bWrData = io_writeData_9;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_87) begin
        banks_7_io_bWrData = io_writeData_10;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_95) begin
        banks_7_io_bWrData = io_writeData_11;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_103) begin
        banks_7_io_bWrData = io_writeData_12;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_111) begin
        banks_7_io_bWrData = io_writeData_13;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_119) begin
        banks_7_io_bWrData = io_writeData_14;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_127) begin
        banks_7_io_bWrData = io_writeData_15;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_135) begin
        banks_7_io_bWrData = io_writeData_16;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_143) begin
        banks_7_io_bWrData = io_writeData_17;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_151) begin
        banks_7_io_bWrData = io_writeData_18;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_159) begin
        banks_7_io_bWrData = io_writeData_19;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_167) begin
        banks_7_io_bWrData = io_writeData_20;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_175) begin
        banks_7_io_bWrData = io_writeData_21;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_183) begin
        banks_7_io_bWrData = io_writeData_22;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_191) begin
        banks_7_io_bWrData = io_writeData_23;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_199) begin
        banks_7_io_bWrData = io_writeData_24;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_207) begin
        banks_7_io_bWrData = io_writeData_25;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_215) begin
        banks_7_io_bWrData = io_writeData_26;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_223) begin
        banks_7_io_bWrData = io_writeData_27;
      end
    end
  end

  always @(*) begin
    io_conflict = 1'b0;
    if(when_BankedScratchMemory_l242) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_1) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_1) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_2) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_2) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_3) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_3) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_4) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_4) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_5) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_5) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_6) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_6) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_7) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_7) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_8) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_8) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_9) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_9) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_10) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_10) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_11) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_11) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_12) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_12) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_13) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_13) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_14) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_14) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_15) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_15) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_16) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_16) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_17) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_17) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_18) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_18) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_19) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_19) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_20) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_20) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_21) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_21) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_22) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_22) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_23) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_23) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_24) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_24) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_25) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_25) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_26) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_26) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_27) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_27) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_28) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_28) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_29) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_29) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_30) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_30) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_31) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_31) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_32) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_32) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_33) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_33) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_34) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_34) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_35) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_35) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_36) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_36) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_37) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_37) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_38) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_38) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_39) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_39) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_40) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_40) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_41) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_41) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_42) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_42) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_43) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_43) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_44) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_44) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_45) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_45) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_46) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_46) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_47) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_47) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_48) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_48) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_49) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_49) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_50) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_50) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_51) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_51) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_52) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_52) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_53) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_53) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_54) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_54) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_55) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_55) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_56) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_56) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_57) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_57) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_58) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_58) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_59) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_59) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_60) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_60) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_61) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_61) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_62) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_62) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_63) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_63) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_64) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_64) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_65) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_65) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_66) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_66) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_67) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_67) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_68) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_68) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_69) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_69) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_70) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_70) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l242_71) begin
      io_conflict = 1'b1;
    end
    if(when_BankedScratchMemory_l245_71) begin
      io_conflict = 1'b1;
    end
  end

  always @(*) begin
    bankWriteActive_0 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_8) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_16) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_24) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_32) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_40) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_48) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_56) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_64) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_72) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_80) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_88) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_96) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_104) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_112) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_120) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_128) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_136) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_144) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_152) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_160) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_168) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_176) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_184) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_192) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_200) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_208) begin
        bankWriteActive_0 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_216) begin
        bankWriteActive_0 = 1'b1;
      end
    end
  end

  always @(*) begin
    bankWriteActive_1 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_1) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_9) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_17) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_25) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_33) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_41) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_49) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_57) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_65) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_73) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_81) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_89) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_97) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_105) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_113) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_121) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_129) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_137) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_145) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_153) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_161) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_169) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_177) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_185) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_193) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_201) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_209) begin
        bankWriteActive_1 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_217) begin
        bankWriteActive_1 = 1'b1;
      end
    end
  end

  always @(*) begin
    bankWriteActive_2 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_2) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_10) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_18) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_26) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_34) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_42) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_50) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_58) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_66) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_74) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_82) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_90) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_98) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_106) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_114) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_122) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_130) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_138) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_146) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_154) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_162) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_170) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_178) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_186) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_194) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_202) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_210) begin
        bankWriteActive_2 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_218) begin
        bankWriteActive_2 = 1'b1;
      end
    end
  end

  always @(*) begin
    bankWriteActive_3 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_3) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_11) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_19) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_27) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_35) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_43) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_51) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_59) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_67) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_75) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_83) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_91) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_99) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_107) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_115) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_123) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_131) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_139) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_147) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_155) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_163) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_171) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_179) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_187) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_195) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_203) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_211) begin
        bankWriteActive_3 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_219) begin
        bankWriteActive_3 = 1'b1;
      end
    end
  end

  always @(*) begin
    bankWriteActive_4 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_4) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_12) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_20) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_28) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_36) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_44) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_52) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_60) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_68) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_76) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_84) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_92) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_100) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_108) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_116) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_124) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_132) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_140) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_148) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_156) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_164) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_172) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_180) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_188) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_196) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_204) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_212) begin
        bankWriteActive_4 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_220) begin
        bankWriteActive_4 = 1'b1;
      end
    end
  end

  always @(*) begin
    bankWriteActive_5 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_5) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_13) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_21) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_29) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_37) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_45) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_53) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_61) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_69) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_77) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_85) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_93) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_101) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_109) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_117) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_125) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_133) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_141) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_149) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_157) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_165) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_173) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_181) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_189) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_197) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_205) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_213) begin
        bankWriteActive_5 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_221) begin
        bankWriteActive_5 = 1'b1;
      end
    end
  end

  always @(*) begin
    bankWriteActive_6 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_6) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_14) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_22) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_30) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_38) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_46) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_54) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_62) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_70) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_78) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_86) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_94) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_102) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_110) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_118) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_126) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_134) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_142) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_150) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_158) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_166) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_174) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_182) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_190) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_198) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_206) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_214) begin
        bankWriteActive_6 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_222) begin
        bankWriteActive_6 = 1'b1;
      end
    end
  end

  always @(*) begin
    bankWriteActive_7 = 1'b0;
    if(io_writeEn_0) begin
      if(when_BankedScratchMemory_l171_7) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_1) begin
      if(when_BankedScratchMemory_l171_15) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_2) begin
      if(when_BankedScratchMemory_l171_23) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_3) begin
      if(when_BankedScratchMemory_l171_31) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_4) begin
      if(when_BankedScratchMemory_l171_39) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_5) begin
      if(when_BankedScratchMemory_l171_47) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_6) begin
      if(when_BankedScratchMemory_l171_55) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_7) begin
      if(when_BankedScratchMemory_l171_63) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_8) begin
      if(when_BankedScratchMemory_l171_71) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_9) begin
      if(when_BankedScratchMemory_l171_79) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_10) begin
      if(when_BankedScratchMemory_l171_87) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_11) begin
      if(when_BankedScratchMemory_l171_95) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_12) begin
      if(when_BankedScratchMemory_l171_103) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_13) begin
      if(when_BankedScratchMemory_l171_111) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_14) begin
      if(when_BankedScratchMemory_l171_119) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_15) begin
      if(when_BankedScratchMemory_l171_127) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_16) begin
      if(when_BankedScratchMemory_l171_135) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_17) begin
      if(when_BankedScratchMemory_l171_143) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_18) begin
      if(when_BankedScratchMemory_l171_151) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_19) begin
      if(when_BankedScratchMemory_l171_159) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_20) begin
      if(when_BankedScratchMemory_l171_167) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_21) begin
      if(when_BankedScratchMemory_l171_175) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_22) begin
      if(when_BankedScratchMemory_l171_183) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_23) begin
      if(when_BankedScratchMemory_l171_191) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_24) begin
      if(when_BankedScratchMemory_l171_199) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_25) begin
      if(when_BankedScratchMemory_l171_207) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_26) begin
      if(when_BankedScratchMemory_l171_215) begin
        bankWriteActive_7 = 1'b1;
      end
    end
    if(io_writeEn_27) begin
      if(when_BankedScratchMemory_l171_223) begin
        bankWriteActive_7 = 1'b1;
      end
    end
  end

  assign _zz_when_BankedScratchMemory_l171 = io_writeAddr_0[2 : 0];
  assign _zz_io_bAddr = io_writeAddr_0[10 : 3];
  assign when_BankedScratchMemory_l171 = (_zz_when_BankedScratchMemory_l171 == 3'b000);
  assign when_BankedScratchMemory_l171_1 = (_zz_when_BankedScratchMemory_l171 == 3'b001);
  assign when_BankedScratchMemory_l171_2 = (_zz_when_BankedScratchMemory_l171 == 3'b010);
  assign when_BankedScratchMemory_l171_3 = (_zz_when_BankedScratchMemory_l171 == 3'b011);
  assign when_BankedScratchMemory_l171_4 = (_zz_when_BankedScratchMemory_l171 == 3'b100);
  assign when_BankedScratchMemory_l171_5 = (_zz_when_BankedScratchMemory_l171 == 3'b101);
  assign when_BankedScratchMemory_l171_6 = (_zz_when_BankedScratchMemory_l171 == 3'b110);
  assign when_BankedScratchMemory_l171_7 = (_zz_when_BankedScratchMemory_l171 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_1 = io_writeAddr_1[2 : 0];
  assign _zz_io_bAddr_1 = io_writeAddr_1[10 : 3];
  assign when_BankedScratchMemory_l171_8 = (_zz_when_BankedScratchMemory_l171_1 == 3'b000);
  assign when_BankedScratchMemory_l171_9 = (_zz_when_BankedScratchMemory_l171_1 == 3'b001);
  assign when_BankedScratchMemory_l171_10 = (_zz_when_BankedScratchMemory_l171_1 == 3'b010);
  assign when_BankedScratchMemory_l171_11 = (_zz_when_BankedScratchMemory_l171_1 == 3'b011);
  assign when_BankedScratchMemory_l171_12 = (_zz_when_BankedScratchMemory_l171_1 == 3'b100);
  assign when_BankedScratchMemory_l171_13 = (_zz_when_BankedScratchMemory_l171_1 == 3'b101);
  assign when_BankedScratchMemory_l171_14 = (_zz_when_BankedScratchMemory_l171_1 == 3'b110);
  assign when_BankedScratchMemory_l171_15 = (_zz_when_BankedScratchMemory_l171_1 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_2 = io_writeAddr_2[2 : 0];
  assign _zz_io_bAddr_2 = io_writeAddr_2[10 : 3];
  assign when_BankedScratchMemory_l171_16 = (_zz_when_BankedScratchMemory_l171_2 == 3'b000);
  assign when_BankedScratchMemory_l171_17 = (_zz_when_BankedScratchMemory_l171_2 == 3'b001);
  assign when_BankedScratchMemory_l171_18 = (_zz_when_BankedScratchMemory_l171_2 == 3'b010);
  assign when_BankedScratchMemory_l171_19 = (_zz_when_BankedScratchMemory_l171_2 == 3'b011);
  assign when_BankedScratchMemory_l171_20 = (_zz_when_BankedScratchMemory_l171_2 == 3'b100);
  assign when_BankedScratchMemory_l171_21 = (_zz_when_BankedScratchMemory_l171_2 == 3'b101);
  assign when_BankedScratchMemory_l171_22 = (_zz_when_BankedScratchMemory_l171_2 == 3'b110);
  assign when_BankedScratchMemory_l171_23 = (_zz_when_BankedScratchMemory_l171_2 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_3 = io_writeAddr_3[2 : 0];
  assign _zz_io_bAddr_3 = io_writeAddr_3[10 : 3];
  assign when_BankedScratchMemory_l171_24 = (_zz_when_BankedScratchMemory_l171_3 == 3'b000);
  assign when_BankedScratchMemory_l171_25 = (_zz_when_BankedScratchMemory_l171_3 == 3'b001);
  assign when_BankedScratchMemory_l171_26 = (_zz_when_BankedScratchMemory_l171_3 == 3'b010);
  assign when_BankedScratchMemory_l171_27 = (_zz_when_BankedScratchMemory_l171_3 == 3'b011);
  assign when_BankedScratchMemory_l171_28 = (_zz_when_BankedScratchMemory_l171_3 == 3'b100);
  assign when_BankedScratchMemory_l171_29 = (_zz_when_BankedScratchMemory_l171_3 == 3'b101);
  assign when_BankedScratchMemory_l171_30 = (_zz_when_BankedScratchMemory_l171_3 == 3'b110);
  assign when_BankedScratchMemory_l171_31 = (_zz_when_BankedScratchMemory_l171_3 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_4 = io_writeAddr_4[2 : 0];
  assign _zz_io_bAddr_4 = io_writeAddr_4[10 : 3];
  assign when_BankedScratchMemory_l171_32 = (_zz_when_BankedScratchMemory_l171_4 == 3'b000);
  assign when_BankedScratchMemory_l171_33 = (_zz_when_BankedScratchMemory_l171_4 == 3'b001);
  assign when_BankedScratchMemory_l171_34 = (_zz_when_BankedScratchMemory_l171_4 == 3'b010);
  assign when_BankedScratchMemory_l171_35 = (_zz_when_BankedScratchMemory_l171_4 == 3'b011);
  assign when_BankedScratchMemory_l171_36 = (_zz_when_BankedScratchMemory_l171_4 == 3'b100);
  assign when_BankedScratchMemory_l171_37 = (_zz_when_BankedScratchMemory_l171_4 == 3'b101);
  assign when_BankedScratchMemory_l171_38 = (_zz_when_BankedScratchMemory_l171_4 == 3'b110);
  assign when_BankedScratchMemory_l171_39 = (_zz_when_BankedScratchMemory_l171_4 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_5 = io_writeAddr_5[2 : 0];
  assign _zz_io_bAddr_5 = io_writeAddr_5[10 : 3];
  assign when_BankedScratchMemory_l171_40 = (_zz_when_BankedScratchMemory_l171_5 == 3'b000);
  assign when_BankedScratchMemory_l171_41 = (_zz_when_BankedScratchMemory_l171_5 == 3'b001);
  assign when_BankedScratchMemory_l171_42 = (_zz_when_BankedScratchMemory_l171_5 == 3'b010);
  assign when_BankedScratchMemory_l171_43 = (_zz_when_BankedScratchMemory_l171_5 == 3'b011);
  assign when_BankedScratchMemory_l171_44 = (_zz_when_BankedScratchMemory_l171_5 == 3'b100);
  assign when_BankedScratchMemory_l171_45 = (_zz_when_BankedScratchMemory_l171_5 == 3'b101);
  assign when_BankedScratchMemory_l171_46 = (_zz_when_BankedScratchMemory_l171_5 == 3'b110);
  assign when_BankedScratchMemory_l171_47 = (_zz_when_BankedScratchMemory_l171_5 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_6 = io_writeAddr_6[2 : 0];
  assign _zz_io_bAddr_6 = io_writeAddr_6[10 : 3];
  assign when_BankedScratchMemory_l171_48 = (_zz_when_BankedScratchMemory_l171_6 == 3'b000);
  assign when_BankedScratchMemory_l171_49 = (_zz_when_BankedScratchMemory_l171_6 == 3'b001);
  assign when_BankedScratchMemory_l171_50 = (_zz_when_BankedScratchMemory_l171_6 == 3'b010);
  assign when_BankedScratchMemory_l171_51 = (_zz_when_BankedScratchMemory_l171_6 == 3'b011);
  assign when_BankedScratchMemory_l171_52 = (_zz_when_BankedScratchMemory_l171_6 == 3'b100);
  assign when_BankedScratchMemory_l171_53 = (_zz_when_BankedScratchMemory_l171_6 == 3'b101);
  assign when_BankedScratchMemory_l171_54 = (_zz_when_BankedScratchMemory_l171_6 == 3'b110);
  assign when_BankedScratchMemory_l171_55 = (_zz_when_BankedScratchMemory_l171_6 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_7 = io_writeAddr_7[2 : 0];
  assign _zz_io_bAddr_7 = io_writeAddr_7[10 : 3];
  assign when_BankedScratchMemory_l171_56 = (_zz_when_BankedScratchMemory_l171_7 == 3'b000);
  assign when_BankedScratchMemory_l171_57 = (_zz_when_BankedScratchMemory_l171_7 == 3'b001);
  assign when_BankedScratchMemory_l171_58 = (_zz_when_BankedScratchMemory_l171_7 == 3'b010);
  assign when_BankedScratchMemory_l171_59 = (_zz_when_BankedScratchMemory_l171_7 == 3'b011);
  assign when_BankedScratchMemory_l171_60 = (_zz_when_BankedScratchMemory_l171_7 == 3'b100);
  assign when_BankedScratchMemory_l171_61 = (_zz_when_BankedScratchMemory_l171_7 == 3'b101);
  assign when_BankedScratchMemory_l171_62 = (_zz_when_BankedScratchMemory_l171_7 == 3'b110);
  assign when_BankedScratchMemory_l171_63 = (_zz_when_BankedScratchMemory_l171_7 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_8 = io_writeAddr_8[2 : 0];
  assign _zz_io_bAddr_8 = io_writeAddr_8[10 : 3];
  assign when_BankedScratchMemory_l171_64 = (_zz_when_BankedScratchMemory_l171_8 == 3'b000);
  assign when_BankedScratchMemory_l171_65 = (_zz_when_BankedScratchMemory_l171_8 == 3'b001);
  assign when_BankedScratchMemory_l171_66 = (_zz_when_BankedScratchMemory_l171_8 == 3'b010);
  assign when_BankedScratchMemory_l171_67 = (_zz_when_BankedScratchMemory_l171_8 == 3'b011);
  assign when_BankedScratchMemory_l171_68 = (_zz_when_BankedScratchMemory_l171_8 == 3'b100);
  assign when_BankedScratchMemory_l171_69 = (_zz_when_BankedScratchMemory_l171_8 == 3'b101);
  assign when_BankedScratchMemory_l171_70 = (_zz_when_BankedScratchMemory_l171_8 == 3'b110);
  assign when_BankedScratchMemory_l171_71 = (_zz_when_BankedScratchMemory_l171_8 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_9 = io_writeAddr_9[2 : 0];
  assign _zz_io_bAddr_9 = io_writeAddr_9[10 : 3];
  assign when_BankedScratchMemory_l171_72 = (_zz_when_BankedScratchMemory_l171_9 == 3'b000);
  assign when_BankedScratchMemory_l171_73 = (_zz_when_BankedScratchMemory_l171_9 == 3'b001);
  assign when_BankedScratchMemory_l171_74 = (_zz_when_BankedScratchMemory_l171_9 == 3'b010);
  assign when_BankedScratchMemory_l171_75 = (_zz_when_BankedScratchMemory_l171_9 == 3'b011);
  assign when_BankedScratchMemory_l171_76 = (_zz_when_BankedScratchMemory_l171_9 == 3'b100);
  assign when_BankedScratchMemory_l171_77 = (_zz_when_BankedScratchMemory_l171_9 == 3'b101);
  assign when_BankedScratchMemory_l171_78 = (_zz_when_BankedScratchMemory_l171_9 == 3'b110);
  assign when_BankedScratchMemory_l171_79 = (_zz_when_BankedScratchMemory_l171_9 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_10 = io_writeAddr_10[2 : 0];
  assign _zz_io_bAddr_10 = io_writeAddr_10[10 : 3];
  assign when_BankedScratchMemory_l171_80 = (_zz_when_BankedScratchMemory_l171_10 == 3'b000);
  assign when_BankedScratchMemory_l171_81 = (_zz_when_BankedScratchMemory_l171_10 == 3'b001);
  assign when_BankedScratchMemory_l171_82 = (_zz_when_BankedScratchMemory_l171_10 == 3'b010);
  assign when_BankedScratchMemory_l171_83 = (_zz_when_BankedScratchMemory_l171_10 == 3'b011);
  assign when_BankedScratchMemory_l171_84 = (_zz_when_BankedScratchMemory_l171_10 == 3'b100);
  assign when_BankedScratchMemory_l171_85 = (_zz_when_BankedScratchMemory_l171_10 == 3'b101);
  assign when_BankedScratchMemory_l171_86 = (_zz_when_BankedScratchMemory_l171_10 == 3'b110);
  assign when_BankedScratchMemory_l171_87 = (_zz_when_BankedScratchMemory_l171_10 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_11 = io_writeAddr_11[2 : 0];
  assign _zz_io_bAddr_11 = io_writeAddr_11[10 : 3];
  assign when_BankedScratchMemory_l171_88 = (_zz_when_BankedScratchMemory_l171_11 == 3'b000);
  assign when_BankedScratchMemory_l171_89 = (_zz_when_BankedScratchMemory_l171_11 == 3'b001);
  assign when_BankedScratchMemory_l171_90 = (_zz_when_BankedScratchMemory_l171_11 == 3'b010);
  assign when_BankedScratchMemory_l171_91 = (_zz_when_BankedScratchMemory_l171_11 == 3'b011);
  assign when_BankedScratchMemory_l171_92 = (_zz_when_BankedScratchMemory_l171_11 == 3'b100);
  assign when_BankedScratchMemory_l171_93 = (_zz_when_BankedScratchMemory_l171_11 == 3'b101);
  assign when_BankedScratchMemory_l171_94 = (_zz_when_BankedScratchMemory_l171_11 == 3'b110);
  assign when_BankedScratchMemory_l171_95 = (_zz_when_BankedScratchMemory_l171_11 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_12 = io_writeAddr_12[2 : 0];
  assign _zz_io_bAddr_12 = io_writeAddr_12[10 : 3];
  assign when_BankedScratchMemory_l171_96 = (_zz_when_BankedScratchMemory_l171_12 == 3'b000);
  assign when_BankedScratchMemory_l171_97 = (_zz_when_BankedScratchMemory_l171_12 == 3'b001);
  assign when_BankedScratchMemory_l171_98 = (_zz_when_BankedScratchMemory_l171_12 == 3'b010);
  assign when_BankedScratchMemory_l171_99 = (_zz_when_BankedScratchMemory_l171_12 == 3'b011);
  assign when_BankedScratchMemory_l171_100 = (_zz_when_BankedScratchMemory_l171_12 == 3'b100);
  assign when_BankedScratchMemory_l171_101 = (_zz_when_BankedScratchMemory_l171_12 == 3'b101);
  assign when_BankedScratchMemory_l171_102 = (_zz_when_BankedScratchMemory_l171_12 == 3'b110);
  assign when_BankedScratchMemory_l171_103 = (_zz_when_BankedScratchMemory_l171_12 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_13 = io_writeAddr_13[2 : 0];
  assign _zz_io_bAddr_13 = io_writeAddr_13[10 : 3];
  assign when_BankedScratchMemory_l171_104 = (_zz_when_BankedScratchMemory_l171_13 == 3'b000);
  assign when_BankedScratchMemory_l171_105 = (_zz_when_BankedScratchMemory_l171_13 == 3'b001);
  assign when_BankedScratchMemory_l171_106 = (_zz_when_BankedScratchMemory_l171_13 == 3'b010);
  assign when_BankedScratchMemory_l171_107 = (_zz_when_BankedScratchMemory_l171_13 == 3'b011);
  assign when_BankedScratchMemory_l171_108 = (_zz_when_BankedScratchMemory_l171_13 == 3'b100);
  assign when_BankedScratchMemory_l171_109 = (_zz_when_BankedScratchMemory_l171_13 == 3'b101);
  assign when_BankedScratchMemory_l171_110 = (_zz_when_BankedScratchMemory_l171_13 == 3'b110);
  assign when_BankedScratchMemory_l171_111 = (_zz_when_BankedScratchMemory_l171_13 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_14 = io_writeAddr_14[2 : 0];
  assign _zz_io_bAddr_14 = io_writeAddr_14[10 : 3];
  assign when_BankedScratchMemory_l171_112 = (_zz_when_BankedScratchMemory_l171_14 == 3'b000);
  assign when_BankedScratchMemory_l171_113 = (_zz_when_BankedScratchMemory_l171_14 == 3'b001);
  assign when_BankedScratchMemory_l171_114 = (_zz_when_BankedScratchMemory_l171_14 == 3'b010);
  assign when_BankedScratchMemory_l171_115 = (_zz_when_BankedScratchMemory_l171_14 == 3'b011);
  assign when_BankedScratchMemory_l171_116 = (_zz_when_BankedScratchMemory_l171_14 == 3'b100);
  assign when_BankedScratchMemory_l171_117 = (_zz_when_BankedScratchMemory_l171_14 == 3'b101);
  assign when_BankedScratchMemory_l171_118 = (_zz_when_BankedScratchMemory_l171_14 == 3'b110);
  assign when_BankedScratchMemory_l171_119 = (_zz_when_BankedScratchMemory_l171_14 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_15 = io_writeAddr_15[2 : 0];
  assign _zz_io_bAddr_15 = io_writeAddr_15[10 : 3];
  assign when_BankedScratchMemory_l171_120 = (_zz_when_BankedScratchMemory_l171_15 == 3'b000);
  assign when_BankedScratchMemory_l171_121 = (_zz_when_BankedScratchMemory_l171_15 == 3'b001);
  assign when_BankedScratchMemory_l171_122 = (_zz_when_BankedScratchMemory_l171_15 == 3'b010);
  assign when_BankedScratchMemory_l171_123 = (_zz_when_BankedScratchMemory_l171_15 == 3'b011);
  assign when_BankedScratchMemory_l171_124 = (_zz_when_BankedScratchMemory_l171_15 == 3'b100);
  assign when_BankedScratchMemory_l171_125 = (_zz_when_BankedScratchMemory_l171_15 == 3'b101);
  assign when_BankedScratchMemory_l171_126 = (_zz_when_BankedScratchMemory_l171_15 == 3'b110);
  assign when_BankedScratchMemory_l171_127 = (_zz_when_BankedScratchMemory_l171_15 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_16 = io_writeAddr_16[2 : 0];
  assign _zz_io_bAddr_16 = io_writeAddr_16[10 : 3];
  assign when_BankedScratchMemory_l171_128 = (_zz_when_BankedScratchMemory_l171_16 == 3'b000);
  assign when_BankedScratchMemory_l171_129 = (_zz_when_BankedScratchMemory_l171_16 == 3'b001);
  assign when_BankedScratchMemory_l171_130 = (_zz_when_BankedScratchMemory_l171_16 == 3'b010);
  assign when_BankedScratchMemory_l171_131 = (_zz_when_BankedScratchMemory_l171_16 == 3'b011);
  assign when_BankedScratchMemory_l171_132 = (_zz_when_BankedScratchMemory_l171_16 == 3'b100);
  assign when_BankedScratchMemory_l171_133 = (_zz_when_BankedScratchMemory_l171_16 == 3'b101);
  assign when_BankedScratchMemory_l171_134 = (_zz_when_BankedScratchMemory_l171_16 == 3'b110);
  assign when_BankedScratchMemory_l171_135 = (_zz_when_BankedScratchMemory_l171_16 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_17 = io_writeAddr_17[2 : 0];
  assign _zz_io_bAddr_17 = io_writeAddr_17[10 : 3];
  assign when_BankedScratchMemory_l171_136 = (_zz_when_BankedScratchMemory_l171_17 == 3'b000);
  assign when_BankedScratchMemory_l171_137 = (_zz_when_BankedScratchMemory_l171_17 == 3'b001);
  assign when_BankedScratchMemory_l171_138 = (_zz_when_BankedScratchMemory_l171_17 == 3'b010);
  assign when_BankedScratchMemory_l171_139 = (_zz_when_BankedScratchMemory_l171_17 == 3'b011);
  assign when_BankedScratchMemory_l171_140 = (_zz_when_BankedScratchMemory_l171_17 == 3'b100);
  assign when_BankedScratchMemory_l171_141 = (_zz_when_BankedScratchMemory_l171_17 == 3'b101);
  assign when_BankedScratchMemory_l171_142 = (_zz_when_BankedScratchMemory_l171_17 == 3'b110);
  assign when_BankedScratchMemory_l171_143 = (_zz_when_BankedScratchMemory_l171_17 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_18 = io_writeAddr_18[2 : 0];
  assign _zz_io_bAddr_18 = io_writeAddr_18[10 : 3];
  assign when_BankedScratchMemory_l171_144 = (_zz_when_BankedScratchMemory_l171_18 == 3'b000);
  assign when_BankedScratchMemory_l171_145 = (_zz_when_BankedScratchMemory_l171_18 == 3'b001);
  assign when_BankedScratchMemory_l171_146 = (_zz_when_BankedScratchMemory_l171_18 == 3'b010);
  assign when_BankedScratchMemory_l171_147 = (_zz_when_BankedScratchMemory_l171_18 == 3'b011);
  assign when_BankedScratchMemory_l171_148 = (_zz_when_BankedScratchMemory_l171_18 == 3'b100);
  assign when_BankedScratchMemory_l171_149 = (_zz_when_BankedScratchMemory_l171_18 == 3'b101);
  assign when_BankedScratchMemory_l171_150 = (_zz_when_BankedScratchMemory_l171_18 == 3'b110);
  assign when_BankedScratchMemory_l171_151 = (_zz_when_BankedScratchMemory_l171_18 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_19 = io_writeAddr_19[2 : 0];
  assign _zz_io_bAddr_19 = io_writeAddr_19[10 : 3];
  assign when_BankedScratchMemory_l171_152 = (_zz_when_BankedScratchMemory_l171_19 == 3'b000);
  assign when_BankedScratchMemory_l171_153 = (_zz_when_BankedScratchMemory_l171_19 == 3'b001);
  assign when_BankedScratchMemory_l171_154 = (_zz_when_BankedScratchMemory_l171_19 == 3'b010);
  assign when_BankedScratchMemory_l171_155 = (_zz_when_BankedScratchMemory_l171_19 == 3'b011);
  assign when_BankedScratchMemory_l171_156 = (_zz_when_BankedScratchMemory_l171_19 == 3'b100);
  assign when_BankedScratchMemory_l171_157 = (_zz_when_BankedScratchMemory_l171_19 == 3'b101);
  assign when_BankedScratchMemory_l171_158 = (_zz_when_BankedScratchMemory_l171_19 == 3'b110);
  assign when_BankedScratchMemory_l171_159 = (_zz_when_BankedScratchMemory_l171_19 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_20 = io_writeAddr_20[2 : 0];
  assign _zz_io_bAddr_20 = io_writeAddr_20[10 : 3];
  assign when_BankedScratchMemory_l171_160 = (_zz_when_BankedScratchMemory_l171_20 == 3'b000);
  assign when_BankedScratchMemory_l171_161 = (_zz_when_BankedScratchMemory_l171_20 == 3'b001);
  assign when_BankedScratchMemory_l171_162 = (_zz_when_BankedScratchMemory_l171_20 == 3'b010);
  assign when_BankedScratchMemory_l171_163 = (_zz_when_BankedScratchMemory_l171_20 == 3'b011);
  assign when_BankedScratchMemory_l171_164 = (_zz_when_BankedScratchMemory_l171_20 == 3'b100);
  assign when_BankedScratchMemory_l171_165 = (_zz_when_BankedScratchMemory_l171_20 == 3'b101);
  assign when_BankedScratchMemory_l171_166 = (_zz_when_BankedScratchMemory_l171_20 == 3'b110);
  assign when_BankedScratchMemory_l171_167 = (_zz_when_BankedScratchMemory_l171_20 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_21 = io_writeAddr_21[2 : 0];
  assign _zz_io_bAddr_21 = io_writeAddr_21[10 : 3];
  assign when_BankedScratchMemory_l171_168 = (_zz_when_BankedScratchMemory_l171_21 == 3'b000);
  assign when_BankedScratchMemory_l171_169 = (_zz_when_BankedScratchMemory_l171_21 == 3'b001);
  assign when_BankedScratchMemory_l171_170 = (_zz_when_BankedScratchMemory_l171_21 == 3'b010);
  assign when_BankedScratchMemory_l171_171 = (_zz_when_BankedScratchMemory_l171_21 == 3'b011);
  assign when_BankedScratchMemory_l171_172 = (_zz_when_BankedScratchMemory_l171_21 == 3'b100);
  assign when_BankedScratchMemory_l171_173 = (_zz_when_BankedScratchMemory_l171_21 == 3'b101);
  assign when_BankedScratchMemory_l171_174 = (_zz_when_BankedScratchMemory_l171_21 == 3'b110);
  assign when_BankedScratchMemory_l171_175 = (_zz_when_BankedScratchMemory_l171_21 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_22 = io_writeAddr_22[2 : 0];
  assign _zz_io_bAddr_22 = io_writeAddr_22[10 : 3];
  assign when_BankedScratchMemory_l171_176 = (_zz_when_BankedScratchMemory_l171_22 == 3'b000);
  assign when_BankedScratchMemory_l171_177 = (_zz_when_BankedScratchMemory_l171_22 == 3'b001);
  assign when_BankedScratchMemory_l171_178 = (_zz_when_BankedScratchMemory_l171_22 == 3'b010);
  assign when_BankedScratchMemory_l171_179 = (_zz_when_BankedScratchMemory_l171_22 == 3'b011);
  assign when_BankedScratchMemory_l171_180 = (_zz_when_BankedScratchMemory_l171_22 == 3'b100);
  assign when_BankedScratchMemory_l171_181 = (_zz_when_BankedScratchMemory_l171_22 == 3'b101);
  assign when_BankedScratchMemory_l171_182 = (_zz_when_BankedScratchMemory_l171_22 == 3'b110);
  assign when_BankedScratchMemory_l171_183 = (_zz_when_BankedScratchMemory_l171_22 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_23 = io_writeAddr_23[2 : 0];
  assign _zz_io_bAddr_23 = io_writeAddr_23[10 : 3];
  assign when_BankedScratchMemory_l171_184 = (_zz_when_BankedScratchMemory_l171_23 == 3'b000);
  assign when_BankedScratchMemory_l171_185 = (_zz_when_BankedScratchMemory_l171_23 == 3'b001);
  assign when_BankedScratchMemory_l171_186 = (_zz_when_BankedScratchMemory_l171_23 == 3'b010);
  assign when_BankedScratchMemory_l171_187 = (_zz_when_BankedScratchMemory_l171_23 == 3'b011);
  assign when_BankedScratchMemory_l171_188 = (_zz_when_BankedScratchMemory_l171_23 == 3'b100);
  assign when_BankedScratchMemory_l171_189 = (_zz_when_BankedScratchMemory_l171_23 == 3'b101);
  assign when_BankedScratchMemory_l171_190 = (_zz_when_BankedScratchMemory_l171_23 == 3'b110);
  assign when_BankedScratchMemory_l171_191 = (_zz_when_BankedScratchMemory_l171_23 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_24 = io_writeAddr_24[2 : 0];
  assign _zz_io_bAddr_24 = io_writeAddr_24[10 : 3];
  assign when_BankedScratchMemory_l171_192 = (_zz_when_BankedScratchMemory_l171_24 == 3'b000);
  assign when_BankedScratchMemory_l171_193 = (_zz_when_BankedScratchMemory_l171_24 == 3'b001);
  assign when_BankedScratchMemory_l171_194 = (_zz_when_BankedScratchMemory_l171_24 == 3'b010);
  assign when_BankedScratchMemory_l171_195 = (_zz_when_BankedScratchMemory_l171_24 == 3'b011);
  assign when_BankedScratchMemory_l171_196 = (_zz_when_BankedScratchMemory_l171_24 == 3'b100);
  assign when_BankedScratchMemory_l171_197 = (_zz_when_BankedScratchMemory_l171_24 == 3'b101);
  assign when_BankedScratchMemory_l171_198 = (_zz_when_BankedScratchMemory_l171_24 == 3'b110);
  assign when_BankedScratchMemory_l171_199 = (_zz_when_BankedScratchMemory_l171_24 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_25 = io_writeAddr_25[2 : 0];
  assign _zz_io_bAddr_25 = io_writeAddr_25[10 : 3];
  assign when_BankedScratchMemory_l171_200 = (_zz_when_BankedScratchMemory_l171_25 == 3'b000);
  assign when_BankedScratchMemory_l171_201 = (_zz_when_BankedScratchMemory_l171_25 == 3'b001);
  assign when_BankedScratchMemory_l171_202 = (_zz_when_BankedScratchMemory_l171_25 == 3'b010);
  assign when_BankedScratchMemory_l171_203 = (_zz_when_BankedScratchMemory_l171_25 == 3'b011);
  assign when_BankedScratchMemory_l171_204 = (_zz_when_BankedScratchMemory_l171_25 == 3'b100);
  assign when_BankedScratchMemory_l171_205 = (_zz_when_BankedScratchMemory_l171_25 == 3'b101);
  assign when_BankedScratchMemory_l171_206 = (_zz_when_BankedScratchMemory_l171_25 == 3'b110);
  assign when_BankedScratchMemory_l171_207 = (_zz_when_BankedScratchMemory_l171_25 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_26 = io_writeAddr_26[2 : 0];
  assign _zz_io_bAddr_26 = io_writeAddr_26[10 : 3];
  assign when_BankedScratchMemory_l171_208 = (_zz_when_BankedScratchMemory_l171_26 == 3'b000);
  assign when_BankedScratchMemory_l171_209 = (_zz_when_BankedScratchMemory_l171_26 == 3'b001);
  assign when_BankedScratchMemory_l171_210 = (_zz_when_BankedScratchMemory_l171_26 == 3'b010);
  assign when_BankedScratchMemory_l171_211 = (_zz_when_BankedScratchMemory_l171_26 == 3'b011);
  assign when_BankedScratchMemory_l171_212 = (_zz_when_BankedScratchMemory_l171_26 == 3'b100);
  assign when_BankedScratchMemory_l171_213 = (_zz_when_BankedScratchMemory_l171_26 == 3'b101);
  assign when_BankedScratchMemory_l171_214 = (_zz_when_BankedScratchMemory_l171_26 == 3'b110);
  assign when_BankedScratchMemory_l171_215 = (_zz_when_BankedScratchMemory_l171_26 == 3'b111);
  assign _zz_when_BankedScratchMemory_l171_27 = io_writeAddr_27[2 : 0];
  assign _zz_io_bAddr_27 = io_writeAddr_27[10 : 3];
  assign when_BankedScratchMemory_l171_216 = (_zz_when_BankedScratchMemory_l171_27 == 3'b000);
  assign when_BankedScratchMemory_l171_217 = (_zz_when_BankedScratchMemory_l171_27 == 3'b001);
  assign when_BankedScratchMemory_l171_218 = (_zz_when_BankedScratchMemory_l171_27 == 3'b010);
  assign when_BankedScratchMemory_l171_219 = (_zz_when_BankedScratchMemory_l171_27 == 3'b011);
  assign when_BankedScratchMemory_l171_220 = (_zz_when_BankedScratchMemory_l171_27 == 3'b100);
  assign when_BankedScratchMemory_l171_221 = (_zz_when_BankedScratchMemory_l171_27 == 3'b101);
  assign when_BankedScratchMemory_l171_222 = (_zz_when_BankedScratchMemory_l171_27 == 3'b110);
  assign when_BankedScratchMemory_l171_223 = (_zz_when_BankedScratchMemory_l171_27 == 3'b111);
  always @(*) begin
    io_scalarReadData_0 = 32'h0;
    if(when_BankedScratchMemory_l262) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_1) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_2) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_3) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_4) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_5) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_6) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_7) begin
      if(scalarUsedPortBReg_0) begin
        io_scalarReadData_0 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_0 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_0) begin
      io_scalarReadData_0 = fwdGap2Data_0;
    end
    if(when_BankedScratchMemory_l390) begin
      io_scalarReadData_0 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_1) begin
      io_scalarReadData_0 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_2) begin
      io_scalarReadData_0 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_3) begin
      io_scalarReadData_0 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_4) begin
      io_scalarReadData_0 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_5) begin
      io_scalarReadData_0 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_6) begin
      io_scalarReadData_0 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_7) begin
      io_scalarReadData_0 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_8) begin
      io_scalarReadData_0 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_9) begin
      io_scalarReadData_0 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_10) begin
      io_scalarReadData_0 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_11) begin
      io_scalarReadData_0 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_12) begin
      io_scalarReadData_0 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_13) begin
      io_scalarReadData_0 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_14) begin
      io_scalarReadData_0 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_15) begin
      io_scalarReadData_0 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_16) begin
      io_scalarReadData_0 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_17) begin
      io_scalarReadData_0 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_18) begin
      io_scalarReadData_0 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_19) begin
      io_scalarReadData_0 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_20) begin
      io_scalarReadData_0 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_21) begin
      io_scalarReadData_0 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_22) begin
      io_scalarReadData_0 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_23) begin
      io_scalarReadData_0 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_24) begin
      io_scalarReadData_0 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_25) begin
      io_scalarReadData_0 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_26) begin
      io_scalarReadData_0 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_27) begin
      io_scalarReadData_0 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_1 = 32'h0;
    if(when_BankedScratchMemory_l262_8) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_9) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_10) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_11) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_12) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_13) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_14) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_15) begin
      if(scalarUsedPortBReg_1) begin
        io_scalarReadData_1 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_1 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_1) begin
      io_scalarReadData_1 = fwdGap2Data_1;
    end
    if(when_BankedScratchMemory_l390_28) begin
      io_scalarReadData_1 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_29) begin
      io_scalarReadData_1 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_30) begin
      io_scalarReadData_1 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_31) begin
      io_scalarReadData_1 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_32) begin
      io_scalarReadData_1 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_33) begin
      io_scalarReadData_1 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_34) begin
      io_scalarReadData_1 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_35) begin
      io_scalarReadData_1 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_36) begin
      io_scalarReadData_1 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_37) begin
      io_scalarReadData_1 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_38) begin
      io_scalarReadData_1 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_39) begin
      io_scalarReadData_1 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_40) begin
      io_scalarReadData_1 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_41) begin
      io_scalarReadData_1 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_42) begin
      io_scalarReadData_1 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_43) begin
      io_scalarReadData_1 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_44) begin
      io_scalarReadData_1 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_45) begin
      io_scalarReadData_1 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_46) begin
      io_scalarReadData_1 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_47) begin
      io_scalarReadData_1 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_48) begin
      io_scalarReadData_1 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_49) begin
      io_scalarReadData_1 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_50) begin
      io_scalarReadData_1 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_51) begin
      io_scalarReadData_1 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_52) begin
      io_scalarReadData_1 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_53) begin
      io_scalarReadData_1 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_54) begin
      io_scalarReadData_1 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_55) begin
      io_scalarReadData_1 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_2 = 32'h0;
    if(when_BankedScratchMemory_l262_16) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_17) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_18) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_19) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_20) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_21) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_22) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_23) begin
      if(scalarUsedPortBReg_2) begin
        io_scalarReadData_2 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_2 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_2) begin
      io_scalarReadData_2 = fwdGap2Data_2;
    end
    if(when_BankedScratchMemory_l390_56) begin
      io_scalarReadData_2 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_57) begin
      io_scalarReadData_2 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_58) begin
      io_scalarReadData_2 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_59) begin
      io_scalarReadData_2 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_60) begin
      io_scalarReadData_2 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_61) begin
      io_scalarReadData_2 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_62) begin
      io_scalarReadData_2 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_63) begin
      io_scalarReadData_2 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_64) begin
      io_scalarReadData_2 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_65) begin
      io_scalarReadData_2 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_66) begin
      io_scalarReadData_2 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_67) begin
      io_scalarReadData_2 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_68) begin
      io_scalarReadData_2 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_69) begin
      io_scalarReadData_2 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_70) begin
      io_scalarReadData_2 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_71) begin
      io_scalarReadData_2 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_72) begin
      io_scalarReadData_2 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_73) begin
      io_scalarReadData_2 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_74) begin
      io_scalarReadData_2 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_75) begin
      io_scalarReadData_2 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_76) begin
      io_scalarReadData_2 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_77) begin
      io_scalarReadData_2 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_78) begin
      io_scalarReadData_2 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_79) begin
      io_scalarReadData_2 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_80) begin
      io_scalarReadData_2 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_81) begin
      io_scalarReadData_2 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_82) begin
      io_scalarReadData_2 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_83) begin
      io_scalarReadData_2 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_3 = 32'h0;
    if(when_BankedScratchMemory_l262_24) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_25) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_26) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_27) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_28) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_29) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_30) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_31) begin
      if(scalarUsedPortBReg_3) begin
        io_scalarReadData_3 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_3 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_3) begin
      io_scalarReadData_3 = fwdGap2Data_3;
    end
    if(when_BankedScratchMemory_l390_84) begin
      io_scalarReadData_3 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_85) begin
      io_scalarReadData_3 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_86) begin
      io_scalarReadData_3 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_87) begin
      io_scalarReadData_3 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_88) begin
      io_scalarReadData_3 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_89) begin
      io_scalarReadData_3 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_90) begin
      io_scalarReadData_3 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_91) begin
      io_scalarReadData_3 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_92) begin
      io_scalarReadData_3 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_93) begin
      io_scalarReadData_3 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_94) begin
      io_scalarReadData_3 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_95) begin
      io_scalarReadData_3 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_96) begin
      io_scalarReadData_3 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_97) begin
      io_scalarReadData_3 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_98) begin
      io_scalarReadData_3 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_99) begin
      io_scalarReadData_3 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_100) begin
      io_scalarReadData_3 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_101) begin
      io_scalarReadData_3 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_102) begin
      io_scalarReadData_3 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_103) begin
      io_scalarReadData_3 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_104) begin
      io_scalarReadData_3 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_105) begin
      io_scalarReadData_3 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_106) begin
      io_scalarReadData_3 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_107) begin
      io_scalarReadData_3 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_108) begin
      io_scalarReadData_3 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_109) begin
      io_scalarReadData_3 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_110) begin
      io_scalarReadData_3 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_111) begin
      io_scalarReadData_3 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_4 = 32'h0;
    if(when_BankedScratchMemory_l262_32) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_33) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_34) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_35) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_36) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_37) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_38) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_39) begin
      if(scalarUsedPortBReg_4) begin
        io_scalarReadData_4 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_4 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_4) begin
      io_scalarReadData_4 = fwdGap2Data_4;
    end
    if(when_BankedScratchMemory_l390_112) begin
      io_scalarReadData_4 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_113) begin
      io_scalarReadData_4 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_114) begin
      io_scalarReadData_4 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_115) begin
      io_scalarReadData_4 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_116) begin
      io_scalarReadData_4 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_117) begin
      io_scalarReadData_4 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_118) begin
      io_scalarReadData_4 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_119) begin
      io_scalarReadData_4 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_120) begin
      io_scalarReadData_4 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_121) begin
      io_scalarReadData_4 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_122) begin
      io_scalarReadData_4 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_123) begin
      io_scalarReadData_4 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_124) begin
      io_scalarReadData_4 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_125) begin
      io_scalarReadData_4 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_126) begin
      io_scalarReadData_4 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_127) begin
      io_scalarReadData_4 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_128) begin
      io_scalarReadData_4 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_129) begin
      io_scalarReadData_4 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_130) begin
      io_scalarReadData_4 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_131) begin
      io_scalarReadData_4 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_132) begin
      io_scalarReadData_4 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_133) begin
      io_scalarReadData_4 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_134) begin
      io_scalarReadData_4 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_135) begin
      io_scalarReadData_4 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_136) begin
      io_scalarReadData_4 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_137) begin
      io_scalarReadData_4 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_138) begin
      io_scalarReadData_4 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_139) begin
      io_scalarReadData_4 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_5 = 32'h0;
    if(when_BankedScratchMemory_l262_40) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_41) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_42) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_43) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_44) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_45) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_46) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_47) begin
      if(scalarUsedPortBReg_5) begin
        io_scalarReadData_5 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_5 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_5) begin
      io_scalarReadData_5 = fwdGap2Data_5;
    end
    if(when_BankedScratchMemory_l390_140) begin
      io_scalarReadData_5 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_141) begin
      io_scalarReadData_5 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_142) begin
      io_scalarReadData_5 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_143) begin
      io_scalarReadData_5 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_144) begin
      io_scalarReadData_5 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_145) begin
      io_scalarReadData_5 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_146) begin
      io_scalarReadData_5 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_147) begin
      io_scalarReadData_5 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_148) begin
      io_scalarReadData_5 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_149) begin
      io_scalarReadData_5 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_150) begin
      io_scalarReadData_5 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_151) begin
      io_scalarReadData_5 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_152) begin
      io_scalarReadData_5 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_153) begin
      io_scalarReadData_5 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_154) begin
      io_scalarReadData_5 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_155) begin
      io_scalarReadData_5 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_156) begin
      io_scalarReadData_5 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_157) begin
      io_scalarReadData_5 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_158) begin
      io_scalarReadData_5 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_159) begin
      io_scalarReadData_5 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_160) begin
      io_scalarReadData_5 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_161) begin
      io_scalarReadData_5 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_162) begin
      io_scalarReadData_5 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_163) begin
      io_scalarReadData_5 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_164) begin
      io_scalarReadData_5 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_165) begin
      io_scalarReadData_5 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_166) begin
      io_scalarReadData_5 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_167) begin
      io_scalarReadData_5 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_6 = 32'h0;
    if(when_BankedScratchMemory_l262_48) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_49) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_50) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_51) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_52) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_53) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_54) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_55) begin
      if(scalarUsedPortBReg_6) begin
        io_scalarReadData_6 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_6 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_6) begin
      io_scalarReadData_6 = fwdGap2Data_6;
    end
    if(when_BankedScratchMemory_l390_168) begin
      io_scalarReadData_6 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_169) begin
      io_scalarReadData_6 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_170) begin
      io_scalarReadData_6 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_171) begin
      io_scalarReadData_6 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_172) begin
      io_scalarReadData_6 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_173) begin
      io_scalarReadData_6 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_174) begin
      io_scalarReadData_6 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_175) begin
      io_scalarReadData_6 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_176) begin
      io_scalarReadData_6 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_177) begin
      io_scalarReadData_6 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_178) begin
      io_scalarReadData_6 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_179) begin
      io_scalarReadData_6 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_180) begin
      io_scalarReadData_6 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_181) begin
      io_scalarReadData_6 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_182) begin
      io_scalarReadData_6 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_183) begin
      io_scalarReadData_6 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_184) begin
      io_scalarReadData_6 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_185) begin
      io_scalarReadData_6 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_186) begin
      io_scalarReadData_6 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_187) begin
      io_scalarReadData_6 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_188) begin
      io_scalarReadData_6 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_189) begin
      io_scalarReadData_6 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_190) begin
      io_scalarReadData_6 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_191) begin
      io_scalarReadData_6 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_192) begin
      io_scalarReadData_6 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_193) begin
      io_scalarReadData_6 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_194) begin
      io_scalarReadData_6 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_195) begin
      io_scalarReadData_6 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_7 = 32'h0;
    if(when_BankedScratchMemory_l262_56) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_57) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_58) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_59) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_60) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_61) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_62) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_63) begin
      if(scalarUsedPortBReg_7) begin
        io_scalarReadData_7 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_7 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_7) begin
      io_scalarReadData_7 = fwdGap2Data_7;
    end
    if(when_BankedScratchMemory_l390_196) begin
      io_scalarReadData_7 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_197) begin
      io_scalarReadData_7 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_198) begin
      io_scalarReadData_7 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_199) begin
      io_scalarReadData_7 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_200) begin
      io_scalarReadData_7 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_201) begin
      io_scalarReadData_7 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_202) begin
      io_scalarReadData_7 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_203) begin
      io_scalarReadData_7 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_204) begin
      io_scalarReadData_7 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_205) begin
      io_scalarReadData_7 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_206) begin
      io_scalarReadData_7 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_207) begin
      io_scalarReadData_7 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_208) begin
      io_scalarReadData_7 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_209) begin
      io_scalarReadData_7 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_210) begin
      io_scalarReadData_7 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_211) begin
      io_scalarReadData_7 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_212) begin
      io_scalarReadData_7 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_213) begin
      io_scalarReadData_7 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_214) begin
      io_scalarReadData_7 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_215) begin
      io_scalarReadData_7 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_216) begin
      io_scalarReadData_7 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_217) begin
      io_scalarReadData_7 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_218) begin
      io_scalarReadData_7 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_219) begin
      io_scalarReadData_7 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_220) begin
      io_scalarReadData_7 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_221) begin
      io_scalarReadData_7 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_222) begin
      io_scalarReadData_7 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_223) begin
      io_scalarReadData_7 = io_writeData_27;
    end
  end

  always @(*) begin
    io_scalarReadData_8 = 32'h0;
    if(when_BankedScratchMemory_l262_64) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_0_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_0_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_65) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_1_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_1_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_66) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_2_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_2_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_67) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_3_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_3_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_68) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_4_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_4_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_69) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_5_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_5_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_70) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_6_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_6_io_aRdData;
      end
    end
    if(when_BankedScratchMemory_l262_71) begin
      if(scalarUsedPortBReg_8) begin
        io_scalarReadData_8 = banks_7_io_bRdData;
      end else begin
        io_scalarReadData_8 = banks_7_io_aRdData;
      end
    end
    if(fwdGap2Valid_8) begin
      io_scalarReadData_8 = fwdGap2Data_8;
    end
    if(when_BankedScratchMemory_l390_224) begin
      io_scalarReadData_8 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l390_225) begin
      io_scalarReadData_8 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l390_226) begin
      io_scalarReadData_8 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l390_227) begin
      io_scalarReadData_8 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l390_228) begin
      io_scalarReadData_8 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l390_229) begin
      io_scalarReadData_8 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l390_230) begin
      io_scalarReadData_8 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l390_231) begin
      io_scalarReadData_8 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l390_232) begin
      io_scalarReadData_8 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l390_233) begin
      io_scalarReadData_8 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l390_234) begin
      io_scalarReadData_8 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l390_235) begin
      io_scalarReadData_8 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l390_236) begin
      io_scalarReadData_8 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l390_237) begin
      io_scalarReadData_8 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l390_238) begin
      io_scalarReadData_8 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l390_239) begin
      io_scalarReadData_8 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l390_240) begin
      io_scalarReadData_8 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l390_241) begin
      io_scalarReadData_8 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l390_242) begin
      io_scalarReadData_8 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l390_243) begin
      io_scalarReadData_8 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l390_244) begin
      io_scalarReadData_8 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l390_245) begin
      io_scalarReadData_8 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l390_246) begin
      io_scalarReadData_8 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l390_247) begin
      io_scalarReadData_8 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l390_248) begin
      io_scalarReadData_8 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l390_249) begin
      io_scalarReadData_8 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l390_250) begin
      io_scalarReadData_8 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l390_251) begin
      io_scalarReadData_8 = io_writeData_27;
    end
  end

  assign scalarBankReq_0 = io_scalarReadAddr_0[2 : 0];
  assign scalarBankRow_0 = io_scalarReadAddr_0[10 : 3];
  assign scalarBankReq_1 = io_scalarReadAddr_1[2 : 0];
  assign scalarBankRow_1 = io_scalarReadAddr_1[10 : 3];
  assign scalarBankReq_2 = io_scalarReadAddr_2[2 : 0];
  assign scalarBankRow_2 = io_scalarReadAddr_2[10 : 3];
  assign scalarBankReq_3 = io_scalarReadAddr_3[2 : 0];
  assign scalarBankRow_3 = io_scalarReadAddr_3[10 : 3];
  assign scalarBankReq_4 = io_scalarReadAddr_4[2 : 0];
  assign scalarBankRow_4 = io_scalarReadAddr_4[10 : 3];
  assign scalarBankReq_5 = io_scalarReadAddr_5[2 : 0];
  assign scalarBankRow_5 = io_scalarReadAddr_5[10 : 3];
  assign scalarBankReq_6 = io_scalarReadAddr_6[2 : 0];
  assign scalarBankRow_6 = io_scalarReadAddr_6[10 : 3];
  assign scalarBankReq_7 = io_scalarReadAddr_7[2 : 0];
  assign scalarBankRow_7 = io_scalarReadAddr_7[10 : 3];
  assign scalarBankReq_8 = io_scalarReadAddr_8[2 : 0];
  assign scalarBankRow_8 = io_scalarReadAddr_8[10 : 3];
  always @(*) begin
    scalarUsedPortB_0 = 1'b0;
    if(when_BankedScratchMemory_l234) begin
      scalarUsedPortB_0 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_9) begin
      scalarUsedPortB_0 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_18) begin
      scalarUsedPortB_0 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_27) begin
      scalarUsedPortB_0 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_36) begin
      scalarUsedPortB_0 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_45) begin
      scalarUsedPortB_0 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_54) begin
      scalarUsedPortB_0 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_63) begin
      scalarUsedPortB_0 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_1 = 1'b0;
    if(when_BankedScratchMemory_l234_1) begin
      scalarUsedPortB_1 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_10) begin
      scalarUsedPortB_1 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_19) begin
      scalarUsedPortB_1 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_28) begin
      scalarUsedPortB_1 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_37) begin
      scalarUsedPortB_1 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_46) begin
      scalarUsedPortB_1 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_55) begin
      scalarUsedPortB_1 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_64) begin
      scalarUsedPortB_1 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_2 = 1'b0;
    if(when_BankedScratchMemory_l234_2) begin
      scalarUsedPortB_2 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_11) begin
      scalarUsedPortB_2 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_20) begin
      scalarUsedPortB_2 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_29) begin
      scalarUsedPortB_2 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_38) begin
      scalarUsedPortB_2 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_47) begin
      scalarUsedPortB_2 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_56) begin
      scalarUsedPortB_2 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_65) begin
      scalarUsedPortB_2 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_3 = 1'b0;
    if(when_BankedScratchMemory_l234_3) begin
      scalarUsedPortB_3 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_12) begin
      scalarUsedPortB_3 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_21) begin
      scalarUsedPortB_3 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_30) begin
      scalarUsedPortB_3 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_39) begin
      scalarUsedPortB_3 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_48) begin
      scalarUsedPortB_3 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_57) begin
      scalarUsedPortB_3 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_66) begin
      scalarUsedPortB_3 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_4 = 1'b0;
    if(when_BankedScratchMemory_l234_4) begin
      scalarUsedPortB_4 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_13) begin
      scalarUsedPortB_4 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_22) begin
      scalarUsedPortB_4 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_31) begin
      scalarUsedPortB_4 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_40) begin
      scalarUsedPortB_4 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_49) begin
      scalarUsedPortB_4 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_58) begin
      scalarUsedPortB_4 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_67) begin
      scalarUsedPortB_4 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_5 = 1'b0;
    if(when_BankedScratchMemory_l234_5) begin
      scalarUsedPortB_5 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_14) begin
      scalarUsedPortB_5 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_23) begin
      scalarUsedPortB_5 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_32) begin
      scalarUsedPortB_5 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_41) begin
      scalarUsedPortB_5 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_50) begin
      scalarUsedPortB_5 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_59) begin
      scalarUsedPortB_5 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_68) begin
      scalarUsedPortB_5 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_6 = 1'b0;
    if(when_BankedScratchMemory_l234_6) begin
      scalarUsedPortB_6 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_15) begin
      scalarUsedPortB_6 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_24) begin
      scalarUsedPortB_6 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_33) begin
      scalarUsedPortB_6 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_42) begin
      scalarUsedPortB_6 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_51) begin
      scalarUsedPortB_6 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_60) begin
      scalarUsedPortB_6 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_69) begin
      scalarUsedPortB_6 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_7 = 1'b0;
    if(when_BankedScratchMemory_l234_7) begin
      scalarUsedPortB_7 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_16) begin
      scalarUsedPortB_7 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_25) begin
      scalarUsedPortB_7 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_34) begin
      scalarUsedPortB_7 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_43) begin
      scalarUsedPortB_7 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_52) begin
      scalarUsedPortB_7 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_61) begin
      scalarUsedPortB_7 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_70) begin
      scalarUsedPortB_7 = 1'b1;
    end
  end

  always @(*) begin
    scalarUsedPortB_8 = 1'b0;
    if(when_BankedScratchMemory_l234_8) begin
      scalarUsedPortB_8 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_17) begin
      scalarUsedPortB_8 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_26) begin
      scalarUsedPortB_8 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_35) begin
      scalarUsedPortB_8 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_44) begin
      scalarUsedPortB_8 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_53) begin
      scalarUsedPortB_8 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_62) begin
      scalarUsedPortB_8 = 1'b1;
    end
    if(when_BankedScratchMemory_l234_71) begin
      scalarUsedPortB_8 = 1'b1;
    end
  end

  assign _zz_when_BankedScratchMemory_l228 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_1 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b000));
  assign when_BankedScratchMemory_l228 = (_zz_when_BankedScratchMemory_l228_1 && (! _zz_when_BankedScratchMemory_l228));
  assign _zz_when_BankedScratchMemory_l234 = ((_zz_when_BankedScratchMemory_l228_1 && _zz_when_BankedScratchMemory_l228) && (! _zz_when_BankedScratchMemory_l245));
  assign when_BankedScratchMemory_l245 = (_zz_when_BankedScratchMemory_l228_1 && _zz_when_BankedScratchMemory_l245);
  assign _zz_when_BankedScratchMemory_l245_1 = (_zz_when_BankedScratchMemory_l245 || (_zz_when_BankedScratchMemory_l228 && _zz_when_BankedScratchMemory_l228_1));
  assign _zz_when_BankedScratchMemory_l228_2 = (_zz_when_BankedScratchMemory_l228 || _zz_when_BankedScratchMemory_l228_1);
  assign when_BankedScratchMemory_l234 = (_zz_when_BankedScratchMemory_l234 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242 = (_zz_when_BankedScratchMemory_l234 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_3 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b000));
  assign when_BankedScratchMemory_l228_1 = (_zz_when_BankedScratchMemory_l228_3 && (! _zz_when_BankedScratchMemory_l228_2));
  assign _zz_when_BankedScratchMemory_l234_1 = ((_zz_when_BankedScratchMemory_l228_3 && _zz_when_BankedScratchMemory_l228_2) && (! _zz_when_BankedScratchMemory_l245_1));
  assign when_BankedScratchMemory_l245_1 = (_zz_when_BankedScratchMemory_l228_3 && _zz_when_BankedScratchMemory_l245_1);
  assign _zz_when_BankedScratchMemory_l245_2 = (_zz_when_BankedScratchMemory_l245_1 || (_zz_when_BankedScratchMemory_l228_2 && _zz_when_BankedScratchMemory_l228_3));
  assign _zz_when_BankedScratchMemory_l228_4 = (_zz_when_BankedScratchMemory_l228_2 || _zz_when_BankedScratchMemory_l228_3);
  assign when_BankedScratchMemory_l234_1 = (_zz_when_BankedScratchMemory_l234_1 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_1 = (_zz_when_BankedScratchMemory_l234_1 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_5 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b000));
  assign when_BankedScratchMemory_l228_2 = (_zz_when_BankedScratchMemory_l228_5 && (! _zz_when_BankedScratchMemory_l228_4));
  assign _zz_when_BankedScratchMemory_l234_2 = ((_zz_when_BankedScratchMemory_l228_5 && _zz_when_BankedScratchMemory_l228_4) && (! _zz_when_BankedScratchMemory_l245_2));
  assign when_BankedScratchMemory_l245_2 = (_zz_when_BankedScratchMemory_l228_5 && _zz_when_BankedScratchMemory_l245_2);
  assign _zz_when_BankedScratchMemory_l245_3 = (_zz_when_BankedScratchMemory_l245_2 || (_zz_when_BankedScratchMemory_l228_4 && _zz_when_BankedScratchMemory_l228_5));
  assign _zz_when_BankedScratchMemory_l228_6 = (_zz_when_BankedScratchMemory_l228_4 || _zz_when_BankedScratchMemory_l228_5);
  assign when_BankedScratchMemory_l234_2 = (_zz_when_BankedScratchMemory_l234_2 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_2 = (_zz_when_BankedScratchMemory_l234_2 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_7 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b000));
  assign when_BankedScratchMemory_l228_3 = (_zz_when_BankedScratchMemory_l228_7 && (! _zz_when_BankedScratchMemory_l228_6));
  assign _zz_when_BankedScratchMemory_l234_3 = ((_zz_when_BankedScratchMemory_l228_7 && _zz_when_BankedScratchMemory_l228_6) && (! _zz_when_BankedScratchMemory_l245_3));
  assign when_BankedScratchMemory_l245_3 = (_zz_when_BankedScratchMemory_l228_7 && _zz_when_BankedScratchMemory_l245_3);
  assign _zz_when_BankedScratchMemory_l245_4 = (_zz_when_BankedScratchMemory_l245_3 || (_zz_when_BankedScratchMemory_l228_6 && _zz_when_BankedScratchMemory_l228_7));
  assign _zz_when_BankedScratchMemory_l228_8 = (_zz_when_BankedScratchMemory_l228_6 || _zz_when_BankedScratchMemory_l228_7);
  assign when_BankedScratchMemory_l234_3 = (_zz_when_BankedScratchMemory_l234_3 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_3 = (_zz_when_BankedScratchMemory_l234_3 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_9 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b000));
  assign when_BankedScratchMemory_l228_4 = (_zz_when_BankedScratchMemory_l228_9 && (! _zz_when_BankedScratchMemory_l228_8));
  assign _zz_when_BankedScratchMemory_l234_4 = ((_zz_when_BankedScratchMemory_l228_9 && _zz_when_BankedScratchMemory_l228_8) && (! _zz_when_BankedScratchMemory_l245_4));
  assign when_BankedScratchMemory_l245_4 = (_zz_when_BankedScratchMemory_l228_9 && _zz_when_BankedScratchMemory_l245_4);
  assign _zz_when_BankedScratchMemory_l245_5 = (_zz_when_BankedScratchMemory_l245_4 || (_zz_when_BankedScratchMemory_l228_8 && _zz_when_BankedScratchMemory_l228_9));
  assign _zz_when_BankedScratchMemory_l228_10 = (_zz_when_BankedScratchMemory_l228_8 || _zz_when_BankedScratchMemory_l228_9);
  assign when_BankedScratchMemory_l234_4 = (_zz_when_BankedScratchMemory_l234_4 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_4 = (_zz_when_BankedScratchMemory_l234_4 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_11 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b000));
  assign when_BankedScratchMemory_l228_5 = (_zz_when_BankedScratchMemory_l228_11 && (! _zz_when_BankedScratchMemory_l228_10));
  assign _zz_when_BankedScratchMemory_l234_5 = ((_zz_when_BankedScratchMemory_l228_11 && _zz_when_BankedScratchMemory_l228_10) && (! _zz_when_BankedScratchMemory_l245_5));
  assign when_BankedScratchMemory_l245_5 = (_zz_when_BankedScratchMemory_l228_11 && _zz_when_BankedScratchMemory_l245_5);
  assign _zz_when_BankedScratchMemory_l245_6 = (_zz_when_BankedScratchMemory_l245_5 || (_zz_when_BankedScratchMemory_l228_10 && _zz_when_BankedScratchMemory_l228_11));
  assign _zz_when_BankedScratchMemory_l228_12 = (_zz_when_BankedScratchMemory_l228_10 || _zz_when_BankedScratchMemory_l228_11);
  assign when_BankedScratchMemory_l234_5 = (_zz_when_BankedScratchMemory_l234_5 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_5 = (_zz_when_BankedScratchMemory_l234_5 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_13 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b000));
  assign when_BankedScratchMemory_l228_6 = (_zz_when_BankedScratchMemory_l228_13 && (! _zz_when_BankedScratchMemory_l228_12));
  assign _zz_when_BankedScratchMemory_l234_6 = ((_zz_when_BankedScratchMemory_l228_13 && _zz_when_BankedScratchMemory_l228_12) && (! _zz_when_BankedScratchMemory_l245_6));
  assign when_BankedScratchMemory_l245_6 = (_zz_when_BankedScratchMemory_l228_13 && _zz_when_BankedScratchMemory_l245_6);
  assign _zz_when_BankedScratchMemory_l245_7 = (_zz_when_BankedScratchMemory_l245_6 || (_zz_when_BankedScratchMemory_l228_12 && _zz_when_BankedScratchMemory_l228_13));
  assign _zz_when_BankedScratchMemory_l228_14 = (_zz_when_BankedScratchMemory_l228_12 || _zz_when_BankedScratchMemory_l228_13);
  assign when_BankedScratchMemory_l234_6 = (_zz_when_BankedScratchMemory_l234_6 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_6 = (_zz_when_BankedScratchMemory_l234_6 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_15 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b000));
  assign when_BankedScratchMemory_l228_7 = (_zz_when_BankedScratchMemory_l228_15 && (! _zz_when_BankedScratchMemory_l228_14));
  assign _zz_when_BankedScratchMemory_l234_7 = ((_zz_when_BankedScratchMemory_l228_15 && _zz_when_BankedScratchMemory_l228_14) && (! _zz_when_BankedScratchMemory_l245_7));
  assign when_BankedScratchMemory_l245_7 = (_zz_when_BankedScratchMemory_l228_15 && _zz_when_BankedScratchMemory_l245_7);
  assign _zz_when_BankedScratchMemory_l245_8 = (_zz_when_BankedScratchMemory_l245_7 || (_zz_when_BankedScratchMemory_l228_14 && _zz_when_BankedScratchMemory_l228_15));
  assign _zz_when_BankedScratchMemory_l228_16 = (_zz_when_BankedScratchMemory_l228_14 || _zz_when_BankedScratchMemory_l228_15);
  assign when_BankedScratchMemory_l234_7 = (_zz_when_BankedScratchMemory_l234_7 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_7 = (_zz_when_BankedScratchMemory_l234_7 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_17 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b000));
  assign when_BankedScratchMemory_l228_8 = (_zz_when_BankedScratchMemory_l228_17 && (! _zz_when_BankedScratchMemory_l228_16));
  assign _zz_when_BankedScratchMemory_l234_8 = ((_zz_when_BankedScratchMemory_l228_17 && _zz_when_BankedScratchMemory_l228_16) && (! _zz_when_BankedScratchMemory_l245_8));
  assign when_BankedScratchMemory_l245_8 = (_zz_when_BankedScratchMemory_l228_17 && _zz_when_BankedScratchMemory_l245_8);
  assign when_BankedScratchMemory_l234_8 = (_zz_when_BankedScratchMemory_l234_8 && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l242_8 = (_zz_when_BankedScratchMemory_l234_8 && bankWriteActive_0);
  assign _zz_when_BankedScratchMemory_l228_18 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245_9 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_19 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b001));
  assign when_BankedScratchMemory_l228_9 = (_zz_when_BankedScratchMemory_l228_19 && (! _zz_when_BankedScratchMemory_l228_18));
  assign _zz_when_BankedScratchMemory_l234_9 = ((_zz_when_BankedScratchMemory_l228_19 && _zz_when_BankedScratchMemory_l228_18) && (! _zz_when_BankedScratchMemory_l245_9));
  assign when_BankedScratchMemory_l245_9 = (_zz_when_BankedScratchMemory_l228_19 && _zz_when_BankedScratchMemory_l245_9);
  assign _zz_when_BankedScratchMemory_l245_10 = (_zz_when_BankedScratchMemory_l245_9 || (_zz_when_BankedScratchMemory_l228_18 && _zz_when_BankedScratchMemory_l228_19));
  assign _zz_when_BankedScratchMemory_l228_20 = (_zz_when_BankedScratchMemory_l228_18 || _zz_when_BankedScratchMemory_l228_19);
  assign when_BankedScratchMemory_l234_9 = (_zz_when_BankedScratchMemory_l234_9 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_9 = (_zz_when_BankedScratchMemory_l234_9 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_21 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b001));
  assign when_BankedScratchMemory_l228_10 = (_zz_when_BankedScratchMemory_l228_21 && (! _zz_when_BankedScratchMemory_l228_20));
  assign _zz_when_BankedScratchMemory_l234_10 = ((_zz_when_BankedScratchMemory_l228_21 && _zz_when_BankedScratchMemory_l228_20) && (! _zz_when_BankedScratchMemory_l245_10));
  assign when_BankedScratchMemory_l245_10 = (_zz_when_BankedScratchMemory_l228_21 && _zz_when_BankedScratchMemory_l245_10);
  assign _zz_when_BankedScratchMemory_l245_11 = (_zz_when_BankedScratchMemory_l245_10 || (_zz_when_BankedScratchMemory_l228_20 && _zz_when_BankedScratchMemory_l228_21));
  assign _zz_when_BankedScratchMemory_l228_22 = (_zz_when_BankedScratchMemory_l228_20 || _zz_when_BankedScratchMemory_l228_21);
  assign when_BankedScratchMemory_l234_10 = (_zz_when_BankedScratchMemory_l234_10 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_10 = (_zz_when_BankedScratchMemory_l234_10 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_23 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b001));
  assign when_BankedScratchMemory_l228_11 = (_zz_when_BankedScratchMemory_l228_23 && (! _zz_when_BankedScratchMemory_l228_22));
  assign _zz_when_BankedScratchMemory_l234_11 = ((_zz_when_BankedScratchMemory_l228_23 && _zz_when_BankedScratchMemory_l228_22) && (! _zz_when_BankedScratchMemory_l245_11));
  assign when_BankedScratchMemory_l245_11 = (_zz_when_BankedScratchMemory_l228_23 && _zz_when_BankedScratchMemory_l245_11);
  assign _zz_when_BankedScratchMemory_l245_12 = (_zz_when_BankedScratchMemory_l245_11 || (_zz_when_BankedScratchMemory_l228_22 && _zz_when_BankedScratchMemory_l228_23));
  assign _zz_when_BankedScratchMemory_l228_24 = (_zz_when_BankedScratchMemory_l228_22 || _zz_when_BankedScratchMemory_l228_23);
  assign when_BankedScratchMemory_l234_11 = (_zz_when_BankedScratchMemory_l234_11 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_11 = (_zz_when_BankedScratchMemory_l234_11 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_25 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b001));
  assign when_BankedScratchMemory_l228_12 = (_zz_when_BankedScratchMemory_l228_25 && (! _zz_when_BankedScratchMemory_l228_24));
  assign _zz_when_BankedScratchMemory_l234_12 = ((_zz_when_BankedScratchMemory_l228_25 && _zz_when_BankedScratchMemory_l228_24) && (! _zz_when_BankedScratchMemory_l245_12));
  assign when_BankedScratchMemory_l245_12 = (_zz_when_BankedScratchMemory_l228_25 && _zz_when_BankedScratchMemory_l245_12);
  assign _zz_when_BankedScratchMemory_l245_13 = (_zz_when_BankedScratchMemory_l245_12 || (_zz_when_BankedScratchMemory_l228_24 && _zz_when_BankedScratchMemory_l228_25));
  assign _zz_when_BankedScratchMemory_l228_26 = (_zz_when_BankedScratchMemory_l228_24 || _zz_when_BankedScratchMemory_l228_25);
  assign when_BankedScratchMemory_l234_12 = (_zz_when_BankedScratchMemory_l234_12 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_12 = (_zz_when_BankedScratchMemory_l234_12 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_27 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b001));
  assign when_BankedScratchMemory_l228_13 = (_zz_when_BankedScratchMemory_l228_27 && (! _zz_when_BankedScratchMemory_l228_26));
  assign _zz_when_BankedScratchMemory_l234_13 = ((_zz_when_BankedScratchMemory_l228_27 && _zz_when_BankedScratchMemory_l228_26) && (! _zz_when_BankedScratchMemory_l245_13));
  assign when_BankedScratchMemory_l245_13 = (_zz_when_BankedScratchMemory_l228_27 && _zz_when_BankedScratchMemory_l245_13);
  assign _zz_when_BankedScratchMemory_l245_14 = (_zz_when_BankedScratchMemory_l245_13 || (_zz_when_BankedScratchMemory_l228_26 && _zz_when_BankedScratchMemory_l228_27));
  assign _zz_when_BankedScratchMemory_l228_28 = (_zz_when_BankedScratchMemory_l228_26 || _zz_when_BankedScratchMemory_l228_27);
  assign when_BankedScratchMemory_l234_13 = (_zz_when_BankedScratchMemory_l234_13 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_13 = (_zz_when_BankedScratchMemory_l234_13 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_29 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b001));
  assign when_BankedScratchMemory_l228_14 = (_zz_when_BankedScratchMemory_l228_29 && (! _zz_when_BankedScratchMemory_l228_28));
  assign _zz_when_BankedScratchMemory_l234_14 = ((_zz_when_BankedScratchMemory_l228_29 && _zz_when_BankedScratchMemory_l228_28) && (! _zz_when_BankedScratchMemory_l245_14));
  assign when_BankedScratchMemory_l245_14 = (_zz_when_BankedScratchMemory_l228_29 && _zz_when_BankedScratchMemory_l245_14);
  assign _zz_when_BankedScratchMemory_l245_15 = (_zz_when_BankedScratchMemory_l245_14 || (_zz_when_BankedScratchMemory_l228_28 && _zz_when_BankedScratchMemory_l228_29));
  assign _zz_when_BankedScratchMemory_l228_30 = (_zz_when_BankedScratchMemory_l228_28 || _zz_when_BankedScratchMemory_l228_29);
  assign when_BankedScratchMemory_l234_14 = (_zz_when_BankedScratchMemory_l234_14 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_14 = (_zz_when_BankedScratchMemory_l234_14 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_31 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b001));
  assign when_BankedScratchMemory_l228_15 = (_zz_when_BankedScratchMemory_l228_31 && (! _zz_when_BankedScratchMemory_l228_30));
  assign _zz_when_BankedScratchMemory_l234_15 = ((_zz_when_BankedScratchMemory_l228_31 && _zz_when_BankedScratchMemory_l228_30) && (! _zz_when_BankedScratchMemory_l245_15));
  assign when_BankedScratchMemory_l245_15 = (_zz_when_BankedScratchMemory_l228_31 && _zz_when_BankedScratchMemory_l245_15);
  assign _zz_when_BankedScratchMemory_l245_16 = (_zz_when_BankedScratchMemory_l245_15 || (_zz_when_BankedScratchMemory_l228_30 && _zz_when_BankedScratchMemory_l228_31));
  assign _zz_when_BankedScratchMemory_l228_32 = (_zz_when_BankedScratchMemory_l228_30 || _zz_when_BankedScratchMemory_l228_31);
  assign when_BankedScratchMemory_l234_15 = (_zz_when_BankedScratchMemory_l234_15 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_15 = (_zz_when_BankedScratchMemory_l234_15 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_33 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b001));
  assign when_BankedScratchMemory_l228_16 = (_zz_when_BankedScratchMemory_l228_33 && (! _zz_when_BankedScratchMemory_l228_32));
  assign _zz_when_BankedScratchMemory_l234_16 = ((_zz_when_BankedScratchMemory_l228_33 && _zz_when_BankedScratchMemory_l228_32) && (! _zz_when_BankedScratchMemory_l245_16));
  assign when_BankedScratchMemory_l245_16 = (_zz_when_BankedScratchMemory_l228_33 && _zz_when_BankedScratchMemory_l245_16);
  assign _zz_when_BankedScratchMemory_l245_17 = (_zz_when_BankedScratchMemory_l245_16 || (_zz_when_BankedScratchMemory_l228_32 && _zz_when_BankedScratchMemory_l228_33));
  assign _zz_when_BankedScratchMemory_l228_34 = (_zz_when_BankedScratchMemory_l228_32 || _zz_when_BankedScratchMemory_l228_33);
  assign when_BankedScratchMemory_l234_16 = (_zz_when_BankedScratchMemory_l234_16 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_16 = (_zz_when_BankedScratchMemory_l234_16 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_35 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b001));
  assign when_BankedScratchMemory_l228_17 = (_zz_when_BankedScratchMemory_l228_35 && (! _zz_when_BankedScratchMemory_l228_34));
  assign _zz_when_BankedScratchMemory_l234_17 = ((_zz_when_BankedScratchMemory_l228_35 && _zz_when_BankedScratchMemory_l228_34) && (! _zz_when_BankedScratchMemory_l245_17));
  assign when_BankedScratchMemory_l245_17 = (_zz_when_BankedScratchMemory_l228_35 && _zz_when_BankedScratchMemory_l245_17);
  assign when_BankedScratchMemory_l234_17 = (_zz_when_BankedScratchMemory_l234_17 && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l242_17 = (_zz_when_BankedScratchMemory_l234_17 && bankWriteActive_1);
  assign _zz_when_BankedScratchMemory_l228_36 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245_18 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_37 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b010));
  assign when_BankedScratchMemory_l228_18 = (_zz_when_BankedScratchMemory_l228_37 && (! _zz_when_BankedScratchMemory_l228_36));
  assign _zz_when_BankedScratchMemory_l234_18 = ((_zz_when_BankedScratchMemory_l228_37 && _zz_when_BankedScratchMemory_l228_36) && (! _zz_when_BankedScratchMemory_l245_18));
  assign when_BankedScratchMemory_l245_18 = (_zz_when_BankedScratchMemory_l228_37 && _zz_when_BankedScratchMemory_l245_18);
  assign _zz_when_BankedScratchMemory_l245_19 = (_zz_when_BankedScratchMemory_l245_18 || (_zz_when_BankedScratchMemory_l228_36 && _zz_when_BankedScratchMemory_l228_37));
  assign _zz_when_BankedScratchMemory_l228_38 = (_zz_when_BankedScratchMemory_l228_36 || _zz_when_BankedScratchMemory_l228_37);
  assign when_BankedScratchMemory_l234_18 = (_zz_when_BankedScratchMemory_l234_18 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_18 = (_zz_when_BankedScratchMemory_l234_18 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_39 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b010));
  assign when_BankedScratchMemory_l228_19 = (_zz_when_BankedScratchMemory_l228_39 && (! _zz_when_BankedScratchMemory_l228_38));
  assign _zz_when_BankedScratchMemory_l234_19 = ((_zz_when_BankedScratchMemory_l228_39 && _zz_when_BankedScratchMemory_l228_38) && (! _zz_when_BankedScratchMemory_l245_19));
  assign when_BankedScratchMemory_l245_19 = (_zz_when_BankedScratchMemory_l228_39 && _zz_when_BankedScratchMemory_l245_19);
  assign _zz_when_BankedScratchMemory_l245_20 = (_zz_when_BankedScratchMemory_l245_19 || (_zz_when_BankedScratchMemory_l228_38 && _zz_when_BankedScratchMemory_l228_39));
  assign _zz_when_BankedScratchMemory_l228_40 = (_zz_when_BankedScratchMemory_l228_38 || _zz_when_BankedScratchMemory_l228_39);
  assign when_BankedScratchMemory_l234_19 = (_zz_when_BankedScratchMemory_l234_19 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_19 = (_zz_when_BankedScratchMemory_l234_19 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_41 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b010));
  assign when_BankedScratchMemory_l228_20 = (_zz_when_BankedScratchMemory_l228_41 && (! _zz_when_BankedScratchMemory_l228_40));
  assign _zz_when_BankedScratchMemory_l234_20 = ((_zz_when_BankedScratchMemory_l228_41 && _zz_when_BankedScratchMemory_l228_40) && (! _zz_when_BankedScratchMemory_l245_20));
  assign when_BankedScratchMemory_l245_20 = (_zz_when_BankedScratchMemory_l228_41 && _zz_when_BankedScratchMemory_l245_20);
  assign _zz_when_BankedScratchMemory_l245_21 = (_zz_when_BankedScratchMemory_l245_20 || (_zz_when_BankedScratchMemory_l228_40 && _zz_when_BankedScratchMemory_l228_41));
  assign _zz_when_BankedScratchMemory_l228_42 = (_zz_when_BankedScratchMemory_l228_40 || _zz_when_BankedScratchMemory_l228_41);
  assign when_BankedScratchMemory_l234_20 = (_zz_when_BankedScratchMemory_l234_20 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_20 = (_zz_when_BankedScratchMemory_l234_20 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_43 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b010));
  assign when_BankedScratchMemory_l228_21 = (_zz_when_BankedScratchMemory_l228_43 && (! _zz_when_BankedScratchMemory_l228_42));
  assign _zz_when_BankedScratchMemory_l234_21 = ((_zz_when_BankedScratchMemory_l228_43 && _zz_when_BankedScratchMemory_l228_42) && (! _zz_when_BankedScratchMemory_l245_21));
  assign when_BankedScratchMemory_l245_21 = (_zz_when_BankedScratchMemory_l228_43 && _zz_when_BankedScratchMemory_l245_21);
  assign _zz_when_BankedScratchMemory_l245_22 = (_zz_when_BankedScratchMemory_l245_21 || (_zz_when_BankedScratchMemory_l228_42 && _zz_when_BankedScratchMemory_l228_43));
  assign _zz_when_BankedScratchMemory_l228_44 = (_zz_when_BankedScratchMemory_l228_42 || _zz_when_BankedScratchMemory_l228_43);
  assign when_BankedScratchMemory_l234_21 = (_zz_when_BankedScratchMemory_l234_21 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_21 = (_zz_when_BankedScratchMemory_l234_21 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_45 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b010));
  assign when_BankedScratchMemory_l228_22 = (_zz_when_BankedScratchMemory_l228_45 && (! _zz_when_BankedScratchMemory_l228_44));
  assign _zz_when_BankedScratchMemory_l234_22 = ((_zz_when_BankedScratchMemory_l228_45 && _zz_when_BankedScratchMemory_l228_44) && (! _zz_when_BankedScratchMemory_l245_22));
  assign when_BankedScratchMemory_l245_22 = (_zz_when_BankedScratchMemory_l228_45 && _zz_when_BankedScratchMemory_l245_22);
  assign _zz_when_BankedScratchMemory_l245_23 = (_zz_when_BankedScratchMemory_l245_22 || (_zz_when_BankedScratchMemory_l228_44 && _zz_when_BankedScratchMemory_l228_45));
  assign _zz_when_BankedScratchMemory_l228_46 = (_zz_when_BankedScratchMemory_l228_44 || _zz_when_BankedScratchMemory_l228_45);
  assign when_BankedScratchMemory_l234_22 = (_zz_when_BankedScratchMemory_l234_22 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_22 = (_zz_when_BankedScratchMemory_l234_22 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_47 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b010));
  assign when_BankedScratchMemory_l228_23 = (_zz_when_BankedScratchMemory_l228_47 && (! _zz_when_BankedScratchMemory_l228_46));
  assign _zz_when_BankedScratchMemory_l234_23 = ((_zz_when_BankedScratchMemory_l228_47 && _zz_when_BankedScratchMemory_l228_46) && (! _zz_when_BankedScratchMemory_l245_23));
  assign when_BankedScratchMemory_l245_23 = (_zz_when_BankedScratchMemory_l228_47 && _zz_when_BankedScratchMemory_l245_23);
  assign _zz_when_BankedScratchMemory_l245_24 = (_zz_when_BankedScratchMemory_l245_23 || (_zz_when_BankedScratchMemory_l228_46 && _zz_when_BankedScratchMemory_l228_47));
  assign _zz_when_BankedScratchMemory_l228_48 = (_zz_when_BankedScratchMemory_l228_46 || _zz_when_BankedScratchMemory_l228_47);
  assign when_BankedScratchMemory_l234_23 = (_zz_when_BankedScratchMemory_l234_23 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_23 = (_zz_when_BankedScratchMemory_l234_23 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_49 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b010));
  assign when_BankedScratchMemory_l228_24 = (_zz_when_BankedScratchMemory_l228_49 && (! _zz_when_BankedScratchMemory_l228_48));
  assign _zz_when_BankedScratchMemory_l234_24 = ((_zz_when_BankedScratchMemory_l228_49 && _zz_when_BankedScratchMemory_l228_48) && (! _zz_when_BankedScratchMemory_l245_24));
  assign when_BankedScratchMemory_l245_24 = (_zz_when_BankedScratchMemory_l228_49 && _zz_when_BankedScratchMemory_l245_24);
  assign _zz_when_BankedScratchMemory_l245_25 = (_zz_when_BankedScratchMemory_l245_24 || (_zz_when_BankedScratchMemory_l228_48 && _zz_when_BankedScratchMemory_l228_49));
  assign _zz_when_BankedScratchMemory_l228_50 = (_zz_when_BankedScratchMemory_l228_48 || _zz_when_BankedScratchMemory_l228_49);
  assign when_BankedScratchMemory_l234_24 = (_zz_when_BankedScratchMemory_l234_24 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_24 = (_zz_when_BankedScratchMemory_l234_24 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_51 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b010));
  assign when_BankedScratchMemory_l228_25 = (_zz_when_BankedScratchMemory_l228_51 && (! _zz_when_BankedScratchMemory_l228_50));
  assign _zz_when_BankedScratchMemory_l234_25 = ((_zz_when_BankedScratchMemory_l228_51 && _zz_when_BankedScratchMemory_l228_50) && (! _zz_when_BankedScratchMemory_l245_25));
  assign when_BankedScratchMemory_l245_25 = (_zz_when_BankedScratchMemory_l228_51 && _zz_when_BankedScratchMemory_l245_25);
  assign _zz_when_BankedScratchMemory_l245_26 = (_zz_when_BankedScratchMemory_l245_25 || (_zz_when_BankedScratchMemory_l228_50 && _zz_when_BankedScratchMemory_l228_51));
  assign _zz_when_BankedScratchMemory_l228_52 = (_zz_when_BankedScratchMemory_l228_50 || _zz_when_BankedScratchMemory_l228_51);
  assign when_BankedScratchMemory_l234_25 = (_zz_when_BankedScratchMemory_l234_25 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_25 = (_zz_when_BankedScratchMemory_l234_25 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_53 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b010));
  assign when_BankedScratchMemory_l228_26 = (_zz_when_BankedScratchMemory_l228_53 && (! _zz_when_BankedScratchMemory_l228_52));
  assign _zz_when_BankedScratchMemory_l234_26 = ((_zz_when_BankedScratchMemory_l228_53 && _zz_when_BankedScratchMemory_l228_52) && (! _zz_when_BankedScratchMemory_l245_26));
  assign when_BankedScratchMemory_l245_26 = (_zz_when_BankedScratchMemory_l228_53 && _zz_when_BankedScratchMemory_l245_26);
  assign when_BankedScratchMemory_l234_26 = (_zz_when_BankedScratchMemory_l234_26 && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l242_26 = (_zz_when_BankedScratchMemory_l234_26 && bankWriteActive_2);
  assign _zz_when_BankedScratchMemory_l228_54 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245_27 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_55 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b011));
  assign when_BankedScratchMemory_l228_27 = (_zz_when_BankedScratchMemory_l228_55 && (! _zz_when_BankedScratchMemory_l228_54));
  assign _zz_when_BankedScratchMemory_l234_27 = ((_zz_when_BankedScratchMemory_l228_55 && _zz_when_BankedScratchMemory_l228_54) && (! _zz_when_BankedScratchMemory_l245_27));
  assign when_BankedScratchMemory_l245_27 = (_zz_when_BankedScratchMemory_l228_55 && _zz_when_BankedScratchMemory_l245_27);
  assign _zz_when_BankedScratchMemory_l245_28 = (_zz_when_BankedScratchMemory_l245_27 || (_zz_when_BankedScratchMemory_l228_54 && _zz_when_BankedScratchMemory_l228_55));
  assign _zz_when_BankedScratchMemory_l228_56 = (_zz_when_BankedScratchMemory_l228_54 || _zz_when_BankedScratchMemory_l228_55);
  assign when_BankedScratchMemory_l234_27 = (_zz_when_BankedScratchMemory_l234_27 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_27 = (_zz_when_BankedScratchMemory_l234_27 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_57 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b011));
  assign when_BankedScratchMemory_l228_28 = (_zz_when_BankedScratchMemory_l228_57 && (! _zz_when_BankedScratchMemory_l228_56));
  assign _zz_when_BankedScratchMemory_l234_28 = ((_zz_when_BankedScratchMemory_l228_57 && _zz_when_BankedScratchMemory_l228_56) && (! _zz_when_BankedScratchMemory_l245_28));
  assign when_BankedScratchMemory_l245_28 = (_zz_when_BankedScratchMemory_l228_57 && _zz_when_BankedScratchMemory_l245_28);
  assign _zz_when_BankedScratchMemory_l245_29 = (_zz_when_BankedScratchMemory_l245_28 || (_zz_when_BankedScratchMemory_l228_56 && _zz_when_BankedScratchMemory_l228_57));
  assign _zz_when_BankedScratchMemory_l228_58 = (_zz_when_BankedScratchMemory_l228_56 || _zz_when_BankedScratchMemory_l228_57);
  assign when_BankedScratchMemory_l234_28 = (_zz_when_BankedScratchMemory_l234_28 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_28 = (_zz_when_BankedScratchMemory_l234_28 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_59 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b011));
  assign when_BankedScratchMemory_l228_29 = (_zz_when_BankedScratchMemory_l228_59 && (! _zz_when_BankedScratchMemory_l228_58));
  assign _zz_when_BankedScratchMemory_l234_29 = ((_zz_when_BankedScratchMemory_l228_59 && _zz_when_BankedScratchMemory_l228_58) && (! _zz_when_BankedScratchMemory_l245_29));
  assign when_BankedScratchMemory_l245_29 = (_zz_when_BankedScratchMemory_l228_59 && _zz_when_BankedScratchMemory_l245_29);
  assign _zz_when_BankedScratchMemory_l245_30 = (_zz_when_BankedScratchMemory_l245_29 || (_zz_when_BankedScratchMemory_l228_58 && _zz_when_BankedScratchMemory_l228_59));
  assign _zz_when_BankedScratchMemory_l228_60 = (_zz_when_BankedScratchMemory_l228_58 || _zz_when_BankedScratchMemory_l228_59);
  assign when_BankedScratchMemory_l234_29 = (_zz_when_BankedScratchMemory_l234_29 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_29 = (_zz_when_BankedScratchMemory_l234_29 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_61 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b011));
  assign when_BankedScratchMemory_l228_30 = (_zz_when_BankedScratchMemory_l228_61 && (! _zz_when_BankedScratchMemory_l228_60));
  assign _zz_when_BankedScratchMemory_l234_30 = ((_zz_when_BankedScratchMemory_l228_61 && _zz_when_BankedScratchMemory_l228_60) && (! _zz_when_BankedScratchMemory_l245_30));
  assign when_BankedScratchMemory_l245_30 = (_zz_when_BankedScratchMemory_l228_61 && _zz_when_BankedScratchMemory_l245_30);
  assign _zz_when_BankedScratchMemory_l245_31 = (_zz_when_BankedScratchMemory_l245_30 || (_zz_when_BankedScratchMemory_l228_60 && _zz_when_BankedScratchMemory_l228_61));
  assign _zz_when_BankedScratchMemory_l228_62 = (_zz_when_BankedScratchMemory_l228_60 || _zz_when_BankedScratchMemory_l228_61);
  assign when_BankedScratchMemory_l234_30 = (_zz_when_BankedScratchMemory_l234_30 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_30 = (_zz_when_BankedScratchMemory_l234_30 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_63 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b011));
  assign when_BankedScratchMemory_l228_31 = (_zz_when_BankedScratchMemory_l228_63 && (! _zz_when_BankedScratchMemory_l228_62));
  assign _zz_when_BankedScratchMemory_l234_31 = ((_zz_when_BankedScratchMemory_l228_63 && _zz_when_BankedScratchMemory_l228_62) && (! _zz_when_BankedScratchMemory_l245_31));
  assign when_BankedScratchMemory_l245_31 = (_zz_when_BankedScratchMemory_l228_63 && _zz_when_BankedScratchMemory_l245_31);
  assign _zz_when_BankedScratchMemory_l245_32 = (_zz_when_BankedScratchMemory_l245_31 || (_zz_when_BankedScratchMemory_l228_62 && _zz_when_BankedScratchMemory_l228_63));
  assign _zz_when_BankedScratchMemory_l228_64 = (_zz_when_BankedScratchMemory_l228_62 || _zz_when_BankedScratchMemory_l228_63);
  assign when_BankedScratchMemory_l234_31 = (_zz_when_BankedScratchMemory_l234_31 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_31 = (_zz_when_BankedScratchMemory_l234_31 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_65 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b011));
  assign when_BankedScratchMemory_l228_32 = (_zz_when_BankedScratchMemory_l228_65 && (! _zz_when_BankedScratchMemory_l228_64));
  assign _zz_when_BankedScratchMemory_l234_32 = ((_zz_when_BankedScratchMemory_l228_65 && _zz_when_BankedScratchMemory_l228_64) && (! _zz_when_BankedScratchMemory_l245_32));
  assign when_BankedScratchMemory_l245_32 = (_zz_when_BankedScratchMemory_l228_65 && _zz_when_BankedScratchMemory_l245_32);
  assign _zz_when_BankedScratchMemory_l245_33 = (_zz_when_BankedScratchMemory_l245_32 || (_zz_when_BankedScratchMemory_l228_64 && _zz_when_BankedScratchMemory_l228_65));
  assign _zz_when_BankedScratchMemory_l228_66 = (_zz_when_BankedScratchMemory_l228_64 || _zz_when_BankedScratchMemory_l228_65);
  assign when_BankedScratchMemory_l234_32 = (_zz_when_BankedScratchMemory_l234_32 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_32 = (_zz_when_BankedScratchMemory_l234_32 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_67 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b011));
  assign when_BankedScratchMemory_l228_33 = (_zz_when_BankedScratchMemory_l228_67 && (! _zz_when_BankedScratchMemory_l228_66));
  assign _zz_when_BankedScratchMemory_l234_33 = ((_zz_when_BankedScratchMemory_l228_67 && _zz_when_BankedScratchMemory_l228_66) && (! _zz_when_BankedScratchMemory_l245_33));
  assign when_BankedScratchMemory_l245_33 = (_zz_when_BankedScratchMemory_l228_67 && _zz_when_BankedScratchMemory_l245_33);
  assign _zz_when_BankedScratchMemory_l245_34 = (_zz_when_BankedScratchMemory_l245_33 || (_zz_when_BankedScratchMemory_l228_66 && _zz_when_BankedScratchMemory_l228_67));
  assign _zz_when_BankedScratchMemory_l228_68 = (_zz_when_BankedScratchMemory_l228_66 || _zz_when_BankedScratchMemory_l228_67);
  assign when_BankedScratchMemory_l234_33 = (_zz_when_BankedScratchMemory_l234_33 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_33 = (_zz_when_BankedScratchMemory_l234_33 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_69 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b011));
  assign when_BankedScratchMemory_l228_34 = (_zz_when_BankedScratchMemory_l228_69 && (! _zz_when_BankedScratchMemory_l228_68));
  assign _zz_when_BankedScratchMemory_l234_34 = ((_zz_when_BankedScratchMemory_l228_69 && _zz_when_BankedScratchMemory_l228_68) && (! _zz_when_BankedScratchMemory_l245_34));
  assign when_BankedScratchMemory_l245_34 = (_zz_when_BankedScratchMemory_l228_69 && _zz_when_BankedScratchMemory_l245_34);
  assign _zz_when_BankedScratchMemory_l245_35 = (_zz_when_BankedScratchMemory_l245_34 || (_zz_when_BankedScratchMemory_l228_68 && _zz_when_BankedScratchMemory_l228_69));
  assign _zz_when_BankedScratchMemory_l228_70 = (_zz_when_BankedScratchMemory_l228_68 || _zz_when_BankedScratchMemory_l228_69);
  assign when_BankedScratchMemory_l234_34 = (_zz_when_BankedScratchMemory_l234_34 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_34 = (_zz_when_BankedScratchMemory_l234_34 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_71 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b011));
  assign when_BankedScratchMemory_l228_35 = (_zz_when_BankedScratchMemory_l228_71 && (! _zz_when_BankedScratchMemory_l228_70));
  assign _zz_when_BankedScratchMemory_l234_35 = ((_zz_when_BankedScratchMemory_l228_71 && _zz_when_BankedScratchMemory_l228_70) && (! _zz_when_BankedScratchMemory_l245_35));
  assign when_BankedScratchMemory_l245_35 = (_zz_when_BankedScratchMemory_l228_71 && _zz_when_BankedScratchMemory_l245_35);
  assign when_BankedScratchMemory_l234_35 = (_zz_when_BankedScratchMemory_l234_35 && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l242_35 = (_zz_when_BankedScratchMemory_l234_35 && bankWriteActive_3);
  assign _zz_when_BankedScratchMemory_l228_72 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245_36 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_73 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b100));
  assign when_BankedScratchMemory_l228_36 = (_zz_when_BankedScratchMemory_l228_73 && (! _zz_when_BankedScratchMemory_l228_72));
  assign _zz_when_BankedScratchMemory_l234_36 = ((_zz_when_BankedScratchMemory_l228_73 && _zz_when_BankedScratchMemory_l228_72) && (! _zz_when_BankedScratchMemory_l245_36));
  assign when_BankedScratchMemory_l245_36 = (_zz_when_BankedScratchMemory_l228_73 && _zz_when_BankedScratchMemory_l245_36);
  assign _zz_when_BankedScratchMemory_l245_37 = (_zz_when_BankedScratchMemory_l245_36 || (_zz_when_BankedScratchMemory_l228_72 && _zz_when_BankedScratchMemory_l228_73));
  assign _zz_when_BankedScratchMemory_l228_74 = (_zz_when_BankedScratchMemory_l228_72 || _zz_when_BankedScratchMemory_l228_73);
  assign when_BankedScratchMemory_l234_36 = (_zz_when_BankedScratchMemory_l234_36 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_36 = (_zz_when_BankedScratchMemory_l234_36 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_75 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b100));
  assign when_BankedScratchMemory_l228_37 = (_zz_when_BankedScratchMemory_l228_75 && (! _zz_when_BankedScratchMemory_l228_74));
  assign _zz_when_BankedScratchMemory_l234_37 = ((_zz_when_BankedScratchMemory_l228_75 && _zz_when_BankedScratchMemory_l228_74) && (! _zz_when_BankedScratchMemory_l245_37));
  assign when_BankedScratchMemory_l245_37 = (_zz_when_BankedScratchMemory_l228_75 && _zz_when_BankedScratchMemory_l245_37);
  assign _zz_when_BankedScratchMemory_l245_38 = (_zz_when_BankedScratchMemory_l245_37 || (_zz_when_BankedScratchMemory_l228_74 && _zz_when_BankedScratchMemory_l228_75));
  assign _zz_when_BankedScratchMemory_l228_76 = (_zz_when_BankedScratchMemory_l228_74 || _zz_when_BankedScratchMemory_l228_75);
  assign when_BankedScratchMemory_l234_37 = (_zz_when_BankedScratchMemory_l234_37 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_37 = (_zz_when_BankedScratchMemory_l234_37 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_77 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b100));
  assign when_BankedScratchMemory_l228_38 = (_zz_when_BankedScratchMemory_l228_77 && (! _zz_when_BankedScratchMemory_l228_76));
  assign _zz_when_BankedScratchMemory_l234_38 = ((_zz_when_BankedScratchMemory_l228_77 && _zz_when_BankedScratchMemory_l228_76) && (! _zz_when_BankedScratchMemory_l245_38));
  assign when_BankedScratchMemory_l245_38 = (_zz_when_BankedScratchMemory_l228_77 && _zz_when_BankedScratchMemory_l245_38);
  assign _zz_when_BankedScratchMemory_l245_39 = (_zz_when_BankedScratchMemory_l245_38 || (_zz_when_BankedScratchMemory_l228_76 && _zz_when_BankedScratchMemory_l228_77));
  assign _zz_when_BankedScratchMemory_l228_78 = (_zz_when_BankedScratchMemory_l228_76 || _zz_when_BankedScratchMemory_l228_77);
  assign when_BankedScratchMemory_l234_38 = (_zz_when_BankedScratchMemory_l234_38 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_38 = (_zz_when_BankedScratchMemory_l234_38 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_79 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b100));
  assign when_BankedScratchMemory_l228_39 = (_zz_when_BankedScratchMemory_l228_79 && (! _zz_when_BankedScratchMemory_l228_78));
  assign _zz_when_BankedScratchMemory_l234_39 = ((_zz_when_BankedScratchMemory_l228_79 && _zz_when_BankedScratchMemory_l228_78) && (! _zz_when_BankedScratchMemory_l245_39));
  assign when_BankedScratchMemory_l245_39 = (_zz_when_BankedScratchMemory_l228_79 && _zz_when_BankedScratchMemory_l245_39);
  assign _zz_when_BankedScratchMemory_l245_40 = (_zz_when_BankedScratchMemory_l245_39 || (_zz_when_BankedScratchMemory_l228_78 && _zz_when_BankedScratchMemory_l228_79));
  assign _zz_when_BankedScratchMemory_l228_80 = (_zz_when_BankedScratchMemory_l228_78 || _zz_when_BankedScratchMemory_l228_79);
  assign when_BankedScratchMemory_l234_39 = (_zz_when_BankedScratchMemory_l234_39 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_39 = (_zz_when_BankedScratchMemory_l234_39 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_81 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b100));
  assign when_BankedScratchMemory_l228_40 = (_zz_when_BankedScratchMemory_l228_81 && (! _zz_when_BankedScratchMemory_l228_80));
  assign _zz_when_BankedScratchMemory_l234_40 = ((_zz_when_BankedScratchMemory_l228_81 && _zz_when_BankedScratchMemory_l228_80) && (! _zz_when_BankedScratchMemory_l245_40));
  assign when_BankedScratchMemory_l245_40 = (_zz_when_BankedScratchMemory_l228_81 && _zz_when_BankedScratchMemory_l245_40);
  assign _zz_when_BankedScratchMemory_l245_41 = (_zz_when_BankedScratchMemory_l245_40 || (_zz_when_BankedScratchMemory_l228_80 && _zz_when_BankedScratchMemory_l228_81));
  assign _zz_when_BankedScratchMemory_l228_82 = (_zz_when_BankedScratchMemory_l228_80 || _zz_when_BankedScratchMemory_l228_81);
  assign when_BankedScratchMemory_l234_40 = (_zz_when_BankedScratchMemory_l234_40 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_40 = (_zz_when_BankedScratchMemory_l234_40 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_83 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b100));
  assign when_BankedScratchMemory_l228_41 = (_zz_when_BankedScratchMemory_l228_83 && (! _zz_when_BankedScratchMemory_l228_82));
  assign _zz_when_BankedScratchMemory_l234_41 = ((_zz_when_BankedScratchMemory_l228_83 && _zz_when_BankedScratchMemory_l228_82) && (! _zz_when_BankedScratchMemory_l245_41));
  assign when_BankedScratchMemory_l245_41 = (_zz_when_BankedScratchMemory_l228_83 && _zz_when_BankedScratchMemory_l245_41);
  assign _zz_when_BankedScratchMemory_l245_42 = (_zz_when_BankedScratchMemory_l245_41 || (_zz_when_BankedScratchMemory_l228_82 && _zz_when_BankedScratchMemory_l228_83));
  assign _zz_when_BankedScratchMemory_l228_84 = (_zz_when_BankedScratchMemory_l228_82 || _zz_when_BankedScratchMemory_l228_83);
  assign when_BankedScratchMemory_l234_41 = (_zz_when_BankedScratchMemory_l234_41 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_41 = (_zz_when_BankedScratchMemory_l234_41 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_85 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b100));
  assign when_BankedScratchMemory_l228_42 = (_zz_when_BankedScratchMemory_l228_85 && (! _zz_when_BankedScratchMemory_l228_84));
  assign _zz_when_BankedScratchMemory_l234_42 = ((_zz_when_BankedScratchMemory_l228_85 && _zz_when_BankedScratchMemory_l228_84) && (! _zz_when_BankedScratchMemory_l245_42));
  assign when_BankedScratchMemory_l245_42 = (_zz_when_BankedScratchMemory_l228_85 && _zz_when_BankedScratchMemory_l245_42);
  assign _zz_when_BankedScratchMemory_l245_43 = (_zz_when_BankedScratchMemory_l245_42 || (_zz_when_BankedScratchMemory_l228_84 && _zz_when_BankedScratchMemory_l228_85));
  assign _zz_when_BankedScratchMemory_l228_86 = (_zz_when_BankedScratchMemory_l228_84 || _zz_when_BankedScratchMemory_l228_85);
  assign when_BankedScratchMemory_l234_42 = (_zz_when_BankedScratchMemory_l234_42 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_42 = (_zz_when_BankedScratchMemory_l234_42 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_87 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b100));
  assign when_BankedScratchMemory_l228_43 = (_zz_when_BankedScratchMemory_l228_87 && (! _zz_when_BankedScratchMemory_l228_86));
  assign _zz_when_BankedScratchMemory_l234_43 = ((_zz_when_BankedScratchMemory_l228_87 && _zz_when_BankedScratchMemory_l228_86) && (! _zz_when_BankedScratchMemory_l245_43));
  assign when_BankedScratchMemory_l245_43 = (_zz_when_BankedScratchMemory_l228_87 && _zz_when_BankedScratchMemory_l245_43);
  assign _zz_when_BankedScratchMemory_l245_44 = (_zz_when_BankedScratchMemory_l245_43 || (_zz_when_BankedScratchMemory_l228_86 && _zz_when_BankedScratchMemory_l228_87));
  assign _zz_when_BankedScratchMemory_l228_88 = (_zz_when_BankedScratchMemory_l228_86 || _zz_when_BankedScratchMemory_l228_87);
  assign when_BankedScratchMemory_l234_43 = (_zz_when_BankedScratchMemory_l234_43 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_43 = (_zz_when_BankedScratchMemory_l234_43 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_89 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b100));
  assign when_BankedScratchMemory_l228_44 = (_zz_when_BankedScratchMemory_l228_89 && (! _zz_when_BankedScratchMemory_l228_88));
  assign _zz_when_BankedScratchMemory_l234_44 = ((_zz_when_BankedScratchMemory_l228_89 && _zz_when_BankedScratchMemory_l228_88) && (! _zz_when_BankedScratchMemory_l245_44));
  assign when_BankedScratchMemory_l245_44 = (_zz_when_BankedScratchMemory_l228_89 && _zz_when_BankedScratchMemory_l245_44);
  assign when_BankedScratchMemory_l234_44 = (_zz_when_BankedScratchMemory_l234_44 && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l242_44 = (_zz_when_BankedScratchMemory_l234_44 && bankWriteActive_4);
  assign _zz_when_BankedScratchMemory_l228_90 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245_45 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_91 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b101));
  assign when_BankedScratchMemory_l228_45 = (_zz_when_BankedScratchMemory_l228_91 && (! _zz_when_BankedScratchMemory_l228_90));
  assign _zz_when_BankedScratchMemory_l234_45 = ((_zz_when_BankedScratchMemory_l228_91 && _zz_when_BankedScratchMemory_l228_90) && (! _zz_when_BankedScratchMemory_l245_45));
  assign when_BankedScratchMemory_l245_45 = (_zz_when_BankedScratchMemory_l228_91 && _zz_when_BankedScratchMemory_l245_45);
  assign _zz_when_BankedScratchMemory_l245_46 = (_zz_when_BankedScratchMemory_l245_45 || (_zz_when_BankedScratchMemory_l228_90 && _zz_when_BankedScratchMemory_l228_91));
  assign _zz_when_BankedScratchMemory_l228_92 = (_zz_when_BankedScratchMemory_l228_90 || _zz_when_BankedScratchMemory_l228_91);
  assign when_BankedScratchMemory_l234_45 = (_zz_when_BankedScratchMemory_l234_45 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_45 = (_zz_when_BankedScratchMemory_l234_45 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_93 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b101));
  assign when_BankedScratchMemory_l228_46 = (_zz_when_BankedScratchMemory_l228_93 && (! _zz_when_BankedScratchMemory_l228_92));
  assign _zz_when_BankedScratchMemory_l234_46 = ((_zz_when_BankedScratchMemory_l228_93 && _zz_when_BankedScratchMemory_l228_92) && (! _zz_when_BankedScratchMemory_l245_46));
  assign when_BankedScratchMemory_l245_46 = (_zz_when_BankedScratchMemory_l228_93 && _zz_when_BankedScratchMemory_l245_46);
  assign _zz_when_BankedScratchMemory_l245_47 = (_zz_when_BankedScratchMemory_l245_46 || (_zz_when_BankedScratchMemory_l228_92 && _zz_when_BankedScratchMemory_l228_93));
  assign _zz_when_BankedScratchMemory_l228_94 = (_zz_when_BankedScratchMemory_l228_92 || _zz_when_BankedScratchMemory_l228_93);
  assign when_BankedScratchMemory_l234_46 = (_zz_when_BankedScratchMemory_l234_46 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_46 = (_zz_when_BankedScratchMemory_l234_46 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_95 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b101));
  assign when_BankedScratchMemory_l228_47 = (_zz_when_BankedScratchMemory_l228_95 && (! _zz_when_BankedScratchMemory_l228_94));
  assign _zz_when_BankedScratchMemory_l234_47 = ((_zz_when_BankedScratchMemory_l228_95 && _zz_when_BankedScratchMemory_l228_94) && (! _zz_when_BankedScratchMemory_l245_47));
  assign when_BankedScratchMemory_l245_47 = (_zz_when_BankedScratchMemory_l228_95 && _zz_when_BankedScratchMemory_l245_47);
  assign _zz_when_BankedScratchMemory_l245_48 = (_zz_when_BankedScratchMemory_l245_47 || (_zz_when_BankedScratchMemory_l228_94 && _zz_when_BankedScratchMemory_l228_95));
  assign _zz_when_BankedScratchMemory_l228_96 = (_zz_when_BankedScratchMemory_l228_94 || _zz_when_BankedScratchMemory_l228_95);
  assign when_BankedScratchMemory_l234_47 = (_zz_when_BankedScratchMemory_l234_47 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_47 = (_zz_when_BankedScratchMemory_l234_47 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_97 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b101));
  assign when_BankedScratchMemory_l228_48 = (_zz_when_BankedScratchMemory_l228_97 && (! _zz_when_BankedScratchMemory_l228_96));
  assign _zz_when_BankedScratchMemory_l234_48 = ((_zz_when_BankedScratchMemory_l228_97 && _zz_when_BankedScratchMemory_l228_96) && (! _zz_when_BankedScratchMemory_l245_48));
  assign when_BankedScratchMemory_l245_48 = (_zz_when_BankedScratchMemory_l228_97 && _zz_when_BankedScratchMemory_l245_48);
  assign _zz_when_BankedScratchMemory_l245_49 = (_zz_when_BankedScratchMemory_l245_48 || (_zz_when_BankedScratchMemory_l228_96 && _zz_when_BankedScratchMemory_l228_97));
  assign _zz_when_BankedScratchMemory_l228_98 = (_zz_when_BankedScratchMemory_l228_96 || _zz_when_BankedScratchMemory_l228_97);
  assign when_BankedScratchMemory_l234_48 = (_zz_when_BankedScratchMemory_l234_48 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_48 = (_zz_when_BankedScratchMemory_l234_48 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_99 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b101));
  assign when_BankedScratchMemory_l228_49 = (_zz_when_BankedScratchMemory_l228_99 && (! _zz_when_BankedScratchMemory_l228_98));
  assign _zz_when_BankedScratchMemory_l234_49 = ((_zz_when_BankedScratchMemory_l228_99 && _zz_when_BankedScratchMemory_l228_98) && (! _zz_when_BankedScratchMemory_l245_49));
  assign when_BankedScratchMemory_l245_49 = (_zz_when_BankedScratchMemory_l228_99 && _zz_when_BankedScratchMemory_l245_49);
  assign _zz_when_BankedScratchMemory_l245_50 = (_zz_when_BankedScratchMemory_l245_49 || (_zz_when_BankedScratchMemory_l228_98 && _zz_when_BankedScratchMemory_l228_99));
  assign _zz_when_BankedScratchMemory_l228_100 = (_zz_when_BankedScratchMemory_l228_98 || _zz_when_BankedScratchMemory_l228_99);
  assign when_BankedScratchMemory_l234_49 = (_zz_when_BankedScratchMemory_l234_49 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_49 = (_zz_when_BankedScratchMemory_l234_49 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_101 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b101));
  assign when_BankedScratchMemory_l228_50 = (_zz_when_BankedScratchMemory_l228_101 && (! _zz_when_BankedScratchMemory_l228_100));
  assign _zz_when_BankedScratchMemory_l234_50 = ((_zz_when_BankedScratchMemory_l228_101 && _zz_when_BankedScratchMemory_l228_100) && (! _zz_when_BankedScratchMemory_l245_50));
  assign when_BankedScratchMemory_l245_50 = (_zz_when_BankedScratchMemory_l228_101 && _zz_when_BankedScratchMemory_l245_50);
  assign _zz_when_BankedScratchMemory_l245_51 = (_zz_when_BankedScratchMemory_l245_50 || (_zz_when_BankedScratchMemory_l228_100 && _zz_when_BankedScratchMemory_l228_101));
  assign _zz_when_BankedScratchMemory_l228_102 = (_zz_when_BankedScratchMemory_l228_100 || _zz_when_BankedScratchMemory_l228_101);
  assign when_BankedScratchMemory_l234_50 = (_zz_when_BankedScratchMemory_l234_50 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_50 = (_zz_when_BankedScratchMemory_l234_50 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_103 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b101));
  assign when_BankedScratchMemory_l228_51 = (_zz_when_BankedScratchMemory_l228_103 && (! _zz_when_BankedScratchMemory_l228_102));
  assign _zz_when_BankedScratchMemory_l234_51 = ((_zz_when_BankedScratchMemory_l228_103 && _zz_when_BankedScratchMemory_l228_102) && (! _zz_when_BankedScratchMemory_l245_51));
  assign when_BankedScratchMemory_l245_51 = (_zz_when_BankedScratchMemory_l228_103 && _zz_when_BankedScratchMemory_l245_51);
  assign _zz_when_BankedScratchMemory_l245_52 = (_zz_when_BankedScratchMemory_l245_51 || (_zz_when_BankedScratchMemory_l228_102 && _zz_when_BankedScratchMemory_l228_103));
  assign _zz_when_BankedScratchMemory_l228_104 = (_zz_when_BankedScratchMemory_l228_102 || _zz_when_BankedScratchMemory_l228_103);
  assign when_BankedScratchMemory_l234_51 = (_zz_when_BankedScratchMemory_l234_51 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_51 = (_zz_when_BankedScratchMemory_l234_51 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_105 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b101));
  assign when_BankedScratchMemory_l228_52 = (_zz_when_BankedScratchMemory_l228_105 && (! _zz_when_BankedScratchMemory_l228_104));
  assign _zz_when_BankedScratchMemory_l234_52 = ((_zz_when_BankedScratchMemory_l228_105 && _zz_when_BankedScratchMemory_l228_104) && (! _zz_when_BankedScratchMemory_l245_52));
  assign when_BankedScratchMemory_l245_52 = (_zz_when_BankedScratchMemory_l228_105 && _zz_when_BankedScratchMemory_l245_52);
  assign _zz_when_BankedScratchMemory_l245_53 = (_zz_when_BankedScratchMemory_l245_52 || (_zz_when_BankedScratchMemory_l228_104 && _zz_when_BankedScratchMemory_l228_105));
  assign _zz_when_BankedScratchMemory_l228_106 = (_zz_when_BankedScratchMemory_l228_104 || _zz_when_BankedScratchMemory_l228_105);
  assign when_BankedScratchMemory_l234_52 = (_zz_when_BankedScratchMemory_l234_52 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_52 = (_zz_when_BankedScratchMemory_l234_52 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_107 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b101));
  assign when_BankedScratchMemory_l228_53 = (_zz_when_BankedScratchMemory_l228_107 && (! _zz_when_BankedScratchMemory_l228_106));
  assign _zz_when_BankedScratchMemory_l234_53 = ((_zz_when_BankedScratchMemory_l228_107 && _zz_when_BankedScratchMemory_l228_106) && (! _zz_when_BankedScratchMemory_l245_53));
  assign when_BankedScratchMemory_l245_53 = (_zz_when_BankedScratchMemory_l228_107 && _zz_when_BankedScratchMemory_l245_53);
  assign when_BankedScratchMemory_l234_53 = (_zz_when_BankedScratchMemory_l234_53 && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l242_53 = (_zz_when_BankedScratchMemory_l234_53 && bankWriteActive_5);
  assign _zz_when_BankedScratchMemory_l228_108 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245_54 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_109 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b110));
  assign when_BankedScratchMemory_l228_54 = (_zz_when_BankedScratchMemory_l228_109 && (! _zz_when_BankedScratchMemory_l228_108));
  assign _zz_when_BankedScratchMemory_l234_54 = ((_zz_when_BankedScratchMemory_l228_109 && _zz_when_BankedScratchMemory_l228_108) && (! _zz_when_BankedScratchMemory_l245_54));
  assign when_BankedScratchMemory_l245_54 = (_zz_when_BankedScratchMemory_l228_109 && _zz_when_BankedScratchMemory_l245_54);
  assign _zz_when_BankedScratchMemory_l245_55 = (_zz_when_BankedScratchMemory_l245_54 || (_zz_when_BankedScratchMemory_l228_108 && _zz_when_BankedScratchMemory_l228_109));
  assign _zz_when_BankedScratchMemory_l228_110 = (_zz_when_BankedScratchMemory_l228_108 || _zz_when_BankedScratchMemory_l228_109);
  assign when_BankedScratchMemory_l234_54 = (_zz_when_BankedScratchMemory_l234_54 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_54 = (_zz_when_BankedScratchMemory_l234_54 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_111 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b110));
  assign when_BankedScratchMemory_l228_55 = (_zz_when_BankedScratchMemory_l228_111 && (! _zz_when_BankedScratchMemory_l228_110));
  assign _zz_when_BankedScratchMemory_l234_55 = ((_zz_when_BankedScratchMemory_l228_111 && _zz_when_BankedScratchMemory_l228_110) && (! _zz_when_BankedScratchMemory_l245_55));
  assign when_BankedScratchMemory_l245_55 = (_zz_when_BankedScratchMemory_l228_111 && _zz_when_BankedScratchMemory_l245_55);
  assign _zz_when_BankedScratchMemory_l245_56 = (_zz_when_BankedScratchMemory_l245_55 || (_zz_when_BankedScratchMemory_l228_110 && _zz_when_BankedScratchMemory_l228_111));
  assign _zz_when_BankedScratchMemory_l228_112 = (_zz_when_BankedScratchMemory_l228_110 || _zz_when_BankedScratchMemory_l228_111);
  assign when_BankedScratchMemory_l234_55 = (_zz_when_BankedScratchMemory_l234_55 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_55 = (_zz_when_BankedScratchMemory_l234_55 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_113 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b110));
  assign when_BankedScratchMemory_l228_56 = (_zz_when_BankedScratchMemory_l228_113 && (! _zz_when_BankedScratchMemory_l228_112));
  assign _zz_when_BankedScratchMemory_l234_56 = ((_zz_when_BankedScratchMemory_l228_113 && _zz_when_BankedScratchMemory_l228_112) && (! _zz_when_BankedScratchMemory_l245_56));
  assign when_BankedScratchMemory_l245_56 = (_zz_when_BankedScratchMemory_l228_113 && _zz_when_BankedScratchMemory_l245_56);
  assign _zz_when_BankedScratchMemory_l245_57 = (_zz_when_BankedScratchMemory_l245_56 || (_zz_when_BankedScratchMemory_l228_112 && _zz_when_BankedScratchMemory_l228_113));
  assign _zz_when_BankedScratchMemory_l228_114 = (_zz_when_BankedScratchMemory_l228_112 || _zz_when_BankedScratchMemory_l228_113);
  assign when_BankedScratchMemory_l234_56 = (_zz_when_BankedScratchMemory_l234_56 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_56 = (_zz_when_BankedScratchMemory_l234_56 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_115 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b110));
  assign when_BankedScratchMemory_l228_57 = (_zz_when_BankedScratchMemory_l228_115 && (! _zz_when_BankedScratchMemory_l228_114));
  assign _zz_when_BankedScratchMemory_l234_57 = ((_zz_when_BankedScratchMemory_l228_115 && _zz_when_BankedScratchMemory_l228_114) && (! _zz_when_BankedScratchMemory_l245_57));
  assign when_BankedScratchMemory_l245_57 = (_zz_when_BankedScratchMemory_l228_115 && _zz_when_BankedScratchMemory_l245_57);
  assign _zz_when_BankedScratchMemory_l245_58 = (_zz_when_BankedScratchMemory_l245_57 || (_zz_when_BankedScratchMemory_l228_114 && _zz_when_BankedScratchMemory_l228_115));
  assign _zz_when_BankedScratchMemory_l228_116 = (_zz_when_BankedScratchMemory_l228_114 || _zz_when_BankedScratchMemory_l228_115);
  assign when_BankedScratchMemory_l234_57 = (_zz_when_BankedScratchMemory_l234_57 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_57 = (_zz_when_BankedScratchMemory_l234_57 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_117 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b110));
  assign when_BankedScratchMemory_l228_58 = (_zz_when_BankedScratchMemory_l228_117 && (! _zz_when_BankedScratchMemory_l228_116));
  assign _zz_when_BankedScratchMemory_l234_58 = ((_zz_when_BankedScratchMemory_l228_117 && _zz_when_BankedScratchMemory_l228_116) && (! _zz_when_BankedScratchMemory_l245_58));
  assign when_BankedScratchMemory_l245_58 = (_zz_when_BankedScratchMemory_l228_117 && _zz_when_BankedScratchMemory_l245_58);
  assign _zz_when_BankedScratchMemory_l245_59 = (_zz_when_BankedScratchMemory_l245_58 || (_zz_when_BankedScratchMemory_l228_116 && _zz_when_BankedScratchMemory_l228_117));
  assign _zz_when_BankedScratchMemory_l228_118 = (_zz_when_BankedScratchMemory_l228_116 || _zz_when_BankedScratchMemory_l228_117);
  assign when_BankedScratchMemory_l234_58 = (_zz_when_BankedScratchMemory_l234_58 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_58 = (_zz_when_BankedScratchMemory_l234_58 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_119 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b110));
  assign when_BankedScratchMemory_l228_59 = (_zz_when_BankedScratchMemory_l228_119 && (! _zz_when_BankedScratchMemory_l228_118));
  assign _zz_when_BankedScratchMemory_l234_59 = ((_zz_when_BankedScratchMemory_l228_119 && _zz_when_BankedScratchMemory_l228_118) && (! _zz_when_BankedScratchMemory_l245_59));
  assign when_BankedScratchMemory_l245_59 = (_zz_when_BankedScratchMemory_l228_119 && _zz_when_BankedScratchMemory_l245_59);
  assign _zz_when_BankedScratchMemory_l245_60 = (_zz_when_BankedScratchMemory_l245_59 || (_zz_when_BankedScratchMemory_l228_118 && _zz_when_BankedScratchMemory_l228_119));
  assign _zz_when_BankedScratchMemory_l228_120 = (_zz_when_BankedScratchMemory_l228_118 || _zz_when_BankedScratchMemory_l228_119);
  assign when_BankedScratchMemory_l234_59 = (_zz_when_BankedScratchMemory_l234_59 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_59 = (_zz_when_BankedScratchMemory_l234_59 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_121 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b110));
  assign when_BankedScratchMemory_l228_60 = (_zz_when_BankedScratchMemory_l228_121 && (! _zz_when_BankedScratchMemory_l228_120));
  assign _zz_when_BankedScratchMemory_l234_60 = ((_zz_when_BankedScratchMemory_l228_121 && _zz_when_BankedScratchMemory_l228_120) && (! _zz_when_BankedScratchMemory_l245_60));
  assign when_BankedScratchMemory_l245_60 = (_zz_when_BankedScratchMemory_l228_121 && _zz_when_BankedScratchMemory_l245_60);
  assign _zz_when_BankedScratchMemory_l245_61 = (_zz_when_BankedScratchMemory_l245_60 || (_zz_when_BankedScratchMemory_l228_120 && _zz_when_BankedScratchMemory_l228_121));
  assign _zz_when_BankedScratchMemory_l228_122 = (_zz_when_BankedScratchMemory_l228_120 || _zz_when_BankedScratchMemory_l228_121);
  assign when_BankedScratchMemory_l234_60 = (_zz_when_BankedScratchMemory_l234_60 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_60 = (_zz_when_BankedScratchMemory_l234_60 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_123 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b110));
  assign when_BankedScratchMemory_l228_61 = (_zz_when_BankedScratchMemory_l228_123 && (! _zz_when_BankedScratchMemory_l228_122));
  assign _zz_when_BankedScratchMemory_l234_61 = ((_zz_when_BankedScratchMemory_l228_123 && _zz_when_BankedScratchMemory_l228_122) && (! _zz_when_BankedScratchMemory_l245_61));
  assign when_BankedScratchMemory_l245_61 = (_zz_when_BankedScratchMemory_l228_123 && _zz_when_BankedScratchMemory_l245_61);
  assign _zz_when_BankedScratchMemory_l245_62 = (_zz_when_BankedScratchMemory_l245_61 || (_zz_when_BankedScratchMemory_l228_122 && _zz_when_BankedScratchMemory_l228_123));
  assign _zz_when_BankedScratchMemory_l228_124 = (_zz_when_BankedScratchMemory_l228_122 || _zz_when_BankedScratchMemory_l228_123);
  assign when_BankedScratchMemory_l234_61 = (_zz_when_BankedScratchMemory_l234_61 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_61 = (_zz_when_BankedScratchMemory_l234_61 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_125 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b110));
  assign when_BankedScratchMemory_l228_62 = (_zz_when_BankedScratchMemory_l228_125 && (! _zz_when_BankedScratchMemory_l228_124));
  assign _zz_when_BankedScratchMemory_l234_62 = ((_zz_when_BankedScratchMemory_l228_125 && _zz_when_BankedScratchMemory_l228_124) && (! _zz_when_BankedScratchMemory_l245_62));
  assign when_BankedScratchMemory_l245_62 = (_zz_when_BankedScratchMemory_l228_125 && _zz_when_BankedScratchMemory_l245_62);
  assign when_BankedScratchMemory_l234_62 = (_zz_when_BankedScratchMemory_l234_62 && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l242_62 = (_zz_when_BankedScratchMemory_l234_62 && bankWriteActive_6);
  assign _zz_when_BankedScratchMemory_l228_126 = 1'b0;
  assign _zz_when_BankedScratchMemory_l245_63 = 1'b0;
  assign _zz_when_BankedScratchMemory_l228_127 = ((io_scalarReadEn_0 && (! io_blockScalarReads)) && (scalarBankReq_0 == 3'b111));
  assign when_BankedScratchMemory_l228_63 = (_zz_when_BankedScratchMemory_l228_127 && (! _zz_when_BankedScratchMemory_l228_126));
  assign _zz_when_BankedScratchMemory_l234_63 = ((_zz_when_BankedScratchMemory_l228_127 && _zz_when_BankedScratchMemory_l228_126) && (! _zz_when_BankedScratchMemory_l245_63));
  assign when_BankedScratchMemory_l245_63 = (_zz_when_BankedScratchMemory_l228_127 && _zz_when_BankedScratchMemory_l245_63);
  assign _zz_when_BankedScratchMemory_l245_64 = (_zz_when_BankedScratchMemory_l245_63 || (_zz_when_BankedScratchMemory_l228_126 && _zz_when_BankedScratchMemory_l228_127));
  assign _zz_when_BankedScratchMemory_l228_128 = (_zz_when_BankedScratchMemory_l228_126 || _zz_when_BankedScratchMemory_l228_127);
  assign when_BankedScratchMemory_l234_63 = (_zz_when_BankedScratchMemory_l234_63 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_63 = (_zz_when_BankedScratchMemory_l234_63 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_129 = ((io_scalarReadEn_1 && (! io_blockScalarReads)) && (scalarBankReq_1 == 3'b111));
  assign when_BankedScratchMemory_l228_64 = (_zz_when_BankedScratchMemory_l228_129 && (! _zz_when_BankedScratchMemory_l228_128));
  assign _zz_when_BankedScratchMemory_l234_64 = ((_zz_when_BankedScratchMemory_l228_129 && _zz_when_BankedScratchMemory_l228_128) && (! _zz_when_BankedScratchMemory_l245_64));
  assign when_BankedScratchMemory_l245_64 = (_zz_when_BankedScratchMemory_l228_129 && _zz_when_BankedScratchMemory_l245_64);
  assign _zz_when_BankedScratchMemory_l245_65 = (_zz_when_BankedScratchMemory_l245_64 || (_zz_when_BankedScratchMemory_l228_128 && _zz_when_BankedScratchMemory_l228_129));
  assign _zz_when_BankedScratchMemory_l228_130 = (_zz_when_BankedScratchMemory_l228_128 || _zz_when_BankedScratchMemory_l228_129);
  assign when_BankedScratchMemory_l234_64 = (_zz_when_BankedScratchMemory_l234_64 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_64 = (_zz_when_BankedScratchMemory_l234_64 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_131 = ((io_scalarReadEn_2 && (! io_blockScalarReads)) && (scalarBankReq_2 == 3'b111));
  assign when_BankedScratchMemory_l228_65 = (_zz_when_BankedScratchMemory_l228_131 && (! _zz_when_BankedScratchMemory_l228_130));
  assign _zz_when_BankedScratchMemory_l234_65 = ((_zz_when_BankedScratchMemory_l228_131 && _zz_when_BankedScratchMemory_l228_130) && (! _zz_when_BankedScratchMemory_l245_65));
  assign when_BankedScratchMemory_l245_65 = (_zz_when_BankedScratchMemory_l228_131 && _zz_when_BankedScratchMemory_l245_65);
  assign _zz_when_BankedScratchMemory_l245_66 = (_zz_when_BankedScratchMemory_l245_65 || (_zz_when_BankedScratchMemory_l228_130 && _zz_when_BankedScratchMemory_l228_131));
  assign _zz_when_BankedScratchMemory_l228_132 = (_zz_when_BankedScratchMemory_l228_130 || _zz_when_BankedScratchMemory_l228_131);
  assign when_BankedScratchMemory_l234_65 = (_zz_when_BankedScratchMemory_l234_65 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_65 = (_zz_when_BankedScratchMemory_l234_65 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_133 = ((io_scalarReadEn_3 && (! io_blockScalarReads)) && (scalarBankReq_3 == 3'b111));
  assign when_BankedScratchMemory_l228_66 = (_zz_when_BankedScratchMemory_l228_133 && (! _zz_when_BankedScratchMemory_l228_132));
  assign _zz_when_BankedScratchMemory_l234_66 = ((_zz_when_BankedScratchMemory_l228_133 && _zz_when_BankedScratchMemory_l228_132) && (! _zz_when_BankedScratchMemory_l245_66));
  assign when_BankedScratchMemory_l245_66 = (_zz_when_BankedScratchMemory_l228_133 && _zz_when_BankedScratchMemory_l245_66);
  assign _zz_when_BankedScratchMemory_l245_67 = (_zz_when_BankedScratchMemory_l245_66 || (_zz_when_BankedScratchMemory_l228_132 && _zz_when_BankedScratchMemory_l228_133));
  assign _zz_when_BankedScratchMemory_l228_134 = (_zz_when_BankedScratchMemory_l228_132 || _zz_when_BankedScratchMemory_l228_133);
  assign when_BankedScratchMemory_l234_66 = (_zz_when_BankedScratchMemory_l234_66 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_66 = (_zz_when_BankedScratchMemory_l234_66 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_135 = ((io_scalarReadEn_4 && (! io_blockScalarReads)) && (scalarBankReq_4 == 3'b111));
  assign when_BankedScratchMemory_l228_67 = (_zz_when_BankedScratchMemory_l228_135 && (! _zz_when_BankedScratchMemory_l228_134));
  assign _zz_when_BankedScratchMemory_l234_67 = ((_zz_when_BankedScratchMemory_l228_135 && _zz_when_BankedScratchMemory_l228_134) && (! _zz_when_BankedScratchMemory_l245_67));
  assign when_BankedScratchMemory_l245_67 = (_zz_when_BankedScratchMemory_l228_135 && _zz_when_BankedScratchMemory_l245_67);
  assign _zz_when_BankedScratchMemory_l245_68 = (_zz_when_BankedScratchMemory_l245_67 || (_zz_when_BankedScratchMemory_l228_134 && _zz_when_BankedScratchMemory_l228_135));
  assign _zz_when_BankedScratchMemory_l228_136 = (_zz_when_BankedScratchMemory_l228_134 || _zz_when_BankedScratchMemory_l228_135);
  assign when_BankedScratchMemory_l234_67 = (_zz_when_BankedScratchMemory_l234_67 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_67 = (_zz_when_BankedScratchMemory_l234_67 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_137 = ((io_scalarReadEn_5 && (! io_blockScalarReads)) && (scalarBankReq_5 == 3'b111));
  assign when_BankedScratchMemory_l228_68 = (_zz_when_BankedScratchMemory_l228_137 && (! _zz_when_BankedScratchMemory_l228_136));
  assign _zz_when_BankedScratchMemory_l234_68 = ((_zz_when_BankedScratchMemory_l228_137 && _zz_when_BankedScratchMemory_l228_136) && (! _zz_when_BankedScratchMemory_l245_68));
  assign when_BankedScratchMemory_l245_68 = (_zz_when_BankedScratchMemory_l228_137 && _zz_when_BankedScratchMemory_l245_68);
  assign _zz_when_BankedScratchMemory_l245_69 = (_zz_when_BankedScratchMemory_l245_68 || (_zz_when_BankedScratchMemory_l228_136 && _zz_when_BankedScratchMemory_l228_137));
  assign _zz_when_BankedScratchMemory_l228_138 = (_zz_when_BankedScratchMemory_l228_136 || _zz_when_BankedScratchMemory_l228_137);
  assign when_BankedScratchMemory_l234_68 = (_zz_when_BankedScratchMemory_l234_68 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_68 = (_zz_when_BankedScratchMemory_l234_68 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_139 = ((io_scalarReadEn_6 && (! io_blockScalarReads)) && (scalarBankReq_6 == 3'b111));
  assign when_BankedScratchMemory_l228_69 = (_zz_when_BankedScratchMemory_l228_139 && (! _zz_when_BankedScratchMemory_l228_138));
  assign _zz_when_BankedScratchMemory_l234_69 = ((_zz_when_BankedScratchMemory_l228_139 && _zz_when_BankedScratchMemory_l228_138) && (! _zz_when_BankedScratchMemory_l245_69));
  assign when_BankedScratchMemory_l245_69 = (_zz_when_BankedScratchMemory_l228_139 && _zz_when_BankedScratchMemory_l245_69);
  assign _zz_when_BankedScratchMemory_l245_70 = (_zz_when_BankedScratchMemory_l245_69 || (_zz_when_BankedScratchMemory_l228_138 && _zz_when_BankedScratchMemory_l228_139));
  assign _zz_when_BankedScratchMemory_l228_140 = (_zz_when_BankedScratchMemory_l228_138 || _zz_when_BankedScratchMemory_l228_139);
  assign when_BankedScratchMemory_l234_69 = (_zz_when_BankedScratchMemory_l234_69 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_69 = (_zz_when_BankedScratchMemory_l234_69 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_141 = ((io_scalarReadEn_7 && (! io_blockScalarReads)) && (scalarBankReq_7 == 3'b111));
  assign when_BankedScratchMemory_l228_70 = (_zz_when_BankedScratchMemory_l228_141 && (! _zz_when_BankedScratchMemory_l228_140));
  assign _zz_when_BankedScratchMemory_l234_70 = ((_zz_when_BankedScratchMemory_l228_141 && _zz_when_BankedScratchMemory_l228_140) && (! _zz_when_BankedScratchMemory_l245_70));
  assign when_BankedScratchMemory_l245_70 = (_zz_when_BankedScratchMemory_l228_141 && _zz_when_BankedScratchMemory_l245_70);
  assign _zz_when_BankedScratchMemory_l245_71 = (_zz_when_BankedScratchMemory_l245_70 || (_zz_when_BankedScratchMemory_l228_140 && _zz_when_BankedScratchMemory_l228_141));
  assign _zz_when_BankedScratchMemory_l228_142 = (_zz_when_BankedScratchMemory_l228_140 || _zz_when_BankedScratchMemory_l228_141);
  assign when_BankedScratchMemory_l234_70 = (_zz_when_BankedScratchMemory_l234_70 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_70 = (_zz_when_BankedScratchMemory_l234_70 && bankWriteActive_7);
  assign _zz_when_BankedScratchMemory_l228_143 = ((io_scalarReadEn_8 && (! io_blockScalarReads)) && (scalarBankReq_8 == 3'b111));
  assign when_BankedScratchMemory_l228_71 = (_zz_when_BankedScratchMemory_l228_143 && (! _zz_when_BankedScratchMemory_l228_142));
  assign _zz_when_BankedScratchMemory_l234_71 = ((_zz_when_BankedScratchMemory_l228_143 && _zz_when_BankedScratchMemory_l228_142) && (! _zz_when_BankedScratchMemory_l245_71));
  assign when_BankedScratchMemory_l245_71 = (_zz_when_BankedScratchMemory_l228_143 && _zz_when_BankedScratchMemory_l245_71);
  assign when_BankedScratchMemory_l234_71 = (_zz_when_BankedScratchMemory_l234_71 && (! bankWriteActive_7));
  assign when_BankedScratchMemory_l242_71 = (_zz_when_BankedScratchMemory_l234_71 && bankWriteActive_7);
  assign when_BankedScratchMemory_l262 = (scalarBankReqReg_0 == 3'b000);
  assign when_BankedScratchMemory_l262_1 = (scalarBankReqReg_0 == 3'b001);
  assign when_BankedScratchMemory_l262_2 = (scalarBankReqReg_0 == 3'b010);
  assign when_BankedScratchMemory_l262_3 = (scalarBankReqReg_0 == 3'b011);
  assign when_BankedScratchMemory_l262_4 = (scalarBankReqReg_0 == 3'b100);
  assign when_BankedScratchMemory_l262_5 = (scalarBankReqReg_0 == 3'b101);
  assign when_BankedScratchMemory_l262_6 = (scalarBankReqReg_0 == 3'b110);
  assign when_BankedScratchMemory_l262_7 = (scalarBankReqReg_0 == 3'b111);
  assign when_BankedScratchMemory_l262_8 = (scalarBankReqReg_1 == 3'b000);
  assign when_BankedScratchMemory_l262_9 = (scalarBankReqReg_1 == 3'b001);
  assign when_BankedScratchMemory_l262_10 = (scalarBankReqReg_1 == 3'b010);
  assign when_BankedScratchMemory_l262_11 = (scalarBankReqReg_1 == 3'b011);
  assign when_BankedScratchMemory_l262_12 = (scalarBankReqReg_1 == 3'b100);
  assign when_BankedScratchMemory_l262_13 = (scalarBankReqReg_1 == 3'b101);
  assign when_BankedScratchMemory_l262_14 = (scalarBankReqReg_1 == 3'b110);
  assign when_BankedScratchMemory_l262_15 = (scalarBankReqReg_1 == 3'b111);
  assign when_BankedScratchMemory_l262_16 = (scalarBankReqReg_2 == 3'b000);
  assign when_BankedScratchMemory_l262_17 = (scalarBankReqReg_2 == 3'b001);
  assign when_BankedScratchMemory_l262_18 = (scalarBankReqReg_2 == 3'b010);
  assign when_BankedScratchMemory_l262_19 = (scalarBankReqReg_2 == 3'b011);
  assign when_BankedScratchMemory_l262_20 = (scalarBankReqReg_2 == 3'b100);
  assign when_BankedScratchMemory_l262_21 = (scalarBankReqReg_2 == 3'b101);
  assign when_BankedScratchMemory_l262_22 = (scalarBankReqReg_2 == 3'b110);
  assign when_BankedScratchMemory_l262_23 = (scalarBankReqReg_2 == 3'b111);
  assign when_BankedScratchMemory_l262_24 = (scalarBankReqReg_3 == 3'b000);
  assign when_BankedScratchMemory_l262_25 = (scalarBankReqReg_3 == 3'b001);
  assign when_BankedScratchMemory_l262_26 = (scalarBankReqReg_3 == 3'b010);
  assign when_BankedScratchMemory_l262_27 = (scalarBankReqReg_3 == 3'b011);
  assign when_BankedScratchMemory_l262_28 = (scalarBankReqReg_3 == 3'b100);
  assign when_BankedScratchMemory_l262_29 = (scalarBankReqReg_3 == 3'b101);
  assign when_BankedScratchMemory_l262_30 = (scalarBankReqReg_3 == 3'b110);
  assign when_BankedScratchMemory_l262_31 = (scalarBankReqReg_3 == 3'b111);
  assign when_BankedScratchMemory_l262_32 = (scalarBankReqReg_4 == 3'b000);
  assign when_BankedScratchMemory_l262_33 = (scalarBankReqReg_4 == 3'b001);
  assign when_BankedScratchMemory_l262_34 = (scalarBankReqReg_4 == 3'b010);
  assign when_BankedScratchMemory_l262_35 = (scalarBankReqReg_4 == 3'b011);
  assign when_BankedScratchMemory_l262_36 = (scalarBankReqReg_4 == 3'b100);
  assign when_BankedScratchMemory_l262_37 = (scalarBankReqReg_4 == 3'b101);
  assign when_BankedScratchMemory_l262_38 = (scalarBankReqReg_4 == 3'b110);
  assign when_BankedScratchMemory_l262_39 = (scalarBankReqReg_4 == 3'b111);
  assign when_BankedScratchMemory_l262_40 = (scalarBankReqReg_5 == 3'b000);
  assign when_BankedScratchMemory_l262_41 = (scalarBankReqReg_5 == 3'b001);
  assign when_BankedScratchMemory_l262_42 = (scalarBankReqReg_5 == 3'b010);
  assign when_BankedScratchMemory_l262_43 = (scalarBankReqReg_5 == 3'b011);
  assign when_BankedScratchMemory_l262_44 = (scalarBankReqReg_5 == 3'b100);
  assign when_BankedScratchMemory_l262_45 = (scalarBankReqReg_5 == 3'b101);
  assign when_BankedScratchMemory_l262_46 = (scalarBankReqReg_5 == 3'b110);
  assign when_BankedScratchMemory_l262_47 = (scalarBankReqReg_5 == 3'b111);
  assign when_BankedScratchMemory_l262_48 = (scalarBankReqReg_6 == 3'b000);
  assign when_BankedScratchMemory_l262_49 = (scalarBankReqReg_6 == 3'b001);
  assign when_BankedScratchMemory_l262_50 = (scalarBankReqReg_6 == 3'b010);
  assign when_BankedScratchMemory_l262_51 = (scalarBankReqReg_6 == 3'b011);
  assign when_BankedScratchMemory_l262_52 = (scalarBankReqReg_6 == 3'b100);
  assign when_BankedScratchMemory_l262_53 = (scalarBankReqReg_6 == 3'b101);
  assign when_BankedScratchMemory_l262_54 = (scalarBankReqReg_6 == 3'b110);
  assign when_BankedScratchMemory_l262_55 = (scalarBankReqReg_6 == 3'b111);
  assign when_BankedScratchMemory_l262_56 = (scalarBankReqReg_7 == 3'b000);
  assign when_BankedScratchMemory_l262_57 = (scalarBankReqReg_7 == 3'b001);
  assign when_BankedScratchMemory_l262_58 = (scalarBankReqReg_7 == 3'b010);
  assign when_BankedScratchMemory_l262_59 = (scalarBankReqReg_7 == 3'b011);
  assign when_BankedScratchMemory_l262_60 = (scalarBankReqReg_7 == 3'b100);
  assign when_BankedScratchMemory_l262_61 = (scalarBankReqReg_7 == 3'b101);
  assign when_BankedScratchMemory_l262_62 = (scalarBankReqReg_7 == 3'b110);
  assign when_BankedScratchMemory_l262_63 = (scalarBankReqReg_7 == 3'b111);
  assign when_BankedScratchMemory_l262_64 = (scalarBankReqReg_8 == 3'b000);
  assign when_BankedScratchMemory_l262_65 = (scalarBankReqReg_8 == 3'b001);
  assign when_BankedScratchMemory_l262_66 = (scalarBankReqReg_8 == 3'b010);
  assign when_BankedScratchMemory_l262_67 = (scalarBankReqReg_8 == 3'b011);
  assign when_BankedScratchMemory_l262_68 = (scalarBankReqReg_8 == 3'b100);
  assign when_BankedScratchMemory_l262_69 = (scalarBankReqReg_8 == 3'b101);
  assign when_BankedScratchMemory_l262_70 = (scalarBankReqReg_8 == 3'b110);
  assign when_BankedScratchMemory_l262_71 = (scalarBankReqReg_8 == 3'b111);
  assign _zz_when_BankedScratchMemory_l286 = io_valuReadAddr_0_0[2 : 0];
  assign _zz_io_aAddr = io_valuReadAddr_0_0[10 : 3];
  assign when_BankedScratchMemory_l286 = ((_zz_when_BankedScratchMemory_l286 == 3'b000) && io_valuReadEn_0_0);
  assign when_BankedScratchMemory_l286_1 = ((_zz_when_BankedScratchMemory_l286 == 3'b001) && io_valuReadEn_0_0);
  assign when_BankedScratchMemory_l286_2 = ((_zz_when_BankedScratchMemory_l286 == 3'b010) && io_valuReadEn_0_0);
  assign when_BankedScratchMemory_l286_3 = ((_zz_when_BankedScratchMemory_l286 == 3'b011) && io_valuReadEn_0_0);
  assign when_BankedScratchMemory_l286_4 = ((_zz_when_BankedScratchMemory_l286 == 3'b100) && io_valuReadEn_0_0);
  assign when_BankedScratchMemory_l286_5 = ((_zz_when_BankedScratchMemory_l286 == 3'b101) && io_valuReadEn_0_0);
  assign when_BankedScratchMemory_l286_6 = ((_zz_when_BankedScratchMemory_l286 == 3'b110) && io_valuReadEn_0_0);
  assign when_BankedScratchMemory_l286_7 = ((_zz_when_BankedScratchMemory_l286 == 3'b111) && io_valuReadEn_0_0);
  always @(*) begin
    _zz_io_valuReadData_0_0 = 32'h0;
    if(when_BankedScratchMemory_l308) begin
      _zz_io_valuReadData_0_0 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_1) begin
      _zz_io_valuReadData_0_0 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_2) begin
      _zz_io_valuReadData_0_0 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_3) begin
      _zz_io_valuReadData_0_0 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_4) begin
      _zz_io_valuReadData_0_0 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_5) begin
      _zz_io_valuReadData_0_0 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_6) begin
      _zz_io_valuReadData_0_0 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_7) begin
      _zz_io_valuReadData_0_0 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308 = (_zz_when_BankedScratchMemory_l308 == 3'b000);
  assign when_BankedScratchMemory_l308_1 = (_zz_when_BankedScratchMemory_l308 == 3'b001);
  assign when_BankedScratchMemory_l308_2 = (_zz_when_BankedScratchMemory_l308 == 3'b010);
  assign when_BankedScratchMemory_l308_3 = (_zz_when_BankedScratchMemory_l308 == 3'b011);
  assign when_BankedScratchMemory_l308_4 = (_zz_when_BankedScratchMemory_l308 == 3'b100);
  assign when_BankedScratchMemory_l308_5 = (_zz_when_BankedScratchMemory_l308 == 3'b101);
  assign when_BankedScratchMemory_l308_6 = (_zz_when_BankedScratchMemory_l308 == 3'b110);
  assign when_BankedScratchMemory_l308_7 = (_zz_when_BankedScratchMemory_l308 == 3'b111);
  always @(*) begin
    io_valuReadData_0_0 = _zz_io_valuReadData_0_0;
    if(fwdValuGap2Valid_0_0) begin
      io_valuReadData_0_0 = fwdValuGap2Data_0_0;
    end
    if(when_BankedScratchMemory_l448) begin
      io_valuReadData_0_0 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_1) begin
      io_valuReadData_0_0 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_2) begin
      io_valuReadData_0_0 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_3) begin
      io_valuReadData_0_0 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_4) begin
      io_valuReadData_0_0 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_5) begin
      io_valuReadData_0_0 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_6) begin
      io_valuReadData_0_0 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_7) begin
      io_valuReadData_0_0 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_8) begin
      io_valuReadData_0_0 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_9) begin
      io_valuReadData_0_0 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_10) begin
      io_valuReadData_0_0 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_11) begin
      io_valuReadData_0_0 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_12) begin
      io_valuReadData_0_0 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_13) begin
      io_valuReadData_0_0 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_14) begin
      io_valuReadData_0_0 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_15) begin
      io_valuReadData_0_0 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_16) begin
      io_valuReadData_0_0 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_17) begin
      io_valuReadData_0_0 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_18) begin
      io_valuReadData_0_0 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_19) begin
      io_valuReadData_0_0 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_20) begin
      io_valuReadData_0_0 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_21) begin
      io_valuReadData_0_0 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_22) begin
      io_valuReadData_0_0 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_23) begin
      io_valuReadData_0_0 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_24) begin
      io_valuReadData_0_0 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_25) begin
      io_valuReadData_0_0 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_26) begin
      io_valuReadData_0_0 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_27) begin
      io_valuReadData_0_0 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_1 = io_valuReadAddr_0_1[2 : 0];
  assign _zz_io_aAddr_1 = io_valuReadAddr_0_1[10 : 3];
  assign when_BankedScratchMemory_l286_8 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b000) && io_valuReadEn_0_1);
  assign when_BankedScratchMemory_l286_9 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b001) && io_valuReadEn_0_1);
  assign when_BankedScratchMemory_l286_10 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b010) && io_valuReadEn_0_1);
  assign when_BankedScratchMemory_l286_11 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b011) && io_valuReadEn_0_1);
  assign when_BankedScratchMemory_l286_12 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b100) && io_valuReadEn_0_1);
  assign when_BankedScratchMemory_l286_13 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b101) && io_valuReadEn_0_1);
  assign when_BankedScratchMemory_l286_14 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b110) && io_valuReadEn_0_1);
  assign when_BankedScratchMemory_l286_15 = ((_zz_when_BankedScratchMemory_l286_1 == 3'b111) && io_valuReadEn_0_1);
  always @(*) begin
    _zz_io_valuReadData_0_1 = 32'h0;
    if(when_BankedScratchMemory_l308_8) begin
      _zz_io_valuReadData_0_1 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_9) begin
      _zz_io_valuReadData_0_1 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_10) begin
      _zz_io_valuReadData_0_1 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_11) begin
      _zz_io_valuReadData_0_1 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_12) begin
      _zz_io_valuReadData_0_1 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_13) begin
      _zz_io_valuReadData_0_1 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_14) begin
      _zz_io_valuReadData_0_1 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_15) begin
      _zz_io_valuReadData_0_1 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308_8 = (_zz_when_BankedScratchMemory_l308_1 == 3'b000);
  assign when_BankedScratchMemory_l308_9 = (_zz_when_BankedScratchMemory_l308_1 == 3'b001);
  assign when_BankedScratchMemory_l308_10 = (_zz_when_BankedScratchMemory_l308_1 == 3'b010);
  assign when_BankedScratchMemory_l308_11 = (_zz_when_BankedScratchMemory_l308_1 == 3'b011);
  assign when_BankedScratchMemory_l308_12 = (_zz_when_BankedScratchMemory_l308_1 == 3'b100);
  assign when_BankedScratchMemory_l308_13 = (_zz_when_BankedScratchMemory_l308_1 == 3'b101);
  assign when_BankedScratchMemory_l308_14 = (_zz_when_BankedScratchMemory_l308_1 == 3'b110);
  assign when_BankedScratchMemory_l308_15 = (_zz_when_BankedScratchMemory_l308_1 == 3'b111);
  always @(*) begin
    io_valuReadData_0_1 = _zz_io_valuReadData_0_1;
    if(fwdValuGap2Valid_0_1) begin
      io_valuReadData_0_1 = fwdValuGap2Data_0_1;
    end
    if(when_BankedScratchMemory_l448_28) begin
      io_valuReadData_0_1 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_29) begin
      io_valuReadData_0_1 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_30) begin
      io_valuReadData_0_1 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_31) begin
      io_valuReadData_0_1 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_32) begin
      io_valuReadData_0_1 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_33) begin
      io_valuReadData_0_1 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_34) begin
      io_valuReadData_0_1 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_35) begin
      io_valuReadData_0_1 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_36) begin
      io_valuReadData_0_1 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_37) begin
      io_valuReadData_0_1 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_38) begin
      io_valuReadData_0_1 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_39) begin
      io_valuReadData_0_1 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_40) begin
      io_valuReadData_0_1 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_41) begin
      io_valuReadData_0_1 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_42) begin
      io_valuReadData_0_1 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_43) begin
      io_valuReadData_0_1 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_44) begin
      io_valuReadData_0_1 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_45) begin
      io_valuReadData_0_1 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_46) begin
      io_valuReadData_0_1 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_47) begin
      io_valuReadData_0_1 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_48) begin
      io_valuReadData_0_1 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_49) begin
      io_valuReadData_0_1 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_50) begin
      io_valuReadData_0_1 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_51) begin
      io_valuReadData_0_1 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_52) begin
      io_valuReadData_0_1 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_53) begin
      io_valuReadData_0_1 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_54) begin
      io_valuReadData_0_1 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_55) begin
      io_valuReadData_0_1 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_2 = io_valuReadAddr_0_2[2 : 0];
  assign _zz_io_aAddr_2 = io_valuReadAddr_0_2[10 : 3];
  assign when_BankedScratchMemory_l286_16 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b000) && io_valuReadEn_0_2);
  assign when_BankedScratchMemory_l286_17 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b001) && io_valuReadEn_0_2);
  assign when_BankedScratchMemory_l286_18 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b010) && io_valuReadEn_0_2);
  assign when_BankedScratchMemory_l286_19 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b011) && io_valuReadEn_0_2);
  assign when_BankedScratchMemory_l286_20 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b100) && io_valuReadEn_0_2);
  assign when_BankedScratchMemory_l286_21 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b101) && io_valuReadEn_0_2);
  assign when_BankedScratchMemory_l286_22 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b110) && io_valuReadEn_0_2);
  assign when_BankedScratchMemory_l286_23 = ((_zz_when_BankedScratchMemory_l286_2 == 3'b111) && io_valuReadEn_0_2);
  always @(*) begin
    _zz_io_valuReadData_0_2 = 32'h0;
    if(when_BankedScratchMemory_l308_16) begin
      _zz_io_valuReadData_0_2 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_17) begin
      _zz_io_valuReadData_0_2 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_18) begin
      _zz_io_valuReadData_0_2 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_19) begin
      _zz_io_valuReadData_0_2 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_20) begin
      _zz_io_valuReadData_0_2 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_21) begin
      _zz_io_valuReadData_0_2 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_22) begin
      _zz_io_valuReadData_0_2 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_23) begin
      _zz_io_valuReadData_0_2 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308_16 = (_zz_when_BankedScratchMemory_l308_2 == 3'b000);
  assign when_BankedScratchMemory_l308_17 = (_zz_when_BankedScratchMemory_l308_2 == 3'b001);
  assign when_BankedScratchMemory_l308_18 = (_zz_when_BankedScratchMemory_l308_2 == 3'b010);
  assign when_BankedScratchMemory_l308_19 = (_zz_when_BankedScratchMemory_l308_2 == 3'b011);
  assign when_BankedScratchMemory_l308_20 = (_zz_when_BankedScratchMemory_l308_2 == 3'b100);
  assign when_BankedScratchMemory_l308_21 = (_zz_when_BankedScratchMemory_l308_2 == 3'b101);
  assign when_BankedScratchMemory_l308_22 = (_zz_when_BankedScratchMemory_l308_2 == 3'b110);
  assign when_BankedScratchMemory_l308_23 = (_zz_when_BankedScratchMemory_l308_2 == 3'b111);
  always @(*) begin
    io_valuReadData_0_2 = _zz_io_valuReadData_0_2;
    if(fwdValuGap2Valid_0_2) begin
      io_valuReadData_0_2 = fwdValuGap2Data_0_2;
    end
    if(when_BankedScratchMemory_l448_56) begin
      io_valuReadData_0_2 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_57) begin
      io_valuReadData_0_2 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_58) begin
      io_valuReadData_0_2 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_59) begin
      io_valuReadData_0_2 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_60) begin
      io_valuReadData_0_2 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_61) begin
      io_valuReadData_0_2 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_62) begin
      io_valuReadData_0_2 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_63) begin
      io_valuReadData_0_2 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_64) begin
      io_valuReadData_0_2 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_65) begin
      io_valuReadData_0_2 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_66) begin
      io_valuReadData_0_2 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_67) begin
      io_valuReadData_0_2 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_68) begin
      io_valuReadData_0_2 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_69) begin
      io_valuReadData_0_2 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_70) begin
      io_valuReadData_0_2 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_71) begin
      io_valuReadData_0_2 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_72) begin
      io_valuReadData_0_2 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_73) begin
      io_valuReadData_0_2 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_74) begin
      io_valuReadData_0_2 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_75) begin
      io_valuReadData_0_2 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_76) begin
      io_valuReadData_0_2 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_77) begin
      io_valuReadData_0_2 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_78) begin
      io_valuReadData_0_2 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_79) begin
      io_valuReadData_0_2 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_80) begin
      io_valuReadData_0_2 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_81) begin
      io_valuReadData_0_2 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_82) begin
      io_valuReadData_0_2 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_83) begin
      io_valuReadData_0_2 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_3 = io_valuReadAddr_0_3[2 : 0];
  assign _zz_io_aAddr_3 = io_valuReadAddr_0_3[10 : 3];
  assign when_BankedScratchMemory_l286_24 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b000) && io_valuReadEn_0_3);
  assign when_BankedScratchMemory_l286_25 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b001) && io_valuReadEn_0_3);
  assign when_BankedScratchMemory_l286_26 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b010) && io_valuReadEn_0_3);
  assign when_BankedScratchMemory_l286_27 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b011) && io_valuReadEn_0_3);
  assign when_BankedScratchMemory_l286_28 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b100) && io_valuReadEn_0_3);
  assign when_BankedScratchMemory_l286_29 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b101) && io_valuReadEn_0_3);
  assign when_BankedScratchMemory_l286_30 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b110) && io_valuReadEn_0_3);
  assign when_BankedScratchMemory_l286_31 = ((_zz_when_BankedScratchMemory_l286_3 == 3'b111) && io_valuReadEn_0_3);
  always @(*) begin
    _zz_io_valuReadData_0_3 = 32'h0;
    if(when_BankedScratchMemory_l308_24) begin
      _zz_io_valuReadData_0_3 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_25) begin
      _zz_io_valuReadData_0_3 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_26) begin
      _zz_io_valuReadData_0_3 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_27) begin
      _zz_io_valuReadData_0_3 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_28) begin
      _zz_io_valuReadData_0_3 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_29) begin
      _zz_io_valuReadData_0_3 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_30) begin
      _zz_io_valuReadData_0_3 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_31) begin
      _zz_io_valuReadData_0_3 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308_24 = (_zz_when_BankedScratchMemory_l308_3 == 3'b000);
  assign when_BankedScratchMemory_l308_25 = (_zz_when_BankedScratchMemory_l308_3 == 3'b001);
  assign when_BankedScratchMemory_l308_26 = (_zz_when_BankedScratchMemory_l308_3 == 3'b010);
  assign when_BankedScratchMemory_l308_27 = (_zz_when_BankedScratchMemory_l308_3 == 3'b011);
  assign when_BankedScratchMemory_l308_28 = (_zz_when_BankedScratchMemory_l308_3 == 3'b100);
  assign when_BankedScratchMemory_l308_29 = (_zz_when_BankedScratchMemory_l308_3 == 3'b101);
  assign when_BankedScratchMemory_l308_30 = (_zz_when_BankedScratchMemory_l308_3 == 3'b110);
  assign when_BankedScratchMemory_l308_31 = (_zz_when_BankedScratchMemory_l308_3 == 3'b111);
  always @(*) begin
    io_valuReadData_0_3 = _zz_io_valuReadData_0_3;
    if(fwdValuGap2Valid_0_3) begin
      io_valuReadData_0_3 = fwdValuGap2Data_0_3;
    end
    if(when_BankedScratchMemory_l448_84) begin
      io_valuReadData_0_3 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_85) begin
      io_valuReadData_0_3 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_86) begin
      io_valuReadData_0_3 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_87) begin
      io_valuReadData_0_3 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_88) begin
      io_valuReadData_0_3 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_89) begin
      io_valuReadData_0_3 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_90) begin
      io_valuReadData_0_3 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_91) begin
      io_valuReadData_0_3 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_92) begin
      io_valuReadData_0_3 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_93) begin
      io_valuReadData_0_3 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_94) begin
      io_valuReadData_0_3 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_95) begin
      io_valuReadData_0_3 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_96) begin
      io_valuReadData_0_3 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_97) begin
      io_valuReadData_0_3 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_98) begin
      io_valuReadData_0_3 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_99) begin
      io_valuReadData_0_3 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_100) begin
      io_valuReadData_0_3 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_101) begin
      io_valuReadData_0_3 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_102) begin
      io_valuReadData_0_3 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_103) begin
      io_valuReadData_0_3 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_104) begin
      io_valuReadData_0_3 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_105) begin
      io_valuReadData_0_3 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_106) begin
      io_valuReadData_0_3 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_107) begin
      io_valuReadData_0_3 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_108) begin
      io_valuReadData_0_3 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_109) begin
      io_valuReadData_0_3 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_110) begin
      io_valuReadData_0_3 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_111) begin
      io_valuReadData_0_3 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_4 = io_valuReadAddr_0_4[2 : 0];
  assign _zz_io_aAddr_4 = io_valuReadAddr_0_4[10 : 3];
  assign when_BankedScratchMemory_l286_32 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b000) && io_valuReadEn_0_4);
  assign when_BankedScratchMemory_l286_33 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b001) && io_valuReadEn_0_4);
  assign when_BankedScratchMemory_l286_34 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b010) && io_valuReadEn_0_4);
  assign when_BankedScratchMemory_l286_35 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b011) && io_valuReadEn_0_4);
  assign when_BankedScratchMemory_l286_36 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b100) && io_valuReadEn_0_4);
  assign when_BankedScratchMemory_l286_37 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b101) && io_valuReadEn_0_4);
  assign when_BankedScratchMemory_l286_38 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b110) && io_valuReadEn_0_4);
  assign when_BankedScratchMemory_l286_39 = ((_zz_when_BankedScratchMemory_l286_4 == 3'b111) && io_valuReadEn_0_4);
  always @(*) begin
    _zz_io_valuReadData_0_4 = 32'h0;
    if(when_BankedScratchMemory_l308_32) begin
      _zz_io_valuReadData_0_4 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_33) begin
      _zz_io_valuReadData_0_4 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_34) begin
      _zz_io_valuReadData_0_4 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_35) begin
      _zz_io_valuReadData_0_4 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_36) begin
      _zz_io_valuReadData_0_4 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_37) begin
      _zz_io_valuReadData_0_4 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_38) begin
      _zz_io_valuReadData_0_4 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_39) begin
      _zz_io_valuReadData_0_4 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308_32 = (_zz_when_BankedScratchMemory_l308_4 == 3'b000);
  assign when_BankedScratchMemory_l308_33 = (_zz_when_BankedScratchMemory_l308_4 == 3'b001);
  assign when_BankedScratchMemory_l308_34 = (_zz_when_BankedScratchMemory_l308_4 == 3'b010);
  assign when_BankedScratchMemory_l308_35 = (_zz_when_BankedScratchMemory_l308_4 == 3'b011);
  assign when_BankedScratchMemory_l308_36 = (_zz_when_BankedScratchMemory_l308_4 == 3'b100);
  assign when_BankedScratchMemory_l308_37 = (_zz_when_BankedScratchMemory_l308_4 == 3'b101);
  assign when_BankedScratchMemory_l308_38 = (_zz_when_BankedScratchMemory_l308_4 == 3'b110);
  assign when_BankedScratchMemory_l308_39 = (_zz_when_BankedScratchMemory_l308_4 == 3'b111);
  always @(*) begin
    io_valuReadData_0_4 = _zz_io_valuReadData_0_4;
    if(fwdValuGap2Valid_0_4) begin
      io_valuReadData_0_4 = fwdValuGap2Data_0_4;
    end
    if(when_BankedScratchMemory_l448_112) begin
      io_valuReadData_0_4 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_113) begin
      io_valuReadData_0_4 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_114) begin
      io_valuReadData_0_4 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_115) begin
      io_valuReadData_0_4 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_116) begin
      io_valuReadData_0_4 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_117) begin
      io_valuReadData_0_4 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_118) begin
      io_valuReadData_0_4 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_119) begin
      io_valuReadData_0_4 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_120) begin
      io_valuReadData_0_4 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_121) begin
      io_valuReadData_0_4 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_122) begin
      io_valuReadData_0_4 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_123) begin
      io_valuReadData_0_4 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_124) begin
      io_valuReadData_0_4 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_125) begin
      io_valuReadData_0_4 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_126) begin
      io_valuReadData_0_4 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_127) begin
      io_valuReadData_0_4 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_128) begin
      io_valuReadData_0_4 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_129) begin
      io_valuReadData_0_4 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_130) begin
      io_valuReadData_0_4 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_131) begin
      io_valuReadData_0_4 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_132) begin
      io_valuReadData_0_4 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_133) begin
      io_valuReadData_0_4 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_134) begin
      io_valuReadData_0_4 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_135) begin
      io_valuReadData_0_4 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_136) begin
      io_valuReadData_0_4 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_137) begin
      io_valuReadData_0_4 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_138) begin
      io_valuReadData_0_4 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_139) begin
      io_valuReadData_0_4 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_5 = io_valuReadAddr_0_5[2 : 0];
  assign _zz_io_aAddr_5 = io_valuReadAddr_0_5[10 : 3];
  assign when_BankedScratchMemory_l286_40 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b000) && io_valuReadEn_0_5);
  assign when_BankedScratchMemory_l286_41 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b001) && io_valuReadEn_0_5);
  assign when_BankedScratchMemory_l286_42 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b010) && io_valuReadEn_0_5);
  assign when_BankedScratchMemory_l286_43 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b011) && io_valuReadEn_0_5);
  assign when_BankedScratchMemory_l286_44 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b100) && io_valuReadEn_0_5);
  assign when_BankedScratchMemory_l286_45 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b101) && io_valuReadEn_0_5);
  assign when_BankedScratchMemory_l286_46 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b110) && io_valuReadEn_0_5);
  assign when_BankedScratchMemory_l286_47 = ((_zz_when_BankedScratchMemory_l286_5 == 3'b111) && io_valuReadEn_0_5);
  always @(*) begin
    _zz_io_valuReadData_0_5 = 32'h0;
    if(when_BankedScratchMemory_l308_40) begin
      _zz_io_valuReadData_0_5 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_41) begin
      _zz_io_valuReadData_0_5 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_42) begin
      _zz_io_valuReadData_0_5 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_43) begin
      _zz_io_valuReadData_0_5 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_44) begin
      _zz_io_valuReadData_0_5 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_45) begin
      _zz_io_valuReadData_0_5 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_46) begin
      _zz_io_valuReadData_0_5 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_47) begin
      _zz_io_valuReadData_0_5 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308_40 = (_zz_when_BankedScratchMemory_l308_5 == 3'b000);
  assign when_BankedScratchMemory_l308_41 = (_zz_when_BankedScratchMemory_l308_5 == 3'b001);
  assign when_BankedScratchMemory_l308_42 = (_zz_when_BankedScratchMemory_l308_5 == 3'b010);
  assign when_BankedScratchMemory_l308_43 = (_zz_when_BankedScratchMemory_l308_5 == 3'b011);
  assign when_BankedScratchMemory_l308_44 = (_zz_when_BankedScratchMemory_l308_5 == 3'b100);
  assign when_BankedScratchMemory_l308_45 = (_zz_when_BankedScratchMemory_l308_5 == 3'b101);
  assign when_BankedScratchMemory_l308_46 = (_zz_when_BankedScratchMemory_l308_5 == 3'b110);
  assign when_BankedScratchMemory_l308_47 = (_zz_when_BankedScratchMemory_l308_5 == 3'b111);
  always @(*) begin
    io_valuReadData_0_5 = _zz_io_valuReadData_0_5;
    if(fwdValuGap2Valid_0_5) begin
      io_valuReadData_0_5 = fwdValuGap2Data_0_5;
    end
    if(when_BankedScratchMemory_l448_140) begin
      io_valuReadData_0_5 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_141) begin
      io_valuReadData_0_5 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_142) begin
      io_valuReadData_0_5 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_143) begin
      io_valuReadData_0_5 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_144) begin
      io_valuReadData_0_5 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_145) begin
      io_valuReadData_0_5 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_146) begin
      io_valuReadData_0_5 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_147) begin
      io_valuReadData_0_5 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_148) begin
      io_valuReadData_0_5 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_149) begin
      io_valuReadData_0_5 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_150) begin
      io_valuReadData_0_5 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_151) begin
      io_valuReadData_0_5 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_152) begin
      io_valuReadData_0_5 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_153) begin
      io_valuReadData_0_5 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_154) begin
      io_valuReadData_0_5 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_155) begin
      io_valuReadData_0_5 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_156) begin
      io_valuReadData_0_5 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_157) begin
      io_valuReadData_0_5 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_158) begin
      io_valuReadData_0_5 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_159) begin
      io_valuReadData_0_5 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_160) begin
      io_valuReadData_0_5 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_161) begin
      io_valuReadData_0_5 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_162) begin
      io_valuReadData_0_5 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_163) begin
      io_valuReadData_0_5 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_164) begin
      io_valuReadData_0_5 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_165) begin
      io_valuReadData_0_5 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_166) begin
      io_valuReadData_0_5 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_167) begin
      io_valuReadData_0_5 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_6 = io_valuReadAddr_0_6[2 : 0];
  assign _zz_io_aAddr_6 = io_valuReadAddr_0_6[10 : 3];
  assign when_BankedScratchMemory_l286_48 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b000) && io_valuReadEn_0_6);
  assign when_BankedScratchMemory_l286_49 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b001) && io_valuReadEn_0_6);
  assign when_BankedScratchMemory_l286_50 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b010) && io_valuReadEn_0_6);
  assign when_BankedScratchMemory_l286_51 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b011) && io_valuReadEn_0_6);
  assign when_BankedScratchMemory_l286_52 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b100) && io_valuReadEn_0_6);
  assign when_BankedScratchMemory_l286_53 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b101) && io_valuReadEn_0_6);
  assign when_BankedScratchMemory_l286_54 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b110) && io_valuReadEn_0_6);
  assign when_BankedScratchMemory_l286_55 = ((_zz_when_BankedScratchMemory_l286_6 == 3'b111) && io_valuReadEn_0_6);
  always @(*) begin
    _zz_io_valuReadData_0_6 = 32'h0;
    if(when_BankedScratchMemory_l308_48) begin
      _zz_io_valuReadData_0_6 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_49) begin
      _zz_io_valuReadData_0_6 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_50) begin
      _zz_io_valuReadData_0_6 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_51) begin
      _zz_io_valuReadData_0_6 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_52) begin
      _zz_io_valuReadData_0_6 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_53) begin
      _zz_io_valuReadData_0_6 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_54) begin
      _zz_io_valuReadData_0_6 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_55) begin
      _zz_io_valuReadData_0_6 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308_48 = (_zz_when_BankedScratchMemory_l308_6 == 3'b000);
  assign when_BankedScratchMemory_l308_49 = (_zz_when_BankedScratchMemory_l308_6 == 3'b001);
  assign when_BankedScratchMemory_l308_50 = (_zz_when_BankedScratchMemory_l308_6 == 3'b010);
  assign when_BankedScratchMemory_l308_51 = (_zz_when_BankedScratchMemory_l308_6 == 3'b011);
  assign when_BankedScratchMemory_l308_52 = (_zz_when_BankedScratchMemory_l308_6 == 3'b100);
  assign when_BankedScratchMemory_l308_53 = (_zz_when_BankedScratchMemory_l308_6 == 3'b101);
  assign when_BankedScratchMemory_l308_54 = (_zz_when_BankedScratchMemory_l308_6 == 3'b110);
  assign when_BankedScratchMemory_l308_55 = (_zz_when_BankedScratchMemory_l308_6 == 3'b111);
  always @(*) begin
    io_valuReadData_0_6 = _zz_io_valuReadData_0_6;
    if(fwdValuGap2Valid_0_6) begin
      io_valuReadData_0_6 = fwdValuGap2Data_0_6;
    end
    if(when_BankedScratchMemory_l448_168) begin
      io_valuReadData_0_6 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_169) begin
      io_valuReadData_0_6 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_170) begin
      io_valuReadData_0_6 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_171) begin
      io_valuReadData_0_6 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_172) begin
      io_valuReadData_0_6 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_173) begin
      io_valuReadData_0_6 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_174) begin
      io_valuReadData_0_6 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_175) begin
      io_valuReadData_0_6 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_176) begin
      io_valuReadData_0_6 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_177) begin
      io_valuReadData_0_6 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_178) begin
      io_valuReadData_0_6 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_179) begin
      io_valuReadData_0_6 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_180) begin
      io_valuReadData_0_6 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_181) begin
      io_valuReadData_0_6 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_182) begin
      io_valuReadData_0_6 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_183) begin
      io_valuReadData_0_6 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_184) begin
      io_valuReadData_0_6 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_185) begin
      io_valuReadData_0_6 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_186) begin
      io_valuReadData_0_6 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_187) begin
      io_valuReadData_0_6 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_188) begin
      io_valuReadData_0_6 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_189) begin
      io_valuReadData_0_6 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_190) begin
      io_valuReadData_0_6 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_191) begin
      io_valuReadData_0_6 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_192) begin
      io_valuReadData_0_6 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_193) begin
      io_valuReadData_0_6 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_194) begin
      io_valuReadData_0_6 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_195) begin
      io_valuReadData_0_6 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_7 = io_valuReadAddr_0_7[2 : 0];
  assign _zz_io_aAddr_7 = io_valuReadAddr_0_7[10 : 3];
  assign when_BankedScratchMemory_l286_56 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b000) && io_valuReadEn_0_7);
  assign when_BankedScratchMemory_l286_57 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b001) && io_valuReadEn_0_7);
  assign when_BankedScratchMemory_l286_58 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b010) && io_valuReadEn_0_7);
  assign when_BankedScratchMemory_l286_59 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b011) && io_valuReadEn_0_7);
  assign when_BankedScratchMemory_l286_60 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b100) && io_valuReadEn_0_7);
  assign when_BankedScratchMemory_l286_61 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b101) && io_valuReadEn_0_7);
  assign when_BankedScratchMemory_l286_62 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b110) && io_valuReadEn_0_7);
  assign when_BankedScratchMemory_l286_63 = ((_zz_when_BankedScratchMemory_l286_7 == 3'b111) && io_valuReadEn_0_7);
  always @(*) begin
    _zz_io_valuReadData_0_7 = 32'h0;
    if(when_BankedScratchMemory_l308_56) begin
      _zz_io_valuReadData_0_7 = banks_0_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_57) begin
      _zz_io_valuReadData_0_7 = banks_1_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_58) begin
      _zz_io_valuReadData_0_7 = banks_2_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_59) begin
      _zz_io_valuReadData_0_7 = banks_3_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_60) begin
      _zz_io_valuReadData_0_7 = banks_4_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_61) begin
      _zz_io_valuReadData_0_7 = banks_5_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_62) begin
      _zz_io_valuReadData_0_7 = banks_6_io_aRdData;
    end
    if(when_BankedScratchMemory_l308_63) begin
      _zz_io_valuReadData_0_7 = banks_7_io_aRdData;
    end
  end

  assign when_BankedScratchMemory_l308_56 = (_zz_when_BankedScratchMemory_l308_7 == 3'b000);
  assign when_BankedScratchMemory_l308_57 = (_zz_when_BankedScratchMemory_l308_7 == 3'b001);
  assign when_BankedScratchMemory_l308_58 = (_zz_when_BankedScratchMemory_l308_7 == 3'b010);
  assign when_BankedScratchMemory_l308_59 = (_zz_when_BankedScratchMemory_l308_7 == 3'b011);
  assign when_BankedScratchMemory_l308_60 = (_zz_when_BankedScratchMemory_l308_7 == 3'b100);
  assign when_BankedScratchMemory_l308_61 = (_zz_when_BankedScratchMemory_l308_7 == 3'b101);
  assign when_BankedScratchMemory_l308_62 = (_zz_when_BankedScratchMemory_l308_7 == 3'b110);
  assign when_BankedScratchMemory_l308_63 = (_zz_when_BankedScratchMemory_l308_7 == 3'b111);
  always @(*) begin
    io_valuReadData_0_7 = _zz_io_valuReadData_0_7;
    if(fwdValuGap2Valid_0_7) begin
      io_valuReadData_0_7 = fwdValuGap2Data_0_7;
    end
    if(when_BankedScratchMemory_l448_196) begin
      io_valuReadData_0_7 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_197) begin
      io_valuReadData_0_7 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_198) begin
      io_valuReadData_0_7 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_199) begin
      io_valuReadData_0_7 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_200) begin
      io_valuReadData_0_7 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_201) begin
      io_valuReadData_0_7 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_202) begin
      io_valuReadData_0_7 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_203) begin
      io_valuReadData_0_7 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_204) begin
      io_valuReadData_0_7 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_205) begin
      io_valuReadData_0_7 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_206) begin
      io_valuReadData_0_7 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_207) begin
      io_valuReadData_0_7 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_208) begin
      io_valuReadData_0_7 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_209) begin
      io_valuReadData_0_7 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_210) begin
      io_valuReadData_0_7 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_211) begin
      io_valuReadData_0_7 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_212) begin
      io_valuReadData_0_7 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_213) begin
      io_valuReadData_0_7 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_214) begin
      io_valuReadData_0_7 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_215) begin
      io_valuReadData_0_7 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_216) begin
      io_valuReadData_0_7 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_217) begin
      io_valuReadData_0_7 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_218) begin
      io_valuReadData_0_7 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_219) begin
      io_valuReadData_0_7 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_220) begin
      io_valuReadData_0_7 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_221) begin
      io_valuReadData_0_7 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_222) begin
      io_valuReadData_0_7 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_223) begin
      io_valuReadData_0_7 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_8 = io_valuReadAddr_1_0[2 : 0];
  assign _zz_io_bAddr_28 = io_valuReadAddr_1_0[10 : 3];
  assign when_BankedScratchMemory_l286_64 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b000) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_65 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b001) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295_1 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_66 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b010) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295_2 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_67 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b011) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295_3 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_68 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b100) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295_4 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_69 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b101) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295_5 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_70 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b110) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295_6 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_71 = ((_zz_when_BankedScratchMemory_l286_8 == 3'b111) && io_valuReadEn_1_0);
  assign when_BankedScratchMemory_l295_7 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_0 = 32'h0;
    if(when_BankedScratchMemory_l308_64) begin
      _zz_io_valuReadData_1_0 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_65) begin
      _zz_io_valuReadData_1_0 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_66) begin
      _zz_io_valuReadData_1_0 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_67) begin
      _zz_io_valuReadData_1_0 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_68) begin
      _zz_io_valuReadData_1_0 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_69) begin
      _zz_io_valuReadData_1_0 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_70) begin
      _zz_io_valuReadData_1_0 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_71) begin
      _zz_io_valuReadData_1_0 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_64 = (_zz_when_BankedScratchMemory_l308_8 == 3'b000);
  assign when_BankedScratchMemory_l308_65 = (_zz_when_BankedScratchMemory_l308_8 == 3'b001);
  assign when_BankedScratchMemory_l308_66 = (_zz_when_BankedScratchMemory_l308_8 == 3'b010);
  assign when_BankedScratchMemory_l308_67 = (_zz_when_BankedScratchMemory_l308_8 == 3'b011);
  assign when_BankedScratchMemory_l308_68 = (_zz_when_BankedScratchMemory_l308_8 == 3'b100);
  assign when_BankedScratchMemory_l308_69 = (_zz_when_BankedScratchMemory_l308_8 == 3'b101);
  assign when_BankedScratchMemory_l308_70 = (_zz_when_BankedScratchMemory_l308_8 == 3'b110);
  assign when_BankedScratchMemory_l308_71 = (_zz_when_BankedScratchMemory_l308_8 == 3'b111);
  always @(*) begin
    io_valuReadData_1_0 = _zz_io_valuReadData_1_0;
    if(fwdValuGap2Valid_1_0) begin
      io_valuReadData_1_0 = fwdValuGap2Data_1_0;
    end
    if(when_BankedScratchMemory_l448_224) begin
      io_valuReadData_1_0 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_225) begin
      io_valuReadData_1_0 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_226) begin
      io_valuReadData_1_0 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_227) begin
      io_valuReadData_1_0 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_228) begin
      io_valuReadData_1_0 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_229) begin
      io_valuReadData_1_0 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_230) begin
      io_valuReadData_1_0 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_231) begin
      io_valuReadData_1_0 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_232) begin
      io_valuReadData_1_0 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_233) begin
      io_valuReadData_1_0 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_234) begin
      io_valuReadData_1_0 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_235) begin
      io_valuReadData_1_0 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_236) begin
      io_valuReadData_1_0 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_237) begin
      io_valuReadData_1_0 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_238) begin
      io_valuReadData_1_0 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_239) begin
      io_valuReadData_1_0 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_240) begin
      io_valuReadData_1_0 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_241) begin
      io_valuReadData_1_0 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_242) begin
      io_valuReadData_1_0 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_243) begin
      io_valuReadData_1_0 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_244) begin
      io_valuReadData_1_0 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_245) begin
      io_valuReadData_1_0 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_246) begin
      io_valuReadData_1_0 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_247) begin
      io_valuReadData_1_0 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_248) begin
      io_valuReadData_1_0 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_249) begin
      io_valuReadData_1_0 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_250) begin
      io_valuReadData_1_0 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_251) begin
      io_valuReadData_1_0 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_9 = io_valuReadAddr_1_1[2 : 0];
  assign _zz_io_bAddr_29 = io_valuReadAddr_1_1[10 : 3];
  assign when_BankedScratchMemory_l286_72 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b000) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_8 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_73 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b001) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_9 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_74 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b010) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_10 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_75 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b011) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_11 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_76 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b100) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_12 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_77 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b101) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_13 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_78 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b110) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_14 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_79 = ((_zz_when_BankedScratchMemory_l286_9 == 3'b111) && io_valuReadEn_1_1);
  assign when_BankedScratchMemory_l295_15 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_1 = 32'h0;
    if(when_BankedScratchMemory_l308_72) begin
      _zz_io_valuReadData_1_1 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_73) begin
      _zz_io_valuReadData_1_1 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_74) begin
      _zz_io_valuReadData_1_1 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_75) begin
      _zz_io_valuReadData_1_1 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_76) begin
      _zz_io_valuReadData_1_1 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_77) begin
      _zz_io_valuReadData_1_1 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_78) begin
      _zz_io_valuReadData_1_1 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_79) begin
      _zz_io_valuReadData_1_1 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_72 = (_zz_when_BankedScratchMemory_l308_9 == 3'b000);
  assign when_BankedScratchMemory_l308_73 = (_zz_when_BankedScratchMemory_l308_9 == 3'b001);
  assign when_BankedScratchMemory_l308_74 = (_zz_when_BankedScratchMemory_l308_9 == 3'b010);
  assign when_BankedScratchMemory_l308_75 = (_zz_when_BankedScratchMemory_l308_9 == 3'b011);
  assign when_BankedScratchMemory_l308_76 = (_zz_when_BankedScratchMemory_l308_9 == 3'b100);
  assign when_BankedScratchMemory_l308_77 = (_zz_when_BankedScratchMemory_l308_9 == 3'b101);
  assign when_BankedScratchMemory_l308_78 = (_zz_when_BankedScratchMemory_l308_9 == 3'b110);
  assign when_BankedScratchMemory_l308_79 = (_zz_when_BankedScratchMemory_l308_9 == 3'b111);
  always @(*) begin
    io_valuReadData_1_1 = _zz_io_valuReadData_1_1;
    if(fwdValuGap2Valid_1_1) begin
      io_valuReadData_1_1 = fwdValuGap2Data_1_1;
    end
    if(when_BankedScratchMemory_l448_252) begin
      io_valuReadData_1_1 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_253) begin
      io_valuReadData_1_1 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_254) begin
      io_valuReadData_1_1 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_255) begin
      io_valuReadData_1_1 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_256) begin
      io_valuReadData_1_1 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_257) begin
      io_valuReadData_1_1 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_258) begin
      io_valuReadData_1_1 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_259) begin
      io_valuReadData_1_1 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_260) begin
      io_valuReadData_1_1 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_261) begin
      io_valuReadData_1_1 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_262) begin
      io_valuReadData_1_1 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_263) begin
      io_valuReadData_1_1 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_264) begin
      io_valuReadData_1_1 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_265) begin
      io_valuReadData_1_1 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_266) begin
      io_valuReadData_1_1 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_267) begin
      io_valuReadData_1_1 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_268) begin
      io_valuReadData_1_1 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_269) begin
      io_valuReadData_1_1 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_270) begin
      io_valuReadData_1_1 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_271) begin
      io_valuReadData_1_1 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_272) begin
      io_valuReadData_1_1 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_273) begin
      io_valuReadData_1_1 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_274) begin
      io_valuReadData_1_1 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_275) begin
      io_valuReadData_1_1 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_276) begin
      io_valuReadData_1_1 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_277) begin
      io_valuReadData_1_1 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_278) begin
      io_valuReadData_1_1 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_279) begin
      io_valuReadData_1_1 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_10 = io_valuReadAddr_1_2[2 : 0];
  assign _zz_io_bAddr_30 = io_valuReadAddr_1_2[10 : 3];
  assign when_BankedScratchMemory_l286_80 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b000) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_16 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_81 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b001) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_17 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_82 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b010) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_18 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_83 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b011) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_19 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_84 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b100) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_20 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_85 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b101) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_21 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_86 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b110) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_22 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_87 = ((_zz_when_BankedScratchMemory_l286_10 == 3'b111) && io_valuReadEn_1_2);
  assign when_BankedScratchMemory_l295_23 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_2 = 32'h0;
    if(when_BankedScratchMemory_l308_80) begin
      _zz_io_valuReadData_1_2 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_81) begin
      _zz_io_valuReadData_1_2 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_82) begin
      _zz_io_valuReadData_1_2 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_83) begin
      _zz_io_valuReadData_1_2 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_84) begin
      _zz_io_valuReadData_1_2 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_85) begin
      _zz_io_valuReadData_1_2 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_86) begin
      _zz_io_valuReadData_1_2 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_87) begin
      _zz_io_valuReadData_1_2 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_80 = (_zz_when_BankedScratchMemory_l308_10 == 3'b000);
  assign when_BankedScratchMemory_l308_81 = (_zz_when_BankedScratchMemory_l308_10 == 3'b001);
  assign when_BankedScratchMemory_l308_82 = (_zz_when_BankedScratchMemory_l308_10 == 3'b010);
  assign when_BankedScratchMemory_l308_83 = (_zz_when_BankedScratchMemory_l308_10 == 3'b011);
  assign when_BankedScratchMemory_l308_84 = (_zz_when_BankedScratchMemory_l308_10 == 3'b100);
  assign when_BankedScratchMemory_l308_85 = (_zz_when_BankedScratchMemory_l308_10 == 3'b101);
  assign when_BankedScratchMemory_l308_86 = (_zz_when_BankedScratchMemory_l308_10 == 3'b110);
  assign when_BankedScratchMemory_l308_87 = (_zz_when_BankedScratchMemory_l308_10 == 3'b111);
  always @(*) begin
    io_valuReadData_1_2 = _zz_io_valuReadData_1_2;
    if(fwdValuGap2Valid_1_2) begin
      io_valuReadData_1_2 = fwdValuGap2Data_1_2;
    end
    if(when_BankedScratchMemory_l448_280) begin
      io_valuReadData_1_2 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_281) begin
      io_valuReadData_1_2 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_282) begin
      io_valuReadData_1_2 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_283) begin
      io_valuReadData_1_2 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_284) begin
      io_valuReadData_1_2 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_285) begin
      io_valuReadData_1_2 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_286) begin
      io_valuReadData_1_2 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_287) begin
      io_valuReadData_1_2 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_288) begin
      io_valuReadData_1_2 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_289) begin
      io_valuReadData_1_2 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_290) begin
      io_valuReadData_1_2 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_291) begin
      io_valuReadData_1_2 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_292) begin
      io_valuReadData_1_2 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_293) begin
      io_valuReadData_1_2 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_294) begin
      io_valuReadData_1_2 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_295) begin
      io_valuReadData_1_2 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_296) begin
      io_valuReadData_1_2 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_297) begin
      io_valuReadData_1_2 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_298) begin
      io_valuReadData_1_2 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_299) begin
      io_valuReadData_1_2 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_300) begin
      io_valuReadData_1_2 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_301) begin
      io_valuReadData_1_2 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_302) begin
      io_valuReadData_1_2 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_303) begin
      io_valuReadData_1_2 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_304) begin
      io_valuReadData_1_2 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_305) begin
      io_valuReadData_1_2 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_306) begin
      io_valuReadData_1_2 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_307) begin
      io_valuReadData_1_2 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_11 = io_valuReadAddr_1_3[2 : 0];
  assign _zz_io_bAddr_31 = io_valuReadAddr_1_3[10 : 3];
  assign when_BankedScratchMemory_l286_88 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b000) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_24 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_89 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b001) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_25 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_90 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b010) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_26 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_91 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b011) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_27 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_92 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b100) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_28 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_93 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b101) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_29 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_94 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b110) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_30 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_95 = ((_zz_when_BankedScratchMemory_l286_11 == 3'b111) && io_valuReadEn_1_3);
  assign when_BankedScratchMemory_l295_31 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_3 = 32'h0;
    if(when_BankedScratchMemory_l308_88) begin
      _zz_io_valuReadData_1_3 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_89) begin
      _zz_io_valuReadData_1_3 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_90) begin
      _zz_io_valuReadData_1_3 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_91) begin
      _zz_io_valuReadData_1_3 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_92) begin
      _zz_io_valuReadData_1_3 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_93) begin
      _zz_io_valuReadData_1_3 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_94) begin
      _zz_io_valuReadData_1_3 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_95) begin
      _zz_io_valuReadData_1_3 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_88 = (_zz_when_BankedScratchMemory_l308_11 == 3'b000);
  assign when_BankedScratchMemory_l308_89 = (_zz_when_BankedScratchMemory_l308_11 == 3'b001);
  assign when_BankedScratchMemory_l308_90 = (_zz_when_BankedScratchMemory_l308_11 == 3'b010);
  assign when_BankedScratchMemory_l308_91 = (_zz_when_BankedScratchMemory_l308_11 == 3'b011);
  assign when_BankedScratchMemory_l308_92 = (_zz_when_BankedScratchMemory_l308_11 == 3'b100);
  assign when_BankedScratchMemory_l308_93 = (_zz_when_BankedScratchMemory_l308_11 == 3'b101);
  assign when_BankedScratchMemory_l308_94 = (_zz_when_BankedScratchMemory_l308_11 == 3'b110);
  assign when_BankedScratchMemory_l308_95 = (_zz_when_BankedScratchMemory_l308_11 == 3'b111);
  always @(*) begin
    io_valuReadData_1_3 = _zz_io_valuReadData_1_3;
    if(fwdValuGap2Valid_1_3) begin
      io_valuReadData_1_3 = fwdValuGap2Data_1_3;
    end
    if(when_BankedScratchMemory_l448_308) begin
      io_valuReadData_1_3 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_309) begin
      io_valuReadData_1_3 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_310) begin
      io_valuReadData_1_3 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_311) begin
      io_valuReadData_1_3 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_312) begin
      io_valuReadData_1_3 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_313) begin
      io_valuReadData_1_3 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_314) begin
      io_valuReadData_1_3 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_315) begin
      io_valuReadData_1_3 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_316) begin
      io_valuReadData_1_3 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_317) begin
      io_valuReadData_1_3 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_318) begin
      io_valuReadData_1_3 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_319) begin
      io_valuReadData_1_3 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_320) begin
      io_valuReadData_1_3 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_321) begin
      io_valuReadData_1_3 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_322) begin
      io_valuReadData_1_3 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_323) begin
      io_valuReadData_1_3 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_324) begin
      io_valuReadData_1_3 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_325) begin
      io_valuReadData_1_3 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_326) begin
      io_valuReadData_1_3 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_327) begin
      io_valuReadData_1_3 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_328) begin
      io_valuReadData_1_3 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_329) begin
      io_valuReadData_1_3 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_330) begin
      io_valuReadData_1_3 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_331) begin
      io_valuReadData_1_3 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_332) begin
      io_valuReadData_1_3 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_333) begin
      io_valuReadData_1_3 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_334) begin
      io_valuReadData_1_3 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_335) begin
      io_valuReadData_1_3 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_12 = io_valuReadAddr_1_4[2 : 0];
  assign _zz_io_bAddr_32 = io_valuReadAddr_1_4[10 : 3];
  assign when_BankedScratchMemory_l286_96 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b000) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_32 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_97 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b001) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_33 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_98 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b010) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_34 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_99 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b011) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_35 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_100 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b100) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_36 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_101 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b101) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_37 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_102 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b110) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_38 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_103 = ((_zz_when_BankedScratchMemory_l286_12 == 3'b111) && io_valuReadEn_1_4);
  assign when_BankedScratchMemory_l295_39 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_4 = 32'h0;
    if(when_BankedScratchMemory_l308_96) begin
      _zz_io_valuReadData_1_4 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_97) begin
      _zz_io_valuReadData_1_4 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_98) begin
      _zz_io_valuReadData_1_4 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_99) begin
      _zz_io_valuReadData_1_4 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_100) begin
      _zz_io_valuReadData_1_4 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_101) begin
      _zz_io_valuReadData_1_4 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_102) begin
      _zz_io_valuReadData_1_4 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_103) begin
      _zz_io_valuReadData_1_4 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_96 = (_zz_when_BankedScratchMemory_l308_12 == 3'b000);
  assign when_BankedScratchMemory_l308_97 = (_zz_when_BankedScratchMemory_l308_12 == 3'b001);
  assign when_BankedScratchMemory_l308_98 = (_zz_when_BankedScratchMemory_l308_12 == 3'b010);
  assign when_BankedScratchMemory_l308_99 = (_zz_when_BankedScratchMemory_l308_12 == 3'b011);
  assign when_BankedScratchMemory_l308_100 = (_zz_when_BankedScratchMemory_l308_12 == 3'b100);
  assign when_BankedScratchMemory_l308_101 = (_zz_when_BankedScratchMemory_l308_12 == 3'b101);
  assign when_BankedScratchMemory_l308_102 = (_zz_when_BankedScratchMemory_l308_12 == 3'b110);
  assign when_BankedScratchMemory_l308_103 = (_zz_when_BankedScratchMemory_l308_12 == 3'b111);
  always @(*) begin
    io_valuReadData_1_4 = _zz_io_valuReadData_1_4;
    if(fwdValuGap2Valid_1_4) begin
      io_valuReadData_1_4 = fwdValuGap2Data_1_4;
    end
    if(when_BankedScratchMemory_l448_336) begin
      io_valuReadData_1_4 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_337) begin
      io_valuReadData_1_4 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_338) begin
      io_valuReadData_1_4 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_339) begin
      io_valuReadData_1_4 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_340) begin
      io_valuReadData_1_4 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_341) begin
      io_valuReadData_1_4 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_342) begin
      io_valuReadData_1_4 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_343) begin
      io_valuReadData_1_4 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_344) begin
      io_valuReadData_1_4 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_345) begin
      io_valuReadData_1_4 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_346) begin
      io_valuReadData_1_4 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_347) begin
      io_valuReadData_1_4 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_348) begin
      io_valuReadData_1_4 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_349) begin
      io_valuReadData_1_4 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_350) begin
      io_valuReadData_1_4 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_351) begin
      io_valuReadData_1_4 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_352) begin
      io_valuReadData_1_4 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_353) begin
      io_valuReadData_1_4 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_354) begin
      io_valuReadData_1_4 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_355) begin
      io_valuReadData_1_4 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_356) begin
      io_valuReadData_1_4 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_357) begin
      io_valuReadData_1_4 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_358) begin
      io_valuReadData_1_4 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_359) begin
      io_valuReadData_1_4 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_360) begin
      io_valuReadData_1_4 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_361) begin
      io_valuReadData_1_4 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_362) begin
      io_valuReadData_1_4 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_363) begin
      io_valuReadData_1_4 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_13 = io_valuReadAddr_1_5[2 : 0];
  assign _zz_io_bAddr_33 = io_valuReadAddr_1_5[10 : 3];
  assign when_BankedScratchMemory_l286_104 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b000) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_40 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_105 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b001) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_41 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_106 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b010) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_42 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_107 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b011) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_43 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_108 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b100) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_44 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_109 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b101) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_45 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_110 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b110) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_46 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_111 = ((_zz_when_BankedScratchMemory_l286_13 == 3'b111) && io_valuReadEn_1_5);
  assign when_BankedScratchMemory_l295_47 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_5 = 32'h0;
    if(when_BankedScratchMemory_l308_104) begin
      _zz_io_valuReadData_1_5 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_105) begin
      _zz_io_valuReadData_1_5 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_106) begin
      _zz_io_valuReadData_1_5 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_107) begin
      _zz_io_valuReadData_1_5 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_108) begin
      _zz_io_valuReadData_1_5 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_109) begin
      _zz_io_valuReadData_1_5 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_110) begin
      _zz_io_valuReadData_1_5 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_111) begin
      _zz_io_valuReadData_1_5 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_104 = (_zz_when_BankedScratchMemory_l308_13 == 3'b000);
  assign when_BankedScratchMemory_l308_105 = (_zz_when_BankedScratchMemory_l308_13 == 3'b001);
  assign when_BankedScratchMemory_l308_106 = (_zz_when_BankedScratchMemory_l308_13 == 3'b010);
  assign when_BankedScratchMemory_l308_107 = (_zz_when_BankedScratchMemory_l308_13 == 3'b011);
  assign when_BankedScratchMemory_l308_108 = (_zz_when_BankedScratchMemory_l308_13 == 3'b100);
  assign when_BankedScratchMemory_l308_109 = (_zz_when_BankedScratchMemory_l308_13 == 3'b101);
  assign when_BankedScratchMemory_l308_110 = (_zz_when_BankedScratchMemory_l308_13 == 3'b110);
  assign when_BankedScratchMemory_l308_111 = (_zz_when_BankedScratchMemory_l308_13 == 3'b111);
  always @(*) begin
    io_valuReadData_1_5 = _zz_io_valuReadData_1_5;
    if(fwdValuGap2Valid_1_5) begin
      io_valuReadData_1_5 = fwdValuGap2Data_1_5;
    end
    if(when_BankedScratchMemory_l448_364) begin
      io_valuReadData_1_5 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_365) begin
      io_valuReadData_1_5 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_366) begin
      io_valuReadData_1_5 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_367) begin
      io_valuReadData_1_5 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_368) begin
      io_valuReadData_1_5 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_369) begin
      io_valuReadData_1_5 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_370) begin
      io_valuReadData_1_5 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_371) begin
      io_valuReadData_1_5 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_372) begin
      io_valuReadData_1_5 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_373) begin
      io_valuReadData_1_5 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_374) begin
      io_valuReadData_1_5 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_375) begin
      io_valuReadData_1_5 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_376) begin
      io_valuReadData_1_5 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_377) begin
      io_valuReadData_1_5 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_378) begin
      io_valuReadData_1_5 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_379) begin
      io_valuReadData_1_5 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_380) begin
      io_valuReadData_1_5 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_381) begin
      io_valuReadData_1_5 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_382) begin
      io_valuReadData_1_5 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_383) begin
      io_valuReadData_1_5 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_384) begin
      io_valuReadData_1_5 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_385) begin
      io_valuReadData_1_5 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_386) begin
      io_valuReadData_1_5 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_387) begin
      io_valuReadData_1_5 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_388) begin
      io_valuReadData_1_5 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_389) begin
      io_valuReadData_1_5 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_390) begin
      io_valuReadData_1_5 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_391) begin
      io_valuReadData_1_5 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_14 = io_valuReadAddr_1_6[2 : 0];
  assign _zz_io_bAddr_34 = io_valuReadAddr_1_6[10 : 3];
  assign when_BankedScratchMemory_l286_112 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b000) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_48 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_113 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b001) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_49 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_114 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b010) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_50 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_115 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b011) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_51 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_116 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b100) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_52 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_117 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b101) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_53 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_118 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b110) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_54 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_119 = ((_zz_when_BankedScratchMemory_l286_14 == 3'b111) && io_valuReadEn_1_6);
  assign when_BankedScratchMemory_l295_55 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_6 = 32'h0;
    if(when_BankedScratchMemory_l308_112) begin
      _zz_io_valuReadData_1_6 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_113) begin
      _zz_io_valuReadData_1_6 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_114) begin
      _zz_io_valuReadData_1_6 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_115) begin
      _zz_io_valuReadData_1_6 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_116) begin
      _zz_io_valuReadData_1_6 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_117) begin
      _zz_io_valuReadData_1_6 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_118) begin
      _zz_io_valuReadData_1_6 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_119) begin
      _zz_io_valuReadData_1_6 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_112 = (_zz_when_BankedScratchMemory_l308_14 == 3'b000);
  assign when_BankedScratchMemory_l308_113 = (_zz_when_BankedScratchMemory_l308_14 == 3'b001);
  assign when_BankedScratchMemory_l308_114 = (_zz_when_BankedScratchMemory_l308_14 == 3'b010);
  assign when_BankedScratchMemory_l308_115 = (_zz_when_BankedScratchMemory_l308_14 == 3'b011);
  assign when_BankedScratchMemory_l308_116 = (_zz_when_BankedScratchMemory_l308_14 == 3'b100);
  assign when_BankedScratchMemory_l308_117 = (_zz_when_BankedScratchMemory_l308_14 == 3'b101);
  assign when_BankedScratchMemory_l308_118 = (_zz_when_BankedScratchMemory_l308_14 == 3'b110);
  assign when_BankedScratchMemory_l308_119 = (_zz_when_BankedScratchMemory_l308_14 == 3'b111);
  always @(*) begin
    io_valuReadData_1_6 = _zz_io_valuReadData_1_6;
    if(fwdValuGap2Valid_1_6) begin
      io_valuReadData_1_6 = fwdValuGap2Data_1_6;
    end
    if(when_BankedScratchMemory_l448_392) begin
      io_valuReadData_1_6 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_393) begin
      io_valuReadData_1_6 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_394) begin
      io_valuReadData_1_6 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_395) begin
      io_valuReadData_1_6 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_396) begin
      io_valuReadData_1_6 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_397) begin
      io_valuReadData_1_6 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_398) begin
      io_valuReadData_1_6 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_399) begin
      io_valuReadData_1_6 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_400) begin
      io_valuReadData_1_6 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_401) begin
      io_valuReadData_1_6 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_402) begin
      io_valuReadData_1_6 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_403) begin
      io_valuReadData_1_6 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_404) begin
      io_valuReadData_1_6 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_405) begin
      io_valuReadData_1_6 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_406) begin
      io_valuReadData_1_6 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_407) begin
      io_valuReadData_1_6 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_408) begin
      io_valuReadData_1_6 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_409) begin
      io_valuReadData_1_6 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_410) begin
      io_valuReadData_1_6 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_411) begin
      io_valuReadData_1_6 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_412) begin
      io_valuReadData_1_6 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_413) begin
      io_valuReadData_1_6 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_414) begin
      io_valuReadData_1_6 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_415) begin
      io_valuReadData_1_6 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_416) begin
      io_valuReadData_1_6 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_417) begin
      io_valuReadData_1_6 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_418) begin
      io_valuReadData_1_6 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_419) begin
      io_valuReadData_1_6 = io_writeData_27;
    end
  end

  assign _zz_when_BankedScratchMemory_l286_15 = io_valuReadAddr_1_7[2 : 0];
  assign _zz_io_bAddr_35 = io_valuReadAddr_1_7[10 : 3];
  assign when_BankedScratchMemory_l286_120 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b000) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_56 = (io_vectorReadActive && (! bankWriteActive_0));
  assign when_BankedScratchMemory_l286_121 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b001) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_57 = (io_vectorReadActive && (! bankWriteActive_1));
  assign when_BankedScratchMemory_l286_122 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b010) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_58 = (io_vectorReadActive && (! bankWriteActive_2));
  assign when_BankedScratchMemory_l286_123 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b011) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_59 = (io_vectorReadActive && (! bankWriteActive_3));
  assign when_BankedScratchMemory_l286_124 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b100) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_60 = (io_vectorReadActive && (! bankWriteActive_4));
  assign when_BankedScratchMemory_l286_125 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b101) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_61 = (io_vectorReadActive && (! bankWriteActive_5));
  assign when_BankedScratchMemory_l286_126 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b110) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_62 = (io_vectorReadActive && (! bankWriteActive_6));
  assign when_BankedScratchMemory_l286_127 = ((_zz_when_BankedScratchMemory_l286_15 == 3'b111) && io_valuReadEn_1_7);
  assign when_BankedScratchMemory_l295_63 = (io_vectorReadActive && (! bankWriteActive_7));
  always @(*) begin
    _zz_io_valuReadData_1_7 = 32'h0;
    if(when_BankedScratchMemory_l308_120) begin
      _zz_io_valuReadData_1_7 = banks_0_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_121) begin
      _zz_io_valuReadData_1_7 = banks_1_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_122) begin
      _zz_io_valuReadData_1_7 = banks_2_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_123) begin
      _zz_io_valuReadData_1_7 = banks_3_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_124) begin
      _zz_io_valuReadData_1_7 = banks_4_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_125) begin
      _zz_io_valuReadData_1_7 = banks_5_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_126) begin
      _zz_io_valuReadData_1_7 = banks_6_io_bRdData;
    end
    if(when_BankedScratchMemory_l308_127) begin
      _zz_io_valuReadData_1_7 = banks_7_io_bRdData;
    end
  end

  assign when_BankedScratchMemory_l308_120 = (_zz_when_BankedScratchMemory_l308_15 == 3'b000);
  assign when_BankedScratchMemory_l308_121 = (_zz_when_BankedScratchMemory_l308_15 == 3'b001);
  assign when_BankedScratchMemory_l308_122 = (_zz_when_BankedScratchMemory_l308_15 == 3'b010);
  assign when_BankedScratchMemory_l308_123 = (_zz_when_BankedScratchMemory_l308_15 == 3'b011);
  assign when_BankedScratchMemory_l308_124 = (_zz_when_BankedScratchMemory_l308_15 == 3'b100);
  assign when_BankedScratchMemory_l308_125 = (_zz_when_BankedScratchMemory_l308_15 == 3'b101);
  assign when_BankedScratchMemory_l308_126 = (_zz_when_BankedScratchMemory_l308_15 == 3'b110);
  assign when_BankedScratchMemory_l308_127 = (_zz_when_BankedScratchMemory_l308_15 == 3'b111);
  always @(*) begin
    io_valuReadData_1_7 = _zz_io_valuReadData_1_7;
    if(fwdValuGap2Valid_1_7) begin
      io_valuReadData_1_7 = fwdValuGap2Data_1_7;
    end
    if(when_BankedScratchMemory_l448_420) begin
      io_valuReadData_1_7 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l448_421) begin
      io_valuReadData_1_7 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l448_422) begin
      io_valuReadData_1_7 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l448_423) begin
      io_valuReadData_1_7 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l448_424) begin
      io_valuReadData_1_7 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l448_425) begin
      io_valuReadData_1_7 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l448_426) begin
      io_valuReadData_1_7 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l448_427) begin
      io_valuReadData_1_7 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l448_428) begin
      io_valuReadData_1_7 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l448_429) begin
      io_valuReadData_1_7 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l448_430) begin
      io_valuReadData_1_7 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l448_431) begin
      io_valuReadData_1_7 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l448_432) begin
      io_valuReadData_1_7 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l448_433) begin
      io_valuReadData_1_7 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l448_434) begin
      io_valuReadData_1_7 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l448_435) begin
      io_valuReadData_1_7 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l448_436) begin
      io_valuReadData_1_7 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l448_437) begin
      io_valuReadData_1_7 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l448_438) begin
      io_valuReadData_1_7 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l448_439) begin
      io_valuReadData_1_7 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l448_440) begin
      io_valuReadData_1_7 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l448_441) begin
      io_valuReadData_1_7 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l448_442) begin
      io_valuReadData_1_7 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l448_443) begin
      io_valuReadData_1_7 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l448_444) begin
      io_valuReadData_1_7 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l448_445) begin
      io_valuReadData_1_7 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l448_446) begin
      io_valuReadData_1_7 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l448_447) begin
      io_valuReadData_1_7 = io_writeData_27;
    end
  end

  always @(*) begin
    _zz_fwdGap2Data_0 = 32'h0;
    if(when_BankedScratchMemory_l360) begin
      _zz_fwdGap2Data_0 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_1) begin
      _zz_fwdGap2Data_0 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_2) begin
      _zz_fwdGap2Data_0 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_3) begin
      _zz_fwdGap2Data_0 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_4) begin
      _zz_fwdGap2Data_0 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_5) begin
      _zz_fwdGap2Data_0 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_6) begin
      _zz_fwdGap2Data_0 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_7) begin
      _zz_fwdGap2Data_0 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_8) begin
      _zz_fwdGap2Data_0 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_9) begin
      _zz_fwdGap2Data_0 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_10) begin
      _zz_fwdGap2Data_0 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_11) begin
      _zz_fwdGap2Data_0 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_12) begin
      _zz_fwdGap2Data_0 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_13) begin
      _zz_fwdGap2Data_0 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_14) begin
      _zz_fwdGap2Data_0 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_15) begin
      _zz_fwdGap2Data_0 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_16) begin
      _zz_fwdGap2Data_0 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_17) begin
      _zz_fwdGap2Data_0 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_18) begin
      _zz_fwdGap2Data_0 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_19) begin
      _zz_fwdGap2Data_0 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_20) begin
      _zz_fwdGap2Data_0 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_21) begin
      _zz_fwdGap2Data_0 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_22) begin
      _zz_fwdGap2Data_0 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_23) begin
      _zz_fwdGap2Data_0 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_24) begin
      _zz_fwdGap2Data_0 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_25) begin
      _zz_fwdGap2Data_0 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_26) begin
      _zz_fwdGap2Data_0 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_27) begin
      _zz_fwdGap2Data_0 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360 = ((io_writeEn_0 && io_scalarReadEn_0) && (io_writeAddr_0 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_1 = ((io_writeEn_1 && io_scalarReadEn_0) && (io_writeAddr_1 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_2 = ((io_writeEn_2 && io_scalarReadEn_0) && (io_writeAddr_2 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_3 = ((io_writeEn_3 && io_scalarReadEn_0) && (io_writeAddr_3 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_4 = ((io_writeEn_4 && io_scalarReadEn_0) && (io_writeAddr_4 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_5 = ((io_writeEn_5 && io_scalarReadEn_0) && (io_writeAddr_5 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_6 = ((io_writeEn_6 && io_scalarReadEn_0) && (io_writeAddr_6 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_7 = ((io_writeEn_7 && io_scalarReadEn_0) && (io_writeAddr_7 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_8 = ((io_writeEn_8 && io_scalarReadEn_0) && (io_writeAddr_8 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_9 = ((io_writeEn_9 && io_scalarReadEn_0) && (io_writeAddr_9 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_10 = ((io_writeEn_10 && io_scalarReadEn_0) && (io_writeAddr_10 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_11 = ((io_writeEn_11 && io_scalarReadEn_0) && (io_writeAddr_11 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_12 = ((io_writeEn_12 && io_scalarReadEn_0) && (io_writeAddr_12 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_13 = ((io_writeEn_13 && io_scalarReadEn_0) && (io_writeAddr_13 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_14 = ((io_writeEn_14 && io_scalarReadEn_0) && (io_writeAddr_14 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_15 = ((io_writeEn_15 && io_scalarReadEn_0) && (io_writeAddr_15 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_16 = ((io_writeEn_16 && io_scalarReadEn_0) && (io_writeAddr_16 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_17 = ((io_writeEn_17 && io_scalarReadEn_0) && (io_writeAddr_17 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_18 = ((io_writeEn_18 && io_scalarReadEn_0) && (io_writeAddr_18 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_19 = ((io_writeEn_19 && io_scalarReadEn_0) && (io_writeAddr_19 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_20 = ((io_writeEn_20 && io_scalarReadEn_0) && (io_writeAddr_20 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_21 = ((io_writeEn_21 && io_scalarReadEn_0) && (io_writeAddr_21 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_22 = ((io_writeEn_22 && io_scalarReadEn_0) && (io_writeAddr_22 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_23 = ((io_writeEn_23 && io_scalarReadEn_0) && (io_writeAddr_23 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_24 = ((io_writeEn_24 && io_scalarReadEn_0) && (io_writeAddr_24 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_25 = ((io_writeEn_25 && io_scalarReadEn_0) && (io_writeAddr_25 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_26 = ((io_writeEn_26 && io_scalarReadEn_0) && (io_writeAddr_26 == io_scalarReadAddr_0));
  assign when_BankedScratchMemory_l360_27 = ((io_writeEn_27 && io_scalarReadEn_0) && (io_writeAddr_27 == io_scalarReadAddr_0));
  always @(*) begin
    _zz_fwdGap2Data_1 = 32'h0;
    if(when_BankedScratchMemory_l360_28) begin
      _zz_fwdGap2Data_1 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_29) begin
      _zz_fwdGap2Data_1 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_30) begin
      _zz_fwdGap2Data_1 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_31) begin
      _zz_fwdGap2Data_1 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_32) begin
      _zz_fwdGap2Data_1 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_33) begin
      _zz_fwdGap2Data_1 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_34) begin
      _zz_fwdGap2Data_1 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_35) begin
      _zz_fwdGap2Data_1 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_36) begin
      _zz_fwdGap2Data_1 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_37) begin
      _zz_fwdGap2Data_1 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_38) begin
      _zz_fwdGap2Data_1 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_39) begin
      _zz_fwdGap2Data_1 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_40) begin
      _zz_fwdGap2Data_1 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_41) begin
      _zz_fwdGap2Data_1 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_42) begin
      _zz_fwdGap2Data_1 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_43) begin
      _zz_fwdGap2Data_1 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_44) begin
      _zz_fwdGap2Data_1 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_45) begin
      _zz_fwdGap2Data_1 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_46) begin
      _zz_fwdGap2Data_1 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_47) begin
      _zz_fwdGap2Data_1 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_48) begin
      _zz_fwdGap2Data_1 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_49) begin
      _zz_fwdGap2Data_1 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_50) begin
      _zz_fwdGap2Data_1 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_51) begin
      _zz_fwdGap2Data_1 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_52) begin
      _zz_fwdGap2Data_1 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_53) begin
      _zz_fwdGap2Data_1 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_54) begin
      _zz_fwdGap2Data_1 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_55) begin
      _zz_fwdGap2Data_1 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_28 = ((io_writeEn_0 && io_scalarReadEn_1) && (io_writeAddr_0 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_29 = ((io_writeEn_1 && io_scalarReadEn_1) && (io_writeAddr_1 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_30 = ((io_writeEn_2 && io_scalarReadEn_1) && (io_writeAddr_2 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_31 = ((io_writeEn_3 && io_scalarReadEn_1) && (io_writeAddr_3 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_32 = ((io_writeEn_4 && io_scalarReadEn_1) && (io_writeAddr_4 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_33 = ((io_writeEn_5 && io_scalarReadEn_1) && (io_writeAddr_5 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_34 = ((io_writeEn_6 && io_scalarReadEn_1) && (io_writeAddr_6 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_35 = ((io_writeEn_7 && io_scalarReadEn_1) && (io_writeAddr_7 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_36 = ((io_writeEn_8 && io_scalarReadEn_1) && (io_writeAddr_8 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_37 = ((io_writeEn_9 && io_scalarReadEn_1) && (io_writeAddr_9 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_38 = ((io_writeEn_10 && io_scalarReadEn_1) && (io_writeAddr_10 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_39 = ((io_writeEn_11 && io_scalarReadEn_1) && (io_writeAddr_11 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_40 = ((io_writeEn_12 && io_scalarReadEn_1) && (io_writeAddr_12 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_41 = ((io_writeEn_13 && io_scalarReadEn_1) && (io_writeAddr_13 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_42 = ((io_writeEn_14 && io_scalarReadEn_1) && (io_writeAddr_14 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_43 = ((io_writeEn_15 && io_scalarReadEn_1) && (io_writeAddr_15 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_44 = ((io_writeEn_16 && io_scalarReadEn_1) && (io_writeAddr_16 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_45 = ((io_writeEn_17 && io_scalarReadEn_1) && (io_writeAddr_17 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_46 = ((io_writeEn_18 && io_scalarReadEn_1) && (io_writeAddr_18 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_47 = ((io_writeEn_19 && io_scalarReadEn_1) && (io_writeAddr_19 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_48 = ((io_writeEn_20 && io_scalarReadEn_1) && (io_writeAddr_20 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_49 = ((io_writeEn_21 && io_scalarReadEn_1) && (io_writeAddr_21 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_50 = ((io_writeEn_22 && io_scalarReadEn_1) && (io_writeAddr_22 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_51 = ((io_writeEn_23 && io_scalarReadEn_1) && (io_writeAddr_23 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_52 = ((io_writeEn_24 && io_scalarReadEn_1) && (io_writeAddr_24 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_53 = ((io_writeEn_25 && io_scalarReadEn_1) && (io_writeAddr_25 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_54 = ((io_writeEn_26 && io_scalarReadEn_1) && (io_writeAddr_26 == io_scalarReadAddr_1));
  assign when_BankedScratchMemory_l360_55 = ((io_writeEn_27 && io_scalarReadEn_1) && (io_writeAddr_27 == io_scalarReadAddr_1));
  always @(*) begin
    _zz_fwdGap2Data_2 = 32'h0;
    if(when_BankedScratchMemory_l360_56) begin
      _zz_fwdGap2Data_2 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_57) begin
      _zz_fwdGap2Data_2 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_58) begin
      _zz_fwdGap2Data_2 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_59) begin
      _zz_fwdGap2Data_2 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_60) begin
      _zz_fwdGap2Data_2 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_61) begin
      _zz_fwdGap2Data_2 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_62) begin
      _zz_fwdGap2Data_2 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_63) begin
      _zz_fwdGap2Data_2 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_64) begin
      _zz_fwdGap2Data_2 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_65) begin
      _zz_fwdGap2Data_2 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_66) begin
      _zz_fwdGap2Data_2 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_67) begin
      _zz_fwdGap2Data_2 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_68) begin
      _zz_fwdGap2Data_2 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_69) begin
      _zz_fwdGap2Data_2 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_70) begin
      _zz_fwdGap2Data_2 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_71) begin
      _zz_fwdGap2Data_2 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_72) begin
      _zz_fwdGap2Data_2 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_73) begin
      _zz_fwdGap2Data_2 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_74) begin
      _zz_fwdGap2Data_2 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_75) begin
      _zz_fwdGap2Data_2 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_76) begin
      _zz_fwdGap2Data_2 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_77) begin
      _zz_fwdGap2Data_2 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_78) begin
      _zz_fwdGap2Data_2 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_79) begin
      _zz_fwdGap2Data_2 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_80) begin
      _zz_fwdGap2Data_2 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_81) begin
      _zz_fwdGap2Data_2 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_82) begin
      _zz_fwdGap2Data_2 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_83) begin
      _zz_fwdGap2Data_2 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_56 = ((io_writeEn_0 && io_scalarReadEn_2) && (io_writeAddr_0 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_57 = ((io_writeEn_1 && io_scalarReadEn_2) && (io_writeAddr_1 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_58 = ((io_writeEn_2 && io_scalarReadEn_2) && (io_writeAddr_2 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_59 = ((io_writeEn_3 && io_scalarReadEn_2) && (io_writeAddr_3 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_60 = ((io_writeEn_4 && io_scalarReadEn_2) && (io_writeAddr_4 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_61 = ((io_writeEn_5 && io_scalarReadEn_2) && (io_writeAddr_5 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_62 = ((io_writeEn_6 && io_scalarReadEn_2) && (io_writeAddr_6 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_63 = ((io_writeEn_7 && io_scalarReadEn_2) && (io_writeAddr_7 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_64 = ((io_writeEn_8 && io_scalarReadEn_2) && (io_writeAddr_8 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_65 = ((io_writeEn_9 && io_scalarReadEn_2) && (io_writeAddr_9 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_66 = ((io_writeEn_10 && io_scalarReadEn_2) && (io_writeAddr_10 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_67 = ((io_writeEn_11 && io_scalarReadEn_2) && (io_writeAddr_11 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_68 = ((io_writeEn_12 && io_scalarReadEn_2) && (io_writeAddr_12 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_69 = ((io_writeEn_13 && io_scalarReadEn_2) && (io_writeAddr_13 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_70 = ((io_writeEn_14 && io_scalarReadEn_2) && (io_writeAddr_14 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_71 = ((io_writeEn_15 && io_scalarReadEn_2) && (io_writeAddr_15 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_72 = ((io_writeEn_16 && io_scalarReadEn_2) && (io_writeAddr_16 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_73 = ((io_writeEn_17 && io_scalarReadEn_2) && (io_writeAddr_17 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_74 = ((io_writeEn_18 && io_scalarReadEn_2) && (io_writeAddr_18 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_75 = ((io_writeEn_19 && io_scalarReadEn_2) && (io_writeAddr_19 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_76 = ((io_writeEn_20 && io_scalarReadEn_2) && (io_writeAddr_20 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_77 = ((io_writeEn_21 && io_scalarReadEn_2) && (io_writeAddr_21 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_78 = ((io_writeEn_22 && io_scalarReadEn_2) && (io_writeAddr_22 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_79 = ((io_writeEn_23 && io_scalarReadEn_2) && (io_writeAddr_23 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_80 = ((io_writeEn_24 && io_scalarReadEn_2) && (io_writeAddr_24 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_81 = ((io_writeEn_25 && io_scalarReadEn_2) && (io_writeAddr_25 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_82 = ((io_writeEn_26 && io_scalarReadEn_2) && (io_writeAddr_26 == io_scalarReadAddr_2));
  assign when_BankedScratchMemory_l360_83 = ((io_writeEn_27 && io_scalarReadEn_2) && (io_writeAddr_27 == io_scalarReadAddr_2));
  always @(*) begin
    _zz_fwdGap2Data_3 = 32'h0;
    if(when_BankedScratchMemory_l360_84) begin
      _zz_fwdGap2Data_3 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_85) begin
      _zz_fwdGap2Data_3 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_86) begin
      _zz_fwdGap2Data_3 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_87) begin
      _zz_fwdGap2Data_3 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_88) begin
      _zz_fwdGap2Data_3 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_89) begin
      _zz_fwdGap2Data_3 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_90) begin
      _zz_fwdGap2Data_3 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_91) begin
      _zz_fwdGap2Data_3 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_92) begin
      _zz_fwdGap2Data_3 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_93) begin
      _zz_fwdGap2Data_3 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_94) begin
      _zz_fwdGap2Data_3 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_95) begin
      _zz_fwdGap2Data_3 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_96) begin
      _zz_fwdGap2Data_3 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_97) begin
      _zz_fwdGap2Data_3 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_98) begin
      _zz_fwdGap2Data_3 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_99) begin
      _zz_fwdGap2Data_3 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_100) begin
      _zz_fwdGap2Data_3 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_101) begin
      _zz_fwdGap2Data_3 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_102) begin
      _zz_fwdGap2Data_3 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_103) begin
      _zz_fwdGap2Data_3 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_104) begin
      _zz_fwdGap2Data_3 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_105) begin
      _zz_fwdGap2Data_3 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_106) begin
      _zz_fwdGap2Data_3 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_107) begin
      _zz_fwdGap2Data_3 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_108) begin
      _zz_fwdGap2Data_3 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_109) begin
      _zz_fwdGap2Data_3 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_110) begin
      _zz_fwdGap2Data_3 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_111) begin
      _zz_fwdGap2Data_3 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_84 = ((io_writeEn_0 && io_scalarReadEn_3) && (io_writeAddr_0 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_85 = ((io_writeEn_1 && io_scalarReadEn_3) && (io_writeAddr_1 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_86 = ((io_writeEn_2 && io_scalarReadEn_3) && (io_writeAddr_2 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_87 = ((io_writeEn_3 && io_scalarReadEn_3) && (io_writeAddr_3 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_88 = ((io_writeEn_4 && io_scalarReadEn_3) && (io_writeAddr_4 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_89 = ((io_writeEn_5 && io_scalarReadEn_3) && (io_writeAddr_5 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_90 = ((io_writeEn_6 && io_scalarReadEn_3) && (io_writeAddr_6 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_91 = ((io_writeEn_7 && io_scalarReadEn_3) && (io_writeAddr_7 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_92 = ((io_writeEn_8 && io_scalarReadEn_3) && (io_writeAddr_8 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_93 = ((io_writeEn_9 && io_scalarReadEn_3) && (io_writeAddr_9 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_94 = ((io_writeEn_10 && io_scalarReadEn_3) && (io_writeAddr_10 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_95 = ((io_writeEn_11 && io_scalarReadEn_3) && (io_writeAddr_11 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_96 = ((io_writeEn_12 && io_scalarReadEn_3) && (io_writeAddr_12 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_97 = ((io_writeEn_13 && io_scalarReadEn_3) && (io_writeAddr_13 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_98 = ((io_writeEn_14 && io_scalarReadEn_3) && (io_writeAddr_14 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_99 = ((io_writeEn_15 && io_scalarReadEn_3) && (io_writeAddr_15 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_100 = ((io_writeEn_16 && io_scalarReadEn_3) && (io_writeAddr_16 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_101 = ((io_writeEn_17 && io_scalarReadEn_3) && (io_writeAddr_17 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_102 = ((io_writeEn_18 && io_scalarReadEn_3) && (io_writeAddr_18 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_103 = ((io_writeEn_19 && io_scalarReadEn_3) && (io_writeAddr_19 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_104 = ((io_writeEn_20 && io_scalarReadEn_3) && (io_writeAddr_20 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_105 = ((io_writeEn_21 && io_scalarReadEn_3) && (io_writeAddr_21 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_106 = ((io_writeEn_22 && io_scalarReadEn_3) && (io_writeAddr_22 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_107 = ((io_writeEn_23 && io_scalarReadEn_3) && (io_writeAddr_23 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_108 = ((io_writeEn_24 && io_scalarReadEn_3) && (io_writeAddr_24 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_109 = ((io_writeEn_25 && io_scalarReadEn_3) && (io_writeAddr_25 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_110 = ((io_writeEn_26 && io_scalarReadEn_3) && (io_writeAddr_26 == io_scalarReadAddr_3));
  assign when_BankedScratchMemory_l360_111 = ((io_writeEn_27 && io_scalarReadEn_3) && (io_writeAddr_27 == io_scalarReadAddr_3));
  always @(*) begin
    _zz_fwdGap2Data_4 = 32'h0;
    if(when_BankedScratchMemory_l360_112) begin
      _zz_fwdGap2Data_4 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_113) begin
      _zz_fwdGap2Data_4 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_114) begin
      _zz_fwdGap2Data_4 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_115) begin
      _zz_fwdGap2Data_4 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_116) begin
      _zz_fwdGap2Data_4 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_117) begin
      _zz_fwdGap2Data_4 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_118) begin
      _zz_fwdGap2Data_4 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_119) begin
      _zz_fwdGap2Data_4 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_120) begin
      _zz_fwdGap2Data_4 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_121) begin
      _zz_fwdGap2Data_4 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_122) begin
      _zz_fwdGap2Data_4 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_123) begin
      _zz_fwdGap2Data_4 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_124) begin
      _zz_fwdGap2Data_4 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_125) begin
      _zz_fwdGap2Data_4 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_126) begin
      _zz_fwdGap2Data_4 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_127) begin
      _zz_fwdGap2Data_4 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_128) begin
      _zz_fwdGap2Data_4 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_129) begin
      _zz_fwdGap2Data_4 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_130) begin
      _zz_fwdGap2Data_4 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_131) begin
      _zz_fwdGap2Data_4 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_132) begin
      _zz_fwdGap2Data_4 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_133) begin
      _zz_fwdGap2Data_4 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_134) begin
      _zz_fwdGap2Data_4 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_135) begin
      _zz_fwdGap2Data_4 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_136) begin
      _zz_fwdGap2Data_4 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_137) begin
      _zz_fwdGap2Data_4 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_138) begin
      _zz_fwdGap2Data_4 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_139) begin
      _zz_fwdGap2Data_4 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_112 = ((io_writeEn_0 && io_scalarReadEn_4) && (io_writeAddr_0 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_113 = ((io_writeEn_1 && io_scalarReadEn_4) && (io_writeAddr_1 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_114 = ((io_writeEn_2 && io_scalarReadEn_4) && (io_writeAddr_2 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_115 = ((io_writeEn_3 && io_scalarReadEn_4) && (io_writeAddr_3 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_116 = ((io_writeEn_4 && io_scalarReadEn_4) && (io_writeAddr_4 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_117 = ((io_writeEn_5 && io_scalarReadEn_4) && (io_writeAddr_5 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_118 = ((io_writeEn_6 && io_scalarReadEn_4) && (io_writeAddr_6 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_119 = ((io_writeEn_7 && io_scalarReadEn_4) && (io_writeAddr_7 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_120 = ((io_writeEn_8 && io_scalarReadEn_4) && (io_writeAddr_8 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_121 = ((io_writeEn_9 && io_scalarReadEn_4) && (io_writeAddr_9 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_122 = ((io_writeEn_10 && io_scalarReadEn_4) && (io_writeAddr_10 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_123 = ((io_writeEn_11 && io_scalarReadEn_4) && (io_writeAddr_11 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_124 = ((io_writeEn_12 && io_scalarReadEn_4) && (io_writeAddr_12 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_125 = ((io_writeEn_13 && io_scalarReadEn_4) && (io_writeAddr_13 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_126 = ((io_writeEn_14 && io_scalarReadEn_4) && (io_writeAddr_14 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_127 = ((io_writeEn_15 && io_scalarReadEn_4) && (io_writeAddr_15 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_128 = ((io_writeEn_16 && io_scalarReadEn_4) && (io_writeAddr_16 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_129 = ((io_writeEn_17 && io_scalarReadEn_4) && (io_writeAddr_17 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_130 = ((io_writeEn_18 && io_scalarReadEn_4) && (io_writeAddr_18 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_131 = ((io_writeEn_19 && io_scalarReadEn_4) && (io_writeAddr_19 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_132 = ((io_writeEn_20 && io_scalarReadEn_4) && (io_writeAddr_20 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_133 = ((io_writeEn_21 && io_scalarReadEn_4) && (io_writeAddr_21 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_134 = ((io_writeEn_22 && io_scalarReadEn_4) && (io_writeAddr_22 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_135 = ((io_writeEn_23 && io_scalarReadEn_4) && (io_writeAddr_23 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_136 = ((io_writeEn_24 && io_scalarReadEn_4) && (io_writeAddr_24 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_137 = ((io_writeEn_25 && io_scalarReadEn_4) && (io_writeAddr_25 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_138 = ((io_writeEn_26 && io_scalarReadEn_4) && (io_writeAddr_26 == io_scalarReadAddr_4));
  assign when_BankedScratchMemory_l360_139 = ((io_writeEn_27 && io_scalarReadEn_4) && (io_writeAddr_27 == io_scalarReadAddr_4));
  always @(*) begin
    _zz_fwdGap2Data_5 = 32'h0;
    if(when_BankedScratchMemory_l360_140) begin
      _zz_fwdGap2Data_5 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_141) begin
      _zz_fwdGap2Data_5 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_142) begin
      _zz_fwdGap2Data_5 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_143) begin
      _zz_fwdGap2Data_5 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_144) begin
      _zz_fwdGap2Data_5 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_145) begin
      _zz_fwdGap2Data_5 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_146) begin
      _zz_fwdGap2Data_5 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_147) begin
      _zz_fwdGap2Data_5 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_148) begin
      _zz_fwdGap2Data_5 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_149) begin
      _zz_fwdGap2Data_5 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_150) begin
      _zz_fwdGap2Data_5 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_151) begin
      _zz_fwdGap2Data_5 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_152) begin
      _zz_fwdGap2Data_5 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_153) begin
      _zz_fwdGap2Data_5 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_154) begin
      _zz_fwdGap2Data_5 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_155) begin
      _zz_fwdGap2Data_5 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_156) begin
      _zz_fwdGap2Data_5 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_157) begin
      _zz_fwdGap2Data_5 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_158) begin
      _zz_fwdGap2Data_5 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_159) begin
      _zz_fwdGap2Data_5 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_160) begin
      _zz_fwdGap2Data_5 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_161) begin
      _zz_fwdGap2Data_5 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_162) begin
      _zz_fwdGap2Data_5 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_163) begin
      _zz_fwdGap2Data_5 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_164) begin
      _zz_fwdGap2Data_5 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_165) begin
      _zz_fwdGap2Data_5 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_166) begin
      _zz_fwdGap2Data_5 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_167) begin
      _zz_fwdGap2Data_5 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_140 = ((io_writeEn_0 && io_scalarReadEn_5) && (io_writeAddr_0 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_141 = ((io_writeEn_1 && io_scalarReadEn_5) && (io_writeAddr_1 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_142 = ((io_writeEn_2 && io_scalarReadEn_5) && (io_writeAddr_2 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_143 = ((io_writeEn_3 && io_scalarReadEn_5) && (io_writeAddr_3 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_144 = ((io_writeEn_4 && io_scalarReadEn_5) && (io_writeAddr_4 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_145 = ((io_writeEn_5 && io_scalarReadEn_5) && (io_writeAddr_5 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_146 = ((io_writeEn_6 && io_scalarReadEn_5) && (io_writeAddr_6 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_147 = ((io_writeEn_7 && io_scalarReadEn_5) && (io_writeAddr_7 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_148 = ((io_writeEn_8 && io_scalarReadEn_5) && (io_writeAddr_8 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_149 = ((io_writeEn_9 && io_scalarReadEn_5) && (io_writeAddr_9 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_150 = ((io_writeEn_10 && io_scalarReadEn_5) && (io_writeAddr_10 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_151 = ((io_writeEn_11 && io_scalarReadEn_5) && (io_writeAddr_11 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_152 = ((io_writeEn_12 && io_scalarReadEn_5) && (io_writeAddr_12 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_153 = ((io_writeEn_13 && io_scalarReadEn_5) && (io_writeAddr_13 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_154 = ((io_writeEn_14 && io_scalarReadEn_5) && (io_writeAddr_14 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_155 = ((io_writeEn_15 && io_scalarReadEn_5) && (io_writeAddr_15 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_156 = ((io_writeEn_16 && io_scalarReadEn_5) && (io_writeAddr_16 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_157 = ((io_writeEn_17 && io_scalarReadEn_5) && (io_writeAddr_17 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_158 = ((io_writeEn_18 && io_scalarReadEn_5) && (io_writeAddr_18 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_159 = ((io_writeEn_19 && io_scalarReadEn_5) && (io_writeAddr_19 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_160 = ((io_writeEn_20 && io_scalarReadEn_5) && (io_writeAddr_20 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_161 = ((io_writeEn_21 && io_scalarReadEn_5) && (io_writeAddr_21 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_162 = ((io_writeEn_22 && io_scalarReadEn_5) && (io_writeAddr_22 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_163 = ((io_writeEn_23 && io_scalarReadEn_5) && (io_writeAddr_23 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_164 = ((io_writeEn_24 && io_scalarReadEn_5) && (io_writeAddr_24 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_165 = ((io_writeEn_25 && io_scalarReadEn_5) && (io_writeAddr_25 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_166 = ((io_writeEn_26 && io_scalarReadEn_5) && (io_writeAddr_26 == io_scalarReadAddr_5));
  assign when_BankedScratchMemory_l360_167 = ((io_writeEn_27 && io_scalarReadEn_5) && (io_writeAddr_27 == io_scalarReadAddr_5));
  always @(*) begin
    _zz_fwdGap2Data_6 = 32'h0;
    if(when_BankedScratchMemory_l360_168) begin
      _zz_fwdGap2Data_6 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_169) begin
      _zz_fwdGap2Data_6 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_170) begin
      _zz_fwdGap2Data_6 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_171) begin
      _zz_fwdGap2Data_6 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_172) begin
      _zz_fwdGap2Data_6 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_173) begin
      _zz_fwdGap2Data_6 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_174) begin
      _zz_fwdGap2Data_6 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_175) begin
      _zz_fwdGap2Data_6 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_176) begin
      _zz_fwdGap2Data_6 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_177) begin
      _zz_fwdGap2Data_6 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_178) begin
      _zz_fwdGap2Data_6 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_179) begin
      _zz_fwdGap2Data_6 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_180) begin
      _zz_fwdGap2Data_6 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_181) begin
      _zz_fwdGap2Data_6 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_182) begin
      _zz_fwdGap2Data_6 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_183) begin
      _zz_fwdGap2Data_6 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_184) begin
      _zz_fwdGap2Data_6 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_185) begin
      _zz_fwdGap2Data_6 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_186) begin
      _zz_fwdGap2Data_6 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_187) begin
      _zz_fwdGap2Data_6 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_188) begin
      _zz_fwdGap2Data_6 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_189) begin
      _zz_fwdGap2Data_6 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_190) begin
      _zz_fwdGap2Data_6 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_191) begin
      _zz_fwdGap2Data_6 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_192) begin
      _zz_fwdGap2Data_6 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_193) begin
      _zz_fwdGap2Data_6 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_194) begin
      _zz_fwdGap2Data_6 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_195) begin
      _zz_fwdGap2Data_6 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_168 = ((io_writeEn_0 && io_scalarReadEn_6) && (io_writeAddr_0 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_169 = ((io_writeEn_1 && io_scalarReadEn_6) && (io_writeAddr_1 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_170 = ((io_writeEn_2 && io_scalarReadEn_6) && (io_writeAddr_2 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_171 = ((io_writeEn_3 && io_scalarReadEn_6) && (io_writeAddr_3 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_172 = ((io_writeEn_4 && io_scalarReadEn_6) && (io_writeAddr_4 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_173 = ((io_writeEn_5 && io_scalarReadEn_6) && (io_writeAddr_5 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_174 = ((io_writeEn_6 && io_scalarReadEn_6) && (io_writeAddr_6 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_175 = ((io_writeEn_7 && io_scalarReadEn_6) && (io_writeAddr_7 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_176 = ((io_writeEn_8 && io_scalarReadEn_6) && (io_writeAddr_8 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_177 = ((io_writeEn_9 && io_scalarReadEn_6) && (io_writeAddr_9 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_178 = ((io_writeEn_10 && io_scalarReadEn_6) && (io_writeAddr_10 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_179 = ((io_writeEn_11 && io_scalarReadEn_6) && (io_writeAddr_11 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_180 = ((io_writeEn_12 && io_scalarReadEn_6) && (io_writeAddr_12 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_181 = ((io_writeEn_13 && io_scalarReadEn_6) && (io_writeAddr_13 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_182 = ((io_writeEn_14 && io_scalarReadEn_6) && (io_writeAddr_14 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_183 = ((io_writeEn_15 && io_scalarReadEn_6) && (io_writeAddr_15 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_184 = ((io_writeEn_16 && io_scalarReadEn_6) && (io_writeAddr_16 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_185 = ((io_writeEn_17 && io_scalarReadEn_6) && (io_writeAddr_17 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_186 = ((io_writeEn_18 && io_scalarReadEn_6) && (io_writeAddr_18 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_187 = ((io_writeEn_19 && io_scalarReadEn_6) && (io_writeAddr_19 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_188 = ((io_writeEn_20 && io_scalarReadEn_6) && (io_writeAddr_20 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_189 = ((io_writeEn_21 && io_scalarReadEn_6) && (io_writeAddr_21 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_190 = ((io_writeEn_22 && io_scalarReadEn_6) && (io_writeAddr_22 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_191 = ((io_writeEn_23 && io_scalarReadEn_6) && (io_writeAddr_23 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_192 = ((io_writeEn_24 && io_scalarReadEn_6) && (io_writeAddr_24 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_193 = ((io_writeEn_25 && io_scalarReadEn_6) && (io_writeAddr_25 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_194 = ((io_writeEn_26 && io_scalarReadEn_6) && (io_writeAddr_26 == io_scalarReadAddr_6));
  assign when_BankedScratchMemory_l360_195 = ((io_writeEn_27 && io_scalarReadEn_6) && (io_writeAddr_27 == io_scalarReadAddr_6));
  always @(*) begin
    _zz_fwdGap2Data_7 = 32'h0;
    if(when_BankedScratchMemory_l360_196) begin
      _zz_fwdGap2Data_7 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_197) begin
      _zz_fwdGap2Data_7 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_198) begin
      _zz_fwdGap2Data_7 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_199) begin
      _zz_fwdGap2Data_7 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_200) begin
      _zz_fwdGap2Data_7 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_201) begin
      _zz_fwdGap2Data_7 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_202) begin
      _zz_fwdGap2Data_7 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_203) begin
      _zz_fwdGap2Data_7 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_204) begin
      _zz_fwdGap2Data_7 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_205) begin
      _zz_fwdGap2Data_7 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_206) begin
      _zz_fwdGap2Data_7 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_207) begin
      _zz_fwdGap2Data_7 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_208) begin
      _zz_fwdGap2Data_7 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_209) begin
      _zz_fwdGap2Data_7 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_210) begin
      _zz_fwdGap2Data_7 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_211) begin
      _zz_fwdGap2Data_7 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_212) begin
      _zz_fwdGap2Data_7 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_213) begin
      _zz_fwdGap2Data_7 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_214) begin
      _zz_fwdGap2Data_7 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_215) begin
      _zz_fwdGap2Data_7 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_216) begin
      _zz_fwdGap2Data_7 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_217) begin
      _zz_fwdGap2Data_7 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_218) begin
      _zz_fwdGap2Data_7 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_219) begin
      _zz_fwdGap2Data_7 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_220) begin
      _zz_fwdGap2Data_7 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_221) begin
      _zz_fwdGap2Data_7 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_222) begin
      _zz_fwdGap2Data_7 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_223) begin
      _zz_fwdGap2Data_7 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_196 = ((io_writeEn_0 && io_scalarReadEn_7) && (io_writeAddr_0 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_197 = ((io_writeEn_1 && io_scalarReadEn_7) && (io_writeAddr_1 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_198 = ((io_writeEn_2 && io_scalarReadEn_7) && (io_writeAddr_2 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_199 = ((io_writeEn_3 && io_scalarReadEn_7) && (io_writeAddr_3 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_200 = ((io_writeEn_4 && io_scalarReadEn_7) && (io_writeAddr_4 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_201 = ((io_writeEn_5 && io_scalarReadEn_7) && (io_writeAddr_5 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_202 = ((io_writeEn_6 && io_scalarReadEn_7) && (io_writeAddr_6 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_203 = ((io_writeEn_7 && io_scalarReadEn_7) && (io_writeAddr_7 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_204 = ((io_writeEn_8 && io_scalarReadEn_7) && (io_writeAddr_8 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_205 = ((io_writeEn_9 && io_scalarReadEn_7) && (io_writeAddr_9 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_206 = ((io_writeEn_10 && io_scalarReadEn_7) && (io_writeAddr_10 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_207 = ((io_writeEn_11 && io_scalarReadEn_7) && (io_writeAddr_11 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_208 = ((io_writeEn_12 && io_scalarReadEn_7) && (io_writeAddr_12 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_209 = ((io_writeEn_13 && io_scalarReadEn_7) && (io_writeAddr_13 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_210 = ((io_writeEn_14 && io_scalarReadEn_7) && (io_writeAddr_14 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_211 = ((io_writeEn_15 && io_scalarReadEn_7) && (io_writeAddr_15 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_212 = ((io_writeEn_16 && io_scalarReadEn_7) && (io_writeAddr_16 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_213 = ((io_writeEn_17 && io_scalarReadEn_7) && (io_writeAddr_17 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_214 = ((io_writeEn_18 && io_scalarReadEn_7) && (io_writeAddr_18 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_215 = ((io_writeEn_19 && io_scalarReadEn_7) && (io_writeAddr_19 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_216 = ((io_writeEn_20 && io_scalarReadEn_7) && (io_writeAddr_20 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_217 = ((io_writeEn_21 && io_scalarReadEn_7) && (io_writeAddr_21 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_218 = ((io_writeEn_22 && io_scalarReadEn_7) && (io_writeAddr_22 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_219 = ((io_writeEn_23 && io_scalarReadEn_7) && (io_writeAddr_23 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_220 = ((io_writeEn_24 && io_scalarReadEn_7) && (io_writeAddr_24 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_221 = ((io_writeEn_25 && io_scalarReadEn_7) && (io_writeAddr_25 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_222 = ((io_writeEn_26 && io_scalarReadEn_7) && (io_writeAddr_26 == io_scalarReadAddr_7));
  assign when_BankedScratchMemory_l360_223 = ((io_writeEn_27 && io_scalarReadEn_7) && (io_writeAddr_27 == io_scalarReadAddr_7));
  always @(*) begin
    _zz_fwdGap2Data_8 = 32'h0;
    if(when_BankedScratchMemory_l360_224) begin
      _zz_fwdGap2Data_8 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l360_225) begin
      _zz_fwdGap2Data_8 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l360_226) begin
      _zz_fwdGap2Data_8 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l360_227) begin
      _zz_fwdGap2Data_8 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l360_228) begin
      _zz_fwdGap2Data_8 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l360_229) begin
      _zz_fwdGap2Data_8 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l360_230) begin
      _zz_fwdGap2Data_8 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l360_231) begin
      _zz_fwdGap2Data_8 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l360_232) begin
      _zz_fwdGap2Data_8 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l360_233) begin
      _zz_fwdGap2Data_8 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l360_234) begin
      _zz_fwdGap2Data_8 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l360_235) begin
      _zz_fwdGap2Data_8 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l360_236) begin
      _zz_fwdGap2Data_8 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l360_237) begin
      _zz_fwdGap2Data_8 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l360_238) begin
      _zz_fwdGap2Data_8 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l360_239) begin
      _zz_fwdGap2Data_8 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l360_240) begin
      _zz_fwdGap2Data_8 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l360_241) begin
      _zz_fwdGap2Data_8 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l360_242) begin
      _zz_fwdGap2Data_8 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l360_243) begin
      _zz_fwdGap2Data_8 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l360_244) begin
      _zz_fwdGap2Data_8 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l360_245) begin
      _zz_fwdGap2Data_8 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l360_246) begin
      _zz_fwdGap2Data_8 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l360_247) begin
      _zz_fwdGap2Data_8 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l360_248) begin
      _zz_fwdGap2Data_8 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l360_249) begin
      _zz_fwdGap2Data_8 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l360_250) begin
      _zz_fwdGap2Data_8 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l360_251) begin
      _zz_fwdGap2Data_8 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l360_224 = ((io_writeEn_0 && io_scalarReadEn_8) && (io_writeAddr_0 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_225 = ((io_writeEn_1 && io_scalarReadEn_8) && (io_writeAddr_1 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_226 = ((io_writeEn_2 && io_scalarReadEn_8) && (io_writeAddr_2 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_227 = ((io_writeEn_3 && io_scalarReadEn_8) && (io_writeAddr_3 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_228 = ((io_writeEn_4 && io_scalarReadEn_8) && (io_writeAddr_4 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_229 = ((io_writeEn_5 && io_scalarReadEn_8) && (io_writeAddr_5 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_230 = ((io_writeEn_6 && io_scalarReadEn_8) && (io_writeAddr_6 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_231 = ((io_writeEn_7 && io_scalarReadEn_8) && (io_writeAddr_7 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_232 = ((io_writeEn_8 && io_scalarReadEn_8) && (io_writeAddr_8 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_233 = ((io_writeEn_9 && io_scalarReadEn_8) && (io_writeAddr_9 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_234 = ((io_writeEn_10 && io_scalarReadEn_8) && (io_writeAddr_10 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_235 = ((io_writeEn_11 && io_scalarReadEn_8) && (io_writeAddr_11 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_236 = ((io_writeEn_12 && io_scalarReadEn_8) && (io_writeAddr_12 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_237 = ((io_writeEn_13 && io_scalarReadEn_8) && (io_writeAddr_13 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_238 = ((io_writeEn_14 && io_scalarReadEn_8) && (io_writeAddr_14 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_239 = ((io_writeEn_15 && io_scalarReadEn_8) && (io_writeAddr_15 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_240 = ((io_writeEn_16 && io_scalarReadEn_8) && (io_writeAddr_16 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_241 = ((io_writeEn_17 && io_scalarReadEn_8) && (io_writeAddr_17 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_242 = ((io_writeEn_18 && io_scalarReadEn_8) && (io_writeAddr_18 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_243 = ((io_writeEn_19 && io_scalarReadEn_8) && (io_writeAddr_19 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_244 = ((io_writeEn_20 && io_scalarReadEn_8) && (io_writeAddr_20 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_245 = ((io_writeEn_21 && io_scalarReadEn_8) && (io_writeAddr_21 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_246 = ((io_writeEn_22 && io_scalarReadEn_8) && (io_writeAddr_22 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_247 = ((io_writeEn_23 && io_scalarReadEn_8) && (io_writeAddr_23 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_248 = ((io_writeEn_24 && io_scalarReadEn_8) && (io_writeAddr_24 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_249 = ((io_writeEn_25 && io_scalarReadEn_8) && (io_writeAddr_25 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_250 = ((io_writeEn_26 && io_scalarReadEn_8) && (io_writeAddr_26 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l360_251 = ((io_writeEn_27 && io_scalarReadEn_8) && (io_writeAddr_27 == io_scalarReadAddr_8));
  assign when_BankedScratchMemory_l390 = ((io_writeEn_0 && prevScalarReadEn_0) && (io_writeAddr_0 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_1 = ((io_writeEn_1 && prevScalarReadEn_0) && (io_writeAddr_1 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_2 = ((io_writeEn_2 && prevScalarReadEn_0) && (io_writeAddr_2 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_3 = ((io_writeEn_3 && prevScalarReadEn_0) && (io_writeAddr_3 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_4 = ((io_writeEn_4 && prevScalarReadEn_0) && (io_writeAddr_4 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_5 = ((io_writeEn_5 && prevScalarReadEn_0) && (io_writeAddr_5 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_6 = ((io_writeEn_6 && prevScalarReadEn_0) && (io_writeAddr_6 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_7 = ((io_writeEn_7 && prevScalarReadEn_0) && (io_writeAddr_7 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_8 = ((io_writeEn_8 && prevScalarReadEn_0) && (io_writeAddr_8 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_9 = ((io_writeEn_9 && prevScalarReadEn_0) && (io_writeAddr_9 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_10 = ((io_writeEn_10 && prevScalarReadEn_0) && (io_writeAddr_10 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_11 = ((io_writeEn_11 && prevScalarReadEn_0) && (io_writeAddr_11 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_12 = ((io_writeEn_12 && prevScalarReadEn_0) && (io_writeAddr_12 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_13 = ((io_writeEn_13 && prevScalarReadEn_0) && (io_writeAddr_13 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_14 = ((io_writeEn_14 && prevScalarReadEn_0) && (io_writeAddr_14 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_15 = ((io_writeEn_15 && prevScalarReadEn_0) && (io_writeAddr_15 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_16 = ((io_writeEn_16 && prevScalarReadEn_0) && (io_writeAddr_16 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_17 = ((io_writeEn_17 && prevScalarReadEn_0) && (io_writeAddr_17 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_18 = ((io_writeEn_18 && prevScalarReadEn_0) && (io_writeAddr_18 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_19 = ((io_writeEn_19 && prevScalarReadEn_0) && (io_writeAddr_19 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_20 = ((io_writeEn_20 && prevScalarReadEn_0) && (io_writeAddr_20 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_21 = ((io_writeEn_21 && prevScalarReadEn_0) && (io_writeAddr_21 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_22 = ((io_writeEn_22 && prevScalarReadEn_0) && (io_writeAddr_22 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_23 = ((io_writeEn_23 && prevScalarReadEn_0) && (io_writeAddr_23 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_24 = ((io_writeEn_24 && prevScalarReadEn_0) && (io_writeAddr_24 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_25 = ((io_writeEn_25 && prevScalarReadEn_0) && (io_writeAddr_25 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_26 = ((io_writeEn_26 && prevScalarReadEn_0) && (io_writeAddr_26 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_27 = ((io_writeEn_27 && prevScalarReadEn_0) && (io_writeAddr_27 == prevScalarReadAddr_0));
  assign when_BankedScratchMemory_l390_28 = ((io_writeEn_0 && prevScalarReadEn_1) && (io_writeAddr_0 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_29 = ((io_writeEn_1 && prevScalarReadEn_1) && (io_writeAddr_1 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_30 = ((io_writeEn_2 && prevScalarReadEn_1) && (io_writeAddr_2 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_31 = ((io_writeEn_3 && prevScalarReadEn_1) && (io_writeAddr_3 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_32 = ((io_writeEn_4 && prevScalarReadEn_1) && (io_writeAddr_4 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_33 = ((io_writeEn_5 && prevScalarReadEn_1) && (io_writeAddr_5 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_34 = ((io_writeEn_6 && prevScalarReadEn_1) && (io_writeAddr_6 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_35 = ((io_writeEn_7 && prevScalarReadEn_1) && (io_writeAddr_7 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_36 = ((io_writeEn_8 && prevScalarReadEn_1) && (io_writeAddr_8 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_37 = ((io_writeEn_9 && prevScalarReadEn_1) && (io_writeAddr_9 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_38 = ((io_writeEn_10 && prevScalarReadEn_1) && (io_writeAddr_10 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_39 = ((io_writeEn_11 && prevScalarReadEn_1) && (io_writeAddr_11 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_40 = ((io_writeEn_12 && prevScalarReadEn_1) && (io_writeAddr_12 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_41 = ((io_writeEn_13 && prevScalarReadEn_1) && (io_writeAddr_13 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_42 = ((io_writeEn_14 && prevScalarReadEn_1) && (io_writeAddr_14 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_43 = ((io_writeEn_15 && prevScalarReadEn_1) && (io_writeAddr_15 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_44 = ((io_writeEn_16 && prevScalarReadEn_1) && (io_writeAddr_16 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_45 = ((io_writeEn_17 && prevScalarReadEn_1) && (io_writeAddr_17 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_46 = ((io_writeEn_18 && prevScalarReadEn_1) && (io_writeAddr_18 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_47 = ((io_writeEn_19 && prevScalarReadEn_1) && (io_writeAddr_19 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_48 = ((io_writeEn_20 && prevScalarReadEn_1) && (io_writeAddr_20 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_49 = ((io_writeEn_21 && prevScalarReadEn_1) && (io_writeAddr_21 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_50 = ((io_writeEn_22 && prevScalarReadEn_1) && (io_writeAddr_22 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_51 = ((io_writeEn_23 && prevScalarReadEn_1) && (io_writeAddr_23 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_52 = ((io_writeEn_24 && prevScalarReadEn_1) && (io_writeAddr_24 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_53 = ((io_writeEn_25 && prevScalarReadEn_1) && (io_writeAddr_25 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_54 = ((io_writeEn_26 && prevScalarReadEn_1) && (io_writeAddr_26 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_55 = ((io_writeEn_27 && prevScalarReadEn_1) && (io_writeAddr_27 == prevScalarReadAddr_1));
  assign when_BankedScratchMemory_l390_56 = ((io_writeEn_0 && prevScalarReadEn_2) && (io_writeAddr_0 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_57 = ((io_writeEn_1 && prevScalarReadEn_2) && (io_writeAddr_1 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_58 = ((io_writeEn_2 && prevScalarReadEn_2) && (io_writeAddr_2 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_59 = ((io_writeEn_3 && prevScalarReadEn_2) && (io_writeAddr_3 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_60 = ((io_writeEn_4 && prevScalarReadEn_2) && (io_writeAddr_4 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_61 = ((io_writeEn_5 && prevScalarReadEn_2) && (io_writeAddr_5 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_62 = ((io_writeEn_6 && prevScalarReadEn_2) && (io_writeAddr_6 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_63 = ((io_writeEn_7 && prevScalarReadEn_2) && (io_writeAddr_7 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_64 = ((io_writeEn_8 && prevScalarReadEn_2) && (io_writeAddr_8 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_65 = ((io_writeEn_9 && prevScalarReadEn_2) && (io_writeAddr_9 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_66 = ((io_writeEn_10 && prevScalarReadEn_2) && (io_writeAddr_10 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_67 = ((io_writeEn_11 && prevScalarReadEn_2) && (io_writeAddr_11 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_68 = ((io_writeEn_12 && prevScalarReadEn_2) && (io_writeAddr_12 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_69 = ((io_writeEn_13 && prevScalarReadEn_2) && (io_writeAddr_13 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_70 = ((io_writeEn_14 && prevScalarReadEn_2) && (io_writeAddr_14 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_71 = ((io_writeEn_15 && prevScalarReadEn_2) && (io_writeAddr_15 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_72 = ((io_writeEn_16 && prevScalarReadEn_2) && (io_writeAddr_16 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_73 = ((io_writeEn_17 && prevScalarReadEn_2) && (io_writeAddr_17 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_74 = ((io_writeEn_18 && prevScalarReadEn_2) && (io_writeAddr_18 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_75 = ((io_writeEn_19 && prevScalarReadEn_2) && (io_writeAddr_19 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_76 = ((io_writeEn_20 && prevScalarReadEn_2) && (io_writeAddr_20 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_77 = ((io_writeEn_21 && prevScalarReadEn_2) && (io_writeAddr_21 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_78 = ((io_writeEn_22 && prevScalarReadEn_2) && (io_writeAddr_22 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_79 = ((io_writeEn_23 && prevScalarReadEn_2) && (io_writeAddr_23 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_80 = ((io_writeEn_24 && prevScalarReadEn_2) && (io_writeAddr_24 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_81 = ((io_writeEn_25 && prevScalarReadEn_2) && (io_writeAddr_25 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_82 = ((io_writeEn_26 && prevScalarReadEn_2) && (io_writeAddr_26 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_83 = ((io_writeEn_27 && prevScalarReadEn_2) && (io_writeAddr_27 == prevScalarReadAddr_2));
  assign when_BankedScratchMemory_l390_84 = ((io_writeEn_0 && prevScalarReadEn_3) && (io_writeAddr_0 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_85 = ((io_writeEn_1 && prevScalarReadEn_3) && (io_writeAddr_1 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_86 = ((io_writeEn_2 && prevScalarReadEn_3) && (io_writeAddr_2 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_87 = ((io_writeEn_3 && prevScalarReadEn_3) && (io_writeAddr_3 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_88 = ((io_writeEn_4 && prevScalarReadEn_3) && (io_writeAddr_4 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_89 = ((io_writeEn_5 && prevScalarReadEn_3) && (io_writeAddr_5 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_90 = ((io_writeEn_6 && prevScalarReadEn_3) && (io_writeAddr_6 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_91 = ((io_writeEn_7 && prevScalarReadEn_3) && (io_writeAddr_7 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_92 = ((io_writeEn_8 && prevScalarReadEn_3) && (io_writeAddr_8 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_93 = ((io_writeEn_9 && prevScalarReadEn_3) && (io_writeAddr_9 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_94 = ((io_writeEn_10 && prevScalarReadEn_3) && (io_writeAddr_10 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_95 = ((io_writeEn_11 && prevScalarReadEn_3) && (io_writeAddr_11 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_96 = ((io_writeEn_12 && prevScalarReadEn_3) && (io_writeAddr_12 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_97 = ((io_writeEn_13 && prevScalarReadEn_3) && (io_writeAddr_13 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_98 = ((io_writeEn_14 && prevScalarReadEn_3) && (io_writeAddr_14 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_99 = ((io_writeEn_15 && prevScalarReadEn_3) && (io_writeAddr_15 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_100 = ((io_writeEn_16 && prevScalarReadEn_3) && (io_writeAddr_16 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_101 = ((io_writeEn_17 && prevScalarReadEn_3) && (io_writeAddr_17 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_102 = ((io_writeEn_18 && prevScalarReadEn_3) && (io_writeAddr_18 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_103 = ((io_writeEn_19 && prevScalarReadEn_3) && (io_writeAddr_19 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_104 = ((io_writeEn_20 && prevScalarReadEn_3) && (io_writeAddr_20 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_105 = ((io_writeEn_21 && prevScalarReadEn_3) && (io_writeAddr_21 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_106 = ((io_writeEn_22 && prevScalarReadEn_3) && (io_writeAddr_22 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_107 = ((io_writeEn_23 && prevScalarReadEn_3) && (io_writeAddr_23 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_108 = ((io_writeEn_24 && prevScalarReadEn_3) && (io_writeAddr_24 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_109 = ((io_writeEn_25 && prevScalarReadEn_3) && (io_writeAddr_25 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_110 = ((io_writeEn_26 && prevScalarReadEn_3) && (io_writeAddr_26 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_111 = ((io_writeEn_27 && prevScalarReadEn_3) && (io_writeAddr_27 == prevScalarReadAddr_3));
  assign when_BankedScratchMemory_l390_112 = ((io_writeEn_0 && prevScalarReadEn_4) && (io_writeAddr_0 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_113 = ((io_writeEn_1 && prevScalarReadEn_4) && (io_writeAddr_1 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_114 = ((io_writeEn_2 && prevScalarReadEn_4) && (io_writeAddr_2 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_115 = ((io_writeEn_3 && prevScalarReadEn_4) && (io_writeAddr_3 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_116 = ((io_writeEn_4 && prevScalarReadEn_4) && (io_writeAddr_4 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_117 = ((io_writeEn_5 && prevScalarReadEn_4) && (io_writeAddr_5 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_118 = ((io_writeEn_6 && prevScalarReadEn_4) && (io_writeAddr_6 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_119 = ((io_writeEn_7 && prevScalarReadEn_4) && (io_writeAddr_7 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_120 = ((io_writeEn_8 && prevScalarReadEn_4) && (io_writeAddr_8 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_121 = ((io_writeEn_9 && prevScalarReadEn_4) && (io_writeAddr_9 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_122 = ((io_writeEn_10 && prevScalarReadEn_4) && (io_writeAddr_10 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_123 = ((io_writeEn_11 && prevScalarReadEn_4) && (io_writeAddr_11 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_124 = ((io_writeEn_12 && prevScalarReadEn_4) && (io_writeAddr_12 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_125 = ((io_writeEn_13 && prevScalarReadEn_4) && (io_writeAddr_13 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_126 = ((io_writeEn_14 && prevScalarReadEn_4) && (io_writeAddr_14 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_127 = ((io_writeEn_15 && prevScalarReadEn_4) && (io_writeAddr_15 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_128 = ((io_writeEn_16 && prevScalarReadEn_4) && (io_writeAddr_16 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_129 = ((io_writeEn_17 && prevScalarReadEn_4) && (io_writeAddr_17 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_130 = ((io_writeEn_18 && prevScalarReadEn_4) && (io_writeAddr_18 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_131 = ((io_writeEn_19 && prevScalarReadEn_4) && (io_writeAddr_19 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_132 = ((io_writeEn_20 && prevScalarReadEn_4) && (io_writeAddr_20 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_133 = ((io_writeEn_21 && prevScalarReadEn_4) && (io_writeAddr_21 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_134 = ((io_writeEn_22 && prevScalarReadEn_4) && (io_writeAddr_22 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_135 = ((io_writeEn_23 && prevScalarReadEn_4) && (io_writeAddr_23 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_136 = ((io_writeEn_24 && prevScalarReadEn_4) && (io_writeAddr_24 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_137 = ((io_writeEn_25 && prevScalarReadEn_4) && (io_writeAddr_25 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_138 = ((io_writeEn_26 && prevScalarReadEn_4) && (io_writeAddr_26 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_139 = ((io_writeEn_27 && prevScalarReadEn_4) && (io_writeAddr_27 == prevScalarReadAddr_4));
  assign when_BankedScratchMemory_l390_140 = ((io_writeEn_0 && prevScalarReadEn_5) && (io_writeAddr_0 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_141 = ((io_writeEn_1 && prevScalarReadEn_5) && (io_writeAddr_1 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_142 = ((io_writeEn_2 && prevScalarReadEn_5) && (io_writeAddr_2 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_143 = ((io_writeEn_3 && prevScalarReadEn_5) && (io_writeAddr_3 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_144 = ((io_writeEn_4 && prevScalarReadEn_5) && (io_writeAddr_4 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_145 = ((io_writeEn_5 && prevScalarReadEn_5) && (io_writeAddr_5 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_146 = ((io_writeEn_6 && prevScalarReadEn_5) && (io_writeAddr_6 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_147 = ((io_writeEn_7 && prevScalarReadEn_5) && (io_writeAddr_7 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_148 = ((io_writeEn_8 && prevScalarReadEn_5) && (io_writeAddr_8 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_149 = ((io_writeEn_9 && prevScalarReadEn_5) && (io_writeAddr_9 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_150 = ((io_writeEn_10 && prevScalarReadEn_5) && (io_writeAddr_10 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_151 = ((io_writeEn_11 && prevScalarReadEn_5) && (io_writeAddr_11 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_152 = ((io_writeEn_12 && prevScalarReadEn_5) && (io_writeAddr_12 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_153 = ((io_writeEn_13 && prevScalarReadEn_5) && (io_writeAddr_13 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_154 = ((io_writeEn_14 && prevScalarReadEn_5) && (io_writeAddr_14 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_155 = ((io_writeEn_15 && prevScalarReadEn_5) && (io_writeAddr_15 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_156 = ((io_writeEn_16 && prevScalarReadEn_5) && (io_writeAddr_16 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_157 = ((io_writeEn_17 && prevScalarReadEn_5) && (io_writeAddr_17 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_158 = ((io_writeEn_18 && prevScalarReadEn_5) && (io_writeAddr_18 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_159 = ((io_writeEn_19 && prevScalarReadEn_5) && (io_writeAddr_19 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_160 = ((io_writeEn_20 && prevScalarReadEn_5) && (io_writeAddr_20 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_161 = ((io_writeEn_21 && prevScalarReadEn_5) && (io_writeAddr_21 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_162 = ((io_writeEn_22 && prevScalarReadEn_5) && (io_writeAddr_22 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_163 = ((io_writeEn_23 && prevScalarReadEn_5) && (io_writeAddr_23 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_164 = ((io_writeEn_24 && prevScalarReadEn_5) && (io_writeAddr_24 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_165 = ((io_writeEn_25 && prevScalarReadEn_5) && (io_writeAddr_25 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_166 = ((io_writeEn_26 && prevScalarReadEn_5) && (io_writeAddr_26 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_167 = ((io_writeEn_27 && prevScalarReadEn_5) && (io_writeAddr_27 == prevScalarReadAddr_5));
  assign when_BankedScratchMemory_l390_168 = ((io_writeEn_0 && prevScalarReadEn_6) && (io_writeAddr_0 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_169 = ((io_writeEn_1 && prevScalarReadEn_6) && (io_writeAddr_1 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_170 = ((io_writeEn_2 && prevScalarReadEn_6) && (io_writeAddr_2 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_171 = ((io_writeEn_3 && prevScalarReadEn_6) && (io_writeAddr_3 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_172 = ((io_writeEn_4 && prevScalarReadEn_6) && (io_writeAddr_4 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_173 = ((io_writeEn_5 && prevScalarReadEn_6) && (io_writeAddr_5 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_174 = ((io_writeEn_6 && prevScalarReadEn_6) && (io_writeAddr_6 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_175 = ((io_writeEn_7 && prevScalarReadEn_6) && (io_writeAddr_7 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_176 = ((io_writeEn_8 && prevScalarReadEn_6) && (io_writeAddr_8 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_177 = ((io_writeEn_9 && prevScalarReadEn_6) && (io_writeAddr_9 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_178 = ((io_writeEn_10 && prevScalarReadEn_6) && (io_writeAddr_10 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_179 = ((io_writeEn_11 && prevScalarReadEn_6) && (io_writeAddr_11 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_180 = ((io_writeEn_12 && prevScalarReadEn_6) && (io_writeAddr_12 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_181 = ((io_writeEn_13 && prevScalarReadEn_6) && (io_writeAddr_13 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_182 = ((io_writeEn_14 && prevScalarReadEn_6) && (io_writeAddr_14 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_183 = ((io_writeEn_15 && prevScalarReadEn_6) && (io_writeAddr_15 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_184 = ((io_writeEn_16 && prevScalarReadEn_6) && (io_writeAddr_16 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_185 = ((io_writeEn_17 && prevScalarReadEn_6) && (io_writeAddr_17 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_186 = ((io_writeEn_18 && prevScalarReadEn_6) && (io_writeAddr_18 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_187 = ((io_writeEn_19 && prevScalarReadEn_6) && (io_writeAddr_19 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_188 = ((io_writeEn_20 && prevScalarReadEn_6) && (io_writeAddr_20 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_189 = ((io_writeEn_21 && prevScalarReadEn_6) && (io_writeAddr_21 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_190 = ((io_writeEn_22 && prevScalarReadEn_6) && (io_writeAddr_22 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_191 = ((io_writeEn_23 && prevScalarReadEn_6) && (io_writeAddr_23 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_192 = ((io_writeEn_24 && prevScalarReadEn_6) && (io_writeAddr_24 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_193 = ((io_writeEn_25 && prevScalarReadEn_6) && (io_writeAddr_25 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_194 = ((io_writeEn_26 && prevScalarReadEn_6) && (io_writeAddr_26 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_195 = ((io_writeEn_27 && prevScalarReadEn_6) && (io_writeAddr_27 == prevScalarReadAddr_6));
  assign when_BankedScratchMemory_l390_196 = ((io_writeEn_0 && prevScalarReadEn_7) && (io_writeAddr_0 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_197 = ((io_writeEn_1 && prevScalarReadEn_7) && (io_writeAddr_1 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_198 = ((io_writeEn_2 && prevScalarReadEn_7) && (io_writeAddr_2 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_199 = ((io_writeEn_3 && prevScalarReadEn_7) && (io_writeAddr_3 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_200 = ((io_writeEn_4 && prevScalarReadEn_7) && (io_writeAddr_4 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_201 = ((io_writeEn_5 && prevScalarReadEn_7) && (io_writeAddr_5 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_202 = ((io_writeEn_6 && prevScalarReadEn_7) && (io_writeAddr_6 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_203 = ((io_writeEn_7 && prevScalarReadEn_7) && (io_writeAddr_7 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_204 = ((io_writeEn_8 && prevScalarReadEn_7) && (io_writeAddr_8 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_205 = ((io_writeEn_9 && prevScalarReadEn_7) && (io_writeAddr_9 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_206 = ((io_writeEn_10 && prevScalarReadEn_7) && (io_writeAddr_10 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_207 = ((io_writeEn_11 && prevScalarReadEn_7) && (io_writeAddr_11 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_208 = ((io_writeEn_12 && prevScalarReadEn_7) && (io_writeAddr_12 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_209 = ((io_writeEn_13 && prevScalarReadEn_7) && (io_writeAddr_13 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_210 = ((io_writeEn_14 && prevScalarReadEn_7) && (io_writeAddr_14 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_211 = ((io_writeEn_15 && prevScalarReadEn_7) && (io_writeAddr_15 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_212 = ((io_writeEn_16 && prevScalarReadEn_7) && (io_writeAddr_16 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_213 = ((io_writeEn_17 && prevScalarReadEn_7) && (io_writeAddr_17 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_214 = ((io_writeEn_18 && prevScalarReadEn_7) && (io_writeAddr_18 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_215 = ((io_writeEn_19 && prevScalarReadEn_7) && (io_writeAddr_19 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_216 = ((io_writeEn_20 && prevScalarReadEn_7) && (io_writeAddr_20 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_217 = ((io_writeEn_21 && prevScalarReadEn_7) && (io_writeAddr_21 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_218 = ((io_writeEn_22 && prevScalarReadEn_7) && (io_writeAddr_22 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_219 = ((io_writeEn_23 && prevScalarReadEn_7) && (io_writeAddr_23 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_220 = ((io_writeEn_24 && prevScalarReadEn_7) && (io_writeAddr_24 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_221 = ((io_writeEn_25 && prevScalarReadEn_7) && (io_writeAddr_25 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_222 = ((io_writeEn_26 && prevScalarReadEn_7) && (io_writeAddr_26 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_223 = ((io_writeEn_27 && prevScalarReadEn_7) && (io_writeAddr_27 == prevScalarReadAddr_7));
  assign when_BankedScratchMemory_l390_224 = ((io_writeEn_0 && prevScalarReadEn_8) && (io_writeAddr_0 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_225 = ((io_writeEn_1 && prevScalarReadEn_8) && (io_writeAddr_1 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_226 = ((io_writeEn_2 && prevScalarReadEn_8) && (io_writeAddr_2 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_227 = ((io_writeEn_3 && prevScalarReadEn_8) && (io_writeAddr_3 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_228 = ((io_writeEn_4 && prevScalarReadEn_8) && (io_writeAddr_4 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_229 = ((io_writeEn_5 && prevScalarReadEn_8) && (io_writeAddr_5 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_230 = ((io_writeEn_6 && prevScalarReadEn_8) && (io_writeAddr_6 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_231 = ((io_writeEn_7 && prevScalarReadEn_8) && (io_writeAddr_7 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_232 = ((io_writeEn_8 && prevScalarReadEn_8) && (io_writeAddr_8 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_233 = ((io_writeEn_9 && prevScalarReadEn_8) && (io_writeAddr_9 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_234 = ((io_writeEn_10 && prevScalarReadEn_8) && (io_writeAddr_10 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_235 = ((io_writeEn_11 && prevScalarReadEn_8) && (io_writeAddr_11 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_236 = ((io_writeEn_12 && prevScalarReadEn_8) && (io_writeAddr_12 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_237 = ((io_writeEn_13 && prevScalarReadEn_8) && (io_writeAddr_13 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_238 = ((io_writeEn_14 && prevScalarReadEn_8) && (io_writeAddr_14 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_239 = ((io_writeEn_15 && prevScalarReadEn_8) && (io_writeAddr_15 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_240 = ((io_writeEn_16 && prevScalarReadEn_8) && (io_writeAddr_16 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_241 = ((io_writeEn_17 && prevScalarReadEn_8) && (io_writeAddr_17 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_242 = ((io_writeEn_18 && prevScalarReadEn_8) && (io_writeAddr_18 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_243 = ((io_writeEn_19 && prevScalarReadEn_8) && (io_writeAddr_19 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_244 = ((io_writeEn_20 && prevScalarReadEn_8) && (io_writeAddr_20 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_245 = ((io_writeEn_21 && prevScalarReadEn_8) && (io_writeAddr_21 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_246 = ((io_writeEn_22 && prevScalarReadEn_8) && (io_writeAddr_22 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_247 = ((io_writeEn_23 && prevScalarReadEn_8) && (io_writeAddr_23 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_248 = ((io_writeEn_24 && prevScalarReadEn_8) && (io_writeAddr_24 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_249 = ((io_writeEn_25 && prevScalarReadEn_8) && (io_writeAddr_25 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_250 = ((io_writeEn_26 && prevScalarReadEn_8) && (io_writeAddr_26 == prevScalarReadAddr_8));
  assign when_BankedScratchMemory_l390_251 = ((io_writeEn_27 && prevScalarReadEn_8) && (io_writeAddr_27 == prevScalarReadAddr_8));
  always @(*) begin
    _zz_fwdValuGap2Data_0_0 = 32'h0;
    if(when_BankedScratchMemory_l412) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_1) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_2) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_3) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_4) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_5) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_6) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_7) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_8) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_9) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_10) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_11) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_12) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_13) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_14) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_15) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_16) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_17) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_18) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_19) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_20) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_21) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_22) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_23) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_24) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_25) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_26) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_27) begin
      _zz_fwdValuGap2Data_0_0 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412 = ((io_writeEn_0 && io_valuReadEn_0_0) && (io_writeAddr_0 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_1 = ((io_writeEn_1 && io_valuReadEn_0_0) && (io_writeAddr_1 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_2 = ((io_writeEn_2 && io_valuReadEn_0_0) && (io_writeAddr_2 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_3 = ((io_writeEn_3 && io_valuReadEn_0_0) && (io_writeAddr_3 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_4 = ((io_writeEn_4 && io_valuReadEn_0_0) && (io_writeAddr_4 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_5 = ((io_writeEn_5 && io_valuReadEn_0_0) && (io_writeAddr_5 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_6 = ((io_writeEn_6 && io_valuReadEn_0_0) && (io_writeAddr_6 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_7 = ((io_writeEn_7 && io_valuReadEn_0_0) && (io_writeAddr_7 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_8 = ((io_writeEn_8 && io_valuReadEn_0_0) && (io_writeAddr_8 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_9 = ((io_writeEn_9 && io_valuReadEn_0_0) && (io_writeAddr_9 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_10 = ((io_writeEn_10 && io_valuReadEn_0_0) && (io_writeAddr_10 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_11 = ((io_writeEn_11 && io_valuReadEn_0_0) && (io_writeAddr_11 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_12 = ((io_writeEn_12 && io_valuReadEn_0_0) && (io_writeAddr_12 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_13 = ((io_writeEn_13 && io_valuReadEn_0_0) && (io_writeAddr_13 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_14 = ((io_writeEn_14 && io_valuReadEn_0_0) && (io_writeAddr_14 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_15 = ((io_writeEn_15 && io_valuReadEn_0_0) && (io_writeAddr_15 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_16 = ((io_writeEn_16 && io_valuReadEn_0_0) && (io_writeAddr_16 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_17 = ((io_writeEn_17 && io_valuReadEn_0_0) && (io_writeAddr_17 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_18 = ((io_writeEn_18 && io_valuReadEn_0_0) && (io_writeAddr_18 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_19 = ((io_writeEn_19 && io_valuReadEn_0_0) && (io_writeAddr_19 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_20 = ((io_writeEn_20 && io_valuReadEn_0_0) && (io_writeAddr_20 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_21 = ((io_writeEn_21 && io_valuReadEn_0_0) && (io_writeAddr_21 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_22 = ((io_writeEn_22 && io_valuReadEn_0_0) && (io_writeAddr_22 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_23 = ((io_writeEn_23 && io_valuReadEn_0_0) && (io_writeAddr_23 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_24 = ((io_writeEn_24 && io_valuReadEn_0_0) && (io_writeAddr_24 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_25 = ((io_writeEn_25 && io_valuReadEn_0_0) && (io_writeAddr_25 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_26 = ((io_writeEn_26 && io_valuReadEn_0_0) && (io_writeAddr_26 == io_valuReadAddr_0_0));
  assign when_BankedScratchMemory_l412_27 = ((io_writeEn_27 && io_valuReadEn_0_0) && (io_writeAddr_27 == io_valuReadAddr_0_0));
  always @(*) begin
    _zz_fwdValuGap2Data_0_1 = 32'h0;
    if(when_BankedScratchMemory_l412_28) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_29) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_30) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_31) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_32) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_33) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_34) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_35) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_36) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_37) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_38) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_39) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_40) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_41) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_42) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_43) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_44) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_45) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_46) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_47) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_48) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_49) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_50) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_51) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_52) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_53) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_54) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_55) begin
      _zz_fwdValuGap2Data_0_1 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_28 = ((io_writeEn_0 && io_valuReadEn_0_1) && (io_writeAddr_0 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_29 = ((io_writeEn_1 && io_valuReadEn_0_1) && (io_writeAddr_1 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_30 = ((io_writeEn_2 && io_valuReadEn_0_1) && (io_writeAddr_2 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_31 = ((io_writeEn_3 && io_valuReadEn_0_1) && (io_writeAddr_3 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_32 = ((io_writeEn_4 && io_valuReadEn_0_1) && (io_writeAddr_4 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_33 = ((io_writeEn_5 && io_valuReadEn_0_1) && (io_writeAddr_5 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_34 = ((io_writeEn_6 && io_valuReadEn_0_1) && (io_writeAddr_6 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_35 = ((io_writeEn_7 && io_valuReadEn_0_1) && (io_writeAddr_7 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_36 = ((io_writeEn_8 && io_valuReadEn_0_1) && (io_writeAddr_8 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_37 = ((io_writeEn_9 && io_valuReadEn_0_1) && (io_writeAddr_9 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_38 = ((io_writeEn_10 && io_valuReadEn_0_1) && (io_writeAddr_10 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_39 = ((io_writeEn_11 && io_valuReadEn_0_1) && (io_writeAddr_11 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_40 = ((io_writeEn_12 && io_valuReadEn_0_1) && (io_writeAddr_12 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_41 = ((io_writeEn_13 && io_valuReadEn_0_1) && (io_writeAddr_13 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_42 = ((io_writeEn_14 && io_valuReadEn_0_1) && (io_writeAddr_14 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_43 = ((io_writeEn_15 && io_valuReadEn_0_1) && (io_writeAddr_15 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_44 = ((io_writeEn_16 && io_valuReadEn_0_1) && (io_writeAddr_16 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_45 = ((io_writeEn_17 && io_valuReadEn_0_1) && (io_writeAddr_17 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_46 = ((io_writeEn_18 && io_valuReadEn_0_1) && (io_writeAddr_18 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_47 = ((io_writeEn_19 && io_valuReadEn_0_1) && (io_writeAddr_19 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_48 = ((io_writeEn_20 && io_valuReadEn_0_1) && (io_writeAddr_20 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_49 = ((io_writeEn_21 && io_valuReadEn_0_1) && (io_writeAddr_21 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_50 = ((io_writeEn_22 && io_valuReadEn_0_1) && (io_writeAddr_22 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_51 = ((io_writeEn_23 && io_valuReadEn_0_1) && (io_writeAddr_23 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_52 = ((io_writeEn_24 && io_valuReadEn_0_1) && (io_writeAddr_24 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_53 = ((io_writeEn_25 && io_valuReadEn_0_1) && (io_writeAddr_25 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_54 = ((io_writeEn_26 && io_valuReadEn_0_1) && (io_writeAddr_26 == io_valuReadAddr_0_1));
  assign when_BankedScratchMemory_l412_55 = ((io_writeEn_27 && io_valuReadEn_0_1) && (io_writeAddr_27 == io_valuReadAddr_0_1));
  always @(*) begin
    _zz_fwdValuGap2Data_0_2 = 32'h0;
    if(when_BankedScratchMemory_l412_56) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_57) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_58) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_59) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_60) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_61) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_62) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_63) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_64) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_65) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_66) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_67) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_68) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_69) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_70) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_71) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_72) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_73) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_74) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_75) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_76) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_77) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_78) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_79) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_80) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_81) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_82) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_83) begin
      _zz_fwdValuGap2Data_0_2 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_56 = ((io_writeEn_0 && io_valuReadEn_0_2) && (io_writeAddr_0 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_57 = ((io_writeEn_1 && io_valuReadEn_0_2) && (io_writeAddr_1 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_58 = ((io_writeEn_2 && io_valuReadEn_0_2) && (io_writeAddr_2 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_59 = ((io_writeEn_3 && io_valuReadEn_0_2) && (io_writeAddr_3 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_60 = ((io_writeEn_4 && io_valuReadEn_0_2) && (io_writeAddr_4 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_61 = ((io_writeEn_5 && io_valuReadEn_0_2) && (io_writeAddr_5 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_62 = ((io_writeEn_6 && io_valuReadEn_0_2) && (io_writeAddr_6 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_63 = ((io_writeEn_7 && io_valuReadEn_0_2) && (io_writeAddr_7 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_64 = ((io_writeEn_8 && io_valuReadEn_0_2) && (io_writeAddr_8 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_65 = ((io_writeEn_9 && io_valuReadEn_0_2) && (io_writeAddr_9 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_66 = ((io_writeEn_10 && io_valuReadEn_0_2) && (io_writeAddr_10 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_67 = ((io_writeEn_11 && io_valuReadEn_0_2) && (io_writeAddr_11 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_68 = ((io_writeEn_12 && io_valuReadEn_0_2) && (io_writeAddr_12 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_69 = ((io_writeEn_13 && io_valuReadEn_0_2) && (io_writeAddr_13 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_70 = ((io_writeEn_14 && io_valuReadEn_0_2) && (io_writeAddr_14 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_71 = ((io_writeEn_15 && io_valuReadEn_0_2) && (io_writeAddr_15 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_72 = ((io_writeEn_16 && io_valuReadEn_0_2) && (io_writeAddr_16 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_73 = ((io_writeEn_17 && io_valuReadEn_0_2) && (io_writeAddr_17 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_74 = ((io_writeEn_18 && io_valuReadEn_0_2) && (io_writeAddr_18 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_75 = ((io_writeEn_19 && io_valuReadEn_0_2) && (io_writeAddr_19 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_76 = ((io_writeEn_20 && io_valuReadEn_0_2) && (io_writeAddr_20 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_77 = ((io_writeEn_21 && io_valuReadEn_0_2) && (io_writeAddr_21 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_78 = ((io_writeEn_22 && io_valuReadEn_0_2) && (io_writeAddr_22 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_79 = ((io_writeEn_23 && io_valuReadEn_0_2) && (io_writeAddr_23 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_80 = ((io_writeEn_24 && io_valuReadEn_0_2) && (io_writeAddr_24 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_81 = ((io_writeEn_25 && io_valuReadEn_0_2) && (io_writeAddr_25 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_82 = ((io_writeEn_26 && io_valuReadEn_0_2) && (io_writeAddr_26 == io_valuReadAddr_0_2));
  assign when_BankedScratchMemory_l412_83 = ((io_writeEn_27 && io_valuReadEn_0_2) && (io_writeAddr_27 == io_valuReadAddr_0_2));
  always @(*) begin
    _zz_fwdValuGap2Data_0_3 = 32'h0;
    if(when_BankedScratchMemory_l412_84) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_85) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_86) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_87) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_88) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_89) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_90) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_91) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_92) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_93) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_94) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_95) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_96) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_97) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_98) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_99) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_100) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_101) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_102) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_103) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_104) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_105) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_106) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_107) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_108) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_109) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_110) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_111) begin
      _zz_fwdValuGap2Data_0_3 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_84 = ((io_writeEn_0 && io_valuReadEn_0_3) && (io_writeAddr_0 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_85 = ((io_writeEn_1 && io_valuReadEn_0_3) && (io_writeAddr_1 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_86 = ((io_writeEn_2 && io_valuReadEn_0_3) && (io_writeAddr_2 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_87 = ((io_writeEn_3 && io_valuReadEn_0_3) && (io_writeAddr_3 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_88 = ((io_writeEn_4 && io_valuReadEn_0_3) && (io_writeAddr_4 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_89 = ((io_writeEn_5 && io_valuReadEn_0_3) && (io_writeAddr_5 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_90 = ((io_writeEn_6 && io_valuReadEn_0_3) && (io_writeAddr_6 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_91 = ((io_writeEn_7 && io_valuReadEn_0_3) && (io_writeAddr_7 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_92 = ((io_writeEn_8 && io_valuReadEn_0_3) && (io_writeAddr_8 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_93 = ((io_writeEn_9 && io_valuReadEn_0_3) && (io_writeAddr_9 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_94 = ((io_writeEn_10 && io_valuReadEn_0_3) && (io_writeAddr_10 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_95 = ((io_writeEn_11 && io_valuReadEn_0_3) && (io_writeAddr_11 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_96 = ((io_writeEn_12 && io_valuReadEn_0_3) && (io_writeAddr_12 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_97 = ((io_writeEn_13 && io_valuReadEn_0_3) && (io_writeAddr_13 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_98 = ((io_writeEn_14 && io_valuReadEn_0_3) && (io_writeAddr_14 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_99 = ((io_writeEn_15 && io_valuReadEn_0_3) && (io_writeAddr_15 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_100 = ((io_writeEn_16 && io_valuReadEn_0_3) && (io_writeAddr_16 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_101 = ((io_writeEn_17 && io_valuReadEn_0_3) && (io_writeAddr_17 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_102 = ((io_writeEn_18 && io_valuReadEn_0_3) && (io_writeAddr_18 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_103 = ((io_writeEn_19 && io_valuReadEn_0_3) && (io_writeAddr_19 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_104 = ((io_writeEn_20 && io_valuReadEn_0_3) && (io_writeAddr_20 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_105 = ((io_writeEn_21 && io_valuReadEn_0_3) && (io_writeAddr_21 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_106 = ((io_writeEn_22 && io_valuReadEn_0_3) && (io_writeAddr_22 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_107 = ((io_writeEn_23 && io_valuReadEn_0_3) && (io_writeAddr_23 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_108 = ((io_writeEn_24 && io_valuReadEn_0_3) && (io_writeAddr_24 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_109 = ((io_writeEn_25 && io_valuReadEn_0_3) && (io_writeAddr_25 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_110 = ((io_writeEn_26 && io_valuReadEn_0_3) && (io_writeAddr_26 == io_valuReadAddr_0_3));
  assign when_BankedScratchMemory_l412_111 = ((io_writeEn_27 && io_valuReadEn_0_3) && (io_writeAddr_27 == io_valuReadAddr_0_3));
  always @(*) begin
    _zz_fwdValuGap2Data_0_4 = 32'h0;
    if(when_BankedScratchMemory_l412_112) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_113) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_114) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_115) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_116) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_117) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_118) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_119) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_120) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_121) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_122) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_123) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_124) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_125) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_126) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_127) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_128) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_129) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_130) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_131) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_132) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_133) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_134) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_135) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_136) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_137) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_138) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_139) begin
      _zz_fwdValuGap2Data_0_4 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_112 = ((io_writeEn_0 && io_valuReadEn_0_4) && (io_writeAddr_0 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_113 = ((io_writeEn_1 && io_valuReadEn_0_4) && (io_writeAddr_1 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_114 = ((io_writeEn_2 && io_valuReadEn_0_4) && (io_writeAddr_2 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_115 = ((io_writeEn_3 && io_valuReadEn_0_4) && (io_writeAddr_3 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_116 = ((io_writeEn_4 && io_valuReadEn_0_4) && (io_writeAddr_4 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_117 = ((io_writeEn_5 && io_valuReadEn_0_4) && (io_writeAddr_5 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_118 = ((io_writeEn_6 && io_valuReadEn_0_4) && (io_writeAddr_6 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_119 = ((io_writeEn_7 && io_valuReadEn_0_4) && (io_writeAddr_7 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_120 = ((io_writeEn_8 && io_valuReadEn_0_4) && (io_writeAddr_8 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_121 = ((io_writeEn_9 && io_valuReadEn_0_4) && (io_writeAddr_9 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_122 = ((io_writeEn_10 && io_valuReadEn_0_4) && (io_writeAddr_10 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_123 = ((io_writeEn_11 && io_valuReadEn_0_4) && (io_writeAddr_11 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_124 = ((io_writeEn_12 && io_valuReadEn_0_4) && (io_writeAddr_12 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_125 = ((io_writeEn_13 && io_valuReadEn_0_4) && (io_writeAddr_13 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_126 = ((io_writeEn_14 && io_valuReadEn_0_4) && (io_writeAddr_14 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_127 = ((io_writeEn_15 && io_valuReadEn_0_4) && (io_writeAddr_15 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_128 = ((io_writeEn_16 && io_valuReadEn_0_4) && (io_writeAddr_16 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_129 = ((io_writeEn_17 && io_valuReadEn_0_4) && (io_writeAddr_17 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_130 = ((io_writeEn_18 && io_valuReadEn_0_4) && (io_writeAddr_18 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_131 = ((io_writeEn_19 && io_valuReadEn_0_4) && (io_writeAddr_19 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_132 = ((io_writeEn_20 && io_valuReadEn_0_4) && (io_writeAddr_20 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_133 = ((io_writeEn_21 && io_valuReadEn_0_4) && (io_writeAddr_21 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_134 = ((io_writeEn_22 && io_valuReadEn_0_4) && (io_writeAddr_22 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_135 = ((io_writeEn_23 && io_valuReadEn_0_4) && (io_writeAddr_23 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_136 = ((io_writeEn_24 && io_valuReadEn_0_4) && (io_writeAddr_24 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_137 = ((io_writeEn_25 && io_valuReadEn_0_4) && (io_writeAddr_25 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_138 = ((io_writeEn_26 && io_valuReadEn_0_4) && (io_writeAddr_26 == io_valuReadAddr_0_4));
  assign when_BankedScratchMemory_l412_139 = ((io_writeEn_27 && io_valuReadEn_0_4) && (io_writeAddr_27 == io_valuReadAddr_0_4));
  always @(*) begin
    _zz_fwdValuGap2Data_0_5 = 32'h0;
    if(when_BankedScratchMemory_l412_140) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_141) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_142) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_143) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_144) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_145) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_146) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_147) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_148) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_149) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_150) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_151) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_152) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_153) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_154) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_155) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_156) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_157) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_158) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_159) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_160) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_161) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_162) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_163) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_164) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_165) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_166) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_167) begin
      _zz_fwdValuGap2Data_0_5 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_140 = ((io_writeEn_0 && io_valuReadEn_0_5) && (io_writeAddr_0 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_141 = ((io_writeEn_1 && io_valuReadEn_0_5) && (io_writeAddr_1 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_142 = ((io_writeEn_2 && io_valuReadEn_0_5) && (io_writeAddr_2 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_143 = ((io_writeEn_3 && io_valuReadEn_0_5) && (io_writeAddr_3 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_144 = ((io_writeEn_4 && io_valuReadEn_0_5) && (io_writeAddr_4 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_145 = ((io_writeEn_5 && io_valuReadEn_0_5) && (io_writeAddr_5 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_146 = ((io_writeEn_6 && io_valuReadEn_0_5) && (io_writeAddr_6 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_147 = ((io_writeEn_7 && io_valuReadEn_0_5) && (io_writeAddr_7 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_148 = ((io_writeEn_8 && io_valuReadEn_0_5) && (io_writeAddr_8 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_149 = ((io_writeEn_9 && io_valuReadEn_0_5) && (io_writeAddr_9 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_150 = ((io_writeEn_10 && io_valuReadEn_0_5) && (io_writeAddr_10 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_151 = ((io_writeEn_11 && io_valuReadEn_0_5) && (io_writeAddr_11 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_152 = ((io_writeEn_12 && io_valuReadEn_0_5) && (io_writeAddr_12 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_153 = ((io_writeEn_13 && io_valuReadEn_0_5) && (io_writeAddr_13 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_154 = ((io_writeEn_14 && io_valuReadEn_0_5) && (io_writeAddr_14 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_155 = ((io_writeEn_15 && io_valuReadEn_0_5) && (io_writeAddr_15 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_156 = ((io_writeEn_16 && io_valuReadEn_0_5) && (io_writeAddr_16 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_157 = ((io_writeEn_17 && io_valuReadEn_0_5) && (io_writeAddr_17 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_158 = ((io_writeEn_18 && io_valuReadEn_0_5) && (io_writeAddr_18 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_159 = ((io_writeEn_19 && io_valuReadEn_0_5) && (io_writeAddr_19 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_160 = ((io_writeEn_20 && io_valuReadEn_0_5) && (io_writeAddr_20 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_161 = ((io_writeEn_21 && io_valuReadEn_0_5) && (io_writeAddr_21 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_162 = ((io_writeEn_22 && io_valuReadEn_0_5) && (io_writeAddr_22 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_163 = ((io_writeEn_23 && io_valuReadEn_0_5) && (io_writeAddr_23 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_164 = ((io_writeEn_24 && io_valuReadEn_0_5) && (io_writeAddr_24 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_165 = ((io_writeEn_25 && io_valuReadEn_0_5) && (io_writeAddr_25 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_166 = ((io_writeEn_26 && io_valuReadEn_0_5) && (io_writeAddr_26 == io_valuReadAddr_0_5));
  assign when_BankedScratchMemory_l412_167 = ((io_writeEn_27 && io_valuReadEn_0_5) && (io_writeAddr_27 == io_valuReadAddr_0_5));
  always @(*) begin
    _zz_fwdValuGap2Data_0_6 = 32'h0;
    if(when_BankedScratchMemory_l412_168) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_169) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_170) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_171) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_172) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_173) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_174) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_175) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_176) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_177) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_178) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_179) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_180) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_181) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_182) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_183) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_184) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_185) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_186) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_187) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_188) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_189) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_190) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_191) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_192) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_193) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_194) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_195) begin
      _zz_fwdValuGap2Data_0_6 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_168 = ((io_writeEn_0 && io_valuReadEn_0_6) && (io_writeAddr_0 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_169 = ((io_writeEn_1 && io_valuReadEn_0_6) && (io_writeAddr_1 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_170 = ((io_writeEn_2 && io_valuReadEn_0_6) && (io_writeAddr_2 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_171 = ((io_writeEn_3 && io_valuReadEn_0_6) && (io_writeAddr_3 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_172 = ((io_writeEn_4 && io_valuReadEn_0_6) && (io_writeAddr_4 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_173 = ((io_writeEn_5 && io_valuReadEn_0_6) && (io_writeAddr_5 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_174 = ((io_writeEn_6 && io_valuReadEn_0_6) && (io_writeAddr_6 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_175 = ((io_writeEn_7 && io_valuReadEn_0_6) && (io_writeAddr_7 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_176 = ((io_writeEn_8 && io_valuReadEn_0_6) && (io_writeAddr_8 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_177 = ((io_writeEn_9 && io_valuReadEn_0_6) && (io_writeAddr_9 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_178 = ((io_writeEn_10 && io_valuReadEn_0_6) && (io_writeAddr_10 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_179 = ((io_writeEn_11 && io_valuReadEn_0_6) && (io_writeAddr_11 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_180 = ((io_writeEn_12 && io_valuReadEn_0_6) && (io_writeAddr_12 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_181 = ((io_writeEn_13 && io_valuReadEn_0_6) && (io_writeAddr_13 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_182 = ((io_writeEn_14 && io_valuReadEn_0_6) && (io_writeAddr_14 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_183 = ((io_writeEn_15 && io_valuReadEn_0_6) && (io_writeAddr_15 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_184 = ((io_writeEn_16 && io_valuReadEn_0_6) && (io_writeAddr_16 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_185 = ((io_writeEn_17 && io_valuReadEn_0_6) && (io_writeAddr_17 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_186 = ((io_writeEn_18 && io_valuReadEn_0_6) && (io_writeAddr_18 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_187 = ((io_writeEn_19 && io_valuReadEn_0_6) && (io_writeAddr_19 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_188 = ((io_writeEn_20 && io_valuReadEn_0_6) && (io_writeAddr_20 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_189 = ((io_writeEn_21 && io_valuReadEn_0_6) && (io_writeAddr_21 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_190 = ((io_writeEn_22 && io_valuReadEn_0_6) && (io_writeAddr_22 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_191 = ((io_writeEn_23 && io_valuReadEn_0_6) && (io_writeAddr_23 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_192 = ((io_writeEn_24 && io_valuReadEn_0_6) && (io_writeAddr_24 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_193 = ((io_writeEn_25 && io_valuReadEn_0_6) && (io_writeAddr_25 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_194 = ((io_writeEn_26 && io_valuReadEn_0_6) && (io_writeAddr_26 == io_valuReadAddr_0_6));
  assign when_BankedScratchMemory_l412_195 = ((io_writeEn_27 && io_valuReadEn_0_6) && (io_writeAddr_27 == io_valuReadAddr_0_6));
  always @(*) begin
    _zz_fwdValuGap2Data_0_7 = 32'h0;
    if(when_BankedScratchMemory_l412_196) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_197) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_198) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_199) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_200) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_201) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_202) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_203) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_204) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_205) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_206) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_207) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_208) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_209) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_210) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_211) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_212) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_213) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_214) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_215) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_216) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_217) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_218) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_219) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_220) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_221) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_222) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_223) begin
      _zz_fwdValuGap2Data_0_7 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_196 = ((io_writeEn_0 && io_valuReadEn_0_7) && (io_writeAddr_0 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_197 = ((io_writeEn_1 && io_valuReadEn_0_7) && (io_writeAddr_1 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_198 = ((io_writeEn_2 && io_valuReadEn_0_7) && (io_writeAddr_2 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_199 = ((io_writeEn_3 && io_valuReadEn_0_7) && (io_writeAddr_3 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_200 = ((io_writeEn_4 && io_valuReadEn_0_7) && (io_writeAddr_4 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_201 = ((io_writeEn_5 && io_valuReadEn_0_7) && (io_writeAddr_5 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_202 = ((io_writeEn_6 && io_valuReadEn_0_7) && (io_writeAddr_6 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_203 = ((io_writeEn_7 && io_valuReadEn_0_7) && (io_writeAddr_7 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_204 = ((io_writeEn_8 && io_valuReadEn_0_7) && (io_writeAddr_8 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_205 = ((io_writeEn_9 && io_valuReadEn_0_7) && (io_writeAddr_9 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_206 = ((io_writeEn_10 && io_valuReadEn_0_7) && (io_writeAddr_10 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_207 = ((io_writeEn_11 && io_valuReadEn_0_7) && (io_writeAddr_11 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_208 = ((io_writeEn_12 && io_valuReadEn_0_7) && (io_writeAddr_12 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_209 = ((io_writeEn_13 && io_valuReadEn_0_7) && (io_writeAddr_13 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_210 = ((io_writeEn_14 && io_valuReadEn_0_7) && (io_writeAddr_14 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_211 = ((io_writeEn_15 && io_valuReadEn_0_7) && (io_writeAddr_15 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_212 = ((io_writeEn_16 && io_valuReadEn_0_7) && (io_writeAddr_16 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_213 = ((io_writeEn_17 && io_valuReadEn_0_7) && (io_writeAddr_17 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_214 = ((io_writeEn_18 && io_valuReadEn_0_7) && (io_writeAddr_18 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_215 = ((io_writeEn_19 && io_valuReadEn_0_7) && (io_writeAddr_19 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_216 = ((io_writeEn_20 && io_valuReadEn_0_7) && (io_writeAddr_20 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_217 = ((io_writeEn_21 && io_valuReadEn_0_7) && (io_writeAddr_21 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_218 = ((io_writeEn_22 && io_valuReadEn_0_7) && (io_writeAddr_22 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_219 = ((io_writeEn_23 && io_valuReadEn_0_7) && (io_writeAddr_23 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_220 = ((io_writeEn_24 && io_valuReadEn_0_7) && (io_writeAddr_24 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_221 = ((io_writeEn_25 && io_valuReadEn_0_7) && (io_writeAddr_25 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_222 = ((io_writeEn_26 && io_valuReadEn_0_7) && (io_writeAddr_26 == io_valuReadAddr_0_7));
  assign when_BankedScratchMemory_l412_223 = ((io_writeEn_27 && io_valuReadEn_0_7) && (io_writeAddr_27 == io_valuReadAddr_0_7));
  always @(*) begin
    _zz_fwdValuGap2Data_1_0 = 32'h0;
    if(when_BankedScratchMemory_l412_224) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_225) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_226) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_227) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_228) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_229) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_230) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_231) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_232) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_233) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_234) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_235) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_236) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_237) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_238) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_239) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_240) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_241) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_242) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_243) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_244) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_245) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_246) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_247) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_248) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_249) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_250) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_251) begin
      _zz_fwdValuGap2Data_1_0 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_224 = ((io_writeEn_0 && io_valuReadEn_1_0) && (io_writeAddr_0 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_225 = ((io_writeEn_1 && io_valuReadEn_1_0) && (io_writeAddr_1 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_226 = ((io_writeEn_2 && io_valuReadEn_1_0) && (io_writeAddr_2 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_227 = ((io_writeEn_3 && io_valuReadEn_1_0) && (io_writeAddr_3 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_228 = ((io_writeEn_4 && io_valuReadEn_1_0) && (io_writeAddr_4 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_229 = ((io_writeEn_5 && io_valuReadEn_1_0) && (io_writeAddr_5 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_230 = ((io_writeEn_6 && io_valuReadEn_1_0) && (io_writeAddr_6 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_231 = ((io_writeEn_7 && io_valuReadEn_1_0) && (io_writeAddr_7 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_232 = ((io_writeEn_8 && io_valuReadEn_1_0) && (io_writeAddr_8 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_233 = ((io_writeEn_9 && io_valuReadEn_1_0) && (io_writeAddr_9 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_234 = ((io_writeEn_10 && io_valuReadEn_1_0) && (io_writeAddr_10 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_235 = ((io_writeEn_11 && io_valuReadEn_1_0) && (io_writeAddr_11 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_236 = ((io_writeEn_12 && io_valuReadEn_1_0) && (io_writeAddr_12 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_237 = ((io_writeEn_13 && io_valuReadEn_1_0) && (io_writeAddr_13 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_238 = ((io_writeEn_14 && io_valuReadEn_1_0) && (io_writeAddr_14 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_239 = ((io_writeEn_15 && io_valuReadEn_1_0) && (io_writeAddr_15 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_240 = ((io_writeEn_16 && io_valuReadEn_1_0) && (io_writeAddr_16 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_241 = ((io_writeEn_17 && io_valuReadEn_1_0) && (io_writeAddr_17 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_242 = ((io_writeEn_18 && io_valuReadEn_1_0) && (io_writeAddr_18 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_243 = ((io_writeEn_19 && io_valuReadEn_1_0) && (io_writeAddr_19 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_244 = ((io_writeEn_20 && io_valuReadEn_1_0) && (io_writeAddr_20 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_245 = ((io_writeEn_21 && io_valuReadEn_1_0) && (io_writeAddr_21 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_246 = ((io_writeEn_22 && io_valuReadEn_1_0) && (io_writeAddr_22 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_247 = ((io_writeEn_23 && io_valuReadEn_1_0) && (io_writeAddr_23 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_248 = ((io_writeEn_24 && io_valuReadEn_1_0) && (io_writeAddr_24 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_249 = ((io_writeEn_25 && io_valuReadEn_1_0) && (io_writeAddr_25 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_250 = ((io_writeEn_26 && io_valuReadEn_1_0) && (io_writeAddr_26 == io_valuReadAddr_1_0));
  assign when_BankedScratchMemory_l412_251 = ((io_writeEn_27 && io_valuReadEn_1_0) && (io_writeAddr_27 == io_valuReadAddr_1_0));
  always @(*) begin
    _zz_fwdValuGap2Data_1_1 = 32'h0;
    if(when_BankedScratchMemory_l412_252) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_253) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_254) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_255) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_256) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_257) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_258) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_259) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_260) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_261) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_262) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_263) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_264) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_265) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_266) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_267) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_268) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_269) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_270) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_271) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_272) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_273) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_274) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_275) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_276) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_277) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_278) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_279) begin
      _zz_fwdValuGap2Data_1_1 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_252 = ((io_writeEn_0 && io_valuReadEn_1_1) && (io_writeAddr_0 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_253 = ((io_writeEn_1 && io_valuReadEn_1_1) && (io_writeAddr_1 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_254 = ((io_writeEn_2 && io_valuReadEn_1_1) && (io_writeAddr_2 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_255 = ((io_writeEn_3 && io_valuReadEn_1_1) && (io_writeAddr_3 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_256 = ((io_writeEn_4 && io_valuReadEn_1_1) && (io_writeAddr_4 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_257 = ((io_writeEn_5 && io_valuReadEn_1_1) && (io_writeAddr_5 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_258 = ((io_writeEn_6 && io_valuReadEn_1_1) && (io_writeAddr_6 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_259 = ((io_writeEn_7 && io_valuReadEn_1_1) && (io_writeAddr_7 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_260 = ((io_writeEn_8 && io_valuReadEn_1_1) && (io_writeAddr_8 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_261 = ((io_writeEn_9 && io_valuReadEn_1_1) && (io_writeAddr_9 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_262 = ((io_writeEn_10 && io_valuReadEn_1_1) && (io_writeAddr_10 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_263 = ((io_writeEn_11 && io_valuReadEn_1_1) && (io_writeAddr_11 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_264 = ((io_writeEn_12 && io_valuReadEn_1_1) && (io_writeAddr_12 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_265 = ((io_writeEn_13 && io_valuReadEn_1_1) && (io_writeAddr_13 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_266 = ((io_writeEn_14 && io_valuReadEn_1_1) && (io_writeAddr_14 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_267 = ((io_writeEn_15 && io_valuReadEn_1_1) && (io_writeAddr_15 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_268 = ((io_writeEn_16 && io_valuReadEn_1_1) && (io_writeAddr_16 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_269 = ((io_writeEn_17 && io_valuReadEn_1_1) && (io_writeAddr_17 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_270 = ((io_writeEn_18 && io_valuReadEn_1_1) && (io_writeAddr_18 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_271 = ((io_writeEn_19 && io_valuReadEn_1_1) && (io_writeAddr_19 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_272 = ((io_writeEn_20 && io_valuReadEn_1_1) && (io_writeAddr_20 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_273 = ((io_writeEn_21 && io_valuReadEn_1_1) && (io_writeAddr_21 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_274 = ((io_writeEn_22 && io_valuReadEn_1_1) && (io_writeAddr_22 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_275 = ((io_writeEn_23 && io_valuReadEn_1_1) && (io_writeAddr_23 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_276 = ((io_writeEn_24 && io_valuReadEn_1_1) && (io_writeAddr_24 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_277 = ((io_writeEn_25 && io_valuReadEn_1_1) && (io_writeAddr_25 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_278 = ((io_writeEn_26 && io_valuReadEn_1_1) && (io_writeAddr_26 == io_valuReadAddr_1_1));
  assign when_BankedScratchMemory_l412_279 = ((io_writeEn_27 && io_valuReadEn_1_1) && (io_writeAddr_27 == io_valuReadAddr_1_1));
  always @(*) begin
    _zz_fwdValuGap2Data_1_2 = 32'h0;
    if(when_BankedScratchMemory_l412_280) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_281) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_282) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_283) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_284) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_285) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_286) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_287) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_288) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_289) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_290) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_291) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_292) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_293) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_294) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_295) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_296) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_297) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_298) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_299) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_300) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_301) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_302) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_303) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_304) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_305) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_306) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_307) begin
      _zz_fwdValuGap2Data_1_2 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_280 = ((io_writeEn_0 && io_valuReadEn_1_2) && (io_writeAddr_0 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_281 = ((io_writeEn_1 && io_valuReadEn_1_2) && (io_writeAddr_1 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_282 = ((io_writeEn_2 && io_valuReadEn_1_2) && (io_writeAddr_2 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_283 = ((io_writeEn_3 && io_valuReadEn_1_2) && (io_writeAddr_3 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_284 = ((io_writeEn_4 && io_valuReadEn_1_2) && (io_writeAddr_4 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_285 = ((io_writeEn_5 && io_valuReadEn_1_2) && (io_writeAddr_5 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_286 = ((io_writeEn_6 && io_valuReadEn_1_2) && (io_writeAddr_6 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_287 = ((io_writeEn_7 && io_valuReadEn_1_2) && (io_writeAddr_7 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_288 = ((io_writeEn_8 && io_valuReadEn_1_2) && (io_writeAddr_8 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_289 = ((io_writeEn_9 && io_valuReadEn_1_2) && (io_writeAddr_9 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_290 = ((io_writeEn_10 && io_valuReadEn_1_2) && (io_writeAddr_10 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_291 = ((io_writeEn_11 && io_valuReadEn_1_2) && (io_writeAddr_11 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_292 = ((io_writeEn_12 && io_valuReadEn_1_2) && (io_writeAddr_12 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_293 = ((io_writeEn_13 && io_valuReadEn_1_2) && (io_writeAddr_13 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_294 = ((io_writeEn_14 && io_valuReadEn_1_2) && (io_writeAddr_14 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_295 = ((io_writeEn_15 && io_valuReadEn_1_2) && (io_writeAddr_15 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_296 = ((io_writeEn_16 && io_valuReadEn_1_2) && (io_writeAddr_16 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_297 = ((io_writeEn_17 && io_valuReadEn_1_2) && (io_writeAddr_17 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_298 = ((io_writeEn_18 && io_valuReadEn_1_2) && (io_writeAddr_18 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_299 = ((io_writeEn_19 && io_valuReadEn_1_2) && (io_writeAddr_19 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_300 = ((io_writeEn_20 && io_valuReadEn_1_2) && (io_writeAddr_20 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_301 = ((io_writeEn_21 && io_valuReadEn_1_2) && (io_writeAddr_21 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_302 = ((io_writeEn_22 && io_valuReadEn_1_2) && (io_writeAddr_22 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_303 = ((io_writeEn_23 && io_valuReadEn_1_2) && (io_writeAddr_23 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_304 = ((io_writeEn_24 && io_valuReadEn_1_2) && (io_writeAddr_24 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_305 = ((io_writeEn_25 && io_valuReadEn_1_2) && (io_writeAddr_25 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_306 = ((io_writeEn_26 && io_valuReadEn_1_2) && (io_writeAddr_26 == io_valuReadAddr_1_2));
  assign when_BankedScratchMemory_l412_307 = ((io_writeEn_27 && io_valuReadEn_1_2) && (io_writeAddr_27 == io_valuReadAddr_1_2));
  always @(*) begin
    _zz_fwdValuGap2Data_1_3 = 32'h0;
    if(when_BankedScratchMemory_l412_308) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_309) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_310) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_311) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_312) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_313) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_314) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_315) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_316) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_317) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_318) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_319) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_320) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_321) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_322) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_323) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_324) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_325) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_326) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_327) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_328) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_329) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_330) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_331) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_332) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_333) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_334) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_335) begin
      _zz_fwdValuGap2Data_1_3 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_308 = ((io_writeEn_0 && io_valuReadEn_1_3) && (io_writeAddr_0 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_309 = ((io_writeEn_1 && io_valuReadEn_1_3) && (io_writeAddr_1 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_310 = ((io_writeEn_2 && io_valuReadEn_1_3) && (io_writeAddr_2 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_311 = ((io_writeEn_3 && io_valuReadEn_1_3) && (io_writeAddr_3 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_312 = ((io_writeEn_4 && io_valuReadEn_1_3) && (io_writeAddr_4 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_313 = ((io_writeEn_5 && io_valuReadEn_1_3) && (io_writeAddr_5 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_314 = ((io_writeEn_6 && io_valuReadEn_1_3) && (io_writeAddr_6 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_315 = ((io_writeEn_7 && io_valuReadEn_1_3) && (io_writeAddr_7 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_316 = ((io_writeEn_8 && io_valuReadEn_1_3) && (io_writeAddr_8 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_317 = ((io_writeEn_9 && io_valuReadEn_1_3) && (io_writeAddr_9 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_318 = ((io_writeEn_10 && io_valuReadEn_1_3) && (io_writeAddr_10 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_319 = ((io_writeEn_11 && io_valuReadEn_1_3) && (io_writeAddr_11 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_320 = ((io_writeEn_12 && io_valuReadEn_1_3) && (io_writeAddr_12 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_321 = ((io_writeEn_13 && io_valuReadEn_1_3) && (io_writeAddr_13 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_322 = ((io_writeEn_14 && io_valuReadEn_1_3) && (io_writeAddr_14 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_323 = ((io_writeEn_15 && io_valuReadEn_1_3) && (io_writeAddr_15 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_324 = ((io_writeEn_16 && io_valuReadEn_1_3) && (io_writeAddr_16 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_325 = ((io_writeEn_17 && io_valuReadEn_1_3) && (io_writeAddr_17 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_326 = ((io_writeEn_18 && io_valuReadEn_1_3) && (io_writeAddr_18 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_327 = ((io_writeEn_19 && io_valuReadEn_1_3) && (io_writeAddr_19 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_328 = ((io_writeEn_20 && io_valuReadEn_1_3) && (io_writeAddr_20 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_329 = ((io_writeEn_21 && io_valuReadEn_1_3) && (io_writeAddr_21 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_330 = ((io_writeEn_22 && io_valuReadEn_1_3) && (io_writeAddr_22 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_331 = ((io_writeEn_23 && io_valuReadEn_1_3) && (io_writeAddr_23 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_332 = ((io_writeEn_24 && io_valuReadEn_1_3) && (io_writeAddr_24 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_333 = ((io_writeEn_25 && io_valuReadEn_1_3) && (io_writeAddr_25 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_334 = ((io_writeEn_26 && io_valuReadEn_1_3) && (io_writeAddr_26 == io_valuReadAddr_1_3));
  assign when_BankedScratchMemory_l412_335 = ((io_writeEn_27 && io_valuReadEn_1_3) && (io_writeAddr_27 == io_valuReadAddr_1_3));
  always @(*) begin
    _zz_fwdValuGap2Data_1_4 = 32'h0;
    if(when_BankedScratchMemory_l412_336) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_337) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_338) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_339) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_340) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_341) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_342) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_343) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_344) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_345) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_346) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_347) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_348) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_349) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_350) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_351) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_352) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_353) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_354) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_355) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_356) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_357) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_358) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_359) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_360) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_361) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_362) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_363) begin
      _zz_fwdValuGap2Data_1_4 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_336 = ((io_writeEn_0 && io_valuReadEn_1_4) && (io_writeAddr_0 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_337 = ((io_writeEn_1 && io_valuReadEn_1_4) && (io_writeAddr_1 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_338 = ((io_writeEn_2 && io_valuReadEn_1_4) && (io_writeAddr_2 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_339 = ((io_writeEn_3 && io_valuReadEn_1_4) && (io_writeAddr_3 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_340 = ((io_writeEn_4 && io_valuReadEn_1_4) && (io_writeAddr_4 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_341 = ((io_writeEn_5 && io_valuReadEn_1_4) && (io_writeAddr_5 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_342 = ((io_writeEn_6 && io_valuReadEn_1_4) && (io_writeAddr_6 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_343 = ((io_writeEn_7 && io_valuReadEn_1_4) && (io_writeAddr_7 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_344 = ((io_writeEn_8 && io_valuReadEn_1_4) && (io_writeAddr_8 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_345 = ((io_writeEn_9 && io_valuReadEn_1_4) && (io_writeAddr_9 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_346 = ((io_writeEn_10 && io_valuReadEn_1_4) && (io_writeAddr_10 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_347 = ((io_writeEn_11 && io_valuReadEn_1_4) && (io_writeAddr_11 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_348 = ((io_writeEn_12 && io_valuReadEn_1_4) && (io_writeAddr_12 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_349 = ((io_writeEn_13 && io_valuReadEn_1_4) && (io_writeAddr_13 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_350 = ((io_writeEn_14 && io_valuReadEn_1_4) && (io_writeAddr_14 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_351 = ((io_writeEn_15 && io_valuReadEn_1_4) && (io_writeAddr_15 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_352 = ((io_writeEn_16 && io_valuReadEn_1_4) && (io_writeAddr_16 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_353 = ((io_writeEn_17 && io_valuReadEn_1_4) && (io_writeAddr_17 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_354 = ((io_writeEn_18 && io_valuReadEn_1_4) && (io_writeAddr_18 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_355 = ((io_writeEn_19 && io_valuReadEn_1_4) && (io_writeAddr_19 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_356 = ((io_writeEn_20 && io_valuReadEn_1_4) && (io_writeAddr_20 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_357 = ((io_writeEn_21 && io_valuReadEn_1_4) && (io_writeAddr_21 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_358 = ((io_writeEn_22 && io_valuReadEn_1_4) && (io_writeAddr_22 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_359 = ((io_writeEn_23 && io_valuReadEn_1_4) && (io_writeAddr_23 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_360 = ((io_writeEn_24 && io_valuReadEn_1_4) && (io_writeAddr_24 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_361 = ((io_writeEn_25 && io_valuReadEn_1_4) && (io_writeAddr_25 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_362 = ((io_writeEn_26 && io_valuReadEn_1_4) && (io_writeAddr_26 == io_valuReadAddr_1_4));
  assign when_BankedScratchMemory_l412_363 = ((io_writeEn_27 && io_valuReadEn_1_4) && (io_writeAddr_27 == io_valuReadAddr_1_4));
  always @(*) begin
    _zz_fwdValuGap2Data_1_5 = 32'h0;
    if(when_BankedScratchMemory_l412_364) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_365) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_366) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_367) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_368) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_369) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_370) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_371) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_372) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_373) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_374) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_375) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_376) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_377) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_378) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_379) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_380) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_381) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_382) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_383) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_384) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_385) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_386) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_387) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_388) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_389) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_390) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_391) begin
      _zz_fwdValuGap2Data_1_5 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_364 = ((io_writeEn_0 && io_valuReadEn_1_5) && (io_writeAddr_0 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_365 = ((io_writeEn_1 && io_valuReadEn_1_5) && (io_writeAddr_1 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_366 = ((io_writeEn_2 && io_valuReadEn_1_5) && (io_writeAddr_2 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_367 = ((io_writeEn_3 && io_valuReadEn_1_5) && (io_writeAddr_3 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_368 = ((io_writeEn_4 && io_valuReadEn_1_5) && (io_writeAddr_4 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_369 = ((io_writeEn_5 && io_valuReadEn_1_5) && (io_writeAddr_5 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_370 = ((io_writeEn_6 && io_valuReadEn_1_5) && (io_writeAddr_6 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_371 = ((io_writeEn_7 && io_valuReadEn_1_5) && (io_writeAddr_7 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_372 = ((io_writeEn_8 && io_valuReadEn_1_5) && (io_writeAddr_8 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_373 = ((io_writeEn_9 && io_valuReadEn_1_5) && (io_writeAddr_9 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_374 = ((io_writeEn_10 && io_valuReadEn_1_5) && (io_writeAddr_10 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_375 = ((io_writeEn_11 && io_valuReadEn_1_5) && (io_writeAddr_11 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_376 = ((io_writeEn_12 && io_valuReadEn_1_5) && (io_writeAddr_12 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_377 = ((io_writeEn_13 && io_valuReadEn_1_5) && (io_writeAddr_13 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_378 = ((io_writeEn_14 && io_valuReadEn_1_5) && (io_writeAddr_14 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_379 = ((io_writeEn_15 && io_valuReadEn_1_5) && (io_writeAddr_15 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_380 = ((io_writeEn_16 && io_valuReadEn_1_5) && (io_writeAddr_16 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_381 = ((io_writeEn_17 && io_valuReadEn_1_5) && (io_writeAddr_17 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_382 = ((io_writeEn_18 && io_valuReadEn_1_5) && (io_writeAddr_18 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_383 = ((io_writeEn_19 && io_valuReadEn_1_5) && (io_writeAddr_19 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_384 = ((io_writeEn_20 && io_valuReadEn_1_5) && (io_writeAddr_20 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_385 = ((io_writeEn_21 && io_valuReadEn_1_5) && (io_writeAddr_21 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_386 = ((io_writeEn_22 && io_valuReadEn_1_5) && (io_writeAddr_22 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_387 = ((io_writeEn_23 && io_valuReadEn_1_5) && (io_writeAddr_23 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_388 = ((io_writeEn_24 && io_valuReadEn_1_5) && (io_writeAddr_24 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_389 = ((io_writeEn_25 && io_valuReadEn_1_5) && (io_writeAddr_25 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_390 = ((io_writeEn_26 && io_valuReadEn_1_5) && (io_writeAddr_26 == io_valuReadAddr_1_5));
  assign when_BankedScratchMemory_l412_391 = ((io_writeEn_27 && io_valuReadEn_1_5) && (io_writeAddr_27 == io_valuReadAddr_1_5));
  always @(*) begin
    _zz_fwdValuGap2Data_1_6 = 32'h0;
    if(when_BankedScratchMemory_l412_392) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_393) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_394) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_395) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_396) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_397) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_398) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_399) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_400) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_401) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_402) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_403) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_404) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_405) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_406) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_407) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_408) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_409) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_410) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_411) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_412) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_413) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_414) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_415) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_416) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_417) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_418) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_419) begin
      _zz_fwdValuGap2Data_1_6 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_392 = ((io_writeEn_0 && io_valuReadEn_1_6) && (io_writeAddr_0 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_393 = ((io_writeEn_1 && io_valuReadEn_1_6) && (io_writeAddr_1 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_394 = ((io_writeEn_2 && io_valuReadEn_1_6) && (io_writeAddr_2 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_395 = ((io_writeEn_3 && io_valuReadEn_1_6) && (io_writeAddr_3 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_396 = ((io_writeEn_4 && io_valuReadEn_1_6) && (io_writeAddr_4 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_397 = ((io_writeEn_5 && io_valuReadEn_1_6) && (io_writeAddr_5 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_398 = ((io_writeEn_6 && io_valuReadEn_1_6) && (io_writeAddr_6 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_399 = ((io_writeEn_7 && io_valuReadEn_1_6) && (io_writeAddr_7 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_400 = ((io_writeEn_8 && io_valuReadEn_1_6) && (io_writeAddr_8 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_401 = ((io_writeEn_9 && io_valuReadEn_1_6) && (io_writeAddr_9 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_402 = ((io_writeEn_10 && io_valuReadEn_1_6) && (io_writeAddr_10 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_403 = ((io_writeEn_11 && io_valuReadEn_1_6) && (io_writeAddr_11 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_404 = ((io_writeEn_12 && io_valuReadEn_1_6) && (io_writeAddr_12 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_405 = ((io_writeEn_13 && io_valuReadEn_1_6) && (io_writeAddr_13 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_406 = ((io_writeEn_14 && io_valuReadEn_1_6) && (io_writeAddr_14 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_407 = ((io_writeEn_15 && io_valuReadEn_1_6) && (io_writeAddr_15 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_408 = ((io_writeEn_16 && io_valuReadEn_1_6) && (io_writeAddr_16 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_409 = ((io_writeEn_17 && io_valuReadEn_1_6) && (io_writeAddr_17 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_410 = ((io_writeEn_18 && io_valuReadEn_1_6) && (io_writeAddr_18 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_411 = ((io_writeEn_19 && io_valuReadEn_1_6) && (io_writeAddr_19 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_412 = ((io_writeEn_20 && io_valuReadEn_1_6) && (io_writeAddr_20 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_413 = ((io_writeEn_21 && io_valuReadEn_1_6) && (io_writeAddr_21 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_414 = ((io_writeEn_22 && io_valuReadEn_1_6) && (io_writeAddr_22 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_415 = ((io_writeEn_23 && io_valuReadEn_1_6) && (io_writeAddr_23 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_416 = ((io_writeEn_24 && io_valuReadEn_1_6) && (io_writeAddr_24 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_417 = ((io_writeEn_25 && io_valuReadEn_1_6) && (io_writeAddr_25 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_418 = ((io_writeEn_26 && io_valuReadEn_1_6) && (io_writeAddr_26 == io_valuReadAddr_1_6));
  assign when_BankedScratchMemory_l412_419 = ((io_writeEn_27 && io_valuReadEn_1_6) && (io_writeAddr_27 == io_valuReadAddr_1_6));
  always @(*) begin
    _zz_fwdValuGap2Data_1_7 = 32'h0;
    if(when_BankedScratchMemory_l412_420) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_0;
    end
    if(when_BankedScratchMemory_l412_421) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_1;
    end
    if(when_BankedScratchMemory_l412_422) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_2;
    end
    if(when_BankedScratchMemory_l412_423) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_3;
    end
    if(when_BankedScratchMemory_l412_424) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_4;
    end
    if(when_BankedScratchMemory_l412_425) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_5;
    end
    if(when_BankedScratchMemory_l412_426) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_6;
    end
    if(when_BankedScratchMemory_l412_427) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_7;
    end
    if(when_BankedScratchMemory_l412_428) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_8;
    end
    if(when_BankedScratchMemory_l412_429) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_9;
    end
    if(when_BankedScratchMemory_l412_430) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_10;
    end
    if(when_BankedScratchMemory_l412_431) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_11;
    end
    if(when_BankedScratchMemory_l412_432) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_12;
    end
    if(when_BankedScratchMemory_l412_433) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_13;
    end
    if(when_BankedScratchMemory_l412_434) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_14;
    end
    if(when_BankedScratchMemory_l412_435) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_15;
    end
    if(when_BankedScratchMemory_l412_436) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_16;
    end
    if(when_BankedScratchMemory_l412_437) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_17;
    end
    if(when_BankedScratchMemory_l412_438) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_18;
    end
    if(when_BankedScratchMemory_l412_439) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_19;
    end
    if(when_BankedScratchMemory_l412_440) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_20;
    end
    if(when_BankedScratchMemory_l412_441) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_21;
    end
    if(when_BankedScratchMemory_l412_442) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_22;
    end
    if(when_BankedScratchMemory_l412_443) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_23;
    end
    if(when_BankedScratchMemory_l412_444) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_24;
    end
    if(when_BankedScratchMemory_l412_445) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_25;
    end
    if(when_BankedScratchMemory_l412_446) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_26;
    end
    if(when_BankedScratchMemory_l412_447) begin
      _zz_fwdValuGap2Data_1_7 = io_writeData_27;
    end
  end

  assign when_BankedScratchMemory_l412_420 = ((io_writeEn_0 && io_valuReadEn_1_7) && (io_writeAddr_0 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_421 = ((io_writeEn_1 && io_valuReadEn_1_7) && (io_writeAddr_1 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_422 = ((io_writeEn_2 && io_valuReadEn_1_7) && (io_writeAddr_2 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_423 = ((io_writeEn_3 && io_valuReadEn_1_7) && (io_writeAddr_3 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_424 = ((io_writeEn_4 && io_valuReadEn_1_7) && (io_writeAddr_4 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_425 = ((io_writeEn_5 && io_valuReadEn_1_7) && (io_writeAddr_5 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_426 = ((io_writeEn_6 && io_valuReadEn_1_7) && (io_writeAddr_6 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_427 = ((io_writeEn_7 && io_valuReadEn_1_7) && (io_writeAddr_7 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_428 = ((io_writeEn_8 && io_valuReadEn_1_7) && (io_writeAddr_8 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_429 = ((io_writeEn_9 && io_valuReadEn_1_7) && (io_writeAddr_9 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_430 = ((io_writeEn_10 && io_valuReadEn_1_7) && (io_writeAddr_10 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_431 = ((io_writeEn_11 && io_valuReadEn_1_7) && (io_writeAddr_11 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_432 = ((io_writeEn_12 && io_valuReadEn_1_7) && (io_writeAddr_12 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_433 = ((io_writeEn_13 && io_valuReadEn_1_7) && (io_writeAddr_13 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_434 = ((io_writeEn_14 && io_valuReadEn_1_7) && (io_writeAddr_14 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_435 = ((io_writeEn_15 && io_valuReadEn_1_7) && (io_writeAddr_15 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_436 = ((io_writeEn_16 && io_valuReadEn_1_7) && (io_writeAddr_16 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_437 = ((io_writeEn_17 && io_valuReadEn_1_7) && (io_writeAddr_17 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_438 = ((io_writeEn_18 && io_valuReadEn_1_7) && (io_writeAddr_18 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_439 = ((io_writeEn_19 && io_valuReadEn_1_7) && (io_writeAddr_19 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_440 = ((io_writeEn_20 && io_valuReadEn_1_7) && (io_writeAddr_20 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_441 = ((io_writeEn_21 && io_valuReadEn_1_7) && (io_writeAddr_21 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_442 = ((io_writeEn_22 && io_valuReadEn_1_7) && (io_writeAddr_22 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_443 = ((io_writeEn_23 && io_valuReadEn_1_7) && (io_writeAddr_23 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_444 = ((io_writeEn_24 && io_valuReadEn_1_7) && (io_writeAddr_24 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_445 = ((io_writeEn_25 && io_valuReadEn_1_7) && (io_writeAddr_25 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_446 = ((io_writeEn_26 && io_valuReadEn_1_7) && (io_writeAddr_26 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l412_447 = ((io_writeEn_27 && io_valuReadEn_1_7) && (io_writeAddr_27 == io_valuReadAddr_1_7));
  assign when_BankedScratchMemory_l448 = ((io_writeEn_0 && prevValuReadEn_0_0) && (io_writeAddr_0 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_1 = ((io_writeEn_1 && prevValuReadEn_0_0) && (io_writeAddr_1 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_2 = ((io_writeEn_2 && prevValuReadEn_0_0) && (io_writeAddr_2 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_3 = ((io_writeEn_3 && prevValuReadEn_0_0) && (io_writeAddr_3 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_4 = ((io_writeEn_4 && prevValuReadEn_0_0) && (io_writeAddr_4 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_5 = ((io_writeEn_5 && prevValuReadEn_0_0) && (io_writeAddr_5 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_6 = ((io_writeEn_6 && prevValuReadEn_0_0) && (io_writeAddr_6 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_7 = ((io_writeEn_7 && prevValuReadEn_0_0) && (io_writeAddr_7 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_8 = ((io_writeEn_8 && prevValuReadEn_0_0) && (io_writeAddr_8 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_9 = ((io_writeEn_9 && prevValuReadEn_0_0) && (io_writeAddr_9 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_10 = ((io_writeEn_10 && prevValuReadEn_0_0) && (io_writeAddr_10 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_11 = ((io_writeEn_11 && prevValuReadEn_0_0) && (io_writeAddr_11 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_12 = ((io_writeEn_12 && prevValuReadEn_0_0) && (io_writeAddr_12 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_13 = ((io_writeEn_13 && prevValuReadEn_0_0) && (io_writeAddr_13 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_14 = ((io_writeEn_14 && prevValuReadEn_0_0) && (io_writeAddr_14 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_15 = ((io_writeEn_15 && prevValuReadEn_0_0) && (io_writeAddr_15 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_16 = ((io_writeEn_16 && prevValuReadEn_0_0) && (io_writeAddr_16 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_17 = ((io_writeEn_17 && prevValuReadEn_0_0) && (io_writeAddr_17 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_18 = ((io_writeEn_18 && prevValuReadEn_0_0) && (io_writeAddr_18 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_19 = ((io_writeEn_19 && prevValuReadEn_0_0) && (io_writeAddr_19 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_20 = ((io_writeEn_20 && prevValuReadEn_0_0) && (io_writeAddr_20 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_21 = ((io_writeEn_21 && prevValuReadEn_0_0) && (io_writeAddr_21 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_22 = ((io_writeEn_22 && prevValuReadEn_0_0) && (io_writeAddr_22 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_23 = ((io_writeEn_23 && prevValuReadEn_0_0) && (io_writeAddr_23 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_24 = ((io_writeEn_24 && prevValuReadEn_0_0) && (io_writeAddr_24 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_25 = ((io_writeEn_25 && prevValuReadEn_0_0) && (io_writeAddr_25 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_26 = ((io_writeEn_26 && prevValuReadEn_0_0) && (io_writeAddr_26 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_27 = ((io_writeEn_27 && prevValuReadEn_0_0) && (io_writeAddr_27 == prevValuReadAddr_0_0));
  assign when_BankedScratchMemory_l448_28 = ((io_writeEn_0 && prevValuReadEn_0_1) && (io_writeAddr_0 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_29 = ((io_writeEn_1 && prevValuReadEn_0_1) && (io_writeAddr_1 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_30 = ((io_writeEn_2 && prevValuReadEn_0_1) && (io_writeAddr_2 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_31 = ((io_writeEn_3 && prevValuReadEn_0_1) && (io_writeAddr_3 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_32 = ((io_writeEn_4 && prevValuReadEn_0_1) && (io_writeAddr_4 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_33 = ((io_writeEn_5 && prevValuReadEn_0_1) && (io_writeAddr_5 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_34 = ((io_writeEn_6 && prevValuReadEn_0_1) && (io_writeAddr_6 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_35 = ((io_writeEn_7 && prevValuReadEn_0_1) && (io_writeAddr_7 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_36 = ((io_writeEn_8 && prevValuReadEn_0_1) && (io_writeAddr_8 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_37 = ((io_writeEn_9 && prevValuReadEn_0_1) && (io_writeAddr_9 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_38 = ((io_writeEn_10 && prevValuReadEn_0_1) && (io_writeAddr_10 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_39 = ((io_writeEn_11 && prevValuReadEn_0_1) && (io_writeAddr_11 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_40 = ((io_writeEn_12 && prevValuReadEn_0_1) && (io_writeAddr_12 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_41 = ((io_writeEn_13 && prevValuReadEn_0_1) && (io_writeAddr_13 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_42 = ((io_writeEn_14 && prevValuReadEn_0_1) && (io_writeAddr_14 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_43 = ((io_writeEn_15 && prevValuReadEn_0_1) && (io_writeAddr_15 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_44 = ((io_writeEn_16 && prevValuReadEn_0_1) && (io_writeAddr_16 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_45 = ((io_writeEn_17 && prevValuReadEn_0_1) && (io_writeAddr_17 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_46 = ((io_writeEn_18 && prevValuReadEn_0_1) && (io_writeAddr_18 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_47 = ((io_writeEn_19 && prevValuReadEn_0_1) && (io_writeAddr_19 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_48 = ((io_writeEn_20 && prevValuReadEn_0_1) && (io_writeAddr_20 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_49 = ((io_writeEn_21 && prevValuReadEn_0_1) && (io_writeAddr_21 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_50 = ((io_writeEn_22 && prevValuReadEn_0_1) && (io_writeAddr_22 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_51 = ((io_writeEn_23 && prevValuReadEn_0_1) && (io_writeAddr_23 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_52 = ((io_writeEn_24 && prevValuReadEn_0_1) && (io_writeAddr_24 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_53 = ((io_writeEn_25 && prevValuReadEn_0_1) && (io_writeAddr_25 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_54 = ((io_writeEn_26 && prevValuReadEn_0_1) && (io_writeAddr_26 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_55 = ((io_writeEn_27 && prevValuReadEn_0_1) && (io_writeAddr_27 == prevValuReadAddr_0_1));
  assign when_BankedScratchMemory_l448_56 = ((io_writeEn_0 && prevValuReadEn_0_2) && (io_writeAddr_0 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_57 = ((io_writeEn_1 && prevValuReadEn_0_2) && (io_writeAddr_1 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_58 = ((io_writeEn_2 && prevValuReadEn_0_2) && (io_writeAddr_2 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_59 = ((io_writeEn_3 && prevValuReadEn_0_2) && (io_writeAddr_3 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_60 = ((io_writeEn_4 && prevValuReadEn_0_2) && (io_writeAddr_4 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_61 = ((io_writeEn_5 && prevValuReadEn_0_2) && (io_writeAddr_5 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_62 = ((io_writeEn_6 && prevValuReadEn_0_2) && (io_writeAddr_6 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_63 = ((io_writeEn_7 && prevValuReadEn_0_2) && (io_writeAddr_7 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_64 = ((io_writeEn_8 && prevValuReadEn_0_2) && (io_writeAddr_8 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_65 = ((io_writeEn_9 && prevValuReadEn_0_2) && (io_writeAddr_9 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_66 = ((io_writeEn_10 && prevValuReadEn_0_2) && (io_writeAddr_10 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_67 = ((io_writeEn_11 && prevValuReadEn_0_2) && (io_writeAddr_11 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_68 = ((io_writeEn_12 && prevValuReadEn_0_2) && (io_writeAddr_12 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_69 = ((io_writeEn_13 && prevValuReadEn_0_2) && (io_writeAddr_13 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_70 = ((io_writeEn_14 && prevValuReadEn_0_2) && (io_writeAddr_14 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_71 = ((io_writeEn_15 && prevValuReadEn_0_2) && (io_writeAddr_15 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_72 = ((io_writeEn_16 && prevValuReadEn_0_2) && (io_writeAddr_16 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_73 = ((io_writeEn_17 && prevValuReadEn_0_2) && (io_writeAddr_17 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_74 = ((io_writeEn_18 && prevValuReadEn_0_2) && (io_writeAddr_18 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_75 = ((io_writeEn_19 && prevValuReadEn_0_2) && (io_writeAddr_19 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_76 = ((io_writeEn_20 && prevValuReadEn_0_2) && (io_writeAddr_20 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_77 = ((io_writeEn_21 && prevValuReadEn_0_2) && (io_writeAddr_21 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_78 = ((io_writeEn_22 && prevValuReadEn_0_2) && (io_writeAddr_22 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_79 = ((io_writeEn_23 && prevValuReadEn_0_2) && (io_writeAddr_23 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_80 = ((io_writeEn_24 && prevValuReadEn_0_2) && (io_writeAddr_24 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_81 = ((io_writeEn_25 && prevValuReadEn_0_2) && (io_writeAddr_25 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_82 = ((io_writeEn_26 && prevValuReadEn_0_2) && (io_writeAddr_26 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_83 = ((io_writeEn_27 && prevValuReadEn_0_2) && (io_writeAddr_27 == prevValuReadAddr_0_2));
  assign when_BankedScratchMemory_l448_84 = ((io_writeEn_0 && prevValuReadEn_0_3) && (io_writeAddr_0 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_85 = ((io_writeEn_1 && prevValuReadEn_0_3) && (io_writeAddr_1 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_86 = ((io_writeEn_2 && prevValuReadEn_0_3) && (io_writeAddr_2 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_87 = ((io_writeEn_3 && prevValuReadEn_0_3) && (io_writeAddr_3 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_88 = ((io_writeEn_4 && prevValuReadEn_0_3) && (io_writeAddr_4 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_89 = ((io_writeEn_5 && prevValuReadEn_0_3) && (io_writeAddr_5 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_90 = ((io_writeEn_6 && prevValuReadEn_0_3) && (io_writeAddr_6 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_91 = ((io_writeEn_7 && prevValuReadEn_0_3) && (io_writeAddr_7 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_92 = ((io_writeEn_8 && prevValuReadEn_0_3) && (io_writeAddr_8 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_93 = ((io_writeEn_9 && prevValuReadEn_0_3) && (io_writeAddr_9 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_94 = ((io_writeEn_10 && prevValuReadEn_0_3) && (io_writeAddr_10 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_95 = ((io_writeEn_11 && prevValuReadEn_0_3) && (io_writeAddr_11 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_96 = ((io_writeEn_12 && prevValuReadEn_0_3) && (io_writeAddr_12 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_97 = ((io_writeEn_13 && prevValuReadEn_0_3) && (io_writeAddr_13 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_98 = ((io_writeEn_14 && prevValuReadEn_0_3) && (io_writeAddr_14 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_99 = ((io_writeEn_15 && prevValuReadEn_0_3) && (io_writeAddr_15 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_100 = ((io_writeEn_16 && prevValuReadEn_0_3) && (io_writeAddr_16 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_101 = ((io_writeEn_17 && prevValuReadEn_0_3) && (io_writeAddr_17 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_102 = ((io_writeEn_18 && prevValuReadEn_0_3) && (io_writeAddr_18 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_103 = ((io_writeEn_19 && prevValuReadEn_0_3) && (io_writeAddr_19 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_104 = ((io_writeEn_20 && prevValuReadEn_0_3) && (io_writeAddr_20 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_105 = ((io_writeEn_21 && prevValuReadEn_0_3) && (io_writeAddr_21 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_106 = ((io_writeEn_22 && prevValuReadEn_0_3) && (io_writeAddr_22 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_107 = ((io_writeEn_23 && prevValuReadEn_0_3) && (io_writeAddr_23 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_108 = ((io_writeEn_24 && prevValuReadEn_0_3) && (io_writeAddr_24 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_109 = ((io_writeEn_25 && prevValuReadEn_0_3) && (io_writeAddr_25 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_110 = ((io_writeEn_26 && prevValuReadEn_0_3) && (io_writeAddr_26 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_111 = ((io_writeEn_27 && prevValuReadEn_0_3) && (io_writeAddr_27 == prevValuReadAddr_0_3));
  assign when_BankedScratchMemory_l448_112 = ((io_writeEn_0 && prevValuReadEn_0_4) && (io_writeAddr_0 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_113 = ((io_writeEn_1 && prevValuReadEn_0_4) && (io_writeAddr_1 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_114 = ((io_writeEn_2 && prevValuReadEn_0_4) && (io_writeAddr_2 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_115 = ((io_writeEn_3 && prevValuReadEn_0_4) && (io_writeAddr_3 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_116 = ((io_writeEn_4 && prevValuReadEn_0_4) && (io_writeAddr_4 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_117 = ((io_writeEn_5 && prevValuReadEn_0_4) && (io_writeAddr_5 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_118 = ((io_writeEn_6 && prevValuReadEn_0_4) && (io_writeAddr_6 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_119 = ((io_writeEn_7 && prevValuReadEn_0_4) && (io_writeAddr_7 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_120 = ((io_writeEn_8 && prevValuReadEn_0_4) && (io_writeAddr_8 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_121 = ((io_writeEn_9 && prevValuReadEn_0_4) && (io_writeAddr_9 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_122 = ((io_writeEn_10 && prevValuReadEn_0_4) && (io_writeAddr_10 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_123 = ((io_writeEn_11 && prevValuReadEn_0_4) && (io_writeAddr_11 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_124 = ((io_writeEn_12 && prevValuReadEn_0_4) && (io_writeAddr_12 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_125 = ((io_writeEn_13 && prevValuReadEn_0_4) && (io_writeAddr_13 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_126 = ((io_writeEn_14 && prevValuReadEn_0_4) && (io_writeAddr_14 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_127 = ((io_writeEn_15 && prevValuReadEn_0_4) && (io_writeAddr_15 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_128 = ((io_writeEn_16 && prevValuReadEn_0_4) && (io_writeAddr_16 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_129 = ((io_writeEn_17 && prevValuReadEn_0_4) && (io_writeAddr_17 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_130 = ((io_writeEn_18 && prevValuReadEn_0_4) && (io_writeAddr_18 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_131 = ((io_writeEn_19 && prevValuReadEn_0_4) && (io_writeAddr_19 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_132 = ((io_writeEn_20 && prevValuReadEn_0_4) && (io_writeAddr_20 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_133 = ((io_writeEn_21 && prevValuReadEn_0_4) && (io_writeAddr_21 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_134 = ((io_writeEn_22 && prevValuReadEn_0_4) && (io_writeAddr_22 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_135 = ((io_writeEn_23 && prevValuReadEn_0_4) && (io_writeAddr_23 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_136 = ((io_writeEn_24 && prevValuReadEn_0_4) && (io_writeAddr_24 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_137 = ((io_writeEn_25 && prevValuReadEn_0_4) && (io_writeAddr_25 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_138 = ((io_writeEn_26 && prevValuReadEn_0_4) && (io_writeAddr_26 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_139 = ((io_writeEn_27 && prevValuReadEn_0_4) && (io_writeAddr_27 == prevValuReadAddr_0_4));
  assign when_BankedScratchMemory_l448_140 = ((io_writeEn_0 && prevValuReadEn_0_5) && (io_writeAddr_0 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_141 = ((io_writeEn_1 && prevValuReadEn_0_5) && (io_writeAddr_1 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_142 = ((io_writeEn_2 && prevValuReadEn_0_5) && (io_writeAddr_2 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_143 = ((io_writeEn_3 && prevValuReadEn_0_5) && (io_writeAddr_3 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_144 = ((io_writeEn_4 && prevValuReadEn_0_5) && (io_writeAddr_4 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_145 = ((io_writeEn_5 && prevValuReadEn_0_5) && (io_writeAddr_5 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_146 = ((io_writeEn_6 && prevValuReadEn_0_5) && (io_writeAddr_6 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_147 = ((io_writeEn_7 && prevValuReadEn_0_5) && (io_writeAddr_7 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_148 = ((io_writeEn_8 && prevValuReadEn_0_5) && (io_writeAddr_8 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_149 = ((io_writeEn_9 && prevValuReadEn_0_5) && (io_writeAddr_9 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_150 = ((io_writeEn_10 && prevValuReadEn_0_5) && (io_writeAddr_10 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_151 = ((io_writeEn_11 && prevValuReadEn_0_5) && (io_writeAddr_11 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_152 = ((io_writeEn_12 && prevValuReadEn_0_5) && (io_writeAddr_12 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_153 = ((io_writeEn_13 && prevValuReadEn_0_5) && (io_writeAddr_13 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_154 = ((io_writeEn_14 && prevValuReadEn_0_5) && (io_writeAddr_14 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_155 = ((io_writeEn_15 && prevValuReadEn_0_5) && (io_writeAddr_15 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_156 = ((io_writeEn_16 && prevValuReadEn_0_5) && (io_writeAddr_16 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_157 = ((io_writeEn_17 && prevValuReadEn_0_5) && (io_writeAddr_17 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_158 = ((io_writeEn_18 && prevValuReadEn_0_5) && (io_writeAddr_18 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_159 = ((io_writeEn_19 && prevValuReadEn_0_5) && (io_writeAddr_19 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_160 = ((io_writeEn_20 && prevValuReadEn_0_5) && (io_writeAddr_20 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_161 = ((io_writeEn_21 && prevValuReadEn_0_5) && (io_writeAddr_21 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_162 = ((io_writeEn_22 && prevValuReadEn_0_5) && (io_writeAddr_22 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_163 = ((io_writeEn_23 && prevValuReadEn_0_5) && (io_writeAddr_23 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_164 = ((io_writeEn_24 && prevValuReadEn_0_5) && (io_writeAddr_24 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_165 = ((io_writeEn_25 && prevValuReadEn_0_5) && (io_writeAddr_25 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_166 = ((io_writeEn_26 && prevValuReadEn_0_5) && (io_writeAddr_26 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_167 = ((io_writeEn_27 && prevValuReadEn_0_5) && (io_writeAddr_27 == prevValuReadAddr_0_5));
  assign when_BankedScratchMemory_l448_168 = ((io_writeEn_0 && prevValuReadEn_0_6) && (io_writeAddr_0 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_169 = ((io_writeEn_1 && prevValuReadEn_0_6) && (io_writeAddr_1 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_170 = ((io_writeEn_2 && prevValuReadEn_0_6) && (io_writeAddr_2 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_171 = ((io_writeEn_3 && prevValuReadEn_0_6) && (io_writeAddr_3 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_172 = ((io_writeEn_4 && prevValuReadEn_0_6) && (io_writeAddr_4 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_173 = ((io_writeEn_5 && prevValuReadEn_0_6) && (io_writeAddr_5 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_174 = ((io_writeEn_6 && prevValuReadEn_0_6) && (io_writeAddr_6 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_175 = ((io_writeEn_7 && prevValuReadEn_0_6) && (io_writeAddr_7 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_176 = ((io_writeEn_8 && prevValuReadEn_0_6) && (io_writeAddr_8 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_177 = ((io_writeEn_9 && prevValuReadEn_0_6) && (io_writeAddr_9 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_178 = ((io_writeEn_10 && prevValuReadEn_0_6) && (io_writeAddr_10 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_179 = ((io_writeEn_11 && prevValuReadEn_0_6) && (io_writeAddr_11 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_180 = ((io_writeEn_12 && prevValuReadEn_0_6) && (io_writeAddr_12 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_181 = ((io_writeEn_13 && prevValuReadEn_0_6) && (io_writeAddr_13 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_182 = ((io_writeEn_14 && prevValuReadEn_0_6) && (io_writeAddr_14 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_183 = ((io_writeEn_15 && prevValuReadEn_0_6) && (io_writeAddr_15 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_184 = ((io_writeEn_16 && prevValuReadEn_0_6) && (io_writeAddr_16 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_185 = ((io_writeEn_17 && prevValuReadEn_0_6) && (io_writeAddr_17 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_186 = ((io_writeEn_18 && prevValuReadEn_0_6) && (io_writeAddr_18 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_187 = ((io_writeEn_19 && prevValuReadEn_0_6) && (io_writeAddr_19 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_188 = ((io_writeEn_20 && prevValuReadEn_0_6) && (io_writeAddr_20 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_189 = ((io_writeEn_21 && prevValuReadEn_0_6) && (io_writeAddr_21 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_190 = ((io_writeEn_22 && prevValuReadEn_0_6) && (io_writeAddr_22 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_191 = ((io_writeEn_23 && prevValuReadEn_0_6) && (io_writeAddr_23 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_192 = ((io_writeEn_24 && prevValuReadEn_0_6) && (io_writeAddr_24 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_193 = ((io_writeEn_25 && prevValuReadEn_0_6) && (io_writeAddr_25 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_194 = ((io_writeEn_26 && prevValuReadEn_0_6) && (io_writeAddr_26 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_195 = ((io_writeEn_27 && prevValuReadEn_0_6) && (io_writeAddr_27 == prevValuReadAddr_0_6));
  assign when_BankedScratchMemory_l448_196 = ((io_writeEn_0 && prevValuReadEn_0_7) && (io_writeAddr_0 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_197 = ((io_writeEn_1 && prevValuReadEn_0_7) && (io_writeAddr_1 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_198 = ((io_writeEn_2 && prevValuReadEn_0_7) && (io_writeAddr_2 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_199 = ((io_writeEn_3 && prevValuReadEn_0_7) && (io_writeAddr_3 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_200 = ((io_writeEn_4 && prevValuReadEn_0_7) && (io_writeAddr_4 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_201 = ((io_writeEn_5 && prevValuReadEn_0_7) && (io_writeAddr_5 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_202 = ((io_writeEn_6 && prevValuReadEn_0_7) && (io_writeAddr_6 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_203 = ((io_writeEn_7 && prevValuReadEn_0_7) && (io_writeAddr_7 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_204 = ((io_writeEn_8 && prevValuReadEn_0_7) && (io_writeAddr_8 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_205 = ((io_writeEn_9 && prevValuReadEn_0_7) && (io_writeAddr_9 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_206 = ((io_writeEn_10 && prevValuReadEn_0_7) && (io_writeAddr_10 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_207 = ((io_writeEn_11 && prevValuReadEn_0_7) && (io_writeAddr_11 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_208 = ((io_writeEn_12 && prevValuReadEn_0_7) && (io_writeAddr_12 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_209 = ((io_writeEn_13 && prevValuReadEn_0_7) && (io_writeAddr_13 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_210 = ((io_writeEn_14 && prevValuReadEn_0_7) && (io_writeAddr_14 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_211 = ((io_writeEn_15 && prevValuReadEn_0_7) && (io_writeAddr_15 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_212 = ((io_writeEn_16 && prevValuReadEn_0_7) && (io_writeAddr_16 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_213 = ((io_writeEn_17 && prevValuReadEn_0_7) && (io_writeAddr_17 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_214 = ((io_writeEn_18 && prevValuReadEn_0_7) && (io_writeAddr_18 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_215 = ((io_writeEn_19 && prevValuReadEn_0_7) && (io_writeAddr_19 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_216 = ((io_writeEn_20 && prevValuReadEn_0_7) && (io_writeAddr_20 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_217 = ((io_writeEn_21 && prevValuReadEn_0_7) && (io_writeAddr_21 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_218 = ((io_writeEn_22 && prevValuReadEn_0_7) && (io_writeAddr_22 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_219 = ((io_writeEn_23 && prevValuReadEn_0_7) && (io_writeAddr_23 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_220 = ((io_writeEn_24 && prevValuReadEn_0_7) && (io_writeAddr_24 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_221 = ((io_writeEn_25 && prevValuReadEn_0_7) && (io_writeAddr_25 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_222 = ((io_writeEn_26 && prevValuReadEn_0_7) && (io_writeAddr_26 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_223 = ((io_writeEn_27 && prevValuReadEn_0_7) && (io_writeAddr_27 == prevValuReadAddr_0_7));
  assign when_BankedScratchMemory_l448_224 = ((io_writeEn_0 && prevValuReadEn_1_0) && (io_writeAddr_0 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_225 = ((io_writeEn_1 && prevValuReadEn_1_0) && (io_writeAddr_1 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_226 = ((io_writeEn_2 && prevValuReadEn_1_0) && (io_writeAddr_2 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_227 = ((io_writeEn_3 && prevValuReadEn_1_0) && (io_writeAddr_3 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_228 = ((io_writeEn_4 && prevValuReadEn_1_0) && (io_writeAddr_4 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_229 = ((io_writeEn_5 && prevValuReadEn_1_0) && (io_writeAddr_5 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_230 = ((io_writeEn_6 && prevValuReadEn_1_0) && (io_writeAddr_6 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_231 = ((io_writeEn_7 && prevValuReadEn_1_0) && (io_writeAddr_7 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_232 = ((io_writeEn_8 && prevValuReadEn_1_0) && (io_writeAddr_8 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_233 = ((io_writeEn_9 && prevValuReadEn_1_0) && (io_writeAddr_9 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_234 = ((io_writeEn_10 && prevValuReadEn_1_0) && (io_writeAddr_10 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_235 = ((io_writeEn_11 && prevValuReadEn_1_0) && (io_writeAddr_11 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_236 = ((io_writeEn_12 && prevValuReadEn_1_0) && (io_writeAddr_12 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_237 = ((io_writeEn_13 && prevValuReadEn_1_0) && (io_writeAddr_13 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_238 = ((io_writeEn_14 && prevValuReadEn_1_0) && (io_writeAddr_14 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_239 = ((io_writeEn_15 && prevValuReadEn_1_0) && (io_writeAddr_15 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_240 = ((io_writeEn_16 && prevValuReadEn_1_0) && (io_writeAddr_16 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_241 = ((io_writeEn_17 && prevValuReadEn_1_0) && (io_writeAddr_17 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_242 = ((io_writeEn_18 && prevValuReadEn_1_0) && (io_writeAddr_18 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_243 = ((io_writeEn_19 && prevValuReadEn_1_0) && (io_writeAddr_19 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_244 = ((io_writeEn_20 && prevValuReadEn_1_0) && (io_writeAddr_20 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_245 = ((io_writeEn_21 && prevValuReadEn_1_0) && (io_writeAddr_21 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_246 = ((io_writeEn_22 && prevValuReadEn_1_0) && (io_writeAddr_22 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_247 = ((io_writeEn_23 && prevValuReadEn_1_0) && (io_writeAddr_23 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_248 = ((io_writeEn_24 && prevValuReadEn_1_0) && (io_writeAddr_24 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_249 = ((io_writeEn_25 && prevValuReadEn_1_0) && (io_writeAddr_25 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_250 = ((io_writeEn_26 && prevValuReadEn_1_0) && (io_writeAddr_26 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_251 = ((io_writeEn_27 && prevValuReadEn_1_0) && (io_writeAddr_27 == prevValuReadAddr_1_0));
  assign when_BankedScratchMemory_l448_252 = ((io_writeEn_0 && prevValuReadEn_1_1) && (io_writeAddr_0 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_253 = ((io_writeEn_1 && prevValuReadEn_1_1) && (io_writeAddr_1 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_254 = ((io_writeEn_2 && prevValuReadEn_1_1) && (io_writeAddr_2 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_255 = ((io_writeEn_3 && prevValuReadEn_1_1) && (io_writeAddr_3 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_256 = ((io_writeEn_4 && prevValuReadEn_1_1) && (io_writeAddr_4 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_257 = ((io_writeEn_5 && prevValuReadEn_1_1) && (io_writeAddr_5 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_258 = ((io_writeEn_6 && prevValuReadEn_1_1) && (io_writeAddr_6 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_259 = ((io_writeEn_7 && prevValuReadEn_1_1) && (io_writeAddr_7 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_260 = ((io_writeEn_8 && prevValuReadEn_1_1) && (io_writeAddr_8 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_261 = ((io_writeEn_9 && prevValuReadEn_1_1) && (io_writeAddr_9 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_262 = ((io_writeEn_10 && prevValuReadEn_1_1) && (io_writeAddr_10 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_263 = ((io_writeEn_11 && prevValuReadEn_1_1) && (io_writeAddr_11 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_264 = ((io_writeEn_12 && prevValuReadEn_1_1) && (io_writeAddr_12 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_265 = ((io_writeEn_13 && prevValuReadEn_1_1) && (io_writeAddr_13 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_266 = ((io_writeEn_14 && prevValuReadEn_1_1) && (io_writeAddr_14 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_267 = ((io_writeEn_15 && prevValuReadEn_1_1) && (io_writeAddr_15 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_268 = ((io_writeEn_16 && prevValuReadEn_1_1) && (io_writeAddr_16 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_269 = ((io_writeEn_17 && prevValuReadEn_1_1) && (io_writeAddr_17 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_270 = ((io_writeEn_18 && prevValuReadEn_1_1) && (io_writeAddr_18 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_271 = ((io_writeEn_19 && prevValuReadEn_1_1) && (io_writeAddr_19 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_272 = ((io_writeEn_20 && prevValuReadEn_1_1) && (io_writeAddr_20 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_273 = ((io_writeEn_21 && prevValuReadEn_1_1) && (io_writeAddr_21 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_274 = ((io_writeEn_22 && prevValuReadEn_1_1) && (io_writeAddr_22 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_275 = ((io_writeEn_23 && prevValuReadEn_1_1) && (io_writeAddr_23 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_276 = ((io_writeEn_24 && prevValuReadEn_1_1) && (io_writeAddr_24 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_277 = ((io_writeEn_25 && prevValuReadEn_1_1) && (io_writeAddr_25 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_278 = ((io_writeEn_26 && prevValuReadEn_1_1) && (io_writeAddr_26 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_279 = ((io_writeEn_27 && prevValuReadEn_1_1) && (io_writeAddr_27 == prevValuReadAddr_1_1));
  assign when_BankedScratchMemory_l448_280 = ((io_writeEn_0 && prevValuReadEn_1_2) && (io_writeAddr_0 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_281 = ((io_writeEn_1 && prevValuReadEn_1_2) && (io_writeAddr_1 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_282 = ((io_writeEn_2 && prevValuReadEn_1_2) && (io_writeAddr_2 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_283 = ((io_writeEn_3 && prevValuReadEn_1_2) && (io_writeAddr_3 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_284 = ((io_writeEn_4 && prevValuReadEn_1_2) && (io_writeAddr_4 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_285 = ((io_writeEn_5 && prevValuReadEn_1_2) && (io_writeAddr_5 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_286 = ((io_writeEn_6 && prevValuReadEn_1_2) && (io_writeAddr_6 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_287 = ((io_writeEn_7 && prevValuReadEn_1_2) && (io_writeAddr_7 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_288 = ((io_writeEn_8 && prevValuReadEn_1_2) && (io_writeAddr_8 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_289 = ((io_writeEn_9 && prevValuReadEn_1_2) && (io_writeAddr_9 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_290 = ((io_writeEn_10 && prevValuReadEn_1_2) && (io_writeAddr_10 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_291 = ((io_writeEn_11 && prevValuReadEn_1_2) && (io_writeAddr_11 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_292 = ((io_writeEn_12 && prevValuReadEn_1_2) && (io_writeAddr_12 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_293 = ((io_writeEn_13 && prevValuReadEn_1_2) && (io_writeAddr_13 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_294 = ((io_writeEn_14 && prevValuReadEn_1_2) && (io_writeAddr_14 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_295 = ((io_writeEn_15 && prevValuReadEn_1_2) && (io_writeAddr_15 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_296 = ((io_writeEn_16 && prevValuReadEn_1_2) && (io_writeAddr_16 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_297 = ((io_writeEn_17 && prevValuReadEn_1_2) && (io_writeAddr_17 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_298 = ((io_writeEn_18 && prevValuReadEn_1_2) && (io_writeAddr_18 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_299 = ((io_writeEn_19 && prevValuReadEn_1_2) && (io_writeAddr_19 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_300 = ((io_writeEn_20 && prevValuReadEn_1_2) && (io_writeAddr_20 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_301 = ((io_writeEn_21 && prevValuReadEn_1_2) && (io_writeAddr_21 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_302 = ((io_writeEn_22 && prevValuReadEn_1_2) && (io_writeAddr_22 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_303 = ((io_writeEn_23 && prevValuReadEn_1_2) && (io_writeAddr_23 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_304 = ((io_writeEn_24 && prevValuReadEn_1_2) && (io_writeAddr_24 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_305 = ((io_writeEn_25 && prevValuReadEn_1_2) && (io_writeAddr_25 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_306 = ((io_writeEn_26 && prevValuReadEn_1_2) && (io_writeAddr_26 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_307 = ((io_writeEn_27 && prevValuReadEn_1_2) && (io_writeAddr_27 == prevValuReadAddr_1_2));
  assign when_BankedScratchMemory_l448_308 = ((io_writeEn_0 && prevValuReadEn_1_3) && (io_writeAddr_0 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_309 = ((io_writeEn_1 && prevValuReadEn_1_3) && (io_writeAddr_1 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_310 = ((io_writeEn_2 && prevValuReadEn_1_3) && (io_writeAddr_2 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_311 = ((io_writeEn_3 && prevValuReadEn_1_3) && (io_writeAddr_3 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_312 = ((io_writeEn_4 && prevValuReadEn_1_3) && (io_writeAddr_4 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_313 = ((io_writeEn_5 && prevValuReadEn_1_3) && (io_writeAddr_5 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_314 = ((io_writeEn_6 && prevValuReadEn_1_3) && (io_writeAddr_6 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_315 = ((io_writeEn_7 && prevValuReadEn_1_3) && (io_writeAddr_7 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_316 = ((io_writeEn_8 && prevValuReadEn_1_3) && (io_writeAddr_8 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_317 = ((io_writeEn_9 && prevValuReadEn_1_3) && (io_writeAddr_9 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_318 = ((io_writeEn_10 && prevValuReadEn_1_3) && (io_writeAddr_10 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_319 = ((io_writeEn_11 && prevValuReadEn_1_3) && (io_writeAddr_11 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_320 = ((io_writeEn_12 && prevValuReadEn_1_3) && (io_writeAddr_12 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_321 = ((io_writeEn_13 && prevValuReadEn_1_3) && (io_writeAddr_13 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_322 = ((io_writeEn_14 && prevValuReadEn_1_3) && (io_writeAddr_14 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_323 = ((io_writeEn_15 && prevValuReadEn_1_3) && (io_writeAddr_15 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_324 = ((io_writeEn_16 && prevValuReadEn_1_3) && (io_writeAddr_16 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_325 = ((io_writeEn_17 && prevValuReadEn_1_3) && (io_writeAddr_17 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_326 = ((io_writeEn_18 && prevValuReadEn_1_3) && (io_writeAddr_18 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_327 = ((io_writeEn_19 && prevValuReadEn_1_3) && (io_writeAddr_19 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_328 = ((io_writeEn_20 && prevValuReadEn_1_3) && (io_writeAddr_20 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_329 = ((io_writeEn_21 && prevValuReadEn_1_3) && (io_writeAddr_21 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_330 = ((io_writeEn_22 && prevValuReadEn_1_3) && (io_writeAddr_22 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_331 = ((io_writeEn_23 && prevValuReadEn_1_3) && (io_writeAddr_23 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_332 = ((io_writeEn_24 && prevValuReadEn_1_3) && (io_writeAddr_24 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_333 = ((io_writeEn_25 && prevValuReadEn_1_3) && (io_writeAddr_25 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_334 = ((io_writeEn_26 && prevValuReadEn_1_3) && (io_writeAddr_26 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_335 = ((io_writeEn_27 && prevValuReadEn_1_3) && (io_writeAddr_27 == prevValuReadAddr_1_3));
  assign when_BankedScratchMemory_l448_336 = ((io_writeEn_0 && prevValuReadEn_1_4) && (io_writeAddr_0 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_337 = ((io_writeEn_1 && prevValuReadEn_1_4) && (io_writeAddr_1 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_338 = ((io_writeEn_2 && prevValuReadEn_1_4) && (io_writeAddr_2 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_339 = ((io_writeEn_3 && prevValuReadEn_1_4) && (io_writeAddr_3 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_340 = ((io_writeEn_4 && prevValuReadEn_1_4) && (io_writeAddr_4 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_341 = ((io_writeEn_5 && prevValuReadEn_1_4) && (io_writeAddr_5 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_342 = ((io_writeEn_6 && prevValuReadEn_1_4) && (io_writeAddr_6 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_343 = ((io_writeEn_7 && prevValuReadEn_1_4) && (io_writeAddr_7 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_344 = ((io_writeEn_8 && prevValuReadEn_1_4) && (io_writeAddr_8 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_345 = ((io_writeEn_9 && prevValuReadEn_1_4) && (io_writeAddr_9 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_346 = ((io_writeEn_10 && prevValuReadEn_1_4) && (io_writeAddr_10 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_347 = ((io_writeEn_11 && prevValuReadEn_1_4) && (io_writeAddr_11 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_348 = ((io_writeEn_12 && prevValuReadEn_1_4) && (io_writeAddr_12 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_349 = ((io_writeEn_13 && prevValuReadEn_1_4) && (io_writeAddr_13 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_350 = ((io_writeEn_14 && prevValuReadEn_1_4) && (io_writeAddr_14 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_351 = ((io_writeEn_15 && prevValuReadEn_1_4) && (io_writeAddr_15 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_352 = ((io_writeEn_16 && prevValuReadEn_1_4) && (io_writeAddr_16 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_353 = ((io_writeEn_17 && prevValuReadEn_1_4) && (io_writeAddr_17 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_354 = ((io_writeEn_18 && prevValuReadEn_1_4) && (io_writeAddr_18 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_355 = ((io_writeEn_19 && prevValuReadEn_1_4) && (io_writeAddr_19 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_356 = ((io_writeEn_20 && prevValuReadEn_1_4) && (io_writeAddr_20 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_357 = ((io_writeEn_21 && prevValuReadEn_1_4) && (io_writeAddr_21 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_358 = ((io_writeEn_22 && prevValuReadEn_1_4) && (io_writeAddr_22 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_359 = ((io_writeEn_23 && prevValuReadEn_1_4) && (io_writeAddr_23 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_360 = ((io_writeEn_24 && prevValuReadEn_1_4) && (io_writeAddr_24 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_361 = ((io_writeEn_25 && prevValuReadEn_1_4) && (io_writeAddr_25 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_362 = ((io_writeEn_26 && prevValuReadEn_1_4) && (io_writeAddr_26 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_363 = ((io_writeEn_27 && prevValuReadEn_1_4) && (io_writeAddr_27 == prevValuReadAddr_1_4));
  assign when_BankedScratchMemory_l448_364 = ((io_writeEn_0 && prevValuReadEn_1_5) && (io_writeAddr_0 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_365 = ((io_writeEn_1 && prevValuReadEn_1_5) && (io_writeAddr_1 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_366 = ((io_writeEn_2 && prevValuReadEn_1_5) && (io_writeAddr_2 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_367 = ((io_writeEn_3 && prevValuReadEn_1_5) && (io_writeAddr_3 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_368 = ((io_writeEn_4 && prevValuReadEn_1_5) && (io_writeAddr_4 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_369 = ((io_writeEn_5 && prevValuReadEn_1_5) && (io_writeAddr_5 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_370 = ((io_writeEn_6 && prevValuReadEn_1_5) && (io_writeAddr_6 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_371 = ((io_writeEn_7 && prevValuReadEn_1_5) && (io_writeAddr_7 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_372 = ((io_writeEn_8 && prevValuReadEn_1_5) && (io_writeAddr_8 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_373 = ((io_writeEn_9 && prevValuReadEn_1_5) && (io_writeAddr_9 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_374 = ((io_writeEn_10 && prevValuReadEn_1_5) && (io_writeAddr_10 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_375 = ((io_writeEn_11 && prevValuReadEn_1_5) && (io_writeAddr_11 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_376 = ((io_writeEn_12 && prevValuReadEn_1_5) && (io_writeAddr_12 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_377 = ((io_writeEn_13 && prevValuReadEn_1_5) && (io_writeAddr_13 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_378 = ((io_writeEn_14 && prevValuReadEn_1_5) && (io_writeAddr_14 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_379 = ((io_writeEn_15 && prevValuReadEn_1_5) && (io_writeAddr_15 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_380 = ((io_writeEn_16 && prevValuReadEn_1_5) && (io_writeAddr_16 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_381 = ((io_writeEn_17 && prevValuReadEn_1_5) && (io_writeAddr_17 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_382 = ((io_writeEn_18 && prevValuReadEn_1_5) && (io_writeAddr_18 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_383 = ((io_writeEn_19 && prevValuReadEn_1_5) && (io_writeAddr_19 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_384 = ((io_writeEn_20 && prevValuReadEn_1_5) && (io_writeAddr_20 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_385 = ((io_writeEn_21 && prevValuReadEn_1_5) && (io_writeAddr_21 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_386 = ((io_writeEn_22 && prevValuReadEn_1_5) && (io_writeAddr_22 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_387 = ((io_writeEn_23 && prevValuReadEn_1_5) && (io_writeAddr_23 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_388 = ((io_writeEn_24 && prevValuReadEn_1_5) && (io_writeAddr_24 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_389 = ((io_writeEn_25 && prevValuReadEn_1_5) && (io_writeAddr_25 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_390 = ((io_writeEn_26 && prevValuReadEn_1_5) && (io_writeAddr_26 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_391 = ((io_writeEn_27 && prevValuReadEn_1_5) && (io_writeAddr_27 == prevValuReadAddr_1_5));
  assign when_BankedScratchMemory_l448_392 = ((io_writeEn_0 && prevValuReadEn_1_6) && (io_writeAddr_0 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_393 = ((io_writeEn_1 && prevValuReadEn_1_6) && (io_writeAddr_1 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_394 = ((io_writeEn_2 && prevValuReadEn_1_6) && (io_writeAddr_2 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_395 = ((io_writeEn_3 && prevValuReadEn_1_6) && (io_writeAddr_3 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_396 = ((io_writeEn_4 && prevValuReadEn_1_6) && (io_writeAddr_4 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_397 = ((io_writeEn_5 && prevValuReadEn_1_6) && (io_writeAddr_5 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_398 = ((io_writeEn_6 && prevValuReadEn_1_6) && (io_writeAddr_6 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_399 = ((io_writeEn_7 && prevValuReadEn_1_6) && (io_writeAddr_7 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_400 = ((io_writeEn_8 && prevValuReadEn_1_6) && (io_writeAddr_8 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_401 = ((io_writeEn_9 && prevValuReadEn_1_6) && (io_writeAddr_9 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_402 = ((io_writeEn_10 && prevValuReadEn_1_6) && (io_writeAddr_10 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_403 = ((io_writeEn_11 && prevValuReadEn_1_6) && (io_writeAddr_11 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_404 = ((io_writeEn_12 && prevValuReadEn_1_6) && (io_writeAddr_12 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_405 = ((io_writeEn_13 && prevValuReadEn_1_6) && (io_writeAddr_13 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_406 = ((io_writeEn_14 && prevValuReadEn_1_6) && (io_writeAddr_14 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_407 = ((io_writeEn_15 && prevValuReadEn_1_6) && (io_writeAddr_15 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_408 = ((io_writeEn_16 && prevValuReadEn_1_6) && (io_writeAddr_16 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_409 = ((io_writeEn_17 && prevValuReadEn_1_6) && (io_writeAddr_17 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_410 = ((io_writeEn_18 && prevValuReadEn_1_6) && (io_writeAddr_18 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_411 = ((io_writeEn_19 && prevValuReadEn_1_6) && (io_writeAddr_19 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_412 = ((io_writeEn_20 && prevValuReadEn_1_6) && (io_writeAddr_20 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_413 = ((io_writeEn_21 && prevValuReadEn_1_6) && (io_writeAddr_21 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_414 = ((io_writeEn_22 && prevValuReadEn_1_6) && (io_writeAddr_22 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_415 = ((io_writeEn_23 && prevValuReadEn_1_6) && (io_writeAddr_23 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_416 = ((io_writeEn_24 && prevValuReadEn_1_6) && (io_writeAddr_24 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_417 = ((io_writeEn_25 && prevValuReadEn_1_6) && (io_writeAddr_25 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_418 = ((io_writeEn_26 && prevValuReadEn_1_6) && (io_writeAddr_26 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_419 = ((io_writeEn_27 && prevValuReadEn_1_6) && (io_writeAddr_27 == prevValuReadAddr_1_6));
  assign when_BankedScratchMemory_l448_420 = ((io_writeEn_0 && prevValuReadEn_1_7) && (io_writeAddr_0 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_421 = ((io_writeEn_1 && prevValuReadEn_1_7) && (io_writeAddr_1 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_422 = ((io_writeEn_2 && prevValuReadEn_1_7) && (io_writeAddr_2 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_423 = ((io_writeEn_3 && prevValuReadEn_1_7) && (io_writeAddr_3 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_424 = ((io_writeEn_4 && prevValuReadEn_1_7) && (io_writeAddr_4 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_425 = ((io_writeEn_5 && prevValuReadEn_1_7) && (io_writeAddr_5 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_426 = ((io_writeEn_6 && prevValuReadEn_1_7) && (io_writeAddr_6 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_427 = ((io_writeEn_7 && prevValuReadEn_1_7) && (io_writeAddr_7 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_428 = ((io_writeEn_8 && prevValuReadEn_1_7) && (io_writeAddr_8 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_429 = ((io_writeEn_9 && prevValuReadEn_1_7) && (io_writeAddr_9 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_430 = ((io_writeEn_10 && prevValuReadEn_1_7) && (io_writeAddr_10 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_431 = ((io_writeEn_11 && prevValuReadEn_1_7) && (io_writeAddr_11 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_432 = ((io_writeEn_12 && prevValuReadEn_1_7) && (io_writeAddr_12 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_433 = ((io_writeEn_13 && prevValuReadEn_1_7) && (io_writeAddr_13 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_434 = ((io_writeEn_14 && prevValuReadEn_1_7) && (io_writeAddr_14 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_435 = ((io_writeEn_15 && prevValuReadEn_1_7) && (io_writeAddr_15 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_436 = ((io_writeEn_16 && prevValuReadEn_1_7) && (io_writeAddr_16 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_437 = ((io_writeEn_17 && prevValuReadEn_1_7) && (io_writeAddr_17 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_438 = ((io_writeEn_18 && prevValuReadEn_1_7) && (io_writeAddr_18 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_439 = ((io_writeEn_19 && prevValuReadEn_1_7) && (io_writeAddr_19 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_440 = ((io_writeEn_20 && prevValuReadEn_1_7) && (io_writeAddr_20 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_441 = ((io_writeEn_21 && prevValuReadEn_1_7) && (io_writeAddr_21 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_442 = ((io_writeEn_22 && prevValuReadEn_1_7) && (io_writeAddr_22 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_443 = ((io_writeEn_23 && prevValuReadEn_1_7) && (io_writeAddr_23 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_444 = ((io_writeEn_24 && prevValuReadEn_1_7) && (io_writeAddr_24 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_445 = ((io_writeEn_25 && prevValuReadEn_1_7) && (io_writeAddr_25 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_446 = ((io_writeEn_26 && prevValuReadEn_1_7) && (io_writeAddr_26 == prevValuReadAddr_1_7));
  assign when_BankedScratchMemory_l448_447 = ((io_writeEn_27 && prevValuReadEn_1_7) && (io_writeAddr_27 == prevValuReadAddr_1_7));
  always @(posedge clk) begin
    if(reset) begin
      scalarBankReqReg_0 <= 3'b000;
      scalarBankReqReg_1 <= 3'b000;
      scalarBankReqReg_2 <= 3'b000;
      scalarBankReqReg_3 <= 3'b000;
      scalarBankReqReg_4 <= 3'b000;
      scalarBankReqReg_5 <= 3'b000;
      scalarBankReqReg_6 <= 3'b000;
      scalarBankReqReg_7 <= 3'b000;
      scalarBankReqReg_8 <= 3'b000;
      scalarUsedPortBReg_0 <= 1'b0;
      scalarUsedPortBReg_1 <= 1'b0;
      scalarUsedPortBReg_2 <= 1'b0;
      scalarUsedPortBReg_3 <= 1'b0;
      scalarUsedPortBReg_4 <= 1'b0;
      scalarUsedPortBReg_5 <= 1'b0;
      scalarUsedPortBReg_6 <= 1'b0;
      scalarUsedPortBReg_7 <= 1'b0;
      scalarUsedPortBReg_8 <= 1'b0;
      _zz_when_BankedScratchMemory_l308 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_1 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_2 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_3 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_4 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_5 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_6 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_7 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_8 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_9 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_10 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_11 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_12 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_13 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_14 <= 3'b000;
      _zz_when_BankedScratchMemory_l308_15 <= 3'b000;
      fwdGap2Valid_0 <= 1'b0;
      fwdGap2Valid_1 <= 1'b0;
      fwdGap2Valid_2 <= 1'b0;
      fwdGap2Valid_3 <= 1'b0;
      fwdGap2Valid_4 <= 1'b0;
      fwdGap2Valid_5 <= 1'b0;
      fwdGap2Valid_6 <= 1'b0;
      fwdGap2Valid_7 <= 1'b0;
      fwdGap2Valid_8 <= 1'b0;
      prevScalarReadEn_0 <= 1'b0;
      prevScalarReadEn_1 <= 1'b0;
      prevScalarReadEn_2 <= 1'b0;
      prevScalarReadEn_3 <= 1'b0;
      prevScalarReadEn_4 <= 1'b0;
      prevScalarReadEn_5 <= 1'b0;
      prevScalarReadEn_6 <= 1'b0;
      prevScalarReadEn_7 <= 1'b0;
      prevScalarReadEn_8 <= 1'b0;
      prevScalarReadAddr_0 <= 11'h0;
      prevScalarReadAddr_1 <= 11'h0;
      prevScalarReadAddr_2 <= 11'h0;
      prevScalarReadAddr_3 <= 11'h0;
      prevScalarReadAddr_4 <= 11'h0;
      prevScalarReadAddr_5 <= 11'h0;
      prevScalarReadAddr_6 <= 11'h0;
      prevScalarReadAddr_7 <= 11'h0;
      prevScalarReadAddr_8 <= 11'h0;
      fwdValuGap2Valid_0_0 <= 1'b0;
      fwdValuGap2Valid_0_1 <= 1'b0;
      fwdValuGap2Valid_0_2 <= 1'b0;
      fwdValuGap2Valid_0_3 <= 1'b0;
      fwdValuGap2Valid_0_4 <= 1'b0;
      fwdValuGap2Valid_0_5 <= 1'b0;
      fwdValuGap2Valid_0_6 <= 1'b0;
      fwdValuGap2Valid_0_7 <= 1'b0;
      fwdValuGap2Valid_1_0 <= 1'b0;
      fwdValuGap2Valid_1_1 <= 1'b0;
      fwdValuGap2Valid_1_2 <= 1'b0;
      fwdValuGap2Valid_1_3 <= 1'b0;
      fwdValuGap2Valid_1_4 <= 1'b0;
      fwdValuGap2Valid_1_5 <= 1'b0;
      fwdValuGap2Valid_1_6 <= 1'b0;
      fwdValuGap2Valid_1_7 <= 1'b0;
      prevValuReadEn_0_0 <= 1'b0;
      prevValuReadEn_0_1 <= 1'b0;
      prevValuReadEn_0_2 <= 1'b0;
      prevValuReadEn_0_3 <= 1'b0;
      prevValuReadEn_0_4 <= 1'b0;
      prevValuReadEn_0_5 <= 1'b0;
      prevValuReadEn_0_6 <= 1'b0;
      prevValuReadEn_0_7 <= 1'b0;
      prevValuReadEn_1_0 <= 1'b0;
      prevValuReadEn_1_1 <= 1'b0;
      prevValuReadEn_1_2 <= 1'b0;
      prevValuReadEn_1_3 <= 1'b0;
      prevValuReadEn_1_4 <= 1'b0;
      prevValuReadEn_1_5 <= 1'b0;
      prevValuReadEn_1_6 <= 1'b0;
      prevValuReadEn_1_7 <= 1'b0;
      prevValuReadAddr_0_0 <= 11'h0;
      prevValuReadAddr_0_1 <= 11'h0;
      prevValuReadAddr_0_2 <= 11'h0;
      prevValuReadAddr_0_3 <= 11'h0;
      prevValuReadAddr_0_4 <= 11'h0;
      prevValuReadAddr_0_5 <= 11'h0;
      prevValuReadAddr_0_6 <= 11'h0;
      prevValuReadAddr_0_7 <= 11'h0;
      prevValuReadAddr_1_0 <= 11'h0;
      prevValuReadAddr_1_1 <= 11'h0;
      prevValuReadAddr_1_2 <= 11'h0;
      prevValuReadAddr_1_3 <= 11'h0;
      prevValuReadAddr_1_4 <= 11'h0;
      prevValuReadAddr_1_5 <= 11'h0;
      prevValuReadAddr_1_6 <= 11'h0;
      prevValuReadAddr_1_7 <= 11'h0;
    end else begin
      scalarBankReqReg_0 <= scalarBankReq_0;
      scalarUsedPortBReg_0 <= scalarUsedPortB_0;
      scalarBankReqReg_1 <= scalarBankReq_1;
      scalarUsedPortBReg_1 <= scalarUsedPortB_1;
      scalarBankReqReg_2 <= scalarBankReq_2;
      scalarUsedPortBReg_2 <= scalarUsedPortB_2;
      scalarBankReqReg_3 <= scalarBankReq_3;
      scalarUsedPortBReg_3 <= scalarUsedPortB_3;
      scalarBankReqReg_4 <= scalarBankReq_4;
      scalarUsedPortBReg_4 <= scalarUsedPortB_4;
      scalarBankReqReg_5 <= scalarBankReq_5;
      scalarUsedPortBReg_5 <= scalarUsedPortB_5;
      scalarBankReqReg_6 <= scalarBankReq_6;
      scalarUsedPortBReg_6 <= scalarUsedPortB_6;
      scalarBankReqReg_7 <= scalarBankReq_7;
      scalarUsedPortBReg_7 <= scalarUsedPortB_7;
      scalarBankReqReg_8 <= scalarBankReq_8;
      scalarUsedPortBReg_8 <= scalarUsedPortB_8;
      _zz_when_BankedScratchMemory_l308 <= _zz_when_BankedScratchMemory_l286;
      _zz_when_BankedScratchMemory_l308_1 <= _zz_when_BankedScratchMemory_l286_1;
      _zz_when_BankedScratchMemory_l308_2 <= _zz_when_BankedScratchMemory_l286_2;
      _zz_when_BankedScratchMemory_l308_3 <= _zz_when_BankedScratchMemory_l286_3;
      _zz_when_BankedScratchMemory_l308_4 <= _zz_when_BankedScratchMemory_l286_4;
      _zz_when_BankedScratchMemory_l308_5 <= _zz_when_BankedScratchMemory_l286_5;
      _zz_when_BankedScratchMemory_l308_6 <= _zz_when_BankedScratchMemory_l286_6;
      _zz_when_BankedScratchMemory_l308_7 <= _zz_when_BankedScratchMemory_l286_7;
      _zz_when_BankedScratchMemory_l308_8 <= _zz_when_BankedScratchMemory_l286_8;
      _zz_when_BankedScratchMemory_l308_9 <= _zz_when_BankedScratchMemory_l286_9;
      _zz_when_BankedScratchMemory_l308_10 <= _zz_when_BankedScratchMemory_l286_10;
      _zz_when_BankedScratchMemory_l308_11 <= _zz_when_BankedScratchMemory_l286_11;
      _zz_when_BankedScratchMemory_l308_12 <= _zz_when_BankedScratchMemory_l286_12;
      _zz_when_BankedScratchMemory_l308_13 <= _zz_when_BankedScratchMemory_l286_13;
      _zz_when_BankedScratchMemory_l308_14 <= _zz_when_BankedScratchMemory_l286_14;
      _zz_when_BankedScratchMemory_l308_15 <= _zz_when_BankedScratchMemory_l286_15;
      fwdGap2Valid_0 <= ((((((((((((((((_zz_fwdGap2Valid_0 || when_BankedScratchMemory_l360_12) || when_BankedScratchMemory_l360_13) || when_BankedScratchMemory_l360_14) || when_BankedScratchMemory_l360_15) || when_BankedScratchMemory_l360_16) || when_BankedScratchMemory_l360_17) || when_BankedScratchMemory_l360_18) || when_BankedScratchMemory_l360_19) || when_BankedScratchMemory_l360_20) || when_BankedScratchMemory_l360_21) || when_BankedScratchMemory_l360_22) || when_BankedScratchMemory_l360_23) || when_BankedScratchMemory_l360_24) || when_BankedScratchMemory_l360_25) || when_BankedScratchMemory_l360_26) || when_BankedScratchMemory_l360_27);
      fwdGap2Valid_1 <= ((((((((((((((((_zz_fwdGap2Valid_1 || when_BankedScratchMemory_l360_40) || when_BankedScratchMemory_l360_41) || when_BankedScratchMemory_l360_42) || when_BankedScratchMemory_l360_43) || when_BankedScratchMemory_l360_44) || when_BankedScratchMemory_l360_45) || when_BankedScratchMemory_l360_46) || when_BankedScratchMemory_l360_47) || when_BankedScratchMemory_l360_48) || when_BankedScratchMemory_l360_49) || when_BankedScratchMemory_l360_50) || when_BankedScratchMemory_l360_51) || when_BankedScratchMemory_l360_52) || when_BankedScratchMemory_l360_53) || when_BankedScratchMemory_l360_54) || when_BankedScratchMemory_l360_55);
      fwdGap2Valid_2 <= ((((((((((((((((_zz_fwdGap2Valid_2 || when_BankedScratchMemory_l360_68) || when_BankedScratchMemory_l360_69) || when_BankedScratchMemory_l360_70) || when_BankedScratchMemory_l360_71) || when_BankedScratchMemory_l360_72) || when_BankedScratchMemory_l360_73) || when_BankedScratchMemory_l360_74) || when_BankedScratchMemory_l360_75) || when_BankedScratchMemory_l360_76) || when_BankedScratchMemory_l360_77) || when_BankedScratchMemory_l360_78) || when_BankedScratchMemory_l360_79) || when_BankedScratchMemory_l360_80) || when_BankedScratchMemory_l360_81) || when_BankedScratchMemory_l360_82) || when_BankedScratchMemory_l360_83);
      fwdGap2Valid_3 <= ((((((((((((((((_zz_fwdGap2Valid_3 || when_BankedScratchMemory_l360_96) || when_BankedScratchMemory_l360_97) || when_BankedScratchMemory_l360_98) || when_BankedScratchMemory_l360_99) || when_BankedScratchMemory_l360_100) || when_BankedScratchMemory_l360_101) || when_BankedScratchMemory_l360_102) || when_BankedScratchMemory_l360_103) || when_BankedScratchMemory_l360_104) || when_BankedScratchMemory_l360_105) || when_BankedScratchMemory_l360_106) || when_BankedScratchMemory_l360_107) || when_BankedScratchMemory_l360_108) || when_BankedScratchMemory_l360_109) || when_BankedScratchMemory_l360_110) || when_BankedScratchMemory_l360_111);
      fwdGap2Valid_4 <= ((((((((((((((((_zz_fwdGap2Valid_4 || when_BankedScratchMemory_l360_124) || when_BankedScratchMemory_l360_125) || when_BankedScratchMemory_l360_126) || when_BankedScratchMemory_l360_127) || when_BankedScratchMemory_l360_128) || when_BankedScratchMemory_l360_129) || when_BankedScratchMemory_l360_130) || when_BankedScratchMemory_l360_131) || when_BankedScratchMemory_l360_132) || when_BankedScratchMemory_l360_133) || when_BankedScratchMemory_l360_134) || when_BankedScratchMemory_l360_135) || when_BankedScratchMemory_l360_136) || when_BankedScratchMemory_l360_137) || when_BankedScratchMemory_l360_138) || when_BankedScratchMemory_l360_139);
      fwdGap2Valid_5 <= ((((((((((((((((_zz_fwdGap2Valid_5 || when_BankedScratchMemory_l360_152) || when_BankedScratchMemory_l360_153) || when_BankedScratchMemory_l360_154) || when_BankedScratchMemory_l360_155) || when_BankedScratchMemory_l360_156) || when_BankedScratchMemory_l360_157) || when_BankedScratchMemory_l360_158) || when_BankedScratchMemory_l360_159) || when_BankedScratchMemory_l360_160) || when_BankedScratchMemory_l360_161) || when_BankedScratchMemory_l360_162) || when_BankedScratchMemory_l360_163) || when_BankedScratchMemory_l360_164) || when_BankedScratchMemory_l360_165) || when_BankedScratchMemory_l360_166) || when_BankedScratchMemory_l360_167);
      fwdGap2Valid_6 <= ((((((((((((((((_zz_fwdGap2Valid_6 || when_BankedScratchMemory_l360_180) || when_BankedScratchMemory_l360_181) || when_BankedScratchMemory_l360_182) || when_BankedScratchMemory_l360_183) || when_BankedScratchMemory_l360_184) || when_BankedScratchMemory_l360_185) || when_BankedScratchMemory_l360_186) || when_BankedScratchMemory_l360_187) || when_BankedScratchMemory_l360_188) || when_BankedScratchMemory_l360_189) || when_BankedScratchMemory_l360_190) || when_BankedScratchMemory_l360_191) || when_BankedScratchMemory_l360_192) || when_BankedScratchMemory_l360_193) || when_BankedScratchMemory_l360_194) || when_BankedScratchMemory_l360_195);
      fwdGap2Valid_7 <= ((((((((((((((((_zz_fwdGap2Valid_7 || when_BankedScratchMemory_l360_208) || when_BankedScratchMemory_l360_209) || when_BankedScratchMemory_l360_210) || when_BankedScratchMemory_l360_211) || when_BankedScratchMemory_l360_212) || when_BankedScratchMemory_l360_213) || when_BankedScratchMemory_l360_214) || when_BankedScratchMemory_l360_215) || when_BankedScratchMemory_l360_216) || when_BankedScratchMemory_l360_217) || when_BankedScratchMemory_l360_218) || when_BankedScratchMemory_l360_219) || when_BankedScratchMemory_l360_220) || when_BankedScratchMemory_l360_221) || when_BankedScratchMemory_l360_222) || when_BankedScratchMemory_l360_223);
      fwdGap2Valid_8 <= ((((((((((((((((_zz_fwdGap2Valid_8 || when_BankedScratchMemory_l360_236) || when_BankedScratchMemory_l360_237) || when_BankedScratchMemory_l360_238) || when_BankedScratchMemory_l360_239) || when_BankedScratchMemory_l360_240) || when_BankedScratchMemory_l360_241) || when_BankedScratchMemory_l360_242) || when_BankedScratchMemory_l360_243) || when_BankedScratchMemory_l360_244) || when_BankedScratchMemory_l360_245) || when_BankedScratchMemory_l360_246) || when_BankedScratchMemory_l360_247) || when_BankedScratchMemory_l360_248) || when_BankedScratchMemory_l360_249) || when_BankedScratchMemory_l360_250) || when_BankedScratchMemory_l360_251);
      prevScalarReadEn_0 <= io_scalarReadEn_0;
      prevScalarReadAddr_0 <= io_scalarReadAddr_0;
      prevScalarReadEn_1 <= io_scalarReadEn_1;
      prevScalarReadAddr_1 <= io_scalarReadAddr_1;
      prevScalarReadEn_2 <= io_scalarReadEn_2;
      prevScalarReadAddr_2 <= io_scalarReadAddr_2;
      prevScalarReadEn_3 <= io_scalarReadEn_3;
      prevScalarReadAddr_3 <= io_scalarReadAddr_3;
      prevScalarReadEn_4 <= io_scalarReadEn_4;
      prevScalarReadAddr_4 <= io_scalarReadAddr_4;
      prevScalarReadEn_5 <= io_scalarReadEn_5;
      prevScalarReadAddr_5 <= io_scalarReadAddr_5;
      prevScalarReadEn_6 <= io_scalarReadEn_6;
      prevScalarReadAddr_6 <= io_scalarReadAddr_6;
      prevScalarReadEn_7 <= io_scalarReadEn_7;
      prevScalarReadAddr_7 <= io_scalarReadAddr_7;
      prevScalarReadEn_8 <= io_scalarReadEn_8;
      prevScalarReadAddr_8 <= io_scalarReadAddr_8;
      fwdValuGap2Valid_0_0 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_0 || when_BankedScratchMemory_l412_12) || when_BankedScratchMemory_l412_13) || when_BankedScratchMemory_l412_14) || when_BankedScratchMemory_l412_15) || when_BankedScratchMemory_l412_16) || when_BankedScratchMemory_l412_17) || when_BankedScratchMemory_l412_18) || when_BankedScratchMemory_l412_19) || when_BankedScratchMemory_l412_20) || when_BankedScratchMemory_l412_21) || when_BankedScratchMemory_l412_22) || when_BankedScratchMemory_l412_23) || when_BankedScratchMemory_l412_24) || when_BankedScratchMemory_l412_25) || when_BankedScratchMemory_l412_26) || when_BankedScratchMemory_l412_27);
      fwdValuGap2Valid_0_1 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_1 || when_BankedScratchMemory_l412_40) || when_BankedScratchMemory_l412_41) || when_BankedScratchMemory_l412_42) || when_BankedScratchMemory_l412_43) || when_BankedScratchMemory_l412_44) || when_BankedScratchMemory_l412_45) || when_BankedScratchMemory_l412_46) || when_BankedScratchMemory_l412_47) || when_BankedScratchMemory_l412_48) || when_BankedScratchMemory_l412_49) || when_BankedScratchMemory_l412_50) || when_BankedScratchMemory_l412_51) || when_BankedScratchMemory_l412_52) || when_BankedScratchMemory_l412_53) || when_BankedScratchMemory_l412_54) || when_BankedScratchMemory_l412_55);
      fwdValuGap2Valid_0_2 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_2 || when_BankedScratchMemory_l412_68) || when_BankedScratchMemory_l412_69) || when_BankedScratchMemory_l412_70) || when_BankedScratchMemory_l412_71) || when_BankedScratchMemory_l412_72) || when_BankedScratchMemory_l412_73) || when_BankedScratchMemory_l412_74) || when_BankedScratchMemory_l412_75) || when_BankedScratchMemory_l412_76) || when_BankedScratchMemory_l412_77) || when_BankedScratchMemory_l412_78) || when_BankedScratchMemory_l412_79) || when_BankedScratchMemory_l412_80) || when_BankedScratchMemory_l412_81) || when_BankedScratchMemory_l412_82) || when_BankedScratchMemory_l412_83);
      fwdValuGap2Valid_0_3 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_3 || when_BankedScratchMemory_l412_96) || when_BankedScratchMemory_l412_97) || when_BankedScratchMemory_l412_98) || when_BankedScratchMemory_l412_99) || when_BankedScratchMemory_l412_100) || when_BankedScratchMemory_l412_101) || when_BankedScratchMemory_l412_102) || when_BankedScratchMemory_l412_103) || when_BankedScratchMemory_l412_104) || when_BankedScratchMemory_l412_105) || when_BankedScratchMemory_l412_106) || when_BankedScratchMemory_l412_107) || when_BankedScratchMemory_l412_108) || when_BankedScratchMemory_l412_109) || when_BankedScratchMemory_l412_110) || when_BankedScratchMemory_l412_111);
      fwdValuGap2Valid_0_4 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_4 || when_BankedScratchMemory_l412_124) || when_BankedScratchMemory_l412_125) || when_BankedScratchMemory_l412_126) || when_BankedScratchMemory_l412_127) || when_BankedScratchMemory_l412_128) || when_BankedScratchMemory_l412_129) || when_BankedScratchMemory_l412_130) || when_BankedScratchMemory_l412_131) || when_BankedScratchMemory_l412_132) || when_BankedScratchMemory_l412_133) || when_BankedScratchMemory_l412_134) || when_BankedScratchMemory_l412_135) || when_BankedScratchMemory_l412_136) || when_BankedScratchMemory_l412_137) || when_BankedScratchMemory_l412_138) || when_BankedScratchMemory_l412_139);
      fwdValuGap2Valid_0_5 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_5 || when_BankedScratchMemory_l412_152) || when_BankedScratchMemory_l412_153) || when_BankedScratchMemory_l412_154) || when_BankedScratchMemory_l412_155) || when_BankedScratchMemory_l412_156) || when_BankedScratchMemory_l412_157) || when_BankedScratchMemory_l412_158) || when_BankedScratchMemory_l412_159) || when_BankedScratchMemory_l412_160) || when_BankedScratchMemory_l412_161) || when_BankedScratchMemory_l412_162) || when_BankedScratchMemory_l412_163) || when_BankedScratchMemory_l412_164) || when_BankedScratchMemory_l412_165) || when_BankedScratchMemory_l412_166) || when_BankedScratchMemory_l412_167);
      fwdValuGap2Valid_0_6 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_6 || when_BankedScratchMemory_l412_180) || when_BankedScratchMemory_l412_181) || when_BankedScratchMemory_l412_182) || when_BankedScratchMemory_l412_183) || when_BankedScratchMemory_l412_184) || when_BankedScratchMemory_l412_185) || when_BankedScratchMemory_l412_186) || when_BankedScratchMemory_l412_187) || when_BankedScratchMemory_l412_188) || when_BankedScratchMemory_l412_189) || when_BankedScratchMemory_l412_190) || when_BankedScratchMemory_l412_191) || when_BankedScratchMemory_l412_192) || when_BankedScratchMemory_l412_193) || when_BankedScratchMemory_l412_194) || when_BankedScratchMemory_l412_195);
      fwdValuGap2Valid_0_7 <= ((((((((((((((((_zz_fwdValuGap2Valid_0_7 || when_BankedScratchMemory_l412_208) || when_BankedScratchMemory_l412_209) || when_BankedScratchMemory_l412_210) || when_BankedScratchMemory_l412_211) || when_BankedScratchMemory_l412_212) || when_BankedScratchMemory_l412_213) || when_BankedScratchMemory_l412_214) || when_BankedScratchMemory_l412_215) || when_BankedScratchMemory_l412_216) || when_BankedScratchMemory_l412_217) || when_BankedScratchMemory_l412_218) || when_BankedScratchMemory_l412_219) || when_BankedScratchMemory_l412_220) || when_BankedScratchMemory_l412_221) || when_BankedScratchMemory_l412_222) || when_BankedScratchMemory_l412_223);
      fwdValuGap2Valid_1_0 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_0 || when_BankedScratchMemory_l412_236) || when_BankedScratchMemory_l412_237) || when_BankedScratchMemory_l412_238) || when_BankedScratchMemory_l412_239) || when_BankedScratchMemory_l412_240) || when_BankedScratchMemory_l412_241) || when_BankedScratchMemory_l412_242) || when_BankedScratchMemory_l412_243) || when_BankedScratchMemory_l412_244) || when_BankedScratchMemory_l412_245) || when_BankedScratchMemory_l412_246) || when_BankedScratchMemory_l412_247) || when_BankedScratchMemory_l412_248) || when_BankedScratchMemory_l412_249) || when_BankedScratchMemory_l412_250) || when_BankedScratchMemory_l412_251);
      fwdValuGap2Valid_1_1 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_1 || when_BankedScratchMemory_l412_264) || when_BankedScratchMemory_l412_265) || when_BankedScratchMemory_l412_266) || when_BankedScratchMemory_l412_267) || when_BankedScratchMemory_l412_268) || when_BankedScratchMemory_l412_269) || when_BankedScratchMemory_l412_270) || when_BankedScratchMemory_l412_271) || when_BankedScratchMemory_l412_272) || when_BankedScratchMemory_l412_273) || when_BankedScratchMemory_l412_274) || when_BankedScratchMemory_l412_275) || when_BankedScratchMemory_l412_276) || when_BankedScratchMemory_l412_277) || when_BankedScratchMemory_l412_278) || when_BankedScratchMemory_l412_279);
      fwdValuGap2Valid_1_2 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_2 || when_BankedScratchMemory_l412_292) || when_BankedScratchMemory_l412_293) || when_BankedScratchMemory_l412_294) || when_BankedScratchMemory_l412_295) || when_BankedScratchMemory_l412_296) || when_BankedScratchMemory_l412_297) || when_BankedScratchMemory_l412_298) || when_BankedScratchMemory_l412_299) || when_BankedScratchMemory_l412_300) || when_BankedScratchMemory_l412_301) || when_BankedScratchMemory_l412_302) || when_BankedScratchMemory_l412_303) || when_BankedScratchMemory_l412_304) || when_BankedScratchMemory_l412_305) || when_BankedScratchMemory_l412_306) || when_BankedScratchMemory_l412_307);
      fwdValuGap2Valid_1_3 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_3 || when_BankedScratchMemory_l412_320) || when_BankedScratchMemory_l412_321) || when_BankedScratchMemory_l412_322) || when_BankedScratchMemory_l412_323) || when_BankedScratchMemory_l412_324) || when_BankedScratchMemory_l412_325) || when_BankedScratchMemory_l412_326) || when_BankedScratchMemory_l412_327) || when_BankedScratchMemory_l412_328) || when_BankedScratchMemory_l412_329) || when_BankedScratchMemory_l412_330) || when_BankedScratchMemory_l412_331) || when_BankedScratchMemory_l412_332) || when_BankedScratchMemory_l412_333) || when_BankedScratchMemory_l412_334) || when_BankedScratchMemory_l412_335);
      fwdValuGap2Valid_1_4 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_4 || when_BankedScratchMemory_l412_348) || when_BankedScratchMemory_l412_349) || when_BankedScratchMemory_l412_350) || when_BankedScratchMemory_l412_351) || when_BankedScratchMemory_l412_352) || when_BankedScratchMemory_l412_353) || when_BankedScratchMemory_l412_354) || when_BankedScratchMemory_l412_355) || when_BankedScratchMemory_l412_356) || when_BankedScratchMemory_l412_357) || when_BankedScratchMemory_l412_358) || when_BankedScratchMemory_l412_359) || when_BankedScratchMemory_l412_360) || when_BankedScratchMemory_l412_361) || when_BankedScratchMemory_l412_362) || when_BankedScratchMemory_l412_363);
      fwdValuGap2Valid_1_5 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_5 || when_BankedScratchMemory_l412_376) || when_BankedScratchMemory_l412_377) || when_BankedScratchMemory_l412_378) || when_BankedScratchMemory_l412_379) || when_BankedScratchMemory_l412_380) || when_BankedScratchMemory_l412_381) || when_BankedScratchMemory_l412_382) || when_BankedScratchMemory_l412_383) || when_BankedScratchMemory_l412_384) || when_BankedScratchMemory_l412_385) || when_BankedScratchMemory_l412_386) || when_BankedScratchMemory_l412_387) || when_BankedScratchMemory_l412_388) || when_BankedScratchMemory_l412_389) || when_BankedScratchMemory_l412_390) || when_BankedScratchMemory_l412_391);
      fwdValuGap2Valid_1_6 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_6 || when_BankedScratchMemory_l412_404) || when_BankedScratchMemory_l412_405) || when_BankedScratchMemory_l412_406) || when_BankedScratchMemory_l412_407) || when_BankedScratchMemory_l412_408) || when_BankedScratchMemory_l412_409) || when_BankedScratchMemory_l412_410) || when_BankedScratchMemory_l412_411) || when_BankedScratchMemory_l412_412) || when_BankedScratchMemory_l412_413) || when_BankedScratchMemory_l412_414) || when_BankedScratchMemory_l412_415) || when_BankedScratchMemory_l412_416) || when_BankedScratchMemory_l412_417) || when_BankedScratchMemory_l412_418) || when_BankedScratchMemory_l412_419);
      fwdValuGap2Valid_1_7 <= ((((((((((((((((_zz_fwdValuGap2Valid_1_7 || when_BankedScratchMemory_l412_432) || when_BankedScratchMemory_l412_433) || when_BankedScratchMemory_l412_434) || when_BankedScratchMemory_l412_435) || when_BankedScratchMemory_l412_436) || when_BankedScratchMemory_l412_437) || when_BankedScratchMemory_l412_438) || when_BankedScratchMemory_l412_439) || when_BankedScratchMemory_l412_440) || when_BankedScratchMemory_l412_441) || when_BankedScratchMemory_l412_442) || when_BankedScratchMemory_l412_443) || when_BankedScratchMemory_l412_444) || when_BankedScratchMemory_l412_445) || when_BankedScratchMemory_l412_446) || when_BankedScratchMemory_l412_447);
      prevValuReadEn_0_0 <= io_valuReadEn_0_0;
      prevValuReadAddr_0_0 <= io_valuReadAddr_0_0;
      prevValuReadEn_0_1 <= io_valuReadEn_0_1;
      prevValuReadAddr_0_1 <= io_valuReadAddr_0_1;
      prevValuReadEn_0_2 <= io_valuReadEn_0_2;
      prevValuReadAddr_0_2 <= io_valuReadAddr_0_2;
      prevValuReadEn_0_3 <= io_valuReadEn_0_3;
      prevValuReadAddr_0_3 <= io_valuReadAddr_0_3;
      prevValuReadEn_0_4 <= io_valuReadEn_0_4;
      prevValuReadAddr_0_4 <= io_valuReadAddr_0_4;
      prevValuReadEn_0_5 <= io_valuReadEn_0_5;
      prevValuReadAddr_0_5 <= io_valuReadAddr_0_5;
      prevValuReadEn_0_6 <= io_valuReadEn_0_6;
      prevValuReadAddr_0_6 <= io_valuReadAddr_0_6;
      prevValuReadEn_0_7 <= io_valuReadEn_0_7;
      prevValuReadAddr_0_7 <= io_valuReadAddr_0_7;
      prevValuReadEn_1_0 <= io_valuReadEn_1_0;
      prevValuReadAddr_1_0 <= io_valuReadAddr_1_0;
      prevValuReadEn_1_1 <= io_valuReadEn_1_1;
      prevValuReadAddr_1_1 <= io_valuReadAddr_1_1;
      prevValuReadEn_1_2 <= io_valuReadEn_1_2;
      prevValuReadAddr_1_2 <= io_valuReadAddr_1_2;
      prevValuReadEn_1_3 <= io_valuReadEn_1_3;
      prevValuReadAddr_1_3 <= io_valuReadAddr_1_3;
      prevValuReadEn_1_4 <= io_valuReadEn_1_4;
      prevValuReadAddr_1_4 <= io_valuReadAddr_1_4;
      prevValuReadEn_1_5 <= io_valuReadEn_1_5;
      prevValuReadAddr_1_5 <= io_valuReadAddr_1_5;
      prevValuReadEn_1_6 <= io_valuReadEn_1_6;
      prevValuReadAddr_1_6 <= io_valuReadAddr_1_6;
      prevValuReadEn_1_7 <= io_valuReadEn_1_7;
      prevValuReadAddr_1_7 <= io_valuReadAddr_1_7;
    end
  end

  always @(posedge clk) begin
    fwdGap2Data_0 <= _zz_fwdGap2Data_0;
    fwdGap2Data_1 <= _zz_fwdGap2Data_1;
    fwdGap2Data_2 <= _zz_fwdGap2Data_2;
    fwdGap2Data_3 <= _zz_fwdGap2Data_3;
    fwdGap2Data_4 <= _zz_fwdGap2Data_4;
    fwdGap2Data_5 <= _zz_fwdGap2Data_5;
    fwdGap2Data_6 <= _zz_fwdGap2Data_6;
    fwdGap2Data_7 <= _zz_fwdGap2Data_7;
    fwdGap2Data_8 <= _zz_fwdGap2Data_8;
    fwdValuGap2Data_0_0 <= _zz_fwdValuGap2Data_0_0;
    fwdValuGap2Data_0_1 <= _zz_fwdValuGap2Data_0_1;
    fwdValuGap2Data_0_2 <= _zz_fwdValuGap2Data_0_2;
    fwdValuGap2Data_0_3 <= _zz_fwdValuGap2Data_0_3;
    fwdValuGap2Data_0_4 <= _zz_fwdValuGap2Data_0_4;
    fwdValuGap2Data_0_5 <= _zz_fwdValuGap2Data_0_5;
    fwdValuGap2Data_0_6 <= _zz_fwdValuGap2Data_0_6;
    fwdValuGap2Data_0_7 <= _zz_fwdValuGap2Data_0_7;
    fwdValuGap2Data_1_0 <= _zz_fwdValuGap2Data_1_0;
    fwdValuGap2Data_1_1 <= _zz_fwdValuGap2Data_1_1;
    fwdValuGap2Data_1_2 <= _zz_fwdValuGap2Data_1_2;
    fwdValuGap2Data_1_3 <= _zz_fwdValuGap2Data_1_3;
    fwdValuGap2Data_1_4 <= _zz_fwdValuGap2Data_1_4;
    fwdValuGap2Data_1_5 <= _zz_fwdValuGap2Data_1_5;
    fwdValuGap2Data_1_6 <= _zz_fwdValuGap2Data_1_6;
    fwdValuGap2Data_1_7 <= _zz_fwdValuGap2Data_1_7;
  end


endmodule

//TdpBank_7 replaced by TdpBank

//TdpBank_6 replaced by TdpBank

//TdpBank_5 replaced by TdpBank

//TdpBank_4 replaced by TdpBank

//TdpBank_3 replaced by TdpBank

//TdpBank_2 replaced by TdpBank

//TdpBank_1 replaced by TdpBank

module TdpBank (
  input  wire [7:0]    io_aAddr,
  input  wire          io_aEn,
  input  wire          io_aWe,
  input  wire [31:0]   io_aWrData,
  output wire [31:0]   io_aRdData,
  input  wire [7:0]    io_bAddr,
  input  wire          io_bEn,
  input  wire          io_bWe,
  input  wire [31:0]   io_bWrData,
  output wire [31:0]   io_bRdData,
  input  wire          clk,
  input  wire          reset
);

  reg        [31:0]   mem_spinal_port0;
  reg        [31:0]   mem_spinal_port1;
  wire       [31:0]   _zz_io_bRdData;
  reg [31:0] mem [0:191];

  always @(posedge clk) begin
    if(io_aEn) begin
      mem_spinal_port0 <= mem[io_aAddr];
    end
  end

  always @(posedge clk) begin
    if(io_bEn) begin
      mem_spinal_port1 <= mem[io_bAddr];
    end
  end

  always @(posedge clk) begin
    if(io_bEn && io_bWe ) begin
      mem[io_bAddr] <= _zz_io_bRdData;
    end
  end

  assign io_aRdData = mem_spinal_port0;
  assign _zz_io_bRdData = io_bWrData;
  assign io_bRdData = mem_spinal_port1;

endmodule
