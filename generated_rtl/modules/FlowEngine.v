// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : FlowEngine
// Git hash  : 2b1c34e10fcfebdb7017c9a507f6d279f35a00fa

`timescale 1ns/1ps

module FlowEngine (
  input  wire          io_slot_valid,
  input  wire [3:0]    io_slot_opcode,
  input  wire [10:0]   io_slot_dest,
  input  wire [10:0]   io_slot_operandA,
  input  wire [10:0]   io_slot_operandB,
  input  wire [9:0]    io_slot_immediate,
  input  wire          io_valid,
  input  wire [9:0]    io_currentPc,
  input  wire [31:0]   io_operandCond,
  input  wire [31:0]   io_operandA,
  input  wire [31:0]   io_operandB,
  input  wire [31:0]   io_vCond_0,
  input  wire [31:0]   io_vCond_1,
  input  wire [31:0]   io_vCond_2,
  input  wire [31:0]   io_vCond_3,
  input  wire [31:0]   io_vCond_4,
  input  wire [31:0]   io_vCond_5,
  input  wire [31:0]   io_vCond_6,
  input  wire [31:0]   io_vCond_7,
  input  wire [31:0]   io_vSrcA_0,
  input  wire [31:0]   io_vSrcA_1,
  input  wire [31:0]   io_vSrcA_2,
  input  wire [31:0]   io_vSrcA_3,
  input  wire [31:0]   io_vSrcA_4,
  input  wire [31:0]   io_vSrcA_5,
  input  wire [31:0]   io_vSrcA_6,
  input  wire [31:0]   io_vSrcA_7,
  input  wire [31:0]   io_vSrcB_0,
  input  wire [31:0]   io_vSrcB_1,
  input  wire [31:0]   io_vSrcB_2,
  input  wire [31:0]   io_vSrcB_3,
  input  wire [31:0]   io_vSrcB_4,
  input  wire [31:0]   io_vSrcB_5,
  input  wire [31:0]   io_vSrcB_6,
  input  wire [31:0]   io_vSrcB_7,
  output reg           io_scalarWriteReq_valid,
  output reg  [10:0]   io_scalarWriteReq_payload_addr,
  output reg  [31:0]   io_scalarWriteReq_payload_data,
  output reg           io_vectorWriteReqs_0_valid,
  output reg  [10:0]   io_vectorWriteReqs_0_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_0_payload_data,
  output reg           io_vectorWriteReqs_1_valid,
  output reg  [10:0]   io_vectorWriteReqs_1_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_1_payload_data,
  output reg           io_vectorWriteReqs_2_valid,
  output reg  [10:0]   io_vectorWriteReqs_2_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_2_payload_data,
  output reg           io_vectorWriteReqs_3_valid,
  output reg  [10:0]   io_vectorWriteReqs_3_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_3_payload_data,
  output reg           io_vectorWriteReqs_4_valid,
  output reg  [10:0]   io_vectorWriteReqs_4_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_4_payload_data,
  output reg           io_vectorWriteReqs_5_valid,
  output reg  [10:0]   io_vectorWriteReqs_5_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_5_payload_data,
  output reg           io_vectorWriteReqs_6_valid,
  output reg  [10:0]   io_vectorWriteReqs_6_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_6_payload_data,
  output reg           io_vectorWriteReqs_7_valid,
  output reg  [10:0]   io_vectorWriteReqs_7_payload_addr,
  output reg  [31:0]   io_vectorWriteReqs_7_payload_data,
  output reg           io_jumpTarget_valid,
  output reg  [9:0]    io_jumpTarget_payload,
  output reg           io_halt
);

  wire       [31:0]   _zz_io_scalarWriteReq_payload_data;
  wire       [9:0]    _zz_io_scalarWriteReq_payload_data_1;
  wire       [20:0]   _zz_io_jumpTarget_payload;
  wire       [9:0]    _zz_io_jumpTarget_payload_1;
  wire       [9:0]    _zz_io_jumpTarget_payload_2;
  wire       [9:0]    _zz_io_jumpTarget_payload_3;
  wire       [20:0]   _zz_io_jumpTarget_payload_4;
  wire                slotValid;
  wire                when_FlowEngine_l109;
  wire                when_FlowEngine_l118;

  assign _zz_io_scalarWriteReq_payload_data_1 = io_slot_immediate;
  assign _zz_io_scalarWriteReq_payload_data = {{22{_zz_io_scalarWriteReq_payload_data_1[9]}}, _zz_io_scalarWriteReq_payload_data_1};
  assign _zz_io_jumpTarget_payload = {io_slot_operandB,io_slot_immediate};
  assign _zz_io_jumpTarget_payload_1 = ($signed(_zz_io_jumpTarget_payload_2) + $signed(_zz_io_jumpTarget_payload_3));
  assign _zz_io_jumpTarget_payload_2 = io_currentPc;
  assign _zz_io_jumpTarget_payload_3 = io_slot_immediate;
  assign _zz_io_jumpTarget_payload_4 = {io_slot_operandB,io_slot_immediate};
  assign slotValid = (io_slot_valid && io_valid);
  always @(*) begin
    io_scalarWriteReq_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0001 : begin
          io_scalarWriteReq_valid = 1'b1;
        end
        4'b0011 : begin
          io_scalarWriteReq_valid = 1'b1;
        end
        4'b1001 : begin
          io_scalarWriteReq_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_scalarWriteReq_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0001 : begin
          io_scalarWriteReq_payload_addr = io_slot_dest;
        end
        4'b0011 : begin
          io_scalarWriteReq_payload_addr = io_slot_dest;
        end
        4'b1001 : begin
          io_scalarWriteReq_payload_addr = io_slot_dest;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_scalarWriteReq_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0001 : begin
          io_scalarWriteReq_payload_data = ((io_operandCond != 32'h0) ? io_operandA : io_operandB);
        end
        4'b0011 : begin
          io_scalarWriteReq_payload_data = (io_operandCond + _zz_io_scalarWriteReq_payload_data);
        end
        4'b1001 : begin
          io_scalarWriteReq_payload_data = 32'h0;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_0_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_0_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_0_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_0_payload_addr = (io_slot_dest + 11'h0);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_0_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_0_payload_data = ((io_vCond_0 != 32'h0) ? io_vSrcA_0 : io_vSrcB_0);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_1_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_1_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_1_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_1_payload_addr = (io_slot_dest + 11'h001);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_1_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_1_payload_data = ((io_vCond_1 != 32'h0) ? io_vSrcA_1 : io_vSrcB_1);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_2_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_2_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_2_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_2_payload_addr = (io_slot_dest + 11'h002);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_2_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_2_payload_data = ((io_vCond_2 != 32'h0) ? io_vSrcA_2 : io_vSrcB_2);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_3_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_3_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_3_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_3_payload_addr = (io_slot_dest + 11'h003);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_3_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_3_payload_data = ((io_vCond_3 != 32'h0) ? io_vSrcA_3 : io_vSrcB_3);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_4_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_4_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_4_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_4_payload_addr = (io_slot_dest + 11'h004);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_4_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_4_payload_data = ((io_vCond_4 != 32'h0) ? io_vSrcA_4 : io_vSrcB_4);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_5_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_5_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_5_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_5_payload_addr = (io_slot_dest + 11'h005);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_5_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_5_payload_data = ((io_vCond_5 != 32'h0) ? io_vSrcA_5 : io_vSrcB_5);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_6_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_6_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_6_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_6_payload_addr = (io_slot_dest + 11'h006);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_6_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_6_payload_data = ((io_vCond_6 != 32'h0) ? io_vSrcA_6 : io_vSrcB_6);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_7_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_7_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_7_payload_addr = 11'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_7_payload_addr = (io_slot_dest + 11'h007);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_vectorWriteReqs_7_payload_data = 32'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0010 : begin
          io_vectorWriteReqs_7_payload_data = ((io_vCond_7 != 32'h0) ? io_vSrcA_7 : io_vSrcB_7);
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_jumpTarget_valid = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0101 : begin
          if(when_FlowEngine_l109) begin
            io_jumpTarget_valid = 1'b1;
          end
        end
        4'b0110 : begin
          if(when_FlowEngine_l118) begin
            io_jumpTarget_valid = 1'b1;
          end
        end
        4'b0111 : begin
          io_jumpTarget_valid = 1'b1;
        end
        4'b1000 : begin
          io_jumpTarget_valid = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_jumpTarget_payload = 10'h0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0101 : begin
          if(when_FlowEngine_l109) begin
            io_jumpTarget_payload = _zz_io_jumpTarget_payload[9:0];
          end
        end
        4'b0110 : begin
          if(when_FlowEngine_l118) begin
            io_jumpTarget_payload = _zz_io_jumpTarget_payload_1;
          end
        end
        4'b0111 : begin
          io_jumpTarget_payload = _zz_io_jumpTarget_payload_4[9:0];
        end
        4'b1000 : begin
          io_jumpTarget_payload = io_operandCond[9:0];
        end
        default : begin
        end
      endcase
    end
  end

  always @(*) begin
    io_halt = 1'b0;
    if(slotValid) begin
      case(io_slot_opcode)
        4'b0100 : begin
          io_halt = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  assign when_FlowEngine_l109 = (io_operandCond != 32'h0);
  assign when_FlowEngine_l118 = (io_operandCond != 32'h0);

endmodule
