// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : DecodeUnit

`timescale 1ns/1ps

module DecodeUnit (
  input  wire [255:0]  io_bundle,
  input  wire          io_valid,
  output wire          io_aluSlots_0_valid,
  output wire [3:0]    io_aluSlots_0_opcode,
  output wire [10:0]   io_aluSlots_0_dest,
  output wire [10:0]   io_aluSlots_0_src1,
  output wire [10:0]   io_aluSlots_0_src2,
  output wire          io_valuSlots_0_valid,
  output wire [3:0]    io_valuSlots_0_opcode,
  output wire [10:0]   io_valuSlots_0_destBase,
  output wire [10:0]   io_valuSlots_0_src1Base,
  output wire [10:0]   io_valuSlots_0_src2Base,
  output wire [10:0]   io_valuSlots_0_src3Base,
  output wire          io_loadSlots_0_valid,
  output wire [2:0]    io_loadSlots_0_opcode,
  output wire [10:0]   io_loadSlots_0_dest,
  output wire [10:0]   io_loadSlots_0_addrReg,
  output wire [2:0]    io_loadSlots_0_offset,
  output wire [31:0]   io_loadSlots_0_immediate,
  output wire          io_storeSlots_0_valid,
  output wire [1:0]    io_storeSlots_0_opcode,
  output wire [10:0]   io_storeSlots_0_addrReg,
  output wire [10:0]   io_storeSlots_0_srcReg,
  output wire          io_flowSlot_valid,
  output wire [3:0]    io_flowSlot_opcode,
  output wire [10:0]   io_flowSlot_dest,
  output wire [10:0]   io_flowSlot_operandA,
  output wire [10:0]   io_flowSlot_operandB,
  output wire [9:0]    io_flowSlot_immediate
);

  wire       [39:0]   _zz_io_aluSlots_0_valid;
  wire       [55:0]   _zz_io_valuSlots_0_valid;
  wire       [47:0]   _zz_io_loadSlots_0_valid;
  wire       [27:0]   _zz_io_storeSlots_0_valid;
  wire       [47:0]   _zz_io_flowSlot_valid;

  assign _zz_io_aluSlots_0_valid = io_bundle[39 : 0];
  assign io_aluSlots_0_valid = (_zz_io_aluSlots_0_valid[39] && io_valid);
  assign io_aluSlots_0_opcode = _zz_io_aluSlots_0_valid[38 : 35];
  assign io_aluSlots_0_dest = _zz_io_aluSlots_0_valid[34 : 24];
  assign io_aluSlots_0_src1 = _zz_io_aluSlots_0_valid[23 : 13];
  assign io_aluSlots_0_src2 = _zz_io_aluSlots_0_valid[12 : 2];
  assign _zz_io_valuSlots_0_valid = io_bundle[95 : 40];
  assign io_valuSlots_0_valid = (_zz_io_valuSlots_0_valid[55] && io_valid);
  assign io_valuSlots_0_opcode = _zz_io_valuSlots_0_valid[54 : 51];
  assign io_valuSlots_0_destBase = _zz_io_valuSlots_0_valid[50 : 40];
  assign io_valuSlots_0_src1Base = _zz_io_valuSlots_0_valid[39 : 29];
  assign io_valuSlots_0_src2Base = _zz_io_valuSlots_0_valid[28 : 18];
  assign io_valuSlots_0_src3Base = _zz_io_valuSlots_0_valid[17 : 7];
  assign _zz_io_loadSlots_0_valid = io_bundle[143 : 96];
  assign io_loadSlots_0_valid = (_zz_io_loadSlots_0_valid[47] && io_valid);
  assign io_loadSlots_0_opcode = _zz_io_loadSlots_0_valid[46 : 44];
  assign io_loadSlots_0_dest = _zz_io_loadSlots_0_valid[43 : 33];
  assign io_loadSlots_0_addrReg = _zz_io_loadSlots_0_valid[32 : 22];
  assign io_loadSlots_0_offset = _zz_io_loadSlots_0_valid[21 : 19];
  assign io_loadSlots_0_immediate = _zz_io_loadSlots_0_valid[31 : 0];
  assign _zz_io_storeSlots_0_valid = io_bundle[171 : 144];
  assign io_storeSlots_0_valid = (_zz_io_storeSlots_0_valid[27] && io_valid);
  assign io_storeSlots_0_opcode = _zz_io_storeSlots_0_valid[26 : 25];
  assign io_storeSlots_0_addrReg = _zz_io_storeSlots_0_valid[24 : 14];
  assign io_storeSlots_0_srcReg = _zz_io_storeSlots_0_valid[13 : 3];
  assign _zz_io_flowSlot_valid = io_bundle[219 : 172];
  assign io_flowSlot_valid = (_zz_io_flowSlot_valid[47] && io_valid);
  assign io_flowSlot_opcode = _zz_io_flowSlot_valid[46 : 43];
  assign io_flowSlot_dest = _zz_io_flowSlot_valid[42 : 32];
  assign io_flowSlot_operandA = _zz_io_flowSlot_valid[31 : 21];
  assign io_flowSlot_operandB = _zz_io_flowSlot_valid[20 : 10];
  assign io_flowSlot_immediate = _zz_io_flowSlot_valid[9 : 0];

endmodule
