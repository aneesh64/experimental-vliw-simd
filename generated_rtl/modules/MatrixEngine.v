// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : MatrixEngine
// Git hash  : 414aef5ea78ca06f57c39f378ed640d967e9cf6d

`timescale 1ns/1ps

module MatrixEngine (
  input  wire          io_slots_0_valid,
  input  wire [4:0]    io_slots_0_opcode,
  input  wire [10:0]   io_slots_0_dest,
  input  wire [10:0]   io_slots_0_srcA,
  input  wire [10:0]   io_slots_0_srcB,
  input  wire [10:0]   io_slots_0_srcC,
  input  wire [3:0]    io_slots_0_tileRows,
  input  wire [3:0]    io_slots_0_tileCols,
  input  wire [5:0]    io_slots_0_flags,
  input  wire          io_valid,
  output reg  [7:0]    io_matrixScratchAAddr,
  output reg           io_matrixScratchAEn,
  output reg           io_matrixScratchAWe,
  output wire [7:0]    io_matrixScratchAWrData,
  input  wire [7:0]    io_matrixScratchARdData,
  output reg  [7:0]    io_matrixScratchBAddr,
  output reg           io_matrixScratchBEn,
  output reg           io_matrixScratchBWe,
  output wire [7:0]    io_matrixScratchBWrData,
  input  wire [7:0]    io_matrixScratchBRdData,
  output reg  [5:0]    io_matrixAccumAddr,
  output reg           io_matrixAccumEn,
  output reg           io_matrixAccumWe,
  output reg  [31:0]   io_matrixAccumWrData,
  input  wire [31:0]   io_matrixAccumRdData,
  output wire          io_busy,
  output wire          io_startPulse,
  output wire [4:0]    io_activeOpcode,
  output wire [10:0]   io_countdown,
  input  wire          clk,
  input  wire          reset
);
  localparam MatrixState_IDLE = 3'd0;
  localparam MatrixState_ZERO = 3'd1;
  localparam MatrixState_ACC_READ = 3'd2;
  localparam MatrixState_ACC_LOAD = 3'd3;
  localparam MatrixState_AB_READ = 3'd4;
  localparam MatrixState_MAC = 3'd5;
  localparam MatrixState_ACC_WRITE = 3'd6;

  wire       [7:0]    _zz_slotTileElems;
  wire       [11:0]   _zz_outputIndex;
  wire       [11:0]   _zz_outputIndex_1;
  wire       [5:0]    _zz_outputIndex_2;
  wire       [11:0]   _zz_outputIndex_3;
  wire       [5:0]    _zz_outputIndex_4;
  wire       [15:0]   _zz_aIndex;
  wire       [15:0]   _zz_aIndex_1;
  wire       [7:0]    _zz_aIndex_2;
  wire       [15:0]   _zz_aIndex_3;
  wire       [7:0]    _zz_aIndex_4;
  wire       [15:0]   _zz_bIndex;
  wire       [15:0]   _zz_bIndex_1;
  wire       [7:0]    _zz_bIndex_2;
  wire       [15:0]   _zz_bIndex_3;
  wire       [7:0]    _zz_bIndex_4;
  wire       [7:0]    _zz_aValue;
  wire       [7:0]    _zz_bValue;
  wire       [63:0]   _zz_product;
  wire       [5:0]    _zz_fpA_E4M3_shift;
  wire       [5:0]    _zz_fpB_E4M3_shift;
  wire       [5:0]    _zz_fpA_E5M2_shift;
  wire       [5:0]    _zz_fpB_E5M2_shift;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154_1;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154_2;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154_3;
  wire       [15:0]   _zz__zz_fpProductE4M3;
  wire       [7:0]    _zz__zz_fpProductE4M3_1;
  wire       [7:0]    _zz__zz_fpProductE4M3_2;
  wire       [72:0]   _zz__zz_fpProductE4M3_1_1;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_2;
  wire       [73:0]   _zz__zz_fpProductE4M3_1_3;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_4;
  wire       [74:0]   _zz__zz_fpProductE4M3_1_5;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_6;
  wire       [75:0]   _zz__zz_fpProductE4M3_1_7;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_8;
  wire       [76:0]   _zz__zz_fpProductE4M3_1_9;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_10;
  wire       [77:0]   _zz__zz_fpProductE4M3_1_11;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_12;
  wire       [78:0]   _zz__zz_fpProductE4M3_1_13;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_14;
  wire       [79:0]   _zz__zz_fpProductE4M3_1_15;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_16;
  wire       [80:0]   _zz__zz_fpProductE4M3_1_17;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_18;
  wire       [81:0]   _zz__zz_fpProductE4M3_1_19;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_20;
  wire       [82:0]   _zz__zz_fpProductE4M3_1_21;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_22;
  wire       [83:0]   _zz__zz_fpProductE4M3_1_23;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_24;
  wire       [84:0]   _zz__zz_fpProductE4M3_1_25;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_26;
  wire       [85:0]   _zz__zz_fpProductE4M3_1_27;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_28;
  wire       [86:0]   _zz__zz_fpProductE4M3_1_29;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_30;
  wire       [87:0]   _zz__zz_fpProductE4M3_1_31;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_32;
  wire       [88:0]   _zz__zz_fpProductE4M3_1_33;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_34;
  wire       [89:0]   _zz__zz_fpProductE4M3_1_35;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_36;
  wire       [90:0]   _zz__zz_fpProductE4M3_1_37;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_38;
  wire       [91:0]   _zz__zz_fpProductE4M3_1_39;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_40;
  wire       [92:0]   _zz__zz_fpProductE4M3_1_41;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_42;
  wire       [93:0]   _zz__zz_fpProductE4M3_1_43;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_44;
  wire       [94:0]   _zz__zz_fpProductE4M3_1_45;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_46;
  wire       [95:0]   _zz__zz_fpProductE4M3_1_47;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_48;
  wire       [96:0]   _zz__zz_fpProductE4M3_1_49;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_50;
  wire       [97:0]   _zz__zz_fpProductE4M3_1_51;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_52;
  wire       [98:0]   _zz__zz_fpProductE4M3_1_53;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_54;
  wire       [99:0]   _zz__zz_fpProductE4M3_1_55;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_56;
  wire       [100:0]  _zz__zz_fpProductE4M3_1_57;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_58;
  wire       [101:0]  _zz__zz_fpProductE4M3_1_59;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_60;
  wire       [102:0]  _zz__zz_fpProductE4M3_1_61;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_62;
  wire       [103:0]  _zz__zz_fpProductE4M3_1_63;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_64;
  wire       [104:0]  _zz__zz_fpProductE4M3_1_65;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_66;
  wire       [105:0]  _zz__zz_fpProductE4M3_1_67;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_68;
  wire       [106:0]  _zz__zz_fpProductE4M3_1_69;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_70;
  wire       [107:0]  _zz__zz_fpProductE4M3_1_71;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_72;
  wire       [108:0]  _zz__zz_fpProductE4M3_1_73;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_74;
  wire       [109:0]  _zz__zz_fpProductE4M3_1_75;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_76;
  wire       [110:0]  _zz__zz_fpProductE4M3_1_77;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_78;
  wire       [111:0]  _zz__zz_fpProductE4M3_1_79;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_80;
  wire       [112:0]  _zz__zz_fpProductE4M3_1_81;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_82;
  wire       [113:0]  _zz__zz_fpProductE4M3_1_83;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_84;
  wire       [114:0]  _zz__zz_fpProductE4M3_1_85;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_86;
  wire       [115:0]  _zz__zz_fpProductE4M3_1_87;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_88;
  wire       [116:0]  _zz__zz_fpProductE4M3_1_89;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_90;
  wire       [117:0]  _zz__zz_fpProductE4M3_1_91;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_92;
  wire       [118:0]  _zz__zz_fpProductE4M3_1_93;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_94;
  wire       [119:0]  _zz__zz_fpProductE4M3_1_95;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_96;
  wire       [120:0]  _zz__zz_fpProductE4M3_1_97;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_98;
  wire       [121:0]  _zz__zz_fpProductE4M3_1_99;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_100;
  wire       [122:0]  _zz__zz_fpProductE4M3_1_101;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_102;
  wire       [123:0]  _zz__zz_fpProductE4M3_1_103;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_104;
  wire       [124:0]  _zz__zz_fpProductE4M3_1_105;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_106;
  wire       [125:0]  _zz__zz_fpProductE4M3_1_107;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_108;
  wire       [126:0]  _zz__zz_fpProductE4M3_1_109;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_110;
  wire       [127:0]  _zz__zz_fpProductE4M3_1_111;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_112;
  wire       [128:0]  _zz__zz_fpProductE4M3_1_113;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_114;
  wire       [129:0]  _zz__zz_fpProductE4M3_1_115;
  wire       [71:0]   _zz__zz_fpProductE4M3_1_116;
  wire       [71:0]   _zz_fpProductE4M3_2;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154_1_1;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154_1_2;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154_1_3;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l154_1_4;
  wire       [15:0]   _zz__zz_fpProductE5M2;
  wire       [7:0]    _zz__zz_fpProductE5M2_1;
  wire       [7:0]    _zz__zz_fpProductE5M2_2;
  wire       [72:0]   _zz__zz_fpProductE5M2_1_1;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_2;
  wire       [73:0]   _zz__zz_fpProductE5M2_1_3;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_4;
  wire       [74:0]   _zz__zz_fpProductE5M2_1_5;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_6;
  wire       [75:0]   _zz__zz_fpProductE5M2_1_7;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_8;
  wire       [76:0]   _zz__zz_fpProductE5M2_1_9;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_10;
  wire       [77:0]   _zz__zz_fpProductE5M2_1_11;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_12;
  wire       [78:0]   _zz__zz_fpProductE5M2_1_13;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_14;
  wire       [79:0]   _zz__zz_fpProductE5M2_1_15;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_16;
  wire       [80:0]   _zz__zz_fpProductE5M2_1_17;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_18;
  wire       [81:0]   _zz__zz_fpProductE5M2_1_19;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_20;
  wire       [82:0]   _zz__zz_fpProductE5M2_1_21;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_22;
  wire       [83:0]   _zz__zz_fpProductE5M2_1_23;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_24;
  wire       [84:0]   _zz__zz_fpProductE5M2_1_25;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_26;
  wire       [85:0]   _zz__zz_fpProductE5M2_1_27;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_28;
  wire       [86:0]   _zz__zz_fpProductE5M2_1_29;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_30;
  wire       [87:0]   _zz__zz_fpProductE5M2_1_31;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_32;
  wire       [88:0]   _zz__zz_fpProductE5M2_1_33;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_34;
  wire       [89:0]   _zz__zz_fpProductE5M2_1_35;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_36;
  wire       [90:0]   _zz__zz_fpProductE5M2_1_37;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_38;
  wire       [91:0]   _zz__zz_fpProductE5M2_1_39;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_40;
  wire       [92:0]   _zz__zz_fpProductE5M2_1_41;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_42;
  wire       [93:0]   _zz__zz_fpProductE5M2_1_43;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_44;
  wire       [94:0]   _zz__zz_fpProductE5M2_1_45;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_46;
  wire       [95:0]   _zz__zz_fpProductE5M2_1_47;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_48;
  wire       [96:0]   _zz__zz_fpProductE5M2_1_49;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_50;
  wire       [97:0]   _zz__zz_fpProductE5M2_1_51;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_52;
  wire       [98:0]   _zz__zz_fpProductE5M2_1_53;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_54;
  wire       [99:0]   _zz__zz_fpProductE5M2_1_55;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_56;
  wire       [100:0]  _zz__zz_fpProductE5M2_1_57;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_58;
  wire       [101:0]  _zz__zz_fpProductE5M2_1_59;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_60;
  wire       [102:0]  _zz__zz_fpProductE5M2_1_61;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_62;
  wire       [103:0]  _zz__zz_fpProductE5M2_1_63;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_64;
  wire       [104:0]  _zz__zz_fpProductE5M2_1_65;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_66;
  wire       [105:0]  _zz__zz_fpProductE5M2_1_67;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_68;
  wire       [106:0]  _zz__zz_fpProductE5M2_1_69;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_70;
  wire       [107:0]  _zz__zz_fpProductE5M2_1_71;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_72;
  wire       [108:0]  _zz__zz_fpProductE5M2_1_73;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_74;
  wire       [109:0]  _zz__zz_fpProductE5M2_1_75;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_76;
  wire       [110:0]  _zz__zz_fpProductE5M2_1_77;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_78;
  wire       [111:0]  _zz__zz_fpProductE5M2_1_79;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_80;
  wire       [112:0]  _zz__zz_fpProductE5M2_1_81;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_82;
  wire       [113:0]  _zz__zz_fpProductE5M2_1_83;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_84;
  wire       [114:0]  _zz__zz_fpProductE5M2_1_85;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_86;
  wire       [115:0]  _zz__zz_fpProductE5M2_1_87;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_88;
  wire       [116:0]  _zz__zz_fpProductE5M2_1_89;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_90;
  wire       [117:0]  _zz__zz_fpProductE5M2_1_91;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_92;
  wire       [118:0]  _zz__zz_fpProductE5M2_1_93;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_94;
  wire       [119:0]  _zz__zz_fpProductE5M2_1_95;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_96;
  wire       [120:0]  _zz__zz_fpProductE5M2_1_97;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_98;
  wire       [121:0]  _zz__zz_fpProductE5M2_1_99;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_100;
  wire       [122:0]  _zz__zz_fpProductE5M2_1_101;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_102;
  wire       [123:0]  _zz__zz_fpProductE5M2_1_103;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_104;
  wire       [124:0]  _zz__zz_fpProductE5M2_1_105;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_106;
  wire       [125:0]  _zz__zz_fpProductE5M2_1_107;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_108;
  wire       [126:0]  _zz__zz_fpProductE5M2_1_109;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_110;
  wire       [127:0]  _zz__zz_fpProductE5M2_1_111;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_112;
  wire       [128:0]  _zz__zz_fpProductE5M2_1_113;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_114;
  wire       [129:0]  _zz__zz_fpProductE5M2_1_115;
  wire       [71:0]   _zz__zz_fpProductE5M2_1_116;
  wire       [71:0]   _zz_fpProductE5M2_2;
  wire       [71:0]   _zz__zz_when_MatrixEngine_l89;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l209;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l204;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_1;
  wire       [25:0]   _zz__zz_when_MatrixEngine_l233_2;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_3;
  wire       [26:0]   _zz__zz_when_MatrixEngine_l233_4;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_5;
  wire       [27:0]   _zz__zz_when_MatrixEngine_l233_6;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_7;
  wire       [28:0]   _zz__zz_when_MatrixEngine_l233_8;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_9;
  wire       [29:0]   _zz__zz_when_MatrixEngine_l233_10;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_11;
  wire       [30:0]   _zz__zz_when_MatrixEngine_l233_12;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_13;
  wire       [31:0]   _zz__zz_when_MatrixEngine_l233_14;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_15;
  wire       [32:0]   _zz__zz_when_MatrixEngine_l233_16;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_17;
  wire       [33:0]   _zz__zz_when_MatrixEngine_l233_18;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_19;
  wire       [34:0]   _zz__zz_when_MatrixEngine_l233_20;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_21;
  wire       [35:0]   _zz__zz_when_MatrixEngine_l233_22;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_23;
  wire       [36:0]   _zz__zz_when_MatrixEngine_l233_24;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_25;
  wire       [37:0]   _zz__zz_when_MatrixEngine_l233_26;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_27;
  wire       [38:0]   _zz__zz_when_MatrixEngine_l233_28;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_29;
  wire       [39:0]   _zz__zz_when_MatrixEngine_l233_30;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_31;
  wire       [40:0]   _zz__zz_when_MatrixEngine_l233_32;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_33;
  wire       [41:0]   _zz__zz_when_MatrixEngine_l233_34;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_35;
  wire       [42:0]   _zz__zz_when_MatrixEngine_l233_36;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_37;
  wire       [43:0]   _zz__zz_when_MatrixEngine_l233_38;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_39;
  wire       [44:0]   _zz__zz_when_MatrixEngine_l233_40;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_41;
  wire       [45:0]   _zz__zz_when_MatrixEngine_l233_42;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_43;
  wire       [46:0]   _zz__zz_when_MatrixEngine_l233_44;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_45;
  wire       [70:0]   _zz__zz_when_MatrixEngine_l233_46;
  wire       [69:0]   _zz__zz_when_MatrixEngine_l233_47;
  wire       [68:0]   _zz__zz_when_MatrixEngine_l233_48;
  wire       [67:0]   _zz__zz_when_MatrixEngine_l233_49;
  wire       [66:0]   _zz__zz_when_MatrixEngine_l233_50;
  wire       [65:0]   _zz__zz_when_MatrixEngine_l233_51;
  wire       [64:0]   _zz__zz_when_MatrixEngine_l233_52;
  wire       [63:0]   _zz__zz_when_MatrixEngine_l233_53;
  wire       [62:0]   _zz__zz_when_MatrixEngine_l233_54;
  wire       [61:0]   _zz__zz_when_MatrixEngine_l233_55;
  wire       [60:0]   _zz__zz_when_MatrixEngine_l233_56;
  wire       [59:0]   _zz__zz_when_MatrixEngine_l233_57;
  wire       [58:0]   _zz__zz_when_MatrixEngine_l233_58;
  wire       [57:0]   _zz__zz_when_MatrixEngine_l233_59;
  wire       [56:0]   _zz__zz_when_MatrixEngine_l233_60;
  wire       [55:0]   _zz__zz_when_MatrixEngine_l233_61;
  wire       [54:0]   _zz__zz_when_MatrixEngine_l233_62;
  wire       [53:0]   _zz__zz_when_MatrixEngine_l233_63;
  wire       [52:0]   _zz__zz_when_MatrixEngine_l233_64;
  wire       [51:0]   _zz__zz_when_MatrixEngine_l233_65;
  wire       [50:0]   _zz__zz_when_MatrixEngine_l233_66;
  wire       [49:0]   _zz__zz_when_MatrixEngine_l233_67;
  wire       [48:0]   _zz__zz_when_MatrixEngine_l233_68;
  wire       [47:0]   _zz__zz_when_MatrixEngine_l233_69;
  wire       [46:0]   _zz__zz_when_MatrixEngine_l233_70;
  wire       [45:0]   _zz__zz_when_MatrixEngine_l233_71;
  wire       [44:0]   _zz__zz_when_MatrixEngine_l233_72;
  wire       [43:0]   _zz__zz_when_MatrixEngine_l233_73;
  wire       [42:0]   _zz__zz_when_MatrixEngine_l233_74;
  wire       [41:0]   _zz__zz_when_MatrixEngine_l233_75;
  wire       [40:0]   _zz__zz_when_MatrixEngine_l233_76;
  wire       [39:0]   _zz__zz_when_MatrixEngine_l233_77;
  wire       [38:0]   _zz__zz_when_MatrixEngine_l233_78;
  wire       [37:0]   _zz__zz_when_MatrixEngine_l233_79;
  wire       [36:0]   _zz__zz_when_MatrixEngine_l233_80;
  wire       [35:0]   _zz__zz_when_MatrixEngine_l233_81;
  wire       [34:0]   _zz__zz_when_MatrixEngine_l233_82;
  wire       [33:0]   _zz__zz_when_MatrixEngine_l233_83;
  wire       [32:0]   _zz__zz_when_MatrixEngine_l233_84;
  wire       [31:0]   _zz__zz_when_MatrixEngine_l233_85;
  wire       [30:0]   _zz__zz_when_MatrixEngine_l233_86;
  wire       [29:0]   _zz__zz_when_MatrixEngine_l233_87;
  wire       [28:0]   _zz__zz_when_MatrixEngine_l233_88;
  wire       [27:0]   _zz__zz_when_MatrixEngine_l233_89;
  wire       [26:0]   _zz__zz_when_MatrixEngine_l233_90;
  wire       [25:0]   _zz__zz_when_MatrixEngine_l233_91;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233_92;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233_3_1;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233_3_2;
  wire       [0:0]    _zz__zz_when_MatrixEngine_l233_3_3;
  wire       [7:0]    _zz__zz_when_MatrixEngine_l290_1;
  wire       [7:0]    _zz__zz_when_MatrixEngine_l262;
  wire       [72:0]   _zz__zz_roundedFpAcc_1;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_1;
  wire       [73:0]   _zz__zz_roundedFpAcc_1_2;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_3;
  wire       [74:0]   _zz__zz_roundedFpAcc_1_4;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_5;
  wire       [75:0]   _zz__zz_roundedFpAcc_1_6;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_7;
  wire       [76:0]   _zz__zz_roundedFpAcc_1_8;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_9;
  wire       [77:0]   _zz__zz_roundedFpAcc_1_10;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_11;
  wire       [78:0]   _zz__zz_roundedFpAcc_1_12;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_13;
  wire       [79:0]   _zz__zz_roundedFpAcc_1_14;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_15;
  wire       [80:0]   _zz__zz_roundedFpAcc_1_16;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_17;
  wire       [81:0]   _zz__zz_roundedFpAcc_1_18;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_19;
  wire       [82:0]   _zz__zz_roundedFpAcc_1_20;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_21;
  wire       [83:0]   _zz__zz_roundedFpAcc_1_22;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_23;
  wire       [84:0]   _zz__zz_roundedFpAcc_1_24;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_25;
  wire       [85:0]   _zz__zz_roundedFpAcc_1_26;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_27;
  wire       [86:0]   _zz__zz_roundedFpAcc_1_28;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_29;
  wire       [87:0]   _zz__zz_roundedFpAcc_1_30;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_31;
  wire       [88:0]   _zz__zz_roundedFpAcc_1_32;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_33;
  wire       [89:0]   _zz__zz_roundedFpAcc_1_34;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_35;
  wire       [90:0]   _zz__zz_roundedFpAcc_1_36;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_37;
  wire       [91:0]   _zz__zz_roundedFpAcc_1_38;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_39;
  wire       [92:0]   _zz__zz_roundedFpAcc_1_40;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_41;
  wire       [93:0]   _zz__zz_roundedFpAcc_1_42;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_43;
  wire       [94:0]   _zz__zz_roundedFpAcc_1_44;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_45;
  wire       [95:0]   _zz__zz_roundedFpAcc_1_46;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_47;
  wire       [96:0]   _zz__zz_roundedFpAcc_1_48;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_49;
  wire       [97:0]   _zz__zz_roundedFpAcc_1_50;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_51;
  wire       [98:0]   _zz__zz_roundedFpAcc_1_52;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_53;
  wire       [99:0]   _zz__zz_roundedFpAcc_1_54;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_55;
  wire       [100:0]  _zz__zz_roundedFpAcc_1_56;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_57;
  wire       [101:0]  _zz__zz_roundedFpAcc_1_58;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_59;
  wire       [102:0]  _zz__zz_roundedFpAcc_1_60;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_61;
  wire       [103:0]  _zz__zz_roundedFpAcc_1_62;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_63;
  wire       [104:0]  _zz__zz_roundedFpAcc_1_64;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_65;
  wire       [105:0]  _zz__zz_roundedFpAcc_1_66;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_67;
  wire       [106:0]  _zz__zz_roundedFpAcc_1_68;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_69;
  wire       [107:0]  _zz__zz_roundedFpAcc_1_70;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_71;
  wire       [108:0]  _zz__zz_roundedFpAcc_1_72;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_73;
  wire       [109:0]  _zz__zz_roundedFpAcc_1_74;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_75;
  wire       [110:0]  _zz__zz_roundedFpAcc_1_76;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_77;
  wire       [111:0]  _zz__zz_roundedFpAcc_1_78;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_79;
  wire       [112:0]  _zz__zz_roundedFpAcc_1_80;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_81;
  wire       [113:0]  _zz__zz_roundedFpAcc_1_82;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_83;
  wire       [114:0]  _zz__zz_roundedFpAcc_1_84;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_85;
  wire       [115:0]  _zz__zz_roundedFpAcc_1_86;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_87;
  wire       [116:0]  _zz__zz_roundedFpAcc_1_88;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_89;
  wire       [117:0]  _zz__zz_roundedFpAcc_1_90;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_91;
  wire       [118:0]  _zz__zz_roundedFpAcc_1_92;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_93;
  wire       [119:0]  _zz__zz_roundedFpAcc_1_94;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_95;
  wire       [22:0]   _zz__zz_roundedFpAcc_3;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_96;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_97;
  wire       [21:0]   _zz__zz_roundedFpAcc_4;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_98;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_99;
  wire       [20:0]   _zz__zz_roundedFpAcc_5;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_100;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_101;
  wire       [19:0]   _zz__zz_roundedFpAcc_6;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_102;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_103;
  wire       [18:0]   _zz__zz_roundedFpAcc_7;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_104;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_105;
  wire       [17:0]   _zz__zz_roundedFpAcc_8;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_106;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_107;
  wire       [16:0]   _zz__zz_roundedFpAcc_9;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_108;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_109;
  wire       [15:0]   _zz__zz_roundedFpAcc_10;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_110;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_111;
  wire       [14:0]   _zz__zz_roundedFpAcc_11;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_112;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_113;
  wire       [13:0]   _zz__zz_roundedFpAcc_12;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_114;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_115;
  wire       [12:0]   _zz__zz_roundedFpAcc_13;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_116;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_117;
  wire       [11:0]   _zz__zz_roundedFpAcc_14;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_118;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_119;
  wire       [10:0]   _zz__zz_roundedFpAcc_15;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_120;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_121;
  wire       [9:0]    _zz__zz_roundedFpAcc_16;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_122;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_123;
  wire       [8:0]    _zz__zz_roundedFpAcc_17;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_124;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_125;
  wire       [7:0]    _zz__zz_roundedFpAcc_18;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_126;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_127;
  wire       [6:0]    _zz__zz_roundedFpAcc_19;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_128;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_129;
  wire       [5:0]    _zz__zz_roundedFpAcc_20;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_130;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_131;
  wire       [4:0]    _zz__zz_roundedFpAcc_21;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_132;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_133;
  wire       [3:0]    _zz__zz_roundedFpAcc_22;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_134;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_135;
  wire       [2:0]    _zz__zz_roundedFpAcc_23;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_136;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_137;
  wire       [1:0]    _zz__zz_roundedFpAcc_24;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_138;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_139;
  wire       [0:0]    _zz__zz_roundedFpAcc_25;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_140;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_141;
  wire       [71:0]   _zz__zz_roundedFpAcc_1_142;
  wire       [0:0]    _zz__zz_roundedFpAcc_1_143;
  wire       [71:0]   _zz_roundedFpAcc_27;
  wire       [5:0]    _zz_io_matrixAccumAddr;
  wire       [5:0]    _zz_io_matrixAccumAddr_1;
  wire       [5:0]    _zz_io_matrixAccumAddr_2;
  wire       [7:0]    _zz__zz_when_MatrixEngine_l262_1;
  wire       [72:0]   _zz__zz_fpAccReg_1;
  wire       [71:0]   _zz__zz_fpAccReg_1_1;
  wire       [73:0]   _zz__zz_fpAccReg_1_2;
  wire       [71:0]   _zz__zz_fpAccReg_1_3;
  wire       [74:0]   _zz__zz_fpAccReg_1_4;
  wire       [71:0]   _zz__zz_fpAccReg_1_5;
  wire       [75:0]   _zz__zz_fpAccReg_1_6;
  wire       [71:0]   _zz__zz_fpAccReg_1_7;
  wire       [76:0]   _zz__zz_fpAccReg_1_8;
  wire       [71:0]   _zz__zz_fpAccReg_1_9;
  wire       [77:0]   _zz__zz_fpAccReg_1_10;
  wire       [71:0]   _zz__zz_fpAccReg_1_11;
  wire       [78:0]   _zz__zz_fpAccReg_1_12;
  wire       [71:0]   _zz__zz_fpAccReg_1_13;
  wire       [79:0]   _zz__zz_fpAccReg_1_14;
  wire       [71:0]   _zz__zz_fpAccReg_1_15;
  wire       [80:0]   _zz__zz_fpAccReg_1_16;
  wire       [71:0]   _zz__zz_fpAccReg_1_17;
  wire       [81:0]   _zz__zz_fpAccReg_1_18;
  wire       [71:0]   _zz__zz_fpAccReg_1_19;
  wire       [82:0]   _zz__zz_fpAccReg_1_20;
  wire       [71:0]   _zz__zz_fpAccReg_1_21;
  wire       [83:0]   _zz__zz_fpAccReg_1_22;
  wire       [71:0]   _zz__zz_fpAccReg_1_23;
  wire       [84:0]   _zz__zz_fpAccReg_1_24;
  wire       [71:0]   _zz__zz_fpAccReg_1_25;
  wire       [85:0]   _zz__zz_fpAccReg_1_26;
  wire       [71:0]   _zz__zz_fpAccReg_1_27;
  wire       [86:0]   _zz__zz_fpAccReg_1_28;
  wire       [71:0]   _zz__zz_fpAccReg_1_29;
  wire       [87:0]   _zz__zz_fpAccReg_1_30;
  wire       [71:0]   _zz__zz_fpAccReg_1_31;
  wire       [88:0]   _zz__zz_fpAccReg_1_32;
  wire       [71:0]   _zz__zz_fpAccReg_1_33;
  wire       [89:0]   _zz__zz_fpAccReg_1_34;
  wire       [71:0]   _zz__zz_fpAccReg_1_35;
  wire       [90:0]   _zz__zz_fpAccReg_1_36;
  wire       [71:0]   _zz__zz_fpAccReg_1_37;
  wire       [91:0]   _zz__zz_fpAccReg_1_38;
  wire       [71:0]   _zz__zz_fpAccReg_1_39;
  wire       [92:0]   _zz__zz_fpAccReg_1_40;
  wire       [71:0]   _zz__zz_fpAccReg_1_41;
  wire       [93:0]   _zz__zz_fpAccReg_1_42;
  wire       [71:0]   _zz__zz_fpAccReg_1_43;
  wire       [94:0]   _zz__zz_fpAccReg_1_44;
  wire       [71:0]   _zz__zz_fpAccReg_1_45;
  wire       [95:0]   _zz__zz_fpAccReg_1_46;
  wire       [71:0]   _zz__zz_fpAccReg_1_47;
  wire       [96:0]   _zz__zz_fpAccReg_1_48;
  wire       [71:0]   _zz__zz_fpAccReg_1_49;
  wire       [97:0]   _zz__zz_fpAccReg_1_50;
  wire       [71:0]   _zz__zz_fpAccReg_1_51;
  wire       [98:0]   _zz__zz_fpAccReg_1_52;
  wire       [71:0]   _zz__zz_fpAccReg_1_53;
  wire       [99:0]   _zz__zz_fpAccReg_1_54;
  wire       [71:0]   _zz__zz_fpAccReg_1_55;
  wire       [100:0]  _zz__zz_fpAccReg_1_56;
  wire       [71:0]   _zz__zz_fpAccReg_1_57;
  wire       [101:0]  _zz__zz_fpAccReg_1_58;
  wire       [71:0]   _zz__zz_fpAccReg_1_59;
  wire       [102:0]  _zz__zz_fpAccReg_1_60;
  wire       [71:0]   _zz__zz_fpAccReg_1_61;
  wire       [103:0]  _zz__zz_fpAccReg_1_62;
  wire       [71:0]   _zz__zz_fpAccReg_1_63;
  wire       [104:0]  _zz__zz_fpAccReg_1_64;
  wire       [71:0]   _zz__zz_fpAccReg_1_65;
  wire       [105:0]  _zz__zz_fpAccReg_1_66;
  wire       [71:0]   _zz__zz_fpAccReg_1_67;
  wire       [106:0]  _zz__zz_fpAccReg_1_68;
  wire       [71:0]   _zz__zz_fpAccReg_1_69;
  wire       [107:0]  _zz__zz_fpAccReg_1_70;
  wire       [71:0]   _zz__zz_fpAccReg_1_71;
  wire       [108:0]  _zz__zz_fpAccReg_1_72;
  wire       [71:0]   _zz__zz_fpAccReg_1_73;
  wire       [109:0]  _zz__zz_fpAccReg_1_74;
  wire       [71:0]   _zz__zz_fpAccReg_1_75;
  wire       [110:0]  _zz__zz_fpAccReg_1_76;
  wire       [71:0]   _zz__zz_fpAccReg_1_77;
  wire       [111:0]  _zz__zz_fpAccReg_1_78;
  wire       [71:0]   _zz__zz_fpAccReg_1_79;
  wire       [112:0]  _zz__zz_fpAccReg_1_80;
  wire       [71:0]   _zz__zz_fpAccReg_1_81;
  wire       [113:0]  _zz__zz_fpAccReg_1_82;
  wire       [71:0]   _zz__zz_fpAccReg_1_83;
  wire       [114:0]  _zz__zz_fpAccReg_1_84;
  wire       [71:0]   _zz__zz_fpAccReg_1_85;
  wire       [115:0]  _zz__zz_fpAccReg_1_86;
  wire       [71:0]   _zz__zz_fpAccReg_1_87;
  wire       [116:0]  _zz__zz_fpAccReg_1_88;
  wire       [71:0]   _zz__zz_fpAccReg_1_89;
  wire       [117:0]  _zz__zz_fpAccReg_1_90;
  wire       [71:0]   _zz__zz_fpAccReg_1_91;
  wire       [118:0]  _zz__zz_fpAccReg_1_92;
  wire       [71:0]   _zz__zz_fpAccReg_1_93;
  wire       [119:0]  _zz__zz_fpAccReg_1_94;
  wire       [71:0]   _zz__zz_fpAccReg_1_95;
  wire       [22:0]   _zz__zz_fpAccReg_3;
  wire       [71:0]   _zz__zz_fpAccReg_1_96;
  wire       [0:0]    _zz__zz_fpAccReg_1_97;
  wire       [21:0]   _zz__zz_fpAccReg_4;
  wire       [71:0]   _zz__zz_fpAccReg_1_98;
  wire       [0:0]    _zz__zz_fpAccReg_1_99;
  wire       [20:0]   _zz__zz_fpAccReg_5;
  wire       [71:0]   _zz__zz_fpAccReg_1_100;
  wire       [0:0]    _zz__zz_fpAccReg_1_101;
  wire       [19:0]   _zz__zz_fpAccReg_6;
  wire       [71:0]   _zz__zz_fpAccReg_1_102;
  wire       [0:0]    _zz__zz_fpAccReg_1_103;
  wire       [18:0]   _zz__zz_fpAccReg_7;
  wire       [71:0]   _zz__zz_fpAccReg_1_104;
  wire       [0:0]    _zz__zz_fpAccReg_1_105;
  wire       [17:0]   _zz__zz_fpAccReg_8;
  wire       [71:0]   _zz__zz_fpAccReg_1_106;
  wire       [0:0]    _zz__zz_fpAccReg_1_107;
  wire       [16:0]   _zz__zz_fpAccReg_9;
  wire       [71:0]   _zz__zz_fpAccReg_1_108;
  wire       [0:0]    _zz__zz_fpAccReg_1_109;
  wire       [15:0]   _zz__zz_fpAccReg_10;
  wire       [71:0]   _zz__zz_fpAccReg_1_110;
  wire       [0:0]    _zz__zz_fpAccReg_1_111;
  wire       [14:0]   _zz__zz_fpAccReg_11;
  wire       [71:0]   _zz__zz_fpAccReg_1_112;
  wire       [0:0]    _zz__zz_fpAccReg_1_113;
  wire       [13:0]   _zz__zz_fpAccReg_12;
  wire       [71:0]   _zz__zz_fpAccReg_1_114;
  wire       [0:0]    _zz__zz_fpAccReg_1_115;
  wire       [12:0]   _zz__zz_fpAccReg_13;
  wire       [71:0]   _zz__zz_fpAccReg_1_116;
  wire       [0:0]    _zz__zz_fpAccReg_1_117;
  wire       [11:0]   _zz__zz_fpAccReg_14;
  wire       [71:0]   _zz__zz_fpAccReg_1_118;
  wire       [0:0]    _zz__zz_fpAccReg_1_119;
  wire       [10:0]   _zz__zz_fpAccReg_15;
  wire       [71:0]   _zz__zz_fpAccReg_1_120;
  wire       [0:0]    _zz__zz_fpAccReg_1_121;
  wire       [9:0]    _zz__zz_fpAccReg_16;
  wire       [71:0]   _zz__zz_fpAccReg_1_122;
  wire       [0:0]    _zz__zz_fpAccReg_1_123;
  wire       [8:0]    _zz__zz_fpAccReg_17;
  wire       [71:0]   _zz__zz_fpAccReg_1_124;
  wire       [0:0]    _zz__zz_fpAccReg_1_125;
  wire       [7:0]    _zz__zz_fpAccReg_18;
  wire       [71:0]   _zz__zz_fpAccReg_1_126;
  wire       [0:0]    _zz__zz_fpAccReg_1_127;
  wire       [6:0]    _zz__zz_fpAccReg_19;
  wire       [71:0]   _zz__zz_fpAccReg_1_128;
  wire       [0:0]    _zz__zz_fpAccReg_1_129;
  wire       [5:0]    _zz__zz_fpAccReg_20;
  wire       [71:0]   _zz__zz_fpAccReg_1_130;
  wire       [0:0]    _zz__zz_fpAccReg_1_131;
  wire       [4:0]    _zz__zz_fpAccReg_21;
  wire       [71:0]   _zz__zz_fpAccReg_1_132;
  wire       [0:0]    _zz__zz_fpAccReg_1_133;
  wire       [3:0]    _zz__zz_fpAccReg_22;
  wire       [71:0]   _zz__zz_fpAccReg_1_134;
  wire       [0:0]    _zz__zz_fpAccReg_1_135;
  wire       [2:0]    _zz__zz_fpAccReg_23;
  wire       [71:0]   _zz__zz_fpAccReg_1_136;
  wire       [0:0]    _zz__zz_fpAccReg_1_137;
  wire       [1:0]    _zz__zz_fpAccReg_24;
  wire       [71:0]   _zz__zz_fpAccReg_1_138;
  wire       [0:0]    _zz__zz_fpAccReg_1_139;
  wire       [0:0]    _zz__zz_fpAccReg_25;
  wire       [71:0]   _zz__zz_fpAccReg_1_140;
  wire       [0:0]    _zz__zz_fpAccReg_1_141;
  wire       [71:0]   _zz__zz_fpAccReg_1_142;
  wire       [0:0]    _zz__zz_fpAccReg_1_143;
  wire       [71:0]   _zz__zz_fpAccReg_27;
  wire       [71:0]   _zz__zz_when_MatrixEngine_l89_1;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l209_1;
  wire       [6:0]    _zz__zz_when_MatrixEngine_l204_1;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233_4_1;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_2;
  wire       [25:0]   _zz__zz_when_MatrixEngine_l233_4_3;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_4;
  wire       [26:0]   _zz__zz_when_MatrixEngine_l233_4_5;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_6;
  wire       [27:0]   _zz__zz_when_MatrixEngine_l233_4_7;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_8;
  wire       [28:0]   _zz__zz_when_MatrixEngine_l233_4_9;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_10;
  wire       [29:0]   _zz__zz_when_MatrixEngine_l233_4_11;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_12;
  wire       [30:0]   _zz__zz_when_MatrixEngine_l233_4_13;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_14;
  wire       [31:0]   _zz__zz_when_MatrixEngine_l233_4_15;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_16;
  wire       [32:0]   _zz__zz_when_MatrixEngine_l233_4_17;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_18;
  wire       [33:0]   _zz__zz_when_MatrixEngine_l233_4_19;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_20;
  wire       [34:0]   _zz__zz_when_MatrixEngine_l233_4_21;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_22;
  wire       [35:0]   _zz__zz_when_MatrixEngine_l233_4_23;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_24;
  wire       [36:0]   _zz__zz_when_MatrixEngine_l233_4_25;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_26;
  wire       [37:0]   _zz__zz_when_MatrixEngine_l233_4_27;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_28;
  wire       [38:0]   _zz__zz_when_MatrixEngine_l233_4_29;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_30;
  wire       [39:0]   _zz__zz_when_MatrixEngine_l233_4_31;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_32;
  wire       [40:0]   _zz__zz_when_MatrixEngine_l233_4_33;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_34;
  wire       [41:0]   _zz__zz_when_MatrixEngine_l233_4_35;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_36;
  wire       [42:0]   _zz__zz_when_MatrixEngine_l233_4_37;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_38;
  wire       [43:0]   _zz__zz_when_MatrixEngine_l233_4_39;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_40;
  wire       [44:0]   _zz__zz_when_MatrixEngine_l233_4_41;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_42;
  wire       [45:0]   _zz__zz_when_MatrixEngine_l233_4_43;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_44;
  wire       [46:0]   _zz__zz_when_MatrixEngine_l233_4_45;
  wire       [23:0]   _zz__zz_when_MatrixEngine_l233_4_46;
  wire       [70:0]   _zz__zz_when_MatrixEngine_l233_4_47;
  wire       [69:0]   _zz__zz_when_MatrixEngine_l233_4_48;
  wire       [68:0]   _zz__zz_when_MatrixEngine_l233_4_49;
  wire       [67:0]   _zz__zz_when_MatrixEngine_l233_4_50;
  wire       [66:0]   _zz__zz_when_MatrixEngine_l233_4_51;
  wire       [65:0]   _zz__zz_when_MatrixEngine_l233_4_52;
  wire       [64:0]   _zz__zz_when_MatrixEngine_l233_4_53;
  wire       [63:0]   _zz__zz_when_MatrixEngine_l233_4_54;
  wire       [62:0]   _zz__zz_when_MatrixEngine_l233_4_55;
  wire       [61:0]   _zz__zz_when_MatrixEngine_l233_4_56;
  wire       [60:0]   _zz__zz_when_MatrixEngine_l233_4_57;
  wire       [59:0]   _zz__zz_when_MatrixEngine_l233_4_58;
  wire       [58:0]   _zz__zz_when_MatrixEngine_l233_4_59;
  wire       [57:0]   _zz__zz_when_MatrixEngine_l233_4_60;
  wire       [56:0]   _zz__zz_when_MatrixEngine_l233_4_61;
  wire       [55:0]   _zz__zz_when_MatrixEngine_l233_4_62;
  wire       [54:0]   _zz__zz_when_MatrixEngine_l233_4_63;
  wire       [53:0]   _zz__zz_when_MatrixEngine_l233_4_64;
  wire       [52:0]   _zz__zz_when_MatrixEngine_l233_4_65;
  wire       [51:0]   _zz__zz_when_MatrixEngine_l233_4_66;
  wire       [50:0]   _zz__zz_when_MatrixEngine_l233_4_67;
  wire       [49:0]   _zz__zz_when_MatrixEngine_l233_4_68;
  wire       [48:0]   _zz__zz_when_MatrixEngine_l233_4_69;
  wire       [47:0]   _zz__zz_when_MatrixEngine_l233_4_70;
  wire       [46:0]   _zz__zz_when_MatrixEngine_l233_4_71;
  wire       [45:0]   _zz__zz_when_MatrixEngine_l233_4_72;
  wire       [44:0]   _zz__zz_when_MatrixEngine_l233_4_73;
  wire       [43:0]   _zz__zz_when_MatrixEngine_l233_4_74;
  wire       [42:0]   _zz__zz_when_MatrixEngine_l233_4_75;
  wire       [41:0]   _zz__zz_when_MatrixEngine_l233_4_76;
  wire       [40:0]   _zz__zz_when_MatrixEngine_l233_4_77;
  wire       [39:0]   _zz__zz_when_MatrixEngine_l233_4_78;
  wire       [38:0]   _zz__zz_when_MatrixEngine_l233_4_79;
  wire       [37:0]   _zz__zz_when_MatrixEngine_l233_4_80;
  wire       [36:0]   _zz__zz_when_MatrixEngine_l233_4_81;
  wire       [35:0]   _zz__zz_when_MatrixEngine_l233_4_82;
  wire       [34:0]   _zz__zz_when_MatrixEngine_l233_4_83;
  wire       [33:0]   _zz__zz_when_MatrixEngine_l233_4_84;
  wire       [32:0]   _zz__zz_when_MatrixEngine_l233_4_85;
  wire       [31:0]   _zz__zz_when_MatrixEngine_l233_4_86;
  wire       [30:0]   _zz__zz_when_MatrixEngine_l233_4_87;
  wire       [29:0]   _zz__zz_when_MatrixEngine_l233_4_88;
  wire       [28:0]   _zz__zz_when_MatrixEngine_l233_4_89;
  wire       [27:0]   _zz__zz_when_MatrixEngine_l233_4_90;
  wire       [26:0]   _zz__zz_when_MatrixEngine_l233_4_91;
  wire       [25:0]   _zz__zz_when_MatrixEngine_l233_4_92;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233_4_93;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233_7_1;
  wire       [24:0]   _zz__zz_when_MatrixEngine_l233_7_2;
  wire       [0:0]    _zz__zz_when_MatrixEngine_l233_7_3;
  wire       [7:0]    _zz__zz_io_matrixAccumWrData_1;
  reg        [2:0]    state;
  reg        [4:0]    activeOpcodeReg;
  reg        [5:0]    localBaseReg;
  reg        [6:0]    totalElemsReg;
  reg        [7:0]    operandABaseReg;
  reg        [7:0]    operandBBaseReg;
  reg        [2:0]    rowReg;
  reg        [2:0]    colReg;
  reg        [2:0]    kReg;
  reg        [31:0]   accReg;
  reg        [71:0]   fpAccReg;
  reg        [10:0]   debugCounter;
  reg                 issueSeenReg;
  wire                slotValid;
  wire       [6:0]    slotTileElems;
  wire                when_MatrixEngine_l317;
  wire                startsCompute;
  wire                startsZero;
  wire                activeUsesFp8;
  wire                activeUsesFp8E5M2;
  wire                activeAccumulates;
  wire       [5:0]    outputIndex;
  wire       [7:0]    aIndex;
  wire       [7:0]    bIndex;
  wire       [31:0]   aValue;
  wire       [31:0]   bValue;
  wire       [31:0]   product;
  wire                fpA_E4M3_isZero;
  wire                fpA_E4M3_isSpecial;
  wire                fpA_E4M3_sign;
  reg        [3:0]    fpA_E4M3_sig;
  reg        [5:0]    fpA_E4M3_shift;
  wire       [3:0]    _zz_fpA_E4M3_isZero;
  wire       [2:0]    _zz_fpA_E4M3_isZero_1;
  wire                when_MatrixEngine_l107;
  wire                when_MatrixEngine_l109;
  wire                fpB_E4M3_isZero;
  wire                fpB_E4M3_isSpecial;
  wire                fpB_E4M3_sign;
  reg        [3:0]    fpB_E4M3_sig;
  reg        [5:0]    fpB_E4M3_shift;
  wire       [3:0]    _zz_fpB_E4M3_isZero;
  wire       [2:0]    _zz_fpB_E4M3_isZero_1;
  wire                when_MatrixEngine_l107_1;
  wire                when_MatrixEngine_l109_1;
  wire                fpA_E5M2_isZero;
  wire                fpA_E5M2_isSpecial;
  wire                fpA_E5M2_sign;
  reg        [3:0]    fpA_E5M2_sig;
  reg        [5:0]    fpA_E5M2_shift;
  wire       [4:0]    _zz_fpA_E5M2_isZero;
  wire       [1:0]    _zz_fpA_E5M2_isZero_1;
  wire                when_MatrixEngine_l131;
  wire                when_MatrixEngine_l133;
  wire                fpB_E5M2_isZero;
  wire                fpB_E5M2_isSpecial;
  wire                fpB_E5M2_sign;
  reg        [3:0]    fpB_E5M2_sig;
  reg        [5:0]    fpB_E5M2_shift;
  wire       [4:0]    _zz_fpB_E5M2_isZero;
  wire       [1:0]    _zz_fpB_E5M2_isZero_1;
  wire                when_MatrixEngine_l131_1;
  wire                when_MatrixEngine_l133_1;
  wire       [5:0]    _zz_when_MatrixEngine_l154;
  wire       [7:0]    _zz_fpProductE4M3;
  reg        [71:0]   _zz_fpProductE4M3_1;
  wire                when_MatrixEngine_l152;
  wire                when_MatrixEngine_l154;
  wire                when_MatrixEngine_l154_1;
  wire                when_MatrixEngine_l154_2;
  wire                when_MatrixEngine_l154_3;
  wire                when_MatrixEngine_l154_4;
  wire                when_MatrixEngine_l154_5;
  wire                when_MatrixEngine_l154_6;
  wire                when_MatrixEngine_l154_7;
  wire                when_MatrixEngine_l154_8;
  wire                when_MatrixEngine_l154_9;
  wire                when_MatrixEngine_l154_10;
  wire                when_MatrixEngine_l154_11;
  wire                when_MatrixEngine_l154_12;
  wire                when_MatrixEngine_l154_13;
  wire                when_MatrixEngine_l154_14;
  wire                when_MatrixEngine_l154_15;
  wire                when_MatrixEngine_l154_16;
  wire                when_MatrixEngine_l154_17;
  wire                when_MatrixEngine_l154_18;
  wire                when_MatrixEngine_l154_19;
  wire                when_MatrixEngine_l154_20;
  wire                when_MatrixEngine_l154_21;
  wire                when_MatrixEngine_l154_22;
  wire                when_MatrixEngine_l154_23;
  wire                when_MatrixEngine_l154_24;
  wire                when_MatrixEngine_l154_25;
  wire                when_MatrixEngine_l154_26;
  wire                when_MatrixEngine_l154_27;
  wire                when_MatrixEngine_l154_28;
  wire                when_MatrixEngine_l154_29;
  wire                when_MatrixEngine_l154_30;
  wire                when_MatrixEngine_l154_31;
  wire                when_MatrixEngine_l154_32;
  wire                when_MatrixEngine_l154_33;
  wire                when_MatrixEngine_l154_34;
  wire                when_MatrixEngine_l154_35;
  wire                when_MatrixEngine_l154_36;
  wire                when_MatrixEngine_l154_37;
  wire                when_MatrixEngine_l154_38;
  wire                when_MatrixEngine_l154_39;
  wire                when_MatrixEngine_l154_40;
  wire                when_MatrixEngine_l154_41;
  wire                when_MatrixEngine_l154_42;
  wire                when_MatrixEngine_l154_43;
  wire                when_MatrixEngine_l154_44;
  wire                when_MatrixEngine_l154_45;
  wire                when_MatrixEngine_l154_46;
  wire                when_MatrixEngine_l154_47;
  wire                when_MatrixEngine_l154_48;
  wire                when_MatrixEngine_l154_49;
  wire                when_MatrixEngine_l154_50;
  wire                when_MatrixEngine_l154_51;
  wire                when_MatrixEngine_l154_52;
  wire                when_MatrixEngine_l154_53;
  wire                when_MatrixEngine_l154_54;
  wire                when_MatrixEngine_l154_55;
  wire                when_MatrixEngine_l154_56;
  wire                when_MatrixEngine_l154_57;
  wire                when_MatrixEngine_l154_58;
  reg        [71:0]   fpProductE4M3;
  wire                when_MatrixEngine_l162;
  wire       [5:0]    _zz_when_MatrixEngine_l154_1;
  wire       [7:0]    _zz_fpProductE5M2;
  reg        [71:0]   _zz_fpProductE5M2_1;
  wire                when_MatrixEngine_l152_1;
  wire                when_MatrixEngine_l154_59;
  wire                when_MatrixEngine_l154_60;
  wire                when_MatrixEngine_l154_61;
  wire                when_MatrixEngine_l154_62;
  wire                when_MatrixEngine_l154_63;
  wire                when_MatrixEngine_l154_64;
  wire                when_MatrixEngine_l154_65;
  wire                when_MatrixEngine_l154_66;
  wire                when_MatrixEngine_l154_67;
  wire                when_MatrixEngine_l154_68;
  wire                when_MatrixEngine_l154_69;
  wire                when_MatrixEngine_l154_70;
  wire                when_MatrixEngine_l154_71;
  wire                when_MatrixEngine_l154_72;
  wire                when_MatrixEngine_l154_73;
  wire                when_MatrixEngine_l154_74;
  wire                when_MatrixEngine_l154_75;
  wire                when_MatrixEngine_l154_76;
  wire                when_MatrixEngine_l154_77;
  wire                when_MatrixEngine_l154_78;
  wire                when_MatrixEngine_l154_79;
  wire                when_MatrixEngine_l154_80;
  wire                when_MatrixEngine_l154_81;
  wire                when_MatrixEngine_l154_82;
  wire                when_MatrixEngine_l154_83;
  wire                when_MatrixEngine_l154_84;
  wire                when_MatrixEngine_l154_85;
  wire                when_MatrixEngine_l154_86;
  wire                when_MatrixEngine_l154_87;
  wire                when_MatrixEngine_l154_88;
  wire                when_MatrixEngine_l154_89;
  wire                when_MatrixEngine_l154_90;
  wire                when_MatrixEngine_l154_91;
  wire                when_MatrixEngine_l154_92;
  wire                when_MatrixEngine_l154_93;
  wire                when_MatrixEngine_l154_94;
  wire                when_MatrixEngine_l154_95;
  wire                when_MatrixEngine_l154_96;
  wire                when_MatrixEngine_l154_97;
  wire                when_MatrixEngine_l154_98;
  wire                when_MatrixEngine_l154_99;
  wire                when_MatrixEngine_l154_100;
  wire                when_MatrixEngine_l154_101;
  wire                when_MatrixEngine_l154_102;
  wire                when_MatrixEngine_l154_103;
  wire                when_MatrixEngine_l154_104;
  wire                when_MatrixEngine_l154_105;
  wire                when_MatrixEngine_l154_106;
  wire                when_MatrixEngine_l154_107;
  wire                when_MatrixEngine_l154_108;
  wire                when_MatrixEngine_l154_109;
  wire                when_MatrixEngine_l154_110;
  wire                when_MatrixEngine_l154_111;
  wire                when_MatrixEngine_l154_112;
  wire                when_MatrixEngine_l154_113;
  wire                when_MatrixEngine_l154_114;
  wire                when_MatrixEngine_l154_115;
  wire                when_MatrixEngine_l154_116;
  wire                when_MatrixEngine_l154_117;
  reg        [71:0]   fpProductE5M2;
  wire                when_MatrixEngine_l162_1;
  wire       [71:0]   fpProduct;
  wire                fpProductHasSpecial;
  reg        [31:0]   _zz_when_MatrixEngine_l290;
  wire                when_MatrixEngine_l175;
  reg        [71:0]   _zz_when_MatrixEngine_l89;
  reg        [6:0]    _zz_when_MatrixEngine_l184;
  wire                when_MatrixEngine_l89;
  wire                when_MatrixEngine_l89_1;
  wire                when_MatrixEngine_l89_2;
  wire                when_MatrixEngine_l89_3;
  wire                when_MatrixEngine_l89_4;
  wire                when_MatrixEngine_l89_5;
  wire                when_MatrixEngine_l89_6;
  wire                when_MatrixEngine_l89_7;
  wire                when_MatrixEngine_l89_8;
  wire                when_MatrixEngine_l89_9;
  wire                when_MatrixEngine_l89_10;
  wire                when_MatrixEngine_l89_11;
  wire                when_MatrixEngine_l89_12;
  wire                when_MatrixEngine_l89_13;
  wire                when_MatrixEngine_l89_14;
  wire                when_MatrixEngine_l89_15;
  wire                when_MatrixEngine_l89_16;
  wire                when_MatrixEngine_l89_17;
  wire                when_MatrixEngine_l89_18;
  wire                when_MatrixEngine_l89_19;
  wire                when_MatrixEngine_l89_20;
  wire                when_MatrixEngine_l89_21;
  wire                when_MatrixEngine_l89_22;
  wire                when_MatrixEngine_l89_23;
  wire                when_MatrixEngine_l89_24;
  wire                when_MatrixEngine_l89_25;
  wire                when_MatrixEngine_l89_26;
  wire                when_MatrixEngine_l89_27;
  wire                when_MatrixEngine_l89_28;
  wire                when_MatrixEngine_l89_29;
  wire                when_MatrixEngine_l89_30;
  wire                when_MatrixEngine_l89_31;
  wire                when_MatrixEngine_l89_32;
  wire                when_MatrixEngine_l89_33;
  wire                when_MatrixEngine_l89_34;
  wire                when_MatrixEngine_l89_35;
  wire                when_MatrixEngine_l89_36;
  wire                when_MatrixEngine_l89_37;
  wire                when_MatrixEngine_l89_38;
  wire                when_MatrixEngine_l89_39;
  wire                when_MatrixEngine_l89_40;
  wire                when_MatrixEngine_l89_41;
  wire                when_MatrixEngine_l89_42;
  wire                when_MatrixEngine_l89_43;
  wire                when_MatrixEngine_l89_44;
  wire                when_MatrixEngine_l89_45;
  wire                when_MatrixEngine_l89_46;
  wire                when_MatrixEngine_l89_47;
  wire                when_MatrixEngine_l89_48;
  wire                when_MatrixEngine_l89_49;
  wire                when_MatrixEngine_l89_50;
  wire                when_MatrixEngine_l89_51;
  wire                when_MatrixEngine_l89_52;
  wire                when_MatrixEngine_l89_53;
  wire                when_MatrixEngine_l89_54;
  wire                when_MatrixEngine_l89_55;
  wire                when_MatrixEngine_l89_56;
  wire                when_MatrixEngine_l89_57;
  wire                when_MatrixEngine_l89_58;
  wire                when_MatrixEngine_l89_59;
  wire                when_MatrixEngine_l89_60;
  wire                when_MatrixEngine_l89_61;
  wire                when_MatrixEngine_l89_62;
  wire                when_MatrixEngine_l89_63;
  wire                when_MatrixEngine_l89_64;
  wire                when_MatrixEngine_l89_65;
  wire                when_MatrixEngine_l89_66;
  wire                when_MatrixEngine_l89_67;
  wire                when_MatrixEngine_l89_68;
  wire                when_MatrixEngine_l89_69;
  wire                when_MatrixEngine_l89_70;
  wire                when_MatrixEngine_l89_71;
  reg        [5:0]    _zz_when_MatrixEngine_l209;
  wire                when_MatrixEngine_l184;
  reg        [4:0]    _zz_when_MatrixEngine_l204;
  wire                when_MatrixEngine_l190;
  reg        [23:0]   _zz_when_MatrixEngine_l233;
  reg                 _zz_when_MatrixEngine_l233_1;
  reg                 _zz_when_MatrixEngine_l233_2;
  wire                when_MatrixEngine_l201;
  wire                when_MatrixEngine_l202;
  wire                when_MatrixEngine_l204;
  wire                when_MatrixEngine_l204_1;
  wire                when_MatrixEngine_l204_2;
  wire                when_MatrixEngine_l204_3;
  wire                when_MatrixEngine_l204_4;
  wire                when_MatrixEngine_l204_5;
  wire                when_MatrixEngine_l204_6;
  wire                when_MatrixEngine_l204_7;
  wire                when_MatrixEngine_l204_8;
  wire                when_MatrixEngine_l204_9;
  wire                when_MatrixEngine_l204_10;
  wire                when_MatrixEngine_l204_11;
  wire                when_MatrixEngine_l204_12;
  wire                when_MatrixEngine_l204_13;
  wire                when_MatrixEngine_l204_14;
  wire                when_MatrixEngine_l204_15;
  wire                when_MatrixEngine_l204_16;
  wire                when_MatrixEngine_l204_17;
  wire                when_MatrixEngine_l204_18;
  wire                when_MatrixEngine_l204_19;
  wire                when_MatrixEngine_l204_20;
  wire                when_MatrixEngine_l204_21;
  wire                when_MatrixEngine_l204_22;
  wire                when_MatrixEngine_l204_23;
  wire                when_MatrixEngine_l209;
  wire                when_MatrixEngine_l213;
  wire                when_MatrixEngine_l213_1;
  wire                when_MatrixEngine_l213_2;
  wire                when_MatrixEngine_l213_3;
  wire                when_MatrixEngine_l213_4;
  wire                when_MatrixEngine_l213_5;
  wire                when_MatrixEngine_l213_6;
  wire                when_MatrixEngine_l213_7;
  wire                when_MatrixEngine_l213_8;
  wire                when_MatrixEngine_l213_9;
  wire                when_MatrixEngine_l213_10;
  wire                when_MatrixEngine_l213_11;
  wire                when_MatrixEngine_l213_12;
  wire                when_MatrixEngine_l213_13;
  wire                when_MatrixEngine_l213_14;
  wire                when_MatrixEngine_l213_15;
  wire                when_MatrixEngine_l213_16;
  wire                when_MatrixEngine_l213_17;
  wire                when_MatrixEngine_l213_18;
  wire                when_MatrixEngine_l213_19;
  wire                when_MatrixEngine_l213_20;
  wire                when_MatrixEngine_l213_21;
  wire                when_MatrixEngine_l213_22;
  wire                when_MatrixEngine_l213_23;
  wire                when_MatrixEngine_l213_24;
  wire                when_MatrixEngine_l213_25;
  wire                when_MatrixEngine_l213_26;
  wire                when_MatrixEngine_l213_27;
  wire                when_MatrixEngine_l213_28;
  wire                when_MatrixEngine_l213_29;
  wire                when_MatrixEngine_l213_30;
  wire                when_MatrixEngine_l213_31;
  wire                when_MatrixEngine_l213_32;
  wire                when_MatrixEngine_l213_33;
  wire                when_MatrixEngine_l213_34;
  wire                when_MatrixEngine_l213_35;
  wire                when_MatrixEngine_l213_36;
  wire                when_MatrixEngine_l213_37;
  wire                when_MatrixEngine_l213_38;
  wire                when_MatrixEngine_l213_39;
  wire                when_MatrixEngine_l213_40;
  wire                when_MatrixEngine_l213_41;
  wire                when_MatrixEngine_l213_42;
  wire                when_MatrixEngine_l213_43;
  wire                when_MatrixEngine_l213_44;
  wire                when_MatrixEngine_l213_45;
  wire                when_MatrixEngine_l213_46;
  wire                when_MatrixEngine_l213_47;
  wire       [24:0]   _zz_when_MatrixEngine_l233_3;
  wire       [7:0]    _zz_when_MatrixEngine_l290_1;
  reg        [7:0]    _zz_when_MatrixEngine_l290_2;
  reg        [23:0]   _zz_when_MatrixEngine_l290_3;
  wire                when_MatrixEngine_l233;
  wire                when_MatrixEngine_l290;
  wire       [7:0]    _zz_when_MatrixEngine_l251;
  wire       [22:0]   _zz_roundedFpAcc;
  reg        [71:0]   _zz_roundedFpAcc_1;
  wire                when_MatrixEngine_l251;
  wire       [23:0]   _zz_roundedFpAcc_2;
  wire                when_MatrixEngine_l257;
  wire       [5:0]    _zz_when_MatrixEngine_l262;
  wire                when_MatrixEngine_l262;
  wire                when_MatrixEngine_l262_1;
  wire                when_MatrixEngine_l262_2;
  wire                when_MatrixEngine_l262_3;
  wire                when_MatrixEngine_l262_4;
  wire                when_MatrixEngine_l262_5;
  wire                when_MatrixEngine_l262_6;
  wire                when_MatrixEngine_l262_7;
  wire                when_MatrixEngine_l262_8;
  wire                when_MatrixEngine_l262_9;
  wire                when_MatrixEngine_l262_10;
  wire                when_MatrixEngine_l262_11;
  wire                when_MatrixEngine_l262_12;
  wire                when_MatrixEngine_l262_13;
  wire                when_MatrixEngine_l262_14;
  wire                when_MatrixEngine_l262_15;
  wire                when_MatrixEngine_l262_16;
  wire                when_MatrixEngine_l262_17;
  wire                when_MatrixEngine_l262_18;
  wire                when_MatrixEngine_l262_19;
  wire                when_MatrixEngine_l262_20;
  wire                when_MatrixEngine_l262_21;
  wire                when_MatrixEngine_l262_22;
  wire                when_MatrixEngine_l262_23;
  wire                when_MatrixEngine_l262_24;
  wire                when_MatrixEngine_l262_25;
  wire                when_MatrixEngine_l262_26;
  wire                when_MatrixEngine_l262_27;
  wire                when_MatrixEngine_l262_28;
  wire                when_MatrixEngine_l262_29;
  wire                when_MatrixEngine_l262_30;
  wire                when_MatrixEngine_l262_31;
  wire                when_MatrixEngine_l262_32;
  wire                when_MatrixEngine_l262_33;
  wire                when_MatrixEngine_l262_34;
  wire                when_MatrixEngine_l262_35;
  wire                when_MatrixEngine_l262_36;
  wire                when_MatrixEngine_l262_37;
  wire                when_MatrixEngine_l262_38;
  wire                when_MatrixEngine_l262_39;
  wire                when_MatrixEngine_l262_40;
  wire                when_MatrixEngine_l262_41;
  wire                when_MatrixEngine_l262_42;
  wire                when_MatrixEngine_l262_43;
  wire                when_MatrixEngine_l262_44;
  wire                when_MatrixEngine_l262_45;
  wire                when_MatrixEngine_l262_46;
  wire                when_MatrixEngine_l262_47;
  wire                when_MatrixEngine_l262_48;
  wire       [7:0]    _zz_when_MatrixEngine_l268;
  wire                when_MatrixEngine_l268;
  wire       [4:0]    _zz_when_MatrixEngine_l272;
  wire                when_MatrixEngine_l272;
  wire                when_MatrixEngine_l276;
  wire       [71:0]   _zz_roundedFpAcc_3;
  wire                when_MatrixEngine_l276_1;
  wire       [71:0]   _zz_roundedFpAcc_4;
  wire                when_MatrixEngine_l276_2;
  wire       [71:0]   _zz_roundedFpAcc_5;
  wire                when_MatrixEngine_l276_3;
  wire       [71:0]   _zz_roundedFpAcc_6;
  wire                when_MatrixEngine_l276_4;
  wire       [71:0]   _zz_roundedFpAcc_7;
  wire                when_MatrixEngine_l276_5;
  wire       [71:0]   _zz_roundedFpAcc_8;
  wire                when_MatrixEngine_l276_6;
  wire       [71:0]   _zz_roundedFpAcc_9;
  wire                when_MatrixEngine_l276_7;
  wire       [71:0]   _zz_roundedFpAcc_10;
  wire                when_MatrixEngine_l276_8;
  wire       [71:0]   _zz_roundedFpAcc_11;
  wire                when_MatrixEngine_l276_9;
  wire       [71:0]   _zz_roundedFpAcc_12;
  wire                when_MatrixEngine_l276_10;
  wire       [71:0]   _zz_roundedFpAcc_13;
  wire                when_MatrixEngine_l276_11;
  wire       [71:0]   _zz_roundedFpAcc_14;
  wire                when_MatrixEngine_l276_12;
  wire       [71:0]   _zz_roundedFpAcc_15;
  wire                when_MatrixEngine_l276_13;
  wire       [71:0]   _zz_roundedFpAcc_16;
  wire                when_MatrixEngine_l276_14;
  wire       [71:0]   _zz_roundedFpAcc_17;
  wire                when_MatrixEngine_l276_15;
  wire       [71:0]   _zz_roundedFpAcc_18;
  wire                when_MatrixEngine_l276_16;
  wire       [71:0]   _zz_roundedFpAcc_19;
  wire                when_MatrixEngine_l276_17;
  wire       [71:0]   _zz_roundedFpAcc_20;
  wire                when_MatrixEngine_l276_18;
  wire       [71:0]   _zz_roundedFpAcc_21;
  wire                when_MatrixEngine_l276_19;
  wire       [71:0]   _zz_roundedFpAcc_22;
  wire                when_MatrixEngine_l276_20;
  wire       [71:0]   _zz_roundedFpAcc_23;
  wire                when_MatrixEngine_l276_21;
  wire       [71:0]   _zz_roundedFpAcc_24;
  wire                when_MatrixEngine_l276_22;
  wire       [71:0]   _zz_roundedFpAcc_25;
  wire                when_MatrixEngine_l276_23;
  wire       [71:0]   _zz_roundedFpAcc_26;
  wire                when_MatrixEngine_l253;
  reg        [71:0]   roundedFpAcc;
  wire                when_MatrixEngine_l364;
  wire                when_MatrixEngine_l379;
  wire                when_MatrixEngine_l382;
  wire                when_MatrixEngine_l395;
  wire                when_MatrixEngine_l411;
  wire                when_MatrixEngine_l290_1;
  wire       [7:0]    _zz_when_MatrixEngine_l251_1;
  wire       [22:0]   _zz_fpAccReg;
  reg        [71:0]   _zz_fpAccReg_1;
  wire                when_MatrixEngine_l251_1;
  wire       [23:0]   _zz_fpAccReg_2;
  wire                when_MatrixEngine_l257_1;
  wire       [5:0]    _zz_when_MatrixEngine_l262_1;
  wire                when_MatrixEngine_l262_49;
  wire                when_MatrixEngine_l262_50;
  wire                when_MatrixEngine_l262_51;
  wire                when_MatrixEngine_l262_52;
  wire                when_MatrixEngine_l262_53;
  wire                when_MatrixEngine_l262_54;
  wire                when_MatrixEngine_l262_55;
  wire                when_MatrixEngine_l262_56;
  wire                when_MatrixEngine_l262_57;
  wire                when_MatrixEngine_l262_58;
  wire                when_MatrixEngine_l262_59;
  wire                when_MatrixEngine_l262_60;
  wire                when_MatrixEngine_l262_61;
  wire                when_MatrixEngine_l262_62;
  wire                when_MatrixEngine_l262_63;
  wire                when_MatrixEngine_l262_64;
  wire                when_MatrixEngine_l262_65;
  wire                when_MatrixEngine_l262_66;
  wire                when_MatrixEngine_l262_67;
  wire                when_MatrixEngine_l262_68;
  wire                when_MatrixEngine_l262_69;
  wire                when_MatrixEngine_l262_70;
  wire                when_MatrixEngine_l262_71;
  wire                when_MatrixEngine_l262_72;
  wire                when_MatrixEngine_l262_73;
  wire                when_MatrixEngine_l262_74;
  wire                when_MatrixEngine_l262_75;
  wire                when_MatrixEngine_l262_76;
  wire                when_MatrixEngine_l262_77;
  wire                when_MatrixEngine_l262_78;
  wire                when_MatrixEngine_l262_79;
  wire                when_MatrixEngine_l262_80;
  wire                when_MatrixEngine_l262_81;
  wire                when_MatrixEngine_l262_82;
  wire                when_MatrixEngine_l262_83;
  wire                when_MatrixEngine_l262_84;
  wire                when_MatrixEngine_l262_85;
  wire                when_MatrixEngine_l262_86;
  wire                when_MatrixEngine_l262_87;
  wire                when_MatrixEngine_l262_88;
  wire                when_MatrixEngine_l262_89;
  wire                when_MatrixEngine_l262_90;
  wire                when_MatrixEngine_l262_91;
  wire                when_MatrixEngine_l262_92;
  wire                when_MatrixEngine_l262_93;
  wire                when_MatrixEngine_l262_94;
  wire                when_MatrixEngine_l262_95;
  wire                when_MatrixEngine_l262_96;
  wire                when_MatrixEngine_l262_97;
  wire       [7:0]    _zz_when_MatrixEngine_l268_1;
  wire                when_MatrixEngine_l268_1;
  wire       [4:0]    _zz_when_MatrixEngine_l272_1;
  wire                when_MatrixEngine_l272_1;
  wire                when_MatrixEngine_l276_24;
  wire       [71:0]   _zz_fpAccReg_3;
  wire                when_MatrixEngine_l276_25;
  wire       [71:0]   _zz_fpAccReg_4;
  wire                when_MatrixEngine_l276_26;
  wire       [71:0]   _zz_fpAccReg_5;
  wire                when_MatrixEngine_l276_27;
  wire       [71:0]   _zz_fpAccReg_6;
  wire                when_MatrixEngine_l276_28;
  wire       [71:0]   _zz_fpAccReg_7;
  wire                when_MatrixEngine_l276_29;
  wire       [71:0]   _zz_fpAccReg_8;
  wire                when_MatrixEngine_l276_30;
  wire       [71:0]   _zz_fpAccReg_9;
  wire                when_MatrixEngine_l276_31;
  wire       [71:0]   _zz_fpAccReg_10;
  wire                when_MatrixEngine_l276_32;
  wire       [71:0]   _zz_fpAccReg_11;
  wire                when_MatrixEngine_l276_33;
  wire       [71:0]   _zz_fpAccReg_12;
  wire                when_MatrixEngine_l276_34;
  wire       [71:0]   _zz_fpAccReg_13;
  wire                when_MatrixEngine_l276_35;
  wire       [71:0]   _zz_fpAccReg_14;
  wire                when_MatrixEngine_l276_36;
  wire       [71:0]   _zz_fpAccReg_15;
  wire                when_MatrixEngine_l276_37;
  wire       [71:0]   _zz_fpAccReg_16;
  wire                when_MatrixEngine_l276_38;
  wire       [71:0]   _zz_fpAccReg_17;
  wire                when_MatrixEngine_l276_39;
  wire       [71:0]   _zz_fpAccReg_18;
  wire                when_MatrixEngine_l276_40;
  wire       [71:0]   _zz_fpAccReg_19;
  wire                when_MatrixEngine_l276_41;
  wire       [71:0]   _zz_fpAccReg_20;
  wire                when_MatrixEngine_l276_42;
  wire       [71:0]   _zz_fpAccReg_21;
  wire                when_MatrixEngine_l276_43;
  wire       [71:0]   _zz_fpAccReg_22;
  wire                when_MatrixEngine_l276_44;
  wire       [71:0]   _zz_fpAccReg_23;
  wire                when_MatrixEngine_l276_45;
  wire       [71:0]   _zz_fpAccReg_24;
  wire                when_MatrixEngine_l276_46;
  wire       [71:0]   _zz_fpAccReg_25;
  wire                when_MatrixEngine_l276_47;
  wire       [71:0]   _zz_fpAccReg_26;
  wire                when_MatrixEngine_l253_1;
  reg        [71:0]   _zz_fpAccReg_27;
  wire                when_MatrixEngine_l458;
  reg        [31:0]   _zz_io_matrixAccumWrData;
  wire                when_MatrixEngine_l175_1;
  reg        [71:0]   _zz_when_MatrixEngine_l89_1;
  reg        [6:0]    _zz_when_MatrixEngine_l184_1;
  wire                when_MatrixEngine_l89_72;
  wire                when_MatrixEngine_l89_73;
  wire                when_MatrixEngine_l89_74;
  wire                when_MatrixEngine_l89_75;
  wire                when_MatrixEngine_l89_76;
  wire                when_MatrixEngine_l89_77;
  wire                when_MatrixEngine_l89_78;
  wire                when_MatrixEngine_l89_79;
  wire                when_MatrixEngine_l89_80;
  wire                when_MatrixEngine_l89_81;
  wire                when_MatrixEngine_l89_82;
  wire                when_MatrixEngine_l89_83;
  wire                when_MatrixEngine_l89_84;
  wire                when_MatrixEngine_l89_85;
  wire                when_MatrixEngine_l89_86;
  wire                when_MatrixEngine_l89_87;
  wire                when_MatrixEngine_l89_88;
  wire                when_MatrixEngine_l89_89;
  wire                when_MatrixEngine_l89_90;
  wire                when_MatrixEngine_l89_91;
  wire                when_MatrixEngine_l89_92;
  wire                when_MatrixEngine_l89_93;
  wire                when_MatrixEngine_l89_94;
  wire                when_MatrixEngine_l89_95;
  wire                when_MatrixEngine_l89_96;
  wire                when_MatrixEngine_l89_97;
  wire                when_MatrixEngine_l89_98;
  wire                when_MatrixEngine_l89_99;
  wire                when_MatrixEngine_l89_100;
  wire                when_MatrixEngine_l89_101;
  wire                when_MatrixEngine_l89_102;
  wire                when_MatrixEngine_l89_103;
  wire                when_MatrixEngine_l89_104;
  wire                when_MatrixEngine_l89_105;
  wire                when_MatrixEngine_l89_106;
  wire                when_MatrixEngine_l89_107;
  wire                when_MatrixEngine_l89_108;
  wire                when_MatrixEngine_l89_109;
  wire                when_MatrixEngine_l89_110;
  wire                when_MatrixEngine_l89_111;
  wire                when_MatrixEngine_l89_112;
  wire                when_MatrixEngine_l89_113;
  wire                when_MatrixEngine_l89_114;
  wire                when_MatrixEngine_l89_115;
  wire                when_MatrixEngine_l89_116;
  wire                when_MatrixEngine_l89_117;
  wire                when_MatrixEngine_l89_118;
  wire                when_MatrixEngine_l89_119;
  wire                when_MatrixEngine_l89_120;
  wire                when_MatrixEngine_l89_121;
  wire                when_MatrixEngine_l89_122;
  wire                when_MatrixEngine_l89_123;
  wire                when_MatrixEngine_l89_124;
  wire                when_MatrixEngine_l89_125;
  wire                when_MatrixEngine_l89_126;
  wire                when_MatrixEngine_l89_127;
  wire                when_MatrixEngine_l89_128;
  wire                when_MatrixEngine_l89_129;
  wire                when_MatrixEngine_l89_130;
  wire                when_MatrixEngine_l89_131;
  wire                when_MatrixEngine_l89_132;
  wire                when_MatrixEngine_l89_133;
  wire                when_MatrixEngine_l89_134;
  wire                when_MatrixEngine_l89_135;
  wire                when_MatrixEngine_l89_136;
  wire                when_MatrixEngine_l89_137;
  wire                when_MatrixEngine_l89_138;
  wire                when_MatrixEngine_l89_139;
  wire                when_MatrixEngine_l89_140;
  wire                when_MatrixEngine_l89_141;
  wire                when_MatrixEngine_l89_142;
  wire                when_MatrixEngine_l89_143;
  reg        [5:0]    _zz_when_MatrixEngine_l209_1;
  wire                when_MatrixEngine_l184_1;
  reg        [4:0]    _zz_when_MatrixEngine_l204_1;
  wire                when_MatrixEngine_l190_1;
  reg        [23:0]   _zz_when_MatrixEngine_l233_4;
  reg                 _zz_when_MatrixEngine_l233_5;
  reg                 _zz_when_MatrixEngine_l233_6;
  wire                when_MatrixEngine_l201_1;
  wire                when_MatrixEngine_l202_1;
  wire                when_MatrixEngine_l204_24;
  wire                when_MatrixEngine_l204_25;
  wire                when_MatrixEngine_l204_26;
  wire                when_MatrixEngine_l204_27;
  wire                when_MatrixEngine_l204_28;
  wire                when_MatrixEngine_l204_29;
  wire                when_MatrixEngine_l204_30;
  wire                when_MatrixEngine_l204_31;
  wire                when_MatrixEngine_l204_32;
  wire                when_MatrixEngine_l204_33;
  wire                when_MatrixEngine_l204_34;
  wire                when_MatrixEngine_l204_35;
  wire                when_MatrixEngine_l204_36;
  wire                when_MatrixEngine_l204_37;
  wire                when_MatrixEngine_l204_38;
  wire                when_MatrixEngine_l204_39;
  wire                when_MatrixEngine_l204_40;
  wire                when_MatrixEngine_l204_41;
  wire                when_MatrixEngine_l204_42;
  wire                when_MatrixEngine_l204_43;
  wire                when_MatrixEngine_l204_44;
  wire                when_MatrixEngine_l204_45;
  wire                when_MatrixEngine_l204_46;
  wire                when_MatrixEngine_l204_47;
  wire                when_MatrixEngine_l209_1;
  wire                when_MatrixEngine_l213_48;
  wire                when_MatrixEngine_l213_49;
  wire                when_MatrixEngine_l213_50;
  wire                when_MatrixEngine_l213_51;
  wire                when_MatrixEngine_l213_52;
  wire                when_MatrixEngine_l213_53;
  wire                when_MatrixEngine_l213_54;
  wire                when_MatrixEngine_l213_55;
  wire                when_MatrixEngine_l213_56;
  wire                when_MatrixEngine_l213_57;
  wire                when_MatrixEngine_l213_58;
  wire                when_MatrixEngine_l213_59;
  wire                when_MatrixEngine_l213_60;
  wire                when_MatrixEngine_l213_61;
  wire                when_MatrixEngine_l213_62;
  wire                when_MatrixEngine_l213_63;
  wire                when_MatrixEngine_l213_64;
  wire                when_MatrixEngine_l213_65;
  wire                when_MatrixEngine_l213_66;
  wire                when_MatrixEngine_l213_67;
  wire                when_MatrixEngine_l213_68;
  wire                when_MatrixEngine_l213_69;
  wire                when_MatrixEngine_l213_70;
  wire                when_MatrixEngine_l213_71;
  wire                when_MatrixEngine_l213_72;
  wire                when_MatrixEngine_l213_73;
  wire                when_MatrixEngine_l213_74;
  wire                when_MatrixEngine_l213_75;
  wire                when_MatrixEngine_l213_76;
  wire                when_MatrixEngine_l213_77;
  wire                when_MatrixEngine_l213_78;
  wire                when_MatrixEngine_l213_79;
  wire                when_MatrixEngine_l213_80;
  wire                when_MatrixEngine_l213_81;
  wire                when_MatrixEngine_l213_82;
  wire                when_MatrixEngine_l213_83;
  wire                when_MatrixEngine_l213_84;
  wire                when_MatrixEngine_l213_85;
  wire                when_MatrixEngine_l213_86;
  wire                when_MatrixEngine_l213_87;
  wire                when_MatrixEngine_l213_88;
  wire                when_MatrixEngine_l213_89;
  wire                when_MatrixEngine_l213_90;
  wire                when_MatrixEngine_l213_91;
  wire                when_MatrixEngine_l213_92;
  wire                when_MatrixEngine_l213_93;
  wire                when_MatrixEngine_l213_94;
  wire                when_MatrixEngine_l213_95;
  wire       [24:0]   _zz_when_MatrixEngine_l233_7;
  wire       [7:0]    _zz_io_matrixAccumWrData_1;
  reg        [7:0]    _zz_io_matrixAccumWrData_2;
  reg        [23:0]   _zz_io_matrixAccumWrData_3;
  wire                when_MatrixEngine_l233_1;
  wire                when_MatrixEngine_l476;
  wire                when_MatrixEngine_l481;
  `ifndef SYNTHESIS
  reg [71:0] state_string;
  `endif


  assign _zz_slotTileElems = (io_slots_0_tileRows * io_slots_0_tileCols);
  assign _zz_outputIndex = (_zz_outputIndex_1 + _zz_outputIndex_3);
  assign _zz_outputIndex_1 = (_zz_outputIndex_2 * 6'h08);
  assign _zz_outputIndex_2 = {3'd0, rowReg};
  assign _zz_outputIndex_4 = {3'd0, colReg};
  assign _zz_outputIndex_3 = {6'd0, _zz_outputIndex_4};
  assign _zz_aIndex = (_zz_aIndex_1 + _zz_aIndex_3);
  assign _zz_aIndex_1 = (_zz_aIndex_2 * 8'h08);
  assign _zz_aIndex_2 = {5'd0, rowReg};
  assign _zz_aIndex_4 = {5'd0, kReg};
  assign _zz_aIndex_3 = {8'd0, _zz_aIndex_4};
  assign _zz_bIndex = (_zz_bIndex_1 + _zz_bIndex_3);
  assign _zz_bIndex_1 = (_zz_bIndex_2 * 8'h08);
  assign _zz_bIndex_2 = {5'd0, kReg};
  assign _zz_bIndex_4 = {5'd0, colReg};
  assign _zz_bIndex_3 = {8'd0, _zz_bIndex_4};
  assign _zz_aValue = io_matrixScratchARdData;
  assign _zz_bValue = io_matrixScratchBRdData;
  assign _zz_product = ($signed(aValue) * $signed(bValue));
  assign _zz_fpA_E4M3_shift = {2'd0, _zz_fpA_E4M3_isZero};
  assign _zz_fpB_E4M3_shift = {2'd0, _zz_fpB_E4M3_isZero};
  assign _zz_fpA_E5M2_shift = {1'd0, _zz_fpA_E5M2_isZero};
  assign _zz_fpB_E5M2_shift = {1'd0, _zz_fpB_E5M2_isZero};
  assign _zz__zz_when_MatrixEngine_l154 = (_zz__zz_when_MatrixEngine_l154_1 - 7'h20);
  assign _zz__zz_when_MatrixEngine_l154_1 = (_zz__zz_when_MatrixEngine_l154_2 + _zz__zz_when_MatrixEngine_l154_3);
  assign _zz__zz_when_MatrixEngine_l154_2 = {1'd0, fpA_E4M3_shift};
  assign _zz__zz_when_MatrixEngine_l154_3 = {1'd0, fpB_E4M3_shift};
  assign _zz__zz_fpProductE4M3 = (_zz__zz_fpProductE4M3_1 * _zz__zz_fpProductE4M3_2);
  assign _zz__zz_fpProductE4M3_1 = {4'd0, fpA_E4M3_sig};
  assign _zz__zz_fpProductE4M3_2 = {4'd0, fpB_E4M3_sig};
  assign _zz__zz_fpProductE4M3_1_1 = ({1'd0,_zz__zz_fpProductE4M3_1_2} <<< 1'd1);
  assign _zz__zz_fpProductE4M3_1_2 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_3 = ({2'd0,_zz__zz_fpProductE4M3_1_4} <<< 2'd2);
  assign _zz__zz_fpProductE4M3_1_4 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_5 = ({3'd0,_zz__zz_fpProductE4M3_1_6} <<< 2'd3);
  assign _zz__zz_fpProductE4M3_1_6 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_7 = ({4'd0,_zz__zz_fpProductE4M3_1_8} <<< 3'd4);
  assign _zz__zz_fpProductE4M3_1_8 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_9 = ({5'd0,_zz__zz_fpProductE4M3_1_10} <<< 3'd5);
  assign _zz__zz_fpProductE4M3_1_10 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_11 = ({6'd0,_zz__zz_fpProductE4M3_1_12} <<< 3'd6);
  assign _zz__zz_fpProductE4M3_1_12 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_13 = ({7'd0,_zz__zz_fpProductE4M3_1_14} <<< 3'd7);
  assign _zz__zz_fpProductE4M3_1_14 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_15 = ({8'd0,_zz__zz_fpProductE4M3_1_16} <<< 4'd8);
  assign _zz__zz_fpProductE4M3_1_16 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_17 = ({9'd0,_zz__zz_fpProductE4M3_1_18} <<< 4'd9);
  assign _zz__zz_fpProductE4M3_1_18 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_19 = ({10'd0,_zz__zz_fpProductE4M3_1_20} <<< 4'd10);
  assign _zz__zz_fpProductE4M3_1_20 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_21 = ({11'd0,_zz__zz_fpProductE4M3_1_22} <<< 4'd11);
  assign _zz__zz_fpProductE4M3_1_22 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_23 = ({12'd0,_zz__zz_fpProductE4M3_1_24} <<< 4'd12);
  assign _zz__zz_fpProductE4M3_1_24 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_25 = ({13'd0,_zz__zz_fpProductE4M3_1_26} <<< 4'd13);
  assign _zz__zz_fpProductE4M3_1_26 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_27 = ({14'd0,_zz__zz_fpProductE4M3_1_28} <<< 4'd14);
  assign _zz__zz_fpProductE4M3_1_28 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_29 = ({15'd0,_zz__zz_fpProductE4M3_1_30} <<< 4'd15);
  assign _zz__zz_fpProductE4M3_1_30 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_31 = ({16'd0,_zz__zz_fpProductE4M3_1_32} <<< 5'd16);
  assign _zz__zz_fpProductE4M3_1_32 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_33 = ({17'd0,_zz__zz_fpProductE4M3_1_34} <<< 5'd17);
  assign _zz__zz_fpProductE4M3_1_34 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_35 = ({18'd0,_zz__zz_fpProductE4M3_1_36} <<< 5'd18);
  assign _zz__zz_fpProductE4M3_1_36 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_37 = ({19'd0,_zz__zz_fpProductE4M3_1_38} <<< 5'd19);
  assign _zz__zz_fpProductE4M3_1_38 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_39 = ({20'd0,_zz__zz_fpProductE4M3_1_40} <<< 5'd20);
  assign _zz__zz_fpProductE4M3_1_40 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_41 = ({21'd0,_zz__zz_fpProductE4M3_1_42} <<< 5'd21);
  assign _zz__zz_fpProductE4M3_1_42 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_43 = ({22'd0,_zz__zz_fpProductE4M3_1_44} <<< 5'd22);
  assign _zz__zz_fpProductE4M3_1_44 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_45 = ({23'd0,_zz__zz_fpProductE4M3_1_46} <<< 5'd23);
  assign _zz__zz_fpProductE4M3_1_46 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_47 = ({24'd0,_zz__zz_fpProductE4M3_1_48} <<< 5'd24);
  assign _zz__zz_fpProductE4M3_1_48 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_49 = ({25'd0,_zz__zz_fpProductE4M3_1_50} <<< 5'd25);
  assign _zz__zz_fpProductE4M3_1_50 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_51 = ({26'd0,_zz__zz_fpProductE4M3_1_52} <<< 5'd26);
  assign _zz__zz_fpProductE4M3_1_52 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_53 = ({27'd0,_zz__zz_fpProductE4M3_1_54} <<< 5'd27);
  assign _zz__zz_fpProductE4M3_1_54 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_55 = ({28'd0,_zz__zz_fpProductE4M3_1_56} <<< 5'd28);
  assign _zz__zz_fpProductE4M3_1_56 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_57 = ({29'd0,_zz__zz_fpProductE4M3_1_58} <<< 5'd29);
  assign _zz__zz_fpProductE4M3_1_58 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_59 = ({30'd0,_zz__zz_fpProductE4M3_1_60} <<< 5'd30);
  assign _zz__zz_fpProductE4M3_1_60 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_61 = ({31'd0,_zz__zz_fpProductE4M3_1_62} <<< 5'd31);
  assign _zz__zz_fpProductE4M3_1_62 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_63 = ({32'd0,_zz__zz_fpProductE4M3_1_64} <<< 6'd32);
  assign _zz__zz_fpProductE4M3_1_64 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_65 = ({33'd0,_zz__zz_fpProductE4M3_1_66} <<< 6'd33);
  assign _zz__zz_fpProductE4M3_1_66 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_67 = ({34'd0,_zz__zz_fpProductE4M3_1_68} <<< 6'd34);
  assign _zz__zz_fpProductE4M3_1_68 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_69 = ({35'd0,_zz__zz_fpProductE4M3_1_70} <<< 6'd35);
  assign _zz__zz_fpProductE4M3_1_70 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_71 = ({36'd0,_zz__zz_fpProductE4M3_1_72} <<< 6'd36);
  assign _zz__zz_fpProductE4M3_1_72 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_73 = ({37'd0,_zz__zz_fpProductE4M3_1_74} <<< 6'd37);
  assign _zz__zz_fpProductE4M3_1_74 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_75 = ({38'd0,_zz__zz_fpProductE4M3_1_76} <<< 6'd38);
  assign _zz__zz_fpProductE4M3_1_76 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_77 = ({39'd0,_zz__zz_fpProductE4M3_1_78} <<< 6'd39);
  assign _zz__zz_fpProductE4M3_1_78 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_79 = ({40'd0,_zz__zz_fpProductE4M3_1_80} <<< 6'd40);
  assign _zz__zz_fpProductE4M3_1_80 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_81 = ({41'd0,_zz__zz_fpProductE4M3_1_82} <<< 6'd41);
  assign _zz__zz_fpProductE4M3_1_82 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_83 = ({42'd0,_zz__zz_fpProductE4M3_1_84} <<< 6'd42);
  assign _zz__zz_fpProductE4M3_1_84 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_85 = ({43'd0,_zz__zz_fpProductE4M3_1_86} <<< 6'd43);
  assign _zz__zz_fpProductE4M3_1_86 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_87 = ({44'd0,_zz__zz_fpProductE4M3_1_88} <<< 6'd44);
  assign _zz__zz_fpProductE4M3_1_88 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_89 = ({45'd0,_zz__zz_fpProductE4M3_1_90} <<< 6'd45);
  assign _zz__zz_fpProductE4M3_1_90 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_91 = ({46'd0,_zz__zz_fpProductE4M3_1_92} <<< 6'd46);
  assign _zz__zz_fpProductE4M3_1_92 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_93 = ({47'd0,_zz__zz_fpProductE4M3_1_94} <<< 6'd47);
  assign _zz__zz_fpProductE4M3_1_94 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_95 = ({48'd0,_zz__zz_fpProductE4M3_1_96} <<< 6'd48);
  assign _zz__zz_fpProductE4M3_1_96 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_97 = ({49'd0,_zz__zz_fpProductE4M3_1_98} <<< 6'd49);
  assign _zz__zz_fpProductE4M3_1_98 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_99 = ({50'd0,_zz__zz_fpProductE4M3_1_100} <<< 6'd50);
  assign _zz__zz_fpProductE4M3_1_100 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_101 = ({51'd0,_zz__zz_fpProductE4M3_1_102} <<< 6'd51);
  assign _zz__zz_fpProductE4M3_1_102 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_103 = ({52'd0,_zz__zz_fpProductE4M3_1_104} <<< 6'd52);
  assign _zz__zz_fpProductE4M3_1_104 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_105 = ({53'd0,_zz__zz_fpProductE4M3_1_106} <<< 6'd53);
  assign _zz__zz_fpProductE4M3_1_106 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_107 = ({54'd0,_zz__zz_fpProductE4M3_1_108} <<< 6'd54);
  assign _zz__zz_fpProductE4M3_1_108 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_109 = ({55'd0,_zz__zz_fpProductE4M3_1_110} <<< 6'd55);
  assign _zz__zz_fpProductE4M3_1_110 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_111 = ({56'd0,_zz__zz_fpProductE4M3_1_112} <<< 6'd56);
  assign _zz__zz_fpProductE4M3_1_112 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_113 = ({57'd0,_zz__zz_fpProductE4M3_1_114} <<< 6'd57);
  assign _zz__zz_fpProductE4M3_1_114 = {64'd0, _zz_fpProductE4M3};
  assign _zz__zz_fpProductE4M3_1_115 = ({58'd0,_zz__zz_fpProductE4M3_1_116} <<< 6'd58);
  assign _zz__zz_fpProductE4M3_1_116 = {64'd0, _zz_fpProductE4M3};
  assign _zz_fpProductE4M3_2 = _zz_fpProductE4M3_1;
  assign _zz__zz_when_MatrixEngine_l154_1_1 = (_zz__zz_when_MatrixEngine_l154_1_2 - 7'h20);
  assign _zz__zz_when_MatrixEngine_l154_1_2 = (_zz__zz_when_MatrixEngine_l154_1_3 + _zz__zz_when_MatrixEngine_l154_1_4);
  assign _zz__zz_when_MatrixEngine_l154_1_3 = {1'd0, fpA_E5M2_shift};
  assign _zz__zz_when_MatrixEngine_l154_1_4 = {1'd0, fpB_E5M2_shift};
  assign _zz__zz_fpProductE5M2 = (_zz__zz_fpProductE5M2_1 * _zz__zz_fpProductE5M2_2);
  assign _zz__zz_fpProductE5M2_1 = {4'd0, fpA_E5M2_sig};
  assign _zz__zz_fpProductE5M2_2 = {4'd0, fpB_E5M2_sig};
  assign _zz__zz_fpProductE5M2_1_1 = ({1'd0,_zz__zz_fpProductE5M2_1_2} <<< 1'd1);
  assign _zz__zz_fpProductE5M2_1_2 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_3 = ({2'd0,_zz__zz_fpProductE5M2_1_4} <<< 2'd2);
  assign _zz__zz_fpProductE5M2_1_4 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_5 = ({3'd0,_zz__zz_fpProductE5M2_1_6} <<< 2'd3);
  assign _zz__zz_fpProductE5M2_1_6 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_7 = ({4'd0,_zz__zz_fpProductE5M2_1_8} <<< 3'd4);
  assign _zz__zz_fpProductE5M2_1_8 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_9 = ({5'd0,_zz__zz_fpProductE5M2_1_10} <<< 3'd5);
  assign _zz__zz_fpProductE5M2_1_10 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_11 = ({6'd0,_zz__zz_fpProductE5M2_1_12} <<< 3'd6);
  assign _zz__zz_fpProductE5M2_1_12 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_13 = ({7'd0,_zz__zz_fpProductE5M2_1_14} <<< 3'd7);
  assign _zz__zz_fpProductE5M2_1_14 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_15 = ({8'd0,_zz__zz_fpProductE5M2_1_16} <<< 4'd8);
  assign _zz__zz_fpProductE5M2_1_16 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_17 = ({9'd0,_zz__zz_fpProductE5M2_1_18} <<< 4'd9);
  assign _zz__zz_fpProductE5M2_1_18 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_19 = ({10'd0,_zz__zz_fpProductE5M2_1_20} <<< 4'd10);
  assign _zz__zz_fpProductE5M2_1_20 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_21 = ({11'd0,_zz__zz_fpProductE5M2_1_22} <<< 4'd11);
  assign _zz__zz_fpProductE5M2_1_22 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_23 = ({12'd0,_zz__zz_fpProductE5M2_1_24} <<< 4'd12);
  assign _zz__zz_fpProductE5M2_1_24 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_25 = ({13'd0,_zz__zz_fpProductE5M2_1_26} <<< 4'd13);
  assign _zz__zz_fpProductE5M2_1_26 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_27 = ({14'd0,_zz__zz_fpProductE5M2_1_28} <<< 4'd14);
  assign _zz__zz_fpProductE5M2_1_28 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_29 = ({15'd0,_zz__zz_fpProductE5M2_1_30} <<< 4'd15);
  assign _zz__zz_fpProductE5M2_1_30 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_31 = ({16'd0,_zz__zz_fpProductE5M2_1_32} <<< 5'd16);
  assign _zz__zz_fpProductE5M2_1_32 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_33 = ({17'd0,_zz__zz_fpProductE5M2_1_34} <<< 5'd17);
  assign _zz__zz_fpProductE5M2_1_34 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_35 = ({18'd0,_zz__zz_fpProductE5M2_1_36} <<< 5'd18);
  assign _zz__zz_fpProductE5M2_1_36 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_37 = ({19'd0,_zz__zz_fpProductE5M2_1_38} <<< 5'd19);
  assign _zz__zz_fpProductE5M2_1_38 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_39 = ({20'd0,_zz__zz_fpProductE5M2_1_40} <<< 5'd20);
  assign _zz__zz_fpProductE5M2_1_40 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_41 = ({21'd0,_zz__zz_fpProductE5M2_1_42} <<< 5'd21);
  assign _zz__zz_fpProductE5M2_1_42 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_43 = ({22'd0,_zz__zz_fpProductE5M2_1_44} <<< 5'd22);
  assign _zz__zz_fpProductE5M2_1_44 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_45 = ({23'd0,_zz__zz_fpProductE5M2_1_46} <<< 5'd23);
  assign _zz__zz_fpProductE5M2_1_46 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_47 = ({24'd0,_zz__zz_fpProductE5M2_1_48} <<< 5'd24);
  assign _zz__zz_fpProductE5M2_1_48 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_49 = ({25'd0,_zz__zz_fpProductE5M2_1_50} <<< 5'd25);
  assign _zz__zz_fpProductE5M2_1_50 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_51 = ({26'd0,_zz__zz_fpProductE5M2_1_52} <<< 5'd26);
  assign _zz__zz_fpProductE5M2_1_52 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_53 = ({27'd0,_zz__zz_fpProductE5M2_1_54} <<< 5'd27);
  assign _zz__zz_fpProductE5M2_1_54 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_55 = ({28'd0,_zz__zz_fpProductE5M2_1_56} <<< 5'd28);
  assign _zz__zz_fpProductE5M2_1_56 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_57 = ({29'd0,_zz__zz_fpProductE5M2_1_58} <<< 5'd29);
  assign _zz__zz_fpProductE5M2_1_58 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_59 = ({30'd0,_zz__zz_fpProductE5M2_1_60} <<< 5'd30);
  assign _zz__zz_fpProductE5M2_1_60 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_61 = ({31'd0,_zz__zz_fpProductE5M2_1_62} <<< 5'd31);
  assign _zz__zz_fpProductE5M2_1_62 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_63 = ({32'd0,_zz__zz_fpProductE5M2_1_64} <<< 6'd32);
  assign _zz__zz_fpProductE5M2_1_64 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_65 = ({33'd0,_zz__zz_fpProductE5M2_1_66} <<< 6'd33);
  assign _zz__zz_fpProductE5M2_1_66 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_67 = ({34'd0,_zz__zz_fpProductE5M2_1_68} <<< 6'd34);
  assign _zz__zz_fpProductE5M2_1_68 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_69 = ({35'd0,_zz__zz_fpProductE5M2_1_70} <<< 6'd35);
  assign _zz__zz_fpProductE5M2_1_70 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_71 = ({36'd0,_zz__zz_fpProductE5M2_1_72} <<< 6'd36);
  assign _zz__zz_fpProductE5M2_1_72 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_73 = ({37'd0,_zz__zz_fpProductE5M2_1_74} <<< 6'd37);
  assign _zz__zz_fpProductE5M2_1_74 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_75 = ({38'd0,_zz__zz_fpProductE5M2_1_76} <<< 6'd38);
  assign _zz__zz_fpProductE5M2_1_76 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_77 = ({39'd0,_zz__zz_fpProductE5M2_1_78} <<< 6'd39);
  assign _zz__zz_fpProductE5M2_1_78 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_79 = ({40'd0,_zz__zz_fpProductE5M2_1_80} <<< 6'd40);
  assign _zz__zz_fpProductE5M2_1_80 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_81 = ({41'd0,_zz__zz_fpProductE5M2_1_82} <<< 6'd41);
  assign _zz__zz_fpProductE5M2_1_82 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_83 = ({42'd0,_zz__zz_fpProductE5M2_1_84} <<< 6'd42);
  assign _zz__zz_fpProductE5M2_1_84 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_85 = ({43'd0,_zz__zz_fpProductE5M2_1_86} <<< 6'd43);
  assign _zz__zz_fpProductE5M2_1_86 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_87 = ({44'd0,_zz__zz_fpProductE5M2_1_88} <<< 6'd44);
  assign _zz__zz_fpProductE5M2_1_88 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_89 = ({45'd0,_zz__zz_fpProductE5M2_1_90} <<< 6'd45);
  assign _zz__zz_fpProductE5M2_1_90 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_91 = ({46'd0,_zz__zz_fpProductE5M2_1_92} <<< 6'd46);
  assign _zz__zz_fpProductE5M2_1_92 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_93 = ({47'd0,_zz__zz_fpProductE5M2_1_94} <<< 6'd47);
  assign _zz__zz_fpProductE5M2_1_94 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_95 = ({48'd0,_zz__zz_fpProductE5M2_1_96} <<< 6'd48);
  assign _zz__zz_fpProductE5M2_1_96 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_97 = ({49'd0,_zz__zz_fpProductE5M2_1_98} <<< 6'd49);
  assign _zz__zz_fpProductE5M2_1_98 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_99 = ({50'd0,_zz__zz_fpProductE5M2_1_100} <<< 6'd50);
  assign _zz__zz_fpProductE5M2_1_100 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_101 = ({51'd0,_zz__zz_fpProductE5M2_1_102} <<< 6'd51);
  assign _zz__zz_fpProductE5M2_1_102 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_103 = ({52'd0,_zz__zz_fpProductE5M2_1_104} <<< 6'd52);
  assign _zz__zz_fpProductE5M2_1_104 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_105 = ({53'd0,_zz__zz_fpProductE5M2_1_106} <<< 6'd53);
  assign _zz__zz_fpProductE5M2_1_106 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_107 = ({54'd0,_zz__zz_fpProductE5M2_1_108} <<< 6'd54);
  assign _zz__zz_fpProductE5M2_1_108 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_109 = ({55'd0,_zz__zz_fpProductE5M2_1_110} <<< 6'd55);
  assign _zz__zz_fpProductE5M2_1_110 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_111 = ({56'd0,_zz__zz_fpProductE5M2_1_112} <<< 6'd56);
  assign _zz__zz_fpProductE5M2_1_112 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_113 = ({57'd0,_zz__zz_fpProductE5M2_1_114} <<< 6'd57);
  assign _zz__zz_fpProductE5M2_1_114 = {64'd0, _zz_fpProductE5M2};
  assign _zz__zz_fpProductE5M2_1_115 = ({58'd0,_zz__zz_fpProductE5M2_1_116} <<< 6'd58);
  assign _zz__zz_fpProductE5M2_1_116 = {64'd0, _zz_fpProductE5M2};
  assign _zz_fpProductE5M2_2 = _zz_fpProductE5M2_1;
  assign _zz__zz_when_MatrixEngine_l89 = (- fpAccReg);
  assign _zz__zz_when_MatrixEngine_l209 = (_zz_when_MatrixEngine_l184 - 7'h17);
  assign _zz__zz_when_MatrixEngine_l204 = (7'h17 - _zz_when_MatrixEngine_l184);
  assign _zz__zz_when_MatrixEngine_l233 = ({1'd0,_zz__zz_when_MatrixEngine_l233_1} <<< 1'd1);
  assign _zz__zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_2 = ({2'd0,_zz__zz_when_MatrixEngine_l233_3} <<< 2'd2);
  assign _zz__zz_when_MatrixEngine_l233_3 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4 = ({3'd0,_zz__zz_when_MatrixEngine_l233_5} <<< 2'd3);
  assign _zz__zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_6 = ({4'd0,_zz__zz_when_MatrixEngine_l233_7} <<< 3'd4);
  assign _zz__zz_when_MatrixEngine_l233_7 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_8 = ({5'd0,_zz__zz_when_MatrixEngine_l233_9} <<< 3'd5);
  assign _zz__zz_when_MatrixEngine_l233_9 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_10 = ({6'd0,_zz__zz_when_MatrixEngine_l233_11} <<< 3'd6);
  assign _zz__zz_when_MatrixEngine_l233_11 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_12 = ({7'd0,_zz__zz_when_MatrixEngine_l233_13} <<< 3'd7);
  assign _zz__zz_when_MatrixEngine_l233_13 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_14 = ({8'd0,_zz__zz_when_MatrixEngine_l233_15} <<< 4'd8);
  assign _zz__zz_when_MatrixEngine_l233_15 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_16 = ({9'd0,_zz__zz_when_MatrixEngine_l233_17} <<< 4'd9);
  assign _zz__zz_when_MatrixEngine_l233_17 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_18 = ({10'd0,_zz__zz_when_MatrixEngine_l233_19} <<< 4'd10);
  assign _zz__zz_when_MatrixEngine_l233_19 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_20 = ({11'd0,_zz__zz_when_MatrixEngine_l233_21} <<< 4'd11);
  assign _zz__zz_when_MatrixEngine_l233_21 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_22 = ({12'd0,_zz__zz_when_MatrixEngine_l233_23} <<< 4'd12);
  assign _zz__zz_when_MatrixEngine_l233_23 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_24 = ({13'd0,_zz__zz_when_MatrixEngine_l233_25} <<< 4'd13);
  assign _zz__zz_when_MatrixEngine_l233_25 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_26 = ({14'd0,_zz__zz_when_MatrixEngine_l233_27} <<< 4'd14);
  assign _zz__zz_when_MatrixEngine_l233_27 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_28 = ({15'd0,_zz__zz_when_MatrixEngine_l233_29} <<< 4'd15);
  assign _zz__zz_when_MatrixEngine_l233_29 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_30 = ({16'd0,_zz__zz_when_MatrixEngine_l233_31} <<< 5'd16);
  assign _zz__zz_when_MatrixEngine_l233_31 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_32 = ({17'd0,_zz__zz_when_MatrixEngine_l233_33} <<< 5'd17);
  assign _zz__zz_when_MatrixEngine_l233_33 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_34 = ({18'd0,_zz__zz_when_MatrixEngine_l233_35} <<< 5'd18);
  assign _zz__zz_when_MatrixEngine_l233_35 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_36 = ({19'd0,_zz__zz_when_MatrixEngine_l233_37} <<< 5'd19);
  assign _zz__zz_when_MatrixEngine_l233_37 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_38 = ({20'd0,_zz__zz_when_MatrixEngine_l233_39} <<< 5'd20);
  assign _zz__zz_when_MatrixEngine_l233_39 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_40 = ({21'd0,_zz__zz_when_MatrixEngine_l233_41} <<< 5'd21);
  assign _zz__zz_when_MatrixEngine_l233_41 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_42 = ({22'd0,_zz__zz_when_MatrixEngine_l233_43} <<< 5'd22);
  assign _zz__zz_when_MatrixEngine_l233_43 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_44 = ({23'd0,_zz__zz_when_MatrixEngine_l233_45} <<< 5'd23);
  assign _zz__zz_when_MatrixEngine_l233_45 = _zz_when_MatrixEngine_l89[23:0];
  assign _zz__zz_when_MatrixEngine_l233_46 = (_zz_when_MatrixEngine_l89 >>> 1'd1);
  assign _zz__zz_when_MatrixEngine_l233_47 = (_zz_when_MatrixEngine_l89 >>> 2'd2);
  assign _zz__zz_when_MatrixEngine_l233_48 = (_zz_when_MatrixEngine_l89 >>> 2'd3);
  assign _zz__zz_when_MatrixEngine_l233_49 = (_zz_when_MatrixEngine_l89 >>> 3'd4);
  assign _zz__zz_when_MatrixEngine_l233_50 = (_zz_when_MatrixEngine_l89 >>> 3'd5);
  assign _zz__zz_when_MatrixEngine_l233_51 = (_zz_when_MatrixEngine_l89 >>> 3'd6);
  assign _zz__zz_when_MatrixEngine_l233_52 = (_zz_when_MatrixEngine_l89 >>> 3'd7);
  assign _zz__zz_when_MatrixEngine_l233_53 = (_zz_when_MatrixEngine_l89 >>> 4'd8);
  assign _zz__zz_when_MatrixEngine_l233_54 = (_zz_when_MatrixEngine_l89 >>> 4'd9);
  assign _zz__zz_when_MatrixEngine_l233_55 = (_zz_when_MatrixEngine_l89 >>> 4'd10);
  assign _zz__zz_when_MatrixEngine_l233_56 = (_zz_when_MatrixEngine_l89 >>> 4'd11);
  assign _zz__zz_when_MatrixEngine_l233_57 = (_zz_when_MatrixEngine_l89 >>> 4'd12);
  assign _zz__zz_when_MatrixEngine_l233_58 = (_zz_when_MatrixEngine_l89 >>> 4'd13);
  assign _zz__zz_when_MatrixEngine_l233_59 = (_zz_when_MatrixEngine_l89 >>> 4'd14);
  assign _zz__zz_when_MatrixEngine_l233_60 = (_zz_when_MatrixEngine_l89 >>> 4'd15);
  assign _zz__zz_when_MatrixEngine_l233_61 = (_zz_when_MatrixEngine_l89 >>> 5'd16);
  assign _zz__zz_when_MatrixEngine_l233_62 = (_zz_when_MatrixEngine_l89 >>> 5'd17);
  assign _zz__zz_when_MatrixEngine_l233_63 = (_zz_when_MatrixEngine_l89 >>> 5'd18);
  assign _zz__zz_when_MatrixEngine_l233_64 = (_zz_when_MatrixEngine_l89 >>> 5'd19);
  assign _zz__zz_when_MatrixEngine_l233_65 = (_zz_when_MatrixEngine_l89 >>> 5'd20);
  assign _zz__zz_when_MatrixEngine_l233_66 = (_zz_when_MatrixEngine_l89 >>> 5'd21);
  assign _zz__zz_when_MatrixEngine_l233_67 = (_zz_when_MatrixEngine_l89 >>> 5'd22);
  assign _zz__zz_when_MatrixEngine_l233_68 = (_zz_when_MatrixEngine_l89 >>> 5'd23);
  assign _zz__zz_when_MatrixEngine_l233_69 = (_zz_when_MatrixEngine_l89 >>> 5'd24);
  assign _zz__zz_when_MatrixEngine_l233_70 = (_zz_when_MatrixEngine_l89 >>> 5'd25);
  assign _zz__zz_when_MatrixEngine_l233_71 = (_zz_when_MatrixEngine_l89 >>> 5'd26);
  assign _zz__zz_when_MatrixEngine_l233_72 = (_zz_when_MatrixEngine_l89 >>> 5'd27);
  assign _zz__zz_when_MatrixEngine_l233_73 = (_zz_when_MatrixEngine_l89 >>> 5'd28);
  assign _zz__zz_when_MatrixEngine_l233_74 = (_zz_when_MatrixEngine_l89 >>> 5'd29);
  assign _zz__zz_when_MatrixEngine_l233_75 = (_zz_when_MatrixEngine_l89 >>> 5'd30);
  assign _zz__zz_when_MatrixEngine_l233_76 = (_zz_when_MatrixEngine_l89 >>> 5'd31);
  assign _zz__zz_when_MatrixEngine_l233_77 = (_zz_when_MatrixEngine_l89 >>> 6'd32);
  assign _zz__zz_when_MatrixEngine_l233_78 = (_zz_when_MatrixEngine_l89 >>> 6'd33);
  assign _zz__zz_when_MatrixEngine_l233_79 = (_zz_when_MatrixEngine_l89 >>> 6'd34);
  assign _zz__zz_when_MatrixEngine_l233_80 = (_zz_when_MatrixEngine_l89 >>> 6'd35);
  assign _zz__zz_when_MatrixEngine_l233_81 = (_zz_when_MatrixEngine_l89 >>> 6'd36);
  assign _zz__zz_when_MatrixEngine_l233_82 = (_zz_when_MatrixEngine_l89 >>> 6'd37);
  assign _zz__zz_when_MatrixEngine_l233_83 = (_zz_when_MatrixEngine_l89 >>> 6'd38);
  assign _zz__zz_when_MatrixEngine_l233_84 = (_zz_when_MatrixEngine_l89 >>> 6'd39);
  assign _zz__zz_when_MatrixEngine_l233_85 = (_zz_when_MatrixEngine_l89 >>> 6'd40);
  assign _zz__zz_when_MatrixEngine_l233_86 = (_zz_when_MatrixEngine_l89 >>> 6'd41);
  assign _zz__zz_when_MatrixEngine_l233_87 = (_zz_when_MatrixEngine_l89 >>> 6'd42);
  assign _zz__zz_when_MatrixEngine_l233_88 = (_zz_when_MatrixEngine_l89 >>> 6'd43);
  assign _zz__zz_when_MatrixEngine_l233_89 = (_zz_when_MatrixEngine_l89 >>> 6'd44);
  assign _zz__zz_when_MatrixEngine_l233_90 = (_zz_when_MatrixEngine_l89 >>> 6'd45);
  assign _zz__zz_when_MatrixEngine_l233_91 = (_zz_when_MatrixEngine_l89 >>> 6'd46);
  assign _zz__zz_when_MatrixEngine_l233_92 = (_zz_when_MatrixEngine_l89 >>> 6'd47);
  assign _zz__zz_when_MatrixEngine_l233_3_1 = {1'd0, _zz_when_MatrixEngine_l233};
  assign _zz__zz_when_MatrixEngine_l233_3_3 = (_zz_when_MatrixEngine_l233_1 && (_zz_when_MatrixEngine_l233_2 || _zz_when_MatrixEngine_l233[0]));
  assign _zz__zz_when_MatrixEngine_l233_3_2 = {24'd0, _zz__zz_when_MatrixEngine_l233_3_3};
  assign _zz__zz_when_MatrixEngine_l290_1 = {1'd0, _zz_when_MatrixEngine_l184};
  assign _zz__zz_when_MatrixEngine_l262 = (_zz_when_MatrixEngine_l251 - 8'h76);
  assign _zz__zz_roundedFpAcc_1 = ({1'd0,_zz__zz_roundedFpAcc_1_1} <<< 1'd1);
  assign _zz__zz_roundedFpAcc_1_1 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_2 = ({2'd0,_zz__zz_roundedFpAcc_1_3} <<< 2'd2);
  assign _zz__zz_roundedFpAcc_1_3 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_4 = ({3'd0,_zz__zz_roundedFpAcc_1_5} <<< 2'd3);
  assign _zz__zz_roundedFpAcc_1_5 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_6 = ({4'd0,_zz__zz_roundedFpAcc_1_7} <<< 3'd4);
  assign _zz__zz_roundedFpAcc_1_7 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_8 = ({5'd0,_zz__zz_roundedFpAcc_1_9} <<< 3'd5);
  assign _zz__zz_roundedFpAcc_1_9 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_10 = ({6'd0,_zz__zz_roundedFpAcc_1_11} <<< 3'd6);
  assign _zz__zz_roundedFpAcc_1_11 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_12 = ({7'd0,_zz__zz_roundedFpAcc_1_13} <<< 3'd7);
  assign _zz__zz_roundedFpAcc_1_13 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_14 = ({8'd0,_zz__zz_roundedFpAcc_1_15} <<< 4'd8);
  assign _zz__zz_roundedFpAcc_1_15 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_16 = ({9'd0,_zz__zz_roundedFpAcc_1_17} <<< 4'd9);
  assign _zz__zz_roundedFpAcc_1_17 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_18 = ({10'd0,_zz__zz_roundedFpAcc_1_19} <<< 4'd10);
  assign _zz__zz_roundedFpAcc_1_19 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_20 = ({11'd0,_zz__zz_roundedFpAcc_1_21} <<< 4'd11);
  assign _zz__zz_roundedFpAcc_1_21 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_22 = ({12'd0,_zz__zz_roundedFpAcc_1_23} <<< 4'd12);
  assign _zz__zz_roundedFpAcc_1_23 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_24 = ({13'd0,_zz__zz_roundedFpAcc_1_25} <<< 4'd13);
  assign _zz__zz_roundedFpAcc_1_25 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_26 = ({14'd0,_zz__zz_roundedFpAcc_1_27} <<< 4'd14);
  assign _zz__zz_roundedFpAcc_1_27 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_28 = ({15'd0,_zz__zz_roundedFpAcc_1_29} <<< 4'd15);
  assign _zz__zz_roundedFpAcc_1_29 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_30 = ({16'd0,_zz__zz_roundedFpAcc_1_31} <<< 5'd16);
  assign _zz__zz_roundedFpAcc_1_31 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_32 = ({17'd0,_zz__zz_roundedFpAcc_1_33} <<< 5'd17);
  assign _zz__zz_roundedFpAcc_1_33 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_34 = ({18'd0,_zz__zz_roundedFpAcc_1_35} <<< 5'd18);
  assign _zz__zz_roundedFpAcc_1_35 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_36 = ({19'd0,_zz__zz_roundedFpAcc_1_37} <<< 5'd19);
  assign _zz__zz_roundedFpAcc_1_37 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_38 = ({20'd0,_zz__zz_roundedFpAcc_1_39} <<< 5'd20);
  assign _zz__zz_roundedFpAcc_1_39 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_40 = ({21'd0,_zz__zz_roundedFpAcc_1_41} <<< 5'd21);
  assign _zz__zz_roundedFpAcc_1_41 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_42 = ({22'd0,_zz__zz_roundedFpAcc_1_43} <<< 5'd22);
  assign _zz__zz_roundedFpAcc_1_43 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_44 = ({23'd0,_zz__zz_roundedFpAcc_1_45} <<< 5'd23);
  assign _zz__zz_roundedFpAcc_1_45 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_46 = ({24'd0,_zz__zz_roundedFpAcc_1_47} <<< 5'd24);
  assign _zz__zz_roundedFpAcc_1_47 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_48 = ({25'd0,_zz__zz_roundedFpAcc_1_49} <<< 5'd25);
  assign _zz__zz_roundedFpAcc_1_49 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_50 = ({26'd0,_zz__zz_roundedFpAcc_1_51} <<< 5'd26);
  assign _zz__zz_roundedFpAcc_1_51 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_52 = ({27'd0,_zz__zz_roundedFpAcc_1_53} <<< 5'd27);
  assign _zz__zz_roundedFpAcc_1_53 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_54 = ({28'd0,_zz__zz_roundedFpAcc_1_55} <<< 5'd28);
  assign _zz__zz_roundedFpAcc_1_55 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_56 = ({29'd0,_zz__zz_roundedFpAcc_1_57} <<< 5'd29);
  assign _zz__zz_roundedFpAcc_1_57 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_58 = ({30'd0,_zz__zz_roundedFpAcc_1_59} <<< 5'd30);
  assign _zz__zz_roundedFpAcc_1_59 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_60 = ({31'd0,_zz__zz_roundedFpAcc_1_61} <<< 5'd31);
  assign _zz__zz_roundedFpAcc_1_61 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_62 = ({32'd0,_zz__zz_roundedFpAcc_1_63} <<< 6'd32);
  assign _zz__zz_roundedFpAcc_1_63 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_64 = ({33'd0,_zz__zz_roundedFpAcc_1_65} <<< 6'd33);
  assign _zz__zz_roundedFpAcc_1_65 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_66 = ({34'd0,_zz__zz_roundedFpAcc_1_67} <<< 6'd34);
  assign _zz__zz_roundedFpAcc_1_67 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_68 = ({35'd0,_zz__zz_roundedFpAcc_1_69} <<< 6'd35);
  assign _zz__zz_roundedFpAcc_1_69 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_70 = ({36'd0,_zz__zz_roundedFpAcc_1_71} <<< 6'd36);
  assign _zz__zz_roundedFpAcc_1_71 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_72 = ({37'd0,_zz__zz_roundedFpAcc_1_73} <<< 6'd37);
  assign _zz__zz_roundedFpAcc_1_73 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_74 = ({38'd0,_zz__zz_roundedFpAcc_1_75} <<< 6'd38);
  assign _zz__zz_roundedFpAcc_1_75 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_76 = ({39'd0,_zz__zz_roundedFpAcc_1_77} <<< 6'd39);
  assign _zz__zz_roundedFpAcc_1_77 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_78 = ({40'd0,_zz__zz_roundedFpAcc_1_79} <<< 6'd40);
  assign _zz__zz_roundedFpAcc_1_79 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_80 = ({41'd0,_zz__zz_roundedFpAcc_1_81} <<< 6'd41);
  assign _zz__zz_roundedFpAcc_1_81 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_82 = ({42'd0,_zz__zz_roundedFpAcc_1_83} <<< 6'd42);
  assign _zz__zz_roundedFpAcc_1_83 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_84 = ({43'd0,_zz__zz_roundedFpAcc_1_85} <<< 6'd43);
  assign _zz__zz_roundedFpAcc_1_85 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_86 = ({44'd0,_zz__zz_roundedFpAcc_1_87} <<< 6'd44);
  assign _zz__zz_roundedFpAcc_1_87 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_88 = ({45'd0,_zz__zz_roundedFpAcc_1_89} <<< 6'd45);
  assign _zz__zz_roundedFpAcc_1_89 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_90 = ({46'd0,_zz__zz_roundedFpAcc_1_91} <<< 6'd46);
  assign _zz__zz_roundedFpAcc_1_91 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_92 = ({47'd0,_zz__zz_roundedFpAcc_1_93} <<< 6'd47);
  assign _zz__zz_roundedFpAcc_1_93 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_1_94 = ({48'd0,_zz__zz_roundedFpAcc_1_95} <<< 6'd48);
  assign _zz__zz_roundedFpAcc_1_95 = {48'd0, _zz_roundedFpAcc_2};
  assign _zz__zz_roundedFpAcc_3 = (_zz_roundedFpAcc_2 >>> 1'd1);
  assign _zz__zz_roundedFpAcc_1_97 = (_zz_roundedFpAcc_2[0] && (1'b0 || _zz_roundedFpAcc_3[0]));
  assign _zz__zz_roundedFpAcc_1_96 = {71'd0, _zz__zz_roundedFpAcc_1_97};
  assign _zz__zz_roundedFpAcc_4 = (_zz_roundedFpAcc_2 >>> 2'd2);
  assign _zz__zz_roundedFpAcc_1_99 = (_zz_roundedFpAcc_2[1] && ((|_zz_roundedFpAcc_2[0 : 0]) || _zz_roundedFpAcc_4[0]));
  assign _zz__zz_roundedFpAcc_1_98 = {71'd0, _zz__zz_roundedFpAcc_1_99};
  assign _zz__zz_roundedFpAcc_5 = (_zz_roundedFpAcc_2 >>> 2'd3);
  assign _zz__zz_roundedFpAcc_1_101 = (_zz_roundedFpAcc_2[2] && ((|_zz_roundedFpAcc_2[1 : 0]) || _zz_roundedFpAcc_5[0]));
  assign _zz__zz_roundedFpAcc_1_100 = {71'd0, _zz__zz_roundedFpAcc_1_101};
  assign _zz__zz_roundedFpAcc_6 = (_zz_roundedFpAcc_2 >>> 3'd4);
  assign _zz__zz_roundedFpAcc_1_103 = (_zz_roundedFpAcc_2[3] && ((|_zz_roundedFpAcc_2[2 : 0]) || _zz_roundedFpAcc_6[0]));
  assign _zz__zz_roundedFpAcc_1_102 = {71'd0, _zz__zz_roundedFpAcc_1_103};
  assign _zz__zz_roundedFpAcc_7 = (_zz_roundedFpAcc_2 >>> 3'd5);
  assign _zz__zz_roundedFpAcc_1_105 = (_zz_roundedFpAcc_2[4] && ((|_zz_roundedFpAcc_2[3 : 0]) || _zz_roundedFpAcc_7[0]));
  assign _zz__zz_roundedFpAcc_1_104 = {71'd0, _zz__zz_roundedFpAcc_1_105};
  assign _zz__zz_roundedFpAcc_8 = (_zz_roundedFpAcc_2 >>> 3'd6);
  assign _zz__zz_roundedFpAcc_1_107 = (_zz_roundedFpAcc_2[5] && ((|_zz_roundedFpAcc_2[4 : 0]) || _zz_roundedFpAcc_8[0]));
  assign _zz__zz_roundedFpAcc_1_106 = {71'd0, _zz__zz_roundedFpAcc_1_107};
  assign _zz__zz_roundedFpAcc_9 = (_zz_roundedFpAcc_2 >>> 3'd7);
  assign _zz__zz_roundedFpAcc_1_109 = (_zz_roundedFpAcc_2[6] && ((|_zz_roundedFpAcc_2[5 : 0]) || _zz_roundedFpAcc_9[0]));
  assign _zz__zz_roundedFpAcc_1_108 = {71'd0, _zz__zz_roundedFpAcc_1_109};
  assign _zz__zz_roundedFpAcc_10 = (_zz_roundedFpAcc_2 >>> 4'd8);
  assign _zz__zz_roundedFpAcc_1_111 = (_zz_roundedFpAcc_2[7] && ((|_zz_roundedFpAcc_2[6 : 0]) || _zz_roundedFpAcc_10[0]));
  assign _zz__zz_roundedFpAcc_1_110 = {71'd0, _zz__zz_roundedFpAcc_1_111};
  assign _zz__zz_roundedFpAcc_11 = (_zz_roundedFpAcc_2 >>> 4'd9);
  assign _zz__zz_roundedFpAcc_1_113 = (_zz_roundedFpAcc_2[8] && ((|_zz_roundedFpAcc_2[7 : 0]) || _zz_roundedFpAcc_11[0]));
  assign _zz__zz_roundedFpAcc_1_112 = {71'd0, _zz__zz_roundedFpAcc_1_113};
  assign _zz__zz_roundedFpAcc_12 = (_zz_roundedFpAcc_2 >>> 4'd10);
  assign _zz__zz_roundedFpAcc_1_115 = (_zz_roundedFpAcc_2[9] && ((|_zz_roundedFpAcc_2[8 : 0]) || _zz_roundedFpAcc_12[0]));
  assign _zz__zz_roundedFpAcc_1_114 = {71'd0, _zz__zz_roundedFpAcc_1_115};
  assign _zz__zz_roundedFpAcc_13 = (_zz_roundedFpAcc_2 >>> 4'd11);
  assign _zz__zz_roundedFpAcc_1_117 = (_zz_roundedFpAcc_2[10] && ((|_zz_roundedFpAcc_2[9 : 0]) || _zz_roundedFpAcc_13[0]));
  assign _zz__zz_roundedFpAcc_1_116 = {71'd0, _zz__zz_roundedFpAcc_1_117};
  assign _zz__zz_roundedFpAcc_14 = (_zz_roundedFpAcc_2 >>> 4'd12);
  assign _zz__zz_roundedFpAcc_1_119 = (_zz_roundedFpAcc_2[11] && ((|_zz_roundedFpAcc_2[10 : 0]) || _zz_roundedFpAcc_14[0]));
  assign _zz__zz_roundedFpAcc_1_118 = {71'd0, _zz__zz_roundedFpAcc_1_119};
  assign _zz__zz_roundedFpAcc_15 = (_zz_roundedFpAcc_2 >>> 4'd13);
  assign _zz__zz_roundedFpAcc_1_121 = (_zz_roundedFpAcc_2[12] && ((|_zz_roundedFpAcc_2[11 : 0]) || _zz_roundedFpAcc_15[0]));
  assign _zz__zz_roundedFpAcc_1_120 = {71'd0, _zz__zz_roundedFpAcc_1_121};
  assign _zz__zz_roundedFpAcc_16 = (_zz_roundedFpAcc_2 >>> 4'd14);
  assign _zz__zz_roundedFpAcc_1_123 = (_zz_roundedFpAcc_2[13] && ((|_zz_roundedFpAcc_2[12 : 0]) || _zz_roundedFpAcc_16[0]));
  assign _zz__zz_roundedFpAcc_1_122 = {71'd0, _zz__zz_roundedFpAcc_1_123};
  assign _zz__zz_roundedFpAcc_17 = (_zz_roundedFpAcc_2 >>> 4'd15);
  assign _zz__zz_roundedFpAcc_1_125 = (_zz_roundedFpAcc_2[14] && ((|_zz_roundedFpAcc_2[13 : 0]) || _zz_roundedFpAcc_17[0]));
  assign _zz__zz_roundedFpAcc_1_124 = {71'd0, _zz__zz_roundedFpAcc_1_125};
  assign _zz__zz_roundedFpAcc_18 = (_zz_roundedFpAcc_2 >>> 5'd16);
  assign _zz__zz_roundedFpAcc_1_127 = (_zz_roundedFpAcc_2[15] && ((|_zz_roundedFpAcc_2[14 : 0]) || _zz_roundedFpAcc_18[0]));
  assign _zz__zz_roundedFpAcc_1_126 = {71'd0, _zz__zz_roundedFpAcc_1_127};
  assign _zz__zz_roundedFpAcc_19 = (_zz_roundedFpAcc_2 >>> 5'd17);
  assign _zz__zz_roundedFpAcc_1_129 = (_zz_roundedFpAcc_2[16] && ((|_zz_roundedFpAcc_2[15 : 0]) || _zz_roundedFpAcc_19[0]));
  assign _zz__zz_roundedFpAcc_1_128 = {71'd0, _zz__zz_roundedFpAcc_1_129};
  assign _zz__zz_roundedFpAcc_20 = (_zz_roundedFpAcc_2 >>> 5'd18);
  assign _zz__zz_roundedFpAcc_1_131 = (_zz_roundedFpAcc_2[17] && ((|_zz_roundedFpAcc_2[16 : 0]) || _zz_roundedFpAcc_20[0]));
  assign _zz__zz_roundedFpAcc_1_130 = {71'd0, _zz__zz_roundedFpAcc_1_131};
  assign _zz__zz_roundedFpAcc_21 = (_zz_roundedFpAcc_2 >>> 5'd19);
  assign _zz__zz_roundedFpAcc_1_133 = (_zz_roundedFpAcc_2[18] && ((|_zz_roundedFpAcc_2[17 : 0]) || _zz_roundedFpAcc_21[0]));
  assign _zz__zz_roundedFpAcc_1_132 = {71'd0, _zz__zz_roundedFpAcc_1_133};
  assign _zz__zz_roundedFpAcc_22 = (_zz_roundedFpAcc_2 >>> 5'd20);
  assign _zz__zz_roundedFpAcc_1_135 = (_zz_roundedFpAcc_2[19] && ((|_zz_roundedFpAcc_2[18 : 0]) || _zz_roundedFpAcc_22[0]));
  assign _zz__zz_roundedFpAcc_1_134 = {71'd0, _zz__zz_roundedFpAcc_1_135};
  assign _zz__zz_roundedFpAcc_23 = (_zz_roundedFpAcc_2 >>> 5'd21);
  assign _zz__zz_roundedFpAcc_1_137 = (_zz_roundedFpAcc_2[20] && ((|_zz_roundedFpAcc_2[19 : 0]) || _zz_roundedFpAcc_23[0]));
  assign _zz__zz_roundedFpAcc_1_136 = {71'd0, _zz__zz_roundedFpAcc_1_137};
  assign _zz__zz_roundedFpAcc_24 = (_zz_roundedFpAcc_2 >>> 5'd22);
  assign _zz__zz_roundedFpAcc_1_139 = (_zz_roundedFpAcc_2[21] && ((|_zz_roundedFpAcc_2[20 : 0]) || _zz_roundedFpAcc_24[0]));
  assign _zz__zz_roundedFpAcc_1_138 = {71'd0, _zz__zz_roundedFpAcc_1_139};
  assign _zz__zz_roundedFpAcc_25 = (_zz_roundedFpAcc_2 >>> 5'd23);
  assign _zz__zz_roundedFpAcc_1_141 = (_zz_roundedFpAcc_2[22] && ((|_zz_roundedFpAcc_2[21 : 0]) || _zz_roundedFpAcc_25[0]));
  assign _zz__zz_roundedFpAcc_1_140 = {71'd0, _zz__zz_roundedFpAcc_1_141};
  assign _zz__zz_roundedFpAcc_1_143 = (_zz_roundedFpAcc_2[23] && ((|_zz_roundedFpAcc_2[22 : 0]) || _zz_roundedFpAcc_26[0]));
  assign _zz__zz_roundedFpAcc_1_142 = {71'd0, _zz__zz_roundedFpAcc_1_143};
  assign _zz_roundedFpAcc_27 = _zz_roundedFpAcc_1;
  assign _zz_io_matrixAccumAddr = (_zz_io_matrixAccumAddr_1 - _zz_io_matrixAccumAddr_2);
  assign _zz_io_matrixAccumAddr_1 = totalElemsReg[5:0];
  assign _zz_io_matrixAccumAddr_2 = debugCounter[5:0];
  assign _zz__zz_when_MatrixEngine_l262_1 = (_zz_when_MatrixEngine_l251_1 - 8'h76);
  assign _zz__zz_fpAccReg_1 = ({1'd0,_zz__zz_fpAccReg_1_1} <<< 1'd1);
  assign _zz__zz_fpAccReg_1_1 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_2 = ({2'd0,_zz__zz_fpAccReg_1_3} <<< 2'd2);
  assign _zz__zz_fpAccReg_1_3 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_4 = ({3'd0,_zz__zz_fpAccReg_1_5} <<< 2'd3);
  assign _zz__zz_fpAccReg_1_5 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_6 = ({4'd0,_zz__zz_fpAccReg_1_7} <<< 3'd4);
  assign _zz__zz_fpAccReg_1_7 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_8 = ({5'd0,_zz__zz_fpAccReg_1_9} <<< 3'd5);
  assign _zz__zz_fpAccReg_1_9 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_10 = ({6'd0,_zz__zz_fpAccReg_1_11} <<< 3'd6);
  assign _zz__zz_fpAccReg_1_11 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_12 = ({7'd0,_zz__zz_fpAccReg_1_13} <<< 3'd7);
  assign _zz__zz_fpAccReg_1_13 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_14 = ({8'd0,_zz__zz_fpAccReg_1_15} <<< 4'd8);
  assign _zz__zz_fpAccReg_1_15 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_16 = ({9'd0,_zz__zz_fpAccReg_1_17} <<< 4'd9);
  assign _zz__zz_fpAccReg_1_17 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_18 = ({10'd0,_zz__zz_fpAccReg_1_19} <<< 4'd10);
  assign _zz__zz_fpAccReg_1_19 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_20 = ({11'd0,_zz__zz_fpAccReg_1_21} <<< 4'd11);
  assign _zz__zz_fpAccReg_1_21 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_22 = ({12'd0,_zz__zz_fpAccReg_1_23} <<< 4'd12);
  assign _zz__zz_fpAccReg_1_23 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_24 = ({13'd0,_zz__zz_fpAccReg_1_25} <<< 4'd13);
  assign _zz__zz_fpAccReg_1_25 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_26 = ({14'd0,_zz__zz_fpAccReg_1_27} <<< 4'd14);
  assign _zz__zz_fpAccReg_1_27 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_28 = ({15'd0,_zz__zz_fpAccReg_1_29} <<< 4'd15);
  assign _zz__zz_fpAccReg_1_29 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_30 = ({16'd0,_zz__zz_fpAccReg_1_31} <<< 5'd16);
  assign _zz__zz_fpAccReg_1_31 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_32 = ({17'd0,_zz__zz_fpAccReg_1_33} <<< 5'd17);
  assign _zz__zz_fpAccReg_1_33 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_34 = ({18'd0,_zz__zz_fpAccReg_1_35} <<< 5'd18);
  assign _zz__zz_fpAccReg_1_35 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_36 = ({19'd0,_zz__zz_fpAccReg_1_37} <<< 5'd19);
  assign _zz__zz_fpAccReg_1_37 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_38 = ({20'd0,_zz__zz_fpAccReg_1_39} <<< 5'd20);
  assign _zz__zz_fpAccReg_1_39 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_40 = ({21'd0,_zz__zz_fpAccReg_1_41} <<< 5'd21);
  assign _zz__zz_fpAccReg_1_41 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_42 = ({22'd0,_zz__zz_fpAccReg_1_43} <<< 5'd22);
  assign _zz__zz_fpAccReg_1_43 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_44 = ({23'd0,_zz__zz_fpAccReg_1_45} <<< 5'd23);
  assign _zz__zz_fpAccReg_1_45 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_46 = ({24'd0,_zz__zz_fpAccReg_1_47} <<< 5'd24);
  assign _zz__zz_fpAccReg_1_47 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_48 = ({25'd0,_zz__zz_fpAccReg_1_49} <<< 5'd25);
  assign _zz__zz_fpAccReg_1_49 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_50 = ({26'd0,_zz__zz_fpAccReg_1_51} <<< 5'd26);
  assign _zz__zz_fpAccReg_1_51 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_52 = ({27'd0,_zz__zz_fpAccReg_1_53} <<< 5'd27);
  assign _zz__zz_fpAccReg_1_53 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_54 = ({28'd0,_zz__zz_fpAccReg_1_55} <<< 5'd28);
  assign _zz__zz_fpAccReg_1_55 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_56 = ({29'd0,_zz__zz_fpAccReg_1_57} <<< 5'd29);
  assign _zz__zz_fpAccReg_1_57 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_58 = ({30'd0,_zz__zz_fpAccReg_1_59} <<< 5'd30);
  assign _zz__zz_fpAccReg_1_59 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_60 = ({31'd0,_zz__zz_fpAccReg_1_61} <<< 5'd31);
  assign _zz__zz_fpAccReg_1_61 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_62 = ({32'd0,_zz__zz_fpAccReg_1_63} <<< 6'd32);
  assign _zz__zz_fpAccReg_1_63 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_64 = ({33'd0,_zz__zz_fpAccReg_1_65} <<< 6'd33);
  assign _zz__zz_fpAccReg_1_65 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_66 = ({34'd0,_zz__zz_fpAccReg_1_67} <<< 6'd34);
  assign _zz__zz_fpAccReg_1_67 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_68 = ({35'd0,_zz__zz_fpAccReg_1_69} <<< 6'd35);
  assign _zz__zz_fpAccReg_1_69 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_70 = ({36'd0,_zz__zz_fpAccReg_1_71} <<< 6'd36);
  assign _zz__zz_fpAccReg_1_71 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_72 = ({37'd0,_zz__zz_fpAccReg_1_73} <<< 6'd37);
  assign _zz__zz_fpAccReg_1_73 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_74 = ({38'd0,_zz__zz_fpAccReg_1_75} <<< 6'd38);
  assign _zz__zz_fpAccReg_1_75 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_76 = ({39'd0,_zz__zz_fpAccReg_1_77} <<< 6'd39);
  assign _zz__zz_fpAccReg_1_77 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_78 = ({40'd0,_zz__zz_fpAccReg_1_79} <<< 6'd40);
  assign _zz__zz_fpAccReg_1_79 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_80 = ({41'd0,_zz__zz_fpAccReg_1_81} <<< 6'd41);
  assign _zz__zz_fpAccReg_1_81 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_82 = ({42'd0,_zz__zz_fpAccReg_1_83} <<< 6'd42);
  assign _zz__zz_fpAccReg_1_83 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_84 = ({43'd0,_zz__zz_fpAccReg_1_85} <<< 6'd43);
  assign _zz__zz_fpAccReg_1_85 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_86 = ({44'd0,_zz__zz_fpAccReg_1_87} <<< 6'd44);
  assign _zz__zz_fpAccReg_1_87 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_88 = ({45'd0,_zz__zz_fpAccReg_1_89} <<< 6'd45);
  assign _zz__zz_fpAccReg_1_89 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_90 = ({46'd0,_zz__zz_fpAccReg_1_91} <<< 6'd46);
  assign _zz__zz_fpAccReg_1_91 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_92 = ({47'd0,_zz__zz_fpAccReg_1_93} <<< 6'd47);
  assign _zz__zz_fpAccReg_1_93 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_1_94 = ({48'd0,_zz__zz_fpAccReg_1_95} <<< 6'd48);
  assign _zz__zz_fpAccReg_1_95 = {48'd0, _zz_fpAccReg_2};
  assign _zz__zz_fpAccReg_3 = (_zz_fpAccReg_2 >>> 1'd1);
  assign _zz__zz_fpAccReg_1_97 = (_zz_fpAccReg_2[0] && (1'b0 || _zz_fpAccReg_3[0]));
  assign _zz__zz_fpAccReg_1_96 = {71'd0, _zz__zz_fpAccReg_1_97};
  assign _zz__zz_fpAccReg_4 = (_zz_fpAccReg_2 >>> 2'd2);
  assign _zz__zz_fpAccReg_1_99 = (_zz_fpAccReg_2[1] && ((|_zz_fpAccReg_2[0 : 0]) || _zz_fpAccReg_4[0]));
  assign _zz__zz_fpAccReg_1_98 = {71'd0, _zz__zz_fpAccReg_1_99};
  assign _zz__zz_fpAccReg_5 = (_zz_fpAccReg_2 >>> 2'd3);
  assign _zz__zz_fpAccReg_1_101 = (_zz_fpAccReg_2[2] && ((|_zz_fpAccReg_2[1 : 0]) || _zz_fpAccReg_5[0]));
  assign _zz__zz_fpAccReg_1_100 = {71'd0, _zz__zz_fpAccReg_1_101};
  assign _zz__zz_fpAccReg_6 = (_zz_fpAccReg_2 >>> 3'd4);
  assign _zz__zz_fpAccReg_1_103 = (_zz_fpAccReg_2[3] && ((|_zz_fpAccReg_2[2 : 0]) || _zz_fpAccReg_6[0]));
  assign _zz__zz_fpAccReg_1_102 = {71'd0, _zz__zz_fpAccReg_1_103};
  assign _zz__zz_fpAccReg_7 = (_zz_fpAccReg_2 >>> 3'd5);
  assign _zz__zz_fpAccReg_1_105 = (_zz_fpAccReg_2[4] && ((|_zz_fpAccReg_2[3 : 0]) || _zz_fpAccReg_7[0]));
  assign _zz__zz_fpAccReg_1_104 = {71'd0, _zz__zz_fpAccReg_1_105};
  assign _zz__zz_fpAccReg_8 = (_zz_fpAccReg_2 >>> 3'd6);
  assign _zz__zz_fpAccReg_1_107 = (_zz_fpAccReg_2[5] && ((|_zz_fpAccReg_2[4 : 0]) || _zz_fpAccReg_8[0]));
  assign _zz__zz_fpAccReg_1_106 = {71'd0, _zz__zz_fpAccReg_1_107};
  assign _zz__zz_fpAccReg_9 = (_zz_fpAccReg_2 >>> 3'd7);
  assign _zz__zz_fpAccReg_1_109 = (_zz_fpAccReg_2[6] && ((|_zz_fpAccReg_2[5 : 0]) || _zz_fpAccReg_9[0]));
  assign _zz__zz_fpAccReg_1_108 = {71'd0, _zz__zz_fpAccReg_1_109};
  assign _zz__zz_fpAccReg_10 = (_zz_fpAccReg_2 >>> 4'd8);
  assign _zz__zz_fpAccReg_1_111 = (_zz_fpAccReg_2[7] && ((|_zz_fpAccReg_2[6 : 0]) || _zz_fpAccReg_10[0]));
  assign _zz__zz_fpAccReg_1_110 = {71'd0, _zz__zz_fpAccReg_1_111};
  assign _zz__zz_fpAccReg_11 = (_zz_fpAccReg_2 >>> 4'd9);
  assign _zz__zz_fpAccReg_1_113 = (_zz_fpAccReg_2[8] && ((|_zz_fpAccReg_2[7 : 0]) || _zz_fpAccReg_11[0]));
  assign _zz__zz_fpAccReg_1_112 = {71'd0, _zz__zz_fpAccReg_1_113};
  assign _zz__zz_fpAccReg_12 = (_zz_fpAccReg_2 >>> 4'd10);
  assign _zz__zz_fpAccReg_1_115 = (_zz_fpAccReg_2[9] && ((|_zz_fpAccReg_2[8 : 0]) || _zz_fpAccReg_12[0]));
  assign _zz__zz_fpAccReg_1_114 = {71'd0, _zz__zz_fpAccReg_1_115};
  assign _zz__zz_fpAccReg_13 = (_zz_fpAccReg_2 >>> 4'd11);
  assign _zz__zz_fpAccReg_1_117 = (_zz_fpAccReg_2[10] && ((|_zz_fpAccReg_2[9 : 0]) || _zz_fpAccReg_13[0]));
  assign _zz__zz_fpAccReg_1_116 = {71'd0, _zz__zz_fpAccReg_1_117};
  assign _zz__zz_fpAccReg_14 = (_zz_fpAccReg_2 >>> 4'd12);
  assign _zz__zz_fpAccReg_1_119 = (_zz_fpAccReg_2[11] && ((|_zz_fpAccReg_2[10 : 0]) || _zz_fpAccReg_14[0]));
  assign _zz__zz_fpAccReg_1_118 = {71'd0, _zz__zz_fpAccReg_1_119};
  assign _zz__zz_fpAccReg_15 = (_zz_fpAccReg_2 >>> 4'd13);
  assign _zz__zz_fpAccReg_1_121 = (_zz_fpAccReg_2[12] && ((|_zz_fpAccReg_2[11 : 0]) || _zz_fpAccReg_15[0]));
  assign _zz__zz_fpAccReg_1_120 = {71'd0, _zz__zz_fpAccReg_1_121};
  assign _zz__zz_fpAccReg_16 = (_zz_fpAccReg_2 >>> 4'd14);
  assign _zz__zz_fpAccReg_1_123 = (_zz_fpAccReg_2[13] && ((|_zz_fpAccReg_2[12 : 0]) || _zz_fpAccReg_16[0]));
  assign _zz__zz_fpAccReg_1_122 = {71'd0, _zz__zz_fpAccReg_1_123};
  assign _zz__zz_fpAccReg_17 = (_zz_fpAccReg_2 >>> 4'd15);
  assign _zz__zz_fpAccReg_1_125 = (_zz_fpAccReg_2[14] && ((|_zz_fpAccReg_2[13 : 0]) || _zz_fpAccReg_17[0]));
  assign _zz__zz_fpAccReg_1_124 = {71'd0, _zz__zz_fpAccReg_1_125};
  assign _zz__zz_fpAccReg_18 = (_zz_fpAccReg_2 >>> 5'd16);
  assign _zz__zz_fpAccReg_1_127 = (_zz_fpAccReg_2[15] && ((|_zz_fpAccReg_2[14 : 0]) || _zz_fpAccReg_18[0]));
  assign _zz__zz_fpAccReg_1_126 = {71'd0, _zz__zz_fpAccReg_1_127};
  assign _zz__zz_fpAccReg_19 = (_zz_fpAccReg_2 >>> 5'd17);
  assign _zz__zz_fpAccReg_1_129 = (_zz_fpAccReg_2[16] && ((|_zz_fpAccReg_2[15 : 0]) || _zz_fpAccReg_19[0]));
  assign _zz__zz_fpAccReg_1_128 = {71'd0, _zz__zz_fpAccReg_1_129};
  assign _zz__zz_fpAccReg_20 = (_zz_fpAccReg_2 >>> 5'd18);
  assign _zz__zz_fpAccReg_1_131 = (_zz_fpAccReg_2[17] && ((|_zz_fpAccReg_2[16 : 0]) || _zz_fpAccReg_20[0]));
  assign _zz__zz_fpAccReg_1_130 = {71'd0, _zz__zz_fpAccReg_1_131};
  assign _zz__zz_fpAccReg_21 = (_zz_fpAccReg_2 >>> 5'd19);
  assign _zz__zz_fpAccReg_1_133 = (_zz_fpAccReg_2[18] && ((|_zz_fpAccReg_2[17 : 0]) || _zz_fpAccReg_21[0]));
  assign _zz__zz_fpAccReg_1_132 = {71'd0, _zz__zz_fpAccReg_1_133};
  assign _zz__zz_fpAccReg_22 = (_zz_fpAccReg_2 >>> 5'd20);
  assign _zz__zz_fpAccReg_1_135 = (_zz_fpAccReg_2[19] && ((|_zz_fpAccReg_2[18 : 0]) || _zz_fpAccReg_22[0]));
  assign _zz__zz_fpAccReg_1_134 = {71'd0, _zz__zz_fpAccReg_1_135};
  assign _zz__zz_fpAccReg_23 = (_zz_fpAccReg_2 >>> 5'd21);
  assign _zz__zz_fpAccReg_1_137 = (_zz_fpAccReg_2[20] && ((|_zz_fpAccReg_2[19 : 0]) || _zz_fpAccReg_23[0]));
  assign _zz__zz_fpAccReg_1_136 = {71'd0, _zz__zz_fpAccReg_1_137};
  assign _zz__zz_fpAccReg_24 = (_zz_fpAccReg_2 >>> 5'd22);
  assign _zz__zz_fpAccReg_1_139 = (_zz_fpAccReg_2[21] && ((|_zz_fpAccReg_2[20 : 0]) || _zz_fpAccReg_24[0]));
  assign _zz__zz_fpAccReg_1_138 = {71'd0, _zz__zz_fpAccReg_1_139};
  assign _zz__zz_fpAccReg_25 = (_zz_fpAccReg_2 >>> 5'd23);
  assign _zz__zz_fpAccReg_1_141 = (_zz_fpAccReg_2[22] && ((|_zz_fpAccReg_2[21 : 0]) || _zz_fpAccReg_25[0]));
  assign _zz__zz_fpAccReg_1_140 = {71'd0, _zz__zz_fpAccReg_1_141};
  assign _zz__zz_fpAccReg_1_143 = (_zz_fpAccReg_2[23] && ((|_zz_fpAccReg_2[22 : 0]) || _zz_fpAccReg_26[0]));
  assign _zz__zz_fpAccReg_1_142 = {71'd0, _zz__zz_fpAccReg_1_143};
  assign _zz__zz_fpAccReg_27 = _zz_fpAccReg_1;
  assign _zz__zz_when_MatrixEngine_l89_1 = (- fpAccReg);
  assign _zz__zz_when_MatrixEngine_l209_1 = (_zz_when_MatrixEngine_l184_1 - 7'h17);
  assign _zz__zz_when_MatrixEngine_l204_1 = (7'h17 - _zz_when_MatrixEngine_l184_1);
  assign _zz__zz_when_MatrixEngine_l233_4_1 = ({1'd0,_zz__zz_when_MatrixEngine_l233_4_2} <<< 1'd1);
  assign _zz__zz_when_MatrixEngine_l233_4_2 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_3 = ({2'd0,_zz__zz_when_MatrixEngine_l233_4_4} <<< 2'd2);
  assign _zz__zz_when_MatrixEngine_l233_4_4 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_5 = ({3'd0,_zz__zz_when_MatrixEngine_l233_4_6} <<< 2'd3);
  assign _zz__zz_when_MatrixEngine_l233_4_6 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_7 = ({4'd0,_zz__zz_when_MatrixEngine_l233_4_8} <<< 3'd4);
  assign _zz__zz_when_MatrixEngine_l233_4_8 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_9 = ({5'd0,_zz__zz_when_MatrixEngine_l233_4_10} <<< 3'd5);
  assign _zz__zz_when_MatrixEngine_l233_4_10 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_11 = ({6'd0,_zz__zz_when_MatrixEngine_l233_4_12} <<< 3'd6);
  assign _zz__zz_when_MatrixEngine_l233_4_12 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_13 = ({7'd0,_zz__zz_when_MatrixEngine_l233_4_14} <<< 3'd7);
  assign _zz__zz_when_MatrixEngine_l233_4_14 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_15 = ({8'd0,_zz__zz_when_MatrixEngine_l233_4_16} <<< 4'd8);
  assign _zz__zz_when_MatrixEngine_l233_4_16 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_17 = ({9'd0,_zz__zz_when_MatrixEngine_l233_4_18} <<< 4'd9);
  assign _zz__zz_when_MatrixEngine_l233_4_18 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_19 = ({10'd0,_zz__zz_when_MatrixEngine_l233_4_20} <<< 4'd10);
  assign _zz__zz_when_MatrixEngine_l233_4_20 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_21 = ({11'd0,_zz__zz_when_MatrixEngine_l233_4_22} <<< 4'd11);
  assign _zz__zz_when_MatrixEngine_l233_4_22 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_23 = ({12'd0,_zz__zz_when_MatrixEngine_l233_4_24} <<< 4'd12);
  assign _zz__zz_when_MatrixEngine_l233_4_24 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_25 = ({13'd0,_zz__zz_when_MatrixEngine_l233_4_26} <<< 4'd13);
  assign _zz__zz_when_MatrixEngine_l233_4_26 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_27 = ({14'd0,_zz__zz_when_MatrixEngine_l233_4_28} <<< 4'd14);
  assign _zz__zz_when_MatrixEngine_l233_4_28 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_29 = ({15'd0,_zz__zz_when_MatrixEngine_l233_4_30} <<< 4'd15);
  assign _zz__zz_when_MatrixEngine_l233_4_30 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_31 = ({16'd0,_zz__zz_when_MatrixEngine_l233_4_32} <<< 5'd16);
  assign _zz__zz_when_MatrixEngine_l233_4_32 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_33 = ({17'd0,_zz__zz_when_MatrixEngine_l233_4_34} <<< 5'd17);
  assign _zz__zz_when_MatrixEngine_l233_4_34 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_35 = ({18'd0,_zz__zz_when_MatrixEngine_l233_4_36} <<< 5'd18);
  assign _zz__zz_when_MatrixEngine_l233_4_36 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_37 = ({19'd0,_zz__zz_when_MatrixEngine_l233_4_38} <<< 5'd19);
  assign _zz__zz_when_MatrixEngine_l233_4_38 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_39 = ({20'd0,_zz__zz_when_MatrixEngine_l233_4_40} <<< 5'd20);
  assign _zz__zz_when_MatrixEngine_l233_4_40 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_41 = ({21'd0,_zz__zz_when_MatrixEngine_l233_4_42} <<< 5'd21);
  assign _zz__zz_when_MatrixEngine_l233_4_42 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_43 = ({22'd0,_zz__zz_when_MatrixEngine_l233_4_44} <<< 5'd22);
  assign _zz__zz_when_MatrixEngine_l233_4_44 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_45 = ({23'd0,_zz__zz_when_MatrixEngine_l233_4_46} <<< 5'd23);
  assign _zz__zz_when_MatrixEngine_l233_4_46 = _zz_when_MatrixEngine_l89_1[23:0];
  assign _zz__zz_when_MatrixEngine_l233_4_47 = (_zz_when_MatrixEngine_l89_1 >>> 1'd1);
  assign _zz__zz_when_MatrixEngine_l233_4_48 = (_zz_when_MatrixEngine_l89_1 >>> 2'd2);
  assign _zz__zz_when_MatrixEngine_l233_4_49 = (_zz_when_MatrixEngine_l89_1 >>> 2'd3);
  assign _zz__zz_when_MatrixEngine_l233_4_50 = (_zz_when_MatrixEngine_l89_1 >>> 3'd4);
  assign _zz__zz_when_MatrixEngine_l233_4_51 = (_zz_when_MatrixEngine_l89_1 >>> 3'd5);
  assign _zz__zz_when_MatrixEngine_l233_4_52 = (_zz_when_MatrixEngine_l89_1 >>> 3'd6);
  assign _zz__zz_when_MatrixEngine_l233_4_53 = (_zz_when_MatrixEngine_l89_1 >>> 3'd7);
  assign _zz__zz_when_MatrixEngine_l233_4_54 = (_zz_when_MatrixEngine_l89_1 >>> 4'd8);
  assign _zz__zz_when_MatrixEngine_l233_4_55 = (_zz_when_MatrixEngine_l89_1 >>> 4'd9);
  assign _zz__zz_when_MatrixEngine_l233_4_56 = (_zz_when_MatrixEngine_l89_1 >>> 4'd10);
  assign _zz__zz_when_MatrixEngine_l233_4_57 = (_zz_when_MatrixEngine_l89_1 >>> 4'd11);
  assign _zz__zz_when_MatrixEngine_l233_4_58 = (_zz_when_MatrixEngine_l89_1 >>> 4'd12);
  assign _zz__zz_when_MatrixEngine_l233_4_59 = (_zz_when_MatrixEngine_l89_1 >>> 4'd13);
  assign _zz__zz_when_MatrixEngine_l233_4_60 = (_zz_when_MatrixEngine_l89_1 >>> 4'd14);
  assign _zz__zz_when_MatrixEngine_l233_4_61 = (_zz_when_MatrixEngine_l89_1 >>> 4'd15);
  assign _zz__zz_when_MatrixEngine_l233_4_62 = (_zz_when_MatrixEngine_l89_1 >>> 5'd16);
  assign _zz__zz_when_MatrixEngine_l233_4_63 = (_zz_when_MatrixEngine_l89_1 >>> 5'd17);
  assign _zz__zz_when_MatrixEngine_l233_4_64 = (_zz_when_MatrixEngine_l89_1 >>> 5'd18);
  assign _zz__zz_when_MatrixEngine_l233_4_65 = (_zz_when_MatrixEngine_l89_1 >>> 5'd19);
  assign _zz__zz_when_MatrixEngine_l233_4_66 = (_zz_when_MatrixEngine_l89_1 >>> 5'd20);
  assign _zz__zz_when_MatrixEngine_l233_4_67 = (_zz_when_MatrixEngine_l89_1 >>> 5'd21);
  assign _zz__zz_when_MatrixEngine_l233_4_68 = (_zz_when_MatrixEngine_l89_1 >>> 5'd22);
  assign _zz__zz_when_MatrixEngine_l233_4_69 = (_zz_when_MatrixEngine_l89_1 >>> 5'd23);
  assign _zz__zz_when_MatrixEngine_l233_4_70 = (_zz_when_MatrixEngine_l89_1 >>> 5'd24);
  assign _zz__zz_when_MatrixEngine_l233_4_71 = (_zz_when_MatrixEngine_l89_1 >>> 5'd25);
  assign _zz__zz_when_MatrixEngine_l233_4_72 = (_zz_when_MatrixEngine_l89_1 >>> 5'd26);
  assign _zz__zz_when_MatrixEngine_l233_4_73 = (_zz_when_MatrixEngine_l89_1 >>> 5'd27);
  assign _zz__zz_when_MatrixEngine_l233_4_74 = (_zz_when_MatrixEngine_l89_1 >>> 5'd28);
  assign _zz__zz_when_MatrixEngine_l233_4_75 = (_zz_when_MatrixEngine_l89_1 >>> 5'd29);
  assign _zz__zz_when_MatrixEngine_l233_4_76 = (_zz_when_MatrixEngine_l89_1 >>> 5'd30);
  assign _zz__zz_when_MatrixEngine_l233_4_77 = (_zz_when_MatrixEngine_l89_1 >>> 5'd31);
  assign _zz__zz_when_MatrixEngine_l233_4_78 = (_zz_when_MatrixEngine_l89_1 >>> 6'd32);
  assign _zz__zz_when_MatrixEngine_l233_4_79 = (_zz_when_MatrixEngine_l89_1 >>> 6'd33);
  assign _zz__zz_when_MatrixEngine_l233_4_80 = (_zz_when_MatrixEngine_l89_1 >>> 6'd34);
  assign _zz__zz_when_MatrixEngine_l233_4_81 = (_zz_when_MatrixEngine_l89_1 >>> 6'd35);
  assign _zz__zz_when_MatrixEngine_l233_4_82 = (_zz_when_MatrixEngine_l89_1 >>> 6'd36);
  assign _zz__zz_when_MatrixEngine_l233_4_83 = (_zz_when_MatrixEngine_l89_1 >>> 6'd37);
  assign _zz__zz_when_MatrixEngine_l233_4_84 = (_zz_when_MatrixEngine_l89_1 >>> 6'd38);
  assign _zz__zz_when_MatrixEngine_l233_4_85 = (_zz_when_MatrixEngine_l89_1 >>> 6'd39);
  assign _zz__zz_when_MatrixEngine_l233_4_86 = (_zz_when_MatrixEngine_l89_1 >>> 6'd40);
  assign _zz__zz_when_MatrixEngine_l233_4_87 = (_zz_when_MatrixEngine_l89_1 >>> 6'd41);
  assign _zz__zz_when_MatrixEngine_l233_4_88 = (_zz_when_MatrixEngine_l89_1 >>> 6'd42);
  assign _zz__zz_when_MatrixEngine_l233_4_89 = (_zz_when_MatrixEngine_l89_1 >>> 6'd43);
  assign _zz__zz_when_MatrixEngine_l233_4_90 = (_zz_when_MatrixEngine_l89_1 >>> 6'd44);
  assign _zz__zz_when_MatrixEngine_l233_4_91 = (_zz_when_MatrixEngine_l89_1 >>> 6'd45);
  assign _zz__zz_when_MatrixEngine_l233_4_92 = (_zz_when_MatrixEngine_l89_1 >>> 6'd46);
  assign _zz__zz_when_MatrixEngine_l233_4_93 = (_zz_when_MatrixEngine_l89_1 >>> 6'd47);
  assign _zz__zz_when_MatrixEngine_l233_7_1 = {1'd0, _zz_when_MatrixEngine_l233_4};
  assign _zz__zz_when_MatrixEngine_l233_7_3 = (_zz_when_MatrixEngine_l233_5 && (_zz_when_MatrixEngine_l233_6 || _zz_when_MatrixEngine_l233_4[0]));
  assign _zz__zz_when_MatrixEngine_l233_7_2 = {24'd0, _zz__zz_when_MatrixEngine_l233_7_3};
  assign _zz__zz_io_matrixAccumWrData_1 = {1'd0, _zz_when_MatrixEngine_l184_1};
  `ifndef SYNTHESIS
  always @(*) begin
    case(state)
      MatrixState_IDLE : state_string = "IDLE     ";
      MatrixState_ZERO : state_string = "ZERO     ";
      MatrixState_ACC_READ : state_string = "ACC_READ ";
      MatrixState_ACC_LOAD : state_string = "ACC_LOAD ";
      MatrixState_AB_READ : state_string = "AB_READ  ";
      MatrixState_MAC : state_string = "MAC      ";
      MatrixState_ACC_WRITE : state_string = "ACC_WRITE";
      default : state_string = "?????????";
    endcase
  end
  `endif

  assign slotValid = (io_valid && io_slots_0_valid);
  assign slotTileElems = _zz_slotTileElems[6:0];
  assign when_MatrixEngine_l317 = (! slotValid);
  assign startsCompute = (((slotValid && (! issueSeenReg)) && (state == MatrixState_IDLE)) && ((((((io_slots_0_opcode == 5'h07) || (io_slots_0_opcode == 5'h08)) || (io_slots_0_opcode == 5'h0a)) || (io_slots_0_opcode == 5'h0b)) || (io_slots_0_opcode == 5'h0c)) || (io_slots_0_opcode == 5'h0d)));
  assign startsZero = (((slotValid && (! issueSeenReg)) && (state == MatrixState_IDLE)) && (io_slots_0_opcode == 5'h09));
  assign activeUsesFp8 = (((activeOpcodeReg == 5'h0a) || (activeOpcodeReg == 5'h0b)) || ((activeOpcodeReg == 5'h0c) || (activeOpcodeReg == 5'h0d)));
  assign activeUsesFp8E5M2 = ((activeOpcodeReg == 5'h0c) || (activeOpcodeReg == 5'h0d));
  assign activeAccumulates = (((activeOpcodeReg == 5'h08) || (activeOpcodeReg == 5'h0b)) || (activeOpcodeReg == 5'h0d));
  always @(*) begin
    io_matrixScratchAAddr = 8'h0;
    case(state)
      MatrixState_AB_READ : begin
        io_matrixScratchAAddr = (operandABaseReg + aIndex);
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchAEn = 1'b0;
    case(state)
      MatrixState_AB_READ : begin
        io_matrixScratchAEn = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchAWe = 1'b0;
    case(state)
      MatrixState_AB_READ : begin
        io_matrixScratchAWe = 1'b0;
      end
      default : begin
      end
    endcase
  end

  assign io_matrixScratchAWrData = 8'h0;
  always @(*) begin
    io_matrixScratchBAddr = 8'h0;
    case(state)
      MatrixState_AB_READ : begin
        io_matrixScratchBAddr = (operandBBaseReg + bIndex);
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchBEn = 1'b0;
    case(state)
      MatrixState_AB_READ : begin
        io_matrixScratchBEn = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchBWe = 1'b0;
    case(state)
      MatrixState_AB_READ : begin
        io_matrixScratchBWe = 1'b0;
      end
      default : begin
      end
    endcase
  end

  assign io_matrixScratchBWrData = 8'h0;
  always @(*) begin
    io_matrixAccumAddr = 6'h0;
    case(state)
      MatrixState_ZERO : begin
        io_matrixAccumAddr = (localBaseReg + _zz_io_matrixAccumAddr);
      end
      MatrixState_ACC_READ : begin
        io_matrixAccumAddr = (localBaseReg + outputIndex);
      end
      MatrixState_ACC_WRITE : begin
        io_matrixAccumAddr = (localBaseReg + outputIndex);
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_matrixAccumEn = 1'b0;
    case(state)
      MatrixState_ZERO : begin
        io_matrixAccumEn = 1'b1;
      end
      MatrixState_ACC_READ : begin
        io_matrixAccumEn = 1'b1;
      end
      MatrixState_ACC_WRITE : begin
        io_matrixAccumEn = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_matrixAccumWe = 1'b0;
    case(state)
      MatrixState_ZERO : begin
        io_matrixAccumWe = 1'b1;
      end
      MatrixState_ACC_READ : begin
        io_matrixAccumWe = 1'b0;
      end
      MatrixState_ACC_WRITE : begin
        io_matrixAccumWe = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_matrixAccumWrData = 32'h0;
    case(state)
      MatrixState_ZERO : begin
        io_matrixAccumWrData = 32'h0;
      end
      MatrixState_ACC_WRITE : begin
        if(activeUsesFp8) begin
          io_matrixAccumWrData = _zz_io_matrixAccumWrData;
        end else begin
          io_matrixAccumWrData = accReg;
        end
      end
      default : begin
      end
    endcase
  end

  assign outputIndex = _zz_outputIndex[5:0];
  assign aIndex = _zz_aIndex[7:0];
  assign bIndex = _zz_bIndex[7:0];
  assign aValue = {{24{_zz_aValue[7]}}, _zz_aValue};
  assign bValue = {{24{_zz_bValue[7]}}, _zz_bValue};
  assign product = _zz_product[31:0];
  assign _zz_fpA_E4M3_isZero = io_matrixScratchARdData[6 : 3];
  assign _zz_fpA_E4M3_isZero_1 = io_matrixScratchARdData[2 : 0];
  assign fpA_E4M3_sign = io_matrixScratchARdData[7];
  assign fpA_E4M3_isZero = ((_zz_fpA_E4M3_isZero == 4'b0000) && (_zz_fpA_E4M3_isZero_1 == 3'b000));
  assign fpA_E4M3_isSpecial = ((_zz_fpA_E4M3_isZero == 4'b1111) && (_zz_fpA_E4M3_isZero_1 == 3'b111));
  always @(*) begin
    fpA_E4M3_sig = 4'b0000;
    if(when_MatrixEngine_l107) begin
      fpA_E4M3_sig = 4'b0000;
    end else begin
      if(when_MatrixEngine_l109) begin
        fpA_E4M3_sig = {1'd0, _zz_fpA_E4M3_isZero_1};
      end else begin
        fpA_E4M3_sig = {1'b1,_zz_fpA_E4M3_isZero_1};
      end
    end
  end

  always @(*) begin
    fpA_E4M3_shift = 6'h17;
    if(!when_MatrixEngine_l107) begin
      if(when_MatrixEngine_l109) begin
        fpA_E4M3_shift = 6'h17;
      end else begin
        fpA_E4M3_shift = (_zz_fpA_E4M3_shift + 6'h16);
      end
    end
  end

  assign when_MatrixEngine_l107 = (fpA_E4M3_isSpecial || fpA_E4M3_isZero);
  assign when_MatrixEngine_l109 = (_zz_fpA_E4M3_isZero == 4'b0000);
  assign _zz_fpB_E4M3_isZero = io_matrixScratchBRdData[6 : 3];
  assign _zz_fpB_E4M3_isZero_1 = io_matrixScratchBRdData[2 : 0];
  assign fpB_E4M3_sign = io_matrixScratchBRdData[7];
  assign fpB_E4M3_isZero = ((_zz_fpB_E4M3_isZero == 4'b0000) && (_zz_fpB_E4M3_isZero_1 == 3'b000));
  assign fpB_E4M3_isSpecial = ((_zz_fpB_E4M3_isZero == 4'b1111) && (_zz_fpB_E4M3_isZero_1 == 3'b111));
  always @(*) begin
    fpB_E4M3_sig = 4'b0000;
    if(when_MatrixEngine_l107_1) begin
      fpB_E4M3_sig = 4'b0000;
    end else begin
      if(when_MatrixEngine_l109_1) begin
        fpB_E4M3_sig = {1'd0, _zz_fpB_E4M3_isZero_1};
      end else begin
        fpB_E4M3_sig = {1'b1,_zz_fpB_E4M3_isZero_1};
      end
    end
  end

  always @(*) begin
    fpB_E4M3_shift = 6'h17;
    if(!when_MatrixEngine_l107_1) begin
      if(when_MatrixEngine_l109_1) begin
        fpB_E4M3_shift = 6'h17;
      end else begin
        fpB_E4M3_shift = (_zz_fpB_E4M3_shift + 6'h16);
      end
    end
  end

  assign when_MatrixEngine_l107_1 = (fpB_E4M3_isSpecial || fpB_E4M3_isZero);
  assign when_MatrixEngine_l109_1 = (_zz_fpB_E4M3_isZero == 4'b0000);
  assign _zz_fpA_E5M2_isZero = io_matrixScratchARdData[6 : 2];
  assign _zz_fpA_E5M2_isZero_1 = io_matrixScratchARdData[1 : 0];
  assign fpA_E5M2_sign = io_matrixScratchARdData[7];
  assign fpA_E5M2_isZero = ((_zz_fpA_E5M2_isZero == 5'h0) && (_zz_fpA_E5M2_isZero_1 == 2'b00));
  assign fpA_E5M2_isSpecial = (_zz_fpA_E5M2_isZero == 5'h1f);
  always @(*) begin
    fpA_E5M2_sig = 4'b0000;
    if(when_MatrixEngine_l131) begin
      fpA_E5M2_sig = 4'b0000;
    end else begin
      if(when_MatrixEngine_l133) begin
        fpA_E5M2_sig = {2'd0, _zz_fpA_E5M2_isZero_1};
      end else begin
        fpA_E5M2_sig = {2'b01,_zz_fpA_E5M2_isZero_1};
      end
    end
  end

  always @(*) begin
    fpA_E5M2_shift = 6'h10;
    if(!when_MatrixEngine_l131) begin
      if(when_MatrixEngine_l133) begin
        fpA_E5M2_shift = 6'h10;
      end else begin
        fpA_E5M2_shift = (_zz_fpA_E5M2_shift + 6'h0f);
      end
    end
  end

  assign when_MatrixEngine_l131 = (fpA_E5M2_isSpecial || fpA_E5M2_isZero);
  assign when_MatrixEngine_l133 = (_zz_fpA_E5M2_isZero == 5'h0);
  assign _zz_fpB_E5M2_isZero = io_matrixScratchBRdData[6 : 2];
  assign _zz_fpB_E5M2_isZero_1 = io_matrixScratchBRdData[1 : 0];
  assign fpB_E5M2_sign = io_matrixScratchBRdData[7];
  assign fpB_E5M2_isZero = ((_zz_fpB_E5M2_isZero == 5'h0) && (_zz_fpB_E5M2_isZero_1 == 2'b00));
  assign fpB_E5M2_isSpecial = (_zz_fpB_E5M2_isZero == 5'h1f);
  always @(*) begin
    fpB_E5M2_sig = 4'b0000;
    if(when_MatrixEngine_l131_1) begin
      fpB_E5M2_sig = 4'b0000;
    end else begin
      if(when_MatrixEngine_l133_1) begin
        fpB_E5M2_sig = {2'd0, _zz_fpB_E5M2_isZero_1};
      end else begin
        fpB_E5M2_sig = {2'b01,_zz_fpB_E5M2_isZero_1};
      end
    end
  end

  always @(*) begin
    fpB_E5M2_shift = 6'h10;
    if(!when_MatrixEngine_l131_1) begin
      if(when_MatrixEngine_l133_1) begin
        fpB_E5M2_shift = 6'h10;
      end else begin
        fpB_E5M2_shift = (_zz_fpB_E5M2_shift + 6'h0f);
      end
    end
  end

  assign when_MatrixEngine_l131_1 = (fpB_E5M2_isSpecial || fpB_E5M2_isZero);
  assign when_MatrixEngine_l133_1 = (_zz_fpB_E5M2_isZero == 5'h0);
  assign _zz_when_MatrixEngine_l154 = _zz__zz_when_MatrixEngine_l154[5:0];
  assign _zz_fpProductE4M3 = _zz__zz_fpProductE4M3[7:0];
  always @(*) begin
    _zz_fpProductE4M3_1 = 72'h0;
    if(when_MatrixEngine_l152) begin
      if(when_MatrixEngine_l154) begin
        _zz_fpProductE4M3_1 = {64'd0, _zz_fpProductE4M3};
      end
      if(when_MatrixEngine_l154_1) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_1[71:0];
      end
      if(when_MatrixEngine_l154_2) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_3[71:0];
      end
      if(when_MatrixEngine_l154_3) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_5[71:0];
      end
      if(when_MatrixEngine_l154_4) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_7[71:0];
      end
      if(when_MatrixEngine_l154_5) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_9[71:0];
      end
      if(when_MatrixEngine_l154_6) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_11[71:0];
      end
      if(when_MatrixEngine_l154_7) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_13[71:0];
      end
      if(when_MatrixEngine_l154_8) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_15[71:0];
      end
      if(when_MatrixEngine_l154_9) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_17[71:0];
      end
      if(when_MatrixEngine_l154_10) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_19[71:0];
      end
      if(when_MatrixEngine_l154_11) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_21[71:0];
      end
      if(when_MatrixEngine_l154_12) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_23[71:0];
      end
      if(when_MatrixEngine_l154_13) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_25[71:0];
      end
      if(when_MatrixEngine_l154_14) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_27[71:0];
      end
      if(when_MatrixEngine_l154_15) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_29[71:0];
      end
      if(when_MatrixEngine_l154_16) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_31[71:0];
      end
      if(when_MatrixEngine_l154_17) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_33[71:0];
      end
      if(when_MatrixEngine_l154_18) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_35[71:0];
      end
      if(when_MatrixEngine_l154_19) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_37[71:0];
      end
      if(when_MatrixEngine_l154_20) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_39[71:0];
      end
      if(when_MatrixEngine_l154_21) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_41[71:0];
      end
      if(when_MatrixEngine_l154_22) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_43[71:0];
      end
      if(when_MatrixEngine_l154_23) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_45[71:0];
      end
      if(when_MatrixEngine_l154_24) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_47[71:0];
      end
      if(when_MatrixEngine_l154_25) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_49[71:0];
      end
      if(when_MatrixEngine_l154_26) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_51[71:0];
      end
      if(when_MatrixEngine_l154_27) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_53[71:0];
      end
      if(when_MatrixEngine_l154_28) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_55[71:0];
      end
      if(when_MatrixEngine_l154_29) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_57[71:0];
      end
      if(when_MatrixEngine_l154_30) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_59[71:0];
      end
      if(when_MatrixEngine_l154_31) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_61[71:0];
      end
      if(when_MatrixEngine_l154_32) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_63[71:0];
      end
      if(when_MatrixEngine_l154_33) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_65[71:0];
      end
      if(when_MatrixEngine_l154_34) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_67[71:0];
      end
      if(when_MatrixEngine_l154_35) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_69[71:0];
      end
      if(when_MatrixEngine_l154_36) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_71[71:0];
      end
      if(when_MatrixEngine_l154_37) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_73[71:0];
      end
      if(when_MatrixEngine_l154_38) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_75[71:0];
      end
      if(when_MatrixEngine_l154_39) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_77[71:0];
      end
      if(when_MatrixEngine_l154_40) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_79[71:0];
      end
      if(when_MatrixEngine_l154_41) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_81[71:0];
      end
      if(when_MatrixEngine_l154_42) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_83[71:0];
      end
      if(when_MatrixEngine_l154_43) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_85[71:0];
      end
      if(when_MatrixEngine_l154_44) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_87[71:0];
      end
      if(when_MatrixEngine_l154_45) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_89[71:0];
      end
      if(when_MatrixEngine_l154_46) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_91[71:0];
      end
      if(when_MatrixEngine_l154_47) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_93[71:0];
      end
      if(when_MatrixEngine_l154_48) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_95[71:0];
      end
      if(when_MatrixEngine_l154_49) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_97[71:0];
      end
      if(when_MatrixEngine_l154_50) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_99[71:0];
      end
      if(when_MatrixEngine_l154_51) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_101[71:0];
      end
      if(when_MatrixEngine_l154_52) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_103[71:0];
      end
      if(when_MatrixEngine_l154_53) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_105[71:0];
      end
      if(when_MatrixEngine_l154_54) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_107[71:0];
      end
      if(when_MatrixEngine_l154_55) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_109[71:0];
      end
      if(when_MatrixEngine_l154_56) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_111[71:0];
      end
      if(when_MatrixEngine_l154_57) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_113[71:0];
      end
      if(when_MatrixEngine_l154_58) begin
        _zz_fpProductE4M3_1 = _zz__zz_fpProductE4M3_1_115[71:0];
      end
    end
  end

  assign when_MatrixEngine_l152 = ((! fpA_E4M3_isZero) && (! fpB_E4M3_isZero));
  assign when_MatrixEngine_l154 = (_zz_when_MatrixEngine_l154 == 6'h0);
  assign when_MatrixEngine_l154_1 = (_zz_when_MatrixEngine_l154 == 6'h01);
  assign when_MatrixEngine_l154_2 = (_zz_when_MatrixEngine_l154 == 6'h02);
  assign when_MatrixEngine_l154_3 = (_zz_when_MatrixEngine_l154 == 6'h03);
  assign when_MatrixEngine_l154_4 = (_zz_when_MatrixEngine_l154 == 6'h04);
  assign when_MatrixEngine_l154_5 = (_zz_when_MatrixEngine_l154 == 6'h05);
  assign when_MatrixEngine_l154_6 = (_zz_when_MatrixEngine_l154 == 6'h06);
  assign when_MatrixEngine_l154_7 = (_zz_when_MatrixEngine_l154 == 6'h07);
  assign when_MatrixEngine_l154_8 = (_zz_when_MatrixEngine_l154 == 6'h08);
  assign when_MatrixEngine_l154_9 = (_zz_when_MatrixEngine_l154 == 6'h09);
  assign when_MatrixEngine_l154_10 = (_zz_when_MatrixEngine_l154 == 6'h0a);
  assign when_MatrixEngine_l154_11 = (_zz_when_MatrixEngine_l154 == 6'h0b);
  assign when_MatrixEngine_l154_12 = (_zz_when_MatrixEngine_l154 == 6'h0c);
  assign when_MatrixEngine_l154_13 = (_zz_when_MatrixEngine_l154 == 6'h0d);
  assign when_MatrixEngine_l154_14 = (_zz_when_MatrixEngine_l154 == 6'h0e);
  assign when_MatrixEngine_l154_15 = (_zz_when_MatrixEngine_l154 == 6'h0f);
  assign when_MatrixEngine_l154_16 = (_zz_when_MatrixEngine_l154 == 6'h10);
  assign when_MatrixEngine_l154_17 = (_zz_when_MatrixEngine_l154 == 6'h11);
  assign when_MatrixEngine_l154_18 = (_zz_when_MatrixEngine_l154 == 6'h12);
  assign when_MatrixEngine_l154_19 = (_zz_when_MatrixEngine_l154 == 6'h13);
  assign when_MatrixEngine_l154_20 = (_zz_when_MatrixEngine_l154 == 6'h14);
  assign when_MatrixEngine_l154_21 = (_zz_when_MatrixEngine_l154 == 6'h15);
  assign when_MatrixEngine_l154_22 = (_zz_when_MatrixEngine_l154 == 6'h16);
  assign when_MatrixEngine_l154_23 = (_zz_when_MatrixEngine_l154 == 6'h17);
  assign when_MatrixEngine_l154_24 = (_zz_when_MatrixEngine_l154 == 6'h18);
  assign when_MatrixEngine_l154_25 = (_zz_when_MatrixEngine_l154 == 6'h19);
  assign when_MatrixEngine_l154_26 = (_zz_when_MatrixEngine_l154 == 6'h1a);
  assign when_MatrixEngine_l154_27 = (_zz_when_MatrixEngine_l154 == 6'h1b);
  assign when_MatrixEngine_l154_28 = (_zz_when_MatrixEngine_l154 == 6'h1c);
  assign when_MatrixEngine_l154_29 = (_zz_when_MatrixEngine_l154 == 6'h1d);
  assign when_MatrixEngine_l154_30 = (_zz_when_MatrixEngine_l154 == 6'h1e);
  assign when_MatrixEngine_l154_31 = (_zz_when_MatrixEngine_l154 == 6'h1f);
  assign when_MatrixEngine_l154_32 = (_zz_when_MatrixEngine_l154 == 6'h20);
  assign when_MatrixEngine_l154_33 = (_zz_when_MatrixEngine_l154 == 6'h21);
  assign when_MatrixEngine_l154_34 = (_zz_when_MatrixEngine_l154 == 6'h22);
  assign when_MatrixEngine_l154_35 = (_zz_when_MatrixEngine_l154 == 6'h23);
  assign when_MatrixEngine_l154_36 = (_zz_when_MatrixEngine_l154 == 6'h24);
  assign when_MatrixEngine_l154_37 = (_zz_when_MatrixEngine_l154 == 6'h25);
  assign when_MatrixEngine_l154_38 = (_zz_when_MatrixEngine_l154 == 6'h26);
  assign when_MatrixEngine_l154_39 = (_zz_when_MatrixEngine_l154 == 6'h27);
  assign when_MatrixEngine_l154_40 = (_zz_when_MatrixEngine_l154 == 6'h28);
  assign when_MatrixEngine_l154_41 = (_zz_when_MatrixEngine_l154 == 6'h29);
  assign when_MatrixEngine_l154_42 = (_zz_when_MatrixEngine_l154 == 6'h2a);
  assign when_MatrixEngine_l154_43 = (_zz_when_MatrixEngine_l154 == 6'h2b);
  assign when_MatrixEngine_l154_44 = (_zz_when_MatrixEngine_l154 == 6'h2c);
  assign when_MatrixEngine_l154_45 = (_zz_when_MatrixEngine_l154 == 6'h2d);
  assign when_MatrixEngine_l154_46 = (_zz_when_MatrixEngine_l154 == 6'h2e);
  assign when_MatrixEngine_l154_47 = (_zz_when_MatrixEngine_l154 == 6'h2f);
  assign when_MatrixEngine_l154_48 = (_zz_when_MatrixEngine_l154 == 6'h30);
  assign when_MatrixEngine_l154_49 = (_zz_when_MatrixEngine_l154 == 6'h31);
  assign when_MatrixEngine_l154_50 = (_zz_when_MatrixEngine_l154 == 6'h32);
  assign when_MatrixEngine_l154_51 = (_zz_when_MatrixEngine_l154 == 6'h33);
  assign when_MatrixEngine_l154_52 = (_zz_when_MatrixEngine_l154 == 6'h34);
  assign when_MatrixEngine_l154_53 = (_zz_when_MatrixEngine_l154 == 6'h35);
  assign when_MatrixEngine_l154_54 = (_zz_when_MatrixEngine_l154 == 6'h36);
  assign when_MatrixEngine_l154_55 = (_zz_when_MatrixEngine_l154 == 6'h37);
  assign when_MatrixEngine_l154_56 = (_zz_when_MatrixEngine_l154 == 6'h38);
  assign when_MatrixEngine_l154_57 = (_zz_when_MatrixEngine_l154 == 6'h39);
  assign when_MatrixEngine_l154_58 = (_zz_when_MatrixEngine_l154 == 6'h3a);
  always @(*) begin
    fpProductE4M3 = _zz_fpProductE4M3_1;
    if(when_MatrixEngine_l162) begin
      fpProductE4M3 = (- _zz_fpProductE4M3_2);
    end
  end

  assign when_MatrixEngine_l162 = (fpA_E4M3_sign ^ fpB_E4M3_sign);
  assign _zz_when_MatrixEngine_l154_1 = _zz__zz_when_MatrixEngine_l154_1_1[5:0];
  assign _zz_fpProductE5M2 = _zz__zz_fpProductE5M2[7:0];
  always @(*) begin
    _zz_fpProductE5M2_1 = 72'h0;
    if(when_MatrixEngine_l152_1) begin
      if(when_MatrixEngine_l154_59) begin
        _zz_fpProductE5M2_1 = {64'd0, _zz_fpProductE5M2};
      end
      if(when_MatrixEngine_l154_60) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_1[71:0];
      end
      if(when_MatrixEngine_l154_61) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_3[71:0];
      end
      if(when_MatrixEngine_l154_62) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_5[71:0];
      end
      if(when_MatrixEngine_l154_63) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_7[71:0];
      end
      if(when_MatrixEngine_l154_64) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_9[71:0];
      end
      if(when_MatrixEngine_l154_65) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_11[71:0];
      end
      if(when_MatrixEngine_l154_66) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_13[71:0];
      end
      if(when_MatrixEngine_l154_67) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_15[71:0];
      end
      if(when_MatrixEngine_l154_68) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_17[71:0];
      end
      if(when_MatrixEngine_l154_69) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_19[71:0];
      end
      if(when_MatrixEngine_l154_70) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_21[71:0];
      end
      if(when_MatrixEngine_l154_71) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_23[71:0];
      end
      if(when_MatrixEngine_l154_72) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_25[71:0];
      end
      if(when_MatrixEngine_l154_73) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_27[71:0];
      end
      if(when_MatrixEngine_l154_74) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_29[71:0];
      end
      if(when_MatrixEngine_l154_75) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_31[71:0];
      end
      if(when_MatrixEngine_l154_76) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_33[71:0];
      end
      if(when_MatrixEngine_l154_77) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_35[71:0];
      end
      if(when_MatrixEngine_l154_78) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_37[71:0];
      end
      if(when_MatrixEngine_l154_79) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_39[71:0];
      end
      if(when_MatrixEngine_l154_80) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_41[71:0];
      end
      if(when_MatrixEngine_l154_81) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_43[71:0];
      end
      if(when_MatrixEngine_l154_82) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_45[71:0];
      end
      if(when_MatrixEngine_l154_83) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_47[71:0];
      end
      if(when_MatrixEngine_l154_84) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_49[71:0];
      end
      if(when_MatrixEngine_l154_85) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_51[71:0];
      end
      if(when_MatrixEngine_l154_86) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_53[71:0];
      end
      if(when_MatrixEngine_l154_87) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_55[71:0];
      end
      if(when_MatrixEngine_l154_88) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_57[71:0];
      end
      if(when_MatrixEngine_l154_89) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_59[71:0];
      end
      if(when_MatrixEngine_l154_90) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_61[71:0];
      end
      if(when_MatrixEngine_l154_91) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_63[71:0];
      end
      if(when_MatrixEngine_l154_92) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_65[71:0];
      end
      if(when_MatrixEngine_l154_93) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_67[71:0];
      end
      if(when_MatrixEngine_l154_94) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_69[71:0];
      end
      if(when_MatrixEngine_l154_95) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_71[71:0];
      end
      if(when_MatrixEngine_l154_96) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_73[71:0];
      end
      if(when_MatrixEngine_l154_97) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_75[71:0];
      end
      if(when_MatrixEngine_l154_98) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_77[71:0];
      end
      if(when_MatrixEngine_l154_99) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_79[71:0];
      end
      if(when_MatrixEngine_l154_100) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_81[71:0];
      end
      if(when_MatrixEngine_l154_101) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_83[71:0];
      end
      if(when_MatrixEngine_l154_102) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_85[71:0];
      end
      if(when_MatrixEngine_l154_103) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_87[71:0];
      end
      if(when_MatrixEngine_l154_104) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_89[71:0];
      end
      if(when_MatrixEngine_l154_105) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_91[71:0];
      end
      if(when_MatrixEngine_l154_106) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_93[71:0];
      end
      if(when_MatrixEngine_l154_107) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_95[71:0];
      end
      if(when_MatrixEngine_l154_108) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_97[71:0];
      end
      if(when_MatrixEngine_l154_109) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_99[71:0];
      end
      if(when_MatrixEngine_l154_110) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_101[71:0];
      end
      if(when_MatrixEngine_l154_111) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_103[71:0];
      end
      if(when_MatrixEngine_l154_112) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_105[71:0];
      end
      if(when_MatrixEngine_l154_113) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_107[71:0];
      end
      if(when_MatrixEngine_l154_114) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_109[71:0];
      end
      if(when_MatrixEngine_l154_115) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_111[71:0];
      end
      if(when_MatrixEngine_l154_116) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_113[71:0];
      end
      if(when_MatrixEngine_l154_117) begin
        _zz_fpProductE5M2_1 = _zz__zz_fpProductE5M2_1_115[71:0];
      end
    end
  end

  assign when_MatrixEngine_l152_1 = ((! fpA_E5M2_isZero) && (! fpB_E5M2_isZero));
  assign when_MatrixEngine_l154_59 = (_zz_when_MatrixEngine_l154_1 == 6'h0);
  assign when_MatrixEngine_l154_60 = (_zz_when_MatrixEngine_l154_1 == 6'h01);
  assign when_MatrixEngine_l154_61 = (_zz_when_MatrixEngine_l154_1 == 6'h02);
  assign when_MatrixEngine_l154_62 = (_zz_when_MatrixEngine_l154_1 == 6'h03);
  assign when_MatrixEngine_l154_63 = (_zz_when_MatrixEngine_l154_1 == 6'h04);
  assign when_MatrixEngine_l154_64 = (_zz_when_MatrixEngine_l154_1 == 6'h05);
  assign when_MatrixEngine_l154_65 = (_zz_when_MatrixEngine_l154_1 == 6'h06);
  assign when_MatrixEngine_l154_66 = (_zz_when_MatrixEngine_l154_1 == 6'h07);
  assign when_MatrixEngine_l154_67 = (_zz_when_MatrixEngine_l154_1 == 6'h08);
  assign when_MatrixEngine_l154_68 = (_zz_when_MatrixEngine_l154_1 == 6'h09);
  assign when_MatrixEngine_l154_69 = (_zz_when_MatrixEngine_l154_1 == 6'h0a);
  assign when_MatrixEngine_l154_70 = (_zz_when_MatrixEngine_l154_1 == 6'h0b);
  assign when_MatrixEngine_l154_71 = (_zz_when_MatrixEngine_l154_1 == 6'h0c);
  assign when_MatrixEngine_l154_72 = (_zz_when_MatrixEngine_l154_1 == 6'h0d);
  assign when_MatrixEngine_l154_73 = (_zz_when_MatrixEngine_l154_1 == 6'h0e);
  assign when_MatrixEngine_l154_74 = (_zz_when_MatrixEngine_l154_1 == 6'h0f);
  assign when_MatrixEngine_l154_75 = (_zz_when_MatrixEngine_l154_1 == 6'h10);
  assign when_MatrixEngine_l154_76 = (_zz_when_MatrixEngine_l154_1 == 6'h11);
  assign when_MatrixEngine_l154_77 = (_zz_when_MatrixEngine_l154_1 == 6'h12);
  assign when_MatrixEngine_l154_78 = (_zz_when_MatrixEngine_l154_1 == 6'h13);
  assign when_MatrixEngine_l154_79 = (_zz_when_MatrixEngine_l154_1 == 6'h14);
  assign when_MatrixEngine_l154_80 = (_zz_when_MatrixEngine_l154_1 == 6'h15);
  assign when_MatrixEngine_l154_81 = (_zz_when_MatrixEngine_l154_1 == 6'h16);
  assign when_MatrixEngine_l154_82 = (_zz_when_MatrixEngine_l154_1 == 6'h17);
  assign when_MatrixEngine_l154_83 = (_zz_when_MatrixEngine_l154_1 == 6'h18);
  assign when_MatrixEngine_l154_84 = (_zz_when_MatrixEngine_l154_1 == 6'h19);
  assign when_MatrixEngine_l154_85 = (_zz_when_MatrixEngine_l154_1 == 6'h1a);
  assign when_MatrixEngine_l154_86 = (_zz_when_MatrixEngine_l154_1 == 6'h1b);
  assign when_MatrixEngine_l154_87 = (_zz_when_MatrixEngine_l154_1 == 6'h1c);
  assign when_MatrixEngine_l154_88 = (_zz_when_MatrixEngine_l154_1 == 6'h1d);
  assign when_MatrixEngine_l154_89 = (_zz_when_MatrixEngine_l154_1 == 6'h1e);
  assign when_MatrixEngine_l154_90 = (_zz_when_MatrixEngine_l154_1 == 6'h1f);
  assign when_MatrixEngine_l154_91 = (_zz_when_MatrixEngine_l154_1 == 6'h20);
  assign when_MatrixEngine_l154_92 = (_zz_when_MatrixEngine_l154_1 == 6'h21);
  assign when_MatrixEngine_l154_93 = (_zz_when_MatrixEngine_l154_1 == 6'h22);
  assign when_MatrixEngine_l154_94 = (_zz_when_MatrixEngine_l154_1 == 6'h23);
  assign when_MatrixEngine_l154_95 = (_zz_when_MatrixEngine_l154_1 == 6'h24);
  assign when_MatrixEngine_l154_96 = (_zz_when_MatrixEngine_l154_1 == 6'h25);
  assign when_MatrixEngine_l154_97 = (_zz_when_MatrixEngine_l154_1 == 6'h26);
  assign when_MatrixEngine_l154_98 = (_zz_when_MatrixEngine_l154_1 == 6'h27);
  assign when_MatrixEngine_l154_99 = (_zz_when_MatrixEngine_l154_1 == 6'h28);
  assign when_MatrixEngine_l154_100 = (_zz_when_MatrixEngine_l154_1 == 6'h29);
  assign when_MatrixEngine_l154_101 = (_zz_when_MatrixEngine_l154_1 == 6'h2a);
  assign when_MatrixEngine_l154_102 = (_zz_when_MatrixEngine_l154_1 == 6'h2b);
  assign when_MatrixEngine_l154_103 = (_zz_when_MatrixEngine_l154_1 == 6'h2c);
  assign when_MatrixEngine_l154_104 = (_zz_when_MatrixEngine_l154_1 == 6'h2d);
  assign when_MatrixEngine_l154_105 = (_zz_when_MatrixEngine_l154_1 == 6'h2e);
  assign when_MatrixEngine_l154_106 = (_zz_when_MatrixEngine_l154_1 == 6'h2f);
  assign when_MatrixEngine_l154_107 = (_zz_when_MatrixEngine_l154_1 == 6'h30);
  assign when_MatrixEngine_l154_108 = (_zz_when_MatrixEngine_l154_1 == 6'h31);
  assign when_MatrixEngine_l154_109 = (_zz_when_MatrixEngine_l154_1 == 6'h32);
  assign when_MatrixEngine_l154_110 = (_zz_when_MatrixEngine_l154_1 == 6'h33);
  assign when_MatrixEngine_l154_111 = (_zz_when_MatrixEngine_l154_1 == 6'h34);
  assign when_MatrixEngine_l154_112 = (_zz_when_MatrixEngine_l154_1 == 6'h35);
  assign when_MatrixEngine_l154_113 = (_zz_when_MatrixEngine_l154_1 == 6'h36);
  assign when_MatrixEngine_l154_114 = (_zz_when_MatrixEngine_l154_1 == 6'h37);
  assign when_MatrixEngine_l154_115 = (_zz_when_MatrixEngine_l154_1 == 6'h38);
  assign when_MatrixEngine_l154_116 = (_zz_when_MatrixEngine_l154_1 == 6'h39);
  assign when_MatrixEngine_l154_117 = (_zz_when_MatrixEngine_l154_1 == 6'h3a);
  always @(*) begin
    fpProductE5M2 = _zz_fpProductE5M2_1;
    if(when_MatrixEngine_l162_1) begin
      fpProductE5M2 = (- _zz_fpProductE5M2_2);
    end
  end

  assign when_MatrixEngine_l162_1 = (fpA_E5M2_sign ^ fpB_E5M2_sign);
  assign fpProduct = (activeUsesFp8E5M2 ? fpProductE5M2 : fpProductE4M3);
  assign fpProductHasSpecial = (activeUsesFp8E5M2 ? (fpA_E5M2_isSpecial || fpB_E5M2_isSpecial) : (fpA_E4M3_isSpecial || fpB_E4M3_isSpecial));
  always @(*) begin
    _zz_when_MatrixEngine_l290 = 32'h0;
    if(when_MatrixEngine_l201) begin
      _zz_when_MatrixEngine_l290 = {{when_MatrixEngine_l175,_zz_when_MatrixEngine_l290_2},_zz_when_MatrixEngine_l290_3[22 : 0]};
    end
  end

  assign when_MatrixEngine_l175 = fpAccReg[71];
  always @(*) begin
    _zz_when_MatrixEngine_l89 = 72'h0;
    if(when_MatrixEngine_l175) begin
      _zz_when_MatrixEngine_l89 = _zz__zz_when_MatrixEngine_l89;
    end else begin
      _zz_when_MatrixEngine_l89 = fpAccReg;
    end
  end

  always @(*) begin
    _zz_when_MatrixEngine_l184 = 7'h0;
    if(when_MatrixEngine_l89) begin
      _zz_when_MatrixEngine_l184 = 7'h0;
    end
    if(when_MatrixEngine_l89_1) begin
      _zz_when_MatrixEngine_l184 = 7'h01;
    end
    if(when_MatrixEngine_l89_2) begin
      _zz_when_MatrixEngine_l184 = 7'h02;
    end
    if(when_MatrixEngine_l89_3) begin
      _zz_when_MatrixEngine_l184 = 7'h03;
    end
    if(when_MatrixEngine_l89_4) begin
      _zz_when_MatrixEngine_l184 = 7'h04;
    end
    if(when_MatrixEngine_l89_5) begin
      _zz_when_MatrixEngine_l184 = 7'h05;
    end
    if(when_MatrixEngine_l89_6) begin
      _zz_when_MatrixEngine_l184 = 7'h06;
    end
    if(when_MatrixEngine_l89_7) begin
      _zz_when_MatrixEngine_l184 = 7'h07;
    end
    if(when_MatrixEngine_l89_8) begin
      _zz_when_MatrixEngine_l184 = 7'h08;
    end
    if(when_MatrixEngine_l89_9) begin
      _zz_when_MatrixEngine_l184 = 7'h09;
    end
    if(when_MatrixEngine_l89_10) begin
      _zz_when_MatrixEngine_l184 = 7'h0a;
    end
    if(when_MatrixEngine_l89_11) begin
      _zz_when_MatrixEngine_l184 = 7'h0b;
    end
    if(when_MatrixEngine_l89_12) begin
      _zz_when_MatrixEngine_l184 = 7'h0c;
    end
    if(when_MatrixEngine_l89_13) begin
      _zz_when_MatrixEngine_l184 = 7'h0d;
    end
    if(when_MatrixEngine_l89_14) begin
      _zz_when_MatrixEngine_l184 = 7'h0e;
    end
    if(when_MatrixEngine_l89_15) begin
      _zz_when_MatrixEngine_l184 = 7'h0f;
    end
    if(when_MatrixEngine_l89_16) begin
      _zz_when_MatrixEngine_l184 = 7'h10;
    end
    if(when_MatrixEngine_l89_17) begin
      _zz_when_MatrixEngine_l184 = 7'h11;
    end
    if(when_MatrixEngine_l89_18) begin
      _zz_when_MatrixEngine_l184 = 7'h12;
    end
    if(when_MatrixEngine_l89_19) begin
      _zz_when_MatrixEngine_l184 = 7'h13;
    end
    if(when_MatrixEngine_l89_20) begin
      _zz_when_MatrixEngine_l184 = 7'h14;
    end
    if(when_MatrixEngine_l89_21) begin
      _zz_when_MatrixEngine_l184 = 7'h15;
    end
    if(when_MatrixEngine_l89_22) begin
      _zz_when_MatrixEngine_l184 = 7'h16;
    end
    if(when_MatrixEngine_l89_23) begin
      _zz_when_MatrixEngine_l184 = 7'h17;
    end
    if(when_MatrixEngine_l89_24) begin
      _zz_when_MatrixEngine_l184 = 7'h18;
    end
    if(when_MatrixEngine_l89_25) begin
      _zz_when_MatrixEngine_l184 = 7'h19;
    end
    if(when_MatrixEngine_l89_26) begin
      _zz_when_MatrixEngine_l184 = 7'h1a;
    end
    if(when_MatrixEngine_l89_27) begin
      _zz_when_MatrixEngine_l184 = 7'h1b;
    end
    if(when_MatrixEngine_l89_28) begin
      _zz_when_MatrixEngine_l184 = 7'h1c;
    end
    if(when_MatrixEngine_l89_29) begin
      _zz_when_MatrixEngine_l184 = 7'h1d;
    end
    if(when_MatrixEngine_l89_30) begin
      _zz_when_MatrixEngine_l184 = 7'h1e;
    end
    if(when_MatrixEngine_l89_31) begin
      _zz_when_MatrixEngine_l184 = 7'h1f;
    end
    if(when_MatrixEngine_l89_32) begin
      _zz_when_MatrixEngine_l184 = 7'h20;
    end
    if(when_MatrixEngine_l89_33) begin
      _zz_when_MatrixEngine_l184 = 7'h21;
    end
    if(when_MatrixEngine_l89_34) begin
      _zz_when_MatrixEngine_l184 = 7'h22;
    end
    if(when_MatrixEngine_l89_35) begin
      _zz_when_MatrixEngine_l184 = 7'h23;
    end
    if(when_MatrixEngine_l89_36) begin
      _zz_when_MatrixEngine_l184 = 7'h24;
    end
    if(when_MatrixEngine_l89_37) begin
      _zz_when_MatrixEngine_l184 = 7'h25;
    end
    if(when_MatrixEngine_l89_38) begin
      _zz_when_MatrixEngine_l184 = 7'h26;
    end
    if(when_MatrixEngine_l89_39) begin
      _zz_when_MatrixEngine_l184 = 7'h27;
    end
    if(when_MatrixEngine_l89_40) begin
      _zz_when_MatrixEngine_l184 = 7'h28;
    end
    if(when_MatrixEngine_l89_41) begin
      _zz_when_MatrixEngine_l184 = 7'h29;
    end
    if(when_MatrixEngine_l89_42) begin
      _zz_when_MatrixEngine_l184 = 7'h2a;
    end
    if(when_MatrixEngine_l89_43) begin
      _zz_when_MatrixEngine_l184 = 7'h2b;
    end
    if(when_MatrixEngine_l89_44) begin
      _zz_when_MatrixEngine_l184 = 7'h2c;
    end
    if(when_MatrixEngine_l89_45) begin
      _zz_when_MatrixEngine_l184 = 7'h2d;
    end
    if(when_MatrixEngine_l89_46) begin
      _zz_when_MatrixEngine_l184 = 7'h2e;
    end
    if(when_MatrixEngine_l89_47) begin
      _zz_when_MatrixEngine_l184 = 7'h2f;
    end
    if(when_MatrixEngine_l89_48) begin
      _zz_when_MatrixEngine_l184 = 7'h30;
    end
    if(when_MatrixEngine_l89_49) begin
      _zz_when_MatrixEngine_l184 = 7'h31;
    end
    if(when_MatrixEngine_l89_50) begin
      _zz_when_MatrixEngine_l184 = 7'h32;
    end
    if(when_MatrixEngine_l89_51) begin
      _zz_when_MatrixEngine_l184 = 7'h33;
    end
    if(when_MatrixEngine_l89_52) begin
      _zz_when_MatrixEngine_l184 = 7'h34;
    end
    if(when_MatrixEngine_l89_53) begin
      _zz_when_MatrixEngine_l184 = 7'h35;
    end
    if(when_MatrixEngine_l89_54) begin
      _zz_when_MatrixEngine_l184 = 7'h36;
    end
    if(when_MatrixEngine_l89_55) begin
      _zz_when_MatrixEngine_l184 = 7'h37;
    end
    if(when_MatrixEngine_l89_56) begin
      _zz_when_MatrixEngine_l184 = 7'h38;
    end
    if(when_MatrixEngine_l89_57) begin
      _zz_when_MatrixEngine_l184 = 7'h39;
    end
    if(when_MatrixEngine_l89_58) begin
      _zz_when_MatrixEngine_l184 = 7'h3a;
    end
    if(when_MatrixEngine_l89_59) begin
      _zz_when_MatrixEngine_l184 = 7'h3b;
    end
    if(when_MatrixEngine_l89_60) begin
      _zz_when_MatrixEngine_l184 = 7'h3c;
    end
    if(when_MatrixEngine_l89_61) begin
      _zz_when_MatrixEngine_l184 = 7'h3d;
    end
    if(when_MatrixEngine_l89_62) begin
      _zz_when_MatrixEngine_l184 = 7'h3e;
    end
    if(when_MatrixEngine_l89_63) begin
      _zz_when_MatrixEngine_l184 = 7'h3f;
    end
    if(when_MatrixEngine_l89_64) begin
      _zz_when_MatrixEngine_l184 = 7'h40;
    end
    if(when_MatrixEngine_l89_65) begin
      _zz_when_MatrixEngine_l184 = 7'h41;
    end
    if(when_MatrixEngine_l89_66) begin
      _zz_when_MatrixEngine_l184 = 7'h42;
    end
    if(when_MatrixEngine_l89_67) begin
      _zz_when_MatrixEngine_l184 = 7'h43;
    end
    if(when_MatrixEngine_l89_68) begin
      _zz_when_MatrixEngine_l184 = 7'h44;
    end
    if(when_MatrixEngine_l89_69) begin
      _zz_when_MatrixEngine_l184 = 7'h45;
    end
    if(when_MatrixEngine_l89_70) begin
      _zz_when_MatrixEngine_l184 = 7'h46;
    end
    if(when_MatrixEngine_l89_71) begin
      _zz_when_MatrixEngine_l184 = 7'h47;
    end
  end

  assign when_MatrixEngine_l89 = _zz_when_MatrixEngine_l89[0];
  assign when_MatrixEngine_l89_1 = _zz_when_MatrixEngine_l89[1];
  assign when_MatrixEngine_l89_2 = _zz_when_MatrixEngine_l89[2];
  assign when_MatrixEngine_l89_3 = _zz_when_MatrixEngine_l89[3];
  assign when_MatrixEngine_l89_4 = _zz_when_MatrixEngine_l89[4];
  assign when_MatrixEngine_l89_5 = _zz_when_MatrixEngine_l89[5];
  assign when_MatrixEngine_l89_6 = _zz_when_MatrixEngine_l89[6];
  assign when_MatrixEngine_l89_7 = _zz_when_MatrixEngine_l89[7];
  assign when_MatrixEngine_l89_8 = _zz_when_MatrixEngine_l89[8];
  assign when_MatrixEngine_l89_9 = _zz_when_MatrixEngine_l89[9];
  assign when_MatrixEngine_l89_10 = _zz_when_MatrixEngine_l89[10];
  assign when_MatrixEngine_l89_11 = _zz_when_MatrixEngine_l89[11];
  assign when_MatrixEngine_l89_12 = _zz_when_MatrixEngine_l89[12];
  assign when_MatrixEngine_l89_13 = _zz_when_MatrixEngine_l89[13];
  assign when_MatrixEngine_l89_14 = _zz_when_MatrixEngine_l89[14];
  assign when_MatrixEngine_l89_15 = _zz_when_MatrixEngine_l89[15];
  assign when_MatrixEngine_l89_16 = _zz_when_MatrixEngine_l89[16];
  assign when_MatrixEngine_l89_17 = _zz_when_MatrixEngine_l89[17];
  assign when_MatrixEngine_l89_18 = _zz_when_MatrixEngine_l89[18];
  assign when_MatrixEngine_l89_19 = _zz_when_MatrixEngine_l89[19];
  assign when_MatrixEngine_l89_20 = _zz_when_MatrixEngine_l89[20];
  assign when_MatrixEngine_l89_21 = _zz_when_MatrixEngine_l89[21];
  assign when_MatrixEngine_l89_22 = _zz_when_MatrixEngine_l89[22];
  assign when_MatrixEngine_l89_23 = _zz_when_MatrixEngine_l89[23];
  assign when_MatrixEngine_l89_24 = _zz_when_MatrixEngine_l89[24];
  assign when_MatrixEngine_l89_25 = _zz_when_MatrixEngine_l89[25];
  assign when_MatrixEngine_l89_26 = _zz_when_MatrixEngine_l89[26];
  assign when_MatrixEngine_l89_27 = _zz_when_MatrixEngine_l89[27];
  assign when_MatrixEngine_l89_28 = _zz_when_MatrixEngine_l89[28];
  assign when_MatrixEngine_l89_29 = _zz_when_MatrixEngine_l89[29];
  assign when_MatrixEngine_l89_30 = _zz_when_MatrixEngine_l89[30];
  assign when_MatrixEngine_l89_31 = _zz_when_MatrixEngine_l89[31];
  assign when_MatrixEngine_l89_32 = _zz_when_MatrixEngine_l89[32];
  assign when_MatrixEngine_l89_33 = _zz_when_MatrixEngine_l89[33];
  assign when_MatrixEngine_l89_34 = _zz_when_MatrixEngine_l89[34];
  assign when_MatrixEngine_l89_35 = _zz_when_MatrixEngine_l89[35];
  assign when_MatrixEngine_l89_36 = _zz_when_MatrixEngine_l89[36];
  assign when_MatrixEngine_l89_37 = _zz_when_MatrixEngine_l89[37];
  assign when_MatrixEngine_l89_38 = _zz_when_MatrixEngine_l89[38];
  assign when_MatrixEngine_l89_39 = _zz_when_MatrixEngine_l89[39];
  assign when_MatrixEngine_l89_40 = _zz_when_MatrixEngine_l89[40];
  assign when_MatrixEngine_l89_41 = _zz_when_MatrixEngine_l89[41];
  assign when_MatrixEngine_l89_42 = _zz_when_MatrixEngine_l89[42];
  assign when_MatrixEngine_l89_43 = _zz_when_MatrixEngine_l89[43];
  assign when_MatrixEngine_l89_44 = _zz_when_MatrixEngine_l89[44];
  assign when_MatrixEngine_l89_45 = _zz_when_MatrixEngine_l89[45];
  assign when_MatrixEngine_l89_46 = _zz_when_MatrixEngine_l89[46];
  assign when_MatrixEngine_l89_47 = _zz_when_MatrixEngine_l89[47];
  assign when_MatrixEngine_l89_48 = _zz_when_MatrixEngine_l89[48];
  assign when_MatrixEngine_l89_49 = _zz_when_MatrixEngine_l89[49];
  assign when_MatrixEngine_l89_50 = _zz_when_MatrixEngine_l89[50];
  assign when_MatrixEngine_l89_51 = _zz_when_MatrixEngine_l89[51];
  assign when_MatrixEngine_l89_52 = _zz_when_MatrixEngine_l89[52];
  assign when_MatrixEngine_l89_53 = _zz_when_MatrixEngine_l89[53];
  assign when_MatrixEngine_l89_54 = _zz_when_MatrixEngine_l89[54];
  assign when_MatrixEngine_l89_55 = _zz_when_MatrixEngine_l89[55];
  assign when_MatrixEngine_l89_56 = _zz_when_MatrixEngine_l89[56];
  assign when_MatrixEngine_l89_57 = _zz_when_MatrixEngine_l89[57];
  assign when_MatrixEngine_l89_58 = _zz_when_MatrixEngine_l89[58];
  assign when_MatrixEngine_l89_59 = _zz_when_MatrixEngine_l89[59];
  assign when_MatrixEngine_l89_60 = _zz_when_MatrixEngine_l89[60];
  assign when_MatrixEngine_l89_61 = _zz_when_MatrixEngine_l89[61];
  assign when_MatrixEngine_l89_62 = _zz_when_MatrixEngine_l89[62];
  assign when_MatrixEngine_l89_63 = _zz_when_MatrixEngine_l89[63];
  assign when_MatrixEngine_l89_64 = _zz_when_MatrixEngine_l89[64];
  assign when_MatrixEngine_l89_65 = _zz_when_MatrixEngine_l89[65];
  assign when_MatrixEngine_l89_66 = _zz_when_MatrixEngine_l89[66];
  assign when_MatrixEngine_l89_67 = _zz_when_MatrixEngine_l89[67];
  assign when_MatrixEngine_l89_68 = _zz_when_MatrixEngine_l89[68];
  assign when_MatrixEngine_l89_69 = _zz_when_MatrixEngine_l89[69];
  assign when_MatrixEngine_l89_70 = _zz_when_MatrixEngine_l89[70];
  assign when_MatrixEngine_l89_71 = _zz_when_MatrixEngine_l89[71];
  always @(*) begin
    _zz_when_MatrixEngine_l209 = 6'h0;
    if(when_MatrixEngine_l184) begin
      _zz_when_MatrixEngine_l209 = _zz__zz_when_MatrixEngine_l209[5:0];
    end
  end

  assign when_MatrixEngine_l184 = (7'h17 < _zz_when_MatrixEngine_l184);
  always @(*) begin
    _zz_when_MatrixEngine_l204 = 5'h0;
    if(when_MatrixEngine_l190) begin
      _zz_when_MatrixEngine_l204 = _zz__zz_when_MatrixEngine_l204[4:0];
    end
  end

  assign when_MatrixEngine_l190 = (_zz_when_MatrixEngine_l184 <= 7'h17);
  always @(*) begin
    _zz_when_MatrixEngine_l233 = 24'h0;
    if(when_MatrixEngine_l201) begin
      if(when_MatrixEngine_l202) begin
        if(when_MatrixEngine_l204) begin
          _zz_when_MatrixEngine_l233 = _zz_when_MatrixEngine_l89[23:0];
        end
        if(when_MatrixEngine_l204_1) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233[23:0];
        end
        if(when_MatrixEngine_l204_2) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_2[23:0];
        end
        if(when_MatrixEngine_l204_3) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_4[23:0];
        end
        if(when_MatrixEngine_l204_4) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_6[23:0];
        end
        if(when_MatrixEngine_l204_5) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_8[23:0];
        end
        if(when_MatrixEngine_l204_6) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_10[23:0];
        end
        if(when_MatrixEngine_l204_7) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_12[23:0];
        end
        if(when_MatrixEngine_l204_8) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_14[23:0];
        end
        if(when_MatrixEngine_l204_9) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_16[23:0];
        end
        if(when_MatrixEngine_l204_10) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_18[23:0];
        end
        if(when_MatrixEngine_l204_11) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_20[23:0];
        end
        if(when_MatrixEngine_l204_12) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_22[23:0];
        end
        if(when_MatrixEngine_l204_13) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_24[23:0];
        end
        if(when_MatrixEngine_l204_14) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_26[23:0];
        end
        if(when_MatrixEngine_l204_15) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_28[23:0];
        end
        if(when_MatrixEngine_l204_16) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_30[23:0];
        end
        if(when_MatrixEngine_l204_17) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_32[23:0];
        end
        if(when_MatrixEngine_l204_18) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_34[23:0];
        end
        if(when_MatrixEngine_l204_19) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_36[23:0];
        end
        if(when_MatrixEngine_l204_20) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_38[23:0];
        end
        if(when_MatrixEngine_l204_21) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_40[23:0];
        end
        if(when_MatrixEngine_l204_22) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_42[23:0];
        end
        if(when_MatrixEngine_l204_23) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_44[23:0];
        end
      end else begin
        if(when_MatrixEngine_l209) begin
          _zz_when_MatrixEngine_l233 = _zz_when_MatrixEngine_l89[23 : 0];
        end
        if(when_MatrixEngine_l213) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_46[23:0];
        end
        if(when_MatrixEngine_l213_1) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_47[23:0];
        end
        if(when_MatrixEngine_l213_2) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_48[23:0];
        end
        if(when_MatrixEngine_l213_3) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_49[23:0];
        end
        if(when_MatrixEngine_l213_4) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_50[23:0];
        end
        if(when_MatrixEngine_l213_5) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_51[23:0];
        end
        if(when_MatrixEngine_l213_6) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_52[23:0];
        end
        if(when_MatrixEngine_l213_7) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_53[23:0];
        end
        if(when_MatrixEngine_l213_8) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_54[23:0];
        end
        if(when_MatrixEngine_l213_9) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_55[23:0];
        end
        if(when_MatrixEngine_l213_10) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_56[23:0];
        end
        if(when_MatrixEngine_l213_11) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_57[23:0];
        end
        if(when_MatrixEngine_l213_12) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_58[23:0];
        end
        if(when_MatrixEngine_l213_13) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_59[23:0];
        end
        if(when_MatrixEngine_l213_14) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_60[23:0];
        end
        if(when_MatrixEngine_l213_15) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_61[23:0];
        end
        if(when_MatrixEngine_l213_16) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_62[23:0];
        end
        if(when_MatrixEngine_l213_17) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_63[23:0];
        end
        if(when_MatrixEngine_l213_18) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_64[23:0];
        end
        if(when_MatrixEngine_l213_19) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_65[23:0];
        end
        if(when_MatrixEngine_l213_20) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_66[23:0];
        end
        if(when_MatrixEngine_l213_21) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_67[23:0];
        end
        if(when_MatrixEngine_l213_22) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_68[23:0];
        end
        if(when_MatrixEngine_l213_23) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_69[23:0];
        end
        if(when_MatrixEngine_l213_24) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_70[23:0];
        end
        if(when_MatrixEngine_l213_25) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_71[23:0];
        end
        if(when_MatrixEngine_l213_26) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_72[23:0];
        end
        if(when_MatrixEngine_l213_27) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_73[23:0];
        end
        if(when_MatrixEngine_l213_28) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_74[23:0];
        end
        if(when_MatrixEngine_l213_29) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_75[23:0];
        end
        if(when_MatrixEngine_l213_30) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_76[23:0];
        end
        if(when_MatrixEngine_l213_31) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_77[23:0];
        end
        if(when_MatrixEngine_l213_32) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_78[23:0];
        end
        if(when_MatrixEngine_l213_33) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_79[23:0];
        end
        if(when_MatrixEngine_l213_34) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_80[23:0];
        end
        if(when_MatrixEngine_l213_35) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_81[23:0];
        end
        if(when_MatrixEngine_l213_36) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_82[23:0];
        end
        if(when_MatrixEngine_l213_37) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_83[23:0];
        end
        if(when_MatrixEngine_l213_38) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_84[23:0];
        end
        if(when_MatrixEngine_l213_39) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_85[23:0];
        end
        if(when_MatrixEngine_l213_40) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_86[23:0];
        end
        if(when_MatrixEngine_l213_41) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_87[23:0];
        end
        if(when_MatrixEngine_l213_42) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_88[23:0];
        end
        if(when_MatrixEngine_l213_43) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_89[23:0];
        end
        if(when_MatrixEngine_l213_44) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_90[23:0];
        end
        if(when_MatrixEngine_l213_45) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_91[23:0];
        end
        if(when_MatrixEngine_l213_46) begin
          _zz_when_MatrixEngine_l233 = _zz__zz_when_MatrixEngine_l233_92[23:0];
        end
        if(when_MatrixEngine_l213_47) begin
          _zz_when_MatrixEngine_l233 = (_zz_when_MatrixEngine_l89 >>> 6'd48);
        end
      end
    end
  end

  always @(*) begin
    _zz_when_MatrixEngine_l233_1 = 1'b0;
    if(when_MatrixEngine_l201) begin
      if(!when_MatrixEngine_l202) begin
        if(when_MatrixEngine_l213) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[0];
        end
        if(when_MatrixEngine_l213_1) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[1];
        end
        if(when_MatrixEngine_l213_2) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[2];
        end
        if(when_MatrixEngine_l213_3) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[3];
        end
        if(when_MatrixEngine_l213_4) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[4];
        end
        if(when_MatrixEngine_l213_5) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[5];
        end
        if(when_MatrixEngine_l213_6) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[6];
        end
        if(when_MatrixEngine_l213_7) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[7];
        end
        if(when_MatrixEngine_l213_8) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[8];
        end
        if(when_MatrixEngine_l213_9) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[9];
        end
        if(when_MatrixEngine_l213_10) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[10];
        end
        if(when_MatrixEngine_l213_11) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[11];
        end
        if(when_MatrixEngine_l213_12) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[12];
        end
        if(when_MatrixEngine_l213_13) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[13];
        end
        if(when_MatrixEngine_l213_14) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[14];
        end
        if(when_MatrixEngine_l213_15) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[15];
        end
        if(when_MatrixEngine_l213_16) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[16];
        end
        if(when_MatrixEngine_l213_17) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[17];
        end
        if(when_MatrixEngine_l213_18) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[18];
        end
        if(when_MatrixEngine_l213_19) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[19];
        end
        if(when_MatrixEngine_l213_20) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[20];
        end
        if(when_MatrixEngine_l213_21) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[21];
        end
        if(when_MatrixEngine_l213_22) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[22];
        end
        if(when_MatrixEngine_l213_23) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[23];
        end
        if(when_MatrixEngine_l213_24) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[24];
        end
        if(when_MatrixEngine_l213_25) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[25];
        end
        if(when_MatrixEngine_l213_26) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[26];
        end
        if(when_MatrixEngine_l213_27) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[27];
        end
        if(when_MatrixEngine_l213_28) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[28];
        end
        if(when_MatrixEngine_l213_29) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[29];
        end
        if(when_MatrixEngine_l213_30) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[30];
        end
        if(when_MatrixEngine_l213_31) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[31];
        end
        if(when_MatrixEngine_l213_32) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[32];
        end
        if(when_MatrixEngine_l213_33) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[33];
        end
        if(when_MatrixEngine_l213_34) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[34];
        end
        if(when_MatrixEngine_l213_35) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[35];
        end
        if(when_MatrixEngine_l213_36) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[36];
        end
        if(when_MatrixEngine_l213_37) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[37];
        end
        if(when_MatrixEngine_l213_38) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[38];
        end
        if(when_MatrixEngine_l213_39) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[39];
        end
        if(when_MatrixEngine_l213_40) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[40];
        end
        if(when_MatrixEngine_l213_41) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[41];
        end
        if(when_MatrixEngine_l213_42) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[42];
        end
        if(when_MatrixEngine_l213_43) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[43];
        end
        if(when_MatrixEngine_l213_44) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[44];
        end
        if(when_MatrixEngine_l213_45) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[45];
        end
        if(when_MatrixEngine_l213_46) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[46];
        end
        if(when_MatrixEngine_l213_47) begin
          _zz_when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l89[47];
        end
      end
    end
  end

  always @(*) begin
    _zz_when_MatrixEngine_l233_2 = 1'b0;
    if(when_MatrixEngine_l201) begin
      if(!when_MatrixEngine_l202) begin
        if(when_MatrixEngine_l213_1) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[0 : 0]);
        end
        if(when_MatrixEngine_l213_2) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[1 : 0]);
        end
        if(when_MatrixEngine_l213_3) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[2 : 0]);
        end
        if(when_MatrixEngine_l213_4) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[3 : 0]);
        end
        if(when_MatrixEngine_l213_5) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[4 : 0]);
        end
        if(when_MatrixEngine_l213_6) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[5 : 0]);
        end
        if(when_MatrixEngine_l213_7) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[6 : 0]);
        end
        if(when_MatrixEngine_l213_8) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[7 : 0]);
        end
        if(when_MatrixEngine_l213_9) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[8 : 0]);
        end
        if(when_MatrixEngine_l213_10) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[9 : 0]);
        end
        if(when_MatrixEngine_l213_11) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[10 : 0]);
        end
        if(when_MatrixEngine_l213_12) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[11 : 0]);
        end
        if(when_MatrixEngine_l213_13) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[12 : 0]);
        end
        if(when_MatrixEngine_l213_14) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[13 : 0]);
        end
        if(when_MatrixEngine_l213_15) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[14 : 0]);
        end
        if(when_MatrixEngine_l213_16) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[15 : 0]);
        end
        if(when_MatrixEngine_l213_17) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[16 : 0]);
        end
        if(when_MatrixEngine_l213_18) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[17 : 0]);
        end
        if(when_MatrixEngine_l213_19) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[18 : 0]);
        end
        if(when_MatrixEngine_l213_20) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[19 : 0]);
        end
        if(when_MatrixEngine_l213_21) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[20 : 0]);
        end
        if(when_MatrixEngine_l213_22) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[21 : 0]);
        end
        if(when_MatrixEngine_l213_23) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[22 : 0]);
        end
        if(when_MatrixEngine_l213_24) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[23 : 0]);
        end
        if(when_MatrixEngine_l213_25) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[24 : 0]);
        end
        if(when_MatrixEngine_l213_26) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[25 : 0]);
        end
        if(when_MatrixEngine_l213_27) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[26 : 0]);
        end
        if(when_MatrixEngine_l213_28) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[27 : 0]);
        end
        if(when_MatrixEngine_l213_29) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[28 : 0]);
        end
        if(when_MatrixEngine_l213_30) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[29 : 0]);
        end
        if(when_MatrixEngine_l213_31) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[30 : 0]);
        end
        if(when_MatrixEngine_l213_32) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[31 : 0]);
        end
        if(when_MatrixEngine_l213_33) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[32 : 0]);
        end
        if(when_MatrixEngine_l213_34) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[33 : 0]);
        end
        if(when_MatrixEngine_l213_35) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[34 : 0]);
        end
        if(when_MatrixEngine_l213_36) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[35 : 0]);
        end
        if(when_MatrixEngine_l213_37) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[36 : 0]);
        end
        if(when_MatrixEngine_l213_38) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[37 : 0]);
        end
        if(when_MatrixEngine_l213_39) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[38 : 0]);
        end
        if(when_MatrixEngine_l213_40) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[39 : 0]);
        end
        if(when_MatrixEngine_l213_41) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[40 : 0]);
        end
        if(when_MatrixEngine_l213_42) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[41 : 0]);
        end
        if(when_MatrixEngine_l213_43) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[42 : 0]);
        end
        if(when_MatrixEngine_l213_44) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[43 : 0]);
        end
        if(when_MatrixEngine_l213_45) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[44 : 0]);
        end
        if(when_MatrixEngine_l213_46) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[45 : 0]);
        end
        if(when_MatrixEngine_l213_47) begin
          _zz_when_MatrixEngine_l233_2 = (|_zz_when_MatrixEngine_l89[46 : 0]);
        end
      end
    end
  end

  assign when_MatrixEngine_l201 = (_zz_when_MatrixEngine_l89 != 72'h0);
  assign when_MatrixEngine_l202 = (_zz_when_MatrixEngine_l184 <= 7'h17);
  assign when_MatrixEngine_l204 = (_zz_when_MatrixEngine_l204 == 5'h0);
  assign when_MatrixEngine_l204_1 = (_zz_when_MatrixEngine_l204 == 5'h01);
  assign when_MatrixEngine_l204_2 = (_zz_when_MatrixEngine_l204 == 5'h02);
  assign when_MatrixEngine_l204_3 = (_zz_when_MatrixEngine_l204 == 5'h03);
  assign when_MatrixEngine_l204_4 = (_zz_when_MatrixEngine_l204 == 5'h04);
  assign when_MatrixEngine_l204_5 = (_zz_when_MatrixEngine_l204 == 5'h05);
  assign when_MatrixEngine_l204_6 = (_zz_when_MatrixEngine_l204 == 5'h06);
  assign when_MatrixEngine_l204_7 = (_zz_when_MatrixEngine_l204 == 5'h07);
  assign when_MatrixEngine_l204_8 = (_zz_when_MatrixEngine_l204 == 5'h08);
  assign when_MatrixEngine_l204_9 = (_zz_when_MatrixEngine_l204 == 5'h09);
  assign when_MatrixEngine_l204_10 = (_zz_when_MatrixEngine_l204 == 5'h0a);
  assign when_MatrixEngine_l204_11 = (_zz_when_MatrixEngine_l204 == 5'h0b);
  assign when_MatrixEngine_l204_12 = (_zz_when_MatrixEngine_l204 == 5'h0c);
  assign when_MatrixEngine_l204_13 = (_zz_when_MatrixEngine_l204 == 5'h0d);
  assign when_MatrixEngine_l204_14 = (_zz_when_MatrixEngine_l204 == 5'h0e);
  assign when_MatrixEngine_l204_15 = (_zz_when_MatrixEngine_l204 == 5'h0f);
  assign when_MatrixEngine_l204_16 = (_zz_when_MatrixEngine_l204 == 5'h10);
  assign when_MatrixEngine_l204_17 = (_zz_when_MatrixEngine_l204 == 5'h11);
  assign when_MatrixEngine_l204_18 = (_zz_when_MatrixEngine_l204 == 5'h12);
  assign when_MatrixEngine_l204_19 = (_zz_when_MatrixEngine_l204 == 5'h13);
  assign when_MatrixEngine_l204_20 = (_zz_when_MatrixEngine_l204 == 5'h14);
  assign when_MatrixEngine_l204_21 = (_zz_when_MatrixEngine_l204 == 5'h15);
  assign when_MatrixEngine_l204_22 = (_zz_when_MatrixEngine_l204 == 5'h16);
  assign when_MatrixEngine_l204_23 = (_zz_when_MatrixEngine_l204 == 5'h17);
  assign when_MatrixEngine_l209 = (_zz_when_MatrixEngine_l209 == 6'h0);
  assign when_MatrixEngine_l213 = (_zz_when_MatrixEngine_l209 == 6'h01);
  assign when_MatrixEngine_l213_1 = (_zz_when_MatrixEngine_l209 == 6'h02);
  assign when_MatrixEngine_l213_2 = (_zz_when_MatrixEngine_l209 == 6'h03);
  assign when_MatrixEngine_l213_3 = (_zz_when_MatrixEngine_l209 == 6'h04);
  assign when_MatrixEngine_l213_4 = (_zz_when_MatrixEngine_l209 == 6'h05);
  assign when_MatrixEngine_l213_5 = (_zz_when_MatrixEngine_l209 == 6'h06);
  assign when_MatrixEngine_l213_6 = (_zz_when_MatrixEngine_l209 == 6'h07);
  assign when_MatrixEngine_l213_7 = (_zz_when_MatrixEngine_l209 == 6'h08);
  assign when_MatrixEngine_l213_8 = (_zz_when_MatrixEngine_l209 == 6'h09);
  assign when_MatrixEngine_l213_9 = (_zz_when_MatrixEngine_l209 == 6'h0a);
  assign when_MatrixEngine_l213_10 = (_zz_when_MatrixEngine_l209 == 6'h0b);
  assign when_MatrixEngine_l213_11 = (_zz_when_MatrixEngine_l209 == 6'h0c);
  assign when_MatrixEngine_l213_12 = (_zz_when_MatrixEngine_l209 == 6'h0d);
  assign when_MatrixEngine_l213_13 = (_zz_when_MatrixEngine_l209 == 6'h0e);
  assign when_MatrixEngine_l213_14 = (_zz_when_MatrixEngine_l209 == 6'h0f);
  assign when_MatrixEngine_l213_15 = (_zz_when_MatrixEngine_l209 == 6'h10);
  assign when_MatrixEngine_l213_16 = (_zz_when_MatrixEngine_l209 == 6'h11);
  assign when_MatrixEngine_l213_17 = (_zz_when_MatrixEngine_l209 == 6'h12);
  assign when_MatrixEngine_l213_18 = (_zz_when_MatrixEngine_l209 == 6'h13);
  assign when_MatrixEngine_l213_19 = (_zz_when_MatrixEngine_l209 == 6'h14);
  assign when_MatrixEngine_l213_20 = (_zz_when_MatrixEngine_l209 == 6'h15);
  assign when_MatrixEngine_l213_21 = (_zz_when_MatrixEngine_l209 == 6'h16);
  assign when_MatrixEngine_l213_22 = (_zz_when_MatrixEngine_l209 == 6'h17);
  assign when_MatrixEngine_l213_23 = (_zz_when_MatrixEngine_l209 == 6'h18);
  assign when_MatrixEngine_l213_24 = (_zz_when_MatrixEngine_l209 == 6'h19);
  assign when_MatrixEngine_l213_25 = (_zz_when_MatrixEngine_l209 == 6'h1a);
  assign when_MatrixEngine_l213_26 = (_zz_when_MatrixEngine_l209 == 6'h1b);
  assign when_MatrixEngine_l213_27 = (_zz_when_MatrixEngine_l209 == 6'h1c);
  assign when_MatrixEngine_l213_28 = (_zz_when_MatrixEngine_l209 == 6'h1d);
  assign when_MatrixEngine_l213_29 = (_zz_when_MatrixEngine_l209 == 6'h1e);
  assign when_MatrixEngine_l213_30 = (_zz_when_MatrixEngine_l209 == 6'h1f);
  assign when_MatrixEngine_l213_31 = (_zz_when_MatrixEngine_l209 == 6'h20);
  assign when_MatrixEngine_l213_32 = (_zz_when_MatrixEngine_l209 == 6'h21);
  assign when_MatrixEngine_l213_33 = (_zz_when_MatrixEngine_l209 == 6'h22);
  assign when_MatrixEngine_l213_34 = (_zz_when_MatrixEngine_l209 == 6'h23);
  assign when_MatrixEngine_l213_35 = (_zz_when_MatrixEngine_l209 == 6'h24);
  assign when_MatrixEngine_l213_36 = (_zz_when_MatrixEngine_l209 == 6'h25);
  assign when_MatrixEngine_l213_37 = (_zz_when_MatrixEngine_l209 == 6'h26);
  assign when_MatrixEngine_l213_38 = (_zz_when_MatrixEngine_l209 == 6'h27);
  assign when_MatrixEngine_l213_39 = (_zz_when_MatrixEngine_l209 == 6'h28);
  assign when_MatrixEngine_l213_40 = (_zz_when_MatrixEngine_l209 == 6'h29);
  assign when_MatrixEngine_l213_41 = (_zz_when_MatrixEngine_l209 == 6'h2a);
  assign when_MatrixEngine_l213_42 = (_zz_when_MatrixEngine_l209 == 6'h2b);
  assign when_MatrixEngine_l213_43 = (_zz_when_MatrixEngine_l209 == 6'h2c);
  assign when_MatrixEngine_l213_44 = (_zz_when_MatrixEngine_l209 == 6'h2d);
  assign when_MatrixEngine_l213_45 = (_zz_when_MatrixEngine_l209 == 6'h2e);
  assign when_MatrixEngine_l213_46 = (_zz_when_MatrixEngine_l209 == 6'h2f);
  assign when_MatrixEngine_l213_47 = (_zz_when_MatrixEngine_l209 == 6'h30);
  assign _zz_when_MatrixEngine_l233_3 = (_zz__zz_when_MatrixEngine_l233_3_1 + _zz__zz_when_MatrixEngine_l233_3_2);
  assign _zz_when_MatrixEngine_l290_1 = (_zz__zz_when_MatrixEngine_l290_1 + 8'h5f);
  always @(*) begin
    _zz_when_MatrixEngine_l290_2 = _zz_when_MatrixEngine_l290_1;
    if(when_MatrixEngine_l233) begin
      _zz_when_MatrixEngine_l290_2 = (_zz_when_MatrixEngine_l290_1 + 8'h01);
    end
  end

  always @(*) begin
    _zz_when_MatrixEngine_l290_3 = _zz_when_MatrixEngine_l233_3[23 : 0];
    if(when_MatrixEngine_l233) begin
      _zz_when_MatrixEngine_l290_3 = (_zz_when_MatrixEngine_l233_3 >>> 1'd1);
    end
  end

  assign when_MatrixEngine_l233 = _zz_when_MatrixEngine_l233_3[24];
  assign when_MatrixEngine_l290 = _zz_when_MatrixEngine_l290[31];
  assign _zz_when_MatrixEngine_l251 = _zz_when_MatrixEngine_l290[30 : 23];
  assign _zz_roundedFpAcc = _zz_when_MatrixEngine_l290[22 : 0];
  always @(*) begin
    _zz_roundedFpAcc_1 = 72'h0;
    if(!when_MatrixEngine_l251) begin
      if(!when_MatrixEngine_l253) begin
        if(when_MatrixEngine_l257) begin
          if(when_MatrixEngine_l262) begin
            _zz_roundedFpAcc_1 = {48'd0, _zz_roundedFpAcc_2};
          end
          if(when_MatrixEngine_l262_1) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1[71:0];
          end
          if(when_MatrixEngine_l262_2) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_2[71:0];
          end
          if(when_MatrixEngine_l262_3) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_4[71:0];
          end
          if(when_MatrixEngine_l262_4) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_6[71:0];
          end
          if(when_MatrixEngine_l262_5) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_8[71:0];
          end
          if(when_MatrixEngine_l262_6) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_10[71:0];
          end
          if(when_MatrixEngine_l262_7) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_12[71:0];
          end
          if(when_MatrixEngine_l262_8) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_14[71:0];
          end
          if(when_MatrixEngine_l262_9) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_16[71:0];
          end
          if(when_MatrixEngine_l262_10) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_18[71:0];
          end
          if(when_MatrixEngine_l262_11) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_20[71:0];
          end
          if(when_MatrixEngine_l262_12) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_22[71:0];
          end
          if(when_MatrixEngine_l262_13) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_24[71:0];
          end
          if(when_MatrixEngine_l262_14) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_26[71:0];
          end
          if(when_MatrixEngine_l262_15) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_28[71:0];
          end
          if(when_MatrixEngine_l262_16) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_30[71:0];
          end
          if(when_MatrixEngine_l262_17) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_32[71:0];
          end
          if(when_MatrixEngine_l262_18) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_34[71:0];
          end
          if(when_MatrixEngine_l262_19) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_36[71:0];
          end
          if(when_MatrixEngine_l262_20) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_38[71:0];
          end
          if(when_MatrixEngine_l262_21) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_40[71:0];
          end
          if(when_MatrixEngine_l262_22) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_42[71:0];
          end
          if(when_MatrixEngine_l262_23) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_44[71:0];
          end
          if(when_MatrixEngine_l262_24) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_46[71:0];
          end
          if(when_MatrixEngine_l262_25) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_48[71:0];
          end
          if(when_MatrixEngine_l262_26) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_50[71:0];
          end
          if(when_MatrixEngine_l262_27) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_52[71:0];
          end
          if(when_MatrixEngine_l262_28) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_54[71:0];
          end
          if(when_MatrixEngine_l262_29) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_56[71:0];
          end
          if(when_MatrixEngine_l262_30) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_58[71:0];
          end
          if(when_MatrixEngine_l262_31) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_60[71:0];
          end
          if(when_MatrixEngine_l262_32) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_62[71:0];
          end
          if(when_MatrixEngine_l262_33) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_64[71:0];
          end
          if(when_MatrixEngine_l262_34) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_66[71:0];
          end
          if(when_MatrixEngine_l262_35) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_68[71:0];
          end
          if(when_MatrixEngine_l262_36) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_70[71:0];
          end
          if(when_MatrixEngine_l262_37) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_72[71:0];
          end
          if(when_MatrixEngine_l262_38) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_74[71:0];
          end
          if(when_MatrixEngine_l262_39) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_76[71:0];
          end
          if(when_MatrixEngine_l262_40) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_78[71:0];
          end
          if(when_MatrixEngine_l262_41) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_80[71:0];
          end
          if(when_MatrixEngine_l262_42) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_82[71:0];
          end
          if(when_MatrixEngine_l262_43) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_84[71:0];
          end
          if(when_MatrixEngine_l262_44) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_86[71:0];
          end
          if(when_MatrixEngine_l262_45) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_88[71:0];
          end
          if(when_MatrixEngine_l262_46) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_90[71:0];
          end
          if(when_MatrixEngine_l262_47) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_92[71:0];
          end
          if(when_MatrixEngine_l262_48) begin
            _zz_roundedFpAcc_1 = _zz__zz_roundedFpAcc_1_94[71:0];
          end
        end else begin
          if(when_MatrixEngine_l268) begin
            _zz_roundedFpAcc_1 = 72'h0;
          end else begin
            if(when_MatrixEngine_l272) begin
              _zz_roundedFpAcc_1 = {48'd0, _zz_roundedFpAcc_2};
            end
            if(when_MatrixEngine_l276) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_3 + _zz__zz_roundedFpAcc_1_96);
            end
            if(when_MatrixEngine_l276_1) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_4 + _zz__zz_roundedFpAcc_1_98);
            end
            if(when_MatrixEngine_l276_2) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_5 + _zz__zz_roundedFpAcc_1_100);
            end
            if(when_MatrixEngine_l276_3) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_6 + _zz__zz_roundedFpAcc_1_102);
            end
            if(when_MatrixEngine_l276_4) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_7 + _zz__zz_roundedFpAcc_1_104);
            end
            if(when_MatrixEngine_l276_5) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_8 + _zz__zz_roundedFpAcc_1_106);
            end
            if(when_MatrixEngine_l276_6) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_9 + _zz__zz_roundedFpAcc_1_108);
            end
            if(when_MatrixEngine_l276_7) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_10 + _zz__zz_roundedFpAcc_1_110);
            end
            if(when_MatrixEngine_l276_8) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_11 + _zz__zz_roundedFpAcc_1_112);
            end
            if(when_MatrixEngine_l276_9) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_12 + _zz__zz_roundedFpAcc_1_114);
            end
            if(when_MatrixEngine_l276_10) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_13 + _zz__zz_roundedFpAcc_1_116);
            end
            if(when_MatrixEngine_l276_11) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_14 + _zz__zz_roundedFpAcc_1_118);
            end
            if(when_MatrixEngine_l276_12) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_15 + _zz__zz_roundedFpAcc_1_120);
            end
            if(when_MatrixEngine_l276_13) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_16 + _zz__zz_roundedFpAcc_1_122);
            end
            if(when_MatrixEngine_l276_14) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_17 + _zz__zz_roundedFpAcc_1_124);
            end
            if(when_MatrixEngine_l276_15) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_18 + _zz__zz_roundedFpAcc_1_126);
            end
            if(when_MatrixEngine_l276_16) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_19 + _zz__zz_roundedFpAcc_1_128);
            end
            if(when_MatrixEngine_l276_17) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_20 + _zz__zz_roundedFpAcc_1_130);
            end
            if(when_MatrixEngine_l276_18) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_21 + _zz__zz_roundedFpAcc_1_132);
            end
            if(when_MatrixEngine_l276_19) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_22 + _zz__zz_roundedFpAcc_1_134);
            end
            if(when_MatrixEngine_l276_20) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_23 + _zz__zz_roundedFpAcc_1_136);
            end
            if(when_MatrixEngine_l276_21) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_24 + _zz__zz_roundedFpAcc_1_138);
            end
            if(when_MatrixEngine_l276_22) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_25 + _zz__zz_roundedFpAcc_1_140);
            end
            if(when_MatrixEngine_l276_23) begin
              _zz_roundedFpAcc_1 = (_zz_roundedFpAcc_26 + _zz__zz_roundedFpAcc_1_142);
            end
          end
        end
      end
    end
  end

  assign when_MatrixEngine_l251 = (_zz_when_MatrixEngine_l251 == 8'h0);
  assign _zz_roundedFpAcc_2 = {1'b1,_zz_roundedFpAcc};
  assign when_MatrixEngine_l257 = (8'h76 <= _zz_when_MatrixEngine_l251);
  assign _zz_when_MatrixEngine_l262 = _zz__zz_when_MatrixEngine_l262[5:0];
  assign when_MatrixEngine_l262 = (_zz_when_MatrixEngine_l262 == 6'h0);
  assign when_MatrixEngine_l262_1 = (_zz_when_MatrixEngine_l262 == 6'h01);
  assign when_MatrixEngine_l262_2 = (_zz_when_MatrixEngine_l262 == 6'h02);
  assign when_MatrixEngine_l262_3 = (_zz_when_MatrixEngine_l262 == 6'h03);
  assign when_MatrixEngine_l262_4 = (_zz_when_MatrixEngine_l262 == 6'h04);
  assign when_MatrixEngine_l262_5 = (_zz_when_MatrixEngine_l262 == 6'h05);
  assign when_MatrixEngine_l262_6 = (_zz_when_MatrixEngine_l262 == 6'h06);
  assign when_MatrixEngine_l262_7 = (_zz_when_MatrixEngine_l262 == 6'h07);
  assign when_MatrixEngine_l262_8 = (_zz_when_MatrixEngine_l262 == 6'h08);
  assign when_MatrixEngine_l262_9 = (_zz_when_MatrixEngine_l262 == 6'h09);
  assign when_MatrixEngine_l262_10 = (_zz_when_MatrixEngine_l262 == 6'h0a);
  assign when_MatrixEngine_l262_11 = (_zz_when_MatrixEngine_l262 == 6'h0b);
  assign when_MatrixEngine_l262_12 = (_zz_when_MatrixEngine_l262 == 6'h0c);
  assign when_MatrixEngine_l262_13 = (_zz_when_MatrixEngine_l262 == 6'h0d);
  assign when_MatrixEngine_l262_14 = (_zz_when_MatrixEngine_l262 == 6'h0e);
  assign when_MatrixEngine_l262_15 = (_zz_when_MatrixEngine_l262 == 6'h0f);
  assign when_MatrixEngine_l262_16 = (_zz_when_MatrixEngine_l262 == 6'h10);
  assign when_MatrixEngine_l262_17 = (_zz_when_MatrixEngine_l262 == 6'h11);
  assign when_MatrixEngine_l262_18 = (_zz_when_MatrixEngine_l262 == 6'h12);
  assign when_MatrixEngine_l262_19 = (_zz_when_MatrixEngine_l262 == 6'h13);
  assign when_MatrixEngine_l262_20 = (_zz_when_MatrixEngine_l262 == 6'h14);
  assign when_MatrixEngine_l262_21 = (_zz_when_MatrixEngine_l262 == 6'h15);
  assign when_MatrixEngine_l262_22 = (_zz_when_MatrixEngine_l262 == 6'h16);
  assign when_MatrixEngine_l262_23 = (_zz_when_MatrixEngine_l262 == 6'h17);
  assign when_MatrixEngine_l262_24 = (_zz_when_MatrixEngine_l262 == 6'h18);
  assign when_MatrixEngine_l262_25 = (_zz_when_MatrixEngine_l262 == 6'h19);
  assign when_MatrixEngine_l262_26 = (_zz_when_MatrixEngine_l262 == 6'h1a);
  assign when_MatrixEngine_l262_27 = (_zz_when_MatrixEngine_l262 == 6'h1b);
  assign when_MatrixEngine_l262_28 = (_zz_when_MatrixEngine_l262 == 6'h1c);
  assign when_MatrixEngine_l262_29 = (_zz_when_MatrixEngine_l262 == 6'h1d);
  assign when_MatrixEngine_l262_30 = (_zz_when_MatrixEngine_l262 == 6'h1e);
  assign when_MatrixEngine_l262_31 = (_zz_when_MatrixEngine_l262 == 6'h1f);
  assign when_MatrixEngine_l262_32 = (_zz_when_MatrixEngine_l262 == 6'h20);
  assign when_MatrixEngine_l262_33 = (_zz_when_MatrixEngine_l262 == 6'h21);
  assign when_MatrixEngine_l262_34 = (_zz_when_MatrixEngine_l262 == 6'h22);
  assign when_MatrixEngine_l262_35 = (_zz_when_MatrixEngine_l262 == 6'h23);
  assign when_MatrixEngine_l262_36 = (_zz_when_MatrixEngine_l262 == 6'h24);
  assign when_MatrixEngine_l262_37 = (_zz_when_MatrixEngine_l262 == 6'h25);
  assign when_MatrixEngine_l262_38 = (_zz_when_MatrixEngine_l262 == 6'h26);
  assign when_MatrixEngine_l262_39 = (_zz_when_MatrixEngine_l262 == 6'h27);
  assign when_MatrixEngine_l262_40 = (_zz_when_MatrixEngine_l262 == 6'h28);
  assign when_MatrixEngine_l262_41 = (_zz_when_MatrixEngine_l262 == 6'h29);
  assign when_MatrixEngine_l262_42 = (_zz_when_MatrixEngine_l262 == 6'h2a);
  assign when_MatrixEngine_l262_43 = (_zz_when_MatrixEngine_l262 == 6'h2b);
  assign when_MatrixEngine_l262_44 = (_zz_when_MatrixEngine_l262 == 6'h2c);
  assign when_MatrixEngine_l262_45 = (_zz_when_MatrixEngine_l262 == 6'h2d);
  assign when_MatrixEngine_l262_46 = (_zz_when_MatrixEngine_l262 == 6'h2e);
  assign when_MatrixEngine_l262_47 = (_zz_when_MatrixEngine_l262 == 6'h2f);
  assign when_MatrixEngine_l262_48 = (_zz_when_MatrixEngine_l262 == 6'h30);
  assign _zz_when_MatrixEngine_l268 = (8'h76 - _zz_when_MatrixEngine_l251);
  assign when_MatrixEngine_l268 = (8'h18 < _zz_when_MatrixEngine_l268);
  assign _zz_when_MatrixEngine_l272 = _zz_when_MatrixEngine_l268[4:0];
  assign when_MatrixEngine_l272 = (_zz_when_MatrixEngine_l272 == 5'h0);
  assign when_MatrixEngine_l276 = (_zz_when_MatrixEngine_l272 == 5'h01);
  assign _zz_roundedFpAcc_3 = {49'd0, _zz__zz_roundedFpAcc_3};
  assign when_MatrixEngine_l276_1 = (_zz_when_MatrixEngine_l272 == 5'h02);
  assign _zz_roundedFpAcc_4 = {50'd0, _zz__zz_roundedFpAcc_4};
  assign when_MatrixEngine_l276_2 = (_zz_when_MatrixEngine_l272 == 5'h03);
  assign _zz_roundedFpAcc_5 = {51'd0, _zz__zz_roundedFpAcc_5};
  assign when_MatrixEngine_l276_3 = (_zz_when_MatrixEngine_l272 == 5'h04);
  assign _zz_roundedFpAcc_6 = {52'd0, _zz__zz_roundedFpAcc_6};
  assign when_MatrixEngine_l276_4 = (_zz_when_MatrixEngine_l272 == 5'h05);
  assign _zz_roundedFpAcc_7 = {53'd0, _zz__zz_roundedFpAcc_7};
  assign when_MatrixEngine_l276_5 = (_zz_when_MatrixEngine_l272 == 5'h06);
  assign _zz_roundedFpAcc_8 = {54'd0, _zz__zz_roundedFpAcc_8};
  assign when_MatrixEngine_l276_6 = (_zz_when_MatrixEngine_l272 == 5'h07);
  assign _zz_roundedFpAcc_9 = {55'd0, _zz__zz_roundedFpAcc_9};
  assign when_MatrixEngine_l276_7 = (_zz_when_MatrixEngine_l272 == 5'h08);
  assign _zz_roundedFpAcc_10 = {56'd0, _zz__zz_roundedFpAcc_10};
  assign when_MatrixEngine_l276_8 = (_zz_when_MatrixEngine_l272 == 5'h09);
  assign _zz_roundedFpAcc_11 = {57'd0, _zz__zz_roundedFpAcc_11};
  assign when_MatrixEngine_l276_9 = (_zz_when_MatrixEngine_l272 == 5'h0a);
  assign _zz_roundedFpAcc_12 = {58'd0, _zz__zz_roundedFpAcc_12};
  assign when_MatrixEngine_l276_10 = (_zz_when_MatrixEngine_l272 == 5'h0b);
  assign _zz_roundedFpAcc_13 = {59'd0, _zz__zz_roundedFpAcc_13};
  assign when_MatrixEngine_l276_11 = (_zz_when_MatrixEngine_l272 == 5'h0c);
  assign _zz_roundedFpAcc_14 = {60'd0, _zz__zz_roundedFpAcc_14};
  assign when_MatrixEngine_l276_12 = (_zz_when_MatrixEngine_l272 == 5'h0d);
  assign _zz_roundedFpAcc_15 = {61'd0, _zz__zz_roundedFpAcc_15};
  assign when_MatrixEngine_l276_13 = (_zz_when_MatrixEngine_l272 == 5'h0e);
  assign _zz_roundedFpAcc_16 = {62'd0, _zz__zz_roundedFpAcc_16};
  assign when_MatrixEngine_l276_14 = (_zz_when_MatrixEngine_l272 == 5'h0f);
  assign _zz_roundedFpAcc_17 = {63'd0, _zz__zz_roundedFpAcc_17};
  assign when_MatrixEngine_l276_15 = (_zz_when_MatrixEngine_l272 == 5'h10);
  assign _zz_roundedFpAcc_18 = {64'd0, _zz__zz_roundedFpAcc_18};
  assign when_MatrixEngine_l276_16 = (_zz_when_MatrixEngine_l272 == 5'h11);
  assign _zz_roundedFpAcc_19 = {65'd0, _zz__zz_roundedFpAcc_19};
  assign when_MatrixEngine_l276_17 = (_zz_when_MatrixEngine_l272 == 5'h12);
  assign _zz_roundedFpAcc_20 = {66'd0, _zz__zz_roundedFpAcc_20};
  assign when_MatrixEngine_l276_18 = (_zz_when_MatrixEngine_l272 == 5'h13);
  assign _zz_roundedFpAcc_21 = {67'd0, _zz__zz_roundedFpAcc_21};
  assign when_MatrixEngine_l276_19 = (_zz_when_MatrixEngine_l272 == 5'h14);
  assign _zz_roundedFpAcc_22 = {68'd0, _zz__zz_roundedFpAcc_22};
  assign when_MatrixEngine_l276_20 = (_zz_when_MatrixEngine_l272 == 5'h15);
  assign _zz_roundedFpAcc_23 = {69'd0, _zz__zz_roundedFpAcc_23};
  assign when_MatrixEngine_l276_21 = (_zz_when_MatrixEngine_l272 == 5'h16);
  assign _zz_roundedFpAcc_24 = {70'd0, _zz__zz_roundedFpAcc_24};
  assign when_MatrixEngine_l276_22 = (_zz_when_MatrixEngine_l272 == 5'h17);
  assign _zz_roundedFpAcc_25 = {71'd0, _zz__zz_roundedFpAcc_25};
  assign when_MatrixEngine_l276_23 = (_zz_when_MatrixEngine_l272 == 5'h18);
  assign _zz_roundedFpAcc_26 = 72'h0;
  assign when_MatrixEngine_l253 = (_zz_when_MatrixEngine_l251 == 8'hff);
  always @(*) begin
    roundedFpAcc = _zz_roundedFpAcc_1;
    if(when_MatrixEngine_l290) begin
      roundedFpAcc = (- _zz_roundedFpAcc_27);
    end
  end

  assign when_MatrixEngine_l364 = (state == MatrixState_IDLE);
  assign when_MatrixEngine_l379 = (((io_slots_0_opcode == 5'h08) || (io_slots_0_opcode == 5'h0b)) || (io_slots_0_opcode == 5'h0d));
  assign when_MatrixEngine_l382 = (((io_slots_0_opcode == 5'h0a) || (io_slots_0_opcode == 5'h0b)) || ((io_slots_0_opcode == 5'h0c) || (io_slots_0_opcode == 5'h0d)));
  assign when_MatrixEngine_l395 = (slotTileElems == 7'h0);
  assign when_MatrixEngine_l411 = (debugCounter == 11'h001);
  assign when_MatrixEngine_l290_1 = io_matrixAccumRdData[31];
  assign _zz_when_MatrixEngine_l251_1 = io_matrixAccumRdData[30 : 23];
  assign _zz_fpAccReg = io_matrixAccumRdData[22 : 0];
  always @(*) begin
    _zz_fpAccReg_1 = 72'h0;
    if(!when_MatrixEngine_l251_1) begin
      if(!when_MatrixEngine_l253_1) begin
        if(when_MatrixEngine_l257_1) begin
          if(when_MatrixEngine_l262_49) begin
            _zz_fpAccReg_1 = {48'd0, _zz_fpAccReg_2};
          end
          if(when_MatrixEngine_l262_50) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1[71:0];
          end
          if(when_MatrixEngine_l262_51) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_2[71:0];
          end
          if(when_MatrixEngine_l262_52) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_4[71:0];
          end
          if(when_MatrixEngine_l262_53) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_6[71:0];
          end
          if(when_MatrixEngine_l262_54) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_8[71:0];
          end
          if(when_MatrixEngine_l262_55) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_10[71:0];
          end
          if(when_MatrixEngine_l262_56) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_12[71:0];
          end
          if(when_MatrixEngine_l262_57) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_14[71:0];
          end
          if(when_MatrixEngine_l262_58) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_16[71:0];
          end
          if(when_MatrixEngine_l262_59) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_18[71:0];
          end
          if(when_MatrixEngine_l262_60) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_20[71:0];
          end
          if(when_MatrixEngine_l262_61) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_22[71:0];
          end
          if(when_MatrixEngine_l262_62) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_24[71:0];
          end
          if(when_MatrixEngine_l262_63) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_26[71:0];
          end
          if(when_MatrixEngine_l262_64) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_28[71:0];
          end
          if(when_MatrixEngine_l262_65) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_30[71:0];
          end
          if(when_MatrixEngine_l262_66) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_32[71:0];
          end
          if(when_MatrixEngine_l262_67) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_34[71:0];
          end
          if(when_MatrixEngine_l262_68) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_36[71:0];
          end
          if(when_MatrixEngine_l262_69) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_38[71:0];
          end
          if(when_MatrixEngine_l262_70) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_40[71:0];
          end
          if(when_MatrixEngine_l262_71) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_42[71:0];
          end
          if(when_MatrixEngine_l262_72) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_44[71:0];
          end
          if(when_MatrixEngine_l262_73) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_46[71:0];
          end
          if(when_MatrixEngine_l262_74) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_48[71:0];
          end
          if(when_MatrixEngine_l262_75) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_50[71:0];
          end
          if(when_MatrixEngine_l262_76) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_52[71:0];
          end
          if(when_MatrixEngine_l262_77) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_54[71:0];
          end
          if(when_MatrixEngine_l262_78) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_56[71:0];
          end
          if(when_MatrixEngine_l262_79) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_58[71:0];
          end
          if(when_MatrixEngine_l262_80) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_60[71:0];
          end
          if(when_MatrixEngine_l262_81) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_62[71:0];
          end
          if(when_MatrixEngine_l262_82) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_64[71:0];
          end
          if(when_MatrixEngine_l262_83) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_66[71:0];
          end
          if(when_MatrixEngine_l262_84) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_68[71:0];
          end
          if(when_MatrixEngine_l262_85) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_70[71:0];
          end
          if(when_MatrixEngine_l262_86) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_72[71:0];
          end
          if(when_MatrixEngine_l262_87) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_74[71:0];
          end
          if(when_MatrixEngine_l262_88) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_76[71:0];
          end
          if(when_MatrixEngine_l262_89) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_78[71:0];
          end
          if(when_MatrixEngine_l262_90) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_80[71:0];
          end
          if(when_MatrixEngine_l262_91) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_82[71:0];
          end
          if(when_MatrixEngine_l262_92) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_84[71:0];
          end
          if(when_MatrixEngine_l262_93) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_86[71:0];
          end
          if(when_MatrixEngine_l262_94) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_88[71:0];
          end
          if(when_MatrixEngine_l262_95) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_90[71:0];
          end
          if(when_MatrixEngine_l262_96) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_92[71:0];
          end
          if(when_MatrixEngine_l262_97) begin
            _zz_fpAccReg_1 = _zz__zz_fpAccReg_1_94[71:0];
          end
        end else begin
          if(when_MatrixEngine_l268_1) begin
            _zz_fpAccReg_1 = 72'h0;
          end else begin
            if(when_MatrixEngine_l272_1) begin
              _zz_fpAccReg_1 = {48'd0, _zz_fpAccReg_2};
            end
            if(when_MatrixEngine_l276_24) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_3 + _zz__zz_fpAccReg_1_96);
            end
            if(when_MatrixEngine_l276_25) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_4 + _zz__zz_fpAccReg_1_98);
            end
            if(when_MatrixEngine_l276_26) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_5 + _zz__zz_fpAccReg_1_100);
            end
            if(when_MatrixEngine_l276_27) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_6 + _zz__zz_fpAccReg_1_102);
            end
            if(when_MatrixEngine_l276_28) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_7 + _zz__zz_fpAccReg_1_104);
            end
            if(when_MatrixEngine_l276_29) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_8 + _zz__zz_fpAccReg_1_106);
            end
            if(when_MatrixEngine_l276_30) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_9 + _zz__zz_fpAccReg_1_108);
            end
            if(when_MatrixEngine_l276_31) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_10 + _zz__zz_fpAccReg_1_110);
            end
            if(when_MatrixEngine_l276_32) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_11 + _zz__zz_fpAccReg_1_112);
            end
            if(when_MatrixEngine_l276_33) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_12 + _zz__zz_fpAccReg_1_114);
            end
            if(when_MatrixEngine_l276_34) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_13 + _zz__zz_fpAccReg_1_116);
            end
            if(when_MatrixEngine_l276_35) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_14 + _zz__zz_fpAccReg_1_118);
            end
            if(when_MatrixEngine_l276_36) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_15 + _zz__zz_fpAccReg_1_120);
            end
            if(when_MatrixEngine_l276_37) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_16 + _zz__zz_fpAccReg_1_122);
            end
            if(when_MatrixEngine_l276_38) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_17 + _zz__zz_fpAccReg_1_124);
            end
            if(when_MatrixEngine_l276_39) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_18 + _zz__zz_fpAccReg_1_126);
            end
            if(when_MatrixEngine_l276_40) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_19 + _zz__zz_fpAccReg_1_128);
            end
            if(when_MatrixEngine_l276_41) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_20 + _zz__zz_fpAccReg_1_130);
            end
            if(when_MatrixEngine_l276_42) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_21 + _zz__zz_fpAccReg_1_132);
            end
            if(when_MatrixEngine_l276_43) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_22 + _zz__zz_fpAccReg_1_134);
            end
            if(when_MatrixEngine_l276_44) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_23 + _zz__zz_fpAccReg_1_136);
            end
            if(when_MatrixEngine_l276_45) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_24 + _zz__zz_fpAccReg_1_138);
            end
            if(when_MatrixEngine_l276_46) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_25 + _zz__zz_fpAccReg_1_140);
            end
            if(when_MatrixEngine_l276_47) begin
              _zz_fpAccReg_1 = (_zz_fpAccReg_26 + _zz__zz_fpAccReg_1_142);
            end
          end
        end
      end
    end
  end

  assign when_MatrixEngine_l251_1 = (_zz_when_MatrixEngine_l251_1 == 8'h0);
  assign _zz_fpAccReg_2 = {1'b1,_zz_fpAccReg};
  assign when_MatrixEngine_l257_1 = (8'h76 <= _zz_when_MatrixEngine_l251_1);
  assign _zz_when_MatrixEngine_l262_1 = _zz__zz_when_MatrixEngine_l262_1[5:0];
  assign when_MatrixEngine_l262_49 = (_zz_when_MatrixEngine_l262_1 == 6'h0);
  assign when_MatrixEngine_l262_50 = (_zz_when_MatrixEngine_l262_1 == 6'h01);
  assign when_MatrixEngine_l262_51 = (_zz_when_MatrixEngine_l262_1 == 6'h02);
  assign when_MatrixEngine_l262_52 = (_zz_when_MatrixEngine_l262_1 == 6'h03);
  assign when_MatrixEngine_l262_53 = (_zz_when_MatrixEngine_l262_1 == 6'h04);
  assign when_MatrixEngine_l262_54 = (_zz_when_MatrixEngine_l262_1 == 6'h05);
  assign when_MatrixEngine_l262_55 = (_zz_when_MatrixEngine_l262_1 == 6'h06);
  assign when_MatrixEngine_l262_56 = (_zz_when_MatrixEngine_l262_1 == 6'h07);
  assign when_MatrixEngine_l262_57 = (_zz_when_MatrixEngine_l262_1 == 6'h08);
  assign when_MatrixEngine_l262_58 = (_zz_when_MatrixEngine_l262_1 == 6'h09);
  assign when_MatrixEngine_l262_59 = (_zz_when_MatrixEngine_l262_1 == 6'h0a);
  assign when_MatrixEngine_l262_60 = (_zz_when_MatrixEngine_l262_1 == 6'h0b);
  assign when_MatrixEngine_l262_61 = (_zz_when_MatrixEngine_l262_1 == 6'h0c);
  assign when_MatrixEngine_l262_62 = (_zz_when_MatrixEngine_l262_1 == 6'h0d);
  assign when_MatrixEngine_l262_63 = (_zz_when_MatrixEngine_l262_1 == 6'h0e);
  assign when_MatrixEngine_l262_64 = (_zz_when_MatrixEngine_l262_1 == 6'h0f);
  assign when_MatrixEngine_l262_65 = (_zz_when_MatrixEngine_l262_1 == 6'h10);
  assign when_MatrixEngine_l262_66 = (_zz_when_MatrixEngine_l262_1 == 6'h11);
  assign when_MatrixEngine_l262_67 = (_zz_when_MatrixEngine_l262_1 == 6'h12);
  assign when_MatrixEngine_l262_68 = (_zz_when_MatrixEngine_l262_1 == 6'h13);
  assign when_MatrixEngine_l262_69 = (_zz_when_MatrixEngine_l262_1 == 6'h14);
  assign when_MatrixEngine_l262_70 = (_zz_when_MatrixEngine_l262_1 == 6'h15);
  assign when_MatrixEngine_l262_71 = (_zz_when_MatrixEngine_l262_1 == 6'h16);
  assign when_MatrixEngine_l262_72 = (_zz_when_MatrixEngine_l262_1 == 6'h17);
  assign when_MatrixEngine_l262_73 = (_zz_when_MatrixEngine_l262_1 == 6'h18);
  assign when_MatrixEngine_l262_74 = (_zz_when_MatrixEngine_l262_1 == 6'h19);
  assign when_MatrixEngine_l262_75 = (_zz_when_MatrixEngine_l262_1 == 6'h1a);
  assign when_MatrixEngine_l262_76 = (_zz_when_MatrixEngine_l262_1 == 6'h1b);
  assign when_MatrixEngine_l262_77 = (_zz_when_MatrixEngine_l262_1 == 6'h1c);
  assign when_MatrixEngine_l262_78 = (_zz_when_MatrixEngine_l262_1 == 6'h1d);
  assign when_MatrixEngine_l262_79 = (_zz_when_MatrixEngine_l262_1 == 6'h1e);
  assign when_MatrixEngine_l262_80 = (_zz_when_MatrixEngine_l262_1 == 6'h1f);
  assign when_MatrixEngine_l262_81 = (_zz_when_MatrixEngine_l262_1 == 6'h20);
  assign when_MatrixEngine_l262_82 = (_zz_when_MatrixEngine_l262_1 == 6'h21);
  assign when_MatrixEngine_l262_83 = (_zz_when_MatrixEngine_l262_1 == 6'h22);
  assign when_MatrixEngine_l262_84 = (_zz_when_MatrixEngine_l262_1 == 6'h23);
  assign when_MatrixEngine_l262_85 = (_zz_when_MatrixEngine_l262_1 == 6'h24);
  assign when_MatrixEngine_l262_86 = (_zz_when_MatrixEngine_l262_1 == 6'h25);
  assign when_MatrixEngine_l262_87 = (_zz_when_MatrixEngine_l262_1 == 6'h26);
  assign when_MatrixEngine_l262_88 = (_zz_when_MatrixEngine_l262_1 == 6'h27);
  assign when_MatrixEngine_l262_89 = (_zz_when_MatrixEngine_l262_1 == 6'h28);
  assign when_MatrixEngine_l262_90 = (_zz_when_MatrixEngine_l262_1 == 6'h29);
  assign when_MatrixEngine_l262_91 = (_zz_when_MatrixEngine_l262_1 == 6'h2a);
  assign when_MatrixEngine_l262_92 = (_zz_when_MatrixEngine_l262_1 == 6'h2b);
  assign when_MatrixEngine_l262_93 = (_zz_when_MatrixEngine_l262_1 == 6'h2c);
  assign when_MatrixEngine_l262_94 = (_zz_when_MatrixEngine_l262_1 == 6'h2d);
  assign when_MatrixEngine_l262_95 = (_zz_when_MatrixEngine_l262_1 == 6'h2e);
  assign when_MatrixEngine_l262_96 = (_zz_when_MatrixEngine_l262_1 == 6'h2f);
  assign when_MatrixEngine_l262_97 = (_zz_when_MatrixEngine_l262_1 == 6'h30);
  assign _zz_when_MatrixEngine_l268_1 = (8'h76 - _zz_when_MatrixEngine_l251_1);
  assign when_MatrixEngine_l268_1 = (8'h18 < _zz_when_MatrixEngine_l268_1);
  assign _zz_when_MatrixEngine_l272_1 = _zz_when_MatrixEngine_l268_1[4:0];
  assign when_MatrixEngine_l272_1 = (_zz_when_MatrixEngine_l272_1 == 5'h0);
  assign when_MatrixEngine_l276_24 = (_zz_when_MatrixEngine_l272_1 == 5'h01);
  assign _zz_fpAccReg_3 = {49'd0, _zz__zz_fpAccReg_3};
  assign when_MatrixEngine_l276_25 = (_zz_when_MatrixEngine_l272_1 == 5'h02);
  assign _zz_fpAccReg_4 = {50'd0, _zz__zz_fpAccReg_4};
  assign when_MatrixEngine_l276_26 = (_zz_when_MatrixEngine_l272_1 == 5'h03);
  assign _zz_fpAccReg_5 = {51'd0, _zz__zz_fpAccReg_5};
  assign when_MatrixEngine_l276_27 = (_zz_when_MatrixEngine_l272_1 == 5'h04);
  assign _zz_fpAccReg_6 = {52'd0, _zz__zz_fpAccReg_6};
  assign when_MatrixEngine_l276_28 = (_zz_when_MatrixEngine_l272_1 == 5'h05);
  assign _zz_fpAccReg_7 = {53'd0, _zz__zz_fpAccReg_7};
  assign when_MatrixEngine_l276_29 = (_zz_when_MatrixEngine_l272_1 == 5'h06);
  assign _zz_fpAccReg_8 = {54'd0, _zz__zz_fpAccReg_8};
  assign when_MatrixEngine_l276_30 = (_zz_when_MatrixEngine_l272_1 == 5'h07);
  assign _zz_fpAccReg_9 = {55'd0, _zz__zz_fpAccReg_9};
  assign when_MatrixEngine_l276_31 = (_zz_when_MatrixEngine_l272_1 == 5'h08);
  assign _zz_fpAccReg_10 = {56'd0, _zz__zz_fpAccReg_10};
  assign when_MatrixEngine_l276_32 = (_zz_when_MatrixEngine_l272_1 == 5'h09);
  assign _zz_fpAccReg_11 = {57'd0, _zz__zz_fpAccReg_11};
  assign when_MatrixEngine_l276_33 = (_zz_when_MatrixEngine_l272_1 == 5'h0a);
  assign _zz_fpAccReg_12 = {58'd0, _zz__zz_fpAccReg_12};
  assign when_MatrixEngine_l276_34 = (_zz_when_MatrixEngine_l272_1 == 5'h0b);
  assign _zz_fpAccReg_13 = {59'd0, _zz__zz_fpAccReg_13};
  assign when_MatrixEngine_l276_35 = (_zz_when_MatrixEngine_l272_1 == 5'h0c);
  assign _zz_fpAccReg_14 = {60'd0, _zz__zz_fpAccReg_14};
  assign when_MatrixEngine_l276_36 = (_zz_when_MatrixEngine_l272_1 == 5'h0d);
  assign _zz_fpAccReg_15 = {61'd0, _zz__zz_fpAccReg_15};
  assign when_MatrixEngine_l276_37 = (_zz_when_MatrixEngine_l272_1 == 5'h0e);
  assign _zz_fpAccReg_16 = {62'd0, _zz__zz_fpAccReg_16};
  assign when_MatrixEngine_l276_38 = (_zz_when_MatrixEngine_l272_1 == 5'h0f);
  assign _zz_fpAccReg_17 = {63'd0, _zz__zz_fpAccReg_17};
  assign when_MatrixEngine_l276_39 = (_zz_when_MatrixEngine_l272_1 == 5'h10);
  assign _zz_fpAccReg_18 = {64'd0, _zz__zz_fpAccReg_18};
  assign when_MatrixEngine_l276_40 = (_zz_when_MatrixEngine_l272_1 == 5'h11);
  assign _zz_fpAccReg_19 = {65'd0, _zz__zz_fpAccReg_19};
  assign when_MatrixEngine_l276_41 = (_zz_when_MatrixEngine_l272_1 == 5'h12);
  assign _zz_fpAccReg_20 = {66'd0, _zz__zz_fpAccReg_20};
  assign when_MatrixEngine_l276_42 = (_zz_when_MatrixEngine_l272_1 == 5'h13);
  assign _zz_fpAccReg_21 = {67'd0, _zz__zz_fpAccReg_21};
  assign when_MatrixEngine_l276_43 = (_zz_when_MatrixEngine_l272_1 == 5'h14);
  assign _zz_fpAccReg_22 = {68'd0, _zz__zz_fpAccReg_22};
  assign when_MatrixEngine_l276_44 = (_zz_when_MatrixEngine_l272_1 == 5'h15);
  assign _zz_fpAccReg_23 = {69'd0, _zz__zz_fpAccReg_23};
  assign when_MatrixEngine_l276_45 = (_zz_when_MatrixEngine_l272_1 == 5'h16);
  assign _zz_fpAccReg_24 = {70'd0, _zz__zz_fpAccReg_24};
  assign when_MatrixEngine_l276_46 = (_zz_when_MatrixEngine_l272_1 == 5'h17);
  assign _zz_fpAccReg_25 = {71'd0, _zz__zz_fpAccReg_25};
  assign when_MatrixEngine_l276_47 = (_zz_when_MatrixEngine_l272_1 == 5'h18);
  assign _zz_fpAccReg_26 = 72'h0;
  assign when_MatrixEngine_l253_1 = (_zz_when_MatrixEngine_l251_1 == 8'hff);
  always @(*) begin
    _zz_fpAccReg_27 = _zz_fpAccReg_1;
    if(when_MatrixEngine_l290_1) begin
      _zz_fpAccReg_27 = (- _zz__zz_fpAccReg_27);
    end
  end

  assign when_MatrixEngine_l458 = (kReg == 3'b111);
  always @(*) begin
    _zz_io_matrixAccumWrData = 32'h0;
    if(when_MatrixEngine_l201_1) begin
      _zz_io_matrixAccumWrData = {{when_MatrixEngine_l175_1,_zz_io_matrixAccumWrData_2},_zz_io_matrixAccumWrData_3[22 : 0]};
    end
  end

  assign when_MatrixEngine_l175_1 = fpAccReg[71];
  always @(*) begin
    _zz_when_MatrixEngine_l89_1 = 72'h0;
    if(when_MatrixEngine_l175_1) begin
      _zz_when_MatrixEngine_l89_1 = _zz__zz_when_MatrixEngine_l89_1;
    end else begin
      _zz_when_MatrixEngine_l89_1 = fpAccReg;
    end
  end

  always @(*) begin
    _zz_when_MatrixEngine_l184_1 = 7'h0;
    if(when_MatrixEngine_l89_72) begin
      _zz_when_MatrixEngine_l184_1 = 7'h0;
    end
    if(when_MatrixEngine_l89_73) begin
      _zz_when_MatrixEngine_l184_1 = 7'h01;
    end
    if(when_MatrixEngine_l89_74) begin
      _zz_when_MatrixEngine_l184_1 = 7'h02;
    end
    if(when_MatrixEngine_l89_75) begin
      _zz_when_MatrixEngine_l184_1 = 7'h03;
    end
    if(when_MatrixEngine_l89_76) begin
      _zz_when_MatrixEngine_l184_1 = 7'h04;
    end
    if(when_MatrixEngine_l89_77) begin
      _zz_when_MatrixEngine_l184_1 = 7'h05;
    end
    if(when_MatrixEngine_l89_78) begin
      _zz_when_MatrixEngine_l184_1 = 7'h06;
    end
    if(when_MatrixEngine_l89_79) begin
      _zz_when_MatrixEngine_l184_1 = 7'h07;
    end
    if(when_MatrixEngine_l89_80) begin
      _zz_when_MatrixEngine_l184_1 = 7'h08;
    end
    if(when_MatrixEngine_l89_81) begin
      _zz_when_MatrixEngine_l184_1 = 7'h09;
    end
    if(when_MatrixEngine_l89_82) begin
      _zz_when_MatrixEngine_l184_1 = 7'h0a;
    end
    if(when_MatrixEngine_l89_83) begin
      _zz_when_MatrixEngine_l184_1 = 7'h0b;
    end
    if(when_MatrixEngine_l89_84) begin
      _zz_when_MatrixEngine_l184_1 = 7'h0c;
    end
    if(when_MatrixEngine_l89_85) begin
      _zz_when_MatrixEngine_l184_1 = 7'h0d;
    end
    if(when_MatrixEngine_l89_86) begin
      _zz_when_MatrixEngine_l184_1 = 7'h0e;
    end
    if(when_MatrixEngine_l89_87) begin
      _zz_when_MatrixEngine_l184_1 = 7'h0f;
    end
    if(when_MatrixEngine_l89_88) begin
      _zz_when_MatrixEngine_l184_1 = 7'h10;
    end
    if(when_MatrixEngine_l89_89) begin
      _zz_when_MatrixEngine_l184_1 = 7'h11;
    end
    if(when_MatrixEngine_l89_90) begin
      _zz_when_MatrixEngine_l184_1 = 7'h12;
    end
    if(when_MatrixEngine_l89_91) begin
      _zz_when_MatrixEngine_l184_1 = 7'h13;
    end
    if(when_MatrixEngine_l89_92) begin
      _zz_when_MatrixEngine_l184_1 = 7'h14;
    end
    if(when_MatrixEngine_l89_93) begin
      _zz_when_MatrixEngine_l184_1 = 7'h15;
    end
    if(when_MatrixEngine_l89_94) begin
      _zz_when_MatrixEngine_l184_1 = 7'h16;
    end
    if(when_MatrixEngine_l89_95) begin
      _zz_when_MatrixEngine_l184_1 = 7'h17;
    end
    if(when_MatrixEngine_l89_96) begin
      _zz_when_MatrixEngine_l184_1 = 7'h18;
    end
    if(when_MatrixEngine_l89_97) begin
      _zz_when_MatrixEngine_l184_1 = 7'h19;
    end
    if(when_MatrixEngine_l89_98) begin
      _zz_when_MatrixEngine_l184_1 = 7'h1a;
    end
    if(when_MatrixEngine_l89_99) begin
      _zz_when_MatrixEngine_l184_1 = 7'h1b;
    end
    if(when_MatrixEngine_l89_100) begin
      _zz_when_MatrixEngine_l184_1 = 7'h1c;
    end
    if(when_MatrixEngine_l89_101) begin
      _zz_when_MatrixEngine_l184_1 = 7'h1d;
    end
    if(when_MatrixEngine_l89_102) begin
      _zz_when_MatrixEngine_l184_1 = 7'h1e;
    end
    if(when_MatrixEngine_l89_103) begin
      _zz_when_MatrixEngine_l184_1 = 7'h1f;
    end
    if(when_MatrixEngine_l89_104) begin
      _zz_when_MatrixEngine_l184_1 = 7'h20;
    end
    if(when_MatrixEngine_l89_105) begin
      _zz_when_MatrixEngine_l184_1 = 7'h21;
    end
    if(when_MatrixEngine_l89_106) begin
      _zz_when_MatrixEngine_l184_1 = 7'h22;
    end
    if(when_MatrixEngine_l89_107) begin
      _zz_when_MatrixEngine_l184_1 = 7'h23;
    end
    if(when_MatrixEngine_l89_108) begin
      _zz_when_MatrixEngine_l184_1 = 7'h24;
    end
    if(when_MatrixEngine_l89_109) begin
      _zz_when_MatrixEngine_l184_1 = 7'h25;
    end
    if(when_MatrixEngine_l89_110) begin
      _zz_when_MatrixEngine_l184_1 = 7'h26;
    end
    if(when_MatrixEngine_l89_111) begin
      _zz_when_MatrixEngine_l184_1 = 7'h27;
    end
    if(when_MatrixEngine_l89_112) begin
      _zz_when_MatrixEngine_l184_1 = 7'h28;
    end
    if(when_MatrixEngine_l89_113) begin
      _zz_when_MatrixEngine_l184_1 = 7'h29;
    end
    if(when_MatrixEngine_l89_114) begin
      _zz_when_MatrixEngine_l184_1 = 7'h2a;
    end
    if(when_MatrixEngine_l89_115) begin
      _zz_when_MatrixEngine_l184_1 = 7'h2b;
    end
    if(when_MatrixEngine_l89_116) begin
      _zz_when_MatrixEngine_l184_1 = 7'h2c;
    end
    if(when_MatrixEngine_l89_117) begin
      _zz_when_MatrixEngine_l184_1 = 7'h2d;
    end
    if(when_MatrixEngine_l89_118) begin
      _zz_when_MatrixEngine_l184_1 = 7'h2e;
    end
    if(when_MatrixEngine_l89_119) begin
      _zz_when_MatrixEngine_l184_1 = 7'h2f;
    end
    if(when_MatrixEngine_l89_120) begin
      _zz_when_MatrixEngine_l184_1 = 7'h30;
    end
    if(when_MatrixEngine_l89_121) begin
      _zz_when_MatrixEngine_l184_1 = 7'h31;
    end
    if(when_MatrixEngine_l89_122) begin
      _zz_when_MatrixEngine_l184_1 = 7'h32;
    end
    if(when_MatrixEngine_l89_123) begin
      _zz_when_MatrixEngine_l184_1 = 7'h33;
    end
    if(when_MatrixEngine_l89_124) begin
      _zz_when_MatrixEngine_l184_1 = 7'h34;
    end
    if(when_MatrixEngine_l89_125) begin
      _zz_when_MatrixEngine_l184_1 = 7'h35;
    end
    if(when_MatrixEngine_l89_126) begin
      _zz_when_MatrixEngine_l184_1 = 7'h36;
    end
    if(when_MatrixEngine_l89_127) begin
      _zz_when_MatrixEngine_l184_1 = 7'h37;
    end
    if(when_MatrixEngine_l89_128) begin
      _zz_when_MatrixEngine_l184_1 = 7'h38;
    end
    if(when_MatrixEngine_l89_129) begin
      _zz_when_MatrixEngine_l184_1 = 7'h39;
    end
    if(when_MatrixEngine_l89_130) begin
      _zz_when_MatrixEngine_l184_1 = 7'h3a;
    end
    if(when_MatrixEngine_l89_131) begin
      _zz_when_MatrixEngine_l184_1 = 7'h3b;
    end
    if(when_MatrixEngine_l89_132) begin
      _zz_when_MatrixEngine_l184_1 = 7'h3c;
    end
    if(when_MatrixEngine_l89_133) begin
      _zz_when_MatrixEngine_l184_1 = 7'h3d;
    end
    if(when_MatrixEngine_l89_134) begin
      _zz_when_MatrixEngine_l184_1 = 7'h3e;
    end
    if(when_MatrixEngine_l89_135) begin
      _zz_when_MatrixEngine_l184_1 = 7'h3f;
    end
    if(when_MatrixEngine_l89_136) begin
      _zz_when_MatrixEngine_l184_1 = 7'h40;
    end
    if(when_MatrixEngine_l89_137) begin
      _zz_when_MatrixEngine_l184_1 = 7'h41;
    end
    if(when_MatrixEngine_l89_138) begin
      _zz_when_MatrixEngine_l184_1 = 7'h42;
    end
    if(when_MatrixEngine_l89_139) begin
      _zz_when_MatrixEngine_l184_1 = 7'h43;
    end
    if(when_MatrixEngine_l89_140) begin
      _zz_when_MatrixEngine_l184_1 = 7'h44;
    end
    if(when_MatrixEngine_l89_141) begin
      _zz_when_MatrixEngine_l184_1 = 7'h45;
    end
    if(when_MatrixEngine_l89_142) begin
      _zz_when_MatrixEngine_l184_1 = 7'h46;
    end
    if(when_MatrixEngine_l89_143) begin
      _zz_when_MatrixEngine_l184_1 = 7'h47;
    end
  end

  assign when_MatrixEngine_l89_72 = _zz_when_MatrixEngine_l89_1[0];
  assign when_MatrixEngine_l89_73 = _zz_when_MatrixEngine_l89_1[1];
  assign when_MatrixEngine_l89_74 = _zz_when_MatrixEngine_l89_1[2];
  assign when_MatrixEngine_l89_75 = _zz_when_MatrixEngine_l89_1[3];
  assign when_MatrixEngine_l89_76 = _zz_when_MatrixEngine_l89_1[4];
  assign when_MatrixEngine_l89_77 = _zz_when_MatrixEngine_l89_1[5];
  assign when_MatrixEngine_l89_78 = _zz_when_MatrixEngine_l89_1[6];
  assign when_MatrixEngine_l89_79 = _zz_when_MatrixEngine_l89_1[7];
  assign when_MatrixEngine_l89_80 = _zz_when_MatrixEngine_l89_1[8];
  assign when_MatrixEngine_l89_81 = _zz_when_MatrixEngine_l89_1[9];
  assign when_MatrixEngine_l89_82 = _zz_when_MatrixEngine_l89_1[10];
  assign when_MatrixEngine_l89_83 = _zz_when_MatrixEngine_l89_1[11];
  assign when_MatrixEngine_l89_84 = _zz_when_MatrixEngine_l89_1[12];
  assign when_MatrixEngine_l89_85 = _zz_when_MatrixEngine_l89_1[13];
  assign when_MatrixEngine_l89_86 = _zz_when_MatrixEngine_l89_1[14];
  assign when_MatrixEngine_l89_87 = _zz_when_MatrixEngine_l89_1[15];
  assign when_MatrixEngine_l89_88 = _zz_when_MatrixEngine_l89_1[16];
  assign when_MatrixEngine_l89_89 = _zz_when_MatrixEngine_l89_1[17];
  assign when_MatrixEngine_l89_90 = _zz_when_MatrixEngine_l89_1[18];
  assign when_MatrixEngine_l89_91 = _zz_when_MatrixEngine_l89_1[19];
  assign when_MatrixEngine_l89_92 = _zz_when_MatrixEngine_l89_1[20];
  assign when_MatrixEngine_l89_93 = _zz_when_MatrixEngine_l89_1[21];
  assign when_MatrixEngine_l89_94 = _zz_when_MatrixEngine_l89_1[22];
  assign when_MatrixEngine_l89_95 = _zz_when_MatrixEngine_l89_1[23];
  assign when_MatrixEngine_l89_96 = _zz_when_MatrixEngine_l89_1[24];
  assign when_MatrixEngine_l89_97 = _zz_when_MatrixEngine_l89_1[25];
  assign when_MatrixEngine_l89_98 = _zz_when_MatrixEngine_l89_1[26];
  assign when_MatrixEngine_l89_99 = _zz_when_MatrixEngine_l89_1[27];
  assign when_MatrixEngine_l89_100 = _zz_when_MatrixEngine_l89_1[28];
  assign when_MatrixEngine_l89_101 = _zz_when_MatrixEngine_l89_1[29];
  assign when_MatrixEngine_l89_102 = _zz_when_MatrixEngine_l89_1[30];
  assign when_MatrixEngine_l89_103 = _zz_when_MatrixEngine_l89_1[31];
  assign when_MatrixEngine_l89_104 = _zz_when_MatrixEngine_l89_1[32];
  assign when_MatrixEngine_l89_105 = _zz_when_MatrixEngine_l89_1[33];
  assign when_MatrixEngine_l89_106 = _zz_when_MatrixEngine_l89_1[34];
  assign when_MatrixEngine_l89_107 = _zz_when_MatrixEngine_l89_1[35];
  assign when_MatrixEngine_l89_108 = _zz_when_MatrixEngine_l89_1[36];
  assign when_MatrixEngine_l89_109 = _zz_when_MatrixEngine_l89_1[37];
  assign when_MatrixEngine_l89_110 = _zz_when_MatrixEngine_l89_1[38];
  assign when_MatrixEngine_l89_111 = _zz_when_MatrixEngine_l89_1[39];
  assign when_MatrixEngine_l89_112 = _zz_when_MatrixEngine_l89_1[40];
  assign when_MatrixEngine_l89_113 = _zz_when_MatrixEngine_l89_1[41];
  assign when_MatrixEngine_l89_114 = _zz_when_MatrixEngine_l89_1[42];
  assign when_MatrixEngine_l89_115 = _zz_when_MatrixEngine_l89_1[43];
  assign when_MatrixEngine_l89_116 = _zz_when_MatrixEngine_l89_1[44];
  assign when_MatrixEngine_l89_117 = _zz_when_MatrixEngine_l89_1[45];
  assign when_MatrixEngine_l89_118 = _zz_when_MatrixEngine_l89_1[46];
  assign when_MatrixEngine_l89_119 = _zz_when_MatrixEngine_l89_1[47];
  assign when_MatrixEngine_l89_120 = _zz_when_MatrixEngine_l89_1[48];
  assign when_MatrixEngine_l89_121 = _zz_when_MatrixEngine_l89_1[49];
  assign when_MatrixEngine_l89_122 = _zz_when_MatrixEngine_l89_1[50];
  assign when_MatrixEngine_l89_123 = _zz_when_MatrixEngine_l89_1[51];
  assign when_MatrixEngine_l89_124 = _zz_when_MatrixEngine_l89_1[52];
  assign when_MatrixEngine_l89_125 = _zz_when_MatrixEngine_l89_1[53];
  assign when_MatrixEngine_l89_126 = _zz_when_MatrixEngine_l89_1[54];
  assign when_MatrixEngine_l89_127 = _zz_when_MatrixEngine_l89_1[55];
  assign when_MatrixEngine_l89_128 = _zz_when_MatrixEngine_l89_1[56];
  assign when_MatrixEngine_l89_129 = _zz_when_MatrixEngine_l89_1[57];
  assign when_MatrixEngine_l89_130 = _zz_when_MatrixEngine_l89_1[58];
  assign when_MatrixEngine_l89_131 = _zz_when_MatrixEngine_l89_1[59];
  assign when_MatrixEngine_l89_132 = _zz_when_MatrixEngine_l89_1[60];
  assign when_MatrixEngine_l89_133 = _zz_when_MatrixEngine_l89_1[61];
  assign when_MatrixEngine_l89_134 = _zz_when_MatrixEngine_l89_1[62];
  assign when_MatrixEngine_l89_135 = _zz_when_MatrixEngine_l89_1[63];
  assign when_MatrixEngine_l89_136 = _zz_when_MatrixEngine_l89_1[64];
  assign when_MatrixEngine_l89_137 = _zz_when_MatrixEngine_l89_1[65];
  assign when_MatrixEngine_l89_138 = _zz_when_MatrixEngine_l89_1[66];
  assign when_MatrixEngine_l89_139 = _zz_when_MatrixEngine_l89_1[67];
  assign when_MatrixEngine_l89_140 = _zz_when_MatrixEngine_l89_1[68];
  assign when_MatrixEngine_l89_141 = _zz_when_MatrixEngine_l89_1[69];
  assign when_MatrixEngine_l89_142 = _zz_when_MatrixEngine_l89_1[70];
  assign when_MatrixEngine_l89_143 = _zz_when_MatrixEngine_l89_1[71];
  always @(*) begin
    _zz_when_MatrixEngine_l209_1 = 6'h0;
    if(when_MatrixEngine_l184_1) begin
      _zz_when_MatrixEngine_l209_1 = _zz__zz_when_MatrixEngine_l209_1[5:0];
    end
  end

  assign when_MatrixEngine_l184_1 = (7'h17 < _zz_when_MatrixEngine_l184_1);
  always @(*) begin
    _zz_when_MatrixEngine_l204_1 = 5'h0;
    if(when_MatrixEngine_l190_1) begin
      _zz_when_MatrixEngine_l204_1 = _zz__zz_when_MatrixEngine_l204_1[4:0];
    end
  end

  assign when_MatrixEngine_l190_1 = (_zz_when_MatrixEngine_l184_1 <= 7'h17);
  always @(*) begin
    _zz_when_MatrixEngine_l233_4 = 24'h0;
    if(when_MatrixEngine_l201_1) begin
      if(when_MatrixEngine_l202_1) begin
        if(when_MatrixEngine_l204_24) begin
          _zz_when_MatrixEngine_l233_4 = _zz_when_MatrixEngine_l89_1[23:0];
        end
        if(when_MatrixEngine_l204_25) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_1[23:0];
        end
        if(when_MatrixEngine_l204_26) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_3[23:0];
        end
        if(when_MatrixEngine_l204_27) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_5[23:0];
        end
        if(when_MatrixEngine_l204_28) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_7[23:0];
        end
        if(when_MatrixEngine_l204_29) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_9[23:0];
        end
        if(when_MatrixEngine_l204_30) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_11[23:0];
        end
        if(when_MatrixEngine_l204_31) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_13[23:0];
        end
        if(when_MatrixEngine_l204_32) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_15[23:0];
        end
        if(when_MatrixEngine_l204_33) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_17[23:0];
        end
        if(when_MatrixEngine_l204_34) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_19[23:0];
        end
        if(when_MatrixEngine_l204_35) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_21[23:0];
        end
        if(when_MatrixEngine_l204_36) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_23[23:0];
        end
        if(when_MatrixEngine_l204_37) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_25[23:0];
        end
        if(when_MatrixEngine_l204_38) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_27[23:0];
        end
        if(when_MatrixEngine_l204_39) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_29[23:0];
        end
        if(when_MatrixEngine_l204_40) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_31[23:0];
        end
        if(when_MatrixEngine_l204_41) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_33[23:0];
        end
        if(when_MatrixEngine_l204_42) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_35[23:0];
        end
        if(when_MatrixEngine_l204_43) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_37[23:0];
        end
        if(when_MatrixEngine_l204_44) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_39[23:0];
        end
        if(when_MatrixEngine_l204_45) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_41[23:0];
        end
        if(when_MatrixEngine_l204_46) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_43[23:0];
        end
        if(when_MatrixEngine_l204_47) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_45[23:0];
        end
      end else begin
        if(when_MatrixEngine_l209_1) begin
          _zz_when_MatrixEngine_l233_4 = _zz_when_MatrixEngine_l89_1[23 : 0];
        end
        if(when_MatrixEngine_l213_48) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_47[23:0];
        end
        if(when_MatrixEngine_l213_49) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_48[23:0];
        end
        if(when_MatrixEngine_l213_50) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_49[23:0];
        end
        if(when_MatrixEngine_l213_51) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_50[23:0];
        end
        if(when_MatrixEngine_l213_52) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_51[23:0];
        end
        if(when_MatrixEngine_l213_53) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_52[23:0];
        end
        if(when_MatrixEngine_l213_54) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_53[23:0];
        end
        if(when_MatrixEngine_l213_55) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_54[23:0];
        end
        if(when_MatrixEngine_l213_56) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_55[23:0];
        end
        if(when_MatrixEngine_l213_57) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_56[23:0];
        end
        if(when_MatrixEngine_l213_58) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_57[23:0];
        end
        if(when_MatrixEngine_l213_59) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_58[23:0];
        end
        if(when_MatrixEngine_l213_60) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_59[23:0];
        end
        if(when_MatrixEngine_l213_61) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_60[23:0];
        end
        if(when_MatrixEngine_l213_62) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_61[23:0];
        end
        if(when_MatrixEngine_l213_63) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_62[23:0];
        end
        if(when_MatrixEngine_l213_64) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_63[23:0];
        end
        if(when_MatrixEngine_l213_65) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_64[23:0];
        end
        if(when_MatrixEngine_l213_66) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_65[23:0];
        end
        if(when_MatrixEngine_l213_67) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_66[23:0];
        end
        if(when_MatrixEngine_l213_68) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_67[23:0];
        end
        if(when_MatrixEngine_l213_69) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_68[23:0];
        end
        if(when_MatrixEngine_l213_70) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_69[23:0];
        end
        if(when_MatrixEngine_l213_71) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_70[23:0];
        end
        if(when_MatrixEngine_l213_72) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_71[23:0];
        end
        if(when_MatrixEngine_l213_73) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_72[23:0];
        end
        if(when_MatrixEngine_l213_74) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_73[23:0];
        end
        if(when_MatrixEngine_l213_75) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_74[23:0];
        end
        if(when_MatrixEngine_l213_76) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_75[23:0];
        end
        if(when_MatrixEngine_l213_77) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_76[23:0];
        end
        if(when_MatrixEngine_l213_78) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_77[23:0];
        end
        if(when_MatrixEngine_l213_79) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_78[23:0];
        end
        if(when_MatrixEngine_l213_80) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_79[23:0];
        end
        if(when_MatrixEngine_l213_81) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_80[23:0];
        end
        if(when_MatrixEngine_l213_82) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_81[23:0];
        end
        if(when_MatrixEngine_l213_83) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_82[23:0];
        end
        if(when_MatrixEngine_l213_84) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_83[23:0];
        end
        if(when_MatrixEngine_l213_85) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_84[23:0];
        end
        if(when_MatrixEngine_l213_86) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_85[23:0];
        end
        if(when_MatrixEngine_l213_87) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_86[23:0];
        end
        if(when_MatrixEngine_l213_88) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_87[23:0];
        end
        if(when_MatrixEngine_l213_89) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_88[23:0];
        end
        if(when_MatrixEngine_l213_90) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_89[23:0];
        end
        if(when_MatrixEngine_l213_91) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_90[23:0];
        end
        if(when_MatrixEngine_l213_92) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_91[23:0];
        end
        if(when_MatrixEngine_l213_93) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_92[23:0];
        end
        if(when_MatrixEngine_l213_94) begin
          _zz_when_MatrixEngine_l233_4 = _zz__zz_when_MatrixEngine_l233_4_93[23:0];
        end
        if(when_MatrixEngine_l213_95) begin
          _zz_when_MatrixEngine_l233_4 = (_zz_when_MatrixEngine_l89_1 >>> 6'd48);
        end
      end
    end
  end

  always @(*) begin
    _zz_when_MatrixEngine_l233_5 = 1'b0;
    if(when_MatrixEngine_l201_1) begin
      if(!when_MatrixEngine_l202_1) begin
        if(when_MatrixEngine_l213_48) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[0];
        end
        if(when_MatrixEngine_l213_49) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[1];
        end
        if(when_MatrixEngine_l213_50) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[2];
        end
        if(when_MatrixEngine_l213_51) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[3];
        end
        if(when_MatrixEngine_l213_52) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[4];
        end
        if(when_MatrixEngine_l213_53) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[5];
        end
        if(when_MatrixEngine_l213_54) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[6];
        end
        if(when_MatrixEngine_l213_55) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[7];
        end
        if(when_MatrixEngine_l213_56) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[8];
        end
        if(when_MatrixEngine_l213_57) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[9];
        end
        if(when_MatrixEngine_l213_58) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[10];
        end
        if(when_MatrixEngine_l213_59) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[11];
        end
        if(when_MatrixEngine_l213_60) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[12];
        end
        if(when_MatrixEngine_l213_61) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[13];
        end
        if(when_MatrixEngine_l213_62) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[14];
        end
        if(when_MatrixEngine_l213_63) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[15];
        end
        if(when_MatrixEngine_l213_64) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[16];
        end
        if(when_MatrixEngine_l213_65) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[17];
        end
        if(when_MatrixEngine_l213_66) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[18];
        end
        if(when_MatrixEngine_l213_67) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[19];
        end
        if(when_MatrixEngine_l213_68) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[20];
        end
        if(when_MatrixEngine_l213_69) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[21];
        end
        if(when_MatrixEngine_l213_70) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[22];
        end
        if(when_MatrixEngine_l213_71) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[23];
        end
        if(when_MatrixEngine_l213_72) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[24];
        end
        if(when_MatrixEngine_l213_73) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[25];
        end
        if(when_MatrixEngine_l213_74) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[26];
        end
        if(when_MatrixEngine_l213_75) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[27];
        end
        if(when_MatrixEngine_l213_76) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[28];
        end
        if(when_MatrixEngine_l213_77) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[29];
        end
        if(when_MatrixEngine_l213_78) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[30];
        end
        if(when_MatrixEngine_l213_79) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[31];
        end
        if(when_MatrixEngine_l213_80) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[32];
        end
        if(when_MatrixEngine_l213_81) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[33];
        end
        if(when_MatrixEngine_l213_82) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[34];
        end
        if(when_MatrixEngine_l213_83) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[35];
        end
        if(when_MatrixEngine_l213_84) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[36];
        end
        if(when_MatrixEngine_l213_85) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[37];
        end
        if(when_MatrixEngine_l213_86) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[38];
        end
        if(when_MatrixEngine_l213_87) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[39];
        end
        if(when_MatrixEngine_l213_88) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[40];
        end
        if(when_MatrixEngine_l213_89) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[41];
        end
        if(when_MatrixEngine_l213_90) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[42];
        end
        if(when_MatrixEngine_l213_91) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[43];
        end
        if(when_MatrixEngine_l213_92) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[44];
        end
        if(when_MatrixEngine_l213_93) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[45];
        end
        if(when_MatrixEngine_l213_94) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[46];
        end
        if(when_MatrixEngine_l213_95) begin
          _zz_when_MatrixEngine_l233_5 = _zz_when_MatrixEngine_l89_1[47];
        end
      end
    end
  end

  always @(*) begin
    _zz_when_MatrixEngine_l233_6 = 1'b0;
    if(when_MatrixEngine_l201_1) begin
      if(!when_MatrixEngine_l202_1) begin
        if(when_MatrixEngine_l213_49) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[0 : 0]);
        end
        if(when_MatrixEngine_l213_50) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[1 : 0]);
        end
        if(when_MatrixEngine_l213_51) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[2 : 0]);
        end
        if(when_MatrixEngine_l213_52) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[3 : 0]);
        end
        if(when_MatrixEngine_l213_53) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[4 : 0]);
        end
        if(when_MatrixEngine_l213_54) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[5 : 0]);
        end
        if(when_MatrixEngine_l213_55) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[6 : 0]);
        end
        if(when_MatrixEngine_l213_56) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[7 : 0]);
        end
        if(when_MatrixEngine_l213_57) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[8 : 0]);
        end
        if(when_MatrixEngine_l213_58) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[9 : 0]);
        end
        if(when_MatrixEngine_l213_59) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[10 : 0]);
        end
        if(when_MatrixEngine_l213_60) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[11 : 0]);
        end
        if(when_MatrixEngine_l213_61) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[12 : 0]);
        end
        if(when_MatrixEngine_l213_62) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[13 : 0]);
        end
        if(when_MatrixEngine_l213_63) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[14 : 0]);
        end
        if(when_MatrixEngine_l213_64) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[15 : 0]);
        end
        if(when_MatrixEngine_l213_65) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[16 : 0]);
        end
        if(when_MatrixEngine_l213_66) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[17 : 0]);
        end
        if(when_MatrixEngine_l213_67) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[18 : 0]);
        end
        if(when_MatrixEngine_l213_68) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[19 : 0]);
        end
        if(when_MatrixEngine_l213_69) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[20 : 0]);
        end
        if(when_MatrixEngine_l213_70) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[21 : 0]);
        end
        if(when_MatrixEngine_l213_71) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[22 : 0]);
        end
        if(when_MatrixEngine_l213_72) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[23 : 0]);
        end
        if(when_MatrixEngine_l213_73) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[24 : 0]);
        end
        if(when_MatrixEngine_l213_74) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[25 : 0]);
        end
        if(when_MatrixEngine_l213_75) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[26 : 0]);
        end
        if(when_MatrixEngine_l213_76) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[27 : 0]);
        end
        if(when_MatrixEngine_l213_77) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[28 : 0]);
        end
        if(when_MatrixEngine_l213_78) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[29 : 0]);
        end
        if(when_MatrixEngine_l213_79) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[30 : 0]);
        end
        if(when_MatrixEngine_l213_80) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[31 : 0]);
        end
        if(when_MatrixEngine_l213_81) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[32 : 0]);
        end
        if(when_MatrixEngine_l213_82) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[33 : 0]);
        end
        if(when_MatrixEngine_l213_83) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[34 : 0]);
        end
        if(when_MatrixEngine_l213_84) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[35 : 0]);
        end
        if(when_MatrixEngine_l213_85) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[36 : 0]);
        end
        if(when_MatrixEngine_l213_86) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[37 : 0]);
        end
        if(when_MatrixEngine_l213_87) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[38 : 0]);
        end
        if(when_MatrixEngine_l213_88) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[39 : 0]);
        end
        if(when_MatrixEngine_l213_89) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[40 : 0]);
        end
        if(when_MatrixEngine_l213_90) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[41 : 0]);
        end
        if(when_MatrixEngine_l213_91) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[42 : 0]);
        end
        if(when_MatrixEngine_l213_92) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[43 : 0]);
        end
        if(when_MatrixEngine_l213_93) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[44 : 0]);
        end
        if(when_MatrixEngine_l213_94) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[45 : 0]);
        end
        if(when_MatrixEngine_l213_95) begin
          _zz_when_MatrixEngine_l233_6 = (|_zz_when_MatrixEngine_l89_1[46 : 0]);
        end
      end
    end
  end

  assign when_MatrixEngine_l201_1 = (_zz_when_MatrixEngine_l89_1 != 72'h0);
  assign when_MatrixEngine_l202_1 = (_zz_when_MatrixEngine_l184_1 <= 7'h17);
  assign when_MatrixEngine_l204_24 = (_zz_when_MatrixEngine_l204_1 == 5'h0);
  assign when_MatrixEngine_l204_25 = (_zz_when_MatrixEngine_l204_1 == 5'h01);
  assign when_MatrixEngine_l204_26 = (_zz_when_MatrixEngine_l204_1 == 5'h02);
  assign when_MatrixEngine_l204_27 = (_zz_when_MatrixEngine_l204_1 == 5'h03);
  assign when_MatrixEngine_l204_28 = (_zz_when_MatrixEngine_l204_1 == 5'h04);
  assign when_MatrixEngine_l204_29 = (_zz_when_MatrixEngine_l204_1 == 5'h05);
  assign when_MatrixEngine_l204_30 = (_zz_when_MatrixEngine_l204_1 == 5'h06);
  assign when_MatrixEngine_l204_31 = (_zz_when_MatrixEngine_l204_1 == 5'h07);
  assign when_MatrixEngine_l204_32 = (_zz_when_MatrixEngine_l204_1 == 5'h08);
  assign when_MatrixEngine_l204_33 = (_zz_when_MatrixEngine_l204_1 == 5'h09);
  assign when_MatrixEngine_l204_34 = (_zz_when_MatrixEngine_l204_1 == 5'h0a);
  assign when_MatrixEngine_l204_35 = (_zz_when_MatrixEngine_l204_1 == 5'h0b);
  assign when_MatrixEngine_l204_36 = (_zz_when_MatrixEngine_l204_1 == 5'h0c);
  assign when_MatrixEngine_l204_37 = (_zz_when_MatrixEngine_l204_1 == 5'h0d);
  assign when_MatrixEngine_l204_38 = (_zz_when_MatrixEngine_l204_1 == 5'h0e);
  assign when_MatrixEngine_l204_39 = (_zz_when_MatrixEngine_l204_1 == 5'h0f);
  assign when_MatrixEngine_l204_40 = (_zz_when_MatrixEngine_l204_1 == 5'h10);
  assign when_MatrixEngine_l204_41 = (_zz_when_MatrixEngine_l204_1 == 5'h11);
  assign when_MatrixEngine_l204_42 = (_zz_when_MatrixEngine_l204_1 == 5'h12);
  assign when_MatrixEngine_l204_43 = (_zz_when_MatrixEngine_l204_1 == 5'h13);
  assign when_MatrixEngine_l204_44 = (_zz_when_MatrixEngine_l204_1 == 5'h14);
  assign when_MatrixEngine_l204_45 = (_zz_when_MatrixEngine_l204_1 == 5'h15);
  assign when_MatrixEngine_l204_46 = (_zz_when_MatrixEngine_l204_1 == 5'h16);
  assign when_MatrixEngine_l204_47 = (_zz_when_MatrixEngine_l204_1 == 5'h17);
  assign when_MatrixEngine_l209_1 = (_zz_when_MatrixEngine_l209_1 == 6'h0);
  assign when_MatrixEngine_l213_48 = (_zz_when_MatrixEngine_l209_1 == 6'h01);
  assign when_MatrixEngine_l213_49 = (_zz_when_MatrixEngine_l209_1 == 6'h02);
  assign when_MatrixEngine_l213_50 = (_zz_when_MatrixEngine_l209_1 == 6'h03);
  assign when_MatrixEngine_l213_51 = (_zz_when_MatrixEngine_l209_1 == 6'h04);
  assign when_MatrixEngine_l213_52 = (_zz_when_MatrixEngine_l209_1 == 6'h05);
  assign when_MatrixEngine_l213_53 = (_zz_when_MatrixEngine_l209_1 == 6'h06);
  assign when_MatrixEngine_l213_54 = (_zz_when_MatrixEngine_l209_1 == 6'h07);
  assign when_MatrixEngine_l213_55 = (_zz_when_MatrixEngine_l209_1 == 6'h08);
  assign when_MatrixEngine_l213_56 = (_zz_when_MatrixEngine_l209_1 == 6'h09);
  assign when_MatrixEngine_l213_57 = (_zz_when_MatrixEngine_l209_1 == 6'h0a);
  assign when_MatrixEngine_l213_58 = (_zz_when_MatrixEngine_l209_1 == 6'h0b);
  assign when_MatrixEngine_l213_59 = (_zz_when_MatrixEngine_l209_1 == 6'h0c);
  assign when_MatrixEngine_l213_60 = (_zz_when_MatrixEngine_l209_1 == 6'h0d);
  assign when_MatrixEngine_l213_61 = (_zz_when_MatrixEngine_l209_1 == 6'h0e);
  assign when_MatrixEngine_l213_62 = (_zz_when_MatrixEngine_l209_1 == 6'h0f);
  assign when_MatrixEngine_l213_63 = (_zz_when_MatrixEngine_l209_1 == 6'h10);
  assign when_MatrixEngine_l213_64 = (_zz_when_MatrixEngine_l209_1 == 6'h11);
  assign when_MatrixEngine_l213_65 = (_zz_when_MatrixEngine_l209_1 == 6'h12);
  assign when_MatrixEngine_l213_66 = (_zz_when_MatrixEngine_l209_1 == 6'h13);
  assign when_MatrixEngine_l213_67 = (_zz_when_MatrixEngine_l209_1 == 6'h14);
  assign when_MatrixEngine_l213_68 = (_zz_when_MatrixEngine_l209_1 == 6'h15);
  assign when_MatrixEngine_l213_69 = (_zz_when_MatrixEngine_l209_1 == 6'h16);
  assign when_MatrixEngine_l213_70 = (_zz_when_MatrixEngine_l209_1 == 6'h17);
  assign when_MatrixEngine_l213_71 = (_zz_when_MatrixEngine_l209_1 == 6'h18);
  assign when_MatrixEngine_l213_72 = (_zz_when_MatrixEngine_l209_1 == 6'h19);
  assign when_MatrixEngine_l213_73 = (_zz_when_MatrixEngine_l209_1 == 6'h1a);
  assign when_MatrixEngine_l213_74 = (_zz_when_MatrixEngine_l209_1 == 6'h1b);
  assign when_MatrixEngine_l213_75 = (_zz_when_MatrixEngine_l209_1 == 6'h1c);
  assign when_MatrixEngine_l213_76 = (_zz_when_MatrixEngine_l209_1 == 6'h1d);
  assign when_MatrixEngine_l213_77 = (_zz_when_MatrixEngine_l209_1 == 6'h1e);
  assign when_MatrixEngine_l213_78 = (_zz_when_MatrixEngine_l209_1 == 6'h1f);
  assign when_MatrixEngine_l213_79 = (_zz_when_MatrixEngine_l209_1 == 6'h20);
  assign when_MatrixEngine_l213_80 = (_zz_when_MatrixEngine_l209_1 == 6'h21);
  assign when_MatrixEngine_l213_81 = (_zz_when_MatrixEngine_l209_1 == 6'h22);
  assign when_MatrixEngine_l213_82 = (_zz_when_MatrixEngine_l209_1 == 6'h23);
  assign when_MatrixEngine_l213_83 = (_zz_when_MatrixEngine_l209_1 == 6'h24);
  assign when_MatrixEngine_l213_84 = (_zz_when_MatrixEngine_l209_1 == 6'h25);
  assign when_MatrixEngine_l213_85 = (_zz_when_MatrixEngine_l209_1 == 6'h26);
  assign when_MatrixEngine_l213_86 = (_zz_when_MatrixEngine_l209_1 == 6'h27);
  assign when_MatrixEngine_l213_87 = (_zz_when_MatrixEngine_l209_1 == 6'h28);
  assign when_MatrixEngine_l213_88 = (_zz_when_MatrixEngine_l209_1 == 6'h29);
  assign when_MatrixEngine_l213_89 = (_zz_when_MatrixEngine_l209_1 == 6'h2a);
  assign when_MatrixEngine_l213_90 = (_zz_when_MatrixEngine_l209_1 == 6'h2b);
  assign when_MatrixEngine_l213_91 = (_zz_when_MatrixEngine_l209_1 == 6'h2c);
  assign when_MatrixEngine_l213_92 = (_zz_when_MatrixEngine_l209_1 == 6'h2d);
  assign when_MatrixEngine_l213_93 = (_zz_when_MatrixEngine_l209_1 == 6'h2e);
  assign when_MatrixEngine_l213_94 = (_zz_when_MatrixEngine_l209_1 == 6'h2f);
  assign when_MatrixEngine_l213_95 = (_zz_when_MatrixEngine_l209_1 == 6'h30);
  assign _zz_when_MatrixEngine_l233_7 = (_zz__zz_when_MatrixEngine_l233_7_1 + _zz__zz_when_MatrixEngine_l233_7_2);
  assign _zz_io_matrixAccumWrData_1 = (_zz__zz_io_matrixAccumWrData_1 + 8'h5f);
  always @(*) begin
    _zz_io_matrixAccumWrData_2 = _zz_io_matrixAccumWrData_1;
    if(when_MatrixEngine_l233_1) begin
      _zz_io_matrixAccumWrData_2 = (_zz_io_matrixAccumWrData_1 + 8'h01);
    end
  end

  always @(*) begin
    _zz_io_matrixAccumWrData_3 = _zz_when_MatrixEngine_l233_7[23 : 0];
    if(when_MatrixEngine_l233_1) begin
      _zz_io_matrixAccumWrData_3 = (_zz_when_MatrixEngine_l233_7 >>> 1'd1);
    end
  end

  assign when_MatrixEngine_l233_1 = _zz_when_MatrixEngine_l233_7[24];
  assign when_MatrixEngine_l476 = ((rowReg == 3'b111) && (colReg == 3'b111));
  assign when_MatrixEngine_l481 = (colReg == 3'b111);
  assign io_busy = (state != MatrixState_IDLE);
  assign io_startPulse = (startsCompute || startsZero);
  assign io_activeOpcode = activeOpcodeReg;
  assign io_countdown = debugCounter;
  always @(posedge clk) begin
    if(reset) begin
      state <= MatrixState_IDLE;
      activeOpcodeReg <= 5'h0;
      localBaseReg <= 6'h0;
      totalElemsReg <= 7'h0;
      operandABaseReg <= 8'h0;
      operandBBaseReg <= 8'h0;
      rowReg <= 3'b000;
      colReg <= 3'b000;
      kReg <= 3'b000;
      accReg <= 32'h0;
      fpAccReg <= 72'h0;
      debugCounter <= 11'h0;
      issueSeenReg <= 1'b0;
    end else begin
      if(when_MatrixEngine_l317) begin
        issueSeenReg <= 1'b0;
      end
      if(when_MatrixEngine_l251) begin
        `ifndef SYNTHESIS
          `ifdef FORMAL
            assert((_zz_roundedFpAcc == 23'h0)); // MatrixEngine.scala:L252
          `else
            if(!(_zz_roundedFpAcc == 23'h0)) begin
              $display("FAILURE MatrixEngine FP32 accumulator seed must not be subnormal in v1"); // MatrixEngine.scala:L252
              $finish;
            end
          `endif
        `endif
      end else begin
        if(when_MatrixEngine_l253) begin
          `ifndef SYNTHESIS
            `ifdef FORMAL
              assert(1'b0); // MatrixEngine.scala:L254
            `else
              if(!1'b0) begin
                $display("FAILURE MatrixEngine FP32 accumulator seed must be finite in v1"); // MatrixEngine.scala:L254
                $finish;
              end
            `endif
          `endif
        end else begin
          if(when_MatrixEngine_l257) begin
            `ifndef SYNTHESIS
              `ifdef FORMAL
                assert((_zz_when_MatrixEngine_l262 <= 6'h30)); // MatrixEngine.scala:L259
              `else
                if(!(_zz_when_MatrixEngine_l262 <= 6'h30)) begin
                  $display("FAILURE MatrixEngine FP32 accumulator seed exceeds v1 fixed-point range"); // MatrixEngine.scala:L259
                  $finish;
                end
              `endif
            `endif
          end
        end
      end
      if(when_MatrixEngine_l364) begin
        debugCounter <= 11'h0;
      end
      if(startsCompute) begin
        issueSeenReg <= 1'b1;
        activeOpcodeReg <= io_slots_0_opcode;
        localBaseReg <= io_slots_0_dest[5:0];
        operandABaseReg <= io_slots_0_srcA[7:0];
        operandBBaseReg <= io_slots_0_srcB[7:0];
        totalElemsReg <= slotTileElems;
        rowReg <= 3'b000;
        colReg <= 3'b000;
        kReg <= 3'b000;
        debugCounter <= 11'h0;
        if(when_MatrixEngine_l379) begin
          state <= MatrixState_ACC_READ;
        end else begin
          if(when_MatrixEngine_l382) begin
            fpAccReg <= 72'h0;
          end else begin
            accReg <= 32'h0;
          end
          state <= MatrixState_AB_READ;
        end
      end else begin
        if(startsZero) begin
          issueSeenReg <= 1'b1;
          activeOpcodeReg <= io_slots_0_opcode;
          localBaseReg <= io_slots_0_dest[5:0];
          totalElemsReg <= slotTileElems;
          debugCounter <= {4'd0, slotTileElems};
          if(when_MatrixEngine_l395) begin
            activeOpcodeReg <= 5'h0;
            state <= MatrixState_IDLE;
          end else begin
            state <= MatrixState_ZERO;
          end
        end
      end
      case(state)
        MatrixState_ZERO : begin
          if(when_MatrixEngine_l411) begin
            activeOpcodeReg <= 5'h0;
            debugCounter <= 11'h0;
            state <= MatrixState_IDLE;
          end else begin
            debugCounter <= (debugCounter - 11'h001);
          end
        end
        MatrixState_ACC_READ : begin
          debugCounter <= {8'd0, kReg};
          state <= MatrixState_ACC_LOAD;
        end
        MatrixState_ACC_LOAD : begin
          if(activeUsesFp8) begin
            if(when_MatrixEngine_l251_1) begin
              `ifndef SYNTHESIS
                `ifdef FORMAL
                  assert((_zz_fpAccReg == 23'h0)); // MatrixEngine.scala:L252
                `else
                  if(!(_zz_fpAccReg == 23'h0)) begin
                    $display("FAILURE MatrixEngine FP32 accumulator seed must not be subnormal in v1"); // MatrixEngine.scala:L252
                    $finish;
                  end
                `endif
              `endif
            end else begin
              if(when_MatrixEngine_l253_1) begin
                `ifndef SYNTHESIS
                  `ifdef FORMAL
                    assert(1'b0); // MatrixEngine.scala:L254
                  `else
                    if(!1'b0) begin
                      $display("FAILURE MatrixEngine FP32 accumulator seed must be finite in v1"); // MatrixEngine.scala:L254
                      $finish;
                    end
                  `endif
                `endif
              end else begin
                if(when_MatrixEngine_l257_1) begin
                  `ifndef SYNTHESIS
                    `ifdef FORMAL
                      assert((_zz_when_MatrixEngine_l262_1 <= 6'h30)); // MatrixEngine.scala:L259
                    `else
                      if(!(_zz_when_MatrixEngine_l262_1 <= 6'h30)) begin
                        $display("FAILURE MatrixEngine FP32 accumulator seed exceeds v1 fixed-point range"); // MatrixEngine.scala:L259
                        $finish;
                      end
                    `endif
                  `endif
                end
              end
            end
            fpAccReg <= _zz_fpAccReg_27;
          end else begin
            accReg <= io_matrixAccumRdData;
          end
          kReg <= 3'b000;
          debugCounter <= 11'h0;
          state <= MatrixState_AB_READ;
        end
        MatrixState_AB_READ : begin
          debugCounter <= {8'd0, kReg};
          state <= MatrixState_MAC;
        end
        MatrixState_MAC : begin
          if(activeUsesFp8) begin
            `ifndef SYNTHESIS
              `ifdef FORMAL
                assert((! fpProductHasSpecial)); // MatrixEngine.scala:L452
              `else
                if(!(! fpProductHasSpecial)) begin
                  $display("FAILURE MatrixEngine FP8 compute expects finite inputs in v1"); // MatrixEngine.scala:L452
                  $finish;
                end
              `endif
            `endif
            fpAccReg <= ($signed(roundedFpAcc) + $signed(fpProduct));
          end else begin
            accReg <= ($signed(accReg) + $signed(product));
          end
          debugCounter <= {8'd0, kReg};
          if(when_MatrixEngine_l458) begin
            state <= MatrixState_ACC_WRITE;
          end else begin
            kReg <= (kReg + 3'b001);
            state <= MatrixState_AB_READ;
          end
        end
        MatrixState_ACC_WRITE : begin
          if(when_MatrixEngine_l476) begin
            activeOpcodeReg <= 5'h0;
            debugCounter <= 11'h0;
            state <= MatrixState_IDLE;
          end else begin
            if(when_MatrixEngine_l481) begin
              colReg <= 3'b000;
              rowReg <= (rowReg + 3'b001);
            end else begin
              colReg <= (colReg + 3'b001);
            end
            kReg <= 3'b000;
            if(activeAccumulates) begin
              state <= MatrixState_ACC_READ;
            end else begin
              if(activeUsesFp8) begin
                fpAccReg <= 72'h0;
              end else begin
                accReg <= 32'h0;
              end
              state <= MatrixState_AB_READ;
            end
          end
        end
        default : begin
        end
      endcase
    end
  end


endmodule
