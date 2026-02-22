// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : MemoryEngine

`timescale 1ns/1ps

module MemoryEngine (
  input  wire          io_loadSlots_0_valid,
  input  wire [2:0]    io_loadSlots_0_opcode,
  input  wire [10:0]   io_loadSlots_0_dest,
  input  wire [10:0]   io_loadSlots_0_addrReg,
  input  wire [2:0]    io_loadSlots_0_offset,
  input  wire [31:0]   io_loadSlots_0_immediate,
  input  wire          io_storeSlots_0_valid,
  input  wire [1:0]    io_storeSlots_0_opcode,
  input  wire [10:0]   io_storeSlots_0_addrReg,
  input  wire [10:0]   io_storeSlots_0_srcReg,
  input  wire          io_valid,
  input  wire [31:0]   io_loadAddrData_0,
  input  wire [31:0]   io_storeAddrData_0,
  input  wire [31:0]   io_storeSrcData_0,
  input  wire [31:0]   io_vstoreSrcData_0_0,
  input  wire [31:0]   io_vstoreSrcData_0_1,
  input  wire [31:0]   io_vstoreSrcData_0_2,
  input  wire [31:0]   io_vstoreSrcData_0_3,
  input  wire [31:0]   io_vstoreSrcData_0_4,
  input  wire [31:0]   io_vstoreSrcData_0_5,
  input  wire [31:0]   io_vstoreSrcData_0_6,
  input  wire [31:0]   io_vstoreSrcData_0_7,
  output reg           io_axiMaster_aw_valid,
  input  wire          io_axiMaster_aw_ready,
  output reg  [31:0]   io_axiMaster_aw_payload_addr,
  output wire [3:0]    io_axiMaster_aw_payload_id,
  output reg  [7:0]    io_axiMaster_aw_payload_len,
  output reg  [2:0]    io_axiMaster_aw_payload_size,
  output wire [1:0]    io_axiMaster_aw_payload_burst,
  output reg           io_axiMaster_w_valid,
  input  wire          io_axiMaster_w_ready,
  output reg  [511:0]  io_axiMaster_w_payload_data,
  output reg  [63:0]   io_axiMaster_w_payload_strb,
  output reg           io_axiMaster_w_payload_last,
  input  wire          io_axiMaster_b_valid,
  output reg           io_axiMaster_b_ready,
  input  wire [3:0]    io_axiMaster_b_payload_id,
  input  wire [1:0]    io_axiMaster_b_payload_resp,
  output reg           io_axiMaster_ar_valid,
  input  wire          io_axiMaster_ar_ready,
  output reg  [31:0]   io_axiMaster_ar_payload_addr,
  output wire [3:0]    io_axiMaster_ar_payload_id,
  output reg  [7:0]    io_axiMaster_ar_payload_len,
  output reg  [2:0]    io_axiMaster_ar_payload_size,
  output wire [1:0]    io_axiMaster_ar_payload_burst,
  input  wire          io_axiMaster_r_valid,
  output reg           io_axiMaster_r_ready,
  input  wire [511:0]  io_axiMaster_r_payload_data,
  input  wire [3:0]    io_axiMaster_r_payload_id,
  input  wire [1:0]    io_axiMaster_r_payload_resp,
  input  wire          io_axiMaster_r_payload_last,
  output reg           io_loadWriteReqs_0_valid,
  output reg  [10:0]   io_loadWriteReqs_0_payload_addr,
  output reg  [31:0]   io_loadWriteReqs_0_payload_data,
  output reg           io_constWriteReqs_0_valid,
  output reg  [10:0]   io_constWriteReqs_0_payload_addr,
  output reg  [31:0]   io_constWriteReqs_0_payload_data,
  output reg           io_vloadWriteReqs_0_0_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_0_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_0_payload_data,
  output reg           io_vloadWriteReqs_0_1_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_1_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_1_payload_data,
  output reg           io_vloadWriteReqs_0_2_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_2_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_2_payload_data,
  output reg           io_vloadWriteReqs_0_3_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_3_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_3_payload_data,
  output reg           io_vloadWriteReqs_0_4_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_4_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_4_payload_data,
  output reg           io_vloadWriteReqs_0_5_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_5_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_5_payload_data,
  output reg           io_vloadWriteReqs_0_6_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_6_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_6_payload_data,
  output reg           io_vloadWriteReqs_0_7_valid,
  output reg  [10:0]   io_vloadWriteReqs_0_7_payload_addr,
  output reg  [31:0]   io_vloadWriteReqs_0_7_payload_data,
  output reg           io_stall,
  input  wire          clk,
  input  wire          reset
);
  localparam MemState_IDLE = 3'd0;
  localparam MemState_LOAD_AR = 3'd1;
  localparam MemState_LOAD_R = 3'd2;
  localparam MemState_STORE_AW_W = 3'd3;
  localparam MemState_STORE_B = 3'd4;

  reg                 loadReqFifo_io_push_valid;
  reg        [31:0]   loadReqFifo_io_push_payload_axiAddr;
  reg        [10:0]   loadReqFifo_io_push_payload_destAddr;
  reg                 loadReqFifo_io_push_payload_isVector;
  reg        [0:0]    loadReqFifo_io_push_payload_slotIdx;
  reg        [3:0]    loadReqFifo_io_push_payload_wordOff;
  reg                 loadReqFifo_io_pop_ready;
  reg                 storeReqFifo_io_push_valid;
  reg        [31:0]   storeReqFifo_io_push_payload_axiAddr;
  reg        [511:0]  storeReqFifo_io_push_payload_wdata;
  reg        [63:0]   storeReqFifo_io_push_payload_wstrb;
  reg                 storeReqFifo_io_pop_ready;
  reg                 loadPendingFifo_io_push_valid;
  reg        [31:0]   loadPendingFifo_io_push_payload_axiAddr;
  reg        [10:0]   loadPendingFifo_io_push_payload_destAddr;
  reg                 loadPendingFifo_io_push_payload_isVector;
  reg        [0:0]    loadPendingFifo_io_push_payload_slotIdx;
  reg        [3:0]    loadPendingFifo_io_push_payload_wordOff;
  reg                 loadPendingFifo_io_pop_ready;
  wire                loadReqFifo_io_push_ready;
  wire                loadReqFifo_io_pop_valid;
  wire       [31:0]   loadReqFifo_io_pop_payload_axiAddr;
  wire       [10:0]   loadReqFifo_io_pop_payload_destAddr;
  wire                loadReqFifo_io_pop_payload_isVector;
  wire       [0:0]    loadReqFifo_io_pop_payload_slotIdx;
  wire       [3:0]    loadReqFifo_io_pop_payload_wordOff;
  wire       [3:0]    loadReqFifo_io_occupancy;
  wire       [3:0]    loadReqFifo_io_availability;
  wire                storeReqFifo_io_push_ready;
  wire                storeReqFifo_io_pop_valid;
  wire       [31:0]   storeReqFifo_io_pop_payload_axiAddr;
  wire       [511:0]  storeReqFifo_io_pop_payload_wdata;
  wire       [63:0]   storeReqFifo_io_pop_payload_wstrb;
  wire       [3:0]    storeReqFifo_io_occupancy;
  wire       [3:0]    storeReqFifo_io_availability;
  wire                loadPendingFifo_io_push_ready;
  wire                loadPendingFifo_io_pop_valid;
  wire       [31:0]   loadPendingFifo_io_pop_payload_axiAddr;
  wire       [10:0]   loadPendingFifo_io_pop_payload_destAddr;
  wire                loadPendingFifo_io_pop_payload_isVector;
  wire       [0:0]    loadPendingFifo_io_pop_payload_slotIdx;
  wire       [3:0]    loadPendingFifo_io_pop_payload_wordOff;
  wire       [3:0]    loadPendingFifo_io_occupancy;
  wire       [3:0]    loadPendingFifo_io_availability;
  wire       [33:0]   _zz__zz_io_push_payload_wordOff;
  wire       [29:0]   _zz_io_push_payload_wordOff_1;
  wire       [33:0]   _zz__zz_io_push_payload_axiAddr_4;
  wire       [31:0]   _zz__zz_io_push_payload_axiAddr_4_1;
  wire       [31:0]   _zz__zz_io_push_payload_axiAddr_4_2;
  wire       [10:0]   _zz_io_push_payload_destAddr;
  wire       [29:0]   _zz_io_push_payload_wordOff_2;
  wire       [33:0]   _zz__zz_io_push_payload_axiAddr_5;
  wire       [29:0]   _zz__zz_when_MemoryEngine_l262;
  wire       [2:0]    axiSizeVal;
  wire                when_MemoryEngine_l111;
  reg                 memProcessed;
  reg                 anyMemOp;
  wire                pendingLoads_0;
  wire                pendingStores_0;
  wire                when_MemoryEngine_l155;
  wire                when_MemoryEngine_l164;
  wire                anyMemOpNew;
  wire                when_MemoryEngine_l168;
  wire       [48:0]   _zz_io_push_payload_axiAddr;
  wire       [607:0]  _zz_io_push_payload_axiAddr_1;
  wire                when_MemoryEngine_l183;
  wire                when_MemoryEngine_l189;
  wire       [31:0]   _zz_io_push_payload_wordOff;
  wire       [31:0]   _zz_io_push_payload_axiAddr_2;
  wire       [31:0]   _zz_io_push_payload_axiAddr_3;
  wire       [31:0]   _zz_io_push_payload_axiAddr_4;
  wire       [31:0]   _zz_io_push_payload_axiAddr_5;
  wire       [3:0]    _zz_when_MemoryEngine_l262;
  reg        [511:0]  _zz_io_push_payload_wdata;
  reg        [63:0]   _zz_io_push_payload_wstrb;
  wire                when_MemoryEngine_l262;
  wire                when_MemoryEngine_l262_1;
  wire                when_MemoryEngine_l262_2;
  wire                when_MemoryEngine_l262_3;
  wire                when_MemoryEngine_l262_4;
  wire                when_MemoryEngine_l262_5;
  wire                when_MemoryEngine_l262_6;
  wire                when_MemoryEngine_l262_7;
  wire                when_MemoryEngine_l262_8;
  wire                when_MemoryEngine_l262_9;
  wire                when_MemoryEngine_l262_10;
  wire                when_MemoryEngine_l262_11;
  wire                when_MemoryEngine_l262_12;
  wire                when_MemoryEngine_l262_13;
  wire                when_MemoryEngine_l262_14;
  wire                when_MemoryEngine_l262_15;
  wire       [3:0]    _zz_when_MemoryEngine_l273;
  wire                when_MemoryEngine_l273;
  wire                when_MemoryEngine_l273_1;
  wire                when_MemoryEngine_l273_2;
  wire                when_MemoryEngine_l273_3;
  wire                when_MemoryEngine_l273_4;
  wire                when_MemoryEngine_l273_5;
  wire                when_MemoryEngine_l273_6;
  wire                when_MemoryEngine_l273_7;
  wire                when_MemoryEngine_l273_8;
  wire                when_MemoryEngine_l273_9;
  wire                when_MemoryEngine_l273_10;
  wire                when_MemoryEngine_l273_11;
  wire                when_MemoryEngine_l273_12;
  wire                when_MemoryEngine_l273_13;
  wire                when_MemoryEngine_l273_14;
  wire                when_MemoryEngine_l273_15;
  wire       [3:0]    _zz_when_MemoryEngine_l273_1;
  wire                when_MemoryEngine_l273_16;
  wire                when_MemoryEngine_l273_17;
  wire                when_MemoryEngine_l273_18;
  wire                when_MemoryEngine_l273_19;
  wire                when_MemoryEngine_l273_20;
  wire                when_MemoryEngine_l273_21;
  wire                when_MemoryEngine_l273_22;
  wire                when_MemoryEngine_l273_23;
  wire                when_MemoryEngine_l273_24;
  wire                when_MemoryEngine_l273_25;
  wire                when_MemoryEngine_l273_26;
  wire                when_MemoryEngine_l273_27;
  wire                when_MemoryEngine_l273_28;
  wire                when_MemoryEngine_l273_29;
  wire                when_MemoryEngine_l273_30;
  wire                when_MemoryEngine_l273_31;
  wire       [3:0]    _zz_when_MemoryEngine_l273_2;
  wire                when_MemoryEngine_l273_32;
  wire                when_MemoryEngine_l273_33;
  wire                when_MemoryEngine_l273_34;
  wire                when_MemoryEngine_l273_35;
  wire                when_MemoryEngine_l273_36;
  wire                when_MemoryEngine_l273_37;
  wire                when_MemoryEngine_l273_38;
  wire                when_MemoryEngine_l273_39;
  wire                when_MemoryEngine_l273_40;
  wire                when_MemoryEngine_l273_41;
  wire                when_MemoryEngine_l273_42;
  wire                when_MemoryEngine_l273_43;
  wire                when_MemoryEngine_l273_44;
  wire                when_MemoryEngine_l273_45;
  wire                when_MemoryEngine_l273_46;
  wire                when_MemoryEngine_l273_47;
  wire       [3:0]    _zz_when_MemoryEngine_l273_3;
  wire                when_MemoryEngine_l273_48;
  wire                when_MemoryEngine_l273_49;
  wire                when_MemoryEngine_l273_50;
  wire                when_MemoryEngine_l273_51;
  wire                when_MemoryEngine_l273_52;
  wire                when_MemoryEngine_l273_53;
  wire                when_MemoryEngine_l273_54;
  wire                when_MemoryEngine_l273_55;
  wire                when_MemoryEngine_l273_56;
  wire                when_MemoryEngine_l273_57;
  wire                when_MemoryEngine_l273_58;
  wire                when_MemoryEngine_l273_59;
  wire                when_MemoryEngine_l273_60;
  wire                when_MemoryEngine_l273_61;
  wire                when_MemoryEngine_l273_62;
  wire                when_MemoryEngine_l273_63;
  wire       [3:0]    _zz_when_MemoryEngine_l273_4;
  wire                when_MemoryEngine_l273_64;
  wire                when_MemoryEngine_l273_65;
  wire                when_MemoryEngine_l273_66;
  wire                when_MemoryEngine_l273_67;
  wire                when_MemoryEngine_l273_68;
  wire                when_MemoryEngine_l273_69;
  wire                when_MemoryEngine_l273_70;
  wire                when_MemoryEngine_l273_71;
  wire                when_MemoryEngine_l273_72;
  wire                when_MemoryEngine_l273_73;
  wire                when_MemoryEngine_l273_74;
  wire                when_MemoryEngine_l273_75;
  wire                when_MemoryEngine_l273_76;
  wire                when_MemoryEngine_l273_77;
  wire                when_MemoryEngine_l273_78;
  wire                when_MemoryEngine_l273_79;
  wire       [3:0]    _zz_when_MemoryEngine_l273_5;
  wire                when_MemoryEngine_l273_80;
  wire                when_MemoryEngine_l273_81;
  wire                when_MemoryEngine_l273_82;
  wire                when_MemoryEngine_l273_83;
  wire                when_MemoryEngine_l273_84;
  wire                when_MemoryEngine_l273_85;
  wire                when_MemoryEngine_l273_86;
  wire                when_MemoryEngine_l273_87;
  wire                when_MemoryEngine_l273_88;
  wire                when_MemoryEngine_l273_89;
  wire                when_MemoryEngine_l273_90;
  wire                when_MemoryEngine_l273_91;
  wire                when_MemoryEngine_l273_92;
  wire                when_MemoryEngine_l273_93;
  wire                when_MemoryEngine_l273_94;
  wire                when_MemoryEngine_l273_95;
  wire       [3:0]    _zz_when_MemoryEngine_l273_6;
  wire                when_MemoryEngine_l273_96;
  wire                when_MemoryEngine_l273_97;
  wire                when_MemoryEngine_l273_98;
  wire                when_MemoryEngine_l273_99;
  wire                when_MemoryEngine_l273_100;
  wire                when_MemoryEngine_l273_101;
  wire                when_MemoryEngine_l273_102;
  wire                when_MemoryEngine_l273_103;
  wire                when_MemoryEngine_l273_104;
  wire                when_MemoryEngine_l273_105;
  wire                when_MemoryEngine_l273_106;
  wire                when_MemoryEngine_l273_107;
  wire                when_MemoryEngine_l273_108;
  wire                when_MemoryEngine_l273_109;
  wire                when_MemoryEngine_l273_110;
  wire                when_MemoryEngine_l273_111;
  wire       [3:0]    _zz_when_MemoryEngine_l273_7;
  wire                when_MemoryEngine_l273_112;
  wire                when_MemoryEngine_l273_113;
  wire                when_MemoryEngine_l273_114;
  wire                when_MemoryEngine_l273_115;
  wire                when_MemoryEngine_l273_116;
  wire                when_MemoryEngine_l273_117;
  wire                when_MemoryEngine_l273_118;
  wire                when_MemoryEngine_l273_119;
  wire                when_MemoryEngine_l273_120;
  wire                when_MemoryEngine_l273_121;
  wire                when_MemoryEngine_l273_122;
  wire                when_MemoryEngine_l273_123;
  wire                when_MemoryEngine_l273_124;
  wire                when_MemoryEngine_l273_125;
  wire                when_MemoryEngine_l273_126;
  wire                when_MemoryEngine_l273_127;
  reg        [2:0]    state;
  reg        [31:0]   capLoadReq_axiAddr;
  reg        [10:0]   capLoadReq_destAddr;
  reg                 capLoadReq_isVector;
  reg        [0:0]    capLoadReq_slotIdx;
  reg        [3:0]    capLoadReq_wordOff;
  reg        [31:0]   capStoreReq_axiAddr;
  reg        [511:0]  capStoreReq_wdata;
  reg        [63:0]   capStoreReq_wstrb;
  reg                 awAccepted;
  reg                 wAccepted;
  wire       [48:0]   _zz_io_push_payload_axiAddr_6;
  wire                when_MemoryEngine_l351;
  wire                when_MemoryEngine_l352;
  wire                io_axiMaster_aw_fire;
  wire                io_axiMaster_w_fire;
  wire                when_MemoryEngine_l364;
  wire                when_MemoryEngine_l382;
  wire                when_MemoryEngine_l386;
  wire                when_MemoryEngine_l387;
  reg        [31:0]   _zz_io_loadWriteReqs_0_payload_data;
  wire                when_MemoryEngine_l392;
  wire                when_MemoryEngine_l392_1;
  wire                when_MemoryEngine_l392_2;
  wire                when_MemoryEngine_l392_3;
  wire                when_MemoryEngine_l392_4;
  wire                when_MemoryEngine_l392_5;
  wire                when_MemoryEngine_l392_6;
  wire                when_MemoryEngine_l392_7;
  wire                when_MemoryEngine_l392_8;
  wire                when_MemoryEngine_l392_9;
  wire                when_MemoryEngine_l392_10;
  wire                when_MemoryEngine_l392_11;
  wire                when_MemoryEngine_l392_12;
  wire                when_MemoryEngine_l392_13;
  wire                when_MemoryEngine_l392_14;
  wire                when_MemoryEngine_l392_15;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_0_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406;
  wire                when_MemoryEngine_l406;
  wire                when_MemoryEngine_l406_1;
  wire                when_MemoryEngine_l406_2;
  wire                when_MemoryEngine_l406_3;
  wire                when_MemoryEngine_l406_4;
  wire                when_MemoryEngine_l406_5;
  wire                when_MemoryEngine_l406_6;
  wire                when_MemoryEngine_l406_7;
  wire                when_MemoryEngine_l406_8;
  wire                when_MemoryEngine_l406_9;
  wire                when_MemoryEngine_l406_10;
  wire                when_MemoryEngine_l406_11;
  wire                when_MemoryEngine_l406_12;
  wire                when_MemoryEngine_l406_13;
  wire                when_MemoryEngine_l406_14;
  wire                when_MemoryEngine_l406_15;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_1_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406_1;
  wire                when_MemoryEngine_l406_16;
  wire                when_MemoryEngine_l406_17;
  wire                when_MemoryEngine_l406_18;
  wire                when_MemoryEngine_l406_19;
  wire                when_MemoryEngine_l406_20;
  wire                when_MemoryEngine_l406_21;
  wire                when_MemoryEngine_l406_22;
  wire                when_MemoryEngine_l406_23;
  wire                when_MemoryEngine_l406_24;
  wire                when_MemoryEngine_l406_25;
  wire                when_MemoryEngine_l406_26;
  wire                when_MemoryEngine_l406_27;
  wire                when_MemoryEngine_l406_28;
  wire                when_MemoryEngine_l406_29;
  wire                when_MemoryEngine_l406_30;
  wire                when_MemoryEngine_l406_31;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_2_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406_2;
  wire                when_MemoryEngine_l406_32;
  wire                when_MemoryEngine_l406_33;
  wire                when_MemoryEngine_l406_34;
  wire                when_MemoryEngine_l406_35;
  wire                when_MemoryEngine_l406_36;
  wire                when_MemoryEngine_l406_37;
  wire                when_MemoryEngine_l406_38;
  wire                when_MemoryEngine_l406_39;
  wire                when_MemoryEngine_l406_40;
  wire                when_MemoryEngine_l406_41;
  wire                when_MemoryEngine_l406_42;
  wire                when_MemoryEngine_l406_43;
  wire                when_MemoryEngine_l406_44;
  wire                when_MemoryEngine_l406_45;
  wire                when_MemoryEngine_l406_46;
  wire                when_MemoryEngine_l406_47;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_3_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406_3;
  wire                when_MemoryEngine_l406_48;
  wire                when_MemoryEngine_l406_49;
  wire                when_MemoryEngine_l406_50;
  wire                when_MemoryEngine_l406_51;
  wire                when_MemoryEngine_l406_52;
  wire                when_MemoryEngine_l406_53;
  wire                when_MemoryEngine_l406_54;
  wire                when_MemoryEngine_l406_55;
  wire                when_MemoryEngine_l406_56;
  wire                when_MemoryEngine_l406_57;
  wire                when_MemoryEngine_l406_58;
  wire                when_MemoryEngine_l406_59;
  wire                when_MemoryEngine_l406_60;
  wire                when_MemoryEngine_l406_61;
  wire                when_MemoryEngine_l406_62;
  wire                when_MemoryEngine_l406_63;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_4_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406_4;
  wire                when_MemoryEngine_l406_64;
  wire                when_MemoryEngine_l406_65;
  wire                when_MemoryEngine_l406_66;
  wire                when_MemoryEngine_l406_67;
  wire                when_MemoryEngine_l406_68;
  wire                when_MemoryEngine_l406_69;
  wire                when_MemoryEngine_l406_70;
  wire                when_MemoryEngine_l406_71;
  wire                when_MemoryEngine_l406_72;
  wire                when_MemoryEngine_l406_73;
  wire                when_MemoryEngine_l406_74;
  wire                when_MemoryEngine_l406_75;
  wire                when_MemoryEngine_l406_76;
  wire                when_MemoryEngine_l406_77;
  wire                when_MemoryEngine_l406_78;
  wire                when_MemoryEngine_l406_79;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_5_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406_5;
  wire                when_MemoryEngine_l406_80;
  wire                when_MemoryEngine_l406_81;
  wire                when_MemoryEngine_l406_82;
  wire                when_MemoryEngine_l406_83;
  wire                when_MemoryEngine_l406_84;
  wire                when_MemoryEngine_l406_85;
  wire                when_MemoryEngine_l406_86;
  wire                when_MemoryEngine_l406_87;
  wire                when_MemoryEngine_l406_88;
  wire                when_MemoryEngine_l406_89;
  wire                when_MemoryEngine_l406_90;
  wire                when_MemoryEngine_l406_91;
  wire                when_MemoryEngine_l406_92;
  wire                when_MemoryEngine_l406_93;
  wire                when_MemoryEngine_l406_94;
  wire                when_MemoryEngine_l406_95;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_6_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406_6;
  wire                when_MemoryEngine_l406_96;
  wire                when_MemoryEngine_l406_97;
  wire                when_MemoryEngine_l406_98;
  wire                when_MemoryEngine_l406_99;
  wire                when_MemoryEngine_l406_100;
  wire                when_MemoryEngine_l406_101;
  wire                when_MemoryEngine_l406_102;
  wire                when_MemoryEngine_l406_103;
  wire                when_MemoryEngine_l406_104;
  wire                when_MemoryEngine_l406_105;
  wire                when_MemoryEngine_l406_106;
  wire                when_MemoryEngine_l406_107;
  wire                when_MemoryEngine_l406_108;
  wire                when_MemoryEngine_l406_109;
  wire                when_MemoryEngine_l406_110;
  wire                when_MemoryEngine_l406_111;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_7_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l406_7;
  wire                when_MemoryEngine_l406_112;
  wire                when_MemoryEngine_l406_113;
  wire                when_MemoryEngine_l406_114;
  wire                when_MemoryEngine_l406_115;
  wire                when_MemoryEngine_l406_116;
  wire                when_MemoryEngine_l406_117;
  wire                when_MemoryEngine_l406_118;
  wire                when_MemoryEngine_l406_119;
  wire                when_MemoryEngine_l406_120;
  wire                when_MemoryEngine_l406_121;
  wire                when_MemoryEngine_l406_122;
  wire                when_MemoryEngine_l406_123;
  wire                when_MemoryEngine_l406_124;
  wire                when_MemoryEngine_l406_125;
  wire                when_MemoryEngine_l406_126;
  wire                when_MemoryEngine_l406_127;
  `ifndef SYNTHESIS
  reg [79:0] state_string;
  `endif


  assign _zz__zz_io_push_payload_wordOff = ({2'd0,io_loadAddrData_0} <<< 2'd2);
  assign _zz_io_push_payload_wordOff_1 = (_zz_io_push_payload_wordOff >>> 2'd2);
  assign _zz__zz_io_push_payload_axiAddr_4 = ({2'd0,_zz__zz_io_push_payload_axiAddr_4_1} <<< 2'd2);
  assign _zz__zz_io_push_payload_axiAddr_4_1 = (io_loadAddrData_0 + _zz__zz_io_push_payload_axiAddr_4_2);
  assign _zz__zz_io_push_payload_axiAddr_4_2 = {29'd0, io_loadSlots_0_offset};
  assign _zz_io_push_payload_destAddr = {8'd0, io_loadSlots_0_offset};
  assign _zz_io_push_payload_wordOff_2 = (_zz_io_push_payload_axiAddr_4 >>> 2'd2);
  assign _zz__zz_io_push_payload_axiAddr_5 = ({2'd0,io_storeAddrData_0} <<< 2'd2);
  assign _zz__zz_when_MemoryEngine_l262 = (_zz_io_push_payload_axiAddr_5 >>> 2'd2);
  StreamFifo loadReqFifo (
    .io_push_valid            (loadReqFifo_io_push_valid                 ), //i
    .io_push_ready            (loadReqFifo_io_push_ready                 ), //o
    .io_push_payload_axiAddr  (loadReqFifo_io_push_payload_axiAddr[31:0] ), //i
    .io_push_payload_destAddr (loadReqFifo_io_push_payload_destAddr[10:0]), //i
    .io_push_payload_isVector (loadReqFifo_io_push_payload_isVector      ), //i
    .io_push_payload_slotIdx  (loadReqFifo_io_push_payload_slotIdx       ), //i
    .io_push_payload_wordOff  (loadReqFifo_io_push_payload_wordOff[3:0]  ), //i
    .io_pop_valid             (loadReqFifo_io_pop_valid                  ), //o
    .io_pop_ready             (loadReqFifo_io_pop_ready                  ), //i
    .io_pop_payload_axiAddr   (loadReqFifo_io_pop_payload_axiAddr[31:0]  ), //o
    .io_pop_payload_destAddr  (loadReqFifo_io_pop_payload_destAddr[10:0] ), //o
    .io_pop_payload_isVector  (loadReqFifo_io_pop_payload_isVector       ), //o
    .io_pop_payload_slotIdx   (loadReqFifo_io_pop_payload_slotIdx        ), //o
    .io_pop_payload_wordOff   (loadReqFifo_io_pop_payload_wordOff[3:0]   ), //o
    .io_flush                 (1'b0                                      ), //i
    .io_occupancy             (loadReqFifo_io_occupancy[3:0]             ), //o
    .io_availability          (loadReqFifo_io_availability[3:0]          ), //o
    .clk                      (clk                                       ), //i
    .reset                    (reset                                     )  //i
  );
  StreamFifo_1 storeReqFifo (
    .io_push_valid           (storeReqFifo_io_push_valid                ), //i
    .io_push_ready           (storeReqFifo_io_push_ready                ), //o
    .io_push_payload_axiAddr (storeReqFifo_io_push_payload_axiAddr[31:0]), //i
    .io_push_payload_wdata   (storeReqFifo_io_push_payload_wdata[511:0] ), //i
    .io_push_payload_wstrb   (storeReqFifo_io_push_payload_wstrb[63:0]  ), //i
    .io_pop_valid            (storeReqFifo_io_pop_valid                 ), //o
    .io_pop_ready            (storeReqFifo_io_pop_ready                 ), //i
    .io_pop_payload_axiAddr  (storeReqFifo_io_pop_payload_axiAddr[31:0] ), //o
    .io_pop_payload_wdata    (storeReqFifo_io_pop_payload_wdata[511:0]  ), //o
    .io_pop_payload_wstrb    (storeReqFifo_io_pop_payload_wstrb[63:0]   ), //o
    .io_flush                (1'b0                                      ), //i
    .io_occupancy            (storeReqFifo_io_occupancy[3:0]            ), //o
    .io_availability         (storeReqFifo_io_availability[3:0]         ), //o
    .clk                     (clk                                       ), //i
    .reset                   (reset                                     )  //i
  );
  StreamFifo loadPendingFifo (
    .io_push_valid            (loadPendingFifo_io_push_valid                 ), //i
    .io_push_ready            (loadPendingFifo_io_push_ready                 ), //o
    .io_push_payload_axiAddr  (loadPendingFifo_io_push_payload_axiAddr[31:0] ), //i
    .io_push_payload_destAddr (loadPendingFifo_io_push_payload_destAddr[10:0]), //i
    .io_push_payload_isVector (loadPendingFifo_io_push_payload_isVector      ), //i
    .io_push_payload_slotIdx  (loadPendingFifo_io_push_payload_slotIdx       ), //i
    .io_push_payload_wordOff  (loadPendingFifo_io_push_payload_wordOff[3:0]  ), //i
    .io_pop_valid             (loadPendingFifo_io_pop_valid                  ), //o
    .io_pop_ready             (loadPendingFifo_io_pop_ready                  ), //i
    .io_pop_payload_axiAddr   (loadPendingFifo_io_pop_payload_axiAddr[31:0]  ), //o
    .io_pop_payload_destAddr  (loadPendingFifo_io_pop_payload_destAddr[10:0] ), //o
    .io_pop_payload_isVector  (loadPendingFifo_io_pop_payload_isVector       ), //o
    .io_pop_payload_slotIdx   (loadPendingFifo_io_pop_payload_slotIdx        ), //o
    .io_pop_payload_wordOff   (loadPendingFifo_io_pop_payload_wordOff[3:0]   ), //o
    .io_flush                 (1'b0                                          ), //i
    .io_occupancy             (loadPendingFifo_io_occupancy[3:0]             ), //o
    .io_availability          (loadPendingFifo_io_availability[3:0]          ), //o
    .clk                      (clk                                           ), //i
    .reset                    (reset                                         )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(state)
      MemState_IDLE : state_string = "IDLE      ";
      MemState_LOAD_AR : state_string = "LOAD_AR   ";
      MemState_LOAD_R : state_string = "LOAD_R    ";
      MemState_STORE_AW_W : state_string = "STORE_AW_W";
      MemState_STORE_B : state_string = "STORE_B   ";
      default : state_string = "??????????";
    endcase
  end
  `endif

  assign axiSizeVal = 3'b110;
  always @(*) begin
    io_stall = 1'b0;
    if(anyMemOpNew) begin
      if(when_MemoryEngine_l183) begin
        io_stall = 1'b1;
      end
    end
  end

  always @(*) begin
    io_loadWriteReqs_0_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(when_MemoryEngine_l387) begin
          io_loadWriteReqs_0_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_loadWriteReqs_0_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(when_MemoryEngine_l387) begin
          io_loadWriteReqs_0_payload_addr = loadPendingFifo_io_pop_payload_destAddr;
        end
      end
    end
  end

  always @(*) begin
    io_loadWriteReqs_0_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(when_MemoryEngine_l387) begin
          io_loadWriteReqs_0_payload_data = _zz_io_loadWriteReqs_0_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_constWriteReqs_0_valid = 1'b0;
    if(when_MemoryEngine_l111) begin
      io_constWriteReqs_0_valid = 1'b1;
    end
  end

  always @(*) begin
    io_constWriteReqs_0_payload_addr = 11'h0;
    if(when_MemoryEngine_l111) begin
      io_constWriteReqs_0_payload_addr = io_loadSlots_0_dest;
    end
  end

  always @(*) begin
    io_constWriteReqs_0_payload_data = 32'h0;
    if(when_MemoryEngine_l111) begin
      io_constWriteReqs_0_payload_data = io_loadSlots_0_immediate;
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_0_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_0_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_0_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_0_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h0);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_0_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_0_payload_data = _zz_io_vloadWriteReqs_0_0_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_1_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_1_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_1_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_1_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h001);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_1_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_1_payload_data = _zz_io_vloadWriteReqs_0_1_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_2_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_2_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_2_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_2_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h002);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_2_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_2_payload_data = _zz_io_vloadWriteReqs_0_2_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_3_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_3_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_3_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_3_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h003);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_3_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_3_payload_data = _zz_io_vloadWriteReqs_0_3_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_4_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_4_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_4_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_4_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h004);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_4_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_4_payload_data = _zz_io_vloadWriteReqs_0_4_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_5_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_5_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_5_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_5_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h005);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_5_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_5_payload_data = _zz_io_vloadWriteReqs_0_5_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_6_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_6_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_6_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_6_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h006);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_6_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_6_payload_data = _zz_io_vloadWriteReqs_0_6_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_7_valid = 1'b0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_7_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_7_payload_addr = 11'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_7_payload_addr = (loadPendingFifo_io_pop_payload_destAddr + 11'h007);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_7_payload_data = 32'h0;
    if(when_MemoryEngine_l382) begin
      if(when_MemoryEngine_l386) begin
        if(!when_MemoryEngine_l387) begin
          io_vloadWriteReqs_0_7_payload_data = _zz_io_vloadWriteReqs_0_7_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_axiMaster_aw_valid = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        if(when_MemoryEngine_l351) begin
          io_axiMaster_aw_valid = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_aw_payload_addr = 32'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        io_axiMaster_aw_payload_addr = capStoreReq_axiAddr;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_aw_payload_len = 8'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        io_axiMaster_aw_payload_len = 8'h0;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_aw_payload_size = axiSizeVal;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        io_axiMaster_aw_payload_size = axiSizeVal;
      end
      default : begin
      end
    endcase
  end

  assign io_axiMaster_aw_payload_burst = 2'b01;
  assign io_axiMaster_aw_payload_id = 4'b0000;
  always @(*) begin
    io_axiMaster_w_valid = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        if(when_MemoryEngine_l352) begin
          io_axiMaster_w_valid = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_w_payload_data = 512'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        io_axiMaster_w_payload_data = capStoreReq_wdata;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_w_payload_strb = 64'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        io_axiMaster_w_payload_strb = capStoreReq_wstrb;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_w_payload_last = 1'b1;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
        io_axiMaster_w_payload_last = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_valid = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        io_axiMaster_ar_valid = 1'b1;
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_payload_addr = 32'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        io_axiMaster_ar_payload_addr = capLoadReq_axiAddr;
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_payload_len = 8'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        io_axiMaster_ar_payload_len = 8'h0;
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_payload_size = axiSizeVal;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        io_axiMaster_ar_payload_size = axiSizeVal;
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  assign io_axiMaster_ar_payload_burst = 2'b01;
  assign io_axiMaster_ar_payload_id = 4'b0000;
  always @(*) begin
    io_axiMaster_r_ready = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
        io_axiMaster_r_ready = 1'b1;
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_b_ready = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
        io_axiMaster_b_ready = 1'b1;
      end
    endcase
  end

  assign when_MemoryEngine_l111 = ((io_loadSlots_0_valid && io_valid) && (io_loadSlots_0_opcode == 3'b100));
  always @(*) begin
    anyMemOp = 1'b0;
    if(when_MemoryEngine_l155) begin
      anyMemOp = 1'b1;
    end
    if(when_MemoryEngine_l164) begin
      anyMemOp = 1'b1;
    end
  end

  assign when_MemoryEngine_l155 = ((io_loadSlots_0_valid && io_valid) && (((io_loadSlots_0_opcode == 3'b001) || (io_loadSlots_0_opcode == 3'b010)) || (io_loadSlots_0_opcode == 3'b011)));
  assign pendingLoads_0 = when_MemoryEngine_l155;
  assign when_MemoryEngine_l164 = ((io_storeSlots_0_valid && io_valid) && ((io_storeSlots_0_opcode == 2'b01) || (io_storeSlots_0_opcode == 2'b10)));
  assign pendingStores_0 = when_MemoryEngine_l164;
  assign anyMemOpNew = (anyMemOp && (! memProcessed));
  assign when_MemoryEngine_l168 = (! anyMemOp);
  always @(*) begin
    loadReqFifo_io_push_valid = 1'b0;
    if(when_MemoryEngine_l189) begin
      if(pendingLoads_0) begin
        case(io_loadSlots_0_opcode)
          3'b001 : begin
            loadReqFifo_io_push_valid = 1'b1;
          end
          3'b010 : begin
            loadReqFifo_io_push_valid = 1'b1;
          end
          3'b011 : begin
            loadReqFifo_io_push_valid = 1'b1;
          end
          default : begin
          end
        endcase
      end
    end
  end

  assign _zz_io_push_payload_axiAddr = 49'h0;
  always @(*) begin
    loadReqFifo_io_push_payload_axiAddr = _zz_io_push_payload_axiAddr[31 : 0];
    if(when_MemoryEngine_l189) begin
      if(pendingLoads_0) begin
        case(io_loadSlots_0_opcode)
          3'b001 : begin
            loadReqFifo_io_push_payload_axiAddr = _zz_io_push_payload_axiAddr_3;
          end
          3'b010 : begin
            loadReqFifo_io_push_payload_axiAddr = (_zz_io_push_payload_axiAddr_4 & (~ _zz_io_push_payload_axiAddr_2));
          end
          3'b011 : begin
            loadReqFifo_io_push_payload_axiAddr = _zz_io_push_payload_axiAddr_3;
          end
          default : begin
          end
        endcase
      end
    end
  end

  always @(*) begin
    loadReqFifo_io_push_payload_destAddr = _zz_io_push_payload_axiAddr[42 : 32];
    if(when_MemoryEngine_l189) begin
      if(pendingLoads_0) begin
        case(io_loadSlots_0_opcode)
          3'b001 : begin
            loadReqFifo_io_push_payload_destAddr = io_loadSlots_0_dest;
          end
          3'b010 : begin
            loadReqFifo_io_push_payload_destAddr = (io_loadSlots_0_dest + _zz_io_push_payload_destAddr);
          end
          3'b011 : begin
            loadReqFifo_io_push_payload_destAddr = io_loadSlots_0_dest;
          end
          default : begin
          end
        endcase
      end
    end
  end

  always @(*) begin
    loadReqFifo_io_push_payload_isVector = _zz_io_push_payload_axiAddr[43];
    if(when_MemoryEngine_l189) begin
      if(pendingLoads_0) begin
        loadReqFifo_io_push_payload_isVector = (io_loadSlots_0_opcode == 3'b011);
      end
    end
  end

  always @(*) begin
    loadReqFifo_io_push_payload_slotIdx = _zz_io_push_payload_axiAddr[44 : 44];
    if(when_MemoryEngine_l189) begin
      if(pendingLoads_0) begin
        loadReqFifo_io_push_payload_slotIdx = 1'b0;
      end
    end
  end

  always @(*) begin
    loadReqFifo_io_push_payload_wordOff = _zz_io_push_payload_axiAddr[48 : 45];
    if(when_MemoryEngine_l189) begin
      if(pendingLoads_0) begin
        loadReqFifo_io_push_payload_wordOff = _zz_io_push_payload_wordOff_1[3:0];
        case(io_loadSlots_0_opcode)
          3'b010 : begin
            loadReqFifo_io_push_payload_wordOff = _zz_io_push_payload_wordOff_2[3:0];
          end
          default : begin
          end
        endcase
      end
    end
  end

  always @(*) begin
    storeReqFifo_io_push_valid = 1'b0;
    if(when_MemoryEngine_l189) begin
      if(pendingStores_0) begin
        storeReqFifo_io_push_valid = 1'b1;
      end
    end
  end

  assign _zz_io_push_payload_axiAddr_1 = 608'h0;
  always @(*) begin
    storeReqFifo_io_push_payload_axiAddr = _zz_io_push_payload_axiAddr_1[31 : 0];
    if(when_MemoryEngine_l189) begin
      if(pendingStores_0) begin
        storeReqFifo_io_push_payload_axiAddr = (_zz_io_push_payload_axiAddr_5 & (~ 32'h0000003f));
      end
    end
  end

  always @(*) begin
    storeReqFifo_io_push_payload_wdata = _zz_io_push_payload_axiAddr_1[543 : 32];
    if(when_MemoryEngine_l189) begin
      if(pendingStores_0) begin
        storeReqFifo_io_push_payload_wdata = _zz_io_push_payload_wdata;
      end
    end
  end

  always @(*) begin
    storeReqFifo_io_push_payload_wstrb = _zz_io_push_payload_axiAddr_1[607 : 544];
    if(when_MemoryEngine_l189) begin
      if(pendingStores_0) begin
        storeReqFifo_io_push_payload_wstrb = _zz_io_push_payload_wstrb;
      end
    end
  end

  assign when_MemoryEngine_l183 = (((|pendingLoads_0) && (! loadReqFifo_io_push_ready)) || ((|pendingStores_0) && (! storeReqFifo_io_push_ready)));
  assign when_MemoryEngine_l189 = (anyMemOpNew && (! io_stall));
  assign _zz_io_push_payload_wordOff = _zz__zz_io_push_payload_wordOff[31:0];
  assign _zz_io_push_payload_axiAddr_2 = 32'h0000003f;
  assign _zz_io_push_payload_axiAddr_3 = (_zz_io_push_payload_wordOff & (~ _zz_io_push_payload_axiAddr_2));
  assign _zz_io_push_payload_axiAddr_4 = _zz__zz_io_push_payload_axiAddr_4[31:0];
  assign _zz_io_push_payload_axiAddr_5 = _zz__zz_io_push_payload_axiAddr_5[31:0];
  assign _zz_when_MemoryEngine_l262 = _zz__zz_when_MemoryEngine_l262[3:0];
  always @(*) begin
    _zz_io_push_payload_wdata = 512'h0;
    case(io_storeSlots_0_opcode)
      2'b01 : begin
        if(when_MemoryEngine_l262) begin
          _zz_io_push_payload_wdata[31 : 0] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_1) begin
          _zz_io_push_payload_wdata[63 : 32] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_2) begin
          _zz_io_push_payload_wdata[95 : 64] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_3) begin
          _zz_io_push_payload_wdata[127 : 96] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_4) begin
          _zz_io_push_payload_wdata[159 : 128] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_5) begin
          _zz_io_push_payload_wdata[191 : 160] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_6) begin
          _zz_io_push_payload_wdata[223 : 192] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_7) begin
          _zz_io_push_payload_wdata[255 : 224] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_8) begin
          _zz_io_push_payload_wdata[287 : 256] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_9) begin
          _zz_io_push_payload_wdata[319 : 288] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_10) begin
          _zz_io_push_payload_wdata[351 : 320] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_11) begin
          _zz_io_push_payload_wdata[383 : 352] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_12) begin
          _zz_io_push_payload_wdata[415 : 384] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_13) begin
          _zz_io_push_payload_wdata[447 : 416] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_14) begin
          _zz_io_push_payload_wdata[479 : 448] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l262_15) begin
          _zz_io_push_payload_wdata[511 : 480] = io_storeSrcData_0;
        end
      end
      2'b10 : begin
        if(when_MemoryEngine_l273) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_1) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_2) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_3) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_4) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_5) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_6) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_7) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_8) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_9) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_10) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_11) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_12) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_13) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_14) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_15) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l273_16) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_17) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_18) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_19) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_20) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_21) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_22) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_23) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_24) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_25) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_26) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_27) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_28) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_29) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_30) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_31) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l273_32) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_33) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_34) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_35) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_36) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_37) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_38) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_39) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_40) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_41) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_42) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_43) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_44) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_45) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_46) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_47) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l273_48) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_49) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_50) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_51) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_52) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_53) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_54) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_55) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_56) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_57) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_58) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_59) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_60) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_61) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_62) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_63) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l273_64) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_65) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_66) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_67) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_68) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_69) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_70) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_71) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_72) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_73) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_74) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_75) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_76) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_77) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_78) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_79) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l273_80) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_81) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_82) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_83) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_84) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_85) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_86) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_87) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_88) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_89) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_90) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_91) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_92) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_93) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_94) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_95) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l273_96) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_97) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_98) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_99) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_100) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_101) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_102) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_103) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_104) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_105) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_106) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_107) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_108) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_109) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_110) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_111) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l273_112) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_113) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_114) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_115) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_116) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_117) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_118) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_119) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_120) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_121) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_122) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_123) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_124) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_125) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_126) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l273_127) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_7;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    _zz_io_push_payload_wstrb = 64'h0;
    case(io_storeSlots_0_opcode)
      2'b01 : begin
        if(when_MemoryEngine_l262) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l262_1) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l262_2) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l262_3) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l262_4) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l262_5) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l262_6) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l262_7) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l262_8) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l262_9) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l262_10) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l262_11) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l262_12) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l262_13) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l262_14) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l262_15) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
      end
      2'b10 : begin
        if(when_MemoryEngine_l273) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_1) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_2) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_3) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_4) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_5) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_6) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_7) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_8) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_9) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_10) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_11) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_12) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_13) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_14) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_15) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l273_16) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_17) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_18) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_19) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_20) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_21) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_22) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_23) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_24) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_25) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_26) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_27) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_28) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_29) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_30) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_31) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l273_32) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_33) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_34) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_35) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_36) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_37) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_38) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_39) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_40) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_41) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_42) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_43) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_44) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_45) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_46) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_47) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l273_48) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_49) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_50) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_51) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_52) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_53) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_54) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_55) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_56) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_57) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_58) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_59) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_60) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_61) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_62) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_63) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l273_64) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_65) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_66) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_67) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_68) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_69) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_70) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_71) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_72) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_73) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_74) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_75) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_76) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_77) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_78) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_79) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l273_80) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_81) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_82) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_83) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_84) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_85) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_86) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_87) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_88) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_89) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_90) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_91) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_92) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_93) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_94) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_95) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l273_96) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_97) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_98) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_99) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_100) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_101) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_102) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_103) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_104) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_105) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_106) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_107) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_108) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_109) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_110) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_111) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l273_112) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l273_113) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l273_114) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l273_115) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l273_116) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l273_117) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l273_118) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l273_119) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l273_120) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l273_121) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l273_122) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l273_123) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l273_124) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l273_125) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l273_126) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l273_127) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_MemoryEngine_l262 = (_zz_when_MemoryEngine_l262 == 4'b0000);
  assign when_MemoryEngine_l262_1 = (_zz_when_MemoryEngine_l262 == 4'b0001);
  assign when_MemoryEngine_l262_2 = (_zz_when_MemoryEngine_l262 == 4'b0010);
  assign when_MemoryEngine_l262_3 = (_zz_when_MemoryEngine_l262 == 4'b0011);
  assign when_MemoryEngine_l262_4 = (_zz_when_MemoryEngine_l262 == 4'b0100);
  assign when_MemoryEngine_l262_5 = (_zz_when_MemoryEngine_l262 == 4'b0101);
  assign when_MemoryEngine_l262_6 = (_zz_when_MemoryEngine_l262 == 4'b0110);
  assign when_MemoryEngine_l262_7 = (_zz_when_MemoryEngine_l262 == 4'b0111);
  assign when_MemoryEngine_l262_8 = (_zz_when_MemoryEngine_l262 == 4'b1000);
  assign when_MemoryEngine_l262_9 = (_zz_when_MemoryEngine_l262 == 4'b1001);
  assign when_MemoryEngine_l262_10 = (_zz_when_MemoryEngine_l262 == 4'b1010);
  assign when_MemoryEngine_l262_11 = (_zz_when_MemoryEngine_l262 == 4'b1011);
  assign when_MemoryEngine_l262_12 = (_zz_when_MemoryEngine_l262 == 4'b1100);
  assign when_MemoryEngine_l262_13 = (_zz_when_MemoryEngine_l262 == 4'b1101);
  assign when_MemoryEngine_l262_14 = (_zz_when_MemoryEngine_l262 == 4'b1110);
  assign when_MemoryEngine_l262_15 = (_zz_when_MemoryEngine_l262 == 4'b1111);
  assign _zz_when_MemoryEngine_l273 = (_zz_when_MemoryEngine_l262 + 4'b0000);
  assign when_MemoryEngine_l273 = (_zz_when_MemoryEngine_l273 == 4'b0000);
  assign when_MemoryEngine_l273_1 = (_zz_when_MemoryEngine_l273 == 4'b0001);
  assign when_MemoryEngine_l273_2 = (_zz_when_MemoryEngine_l273 == 4'b0010);
  assign when_MemoryEngine_l273_3 = (_zz_when_MemoryEngine_l273 == 4'b0011);
  assign when_MemoryEngine_l273_4 = (_zz_when_MemoryEngine_l273 == 4'b0100);
  assign when_MemoryEngine_l273_5 = (_zz_when_MemoryEngine_l273 == 4'b0101);
  assign when_MemoryEngine_l273_6 = (_zz_when_MemoryEngine_l273 == 4'b0110);
  assign when_MemoryEngine_l273_7 = (_zz_when_MemoryEngine_l273 == 4'b0111);
  assign when_MemoryEngine_l273_8 = (_zz_when_MemoryEngine_l273 == 4'b1000);
  assign when_MemoryEngine_l273_9 = (_zz_when_MemoryEngine_l273 == 4'b1001);
  assign when_MemoryEngine_l273_10 = (_zz_when_MemoryEngine_l273 == 4'b1010);
  assign when_MemoryEngine_l273_11 = (_zz_when_MemoryEngine_l273 == 4'b1011);
  assign when_MemoryEngine_l273_12 = (_zz_when_MemoryEngine_l273 == 4'b1100);
  assign when_MemoryEngine_l273_13 = (_zz_when_MemoryEngine_l273 == 4'b1101);
  assign when_MemoryEngine_l273_14 = (_zz_when_MemoryEngine_l273 == 4'b1110);
  assign when_MemoryEngine_l273_15 = (_zz_when_MemoryEngine_l273 == 4'b1111);
  assign _zz_when_MemoryEngine_l273_1 = (_zz_when_MemoryEngine_l262 + 4'b0001);
  assign when_MemoryEngine_l273_16 = (_zz_when_MemoryEngine_l273_1 == 4'b0000);
  assign when_MemoryEngine_l273_17 = (_zz_when_MemoryEngine_l273_1 == 4'b0001);
  assign when_MemoryEngine_l273_18 = (_zz_when_MemoryEngine_l273_1 == 4'b0010);
  assign when_MemoryEngine_l273_19 = (_zz_when_MemoryEngine_l273_1 == 4'b0011);
  assign when_MemoryEngine_l273_20 = (_zz_when_MemoryEngine_l273_1 == 4'b0100);
  assign when_MemoryEngine_l273_21 = (_zz_when_MemoryEngine_l273_1 == 4'b0101);
  assign when_MemoryEngine_l273_22 = (_zz_when_MemoryEngine_l273_1 == 4'b0110);
  assign when_MemoryEngine_l273_23 = (_zz_when_MemoryEngine_l273_1 == 4'b0111);
  assign when_MemoryEngine_l273_24 = (_zz_when_MemoryEngine_l273_1 == 4'b1000);
  assign when_MemoryEngine_l273_25 = (_zz_when_MemoryEngine_l273_1 == 4'b1001);
  assign when_MemoryEngine_l273_26 = (_zz_when_MemoryEngine_l273_1 == 4'b1010);
  assign when_MemoryEngine_l273_27 = (_zz_when_MemoryEngine_l273_1 == 4'b1011);
  assign when_MemoryEngine_l273_28 = (_zz_when_MemoryEngine_l273_1 == 4'b1100);
  assign when_MemoryEngine_l273_29 = (_zz_when_MemoryEngine_l273_1 == 4'b1101);
  assign when_MemoryEngine_l273_30 = (_zz_when_MemoryEngine_l273_1 == 4'b1110);
  assign when_MemoryEngine_l273_31 = (_zz_when_MemoryEngine_l273_1 == 4'b1111);
  assign _zz_when_MemoryEngine_l273_2 = (_zz_when_MemoryEngine_l262 + 4'b0010);
  assign when_MemoryEngine_l273_32 = (_zz_when_MemoryEngine_l273_2 == 4'b0000);
  assign when_MemoryEngine_l273_33 = (_zz_when_MemoryEngine_l273_2 == 4'b0001);
  assign when_MemoryEngine_l273_34 = (_zz_when_MemoryEngine_l273_2 == 4'b0010);
  assign when_MemoryEngine_l273_35 = (_zz_when_MemoryEngine_l273_2 == 4'b0011);
  assign when_MemoryEngine_l273_36 = (_zz_when_MemoryEngine_l273_2 == 4'b0100);
  assign when_MemoryEngine_l273_37 = (_zz_when_MemoryEngine_l273_2 == 4'b0101);
  assign when_MemoryEngine_l273_38 = (_zz_when_MemoryEngine_l273_2 == 4'b0110);
  assign when_MemoryEngine_l273_39 = (_zz_when_MemoryEngine_l273_2 == 4'b0111);
  assign when_MemoryEngine_l273_40 = (_zz_when_MemoryEngine_l273_2 == 4'b1000);
  assign when_MemoryEngine_l273_41 = (_zz_when_MemoryEngine_l273_2 == 4'b1001);
  assign when_MemoryEngine_l273_42 = (_zz_when_MemoryEngine_l273_2 == 4'b1010);
  assign when_MemoryEngine_l273_43 = (_zz_when_MemoryEngine_l273_2 == 4'b1011);
  assign when_MemoryEngine_l273_44 = (_zz_when_MemoryEngine_l273_2 == 4'b1100);
  assign when_MemoryEngine_l273_45 = (_zz_when_MemoryEngine_l273_2 == 4'b1101);
  assign when_MemoryEngine_l273_46 = (_zz_when_MemoryEngine_l273_2 == 4'b1110);
  assign when_MemoryEngine_l273_47 = (_zz_when_MemoryEngine_l273_2 == 4'b1111);
  assign _zz_when_MemoryEngine_l273_3 = (_zz_when_MemoryEngine_l262 + 4'b0011);
  assign when_MemoryEngine_l273_48 = (_zz_when_MemoryEngine_l273_3 == 4'b0000);
  assign when_MemoryEngine_l273_49 = (_zz_when_MemoryEngine_l273_3 == 4'b0001);
  assign when_MemoryEngine_l273_50 = (_zz_when_MemoryEngine_l273_3 == 4'b0010);
  assign when_MemoryEngine_l273_51 = (_zz_when_MemoryEngine_l273_3 == 4'b0011);
  assign when_MemoryEngine_l273_52 = (_zz_when_MemoryEngine_l273_3 == 4'b0100);
  assign when_MemoryEngine_l273_53 = (_zz_when_MemoryEngine_l273_3 == 4'b0101);
  assign when_MemoryEngine_l273_54 = (_zz_when_MemoryEngine_l273_3 == 4'b0110);
  assign when_MemoryEngine_l273_55 = (_zz_when_MemoryEngine_l273_3 == 4'b0111);
  assign when_MemoryEngine_l273_56 = (_zz_when_MemoryEngine_l273_3 == 4'b1000);
  assign when_MemoryEngine_l273_57 = (_zz_when_MemoryEngine_l273_3 == 4'b1001);
  assign when_MemoryEngine_l273_58 = (_zz_when_MemoryEngine_l273_3 == 4'b1010);
  assign when_MemoryEngine_l273_59 = (_zz_when_MemoryEngine_l273_3 == 4'b1011);
  assign when_MemoryEngine_l273_60 = (_zz_when_MemoryEngine_l273_3 == 4'b1100);
  assign when_MemoryEngine_l273_61 = (_zz_when_MemoryEngine_l273_3 == 4'b1101);
  assign when_MemoryEngine_l273_62 = (_zz_when_MemoryEngine_l273_3 == 4'b1110);
  assign when_MemoryEngine_l273_63 = (_zz_when_MemoryEngine_l273_3 == 4'b1111);
  assign _zz_when_MemoryEngine_l273_4 = (_zz_when_MemoryEngine_l262 + 4'b0100);
  assign when_MemoryEngine_l273_64 = (_zz_when_MemoryEngine_l273_4 == 4'b0000);
  assign when_MemoryEngine_l273_65 = (_zz_when_MemoryEngine_l273_4 == 4'b0001);
  assign when_MemoryEngine_l273_66 = (_zz_when_MemoryEngine_l273_4 == 4'b0010);
  assign when_MemoryEngine_l273_67 = (_zz_when_MemoryEngine_l273_4 == 4'b0011);
  assign when_MemoryEngine_l273_68 = (_zz_when_MemoryEngine_l273_4 == 4'b0100);
  assign when_MemoryEngine_l273_69 = (_zz_when_MemoryEngine_l273_4 == 4'b0101);
  assign when_MemoryEngine_l273_70 = (_zz_when_MemoryEngine_l273_4 == 4'b0110);
  assign when_MemoryEngine_l273_71 = (_zz_when_MemoryEngine_l273_4 == 4'b0111);
  assign when_MemoryEngine_l273_72 = (_zz_when_MemoryEngine_l273_4 == 4'b1000);
  assign when_MemoryEngine_l273_73 = (_zz_when_MemoryEngine_l273_4 == 4'b1001);
  assign when_MemoryEngine_l273_74 = (_zz_when_MemoryEngine_l273_4 == 4'b1010);
  assign when_MemoryEngine_l273_75 = (_zz_when_MemoryEngine_l273_4 == 4'b1011);
  assign when_MemoryEngine_l273_76 = (_zz_when_MemoryEngine_l273_4 == 4'b1100);
  assign when_MemoryEngine_l273_77 = (_zz_when_MemoryEngine_l273_4 == 4'b1101);
  assign when_MemoryEngine_l273_78 = (_zz_when_MemoryEngine_l273_4 == 4'b1110);
  assign when_MemoryEngine_l273_79 = (_zz_when_MemoryEngine_l273_4 == 4'b1111);
  assign _zz_when_MemoryEngine_l273_5 = (_zz_when_MemoryEngine_l262 + 4'b0101);
  assign when_MemoryEngine_l273_80 = (_zz_when_MemoryEngine_l273_5 == 4'b0000);
  assign when_MemoryEngine_l273_81 = (_zz_when_MemoryEngine_l273_5 == 4'b0001);
  assign when_MemoryEngine_l273_82 = (_zz_when_MemoryEngine_l273_5 == 4'b0010);
  assign when_MemoryEngine_l273_83 = (_zz_when_MemoryEngine_l273_5 == 4'b0011);
  assign when_MemoryEngine_l273_84 = (_zz_when_MemoryEngine_l273_5 == 4'b0100);
  assign when_MemoryEngine_l273_85 = (_zz_when_MemoryEngine_l273_5 == 4'b0101);
  assign when_MemoryEngine_l273_86 = (_zz_when_MemoryEngine_l273_5 == 4'b0110);
  assign when_MemoryEngine_l273_87 = (_zz_when_MemoryEngine_l273_5 == 4'b0111);
  assign when_MemoryEngine_l273_88 = (_zz_when_MemoryEngine_l273_5 == 4'b1000);
  assign when_MemoryEngine_l273_89 = (_zz_when_MemoryEngine_l273_5 == 4'b1001);
  assign when_MemoryEngine_l273_90 = (_zz_when_MemoryEngine_l273_5 == 4'b1010);
  assign when_MemoryEngine_l273_91 = (_zz_when_MemoryEngine_l273_5 == 4'b1011);
  assign when_MemoryEngine_l273_92 = (_zz_when_MemoryEngine_l273_5 == 4'b1100);
  assign when_MemoryEngine_l273_93 = (_zz_when_MemoryEngine_l273_5 == 4'b1101);
  assign when_MemoryEngine_l273_94 = (_zz_when_MemoryEngine_l273_5 == 4'b1110);
  assign when_MemoryEngine_l273_95 = (_zz_when_MemoryEngine_l273_5 == 4'b1111);
  assign _zz_when_MemoryEngine_l273_6 = (_zz_when_MemoryEngine_l262 + 4'b0110);
  assign when_MemoryEngine_l273_96 = (_zz_when_MemoryEngine_l273_6 == 4'b0000);
  assign when_MemoryEngine_l273_97 = (_zz_when_MemoryEngine_l273_6 == 4'b0001);
  assign when_MemoryEngine_l273_98 = (_zz_when_MemoryEngine_l273_6 == 4'b0010);
  assign when_MemoryEngine_l273_99 = (_zz_when_MemoryEngine_l273_6 == 4'b0011);
  assign when_MemoryEngine_l273_100 = (_zz_when_MemoryEngine_l273_6 == 4'b0100);
  assign when_MemoryEngine_l273_101 = (_zz_when_MemoryEngine_l273_6 == 4'b0101);
  assign when_MemoryEngine_l273_102 = (_zz_when_MemoryEngine_l273_6 == 4'b0110);
  assign when_MemoryEngine_l273_103 = (_zz_when_MemoryEngine_l273_6 == 4'b0111);
  assign when_MemoryEngine_l273_104 = (_zz_when_MemoryEngine_l273_6 == 4'b1000);
  assign when_MemoryEngine_l273_105 = (_zz_when_MemoryEngine_l273_6 == 4'b1001);
  assign when_MemoryEngine_l273_106 = (_zz_when_MemoryEngine_l273_6 == 4'b1010);
  assign when_MemoryEngine_l273_107 = (_zz_when_MemoryEngine_l273_6 == 4'b1011);
  assign when_MemoryEngine_l273_108 = (_zz_when_MemoryEngine_l273_6 == 4'b1100);
  assign when_MemoryEngine_l273_109 = (_zz_when_MemoryEngine_l273_6 == 4'b1101);
  assign when_MemoryEngine_l273_110 = (_zz_when_MemoryEngine_l273_6 == 4'b1110);
  assign when_MemoryEngine_l273_111 = (_zz_when_MemoryEngine_l273_6 == 4'b1111);
  assign _zz_when_MemoryEngine_l273_7 = (_zz_when_MemoryEngine_l262 + 4'b0111);
  assign when_MemoryEngine_l273_112 = (_zz_when_MemoryEngine_l273_7 == 4'b0000);
  assign when_MemoryEngine_l273_113 = (_zz_when_MemoryEngine_l273_7 == 4'b0001);
  assign when_MemoryEngine_l273_114 = (_zz_when_MemoryEngine_l273_7 == 4'b0010);
  assign when_MemoryEngine_l273_115 = (_zz_when_MemoryEngine_l273_7 == 4'b0011);
  assign when_MemoryEngine_l273_116 = (_zz_when_MemoryEngine_l273_7 == 4'b0100);
  assign when_MemoryEngine_l273_117 = (_zz_when_MemoryEngine_l273_7 == 4'b0101);
  assign when_MemoryEngine_l273_118 = (_zz_when_MemoryEngine_l273_7 == 4'b0110);
  assign when_MemoryEngine_l273_119 = (_zz_when_MemoryEngine_l273_7 == 4'b0111);
  assign when_MemoryEngine_l273_120 = (_zz_when_MemoryEngine_l273_7 == 4'b1000);
  assign when_MemoryEngine_l273_121 = (_zz_when_MemoryEngine_l273_7 == 4'b1001);
  assign when_MemoryEngine_l273_122 = (_zz_when_MemoryEngine_l273_7 == 4'b1010);
  assign when_MemoryEngine_l273_123 = (_zz_when_MemoryEngine_l273_7 == 4'b1011);
  assign when_MemoryEngine_l273_124 = (_zz_when_MemoryEngine_l273_7 == 4'b1100);
  assign when_MemoryEngine_l273_125 = (_zz_when_MemoryEngine_l273_7 == 4'b1101);
  assign when_MemoryEngine_l273_126 = (_zz_when_MemoryEngine_l273_7 == 4'b1110);
  assign when_MemoryEngine_l273_127 = (_zz_when_MemoryEngine_l273_7 == 4'b1111);
  always @(*) begin
    loadReqFifo_io_pop_ready = 1'b0;
    case(state)
      MemState_IDLE : begin
        if(loadReqFifo_io_pop_valid) begin
          loadReqFifo_io_pop_ready = 1'b1;
        end
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    storeReqFifo_io_pop_ready = 1'b0;
    case(state)
      MemState_IDLE : begin
        if(!loadReqFifo_io_pop_valid) begin
          if(storeReqFifo_io_pop_valid) begin
            storeReqFifo_io_pop_ready = 1'b1;
          end
        end
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    loadPendingFifo_io_push_valid = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        if(io_axiMaster_ar_ready) begin
          loadPendingFifo_io_push_valid = 1'b1;
        end
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  assign _zz_io_push_payload_axiAddr_6 = 49'h0;
  always @(*) begin
    loadPendingFifo_io_push_payload_axiAddr = _zz_io_push_payload_axiAddr_6[31 : 0];
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        if(io_axiMaster_ar_ready) begin
          loadPendingFifo_io_push_payload_axiAddr = capLoadReq_axiAddr;
        end
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    loadPendingFifo_io_push_payload_destAddr = _zz_io_push_payload_axiAddr_6[42 : 32];
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        if(io_axiMaster_ar_ready) begin
          loadPendingFifo_io_push_payload_destAddr = capLoadReq_destAddr;
        end
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    loadPendingFifo_io_push_payload_isVector = _zz_io_push_payload_axiAddr_6[43];
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        if(io_axiMaster_ar_ready) begin
          loadPendingFifo_io_push_payload_isVector = capLoadReq_isVector;
        end
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    loadPendingFifo_io_push_payload_slotIdx = _zz_io_push_payload_axiAddr_6[44 : 44];
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        if(io_axiMaster_ar_ready) begin
          loadPendingFifo_io_push_payload_slotIdx = capLoadReq_slotIdx;
        end
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    loadPendingFifo_io_push_payload_wordOff = _zz_io_push_payload_axiAddr_6[48 : 45];
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
        if(io_axiMaster_ar_ready) begin
          loadPendingFifo_io_push_payload_wordOff = capLoadReq_wordOff;
        end
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    loadPendingFifo_io_pop_ready = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
        if(io_axiMaster_r_valid) begin
          loadPendingFifo_io_pop_ready = 1'b1;
        end
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end

  assign when_MemoryEngine_l351 = (! awAccepted);
  assign when_MemoryEngine_l352 = (! wAccepted);
  assign io_axiMaster_aw_fire = (io_axiMaster_aw_valid && io_axiMaster_aw_ready);
  assign io_axiMaster_w_fire = (io_axiMaster_w_valid && io_axiMaster_w_ready);
  assign when_MemoryEngine_l364 = ((io_axiMaster_aw_fire || awAccepted) && (io_axiMaster_w_fire || wAccepted));
  assign when_MemoryEngine_l382 = ((io_axiMaster_r_valid && io_axiMaster_r_ready) && loadPendingFifo_io_pop_valid);
  assign when_MemoryEngine_l386 = (loadPendingFifo_io_pop_payload_slotIdx == 1'b0);
  assign when_MemoryEngine_l387 = (! loadPendingFifo_io_pop_payload_isVector);
  always @(*) begin
    _zz_io_loadWriteReqs_0_payload_data = 32'h0;
    if(when_MemoryEngine_l392) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l392_1) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l392_2) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l392_3) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l392_4) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l392_5) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l392_6) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l392_7) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l392_8) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l392_9) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l392_10) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l392_11) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l392_12) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l392_13) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l392_14) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l392_15) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign when_MemoryEngine_l392 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0000);
  assign when_MemoryEngine_l392_1 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0001);
  assign when_MemoryEngine_l392_2 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0010);
  assign when_MemoryEngine_l392_3 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0011);
  assign when_MemoryEngine_l392_4 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0100);
  assign when_MemoryEngine_l392_5 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0101);
  assign when_MemoryEngine_l392_6 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0110);
  assign when_MemoryEngine_l392_7 = (loadPendingFifo_io_pop_payload_wordOff == 4'b0111);
  assign when_MemoryEngine_l392_8 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1000);
  assign when_MemoryEngine_l392_9 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1001);
  assign when_MemoryEngine_l392_10 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1010);
  assign when_MemoryEngine_l392_11 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1011);
  assign when_MemoryEngine_l392_12 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1100);
  assign when_MemoryEngine_l392_13 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1101);
  assign when_MemoryEngine_l392_14 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1110);
  assign when_MemoryEngine_l392_15 = (loadPendingFifo_io_pop_payload_wordOff == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_0_payload_data = 32'h0;
    if(when_MemoryEngine_l406) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_1) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_2) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_3) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_4) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_5) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_6) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_7) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_8) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_9) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_10) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_11) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_12) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_13) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_14) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_15) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0000);
  assign when_MemoryEngine_l406 = (_zz_when_MemoryEngine_l406 == 4'b0000);
  assign when_MemoryEngine_l406_1 = (_zz_when_MemoryEngine_l406 == 4'b0001);
  assign when_MemoryEngine_l406_2 = (_zz_when_MemoryEngine_l406 == 4'b0010);
  assign when_MemoryEngine_l406_3 = (_zz_when_MemoryEngine_l406 == 4'b0011);
  assign when_MemoryEngine_l406_4 = (_zz_when_MemoryEngine_l406 == 4'b0100);
  assign when_MemoryEngine_l406_5 = (_zz_when_MemoryEngine_l406 == 4'b0101);
  assign when_MemoryEngine_l406_6 = (_zz_when_MemoryEngine_l406 == 4'b0110);
  assign when_MemoryEngine_l406_7 = (_zz_when_MemoryEngine_l406 == 4'b0111);
  assign when_MemoryEngine_l406_8 = (_zz_when_MemoryEngine_l406 == 4'b1000);
  assign when_MemoryEngine_l406_9 = (_zz_when_MemoryEngine_l406 == 4'b1001);
  assign when_MemoryEngine_l406_10 = (_zz_when_MemoryEngine_l406 == 4'b1010);
  assign when_MemoryEngine_l406_11 = (_zz_when_MemoryEngine_l406 == 4'b1011);
  assign when_MemoryEngine_l406_12 = (_zz_when_MemoryEngine_l406 == 4'b1100);
  assign when_MemoryEngine_l406_13 = (_zz_when_MemoryEngine_l406 == 4'b1101);
  assign when_MemoryEngine_l406_14 = (_zz_when_MemoryEngine_l406 == 4'b1110);
  assign when_MemoryEngine_l406_15 = (_zz_when_MemoryEngine_l406 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_1_payload_data = 32'h0;
    if(when_MemoryEngine_l406_16) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_17) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_18) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_19) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_20) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_21) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_22) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_23) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_24) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_25) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_26) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_27) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_28) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_29) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_30) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_31) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406_1 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0001);
  assign when_MemoryEngine_l406_16 = (_zz_when_MemoryEngine_l406_1 == 4'b0000);
  assign when_MemoryEngine_l406_17 = (_zz_when_MemoryEngine_l406_1 == 4'b0001);
  assign when_MemoryEngine_l406_18 = (_zz_when_MemoryEngine_l406_1 == 4'b0010);
  assign when_MemoryEngine_l406_19 = (_zz_when_MemoryEngine_l406_1 == 4'b0011);
  assign when_MemoryEngine_l406_20 = (_zz_when_MemoryEngine_l406_1 == 4'b0100);
  assign when_MemoryEngine_l406_21 = (_zz_when_MemoryEngine_l406_1 == 4'b0101);
  assign when_MemoryEngine_l406_22 = (_zz_when_MemoryEngine_l406_1 == 4'b0110);
  assign when_MemoryEngine_l406_23 = (_zz_when_MemoryEngine_l406_1 == 4'b0111);
  assign when_MemoryEngine_l406_24 = (_zz_when_MemoryEngine_l406_1 == 4'b1000);
  assign when_MemoryEngine_l406_25 = (_zz_when_MemoryEngine_l406_1 == 4'b1001);
  assign when_MemoryEngine_l406_26 = (_zz_when_MemoryEngine_l406_1 == 4'b1010);
  assign when_MemoryEngine_l406_27 = (_zz_when_MemoryEngine_l406_1 == 4'b1011);
  assign when_MemoryEngine_l406_28 = (_zz_when_MemoryEngine_l406_1 == 4'b1100);
  assign when_MemoryEngine_l406_29 = (_zz_when_MemoryEngine_l406_1 == 4'b1101);
  assign when_MemoryEngine_l406_30 = (_zz_when_MemoryEngine_l406_1 == 4'b1110);
  assign when_MemoryEngine_l406_31 = (_zz_when_MemoryEngine_l406_1 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_2_payload_data = 32'h0;
    if(when_MemoryEngine_l406_32) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_33) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_34) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_35) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_36) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_37) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_38) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_39) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_40) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_41) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_42) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_43) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_44) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_45) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_46) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_47) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406_2 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0010);
  assign when_MemoryEngine_l406_32 = (_zz_when_MemoryEngine_l406_2 == 4'b0000);
  assign when_MemoryEngine_l406_33 = (_zz_when_MemoryEngine_l406_2 == 4'b0001);
  assign when_MemoryEngine_l406_34 = (_zz_when_MemoryEngine_l406_2 == 4'b0010);
  assign when_MemoryEngine_l406_35 = (_zz_when_MemoryEngine_l406_2 == 4'b0011);
  assign when_MemoryEngine_l406_36 = (_zz_when_MemoryEngine_l406_2 == 4'b0100);
  assign when_MemoryEngine_l406_37 = (_zz_when_MemoryEngine_l406_2 == 4'b0101);
  assign when_MemoryEngine_l406_38 = (_zz_when_MemoryEngine_l406_2 == 4'b0110);
  assign when_MemoryEngine_l406_39 = (_zz_when_MemoryEngine_l406_2 == 4'b0111);
  assign when_MemoryEngine_l406_40 = (_zz_when_MemoryEngine_l406_2 == 4'b1000);
  assign when_MemoryEngine_l406_41 = (_zz_when_MemoryEngine_l406_2 == 4'b1001);
  assign when_MemoryEngine_l406_42 = (_zz_when_MemoryEngine_l406_2 == 4'b1010);
  assign when_MemoryEngine_l406_43 = (_zz_when_MemoryEngine_l406_2 == 4'b1011);
  assign when_MemoryEngine_l406_44 = (_zz_when_MemoryEngine_l406_2 == 4'b1100);
  assign when_MemoryEngine_l406_45 = (_zz_when_MemoryEngine_l406_2 == 4'b1101);
  assign when_MemoryEngine_l406_46 = (_zz_when_MemoryEngine_l406_2 == 4'b1110);
  assign when_MemoryEngine_l406_47 = (_zz_when_MemoryEngine_l406_2 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_3_payload_data = 32'h0;
    if(when_MemoryEngine_l406_48) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_49) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_50) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_51) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_52) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_53) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_54) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_55) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_56) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_57) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_58) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_59) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_60) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_61) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_62) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_63) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406_3 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0011);
  assign when_MemoryEngine_l406_48 = (_zz_when_MemoryEngine_l406_3 == 4'b0000);
  assign when_MemoryEngine_l406_49 = (_zz_when_MemoryEngine_l406_3 == 4'b0001);
  assign when_MemoryEngine_l406_50 = (_zz_when_MemoryEngine_l406_3 == 4'b0010);
  assign when_MemoryEngine_l406_51 = (_zz_when_MemoryEngine_l406_3 == 4'b0011);
  assign when_MemoryEngine_l406_52 = (_zz_when_MemoryEngine_l406_3 == 4'b0100);
  assign when_MemoryEngine_l406_53 = (_zz_when_MemoryEngine_l406_3 == 4'b0101);
  assign when_MemoryEngine_l406_54 = (_zz_when_MemoryEngine_l406_3 == 4'b0110);
  assign when_MemoryEngine_l406_55 = (_zz_when_MemoryEngine_l406_3 == 4'b0111);
  assign when_MemoryEngine_l406_56 = (_zz_when_MemoryEngine_l406_3 == 4'b1000);
  assign when_MemoryEngine_l406_57 = (_zz_when_MemoryEngine_l406_3 == 4'b1001);
  assign when_MemoryEngine_l406_58 = (_zz_when_MemoryEngine_l406_3 == 4'b1010);
  assign when_MemoryEngine_l406_59 = (_zz_when_MemoryEngine_l406_3 == 4'b1011);
  assign when_MemoryEngine_l406_60 = (_zz_when_MemoryEngine_l406_3 == 4'b1100);
  assign when_MemoryEngine_l406_61 = (_zz_when_MemoryEngine_l406_3 == 4'b1101);
  assign when_MemoryEngine_l406_62 = (_zz_when_MemoryEngine_l406_3 == 4'b1110);
  assign when_MemoryEngine_l406_63 = (_zz_when_MemoryEngine_l406_3 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_4_payload_data = 32'h0;
    if(when_MemoryEngine_l406_64) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_65) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_66) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_67) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_68) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_69) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_70) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_71) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_72) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_73) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_74) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_75) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_76) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_77) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_78) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_79) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406_4 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0100);
  assign when_MemoryEngine_l406_64 = (_zz_when_MemoryEngine_l406_4 == 4'b0000);
  assign when_MemoryEngine_l406_65 = (_zz_when_MemoryEngine_l406_4 == 4'b0001);
  assign when_MemoryEngine_l406_66 = (_zz_when_MemoryEngine_l406_4 == 4'b0010);
  assign when_MemoryEngine_l406_67 = (_zz_when_MemoryEngine_l406_4 == 4'b0011);
  assign when_MemoryEngine_l406_68 = (_zz_when_MemoryEngine_l406_4 == 4'b0100);
  assign when_MemoryEngine_l406_69 = (_zz_when_MemoryEngine_l406_4 == 4'b0101);
  assign when_MemoryEngine_l406_70 = (_zz_when_MemoryEngine_l406_4 == 4'b0110);
  assign when_MemoryEngine_l406_71 = (_zz_when_MemoryEngine_l406_4 == 4'b0111);
  assign when_MemoryEngine_l406_72 = (_zz_when_MemoryEngine_l406_4 == 4'b1000);
  assign when_MemoryEngine_l406_73 = (_zz_when_MemoryEngine_l406_4 == 4'b1001);
  assign when_MemoryEngine_l406_74 = (_zz_when_MemoryEngine_l406_4 == 4'b1010);
  assign when_MemoryEngine_l406_75 = (_zz_when_MemoryEngine_l406_4 == 4'b1011);
  assign when_MemoryEngine_l406_76 = (_zz_when_MemoryEngine_l406_4 == 4'b1100);
  assign when_MemoryEngine_l406_77 = (_zz_when_MemoryEngine_l406_4 == 4'b1101);
  assign when_MemoryEngine_l406_78 = (_zz_when_MemoryEngine_l406_4 == 4'b1110);
  assign when_MemoryEngine_l406_79 = (_zz_when_MemoryEngine_l406_4 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_5_payload_data = 32'h0;
    if(when_MemoryEngine_l406_80) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_81) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_82) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_83) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_84) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_85) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_86) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_87) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_88) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_89) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_90) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_91) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_92) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_93) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_94) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_95) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406_5 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0101);
  assign when_MemoryEngine_l406_80 = (_zz_when_MemoryEngine_l406_5 == 4'b0000);
  assign when_MemoryEngine_l406_81 = (_zz_when_MemoryEngine_l406_5 == 4'b0001);
  assign when_MemoryEngine_l406_82 = (_zz_when_MemoryEngine_l406_5 == 4'b0010);
  assign when_MemoryEngine_l406_83 = (_zz_when_MemoryEngine_l406_5 == 4'b0011);
  assign when_MemoryEngine_l406_84 = (_zz_when_MemoryEngine_l406_5 == 4'b0100);
  assign when_MemoryEngine_l406_85 = (_zz_when_MemoryEngine_l406_5 == 4'b0101);
  assign when_MemoryEngine_l406_86 = (_zz_when_MemoryEngine_l406_5 == 4'b0110);
  assign when_MemoryEngine_l406_87 = (_zz_when_MemoryEngine_l406_5 == 4'b0111);
  assign when_MemoryEngine_l406_88 = (_zz_when_MemoryEngine_l406_5 == 4'b1000);
  assign when_MemoryEngine_l406_89 = (_zz_when_MemoryEngine_l406_5 == 4'b1001);
  assign when_MemoryEngine_l406_90 = (_zz_when_MemoryEngine_l406_5 == 4'b1010);
  assign when_MemoryEngine_l406_91 = (_zz_when_MemoryEngine_l406_5 == 4'b1011);
  assign when_MemoryEngine_l406_92 = (_zz_when_MemoryEngine_l406_5 == 4'b1100);
  assign when_MemoryEngine_l406_93 = (_zz_when_MemoryEngine_l406_5 == 4'b1101);
  assign when_MemoryEngine_l406_94 = (_zz_when_MemoryEngine_l406_5 == 4'b1110);
  assign when_MemoryEngine_l406_95 = (_zz_when_MemoryEngine_l406_5 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_6_payload_data = 32'h0;
    if(when_MemoryEngine_l406_96) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_97) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_98) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_99) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_100) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_101) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_102) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_103) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_104) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_105) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_106) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_107) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_108) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_109) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_110) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_111) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406_6 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0110);
  assign when_MemoryEngine_l406_96 = (_zz_when_MemoryEngine_l406_6 == 4'b0000);
  assign when_MemoryEngine_l406_97 = (_zz_when_MemoryEngine_l406_6 == 4'b0001);
  assign when_MemoryEngine_l406_98 = (_zz_when_MemoryEngine_l406_6 == 4'b0010);
  assign when_MemoryEngine_l406_99 = (_zz_when_MemoryEngine_l406_6 == 4'b0011);
  assign when_MemoryEngine_l406_100 = (_zz_when_MemoryEngine_l406_6 == 4'b0100);
  assign when_MemoryEngine_l406_101 = (_zz_when_MemoryEngine_l406_6 == 4'b0101);
  assign when_MemoryEngine_l406_102 = (_zz_when_MemoryEngine_l406_6 == 4'b0110);
  assign when_MemoryEngine_l406_103 = (_zz_when_MemoryEngine_l406_6 == 4'b0111);
  assign when_MemoryEngine_l406_104 = (_zz_when_MemoryEngine_l406_6 == 4'b1000);
  assign when_MemoryEngine_l406_105 = (_zz_when_MemoryEngine_l406_6 == 4'b1001);
  assign when_MemoryEngine_l406_106 = (_zz_when_MemoryEngine_l406_6 == 4'b1010);
  assign when_MemoryEngine_l406_107 = (_zz_when_MemoryEngine_l406_6 == 4'b1011);
  assign when_MemoryEngine_l406_108 = (_zz_when_MemoryEngine_l406_6 == 4'b1100);
  assign when_MemoryEngine_l406_109 = (_zz_when_MemoryEngine_l406_6 == 4'b1101);
  assign when_MemoryEngine_l406_110 = (_zz_when_MemoryEngine_l406_6 == 4'b1110);
  assign when_MemoryEngine_l406_111 = (_zz_when_MemoryEngine_l406_6 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_7_payload_data = 32'h0;
    if(when_MemoryEngine_l406_112) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l406_113) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l406_114) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l406_115) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l406_116) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l406_117) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l406_118) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l406_119) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l406_120) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l406_121) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l406_122) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l406_123) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l406_124) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l406_125) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l406_126) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l406_127) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l406_7 = (loadPendingFifo_io_pop_payload_wordOff + 4'b0111);
  assign when_MemoryEngine_l406_112 = (_zz_when_MemoryEngine_l406_7 == 4'b0000);
  assign when_MemoryEngine_l406_113 = (_zz_when_MemoryEngine_l406_7 == 4'b0001);
  assign when_MemoryEngine_l406_114 = (_zz_when_MemoryEngine_l406_7 == 4'b0010);
  assign when_MemoryEngine_l406_115 = (_zz_when_MemoryEngine_l406_7 == 4'b0011);
  assign when_MemoryEngine_l406_116 = (_zz_when_MemoryEngine_l406_7 == 4'b0100);
  assign when_MemoryEngine_l406_117 = (_zz_when_MemoryEngine_l406_7 == 4'b0101);
  assign when_MemoryEngine_l406_118 = (_zz_when_MemoryEngine_l406_7 == 4'b0110);
  assign when_MemoryEngine_l406_119 = (_zz_when_MemoryEngine_l406_7 == 4'b0111);
  assign when_MemoryEngine_l406_120 = (_zz_when_MemoryEngine_l406_7 == 4'b1000);
  assign when_MemoryEngine_l406_121 = (_zz_when_MemoryEngine_l406_7 == 4'b1001);
  assign when_MemoryEngine_l406_122 = (_zz_when_MemoryEngine_l406_7 == 4'b1010);
  assign when_MemoryEngine_l406_123 = (_zz_when_MemoryEngine_l406_7 == 4'b1011);
  assign when_MemoryEngine_l406_124 = (_zz_when_MemoryEngine_l406_7 == 4'b1100);
  assign when_MemoryEngine_l406_125 = (_zz_when_MemoryEngine_l406_7 == 4'b1101);
  assign when_MemoryEngine_l406_126 = (_zz_when_MemoryEngine_l406_7 == 4'b1110);
  assign when_MemoryEngine_l406_127 = (_zz_when_MemoryEngine_l406_7 == 4'b1111);
  always @(posedge clk) begin
    if(reset) begin
      memProcessed <= 1'b0;
      state <= MemState_IDLE;
      awAccepted <= 1'b0;
      wAccepted <= 1'b0;
    end else begin
      if(when_MemoryEngine_l168) begin
        memProcessed <= 1'b0;
      end
      if(when_MemoryEngine_l189) begin
        memProcessed <= 1'b1;
      end
      case(state)
        MemState_IDLE : begin
          if(loadReqFifo_io_pop_valid) begin
            state <= MemState_LOAD_AR;
          end else begin
            if(storeReqFifo_io_pop_valid) begin
              awAccepted <= 1'b0;
              wAccepted <= 1'b0;
              state <= MemState_STORE_AW_W;
            end
          end
        end
        MemState_LOAD_AR : begin
          if(io_axiMaster_ar_ready) begin
            state <= MemState_LOAD_R;
          end
        end
        MemState_LOAD_R : begin
          if(io_axiMaster_r_valid) begin
            state <= MemState_IDLE;
          end
        end
        MemState_STORE_AW_W : begin
          if(io_axiMaster_aw_fire) begin
            awAccepted <= 1'b1;
          end
          if(io_axiMaster_w_fire) begin
            wAccepted <= 1'b1;
          end
          if(when_MemoryEngine_l364) begin
            awAccepted <= 1'b0;
            wAccepted <= 1'b0;
            state <= MemState_STORE_B;
          end
        end
        default : begin
          if(io_axiMaster_b_valid) begin
            state <= MemState_IDLE;
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    case(state)
      MemState_IDLE : begin
        if(loadReqFifo_io_pop_valid) begin
          capLoadReq_axiAddr <= loadReqFifo_io_pop_payload_axiAddr;
          capLoadReq_destAddr <= loadReqFifo_io_pop_payload_destAddr;
          capLoadReq_isVector <= loadReqFifo_io_pop_payload_isVector;
          capLoadReq_slotIdx <= loadReqFifo_io_pop_payload_slotIdx;
          capLoadReq_wordOff <= loadReqFifo_io_pop_payload_wordOff;
        end else begin
          if(storeReqFifo_io_pop_valid) begin
            capStoreReq_axiAddr <= storeReqFifo_io_pop_payload_axiAddr;
            capStoreReq_wdata <= storeReqFifo_io_pop_payload_wdata;
            capStoreReq_wstrb <= storeReqFifo_io_pop_payload_wstrb;
          end
        end
      end
      MemState_LOAD_AR : begin
      end
      MemState_LOAD_R : begin
      end
      MemState_STORE_AW_W : begin
      end
      default : begin
      end
    endcase
  end


endmodule

//StreamFifo_2 replaced by StreamFifo

module StreamFifo_1 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [31:0]   io_push_payload_axiAddr,
  input  wire [511:0]  io_push_payload_wdata,
  input  wire [63:0]   io_push_payload_wstrb,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [31:0]   io_pop_payload_axiAddr,
  output wire [511:0]  io_pop_payload_wdata,
  output wire [63:0]   io_pop_payload_wstrb,
  input  wire          io_flush,
  output wire [3:0]    io_occupancy,
  output wire [3:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [607:0]  logic_ram_spinal_port1;
  wire       [607:0]  _zz_logic_ram_port;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [3:0]    logic_ptr_push;
  reg        [3:0]    logic_ptr_pop;
  wire       [3:0]    logic_ptr_occupancy;
  wire       [3:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1248;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [2:0]    logic_push_onRam_write_payload_address;
  wire       [31:0]   logic_push_onRam_write_payload_data_axiAddr;
  wire       [511:0]  logic_push_onRam_write_payload_data_wdata;
  wire       [63:0]   logic_push_onRam_write_payload_data_wstrb;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [2:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [2:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [2:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l375;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [2:0]    logic_pop_sync_readPort_cmd_payload;
  wire       [31:0]   logic_pop_sync_readPort_rsp_axiAddr;
  wire       [511:0]  logic_pop_sync_readPort_rsp_wdata;
  wire       [63:0]   logic_pop_sync_readPort_rsp_wstrb;
  wire       [607:0]  _zz_logic_pop_sync_readPort_rsp_axiAddr;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire       [31:0]   logic_pop_sync_readArbitation_translated_payload_axiAddr;
  wire       [511:0]  logic_pop_sync_readArbitation_translated_payload_wdata;
  wire       [63:0]   logic_pop_sync_readArbitation_translated_payload_wstrb;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [3:0]    logic_pop_sync_popReg;
  reg [607:0] logic_ram [0:7];

  assign _zz_logic_ram_port = {logic_push_onRam_write_payload_data_wstrb,{logic_push_onRam_write_payload_data_wdata,logic_push_onRam_write_payload_data_axiAddr}};
  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= _zz_logic_ram_port;
    end
  end

  always @(posedge clk) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1248 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 4'b1000) == 4'b0000);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[2:0];
  assign logic_push_onRam_write_payload_data_axiAddr = io_push_payload_axiAddr;
  assign logic_push_onRam_write_payload_data_wdata = io_push_payload_wdata;
  assign logic_push_onRam_write_payload_data_wstrb = io_push_payload_wstrb;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[2:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l375) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign _zz_logic_pop_sync_readPort_rsp_axiAddr = logic_ram_spinal_port1;
  assign logic_pop_sync_readPort_rsp_axiAddr = _zz_logic_pop_sync_readPort_rsp_axiAddr[31 : 0];
  assign logic_pop_sync_readPort_rsp_wdata = _zz_logic_pop_sync_readPort_rsp_axiAddr[543 : 32];
  assign logic_pop_sync_readPort_rsp_wstrb = _zz_logic_pop_sync_readPort_rsp_axiAddr[607 : 544];
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload_axiAddr = logic_pop_sync_readPort_rsp_axiAddr;
  assign logic_pop_sync_readArbitation_translated_payload_wdata = logic_pop_sync_readPort_rsp_wdata;
  assign logic_pop_sync_readArbitation_translated_payload_wstrb = logic_pop_sync_readPort_rsp_wstrb;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload_axiAddr = logic_pop_sync_readArbitation_translated_payload_axiAddr;
  assign io_pop_payload_wdata = logic_pop_sync_readArbitation_translated_payload_wdata;
  assign io_pop_payload_wstrb = logic_pop_sync_readArbitation_translated_payload_wstrb;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (4'b1000 - logic_ptr_occupancy);
  always @(posedge clk) begin
    if(reset) begin
      logic_ptr_push <= 4'b0000;
      logic_ptr_pop <= 4'b0000;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 4'b0000;
    end else begin
      if(when_Stream_l1248) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 4'b0001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 4'b0001);
      end
      if(io_flush) begin
        logic_ptr_push <= 4'b0000;
        logic_ptr_pop <= 4'b0000;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 4'b0000;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

module StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [31:0]   io_push_payload_axiAddr,
  input  wire [10:0]   io_push_payload_destAddr,
  input  wire          io_push_payload_isVector,
  input  wire [0:0]    io_push_payload_slotIdx,
  input  wire [3:0]    io_push_payload_wordOff,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [31:0]   io_pop_payload_axiAddr,
  output wire [10:0]   io_pop_payload_destAddr,
  output wire          io_pop_payload_isVector,
  output wire [0:0]    io_pop_payload_slotIdx,
  output wire [3:0]    io_pop_payload_wordOff,
  input  wire          io_flush,
  output wire [3:0]    io_occupancy,
  output wire [3:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [48:0]   logic_ram_spinal_port1;
  wire       [48:0]   _zz_logic_ram_port;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [3:0]    logic_ptr_push;
  reg        [3:0]    logic_ptr_pop;
  wire       [3:0]    logic_ptr_occupancy;
  wire       [3:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1248;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [2:0]    logic_push_onRam_write_payload_address;
  wire       [31:0]   logic_push_onRam_write_payload_data_axiAddr;
  wire       [10:0]   logic_push_onRam_write_payload_data_destAddr;
  wire                logic_push_onRam_write_payload_data_isVector;
  wire       [0:0]    logic_push_onRam_write_payload_data_slotIdx;
  wire       [3:0]    logic_push_onRam_write_payload_data_wordOff;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [2:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [2:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [2:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l375;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [2:0]    logic_pop_sync_readPort_cmd_payload;
  wire       [31:0]   logic_pop_sync_readPort_rsp_axiAddr;
  wire       [10:0]   logic_pop_sync_readPort_rsp_destAddr;
  wire                logic_pop_sync_readPort_rsp_isVector;
  wire       [0:0]    logic_pop_sync_readPort_rsp_slotIdx;
  wire       [3:0]    logic_pop_sync_readPort_rsp_wordOff;
  wire       [48:0]   _zz_logic_pop_sync_readPort_rsp_axiAddr;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire       [31:0]   logic_pop_sync_readArbitation_translated_payload_axiAddr;
  wire       [10:0]   logic_pop_sync_readArbitation_translated_payload_destAddr;
  wire                logic_pop_sync_readArbitation_translated_payload_isVector;
  wire       [0:0]    logic_pop_sync_readArbitation_translated_payload_slotIdx;
  wire       [3:0]    logic_pop_sync_readArbitation_translated_payload_wordOff;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [3:0]    logic_pop_sync_popReg;
  reg [48:0] logic_ram [0:7];

  assign _zz_logic_ram_port = {logic_push_onRam_write_payload_data_wordOff,{logic_push_onRam_write_payload_data_slotIdx,{logic_push_onRam_write_payload_data_isVector,{logic_push_onRam_write_payload_data_destAddr,logic_push_onRam_write_payload_data_axiAddr}}}};
  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= _zz_logic_ram_port;
    end
  end

  always @(posedge clk) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1248 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 4'b1000) == 4'b0000);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[2:0];
  assign logic_push_onRam_write_payload_data_axiAddr = io_push_payload_axiAddr;
  assign logic_push_onRam_write_payload_data_destAddr = io_push_payload_destAddr;
  assign logic_push_onRam_write_payload_data_isVector = io_push_payload_isVector;
  assign logic_push_onRam_write_payload_data_slotIdx = io_push_payload_slotIdx;
  assign logic_push_onRam_write_payload_data_wordOff = io_push_payload_wordOff;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[2:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l375) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign _zz_logic_pop_sync_readPort_rsp_axiAddr = logic_ram_spinal_port1;
  assign logic_pop_sync_readPort_rsp_axiAddr = _zz_logic_pop_sync_readPort_rsp_axiAddr[31 : 0];
  assign logic_pop_sync_readPort_rsp_destAddr = _zz_logic_pop_sync_readPort_rsp_axiAddr[42 : 32];
  assign logic_pop_sync_readPort_rsp_isVector = _zz_logic_pop_sync_readPort_rsp_axiAddr[43];
  assign logic_pop_sync_readPort_rsp_slotIdx = _zz_logic_pop_sync_readPort_rsp_axiAddr[44 : 44];
  assign logic_pop_sync_readPort_rsp_wordOff = _zz_logic_pop_sync_readPort_rsp_axiAddr[48 : 45];
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload_axiAddr = logic_pop_sync_readPort_rsp_axiAddr;
  assign logic_pop_sync_readArbitation_translated_payload_destAddr = logic_pop_sync_readPort_rsp_destAddr;
  assign logic_pop_sync_readArbitation_translated_payload_isVector = logic_pop_sync_readPort_rsp_isVector;
  assign logic_pop_sync_readArbitation_translated_payload_slotIdx = logic_pop_sync_readPort_rsp_slotIdx;
  assign logic_pop_sync_readArbitation_translated_payload_wordOff = logic_pop_sync_readPort_rsp_wordOff;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload_axiAddr = logic_pop_sync_readArbitation_translated_payload_axiAddr;
  assign io_pop_payload_destAddr = logic_pop_sync_readArbitation_translated_payload_destAddr;
  assign io_pop_payload_isVector = logic_pop_sync_readArbitation_translated_payload_isVector;
  assign io_pop_payload_slotIdx = logic_pop_sync_readArbitation_translated_payload_slotIdx;
  assign io_pop_payload_wordOff = logic_pop_sync_readArbitation_translated_payload_wordOff;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (4'b1000 - logic_ptr_occupancy);
  always @(posedge clk) begin
    if(reset) begin
      logic_ptr_push <= 4'b0000;
      logic_ptr_pop <= 4'b0000;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 4'b0000;
    end else begin
      if(when_Stream_l1248) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 4'b0001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 4'b0001);
      end
      if(io_flush) begin
        logic_ptr_push <= 4'b0000;
        logic_ptr_pop <= 4'b0000;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 4'b0000;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule
