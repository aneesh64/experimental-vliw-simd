// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : DecodeUnit
// Git hash  : 414aef5ea78ca06f57c39f378ed640d967e9cf6d

`timescale 1ns/1ps

module DecodeUnit (
  input  wire [255:0]  io_bundle,
  input  wire          io_valid,
  output wire          io_aluSlots_0_valid,
  output wire [4:0]    io_aluSlots_0_opcode,
  output wire [10:0]   io_aluSlots_0_dest,
  output wire [10:0]   io_aluSlots_0_src1,
  output wire [10:0]   io_aluSlots_0_src2,
  output wire          io_valuSlots_0_valid,
  output wire [4:0]    io_valuSlots_0_opcode,
  output wire [10:0]   io_valuSlots_0_destBase,
  output wire [10:0]   io_valuSlots_0_src1Base,
  output wire [10:0]   io_valuSlots_0_src2Base,
  output wire [10:0]   io_valuSlots_0_src3Base,
  output wire [2:0]    io_valuSlots_0_ewidth,
  output wire [2:0]    io_valuSlots_0_dwidth,
  output wire          io_valuSlots_0_isSigned,
  output wire          io_loadSlots_0_valid,
  output wire [3:0]    io_loadSlots_0_opcode,
  output wire [10:0]   io_loadSlots_0_dest,
  output wire [10:0]   io_loadSlots_0_addrReg,
  output wire [2:0]    io_loadSlots_0_offset,
  output wire [31:0]   io_loadSlots_0_immediate,
  output wire          io_storeSlots_0_valid,
  output wire [2:0]    io_storeSlots_0_opcode,
  output wire [10:0]   io_storeSlots_0_addrReg,
  output wire [10:0]   io_storeSlots_0_srcReg,
  output wire          io_flowSlot_valid,
  output wire [4:0]    io_flowSlot_opcode,
  output wire [10:0]   io_flowSlot_dest,
  output wire [10:0]   io_flowSlot_operandA,
  output wire [10:0]   io_flowSlot_operandB,
  output wire [9:0]    io_flowSlot_immediate
);

  wire       [40:0]   _zz_io_aluSlots_0_valid;
  wire       [56:0]   _zz_io_valuSlots_0_valid;
  wire       [48:0]   _zz_io_loadSlots_0_valid;
  wire       [28:0]   _zz_io_storeSlots_0_valid;
  wire       [48:0]   _zz_io_flowSlot_valid;

  assign _zz_io_aluSlots_0_valid = io_bundle[40 : 0];
  assign io_aluSlots_0_valid = (_zz_io_aluSlots_0_valid[40] && io_valid);
  assign io_aluSlots_0_opcode = _zz_io_aluSlots_0_valid[39 : 35];
  assign io_aluSlots_0_dest = _zz_io_aluSlots_0_valid[34 : 24];
  assign io_aluSlots_0_src1 = _zz_io_aluSlots_0_valid[23 : 13];
  assign io_aluSlots_0_src2 = _zz_io_aluSlots_0_valid[12 : 2];
  assign _zz_io_valuSlots_0_valid = io_bundle[97 : 41];
  assign io_valuSlots_0_valid = (_zz_io_valuSlots_0_valid[56] && io_valid);
  assign io_valuSlots_0_opcode = _zz_io_valuSlots_0_valid[55 : 51];
  assign io_valuSlots_0_destBase = _zz_io_valuSlots_0_valid[50 : 40];
  assign io_valuSlots_0_src1Base = _zz_io_valuSlots_0_valid[39 : 29];
  assign io_valuSlots_0_src2Base = _zz_io_valuSlots_0_valid[28 : 18];
  assign io_valuSlots_0_src3Base = _zz_io_valuSlots_0_valid[17 : 7];
  assign io_valuSlots_0_ewidth = _zz_io_valuSlots_0_valid[6 : 4];
  assign io_valuSlots_0_dwidth = _zz_io_valuSlots_0_valid[3 : 1];
  assign io_valuSlots_0_isSigned = _zz_io_valuSlots_0_valid[0];
  assign _zz_io_loadSlots_0_valid = io_bundle[146 : 98];
  assign io_loadSlots_0_valid = (_zz_io_loadSlots_0_valid[48] && io_valid);
  assign io_loadSlots_0_opcode = _zz_io_loadSlots_0_valid[47 : 44];
  assign io_loadSlots_0_dest = _zz_io_loadSlots_0_valid[43 : 33];
  assign io_loadSlots_0_addrReg = _zz_io_loadSlots_0_valid[32 : 22];
  assign io_loadSlots_0_offset = _zz_io_loadSlots_0_valid[21 : 19];
  assign io_loadSlots_0_immediate = _zz_io_loadSlots_0_valid[31 : 0];
  assign _zz_io_storeSlots_0_valid = io_bundle[175 : 147];
  assign io_storeSlots_0_valid = (_zz_io_storeSlots_0_valid[28] && io_valid);
  assign io_storeSlots_0_opcode = _zz_io_storeSlots_0_valid[27 : 25];
  assign io_storeSlots_0_addrReg = _zz_io_storeSlots_0_valid[24 : 14];
  assign io_storeSlots_0_srcReg = _zz_io_storeSlots_0_valid[13 : 3];
  assign _zz_io_flowSlot_valid = io_bundle[224 : 176];
  assign io_flowSlot_valid = (_zz_io_flowSlot_valid[48] && io_valid);
  assign io_flowSlot_opcode = _zz_io_flowSlot_valid[47 : 43];
  assign io_flowSlot_dest = _zz_io_flowSlot_valid[42 : 32];
  assign io_flowSlot_operandA = _zz_io_flowSlot_valid[31 : 21];
  assign io_flowSlot_operandB = _zz_io_flowSlot_valid[20 : 10];
  assign io_flowSlot_immediate = _zz_io_flowSlot_valid[9 : 0];

endmodule
