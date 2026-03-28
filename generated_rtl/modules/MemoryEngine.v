// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : MemoryEngine
// Git hash  : 414aef5ea78ca06f57c39f378ed640d967e9cf6d

`timescale 1ns/1ps

module MemoryEngine (
  input  wire          io_loadSlots_0_valid,
  input  wire [3:0]    io_loadSlots_0_opcode,
  input  wire [10:0]   io_loadSlots_0_dest,
  input  wire [10:0]   io_loadSlots_0_addrReg,
  input  wire [2:0]    io_loadSlots_0_offset,
  input  wire [31:0]   io_loadSlots_0_immediate,
  input  wire          io_storeSlots_0_valid,
  input  wire [2:0]    io_storeSlots_0_opcode,
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
  output reg  [3:0]    io_axiMaster_ar_payload_id,
  output reg  [7:0]    io_axiMaster_ar_payload_len,
  output reg  [2:0]    io_axiMaster_ar_payload_size,
  output reg  [1:0]    io_axiMaster_ar_payload_burst,
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
  output reg           io_scopyWriteReq_valid,
  output reg  [10:0]   io_scopyWriteReq_payload_addr,
  output reg  [31:0]   io_scopyWriteReq_payload_data,
  output reg  [10:0]   io_scopyReadAddr,
  output reg           io_scopyReadEn,
  input  wire [31:0]   io_scopyReadData,
  output reg           io_scopyBusy,
  output reg  [7:0]    io_matrixScratchAAddr,
  output reg           io_matrixScratchAEn,
  output reg           io_matrixScratchAWe,
  output reg  [7:0]    io_matrixScratchAWrData,
  input  wire [7:0]    io_matrixScratchARdData,
  output reg  [7:0]    io_matrixScratchBAddr,
  output reg           io_matrixScratchBEn,
  output reg           io_matrixScratchBWe,
  output reg  [7:0]    io_matrixScratchBWrData,
  input  wire [7:0]    io_matrixScratchBRdData,
  output reg  [5:0]    io_matrixAccumAddr,
  output reg           io_matrixAccumEn,
  output reg           io_matrixAccumWe,
  output reg  [31:0]   io_matrixAccumWrData,
  input  wire [31:0]   io_matrixAccumRdData,
  output reg           io_stall,
  output wire          io_scalarStoreBusy,
  output wire          io_matrixTransferBusy,
  output wire          io_matrixTransferBypassable,
  output wire          io_matrixTransferStartPulse,
  output wire          io_loadPendingValid,
  output wire [10:0]   io_loadPendingDestAddr,
  output wire          io_loadPendingIsVector,
  input  wire          clk,
  input  wire          reset
);
  localparam MemState_IDLE = 4'd0;
  localparam MemState_STORE_AW_W = 4'd1;
  localparam MemState_STORE_B = 4'd2;
  localparam MemState_MATRIX_READ_AR = 4'd3;
  localparam MemState_MATRIX_READ_R = 4'd4;
  localparam MemState_MATRIX_READ_DRAIN = 4'd5;
  localparam MemState_MATRIX_WRITE_GATHER = 4'd6;
  localparam MemState_MATRIX_WRITE_AW_W = 4'd7;
  localparam MemState_MATRIX_WRITE_B = 4'd8;
  localparam MemState_SCOPY_M2V = 4'd9;
  localparam MemState_SCOPY_V2M = 4'd10;

  reg                 storeReqFifo_io_push_valid;
  reg        [31:0]   storeReqFifo_io_push_payload_axiAddr;
  reg        [511:0]  storeReqFifo_io_push_payload_wdata;
  reg        [63:0]   storeReqFifo_io_push_payload_wstrb;
  reg                 storeReqFifo_io_pop_ready;
  wire                storeReqFifo_io_push_ready;
  wire                storeReqFifo_io_pop_valid;
  wire       [31:0]   storeReqFifo_io_pop_payload_axiAddr;
  wire       [511:0]  storeReqFifo_io_pop_payload_wdata;
  wire       [63:0]   storeReqFifo_io_pop_payload_wstrb;
  wire       [2:0]    storeReqFifo_io_occupancy;
  wire       [2:0]    storeReqFifo_io_availability;
  wire       [33:0]   _zz__zz_loadReqEntry_axiAddr;
  wire       [29:0]   _zz__zz_loadReqEntry_wordOff;
  wire       [33:0]   _zz__zz_loadReqEntry_axiAddr_2;
  wire       [31:0]   _zz__zz_loadReqEntry_axiAddr_2_1;
  wire       [31:0]   _zz__zz_loadReqEntry_axiAddr_2_2;
  wire       [10:0]   _zz_loadReqEntry_destAddr;
  wire       [29:0]   _zz_loadReqEntry_wordOff_1;
  wire       [33:0]   _zz__zz_io_push_payload_axiAddr_1;
  wire       [29:0]   _zz__zz_when_MemoryEngine_l498;
  wire       [8:0]    _zz_matrixBeatBytes;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr_1;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr_2;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr_1_1;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr_1_2;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr_1_3;
  wire       [6:0]    _zz_when_MemoryEngine_l853;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr_2_1;
  wire       [10:0]   _zz_io_scopyWriteReq_payload_addr;
  wire       [3:0]    _zz_io_scopyWriteReq_payload_addr_1;
  wire       [7:0]    _zz__zz_io_matrixScratchAAddr_3;
  wire       [3:0]    _zz__zz_io_matrixScratchAAddr_3_1;
  wire       [10:0]   _zz_io_scopyReadAddr;
  wire       [2:0]    axiSizeVal;
  wire       [31:0]   alignMask;
  wire                when_MemoryEngine_l166;
  wire       [607:0]  _zz_io_push_payload_axiAddr;
  reg        [3:0]    state;
  reg        [31:0]   capStoreReq_axiAddr;
  reg        [511:0]  capStoreReq_wdata;
  reg        [63:0]   capStoreReq_wstrb;
  reg                 awAccepted;
  reg                 wAccepted;
  reg                 loadReqValid;
  reg                 loadAddrAccepted;
  reg        [31:0]   loadReqEntry_axiAddr;
  reg        [10:0]   loadReqEntry_destAddr;
  reg                 loadReqEntry_isVector;
  reg        [0:0]    loadReqEntry_slotIdx;
  reg        [3:0]    loadReqEntry_wordOff;
  reg                 loadTrackValid_0;
  reg                 loadTrackValid_1;
  reg                 loadTrackValid_2;
  reg                 loadTrackValid_3;
  reg        [10:0]   loadTrackDestAddr_0;
  reg        [10:0]   loadTrackDestAddr_1;
  reg        [10:0]   loadTrackDestAddr_2;
  reg        [10:0]   loadTrackDestAddr_3;
  reg        [1:0]    loadTrackCountdown_0;
  reg        [1:0]    loadTrackCountdown_1;
  reg        [1:0]    loadTrackCountdown_2;
  reg        [1:0]    loadTrackCountdown_3;
  reg        [1:0]    loadTrackHead;
  reg        [1:0]    loadTrackTail;
  reg                 matrixUseAccum;
  reg                 matrixUseScratchB;
  reg                 matrixTransferBypassable;
  reg                 matrixIssueSeen;
  reg        [7:0]    matrixLocalBase;
  reg        [31:0]   matrixDramAddr;
  reg        [6:0]    matrixTotalElems;
  reg        [6:0]    matrixElemsTransferred;
  reg        [6:0]    matrixBeatElems;
  reg        [6:0]    matrixDrainIndex;
  reg        [6:0]    matrixGatherIssued;
  reg        [6:0]    matrixGatherCaptured;
  reg                 matrixReadPipeValid;
  reg        [6:0]    matrixReadPipeIndex;
  reg        [511:0]  matrixBeatBuffer;
  reg                 scopyIsM2V;
  reg        [10:0]   scopyVectorBase;
  reg        [7:0]    scopyMatrixBase;
  reg        [3:0]    scopyElemIdx;
  reg        [3:0]    scopyTotalElems;
  reg                 scopyUseAccum;
  reg                 scopyUseScratchB;
  reg                 scopyReadPipeValid;
  wire                when_MemoryEngine_l269;
  wire                when_MemoryEngine_l269_1;
  wire                when_MemoryEngine_l269_2;
  wire                when_MemoryEngine_l269_3;
  wire                when_MemoryEngine_l275;
  wire                when_MemoryEngine_l275_1;
  wire                when_MemoryEngine_l275_2;
  wire                when_MemoryEngine_l275_3;
  reg                 anyLoadOp;
  wire                isLoadOp_0;
  wire                isWaitForLoad_0;
  reg                 anyWaitForLoad;
  wire                isScopyOp_0;
  reg                 anyScopyOp;
  reg                 anyStoreOp;
  wire                isStoreOp_0;
  wire                matrixTransferRequested;
  wire                when_MemoryEngine_l347;
  wire                matrixTransferInFlight;
  wire                scopyInFlight;
  wire                scalarStoreInFlight;
  wire                scalarStorePending;
  wire                regularMemBusyForMatrix;
  wire                matrixBundleConflict;
  wire                when_MemoryEngine_l365;
  reg                 _zz_when_MemoryEngine_l387;
  wire                when_MemoryEngine_l382;
  wire                when_MemoryEngine_l382_1;
  wire                when_MemoryEngine_l382_2;
  wire                when_MemoryEngine_l382_3;
  wire                when_MemoryEngine_l387;
  wire                when_MemoryEngine_l398;
  wire                when_MemoryEngine_l404;
  wire                storeQueueFull;
  wire                storeQueueNearFullWithInFlight;
  wire                stallOnStoreFull;
  wire                when_MemoryEngine_l424;
  wire                when_MemoryEngine_l436;
  wire       [31:0]   _zz_loadReqEntry_axiAddr;
  wire       [31:0]   _zz_loadReqEntry_axiAddr_1;
  wire       [3:0]    _zz_loadReqEntry_wordOff;
  wire       [31:0]   _zz_loadReqEntry_axiAddr_2;
  wire                when_MemoryEngine_l479;
  wire       [31:0]   _zz_io_push_payload_axiAddr_1;
  wire       [3:0]    _zz_when_MemoryEngine_l498;
  reg        [511:0]  _zz_io_push_payload_wdata;
  reg        [63:0]   _zz_io_push_payload_wstrb;
  wire                when_MemoryEngine_l498;
  wire                when_MemoryEngine_l498_1;
  wire                when_MemoryEngine_l498_2;
  wire                when_MemoryEngine_l498_3;
  wire                when_MemoryEngine_l498_4;
  wire                when_MemoryEngine_l498_5;
  wire                when_MemoryEngine_l498_6;
  wire                when_MemoryEngine_l498_7;
  wire                when_MemoryEngine_l498_8;
  wire                when_MemoryEngine_l498_9;
  wire                when_MemoryEngine_l498_10;
  wire                when_MemoryEngine_l498_11;
  wire                when_MemoryEngine_l498_12;
  wire                when_MemoryEngine_l498_13;
  wire                when_MemoryEngine_l498_14;
  wire                when_MemoryEngine_l498_15;
  wire       [3:0]    _zz_when_MemoryEngine_l516;
  wire                when_MemoryEngine_l516;
  wire                when_MemoryEngine_l516_1;
  wire                when_MemoryEngine_l516_2;
  wire                when_MemoryEngine_l516_3;
  wire                when_MemoryEngine_l516_4;
  wire                when_MemoryEngine_l516_5;
  wire                when_MemoryEngine_l516_6;
  wire                when_MemoryEngine_l516_7;
  wire                when_MemoryEngine_l516_8;
  wire                when_MemoryEngine_l516_9;
  wire                when_MemoryEngine_l516_10;
  wire                when_MemoryEngine_l516_11;
  wire                when_MemoryEngine_l516_12;
  wire                when_MemoryEngine_l516_13;
  wire                when_MemoryEngine_l516_14;
  wire                when_MemoryEngine_l516_15;
  wire       [3:0]    _zz_when_MemoryEngine_l516_1;
  wire                when_MemoryEngine_l516_16;
  wire                when_MemoryEngine_l516_17;
  wire                when_MemoryEngine_l516_18;
  wire                when_MemoryEngine_l516_19;
  wire                when_MemoryEngine_l516_20;
  wire                when_MemoryEngine_l516_21;
  wire                when_MemoryEngine_l516_22;
  wire                when_MemoryEngine_l516_23;
  wire                when_MemoryEngine_l516_24;
  wire                when_MemoryEngine_l516_25;
  wire                when_MemoryEngine_l516_26;
  wire                when_MemoryEngine_l516_27;
  wire                when_MemoryEngine_l516_28;
  wire                when_MemoryEngine_l516_29;
  wire                when_MemoryEngine_l516_30;
  wire                when_MemoryEngine_l516_31;
  wire       [3:0]    _zz_when_MemoryEngine_l516_2;
  wire                when_MemoryEngine_l516_32;
  wire                when_MemoryEngine_l516_33;
  wire                when_MemoryEngine_l516_34;
  wire                when_MemoryEngine_l516_35;
  wire                when_MemoryEngine_l516_36;
  wire                when_MemoryEngine_l516_37;
  wire                when_MemoryEngine_l516_38;
  wire                when_MemoryEngine_l516_39;
  wire                when_MemoryEngine_l516_40;
  wire                when_MemoryEngine_l516_41;
  wire                when_MemoryEngine_l516_42;
  wire                when_MemoryEngine_l516_43;
  wire                when_MemoryEngine_l516_44;
  wire                when_MemoryEngine_l516_45;
  wire                when_MemoryEngine_l516_46;
  wire                when_MemoryEngine_l516_47;
  wire       [3:0]    _zz_when_MemoryEngine_l516_3;
  wire                when_MemoryEngine_l516_48;
  wire                when_MemoryEngine_l516_49;
  wire                when_MemoryEngine_l516_50;
  wire                when_MemoryEngine_l516_51;
  wire                when_MemoryEngine_l516_52;
  wire                when_MemoryEngine_l516_53;
  wire                when_MemoryEngine_l516_54;
  wire                when_MemoryEngine_l516_55;
  wire                when_MemoryEngine_l516_56;
  wire                when_MemoryEngine_l516_57;
  wire                when_MemoryEngine_l516_58;
  wire                when_MemoryEngine_l516_59;
  wire                when_MemoryEngine_l516_60;
  wire                when_MemoryEngine_l516_61;
  wire                when_MemoryEngine_l516_62;
  wire                when_MemoryEngine_l516_63;
  wire       [3:0]    _zz_when_MemoryEngine_l516_4;
  wire                when_MemoryEngine_l516_64;
  wire                when_MemoryEngine_l516_65;
  wire                when_MemoryEngine_l516_66;
  wire                when_MemoryEngine_l516_67;
  wire                when_MemoryEngine_l516_68;
  wire                when_MemoryEngine_l516_69;
  wire                when_MemoryEngine_l516_70;
  wire                when_MemoryEngine_l516_71;
  wire                when_MemoryEngine_l516_72;
  wire                when_MemoryEngine_l516_73;
  wire                when_MemoryEngine_l516_74;
  wire                when_MemoryEngine_l516_75;
  wire                when_MemoryEngine_l516_76;
  wire                when_MemoryEngine_l516_77;
  wire                when_MemoryEngine_l516_78;
  wire                when_MemoryEngine_l516_79;
  wire       [3:0]    _zz_when_MemoryEngine_l516_5;
  wire                when_MemoryEngine_l516_80;
  wire                when_MemoryEngine_l516_81;
  wire                when_MemoryEngine_l516_82;
  wire                when_MemoryEngine_l516_83;
  wire                when_MemoryEngine_l516_84;
  wire                when_MemoryEngine_l516_85;
  wire                when_MemoryEngine_l516_86;
  wire                when_MemoryEngine_l516_87;
  wire                when_MemoryEngine_l516_88;
  wire                when_MemoryEngine_l516_89;
  wire                when_MemoryEngine_l516_90;
  wire                when_MemoryEngine_l516_91;
  wire                when_MemoryEngine_l516_92;
  wire                when_MemoryEngine_l516_93;
  wire                when_MemoryEngine_l516_94;
  wire                when_MemoryEngine_l516_95;
  wire       [3:0]    _zz_when_MemoryEngine_l516_6;
  wire                when_MemoryEngine_l516_96;
  wire                when_MemoryEngine_l516_97;
  wire                when_MemoryEngine_l516_98;
  wire                when_MemoryEngine_l516_99;
  wire                when_MemoryEngine_l516_100;
  wire                when_MemoryEngine_l516_101;
  wire                when_MemoryEngine_l516_102;
  wire                when_MemoryEngine_l516_103;
  wire                when_MemoryEngine_l516_104;
  wire                when_MemoryEngine_l516_105;
  wire                when_MemoryEngine_l516_106;
  wire                when_MemoryEngine_l516_107;
  wire                when_MemoryEngine_l516_108;
  wire                when_MemoryEngine_l516_109;
  wire                when_MemoryEngine_l516_110;
  wire                when_MemoryEngine_l516_111;
  wire       [3:0]    _zz_when_MemoryEngine_l516_7;
  wire                when_MemoryEngine_l516_112;
  wire                when_MemoryEngine_l516_113;
  wire                when_MemoryEngine_l516_114;
  wire                when_MemoryEngine_l516_115;
  wire                when_MemoryEngine_l516_116;
  wire                when_MemoryEngine_l516_117;
  wire                when_MemoryEngine_l516_118;
  wire                when_MemoryEngine_l516_119;
  wire                when_MemoryEngine_l516_120;
  wire                when_MemoryEngine_l516_121;
  wire                when_MemoryEngine_l516_122;
  wire                when_MemoryEngine_l516_123;
  wire                when_MemoryEngine_l516_124;
  wire                when_MemoryEngine_l516_125;
  wire                when_MemoryEngine_l516_126;
  wire                when_MemoryEngine_l516_127;
  wire                when_MemoryEngine_l581;
  wire                when_MemoryEngine_l591;
  wire                io_axiMaster_ar_fire;
  wire                when_MemoryEngine_l623;
  wire                when_MemoryEngine_l629;
  wire                when_MemoryEngine_l630;
  reg        [31:0]   _zz_io_loadWriteReqs_0_payload_data;
  wire                when_MemoryEngine_l635;
  wire                when_MemoryEngine_l635_1;
  wire                when_MemoryEngine_l635_2;
  wire                when_MemoryEngine_l635_3;
  wire                when_MemoryEngine_l635_4;
  wire                when_MemoryEngine_l635_5;
  wire                when_MemoryEngine_l635_6;
  wire                when_MemoryEngine_l635_7;
  wire                when_MemoryEngine_l635_8;
  wire                when_MemoryEngine_l635_9;
  wire                when_MemoryEngine_l635_10;
  wire                when_MemoryEngine_l635_11;
  wire                when_MemoryEngine_l635_12;
  wire                when_MemoryEngine_l635_13;
  wire                when_MemoryEngine_l635_14;
  wire                when_MemoryEngine_l635_15;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_0_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649;
  wire                when_MemoryEngine_l649;
  wire                when_MemoryEngine_l649_1;
  wire                when_MemoryEngine_l649_2;
  wire                when_MemoryEngine_l649_3;
  wire                when_MemoryEngine_l649_4;
  wire                when_MemoryEngine_l649_5;
  wire                when_MemoryEngine_l649_6;
  wire                when_MemoryEngine_l649_7;
  wire                when_MemoryEngine_l649_8;
  wire                when_MemoryEngine_l649_9;
  wire                when_MemoryEngine_l649_10;
  wire                when_MemoryEngine_l649_11;
  wire                when_MemoryEngine_l649_12;
  wire                when_MemoryEngine_l649_13;
  wire                when_MemoryEngine_l649_14;
  wire                when_MemoryEngine_l649_15;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_1_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649_1;
  wire                when_MemoryEngine_l649_16;
  wire                when_MemoryEngine_l649_17;
  wire                when_MemoryEngine_l649_18;
  wire                when_MemoryEngine_l649_19;
  wire                when_MemoryEngine_l649_20;
  wire                when_MemoryEngine_l649_21;
  wire                when_MemoryEngine_l649_22;
  wire                when_MemoryEngine_l649_23;
  wire                when_MemoryEngine_l649_24;
  wire                when_MemoryEngine_l649_25;
  wire                when_MemoryEngine_l649_26;
  wire                when_MemoryEngine_l649_27;
  wire                when_MemoryEngine_l649_28;
  wire                when_MemoryEngine_l649_29;
  wire                when_MemoryEngine_l649_30;
  wire                when_MemoryEngine_l649_31;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_2_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649_2;
  wire                when_MemoryEngine_l649_32;
  wire                when_MemoryEngine_l649_33;
  wire                when_MemoryEngine_l649_34;
  wire                when_MemoryEngine_l649_35;
  wire                when_MemoryEngine_l649_36;
  wire                when_MemoryEngine_l649_37;
  wire                when_MemoryEngine_l649_38;
  wire                when_MemoryEngine_l649_39;
  wire                when_MemoryEngine_l649_40;
  wire                when_MemoryEngine_l649_41;
  wire                when_MemoryEngine_l649_42;
  wire                when_MemoryEngine_l649_43;
  wire                when_MemoryEngine_l649_44;
  wire                when_MemoryEngine_l649_45;
  wire                when_MemoryEngine_l649_46;
  wire                when_MemoryEngine_l649_47;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_3_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649_3;
  wire                when_MemoryEngine_l649_48;
  wire                when_MemoryEngine_l649_49;
  wire                when_MemoryEngine_l649_50;
  wire                when_MemoryEngine_l649_51;
  wire                when_MemoryEngine_l649_52;
  wire                when_MemoryEngine_l649_53;
  wire                when_MemoryEngine_l649_54;
  wire                when_MemoryEngine_l649_55;
  wire                when_MemoryEngine_l649_56;
  wire                when_MemoryEngine_l649_57;
  wire                when_MemoryEngine_l649_58;
  wire                when_MemoryEngine_l649_59;
  wire                when_MemoryEngine_l649_60;
  wire                when_MemoryEngine_l649_61;
  wire                when_MemoryEngine_l649_62;
  wire                when_MemoryEngine_l649_63;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_4_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649_4;
  wire                when_MemoryEngine_l649_64;
  wire                when_MemoryEngine_l649_65;
  wire                when_MemoryEngine_l649_66;
  wire                when_MemoryEngine_l649_67;
  wire                when_MemoryEngine_l649_68;
  wire                when_MemoryEngine_l649_69;
  wire                when_MemoryEngine_l649_70;
  wire                when_MemoryEngine_l649_71;
  wire                when_MemoryEngine_l649_72;
  wire                when_MemoryEngine_l649_73;
  wire                when_MemoryEngine_l649_74;
  wire                when_MemoryEngine_l649_75;
  wire                when_MemoryEngine_l649_76;
  wire                when_MemoryEngine_l649_77;
  wire                when_MemoryEngine_l649_78;
  wire                when_MemoryEngine_l649_79;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_5_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649_5;
  wire                when_MemoryEngine_l649_80;
  wire                when_MemoryEngine_l649_81;
  wire                when_MemoryEngine_l649_82;
  wire                when_MemoryEngine_l649_83;
  wire                when_MemoryEngine_l649_84;
  wire                when_MemoryEngine_l649_85;
  wire                when_MemoryEngine_l649_86;
  wire                when_MemoryEngine_l649_87;
  wire                when_MemoryEngine_l649_88;
  wire                when_MemoryEngine_l649_89;
  wire                when_MemoryEngine_l649_90;
  wire                when_MemoryEngine_l649_91;
  wire                when_MemoryEngine_l649_92;
  wire                when_MemoryEngine_l649_93;
  wire                when_MemoryEngine_l649_94;
  wire                when_MemoryEngine_l649_95;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_6_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649_6;
  wire                when_MemoryEngine_l649_96;
  wire                when_MemoryEngine_l649_97;
  wire                when_MemoryEngine_l649_98;
  wire                when_MemoryEngine_l649_99;
  wire                when_MemoryEngine_l649_100;
  wire                when_MemoryEngine_l649_101;
  wire                when_MemoryEngine_l649_102;
  wire                when_MemoryEngine_l649_103;
  wire                when_MemoryEngine_l649_104;
  wire                when_MemoryEngine_l649_105;
  wire                when_MemoryEngine_l649_106;
  wire                when_MemoryEngine_l649_107;
  wire                when_MemoryEngine_l649_108;
  wire                when_MemoryEngine_l649_109;
  wire                when_MemoryEngine_l649_110;
  wire                when_MemoryEngine_l649_111;
  reg        [31:0]   _zz_io_vloadWriteReqs_0_7_payload_data;
  wire       [3:0]    _zz_when_MemoryEngine_l649_7;
  wire                when_MemoryEngine_l649_112;
  wire                when_MemoryEngine_l649_113;
  wire                when_MemoryEngine_l649_114;
  wire                when_MemoryEngine_l649_115;
  wire                when_MemoryEngine_l649_116;
  wire                when_MemoryEngine_l649_117;
  wire                when_MemoryEngine_l649_118;
  wire                when_MemoryEngine_l649_119;
  wire                when_MemoryEngine_l649_120;
  wire                when_MemoryEngine_l649_121;
  wire                when_MemoryEngine_l649_122;
  wire                when_MemoryEngine_l649_123;
  wire                when_MemoryEngine_l649_124;
  wire                when_MemoryEngine_l649_125;
  wire                when_MemoryEngine_l649_126;
  wire                when_MemoryEngine_l649_127;
  wire                when_MemoryEngine_l667;
  wire                when_MemoryEngine_l667_1;
  wire                when_MemoryEngine_l667_2;
  wire                when_MemoryEngine_l667_3;
  reg        [6:0]    matrixBeatBytes;
  reg        [63:0]   matrixWriteStrb;
  wire                when_MemoryEngine_l685;
  wire                when_MemoryEngine_l685_1;
  wire                when_MemoryEngine_l685_2;
  wire                when_MemoryEngine_l685_3;
  wire                when_MemoryEngine_l685_4;
  wire                when_MemoryEngine_l685_5;
  wire                when_MemoryEngine_l685_6;
  wire                when_MemoryEngine_l685_7;
  wire                when_MemoryEngine_l685_8;
  wire                when_MemoryEngine_l685_9;
  wire                when_MemoryEngine_l685_10;
  wire                when_MemoryEngine_l685_11;
  wire                when_MemoryEngine_l685_12;
  wire                when_MemoryEngine_l685_13;
  wire                when_MemoryEngine_l685_14;
  wire                when_MemoryEngine_l685_15;
  wire                when_MemoryEngine_l685_16;
  wire                when_MemoryEngine_l685_17;
  wire                when_MemoryEngine_l685_18;
  wire                when_MemoryEngine_l685_19;
  wire                when_MemoryEngine_l685_20;
  wire                when_MemoryEngine_l685_21;
  wire                when_MemoryEngine_l685_22;
  wire                when_MemoryEngine_l685_23;
  wire                when_MemoryEngine_l685_24;
  wire                when_MemoryEngine_l685_25;
  wire                when_MemoryEngine_l685_26;
  wire                when_MemoryEngine_l685_27;
  wire                when_MemoryEngine_l685_28;
  wire                when_MemoryEngine_l685_29;
  wire                when_MemoryEngine_l685_30;
  wire                when_MemoryEngine_l685_31;
  wire                when_MemoryEngine_l685_32;
  wire                when_MemoryEngine_l685_33;
  wire                when_MemoryEngine_l685_34;
  wire                when_MemoryEngine_l685_35;
  wire                when_MemoryEngine_l685_36;
  wire                when_MemoryEngine_l685_37;
  wire                when_MemoryEngine_l685_38;
  wire                when_MemoryEngine_l685_39;
  wire                when_MemoryEngine_l685_40;
  wire                when_MemoryEngine_l685_41;
  wire                when_MemoryEngine_l685_42;
  wire                when_MemoryEngine_l685_43;
  wire                when_MemoryEngine_l685_44;
  wire                when_MemoryEngine_l685_45;
  wire                when_MemoryEngine_l685_46;
  wire                when_MemoryEngine_l685_47;
  wire                when_MemoryEngine_l685_48;
  wire                when_MemoryEngine_l685_49;
  wire                when_MemoryEngine_l685_50;
  wire                when_MemoryEngine_l685_51;
  wire                when_MemoryEngine_l685_52;
  wire                when_MemoryEngine_l685_53;
  wire                when_MemoryEngine_l685_54;
  wire                when_MemoryEngine_l685_55;
  wire                when_MemoryEngine_l685_56;
  wire                when_MemoryEngine_l685_57;
  wire                when_MemoryEngine_l685_58;
  wire                when_MemoryEngine_l685_59;
  wire                when_MemoryEngine_l685_60;
  wire                when_MemoryEngine_l685_61;
  wire                when_MemoryEngine_l685_62;
  wire                when_MemoryEngine_l685_63;
  wire                when_MemoryEngine_l703;
  wire                when_MemoryEngine_l704;
  wire                io_axiMaster_aw_fire;
  wire                io_axiMaster_w_fire;
  wire                when_MemoryEngine_l716;
  wire       [7:0]    _zz_io_matrixScratchAAddr;
  reg        [31:0]   _zz_io_matrixAccumWrData;
  wire                when_MemoryEngine_l758;
  wire                when_MemoryEngine_l758_1;
  wire                when_MemoryEngine_l758_2;
  wire                when_MemoryEngine_l758_3;
  wire                when_MemoryEngine_l758_4;
  wire                when_MemoryEngine_l758_5;
  wire                when_MemoryEngine_l758_6;
  wire                when_MemoryEngine_l758_7;
  wire                when_MemoryEngine_l758_8;
  wire                when_MemoryEngine_l758_9;
  wire                when_MemoryEngine_l758_10;
  wire                when_MemoryEngine_l758_11;
  wire                when_MemoryEngine_l758_12;
  wire                when_MemoryEngine_l758_13;
  wire                when_MemoryEngine_l758_14;
  wire                when_MemoryEngine_l758_15;
  reg        [7:0]    _zz_io_matrixScratchAWrData;
  wire                when_MemoryEngine_l770;
  wire                when_MemoryEngine_l770_1;
  wire                when_MemoryEngine_l770_2;
  wire                when_MemoryEngine_l770_3;
  wire                when_MemoryEngine_l770_4;
  wire                when_MemoryEngine_l770_5;
  wire                when_MemoryEngine_l770_6;
  wire                when_MemoryEngine_l770_7;
  wire                when_MemoryEngine_l770_8;
  wire                when_MemoryEngine_l770_9;
  wire                when_MemoryEngine_l770_10;
  wire                when_MemoryEngine_l770_11;
  wire                when_MemoryEngine_l770_12;
  wire                when_MemoryEngine_l770_13;
  wire                when_MemoryEngine_l770_14;
  wire                when_MemoryEngine_l770_15;
  wire                when_MemoryEngine_l770_16;
  wire                when_MemoryEngine_l770_17;
  wire                when_MemoryEngine_l770_18;
  wire                when_MemoryEngine_l770_19;
  wire                when_MemoryEngine_l770_20;
  wire                when_MemoryEngine_l770_21;
  wire                when_MemoryEngine_l770_22;
  wire                when_MemoryEngine_l770_23;
  wire                when_MemoryEngine_l770_24;
  wire                when_MemoryEngine_l770_25;
  wire                when_MemoryEngine_l770_26;
  wire                when_MemoryEngine_l770_27;
  wire                when_MemoryEngine_l770_28;
  wire                when_MemoryEngine_l770_29;
  wire                when_MemoryEngine_l770_30;
  wire                when_MemoryEngine_l770_31;
  wire                when_MemoryEngine_l770_32;
  wire                when_MemoryEngine_l770_33;
  wire                when_MemoryEngine_l770_34;
  wire                when_MemoryEngine_l770_35;
  wire                when_MemoryEngine_l770_36;
  wire                when_MemoryEngine_l770_37;
  wire                when_MemoryEngine_l770_38;
  wire                when_MemoryEngine_l770_39;
  wire                when_MemoryEngine_l770_40;
  wire                when_MemoryEngine_l770_41;
  wire                when_MemoryEngine_l770_42;
  wire                when_MemoryEngine_l770_43;
  wire                when_MemoryEngine_l770_44;
  wire                when_MemoryEngine_l770_45;
  wire                when_MemoryEngine_l770_46;
  wire                when_MemoryEngine_l770_47;
  wire                when_MemoryEngine_l770_48;
  wire                when_MemoryEngine_l770_49;
  wire                when_MemoryEngine_l770_50;
  wire                when_MemoryEngine_l770_51;
  wire                when_MemoryEngine_l770_52;
  wire                when_MemoryEngine_l770_53;
  wire                when_MemoryEngine_l770_54;
  wire                when_MemoryEngine_l770_55;
  wire                when_MemoryEngine_l770_56;
  wire                when_MemoryEngine_l770_57;
  wire                when_MemoryEngine_l770_58;
  wire                when_MemoryEngine_l770_59;
  wire                when_MemoryEngine_l770_60;
  wire                when_MemoryEngine_l770_61;
  wire                when_MemoryEngine_l770_62;
  wire                when_MemoryEngine_l770_63;
  wire       [6:0]    _zz_matrixDrainIndex;
  wire       [6:0]    _zz_matrixElemsTransferred;
  wire                when_MemoryEngine_l789;
  wire                when_MemoryEngine_l793;
  wire       [6:0]    _zz_when_MemoryEngine_l284;
  reg        [6:0]    _zz_matrixBeatElems;
  wire                when_MemoryEngine_l284;
  wire                when_MemoryEngine_l830;
  wire       [7:0]    _zz_io_matrixScratchAAddr_1;
  wire                when_MemoryEngine_l812;
  wire                when_MemoryEngine_l812_1;
  wire                when_MemoryEngine_l812_2;
  wire                when_MemoryEngine_l812_3;
  wire                when_MemoryEngine_l812_4;
  wire                when_MemoryEngine_l812_5;
  wire                when_MemoryEngine_l812_6;
  wire                when_MemoryEngine_l812_7;
  wire                when_MemoryEngine_l812_8;
  wire                when_MemoryEngine_l812_9;
  wire                when_MemoryEngine_l812_10;
  wire                when_MemoryEngine_l812_11;
  wire                when_MemoryEngine_l812_12;
  wire                when_MemoryEngine_l812_13;
  wire                when_MemoryEngine_l812_14;
  wire                when_MemoryEngine_l812_15;
  wire                when_MemoryEngine_l818;
  wire                when_MemoryEngine_l818_1;
  wire                when_MemoryEngine_l818_2;
  wire                when_MemoryEngine_l818_3;
  wire                when_MemoryEngine_l818_4;
  wire                when_MemoryEngine_l818_5;
  wire                when_MemoryEngine_l818_6;
  wire                when_MemoryEngine_l818_7;
  wire                when_MemoryEngine_l818_8;
  wire                when_MemoryEngine_l818_9;
  wire                when_MemoryEngine_l818_10;
  wire                when_MemoryEngine_l818_11;
  wire                when_MemoryEngine_l818_12;
  wire                when_MemoryEngine_l818_13;
  wire                when_MemoryEngine_l818_14;
  wire                when_MemoryEngine_l818_15;
  wire                when_MemoryEngine_l818_16;
  wire                when_MemoryEngine_l818_17;
  wire                when_MemoryEngine_l818_18;
  wire                when_MemoryEngine_l818_19;
  wire                when_MemoryEngine_l818_20;
  wire                when_MemoryEngine_l818_21;
  wire                when_MemoryEngine_l818_22;
  wire                when_MemoryEngine_l818_23;
  wire                when_MemoryEngine_l818_24;
  wire                when_MemoryEngine_l818_25;
  wire                when_MemoryEngine_l818_26;
  wire                when_MemoryEngine_l818_27;
  wire                when_MemoryEngine_l818_28;
  wire                when_MemoryEngine_l818_29;
  wire                when_MemoryEngine_l818_30;
  wire                when_MemoryEngine_l818_31;
  wire                when_MemoryEngine_l818_32;
  wire                when_MemoryEngine_l818_33;
  wire                when_MemoryEngine_l818_34;
  wire                when_MemoryEngine_l818_35;
  wire                when_MemoryEngine_l818_36;
  wire                when_MemoryEngine_l818_37;
  wire                when_MemoryEngine_l818_38;
  wire                when_MemoryEngine_l818_39;
  wire                when_MemoryEngine_l818_40;
  wire                when_MemoryEngine_l818_41;
  wire                when_MemoryEngine_l818_42;
  wire                when_MemoryEngine_l818_43;
  wire                when_MemoryEngine_l818_44;
  wire                when_MemoryEngine_l818_45;
  wire                when_MemoryEngine_l818_46;
  wire                when_MemoryEngine_l818_47;
  wire                when_MemoryEngine_l818_48;
  wire                when_MemoryEngine_l818_49;
  wire                when_MemoryEngine_l818_50;
  wire                when_MemoryEngine_l818_51;
  wire                when_MemoryEngine_l818_52;
  wire                when_MemoryEngine_l818_53;
  wire                when_MemoryEngine_l818_54;
  wire                when_MemoryEngine_l818_55;
  wire                when_MemoryEngine_l818_56;
  wire                when_MemoryEngine_l818_57;
  wire                when_MemoryEngine_l818_58;
  wire                when_MemoryEngine_l818_59;
  wire                when_MemoryEngine_l818_60;
  wire                when_MemoryEngine_l818_61;
  wire                when_MemoryEngine_l818_62;
  wire                when_MemoryEngine_l818_63;
  wire                when_MemoryEngine_l853;
  wire                when_MemoryEngine_l861;
  wire                when_MemoryEngine_l862;
  wire                when_MemoryEngine_l874;
  wire       [6:0]    _zz_matrixElemsTransferred_1;
  wire                when_MemoryEngine_l892;
  wire       [6:0]    _zz_when_MemoryEngine_l284_1;
  reg        [6:0]    _zz_matrixBeatElems_1;
  wire                when_MemoryEngine_l284_1;
  wire       [7:0]    _zz_io_matrixScratchAAddr_2;
  wire                when_MemoryEngine_l926;
  wire                when_MemoryEngine_l949;
  wire                when_MemoryEngine_l985;
  wire       [7:0]    _zz_io_matrixScratchAAddr_3;
  wire                when_MemoryEngine_l996;
  `ifndef SYNTHESIS
  reg [151:0] state_string;
  `endif


  assign _zz__zz_loadReqEntry_axiAddr = ({2'd0,io_loadAddrData_0} <<< 2'd2);
  assign _zz__zz_loadReqEntry_wordOff = (_zz_loadReqEntry_axiAddr >>> 2'd2);
  assign _zz__zz_loadReqEntry_axiAddr_2 = ({2'd0,_zz__zz_loadReqEntry_axiAddr_2_1} <<< 2'd2);
  assign _zz__zz_loadReqEntry_axiAddr_2_1 = (io_loadAddrData_0 + _zz__zz_loadReqEntry_axiAddr_2_2);
  assign _zz__zz_loadReqEntry_axiAddr_2_2 = {29'd0, io_loadSlots_0_offset};
  assign _zz_loadReqEntry_destAddr = {8'd0, io_loadSlots_0_offset};
  assign _zz_loadReqEntry_wordOff_1 = (_zz_loadReqEntry_axiAddr_2 >>> 2'd2);
  assign _zz__zz_io_push_payload_axiAddr_1 = ({2'd0,io_storeAddrData_0} <<< 2'd2);
  assign _zz__zz_when_MemoryEngine_l498 = (_zz_io_push_payload_axiAddr_1 >>> 2'd2);
  assign _zz_matrixBeatBytes = ({2'd0,matrixBeatElems} <<< 2'd2);
  assign _zz__zz_io_matrixScratchAAddr = (matrixLocalBase + _zz__zz_io_matrixScratchAAddr_1);
  assign _zz__zz_io_matrixScratchAAddr_1 = {1'd0, matrixElemsTransferred};
  assign _zz__zz_io_matrixScratchAAddr_2 = {1'd0, matrixDrainIndex};
  assign _zz__zz_io_matrixScratchAAddr_1_1 = (matrixLocalBase + _zz__zz_io_matrixScratchAAddr_1_2);
  assign _zz__zz_io_matrixScratchAAddr_1_2 = {1'd0, matrixElemsTransferred};
  assign _zz__zz_io_matrixScratchAAddr_1_3 = {1'd0, matrixGatherIssued};
  assign _zz_when_MemoryEngine_l853 = (matrixGatherCaptured + 7'h01);
  assign _zz__zz_io_matrixScratchAAddr_2_1 = {4'd0, scopyElemIdx};
  assign _zz_io_scopyWriteReq_payload_addr_1 = (scopyElemIdx - 4'b0001);
  assign _zz_io_scopyWriteReq_payload_addr = {7'd0, _zz_io_scopyWriteReq_payload_addr_1};
  assign _zz__zz_io_matrixScratchAAddr_3_1 = (scopyElemIdx - 4'b0001);
  assign _zz__zz_io_matrixScratchAAddr_3 = {4'd0, _zz__zz_io_matrixScratchAAddr_3_1};
  assign _zz_io_scopyReadAddr = {7'd0, scopyElemIdx};
  StreamFifo storeReqFifo (
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
    .io_occupancy            (storeReqFifo_io_occupancy[2:0]            ), //o
    .io_availability         (storeReqFifo_io_availability[2:0]         ), //o
    .clk                     (clk                                       ), //i
    .reset                   (reset                                     )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(state)
      MemState_IDLE : state_string = "IDLE               ";
      MemState_STORE_AW_W : state_string = "STORE_AW_W         ";
      MemState_STORE_B : state_string = "STORE_B            ";
      MemState_MATRIX_READ_AR : state_string = "MATRIX_READ_AR     ";
      MemState_MATRIX_READ_R : state_string = "MATRIX_READ_R      ";
      MemState_MATRIX_READ_DRAIN : state_string = "MATRIX_READ_DRAIN  ";
      MemState_MATRIX_WRITE_GATHER : state_string = "MATRIX_WRITE_GATHER";
      MemState_MATRIX_WRITE_AW_W : state_string = "MATRIX_WRITE_AW_W  ";
      MemState_MATRIX_WRITE_B : state_string = "MATRIX_WRITE_B     ";
      MemState_SCOPY_M2V : state_string = "SCOPY_M2V          ";
      MemState_SCOPY_V2M : state_string = "SCOPY_V2M          ";
      default : state_string = "???????????????????";
    endcase
  end
  `endif

  assign axiSizeVal = 3'b110;
  assign alignMask = 32'h0000003f;
  always @(*) begin
    io_stall = 1'b0;
    if(when_MemoryEngine_l365) begin
      io_stall = 1'b1;
    end
    if(isWaitForLoad_0) begin
      if(when_MemoryEngine_l387) begin
        io_stall = 1'b1;
      end
    end
    if(scopyInFlight) begin
      io_stall = 1'b1;
    end
    if(when_MemoryEngine_l398) begin
      io_stall = 1'b1;
    end
    if(when_MemoryEngine_l404) begin
      io_stall = 1'b1;
    end
    if(stallOnStoreFull) begin
      io_stall = 1'b1;
    end
    if(when_MemoryEngine_l424) begin
      io_stall = 1'b1;
    end
  end

  assign io_matrixTransferStartPulse = 1'b0;
  always @(*) begin
    io_scopyWriteReq_valid = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(scopyReadPipeValid) begin
          io_scopyWriteReq_valid = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_scopyWriteReq_payload_addr = 11'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(scopyReadPipeValid) begin
          io_scopyWriteReq_payload_addr = (scopyVectorBase + _zz_io_scopyWriteReq_payload_addr);
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_scopyWriteReq_payload_data = 32'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(scopyReadPipeValid) begin
          if(scopyUseAccum) begin
            io_scopyWriteReq_payload_data = io_matrixAccumRdData;
          end else begin
            if(scopyUseScratchB) begin
              io_scopyWriteReq_payload_data = {24'd0, io_matrixScratchBRdData};
            end else begin
              io_scopyWriteReq_payload_data = {24'd0, io_matrixScratchARdData};
            end
          end
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_scopyReadAddr = 11'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
        if(when_MemoryEngine_l985) begin
          io_scopyReadAddr = (scopyVectorBase + _zz_io_scopyReadAddr);
        end
      end
    endcase
  end

  always @(*) begin
    io_scopyReadEn = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
        if(when_MemoryEngine_l985) begin
          io_scopyReadEn = 1'b1;
        end
      end
    endcase
  end

  always @(*) begin
    io_scopyBusy = 1'b0;
    if(scopyInFlight) begin
      io_scopyBusy = 1'b1;
    end
  end

  always @(*) begin
    io_loadWriteReqs_0_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(when_MemoryEngine_l630) begin
          io_loadWriteReqs_0_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_loadWriteReqs_0_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(when_MemoryEngine_l630) begin
          io_loadWriteReqs_0_payload_addr = loadReqEntry_destAddr;
        end
      end
    end
  end

  always @(*) begin
    io_loadWriteReqs_0_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(when_MemoryEngine_l630) begin
          io_loadWriteReqs_0_payload_data = _zz_io_loadWriteReqs_0_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_constWriteReqs_0_valid = 1'b0;
    if(when_MemoryEngine_l166) begin
      io_constWriteReqs_0_valid = 1'b1;
    end
  end

  always @(*) begin
    io_constWriteReqs_0_payload_addr = 11'h0;
    if(when_MemoryEngine_l166) begin
      io_constWriteReqs_0_payload_addr = io_loadSlots_0_dest;
    end
  end

  always @(*) begin
    io_constWriteReqs_0_payload_data = 32'h0;
    if(when_MemoryEngine_l166) begin
      io_constWriteReqs_0_payload_data = io_loadSlots_0_immediate;
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_0_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_0_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_0_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_0_payload_addr = (loadReqEntry_destAddr + 11'h0);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_0_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_0_payload_data = _zz_io_vloadWriteReqs_0_0_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_1_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_1_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_1_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_1_payload_addr = (loadReqEntry_destAddr + 11'h001);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_1_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_1_payload_data = _zz_io_vloadWriteReqs_0_1_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_2_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_2_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_2_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_2_payload_addr = (loadReqEntry_destAddr + 11'h002);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_2_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_2_payload_data = _zz_io_vloadWriteReqs_0_2_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_3_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_3_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_3_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_3_payload_addr = (loadReqEntry_destAddr + 11'h003);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_3_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_3_payload_data = _zz_io_vloadWriteReqs_0_3_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_4_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_4_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_4_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_4_payload_addr = (loadReqEntry_destAddr + 11'h004);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_4_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_4_payload_data = _zz_io_vloadWriteReqs_0_4_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_5_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_5_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_5_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_5_payload_addr = (loadReqEntry_destAddr + 11'h005);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_5_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_5_payload_data = _zz_io_vloadWriteReqs_0_5_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_6_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_6_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_6_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_6_payload_addr = (loadReqEntry_destAddr + 11'h006);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_6_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_6_payload_data = _zz_io_vloadWriteReqs_0_6_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_7_valid = 1'b0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_7_valid = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_7_payload_addr = 11'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_7_payload_addr = (loadReqEntry_destAddr + 11'h007);
        end
      end
    end
  end

  always @(*) begin
    io_vloadWriteReqs_0_7_payload_data = 32'h0;
    if(when_MemoryEngine_l623) begin
      if(when_MemoryEngine_l629) begin
        if(!when_MemoryEngine_l630) begin
          io_vloadWriteReqs_0_7_payload_data = _zz_io_vloadWriteReqs_0_7_payload_data;
        end
      end
    end
  end

  always @(*) begin
    io_matrixScratchAAddr = 8'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(!matrixUseScratchB) begin
            io_matrixScratchAAddr = _zz_io_matrixScratchAAddr;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(!matrixUseAccum) begin
            if(!matrixUseScratchB) begin
              io_matrixScratchAAddr = _zz_io_matrixScratchAAddr_1;
            end
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(!scopyUseAccum) begin
            if(!scopyUseScratchB) begin
              io_matrixScratchAAddr = _zz_io_matrixScratchAAddr_2;
            end
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(!scopyUseScratchB) begin
              io_matrixScratchAAddr = _zz_io_matrixScratchAAddr_3;
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchAEn = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(!matrixUseScratchB) begin
            io_matrixScratchAEn = 1'b1;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(!matrixUseAccum) begin
            if(!matrixUseScratchB) begin
              io_matrixScratchAEn = 1'b1;
            end
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(!scopyUseAccum) begin
            if(!scopyUseScratchB) begin
              io_matrixScratchAEn = 1'b1;
            end
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(!scopyUseScratchB) begin
              io_matrixScratchAEn = 1'b1;
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchAWe = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(!matrixUseScratchB) begin
            io_matrixScratchAWe = 1'b1;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(!matrixUseAccum) begin
            if(!matrixUseScratchB) begin
              io_matrixScratchAWe = 1'b0;
            end
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(!scopyUseAccum) begin
            if(!scopyUseScratchB) begin
              io_matrixScratchAWe = 1'b0;
            end
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(!scopyUseScratchB) begin
              io_matrixScratchAWe = 1'b1;
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchAWrData = 8'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(!matrixUseScratchB) begin
            io_matrixScratchAWrData = _zz_io_matrixScratchAWrData;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(!scopyUseScratchB) begin
              io_matrixScratchAWrData = io_scopyReadData[7:0];
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchBAddr = 8'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(matrixUseScratchB) begin
            io_matrixScratchBAddr = _zz_io_matrixScratchAAddr;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(!matrixUseAccum) begin
            if(matrixUseScratchB) begin
              io_matrixScratchBAddr = _zz_io_matrixScratchAAddr_1;
            end
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(!scopyUseAccum) begin
            if(scopyUseScratchB) begin
              io_matrixScratchBAddr = _zz_io_matrixScratchAAddr_2;
            end
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(scopyUseScratchB) begin
              io_matrixScratchBAddr = _zz_io_matrixScratchAAddr_3;
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchBEn = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(matrixUseScratchB) begin
            io_matrixScratchBEn = 1'b1;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(!matrixUseAccum) begin
            if(matrixUseScratchB) begin
              io_matrixScratchBEn = 1'b1;
            end
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(!scopyUseAccum) begin
            if(scopyUseScratchB) begin
              io_matrixScratchBEn = 1'b1;
            end
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(scopyUseScratchB) begin
              io_matrixScratchBEn = 1'b1;
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchBWe = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(matrixUseScratchB) begin
            io_matrixScratchBWe = 1'b1;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(!matrixUseAccum) begin
            if(matrixUseScratchB) begin
              io_matrixScratchBWe = 1'b0;
            end
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(!scopyUseAccum) begin
            if(scopyUseScratchB) begin
              io_matrixScratchBWe = 1'b0;
            end
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(scopyUseScratchB) begin
              io_matrixScratchBWe = 1'b1;
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixScratchBWrData = 8'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(!matrixUseAccum) begin
          if(matrixUseScratchB) begin
            io_matrixScratchBWrData = _zz_io_matrixScratchAWrData;
          end
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(!scopyUseAccum) begin
            if(scopyUseScratchB) begin
              io_matrixScratchBWrData = io_scopyReadData[7:0];
            end
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixAccumAddr = 6'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(matrixUseAccum) begin
          io_matrixAccumAddr = _zz_io_matrixScratchAAddr[5:0];
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(matrixUseAccum) begin
            io_matrixAccumAddr = _zz_io_matrixScratchAAddr_1[5:0];
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(scopyUseAccum) begin
            io_matrixAccumAddr = _zz_io_matrixScratchAAddr_2[5:0];
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(scopyUseAccum) begin
            io_matrixAccumAddr = _zz_io_matrixScratchAAddr_3[5:0];
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixAccumEn = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(matrixUseAccum) begin
          io_matrixAccumEn = 1'b1;
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(matrixUseAccum) begin
            io_matrixAccumEn = 1'b1;
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(scopyUseAccum) begin
            io_matrixAccumEn = 1'b1;
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(scopyUseAccum) begin
            io_matrixAccumEn = 1'b1;
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixAccumWe = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(matrixUseAccum) begin
          io_matrixAccumWe = 1'b1;
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
        if(when_MemoryEngine_l830) begin
          if(matrixUseAccum) begin
            io_matrixAccumWe = 1'b0;
          end
        end
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
        if(when_MemoryEngine_l926) begin
          if(scopyUseAccum) begin
            io_matrixAccumWe = 1'b0;
          end
        end
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(scopyUseAccum) begin
            io_matrixAccumWe = 1'b1;
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_matrixAccumWrData = 32'h0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
        if(matrixUseAccum) begin
          io_matrixAccumWrData = _zz_io_matrixAccumWrData;
        end
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
        if(scopyReadPipeValid) begin
          if(scopyUseAccum) begin
            io_matrixAccumWrData = io_scopyReadData;
          end
        end
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_aw_valid = 1'b0;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
        if(when_MemoryEngine_l703) begin
          io_axiMaster_aw_valid = 1'b1;
        end
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        if(when_MemoryEngine_l861) begin
          io_axiMaster_aw_valid = 1'b1;
        end
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
        io_axiMaster_aw_payload_addr = capStoreReq_axiAddr;
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        io_axiMaster_aw_payload_addr = matrixDramAddr;
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
        io_axiMaster_aw_payload_len = 8'h0;
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        io_axiMaster_aw_payload_len = 8'h0;
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
        io_axiMaster_aw_payload_size = axiSizeVal;
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        io_axiMaster_aw_payload_size = axiSizeVal;
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
        if(when_MemoryEngine_l704) begin
          io_axiMaster_w_valid = 1'b1;
        end
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        if(when_MemoryEngine_l862) begin
          io_axiMaster_w_valid = 1'b1;
        end
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
        io_axiMaster_w_payload_data = capStoreReq_wdata;
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        io_axiMaster_w_payload_data = matrixBeatBuffer;
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
        io_axiMaster_w_payload_strb = capStoreReq_wstrb;
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        io_axiMaster_w_payload_strb = matrixWriteStrb;
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
        io_axiMaster_w_payload_last = 1'b1;
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
        io_axiMaster_w_payload_last = 1'b1;
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
        io_axiMaster_b_ready = 1'b1;
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
        io_axiMaster_b_ready = 1'b1;
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end

  assign when_MemoryEngine_l166 = ((io_loadSlots_0_valid && io_valid) && (io_loadSlots_0_opcode == 4'b0100));
  always @(*) begin
    storeReqFifo_io_push_valid = 1'b0;
    if(when_MemoryEngine_l479) begin
      storeReqFifo_io_push_valid = 1'b1;
    end
  end

  assign _zz_io_push_payload_axiAddr = 608'h0;
  always @(*) begin
    storeReqFifo_io_push_payload_axiAddr = _zz_io_push_payload_axiAddr[31 : 0];
    if(when_MemoryEngine_l479) begin
      storeReqFifo_io_push_payload_axiAddr = (_zz_io_push_payload_axiAddr_1 & (~ alignMask));
    end
  end

  always @(*) begin
    storeReqFifo_io_push_payload_wdata = _zz_io_push_payload_axiAddr[543 : 32];
    if(when_MemoryEngine_l479) begin
      storeReqFifo_io_push_payload_wdata = _zz_io_push_payload_wdata;
    end
  end

  always @(*) begin
    storeReqFifo_io_push_payload_wstrb = _zz_io_push_payload_axiAddr[607 : 544];
    if(when_MemoryEngine_l479) begin
      storeReqFifo_io_push_payload_wstrb = _zz_io_push_payload_wstrb;
    end
  end

  assign io_loadPendingValid = loadReqValid;
  assign io_loadPendingDestAddr = loadReqEntry_destAddr;
  assign io_loadPendingIsVector = loadReqEntry_isVector;
  assign when_MemoryEngine_l269 = (loadTrackValid_0 && (2'b00 < loadTrackCountdown_0));
  assign when_MemoryEngine_l269_1 = (loadTrackValid_1 && (2'b00 < loadTrackCountdown_1));
  assign when_MemoryEngine_l269_2 = (loadTrackValid_2 && (2'b00 < loadTrackCountdown_2));
  assign when_MemoryEngine_l269_3 = (loadTrackValid_3 && (2'b00 < loadTrackCountdown_3));
  assign when_MemoryEngine_l275 = (((2'b00 == loadTrackHead) && loadTrackValid_0) && (loadTrackCountdown_0 == 2'b00));
  assign when_MemoryEngine_l275_1 = (((2'b01 == loadTrackHead) && loadTrackValid_1) && (loadTrackCountdown_1 == 2'b00));
  assign when_MemoryEngine_l275_2 = (((2'b10 == loadTrackHead) && loadTrackValid_2) && (loadTrackCountdown_2 == 2'b00));
  assign when_MemoryEngine_l275_3 = (((2'b11 == loadTrackHead) && loadTrackValid_3) && (loadTrackCountdown_3 == 2'b00));
  always @(*) begin
    anyLoadOp = 1'b0;
    if(isLoadOp_0) begin
      anyLoadOp = 1'b1;
    end
  end

  assign isLoadOp_0 = ((io_loadSlots_0_valid && io_valid) && (((io_loadSlots_0_opcode == 4'b0001) || (io_loadSlots_0_opcode == 4'b0010)) || (io_loadSlots_0_opcode == 4'b0011)));
  always @(*) begin
    anyWaitForLoad = 1'b0;
    if(isWaitForLoad_0) begin
      anyWaitForLoad = 1'b1;
    end
  end

  assign isWaitForLoad_0 = ((io_loadSlots_0_valid && io_valid) && (io_loadSlots_0_opcode == 4'b0101));
  always @(*) begin
    anyScopyOp = 1'b0;
    if(isScopyOp_0) begin
      anyScopyOp = 1'b1;
    end
  end

  assign isScopyOp_0 = ((io_loadSlots_0_valid && io_valid) && ((io_loadSlots_0_opcode == 4'b0110) || (io_loadSlots_0_opcode == 4'b0111)));
  always @(*) begin
    anyStoreOp = 1'b0;
    if(isStoreOp_0) begin
      anyStoreOp = 1'b1;
    end
  end

  assign isStoreOp_0 = ((io_storeSlots_0_valid && io_valid) && ((io_storeSlots_0_opcode == 3'b001) || (io_storeSlots_0_opcode == 3'b010)));
  assign matrixTransferRequested = 1'b0;
  assign when_MemoryEngine_l347 = (! matrixTransferRequested);
  assign matrixTransferInFlight = ((((((state == MemState_MATRIX_READ_AR) || (state == MemState_MATRIX_READ_R)) || (state == MemState_MATRIX_READ_DRAIN)) || (state == MemState_MATRIX_WRITE_GATHER)) || (state == MemState_MATRIX_WRITE_AW_W)) || (state == MemState_MATRIX_WRITE_B));
  assign scopyInFlight = ((state == MemState_SCOPY_M2V) || (state == MemState_SCOPY_V2M));
  assign scalarStoreInFlight = ((state == MemState_STORE_AW_W) || (state == MemState_STORE_B));
  assign scalarStorePending = (scalarStoreInFlight || (storeReqFifo_io_occupancy != 3'b000));
  assign regularMemBusyForMatrix = (loadReqValid || scalarStorePending);
  assign matrixBundleConflict = (matrixTransferRequested && (anyLoadOp || anyStoreOp));
  assign when_MemoryEngine_l365 = (anyLoadOp && loadReqValid);
  always @(*) begin
    _zz_when_MemoryEngine_l387 = 1'b0;
    if(when_MemoryEngine_l382) begin
      _zz_when_MemoryEngine_l387 = 1'b1;
    end
    if(when_MemoryEngine_l382_1) begin
      _zz_when_MemoryEngine_l387 = 1'b1;
    end
    if(when_MemoryEngine_l382_2) begin
      _zz_when_MemoryEngine_l387 = 1'b1;
    end
    if(when_MemoryEngine_l382_3) begin
      _zz_when_MemoryEngine_l387 = 1'b1;
    end
  end

  assign when_MemoryEngine_l382 = ((loadTrackValid_0 && (loadTrackCountdown_0 != 2'b00)) && (loadTrackDestAddr_0 == io_loadSlots_0_dest));
  assign when_MemoryEngine_l382_1 = ((loadTrackValid_1 && (loadTrackCountdown_1 != 2'b00)) && (loadTrackDestAddr_1 == io_loadSlots_0_dest));
  assign when_MemoryEngine_l382_2 = ((loadTrackValid_2 && (loadTrackCountdown_2 != 2'b00)) && (loadTrackDestAddr_2 == io_loadSlots_0_dest));
  assign when_MemoryEngine_l382_3 = ((loadTrackValid_3 && (loadTrackCountdown_3 != 2'b00)) && (loadTrackDestAddr_3 == io_loadSlots_0_dest));
  assign when_MemoryEngine_l387 = ((loadReqValid && (loadReqEntry_destAddr == io_loadSlots_0_dest)) || _zz_when_MemoryEngine_l387);
  assign when_MemoryEngine_l398 = (anyScopyOp && (state != MemState_IDLE));
  assign when_MemoryEngine_l404 = (anyStoreOp && loadReqValid);
  assign storeQueueFull = (! storeReqFifo_io_push_ready);
  assign storeQueueNearFullWithInFlight = ((state != MemState_IDLE) && (storeReqFifo_io_occupancy == 3'b011));
  assign stallOnStoreFull = (anyStoreOp && (storeQueueFull || storeQueueNearFullWithInFlight));
  assign when_MemoryEngine_l424 = (matrixTransferRequested && (matrixBundleConflict || regularMemBusyForMatrix));
  assign io_scalarStoreBusy = scalarStorePending;
  assign io_matrixTransferBusy = matrixTransferInFlight;
  assign io_matrixTransferBypassable = matrixTransferBypassable;
  assign when_MemoryEngine_l436 = (isLoadOp_0 && (! io_stall));
  assign _zz_loadReqEntry_axiAddr = _zz__zz_loadReqEntry_axiAddr[31:0];
  assign _zz_loadReqEntry_axiAddr_1 = (_zz_loadReqEntry_axiAddr & (~ alignMask));
  assign _zz_loadReqEntry_wordOff = _zz__zz_loadReqEntry_wordOff[3:0];
  assign _zz_loadReqEntry_axiAddr_2 = _zz__zz_loadReqEntry_axiAddr_2[31:0];
  assign when_MemoryEngine_l479 = (isStoreOp_0 && (! io_stall));
  assign _zz_io_push_payload_axiAddr_1 = _zz__zz_io_push_payload_axiAddr_1[31:0];
  assign _zz_when_MemoryEngine_l498 = _zz__zz_when_MemoryEngine_l498[3:0];
  always @(*) begin
    _zz_io_push_payload_wdata = 512'h0;
    case(io_storeSlots_0_opcode)
      3'b001 : begin
        if(when_MemoryEngine_l498) begin
          _zz_io_push_payload_wdata[31 : 0] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_1) begin
          _zz_io_push_payload_wdata[63 : 32] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_2) begin
          _zz_io_push_payload_wdata[95 : 64] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_3) begin
          _zz_io_push_payload_wdata[127 : 96] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_4) begin
          _zz_io_push_payload_wdata[159 : 128] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_5) begin
          _zz_io_push_payload_wdata[191 : 160] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_6) begin
          _zz_io_push_payload_wdata[223 : 192] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_7) begin
          _zz_io_push_payload_wdata[255 : 224] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_8) begin
          _zz_io_push_payload_wdata[287 : 256] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_9) begin
          _zz_io_push_payload_wdata[319 : 288] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_10) begin
          _zz_io_push_payload_wdata[351 : 320] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_11) begin
          _zz_io_push_payload_wdata[383 : 352] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_12) begin
          _zz_io_push_payload_wdata[415 : 384] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_13) begin
          _zz_io_push_payload_wdata[447 : 416] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_14) begin
          _zz_io_push_payload_wdata[479 : 448] = io_storeSrcData_0;
        end
        if(when_MemoryEngine_l498_15) begin
          _zz_io_push_payload_wdata[511 : 480] = io_storeSrcData_0;
        end
      end
      3'b010 : begin
        if(when_MemoryEngine_l516) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_1) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_2) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_3) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_4) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_5) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_6) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_7) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_8) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_9) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_10) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_11) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_12) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_13) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_14) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_15) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_0;
        end
        if(when_MemoryEngine_l516_16) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_17) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_18) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_19) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_20) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_21) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_22) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_23) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_24) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_25) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_26) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_27) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_28) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_29) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_30) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_31) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_1;
        end
        if(when_MemoryEngine_l516_32) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_33) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_34) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_35) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_36) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_37) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_38) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_39) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_40) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_41) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_42) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_43) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_44) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_45) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_46) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_47) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_2;
        end
        if(when_MemoryEngine_l516_48) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_49) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_50) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_51) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_52) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_53) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_54) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_55) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_56) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_57) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_58) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_59) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_60) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_61) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_62) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_63) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_3;
        end
        if(when_MemoryEngine_l516_64) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_65) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_66) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_67) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_68) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_69) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_70) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_71) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_72) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_73) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_74) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_75) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_76) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_77) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_78) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_79) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_4;
        end
        if(when_MemoryEngine_l516_80) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_81) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_82) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_83) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_84) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_85) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_86) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_87) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_88) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_89) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_90) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_91) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_92) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_93) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_94) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_95) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_5;
        end
        if(when_MemoryEngine_l516_96) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_97) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_98) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_99) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_100) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_101) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_102) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_103) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_104) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_105) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_106) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_107) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_108) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_109) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_110) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_111) begin
          _zz_io_push_payload_wdata[511 : 480] = io_vstoreSrcData_0_6;
        end
        if(when_MemoryEngine_l516_112) begin
          _zz_io_push_payload_wdata[31 : 0] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_113) begin
          _zz_io_push_payload_wdata[63 : 32] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_114) begin
          _zz_io_push_payload_wdata[95 : 64] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_115) begin
          _zz_io_push_payload_wdata[127 : 96] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_116) begin
          _zz_io_push_payload_wdata[159 : 128] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_117) begin
          _zz_io_push_payload_wdata[191 : 160] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_118) begin
          _zz_io_push_payload_wdata[223 : 192] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_119) begin
          _zz_io_push_payload_wdata[255 : 224] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_120) begin
          _zz_io_push_payload_wdata[287 : 256] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_121) begin
          _zz_io_push_payload_wdata[319 : 288] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_122) begin
          _zz_io_push_payload_wdata[351 : 320] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_123) begin
          _zz_io_push_payload_wdata[383 : 352] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_124) begin
          _zz_io_push_payload_wdata[415 : 384] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_125) begin
          _zz_io_push_payload_wdata[447 : 416] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_126) begin
          _zz_io_push_payload_wdata[479 : 448] = io_vstoreSrcData_0_7;
        end
        if(when_MemoryEngine_l516_127) begin
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
      3'b001 : begin
        if(when_MemoryEngine_l498) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l498_1) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l498_2) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l498_3) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l498_4) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l498_5) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l498_6) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l498_7) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l498_8) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l498_9) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l498_10) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l498_11) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l498_12) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l498_13) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l498_14) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l498_15) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
      end
      3'b010 : begin
        if(when_MemoryEngine_l516) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_1) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_2) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_3) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_4) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_5) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_6) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_7) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_8) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_9) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_10) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_11) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_12) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_13) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_14) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_15) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l516_16) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_17) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_18) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_19) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_20) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_21) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_22) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_23) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_24) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_25) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_26) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_27) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_28) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_29) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_30) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_31) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l516_32) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_33) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_34) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_35) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_36) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_37) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_38) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_39) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_40) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_41) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_42) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_43) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_44) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_45) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_46) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_47) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l516_48) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_49) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_50) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_51) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_52) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_53) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_54) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_55) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_56) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_57) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_58) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_59) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_60) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_61) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_62) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_63) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l516_64) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_65) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_66) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_67) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_68) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_69) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_70) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_71) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_72) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_73) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_74) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_75) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_76) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_77) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_78) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_79) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l516_80) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_81) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_82) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_83) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_84) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_85) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_86) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_87) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_88) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_89) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_90) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_91) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_92) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_93) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_94) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_95) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l516_96) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_97) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_98) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_99) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_100) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_101) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_102) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_103) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_104) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_105) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_106) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_107) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_108) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_109) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_110) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_111) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
        if(when_MemoryEngine_l516_112) begin
          _zz_io_push_payload_wstrb[3 : 0] = 4'b1111;
        end
        if(when_MemoryEngine_l516_113) begin
          _zz_io_push_payload_wstrb[7 : 4] = 4'b1111;
        end
        if(when_MemoryEngine_l516_114) begin
          _zz_io_push_payload_wstrb[11 : 8] = 4'b1111;
        end
        if(when_MemoryEngine_l516_115) begin
          _zz_io_push_payload_wstrb[15 : 12] = 4'b1111;
        end
        if(when_MemoryEngine_l516_116) begin
          _zz_io_push_payload_wstrb[19 : 16] = 4'b1111;
        end
        if(when_MemoryEngine_l516_117) begin
          _zz_io_push_payload_wstrb[23 : 20] = 4'b1111;
        end
        if(when_MemoryEngine_l516_118) begin
          _zz_io_push_payload_wstrb[27 : 24] = 4'b1111;
        end
        if(when_MemoryEngine_l516_119) begin
          _zz_io_push_payload_wstrb[31 : 28] = 4'b1111;
        end
        if(when_MemoryEngine_l516_120) begin
          _zz_io_push_payload_wstrb[35 : 32] = 4'b1111;
        end
        if(when_MemoryEngine_l516_121) begin
          _zz_io_push_payload_wstrb[39 : 36] = 4'b1111;
        end
        if(when_MemoryEngine_l516_122) begin
          _zz_io_push_payload_wstrb[43 : 40] = 4'b1111;
        end
        if(when_MemoryEngine_l516_123) begin
          _zz_io_push_payload_wstrb[47 : 44] = 4'b1111;
        end
        if(when_MemoryEngine_l516_124) begin
          _zz_io_push_payload_wstrb[51 : 48] = 4'b1111;
        end
        if(when_MemoryEngine_l516_125) begin
          _zz_io_push_payload_wstrb[55 : 52] = 4'b1111;
        end
        if(when_MemoryEngine_l516_126) begin
          _zz_io_push_payload_wstrb[59 : 56] = 4'b1111;
        end
        if(when_MemoryEngine_l516_127) begin
          _zz_io_push_payload_wstrb[63 : 60] = 4'b1111;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_MemoryEngine_l498 = (_zz_when_MemoryEngine_l498 == 4'b0000);
  assign when_MemoryEngine_l498_1 = (_zz_when_MemoryEngine_l498 == 4'b0001);
  assign when_MemoryEngine_l498_2 = (_zz_when_MemoryEngine_l498 == 4'b0010);
  assign when_MemoryEngine_l498_3 = (_zz_when_MemoryEngine_l498 == 4'b0011);
  assign when_MemoryEngine_l498_4 = (_zz_when_MemoryEngine_l498 == 4'b0100);
  assign when_MemoryEngine_l498_5 = (_zz_when_MemoryEngine_l498 == 4'b0101);
  assign when_MemoryEngine_l498_6 = (_zz_when_MemoryEngine_l498 == 4'b0110);
  assign when_MemoryEngine_l498_7 = (_zz_when_MemoryEngine_l498 == 4'b0111);
  assign when_MemoryEngine_l498_8 = (_zz_when_MemoryEngine_l498 == 4'b1000);
  assign when_MemoryEngine_l498_9 = (_zz_when_MemoryEngine_l498 == 4'b1001);
  assign when_MemoryEngine_l498_10 = (_zz_when_MemoryEngine_l498 == 4'b1010);
  assign when_MemoryEngine_l498_11 = (_zz_when_MemoryEngine_l498 == 4'b1011);
  assign when_MemoryEngine_l498_12 = (_zz_when_MemoryEngine_l498 == 4'b1100);
  assign when_MemoryEngine_l498_13 = (_zz_when_MemoryEngine_l498 == 4'b1101);
  assign when_MemoryEngine_l498_14 = (_zz_when_MemoryEngine_l498 == 4'b1110);
  assign when_MemoryEngine_l498_15 = (_zz_when_MemoryEngine_l498 == 4'b1111);
  assign _zz_when_MemoryEngine_l516 = (_zz_when_MemoryEngine_l498 + 4'b0000);
  assign when_MemoryEngine_l516 = (_zz_when_MemoryEngine_l516 == 4'b0000);
  assign when_MemoryEngine_l516_1 = (_zz_when_MemoryEngine_l516 == 4'b0001);
  assign when_MemoryEngine_l516_2 = (_zz_when_MemoryEngine_l516 == 4'b0010);
  assign when_MemoryEngine_l516_3 = (_zz_when_MemoryEngine_l516 == 4'b0011);
  assign when_MemoryEngine_l516_4 = (_zz_when_MemoryEngine_l516 == 4'b0100);
  assign when_MemoryEngine_l516_5 = (_zz_when_MemoryEngine_l516 == 4'b0101);
  assign when_MemoryEngine_l516_6 = (_zz_when_MemoryEngine_l516 == 4'b0110);
  assign when_MemoryEngine_l516_7 = (_zz_when_MemoryEngine_l516 == 4'b0111);
  assign when_MemoryEngine_l516_8 = (_zz_when_MemoryEngine_l516 == 4'b1000);
  assign when_MemoryEngine_l516_9 = (_zz_when_MemoryEngine_l516 == 4'b1001);
  assign when_MemoryEngine_l516_10 = (_zz_when_MemoryEngine_l516 == 4'b1010);
  assign when_MemoryEngine_l516_11 = (_zz_when_MemoryEngine_l516 == 4'b1011);
  assign when_MemoryEngine_l516_12 = (_zz_when_MemoryEngine_l516 == 4'b1100);
  assign when_MemoryEngine_l516_13 = (_zz_when_MemoryEngine_l516 == 4'b1101);
  assign when_MemoryEngine_l516_14 = (_zz_when_MemoryEngine_l516 == 4'b1110);
  assign when_MemoryEngine_l516_15 = (_zz_when_MemoryEngine_l516 == 4'b1111);
  assign _zz_when_MemoryEngine_l516_1 = (_zz_when_MemoryEngine_l498 + 4'b0001);
  assign when_MemoryEngine_l516_16 = (_zz_when_MemoryEngine_l516_1 == 4'b0000);
  assign when_MemoryEngine_l516_17 = (_zz_when_MemoryEngine_l516_1 == 4'b0001);
  assign when_MemoryEngine_l516_18 = (_zz_when_MemoryEngine_l516_1 == 4'b0010);
  assign when_MemoryEngine_l516_19 = (_zz_when_MemoryEngine_l516_1 == 4'b0011);
  assign when_MemoryEngine_l516_20 = (_zz_when_MemoryEngine_l516_1 == 4'b0100);
  assign when_MemoryEngine_l516_21 = (_zz_when_MemoryEngine_l516_1 == 4'b0101);
  assign when_MemoryEngine_l516_22 = (_zz_when_MemoryEngine_l516_1 == 4'b0110);
  assign when_MemoryEngine_l516_23 = (_zz_when_MemoryEngine_l516_1 == 4'b0111);
  assign when_MemoryEngine_l516_24 = (_zz_when_MemoryEngine_l516_1 == 4'b1000);
  assign when_MemoryEngine_l516_25 = (_zz_when_MemoryEngine_l516_1 == 4'b1001);
  assign when_MemoryEngine_l516_26 = (_zz_when_MemoryEngine_l516_1 == 4'b1010);
  assign when_MemoryEngine_l516_27 = (_zz_when_MemoryEngine_l516_1 == 4'b1011);
  assign when_MemoryEngine_l516_28 = (_zz_when_MemoryEngine_l516_1 == 4'b1100);
  assign when_MemoryEngine_l516_29 = (_zz_when_MemoryEngine_l516_1 == 4'b1101);
  assign when_MemoryEngine_l516_30 = (_zz_when_MemoryEngine_l516_1 == 4'b1110);
  assign when_MemoryEngine_l516_31 = (_zz_when_MemoryEngine_l516_1 == 4'b1111);
  assign _zz_when_MemoryEngine_l516_2 = (_zz_when_MemoryEngine_l498 + 4'b0010);
  assign when_MemoryEngine_l516_32 = (_zz_when_MemoryEngine_l516_2 == 4'b0000);
  assign when_MemoryEngine_l516_33 = (_zz_when_MemoryEngine_l516_2 == 4'b0001);
  assign when_MemoryEngine_l516_34 = (_zz_when_MemoryEngine_l516_2 == 4'b0010);
  assign when_MemoryEngine_l516_35 = (_zz_when_MemoryEngine_l516_2 == 4'b0011);
  assign when_MemoryEngine_l516_36 = (_zz_when_MemoryEngine_l516_2 == 4'b0100);
  assign when_MemoryEngine_l516_37 = (_zz_when_MemoryEngine_l516_2 == 4'b0101);
  assign when_MemoryEngine_l516_38 = (_zz_when_MemoryEngine_l516_2 == 4'b0110);
  assign when_MemoryEngine_l516_39 = (_zz_when_MemoryEngine_l516_2 == 4'b0111);
  assign when_MemoryEngine_l516_40 = (_zz_when_MemoryEngine_l516_2 == 4'b1000);
  assign when_MemoryEngine_l516_41 = (_zz_when_MemoryEngine_l516_2 == 4'b1001);
  assign when_MemoryEngine_l516_42 = (_zz_when_MemoryEngine_l516_2 == 4'b1010);
  assign when_MemoryEngine_l516_43 = (_zz_when_MemoryEngine_l516_2 == 4'b1011);
  assign when_MemoryEngine_l516_44 = (_zz_when_MemoryEngine_l516_2 == 4'b1100);
  assign when_MemoryEngine_l516_45 = (_zz_when_MemoryEngine_l516_2 == 4'b1101);
  assign when_MemoryEngine_l516_46 = (_zz_when_MemoryEngine_l516_2 == 4'b1110);
  assign when_MemoryEngine_l516_47 = (_zz_when_MemoryEngine_l516_2 == 4'b1111);
  assign _zz_when_MemoryEngine_l516_3 = (_zz_when_MemoryEngine_l498 + 4'b0011);
  assign when_MemoryEngine_l516_48 = (_zz_when_MemoryEngine_l516_3 == 4'b0000);
  assign when_MemoryEngine_l516_49 = (_zz_when_MemoryEngine_l516_3 == 4'b0001);
  assign when_MemoryEngine_l516_50 = (_zz_when_MemoryEngine_l516_3 == 4'b0010);
  assign when_MemoryEngine_l516_51 = (_zz_when_MemoryEngine_l516_3 == 4'b0011);
  assign when_MemoryEngine_l516_52 = (_zz_when_MemoryEngine_l516_3 == 4'b0100);
  assign when_MemoryEngine_l516_53 = (_zz_when_MemoryEngine_l516_3 == 4'b0101);
  assign when_MemoryEngine_l516_54 = (_zz_when_MemoryEngine_l516_3 == 4'b0110);
  assign when_MemoryEngine_l516_55 = (_zz_when_MemoryEngine_l516_3 == 4'b0111);
  assign when_MemoryEngine_l516_56 = (_zz_when_MemoryEngine_l516_3 == 4'b1000);
  assign when_MemoryEngine_l516_57 = (_zz_when_MemoryEngine_l516_3 == 4'b1001);
  assign when_MemoryEngine_l516_58 = (_zz_when_MemoryEngine_l516_3 == 4'b1010);
  assign when_MemoryEngine_l516_59 = (_zz_when_MemoryEngine_l516_3 == 4'b1011);
  assign when_MemoryEngine_l516_60 = (_zz_when_MemoryEngine_l516_3 == 4'b1100);
  assign when_MemoryEngine_l516_61 = (_zz_when_MemoryEngine_l516_3 == 4'b1101);
  assign when_MemoryEngine_l516_62 = (_zz_when_MemoryEngine_l516_3 == 4'b1110);
  assign when_MemoryEngine_l516_63 = (_zz_when_MemoryEngine_l516_3 == 4'b1111);
  assign _zz_when_MemoryEngine_l516_4 = (_zz_when_MemoryEngine_l498 + 4'b0100);
  assign when_MemoryEngine_l516_64 = (_zz_when_MemoryEngine_l516_4 == 4'b0000);
  assign when_MemoryEngine_l516_65 = (_zz_when_MemoryEngine_l516_4 == 4'b0001);
  assign when_MemoryEngine_l516_66 = (_zz_when_MemoryEngine_l516_4 == 4'b0010);
  assign when_MemoryEngine_l516_67 = (_zz_when_MemoryEngine_l516_4 == 4'b0011);
  assign when_MemoryEngine_l516_68 = (_zz_when_MemoryEngine_l516_4 == 4'b0100);
  assign when_MemoryEngine_l516_69 = (_zz_when_MemoryEngine_l516_4 == 4'b0101);
  assign when_MemoryEngine_l516_70 = (_zz_when_MemoryEngine_l516_4 == 4'b0110);
  assign when_MemoryEngine_l516_71 = (_zz_when_MemoryEngine_l516_4 == 4'b0111);
  assign when_MemoryEngine_l516_72 = (_zz_when_MemoryEngine_l516_4 == 4'b1000);
  assign when_MemoryEngine_l516_73 = (_zz_when_MemoryEngine_l516_4 == 4'b1001);
  assign when_MemoryEngine_l516_74 = (_zz_when_MemoryEngine_l516_4 == 4'b1010);
  assign when_MemoryEngine_l516_75 = (_zz_when_MemoryEngine_l516_4 == 4'b1011);
  assign when_MemoryEngine_l516_76 = (_zz_when_MemoryEngine_l516_4 == 4'b1100);
  assign when_MemoryEngine_l516_77 = (_zz_when_MemoryEngine_l516_4 == 4'b1101);
  assign when_MemoryEngine_l516_78 = (_zz_when_MemoryEngine_l516_4 == 4'b1110);
  assign when_MemoryEngine_l516_79 = (_zz_when_MemoryEngine_l516_4 == 4'b1111);
  assign _zz_when_MemoryEngine_l516_5 = (_zz_when_MemoryEngine_l498 + 4'b0101);
  assign when_MemoryEngine_l516_80 = (_zz_when_MemoryEngine_l516_5 == 4'b0000);
  assign when_MemoryEngine_l516_81 = (_zz_when_MemoryEngine_l516_5 == 4'b0001);
  assign when_MemoryEngine_l516_82 = (_zz_when_MemoryEngine_l516_5 == 4'b0010);
  assign when_MemoryEngine_l516_83 = (_zz_when_MemoryEngine_l516_5 == 4'b0011);
  assign when_MemoryEngine_l516_84 = (_zz_when_MemoryEngine_l516_5 == 4'b0100);
  assign when_MemoryEngine_l516_85 = (_zz_when_MemoryEngine_l516_5 == 4'b0101);
  assign when_MemoryEngine_l516_86 = (_zz_when_MemoryEngine_l516_5 == 4'b0110);
  assign when_MemoryEngine_l516_87 = (_zz_when_MemoryEngine_l516_5 == 4'b0111);
  assign when_MemoryEngine_l516_88 = (_zz_when_MemoryEngine_l516_5 == 4'b1000);
  assign when_MemoryEngine_l516_89 = (_zz_when_MemoryEngine_l516_5 == 4'b1001);
  assign when_MemoryEngine_l516_90 = (_zz_when_MemoryEngine_l516_5 == 4'b1010);
  assign when_MemoryEngine_l516_91 = (_zz_when_MemoryEngine_l516_5 == 4'b1011);
  assign when_MemoryEngine_l516_92 = (_zz_when_MemoryEngine_l516_5 == 4'b1100);
  assign when_MemoryEngine_l516_93 = (_zz_when_MemoryEngine_l516_5 == 4'b1101);
  assign when_MemoryEngine_l516_94 = (_zz_when_MemoryEngine_l516_5 == 4'b1110);
  assign when_MemoryEngine_l516_95 = (_zz_when_MemoryEngine_l516_5 == 4'b1111);
  assign _zz_when_MemoryEngine_l516_6 = (_zz_when_MemoryEngine_l498 + 4'b0110);
  assign when_MemoryEngine_l516_96 = (_zz_when_MemoryEngine_l516_6 == 4'b0000);
  assign when_MemoryEngine_l516_97 = (_zz_when_MemoryEngine_l516_6 == 4'b0001);
  assign when_MemoryEngine_l516_98 = (_zz_when_MemoryEngine_l516_6 == 4'b0010);
  assign when_MemoryEngine_l516_99 = (_zz_when_MemoryEngine_l516_6 == 4'b0011);
  assign when_MemoryEngine_l516_100 = (_zz_when_MemoryEngine_l516_6 == 4'b0100);
  assign when_MemoryEngine_l516_101 = (_zz_when_MemoryEngine_l516_6 == 4'b0101);
  assign when_MemoryEngine_l516_102 = (_zz_when_MemoryEngine_l516_6 == 4'b0110);
  assign when_MemoryEngine_l516_103 = (_zz_when_MemoryEngine_l516_6 == 4'b0111);
  assign when_MemoryEngine_l516_104 = (_zz_when_MemoryEngine_l516_6 == 4'b1000);
  assign when_MemoryEngine_l516_105 = (_zz_when_MemoryEngine_l516_6 == 4'b1001);
  assign when_MemoryEngine_l516_106 = (_zz_when_MemoryEngine_l516_6 == 4'b1010);
  assign when_MemoryEngine_l516_107 = (_zz_when_MemoryEngine_l516_6 == 4'b1011);
  assign when_MemoryEngine_l516_108 = (_zz_when_MemoryEngine_l516_6 == 4'b1100);
  assign when_MemoryEngine_l516_109 = (_zz_when_MemoryEngine_l516_6 == 4'b1101);
  assign when_MemoryEngine_l516_110 = (_zz_when_MemoryEngine_l516_6 == 4'b1110);
  assign when_MemoryEngine_l516_111 = (_zz_when_MemoryEngine_l516_6 == 4'b1111);
  assign _zz_when_MemoryEngine_l516_7 = (_zz_when_MemoryEngine_l498 + 4'b0111);
  assign when_MemoryEngine_l516_112 = (_zz_when_MemoryEngine_l516_7 == 4'b0000);
  assign when_MemoryEngine_l516_113 = (_zz_when_MemoryEngine_l516_7 == 4'b0001);
  assign when_MemoryEngine_l516_114 = (_zz_when_MemoryEngine_l516_7 == 4'b0010);
  assign when_MemoryEngine_l516_115 = (_zz_when_MemoryEngine_l516_7 == 4'b0011);
  assign when_MemoryEngine_l516_116 = (_zz_when_MemoryEngine_l516_7 == 4'b0100);
  assign when_MemoryEngine_l516_117 = (_zz_when_MemoryEngine_l516_7 == 4'b0101);
  assign when_MemoryEngine_l516_118 = (_zz_when_MemoryEngine_l516_7 == 4'b0110);
  assign when_MemoryEngine_l516_119 = (_zz_when_MemoryEngine_l516_7 == 4'b0111);
  assign when_MemoryEngine_l516_120 = (_zz_when_MemoryEngine_l516_7 == 4'b1000);
  assign when_MemoryEngine_l516_121 = (_zz_when_MemoryEngine_l516_7 == 4'b1001);
  assign when_MemoryEngine_l516_122 = (_zz_when_MemoryEngine_l516_7 == 4'b1010);
  assign when_MemoryEngine_l516_123 = (_zz_when_MemoryEngine_l516_7 == 4'b1011);
  assign when_MemoryEngine_l516_124 = (_zz_when_MemoryEngine_l516_7 == 4'b1100);
  assign when_MemoryEngine_l516_125 = (_zz_when_MemoryEngine_l516_7 == 4'b1101);
  assign when_MemoryEngine_l516_126 = (_zz_when_MemoryEngine_l516_7 == 4'b1110);
  assign when_MemoryEngine_l516_127 = (_zz_when_MemoryEngine_l516_7 == 4'b1111);
  assign when_MemoryEngine_l581 = ((isScopyOp_0 && (! io_stall)) && (state == MemState_IDLE));
  assign when_MemoryEngine_l591 = (io_loadSlots_0_opcode == 4'b0110);
  always @(*) begin
    storeReqFifo_io_pop_ready = 1'b0;
    case(state)
      MemState_IDLE : begin
        if(storeReqFifo_io_pop_valid) begin
          storeReqFifo_io_pop_ready = 1'b1;
        end
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_valid = (loadReqValid && (! loadAddrAccepted));
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
        io_axiMaster_ar_valid = 1'b1;
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_payload_addr = loadReqEntry_axiAddr;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
        io_axiMaster_ar_payload_addr = matrixDramAddr;
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
        io_axiMaster_ar_payload_len = 8'h0;
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
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
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
        io_axiMaster_ar_payload_size = axiSizeVal;
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_payload_burst = 2'b01;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
        io_axiMaster_ar_payload_burst = 2'b01;
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_axiMaster_ar_payload_id = 4'b0000;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
        io_axiMaster_ar_payload_id = 4'b0000;
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end

  assign io_axiMaster_ar_fire = (io_axiMaster_ar_valid && io_axiMaster_ar_ready);
  always @(*) begin
    io_axiMaster_r_ready = loadReqValid;
    case(state)
      MemState_IDLE : begin
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
        io_axiMaster_r_ready = 1'b1;
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end

  assign when_MemoryEngine_l623 = (io_axiMaster_r_valid && loadReqValid);
  assign when_MemoryEngine_l629 = (loadReqEntry_slotIdx == 1'b0);
  assign when_MemoryEngine_l630 = (! loadReqEntry_isVector);
  always @(*) begin
    _zz_io_loadWriteReqs_0_payload_data = 32'h0;
    if(when_MemoryEngine_l635) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l635_1) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l635_2) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l635_3) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l635_4) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l635_5) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l635_6) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l635_7) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l635_8) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l635_9) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l635_10) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l635_11) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l635_12) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l635_13) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l635_14) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l635_15) begin
      _zz_io_loadWriteReqs_0_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign when_MemoryEngine_l635 = (loadReqEntry_wordOff == 4'b0000);
  assign when_MemoryEngine_l635_1 = (loadReqEntry_wordOff == 4'b0001);
  assign when_MemoryEngine_l635_2 = (loadReqEntry_wordOff == 4'b0010);
  assign when_MemoryEngine_l635_3 = (loadReqEntry_wordOff == 4'b0011);
  assign when_MemoryEngine_l635_4 = (loadReqEntry_wordOff == 4'b0100);
  assign when_MemoryEngine_l635_5 = (loadReqEntry_wordOff == 4'b0101);
  assign when_MemoryEngine_l635_6 = (loadReqEntry_wordOff == 4'b0110);
  assign when_MemoryEngine_l635_7 = (loadReqEntry_wordOff == 4'b0111);
  assign when_MemoryEngine_l635_8 = (loadReqEntry_wordOff == 4'b1000);
  assign when_MemoryEngine_l635_9 = (loadReqEntry_wordOff == 4'b1001);
  assign when_MemoryEngine_l635_10 = (loadReqEntry_wordOff == 4'b1010);
  assign when_MemoryEngine_l635_11 = (loadReqEntry_wordOff == 4'b1011);
  assign when_MemoryEngine_l635_12 = (loadReqEntry_wordOff == 4'b1100);
  assign when_MemoryEngine_l635_13 = (loadReqEntry_wordOff == 4'b1101);
  assign when_MemoryEngine_l635_14 = (loadReqEntry_wordOff == 4'b1110);
  assign when_MemoryEngine_l635_15 = (loadReqEntry_wordOff == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_0_payload_data = 32'h0;
    if(when_MemoryEngine_l649) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_1) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_2) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_3) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_4) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_5) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_6) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_7) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_8) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_9) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_10) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_11) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_12) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_13) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_14) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_15) begin
      _zz_io_vloadWriteReqs_0_0_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649 = (loadReqEntry_wordOff + 4'b0000);
  assign when_MemoryEngine_l649 = (_zz_when_MemoryEngine_l649 == 4'b0000);
  assign when_MemoryEngine_l649_1 = (_zz_when_MemoryEngine_l649 == 4'b0001);
  assign when_MemoryEngine_l649_2 = (_zz_when_MemoryEngine_l649 == 4'b0010);
  assign when_MemoryEngine_l649_3 = (_zz_when_MemoryEngine_l649 == 4'b0011);
  assign when_MemoryEngine_l649_4 = (_zz_when_MemoryEngine_l649 == 4'b0100);
  assign when_MemoryEngine_l649_5 = (_zz_when_MemoryEngine_l649 == 4'b0101);
  assign when_MemoryEngine_l649_6 = (_zz_when_MemoryEngine_l649 == 4'b0110);
  assign when_MemoryEngine_l649_7 = (_zz_when_MemoryEngine_l649 == 4'b0111);
  assign when_MemoryEngine_l649_8 = (_zz_when_MemoryEngine_l649 == 4'b1000);
  assign when_MemoryEngine_l649_9 = (_zz_when_MemoryEngine_l649 == 4'b1001);
  assign when_MemoryEngine_l649_10 = (_zz_when_MemoryEngine_l649 == 4'b1010);
  assign when_MemoryEngine_l649_11 = (_zz_when_MemoryEngine_l649 == 4'b1011);
  assign when_MemoryEngine_l649_12 = (_zz_when_MemoryEngine_l649 == 4'b1100);
  assign when_MemoryEngine_l649_13 = (_zz_when_MemoryEngine_l649 == 4'b1101);
  assign when_MemoryEngine_l649_14 = (_zz_when_MemoryEngine_l649 == 4'b1110);
  assign when_MemoryEngine_l649_15 = (_zz_when_MemoryEngine_l649 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_1_payload_data = 32'h0;
    if(when_MemoryEngine_l649_16) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_17) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_18) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_19) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_20) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_21) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_22) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_23) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_24) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_25) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_26) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_27) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_28) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_29) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_30) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_31) begin
      _zz_io_vloadWriteReqs_0_1_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649_1 = (loadReqEntry_wordOff + 4'b0001);
  assign when_MemoryEngine_l649_16 = (_zz_when_MemoryEngine_l649_1 == 4'b0000);
  assign when_MemoryEngine_l649_17 = (_zz_when_MemoryEngine_l649_1 == 4'b0001);
  assign when_MemoryEngine_l649_18 = (_zz_when_MemoryEngine_l649_1 == 4'b0010);
  assign when_MemoryEngine_l649_19 = (_zz_when_MemoryEngine_l649_1 == 4'b0011);
  assign when_MemoryEngine_l649_20 = (_zz_when_MemoryEngine_l649_1 == 4'b0100);
  assign when_MemoryEngine_l649_21 = (_zz_when_MemoryEngine_l649_1 == 4'b0101);
  assign when_MemoryEngine_l649_22 = (_zz_when_MemoryEngine_l649_1 == 4'b0110);
  assign when_MemoryEngine_l649_23 = (_zz_when_MemoryEngine_l649_1 == 4'b0111);
  assign when_MemoryEngine_l649_24 = (_zz_when_MemoryEngine_l649_1 == 4'b1000);
  assign when_MemoryEngine_l649_25 = (_zz_when_MemoryEngine_l649_1 == 4'b1001);
  assign when_MemoryEngine_l649_26 = (_zz_when_MemoryEngine_l649_1 == 4'b1010);
  assign when_MemoryEngine_l649_27 = (_zz_when_MemoryEngine_l649_1 == 4'b1011);
  assign when_MemoryEngine_l649_28 = (_zz_when_MemoryEngine_l649_1 == 4'b1100);
  assign when_MemoryEngine_l649_29 = (_zz_when_MemoryEngine_l649_1 == 4'b1101);
  assign when_MemoryEngine_l649_30 = (_zz_when_MemoryEngine_l649_1 == 4'b1110);
  assign when_MemoryEngine_l649_31 = (_zz_when_MemoryEngine_l649_1 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_2_payload_data = 32'h0;
    if(when_MemoryEngine_l649_32) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_33) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_34) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_35) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_36) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_37) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_38) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_39) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_40) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_41) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_42) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_43) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_44) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_45) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_46) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_47) begin
      _zz_io_vloadWriteReqs_0_2_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649_2 = (loadReqEntry_wordOff + 4'b0010);
  assign when_MemoryEngine_l649_32 = (_zz_when_MemoryEngine_l649_2 == 4'b0000);
  assign when_MemoryEngine_l649_33 = (_zz_when_MemoryEngine_l649_2 == 4'b0001);
  assign when_MemoryEngine_l649_34 = (_zz_when_MemoryEngine_l649_2 == 4'b0010);
  assign when_MemoryEngine_l649_35 = (_zz_when_MemoryEngine_l649_2 == 4'b0011);
  assign when_MemoryEngine_l649_36 = (_zz_when_MemoryEngine_l649_2 == 4'b0100);
  assign when_MemoryEngine_l649_37 = (_zz_when_MemoryEngine_l649_2 == 4'b0101);
  assign when_MemoryEngine_l649_38 = (_zz_when_MemoryEngine_l649_2 == 4'b0110);
  assign when_MemoryEngine_l649_39 = (_zz_when_MemoryEngine_l649_2 == 4'b0111);
  assign when_MemoryEngine_l649_40 = (_zz_when_MemoryEngine_l649_2 == 4'b1000);
  assign when_MemoryEngine_l649_41 = (_zz_when_MemoryEngine_l649_2 == 4'b1001);
  assign when_MemoryEngine_l649_42 = (_zz_when_MemoryEngine_l649_2 == 4'b1010);
  assign when_MemoryEngine_l649_43 = (_zz_when_MemoryEngine_l649_2 == 4'b1011);
  assign when_MemoryEngine_l649_44 = (_zz_when_MemoryEngine_l649_2 == 4'b1100);
  assign when_MemoryEngine_l649_45 = (_zz_when_MemoryEngine_l649_2 == 4'b1101);
  assign when_MemoryEngine_l649_46 = (_zz_when_MemoryEngine_l649_2 == 4'b1110);
  assign when_MemoryEngine_l649_47 = (_zz_when_MemoryEngine_l649_2 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_3_payload_data = 32'h0;
    if(when_MemoryEngine_l649_48) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_49) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_50) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_51) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_52) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_53) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_54) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_55) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_56) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_57) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_58) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_59) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_60) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_61) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_62) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_63) begin
      _zz_io_vloadWriteReqs_0_3_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649_3 = (loadReqEntry_wordOff + 4'b0011);
  assign when_MemoryEngine_l649_48 = (_zz_when_MemoryEngine_l649_3 == 4'b0000);
  assign when_MemoryEngine_l649_49 = (_zz_when_MemoryEngine_l649_3 == 4'b0001);
  assign when_MemoryEngine_l649_50 = (_zz_when_MemoryEngine_l649_3 == 4'b0010);
  assign when_MemoryEngine_l649_51 = (_zz_when_MemoryEngine_l649_3 == 4'b0011);
  assign when_MemoryEngine_l649_52 = (_zz_when_MemoryEngine_l649_3 == 4'b0100);
  assign when_MemoryEngine_l649_53 = (_zz_when_MemoryEngine_l649_3 == 4'b0101);
  assign when_MemoryEngine_l649_54 = (_zz_when_MemoryEngine_l649_3 == 4'b0110);
  assign when_MemoryEngine_l649_55 = (_zz_when_MemoryEngine_l649_3 == 4'b0111);
  assign when_MemoryEngine_l649_56 = (_zz_when_MemoryEngine_l649_3 == 4'b1000);
  assign when_MemoryEngine_l649_57 = (_zz_when_MemoryEngine_l649_3 == 4'b1001);
  assign when_MemoryEngine_l649_58 = (_zz_when_MemoryEngine_l649_3 == 4'b1010);
  assign when_MemoryEngine_l649_59 = (_zz_when_MemoryEngine_l649_3 == 4'b1011);
  assign when_MemoryEngine_l649_60 = (_zz_when_MemoryEngine_l649_3 == 4'b1100);
  assign when_MemoryEngine_l649_61 = (_zz_when_MemoryEngine_l649_3 == 4'b1101);
  assign when_MemoryEngine_l649_62 = (_zz_when_MemoryEngine_l649_3 == 4'b1110);
  assign when_MemoryEngine_l649_63 = (_zz_when_MemoryEngine_l649_3 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_4_payload_data = 32'h0;
    if(when_MemoryEngine_l649_64) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_65) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_66) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_67) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_68) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_69) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_70) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_71) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_72) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_73) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_74) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_75) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_76) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_77) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_78) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_79) begin
      _zz_io_vloadWriteReqs_0_4_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649_4 = (loadReqEntry_wordOff + 4'b0100);
  assign when_MemoryEngine_l649_64 = (_zz_when_MemoryEngine_l649_4 == 4'b0000);
  assign when_MemoryEngine_l649_65 = (_zz_when_MemoryEngine_l649_4 == 4'b0001);
  assign when_MemoryEngine_l649_66 = (_zz_when_MemoryEngine_l649_4 == 4'b0010);
  assign when_MemoryEngine_l649_67 = (_zz_when_MemoryEngine_l649_4 == 4'b0011);
  assign when_MemoryEngine_l649_68 = (_zz_when_MemoryEngine_l649_4 == 4'b0100);
  assign when_MemoryEngine_l649_69 = (_zz_when_MemoryEngine_l649_4 == 4'b0101);
  assign when_MemoryEngine_l649_70 = (_zz_when_MemoryEngine_l649_4 == 4'b0110);
  assign when_MemoryEngine_l649_71 = (_zz_when_MemoryEngine_l649_4 == 4'b0111);
  assign when_MemoryEngine_l649_72 = (_zz_when_MemoryEngine_l649_4 == 4'b1000);
  assign when_MemoryEngine_l649_73 = (_zz_when_MemoryEngine_l649_4 == 4'b1001);
  assign when_MemoryEngine_l649_74 = (_zz_when_MemoryEngine_l649_4 == 4'b1010);
  assign when_MemoryEngine_l649_75 = (_zz_when_MemoryEngine_l649_4 == 4'b1011);
  assign when_MemoryEngine_l649_76 = (_zz_when_MemoryEngine_l649_4 == 4'b1100);
  assign when_MemoryEngine_l649_77 = (_zz_when_MemoryEngine_l649_4 == 4'b1101);
  assign when_MemoryEngine_l649_78 = (_zz_when_MemoryEngine_l649_4 == 4'b1110);
  assign when_MemoryEngine_l649_79 = (_zz_when_MemoryEngine_l649_4 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_5_payload_data = 32'h0;
    if(when_MemoryEngine_l649_80) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_81) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_82) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_83) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_84) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_85) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_86) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_87) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_88) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_89) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_90) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_91) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_92) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_93) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_94) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_95) begin
      _zz_io_vloadWriteReqs_0_5_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649_5 = (loadReqEntry_wordOff + 4'b0101);
  assign when_MemoryEngine_l649_80 = (_zz_when_MemoryEngine_l649_5 == 4'b0000);
  assign when_MemoryEngine_l649_81 = (_zz_when_MemoryEngine_l649_5 == 4'b0001);
  assign when_MemoryEngine_l649_82 = (_zz_when_MemoryEngine_l649_5 == 4'b0010);
  assign when_MemoryEngine_l649_83 = (_zz_when_MemoryEngine_l649_5 == 4'b0011);
  assign when_MemoryEngine_l649_84 = (_zz_when_MemoryEngine_l649_5 == 4'b0100);
  assign when_MemoryEngine_l649_85 = (_zz_when_MemoryEngine_l649_5 == 4'b0101);
  assign when_MemoryEngine_l649_86 = (_zz_when_MemoryEngine_l649_5 == 4'b0110);
  assign when_MemoryEngine_l649_87 = (_zz_when_MemoryEngine_l649_5 == 4'b0111);
  assign when_MemoryEngine_l649_88 = (_zz_when_MemoryEngine_l649_5 == 4'b1000);
  assign when_MemoryEngine_l649_89 = (_zz_when_MemoryEngine_l649_5 == 4'b1001);
  assign when_MemoryEngine_l649_90 = (_zz_when_MemoryEngine_l649_5 == 4'b1010);
  assign when_MemoryEngine_l649_91 = (_zz_when_MemoryEngine_l649_5 == 4'b1011);
  assign when_MemoryEngine_l649_92 = (_zz_when_MemoryEngine_l649_5 == 4'b1100);
  assign when_MemoryEngine_l649_93 = (_zz_when_MemoryEngine_l649_5 == 4'b1101);
  assign when_MemoryEngine_l649_94 = (_zz_when_MemoryEngine_l649_5 == 4'b1110);
  assign when_MemoryEngine_l649_95 = (_zz_when_MemoryEngine_l649_5 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_6_payload_data = 32'h0;
    if(when_MemoryEngine_l649_96) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_97) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_98) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_99) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_100) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_101) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_102) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_103) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_104) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_105) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_106) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_107) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_108) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_109) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_110) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_111) begin
      _zz_io_vloadWriteReqs_0_6_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649_6 = (loadReqEntry_wordOff + 4'b0110);
  assign when_MemoryEngine_l649_96 = (_zz_when_MemoryEngine_l649_6 == 4'b0000);
  assign when_MemoryEngine_l649_97 = (_zz_when_MemoryEngine_l649_6 == 4'b0001);
  assign when_MemoryEngine_l649_98 = (_zz_when_MemoryEngine_l649_6 == 4'b0010);
  assign when_MemoryEngine_l649_99 = (_zz_when_MemoryEngine_l649_6 == 4'b0011);
  assign when_MemoryEngine_l649_100 = (_zz_when_MemoryEngine_l649_6 == 4'b0100);
  assign when_MemoryEngine_l649_101 = (_zz_when_MemoryEngine_l649_6 == 4'b0101);
  assign when_MemoryEngine_l649_102 = (_zz_when_MemoryEngine_l649_6 == 4'b0110);
  assign when_MemoryEngine_l649_103 = (_zz_when_MemoryEngine_l649_6 == 4'b0111);
  assign when_MemoryEngine_l649_104 = (_zz_when_MemoryEngine_l649_6 == 4'b1000);
  assign when_MemoryEngine_l649_105 = (_zz_when_MemoryEngine_l649_6 == 4'b1001);
  assign when_MemoryEngine_l649_106 = (_zz_when_MemoryEngine_l649_6 == 4'b1010);
  assign when_MemoryEngine_l649_107 = (_zz_when_MemoryEngine_l649_6 == 4'b1011);
  assign when_MemoryEngine_l649_108 = (_zz_when_MemoryEngine_l649_6 == 4'b1100);
  assign when_MemoryEngine_l649_109 = (_zz_when_MemoryEngine_l649_6 == 4'b1101);
  assign when_MemoryEngine_l649_110 = (_zz_when_MemoryEngine_l649_6 == 4'b1110);
  assign when_MemoryEngine_l649_111 = (_zz_when_MemoryEngine_l649_6 == 4'b1111);
  always @(*) begin
    _zz_io_vloadWriteReqs_0_7_payload_data = 32'h0;
    if(when_MemoryEngine_l649_112) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[31 : 0];
    end
    if(when_MemoryEngine_l649_113) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[63 : 32];
    end
    if(when_MemoryEngine_l649_114) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[95 : 64];
    end
    if(when_MemoryEngine_l649_115) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[127 : 96];
    end
    if(when_MemoryEngine_l649_116) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[159 : 128];
    end
    if(when_MemoryEngine_l649_117) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[191 : 160];
    end
    if(when_MemoryEngine_l649_118) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[223 : 192];
    end
    if(when_MemoryEngine_l649_119) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[255 : 224];
    end
    if(when_MemoryEngine_l649_120) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[287 : 256];
    end
    if(when_MemoryEngine_l649_121) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[319 : 288];
    end
    if(when_MemoryEngine_l649_122) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[351 : 320];
    end
    if(when_MemoryEngine_l649_123) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[383 : 352];
    end
    if(when_MemoryEngine_l649_124) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[415 : 384];
    end
    if(when_MemoryEngine_l649_125) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[447 : 416];
    end
    if(when_MemoryEngine_l649_126) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[479 : 448];
    end
    if(when_MemoryEngine_l649_127) begin
      _zz_io_vloadWriteReqs_0_7_payload_data = io_axiMaster_r_payload_data[511 : 480];
    end
  end

  assign _zz_when_MemoryEngine_l649_7 = (loadReqEntry_wordOff + 4'b0111);
  assign when_MemoryEngine_l649_112 = (_zz_when_MemoryEngine_l649_7 == 4'b0000);
  assign when_MemoryEngine_l649_113 = (_zz_when_MemoryEngine_l649_7 == 4'b0001);
  assign when_MemoryEngine_l649_114 = (_zz_when_MemoryEngine_l649_7 == 4'b0010);
  assign when_MemoryEngine_l649_115 = (_zz_when_MemoryEngine_l649_7 == 4'b0011);
  assign when_MemoryEngine_l649_116 = (_zz_when_MemoryEngine_l649_7 == 4'b0100);
  assign when_MemoryEngine_l649_117 = (_zz_when_MemoryEngine_l649_7 == 4'b0101);
  assign when_MemoryEngine_l649_118 = (_zz_when_MemoryEngine_l649_7 == 4'b0110);
  assign when_MemoryEngine_l649_119 = (_zz_when_MemoryEngine_l649_7 == 4'b0111);
  assign when_MemoryEngine_l649_120 = (_zz_when_MemoryEngine_l649_7 == 4'b1000);
  assign when_MemoryEngine_l649_121 = (_zz_when_MemoryEngine_l649_7 == 4'b1001);
  assign when_MemoryEngine_l649_122 = (_zz_when_MemoryEngine_l649_7 == 4'b1010);
  assign when_MemoryEngine_l649_123 = (_zz_when_MemoryEngine_l649_7 == 4'b1011);
  assign when_MemoryEngine_l649_124 = (_zz_when_MemoryEngine_l649_7 == 4'b1100);
  assign when_MemoryEngine_l649_125 = (_zz_when_MemoryEngine_l649_7 == 4'b1101);
  assign when_MemoryEngine_l649_126 = (_zz_when_MemoryEngine_l649_7 == 4'b1110);
  assign when_MemoryEngine_l649_127 = (_zz_when_MemoryEngine_l649_7 == 4'b1111);
  assign when_MemoryEngine_l667 = (2'b00 == loadTrackTail);
  assign when_MemoryEngine_l667_1 = (2'b01 == loadTrackTail);
  assign when_MemoryEngine_l667_2 = (2'b10 == loadTrackTail);
  assign when_MemoryEngine_l667_3 = (2'b11 == loadTrackTail);
  always @(*) begin
    matrixBeatBytes = matrixBeatElems;
    if(matrixUseAccum) begin
      matrixBeatBytes = _zz_matrixBeatBytes[6:0];
    end
  end

  always @(*) begin
    matrixWriteStrb = 64'h0;
    if(when_MemoryEngine_l685) begin
      matrixWriteStrb[0] = 1'b1;
    end
    if(when_MemoryEngine_l685_1) begin
      matrixWriteStrb[1] = 1'b1;
    end
    if(when_MemoryEngine_l685_2) begin
      matrixWriteStrb[2] = 1'b1;
    end
    if(when_MemoryEngine_l685_3) begin
      matrixWriteStrb[3] = 1'b1;
    end
    if(when_MemoryEngine_l685_4) begin
      matrixWriteStrb[4] = 1'b1;
    end
    if(when_MemoryEngine_l685_5) begin
      matrixWriteStrb[5] = 1'b1;
    end
    if(when_MemoryEngine_l685_6) begin
      matrixWriteStrb[6] = 1'b1;
    end
    if(when_MemoryEngine_l685_7) begin
      matrixWriteStrb[7] = 1'b1;
    end
    if(when_MemoryEngine_l685_8) begin
      matrixWriteStrb[8] = 1'b1;
    end
    if(when_MemoryEngine_l685_9) begin
      matrixWriteStrb[9] = 1'b1;
    end
    if(when_MemoryEngine_l685_10) begin
      matrixWriteStrb[10] = 1'b1;
    end
    if(when_MemoryEngine_l685_11) begin
      matrixWriteStrb[11] = 1'b1;
    end
    if(when_MemoryEngine_l685_12) begin
      matrixWriteStrb[12] = 1'b1;
    end
    if(when_MemoryEngine_l685_13) begin
      matrixWriteStrb[13] = 1'b1;
    end
    if(when_MemoryEngine_l685_14) begin
      matrixWriteStrb[14] = 1'b1;
    end
    if(when_MemoryEngine_l685_15) begin
      matrixWriteStrb[15] = 1'b1;
    end
    if(when_MemoryEngine_l685_16) begin
      matrixWriteStrb[16] = 1'b1;
    end
    if(when_MemoryEngine_l685_17) begin
      matrixWriteStrb[17] = 1'b1;
    end
    if(when_MemoryEngine_l685_18) begin
      matrixWriteStrb[18] = 1'b1;
    end
    if(when_MemoryEngine_l685_19) begin
      matrixWriteStrb[19] = 1'b1;
    end
    if(when_MemoryEngine_l685_20) begin
      matrixWriteStrb[20] = 1'b1;
    end
    if(when_MemoryEngine_l685_21) begin
      matrixWriteStrb[21] = 1'b1;
    end
    if(when_MemoryEngine_l685_22) begin
      matrixWriteStrb[22] = 1'b1;
    end
    if(when_MemoryEngine_l685_23) begin
      matrixWriteStrb[23] = 1'b1;
    end
    if(when_MemoryEngine_l685_24) begin
      matrixWriteStrb[24] = 1'b1;
    end
    if(when_MemoryEngine_l685_25) begin
      matrixWriteStrb[25] = 1'b1;
    end
    if(when_MemoryEngine_l685_26) begin
      matrixWriteStrb[26] = 1'b1;
    end
    if(when_MemoryEngine_l685_27) begin
      matrixWriteStrb[27] = 1'b1;
    end
    if(when_MemoryEngine_l685_28) begin
      matrixWriteStrb[28] = 1'b1;
    end
    if(when_MemoryEngine_l685_29) begin
      matrixWriteStrb[29] = 1'b1;
    end
    if(when_MemoryEngine_l685_30) begin
      matrixWriteStrb[30] = 1'b1;
    end
    if(when_MemoryEngine_l685_31) begin
      matrixWriteStrb[31] = 1'b1;
    end
    if(when_MemoryEngine_l685_32) begin
      matrixWriteStrb[32] = 1'b1;
    end
    if(when_MemoryEngine_l685_33) begin
      matrixWriteStrb[33] = 1'b1;
    end
    if(when_MemoryEngine_l685_34) begin
      matrixWriteStrb[34] = 1'b1;
    end
    if(when_MemoryEngine_l685_35) begin
      matrixWriteStrb[35] = 1'b1;
    end
    if(when_MemoryEngine_l685_36) begin
      matrixWriteStrb[36] = 1'b1;
    end
    if(when_MemoryEngine_l685_37) begin
      matrixWriteStrb[37] = 1'b1;
    end
    if(when_MemoryEngine_l685_38) begin
      matrixWriteStrb[38] = 1'b1;
    end
    if(when_MemoryEngine_l685_39) begin
      matrixWriteStrb[39] = 1'b1;
    end
    if(when_MemoryEngine_l685_40) begin
      matrixWriteStrb[40] = 1'b1;
    end
    if(when_MemoryEngine_l685_41) begin
      matrixWriteStrb[41] = 1'b1;
    end
    if(when_MemoryEngine_l685_42) begin
      matrixWriteStrb[42] = 1'b1;
    end
    if(when_MemoryEngine_l685_43) begin
      matrixWriteStrb[43] = 1'b1;
    end
    if(when_MemoryEngine_l685_44) begin
      matrixWriteStrb[44] = 1'b1;
    end
    if(when_MemoryEngine_l685_45) begin
      matrixWriteStrb[45] = 1'b1;
    end
    if(when_MemoryEngine_l685_46) begin
      matrixWriteStrb[46] = 1'b1;
    end
    if(when_MemoryEngine_l685_47) begin
      matrixWriteStrb[47] = 1'b1;
    end
    if(when_MemoryEngine_l685_48) begin
      matrixWriteStrb[48] = 1'b1;
    end
    if(when_MemoryEngine_l685_49) begin
      matrixWriteStrb[49] = 1'b1;
    end
    if(when_MemoryEngine_l685_50) begin
      matrixWriteStrb[50] = 1'b1;
    end
    if(when_MemoryEngine_l685_51) begin
      matrixWriteStrb[51] = 1'b1;
    end
    if(when_MemoryEngine_l685_52) begin
      matrixWriteStrb[52] = 1'b1;
    end
    if(when_MemoryEngine_l685_53) begin
      matrixWriteStrb[53] = 1'b1;
    end
    if(when_MemoryEngine_l685_54) begin
      matrixWriteStrb[54] = 1'b1;
    end
    if(when_MemoryEngine_l685_55) begin
      matrixWriteStrb[55] = 1'b1;
    end
    if(when_MemoryEngine_l685_56) begin
      matrixWriteStrb[56] = 1'b1;
    end
    if(when_MemoryEngine_l685_57) begin
      matrixWriteStrb[57] = 1'b1;
    end
    if(when_MemoryEngine_l685_58) begin
      matrixWriteStrb[58] = 1'b1;
    end
    if(when_MemoryEngine_l685_59) begin
      matrixWriteStrb[59] = 1'b1;
    end
    if(when_MemoryEngine_l685_60) begin
      matrixWriteStrb[60] = 1'b1;
    end
    if(when_MemoryEngine_l685_61) begin
      matrixWriteStrb[61] = 1'b1;
    end
    if(when_MemoryEngine_l685_62) begin
      matrixWriteStrb[62] = 1'b1;
    end
    if(when_MemoryEngine_l685_63) begin
      matrixWriteStrb[63] = 1'b1;
    end
  end

  assign when_MemoryEngine_l685 = (7'h0 < matrixBeatBytes);
  assign when_MemoryEngine_l685_1 = (7'h01 < matrixBeatBytes);
  assign when_MemoryEngine_l685_2 = (7'h02 < matrixBeatBytes);
  assign when_MemoryEngine_l685_3 = (7'h03 < matrixBeatBytes);
  assign when_MemoryEngine_l685_4 = (7'h04 < matrixBeatBytes);
  assign when_MemoryEngine_l685_5 = (7'h05 < matrixBeatBytes);
  assign when_MemoryEngine_l685_6 = (7'h06 < matrixBeatBytes);
  assign when_MemoryEngine_l685_7 = (7'h07 < matrixBeatBytes);
  assign when_MemoryEngine_l685_8 = (7'h08 < matrixBeatBytes);
  assign when_MemoryEngine_l685_9 = (7'h09 < matrixBeatBytes);
  assign when_MemoryEngine_l685_10 = (7'h0a < matrixBeatBytes);
  assign when_MemoryEngine_l685_11 = (7'h0b < matrixBeatBytes);
  assign when_MemoryEngine_l685_12 = (7'h0c < matrixBeatBytes);
  assign when_MemoryEngine_l685_13 = (7'h0d < matrixBeatBytes);
  assign when_MemoryEngine_l685_14 = (7'h0e < matrixBeatBytes);
  assign when_MemoryEngine_l685_15 = (7'h0f < matrixBeatBytes);
  assign when_MemoryEngine_l685_16 = (7'h10 < matrixBeatBytes);
  assign when_MemoryEngine_l685_17 = (7'h11 < matrixBeatBytes);
  assign when_MemoryEngine_l685_18 = (7'h12 < matrixBeatBytes);
  assign when_MemoryEngine_l685_19 = (7'h13 < matrixBeatBytes);
  assign when_MemoryEngine_l685_20 = (7'h14 < matrixBeatBytes);
  assign when_MemoryEngine_l685_21 = (7'h15 < matrixBeatBytes);
  assign when_MemoryEngine_l685_22 = (7'h16 < matrixBeatBytes);
  assign when_MemoryEngine_l685_23 = (7'h17 < matrixBeatBytes);
  assign when_MemoryEngine_l685_24 = (7'h18 < matrixBeatBytes);
  assign when_MemoryEngine_l685_25 = (7'h19 < matrixBeatBytes);
  assign when_MemoryEngine_l685_26 = (7'h1a < matrixBeatBytes);
  assign when_MemoryEngine_l685_27 = (7'h1b < matrixBeatBytes);
  assign when_MemoryEngine_l685_28 = (7'h1c < matrixBeatBytes);
  assign when_MemoryEngine_l685_29 = (7'h1d < matrixBeatBytes);
  assign when_MemoryEngine_l685_30 = (7'h1e < matrixBeatBytes);
  assign when_MemoryEngine_l685_31 = (7'h1f < matrixBeatBytes);
  assign when_MemoryEngine_l685_32 = (7'h20 < matrixBeatBytes);
  assign when_MemoryEngine_l685_33 = (7'h21 < matrixBeatBytes);
  assign when_MemoryEngine_l685_34 = (7'h22 < matrixBeatBytes);
  assign when_MemoryEngine_l685_35 = (7'h23 < matrixBeatBytes);
  assign when_MemoryEngine_l685_36 = (7'h24 < matrixBeatBytes);
  assign when_MemoryEngine_l685_37 = (7'h25 < matrixBeatBytes);
  assign when_MemoryEngine_l685_38 = (7'h26 < matrixBeatBytes);
  assign when_MemoryEngine_l685_39 = (7'h27 < matrixBeatBytes);
  assign when_MemoryEngine_l685_40 = (7'h28 < matrixBeatBytes);
  assign when_MemoryEngine_l685_41 = (7'h29 < matrixBeatBytes);
  assign when_MemoryEngine_l685_42 = (7'h2a < matrixBeatBytes);
  assign when_MemoryEngine_l685_43 = (7'h2b < matrixBeatBytes);
  assign when_MemoryEngine_l685_44 = (7'h2c < matrixBeatBytes);
  assign when_MemoryEngine_l685_45 = (7'h2d < matrixBeatBytes);
  assign when_MemoryEngine_l685_46 = (7'h2e < matrixBeatBytes);
  assign when_MemoryEngine_l685_47 = (7'h2f < matrixBeatBytes);
  assign when_MemoryEngine_l685_48 = (7'h30 < matrixBeatBytes);
  assign when_MemoryEngine_l685_49 = (7'h31 < matrixBeatBytes);
  assign when_MemoryEngine_l685_50 = (7'h32 < matrixBeatBytes);
  assign when_MemoryEngine_l685_51 = (7'h33 < matrixBeatBytes);
  assign when_MemoryEngine_l685_52 = (7'h34 < matrixBeatBytes);
  assign when_MemoryEngine_l685_53 = (7'h35 < matrixBeatBytes);
  assign when_MemoryEngine_l685_54 = (7'h36 < matrixBeatBytes);
  assign when_MemoryEngine_l685_55 = (7'h37 < matrixBeatBytes);
  assign when_MemoryEngine_l685_56 = (7'h38 < matrixBeatBytes);
  assign when_MemoryEngine_l685_57 = (7'h39 < matrixBeatBytes);
  assign when_MemoryEngine_l685_58 = (7'h3a < matrixBeatBytes);
  assign when_MemoryEngine_l685_59 = (7'h3b < matrixBeatBytes);
  assign when_MemoryEngine_l685_60 = (7'h3c < matrixBeatBytes);
  assign when_MemoryEngine_l685_61 = (7'h3d < matrixBeatBytes);
  assign when_MemoryEngine_l685_62 = (7'h3e < matrixBeatBytes);
  assign when_MemoryEngine_l685_63 = (7'h3f < matrixBeatBytes);
  assign when_MemoryEngine_l703 = (! awAccepted);
  assign when_MemoryEngine_l704 = (! wAccepted);
  assign io_axiMaster_aw_fire = (io_axiMaster_aw_valid && io_axiMaster_aw_ready);
  assign io_axiMaster_w_fire = (io_axiMaster_w_valid && io_axiMaster_w_ready);
  assign when_MemoryEngine_l716 = ((io_axiMaster_aw_fire || awAccepted) && (io_axiMaster_w_fire || wAccepted));
  assign _zz_io_matrixScratchAAddr = (_zz__zz_io_matrixScratchAAddr + _zz__zz_io_matrixScratchAAddr_2);
  always @(*) begin
    _zz_io_matrixAccumWrData = 32'h0;
    if(when_MemoryEngine_l758) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[31 : 0];
    end
    if(when_MemoryEngine_l758_1) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[63 : 32];
    end
    if(when_MemoryEngine_l758_2) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[95 : 64];
    end
    if(when_MemoryEngine_l758_3) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[127 : 96];
    end
    if(when_MemoryEngine_l758_4) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[159 : 128];
    end
    if(when_MemoryEngine_l758_5) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[191 : 160];
    end
    if(when_MemoryEngine_l758_6) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[223 : 192];
    end
    if(when_MemoryEngine_l758_7) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[255 : 224];
    end
    if(when_MemoryEngine_l758_8) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[287 : 256];
    end
    if(when_MemoryEngine_l758_9) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[319 : 288];
    end
    if(when_MemoryEngine_l758_10) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[351 : 320];
    end
    if(when_MemoryEngine_l758_11) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[383 : 352];
    end
    if(when_MemoryEngine_l758_12) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[415 : 384];
    end
    if(when_MemoryEngine_l758_13) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[447 : 416];
    end
    if(when_MemoryEngine_l758_14) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[479 : 448];
    end
    if(when_MemoryEngine_l758_15) begin
      _zz_io_matrixAccumWrData = matrixBeatBuffer[511 : 480];
    end
  end

  assign when_MemoryEngine_l758 = (matrixDrainIndex == 7'h0);
  assign when_MemoryEngine_l758_1 = (matrixDrainIndex == 7'h01);
  assign when_MemoryEngine_l758_2 = (matrixDrainIndex == 7'h02);
  assign when_MemoryEngine_l758_3 = (matrixDrainIndex == 7'h03);
  assign when_MemoryEngine_l758_4 = (matrixDrainIndex == 7'h04);
  assign when_MemoryEngine_l758_5 = (matrixDrainIndex == 7'h05);
  assign when_MemoryEngine_l758_6 = (matrixDrainIndex == 7'h06);
  assign when_MemoryEngine_l758_7 = (matrixDrainIndex == 7'h07);
  assign when_MemoryEngine_l758_8 = (matrixDrainIndex == 7'h08);
  assign when_MemoryEngine_l758_9 = (matrixDrainIndex == 7'h09);
  assign when_MemoryEngine_l758_10 = (matrixDrainIndex == 7'h0a);
  assign when_MemoryEngine_l758_11 = (matrixDrainIndex == 7'h0b);
  assign when_MemoryEngine_l758_12 = (matrixDrainIndex == 7'h0c);
  assign when_MemoryEngine_l758_13 = (matrixDrainIndex == 7'h0d);
  assign when_MemoryEngine_l758_14 = (matrixDrainIndex == 7'h0e);
  assign when_MemoryEngine_l758_15 = (matrixDrainIndex == 7'h0f);
  always @(*) begin
    _zz_io_matrixScratchAWrData = 8'h0;
    if(when_MemoryEngine_l770) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[7 : 0];
    end
    if(when_MemoryEngine_l770_1) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[15 : 8];
    end
    if(when_MemoryEngine_l770_2) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[23 : 16];
    end
    if(when_MemoryEngine_l770_3) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[31 : 24];
    end
    if(when_MemoryEngine_l770_4) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[39 : 32];
    end
    if(when_MemoryEngine_l770_5) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[47 : 40];
    end
    if(when_MemoryEngine_l770_6) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[55 : 48];
    end
    if(when_MemoryEngine_l770_7) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[63 : 56];
    end
    if(when_MemoryEngine_l770_8) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[71 : 64];
    end
    if(when_MemoryEngine_l770_9) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[79 : 72];
    end
    if(when_MemoryEngine_l770_10) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[87 : 80];
    end
    if(when_MemoryEngine_l770_11) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[95 : 88];
    end
    if(when_MemoryEngine_l770_12) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[103 : 96];
    end
    if(when_MemoryEngine_l770_13) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[111 : 104];
    end
    if(when_MemoryEngine_l770_14) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[119 : 112];
    end
    if(when_MemoryEngine_l770_15) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[127 : 120];
    end
    if(when_MemoryEngine_l770_16) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[135 : 128];
    end
    if(when_MemoryEngine_l770_17) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[143 : 136];
    end
    if(when_MemoryEngine_l770_18) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[151 : 144];
    end
    if(when_MemoryEngine_l770_19) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[159 : 152];
    end
    if(when_MemoryEngine_l770_20) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[167 : 160];
    end
    if(when_MemoryEngine_l770_21) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[175 : 168];
    end
    if(when_MemoryEngine_l770_22) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[183 : 176];
    end
    if(when_MemoryEngine_l770_23) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[191 : 184];
    end
    if(when_MemoryEngine_l770_24) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[199 : 192];
    end
    if(when_MemoryEngine_l770_25) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[207 : 200];
    end
    if(when_MemoryEngine_l770_26) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[215 : 208];
    end
    if(when_MemoryEngine_l770_27) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[223 : 216];
    end
    if(when_MemoryEngine_l770_28) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[231 : 224];
    end
    if(when_MemoryEngine_l770_29) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[239 : 232];
    end
    if(when_MemoryEngine_l770_30) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[247 : 240];
    end
    if(when_MemoryEngine_l770_31) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[255 : 248];
    end
    if(when_MemoryEngine_l770_32) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[263 : 256];
    end
    if(when_MemoryEngine_l770_33) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[271 : 264];
    end
    if(when_MemoryEngine_l770_34) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[279 : 272];
    end
    if(when_MemoryEngine_l770_35) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[287 : 280];
    end
    if(when_MemoryEngine_l770_36) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[295 : 288];
    end
    if(when_MemoryEngine_l770_37) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[303 : 296];
    end
    if(when_MemoryEngine_l770_38) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[311 : 304];
    end
    if(when_MemoryEngine_l770_39) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[319 : 312];
    end
    if(when_MemoryEngine_l770_40) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[327 : 320];
    end
    if(when_MemoryEngine_l770_41) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[335 : 328];
    end
    if(when_MemoryEngine_l770_42) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[343 : 336];
    end
    if(when_MemoryEngine_l770_43) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[351 : 344];
    end
    if(when_MemoryEngine_l770_44) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[359 : 352];
    end
    if(when_MemoryEngine_l770_45) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[367 : 360];
    end
    if(when_MemoryEngine_l770_46) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[375 : 368];
    end
    if(when_MemoryEngine_l770_47) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[383 : 376];
    end
    if(when_MemoryEngine_l770_48) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[391 : 384];
    end
    if(when_MemoryEngine_l770_49) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[399 : 392];
    end
    if(when_MemoryEngine_l770_50) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[407 : 400];
    end
    if(when_MemoryEngine_l770_51) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[415 : 408];
    end
    if(when_MemoryEngine_l770_52) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[423 : 416];
    end
    if(when_MemoryEngine_l770_53) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[431 : 424];
    end
    if(when_MemoryEngine_l770_54) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[439 : 432];
    end
    if(when_MemoryEngine_l770_55) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[447 : 440];
    end
    if(when_MemoryEngine_l770_56) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[455 : 448];
    end
    if(when_MemoryEngine_l770_57) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[463 : 456];
    end
    if(when_MemoryEngine_l770_58) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[471 : 464];
    end
    if(when_MemoryEngine_l770_59) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[479 : 472];
    end
    if(when_MemoryEngine_l770_60) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[487 : 480];
    end
    if(when_MemoryEngine_l770_61) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[495 : 488];
    end
    if(when_MemoryEngine_l770_62) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[503 : 496];
    end
    if(when_MemoryEngine_l770_63) begin
      _zz_io_matrixScratchAWrData = matrixBeatBuffer[511 : 504];
    end
  end

  assign when_MemoryEngine_l770 = (matrixDrainIndex == 7'h0);
  assign when_MemoryEngine_l770_1 = (matrixDrainIndex == 7'h01);
  assign when_MemoryEngine_l770_2 = (matrixDrainIndex == 7'h02);
  assign when_MemoryEngine_l770_3 = (matrixDrainIndex == 7'h03);
  assign when_MemoryEngine_l770_4 = (matrixDrainIndex == 7'h04);
  assign when_MemoryEngine_l770_5 = (matrixDrainIndex == 7'h05);
  assign when_MemoryEngine_l770_6 = (matrixDrainIndex == 7'h06);
  assign when_MemoryEngine_l770_7 = (matrixDrainIndex == 7'h07);
  assign when_MemoryEngine_l770_8 = (matrixDrainIndex == 7'h08);
  assign when_MemoryEngine_l770_9 = (matrixDrainIndex == 7'h09);
  assign when_MemoryEngine_l770_10 = (matrixDrainIndex == 7'h0a);
  assign when_MemoryEngine_l770_11 = (matrixDrainIndex == 7'h0b);
  assign when_MemoryEngine_l770_12 = (matrixDrainIndex == 7'h0c);
  assign when_MemoryEngine_l770_13 = (matrixDrainIndex == 7'h0d);
  assign when_MemoryEngine_l770_14 = (matrixDrainIndex == 7'h0e);
  assign when_MemoryEngine_l770_15 = (matrixDrainIndex == 7'h0f);
  assign when_MemoryEngine_l770_16 = (matrixDrainIndex == 7'h10);
  assign when_MemoryEngine_l770_17 = (matrixDrainIndex == 7'h11);
  assign when_MemoryEngine_l770_18 = (matrixDrainIndex == 7'h12);
  assign when_MemoryEngine_l770_19 = (matrixDrainIndex == 7'h13);
  assign when_MemoryEngine_l770_20 = (matrixDrainIndex == 7'h14);
  assign when_MemoryEngine_l770_21 = (matrixDrainIndex == 7'h15);
  assign when_MemoryEngine_l770_22 = (matrixDrainIndex == 7'h16);
  assign when_MemoryEngine_l770_23 = (matrixDrainIndex == 7'h17);
  assign when_MemoryEngine_l770_24 = (matrixDrainIndex == 7'h18);
  assign when_MemoryEngine_l770_25 = (matrixDrainIndex == 7'h19);
  assign when_MemoryEngine_l770_26 = (matrixDrainIndex == 7'h1a);
  assign when_MemoryEngine_l770_27 = (matrixDrainIndex == 7'h1b);
  assign when_MemoryEngine_l770_28 = (matrixDrainIndex == 7'h1c);
  assign when_MemoryEngine_l770_29 = (matrixDrainIndex == 7'h1d);
  assign when_MemoryEngine_l770_30 = (matrixDrainIndex == 7'h1e);
  assign when_MemoryEngine_l770_31 = (matrixDrainIndex == 7'h1f);
  assign when_MemoryEngine_l770_32 = (matrixDrainIndex == 7'h20);
  assign when_MemoryEngine_l770_33 = (matrixDrainIndex == 7'h21);
  assign when_MemoryEngine_l770_34 = (matrixDrainIndex == 7'h22);
  assign when_MemoryEngine_l770_35 = (matrixDrainIndex == 7'h23);
  assign when_MemoryEngine_l770_36 = (matrixDrainIndex == 7'h24);
  assign when_MemoryEngine_l770_37 = (matrixDrainIndex == 7'h25);
  assign when_MemoryEngine_l770_38 = (matrixDrainIndex == 7'h26);
  assign when_MemoryEngine_l770_39 = (matrixDrainIndex == 7'h27);
  assign when_MemoryEngine_l770_40 = (matrixDrainIndex == 7'h28);
  assign when_MemoryEngine_l770_41 = (matrixDrainIndex == 7'h29);
  assign when_MemoryEngine_l770_42 = (matrixDrainIndex == 7'h2a);
  assign when_MemoryEngine_l770_43 = (matrixDrainIndex == 7'h2b);
  assign when_MemoryEngine_l770_44 = (matrixDrainIndex == 7'h2c);
  assign when_MemoryEngine_l770_45 = (matrixDrainIndex == 7'h2d);
  assign when_MemoryEngine_l770_46 = (matrixDrainIndex == 7'h2e);
  assign when_MemoryEngine_l770_47 = (matrixDrainIndex == 7'h2f);
  assign when_MemoryEngine_l770_48 = (matrixDrainIndex == 7'h30);
  assign when_MemoryEngine_l770_49 = (matrixDrainIndex == 7'h31);
  assign when_MemoryEngine_l770_50 = (matrixDrainIndex == 7'h32);
  assign when_MemoryEngine_l770_51 = (matrixDrainIndex == 7'h33);
  assign when_MemoryEngine_l770_52 = (matrixDrainIndex == 7'h34);
  assign when_MemoryEngine_l770_53 = (matrixDrainIndex == 7'h35);
  assign when_MemoryEngine_l770_54 = (matrixDrainIndex == 7'h36);
  assign when_MemoryEngine_l770_55 = (matrixDrainIndex == 7'h37);
  assign when_MemoryEngine_l770_56 = (matrixDrainIndex == 7'h38);
  assign when_MemoryEngine_l770_57 = (matrixDrainIndex == 7'h39);
  assign when_MemoryEngine_l770_58 = (matrixDrainIndex == 7'h3a);
  assign when_MemoryEngine_l770_59 = (matrixDrainIndex == 7'h3b);
  assign when_MemoryEngine_l770_60 = (matrixDrainIndex == 7'h3c);
  assign when_MemoryEngine_l770_61 = (matrixDrainIndex == 7'h3d);
  assign when_MemoryEngine_l770_62 = (matrixDrainIndex == 7'h3e);
  assign when_MemoryEngine_l770_63 = (matrixDrainIndex == 7'h3f);
  assign _zz_matrixDrainIndex = (matrixDrainIndex + 7'h01);
  assign _zz_matrixElemsTransferred = (matrixElemsTransferred + matrixBeatElems);
  assign when_MemoryEngine_l789 = (_zz_matrixDrainIndex == matrixBeatElems);
  assign when_MemoryEngine_l793 = (_zz_matrixElemsTransferred == matrixTotalElems);
  assign _zz_when_MemoryEngine_l284 = (matrixTotalElems - _zz_matrixElemsTransferred);
  always @(*) begin
    _zz_matrixBeatElems = _zz_when_MemoryEngine_l284;
    if(when_MemoryEngine_l284) begin
      _zz_matrixBeatElems = 7'h10;
    end
  end

  assign when_MemoryEngine_l284 = (matrixUseAccum && (7'h10 < _zz_when_MemoryEngine_l284));
  assign when_MemoryEngine_l830 = (matrixGatherIssued < matrixBeatElems);
  assign _zz_io_matrixScratchAAddr_1 = (_zz__zz_io_matrixScratchAAddr_1_1 + _zz__zz_io_matrixScratchAAddr_1_3);
  assign when_MemoryEngine_l812 = (matrixReadPipeIndex == 7'h0);
  assign when_MemoryEngine_l812_1 = (matrixReadPipeIndex == 7'h01);
  assign when_MemoryEngine_l812_2 = (matrixReadPipeIndex == 7'h02);
  assign when_MemoryEngine_l812_3 = (matrixReadPipeIndex == 7'h03);
  assign when_MemoryEngine_l812_4 = (matrixReadPipeIndex == 7'h04);
  assign when_MemoryEngine_l812_5 = (matrixReadPipeIndex == 7'h05);
  assign when_MemoryEngine_l812_6 = (matrixReadPipeIndex == 7'h06);
  assign when_MemoryEngine_l812_7 = (matrixReadPipeIndex == 7'h07);
  assign when_MemoryEngine_l812_8 = (matrixReadPipeIndex == 7'h08);
  assign when_MemoryEngine_l812_9 = (matrixReadPipeIndex == 7'h09);
  assign when_MemoryEngine_l812_10 = (matrixReadPipeIndex == 7'h0a);
  assign when_MemoryEngine_l812_11 = (matrixReadPipeIndex == 7'h0b);
  assign when_MemoryEngine_l812_12 = (matrixReadPipeIndex == 7'h0c);
  assign when_MemoryEngine_l812_13 = (matrixReadPipeIndex == 7'h0d);
  assign when_MemoryEngine_l812_14 = (matrixReadPipeIndex == 7'h0e);
  assign when_MemoryEngine_l812_15 = (matrixReadPipeIndex == 7'h0f);
  assign when_MemoryEngine_l818 = (matrixReadPipeIndex == 7'h0);
  assign when_MemoryEngine_l818_1 = (matrixReadPipeIndex == 7'h01);
  assign when_MemoryEngine_l818_2 = (matrixReadPipeIndex == 7'h02);
  assign when_MemoryEngine_l818_3 = (matrixReadPipeIndex == 7'h03);
  assign when_MemoryEngine_l818_4 = (matrixReadPipeIndex == 7'h04);
  assign when_MemoryEngine_l818_5 = (matrixReadPipeIndex == 7'h05);
  assign when_MemoryEngine_l818_6 = (matrixReadPipeIndex == 7'h06);
  assign when_MemoryEngine_l818_7 = (matrixReadPipeIndex == 7'h07);
  assign when_MemoryEngine_l818_8 = (matrixReadPipeIndex == 7'h08);
  assign when_MemoryEngine_l818_9 = (matrixReadPipeIndex == 7'h09);
  assign when_MemoryEngine_l818_10 = (matrixReadPipeIndex == 7'h0a);
  assign when_MemoryEngine_l818_11 = (matrixReadPipeIndex == 7'h0b);
  assign when_MemoryEngine_l818_12 = (matrixReadPipeIndex == 7'h0c);
  assign when_MemoryEngine_l818_13 = (matrixReadPipeIndex == 7'h0d);
  assign when_MemoryEngine_l818_14 = (matrixReadPipeIndex == 7'h0e);
  assign when_MemoryEngine_l818_15 = (matrixReadPipeIndex == 7'h0f);
  assign when_MemoryEngine_l818_16 = (matrixReadPipeIndex == 7'h10);
  assign when_MemoryEngine_l818_17 = (matrixReadPipeIndex == 7'h11);
  assign when_MemoryEngine_l818_18 = (matrixReadPipeIndex == 7'h12);
  assign when_MemoryEngine_l818_19 = (matrixReadPipeIndex == 7'h13);
  assign when_MemoryEngine_l818_20 = (matrixReadPipeIndex == 7'h14);
  assign when_MemoryEngine_l818_21 = (matrixReadPipeIndex == 7'h15);
  assign when_MemoryEngine_l818_22 = (matrixReadPipeIndex == 7'h16);
  assign when_MemoryEngine_l818_23 = (matrixReadPipeIndex == 7'h17);
  assign when_MemoryEngine_l818_24 = (matrixReadPipeIndex == 7'h18);
  assign when_MemoryEngine_l818_25 = (matrixReadPipeIndex == 7'h19);
  assign when_MemoryEngine_l818_26 = (matrixReadPipeIndex == 7'h1a);
  assign when_MemoryEngine_l818_27 = (matrixReadPipeIndex == 7'h1b);
  assign when_MemoryEngine_l818_28 = (matrixReadPipeIndex == 7'h1c);
  assign when_MemoryEngine_l818_29 = (matrixReadPipeIndex == 7'h1d);
  assign when_MemoryEngine_l818_30 = (matrixReadPipeIndex == 7'h1e);
  assign when_MemoryEngine_l818_31 = (matrixReadPipeIndex == 7'h1f);
  assign when_MemoryEngine_l818_32 = (matrixReadPipeIndex == 7'h20);
  assign when_MemoryEngine_l818_33 = (matrixReadPipeIndex == 7'h21);
  assign when_MemoryEngine_l818_34 = (matrixReadPipeIndex == 7'h22);
  assign when_MemoryEngine_l818_35 = (matrixReadPipeIndex == 7'h23);
  assign when_MemoryEngine_l818_36 = (matrixReadPipeIndex == 7'h24);
  assign when_MemoryEngine_l818_37 = (matrixReadPipeIndex == 7'h25);
  assign when_MemoryEngine_l818_38 = (matrixReadPipeIndex == 7'h26);
  assign when_MemoryEngine_l818_39 = (matrixReadPipeIndex == 7'h27);
  assign when_MemoryEngine_l818_40 = (matrixReadPipeIndex == 7'h28);
  assign when_MemoryEngine_l818_41 = (matrixReadPipeIndex == 7'h29);
  assign when_MemoryEngine_l818_42 = (matrixReadPipeIndex == 7'h2a);
  assign when_MemoryEngine_l818_43 = (matrixReadPipeIndex == 7'h2b);
  assign when_MemoryEngine_l818_44 = (matrixReadPipeIndex == 7'h2c);
  assign when_MemoryEngine_l818_45 = (matrixReadPipeIndex == 7'h2d);
  assign when_MemoryEngine_l818_46 = (matrixReadPipeIndex == 7'h2e);
  assign when_MemoryEngine_l818_47 = (matrixReadPipeIndex == 7'h2f);
  assign when_MemoryEngine_l818_48 = (matrixReadPipeIndex == 7'h30);
  assign when_MemoryEngine_l818_49 = (matrixReadPipeIndex == 7'h31);
  assign when_MemoryEngine_l818_50 = (matrixReadPipeIndex == 7'h32);
  assign when_MemoryEngine_l818_51 = (matrixReadPipeIndex == 7'h33);
  assign when_MemoryEngine_l818_52 = (matrixReadPipeIndex == 7'h34);
  assign when_MemoryEngine_l818_53 = (matrixReadPipeIndex == 7'h35);
  assign when_MemoryEngine_l818_54 = (matrixReadPipeIndex == 7'h36);
  assign when_MemoryEngine_l818_55 = (matrixReadPipeIndex == 7'h37);
  assign when_MemoryEngine_l818_56 = (matrixReadPipeIndex == 7'h38);
  assign when_MemoryEngine_l818_57 = (matrixReadPipeIndex == 7'h39);
  assign when_MemoryEngine_l818_58 = (matrixReadPipeIndex == 7'h3a);
  assign when_MemoryEngine_l818_59 = (matrixReadPipeIndex == 7'h3b);
  assign when_MemoryEngine_l818_60 = (matrixReadPipeIndex == 7'h3c);
  assign when_MemoryEngine_l818_61 = (matrixReadPipeIndex == 7'h3d);
  assign when_MemoryEngine_l818_62 = (matrixReadPipeIndex == 7'h3e);
  assign when_MemoryEngine_l818_63 = (matrixReadPipeIndex == 7'h3f);
  assign when_MemoryEngine_l853 = (((! when_MemoryEngine_l830) && matrixReadPipeValid) && (_zz_when_MemoryEngine_l853 == matrixBeatElems));
  assign when_MemoryEngine_l861 = (! awAccepted);
  assign when_MemoryEngine_l862 = (! wAccepted);
  assign when_MemoryEngine_l874 = ((io_axiMaster_aw_fire || awAccepted) && (io_axiMaster_w_fire || wAccepted));
  assign _zz_matrixElemsTransferred_1 = (matrixElemsTransferred + matrixBeatElems);
  assign when_MemoryEngine_l892 = (_zz_matrixElemsTransferred_1 == matrixTotalElems);
  assign _zz_when_MemoryEngine_l284_1 = (matrixTotalElems - _zz_matrixElemsTransferred_1);
  always @(*) begin
    _zz_matrixBeatElems_1 = _zz_when_MemoryEngine_l284_1;
    if(when_MemoryEngine_l284_1) begin
      _zz_matrixBeatElems_1 = 7'h10;
    end
  end

  assign when_MemoryEngine_l284_1 = (matrixUseAccum && (7'h10 < _zz_when_MemoryEngine_l284_1));
  assign _zz_io_matrixScratchAAddr_2 = (scopyMatrixBase + _zz__zz_io_matrixScratchAAddr_2_1);
  assign when_MemoryEngine_l926 = (scopyElemIdx < scopyTotalElems);
  assign when_MemoryEngine_l949 = ((! when_MemoryEngine_l926) && (! scopyReadPipeValid));
  assign when_MemoryEngine_l985 = (scopyElemIdx < scopyTotalElems);
  assign _zz_io_matrixScratchAAddr_3 = (scopyMatrixBase + _zz__zz_io_matrixScratchAAddr_3);
  assign when_MemoryEngine_l996 = ((! when_MemoryEngine_l985) && (! scopyReadPipeValid));
  always @(posedge clk) begin
    if(reset) begin
      state <= MemState_IDLE;
      awAccepted <= 1'b0;
      wAccepted <= 1'b0;
      loadReqValid <= 1'b0;
      loadAddrAccepted <= 1'b0;
      loadTrackValid_0 <= 1'b0;
      loadTrackValid_1 <= 1'b0;
      loadTrackValid_2 <= 1'b0;
      loadTrackValid_3 <= 1'b0;
      loadTrackDestAddr_0 <= 11'h0;
      loadTrackDestAddr_1 <= 11'h0;
      loadTrackDestAddr_2 <= 11'h0;
      loadTrackDestAddr_3 <= 11'h0;
      loadTrackCountdown_0 <= 2'b00;
      loadTrackCountdown_1 <= 2'b00;
      loadTrackCountdown_2 <= 2'b00;
      loadTrackCountdown_3 <= 2'b00;
      loadTrackHead <= 2'b00;
      loadTrackTail <= 2'b00;
      matrixUseAccum <= 1'b0;
      matrixUseScratchB <= 1'b0;
      matrixTransferBypassable <= 1'b0;
      matrixIssueSeen <= 1'b0;
      matrixLocalBase <= 8'h0;
      matrixDramAddr <= 32'h0;
      matrixTotalElems <= 7'h0;
      matrixElemsTransferred <= 7'h0;
      matrixBeatElems <= 7'h0;
      matrixDrainIndex <= 7'h0;
      matrixGatherIssued <= 7'h0;
      matrixGatherCaptured <= 7'h0;
      matrixReadPipeValid <= 1'b0;
      matrixReadPipeIndex <= 7'h0;
      matrixBeatBuffer <= 512'h0;
      scopyIsM2V <= 1'b0;
      scopyVectorBase <= 11'h0;
      scopyMatrixBase <= 8'h0;
      scopyElemIdx <= 4'b0000;
      scopyTotalElems <= 4'b0000;
      scopyUseAccum <= 1'b0;
      scopyUseScratchB <= 1'b0;
      scopyReadPipeValid <= 1'b0;
    end else begin
      matrixUseAccum <= matrixUseAccum;
      matrixUseScratchB <= matrixUseScratchB;
      matrixTransferBypassable <= matrixTransferBypassable;
      matrixIssueSeen <= matrixIssueSeen;
      matrixLocalBase <= matrixLocalBase;
      matrixTotalElems <= matrixTotalElems;
      if(when_MemoryEngine_l269) begin
        loadTrackCountdown_0 <= (loadTrackCountdown_0 - 2'b01);
      end
      if(when_MemoryEngine_l269_1) begin
        loadTrackCountdown_1 <= (loadTrackCountdown_1 - 2'b01);
      end
      if(when_MemoryEngine_l269_2) begin
        loadTrackCountdown_2 <= (loadTrackCountdown_2 - 2'b01);
      end
      if(when_MemoryEngine_l269_3) begin
        loadTrackCountdown_3 <= (loadTrackCountdown_3 - 2'b01);
      end
      if(when_MemoryEngine_l275) begin
        loadTrackValid_0 <= 1'b0;
        loadTrackHead <= (loadTrackHead + 2'b01);
      end
      if(when_MemoryEngine_l275_1) begin
        loadTrackValid_1 <= 1'b0;
        loadTrackHead <= (loadTrackHead + 2'b01);
      end
      if(when_MemoryEngine_l275_2) begin
        loadTrackValid_2 <= 1'b0;
        loadTrackHead <= (loadTrackHead + 2'b01);
      end
      if(when_MemoryEngine_l275_3) begin
        loadTrackValid_3 <= 1'b0;
        loadTrackHead <= (loadTrackHead + 2'b01);
      end
      if(when_MemoryEngine_l347) begin
        matrixIssueSeen <= 1'b0;
      end
      if(when_MemoryEngine_l436) begin
        case(io_loadSlots_0_opcode)
          4'b0011 : begin
            `ifndef SYNTHESIS
              `ifdef FORMAL
                assert((_zz_loadReqEntry_wordOff <= 4'b1000)); // MemoryEngine.scala:L465
              `else
                if(!(_zz_loadReqEntry_wordOff <= 4'b1000)) begin
                  $display("FAILURE VLOAD: vector crosses AXI beat boundary (word offset + VLEN > wordsPerBeat). Use aligned address."); // MemoryEngine.scala:L465
                  $finish;
                end
              `endif
            `endif
          end
          default : begin
          end
        endcase
        loadReqValid <= 1'b1;
        loadAddrAccepted <= 1'b0;
      end
      if(when_MemoryEngine_l479) begin
        case(io_storeSlots_0_opcode)
          3'b010 : begin
            `ifndef SYNTHESIS
              `ifdef FORMAL
                assert((_zz_when_MemoryEngine_l498 <= 4'b1000)); // MemoryEngine.scala:L508
              `else
                if(!(_zz_when_MemoryEngine_l498 <= 4'b1000)) begin
                  $display("FAILURE VSTORE: vector crosses AXI beat boundary (word offset + VLEN > wordsPerBeat). Use aligned address."); // MemoryEngine.scala:L508
                  $finish;
                end
              `endif
            `endif
          end
          default : begin
          end
        endcase
      end
      if(when_MemoryEngine_l581) begin
        scopyIsM2V <= when_MemoryEngine_l591;
        scopyUseAccum <= io_loadSlots_0_offset[0];
        scopyUseScratchB <= io_loadSlots_0_offset[1];
        scopyTotalElems <= 4'b1000;
        scopyElemIdx <= 4'b0000;
        scopyReadPipeValid <= 1'b0;
        if(when_MemoryEngine_l591) begin
          scopyVectorBase <= io_loadSlots_0_dest;
          scopyMatrixBase <= io_loadSlots_0_addrReg[7:0];
          state <= MemState_SCOPY_M2V;
        end else begin
          scopyVectorBase <= io_loadSlots_0_addrReg;
          scopyMatrixBase <= io_loadSlots_0_dest[7:0];
          state <= MemState_SCOPY_V2M;
        end
      end
      if(io_axiMaster_ar_fire) begin
        loadAddrAccepted <= 1'b1;
      end
      if(when_MemoryEngine_l623) begin
        loadReqValid <= 1'b0;
        loadAddrAccepted <= 1'b0;
        if(when_MemoryEngine_l667) begin
          loadTrackValid_0 <= 1'b1;
          loadTrackDestAddr_0 <= loadReqEntry_destAddr;
          loadTrackCountdown_0 <= 2'b11;
        end
        if(when_MemoryEngine_l667_1) begin
          loadTrackValid_1 <= 1'b1;
          loadTrackDestAddr_1 <= loadReqEntry_destAddr;
          loadTrackCountdown_1 <= 2'b11;
        end
        if(when_MemoryEngine_l667_2) begin
          loadTrackValid_2 <= 1'b1;
          loadTrackDestAddr_2 <= loadReqEntry_destAddr;
          loadTrackCountdown_2 <= 2'b11;
        end
        if(when_MemoryEngine_l667_3) begin
          loadTrackValid_3 <= 1'b1;
          loadTrackDestAddr_3 <= loadReqEntry_destAddr;
          loadTrackCountdown_3 <= 2'b11;
        end
        loadTrackTail <= (loadTrackTail + 2'b01);
      end
      case(state)
        MemState_IDLE : begin
          if(storeReqFifo_io_pop_valid) begin
            awAccepted <= 1'b0;
            wAccepted <= 1'b0;
            state <= MemState_STORE_AW_W;
          end
        end
        MemState_STORE_AW_W : begin
          if(io_axiMaster_aw_fire) begin
            awAccepted <= 1'b1;
          end
          if(io_axiMaster_w_fire) begin
            wAccepted <= 1'b1;
          end
          if(when_MemoryEngine_l716) begin
            awAccepted <= 1'b0;
            wAccepted <= 1'b0;
            state <= MemState_STORE_B;
          end
        end
        MemState_STORE_B : begin
          if(io_axiMaster_b_valid) begin
            state <= MemState_IDLE;
          end
        end
        MemState_MATRIX_READ_AR : begin
          if(io_axiMaster_ar_fire) begin
            state <= MemState_MATRIX_READ_R;
          end
        end
        MemState_MATRIX_READ_R : begin
          if(io_axiMaster_r_valid) begin
            matrixBeatBuffer <= io_axiMaster_r_payload_data;
            matrixDrainIndex <= 7'h0;
            state <= MemState_MATRIX_READ_DRAIN;
          end
        end
        MemState_MATRIX_READ_DRAIN : begin
          if(when_MemoryEngine_l789) begin
            matrixDrainIndex <= 7'h0;
            matrixElemsTransferred <= _zz_matrixElemsTransferred;
            matrixDramAddr <= (matrixDramAddr + 32'h00000040);
            if(when_MemoryEngine_l793) begin
              state <= MemState_IDLE;
            end else begin
              matrixBeatElems <= _zz_matrixBeatElems;
              state <= MemState_MATRIX_READ_AR;
            end
          end else begin
            matrixDrainIndex <= _zz_matrixDrainIndex;
          end
        end
        MemState_MATRIX_WRITE_GATHER : begin
          if(matrixReadPipeValid) begin
            if(matrixUseAccum) begin
              if(when_MemoryEngine_l812) begin
                matrixBeatBuffer[31 : 0] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_1) begin
                matrixBeatBuffer[63 : 32] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_2) begin
                matrixBeatBuffer[95 : 64] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_3) begin
                matrixBeatBuffer[127 : 96] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_4) begin
                matrixBeatBuffer[159 : 128] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_5) begin
                matrixBeatBuffer[191 : 160] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_6) begin
                matrixBeatBuffer[223 : 192] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_7) begin
                matrixBeatBuffer[255 : 224] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_8) begin
                matrixBeatBuffer[287 : 256] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_9) begin
                matrixBeatBuffer[319 : 288] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_10) begin
                matrixBeatBuffer[351 : 320] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_11) begin
                matrixBeatBuffer[383 : 352] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_12) begin
                matrixBeatBuffer[415 : 384] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_13) begin
                matrixBeatBuffer[447 : 416] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_14) begin
                matrixBeatBuffer[479 : 448] <= io_matrixAccumRdData;
              end
              if(when_MemoryEngine_l812_15) begin
                matrixBeatBuffer[511 : 480] <= io_matrixAccumRdData;
              end
            end else begin
              if(when_MemoryEngine_l818) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[7 : 0] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[7 : 0] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_1) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[15 : 8] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[15 : 8] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_2) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[23 : 16] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[23 : 16] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_3) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[31 : 24] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[31 : 24] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_4) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[39 : 32] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[39 : 32] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_5) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[47 : 40] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[47 : 40] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_6) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[55 : 48] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[55 : 48] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_7) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[63 : 56] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[63 : 56] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_8) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[71 : 64] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[71 : 64] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_9) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[79 : 72] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[79 : 72] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_10) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[87 : 80] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[87 : 80] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_11) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[95 : 88] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[95 : 88] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_12) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[103 : 96] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[103 : 96] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_13) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[111 : 104] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[111 : 104] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_14) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[119 : 112] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[119 : 112] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_15) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[127 : 120] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[127 : 120] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_16) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[135 : 128] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[135 : 128] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_17) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[143 : 136] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[143 : 136] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_18) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[151 : 144] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[151 : 144] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_19) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[159 : 152] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[159 : 152] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_20) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[167 : 160] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[167 : 160] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_21) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[175 : 168] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[175 : 168] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_22) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[183 : 176] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[183 : 176] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_23) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[191 : 184] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[191 : 184] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_24) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[199 : 192] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[199 : 192] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_25) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[207 : 200] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[207 : 200] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_26) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[215 : 208] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[215 : 208] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_27) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[223 : 216] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[223 : 216] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_28) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[231 : 224] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[231 : 224] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_29) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[239 : 232] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[239 : 232] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_30) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[247 : 240] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[247 : 240] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_31) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[255 : 248] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[255 : 248] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_32) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[263 : 256] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[263 : 256] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_33) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[271 : 264] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[271 : 264] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_34) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[279 : 272] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[279 : 272] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_35) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[287 : 280] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[287 : 280] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_36) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[295 : 288] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[295 : 288] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_37) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[303 : 296] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[303 : 296] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_38) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[311 : 304] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[311 : 304] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_39) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[319 : 312] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[319 : 312] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_40) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[327 : 320] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[327 : 320] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_41) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[335 : 328] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[335 : 328] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_42) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[343 : 336] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[343 : 336] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_43) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[351 : 344] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[351 : 344] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_44) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[359 : 352] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[359 : 352] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_45) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[367 : 360] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[367 : 360] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_46) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[375 : 368] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[375 : 368] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_47) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[383 : 376] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[383 : 376] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_48) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[391 : 384] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[391 : 384] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_49) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[399 : 392] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[399 : 392] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_50) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[407 : 400] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[407 : 400] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_51) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[415 : 408] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[415 : 408] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_52) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[423 : 416] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[423 : 416] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_53) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[431 : 424] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[431 : 424] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_54) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[439 : 432] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[439 : 432] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_55) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[447 : 440] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[447 : 440] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_56) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[455 : 448] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[455 : 448] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_57) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[463 : 456] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[463 : 456] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_58) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[471 : 464] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[471 : 464] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_59) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[479 : 472] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[479 : 472] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_60) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[487 : 480] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[487 : 480] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_61) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[495 : 488] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[495 : 488] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_62) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[503 : 496] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[503 : 496] <= io_matrixScratchARdData;
                end
              end
              if(when_MemoryEngine_l818_63) begin
                if(matrixUseScratchB) begin
                  matrixBeatBuffer[511 : 504] <= io_matrixScratchBRdData;
                end else begin
                  matrixBeatBuffer[511 : 504] <= io_matrixScratchARdData;
                end
              end
            end
            matrixGatherCaptured <= (matrixGatherCaptured + 7'h01);
          end
          if(when_MemoryEngine_l830) begin
            matrixReadPipeValid <= 1'b1;
            matrixReadPipeIndex <= matrixGatherIssued;
            matrixGatherIssued <= (matrixGatherIssued + 7'h01);
          end else begin
            matrixReadPipeValid <= 1'b0;
          end
          if(when_MemoryEngine_l853) begin
            awAccepted <= 1'b0;
            wAccepted <= 1'b0;
            state <= MemState_MATRIX_WRITE_AW_W;
          end
        end
        MemState_MATRIX_WRITE_AW_W : begin
          if(io_axiMaster_aw_fire) begin
            awAccepted <= 1'b1;
          end
          if(io_axiMaster_w_fire) begin
            wAccepted <= 1'b1;
          end
          if(when_MemoryEngine_l874) begin
            awAccepted <= 1'b0;
            wAccepted <= 1'b0;
            state <= MemState_MATRIX_WRITE_B;
          end
        end
        MemState_MATRIX_WRITE_B : begin
          if(io_axiMaster_b_valid) begin
            matrixElemsTransferred <= _zz_matrixElemsTransferred_1;
            matrixDramAddr <= (matrixDramAddr + 32'h00000040);
            matrixBeatBuffer <= 512'h0;
            matrixGatherIssued <= 7'h0;
            matrixGatherCaptured <= 7'h0;
            matrixReadPipeValid <= 1'b0;
            matrixReadPipeIndex <= 7'h0;
            if(when_MemoryEngine_l892) begin
              state <= MemState_IDLE;
            end else begin
              matrixBeatElems <= _zz_matrixBeatElems_1;
              state <= MemState_MATRIX_WRITE_GATHER;
            end
          end
        end
        MemState_SCOPY_M2V : begin
          if(when_MemoryEngine_l926) begin
            scopyReadPipeValid <= 1'b1;
            scopyElemIdx <= (scopyElemIdx + 4'b0001);
          end else begin
            scopyReadPipeValid <= 1'b0;
          end
          if(when_MemoryEngine_l949) begin
            state <= MemState_IDLE;
          end
        end
        default : begin
          if(when_MemoryEngine_l985) begin
            scopyReadPipeValid <= 1'b1;
            scopyElemIdx <= (scopyElemIdx + 4'b0001);
          end else begin
            scopyReadPipeValid <= 1'b0;
          end
          if(when_MemoryEngine_l996) begin
            state <= MemState_IDLE;
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if(when_MemoryEngine_l436) begin
      loadReqEntry_slotIdx <= 1'b0;
      loadReqEntry_wordOff <= _zz_loadReqEntry_wordOff;
      loadReqEntry_isVector <= (io_loadSlots_0_opcode == 4'b0011);
      case(io_loadSlots_0_opcode)
        4'b0001 : begin
          loadReqEntry_axiAddr <= _zz_loadReqEntry_axiAddr_1;
          loadReqEntry_destAddr <= io_loadSlots_0_dest;
        end
        4'b0010 : begin
          loadReqEntry_axiAddr <= (_zz_loadReqEntry_axiAddr_2 & (~ alignMask));
          loadReqEntry_destAddr <= (io_loadSlots_0_dest + _zz_loadReqEntry_destAddr);
          loadReqEntry_wordOff <= _zz_loadReqEntry_wordOff_1[3:0];
        end
        4'b0011 : begin
          loadReqEntry_axiAddr <= _zz_loadReqEntry_axiAddr_1;
          loadReqEntry_destAddr <= io_loadSlots_0_dest;
        end
        default : begin
        end
      endcase
    end
    case(state)
      MemState_IDLE : begin
        if(storeReqFifo_io_pop_valid) begin
          capStoreReq_axiAddr <= storeReqFifo_io_pop_payload_axiAddr;
          capStoreReq_wdata <= storeReqFifo_io_pop_payload_wdata;
          capStoreReq_wstrb <= storeReqFifo_io_pop_payload_wstrb;
        end
      end
      MemState_STORE_AW_W : begin
      end
      MemState_STORE_B : begin
      end
      MemState_MATRIX_READ_AR : begin
      end
      MemState_MATRIX_READ_R : begin
      end
      MemState_MATRIX_READ_DRAIN : begin
      end
      MemState_MATRIX_WRITE_GATHER : begin
      end
      MemState_MATRIX_WRITE_AW_W : begin
      end
      MemState_MATRIX_WRITE_B : begin
      end
      MemState_SCOPY_M2V : begin
      end
      default : begin
      end
    endcase
  end


endmodule

module StreamFifo (
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
  output wire [2:0]    io_occupancy,
  output wire [2:0]    io_availability,
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
  reg        [2:0]    logic_ptr_push;
  reg        [2:0]    logic_ptr_pop;
  wire       [2:0]    logic_ptr_occupancy;
  wire       [2:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1248;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [1:0]    logic_push_onRam_write_payload_address;
  wire       [31:0]   logic_push_onRam_write_payload_data_axiAddr;
  wire       [511:0]  logic_push_onRam_write_payload_data_wdata;
  wire       [63:0]   logic_push_onRam_write_payload_data_wstrb;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [1:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [1:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [1:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l375;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [1:0]    logic_pop_sync_readPort_cmd_payload;
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
  reg        [2:0]    logic_pop_sync_popReg;
  reg [607:0] logic_ram [0:3];

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
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 3'b100) == 3'b000);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[1:0];
  assign logic_push_onRam_write_payload_data_axiAddr = io_push_payload_axiAddr;
  assign logic_push_onRam_write_payload_data_wdata = io_push_payload_wdata;
  assign logic_push_onRam_write_payload_data_wstrb = io_push_payload_wstrb;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[1:0];
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
  assign io_availability = (3'b100 - logic_ptr_occupancy);
  always @(posedge clk) begin
    if(reset) begin
      logic_ptr_push <= 3'b000;
      logic_ptr_pop <= 3'b000;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 3'b000;
    end else begin
      if(when_Stream_l1248) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 3'b001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 3'b001);
      end
      if(io_flush) begin
        logic_ptr_push <= 3'b000;
        logic_ptr_pop <= 3'b000;
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
        logic_pop_sync_popReg <= 3'b000;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule
