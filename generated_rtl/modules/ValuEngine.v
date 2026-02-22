// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : ValuEngine

`timescale 1ns/1ps

module ValuEngine (
  input  wire          io_slots_0_valid,
  input  wire [3:0]    io_slots_0_opcode,
  input  wire [10:0]   io_slots_0_destBase,
  input  wire [10:0]   io_slots_0_src1Base,
  input  wire [10:0]   io_slots_0_src2Base,
  input  wire [10:0]   io_slots_0_src3Base,
  input  wire          io_valid,
  input  wire [31:0]   io_operandA_0_0,
  input  wire [31:0]   io_operandA_0_1,
  input  wire [31:0]   io_operandA_0_2,
  input  wire [31:0]   io_operandA_0_3,
  input  wire [31:0]   io_operandA_0_4,
  input  wire [31:0]   io_operandA_0_5,
  input  wire [31:0]   io_operandA_0_6,
  input  wire [31:0]   io_operandA_0_7,
  input  wire [31:0]   io_operandB_0_0,
  input  wire [31:0]   io_operandB_0_1,
  input  wire [31:0]   io_operandB_0_2,
  input  wire [31:0]   io_operandB_0_3,
  input  wire [31:0]   io_operandB_0_4,
  input  wire [31:0]   io_operandB_0_5,
  input  wire [31:0]   io_operandB_0_6,
  input  wire [31:0]   io_operandB_0_7,
  input  wire [31:0]   io_operandC_0_0,
  input  wire [31:0]   io_operandC_0_1,
  input  wire [31:0]   io_operandC_0_2,
  input  wire [31:0]   io_operandC_0_3,
  input  wire [31:0]   io_operandC_0_4,
  input  wire [31:0]   io_operandC_0_5,
  input  wire [31:0]   io_operandC_0_6,
  input  wire [31:0]   io_operandC_0_7,
  output wire          io_writeReqs_0_0_valid,
  output wire [10:0]   io_writeReqs_0_0_payload_addr,
  output wire [31:0]   io_writeReqs_0_0_payload_data,
  output wire          io_writeReqs_0_1_valid,
  output wire [10:0]   io_writeReqs_0_1_payload_addr,
  output wire [31:0]   io_writeReqs_0_1_payload_data,
  output wire          io_writeReqs_0_2_valid,
  output wire [10:0]   io_writeReqs_0_2_payload_addr,
  output wire [31:0]   io_writeReqs_0_2_payload_data,
  output wire          io_writeReqs_0_3_valid,
  output wire [10:0]   io_writeReqs_0_3_payload_addr,
  output wire [31:0]   io_writeReqs_0_3_payload_data,
  output wire          io_writeReqs_0_4_valid,
  output wire [10:0]   io_writeReqs_0_4_payload_addr,
  output wire [31:0]   io_writeReqs_0_4_payload_data,
  output wire          io_writeReqs_0_5_valid,
  output wire [10:0]   io_writeReqs_0_5_payload_addr,
  output wire [31:0]   io_writeReqs_0_5_payload_data,
  output wire          io_writeReqs_0_6_valid,
  output wire [10:0]   io_writeReqs_0_6_payload_addr,
  output wire [31:0]   io_writeReqs_0_6_payload_data,
  output wire          io_writeReqs_0_7_valid,
  output wire [10:0]   io_writeReqs_0_7_payload_addr,
  output wire [31:0]   io_writeReqs_0_7_payload_data,
  input  wire          clk,
  input  wire          reset
);

  wire                unsignedDivider_8_io_start;
  wire       [31:0]   unsignedDivider_8_io_dividend;
  wire                unsignedDivider_9_io_start;
  wire       [31:0]   unsignedDivider_9_io_dividend;
  wire                unsignedDivider_10_io_start;
  wire       [31:0]   unsignedDivider_10_io_dividend;
  wire                unsignedDivider_11_io_start;
  wire       [31:0]   unsignedDivider_11_io_dividend;
  wire                unsignedDivider_12_io_start;
  wire       [31:0]   unsignedDivider_12_io_dividend;
  wire                unsignedDivider_13_io_start;
  wire       [31:0]   unsignedDivider_13_io_dividend;
  wire                unsignedDivider_14_io_start;
  wire       [31:0]   unsignedDivider_14_io_dividend;
  wire                unsignedDivider_15_io_start;
  wire       [31:0]   unsignedDivider_15_io_dividend;
  wire                unsignedDivider_8_io_done;
  wire                unsignedDivider_8_io_busy;
  wire       [31:0]   unsignedDivider_8_io_quotient;
  wire       [31:0]   unsignedDivider_8_io_remainder;
  wire                unsignedDivider_9_io_done;
  wire                unsignedDivider_9_io_busy;
  wire       [31:0]   unsignedDivider_9_io_quotient;
  wire       [31:0]   unsignedDivider_9_io_remainder;
  wire                unsignedDivider_10_io_done;
  wire                unsignedDivider_10_io_busy;
  wire       [31:0]   unsignedDivider_10_io_quotient;
  wire       [31:0]   unsignedDivider_10_io_remainder;
  wire                unsignedDivider_11_io_done;
  wire                unsignedDivider_11_io_busy;
  wire       [31:0]   unsignedDivider_11_io_quotient;
  wire       [31:0]   unsignedDivider_11_io_remainder;
  wire                unsignedDivider_12_io_done;
  wire                unsignedDivider_12_io_busy;
  wire       [31:0]   unsignedDivider_12_io_quotient;
  wire       [31:0]   unsignedDivider_12_io_remainder;
  wire                unsignedDivider_13_io_done;
  wire                unsignedDivider_13_io_busy;
  wire       [31:0]   unsignedDivider_13_io_quotient;
  wire       [31:0]   unsignedDivider_13_io_remainder;
  wire                unsignedDivider_14_io_done;
  wire                unsignedDivider_14_io_busy;
  wire       [31:0]   unsignedDivider_14_io_quotient;
  wire       [31:0]   unsignedDivider_14_io_remainder;
  wire                unsignedDivider_15_io_done;
  wire                unsignedDivider_15_io_busy;
  wire       [31:0]   unsignedDivider_15_io_quotient;
  wire       [31:0]   unsignedDivider_15_io_remainder;
  wire       [31:0]   _zz_io_dividend;
  wire       [31:0]   _zz_io_dividend_1;
  wire       [63:0]   _zz__zz_io_writeReqs_0_0_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_0_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_0_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_0_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_0_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_0_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_0_payload_addr_1;
  wire       [31:0]   _zz_io_dividend_2;
  wire       [31:0]   _zz_io_dividend_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_1_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_1_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_1_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_1_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_1_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_1_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_1_payload_addr_1;
  wire       [31:0]   _zz_io_dividend_4;
  wire       [31:0]   _zz_io_dividend_5;
  wire       [63:0]   _zz__zz_io_writeReqs_0_2_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_2_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_2_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_2_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_2_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_2_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_2_payload_addr_1;
  wire       [31:0]   _zz_io_dividend_6;
  wire       [31:0]   _zz_io_dividend_7;
  wire       [63:0]   _zz__zz_io_writeReqs_0_3_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_3_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_3_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_3_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_3_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_3_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_3_payload_addr_1;
  wire       [31:0]   _zz_io_dividend_8;
  wire       [31:0]   _zz_io_dividend_9;
  wire       [63:0]   _zz__zz_io_writeReqs_0_4_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_4_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_4_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_4_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_4_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_4_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_4_payload_addr_1;
  wire       [31:0]   _zz_io_dividend_10;
  wire       [31:0]   _zz_io_dividend_11;
  wire       [63:0]   _zz__zz_io_writeReqs_0_5_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_5_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_5_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_5_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_5_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_5_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_5_payload_addr_1;
  wire       [31:0]   _zz_io_dividend_12;
  wire       [31:0]   _zz_io_dividend_13;
  wire       [63:0]   _zz__zz_io_writeReqs_0_6_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_6_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_6_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_6_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_6_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_6_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_6_payload_addr_1;
  wire       [31:0]   _zz_io_dividend_14;
  wire       [31:0]   _zz_io_dividend_15;
  wire       [63:0]   _zz__zz_io_writeReqs_0_7_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_7_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_7_payload_data_1_2;
  wire       [63:0]   _zz__zz_io_writeReqs_0_7_payload_data_1_3;
  wire       [63:0]   _zz__zz_io_writeReqs_0_7_payload_data_1_4;
  wire       [63:0]   _zz__zz_io_writeReqs_0_7_payload_data_1_5;
  wire       [10:0]   _zz_io_writeReqs_0_7_payload_addr_1;
  wire                _zz_io_writeReqs_0_0_valid;
  reg        [10:0]   _zz_io_writeReqs_0_0_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_0_payload_data;
  wire                _zz_io_writeReqs_0_0_valid_1;
  wire                when_ValuEngine_l75;
  wire                when_ValuEngine_l77;
  reg        [31:0]   _zz_io_writeReqs_0_0_payload_data_1;
  reg        [10:0]   _zz_io_writeReqs_0_1_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_1_payload_data;
  wire                _zz_io_writeReqs_0_1_valid;
  wire                when_ValuEngine_l75_1;
  wire                when_ValuEngine_l77_1;
  reg        [31:0]   _zz_io_writeReqs_0_1_payload_data_1;
  reg        [10:0]   _zz_io_writeReqs_0_2_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_2_payload_data;
  wire                _zz_io_writeReqs_0_2_valid;
  wire                when_ValuEngine_l75_2;
  wire                when_ValuEngine_l77_2;
  reg        [31:0]   _zz_io_writeReqs_0_2_payload_data_1;
  reg        [10:0]   _zz_io_writeReqs_0_3_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_3_payload_data;
  wire                _zz_io_writeReqs_0_3_valid;
  wire                when_ValuEngine_l75_3;
  wire                when_ValuEngine_l77_3;
  reg        [31:0]   _zz_io_writeReqs_0_3_payload_data_1;
  reg        [10:0]   _zz_io_writeReqs_0_4_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_4_payload_data;
  wire                _zz_io_writeReqs_0_4_valid;
  wire                when_ValuEngine_l75_4;
  wire                when_ValuEngine_l77_4;
  reg        [31:0]   _zz_io_writeReqs_0_4_payload_data_1;
  reg        [10:0]   _zz_io_writeReqs_0_5_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_5_payload_data;
  wire                _zz_io_writeReqs_0_5_valid;
  wire                when_ValuEngine_l75_5;
  wire                when_ValuEngine_l77_5;
  reg        [31:0]   _zz_io_writeReqs_0_5_payload_data_1;
  reg        [10:0]   _zz_io_writeReqs_0_6_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_6_payload_data;
  wire                _zz_io_writeReqs_0_6_valid;
  wire                when_ValuEngine_l75_6;
  wire                when_ValuEngine_l77_6;
  reg        [31:0]   _zz_io_writeReqs_0_6_payload_data_1;
  reg        [10:0]   _zz_io_writeReqs_0_7_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_7_payload_data;
  wire                _zz_io_writeReqs_0_7_valid;
  wire                when_ValuEngine_l75_7;
  wire                when_ValuEngine_l77_7;
  reg        [31:0]   _zz_io_writeReqs_0_7_payload_data_1;

  assign _zz_io_dividend = (_zz_io_dividend_1 - 32'h00000001);
  assign _zz_io_dividend_1 = (io_operandA_0_0 + io_operandB_0_0);
  assign _zz__zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 * io_operandB_0_0);
  assign _zz__zz_io_writeReqs_0_0_payload_data_1_1 = (io_operandA_0_0 < io_operandB_0_0);
  assign _zz__zz_io_writeReqs_0_0_payload_data_1_2 = (io_operandA_0_0 == io_operandB_0_0);
  assign _zz__zz_io_writeReqs_0_0_payload_data_1_3 = (_zz__zz_io_writeReqs_0_0_payload_data_1_4 + _zz__zz_io_writeReqs_0_0_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_0_payload_data_1_4 = (io_operandA_0_0 * io_operandB_0_0);
  assign _zz__zz_io_writeReqs_0_0_payload_data_1_5 = {32'd0, io_operandC_0_0};
  assign _zz_io_writeReqs_0_0_payload_addr_1 = (io_slots_0_destBase + 11'h0);
  assign _zz_io_dividend_2 = (_zz_io_dividend_3 - 32'h00000001);
  assign _zz_io_dividend_3 = (io_operandA_0_1 + io_operandB_0_1);
  assign _zz__zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 * io_operandB_0_1);
  assign _zz__zz_io_writeReqs_0_1_payload_data_1_1 = (io_operandA_0_1 < io_operandB_0_1);
  assign _zz__zz_io_writeReqs_0_1_payload_data_1_2 = (io_operandA_0_1 == io_operandB_0_1);
  assign _zz__zz_io_writeReqs_0_1_payload_data_1_3 = (_zz__zz_io_writeReqs_0_1_payload_data_1_4 + _zz__zz_io_writeReqs_0_1_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_1_payload_data_1_4 = (io_operandA_0_1 * io_operandB_0_1);
  assign _zz__zz_io_writeReqs_0_1_payload_data_1_5 = {32'd0, io_operandC_0_1};
  assign _zz_io_writeReqs_0_1_payload_addr_1 = (io_slots_0_destBase + 11'h001);
  assign _zz_io_dividend_4 = (_zz_io_dividend_5 - 32'h00000001);
  assign _zz_io_dividend_5 = (io_operandA_0_2 + io_operandB_0_2);
  assign _zz__zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 * io_operandB_0_2);
  assign _zz__zz_io_writeReqs_0_2_payload_data_1_1 = (io_operandA_0_2 < io_operandB_0_2);
  assign _zz__zz_io_writeReqs_0_2_payload_data_1_2 = (io_operandA_0_2 == io_operandB_0_2);
  assign _zz__zz_io_writeReqs_0_2_payload_data_1_3 = (_zz__zz_io_writeReqs_0_2_payload_data_1_4 + _zz__zz_io_writeReqs_0_2_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_2_payload_data_1_4 = (io_operandA_0_2 * io_operandB_0_2);
  assign _zz__zz_io_writeReqs_0_2_payload_data_1_5 = {32'd0, io_operandC_0_2};
  assign _zz_io_writeReqs_0_2_payload_addr_1 = (io_slots_0_destBase + 11'h002);
  assign _zz_io_dividend_6 = (_zz_io_dividend_7 - 32'h00000001);
  assign _zz_io_dividend_7 = (io_operandA_0_3 + io_operandB_0_3);
  assign _zz__zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 * io_operandB_0_3);
  assign _zz__zz_io_writeReqs_0_3_payload_data_1_1 = (io_operandA_0_3 < io_operandB_0_3);
  assign _zz__zz_io_writeReqs_0_3_payload_data_1_2 = (io_operandA_0_3 == io_operandB_0_3);
  assign _zz__zz_io_writeReqs_0_3_payload_data_1_3 = (_zz__zz_io_writeReqs_0_3_payload_data_1_4 + _zz__zz_io_writeReqs_0_3_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_3_payload_data_1_4 = (io_operandA_0_3 * io_operandB_0_3);
  assign _zz__zz_io_writeReqs_0_3_payload_data_1_5 = {32'd0, io_operandC_0_3};
  assign _zz_io_writeReqs_0_3_payload_addr_1 = (io_slots_0_destBase + 11'h003);
  assign _zz_io_dividend_8 = (_zz_io_dividend_9 - 32'h00000001);
  assign _zz_io_dividend_9 = (io_operandA_0_4 + io_operandB_0_4);
  assign _zz__zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 * io_operandB_0_4);
  assign _zz__zz_io_writeReqs_0_4_payload_data_1_1 = (io_operandA_0_4 < io_operandB_0_4);
  assign _zz__zz_io_writeReqs_0_4_payload_data_1_2 = (io_operandA_0_4 == io_operandB_0_4);
  assign _zz__zz_io_writeReqs_0_4_payload_data_1_3 = (_zz__zz_io_writeReqs_0_4_payload_data_1_4 + _zz__zz_io_writeReqs_0_4_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_4_payload_data_1_4 = (io_operandA_0_4 * io_operandB_0_4);
  assign _zz__zz_io_writeReqs_0_4_payload_data_1_5 = {32'd0, io_operandC_0_4};
  assign _zz_io_writeReqs_0_4_payload_addr_1 = (io_slots_0_destBase + 11'h004);
  assign _zz_io_dividend_10 = (_zz_io_dividend_11 - 32'h00000001);
  assign _zz_io_dividend_11 = (io_operandA_0_5 + io_operandB_0_5);
  assign _zz__zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 * io_operandB_0_5);
  assign _zz__zz_io_writeReqs_0_5_payload_data_1_1 = (io_operandA_0_5 < io_operandB_0_5);
  assign _zz__zz_io_writeReqs_0_5_payload_data_1_2 = (io_operandA_0_5 == io_operandB_0_5);
  assign _zz__zz_io_writeReqs_0_5_payload_data_1_3 = (_zz__zz_io_writeReqs_0_5_payload_data_1_4 + _zz__zz_io_writeReqs_0_5_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_5_payload_data_1_4 = (io_operandA_0_5 * io_operandB_0_5);
  assign _zz__zz_io_writeReqs_0_5_payload_data_1_5 = {32'd0, io_operandC_0_5};
  assign _zz_io_writeReqs_0_5_payload_addr_1 = (io_slots_0_destBase + 11'h005);
  assign _zz_io_dividend_12 = (_zz_io_dividend_13 - 32'h00000001);
  assign _zz_io_dividend_13 = (io_operandA_0_6 + io_operandB_0_6);
  assign _zz__zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 * io_operandB_0_6);
  assign _zz__zz_io_writeReqs_0_6_payload_data_1_1 = (io_operandA_0_6 < io_operandB_0_6);
  assign _zz__zz_io_writeReqs_0_6_payload_data_1_2 = (io_operandA_0_6 == io_operandB_0_6);
  assign _zz__zz_io_writeReqs_0_6_payload_data_1_3 = (_zz__zz_io_writeReqs_0_6_payload_data_1_4 + _zz__zz_io_writeReqs_0_6_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_6_payload_data_1_4 = (io_operandA_0_6 * io_operandB_0_6);
  assign _zz__zz_io_writeReqs_0_6_payload_data_1_5 = {32'd0, io_operandC_0_6};
  assign _zz_io_writeReqs_0_6_payload_addr_1 = (io_slots_0_destBase + 11'h006);
  assign _zz_io_dividend_14 = (_zz_io_dividend_15 - 32'h00000001);
  assign _zz_io_dividend_15 = (io_operandA_0_7 + io_operandB_0_7);
  assign _zz__zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 * io_operandB_0_7);
  assign _zz__zz_io_writeReqs_0_7_payload_data_1_1 = (io_operandA_0_7 < io_operandB_0_7);
  assign _zz__zz_io_writeReqs_0_7_payload_data_1_2 = (io_operandA_0_7 == io_operandB_0_7);
  assign _zz__zz_io_writeReqs_0_7_payload_data_1_3 = (_zz__zz_io_writeReqs_0_7_payload_data_1_4 + _zz__zz_io_writeReqs_0_7_payload_data_1_5);
  assign _zz__zz_io_writeReqs_0_7_payload_data_1_4 = (io_operandA_0_7 * io_operandB_0_7);
  assign _zz__zz_io_writeReqs_0_7_payload_data_1_5 = {32'd0, io_operandC_0_7};
  assign _zz_io_writeReqs_0_7_payload_addr_1 = (io_slots_0_destBase + 11'h007);
  UnsignedDivider unsignedDivider_8 (
    .io_start     (unsignedDivider_8_io_start          ), //i
    .io_dividend  (unsignedDivider_8_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_0[31:0]               ), //i
    .io_done      (unsignedDivider_8_io_done           ), //o
    .io_busy      (unsignedDivider_8_io_busy           ), //o
    .io_quotient  (unsignedDivider_8_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_8_io_remainder[31:0]), //o
    .clk          (clk                                 ), //i
    .reset        (reset                               )  //i
  );
  UnsignedDivider unsignedDivider_9 (
    .io_start     (unsignedDivider_9_io_start          ), //i
    .io_dividend  (unsignedDivider_9_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_1[31:0]               ), //i
    .io_done      (unsignedDivider_9_io_done           ), //o
    .io_busy      (unsignedDivider_9_io_busy           ), //o
    .io_quotient  (unsignedDivider_9_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_9_io_remainder[31:0]), //o
    .clk          (clk                                 ), //i
    .reset        (reset                               )  //i
  );
  UnsignedDivider unsignedDivider_10 (
    .io_start     (unsignedDivider_10_io_start          ), //i
    .io_dividend  (unsignedDivider_10_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_2[31:0]                ), //i
    .io_done      (unsignedDivider_10_io_done           ), //o
    .io_busy      (unsignedDivider_10_io_busy           ), //o
    .io_quotient  (unsignedDivider_10_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_10_io_remainder[31:0]), //o
    .clk          (clk                                  ), //i
    .reset        (reset                                )  //i
  );
  UnsignedDivider unsignedDivider_11 (
    .io_start     (unsignedDivider_11_io_start          ), //i
    .io_dividend  (unsignedDivider_11_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_3[31:0]                ), //i
    .io_done      (unsignedDivider_11_io_done           ), //o
    .io_busy      (unsignedDivider_11_io_busy           ), //o
    .io_quotient  (unsignedDivider_11_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_11_io_remainder[31:0]), //o
    .clk          (clk                                  ), //i
    .reset        (reset                                )  //i
  );
  UnsignedDivider unsignedDivider_12 (
    .io_start     (unsignedDivider_12_io_start          ), //i
    .io_dividend  (unsignedDivider_12_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_4[31:0]                ), //i
    .io_done      (unsignedDivider_12_io_done           ), //o
    .io_busy      (unsignedDivider_12_io_busy           ), //o
    .io_quotient  (unsignedDivider_12_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_12_io_remainder[31:0]), //o
    .clk          (clk                                  ), //i
    .reset        (reset                                )  //i
  );
  UnsignedDivider unsignedDivider_13 (
    .io_start     (unsignedDivider_13_io_start          ), //i
    .io_dividend  (unsignedDivider_13_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_5[31:0]                ), //i
    .io_done      (unsignedDivider_13_io_done           ), //o
    .io_busy      (unsignedDivider_13_io_busy           ), //o
    .io_quotient  (unsignedDivider_13_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_13_io_remainder[31:0]), //o
    .clk          (clk                                  ), //i
    .reset        (reset                                )  //i
  );
  UnsignedDivider unsignedDivider_14 (
    .io_start     (unsignedDivider_14_io_start          ), //i
    .io_dividend  (unsignedDivider_14_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_6[31:0]                ), //i
    .io_done      (unsignedDivider_14_io_done           ), //o
    .io_busy      (unsignedDivider_14_io_busy           ), //o
    .io_quotient  (unsignedDivider_14_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_14_io_remainder[31:0]), //o
    .clk          (clk                                  ), //i
    .reset        (reset                                )  //i
  );
  UnsignedDivider unsignedDivider_15 (
    .io_start     (unsignedDivider_15_io_start          ), //i
    .io_dividend  (unsignedDivider_15_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0_7[31:0]                ), //i
    .io_done      (unsignedDivider_15_io_done           ), //o
    .io_busy      (unsignedDivider_15_io_busy           ), //o
    .io_quotient  (unsignedDivider_15_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_15_io_remainder[31:0]), //o
    .clk          (clk                                  ), //i
    .reset        (reset                                )  //i
  );
  assign _zz_io_writeReqs_0_0_valid = (io_slots_0_valid && io_valid);
  assign _zz_io_writeReqs_0_0_valid_1 = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_8_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_0_valid_1) && (! unsignedDivider_8_io_busy));
  assign unsignedDivider_8_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend : io_operandA_0_0);
  assign when_ValuEngine_l75 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_0_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 + io_operandB_0_0);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 - io_operandB_0_0);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = _zz__zz_io_writeReqs_0_0_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 ^ io_operandB_0_0);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 & io_operandB_0_0);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 | io_operandB_0_0);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 <<< io_operandB_0_0[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = (io_operandA_0_0 >>> io_operandB_0_0[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_0_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_0_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_0_payload_data_1 = _zz__zz_io_writeReqs_0_0_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_0_valid = (unsignedDivider_8_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_0_valid_1)));
  assign io_writeReqs_0_0_payload_addr = (unsignedDivider_8_io_done ? _zz_io_writeReqs_0_0_payload_addr : _zz_io_writeReqs_0_0_payload_addr_1);
  assign io_writeReqs_0_0_payload_data = (unsignedDivider_8_io_done ? ((_zz_io_writeReqs_0_0_payload_data == 2'b00) ? unsignedDivider_8_io_remainder : unsignedDivider_8_io_quotient) : _zz_io_writeReqs_0_0_payload_data_1);
  assign _zz_io_writeReqs_0_1_valid = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_9_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_1_valid) && (! unsignedDivider_9_io_busy));
  assign unsignedDivider_9_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend_2 : io_operandA_0_1);
  assign when_ValuEngine_l75_1 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77_1 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_1_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 + io_operandB_0_1);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 - io_operandB_0_1);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = _zz__zz_io_writeReqs_0_1_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 ^ io_operandB_0_1);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 & io_operandB_0_1);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 | io_operandB_0_1);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 <<< io_operandB_0_1[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = (io_operandA_0_1 >>> io_operandB_0_1[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_1_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_1_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_1_payload_data_1 = _zz__zz_io_writeReqs_0_1_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_1_valid = (unsignedDivider_9_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_1_valid)));
  assign io_writeReqs_0_1_payload_addr = (unsignedDivider_9_io_done ? _zz_io_writeReqs_0_1_payload_addr : _zz_io_writeReqs_0_1_payload_addr_1);
  assign io_writeReqs_0_1_payload_data = (unsignedDivider_9_io_done ? ((_zz_io_writeReqs_0_1_payload_data == 2'b00) ? unsignedDivider_9_io_remainder : unsignedDivider_9_io_quotient) : _zz_io_writeReqs_0_1_payload_data_1);
  assign _zz_io_writeReqs_0_2_valid = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_10_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_2_valid) && (! unsignedDivider_10_io_busy));
  assign unsignedDivider_10_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend_4 : io_operandA_0_2);
  assign when_ValuEngine_l75_2 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77_2 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_2_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 + io_operandB_0_2);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 - io_operandB_0_2);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = _zz__zz_io_writeReqs_0_2_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 ^ io_operandB_0_2);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 & io_operandB_0_2);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 | io_operandB_0_2);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 <<< io_operandB_0_2[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = (io_operandA_0_2 >>> io_operandB_0_2[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_2_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_2_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_2_payload_data_1 = _zz__zz_io_writeReqs_0_2_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_2_valid = (unsignedDivider_10_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_2_valid)));
  assign io_writeReqs_0_2_payload_addr = (unsignedDivider_10_io_done ? _zz_io_writeReqs_0_2_payload_addr : _zz_io_writeReqs_0_2_payload_addr_1);
  assign io_writeReqs_0_2_payload_data = (unsignedDivider_10_io_done ? ((_zz_io_writeReqs_0_2_payload_data == 2'b00) ? unsignedDivider_10_io_remainder : unsignedDivider_10_io_quotient) : _zz_io_writeReqs_0_2_payload_data_1);
  assign _zz_io_writeReqs_0_3_valid = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_11_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_3_valid) && (! unsignedDivider_11_io_busy));
  assign unsignedDivider_11_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend_6 : io_operandA_0_3);
  assign when_ValuEngine_l75_3 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77_3 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_3_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 + io_operandB_0_3);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 - io_operandB_0_3);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = _zz__zz_io_writeReqs_0_3_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 ^ io_operandB_0_3);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 & io_operandB_0_3);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 | io_operandB_0_3);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 <<< io_operandB_0_3[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = (io_operandA_0_3 >>> io_operandB_0_3[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_3_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_3_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_3_payload_data_1 = _zz__zz_io_writeReqs_0_3_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_3_valid = (unsignedDivider_11_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_3_valid)));
  assign io_writeReqs_0_3_payload_addr = (unsignedDivider_11_io_done ? _zz_io_writeReqs_0_3_payload_addr : _zz_io_writeReqs_0_3_payload_addr_1);
  assign io_writeReqs_0_3_payload_data = (unsignedDivider_11_io_done ? ((_zz_io_writeReqs_0_3_payload_data == 2'b00) ? unsignedDivider_11_io_remainder : unsignedDivider_11_io_quotient) : _zz_io_writeReqs_0_3_payload_data_1);
  assign _zz_io_writeReqs_0_4_valid = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_12_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_4_valid) && (! unsignedDivider_12_io_busy));
  assign unsignedDivider_12_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend_8 : io_operandA_0_4);
  assign when_ValuEngine_l75_4 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77_4 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_4_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 + io_operandB_0_4);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 - io_operandB_0_4);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = _zz__zz_io_writeReqs_0_4_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 ^ io_operandB_0_4);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 & io_operandB_0_4);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 | io_operandB_0_4);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 <<< io_operandB_0_4[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = (io_operandA_0_4 >>> io_operandB_0_4[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_4_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_4_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_4_payload_data_1 = _zz__zz_io_writeReqs_0_4_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_4_valid = (unsignedDivider_12_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_4_valid)));
  assign io_writeReqs_0_4_payload_addr = (unsignedDivider_12_io_done ? _zz_io_writeReqs_0_4_payload_addr : _zz_io_writeReqs_0_4_payload_addr_1);
  assign io_writeReqs_0_4_payload_data = (unsignedDivider_12_io_done ? ((_zz_io_writeReqs_0_4_payload_data == 2'b00) ? unsignedDivider_12_io_remainder : unsignedDivider_12_io_quotient) : _zz_io_writeReqs_0_4_payload_data_1);
  assign _zz_io_writeReqs_0_5_valid = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_13_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_5_valid) && (! unsignedDivider_13_io_busy));
  assign unsignedDivider_13_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend_10 : io_operandA_0_5);
  assign when_ValuEngine_l75_5 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77_5 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_5_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 + io_operandB_0_5);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 - io_operandB_0_5);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = _zz__zz_io_writeReqs_0_5_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 ^ io_operandB_0_5);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 & io_operandB_0_5);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 | io_operandB_0_5);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 <<< io_operandB_0_5[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = (io_operandA_0_5 >>> io_operandB_0_5[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_5_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_5_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_5_payload_data_1 = _zz__zz_io_writeReqs_0_5_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_5_valid = (unsignedDivider_13_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_5_valid)));
  assign io_writeReqs_0_5_payload_addr = (unsignedDivider_13_io_done ? _zz_io_writeReqs_0_5_payload_addr : _zz_io_writeReqs_0_5_payload_addr_1);
  assign io_writeReqs_0_5_payload_data = (unsignedDivider_13_io_done ? ((_zz_io_writeReqs_0_5_payload_data == 2'b00) ? unsignedDivider_13_io_remainder : unsignedDivider_13_io_quotient) : _zz_io_writeReqs_0_5_payload_data_1);
  assign _zz_io_writeReqs_0_6_valid = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_14_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_6_valid) && (! unsignedDivider_14_io_busy));
  assign unsignedDivider_14_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend_12 : io_operandA_0_6);
  assign when_ValuEngine_l75_6 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77_6 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_6_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 + io_operandB_0_6);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 - io_operandB_0_6);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = _zz__zz_io_writeReqs_0_6_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 ^ io_operandB_0_6);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 & io_operandB_0_6);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 | io_operandB_0_6);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 <<< io_operandB_0_6[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = (io_operandA_0_6 >>> io_operandB_0_6[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_6_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_6_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_6_payload_data_1 = _zz__zz_io_writeReqs_0_6_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_6_valid = (unsignedDivider_14_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_6_valid)));
  assign io_writeReqs_0_6_payload_addr = (unsignedDivider_14_io_done ? _zz_io_writeReqs_0_6_payload_addr : _zz_io_writeReqs_0_6_payload_addr_1);
  assign io_writeReqs_0_6_payload_data = (unsignedDivider_14_io_done ? ((_zz_io_writeReqs_0_6_payload_data == 2'b00) ? unsignedDivider_14_io_remainder : unsignedDivider_14_io_quotient) : _zz_io_writeReqs_0_6_payload_data_1);
  assign _zz_io_writeReqs_0_7_valid = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_15_io_start = ((_zz_io_writeReqs_0_0_valid && _zz_io_writeReqs_0_7_valid) && (! unsignedDivider_15_io_busy));
  assign unsignedDivider_15_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend_14 : io_operandA_0_7);
  assign when_ValuEngine_l75_7 = (io_slots_0_opcode == 4'b1010);
  assign when_ValuEngine_l77_7 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_7_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 + io_operandB_0_7);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 - io_operandB_0_7);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = _zz__zz_io_writeReqs_0_7_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 ^ io_operandB_0_7);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 & io_operandB_0_7);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 | io_operandB_0_7);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 <<< io_operandB_0_7[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = (io_operandA_0_7 >>> io_operandB_0_7[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_7_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_7_payload_data_1_2};
      end
      4'b1101 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = io_operandC_0_0;
      end
      4'b1110 : begin
        _zz_io_writeReqs_0_7_payload_data_1 = _zz__zz_io_writeReqs_0_7_payload_data_1_3[31:0];
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_7_valid = (unsignedDivider_15_io_done || (_zz_io_writeReqs_0_0_valid && (! _zz_io_writeReqs_0_7_valid)));
  assign io_writeReqs_0_7_payload_addr = (unsignedDivider_15_io_done ? _zz_io_writeReqs_0_7_payload_addr : _zz_io_writeReqs_0_7_payload_addr_1);
  assign io_writeReqs_0_7_payload_data = (unsignedDivider_15_io_done ? ((_zz_io_writeReqs_0_7_payload_data == 2'b00) ? unsignedDivider_15_io_remainder : unsignedDivider_15_io_quotient) : _zz_io_writeReqs_0_7_payload_data_1);
  always @(posedge clk) begin
    if(reset) begin
      _zz_io_writeReqs_0_0_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_0_payload_data <= 2'b00;
      _zz_io_writeReqs_0_1_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_1_payload_data <= 2'b00;
      _zz_io_writeReqs_0_2_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_2_payload_data <= 2'b00;
      _zz_io_writeReqs_0_3_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_3_payload_data <= 2'b00;
      _zz_io_writeReqs_0_4_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_4_payload_data <= 2'b00;
      _zz_io_writeReqs_0_5_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_5_payload_data <= 2'b00;
      _zz_io_writeReqs_0_6_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_6_payload_data <= 2'b00;
      _zz_io_writeReqs_0_7_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_7_payload_data <= 2'b00;
    end else begin
      if(unsignedDivider_8_io_start) begin
        _zz_io_writeReqs_0_0_payload_addr <= (io_slots_0_destBase + 11'h0);
        if(when_ValuEngine_l75) begin
          _zz_io_writeReqs_0_0_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77) begin
            _zz_io_writeReqs_0_0_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_0_payload_data <= 2'b10;
          end
        end
      end
      if(unsignedDivider_9_io_start) begin
        _zz_io_writeReqs_0_1_payload_addr <= (io_slots_0_destBase + 11'h001);
        if(when_ValuEngine_l75_1) begin
          _zz_io_writeReqs_0_1_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77_1) begin
            _zz_io_writeReqs_0_1_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_1_payload_data <= 2'b10;
          end
        end
      end
      if(unsignedDivider_10_io_start) begin
        _zz_io_writeReqs_0_2_payload_addr <= (io_slots_0_destBase + 11'h002);
        if(when_ValuEngine_l75_2) begin
          _zz_io_writeReqs_0_2_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77_2) begin
            _zz_io_writeReqs_0_2_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_2_payload_data <= 2'b10;
          end
        end
      end
      if(unsignedDivider_11_io_start) begin
        _zz_io_writeReqs_0_3_payload_addr <= (io_slots_0_destBase + 11'h003);
        if(when_ValuEngine_l75_3) begin
          _zz_io_writeReqs_0_3_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77_3) begin
            _zz_io_writeReqs_0_3_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_3_payload_data <= 2'b10;
          end
        end
      end
      if(unsignedDivider_12_io_start) begin
        _zz_io_writeReqs_0_4_payload_addr <= (io_slots_0_destBase + 11'h004);
        if(when_ValuEngine_l75_4) begin
          _zz_io_writeReqs_0_4_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77_4) begin
            _zz_io_writeReqs_0_4_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_4_payload_data <= 2'b10;
          end
        end
      end
      if(unsignedDivider_13_io_start) begin
        _zz_io_writeReqs_0_5_payload_addr <= (io_slots_0_destBase + 11'h005);
        if(when_ValuEngine_l75_5) begin
          _zz_io_writeReqs_0_5_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77_5) begin
            _zz_io_writeReqs_0_5_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_5_payload_data <= 2'b10;
          end
        end
      end
      if(unsignedDivider_14_io_start) begin
        _zz_io_writeReqs_0_6_payload_addr <= (io_slots_0_destBase + 11'h006);
        if(when_ValuEngine_l75_6) begin
          _zz_io_writeReqs_0_6_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77_6) begin
            _zz_io_writeReqs_0_6_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_6_payload_data <= 2'b10;
          end
        end
      end
      if(unsignedDivider_15_io_start) begin
        _zz_io_writeReqs_0_7_payload_addr <= (io_slots_0_destBase + 11'h007);
        if(when_ValuEngine_l75_7) begin
          _zz_io_writeReqs_0_7_payload_data <= 2'b00;
        end else begin
          if(when_ValuEngine_l77_7) begin
            _zz_io_writeReqs_0_7_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_7_payload_data <= 2'b10;
          end
        end
      end
    end
  end


endmodule

//UnsignedDivider_7 replaced by UnsignedDivider

//UnsignedDivider_6 replaced by UnsignedDivider

//UnsignedDivider_5 replaced by UnsignedDivider

//UnsignedDivider_4 replaced by UnsignedDivider

//UnsignedDivider_3 replaced by UnsignedDivider

//UnsignedDivider_2 replaced by UnsignedDivider

//UnsignedDivider_1 replaced by UnsignedDivider

module UnsignedDivider (
  input  wire          io_start,
  input  wire [31:0]   io_dividend,
  input  wire [31:0]   io_divisor,
  output wire          io_done,
  output wire          io_busy,
  output wire [31:0]   io_quotient,
  output wire [31:0]   io_remainder,
  input  wire          clk,
  input  wire          reset
);

  wire       [33:0]   _zz__zz_r_1;
  wire       [33:0]   _zz__zz_r_1_1;
  reg                 running;
  reg        [5:0]    counter;
  reg                 donePulse;
  reg        [32:0]   r;
  reg        [31:0]   q;
  reg        [32:0]   d;
  wire                when_UnsignedDivider_l58;
  wire       [32:0]   _zz_r;
  wire       [31:0]   _zz_q;
  wire       [33:0]   _zz_r_1;
  wire                when_UnsignedDivider_l77;
  wire                when_UnsignedDivider_l88;

  assign _zz__zz_r_1 = {1'd0, _zz_r};
  assign _zz__zz_r_1_1 = {1'd0, d};
  assign io_busy = running;
  assign io_done = donePulse;
  assign io_quotient = q;
  assign io_remainder = r[31:0];
  assign when_UnsignedDivider_l58 = (io_start && (! running));
  assign _zz_r = {r[31 : 0],q[31]};
  assign _zz_q = {q[30 : 0],1'b0};
  assign _zz_r_1 = (_zz__zz_r_1 - _zz__zz_r_1_1);
  assign when_UnsignedDivider_l77 = (! _zz_r_1[33]);
  assign when_UnsignedDivider_l88 = (counter == 6'h01);
  always @(posedge clk) begin
    if(reset) begin
      running <= 1'b0;
      counter <= 6'h0;
      donePulse <= 1'b0;
      r <= 33'h0;
      q <= 32'h0;
      d <= 33'h0;
    end else begin
      donePulse <= 1'b0;
      if(when_UnsignedDivider_l58) begin
        r <= 33'h0;
        q <= io_dividend;
        d <= {1'd0, io_divisor};
        counter <= 6'h20;
        running <= 1'b1;
      end
      if(running) begin
        if(when_UnsignedDivider_l77) begin
          r <= _zz_r_1[32:0];
          q <= (_zz_q | 32'h00000001);
        end else begin
          r <= _zz_r;
          q <= _zz_q;
        end
        counter <= (counter - 6'h01);
        if(when_UnsignedDivider_l88) begin
          running <= 1'b0;
          donePulse <= 1'b1;
        end
      end
    end
  end


endmodule
