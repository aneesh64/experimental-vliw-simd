// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : AluEngine
// Git hash  : 414aef5ea78ca06f57c39f378ed640d967e9cf6d

`timescale 1ns/1ps

module AluEngine (
  input  wire          io_slots_0_valid,
  input  wire [4:0]    io_slots_0_opcode,
  input  wire [10:0]   io_slots_0_dest,
  input  wire [10:0]   io_slots_0_src1,
  input  wire [10:0]   io_slots_0_src2,
  input  wire          io_valid,
  input  wire [31:0]   io_operandA_0,
  input  wire [31:0]   io_operandB_0,
  output wire          io_writeReqs_0_valid,
  output wire [10:0]   io_writeReqs_0_payload_addr,
  output wire [31:0]   io_writeReqs_0_payload_data,
  input  wire          clk,
  input  wire          reset
);

  wire                unsignedDivider_1_io_start;
  wire       [31:0]   unsignedDivider_1_io_dividend;
  wire                fp32Unit_1_io_fire;
  wire                unsignedDivider_1_io_done;
  wire                unsignedDivider_1_io_busy;
  wire       [31:0]   unsignedDivider_1_io_quotient;
  wire       [31:0]   unsignedDivider_1_io_remainder;
  wire                fp32Unit_1_io_busy;
  wire                fp32Unit_1_io_done;
  wire       [31:0]   fp32Unit_1_io_result;
  wire       [10:0]   fp32Unit_1_io_tagOut;
  wire       [31:0]   _zz_io_dividend;
  wire       [31:0]   _zz_io_dividend_1;
  wire       [63:0]   _zz__zz_io_writeReqs_0_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_payload_data_1_2;
  wire                _zz_io_writeReqs_0_valid;
  reg        [10:0]   _zz_io_writeReqs_0_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_payload_data;
  wire                _zz_io_writeReqs_0_valid_1;
  wire                _zz_io_writeReqs_0_valid_2;
  wire                when_AluEngine_l78;
  wire                when_AluEngine_l80;
  reg        [31:0]   _zz_io_writeReqs_0_payload_data_1;

  assign _zz_io_dividend = (_zz_io_dividend_1 - 32'h00000001);
  assign _zz_io_dividend_1 = (io_operandA_0 + io_operandB_0);
  assign _zz__zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 * io_operandB_0);
  assign _zz__zz_io_writeReqs_0_payload_data_1_1 = (io_operandA_0 < io_operandB_0);
  assign _zz__zz_io_writeReqs_0_payload_data_1_2 = (io_operandA_0 == io_operandB_0);
  UnsignedDivider unsignedDivider_1 (
    .io_start     (unsignedDivider_1_io_start          ), //i
    .io_dividend  (unsignedDivider_1_io_dividend[31:0] ), //i
    .io_divisor   (io_operandB_0[31:0]                 ), //i
    .io_done      (unsignedDivider_1_io_done           ), //o
    .io_busy      (unsignedDivider_1_io_busy           ), //o
    .io_quotient  (unsignedDivider_1_io_quotient[31:0] ), //o
    .io_remainder (unsignedDivider_1_io_remainder[31:0]), //o
    .clk          (clk                                 ), //i
    .reset        (reset                               )  //i
  );
  Fp32Unit fp32Unit_1 (
    .io_fire   (fp32Unit_1_io_fire        ), //i
    .io_mode   (io_slots_0_opcode[4:0]    ), //i
    .io_a      (io_operandA_0[31:0]       ), //i
    .io_b      (io_operandB_0[31:0]       ), //i
    .io_tagIn  (io_slots_0_dest[10:0]     ), //i
    .io_busy   (fp32Unit_1_io_busy        ), //o
    .io_done   (fp32Unit_1_io_done        ), //o
    .io_result (fp32Unit_1_io_result[31:0]), //o
    .io_tagOut (fp32Unit_1_io_tagOut[10:0]), //o
    .clk       (clk                       ), //i
    .reset     (reset                     )  //i
  );
  assign _zz_io_writeReqs_0_valid = (io_slots_0_valid && io_valid);
  assign _zz_io_writeReqs_0_valid_1 = (((io_slots_0_opcode == 5'h0a) || (io_slots_0_opcode == 5'h0b)) || (io_slots_0_opcode == 5'h0c));
  assign _zz_io_writeReqs_0_valid_2 = (((((((((io_slots_0_opcode == 5'h12) || (io_slots_0_opcode == 5'h13)) || (io_slots_0_opcode == 5'h14)) || (io_slots_0_opcode == 5'h15)) || (io_slots_0_opcode == 5'h16)) || (io_slots_0_opcode == 5'h17)) || (io_slots_0_opcode == 5'h18)) || (io_slots_0_opcode == 5'h19)) || (io_slots_0_opcode == 5'h1a));
  assign fp32Unit_1_io_fire = ((_zz_io_writeReqs_0_valid && _zz_io_writeReqs_0_valid_2) && (! fp32Unit_1_io_busy));
  assign unsignedDivider_1_io_start = ((_zz_io_writeReqs_0_valid && _zz_io_writeReqs_0_valid_1) && (! unsignedDivider_1_io_busy));
  assign unsignedDivider_1_io_dividend = ((io_slots_0_opcode == 5'h0c) ? _zz_io_dividend : io_operandA_0);
  assign when_AluEngine_l78 = (io_slots_0_opcode == 5'h0a);
  assign when_AluEngine_l80 = (io_slots_0_opcode == 5'h0b);
  always @(*) begin
    _zz_io_writeReqs_0_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      5'h0 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 + io_operandB_0);
      end
      5'h01 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 - io_operandB_0);
      end
      5'h02 : begin
        _zz_io_writeReqs_0_payload_data_1 = _zz__zz_io_writeReqs_0_payload_data_1[31:0];
      end
      5'h03 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 ^ io_operandB_0);
      end
      5'h04 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 & io_operandB_0);
      end
      5'h05 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 | io_operandB_0);
      end
      5'h06 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 <<< io_operandB_0[4 : 0]);
      end
      5'h07 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 >>> io_operandB_0[4 : 0]);
      end
      5'h08 : begin
        _zz_io_writeReqs_0_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_payload_data_1_1};
      end
      5'h09 : begin
        _zz_io_writeReqs_0_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_payload_data_1_2};
      end
      5'h0d : begin
        _zz_io_writeReqs_0_payload_data_1 = ((io_operandB_0 <= io_operandA_0) ? io_operandA_0 : io_operandB_0);
      end
      5'h0e : begin
        _zz_io_writeReqs_0_payload_data_1 = ((io_operandA_0 <= io_operandB_0) ? io_operandA_0 : io_operandB_0);
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_valid = ((unsignedDivider_1_io_done || fp32Unit_1_io_done) || ((_zz_io_writeReqs_0_valid && (! _zz_io_writeReqs_0_valid_1)) && (! _zz_io_writeReqs_0_valid_2)));
  assign io_writeReqs_0_payload_addr = (unsignedDivider_1_io_done ? _zz_io_writeReqs_0_payload_addr : (fp32Unit_1_io_done ? fp32Unit_1_io_tagOut : io_slots_0_dest));
  assign io_writeReqs_0_payload_data = (unsignedDivider_1_io_done ? ((_zz_io_writeReqs_0_payload_data == 2'b00) ? unsignedDivider_1_io_remainder : unsignedDivider_1_io_quotient) : (fp32Unit_1_io_done ? fp32Unit_1_io_result : _zz_io_writeReqs_0_payload_data_1));
  always @(posedge clk) begin
    if(reset) begin
      _zz_io_writeReqs_0_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_payload_data <= 2'b00;
    end else begin
      if(unsignedDivider_1_io_start) begin
        _zz_io_writeReqs_0_payload_addr <= io_slots_0_dest;
        if(when_AluEngine_l78) begin
          _zz_io_writeReqs_0_payload_data <= 2'b00;
        end else begin
          if(when_AluEngine_l80) begin
            _zz_io_writeReqs_0_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_payload_data <= 2'b10;
          end
        end
      end
    end
  end


endmodule

module Fp32Unit (
  input  wire          io_fire,
  input  wire [4:0]    io_mode,
  input  wire [31:0]   io_a,
  input  wire [31:0]   io_b,
  input  wire [10:0]   io_tagIn,
  output wire          io_busy,
  output wire          io_done,
  output wire [31:0]   io_result,
  output wire [10:0]   io_tagOut,
  input  wire          clk,
  input  wire          reset
);

  wire       [4:0]    _zz__zz_decA_exp_2;
  wire       [23:0]   _zz_decA_sig_1;
  wire       [9:0]    _zz_decA_exp_3;
  wire       [5:0]    _zz_decA_exp_4;
  wire       [9:0]    _zz_decA_exp_5;
  wire       [9:0]    _zz_decA_exp_6;
  wire       [4:0]    _zz__zz_decB_exp_2;
  wire       [23:0]   _zz_decB_sig_1;
  wire       [9:0]    _zz_decB_exp_3;
  wire       [5:0]    _zz_decB_exp_4;
  wire       [9:0]    _zz_decB_exp_5;
  wire       [9:0]    _zz_decB_exp_6;
  wire       [9:0]    _zz_expDiff;
  wire       [26:0]   _zz_bigExt;
  wire       [26:0]   _zz_smallExtBase;
  wire       [26:0]   _zz_smallExt;
  wire       [25:0]   _zz_smallExt_1;
  wire       [26:0]   _zz_smallExt_2;
  wire       [0:0]    _zz_smallExt_3;
  wire       [26:0]   _zz_smallExt_4;
  wire       [24:0]   _zz_smallExt_5;
  wire       [26:0]   _zz_smallExt_6;
  wire       [0:0]    _zz_smallExt_7;
  wire       [26:0]   _zz_smallExt_8;
  wire       [23:0]   _zz_smallExt_9;
  wire       [26:0]   _zz_smallExt_10;
  wire       [0:0]    _zz_smallExt_11;
  wire       [26:0]   _zz_smallExt_12;
  wire       [22:0]   _zz_smallExt_13;
  wire       [26:0]   _zz_smallExt_14;
  wire       [0:0]    _zz_smallExt_15;
  wire       [26:0]   _zz_smallExt_16;
  wire       [21:0]   _zz_smallExt_17;
  wire       [26:0]   _zz_smallExt_18;
  wire       [0:0]    _zz_smallExt_19;
  wire       [26:0]   _zz_smallExt_20;
  wire       [20:0]   _zz_smallExt_21;
  wire       [26:0]   _zz_smallExt_22;
  wire       [0:0]    _zz_smallExt_23;
  wire       [26:0]   _zz_smallExt_24;
  wire       [19:0]   _zz_smallExt_25;
  wire       [26:0]   _zz_smallExt_26;
  wire       [0:0]    _zz_smallExt_27;
  wire       [26:0]   _zz_smallExt_28;
  wire       [18:0]   _zz_smallExt_29;
  wire       [26:0]   _zz_smallExt_30;
  wire       [0:0]    _zz_smallExt_31;
  wire       [26:0]   _zz_smallExt_32;
  wire       [17:0]   _zz_smallExt_33;
  wire       [26:0]   _zz_smallExt_34;
  wire       [0:0]    _zz_smallExt_35;
  wire       [26:0]   _zz_smallExt_36;
  wire       [16:0]   _zz_smallExt_37;
  wire       [26:0]   _zz_smallExt_38;
  wire       [0:0]    _zz_smallExt_39;
  wire       [26:0]   _zz_smallExt_40;
  wire       [15:0]   _zz_smallExt_41;
  wire       [26:0]   _zz_smallExt_42;
  wire       [0:0]    _zz_smallExt_43;
  wire       [26:0]   _zz_smallExt_44;
  wire       [14:0]   _zz_smallExt_45;
  wire       [26:0]   _zz_smallExt_46;
  wire       [0:0]    _zz_smallExt_47;
  wire       [26:0]   _zz_smallExt_48;
  wire       [13:0]   _zz_smallExt_49;
  wire       [26:0]   _zz_smallExt_50;
  wire       [0:0]    _zz_smallExt_51;
  wire       [26:0]   _zz_smallExt_52;
  wire       [12:0]   _zz_smallExt_53;
  wire       [26:0]   _zz_smallExt_54;
  wire       [0:0]    _zz_smallExt_55;
  wire       [26:0]   _zz_smallExt_56;
  wire       [11:0]   _zz_smallExt_57;
  wire       [26:0]   _zz_smallExt_58;
  wire       [0:0]    _zz_smallExt_59;
  wire       [26:0]   _zz_smallExt_60;
  wire       [10:0]   _zz_smallExt_61;
  wire       [26:0]   _zz_smallExt_62;
  wire       [0:0]    _zz_smallExt_63;
  wire       [26:0]   _zz_smallExt_64;
  wire       [9:0]    _zz_smallExt_65;
  wire       [26:0]   _zz_smallExt_66;
  wire       [0:0]    _zz_smallExt_67;
  wire       [26:0]   _zz_smallExt_68;
  wire       [8:0]    _zz_smallExt_69;
  wire       [26:0]   _zz_smallExt_70;
  wire       [0:0]    _zz_smallExt_71;
  wire       [26:0]   _zz_smallExt_72;
  wire       [7:0]    _zz_smallExt_73;
  wire       [26:0]   _zz_smallExt_74;
  wire       [0:0]    _zz_smallExt_75;
  wire       [26:0]   _zz_smallExt_76;
  wire       [6:0]    _zz_smallExt_77;
  wire       [26:0]   _zz_smallExt_78;
  wire       [0:0]    _zz_smallExt_79;
  wire       [26:0]   _zz_smallExt_80;
  wire       [5:0]    _zz_smallExt_81;
  wire       [26:0]   _zz_smallExt_82;
  wire       [0:0]    _zz_smallExt_83;
  wire       [26:0]   _zz_smallExt_84;
  wire       [4:0]    _zz_smallExt_85;
  wire       [26:0]   _zz_smallExt_86;
  wire       [0:0]    _zz_smallExt_87;
  wire       [26:0]   _zz_smallExt_88;
  wire       [3:0]    _zz_smallExt_89;
  wire       [26:0]   _zz_smallExt_90;
  wire       [0:0]    _zz_smallExt_91;
  wire       [26:0]   _zz_smallExt_92;
  wire       [2:0]    _zz_smallExt_93;
  wire       [26:0]   _zz_smallExt_94;
  wire       [0:0]    _zz_smallExt_95;
  wire       [26:0]   _zz_smallExt_96;
  wire       [1:0]    _zz_smallExt_97;
  wire       [26:0]   _zz_smallExt_98;
  wire       [0:0]    _zz_smallExt_99;
  wire       [26:0]   _zz_smallExt_100;
  wire       [0:0]    _zz_smallExt_101;
  wire       [26:0]   _zz_smallExt_102;
  wire       [0:0]    _zz_smallExt_103;
  wire       [0:0]    _zz_smallExt_104;
  wire       [0:0]    _zz_smallExt_105;
  wire       [0:0]    _zz_smallExt_106;
  wire       [0:0]    _zz_smallExt_107;
  wire       [0:0]    _zz_smallExt_108;
  wire       [0:0]    _zz_smallExt_109;
  wire       [27:0]   _zz__zz_addFiniteSig;
  wire       [27:0]   _zz__zz_addFiniteSig_1;
  wire       [26:0]   _zz_addFiniteSig_2;
  wire       [0:0]    _zz_addFiniteSig_3;
  wire       [4:0]    _zz__zz_addFiniteExp_1;
  wire       [9:0]    _zz_addFiniteExp_2;
  wire       [5:0]    _zz_addFiniteExp_3;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l67;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1;
  wire       [25:0]   _zz__zz_when_Fp32Unit_l148_1_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_2;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_3;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_4;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_1_5;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_6;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_7;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_8;
  wire       [23:0]   _zz__zz_when_Fp32Unit_l148_1_9;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_10;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_11;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_12;
  wire       [22:0]   _zz__zz_when_Fp32Unit_l148_1_13;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_14;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_15;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_16;
  wire       [21:0]   _zz__zz_when_Fp32Unit_l148_1_17;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_18;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_19;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_20;
  wire       [20:0]   _zz__zz_when_Fp32Unit_l148_1_21;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_22;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_23;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_24;
  wire       [19:0]   _zz__zz_when_Fp32Unit_l148_1_25;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_26;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_27;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_28;
  wire       [18:0]   _zz__zz_when_Fp32Unit_l148_1_29;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_30;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_31;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_32;
  wire       [17:0]   _zz__zz_when_Fp32Unit_l148_1_33;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_34;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_35;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_36;
  wire       [16:0]   _zz__zz_when_Fp32Unit_l148_1_37;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_38;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_39;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_40;
  wire       [15:0]   _zz__zz_when_Fp32Unit_l148_1_41;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_42;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_43;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_44;
  wire       [14:0]   _zz__zz_when_Fp32Unit_l148_1_45;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_46;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_47;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_48;
  wire       [13:0]   _zz__zz_when_Fp32Unit_l148_1_49;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_50;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_51;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_52;
  wire       [12:0]   _zz__zz_when_Fp32Unit_l148_1_53;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_54;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_55;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_56;
  wire       [11:0]   _zz__zz_when_Fp32Unit_l148_1_57;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_58;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_59;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_60;
  wire       [10:0]   _zz__zz_when_Fp32Unit_l148_1_61;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_62;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_63;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_64;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l148_1_65;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_66;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_67;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_68;
  wire       [8:0]    _zz__zz_when_Fp32Unit_l148_1_69;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_70;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_71;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_72;
  wire       [7:0]    _zz__zz_when_Fp32Unit_l148_1_73;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_74;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_75;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_76;
  wire       [6:0]    _zz__zz_when_Fp32Unit_l148_1_77;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_78;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_79;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_80;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_1_81;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_82;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_83;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_84;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_1_85;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_86;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_87;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_88;
  wire       [3:0]    _zz__zz_when_Fp32Unit_l148_1_89;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_90;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_91;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_92;
  wire       [2:0]    _zz__zz_when_Fp32Unit_l148_1_93;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_94;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_95;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_96;
  wire       [1:0]    _zz__zz_when_Fp32Unit_l148_1_97;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_98;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_99;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_100;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_101;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_1_102;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_103;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_104;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_105;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_106;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_107;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_108;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_1_109;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_3;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_3_1;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_3_2;
  wire       [9:0]    _zz__zz_addResult_1;
  wire       [9:0]    _zz__zz_addResult_1_1;
  wire       [95:0]   _zz__zz_when_Fp32Unit_l328;
  wire       [47:0]   _zz__zz_when_Fp32Unit_l328_1;
  wire       [47:0]   _zz__zz_when_Fp32Unit_l328_2;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l124;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_4;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_4_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_4_2;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_4_3;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l67_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6;
  wire       [25:0]   _zz__zz_when_Fp32Unit_l148_6_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_2;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_3;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_4;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_6_5;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_6;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_7;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_8;
  wire       [23:0]   _zz__zz_when_Fp32Unit_l148_6_9;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_10;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_11;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_12;
  wire       [22:0]   _zz__zz_when_Fp32Unit_l148_6_13;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_14;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_15;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_16;
  wire       [21:0]   _zz__zz_when_Fp32Unit_l148_6_17;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_18;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_19;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_20;
  wire       [20:0]   _zz__zz_when_Fp32Unit_l148_6_21;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_22;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_23;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_24;
  wire       [19:0]   _zz__zz_when_Fp32Unit_l148_6_25;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_26;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_27;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_28;
  wire       [18:0]   _zz__zz_when_Fp32Unit_l148_6_29;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_30;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_31;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_32;
  wire       [17:0]   _zz__zz_when_Fp32Unit_l148_6_33;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_34;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_35;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_36;
  wire       [16:0]   _zz__zz_when_Fp32Unit_l148_6_37;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_38;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_39;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_40;
  wire       [15:0]   _zz__zz_when_Fp32Unit_l148_6_41;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_42;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_43;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_44;
  wire       [14:0]   _zz__zz_when_Fp32Unit_l148_6_45;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_46;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_47;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_48;
  wire       [13:0]   _zz__zz_when_Fp32Unit_l148_6_49;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_50;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_51;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_52;
  wire       [12:0]   _zz__zz_when_Fp32Unit_l148_6_53;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_54;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_55;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_56;
  wire       [11:0]   _zz__zz_when_Fp32Unit_l148_6_57;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_58;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_59;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_60;
  wire       [10:0]   _zz__zz_when_Fp32Unit_l148_6_61;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_62;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_63;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_64;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l148_6_65;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_66;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_67;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_68;
  wire       [8:0]    _zz__zz_when_Fp32Unit_l148_6_69;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_70;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_71;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_72;
  wire       [7:0]    _zz__zz_when_Fp32Unit_l148_6_73;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_74;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_75;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_76;
  wire       [6:0]    _zz__zz_when_Fp32Unit_l148_6_77;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_78;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_79;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_80;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_6_81;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_82;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_83;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_84;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_6_85;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_86;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_87;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_88;
  wire       [3:0]    _zz__zz_when_Fp32Unit_l148_6_89;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_90;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_91;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_92;
  wire       [2:0]    _zz__zz_when_Fp32Unit_l148_6_93;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_94;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_95;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_96;
  wire       [1:0]    _zz__zz_when_Fp32Unit_l148_6_97;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_98;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_99;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_100;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_101;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_6_102;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_103;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_104;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_105;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_106;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_107;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_108;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_6_109;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_8;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_8_1;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_8_2;
  wire       [9:0]    _zz__zz_mulResult_1;
  wire       [9:0]    _zz__zz_mulResult_1_1;
  wire       [31:0]   _zz_iMag;
  wire       [31:0]   _zz_iMag_1;
  wire       [34:0]   _zz__zz_when_Fp32Unit_l148_9;
  wire       [34:0]   _zz__zz_when_Fp32Unit_l148_10;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_10_1;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_10_2;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l67_2;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11;
  wire       [33:0]   _zz__zz_when_Fp32Unit_l148_11_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_2;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_3;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_4;
  wire       [32:0]   _zz__zz_when_Fp32Unit_l148_11_5;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_6;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_7;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_8;
  wire       [31:0]   _zz__zz_when_Fp32Unit_l148_11_9;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_10;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_11;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_12;
  wire       [30:0]   _zz__zz_when_Fp32Unit_l148_11_13;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_14;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_15;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_16;
  wire       [29:0]   _zz__zz_when_Fp32Unit_l148_11_17;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_18;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_19;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_20;
  wire       [28:0]   _zz__zz_when_Fp32Unit_l148_11_21;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_22;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_23;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_24;
  wire       [27:0]   _zz__zz_when_Fp32Unit_l148_11_25;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_26;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_27;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_28;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_29;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_30;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_31;
  wire       [25:0]   _zz__zz_when_Fp32Unit_l148_11_32;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_33;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_34;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_35;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_11_36;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_37;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_38;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_39;
  wire       [23:0]   _zz__zz_when_Fp32Unit_l148_11_40;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_41;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_42;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_43;
  wire       [22:0]   _zz__zz_when_Fp32Unit_l148_11_44;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_45;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_46;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_47;
  wire       [21:0]   _zz__zz_when_Fp32Unit_l148_11_48;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_49;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_50;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_51;
  wire       [20:0]   _zz__zz_when_Fp32Unit_l148_11_52;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_53;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_54;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_55;
  wire       [19:0]   _zz__zz_when_Fp32Unit_l148_11_56;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_57;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_58;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_59;
  wire       [18:0]   _zz__zz_when_Fp32Unit_l148_11_60;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_61;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_62;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_63;
  wire       [17:0]   _zz__zz_when_Fp32Unit_l148_11_64;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_65;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_66;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_67;
  wire       [16:0]   _zz__zz_when_Fp32Unit_l148_11_68;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_69;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_70;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_71;
  wire       [15:0]   _zz__zz_when_Fp32Unit_l148_11_72;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_73;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_74;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_75;
  wire       [14:0]   _zz__zz_when_Fp32Unit_l148_11_76;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_77;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_78;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_79;
  wire       [13:0]   _zz__zz_when_Fp32Unit_l148_11_80;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_81;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_82;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_83;
  wire       [12:0]   _zz__zz_when_Fp32Unit_l148_11_84;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_85;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_86;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_87;
  wire       [11:0]   _zz__zz_when_Fp32Unit_l148_11_88;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_89;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_90;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_91;
  wire       [10:0]   _zz__zz_when_Fp32Unit_l148_11_92;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_93;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_94;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_95;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l148_11_96;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_97;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_98;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_99;
  wire       [8:0]    _zz__zz_when_Fp32Unit_l148_11_100;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_101;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_102;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_103;
  wire       [7:0]    _zz__zz_when_Fp32Unit_l148_11_104;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_105;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_106;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_107;
  wire       [6:0]    _zz__zz_when_Fp32Unit_l148_11_108;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_109;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_110;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_111;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_11_112;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_113;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_114;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_115;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_11_116;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_117;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_118;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_119;
  wire       [3:0]    _zz__zz_when_Fp32Unit_l148_11_120;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_121;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_122;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_123;
  wire       [2:0]    _zz__zz_when_Fp32Unit_l148_11_124;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_125;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_126;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_127;
  wire       [1:0]    _zz__zz_when_Fp32Unit_l148_11_128;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_129;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_130;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_131;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_132;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_11_133;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_134;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_11_135;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l124_1;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l67_3;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13;
  wire       [25:0]   _zz__zz_when_Fp32Unit_l148_13_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_2;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_3;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_4;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_13_5;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_6;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_7;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_8;
  wire       [23:0]   _zz__zz_when_Fp32Unit_l148_13_9;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_10;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_11;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_12;
  wire       [22:0]   _zz__zz_when_Fp32Unit_l148_13_13;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_14;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_15;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_16;
  wire       [21:0]   _zz__zz_when_Fp32Unit_l148_13_17;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_18;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_19;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_20;
  wire       [20:0]   _zz__zz_when_Fp32Unit_l148_13_21;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_22;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_23;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_24;
  wire       [19:0]   _zz__zz_when_Fp32Unit_l148_13_25;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_26;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_27;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_28;
  wire       [18:0]   _zz__zz_when_Fp32Unit_l148_13_29;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_30;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_31;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_32;
  wire       [17:0]   _zz__zz_when_Fp32Unit_l148_13_33;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_34;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_35;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_36;
  wire       [16:0]   _zz__zz_when_Fp32Unit_l148_13_37;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_38;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_39;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_40;
  wire       [15:0]   _zz__zz_when_Fp32Unit_l148_13_41;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_42;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_43;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_44;
  wire       [14:0]   _zz__zz_when_Fp32Unit_l148_13_45;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_46;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_47;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_48;
  wire       [13:0]   _zz__zz_when_Fp32Unit_l148_13_49;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_50;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_51;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_52;
  wire       [12:0]   _zz__zz_when_Fp32Unit_l148_13_53;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_54;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_55;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_56;
  wire       [11:0]   _zz__zz_when_Fp32Unit_l148_13_57;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_58;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_59;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_60;
  wire       [10:0]   _zz__zz_when_Fp32Unit_l148_13_61;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_62;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_63;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_64;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l148_13_65;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_66;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_67;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_68;
  wire       [8:0]    _zz__zz_when_Fp32Unit_l148_13_69;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_70;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_71;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_72;
  wire       [7:0]    _zz__zz_when_Fp32Unit_l148_13_73;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_74;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_75;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_76;
  wire       [6:0]    _zz__zz_when_Fp32Unit_l148_13_77;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_78;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_79;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_80;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_13_81;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_82;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_83;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_84;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_13_85;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_86;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_87;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_88;
  wire       [3:0]    _zz__zz_when_Fp32Unit_l148_13_89;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_90;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_91;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_92;
  wire       [2:0]    _zz__zz_when_Fp32Unit_l148_13_93;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_94;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_95;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_96;
  wire       [1:0]    _zz__zz_when_Fp32Unit_l148_13_97;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_98;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_99;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_100;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_101;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_13_102;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_103;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_104;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_105;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_106;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_107;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_108;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_13_109;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_15;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_15_1;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_15_2;
  wire       [9:0]    _zz__zz_i2fResult_2;
  wire       [9:0]    _zz__zz_i2fResult_2_1;
  wire       [34:0]   _zz__zz_when_Fp32Unit_l148_16;
  wire       [34:0]   _zz__zz_when_Fp32Unit_l148_17;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_17_1;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_17_2;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l67_4;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18;
  wire       [33:0]   _zz__zz_when_Fp32Unit_l148_18_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_2;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_3;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_4;
  wire       [32:0]   _zz__zz_when_Fp32Unit_l148_18_5;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_6;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_7;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_8;
  wire       [31:0]   _zz__zz_when_Fp32Unit_l148_18_9;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_10;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_11;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_12;
  wire       [30:0]   _zz__zz_when_Fp32Unit_l148_18_13;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_14;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_15;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_16;
  wire       [29:0]   _zz__zz_when_Fp32Unit_l148_18_17;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_18;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_19;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_20;
  wire       [28:0]   _zz__zz_when_Fp32Unit_l148_18_21;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_22;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_23;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_24;
  wire       [27:0]   _zz__zz_when_Fp32Unit_l148_18_25;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_26;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_27;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_28;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_29;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_30;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_31;
  wire       [25:0]   _zz__zz_when_Fp32Unit_l148_18_32;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_33;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_34;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_35;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_18_36;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_37;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_38;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_39;
  wire       [23:0]   _zz__zz_when_Fp32Unit_l148_18_40;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_41;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_42;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_43;
  wire       [22:0]   _zz__zz_when_Fp32Unit_l148_18_44;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_45;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_46;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_47;
  wire       [21:0]   _zz__zz_when_Fp32Unit_l148_18_48;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_49;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_50;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_51;
  wire       [20:0]   _zz__zz_when_Fp32Unit_l148_18_52;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_53;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_54;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_55;
  wire       [19:0]   _zz__zz_when_Fp32Unit_l148_18_56;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_57;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_58;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_59;
  wire       [18:0]   _zz__zz_when_Fp32Unit_l148_18_60;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_61;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_62;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_63;
  wire       [17:0]   _zz__zz_when_Fp32Unit_l148_18_64;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_65;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_66;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_67;
  wire       [16:0]   _zz__zz_when_Fp32Unit_l148_18_68;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_69;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_70;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_71;
  wire       [15:0]   _zz__zz_when_Fp32Unit_l148_18_72;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_73;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_74;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_75;
  wire       [14:0]   _zz__zz_when_Fp32Unit_l148_18_76;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_77;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_78;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_79;
  wire       [13:0]   _zz__zz_when_Fp32Unit_l148_18_80;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_81;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_82;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_83;
  wire       [12:0]   _zz__zz_when_Fp32Unit_l148_18_84;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_85;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_86;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_87;
  wire       [11:0]   _zz__zz_when_Fp32Unit_l148_18_88;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_89;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_90;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_91;
  wire       [10:0]   _zz__zz_when_Fp32Unit_l148_18_92;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_93;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_94;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_95;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l148_18_96;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_97;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_98;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_99;
  wire       [8:0]    _zz__zz_when_Fp32Unit_l148_18_100;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_101;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_102;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_103;
  wire       [7:0]    _zz__zz_when_Fp32Unit_l148_18_104;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_105;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_106;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_107;
  wire       [6:0]    _zz__zz_when_Fp32Unit_l148_18_108;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_109;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_110;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_111;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_18_112;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_113;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_114;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_115;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_18_116;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_117;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_118;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_119;
  wire       [3:0]    _zz__zz_when_Fp32Unit_l148_18_120;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_121;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_122;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_123;
  wire       [2:0]    _zz__zz_when_Fp32Unit_l148_18_124;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_125;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_126;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_127;
  wire       [1:0]    _zz__zz_when_Fp32Unit_l148_18_128;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_129;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_130;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_131;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_132;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_18_133;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_134;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_18_135;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l124_2;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l67_5;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20;
  wire       [25:0]   _zz__zz_when_Fp32Unit_l148_20_1;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_2;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_3;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_4;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_20_5;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_6;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_7;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_8;
  wire       [23:0]   _zz__zz_when_Fp32Unit_l148_20_9;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_10;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_11;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_12;
  wire       [22:0]   _zz__zz_when_Fp32Unit_l148_20_13;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_14;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_15;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_16;
  wire       [21:0]   _zz__zz_when_Fp32Unit_l148_20_17;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_18;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_19;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_20;
  wire       [20:0]   _zz__zz_when_Fp32Unit_l148_20_21;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_22;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_23;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_24;
  wire       [19:0]   _zz__zz_when_Fp32Unit_l148_20_25;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_26;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_27;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_28;
  wire       [18:0]   _zz__zz_when_Fp32Unit_l148_20_29;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_30;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_31;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_32;
  wire       [17:0]   _zz__zz_when_Fp32Unit_l148_20_33;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_34;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_35;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_36;
  wire       [16:0]   _zz__zz_when_Fp32Unit_l148_20_37;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_38;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_39;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_40;
  wire       [15:0]   _zz__zz_when_Fp32Unit_l148_20_41;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_42;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_43;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_44;
  wire       [14:0]   _zz__zz_when_Fp32Unit_l148_20_45;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_46;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_47;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_48;
  wire       [13:0]   _zz__zz_when_Fp32Unit_l148_20_49;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_50;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_51;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_52;
  wire       [12:0]   _zz__zz_when_Fp32Unit_l148_20_53;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_54;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_55;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_56;
  wire       [11:0]   _zz__zz_when_Fp32Unit_l148_20_57;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_58;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_59;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_60;
  wire       [10:0]   _zz__zz_when_Fp32Unit_l148_20_61;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_62;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_63;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_64;
  wire       [9:0]    _zz__zz_when_Fp32Unit_l148_20_65;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_66;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_67;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_68;
  wire       [8:0]    _zz__zz_when_Fp32Unit_l148_20_69;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_70;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_71;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_72;
  wire       [7:0]    _zz__zz_when_Fp32Unit_l148_20_73;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_74;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_75;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_76;
  wire       [6:0]    _zz__zz_when_Fp32Unit_l148_20_77;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_78;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_79;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_80;
  wire       [5:0]    _zz__zz_when_Fp32Unit_l148_20_81;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_82;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_83;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_84;
  wire       [4:0]    _zz__zz_when_Fp32Unit_l148_20_85;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_86;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_87;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_88;
  wire       [3:0]    _zz__zz_when_Fp32Unit_l148_20_89;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_90;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_91;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_92;
  wire       [2:0]    _zz__zz_when_Fp32Unit_l148_20_93;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_94;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_95;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_96;
  wire       [1:0]    _zz__zz_when_Fp32Unit_l148_20_97;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_98;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_99;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_100;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_101;
  wire       [26:0]   _zz__zz_when_Fp32Unit_l148_20_102;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_103;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_104;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_105;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_106;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_107;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_108;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_20_109;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_22;
  wire       [24:0]   _zz__zz_when_Fp32Unit_l148_22_1;
  wire       [0:0]    _zz__zz_when_Fp32Unit_l148_22_2;
  wire       [9:0]    _zz__zz_u2fResult_2;
  wire       [9:0]    _zz__zz_u2fResult_2_1;
  wire       [32:0]   _zz_intMagnitude;
  wire       [5:0]    _zz_intMagnitude_1;
  wire       [9:0]    _zz_intMagnitude_2;
  wire       [9:0]    _zz_intMagnitude_3;
  wire       [23:0]   _zz_intMagnitude_4;
  wire       [5:0]    _zz_intMagnitude_5;
  wire       [9:0]    _zz_intMagnitude_6;
  wire       [9:0]    _zz_intMagnitude_7;
  wire       [31:0]   _zz_f2iResult;
  wire       [33:0]   _zz_f2iResult_1;
  wire       [33:0]   _zz_f2iResult_2;
  wire       [32:0]   _zz_f2iResult_3;
  wire                decA_sign;
  reg        [9:0]    decA_exp;
  reg        [23:0]   decA_sig;
  wire                decA_isZero;
  wire                decA_isInf;
  wire                decA_isNaN;
  wire       [7:0]    _zz_decA_exp;
  wire       [22:0]   _zz_decA_sig;
  wire                when_Fp32Unit_l102;
  wire                when_Fp32Unit_l103;
  reg        [4:0]    _zz_decA_exp_1;
  wire                when_Fp32Unit_l56;
  wire                when_Fp32Unit_l56_1;
  wire                when_Fp32Unit_l56_2;
  wire                when_Fp32Unit_l56_3;
  wire                when_Fp32Unit_l56_4;
  wire                when_Fp32Unit_l56_5;
  wire                when_Fp32Unit_l56_6;
  wire                when_Fp32Unit_l56_7;
  wire                when_Fp32Unit_l56_8;
  wire                when_Fp32Unit_l56_9;
  wire                when_Fp32Unit_l56_10;
  wire                when_Fp32Unit_l56_11;
  wire                when_Fp32Unit_l56_12;
  wire                when_Fp32Unit_l56_13;
  wire                when_Fp32Unit_l56_14;
  wire                when_Fp32Unit_l56_15;
  wire                when_Fp32Unit_l56_16;
  wire                when_Fp32Unit_l56_17;
  wire                when_Fp32Unit_l56_18;
  wire                when_Fp32Unit_l56_19;
  wire                when_Fp32Unit_l56_20;
  wire                when_Fp32Unit_l56_21;
  wire                when_Fp32Unit_l56_22;
  wire       [5:0]    _zz_decA_exp_2;
  wire                when_Fp32Unit_l109;
  wire                decB_sign;
  reg        [9:0]    decB_exp;
  reg        [23:0]   decB_sig;
  wire                decB_isZero;
  wire                decB_isInf;
  wire                decB_isNaN;
  wire       [7:0]    _zz_decB_exp;
  wire       [22:0]   _zz_decB_sig;
  wire                when_Fp32Unit_l102_1;
  wire                when_Fp32Unit_l103_1;
  reg        [4:0]    _zz_decB_exp_1;
  wire                when_Fp32Unit_l56_23;
  wire                when_Fp32Unit_l56_24;
  wire                when_Fp32Unit_l56_25;
  wire                when_Fp32Unit_l56_26;
  wire                when_Fp32Unit_l56_27;
  wire                when_Fp32Unit_l56_28;
  wire                when_Fp32Unit_l56_29;
  wire                when_Fp32Unit_l56_30;
  wire                when_Fp32Unit_l56_31;
  wire                when_Fp32Unit_l56_32;
  wire                when_Fp32Unit_l56_33;
  wire                when_Fp32Unit_l56_34;
  wire                when_Fp32Unit_l56_35;
  wire                when_Fp32Unit_l56_36;
  wire                when_Fp32Unit_l56_37;
  wire                when_Fp32Unit_l56_38;
  wire                when_Fp32Unit_l56_39;
  wire                when_Fp32Unit_l56_40;
  wire                when_Fp32Unit_l56_41;
  wire                when_Fp32Unit_l56_42;
  wire                when_Fp32Unit_l56_43;
  wire                when_Fp32Unit_l56_44;
  wire                when_Fp32Unit_l56_45;
  wire       [5:0]    _zz_decB_exp_2;
  wire                when_Fp32Unit_l109_1;
  wire                effBSign;
  wire                sameSignAdd;
  wire                aMagGreater;
  reg        [9:0]    bigExp;
  wire                when_Fp32Unit_l232;
  reg        [9:0]    smallExp;
  wire                when_Fp32Unit_l238;
  reg        [23:0]   bigSig;
  wire                when_Fp32Unit_l244;
  reg        [23:0]   smallSig;
  wire                when_Fp32Unit_l250;
  reg                 bigSign;
  wire                when_Fp32Unit_l256;
  wire       [9:0]    expDiff;
  wire       [26:0]   bigExt;
  wire       [26:0]   smallExtBase;
  reg        [26:0]   smallExt;
  wire                when_Fp32Unit_l67;
  wire                when_Fp32Unit_l72;
  wire                when_Fp32Unit_l72_1;
  wire                when_Fp32Unit_l72_2;
  wire                when_Fp32Unit_l72_3;
  wire                when_Fp32Unit_l72_4;
  wire                when_Fp32Unit_l72_5;
  wire                when_Fp32Unit_l72_6;
  wire                when_Fp32Unit_l72_7;
  wire                when_Fp32Unit_l72_8;
  wire                when_Fp32Unit_l72_9;
  wire                when_Fp32Unit_l72_10;
  wire                when_Fp32Unit_l72_11;
  wire                when_Fp32Unit_l72_12;
  wire                when_Fp32Unit_l72_13;
  wire                when_Fp32Unit_l72_14;
  wire                when_Fp32Unit_l72_15;
  wire                when_Fp32Unit_l72_16;
  wire                when_Fp32Unit_l72_17;
  wire                when_Fp32Unit_l72_18;
  wire                when_Fp32Unit_l72_19;
  wire                when_Fp32Unit_l72_20;
  wire                when_Fp32Unit_l72_21;
  wire                when_Fp32Unit_l72_22;
  wire                when_Fp32Unit_l72_23;
  wire                when_Fp32Unit_l72_24;
  wire                when_Fp32Unit_l72_25;
  wire                when_Fp32Unit_l72_26;
  wire                when_Fp32Unit_l72_27;
  wire                when_Fp32Unit_l72_28;
  wire                when_Fp32Unit_l72_29;
  wire                when_Fp32Unit_l72_30;
  wire                when_Fp32Unit_l83;
  reg                 addFiniteSign;
  reg        [9:0]    addFiniteExp;
  reg        [26:0]   addFiniteSig;
  wire       [27:0]   _zz_addFiniteSig;
  wire                when_Fp32Unit_l276;
  wire       [26:0]   _zz_addFiniteSig_1;
  wire                when_Fp32Unit_l285;
  reg        [4:0]    _zz_addFiniteExp;
  wire                when_Fp32Unit_l56_46;
  wire                when_Fp32Unit_l56_47;
  wire                when_Fp32Unit_l56_48;
  wire                when_Fp32Unit_l56_49;
  wire                when_Fp32Unit_l56_50;
  wire                when_Fp32Unit_l56_51;
  wire                when_Fp32Unit_l56_52;
  wire                when_Fp32Unit_l56_53;
  wire                when_Fp32Unit_l56_54;
  wire                when_Fp32Unit_l56_55;
  wire                when_Fp32Unit_l56_56;
  wire                when_Fp32Unit_l56_57;
  wire                when_Fp32Unit_l56_58;
  wire                when_Fp32Unit_l56_59;
  wire                when_Fp32Unit_l56_60;
  wire                when_Fp32Unit_l56_61;
  wire                when_Fp32Unit_l56_62;
  wire                when_Fp32Unit_l56_63;
  wire                when_Fp32Unit_l56_64;
  wire                when_Fp32Unit_l56_65;
  wire                when_Fp32Unit_l56_66;
  wire                when_Fp32Unit_l56_67;
  wire                when_Fp32Unit_l56_68;
  wire                when_Fp32Unit_l56_69;
  wire                when_Fp32Unit_l56_70;
  wire                when_Fp32Unit_l56_71;
  wire                when_Fp32Unit_l56_72;
  wire       [5:0]    _zz_addFiniteExp_1;
  reg        [31:0]   addResult;
  reg        [31:0]   _zz_addResult;
  wire                when_Fp32Unit_l124;
  reg        [9:0]    _zz_when_Fp32Unit_l67;
  reg        [26:0]   _zz_when_Fp32Unit_l148;
  reg        [26:0]   _zz_when_Fp32Unit_l148_1;
  wire                when_Fp32Unit_l67_1;
  wire                when_Fp32Unit_l72_31;
  wire                when_Fp32Unit_l72_32;
  wire                when_Fp32Unit_l72_33;
  wire                when_Fp32Unit_l72_34;
  wire                when_Fp32Unit_l72_35;
  wire                when_Fp32Unit_l72_36;
  wire                when_Fp32Unit_l72_37;
  wire                when_Fp32Unit_l72_38;
  wire                when_Fp32Unit_l72_39;
  wire                when_Fp32Unit_l72_40;
  wire                when_Fp32Unit_l72_41;
  wire                when_Fp32Unit_l72_42;
  wire                when_Fp32Unit_l72_43;
  wire                when_Fp32Unit_l72_44;
  wire                when_Fp32Unit_l72_45;
  wire                when_Fp32Unit_l72_46;
  wire                when_Fp32Unit_l72_47;
  wire                when_Fp32Unit_l72_48;
  wire                when_Fp32Unit_l72_49;
  wire                when_Fp32Unit_l72_50;
  wire                when_Fp32Unit_l72_51;
  wire                when_Fp32Unit_l72_52;
  wire                when_Fp32Unit_l72_53;
  wire                when_Fp32Unit_l72_54;
  wire                when_Fp32Unit_l72_55;
  wire                when_Fp32Unit_l72_56;
  wire                when_Fp32Unit_l72_57;
  wire                when_Fp32Unit_l72_58;
  wire                when_Fp32Unit_l72_59;
  wire                when_Fp32Unit_l72_60;
  wire                when_Fp32Unit_l72_61;
  wire                when_Fp32Unit_l83_1;
  reg        [9:0]    _zz_when_Fp32Unit_l161;
  wire       [23:0]   _zz_when_Fp32Unit_l148_2;
  wire       [24:0]   _zz_when_Fp32Unit_l148_3;
  reg        [23:0]   _zz_when_Fp32Unit_l153;
  reg        [9:0]    _zz_when_Fp32Unit_l161_1;
  wire                when_Fp32Unit_l148;
  wire                when_Fp32Unit_l153;
  reg        [7:0]    _zz_addResult_1;
  wire                when_Fp32Unit_l161;
  wire                when_Fp32Unit_l163;
  wire                when_Fp32Unit_l155;
  wire                when_Fp32Unit_l300;
  wire                when_Fp32Unit_l302;
  reg        [31:0]   mulResult;
  wire                mulSign;
  wire                when_Fp32Unit_l313;
  wire       [47:0]   _zz_when_Fp32Unit_l328;
  reg        [9:0]    _zz_when_Fp32Unit_l124;
  reg        [26:0]   _zz_when_Fp32Unit_l148_4;
  wire                when_Fp32Unit_l328;
  reg        [31:0]   _zz_mulResult;
  wire                when_Fp32Unit_l124_1;
  reg        [9:0]    _zz_when_Fp32Unit_l67_1;
  reg        [26:0]   _zz_when_Fp32Unit_l148_5;
  reg        [26:0]   _zz_when_Fp32Unit_l148_6;
  wire                when_Fp32Unit_l67_2;
  wire                when_Fp32Unit_l72_62;
  wire                when_Fp32Unit_l72_63;
  wire                when_Fp32Unit_l72_64;
  wire                when_Fp32Unit_l72_65;
  wire                when_Fp32Unit_l72_66;
  wire                when_Fp32Unit_l72_67;
  wire                when_Fp32Unit_l72_68;
  wire                when_Fp32Unit_l72_69;
  wire                when_Fp32Unit_l72_70;
  wire                when_Fp32Unit_l72_71;
  wire                when_Fp32Unit_l72_72;
  wire                when_Fp32Unit_l72_73;
  wire                when_Fp32Unit_l72_74;
  wire                when_Fp32Unit_l72_75;
  wire                when_Fp32Unit_l72_76;
  wire                when_Fp32Unit_l72_77;
  wire                when_Fp32Unit_l72_78;
  wire                when_Fp32Unit_l72_79;
  wire                when_Fp32Unit_l72_80;
  wire                when_Fp32Unit_l72_81;
  wire                when_Fp32Unit_l72_82;
  wire                when_Fp32Unit_l72_83;
  wire                when_Fp32Unit_l72_84;
  wire                when_Fp32Unit_l72_85;
  wire                when_Fp32Unit_l72_86;
  wire                when_Fp32Unit_l72_87;
  wire                when_Fp32Unit_l72_88;
  wire                when_Fp32Unit_l72_89;
  wire                when_Fp32Unit_l72_90;
  wire                when_Fp32Unit_l72_91;
  wire                when_Fp32Unit_l72_92;
  wire                when_Fp32Unit_l83_2;
  reg        [9:0]    _zz_when_Fp32Unit_l161_2;
  wire       [23:0]   _zz_when_Fp32Unit_l148_7;
  wire       [24:0]   _zz_when_Fp32Unit_l148_8;
  reg        [23:0]   _zz_when_Fp32Unit_l153_1;
  reg        [9:0]    _zz_when_Fp32Unit_l161_3;
  wire                when_Fp32Unit_l148_1;
  wire                when_Fp32Unit_l153_1;
  reg        [7:0]    _zz_mulResult_1;
  wire                when_Fp32Unit_l161_1;
  wire                when_Fp32Unit_l163_1;
  wire                when_Fp32Unit_l155_1;
  wire                when_Fp32Unit_l315;
  wire                when_Fp32Unit_l317;
  wire                when_Fp32Unit_l319;
  reg        [31:0]   maxMinResult;
  wire                when_Fp32Unit_l342;
  wire                _zz_when_Fp32Unit_l208;
  wire       [30:0]   _zz_when_Fp32Unit_l210;
  wire       [30:0]   _zz_when_Fp32Unit_l210_1;
  reg                 _zz_maxMinResult;
  wire                when_Fp32Unit_l206;
  wire                when_Fp32Unit_l208;
  wire                when_Fp32Unit_l210;
  wire                when_Fp32Unit_l212;
  wire                when_Fp32Unit_l350;
  wire                when_Fp32Unit_l351;
  wire                when_Fp32Unit_l357;
  wire       [31:0]   iMag;
  wire                _zz_i2fResult;
  reg        [31:0]   i2fResult;
  wire                when_Fp32Unit_l177;
  reg        [4:0]    _zz_when_Fp32Unit_l184;
  wire                when_Fp32Unit_l56_73;
  wire                when_Fp32Unit_l56_74;
  wire                when_Fp32Unit_l56_75;
  wire                when_Fp32Unit_l56_76;
  wire                when_Fp32Unit_l56_77;
  wire                when_Fp32Unit_l56_78;
  wire                when_Fp32Unit_l56_79;
  wire                when_Fp32Unit_l56_80;
  wire                when_Fp32Unit_l56_81;
  wire                when_Fp32Unit_l56_82;
  wire                when_Fp32Unit_l56_83;
  wire                when_Fp32Unit_l56_84;
  wire                when_Fp32Unit_l56_85;
  wire                when_Fp32Unit_l56_86;
  wire                when_Fp32Unit_l56_87;
  wire                when_Fp32Unit_l56_88;
  wire                when_Fp32Unit_l56_89;
  wire                when_Fp32Unit_l56_90;
  wire                when_Fp32Unit_l56_91;
  wire                when_Fp32Unit_l56_92;
  wire                when_Fp32Unit_l56_93;
  wire                when_Fp32Unit_l56_94;
  wire                when_Fp32Unit_l56_95;
  wire                when_Fp32Unit_l56_96;
  wire                when_Fp32Unit_l56_97;
  wire                when_Fp32Unit_l56_98;
  wire                when_Fp32Unit_l56_99;
  wire                when_Fp32Unit_l56_100;
  wire                when_Fp32Unit_l56_101;
  wire                when_Fp32Unit_l56_102;
  wire                when_Fp32Unit_l56_103;
  wire                when_Fp32Unit_l56_104;
  wire       [34:0]   _zz_when_Fp32Unit_l148_9;
  reg        [26:0]   _zz_when_Fp32Unit_l148_10;
  wire                when_Fp32Unit_l184;
  wire       [5:0]    _zz_when_Fp32Unit_l67_2;
  reg        [26:0]   _zz_when_Fp32Unit_l148_11;
  wire                when_Fp32Unit_l67_3;
  wire                when_Fp32Unit_l72_93;
  wire                when_Fp32Unit_l72_94;
  wire                when_Fp32Unit_l72_95;
  wire                when_Fp32Unit_l72_96;
  wire                when_Fp32Unit_l72_97;
  wire                when_Fp32Unit_l72_98;
  wire                when_Fp32Unit_l72_99;
  wire                when_Fp32Unit_l72_100;
  wire                when_Fp32Unit_l72_101;
  wire                when_Fp32Unit_l72_102;
  wire                when_Fp32Unit_l72_103;
  wire                when_Fp32Unit_l72_104;
  wire                when_Fp32Unit_l72_105;
  wire                when_Fp32Unit_l72_106;
  wire                when_Fp32Unit_l72_107;
  wire                when_Fp32Unit_l72_108;
  wire                when_Fp32Unit_l72_109;
  wire                when_Fp32Unit_l72_110;
  wire                when_Fp32Unit_l72_111;
  wire                when_Fp32Unit_l72_112;
  wire                when_Fp32Unit_l72_113;
  wire                when_Fp32Unit_l72_114;
  wire                when_Fp32Unit_l72_115;
  wire                when_Fp32Unit_l72_116;
  wire                when_Fp32Unit_l72_117;
  wire                when_Fp32Unit_l72_118;
  wire                when_Fp32Unit_l72_119;
  wire                when_Fp32Unit_l72_120;
  wire                when_Fp32Unit_l72_121;
  wire                when_Fp32Unit_l72_122;
  wire                when_Fp32Unit_l72_123;
  wire                when_Fp32Unit_l72_124;
  wire                when_Fp32Unit_l72_125;
  wire                when_Fp32Unit_l72_126;
  wire                when_Fp32Unit_l83_3;
  wire       [9:0]    _zz_when_Fp32Unit_l124_1;
  reg        [31:0]   _zz_i2fResult_1;
  wire                when_Fp32Unit_l124_2;
  reg        [9:0]    _zz_when_Fp32Unit_l67_3;
  reg        [26:0]   _zz_when_Fp32Unit_l148_12;
  reg        [26:0]   _zz_when_Fp32Unit_l148_13;
  wire                when_Fp32Unit_l67_4;
  wire                when_Fp32Unit_l72_127;
  wire                when_Fp32Unit_l72_128;
  wire                when_Fp32Unit_l72_129;
  wire                when_Fp32Unit_l72_130;
  wire                when_Fp32Unit_l72_131;
  wire                when_Fp32Unit_l72_132;
  wire                when_Fp32Unit_l72_133;
  wire                when_Fp32Unit_l72_134;
  wire                when_Fp32Unit_l72_135;
  wire                when_Fp32Unit_l72_136;
  wire                when_Fp32Unit_l72_137;
  wire                when_Fp32Unit_l72_138;
  wire                when_Fp32Unit_l72_139;
  wire                when_Fp32Unit_l72_140;
  wire                when_Fp32Unit_l72_141;
  wire                when_Fp32Unit_l72_142;
  wire                when_Fp32Unit_l72_143;
  wire                when_Fp32Unit_l72_144;
  wire                when_Fp32Unit_l72_145;
  wire                when_Fp32Unit_l72_146;
  wire                when_Fp32Unit_l72_147;
  wire                when_Fp32Unit_l72_148;
  wire                when_Fp32Unit_l72_149;
  wire                when_Fp32Unit_l72_150;
  wire                when_Fp32Unit_l72_151;
  wire                when_Fp32Unit_l72_152;
  wire                when_Fp32Unit_l72_153;
  wire                when_Fp32Unit_l72_154;
  wire                when_Fp32Unit_l72_155;
  wire                when_Fp32Unit_l72_156;
  wire                when_Fp32Unit_l72_157;
  wire                when_Fp32Unit_l83_4;
  reg        [9:0]    _zz_when_Fp32Unit_l161_4;
  wire       [23:0]   _zz_when_Fp32Unit_l148_14;
  wire       [24:0]   _zz_when_Fp32Unit_l148_15;
  reg        [23:0]   _zz_when_Fp32Unit_l153_2;
  reg        [9:0]    _zz_when_Fp32Unit_l161_5;
  wire                when_Fp32Unit_l148_2;
  wire                when_Fp32Unit_l153_2;
  reg        [7:0]    _zz_i2fResult_2;
  wire                when_Fp32Unit_l161_2;
  wire                when_Fp32Unit_l163_2;
  wire                when_Fp32Unit_l155_2;
  wire                _zz_u2fResult;
  reg        [31:0]   u2fResult;
  wire                when_Fp32Unit_l177_1;
  reg        [4:0]    _zz_when_Fp32Unit_l184_1;
  wire                when_Fp32Unit_l56_105;
  wire                when_Fp32Unit_l56_106;
  wire                when_Fp32Unit_l56_107;
  wire                when_Fp32Unit_l56_108;
  wire                when_Fp32Unit_l56_109;
  wire                when_Fp32Unit_l56_110;
  wire                when_Fp32Unit_l56_111;
  wire                when_Fp32Unit_l56_112;
  wire                when_Fp32Unit_l56_113;
  wire                when_Fp32Unit_l56_114;
  wire                when_Fp32Unit_l56_115;
  wire                when_Fp32Unit_l56_116;
  wire                when_Fp32Unit_l56_117;
  wire                when_Fp32Unit_l56_118;
  wire                when_Fp32Unit_l56_119;
  wire                when_Fp32Unit_l56_120;
  wire                when_Fp32Unit_l56_121;
  wire                when_Fp32Unit_l56_122;
  wire                when_Fp32Unit_l56_123;
  wire                when_Fp32Unit_l56_124;
  wire                when_Fp32Unit_l56_125;
  wire                when_Fp32Unit_l56_126;
  wire                when_Fp32Unit_l56_127;
  wire                when_Fp32Unit_l56_128;
  wire                when_Fp32Unit_l56_129;
  wire                when_Fp32Unit_l56_130;
  wire                when_Fp32Unit_l56_131;
  wire                when_Fp32Unit_l56_132;
  wire                when_Fp32Unit_l56_133;
  wire                when_Fp32Unit_l56_134;
  wire                when_Fp32Unit_l56_135;
  wire                when_Fp32Unit_l56_136;
  wire       [34:0]   _zz_when_Fp32Unit_l148_16;
  reg        [26:0]   _zz_when_Fp32Unit_l148_17;
  wire                when_Fp32Unit_l184_1;
  wire       [5:0]    _zz_when_Fp32Unit_l67_4;
  reg        [26:0]   _zz_when_Fp32Unit_l148_18;
  wire                when_Fp32Unit_l67_5;
  wire                when_Fp32Unit_l72_158;
  wire                when_Fp32Unit_l72_159;
  wire                when_Fp32Unit_l72_160;
  wire                when_Fp32Unit_l72_161;
  wire                when_Fp32Unit_l72_162;
  wire                when_Fp32Unit_l72_163;
  wire                when_Fp32Unit_l72_164;
  wire                when_Fp32Unit_l72_165;
  wire                when_Fp32Unit_l72_166;
  wire                when_Fp32Unit_l72_167;
  wire                when_Fp32Unit_l72_168;
  wire                when_Fp32Unit_l72_169;
  wire                when_Fp32Unit_l72_170;
  wire                when_Fp32Unit_l72_171;
  wire                when_Fp32Unit_l72_172;
  wire                when_Fp32Unit_l72_173;
  wire                when_Fp32Unit_l72_174;
  wire                when_Fp32Unit_l72_175;
  wire                when_Fp32Unit_l72_176;
  wire                when_Fp32Unit_l72_177;
  wire                when_Fp32Unit_l72_178;
  wire                when_Fp32Unit_l72_179;
  wire                when_Fp32Unit_l72_180;
  wire                when_Fp32Unit_l72_181;
  wire                when_Fp32Unit_l72_182;
  wire                when_Fp32Unit_l72_183;
  wire                when_Fp32Unit_l72_184;
  wire                when_Fp32Unit_l72_185;
  wire                when_Fp32Unit_l72_186;
  wire                when_Fp32Unit_l72_187;
  wire                when_Fp32Unit_l72_188;
  wire                when_Fp32Unit_l72_189;
  wire                when_Fp32Unit_l72_190;
  wire                when_Fp32Unit_l72_191;
  wire                when_Fp32Unit_l83_5;
  wire       [9:0]    _zz_when_Fp32Unit_l124_2;
  reg        [31:0]   _zz_u2fResult_1;
  wire                when_Fp32Unit_l124_3;
  reg        [9:0]    _zz_when_Fp32Unit_l67_5;
  reg        [26:0]   _zz_when_Fp32Unit_l148_19;
  reg        [26:0]   _zz_when_Fp32Unit_l148_20;
  wire                when_Fp32Unit_l67_6;
  wire                when_Fp32Unit_l72_192;
  wire                when_Fp32Unit_l72_193;
  wire                when_Fp32Unit_l72_194;
  wire                when_Fp32Unit_l72_195;
  wire                when_Fp32Unit_l72_196;
  wire                when_Fp32Unit_l72_197;
  wire                when_Fp32Unit_l72_198;
  wire                when_Fp32Unit_l72_199;
  wire                when_Fp32Unit_l72_200;
  wire                when_Fp32Unit_l72_201;
  wire                when_Fp32Unit_l72_202;
  wire                when_Fp32Unit_l72_203;
  wire                when_Fp32Unit_l72_204;
  wire                when_Fp32Unit_l72_205;
  wire                when_Fp32Unit_l72_206;
  wire                when_Fp32Unit_l72_207;
  wire                when_Fp32Unit_l72_208;
  wire                when_Fp32Unit_l72_209;
  wire                when_Fp32Unit_l72_210;
  wire                when_Fp32Unit_l72_211;
  wire                when_Fp32Unit_l72_212;
  wire                when_Fp32Unit_l72_213;
  wire                when_Fp32Unit_l72_214;
  wire                when_Fp32Unit_l72_215;
  wire                when_Fp32Unit_l72_216;
  wire                when_Fp32Unit_l72_217;
  wire                when_Fp32Unit_l72_218;
  wire                when_Fp32Unit_l72_219;
  wire                when_Fp32Unit_l72_220;
  wire                when_Fp32Unit_l72_221;
  wire                when_Fp32Unit_l72_222;
  wire                when_Fp32Unit_l83_6;
  reg        [9:0]    _zz_when_Fp32Unit_l161_6;
  wire       [23:0]   _zz_when_Fp32Unit_l148_21;
  wire       [24:0]   _zz_when_Fp32Unit_l148_22;
  reg        [23:0]   _zz_when_Fp32Unit_l153_3;
  reg        [9:0]    _zz_when_Fp32Unit_l161_7;
  wire                when_Fp32Unit_l148_3;
  wire                when_Fp32Unit_l153_3;
  reg        [7:0]    _zz_u2fResult_2;
  wire                when_Fp32Unit_l161_3;
  wire                when_Fp32Unit_l163_3;
  wire                when_Fp32Unit_l155_3;
  reg        [32:0]   intMagnitude;
  wire                when_Fp32Unit_l372;
  wire                when_Fp32Unit_l373;
  reg        [31:0]   f2iResult;
  wire                when_Fp32Unit_l391;
  wire                when_Fp32Unit_l397;
  wire                when_Fp32Unit_l388;
  wire                when_Fp32Unit_l390;
  reg        [31:0]   f2uResult;
  wire                when_Fp32Unit_l410;
  wire                when_Fp32Unit_l412;
  reg        [31:0]   addClassResult;
  reg                 addValids_0;
  reg                 addValids_1;
  reg                 addValids_2;
  reg                 addValids_3;
  reg        [31:0]   addResults_0;
  reg        [31:0]   addResults_1;
  reg        [31:0]   addResults_2;
  reg        [31:0]   addResults_3;
  reg        [10:0]   addTags_0;
  reg        [10:0]   addTags_1;
  reg        [10:0]   addTags_2;
  reg        [10:0]   addTags_3;
  reg                 mulValids_0;
  reg                 mulValids_1;
  reg                 mulValids_2;
  reg                 mulValids_3;
  reg                 mulValids_4;
  reg        [31:0]   mulResults_0;
  reg        [31:0]   mulResults_1;
  reg        [31:0]   mulResults_2;
  reg        [31:0]   mulResults_3;
  reg        [31:0]   mulResults_4;
  reg        [10:0]   mulTags_0;
  reg        [10:0]   mulTags_1;
  reg        [10:0]   mulTags_2;
  reg        [10:0]   mulTags_3;
  reg        [10:0]   mulTags_4;
  wire                addBusy;
  wire                mulBusy;
  wire                when_Fp32Unit_l460;
  wire                when_Fp32Unit_l461;

  assign _zz__zz_decA_exp_2 = (5'h17 - _zz_decA_exp_1);
  assign _zz_decA_sig_1 = {1'd0, _zz_decA_sig};
  assign _zz_decA_exp_4 = _zz_decA_exp_2;
  assign _zz_decA_exp_3 = {{4{_zz_decA_exp_4[5]}}, _zz_decA_exp_4};
  assign _zz_decA_exp_5 = _zz_decA_exp_6;
  assign _zz_decA_exp_6 = {2'd0, _zz_decA_exp};
  assign _zz__zz_decB_exp_2 = (5'h17 - _zz_decB_exp_1);
  assign _zz_decB_sig_1 = {1'd0, _zz_decB_sig};
  assign _zz_decB_exp_4 = _zz_decB_exp_2;
  assign _zz_decB_exp_3 = {{4{_zz_decB_exp_4[5]}}, _zz_decB_exp_4};
  assign _zz_decB_exp_5 = _zz_decB_exp_6;
  assign _zz_decB_exp_6 = {2'd0, _zz_decB_exp};
  assign _zz_expDiff = ($signed(bigExp) - $signed(smallExp));
  assign _zz_bigExt = {3'd0, bigSig};
  assign _zz_smallExtBase = {3'd0, smallSig};
  assign _zz_smallExt_1 = (smallExtBase >>> 1'd1);
  assign _zz_smallExt = {1'd0, _zz_smallExt_1};
  assign _zz_smallExt_3 = (|smallExtBase[0 : 0]);
  assign _zz_smallExt_2 = {26'd0, _zz_smallExt_3};
  assign _zz_smallExt_5 = (smallExtBase >>> 2'd2);
  assign _zz_smallExt_4 = {2'd0, _zz_smallExt_5};
  assign _zz_smallExt_7 = (|smallExtBase[1 : 0]);
  assign _zz_smallExt_6 = {26'd0, _zz_smallExt_7};
  assign _zz_smallExt_9 = (smallExtBase >>> 2'd3);
  assign _zz_smallExt_8 = {3'd0, _zz_smallExt_9};
  assign _zz_smallExt_11 = (|smallExtBase[2 : 0]);
  assign _zz_smallExt_10 = {26'd0, _zz_smallExt_11};
  assign _zz_smallExt_13 = (smallExtBase >>> 3'd4);
  assign _zz_smallExt_12 = {4'd0, _zz_smallExt_13};
  assign _zz_smallExt_15 = (|smallExtBase[3 : 0]);
  assign _zz_smallExt_14 = {26'd0, _zz_smallExt_15};
  assign _zz_smallExt_17 = (smallExtBase >>> 3'd5);
  assign _zz_smallExt_16 = {5'd0, _zz_smallExt_17};
  assign _zz_smallExt_19 = (|smallExtBase[4 : 0]);
  assign _zz_smallExt_18 = {26'd0, _zz_smallExt_19};
  assign _zz_smallExt_21 = (smallExtBase >>> 3'd6);
  assign _zz_smallExt_20 = {6'd0, _zz_smallExt_21};
  assign _zz_smallExt_23 = (|smallExtBase[5 : 0]);
  assign _zz_smallExt_22 = {26'd0, _zz_smallExt_23};
  assign _zz_smallExt_25 = (smallExtBase >>> 3'd7);
  assign _zz_smallExt_24 = {7'd0, _zz_smallExt_25};
  assign _zz_smallExt_27 = (|smallExtBase[6 : 0]);
  assign _zz_smallExt_26 = {26'd0, _zz_smallExt_27};
  assign _zz_smallExt_29 = (smallExtBase >>> 4'd8);
  assign _zz_smallExt_28 = {8'd0, _zz_smallExt_29};
  assign _zz_smallExt_31 = (|smallExtBase[7 : 0]);
  assign _zz_smallExt_30 = {26'd0, _zz_smallExt_31};
  assign _zz_smallExt_33 = (smallExtBase >>> 4'd9);
  assign _zz_smallExt_32 = {9'd0, _zz_smallExt_33};
  assign _zz_smallExt_35 = (|smallExtBase[8 : 0]);
  assign _zz_smallExt_34 = {26'd0, _zz_smallExt_35};
  assign _zz_smallExt_37 = (smallExtBase >>> 4'd10);
  assign _zz_smallExt_36 = {10'd0, _zz_smallExt_37};
  assign _zz_smallExt_39 = (|smallExtBase[9 : 0]);
  assign _zz_smallExt_38 = {26'd0, _zz_smallExt_39};
  assign _zz_smallExt_41 = (smallExtBase >>> 4'd11);
  assign _zz_smallExt_40 = {11'd0, _zz_smallExt_41};
  assign _zz_smallExt_43 = (|smallExtBase[10 : 0]);
  assign _zz_smallExt_42 = {26'd0, _zz_smallExt_43};
  assign _zz_smallExt_45 = (smallExtBase >>> 4'd12);
  assign _zz_smallExt_44 = {12'd0, _zz_smallExt_45};
  assign _zz_smallExt_47 = (|smallExtBase[11 : 0]);
  assign _zz_smallExt_46 = {26'd0, _zz_smallExt_47};
  assign _zz_smallExt_49 = (smallExtBase >>> 4'd13);
  assign _zz_smallExt_48 = {13'd0, _zz_smallExt_49};
  assign _zz_smallExt_51 = (|smallExtBase[12 : 0]);
  assign _zz_smallExt_50 = {26'd0, _zz_smallExt_51};
  assign _zz_smallExt_53 = (smallExtBase >>> 4'd14);
  assign _zz_smallExt_52 = {14'd0, _zz_smallExt_53};
  assign _zz_smallExt_55 = (|smallExtBase[13 : 0]);
  assign _zz_smallExt_54 = {26'd0, _zz_smallExt_55};
  assign _zz_smallExt_57 = (smallExtBase >>> 4'd15);
  assign _zz_smallExt_56 = {15'd0, _zz_smallExt_57};
  assign _zz_smallExt_59 = (|smallExtBase[14 : 0]);
  assign _zz_smallExt_58 = {26'd0, _zz_smallExt_59};
  assign _zz_smallExt_61 = (smallExtBase >>> 5'd16);
  assign _zz_smallExt_60 = {16'd0, _zz_smallExt_61};
  assign _zz_smallExt_63 = (|smallExtBase[15 : 0]);
  assign _zz_smallExt_62 = {26'd0, _zz_smallExt_63};
  assign _zz_smallExt_65 = (smallExtBase >>> 5'd17);
  assign _zz_smallExt_64 = {17'd0, _zz_smallExt_65};
  assign _zz_smallExt_67 = (|smallExtBase[16 : 0]);
  assign _zz_smallExt_66 = {26'd0, _zz_smallExt_67};
  assign _zz_smallExt_69 = (smallExtBase >>> 5'd18);
  assign _zz_smallExt_68 = {18'd0, _zz_smallExt_69};
  assign _zz_smallExt_71 = (|smallExtBase[17 : 0]);
  assign _zz_smallExt_70 = {26'd0, _zz_smallExt_71};
  assign _zz_smallExt_73 = (smallExtBase >>> 5'd19);
  assign _zz_smallExt_72 = {19'd0, _zz_smallExt_73};
  assign _zz_smallExt_75 = (|smallExtBase[18 : 0]);
  assign _zz_smallExt_74 = {26'd0, _zz_smallExt_75};
  assign _zz_smallExt_77 = (smallExtBase >>> 5'd20);
  assign _zz_smallExt_76 = {20'd0, _zz_smallExt_77};
  assign _zz_smallExt_79 = (|smallExtBase[19 : 0]);
  assign _zz_smallExt_78 = {26'd0, _zz_smallExt_79};
  assign _zz_smallExt_81 = (smallExtBase >>> 5'd21);
  assign _zz_smallExt_80 = {21'd0, _zz_smallExt_81};
  assign _zz_smallExt_83 = (|smallExtBase[20 : 0]);
  assign _zz_smallExt_82 = {26'd0, _zz_smallExt_83};
  assign _zz_smallExt_85 = (smallExtBase >>> 5'd22);
  assign _zz_smallExt_84 = {22'd0, _zz_smallExt_85};
  assign _zz_smallExt_87 = (|smallExtBase[21 : 0]);
  assign _zz_smallExt_86 = {26'd0, _zz_smallExt_87};
  assign _zz_smallExt_89 = (smallExtBase >>> 5'd23);
  assign _zz_smallExt_88 = {23'd0, _zz_smallExt_89};
  assign _zz_smallExt_91 = (|smallExtBase[22 : 0]);
  assign _zz_smallExt_90 = {26'd0, _zz_smallExt_91};
  assign _zz_smallExt_93 = (smallExtBase >>> 5'd24);
  assign _zz_smallExt_92 = {24'd0, _zz_smallExt_93};
  assign _zz_smallExt_95 = (|smallExtBase[23 : 0]);
  assign _zz_smallExt_94 = {26'd0, _zz_smallExt_95};
  assign _zz_smallExt_97 = (smallExtBase >>> 5'd25);
  assign _zz_smallExt_96 = {25'd0, _zz_smallExt_97};
  assign _zz_smallExt_99 = (|smallExtBase[24 : 0]);
  assign _zz_smallExt_98 = {26'd0, _zz_smallExt_99};
  assign _zz_smallExt_101 = (smallExtBase >>> 5'd26);
  assign _zz_smallExt_100 = {26'd0, _zz_smallExt_101};
  assign _zz_smallExt_103 = (|smallExtBase[25 : 0]);
  assign _zz_smallExt_102 = {26'd0, _zz_smallExt_103};
  assign _zz_smallExt_104 = (|smallExtBase);
  assign _zz_smallExt_105 = (|smallExtBase);
  assign _zz_smallExt_106 = (|smallExtBase);
  assign _zz_smallExt_107 = (|smallExtBase);
  assign _zz_smallExt_108 = (|smallExtBase);
  assign _zz_smallExt_109 = (|smallExtBase);
  assign _zz__zz_addFiniteSig = {1'd0, bigExt};
  assign _zz__zz_addFiniteSig_1 = {1'd0, smallExt};
  assign _zz_addFiniteSig_3 = _zz_addFiniteSig[0];
  assign _zz_addFiniteSig_2 = {26'd0, _zz_addFiniteSig_3};
  assign _zz__zz_addFiniteExp_1 = (5'h1a - _zz_addFiniteExp);
  assign _zz_addFiniteExp_3 = _zz_addFiniteExp_1;
  assign _zz_addFiniteExp_2 = {{4{_zz_addFiniteExp_3[5]}}, _zz_addFiniteExp_3};
  assign _zz__zz_when_Fp32Unit_l67 = ($signed(10'h382) - $signed(addFiniteExp));
  assign _zz__zz_when_Fp32Unit_l148_1_1 = (addFiniteSig >>> 1'd1);
  assign _zz__zz_when_Fp32Unit_l148_1 = {1'd0, _zz__zz_when_Fp32Unit_l148_1_1};
  assign _zz__zz_when_Fp32Unit_l148_1_3 = (|addFiniteSig[0 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_2 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_3};
  assign _zz__zz_when_Fp32Unit_l148_1_5 = (addFiniteSig >>> 2'd2);
  assign _zz__zz_when_Fp32Unit_l148_1_4 = {2'd0, _zz__zz_when_Fp32Unit_l148_1_5};
  assign _zz__zz_when_Fp32Unit_l148_1_7 = (|addFiniteSig[1 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_7};
  assign _zz__zz_when_Fp32Unit_l148_1_9 = (addFiniteSig >>> 2'd3);
  assign _zz__zz_when_Fp32Unit_l148_1_8 = {3'd0, _zz__zz_when_Fp32Unit_l148_1_9};
  assign _zz__zz_when_Fp32Unit_l148_1_11 = (|addFiniteSig[2 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_10 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_11};
  assign _zz__zz_when_Fp32Unit_l148_1_13 = (addFiniteSig >>> 3'd4);
  assign _zz__zz_when_Fp32Unit_l148_1_12 = {4'd0, _zz__zz_when_Fp32Unit_l148_1_13};
  assign _zz__zz_when_Fp32Unit_l148_1_15 = (|addFiniteSig[3 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_14 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_15};
  assign _zz__zz_when_Fp32Unit_l148_1_17 = (addFiniteSig >>> 3'd5);
  assign _zz__zz_when_Fp32Unit_l148_1_16 = {5'd0, _zz__zz_when_Fp32Unit_l148_1_17};
  assign _zz__zz_when_Fp32Unit_l148_1_19 = (|addFiniteSig[4 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_18 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_19};
  assign _zz__zz_when_Fp32Unit_l148_1_21 = (addFiniteSig >>> 3'd6);
  assign _zz__zz_when_Fp32Unit_l148_1_20 = {6'd0, _zz__zz_when_Fp32Unit_l148_1_21};
  assign _zz__zz_when_Fp32Unit_l148_1_23 = (|addFiniteSig[5 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_22 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_23};
  assign _zz__zz_when_Fp32Unit_l148_1_25 = (addFiniteSig >>> 3'd7);
  assign _zz__zz_when_Fp32Unit_l148_1_24 = {7'd0, _zz__zz_when_Fp32Unit_l148_1_25};
  assign _zz__zz_when_Fp32Unit_l148_1_27 = (|addFiniteSig[6 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_26 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_27};
  assign _zz__zz_when_Fp32Unit_l148_1_29 = (addFiniteSig >>> 4'd8);
  assign _zz__zz_when_Fp32Unit_l148_1_28 = {8'd0, _zz__zz_when_Fp32Unit_l148_1_29};
  assign _zz__zz_when_Fp32Unit_l148_1_31 = (|addFiniteSig[7 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_30 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_31};
  assign _zz__zz_when_Fp32Unit_l148_1_33 = (addFiniteSig >>> 4'd9);
  assign _zz__zz_when_Fp32Unit_l148_1_32 = {9'd0, _zz__zz_when_Fp32Unit_l148_1_33};
  assign _zz__zz_when_Fp32Unit_l148_1_35 = (|addFiniteSig[8 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_34 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_35};
  assign _zz__zz_when_Fp32Unit_l148_1_37 = (addFiniteSig >>> 4'd10);
  assign _zz__zz_when_Fp32Unit_l148_1_36 = {10'd0, _zz__zz_when_Fp32Unit_l148_1_37};
  assign _zz__zz_when_Fp32Unit_l148_1_39 = (|addFiniteSig[9 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_38 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_39};
  assign _zz__zz_when_Fp32Unit_l148_1_41 = (addFiniteSig >>> 4'd11);
  assign _zz__zz_when_Fp32Unit_l148_1_40 = {11'd0, _zz__zz_when_Fp32Unit_l148_1_41};
  assign _zz__zz_when_Fp32Unit_l148_1_43 = (|addFiniteSig[10 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_42 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_43};
  assign _zz__zz_when_Fp32Unit_l148_1_45 = (addFiniteSig >>> 4'd12);
  assign _zz__zz_when_Fp32Unit_l148_1_44 = {12'd0, _zz__zz_when_Fp32Unit_l148_1_45};
  assign _zz__zz_when_Fp32Unit_l148_1_47 = (|addFiniteSig[11 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_46 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_47};
  assign _zz__zz_when_Fp32Unit_l148_1_49 = (addFiniteSig >>> 4'd13);
  assign _zz__zz_when_Fp32Unit_l148_1_48 = {13'd0, _zz__zz_when_Fp32Unit_l148_1_49};
  assign _zz__zz_when_Fp32Unit_l148_1_51 = (|addFiniteSig[12 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_50 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_51};
  assign _zz__zz_when_Fp32Unit_l148_1_53 = (addFiniteSig >>> 4'd14);
  assign _zz__zz_when_Fp32Unit_l148_1_52 = {14'd0, _zz__zz_when_Fp32Unit_l148_1_53};
  assign _zz__zz_when_Fp32Unit_l148_1_55 = (|addFiniteSig[13 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_54 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_55};
  assign _zz__zz_when_Fp32Unit_l148_1_57 = (addFiniteSig >>> 4'd15);
  assign _zz__zz_when_Fp32Unit_l148_1_56 = {15'd0, _zz__zz_when_Fp32Unit_l148_1_57};
  assign _zz__zz_when_Fp32Unit_l148_1_59 = (|addFiniteSig[14 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_58 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_59};
  assign _zz__zz_when_Fp32Unit_l148_1_61 = (addFiniteSig >>> 5'd16);
  assign _zz__zz_when_Fp32Unit_l148_1_60 = {16'd0, _zz__zz_when_Fp32Unit_l148_1_61};
  assign _zz__zz_when_Fp32Unit_l148_1_63 = (|addFiniteSig[15 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_62 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_63};
  assign _zz__zz_when_Fp32Unit_l148_1_65 = (addFiniteSig >>> 5'd17);
  assign _zz__zz_when_Fp32Unit_l148_1_64 = {17'd0, _zz__zz_when_Fp32Unit_l148_1_65};
  assign _zz__zz_when_Fp32Unit_l148_1_67 = (|addFiniteSig[16 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_66 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_67};
  assign _zz__zz_when_Fp32Unit_l148_1_69 = (addFiniteSig >>> 5'd18);
  assign _zz__zz_when_Fp32Unit_l148_1_68 = {18'd0, _zz__zz_when_Fp32Unit_l148_1_69};
  assign _zz__zz_when_Fp32Unit_l148_1_71 = (|addFiniteSig[17 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_70 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_71};
  assign _zz__zz_when_Fp32Unit_l148_1_73 = (addFiniteSig >>> 5'd19);
  assign _zz__zz_when_Fp32Unit_l148_1_72 = {19'd0, _zz__zz_when_Fp32Unit_l148_1_73};
  assign _zz__zz_when_Fp32Unit_l148_1_75 = (|addFiniteSig[18 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_74 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_75};
  assign _zz__zz_when_Fp32Unit_l148_1_77 = (addFiniteSig >>> 5'd20);
  assign _zz__zz_when_Fp32Unit_l148_1_76 = {20'd0, _zz__zz_when_Fp32Unit_l148_1_77};
  assign _zz__zz_when_Fp32Unit_l148_1_79 = (|addFiniteSig[19 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_78 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_79};
  assign _zz__zz_when_Fp32Unit_l148_1_81 = (addFiniteSig >>> 5'd21);
  assign _zz__zz_when_Fp32Unit_l148_1_80 = {21'd0, _zz__zz_when_Fp32Unit_l148_1_81};
  assign _zz__zz_when_Fp32Unit_l148_1_83 = (|addFiniteSig[20 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_82 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_83};
  assign _zz__zz_when_Fp32Unit_l148_1_85 = (addFiniteSig >>> 5'd22);
  assign _zz__zz_when_Fp32Unit_l148_1_84 = {22'd0, _zz__zz_when_Fp32Unit_l148_1_85};
  assign _zz__zz_when_Fp32Unit_l148_1_87 = (|addFiniteSig[21 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_86 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_87};
  assign _zz__zz_when_Fp32Unit_l148_1_89 = (addFiniteSig >>> 5'd23);
  assign _zz__zz_when_Fp32Unit_l148_1_88 = {23'd0, _zz__zz_when_Fp32Unit_l148_1_89};
  assign _zz__zz_when_Fp32Unit_l148_1_91 = (|addFiniteSig[22 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_90 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_91};
  assign _zz__zz_when_Fp32Unit_l148_1_93 = (addFiniteSig >>> 5'd24);
  assign _zz__zz_when_Fp32Unit_l148_1_92 = {24'd0, _zz__zz_when_Fp32Unit_l148_1_93};
  assign _zz__zz_when_Fp32Unit_l148_1_95 = (|addFiniteSig[23 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_94 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_95};
  assign _zz__zz_when_Fp32Unit_l148_1_97 = (addFiniteSig >>> 5'd25);
  assign _zz__zz_when_Fp32Unit_l148_1_96 = {25'd0, _zz__zz_when_Fp32Unit_l148_1_97};
  assign _zz__zz_when_Fp32Unit_l148_1_99 = (|addFiniteSig[24 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_98 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_99};
  assign _zz__zz_when_Fp32Unit_l148_1_101 = (addFiniteSig >>> 5'd26);
  assign _zz__zz_when_Fp32Unit_l148_1_100 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_101};
  assign _zz__zz_when_Fp32Unit_l148_1_103 = (|addFiniteSig[25 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_1_102 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_103};
  assign _zz__zz_when_Fp32Unit_l148_1_104 = (|addFiniteSig);
  assign _zz__zz_when_Fp32Unit_l148_1_105 = (|addFiniteSig);
  assign _zz__zz_when_Fp32Unit_l148_1_106 = (|addFiniteSig);
  assign _zz__zz_when_Fp32Unit_l148_1_107 = (|addFiniteSig);
  assign _zz__zz_when_Fp32Unit_l148_1_108 = (|addFiniteSig);
  assign _zz__zz_when_Fp32Unit_l148_1_109 = (|addFiniteSig);
  assign _zz__zz_when_Fp32Unit_l148_3 = {1'd0, _zz_when_Fp32Unit_l148_2};
  assign _zz__zz_when_Fp32Unit_l148_3_2 = (_zz_when_Fp32Unit_l148[2] && ((_zz_when_Fp32Unit_l148[1] || _zz_when_Fp32Unit_l148[0]) || _zz_when_Fp32Unit_l148_2[0]));
  assign _zz__zz_when_Fp32Unit_l148_3_1 = {24'd0, _zz__zz_when_Fp32Unit_l148_3_2};
  assign _zz__zz_addResult_1 = _zz__zz_addResult_1_1;
  assign _zz__zz_addResult_1_1 = ($signed(_zz_when_Fp32Unit_l161_1) + $signed(10'h07f));
  assign _zz__zz_when_Fp32Unit_l328 = (_zz__zz_when_Fp32Unit_l328_1 * _zz__zz_when_Fp32Unit_l328_2);
  assign _zz__zz_when_Fp32Unit_l328_1 = {24'd0, decA_sig};
  assign _zz__zz_when_Fp32Unit_l328_2 = {24'd0, decB_sig};
  assign _zz__zz_when_Fp32Unit_l124 = ($signed(decA_exp) + $signed(decB_exp));
  assign _zz__zz_when_Fp32Unit_l148_4_1 = (|_zz_when_Fp32Unit_l328[20 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_4 = {26'd0, _zz__zz_when_Fp32Unit_l148_4_1};
  assign _zz__zz_when_Fp32Unit_l148_4_3 = (|_zz_when_Fp32Unit_l328[19 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_4_2 = {26'd0, _zz__zz_when_Fp32Unit_l148_4_3};
  assign _zz__zz_when_Fp32Unit_l67_1 = ($signed(10'h382) - $signed(_zz_when_Fp32Unit_l124));
  assign _zz__zz_when_Fp32Unit_l148_6_1 = (_zz_when_Fp32Unit_l148_4 >>> 1'd1);
  assign _zz__zz_when_Fp32Unit_l148_6 = {1'd0, _zz__zz_when_Fp32Unit_l148_6_1};
  assign _zz__zz_when_Fp32Unit_l148_6_3 = (|_zz_when_Fp32Unit_l148_4[0 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_2 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_3};
  assign _zz__zz_when_Fp32Unit_l148_6_5 = (_zz_when_Fp32Unit_l148_4 >>> 2'd2);
  assign _zz__zz_when_Fp32Unit_l148_6_4 = {2'd0, _zz__zz_when_Fp32Unit_l148_6_5};
  assign _zz__zz_when_Fp32Unit_l148_6_7 = (|_zz_when_Fp32Unit_l148_4[1 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_7};
  assign _zz__zz_when_Fp32Unit_l148_6_9 = (_zz_when_Fp32Unit_l148_4 >>> 2'd3);
  assign _zz__zz_when_Fp32Unit_l148_6_8 = {3'd0, _zz__zz_when_Fp32Unit_l148_6_9};
  assign _zz__zz_when_Fp32Unit_l148_6_11 = (|_zz_when_Fp32Unit_l148_4[2 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_10 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_11};
  assign _zz__zz_when_Fp32Unit_l148_6_13 = (_zz_when_Fp32Unit_l148_4 >>> 3'd4);
  assign _zz__zz_when_Fp32Unit_l148_6_12 = {4'd0, _zz__zz_when_Fp32Unit_l148_6_13};
  assign _zz__zz_when_Fp32Unit_l148_6_15 = (|_zz_when_Fp32Unit_l148_4[3 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_14 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_15};
  assign _zz__zz_when_Fp32Unit_l148_6_17 = (_zz_when_Fp32Unit_l148_4 >>> 3'd5);
  assign _zz__zz_when_Fp32Unit_l148_6_16 = {5'd0, _zz__zz_when_Fp32Unit_l148_6_17};
  assign _zz__zz_when_Fp32Unit_l148_6_19 = (|_zz_when_Fp32Unit_l148_4[4 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_18 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_19};
  assign _zz__zz_when_Fp32Unit_l148_6_21 = (_zz_when_Fp32Unit_l148_4 >>> 3'd6);
  assign _zz__zz_when_Fp32Unit_l148_6_20 = {6'd0, _zz__zz_when_Fp32Unit_l148_6_21};
  assign _zz__zz_when_Fp32Unit_l148_6_23 = (|_zz_when_Fp32Unit_l148_4[5 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_22 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_23};
  assign _zz__zz_when_Fp32Unit_l148_6_25 = (_zz_when_Fp32Unit_l148_4 >>> 3'd7);
  assign _zz__zz_when_Fp32Unit_l148_6_24 = {7'd0, _zz__zz_when_Fp32Unit_l148_6_25};
  assign _zz__zz_when_Fp32Unit_l148_6_27 = (|_zz_when_Fp32Unit_l148_4[6 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_26 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_27};
  assign _zz__zz_when_Fp32Unit_l148_6_29 = (_zz_when_Fp32Unit_l148_4 >>> 4'd8);
  assign _zz__zz_when_Fp32Unit_l148_6_28 = {8'd0, _zz__zz_when_Fp32Unit_l148_6_29};
  assign _zz__zz_when_Fp32Unit_l148_6_31 = (|_zz_when_Fp32Unit_l148_4[7 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_30 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_31};
  assign _zz__zz_when_Fp32Unit_l148_6_33 = (_zz_when_Fp32Unit_l148_4 >>> 4'd9);
  assign _zz__zz_when_Fp32Unit_l148_6_32 = {9'd0, _zz__zz_when_Fp32Unit_l148_6_33};
  assign _zz__zz_when_Fp32Unit_l148_6_35 = (|_zz_when_Fp32Unit_l148_4[8 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_34 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_35};
  assign _zz__zz_when_Fp32Unit_l148_6_37 = (_zz_when_Fp32Unit_l148_4 >>> 4'd10);
  assign _zz__zz_when_Fp32Unit_l148_6_36 = {10'd0, _zz__zz_when_Fp32Unit_l148_6_37};
  assign _zz__zz_when_Fp32Unit_l148_6_39 = (|_zz_when_Fp32Unit_l148_4[9 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_38 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_39};
  assign _zz__zz_when_Fp32Unit_l148_6_41 = (_zz_when_Fp32Unit_l148_4 >>> 4'd11);
  assign _zz__zz_when_Fp32Unit_l148_6_40 = {11'd0, _zz__zz_when_Fp32Unit_l148_6_41};
  assign _zz__zz_when_Fp32Unit_l148_6_43 = (|_zz_when_Fp32Unit_l148_4[10 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_42 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_43};
  assign _zz__zz_when_Fp32Unit_l148_6_45 = (_zz_when_Fp32Unit_l148_4 >>> 4'd12);
  assign _zz__zz_when_Fp32Unit_l148_6_44 = {12'd0, _zz__zz_when_Fp32Unit_l148_6_45};
  assign _zz__zz_when_Fp32Unit_l148_6_47 = (|_zz_when_Fp32Unit_l148_4[11 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_46 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_47};
  assign _zz__zz_when_Fp32Unit_l148_6_49 = (_zz_when_Fp32Unit_l148_4 >>> 4'd13);
  assign _zz__zz_when_Fp32Unit_l148_6_48 = {13'd0, _zz__zz_when_Fp32Unit_l148_6_49};
  assign _zz__zz_when_Fp32Unit_l148_6_51 = (|_zz_when_Fp32Unit_l148_4[12 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_50 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_51};
  assign _zz__zz_when_Fp32Unit_l148_6_53 = (_zz_when_Fp32Unit_l148_4 >>> 4'd14);
  assign _zz__zz_when_Fp32Unit_l148_6_52 = {14'd0, _zz__zz_when_Fp32Unit_l148_6_53};
  assign _zz__zz_when_Fp32Unit_l148_6_55 = (|_zz_when_Fp32Unit_l148_4[13 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_54 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_55};
  assign _zz__zz_when_Fp32Unit_l148_6_57 = (_zz_when_Fp32Unit_l148_4 >>> 4'd15);
  assign _zz__zz_when_Fp32Unit_l148_6_56 = {15'd0, _zz__zz_when_Fp32Unit_l148_6_57};
  assign _zz__zz_when_Fp32Unit_l148_6_59 = (|_zz_when_Fp32Unit_l148_4[14 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_58 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_59};
  assign _zz__zz_when_Fp32Unit_l148_6_61 = (_zz_when_Fp32Unit_l148_4 >>> 5'd16);
  assign _zz__zz_when_Fp32Unit_l148_6_60 = {16'd0, _zz__zz_when_Fp32Unit_l148_6_61};
  assign _zz__zz_when_Fp32Unit_l148_6_63 = (|_zz_when_Fp32Unit_l148_4[15 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_62 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_63};
  assign _zz__zz_when_Fp32Unit_l148_6_65 = (_zz_when_Fp32Unit_l148_4 >>> 5'd17);
  assign _zz__zz_when_Fp32Unit_l148_6_64 = {17'd0, _zz__zz_when_Fp32Unit_l148_6_65};
  assign _zz__zz_when_Fp32Unit_l148_6_67 = (|_zz_when_Fp32Unit_l148_4[16 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_66 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_67};
  assign _zz__zz_when_Fp32Unit_l148_6_69 = (_zz_when_Fp32Unit_l148_4 >>> 5'd18);
  assign _zz__zz_when_Fp32Unit_l148_6_68 = {18'd0, _zz__zz_when_Fp32Unit_l148_6_69};
  assign _zz__zz_when_Fp32Unit_l148_6_71 = (|_zz_when_Fp32Unit_l148_4[17 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_70 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_71};
  assign _zz__zz_when_Fp32Unit_l148_6_73 = (_zz_when_Fp32Unit_l148_4 >>> 5'd19);
  assign _zz__zz_when_Fp32Unit_l148_6_72 = {19'd0, _zz__zz_when_Fp32Unit_l148_6_73};
  assign _zz__zz_when_Fp32Unit_l148_6_75 = (|_zz_when_Fp32Unit_l148_4[18 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_74 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_75};
  assign _zz__zz_when_Fp32Unit_l148_6_77 = (_zz_when_Fp32Unit_l148_4 >>> 5'd20);
  assign _zz__zz_when_Fp32Unit_l148_6_76 = {20'd0, _zz__zz_when_Fp32Unit_l148_6_77};
  assign _zz__zz_when_Fp32Unit_l148_6_79 = (|_zz_when_Fp32Unit_l148_4[19 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_78 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_79};
  assign _zz__zz_when_Fp32Unit_l148_6_81 = (_zz_when_Fp32Unit_l148_4 >>> 5'd21);
  assign _zz__zz_when_Fp32Unit_l148_6_80 = {21'd0, _zz__zz_when_Fp32Unit_l148_6_81};
  assign _zz__zz_when_Fp32Unit_l148_6_83 = (|_zz_when_Fp32Unit_l148_4[20 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_82 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_83};
  assign _zz__zz_when_Fp32Unit_l148_6_85 = (_zz_when_Fp32Unit_l148_4 >>> 5'd22);
  assign _zz__zz_when_Fp32Unit_l148_6_84 = {22'd0, _zz__zz_when_Fp32Unit_l148_6_85};
  assign _zz__zz_when_Fp32Unit_l148_6_87 = (|_zz_when_Fp32Unit_l148_4[21 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_86 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_87};
  assign _zz__zz_when_Fp32Unit_l148_6_89 = (_zz_when_Fp32Unit_l148_4 >>> 5'd23);
  assign _zz__zz_when_Fp32Unit_l148_6_88 = {23'd0, _zz__zz_when_Fp32Unit_l148_6_89};
  assign _zz__zz_when_Fp32Unit_l148_6_91 = (|_zz_when_Fp32Unit_l148_4[22 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_90 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_91};
  assign _zz__zz_when_Fp32Unit_l148_6_93 = (_zz_when_Fp32Unit_l148_4 >>> 5'd24);
  assign _zz__zz_when_Fp32Unit_l148_6_92 = {24'd0, _zz__zz_when_Fp32Unit_l148_6_93};
  assign _zz__zz_when_Fp32Unit_l148_6_95 = (|_zz_when_Fp32Unit_l148_4[23 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_94 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_95};
  assign _zz__zz_when_Fp32Unit_l148_6_97 = (_zz_when_Fp32Unit_l148_4 >>> 5'd25);
  assign _zz__zz_when_Fp32Unit_l148_6_96 = {25'd0, _zz__zz_when_Fp32Unit_l148_6_97};
  assign _zz__zz_when_Fp32Unit_l148_6_99 = (|_zz_when_Fp32Unit_l148_4[24 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_98 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_99};
  assign _zz__zz_when_Fp32Unit_l148_6_101 = (_zz_when_Fp32Unit_l148_4 >>> 5'd26);
  assign _zz__zz_when_Fp32Unit_l148_6_100 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_101};
  assign _zz__zz_when_Fp32Unit_l148_6_103 = (|_zz_when_Fp32Unit_l148_4[25 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_6_102 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_103};
  assign _zz__zz_when_Fp32Unit_l148_6_104 = (|_zz_when_Fp32Unit_l148_4);
  assign _zz__zz_when_Fp32Unit_l148_6_105 = (|_zz_when_Fp32Unit_l148_4);
  assign _zz__zz_when_Fp32Unit_l148_6_106 = (|_zz_when_Fp32Unit_l148_4);
  assign _zz__zz_when_Fp32Unit_l148_6_107 = (|_zz_when_Fp32Unit_l148_4);
  assign _zz__zz_when_Fp32Unit_l148_6_108 = (|_zz_when_Fp32Unit_l148_4);
  assign _zz__zz_when_Fp32Unit_l148_6_109 = (|_zz_when_Fp32Unit_l148_4);
  assign _zz__zz_when_Fp32Unit_l148_8 = {1'd0, _zz_when_Fp32Unit_l148_7};
  assign _zz__zz_when_Fp32Unit_l148_8_2 = (_zz_when_Fp32Unit_l148_5[2] && ((_zz_when_Fp32Unit_l148_5[1] || _zz_when_Fp32Unit_l148_5[0]) || _zz_when_Fp32Unit_l148_7[0]));
  assign _zz__zz_when_Fp32Unit_l148_8_1 = {24'd0, _zz__zz_when_Fp32Unit_l148_8_2};
  assign _zz__zz_mulResult_1 = _zz__zz_mulResult_1_1;
  assign _zz__zz_mulResult_1_1 = ($signed(_zz_when_Fp32Unit_l161_3) + $signed(10'h07f));
  assign _zz_iMag = (- _zz_iMag_1);
  assign _zz_iMag_1 = io_a;
  assign _zz__zz_when_Fp32Unit_l148_9 = {3'd0, iMag};
  assign _zz__zz_when_Fp32Unit_l148_10 = (_zz_when_Fp32Unit_l148_9 <<< _zz__zz_when_Fp32Unit_l148_10_1);
  assign _zz__zz_when_Fp32Unit_l148_10_2 = (5'h17 - _zz_when_Fp32Unit_l184);
  assign _zz__zz_when_Fp32Unit_l148_10_1 = {1'd0, _zz__zz_when_Fp32Unit_l148_10_2};
  assign _zz__zz_when_Fp32Unit_l67_2 = (_zz_when_Fp32Unit_l184 - 5'h17);
  assign _zz__zz_when_Fp32Unit_l148_11_1 = (_zz_when_Fp32Unit_l148_9 >>> 1'd1);
  assign _zz__zz_when_Fp32Unit_l148_11 = _zz__zz_when_Fp32Unit_l148_11_1[26:0];
  assign _zz__zz_when_Fp32Unit_l148_11_3 = (|_zz_when_Fp32Unit_l148_9[0 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_2 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_3};
  assign _zz__zz_when_Fp32Unit_l148_11_5 = (_zz_when_Fp32Unit_l148_9 >>> 2'd2);
  assign _zz__zz_when_Fp32Unit_l148_11_4 = _zz__zz_when_Fp32Unit_l148_11_5[26:0];
  assign _zz__zz_when_Fp32Unit_l148_11_7 = (|_zz_when_Fp32Unit_l148_9[1 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_7};
  assign _zz__zz_when_Fp32Unit_l148_11_9 = (_zz_when_Fp32Unit_l148_9 >>> 2'd3);
  assign _zz__zz_when_Fp32Unit_l148_11_8 = _zz__zz_when_Fp32Unit_l148_11_9[26:0];
  assign _zz__zz_when_Fp32Unit_l148_11_11 = (|_zz_when_Fp32Unit_l148_9[2 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_10 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_11};
  assign _zz__zz_when_Fp32Unit_l148_11_13 = (_zz_when_Fp32Unit_l148_9 >>> 3'd4);
  assign _zz__zz_when_Fp32Unit_l148_11_12 = _zz__zz_when_Fp32Unit_l148_11_13[26:0];
  assign _zz__zz_when_Fp32Unit_l148_11_15 = (|_zz_when_Fp32Unit_l148_9[3 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_14 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_15};
  assign _zz__zz_when_Fp32Unit_l148_11_17 = (_zz_when_Fp32Unit_l148_9 >>> 3'd5);
  assign _zz__zz_when_Fp32Unit_l148_11_16 = _zz__zz_when_Fp32Unit_l148_11_17[26:0];
  assign _zz__zz_when_Fp32Unit_l148_11_19 = (|_zz_when_Fp32Unit_l148_9[4 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_18 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_19};
  assign _zz__zz_when_Fp32Unit_l148_11_21 = (_zz_when_Fp32Unit_l148_9 >>> 3'd6);
  assign _zz__zz_when_Fp32Unit_l148_11_20 = _zz__zz_when_Fp32Unit_l148_11_21[26:0];
  assign _zz__zz_when_Fp32Unit_l148_11_23 = (|_zz_when_Fp32Unit_l148_9[5 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_22 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_23};
  assign _zz__zz_when_Fp32Unit_l148_11_25 = (_zz_when_Fp32Unit_l148_9 >>> 3'd7);
  assign _zz__zz_when_Fp32Unit_l148_11_24 = _zz__zz_when_Fp32Unit_l148_11_25[26:0];
  assign _zz__zz_when_Fp32Unit_l148_11_27 = (|_zz_when_Fp32Unit_l148_9[6 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_26 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_27};
  assign _zz__zz_when_Fp32Unit_l148_11_28 = (_zz_when_Fp32Unit_l148_9 >>> 4'd8);
  assign _zz__zz_when_Fp32Unit_l148_11_30 = (|_zz_when_Fp32Unit_l148_9[7 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_29 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_30};
  assign _zz__zz_when_Fp32Unit_l148_11_32 = (_zz_when_Fp32Unit_l148_9 >>> 4'd9);
  assign _zz__zz_when_Fp32Unit_l148_11_31 = {1'd0, _zz__zz_when_Fp32Unit_l148_11_32};
  assign _zz__zz_when_Fp32Unit_l148_11_34 = (|_zz_when_Fp32Unit_l148_9[8 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_33 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_34};
  assign _zz__zz_when_Fp32Unit_l148_11_36 = (_zz_when_Fp32Unit_l148_9 >>> 4'd10);
  assign _zz__zz_when_Fp32Unit_l148_11_35 = {2'd0, _zz__zz_when_Fp32Unit_l148_11_36};
  assign _zz__zz_when_Fp32Unit_l148_11_38 = (|_zz_when_Fp32Unit_l148_9[9 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_37 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_38};
  assign _zz__zz_when_Fp32Unit_l148_11_40 = (_zz_when_Fp32Unit_l148_9 >>> 4'd11);
  assign _zz__zz_when_Fp32Unit_l148_11_39 = {3'd0, _zz__zz_when_Fp32Unit_l148_11_40};
  assign _zz__zz_when_Fp32Unit_l148_11_42 = (|_zz_when_Fp32Unit_l148_9[10 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_41 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_42};
  assign _zz__zz_when_Fp32Unit_l148_11_44 = (_zz_when_Fp32Unit_l148_9 >>> 4'd12);
  assign _zz__zz_when_Fp32Unit_l148_11_43 = {4'd0, _zz__zz_when_Fp32Unit_l148_11_44};
  assign _zz__zz_when_Fp32Unit_l148_11_46 = (|_zz_when_Fp32Unit_l148_9[11 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_45 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_46};
  assign _zz__zz_when_Fp32Unit_l148_11_48 = (_zz_when_Fp32Unit_l148_9 >>> 4'd13);
  assign _zz__zz_when_Fp32Unit_l148_11_47 = {5'd0, _zz__zz_when_Fp32Unit_l148_11_48};
  assign _zz__zz_when_Fp32Unit_l148_11_50 = (|_zz_when_Fp32Unit_l148_9[12 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_49 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_50};
  assign _zz__zz_when_Fp32Unit_l148_11_52 = (_zz_when_Fp32Unit_l148_9 >>> 4'd14);
  assign _zz__zz_when_Fp32Unit_l148_11_51 = {6'd0, _zz__zz_when_Fp32Unit_l148_11_52};
  assign _zz__zz_when_Fp32Unit_l148_11_54 = (|_zz_when_Fp32Unit_l148_9[13 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_53 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_54};
  assign _zz__zz_when_Fp32Unit_l148_11_56 = (_zz_when_Fp32Unit_l148_9 >>> 4'd15);
  assign _zz__zz_when_Fp32Unit_l148_11_55 = {7'd0, _zz__zz_when_Fp32Unit_l148_11_56};
  assign _zz__zz_when_Fp32Unit_l148_11_58 = (|_zz_when_Fp32Unit_l148_9[14 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_57 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_58};
  assign _zz__zz_when_Fp32Unit_l148_11_60 = (_zz_when_Fp32Unit_l148_9 >>> 5'd16);
  assign _zz__zz_when_Fp32Unit_l148_11_59 = {8'd0, _zz__zz_when_Fp32Unit_l148_11_60};
  assign _zz__zz_when_Fp32Unit_l148_11_62 = (|_zz_when_Fp32Unit_l148_9[15 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_61 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_62};
  assign _zz__zz_when_Fp32Unit_l148_11_64 = (_zz_when_Fp32Unit_l148_9 >>> 5'd17);
  assign _zz__zz_when_Fp32Unit_l148_11_63 = {9'd0, _zz__zz_when_Fp32Unit_l148_11_64};
  assign _zz__zz_when_Fp32Unit_l148_11_66 = (|_zz_when_Fp32Unit_l148_9[16 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_65 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_66};
  assign _zz__zz_when_Fp32Unit_l148_11_68 = (_zz_when_Fp32Unit_l148_9 >>> 5'd18);
  assign _zz__zz_when_Fp32Unit_l148_11_67 = {10'd0, _zz__zz_when_Fp32Unit_l148_11_68};
  assign _zz__zz_when_Fp32Unit_l148_11_70 = (|_zz_when_Fp32Unit_l148_9[17 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_69 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_70};
  assign _zz__zz_when_Fp32Unit_l148_11_72 = (_zz_when_Fp32Unit_l148_9 >>> 5'd19);
  assign _zz__zz_when_Fp32Unit_l148_11_71 = {11'd0, _zz__zz_when_Fp32Unit_l148_11_72};
  assign _zz__zz_when_Fp32Unit_l148_11_74 = (|_zz_when_Fp32Unit_l148_9[18 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_73 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_74};
  assign _zz__zz_when_Fp32Unit_l148_11_76 = (_zz_when_Fp32Unit_l148_9 >>> 5'd20);
  assign _zz__zz_when_Fp32Unit_l148_11_75 = {12'd0, _zz__zz_when_Fp32Unit_l148_11_76};
  assign _zz__zz_when_Fp32Unit_l148_11_78 = (|_zz_when_Fp32Unit_l148_9[19 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_77 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_78};
  assign _zz__zz_when_Fp32Unit_l148_11_80 = (_zz_when_Fp32Unit_l148_9 >>> 5'd21);
  assign _zz__zz_when_Fp32Unit_l148_11_79 = {13'd0, _zz__zz_when_Fp32Unit_l148_11_80};
  assign _zz__zz_when_Fp32Unit_l148_11_82 = (|_zz_when_Fp32Unit_l148_9[20 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_81 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_82};
  assign _zz__zz_when_Fp32Unit_l148_11_84 = (_zz_when_Fp32Unit_l148_9 >>> 5'd22);
  assign _zz__zz_when_Fp32Unit_l148_11_83 = {14'd0, _zz__zz_when_Fp32Unit_l148_11_84};
  assign _zz__zz_when_Fp32Unit_l148_11_86 = (|_zz_when_Fp32Unit_l148_9[21 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_85 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_86};
  assign _zz__zz_when_Fp32Unit_l148_11_88 = (_zz_when_Fp32Unit_l148_9 >>> 5'd23);
  assign _zz__zz_when_Fp32Unit_l148_11_87 = {15'd0, _zz__zz_when_Fp32Unit_l148_11_88};
  assign _zz__zz_when_Fp32Unit_l148_11_90 = (|_zz_when_Fp32Unit_l148_9[22 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_89 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_90};
  assign _zz__zz_when_Fp32Unit_l148_11_92 = (_zz_when_Fp32Unit_l148_9 >>> 5'd24);
  assign _zz__zz_when_Fp32Unit_l148_11_91 = {16'd0, _zz__zz_when_Fp32Unit_l148_11_92};
  assign _zz__zz_when_Fp32Unit_l148_11_94 = (|_zz_when_Fp32Unit_l148_9[23 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_93 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_94};
  assign _zz__zz_when_Fp32Unit_l148_11_96 = (_zz_when_Fp32Unit_l148_9 >>> 5'd25);
  assign _zz__zz_when_Fp32Unit_l148_11_95 = {17'd0, _zz__zz_when_Fp32Unit_l148_11_96};
  assign _zz__zz_when_Fp32Unit_l148_11_98 = (|_zz_when_Fp32Unit_l148_9[24 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_97 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_98};
  assign _zz__zz_when_Fp32Unit_l148_11_100 = (_zz_when_Fp32Unit_l148_9 >>> 5'd26);
  assign _zz__zz_when_Fp32Unit_l148_11_99 = {18'd0, _zz__zz_when_Fp32Unit_l148_11_100};
  assign _zz__zz_when_Fp32Unit_l148_11_102 = (|_zz_when_Fp32Unit_l148_9[25 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_101 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_102};
  assign _zz__zz_when_Fp32Unit_l148_11_104 = (_zz_when_Fp32Unit_l148_9 >>> 5'd27);
  assign _zz__zz_when_Fp32Unit_l148_11_103 = {19'd0, _zz__zz_when_Fp32Unit_l148_11_104};
  assign _zz__zz_when_Fp32Unit_l148_11_106 = (|_zz_when_Fp32Unit_l148_9[26 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_105 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_106};
  assign _zz__zz_when_Fp32Unit_l148_11_108 = (_zz_when_Fp32Unit_l148_9 >>> 5'd28);
  assign _zz__zz_when_Fp32Unit_l148_11_107 = {20'd0, _zz__zz_when_Fp32Unit_l148_11_108};
  assign _zz__zz_when_Fp32Unit_l148_11_110 = (|_zz_when_Fp32Unit_l148_9[27 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_109 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_110};
  assign _zz__zz_when_Fp32Unit_l148_11_112 = (_zz_when_Fp32Unit_l148_9 >>> 5'd29);
  assign _zz__zz_when_Fp32Unit_l148_11_111 = {21'd0, _zz__zz_when_Fp32Unit_l148_11_112};
  assign _zz__zz_when_Fp32Unit_l148_11_114 = (|_zz_when_Fp32Unit_l148_9[28 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_113 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_114};
  assign _zz__zz_when_Fp32Unit_l148_11_116 = (_zz_when_Fp32Unit_l148_9 >>> 5'd30);
  assign _zz__zz_when_Fp32Unit_l148_11_115 = {22'd0, _zz__zz_when_Fp32Unit_l148_11_116};
  assign _zz__zz_when_Fp32Unit_l148_11_118 = (|_zz_when_Fp32Unit_l148_9[29 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_117 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_118};
  assign _zz__zz_when_Fp32Unit_l148_11_120 = (_zz_when_Fp32Unit_l148_9 >>> 5'd31);
  assign _zz__zz_when_Fp32Unit_l148_11_119 = {23'd0, _zz__zz_when_Fp32Unit_l148_11_120};
  assign _zz__zz_when_Fp32Unit_l148_11_122 = (|_zz_when_Fp32Unit_l148_9[30 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_121 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_122};
  assign _zz__zz_when_Fp32Unit_l148_11_124 = (_zz_when_Fp32Unit_l148_9 >>> 6'd32);
  assign _zz__zz_when_Fp32Unit_l148_11_123 = {24'd0, _zz__zz_when_Fp32Unit_l148_11_124};
  assign _zz__zz_when_Fp32Unit_l148_11_126 = (|_zz_when_Fp32Unit_l148_9[31 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_125 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_126};
  assign _zz__zz_when_Fp32Unit_l148_11_128 = (_zz_when_Fp32Unit_l148_9 >>> 6'd33);
  assign _zz__zz_when_Fp32Unit_l148_11_127 = {25'd0, _zz__zz_when_Fp32Unit_l148_11_128};
  assign _zz__zz_when_Fp32Unit_l148_11_130 = (|_zz_when_Fp32Unit_l148_9[32 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_129 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_130};
  assign _zz__zz_when_Fp32Unit_l148_11_132 = (_zz_when_Fp32Unit_l148_9 >>> 6'd34);
  assign _zz__zz_when_Fp32Unit_l148_11_131 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_132};
  assign _zz__zz_when_Fp32Unit_l148_11_134 = (|_zz_when_Fp32Unit_l148_9[33 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_11_133 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_134};
  assign _zz__zz_when_Fp32Unit_l148_11_135 = (|_zz_when_Fp32Unit_l148_9);
  assign _zz__zz_when_Fp32Unit_l124_1 = {5'd0, _zz_when_Fp32Unit_l184};
  assign _zz__zz_when_Fp32Unit_l67_3 = ($signed(10'h382) - $signed(_zz_when_Fp32Unit_l124_1));
  assign _zz__zz_when_Fp32Unit_l148_13_1 = (_zz_when_Fp32Unit_l148_10 >>> 1'd1);
  assign _zz__zz_when_Fp32Unit_l148_13 = {1'd0, _zz__zz_when_Fp32Unit_l148_13_1};
  assign _zz__zz_when_Fp32Unit_l148_13_3 = (|_zz_when_Fp32Unit_l148_10[0 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_2 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_3};
  assign _zz__zz_when_Fp32Unit_l148_13_5 = (_zz_when_Fp32Unit_l148_10 >>> 2'd2);
  assign _zz__zz_when_Fp32Unit_l148_13_4 = {2'd0, _zz__zz_when_Fp32Unit_l148_13_5};
  assign _zz__zz_when_Fp32Unit_l148_13_7 = (|_zz_when_Fp32Unit_l148_10[1 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_7};
  assign _zz__zz_when_Fp32Unit_l148_13_9 = (_zz_when_Fp32Unit_l148_10 >>> 2'd3);
  assign _zz__zz_when_Fp32Unit_l148_13_8 = {3'd0, _zz__zz_when_Fp32Unit_l148_13_9};
  assign _zz__zz_when_Fp32Unit_l148_13_11 = (|_zz_when_Fp32Unit_l148_10[2 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_10 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_11};
  assign _zz__zz_when_Fp32Unit_l148_13_13 = (_zz_when_Fp32Unit_l148_10 >>> 3'd4);
  assign _zz__zz_when_Fp32Unit_l148_13_12 = {4'd0, _zz__zz_when_Fp32Unit_l148_13_13};
  assign _zz__zz_when_Fp32Unit_l148_13_15 = (|_zz_when_Fp32Unit_l148_10[3 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_14 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_15};
  assign _zz__zz_when_Fp32Unit_l148_13_17 = (_zz_when_Fp32Unit_l148_10 >>> 3'd5);
  assign _zz__zz_when_Fp32Unit_l148_13_16 = {5'd0, _zz__zz_when_Fp32Unit_l148_13_17};
  assign _zz__zz_when_Fp32Unit_l148_13_19 = (|_zz_when_Fp32Unit_l148_10[4 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_18 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_19};
  assign _zz__zz_when_Fp32Unit_l148_13_21 = (_zz_when_Fp32Unit_l148_10 >>> 3'd6);
  assign _zz__zz_when_Fp32Unit_l148_13_20 = {6'd0, _zz__zz_when_Fp32Unit_l148_13_21};
  assign _zz__zz_when_Fp32Unit_l148_13_23 = (|_zz_when_Fp32Unit_l148_10[5 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_22 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_23};
  assign _zz__zz_when_Fp32Unit_l148_13_25 = (_zz_when_Fp32Unit_l148_10 >>> 3'd7);
  assign _zz__zz_when_Fp32Unit_l148_13_24 = {7'd0, _zz__zz_when_Fp32Unit_l148_13_25};
  assign _zz__zz_when_Fp32Unit_l148_13_27 = (|_zz_when_Fp32Unit_l148_10[6 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_26 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_27};
  assign _zz__zz_when_Fp32Unit_l148_13_29 = (_zz_when_Fp32Unit_l148_10 >>> 4'd8);
  assign _zz__zz_when_Fp32Unit_l148_13_28 = {8'd0, _zz__zz_when_Fp32Unit_l148_13_29};
  assign _zz__zz_when_Fp32Unit_l148_13_31 = (|_zz_when_Fp32Unit_l148_10[7 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_30 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_31};
  assign _zz__zz_when_Fp32Unit_l148_13_33 = (_zz_when_Fp32Unit_l148_10 >>> 4'd9);
  assign _zz__zz_when_Fp32Unit_l148_13_32 = {9'd0, _zz__zz_when_Fp32Unit_l148_13_33};
  assign _zz__zz_when_Fp32Unit_l148_13_35 = (|_zz_when_Fp32Unit_l148_10[8 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_34 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_35};
  assign _zz__zz_when_Fp32Unit_l148_13_37 = (_zz_when_Fp32Unit_l148_10 >>> 4'd10);
  assign _zz__zz_when_Fp32Unit_l148_13_36 = {10'd0, _zz__zz_when_Fp32Unit_l148_13_37};
  assign _zz__zz_when_Fp32Unit_l148_13_39 = (|_zz_when_Fp32Unit_l148_10[9 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_38 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_39};
  assign _zz__zz_when_Fp32Unit_l148_13_41 = (_zz_when_Fp32Unit_l148_10 >>> 4'd11);
  assign _zz__zz_when_Fp32Unit_l148_13_40 = {11'd0, _zz__zz_when_Fp32Unit_l148_13_41};
  assign _zz__zz_when_Fp32Unit_l148_13_43 = (|_zz_when_Fp32Unit_l148_10[10 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_42 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_43};
  assign _zz__zz_when_Fp32Unit_l148_13_45 = (_zz_when_Fp32Unit_l148_10 >>> 4'd12);
  assign _zz__zz_when_Fp32Unit_l148_13_44 = {12'd0, _zz__zz_when_Fp32Unit_l148_13_45};
  assign _zz__zz_when_Fp32Unit_l148_13_47 = (|_zz_when_Fp32Unit_l148_10[11 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_46 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_47};
  assign _zz__zz_when_Fp32Unit_l148_13_49 = (_zz_when_Fp32Unit_l148_10 >>> 4'd13);
  assign _zz__zz_when_Fp32Unit_l148_13_48 = {13'd0, _zz__zz_when_Fp32Unit_l148_13_49};
  assign _zz__zz_when_Fp32Unit_l148_13_51 = (|_zz_when_Fp32Unit_l148_10[12 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_50 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_51};
  assign _zz__zz_when_Fp32Unit_l148_13_53 = (_zz_when_Fp32Unit_l148_10 >>> 4'd14);
  assign _zz__zz_when_Fp32Unit_l148_13_52 = {14'd0, _zz__zz_when_Fp32Unit_l148_13_53};
  assign _zz__zz_when_Fp32Unit_l148_13_55 = (|_zz_when_Fp32Unit_l148_10[13 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_54 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_55};
  assign _zz__zz_when_Fp32Unit_l148_13_57 = (_zz_when_Fp32Unit_l148_10 >>> 4'd15);
  assign _zz__zz_when_Fp32Unit_l148_13_56 = {15'd0, _zz__zz_when_Fp32Unit_l148_13_57};
  assign _zz__zz_when_Fp32Unit_l148_13_59 = (|_zz_when_Fp32Unit_l148_10[14 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_58 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_59};
  assign _zz__zz_when_Fp32Unit_l148_13_61 = (_zz_when_Fp32Unit_l148_10 >>> 5'd16);
  assign _zz__zz_when_Fp32Unit_l148_13_60 = {16'd0, _zz__zz_when_Fp32Unit_l148_13_61};
  assign _zz__zz_when_Fp32Unit_l148_13_63 = (|_zz_when_Fp32Unit_l148_10[15 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_62 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_63};
  assign _zz__zz_when_Fp32Unit_l148_13_65 = (_zz_when_Fp32Unit_l148_10 >>> 5'd17);
  assign _zz__zz_when_Fp32Unit_l148_13_64 = {17'd0, _zz__zz_when_Fp32Unit_l148_13_65};
  assign _zz__zz_when_Fp32Unit_l148_13_67 = (|_zz_when_Fp32Unit_l148_10[16 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_66 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_67};
  assign _zz__zz_when_Fp32Unit_l148_13_69 = (_zz_when_Fp32Unit_l148_10 >>> 5'd18);
  assign _zz__zz_when_Fp32Unit_l148_13_68 = {18'd0, _zz__zz_when_Fp32Unit_l148_13_69};
  assign _zz__zz_when_Fp32Unit_l148_13_71 = (|_zz_when_Fp32Unit_l148_10[17 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_70 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_71};
  assign _zz__zz_when_Fp32Unit_l148_13_73 = (_zz_when_Fp32Unit_l148_10 >>> 5'd19);
  assign _zz__zz_when_Fp32Unit_l148_13_72 = {19'd0, _zz__zz_when_Fp32Unit_l148_13_73};
  assign _zz__zz_when_Fp32Unit_l148_13_75 = (|_zz_when_Fp32Unit_l148_10[18 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_74 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_75};
  assign _zz__zz_when_Fp32Unit_l148_13_77 = (_zz_when_Fp32Unit_l148_10 >>> 5'd20);
  assign _zz__zz_when_Fp32Unit_l148_13_76 = {20'd0, _zz__zz_when_Fp32Unit_l148_13_77};
  assign _zz__zz_when_Fp32Unit_l148_13_79 = (|_zz_when_Fp32Unit_l148_10[19 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_78 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_79};
  assign _zz__zz_when_Fp32Unit_l148_13_81 = (_zz_when_Fp32Unit_l148_10 >>> 5'd21);
  assign _zz__zz_when_Fp32Unit_l148_13_80 = {21'd0, _zz__zz_when_Fp32Unit_l148_13_81};
  assign _zz__zz_when_Fp32Unit_l148_13_83 = (|_zz_when_Fp32Unit_l148_10[20 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_82 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_83};
  assign _zz__zz_when_Fp32Unit_l148_13_85 = (_zz_when_Fp32Unit_l148_10 >>> 5'd22);
  assign _zz__zz_when_Fp32Unit_l148_13_84 = {22'd0, _zz__zz_when_Fp32Unit_l148_13_85};
  assign _zz__zz_when_Fp32Unit_l148_13_87 = (|_zz_when_Fp32Unit_l148_10[21 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_86 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_87};
  assign _zz__zz_when_Fp32Unit_l148_13_89 = (_zz_when_Fp32Unit_l148_10 >>> 5'd23);
  assign _zz__zz_when_Fp32Unit_l148_13_88 = {23'd0, _zz__zz_when_Fp32Unit_l148_13_89};
  assign _zz__zz_when_Fp32Unit_l148_13_91 = (|_zz_when_Fp32Unit_l148_10[22 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_90 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_91};
  assign _zz__zz_when_Fp32Unit_l148_13_93 = (_zz_when_Fp32Unit_l148_10 >>> 5'd24);
  assign _zz__zz_when_Fp32Unit_l148_13_92 = {24'd0, _zz__zz_when_Fp32Unit_l148_13_93};
  assign _zz__zz_when_Fp32Unit_l148_13_95 = (|_zz_when_Fp32Unit_l148_10[23 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_94 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_95};
  assign _zz__zz_when_Fp32Unit_l148_13_97 = (_zz_when_Fp32Unit_l148_10 >>> 5'd25);
  assign _zz__zz_when_Fp32Unit_l148_13_96 = {25'd0, _zz__zz_when_Fp32Unit_l148_13_97};
  assign _zz__zz_when_Fp32Unit_l148_13_99 = (|_zz_when_Fp32Unit_l148_10[24 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_98 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_99};
  assign _zz__zz_when_Fp32Unit_l148_13_101 = (_zz_when_Fp32Unit_l148_10 >>> 5'd26);
  assign _zz__zz_when_Fp32Unit_l148_13_100 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_101};
  assign _zz__zz_when_Fp32Unit_l148_13_103 = (|_zz_when_Fp32Unit_l148_10[25 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_13_102 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_103};
  assign _zz__zz_when_Fp32Unit_l148_13_104 = (|_zz_when_Fp32Unit_l148_10);
  assign _zz__zz_when_Fp32Unit_l148_13_105 = (|_zz_when_Fp32Unit_l148_10);
  assign _zz__zz_when_Fp32Unit_l148_13_106 = (|_zz_when_Fp32Unit_l148_10);
  assign _zz__zz_when_Fp32Unit_l148_13_107 = (|_zz_when_Fp32Unit_l148_10);
  assign _zz__zz_when_Fp32Unit_l148_13_108 = (|_zz_when_Fp32Unit_l148_10);
  assign _zz__zz_when_Fp32Unit_l148_13_109 = (|_zz_when_Fp32Unit_l148_10);
  assign _zz__zz_when_Fp32Unit_l148_15 = {1'd0, _zz_when_Fp32Unit_l148_14};
  assign _zz__zz_when_Fp32Unit_l148_15_2 = (_zz_when_Fp32Unit_l148_12[2] && ((_zz_when_Fp32Unit_l148_12[1] || _zz_when_Fp32Unit_l148_12[0]) || _zz_when_Fp32Unit_l148_14[0]));
  assign _zz__zz_when_Fp32Unit_l148_15_1 = {24'd0, _zz__zz_when_Fp32Unit_l148_15_2};
  assign _zz__zz_i2fResult_2 = _zz__zz_i2fResult_2_1;
  assign _zz__zz_i2fResult_2_1 = ($signed(_zz_when_Fp32Unit_l161_5) + $signed(10'h07f));
  assign _zz__zz_when_Fp32Unit_l148_16 = {3'd0, io_a};
  assign _zz__zz_when_Fp32Unit_l148_17 = (_zz_when_Fp32Unit_l148_16 <<< _zz__zz_when_Fp32Unit_l148_17_1);
  assign _zz__zz_when_Fp32Unit_l148_17_2 = (5'h17 - _zz_when_Fp32Unit_l184_1);
  assign _zz__zz_when_Fp32Unit_l148_17_1 = {1'd0, _zz__zz_when_Fp32Unit_l148_17_2};
  assign _zz__zz_when_Fp32Unit_l67_4 = (_zz_when_Fp32Unit_l184_1 - 5'h17);
  assign _zz__zz_when_Fp32Unit_l148_18_1 = (_zz_when_Fp32Unit_l148_16 >>> 1'd1);
  assign _zz__zz_when_Fp32Unit_l148_18 = _zz__zz_when_Fp32Unit_l148_18_1[26:0];
  assign _zz__zz_when_Fp32Unit_l148_18_3 = (|_zz_when_Fp32Unit_l148_16[0 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_2 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_3};
  assign _zz__zz_when_Fp32Unit_l148_18_5 = (_zz_when_Fp32Unit_l148_16 >>> 2'd2);
  assign _zz__zz_when_Fp32Unit_l148_18_4 = _zz__zz_when_Fp32Unit_l148_18_5[26:0];
  assign _zz__zz_when_Fp32Unit_l148_18_7 = (|_zz_when_Fp32Unit_l148_16[1 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_7};
  assign _zz__zz_when_Fp32Unit_l148_18_9 = (_zz_when_Fp32Unit_l148_16 >>> 2'd3);
  assign _zz__zz_when_Fp32Unit_l148_18_8 = _zz__zz_when_Fp32Unit_l148_18_9[26:0];
  assign _zz__zz_when_Fp32Unit_l148_18_11 = (|_zz_when_Fp32Unit_l148_16[2 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_10 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_11};
  assign _zz__zz_when_Fp32Unit_l148_18_13 = (_zz_when_Fp32Unit_l148_16 >>> 3'd4);
  assign _zz__zz_when_Fp32Unit_l148_18_12 = _zz__zz_when_Fp32Unit_l148_18_13[26:0];
  assign _zz__zz_when_Fp32Unit_l148_18_15 = (|_zz_when_Fp32Unit_l148_16[3 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_14 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_15};
  assign _zz__zz_when_Fp32Unit_l148_18_17 = (_zz_when_Fp32Unit_l148_16 >>> 3'd5);
  assign _zz__zz_when_Fp32Unit_l148_18_16 = _zz__zz_when_Fp32Unit_l148_18_17[26:0];
  assign _zz__zz_when_Fp32Unit_l148_18_19 = (|_zz_when_Fp32Unit_l148_16[4 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_18 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_19};
  assign _zz__zz_when_Fp32Unit_l148_18_21 = (_zz_when_Fp32Unit_l148_16 >>> 3'd6);
  assign _zz__zz_when_Fp32Unit_l148_18_20 = _zz__zz_when_Fp32Unit_l148_18_21[26:0];
  assign _zz__zz_when_Fp32Unit_l148_18_23 = (|_zz_when_Fp32Unit_l148_16[5 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_22 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_23};
  assign _zz__zz_when_Fp32Unit_l148_18_25 = (_zz_when_Fp32Unit_l148_16 >>> 3'd7);
  assign _zz__zz_when_Fp32Unit_l148_18_24 = _zz__zz_when_Fp32Unit_l148_18_25[26:0];
  assign _zz__zz_when_Fp32Unit_l148_18_27 = (|_zz_when_Fp32Unit_l148_16[6 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_26 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_27};
  assign _zz__zz_when_Fp32Unit_l148_18_28 = (_zz_when_Fp32Unit_l148_16 >>> 4'd8);
  assign _zz__zz_when_Fp32Unit_l148_18_30 = (|_zz_when_Fp32Unit_l148_16[7 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_29 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_30};
  assign _zz__zz_when_Fp32Unit_l148_18_32 = (_zz_when_Fp32Unit_l148_16 >>> 4'd9);
  assign _zz__zz_when_Fp32Unit_l148_18_31 = {1'd0, _zz__zz_when_Fp32Unit_l148_18_32};
  assign _zz__zz_when_Fp32Unit_l148_18_34 = (|_zz_when_Fp32Unit_l148_16[8 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_33 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_34};
  assign _zz__zz_when_Fp32Unit_l148_18_36 = (_zz_when_Fp32Unit_l148_16 >>> 4'd10);
  assign _zz__zz_when_Fp32Unit_l148_18_35 = {2'd0, _zz__zz_when_Fp32Unit_l148_18_36};
  assign _zz__zz_when_Fp32Unit_l148_18_38 = (|_zz_when_Fp32Unit_l148_16[9 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_37 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_38};
  assign _zz__zz_when_Fp32Unit_l148_18_40 = (_zz_when_Fp32Unit_l148_16 >>> 4'd11);
  assign _zz__zz_when_Fp32Unit_l148_18_39 = {3'd0, _zz__zz_when_Fp32Unit_l148_18_40};
  assign _zz__zz_when_Fp32Unit_l148_18_42 = (|_zz_when_Fp32Unit_l148_16[10 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_41 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_42};
  assign _zz__zz_when_Fp32Unit_l148_18_44 = (_zz_when_Fp32Unit_l148_16 >>> 4'd12);
  assign _zz__zz_when_Fp32Unit_l148_18_43 = {4'd0, _zz__zz_when_Fp32Unit_l148_18_44};
  assign _zz__zz_when_Fp32Unit_l148_18_46 = (|_zz_when_Fp32Unit_l148_16[11 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_45 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_46};
  assign _zz__zz_when_Fp32Unit_l148_18_48 = (_zz_when_Fp32Unit_l148_16 >>> 4'd13);
  assign _zz__zz_when_Fp32Unit_l148_18_47 = {5'd0, _zz__zz_when_Fp32Unit_l148_18_48};
  assign _zz__zz_when_Fp32Unit_l148_18_50 = (|_zz_when_Fp32Unit_l148_16[12 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_49 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_50};
  assign _zz__zz_when_Fp32Unit_l148_18_52 = (_zz_when_Fp32Unit_l148_16 >>> 4'd14);
  assign _zz__zz_when_Fp32Unit_l148_18_51 = {6'd0, _zz__zz_when_Fp32Unit_l148_18_52};
  assign _zz__zz_when_Fp32Unit_l148_18_54 = (|_zz_when_Fp32Unit_l148_16[13 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_53 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_54};
  assign _zz__zz_when_Fp32Unit_l148_18_56 = (_zz_when_Fp32Unit_l148_16 >>> 4'd15);
  assign _zz__zz_when_Fp32Unit_l148_18_55 = {7'd0, _zz__zz_when_Fp32Unit_l148_18_56};
  assign _zz__zz_when_Fp32Unit_l148_18_58 = (|_zz_when_Fp32Unit_l148_16[14 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_57 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_58};
  assign _zz__zz_when_Fp32Unit_l148_18_60 = (_zz_when_Fp32Unit_l148_16 >>> 5'd16);
  assign _zz__zz_when_Fp32Unit_l148_18_59 = {8'd0, _zz__zz_when_Fp32Unit_l148_18_60};
  assign _zz__zz_when_Fp32Unit_l148_18_62 = (|_zz_when_Fp32Unit_l148_16[15 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_61 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_62};
  assign _zz__zz_when_Fp32Unit_l148_18_64 = (_zz_when_Fp32Unit_l148_16 >>> 5'd17);
  assign _zz__zz_when_Fp32Unit_l148_18_63 = {9'd0, _zz__zz_when_Fp32Unit_l148_18_64};
  assign _zz__zz_when_Fp32Unit_l148_18_66 = (|_zz_when_Fp32Unit_l148_16[16 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_65 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_66};
  assign _zz__zz_when_Fp32Unit_l148_18_68 = (_zz_when_Fp32Unit_l148_16 >>> 5'd18);
  assign _zz__zz_when_Fp32Unit_l148_18_67 = {10'd0, _zz__zz_when_Fp32Unit_l148_18_68};
  assign _zz__zz_when_Fp32Unit_l148_18_70 = (|_zz_when_Fp32Unit_l148_16[17 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_69 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_70};
  assign _zz__zz_when_Fp32Unit_l148_18_72 = (_zz_when_Fp32Unit_l148_16 >>> 5'd19);
  assign _zz__zz_when_Fp32Unit_l148_18_71 = {11'd0, _zz__zz_when_Fp32Unit_l148_18_72};
  assign _zz__zz_when_Fp32Unit_l148_18_74 = (|_zz_when_Fp32Unit_l148_16[18 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_73 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_74};
  assign _zz__zz_when_Fp32Unit_l148_18_76 = (_zz_when_Fp32Unit_l148_16 >>> 5'd20);
  assign _zz__zz_when_Fp32Unit_l148_18_75 = {12'd0, _zz__zz_when_Fp32Unit_l148_18_76};
  assign _zz__zz_when_Fp32Unit_l148_18_78 = (|_zz_when_Fp32Unit_l148_16[19 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_77 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_78};
  assign _zz__zz_when_Fp32Unit_l148_18_80 = (_zz_when_Fp32Unit_l148_16 >>> 5'd21);
  assign _zz__zz_when_Fp32Unit_l148_18_79 = {13'd0, _zz__zz_when_Fp32Unit_l148_18_80};
  assign _zz__zz_when_Fp32Unit_l148_18_82 = (|_zz_when_Fp32Unit_l148_16[20 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_81 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_82};
  assign _zz__zz_when_Fp32Unit_l148_18_84 = (_zz_when_Fp32Unit_l148_16 >>> 5'd22);
  assign _zz__zz_when_Fp32Unit_l148_18_83 = {14'd0, _zz__zz_when_Fp32Unit_l148_18_84};
  assign _zz__zz_when_Fp32Unit_l148_18_86 = (|_zz_when_Fp32Unit_l148_16[21 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_85 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_86};
  assign _zz__zz_when_Fp32Unit_l148_18_88 = (_zz_when_Fp32Unit_l148_16 >>> 5'd23);
  assign _zz__zz_when_Fp32Unit_l148_18_87 = {15'd0, _zz__zz_when_Fp32Unit_l148_18_88};
  assign _zz__zz_when_Fp32Unit_l148_18_90 = (|_zz_when_Fp32Unit_l148_16[22 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_89 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_90};
  assign _zz__zz_when_Fp32Unit_l148_18_92 = (_zz_when_Fp32Unit_l148_16 >>> 5'd24);
  assign _zz__zz_when_Fp32Unit_l148_18_91 = {16'd0, _zz__zz_when_Fp32Unit_l148_18_92};
  assign _zz__zz_when_Fp32Unit_l148_18_94 = (|_zz_when_Fp32Unit_l148_16[23 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_93 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_94};
  assign _zz__zz_when_Fp32Unit_l148_18_96 = (_zz_when_Fp32Unit_l148_16 >>> 5'd25);
  assign _zz__zz_when_Fp32Unit_l148_18_95 = {17'd0, _zz__zz_when_Fp32Unit_l148_18_96};
  assign _zz__zz_when_Fp32Unit_l148_18_98 = (|_zz_when_Fp32Unit_l148_16[24 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_97 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_98};
  assign _zz__zz_when_Fp32Unit_l148_18_100 = (_zz_when_Fp32Unit_l148_16 >>> 5'd26);
  assign _zz__zz_when_Fp32Unit_l148_18_99 = {18'd0, _zz__zz_when_Fp32Unit_l148_18_100};
  assign _zz__zz_when_Fp32Unit_l148_18_102 = (|_zz_when_Fp32Unit_l148_16[25 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_101 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_102};
  assign _zz__zz_when_Fp32Unit_l148_18_104 = (_zz_when_Fp32Unit_l148_16 >>> 5'd27);
  assign _zz__zz_when_Fp32Unit_l148_18_103 = {19'd0, _zz__zz_when_Fp32Unit_l148_18_104};
  assign _zz__zz_when_Fp32Unit_l148_18_106 = (|_zz_when_Fp32Unit_l148_16[26 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_105 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_106};
  assign _zz__zz_when_Fp32Unit_l148_18_108 = (_zz_when_Fp32Unit_l148_16 >>> 5'd28);
  assign _zz__zz_when_Fp32Unit_l148_18_107 = {20'd0, _zz__zz_when_Fp32Unit_l148_18_108};
  assign _zz__zz_when_Fp32Unit_l148_18_110 = (|_zz_when_Fp32Unit_l148_16[27 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_109 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_110};
  assign _zz__zz_when_Fp32Unit_l148_18_112 = (_zz_when_Fp32Unit_l148_16 >>> 5'd29);
  assign _zz__zz_when_Fp32Unit_l148_18_111 = {21'd0, _zz__zz_when_Fp32Unit_l148_18_112};
  assign _zz__zz_when_Fp32Unit_l148_18_114 = (|_zz_when_Fp32Unit_l148_16[28 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_113 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_114};
  assign _zz__zz_when_Fp32Unit_l148_18_116 = (_zz_when_Fp32Unit_l148_16 >>> 5'd30);
  assign _zz__zz_when_Fp32Unit_l148_18_115 = {22'd0, _zz__zz_when_Fp32Unit_l148_18_116};
  assign _zz__zz_when_Fp32Unit_l148_18_118 = (|_zz_when_Fp32Unit_l148_16[29 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_117 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_118};
  assign _zz__zz_when_Fp32Unit_l148_18_120 = (_zz_when_Fp32Unit_l148_16 >>> 5'd31);
  assign _zz__zz_when_Fp32Unit_l148_18_119 = {23'd0, _zz__zz_when_Fp32Unit_l148_18_120};
  assign _zz__zz_when_Fp32Unit_l148_18_122 = (|_zz_when_Fp32Unit_l148_16[30 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_121 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_122};
  assign _zz__zz_when_Fp32Unit_l148_18_124 = (_zz_when_Fp32Unit_l148_16 >>> 6'd32);
  assign _zz__zz_when_Fp32Unit_l148_18_123 = {24'd0, _zz__zz_when_Fp32Unit_l148_18_124};
  assign _zz__zz_when_Fp32Unit_l148_18_126 = (|_zz_when_Fp32Unit_l148_16[31 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_125 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_126};
  assign _zz__zz_when_Fp32Unit_l148_18_128 = (_zz_when_Fp32Unit_l148_16 >>> 6'd33);
  assign _zz__zz_when_Fp32Unit_l148_18_127 = {25'd0, _zz__zz_when_Fp32Unit_l148_18_128};
  assign _zz__zz_when_Fp32Unit_l148_18_130 = (|_zz_when_Fp32Unit_l148_16[32 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_129 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_130};
  assign _zz__zz_when_Fp32Unit_l148_18_132 = (_zz_when_Fp32Unit_l148_16 >>> 6'd34);
  assign _zz__zz_when_Fp32Unit_l148_18_131 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_132};
  assign _zz__zz_when_Fp32Unit_l148_18_134 = (|_zz_when_Fp32Unit_l148_16[33 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_18_133 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_134};
  assign _zz__zz_when_Fp32Unit_l148_18_135 = (|_zz_when_Fp32Unit_l148_16);
  assign _zz__zz_when_Fp32Unit_l124_2 = {5'd0, _zz_when_Fp32Unit_l184_1};
  assign _zz__zz_when_Fp32Unit_l67_5 = ($signed(10'h382) - $signed(_zz_when_Fp32Unit_l124_2));
  assign _zz__zz_when_Fp32Unit_l148_20_1 = (_zz_when_Fp32Unit_l148_17 >>> 1'd1);
  assign _zz__zz_when_Fp32Unit_l148_20 = {1'd0, _zz__zz_when_Fp32Unit_l148_20_1};
  assign _zz__zz_when_Fp32Unit_l148_20_3 = (|_zz_when_Fp32Unit_l148_17[0 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_2 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_3};
  assign _zz__zz_when_Fp32Unit_l148_20_5 = (_zz_when_Fp32Unit_l148_17 >>> 2'd2);
  assign _zz__zz_when_Fp32Unit_l148_20_4 = {2'd0, _zz__zz_when_Fp32Unit_l148_20_5};
  assign _zz__zz_when_Fp32Unit_l148_20_7 = (|_zz_when_Fp32Unit_l148_17[1 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_7};
  assign _zz__zz_when_Fp32Unit_l148_20_9 = (_zz_when_Fp32Unit_l148_17 >>> 2'd3);
  assign _zz__zz_when_Fp32Unit_l148_20_8 = {3'd0, _zz__zz_when_Fp32Unit_l148_20_9};
  assign _zz__zz_when_Fp32Unit_l148_20_11 = (|_zz_when_Fp32Unit_l148_17[2 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_10 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_11};
  assign _zz__zz_when_Fp32Unit_l148_20_13 = (_zz_when_Fp32Unit_l148_17 >>> 3'd4);
  assign _zz__zz_when_Fp32Unit_l148_20_12 = {4'd0, _zz__zz_when_Fp32Unit_l148_20_13};
  assign _zz__zz_when_Fp32Unit_l148_20_15 = (|_zz_when_Fp32Unit_l148_17[3 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_14 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_15};
  assign _zz__zz_when_Fp32Unit_l148_20_17 = (_zz_when_Fp32Unit_l148_17 >>> 3'd5);
  assign _zz__zz_when_Fp32Unit_l148_20_16 = {5'd0, _zz__zz_when_Fp32Unit_l148_20_17};
  assign _zz__zz_when_Fp32Unit_l148_20_19 = (|_zz_when_Fp32Unit_l148_17[4 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_18 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_19};
  assign _zz__zz_when_Fp32Unit_l148_20_21 = (_zz_when_Fp32Unit_l148_17 >>> 3'd6);
  assign _zz__zz_when_Fp32Unit_l148_20_20 = {6'd0, _zz__zz_when_Fp32Unit_l148_20_21};
  assign _zz__zz_when_Fp32Unit_l148_20_23 = (|_zz_when_Fp32Unit_l148_17[5 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_22 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_23};
  assign _zz__zz_when_Fp32Unit_l148_20_25 = (_zz_when_Fp32Unit_l148_17 >>> 3'd7);
  assign _zz__zz_when_Fp32Unit_l148_20_24 = {7'd0, _zz__zz_when_Fp32Unit_l148_20_25};
  assign _zz__zz_when_Fp32Unit_l148_20_27 = (|_zz_when_Fp32Unit_l148_17[6 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_26 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_27};
  assign _zz__zz_when_Fp32Unit_l148_20_29 = (_zz_when_Fp32Unit_l148_17 >>> 4'd8);
  assign _zz__zz_when_Fp32Unit_l148_20_28 = {8'd0, _zz__zz_when_Fp32Unit_l148_20_29};
  assign _zz__zz_when_Fp32Unit_l148_20_31 = (|_zz_when_Fp32Unit_l148_17[7 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_30 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_31};
  assign _zz__zz_when_Fp32Unit_l148_20_33 = (_zz_when_Fp32Unit_l148_17 >>> 4'd9);
  assign _zz__zz_when_Fp32Unit_l148_20_32 = {9'd0, _zz__zz_when_Fp32Unit_l148_20_33};
  assign _zz__zz_when_Fp32Unit_l148_20_35 = (|_zz_when_Fp32Unit_l148_17[8 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_34 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_35};
  assign _zz__zz_when_Fp32Unit_l148_20_37 = (_zz_when_Fp32Unit_l148_17 >>> 4'd10);
  assign _zz__zz_when_Fp32Unit_l148_20_36 = {10'd0, _zz__zz_when_Fp32Unit_l148_20_37};
  assign _zz__zz_when_Fp32Unit_l148_20_39 = (|_zz_when_Fp32Unit_l148_17[9 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_38 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_39};
  assign _zz__zz_when_Fp32Unit_l148_20_41 = (_zz_when_Fp32Unit_l148_17 >>> 4'd11);
  assign _zz__zz_when_Fp32Unit_l148_20_40 = {11'd0, _zz__zz_when_Fp32Unit_l148_20_41};
  assign _zz__zz_when_Fp32Unit_l148_20_43 = (|_zz_when_Fp32Unit_l148_17[10 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_42 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_43};
  assign _zz__zz_when_Fp32Unit_l148_20_45 = (_zz_when_Fp32Unit_l148_17 >>> 4'd12);
  assign _zz__zz_when_Fp32Unit_l148_20_44 = {12'd0, _zz__zz_when_Fp32Unit_l148_20_45};
  assign _zz__zz_when_Fp32Unit_l148_20_47 = (|_zz_when_Fp32Unit_l148_17[11 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_46 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_47};
  assign _zz__zz_when_Fp32Unit_l148_20_49 = (_zz_when_Fp32Unit_l148_17 >>> 4'd13);
  assign _zz__zz_when_Fp32Unit_l148_20_48 = {13'd0, _zz__zz_when_Fp32Unit_l148_20_49};
  assign _zz__zz_when_Fp32Unit_l148_20_51 = (|_zz_when_Fp32Unit_l148_17[12 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_50 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_51};
  assign _zz__zz_when_Fp32Unit_l148_20_53 = (_zz_when_Fp32Unit_l148_17 >>> 4'd14);
  assign _zz__zz_when_Fp32Unit_l148_20_52 = {14'd0, _zz__zz_when_Fp32Unit_l148_20_53};
  assign _zz__zz_when_Fp32Unit_l148_20_55 = (|_zz_when_Fp32Unit_l148_17[13 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_54 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_55};
  assign _zz__zz_when_Fp32Unit_l148_20_57 = (_zz_when_Fp32Unit_l148_17 >>> 4'd15);
  assign _zz__zz_when_Fp32Unit_l148_20_56 = {15'd0, _zz__zz_when_Fp32Unit_l148_20_57};
  assign _zz__zz_when_Fp32Unit_l148_20_59 = (|_zz_when_Fp32Unit_l148_17[14 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_58 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_59};
  assign _zz__zz_when_Fp32Unit_l148_20_61 = (_zz_when_Fp32Unit_l148_17 >>> 5'd16);
  assign _zz__zz_when_Fp32Unit_l148_20_60 = {16'd0, _zz__zz_when_Fp32Unit_l148_20_61};
  assign _zz__zz_when_Fp32Unit_l148_20_63 = (|_zz_when_Fp32Unit_l148_17[15 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_62 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_63};
  assign _zz__zz_when_Fp32Unit_l148_20_65 = (_zz_when_Fp32Unit_l148_17 >>> 5'd17);
  assign _zz__zz_when_Fp32Unit_l148_20_64 = {17'd0, _zz__zz_when_Fp32Unit_l148_20_65};
  assign _zz__zz_when_Fp32Unit_l148_20_67 = (|_zz_when_Fp32Unit_l148_17[16 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_66 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_67};
  assign _zz__zz_when_Fp32Unit_l148_20_69 = (_zz_when_Fp32Unit_l148_17 >>> 5'd18);
  assign _zz__zz_when_Fp32Unit_l148_20_68 = {18'd0, _zz__zz_when_Fp32Unit_l148_20_69};
  assign _zz__zz_when_Fp32Unit_l148_20_71 = (|_zz_when_Fp32Unit_l148_17[17 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_70 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_71};
  assign _zz__zz_when_Fp32Unit_l148_20_73 = (_zz_when_Fp32Unit_l148_17 >>> 5'd19);
  assign _zz__zz_when_Fp32Unit_l148_20_72 = {19'd0, _zz__zz_when_Fp32Unit_l148_20_73};
  assign _zz__zz_when_Fp32Unit_l148_20_75 = (|_zz_when_Fp32Unit_l148_17[18 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_74 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_75};
  assign _zz__zz_when_Fp32Unit_l148_20_77 = (_zz_when_Fp32Unit_l148_17 >>> 5'd20);
  assign _zz__zz_when_Fp32Unit_l148_20_76 = {20'd0, _zz__zz_when_Fp32Unit_l148_20_77};
  assign _zz__zz_when_Fp32Unit_l148_20_79 = (|_zz_when_Fp32Unit_l148_17[19 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_78 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_79};
  assign _zz__zz_when_Fp32Unit_l148_20_81 = (_zz_when_Fp32Unit_l148_17 >>> 5'd21);
  assign _zz__zz_when_Fp32Unit_l148_20_80 = {21'd0, _zz__zz_when_Fp32Unit_l148_20_81};
  assign _zz__zz_when_Fp32Unit_l148_20_83 = (|_zz_when_Fp32Unit_l148_17[20 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_82 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_83};
  assign _zz__zz_when_Fp32Unit_l148_20_85 = (_zz_when_Fp32Unit_l148_17 >>> 5'd22);
  assign _zz__zz_when_Fp32Unit_l148_20_84 = {22'd0, _zz__zz_when_Fp32Unit_l148_20_85};
  assign _zz__zz_when_Fp32Unit_l148_20_87 = (|_zz_when_Fp32Unit_l148_17[21 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_86 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_87};
  assign _zz__zz_when_Fp32Unit_l148_20_89 = (_zz_when_Fp32Unit_l148_17 >>> 5'd23);
  assign _zz__zz_when_Fp32Unit_l148_20_88 = {23'd0, _zz__zz_when_Fp32Unit_l148_20_89};
  assign _zz__zz_when_Fp32Unit_l148_20_91 = (|_zz_when_Fp32Unit_l148_17[22 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_90 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_91};
  assign _zz__zz_when_Fp32Unit_l148_20_93 = (_zz_when_Fp32Unit_l148_17 >>> 5'd24);
  assign _zz__zz_when_Fp32Unit_l148_20_92 = {24'd0, _zz__zz_when_Fp32Unit_l148_20_93};
  assign _zz__zz_when_Fp32Unit_l148_20_95 = (|_zz_when_Fp32Unit_l148_17[23 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_94 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_95};
  assign _zz__zz_when_Fp32Unit_l148_20_97 = (_zz_when_Fp32Unit_l148_17 >>> 5'd25);
  assign _zz__zz_when_Fp32Unit_l148_20_96 = {25'd0, _zz__zz_when_Fp32Unit_l148_20_97};
  assign _zz__zz_when_Fp32Unit_l148_20_99 = (|_zz_when_Fp32Unit_l148_17[24 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_98 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_99};
  assign _zz__zz_when_Fp32Unit_l148_20_101 = (_zz_when_Fp32Unit_l148_17 >>> 5'd26);
  assign _zz__zz_when_Fp32Unit_l148_20_100 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_101};
  assign _zz__zz_when_Fp32Unit_l148_20_103 = (|_zz_when_Fp32Unit_l148_17[25 : 0]);
  assign _zz__zz_when_Fp32Unit_l148_20_102 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_103};
  assign _zz__zz_when_Fp32Unit_l148_20_104 = (|_zz_when_Fp32Unit_l148_17);
  assign _zz__zz_when_Fp32Unit_l148_20_105 = (|_zz_when_Fp32Unit_l148_17);
  assign _zz__zz_when_Fp32Unit_l148_20_106 = (|_zz_when_Fp32Unit_l148_17);
  assign _zz__zz_when_Fp32Unit_l148_20_107 = (|_zz_when_Fp32Unit_l148_17);
  assign _zz__zz_when_Fp32Unit_l148_20_108 = (|_zz_when_Fp32Unit_l148_17);
  assign _zz__zz_when_Fp32Unit_l148_20_109 = (|_zz_when_Fp32Unit_l148_17);
  assign _zz__zz_when_Fp32Unit_l148_22 = {1'd0, _zz_when_Fp32Unit_l148_21};
  assign _zz__zz_when_Fp32Unit_l148_22_2 = (_zz_when_Fp32Unit_l148_19[2] && ((_zz_when_Fp32Unit_l148_19[1] || _zz_when_Fp32Unit_l148_19[0]) || _zz_when_Fp32Unit_l148_21[0]));
  assign _zz__zz_when_Fp32Unit_l148_22_1 = {24'd0, _zz__zz_when_Fp32Unit_l148_22_2};
  assign _zz__zz_u2fResult_2 = _zz__zz_u2fResult_2_1;
  assign _zz__zz_u2fResult_2_1 = ($signed(_zz_when_Fp32Unit_l161_7) + $signed(10'h07f));
  assign _zz_intMagnitude = {9'd0, decA_sig};
  assign _zz_intMagnitude_2 = _zz_intMagnitude_3;
  assign _zz_intMagnitude_1 = _zz_intMagnitude_2[5:0];
  assign _zz_intMagnitude_3 = ($signed(decA_exp) - $signed(10'h017));
  assign _zz_intMagnitude_4 = (decA_sig >>> _zz_intMagnitude_5);
  assign _zz_intMagnitude_6 = _zz_intMagnitude_7;
  assign _zz_intMagnitude_5 = _zz_intMagnitude_6[5:0];
  assign _zz_intMagnitude_7 = ($signed(10'h017) - $signed(decA_exp));
  assign _zz_f2iResult_1 = (- _zz_f2iResult_2);
  assign _zz_f2iResult = _zz_f2iResult_1[31:0];
  assign _zz_f2iResult_3 = intMagnitude;
  assign _zz_f2iResult_2 = {{1{_zz_f2iResult_3[32]}}, _zz_f2iResult_3};
  assign _zz_decA_exp = io_a[30 : 23];
  assign _zz_decA_sig = io_a[22 : 0];
  assign decA_sign = io_a[31];
  always @(*) begin
    decA_exp = 10'h382;
    if(when_Fp32Unit_l102) begin
      if(when_Fp32Unit_l103) begin
        decA_exp = ($signed(10'h382) - $signed(_zz_decA_exp_3));
      end
    end else begin
      if(when_Fp32Unit_l109) begin
        decA_exp = ($signed(_zz_decA_exp_5) - $signed(10'h07f));
      end
    end
  end

  always @(*) begin
    decA_sig = 24'h0;
    if(when_Fp32Unit_l102) begin
      if(when_Fp32Unit_l103) begin
        decA_sig = (_zz_decA_sig_1 <<< _zz_decA_exp_2);
      end
    end else begin
      if(when_Fp32Unit_l109) begin
        decA_sig = {1'b1,_zz_decA_sig};
      end
    end
  end

  assign decA_isZero = ((_zz_decA_exp == 8'h0) && (_zz_decA_sig == 23'h0));
  assign decA_isInf = ((_zz_decA_exp == 8'hff) && (_zz_decA_sig == 23'h0));
  assign decA_isNaN = ((_zz_decA_exp == 8'hff) && (_zz_decA_sig != 23'h0));
  assign when_Fp32Unit_l102 = (_zz_decA_exp == 8'h0);
  assign when_Fp32Unit_l103 = (_zz_decA_sig != 23'h0);
  always @(*) begin
    _zz_decA_exp_1 = 5'h0;
    if(when_Fp32Unit_l56) begin
      _zz_decA_exp_1 = 5'h0;
    end
    if(when_Fp32Unit_l56_1) begin
      _zz_decA_exp_1 = 5'h01;
    end
    if(when_Fp32Unit_l56_2) begin
      _zz_decA_exp_1 = 5'h02;
    end
    if(when_Fp32Unit_l56_3) begin
      _zz_decA_exp_1 = 5'h03;
    end
    if(when_Fp32Unit_l56_4) begin
      _zz_decA_exp_1 = 5'h04;
    end
    if(when_Fp32Unit_l56_5) begin
      _zz_decA_exp_1 = 5'h05;
    end
    if(when_Fp32Unit_l56_6) begin
      _zz_decA_exp_1 = 5'h06;
    end
    if(when_Fp32Unit_l56_7) begin
      _zz_decA_exp_1 = 5'h07;
    end
    if(when_Fp32Unit_l56_8) begin
      _zz_decA_exp_1 = 5'h08;
    end
    if(when_Fp32Unit_l56_9) begin
      _zz_decA_exp_1 = 5'h09;
    end
    if(when_Fp32Unit_l56_10) begin
      _zz_decA_exp_1 = 5'h0a;
    end
    if(when_Fp32Unit_l56_11) begin
      _zz_decA_exp_1 = 5'h0b;
    end
    if(when_Fp32Unit_l56_12) begin
      _zz_decA_exp_1 = 5'h0c;
    end
    if(when_Fp32Unit_l56_13) begin
      _zz_decA_exp_1 = 5'h0d;
    end
    if(when_Fp32Unit_l56_14) begin
      _zz_decA_exp_1 = 5'h0e;
    end
    if(when_Fp32Unit_l56_15) begin
      _zz_decA_exp_1 = 5'h0f;
    end
    if(when_Fp32Unit_l56_16) begin
      _zz_decA_exp_1 = 5'h10;
    end
    if(when_Fp32Unit_l56_17) begin
      _zz_decA_exp_1 = 5'h11;
    end
    if(when_Fp32Unit_l56_18) begin
      _zz_decA_exp_1 = 5'h12;
    end
    if(when_Fp32Unit_l56_19) begin
      _zz_decA_exp_1 = 5'h13;
    end
    if(when_Fp32Unit_l56_20) begin
      _zz_decA_exp_1 = 5'h14;
    end
    if(when_Fp32Unit_l56_21) begin
      _zz_decA_exp_1 = 5'h15;
    end
    if(when_Fp32Unit_l56_22) begin
      _zz_decA_exp_1 = 5'h16;
    end
  end

  assign when_Fp32Unit_l56 = _zz_decA_sig[0];
  assign when_Fp32Unit_l56_1 = _zz_decA_sig[1];
  assign when_Fp32Unit_l56_2 = _zz_decA_sig[2];
  assign when_Fp32Unit_l56_3 = _zz_decA_sig[3];
  assign when_Fp32Unit_l56_4 = _zz_decA_sig[4];
  assign when_Fp32Unit_l56_5 = _zz_decA_sig[5];
  assign when_Fp32Unit_l56_6 = _zz_decA_sig[6];
  assign when_Fp32Unit_l56_7 = _zz_decA_sig[7];
  assign when_Fp32Unit_l56_8 = _zz_decA_sig[8];
  assign when_Fp32Unit_l56_9 = _zz_decA_sig[9];
  assign when_Fp32Unit_l56_10 = _zz_decA_sig[10];
  assign when_Fp32Unit_l56_11 = _zz_decA_sig[11];
  assign when_Fp32Unit_l56_12 = _zz_decA_sig[12];
  assign when_Fp32Unit_l56_13 = _zz_decA_sig[13];
  assign when_Fp32Unit_l56_14 = _zz_decA_sig[14];
  assign when_Fp32Unit_l56_15 = _zz_decA_sig[15];
  assign when_Fp32Unit_l56_16 = _zz_decA_sig[16];
  assign when_Fp32Unit_l56_17 = _zz_decA_sig[17];
  assign when_Fp32Unit_l56_18 = _zz_decA_sig[18];
  assign when_Fp32Unit_l56_19 = _zz_decA_sig[19];
  assign when_Fp32Unit_l56_20 = _zz_decA_sig[20];
  assign when_Fp32Unit_l56_21 = _zz_decA_sig[21];
  assign when_Fp32Unit_l56_22 = _zz_decA_sig[22];
  assign _zz_decA_exp_2 = {1'd0, _zz__zz_decA_exp_2};
  assign when_Fp32Unit_l109 = (_zz_decA_exp != 8'hff);
  assign _zz_decB_exp = io_b[30 : 23];
  assign _zz_decB_sig = io_b[22 : 0];
  assign decB_sign = io_b[31];
  always @(*) begin
    decB_exp = 10'h382;
    if(when_Fp32Unit_l102_1) begin
      if(when_Fp32Unit_l103_1) begin
        decB_exp = ($signed(10'h382) - $signed(_zz_decB_exp_3));
      end
    end else begin
      if(when_Fp32Unit_l109_1) begin
        decB_exp = ($signed(_zz_decB_exp_5) - $signed(10'h07f));
      end
    end
  end

  always @(*) begin
    decB_sig = 24'h0;
    if(when_Fp32Unit_l102_1) begin
      if(when_Fp32Unit_l103_1) begin
        decB_sig = (_zz_decB_sig_1 <<< _zz_decB_exp_2);
      end
    end else begin
      if(when_Fp32Unit_l109_1) begin
        decB_sig = {1'b1,_zz_decB_sig};
      end
    end
  end

  assign decB_isZero = ((_zz_decB_exp == 8'h0) && (_zz_decB_sig == 23'h0));
  assign decB_isInf = ((_zz_decB_exp == 8'hff) && (_zz_decB_sig == 23'h0));
  assign decB_isNaN = ((_zz_decB_exp == 8'hff) && (_zz_decB_sig != 23'h0));
  assign when_Fp32Unit_l102_1 = (_zz_decB_exp == 8'h0);
  assign when_Fp32Unit_l103_1 = (_zz_decB_sig != 23'h0);
  always @(*) begin
    _zz_decB_exp_1 = 5'h0;
    if(when_Fp32Unit_l56_23) begin
      _zz_decB_exp_1 = 5'h0;
    end
    if(when_Fp32Unit_l56_24) begin
      _zz_decB_exp_1 = 5'h01;
    end
    if(when_Fp32Unit_l56_25) begin
      _zz_decB_exp_1 = 5'h02;
    end
    if(when_Fp32Unit_l56_26) begin
      _zz_decB_exp_1 = 5'h03;
    end
    if(when_Fp32Unit_l56_27) begin
      _zz_decB_exp_1 = 5'h04;
    end
    if(when_Fp32Unit_l56_28) begin
      _zz_decB_exp_1 = 5'h05;
    end
    if(when_Fp32Unit_l56_29) begin
      _zz_decB_exp_1 = 5'h06;
    end
    if(when_Fp32Unit_l56_30) begin
      _zz_decB_exp_1 = 5'h07;
    end
    if(when_Fp32Unit_l56_31) begin
      _zz_decB_exp_1 = 5'h08;
    end
    if(when_Fp32Unit_l56_32) begin
      _zz_decB_exp_1 = 5'h09;
    end
    if(when_Fp32Unit_l56_33) begin
      _zz_decB_exp_1 = 5'h0a;
    end
    if(when_Fp32Unit_l56_34) begin
      _zz_decB_exp_1 = 5'h0b;
    end
    if(when_Fp32Unit_l56_35) begin
      _zz_decB_exp_1 = 5'h0c;
    end
    if(when_Fp32Unit_l56_36) begin
      _zz_decB_exp_1 = 5'h0d;
    end
    if(when_Fp32Unit_l56_37) begin
      _zz_decB_exp_1 = 5'h0e;
    end
    if(when_Fp32Unit_l56_38) begin
      _zz_decB_exp_1 = 5'h0f;
    end
    if(when_Fp32Unit_l56_39) begin
      _zz_decB_exp_1 = 5'h10;
    end
    if(when_Fp32Unit_l56_40) begin
      _zz_decB_exp_1 = 5'h11;
    end
    if(when_Fp32Unit_l56_41) begin
      _zz_decB_exp_1 = 5'h12;
    end
    if(when_Fp32Unit_l56_42) begin
      _zz_decB_exp_1 = 5'h13;
    end
    if(when_Fp32Unit_l56_43) begin
      _zz_decB_exp_1 = 5'h14;
    end
    if(when_Fp32Unit_l56_44) begin
      _zz_decB_exp_1 = 5'h15;
    end
    if(when_Fp32Unit_l56_45) begin
      _zz_decB_exp_1 = 5'h16;
    end
  end

  assign when_Fp32Unit_l56_23 = _zz_decB_sig[0];
  assign when_Fp32Unit_l56_24 = _zz_decB_sig[1];
  assign when_Fp32Unit_l56_25 = _zz_decB_sig[2];
  assign when_Fp32Unit_l56_26 = _zz_decB_sig[3];
  assign when_Fp32Unit_l56_27 = _zz_decB_sig[4];
  assign when_Fp32Unit_l56_28 = _zz_decB_sig[5];
  assign when_Fp32Unit_l56_29 = _zz_decB_sig[6];
  assign when_Fp32Unit_l56_30 = _zz_decB_sig[7];
  assign when_Fp32Unit_l56_31 = _zz_decB_sig[8];
  assign when_Fp32Unit_l56_32 = _zz_decB_sig[9];
  assign when_Fp32Unit_l56_33 = _zz_decB_sig[10];
  assign when_Fp32Unit_l56_34 = _zz_decB_sig[11];
  assign when_Fp32Unit_l56_35 = _zz_decB_sig[12];
  assign when_Fp32Unit_l56_36 = _zz_decB_sig[13];
  assign when_Fp32Unit_l56_37 = _zz_decB_sig[14];
  assign when_Fp32Unit_l56_38 = _zz_decB_sig[15];
  assign when_Fp32Unit_l56_39 = _zz_decB_sig[16];
  assign when_Fp32Unit_l56_40 = _zz_decB_sig[17];
  assign when_Fp32Unit_l56_41 = _zz_decB_sig[18];
  assign when_Fp32Unit_l56_42 = _zz_decB_sig[19];
  assign when_Fp32Unit_l56_43 = _zz_decB_sig[20];
  assign when_Fp32Unit_l56_44 = _zz_decB_sig[21];
  assign when_Fp32Unit_l56_45 = _zz_decB_sig[22];
  assign _zz_decB_exp_2 = {1'd0, _zz__zz_decB_exp_2};
  assign when_Fp32Unit_l109_1 = (_zz_decB_exp != 8'hff);
  assign effBSign = (decB_sign ^ (io_mode == 5'h13));
  assign sameSignAdd = (decA_sign == effBSign);
  assign aMagGreater = (($signed(decB_exp) < $signed(decA_exp)) || (($signed(decA_exp) == $signed(decB_exp)) && (decB_sig <= decA_sig)));
  always @(*) begin
    bigExp = decA_exp;
    if(when_Fp32Unit_l232) begin
      bigExp = decB_exp;
    end
  end

  assign when_Fp32Unit_l232 = (! aMagGreater);
  always @(*) begin
    smallExp = decB_exp;
    if(when_Fp32Unit_l238) begin
      smallExp = decA_exp;
    end
  end

  assign when_Fp32Unit_l238 = (! aMagGreater);
  always @(*) begin
    bigSig = decA_sig;
    if(when_Fp32Unit_l244) begin
      bigSig = decB_sig;
    end
  end

  assign when_Fp32Unit_l244 = (! aMagGreater);
  always @(*) begin
    smallSig = decB_sig;
    if(when_Fp32Unit_l250) begin
      smallSig = decA_sig;
    end
  end

  assign when_Fp32Unit_l250 = (! aMagGreater);
  always @(*) begin
    bigSign = decA_sign;
    if(when_Fp32Unit_l256) begin
      bigSign = effBSign;
    end
  end

  assign when_Fp32Unit_l256 = (! aMagGreater);
  assign expDiff = _zz_expDiff;
  assign bigExt = (_zz_bigExt <<< 3);
  assign smallExtBase = (_zz_smallExtBase <<< 3);
  always @(*) begin
    smallExt = 27'h0;
    if(when_Fp32Unit_l67) begin
      smallExt = smallExtBase;
    end
    if(when_Fp32Unit_l72) begin
      smallExt = (_zz_smallExt | _zz_smallExt_2);
    end
    if(when_Fp32Unit_l72_1) begin
      smallExt = (_zz_smallExt_4 | _zz_smallExt_6);
    end
    if(when_Fp32Unit_l72_2) begin
      smallExt = (_zz_smallExt_8 | _zz_smallExt_10);
    end
    if(when_Fp32Unit_l72_3) begin
      smallExt = (_zz_smallExt_12 | _zz_smallExt_14);
    end
    if(when_Fp32Unit_l72_4) begin
      smallExt = (_zz_smallExt_16 | _zz_smallExt_18);
    end
    if(when_Fp32Unit_l72_5) begin
      smallExt = (_zz_smallExt_20 | _zz_smallExt_22);
    end
    if(when_Fp32Unit_l72_6) begin
      smallExt = (_zz_smallExt_24 | _zz_smallExt_26);
    end
    if(when_Fp32Unit_l72_7) begin
      smallExt = (_zz_smallExt_28 | _zz_smallExt_30);
    end
    if(when_Fp32Unit_l72_8) begin
      smallExt = (_zz_smallExt_32 | _zz_smallExt_34);
    end
    if(when_Fp32Unit_l72_9) begin
      smallExt = (_zz_smallExt_36 | _zz_smallExt_38);
    end
    if(when_Fp32Unit_l72_10) begin
      smallExt = (_zz_smallExt_40 | _zz_smallExt_42);
    end
    if(when_Fp32Unit_l72_11) begin
      smallExt = (_zz_smallExt_44 | _zz_smallExt_46);
    end
    if(when_Fp32Unit_l72_12) begin
      smallExt = (_zz_smallExt_48 | _zz_smallExt_50);
    end
    if(when_Fp32Unit_l72_13) begin
      smallExt = (_zz_smallExt_52 | _zz_smallExt_54);
    end
    if(when_Fp32Unit_l72_14) begin
      smallExt = (_zz_smallExt_56 | _zz_smallExt_58);
    end
    if(when_Fp32Unit_l72_15) begin
      smallExt = (_zz_smallExt_60 | _zz_smallExt_62);
    end
    if(when_Fp32Unit_l72_16) begin
      smallExt = (_zz_smallExt_64 | _zz_smallExt_66);
    end
    if(when_Fp32Unit_l72_17) begin
      smallExt = (_zz_smallExt_68 | _zz_smallExt_70);
    end
    if(when_Fp32Unit_l72_18) begin
      smallExt = (_zz_smallExt_72 | _zz_smallExt_74);
    end
    if(when_Fp32Unit_l72_19) begin
      smallExt = (_zz_smallExt_76 | _zz_smallExt_78);
    end
    if(when_Fp32Unit_l72_20) begin
      smallExt = (_zz_smallExt_80 | _zz_smallExt_82);
    end
    if(when_Fp32Unit_l72_21) begin
      smallExt = (_zz_smallExt_84 | _zz_smallExt_86);
    end
    if(when_Fp32Unit_l72_22) begin
      smallExt = (_zz_smallExt_88 | _zz_smallExt_90);
    end
    if(when_Fp32Unit_l72_23) begin
      smallExt = (_zz_smallExt_92 | _zz_smallExt_94);
    end
    if(when_Fp32Unit_l72_24) begin
      smallExt = (_zz_smallExt_96 | _zz_smallExt_98);
    end
    if(when_Fp32Unit_l72_25) begin
      smallExt = (_zz_smallExt_100 | _zz_smallExt_102);
    end
    if(when_Fp32Unit_l72_26) begin
      smallExt = {26'd0, _zz_smallExt_104};
    end
    if(when_Fp32Unit_l72_27) begin
      smallExt = {26'd0, _zz_smallExt_105};
    end
    if(when_Fp32Unit_l72_28) begin
      smallExt = {26'd0, _zz_smallExt_106};
    end
    if(when_Fp32Unit_l72_29) begin
      smallExt = {26'd0, _zz_smallExt_107};
    end
    if(when_Fp32Unit_l72_30) begin
      smallExt = {26'd0, _zz_smallExt_108};
    end
    if(when_Fp32Unit_l83) begin
      smallExt = {26'd0, _zz_smallExt_109};
    end
  end

  assign when_Fp32Unit_l67 = (expDiff == 10'h0);
  assign when_Fp32Unit_l72 = (expDiff == 10'h001);
  assign when_Fp32Unit_l72_1 = (expDiff == 10'h002);
  assign when_Fp32Unit_l72_2 = (expDiff == 10'h003);
  assign when_Fp32Unit_l72_3 = (expDiff == 10'h004);
  assign when_Fp32Unit_l72_4 = (expDiff == 10'h005);
  assign when_Fp32Unit_l72_5 = (expDiff == 10'h006);
  assign when_Fp32Unit_l72_6 = (expDiff == 10'h007);
  assign when_Fp32Unit_l72_7 = (expDiff == 10'h008);
  assign when_Fp32Unit_l72_8 = (expDiff == 10'h009);
  assign when_Fp32Unit_l72_9 = (expDiff == 10'h00a);
  assign when_Fp32Unit_l72_10 = (expDiff == 10'h00b);
  assign when_Fp32Unit_l72_11 = (expDiff == 10'h00c);
  assign when_Fp32Unit_l72_12 = (expDiff == 10'h00d);
  assign when_Fp32Unit_l72_13 = (expDiff == 10'h00e);
  assign when_Fp32Unit_l72_14 = (expDiff == 10'h00f);
  assign when_Fp32Unit_l72_15 = (expDiff == 10'h010);
  assign when_Fp32Unit_l72_16 = (expDiff == 10'h011);
  assign when_Fp32Unit_l72_17 = (expDiff == 10'h012);
  assign when_Fp32Unit_l72_18 = (expDiff == 10'h013);
  assign when_Fp32Unit_l72_19 = (expDiff == 10'h014);
  assign when_Fp32Unit_l72_20 = (expDiff == 10'h015);
  assign when_Fp32Unit_l72_21 = (expDiff == 10'h016);
  assign when_Fp32Unit_l72_22 = (expDiff == 10'h017);
  assign when_Fp32Unit_l72_23 = (expDiff == 10'h018);
  assign when_Fp32Unit_l72_24 = (expDiff == 10'h019);
  assign when_Fp32Unit_l72_25 = (expDiff == 10'h01a);
  assign when_Fp32Unit_l72_26 = (expDiff == 10'h01b);
  assign when_Fp32Unit_l72_27 = (expDiff == 10'h01c);
  assign when_Fp32Unit_l72_28 = (expDiff == 10'h01d);
  assign when_Fp32Unit_l72_29 = (expDiff == 10'h01e);
  assign when_Fp32Unit_l72_30 = (expDiff == 10'h01f);
  assign when_Fp32Unit_l83 = (10'h01f < expDiff);
  always @(*) begin
    addFiniteSign = bigSign;
    if(!sameSignAdd) begin
      if(when_Fp32Unit_l285) begin
        addFiniteSign = 1'b0;
      end else begin
        addFiniteSign = bigSign;
      end
    end
  end

  always @(*) begin
    addFiniteExp = bigExp;
    if(sameSignAdd) begin
      if(when_Fp32Unit_l276) begin
        addFiniteExp = ($signed(bigExp) + $signed(10'h001));
      end else begin
        addFiniteExp = bigExp;
      end
    end else begin
      if(when_Fp32Unit_l285) begin
        addFiniteExp = 10'h382;
      end else begin
        addFiniteExp = ($signed(bigExp) - $signed(_zz_addFiniteExp_2));
      end
    end
  end

  always @(*) begin
    addFiniteSig = 27'h0;
    if(sameSignAdd) begin
      if(when_Fp32Unit_l276) begin
        addFiniteSig = (_zz_addFiniteSig[27 : 1] | _zz_addFiniteSig_2);
      end else begin
        addFiniteSig = _zz_addFiniteSig[26 : 0];
      end
    end else begin
      if(when_Fp32Unit_l285) begin
        addFiniteSig = 27'h0;
      end else begin
        addFiniteSig = (_zz_addFiniteSig_1 <<< _zz_addFiniteExp_1);
      end
    end
  end

  assign _zz_addFiniteSig = (_zz__zz_addFiniteSig + _zz__zz_addFiniteSig_1);
  assign when_Fp32Unit_l276 = _zz_addFiniteSig[27];
  assign _zz_addFiniteSig_1 = (bigExt - smallExt);
  assign when_Fp32Unit_l285 = (_zz_addFiniteSig_1 == 27'h0);
  always @(*) begin
    _zz_addFiniteExp = 5'h0;
    if(when_Fp32Unit_l56_46) begin
      _zz_addFiniteExp = 5'h0;
    end
    if(when_Fp32Unit_l56_47) begin
      _zz_addFiniteExp = 5'h01;
    end
    if(when_Fp32Unit_l56_48) begin
      _zz_addFiniteExp = 5'h02;
    end
    if(when_Fp32Unit_l56_49) begin
      _zz_addFiniteExp = 5'h03;
    end
    if(when_Fp32Unit_l56_50) begin
      _zz_addFiniteExp = 5'h04;
    end
    if(when_Fp32Unit_l56_51) begin
      _zz_addFiniteExp = 5'h05;
    end
    if(when_Fp32Unit_l56_52) begin
      _zz_addFiniteExp = 5'h06;
    end
    if(when_Fp32Unit_l56_53) begin
      _zz_addFiniteExp = 5'h07;
    end
    if(when_Fp32Unit_l56_54) begin
      _zz_addFiniteExp = 5'h08;
    end
    if(when_Fp32Unit_l56_55) begin
      _zz_addFiniteExp = 5'h09;
    end
    if(when_Fp32Unit_l56_56) begin
      _zz_addFiniteExp = 5'h0a;
    end
    if(when_Fp32Unit_l56_57) begin
      _zz_addFiniteExp = 5'h0b;
    end
    if(when_Fp32Unit_l56_58) begin
      _zz_addFiniteExp = 5'h0c;
    end
    if(when_Fp32Unit_l56_59) begin
      _zz_addFiniteExp = 5'h0d;
    end
    if(when_Fp32Unit_l56_60) begin
      _zz_addFiniteExp = 5'h0e;
    end
    if(when_Fp32Unit_l56_61) begin
      _zz_addFiniteExp = 5'h0f;
    end
    if(when_Fp32Unit_l56_62) begin
      _zz_addFiniteExp = 5'h10;
    end
    if(when_Fp32Unit_l56_63) begin
      _zz_addFiniteExp = 5'h11;
    end
    if(when_Fp32Unit_l56_64) begin
      _zz_addFiniteExp = 5'h12;
    end
    if(when_Fp32Unit_l56_65) begin
      _zz_addFiniteExp = 5'h13;
    end
    if(when_Fp32Unit_l56_66) begin
      _zz_addFiniteExp = 5'h14;
    end
    if(when_Fp32Unit_l56_67) begin
      _zz_addFiniteExp = 5'h15;
    end
    if(when_Fp32Unit_l56_68) begin
      _zz_addFiniteExp = 5'h16;
    end
    if(when_Fp32Unit_l56_69) begin
      _zz_addFiniteExp = 5'h17;
    end
    if(when_Fp32Unit_l56_70) begin
      _zz_addFiniteExp = 5'h18;
    end
    if(when_Fp32Unit_l56_71) begin
      _zz_addFiniteExp = 5'h19;
    end
    if(when_Fp32Unit_l56_72) begin
      _zz_addFiniteExp = 5'h1a;
    end
  end

  assign when_Fp32Unit_l56_46 = _zz_addFiniteSig_1[0];
  assign when_Fp32Unit_l56_47 = _zz_addFiniteSig_1[1];
  assign when_Fp32Unit_l56_48 = _zz_addFiniteSig_1[2];
  assign when_Fp32Unit_l56_49 = _zz_addFiniteSig_1[3];
  assign when_Fp32Unit_l56_50 = _zz_addFiniteSig_1[4];
  assign when_Fp32Unit_l56_51 = _zz_addFiniteSig_1[5];
  assign when_Fp32Unit_l56_52 = _zz_addFiniteSig_1[6];
  assign when_Fp32Unit_l56_53 = _zz_addFiniteSig_1[7];
  assign when_Fp32Unit_l56_54 = _zz_addFiniteSig_1[8];
  assign when_Fp32Unit_l56_55 = _zz_addFiniteSig_1[9];
  assign when_Fp32Unit_l56_56 = _zz_addFiniteSig_1[10];
  assign when_Fp32Unit_l56_57 = _zz_addFiniteSig_1[11];
  assign when_Fp32Unit_l56_58 = _zz_addFiniteSig_1[12];
  assign when_Fp32Unit_l56_59 = _zz_addFiniteSig_1[13];
  assign when_Fp32Unit_l56_60 = _zz_addFiniteSig_1[14];
  assign when_Fp32Unit_l56_61 = _zz_addFiniteSig_1[15];
  assign when_Fp32Unit_l56_62 = _zz_addFiniteSig_1[16];
  assign when_Fp32Unit_l56_63 = _zz_addFiniteSig_1[17];
  assign when_Fp32Unit_l56_64 = _zz_addFiniteSig_1[18];
  assign when_Fp32Unit_l56_65 = _zz_addFiniteSig_1[19];
  assign when_Fp32Unit_l56_66 = _zz_addFiniteSig_1[20];
  assign when_Fp32Unit_l56_67 = _zz_addFiniteSig_1[21];
  assign when_Fp32Unit_l56_68 = _zz_addFiniteSig_1[22];
  assign when_Fp32Unit_l56_69 = _zz_addFiniteSig_1[23];
  assign when_Fp32Unit_l56_70 = _zz_addFiniteSig_1[24];
  assign when_Fp32Unit_l56_71 = _zz_addFiniteSig_1[25];
  assign when_Fp32Unit_l56_72 = _zz_addFiniteSig_1[26];
  assign _zz_addFiniteExp_1 = {1'd0, _zz__zz_addFiniteExp_1};
  always @(*) begin
    _zz_addResult = {addFiniteSign,31'h0};
    if(when_Fp32Unit_l153) begin
      _zz_addResult = {addFiniteSign,31'h0};
    end else begin
      if(when_Fp32Unit_l155) begin
        _zz_addResult = {{addFiniteSign,8'hff},23'h0};
      end else begin
        _zz_addResult = {{addFiniteSign,_zz_addResult_1},_zz_when_Fp32Unit_l153[22 : 0]};
      end
    end
  end

  assign when_Fp32Unit_l124 = ($signed(addFiniteExp) < $signed(10'h382));
  always @(*) begin
    _zz_when_Fp32Unit_l67 = 10'h0;
    if(when_Fp32Unit_l124) begin
      _zz_when_Fp32Unit_l67 = _zz__zz_when_Fp32Unit_l67;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148 = addFiniteSig;
    if(when_Fp32Unit_l124) begin
      _zz_when_Fp32Unit_l148 = _zz_when_Fp32Unit_l148_1;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_1 = 27'h0;
    if(when_Fp32Unit_l67_1) begin
      _zz_when_Fp32Unit_l148_1 = addFiniteSig;
    end
    if(when_Fp32Unit_l72_31) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1 | _zz__zz_when_Fp32Unit_l148_1_2);
    end
    if(when_Fp32Unit_l72_32) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_4 | _zz__zz_when_Fp32Unit_l148_1_6);
    end
    if(when_Fp32Unit_l72_33) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_8 | _zz__zz_when_Fp32Unit_l148_1_10);
    end
    if(when_Fp32Unit_l72_34) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_12 | _zz__zz_when_Fp32Unit_l148_1_14);
    end
    if(when_Fp32Unit_l72_35) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_16 | _zz__zz_when_Fp32Unit_l148_1_18);
    end
    if(when_Fp32Unit_l72_36) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_20 | _zz__zz_when_Fp32Unit_l148_1_22);
    end
    if(when_Fp32Unit_l72_37) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_24 | _zz__zz_when_Fp32Unit_l148_1_26);
    end
    if(when_Fp32Unit_l72_38) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_28 | _zz__zz_when_Fp32Unit_l148_1_30);
    end
    if(when_Fp32Unit_l72_39) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_32 | _zz__zz_when_Fp32Unit_l148_1_34);
    end
    if(when_Fp32Unit_l72_40) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_36 | _zz__zz_when_Fp32Unit_l148_1_38);
    end
    if(when_Fp32Unit_l72_41) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_40 | _zz__zz_when_Fp32Unit_l148_1_42);
    end
    if(when_Fp32Unit_l72_42) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_44 | _zz__zz_when_Fp32Unit_l148_1_46);
    end
    if(when_Fp32Unit_l72_43) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_48 | _zz__zz_when_Fp32Unit_l148_1_50);
    end
    if(when_Fp32Unit_l72_44) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_52 | _zz__zz_when_Fp32Unit_l148_1_54);
    end
    if(when_Fp32Unit_l72_45) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_56 | _zz__zz_when_Fp32Unit_l148_1_58);
    end
    if(when_Fp32Unit_l72_46) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_60 | _zz__zz_when_Fp32Unit_l148_1_62);
    end
    if(when_Fp32Unit_l72_47) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_64 | _zz__zz_when_Fp32Unit_l148_1_66);
    end
    if(when_Fp32Unit_l72_48) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_68 | _zz__zz_when_Fp32Unit_l148_1_70);
    end
    if(when_Fp32Unit_l72_49) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_72 | _zz__zz_when_Fp32Unit_l148_1_74);
    end
    if(when_Fp32Unit_l72_50) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_76 | _zz__zz_when_Fp32Unit_l148_1_78);
    end
    if(when_Fp32Unit_l72_51) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_80 | _zz__zz_when_Fp32Unit_l148_1_82);
    end
    if(when_Fp32Unit_l72_52) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_84 | _zz__zz_when_Fp32Unit_l148_1_86);
    end
    if(when_Fp32Unit_l72_53) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_88 | _zz__zz_when_Fp32Unit_l148_1_90);
    end
    if(when_Fp32Unit_l72_54) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_92 | _zz__zz_when_Fp32Unit_l148_1_94);
    end
    if(when_Fp32Unit_l72_55) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_96 | _zz__zz_when_Fp32Unit_l148_1_98);
    end
    if(when_Fp32Unit_l72_56) begin
      _zz_when_Fp32Unit_l148_1 = (_zz__zz_when_Fp32Unit_l148_1_100 | _zz__zz_when_Fp32Unit_l148_1_102);
    end
    if(when_Fp32Unit_l72_57) begin
      _zz_when_Fp32Unit_l148_1 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_104};
    end
    if(when_Fp32Unit_l72_58) begin
      _zz_when_Fp32Unit_l148_1 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_105};
    end
    if(when_Fp32Unit_l72_59) begin
      _zz_when_Fp32Unit_l148_1 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_106};
    end
    if(when_Fp32Unit_l72_60) begin
      _zz_when_Fp32Unit_l148_1 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_107};
    end
    if(when_Fp32Unit_l72_61) begin
      _zz_when_Fp32Unit_l148_1 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_108};
    end
    if(when_Fp32Unit_l83_1) begin
      _zz_when_Fp32Unit_l148_1 = {26'd0, _zz__zz_when_Fp32Unit_l148_1_109};
    end
  end

  assign when_Fp32Unit_l67_1 = (_zz_when_Fp32Unit_l67 == 10'h0);
  assign when_Fp32Unit_l72_31 = (_zz_when_Fp32Unit_l67 == 10'h001);
  assign when_Fp32Unit_l72_32 = (_zz_when_Fp32Unit_l67 == 10'h002);
  assign when_Fp32Unit_l72_33 = (_zz_when_Fp32Unit_l67 == 10'h003);
  assign when_Fp32Unit_l72_34 = (_zz_when_Fp32Unit_l67 == 10'h004);
  assign when_Fp32Unit_l72_35 = (_zz_when_Fp32Unit_l67 == 10'h005);
  assign when_Fp32Unit_l72_36 = (_zz_when_Fp32Unit_l67 == 10'h006);
  assign when_Fp32Unit_l72_37 = (_zz_when_Fp32Unit_l67 == 10'h007);
  assign when_Fp32Unit_l72_38 = (_zz_when_Fp32Unit_l67 == 10'h008);
  assign when_Fp32Unit_l72_39 = (_zz_when_Fp32Unit_l67 == 10'h009);
  assign when_Fp32Unit_l72_40 = (_zz_when_Fp32Unit_l67 == 10'h00a);
  assign when_Fp32Unit_l72_41 = (_zz_when_Fp32Unit_l67 == 10'h00b);
  assign when_Fp32Unit_l72_42 = (_zz_when_Fp32Unit_l67 == 10'h00c);
  assign when_Fp32Unit_l72_43 = (_zz_when_Fp32Unit_l67 == 10'h00d);
  assign when_Fp32Unit_l72_44 = (_zz_when_Fp32Unit_l67 == 10'h00e);
  assign when_Fp32Unit_l72_45 = (_zz_when_Fp32Unit_l67 == 10'h00f);
  assign when_Fp32Unit_l72_46 = (_zz_when_Fp32Unit_l67 == 10'h010);
  assign when_Fp32Unit_l72_47 = (_zz_when_Fp32Unit_l67 == 10'h011);
  assign when_Fp32Unit_l72_48 = (_zz_when_Fp32Unit_l67 == 10'h012);
  assign when_Fp32Unit_l72_49 = (_zz_when_Fp32Unit_l67 == 10'h013);
  assign when_Fp32Unit_l72_50 = (_zz_when_Fp32Unit_l67 == 10'h014);
  assign when_Fp32Unit_l72_51 = (_zz_when_Fp32Unit_l67 == 10'h015);
  assign when_Fp32Unit_l72_52 = (_zz_when_Fp32Unit_l67 == 10'h016);
  assign when_Fp32Unit_l72_53 = (_zz_when_Fp32Unit_l67 == 10'h017);
  assign when_Fp32Unit_l72_54 = (_zz_when_Fp32Unit_l67 == 10'h018);
  assign when_Fp32Unit_l72_55 = (_zz_when_Fp32Unit_l67 == 10'h019);
  assign when_Fp32Unit_l72_56 = (_zz_when_Fp32Unit_l67 == 10'h01a);
  assign when_Fp32Unit_l72_57 = (_zz_when_Fp32Unit_l67 == 10'h01b);
  assign when_Fp32Unit_l72_58 = (_zz_when_Fp32Unit_l67 == 10'h01c);
  assign when_Fp32Unit_l72_59 = (_zz_when_Fp32Unit_l67 == 10'h01d);
  assign when_Fp32Unit_l72_60 = (_zz_when_Fp32Unit_l67 == 10'h01e);
  assign when_Fp32Unit_l72_61 = (_zz_when_Fp32Unit_l67 == 10'h01f);
  assign when_Fp32Unit_l83_1 = (10'h01f < _zz_when_Fp32Unit_l67);
  always @(*) begin
    _zz_when_Fp32Unit_l161 = addFiniteExp;
    if(when_Fp32Unit_l124) begin
      _zz_when_Fp32Unit_l161 = 10'h382;
    end
  end

  assign _zz_when_Fp32Unit_l148_2 = _zz_when_Fp32Unit_l148[26 : 3];
  assign _zz_when_Fp32Unit_l148_3 = (_zz__zz_when_Fp32Unit_l148_3 + _zz__zz_when_Fp32Unit_l148_3_1);
  always @(*) begin
    _zz_when_Fp32Unit_l153 = _zz_when_Fp32Unit_l148_3[23 : 0];
    if(when_Fp32Unit_l148) begin
      _zz_when_Fp32Unit_l153 = _zz_when_Fp32Unit_l148_3[24 : 1];
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l161_1 = _zz_when_Fp32Unit_l161;
    if(when_Fp32Unit_l148) begin
      _zz_when_Fp32Unit_l161_1 = ($signed(_zz_when_Fp32Unit_l161) + $signed(10'h001));
    end
  end

  assign when_Fp32Unit_l148 = _zz_when_Fp32Unit_l148_3[24];
  assign when_Fp32Unit_l153 = (_zz_when_Fp32Unit_l153 == 24'h0);
  always @(*) begin
    _zz_addResult_1 = 8'h0;
    if(when_Fp32Unit_l161) begin
      _zz_addResult_1 = 8'h01;
    end else begin
      if(when_Fp32Unit_l163) begin
        _zz_addResult_1 = _zz__zz_addResult_1[7:0];
      end
    end
  end

  assign when_Fp32Unit_l161 = (($signed(_zz_when_Fp32Unit_l161_1) == $signed(10'h382)) && _zz_when_Fp32Unit_l153[23]);
  assign when_Fp32Unit_l163 = ($signed(10'h382) < $signed(_zz_when_Fp32Unit_l161_1));
  assign when_Fp32Unit_l155 = ($signed(10'h07f) < $signed(_zz_when_Fp32Unit_l161_1));
  always @(*) begin
    addResult = _zz_addResult;
    if(when_Fp32Unit_l300) begin
      addResult = 32'h7fc00000;
    end else begin
      if(when_Fp32Unit_l302) begin
        addResult = 32'h7fc00000;
      end else begin
        if(decA_isInf) begin
          addResult = {{decA_sign,8'hff},23'h0};
        end else begin
          if(decB_isInf) begin
            addResult = {{effBSign,8'hff},23'h0};
          end
        end
      end
    end
  end

  assign when_Fp32Unit_l300 = (decA_isNaN || decB_isNaN);
  assign when_Fp32Unit_l302 = ((decA_isInf && decB_isInf) && (decA_sign != effBSign));
  always @(*) begin
    mulResult = 32'h0;
    if(when_Fp32Unit_l313) begin
      mulResult = 32'h7fc00000;
    end else begin
      if(when_Fp32Unit_l315) begin
        mulResult = 32'h7fc00000;
      end else begin
        if(when_Fp32Unit_l317) begin
          mulResult = {{mulSign,8'hff},23'h0};
        end else begin
          if(when_Fp32Unit_l319) begin
            mulResult = {mulSign,31'h0};
          end else begin
            mulResult = _zz_mulResult;
          end
        end
      end
    end
  end

  assign mulSign = (decA_sign ^ decB_sign);
  assign when_Fp32Unit_l313 = (decA_isNaN || decB_isNaN);
  assign _zz_when_Fp32Unit_l328 = _zz__zz_when_Fp32Unit_l328[47:0];
  always @(*) begin
    _zz_when_Fp32Unit_l124 = ($signed(decA_exp) + $signed(decB_exp));
    if(when_Fp32Unit_l328) begin
      _zz_when_Fp32Unit_l124 = ($signed(_zz__zz_when_Fp32Unit_l124) + $signed(10'h001));
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_4 = 27'h0;
    if(when_Fp32Unit_l328) begin
      _zz_when_Fp32Unit_l148_4 = (_zz_when_Fp32Unit_l328[47 : 21] | _zz__zz_when_Fp32Unit_l148_4);
    end else begin
      _zz_when_Fp32Unit_l148_4 = (_zz_when_Fp32Unit_l328[46 : 20] | _zz__zz_when_Fp32Unit_l148_4_2);
    end
  end

  assign when_Fp32Unit_l328 = _zz_when_Fp32Unit_l328[47];
  always @(*) begin
    _zz_mulResult = {mulSign,31'h0};
    if(when_Fp32Unit_l153_1) begin
      _zz_mulResult = {mulSign,31'h0};
    end else begin
      if(when_Fp32Unit_l155_1) begin
        _zz_mulResult = {{mulSign,8'hff},23'h0};
      end else begin
        _zz_mulResult = {{mulSign,_zz_mulResult_1},_zz_when_Fp32Unit_l153_1[22 : 0]};
      end
    end
  end

  assign when_Fp32Unit_l124_1 = ($signed(_zz_when_Fp32Unit_l124) < $signed(10'h382));
  always @(*) begin
    _zz_when_Fp32Unit_l67_1 = 10'h0;
    if(when_Fp32Unit_l124_1) begin
      _zz_when_Fp32Unit_l67_1 = _zz__zz_when_Fp32Unit_l67_1;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_5 = _zz_when_Fp32Unit_l148_4;
    if(when_Fp32Unit_l124_1) begin
      _zz_when_Fp32Unit_l148_5 = _zz_when_Fp32Unit_l148_6;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_6 = 27'h0;
    if(when_Fp32Unit_l67_2) begin
      _zz_when_Fp32Unit_l148_6 = _zz_when_Fp32Unit_l148_4;
    end
    if(when_Fp32Unit_l72_62) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6 | _zz__zz_when_Fp32Unit_l148_6_2);
    end
    if(when_Fp32Unit_l72_63) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_4 | _zz__zz_when_Fp32Unit_l148_6_6);
    end
    if(when_Fp32Unit_l72_64) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_8 | _zz__zz_when_Fp32Unit_l148_6_10);
    end
    if(when_Fp32Unit_l72_65) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_12 | _zz__zz_when_Fp32Unit_l148_6_14);
    end
    if(when_Fp32Unit_l72_66) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_16 | _zz__zz_when_Fp32Unit_l148_6_18);
    end
    if(when_Fp32Unit_l72_67) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_20 | _zz__zz_when_Fp32Unit_l148_6_22);
    end
    if(when_Fp32Unit_l72_68) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_24 | _zz__zz_when_Fp32Unit_l148_6_26);
    end
    if(when_Fp32Unit_l72_69) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_28 | _zz__zz_when_Fp32Unit_l148_6_30);
    end
    if(when_Fp32Unit_l72_70) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_32 | _zz__zz_when_Fp32Unit_l148_6_34);
    end
    if(when_Fp32Unit_l72_71) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_36 | _zz__zz_when_Fp32Unit_l148_6_38);
    end
    if(when_Fp32Unit_l72_72) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_40 | _zz__zz_when_Fp32Unit_l148_6_42);
    end
    if(when_Fp32Unit_l72_73) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_44 | _zz__zz_when_Fp32Unit_l148_6_46);
    end
    if(when_Fp32Unit_l72_74) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_48 | _zz__zz_when_Fp32Unit_l148_6_50);
    end
    if(when_Fp32Unit_l72_75) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_52 | _zz__zz_when_Fp32Unit_l148_6_54);
    end
    if(when_Fp32Unit_l72_76) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_56 | _zz__zz_when_Fp32Unit_l148_6_58);
    end
    if(when_Fp32Unit_l72_77) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_60 | _zz__zz_when_Fp32Unit_l148_6_62);
    end
    if(when_Fp32Unit_l72_78) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_64 | _zz__zz_when_Fp32Unit_l148_6_66);
    end
    if(when_Fp32Unit_l72_79) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_68 | _zz__zz_when_Fp32Unit_l148_6_70);
    end
    if(when_Fp32Unit_l72_80) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_72 | _zz__zz_when_Fp32Unit_l148_6_74);
    end
    if(when_Fp32Unit_l72_81) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_76 | _zz__zz_when_Fp32Unit_l148_6_78);
    end
    if(when_Fp32Unit_l72_82) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_80 | _zz__zz_when_Fp32Unit_l148_6_82);
    end
    if(when_Fp32Unit_l72_83) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_84 | _zz__zz_when_Fp32Unit_l148_6_86);
    end
    if(when_Fp32Unit_l72_84) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_88 | _zz__zz_when_Fp32Unit_l148_6_90);
    end
    if(when_Fp32Unit_l72_85) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_92 | _zz__zz_when_Fp32Unit_l148_6_94);
    end
    if(when_Fp32Unit_l72_86) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_96 | _zz__zz_when_Fp32Unit_l148_6_98);
    end
    if(when_Fp32Unit_l72_87) begin
      _zz_when_Fp32Unit_l148_6 = (_zz__zz_when_Fp32Unit_l148_6_100 | _zz__zz_when_Fp32Unit_l148_6_102);
    end
    if(when_Fp32Unit_l72_88) begin
      _zz_when_Fp32Unit_l148_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_104};
    end
    if(when_Fp32Unit_l72_89) begin
      _zz_when_Fp32Unit_l148_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_105};
    end
    if(when_Fp32Unit_l72_90) begin
      _zz_when_Fp32Unit_l148_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_106};
    end
    if(when_Fp32Unit_l72_91) begin
      _zz_when_Fp32Unit_l148_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_107};
    end
    if(when_Fp32Unit_l72_92) begin
      _zz_when_Fp32Unit_l148_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_108};
    end
    if(when_Fp32Unit_l83_2) begin
      _zz_when_Fp32Unit_l148_6 = {26'd0, _zz__zz_when_Fp32Unit_l148_6_109};
    end
  end

  assign when_Fp32Unit_l67_2 = (_zz_when_Fp32Unit_l67_1 == 10'h0);
  assign when_Fp32Unit_l72_62 = (_zz_when_Fp32Unit_l67_1 == 10'h001);
  assign when_Fp32Unit_l72_63 = (_zz_when_Fp32Unit_l67_1 == 10'h002);
  assign when_Fp32Unit_l72_64 = (_zz_when_Fp32Unit_l67_1 == 10'h003);
  assign when_Fp32Unit_l72_65 = (_zz_when_Fp32Unit_l67_1 == 10'h004);
  assign when_Fp32Unit_l72_66 = (_zz_when_Fp32Unit_l67_1 == 10'h005);
  assign when_Fp32Unit_l72_67 = (_zz_when_Fp32Unit_l67_1 == 10'h006);
  assign when_Fp32Unit_l72_68 = (_zz_when_Fp32Unit_l67_1 == 10'h007);
  assign when_Fp32Unit_l72_69 = (_zz_when_Fp32Unit_l67_1 == 10'h008);
  assign when_Fp32Unit_l72_70 = (_zz_when_Fp32Unit_l67_1 == 10'h009);
  assign when_Fp32Unit_l72_71 = (_zz_when_Fp32Unit_l67_1 == 10'h00a);
  assign when_Fp32Unit_l72_72 = (_zz_when_Fp32Unit_l67_1 == 10'h00b);
  assign when_Fp32Unit_l72_73 = (_zz_when_Fp32Unit_l67_1 == 10'h00c);
  assign when_Fp32Unit_l72_74 = (_zz_when_Fp32Unit_l67_1 == 10'h00d);
  assign when_Fp32Unit_l72_75 = (_zz_when_Fp32Unit_l67_1 == 10'h00e);
  assign when_Fp32Unit_l72_76 = (_zz_when_Fp32Unit_l67_1 == 10'h00f);
  assign when_Fp32Unit_l72_77 = (_zz_when_Fp32Unit_l67_1 == 10'h010);
  assign when_Fp32Unit_l72_78 = (_zz_when_Fp32Unit_l67_1 == 10'h011);
  assign when_Fp32Unit_l72_79 = (_zz_when_Fp32Unit_l67_1 == 10'h012);
  assign when_Fp32Unit_l72_80 = (_zz_when_Fp32Unit_l67_1 == 10'h013);
  assign when_Fp32Unit_l72_81 = (_zz_when_Fp32Unit_l67_1 == 10'h014);
  assign when_Fp32Unit_l72_82 = (_zz_when_Fp32Unit_l67_1 == 10'h015);
  assign when_Fp32Unit_l72_83 = (_zz_when_Fp32Unit_l67_1 == 10'h016);
  assign when_Fp32Unit_l72_84 = (_zz_when_Fp32Unit_l67_1 == 10'h017);
  assign when_Fp32Unit_l72_85 = (_zz_when_Fp32Unit_l67_1 == 10'h018);
  assign when_Fp32Unit_l72_86 = (_zz_when_Fp32Unit_l67_1 == 10'h019);
  assign when_Fp32Unit_l72_87 = (_zz_when_Fp32Unit_l67_1 == 10'h01a);
  assign when_Fp32Unit_l72_88 = (_zz_when_Fp32Unit_l67_1 == 10'h01b);
  assign when_Fp32Unit_l72_89 = (_zz_when_Fp32Unit_l67_1 == 10'h01c);
  assign when_Fp32Unit_l72_90 = (_zz_when_Fp32Unit_l67_1 == 10'h01d);
  assign when_Fp32Unit_l72_91 = (_zz_when_Fp32Unit_l67_1 == 10'h01e);
  assign when_Fp32Unit_l72_92 = (_zz_when_Fp32Unit_l67_1 == 10'h01f);
  assign when_Fp32Unit_l83_2 = (10'h01f < _zz_when_Fp32Unit_l67_1);
  always @(*) begin
    _zz_when_Fp32Unit_l161_2 = _zz_when_Fp32Unit_l124;
    if(when_Fp32Unit_l124_1) begin
      _zz_when_Fp32Unit_l161_2 = 10'h382;
    end
  end

  assign _zz_when_Fp32Unit_l148_7 = _zz_when_Fp32Unit_l148_5[26 : 3];
  assign _zz_when_Fp32Unit_l148_8 = (_zz__zz_when_Fp32Unit_l148_8 + _zz__zz_when_Fp32Unit_l148_8_1);
  always @(*) begin
    _zz_when_Fp32Unit_l153_1 = _zz_when_Fp32Unit_l148_8[23 : 0];
    if(when_Fp32Unit_l148_1) begin
      _zz_when_Fp32Unit_l153_1 = _zz_when_Fp32Unit_l148_8[24 : 1];
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l161_3 = _zz_when_Fp32Unit_l161_2;
    if(when_Fp32Unit_l148_1) begin
      _zz_when_Fp32Unit_l161_3 = ($signed(_zz_when_Fp32Unit_l161_2) + $signed(10'h001));
    end
  end

  assign when_Fp32Unit_l148_1 = _zz_when_Fp32Unit_l148_8[24];
  assign when_Fp32Unit_l153_1 = (_zz_when_Fp32Unit_l153_1 == 24'h0);
  always @(*) begin
    _zz_mulResult_1 = 8'h0;
    if(when_Fp32Unit_l161_1) begin
      _zz_mulResult_1 = 8'h01;
    end else begin
      if(when_Fp32Unit_l163_1) begin
        _zz_mulResult_1 = _zz__zz_mulResult_1[7:0];
      end
    end
  end

  assign when_Fp32Unit_l161_1 = (($signed(_zz_when_Fp32Unit_l161_3) == $signed(10'h382)) && _zz_when_Fp32Unit_l153_1[23]);
  assign when_Fp32Unit_l163_1 = ($signed(10'h382) < $signed(_zz_when_Fp32Unit_l161_3));
  assign when_Fp32Unit_l155_1 = ($signed(10'h07f) < $signed(_zz_when_Fp32Unit_l161_3));
  assign when_Fp32Unit_l315 = ((decA_isInf && decB_isZero) || (decB_isInf && decA_isZero));
  assign when_Fp32Unit_l317 = (decA_isInf || decB_isInf);
  assign when_Fp32Unit_l319 = (decA_isZero || decB_isZero);
  always @(*) begin
    maxMinResult = io_a;
    if(when_Fp32Unit_l342) begin
      maxMinResult = 32'h7fc00000;
    end else begin
      if(decA_isNaN) begin
        maxMinResult = io_b;
      end else begin
        if(decB_isNaN) begin
          maxMinResult = io_a;
        end else begin
          if(when_Fp32Unit_l350) begin
            if(when_Fp32Unit_l351) begin
              maxMinResult = 32'h0;
            end else begin
              maxMinResult = (_zz_maxMinResult ? io_b : io_a);
            end
          end else begin
            if(when_Fp32Unit_l357) begin
              maxMinResult = 32'h80000000;
            end else begin
              maxMinResult = (_zz_maxMinResult ? io_a : io_b);
            end
          end
        end
      end
    end
  end

  assign when_Fp32Unit_l342 = (decA_isNaN && decB_isNaN);
  assign _zz_when_Fp32Unit_l208 = io_a[31];
  assign _zz_when_Fp32Unit_l210 = io_a[30 : 0];
  assign _zz_when_Fp32Unit_l210_1 = io_b[30 : 0];
  always @(*) begin
    _zz_maxMinResult = 1'b0;
    if(when_Fp32Unit_l206) begin
      _zz_maxMinResult = 1'b0;
    end else begin
      if(when_Fp32Unit_l208) begin
        _zz_maxMinResult = _zz_when_Fp32Unit_l208;
      end else begin
        if(when_Fp32Unit_l210) begin
          _zz_maxMinResult = 1'b0;
        end else begin
          if(when_Fp32Unit_l212) begin
            _zz_maxMinResult = (_zz_when_Fp32Unit_l210 < _zz_when_Fp32Unit_l210_1);
          end else begin
            _zz_maxMinResult = (_zz_when_Fp32Unit_l210_1 < _zz_when_Fp32Unit_l210);
          end
        end
      end
    end
  end

  assign when_Fp32Unit_l206 = ((io_a[30 : 0] == 31'h0) && (io_b[30 : 0] == 31'h0));
  assign when_Fp32Unit_l208 = (_zz_when_Fp32Unit_l208 != io_b[31]);
  assign when_Fp32Unit_l210 = (_zz_when_Fp32Unit_l210 == _zz_when_Fp32Unit_l210_1);
  assign when_Fp32Unit_l212 = (! _zz_when_Fp32Unit_l208);
  assign when_Fp32Unit_l350 = (io_mode == 5'h15);
  assign when_Fp32Unit_l351 = ((io_a[30 : 0] == 31'h0) && (io_b[30 : 0] == 31'h0));
  assign when_Fp32Unit_l357 = ((io_a[30 : 0] == 31'h0) && (io_b[30 : 0] == 31'h0));
  assign iMag = (io_a[31] ? _zz_iMag : io_a);
  assign _zz_i2fResult = io_a[31];
  always @(*) begin
    i2fResult = {_zz_i2fResult,31'h0};
    if(when_Fp32Unit_l177) begin
      i2fResult = _zz_i2fResult_1;
    end
  end

  assign when_Fp32Unit_l177 = (iMag != 32'h0);
  always @(*) begin
    _zz_when_Fp32Unit_l184 = 5'h0;
    if(when_Fp32Unit_l56_73) begin
      _zz_when_Fp32Unit_l184 = 5'h0;
    end
    if(when_Fp32Unit_l56_74) begin
      _zz_when_Fp32Unit_l184 = 5'h01;
    end
    if(when_Fp32Unit_l56_75) begin
      _zz_when_Fp32Unit_l184 = 5'h02;
    end
    if(when_Fp32Unit_l56_76) begin
      _zz_when_Fp32Unit_l184 = 5'h03;
    end
    if(when_Fp32Unit_l56_77) begin
      _zz_when_Fp32Unit_l184 = 5'h04;
    end
    if(when_Fp32Unit_l56_78) begin
      _zz_when_Fp32Unit_l184 = 5'h05;
    end
    if(when_Fp32Unit_l56_79) begin
      _zz_when_Fp32Unit_l184 = 5'h06;
    end
    if(when_Fp32Unit_l56_80) begin
      _zz_when_Fp32Unit_l184 = 5'h07;
    end
    if(when_Fp32Unit_l56_81) begin
      _zz_when_Fp32Unit_l184 = 5'h08;
    end
    if(when_Fp32Unit_l56_82) begin
      _zz_when_Fp32Unit_l184 = 5'h09;
    end
    if(when_Fp32Unit_l56_83) begin
      _zz_when_Fp32Unit_l184 = 5'h0a;
    end
    if(when_Fp32Unit_l56_84) begin
      _zz_when_Fp32Unit_l184 = 5'h0b;
    end
    if(when_Fp32Unit_l56_85) begin
      _zz_when_Fp32Unit_l184 = 5'h0c;
    end
    if(when_Fp32Unit_l56_86) begin
      _zz_when_Fp32Unit_l184 = 5'h0d;
    end
    if(when_Fp32Unit_l56_87) begin
      _zz_when_Fp32Unit_l184 = 5'h0e;
    end
    if(when_Fp32Unit_l56_88) begin
      _zz_when_Fp32Unit_l184 = 5'h0f;
    end
    if(when_Fp32Unit_l56_89) begin
      _zz_when_Fp32Unit_l184 = 5'h10;
    end
    if(when_Fp32Unit_l56_90) begin
      _zz_when_Fp32Unit_l184 = 5'h11;
    end
    if(when_Fp32Unit_l56_91) begin
      _zz_when_Fp32Unit_l184 = 5'h12;
    end
    if(when_Fp32Unit_l56_92) begin
      _zz_when_Fp32Unit_l184 = 5'h13;
    end
    if(when_Fp32Unit_l56_93) begin
      _zz_when_Fp32Unit_l184 = 5'h14;
    end
    if(when_Fp32Unit_l56_94) begin
      _zz_when_Fp32Unit_l184 = 5'h15;
    end
    if(when_Fp32Unit_l56_95) begin
      _zz_when_Fp32Unit_l184 = 5'h16;
    end
    if(when_Fp32Unit_l56_96) begin
      _zz_when_Fp32Unit_l184 = 5'h17;
    end
    if(when_Fp32Unit_l56_97) begin
      _zz_when_Fp32Unit_l184 = 5'h18;
    end
    if(when_Fp32Unit_l56_98) begin
      _zz_when_Fp32Unit_l184 = 5'h19;
    end
    if(when_Fp32Unit_l56_99) begin
      _zz_when_Fp32Unit_l184 = 5'h1a;
    end
    if(when_Fp32Unit_l56_100) begin
      _zz_when_Fp32Unit_l184 = 5'h1b;
    end
    if(when_Fp32Unit_l56_101) begin
      _zz_when_Fp32Unit_l184 = 5'h1c;
    end
    if(when_Fp32Unit_l56_102) begin
      _zz_when_Fp32Unit_l184 = 5'h1d;
    end
    if(when_Fp32Unit_l56_103) begin
      _zz_when_Fp32Unit_l184 = 5'h1e;
    end
    if(when_Fp32Unit_l56_104) begin
      _zz_when_Fp32Unit_l184 = 5'h1f;
    end
  end

  assign when_Fp32Unit_l56_73 = iMag[0];
  assign when_Fp32Unit_l56_74 = iMag[1];
  assign when_Fp32Unit_l56_75 = iMag[2];
  assign when_Fp32Unit_l56_76 = iMag[3];
  assign when_Fp32Unit_l56_77 = iMag[4];
  assign when_Fp32Unit_l56_78 = iMag[5];
  assign when_Fp32Unit_l56_79 = iMag[6];
  assign when_Fp32Unit_l56_80 = iMag[7];
  assign when_Fp32Unit_l56_81 = iMag[8];
  assign when_Fp32Unit_l56_82 = iMag[9];
  assign when_Fp32Unit_l56_83 = iMag[10];
  assign when_Fp32Unit_l56_84 = iMag[11];
  assign when_Fp32Unit_l56_85 = iMag[12];
  assign when_Fp32Unit_l56_86 = iMag[13];
  assign when_Fp32Unit_l56_87 = iMag[14];
  assign when_Fp32Unit_l56_88 = iMag[15];
  assign when_Fp32Unit_l56_89 = iMag[16];
  assign when_Fp32Unit_l56_90 = iMag[17];
  assign when_Fp32Unit_l56_91 = iMag[18];
  assign when_Fp32Unit_l56_92 = iMag[19];
  assign when_Fp32Unit_l56_93 = iMag[20];
  assign when_Fp32Unit_l56_94 = iMag[21];
  assign when_Fp32Unit_l56_95 = iMag[22];
  assign when_Fp32Unit_l56_96 = iMag[23];
  assign when_Fp32Unit_l56_97 = iMag[24];
  assign when_Fp32Unit_l56_98 = iMag[25];
  assign when_Fp32Unit_l56_99 = iMag[26];
  assign when_Fp32Unit_l56_100 = iMag[27];
  assign when_Fp32Unit_l56_101 = iMag[28];
  assign when_Fp32Unit_l56_102 = iMag[29];
  assign when_Fp32Unit_l56_103 = iMag[30];
  assign when_Fp32Unit_l56_104 = iMag[31];
  assign _zz_when_Fp32Unit_l148_9 = (_zz__zz_when_Fp32Unit_l148_9 <<< 3);
  always @(*) begin
    _zz_when_Fp32Unit_l148_10 = 27'h0;
    if(when_Fp32Unit_l184) begin
      _zz_when_Fp32Unit_l148_10 = _zz__zz_when_Fp32Unit_l148_10[26:0];
    end else begin
      _zz_when_Fp32Unit_l148_10 = _zz_when_Fp32Unit_l148_11;
    end
  end

  assign when_Fp32Unit_l184 = (_zz_when_Fp32Unit_l184 <= 5'h17);
  assign _zz_when_Fp32Unit_l67_2 = {1'd0, _zz__zz_when_Fp32Unit_l67_2};
  always @(*) begin
    _zz_when_Fp32Unit_l148_11 = 27'h0;
    if(when_Fp32Unit_l67_3) begin
      _zz_when_Fp32Unit_l148_11 = _zz_when_Fp32Unit_l148_9[26:0];
    end
    if(when_Fp32Unit_l72_93) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11 | _zz__zz_when_Fp32Unit_l148_11_2);
    end
    if(when_Fp32Unit_l72_94) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_4 | _zz__zz_when_Fp32Unit_l148_11_6);
    end
    if(when_Fp32Unit_l72_95) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_8 | _zz__zz_when_Fp32Unit_l148_11_10);
    end
    if(when_Fp32Unit_l72_96) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_12 | _zz__zz_when_Fp32Unit_l148_11_14);
    end
    if(when_Fp32Unit_l72_97) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_16 | _zz__zz_when_Fp32Unit_l148_11_18);
    end
    if(when_Fp32Unit_l72_98) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_20 | _zz__zz_when_Fp32Unit_l148_11_22);
    end
    if(when_Fp32Unit_l72_99) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_24 | _zz__zz_when_Fp32Unit_l148_11_26);
    end
    if(when_Fp32Unit_l72_100) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_28 | _zz__zz_when_Fp32Unit_l148_11_29);
    end
    if(when_Fp32Unit_l72_101) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_31 | _zz__zz_when_Fp32Unit_l148_11_33);
    end
    if(when_Fp32Unit_l72_102) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_35 | _zz__zz_when_Fp32Unit_l148_11_37);
    end
    if(when_Fp32Unit_l72_103) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_39 | _zz__zz_when_Fp32Unit_l148_11_41);
    end
    if(when_Fp32Unit_l72_104) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_43 | _zz__zz_when_Fp32Unit_l148_11_45);
    end
    if(when_Fp32Unit_l72_105) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_47 | _zz__zz_when_Fp32Unit_l148_11_49);
    end
    if(when_Fp32Unit_l72_106) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_51 | _zz__zz_when_Fp32Unit_l148_11_53);
    end
    if(when_Fp32Unit_l72_107) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_55 | _zz__zz_when_Fp32Unit_l148_11_57);
    end
    if(when_Fp32Unit_l72_108) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_59 | _zz__zz_when_Fp32Unit_l148_11_61);
    end
    if(when_Fp32Unit_l72_109) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_63 | _zz__zz_when_Fp32Unit_l148_11_65);
    end
    if(when_Fp32Unit_l72_110) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_67 | _zz__zz_when_Fp32Unit_l148_11_69);
    end
    if(when_Fp32Unit_l72_111) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_71 | _zz__zz_when_Fp32Unit_l148_11_73);
    end
    if(when_Fp32Unit_l72_112) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_75 | _zz__zz_when_Fp32Unit_l148_11_77);
    end
    if(when_Fp32Unit_l72_113) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_79 | _zz__zz_when_Fp32Unit_l148_11_81);
    end
    if(when_Fp32Unit_l72_114) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_83 | _zz__zz_when_Fp32Unit_l148_11_85);
    end
    if(when_Fp32Unit_l72_115) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_87 | _zz__zz_when_Fp32Unit_l148_11_89);
    end
    if(when_Fp32Unit_l72_116) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_91 | _zz__zz_when_Fp32Unit_l148_11_93);
    end
    if(when_Fp32Unit_l72_117) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_95 | _zz__zz_when_Fp32Unit_l148_11_97);
    end
    if(when_Fp32Unit_l72_118) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_99 | _zz__zz_when_Fp32Unit_l148_11_101);
    end
    if(when_Fp32Unit_l72_119) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_103 | _zz__zz_when_Fp32Unit_l148_11_105);
    end
    if(when_Fp32Unit_l72_120) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_107 | _zz__zz_when_Fp32Unit_l148_11_109);
    end
    if(when_Fp32Unit_l72_121) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_111 | _zz__zz_when_Fp32Unit_l148_11_113);
    end
    if(when_Fp32Unit_l72_122) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_115 | _zz__zz_when_Fp32Unit_l148_11_117);
    end
    if(when_Fp32Unit_l72_123) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_119 | _zz__zz_when_Fp32Unit_l148_11_121);
    end
    if(when_Fp32Unit_l72_124) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_123 | _zz__zz_when_Fp32Unit_l148_11_125);
    end
    if(when_Fp32Unit_l72_125) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_127 | _zz__zz_when_Fp32Unit_l148_11_129);
    end
    if(when_Fp32Unit_l72_126) begin
      _zz_when_Fp32Unit_l148_11 = (_zz__zz_when_Fp32Unit_l148_11_131 | _zz__zz_when_Fp32Unit_l148_11_133);
    end
    if(when_Fp32Unit_l83_3) begin
      _zz_when_Fp32Unit_l148_11 = {26'd0, _zz__zz_when_Fp32Unit_l148_11_135};
    end
  end

  assign when_Fp32Unit_l67_3 = (_zz_when_Fp32Unit_l67_2 == 6'h0);
  assign when_Fp32Unit_l72_93 = (_zz_when_Fp32Unit_l67_2 == 6'h01);
  assign when_Fp32Unit_l72_94 = (_zz_when_Fp32Unit_l67_2 == 6'h02);
  assign when_Fp32Unit_l72_95 = (_zz_when_Fp32Unit_l67_2 == 6'h03);
  assign when_Fp32Unit_l72_96 = (_zz_when_Fp32Unit_l67_2 == 6'h04);
  assign when_Fp32Unit_l72_97 = (_zz_when_Fp32Unit_l67_2 == 6'h05);
  assign when_Fp32Unit_l72_98 = (_zz_when_Fp32Unit_l67_2 == 6'h06);
  assign when_Fp32Unit_l72_99 = (_zz_when_Fp32Unit_l67_2 == 6'h07);
  assign when_Fp32Unit_l72_100 = (_zz_when_Fp32Unit_l67_2 == 6'h08);
  assign when_Fp32Unit_l72_101 = (_zz_when_Fp32Unit_l67_2 == 6'h09);
  assign when_Fp32Unit_l72_102 = (_zz_when_Fp32Unit_l67_2 == 6'h0a);
  assign when_Fp32Unit_l72_103 = (_zz_when_Fp32Unit_l67_2 == 6'h0b);
  assign when_Fp32Unit_l72_104 = (_zz_when_Fp32Unit_l67_2 == 6'h0c);
  assign when_Fp32Unit_l72_105 = (_zz_when_Fp32Unit_l67_2 == 6'h0d);
  assign when_Fp32Unit_l72_106 = (_zz_when_Fp32Unit_l67_2 == 6'h0e);
  assign when_Fp32Unit_l72_107 = (_zz_when_Fp32Unit_l67_2 == 6'h0f);
  assign when_Fp32Unit_l72_108 = (_zz_when_Fp32Unit_l67_2 == 6'h10);
  assign when_Fp32Unit_l72_109 = (_zz_when_Fp32Unit_l67_2 == 6'h11);
  assign when_Fp32Unit_l72_110 = (_zz_when_Fp32Unit_l67_2 == 6'h12);
  assign when_Fp32Unit_l72_111 = (_zz_when_Fp32Unit_l67_2 == 6'h13);
  assign when_Fp32Unit_l72_112 = (_zz_when_Fp32Unit_l67_2 == 6'h14);
  assign when_Fp32Unit_l72_113 = (_zz_when_Fp32Unit_l67_2 == 6'h15);
  assign when_Fp32Unit_l72_114 = (_zz_when_Fp32Unit_l67_2 == 6'h16);
  assign when_Fp32Unit_l72_115 = (_zz_when_Fp32Unit_l67_2 == 6'h17);
  assign when_Fp32Unit_l72_116 = (_zz_when_Fp32Unit_l67_2 == 6'h18);
  assign when_Fp32Unit_l72_117 = (_zz_when_Fp32Unit_l67_2 == 6'h19);
  assign when_Fp32Unit_l72_118 = (_zz_when_Fp32Unit_l67_2 == 6'h1a);
  assign when_Fp32Unit_l72_119 = (_zz_when_Fp32Unit_l67_2 == 6'h1b);
  assign when_Fp32Unit_l72_120 = (_zz_when_Fp32Unit_l67_2 == 6'h1c);
  assign when_Fp32Unit_l72_121 = (_zz_when_Fp32Unit_l67_2 == 6'h1d);
  assign when_Fp32Unit_l72_122 = (_zz_when_Fp32Unit_l67_2 == 6'h1e);
  assign when_Fp32Unit_l72_123 = (_zz_when_Fp32Unit_l67_2 == 6'h1f);
  assign when_Fp32Unit_l72_124 = (_zz_when_Fp32Unit_l67_2 == 6'h20);
  assign when_Fp32Unit_l72_125 = (_zz_when_Fp32Unit_l67_2 == 6'h21);
  assign when_Fp32Unit_l72_126 = (_zz_when_Fp32Unit_l67_2 == 6'h22);
  assign when_Fp32Unit_l83_3 = (6'h22 < _zz_when_Fp32Unit_l67_2);
  assign _zz_when_Fp32Unit_l124_1 = _zz__zz_when_Fp32Unit_l124_1;
  always @(*) begin
    _zz_i2fResult_1 = {_zz_i2fResult,31'h0};
    if(when_Fp32Unit_l153_2) begin
      _zz_i2fResult_1 = {_zz_i2fResult,31'h0};
    end else begin
      if(when_Fp32Unit_l155_2) begin
        _zz_i2fResult_1 = {{_zz_i2fResult,8'hff},23'h0};
      end else begin
        _zz_i2fResult_1 = {{_zz_i2fResult,_zz_i2fResult_2},_zz_when_Fp32Unit_l153_2[22 : 0]};
      end
    end
  end

  assign when_Fp32Unit_l124_2 = ($signed(_zz_when_Fp32Unit_l124_1) < $signed(10'h382));
  always @(*) begin
    _zz_when_Fp32Unit_l67_3 = 10'h0;
    if(when_Fp32Unit_l124_2) begin
      _zz_when_Fp32Unit_l67_3 = _zz__zz_when_Fp32Unit_l67_3;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_12 = _zz_when_Fp32Unit_l148_10;
    if(when_Fp32Unit_l124_2) begin
      _zz_when_Fp32Unit_l148_12 = _zz_when_Fp32Unit_l148_13;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_13 = 27'h0;
    if(when_Fp32Unit_l67_4) begin
      _zz_when_Fp32Unit_l148_13 = _zz_when_Fp32Unit_l148_10;
    end
    if(when_Fp32Unit_l72_127) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13 | _zz__zz_when_Fp32Unit_l148_13_2);
    end
    if(when_Fp32Unit_l72_128) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_4 | _zz__zz_when_Fp32Unit_l148_13_6);
    end
    if(when_Fp32Unit_l72_129) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_8 | _zz__zz_when_Fp32Unit_l148_13_10);
    end
    if(when_Fp32Unit_l72_130) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_12 | _zz__zz_when_Fp32Unit_l148_13_14);
    end
    if(when_Fp32Unit_l72_131) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_16 | _zz__zz_when_Fp32Unit_l148_13_18);
    end
    if(when_Fp32Unit_l72_132) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_20 | _zz__zz_when_Fp32Unit_l148_13_22);
    end
    if(when_Fp32Unit_l72_133) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_24 | _zz__zz_when_Fp32Unit_l148_13_26);
    end
    if(when_Fp32Unit_l72_134) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_28 | _zz__zz_when_Fp32Unit_l148_13_30);
    end
    if(when_Fp32Unit_l72_135) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_32 | _zz__zz_when_Fp32Unit_l148_13_34);
    end
    if(when_Fp32Unit_l72_136) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_36 | _zz__zz_when_Fp32Unit_l148_13_38);
    end
    if(when_Fp32Unit_l72_137) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_40 | _zz__zz_when_Fp32Unit_l148_13_42);
    end
    if(when_Fp32Unit_l72_138) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_44 | _zz__zz_when_Fp32Unit_l148_13_46);
    end
    if(when_Fp32Unit_l72_139) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_48 | _zz__zz_when_Fp32Unit_l148_13_50);
    end
    if(when_Fp32Unit_l72_140) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_52 | _zz__zz_when_Fp32Unit_l148_13_54);
    end
    if(when_Fp32Unit_l72_141) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_56 | _zz__zz_when_Fp32Unit_l148_13_58);
    end
    if(when_Fp32Unit_l72_142) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_60 | _zz__zz_when_Fp32Unit_l148_13_62);
    end
    if(when_Fp32Unit_l72_143) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_64 | _zz__zz_when_Fp32Unit_l148_13_66);
    end
    if(when_Fp32Unit_l72_144) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_68 | _zz__zz_when_Fp32Unit_l148_13_70);
    end
    if(when_Fp32Unit_l72_145) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_72 | _zz__zz_when_Fp32Unit_l148_13_74);
    end
    if(when_Fp32Unit_l72_146) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_76 | _zz__zz_when_Fp32Unit_l148_13_78);
    end
    if(when_Fp32Unit_l72_147) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_80 | _zz__zz_when_Fp32Unit_l148_13_82);
    end
    if(when_Fp32Unit_l72_148) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_84 | _zz__zz_when_Fp32Unit_l148_13_86);
    end
    if(when_Fp32Unit_l72_149) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_88 | _zz__zz_when_Fp32Unit_l148_13_90);
    end
    if(when_Fp32Unit_l72_150) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_92 | _zz__zz_when_Fp32Unit_l148_13_94);
    end
    if(when_Fp32Unit_l72_151) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_96 | _zz__zz_when_Fp32Unit_l148_13_98);
    end
    if(when_Fp32Unit_l72_152) begin
      _zz_when_Fp32Unit_l148_13 = (_zz__zz_when_Fp32Unit_l148_13_100 | _zz__zz_when_Fp32Unit_l148_13_102);
    end
    if(when_Fp32Unit_l72_153) begin
      _zz_when_Fp32Unit_l148_13 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_104};
    end
    if(when_Fp32Unit_l72_154) begin
      _zz_when_Fp32Unit_l148_13 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_105};
    end
    if(when_Fp32Unit_l72_155) begin
      _zz_when_Fp32Unit_l148_13 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_106};
    end
    if(when_Fp32Unit_l72_156) begin
      _zz_when_Fp32Unit_l148_13 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_107};
    end
    if(when_Fp32Unit_l72_157) begin
      _zz_when_Fp32Unit_l148_13 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_108};
    end
    if(when_Fp32Unit_l83_4) begin
      _zz_when_Fp32Unit_l148_13 = {26'd0, _zz__zz_when_Fp32Unit_l148_13_109};
    end
  end

  assign when_Fp32Unit_l67_4 = (_zz_when_Fp32Unit_l67_3 == 10'h0);
  assign when_Fp32Unit_l72_127 = (_zz_when_Fp32Unit_l67_3 == 10'h001);
  assign when_Fp32Unit_l72_128 = (_zz_when_Fp32Unit_l67_3 == 10'h002);
  assign when_Fp32Unit_l72_129 = (_zz_when_Fp32Unit_l67_3 == 10'h003);
  assign when_Fp32Unit_l72_130 = (_zz_when_Fp32Unit_l67_3 == 10'h004);
  assign when_Fp32Unit_l72_131 = (_zz_when_Fp32Unit_l67_3 == 10'h005);
  assign when_Fp32Unit_l72_132 = (_zz_when_Fp32Unit_l67_3 == 10'h006);
  assign when_Fp32Unit_l72_133 = (_zz_when_Fp32Unit_l67_3 == 10'h007);
  assign when_Fp32Unit_l72_134 = (_zz_when_Fp32Unit_l67_3 == 10'h008);
  assign when_Fp32Unit_l72_135 = (_zz_when_Fp32Unit_l67_3 == 10'h009);
  assign when_Fp32Unit_l72_136 = (_zz_when_Fp32Unit_l67_3 == 10'h00a);
  assign when_Fp32Unit_l72_137 = (_zz_when_Fp32Unit_l67_3 == 10'h00b);
  assign when_Fp32Unit_l72_138 = (_zz_when_Fp32Unit_l67_3 == 10'h00c);
  assign when_Fp32Unit_l72_139 = (_zz_when_Fp32Unit_l67_3 == 10'h00d);
  assign when_Fp32Unit_l72_140 = (_zz_when_Fp32Unit_l67_3 == 10'h00e);
  assign when_Fp32Unit_l72_141 = (_zz_when_Fp32Unit_l67_3 == 10'h00f);
  assign when_Fp32Unit_l72_142 = (_zz_when_Fp32Unit_l67_3 == 10'h010);
  assign when_Fp32Unit_l72_143 = (_zz_when_Fp32Unit_l67_3 == 10'h011);
  assign when_Fp32Unit_l72_144 = (_zz_when_Fp32Unit_l67_3 == 10'h012);
  assign when_Fp32Unit_l72_145 = (_zz_when_Fp32Unit_l67_3 == 10'h013);
  assign when_Fp32Unit_l72_146 = (_zz_when_Fp32Unit_l67_3 == 10'h014);
  assign when_Fp32Unit_l72_147 = (_zz_when_Fp32Unit_l67_3 == 10'h015);
  assign when_Fp32Unit_l72_148 = (_zz_when_Fp32Unit_l67_3 == 10'h016);
  assign when_Fp32Unit_l72_149 = (_zz_when_Fp32Unit_l67_3 == 10'h017);
  assign when_Fp32Unit_l72_150 = (_zz_when_Fp32Unit_l67_3 == 10'h018);
  assign when_Fp32Unit_l72_151 = (_zz_when_Fp32Unit_l67_3 == 10'h019);
  assign when_Fp32Unit_l72_152 = (_zz_when_Fp32Unit_l67_3 == 10'h01a);
  assign when_Fp32Unit_l72_153 = (_zz_when_Fp32Unit_l67_3 == 10'h01b);
  assign when_Fp32Unit_l72_154 = (_zz_when_Fp32Unit_l67_3 == 10'h01c);
  assign when_Fp32Unit_l72_155 = (_zz_when_Fp32Unit_l67_3 == 10'h01d);
  assign when_Fp32Unit_l72_156 = (_zz_when_Fp32Unit_l67_3 == 10'h01e);
  assign when_Fp32Unit_l72_157 = (_zz_when_Fp32Unit_l67_3 == 10'h01f);
  assign when_Fp32Unit_l83_4 = (10'h01f < _zz_when_Fp32Unit_l67_3);
  always @(*) begin
    _zz_when_Fp32Unit_l161_4 = _zz_when_Fp32Unit_l124_1;
    if(when_Fp32Unit_l124_2) begin
      _zz_when_Fp32Unit_l161_4 = 10'h382;
    end
  end

  assign _zz_when_Fp32Unit_l148_14 = _zz_when_Fp32Unit_l148_12[26 : 3];
  assign _zz_when_Fp32Unit_l148_15 = (_zz__zz_when_Fp32Unit_l148_15 + _zz__zz_when_Fp32Unit_l148_15_1);
  always @(*) begin
    _zz_when_Fp32Unit_l153_2 = _zz_when_Fp32Unit_l148_15[23 : 0];
    if(when_Fp32Unit_l148_2) begin
      _zz_when_Fp32Unit_l153_2 = _zz_when_Fp32Unit_l148_15[24 : 1];
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l161_5 = _zz_when_Fp32Unit_l161_4;
    if(when_Fp32Unit_l148_2) begin
      _zz_when_Fp32Unit_l161_5 = ($signed(_zz_when_Fp32Unit_l161_4) + $signed(10'h001));
    end
  end

  assign when_Fp32Unit_l148_2 = _zz_when_Fp32Unit_l148_15[24];
  assign when_Fp32Unit_l153_2 = (_zz_when_Fp32Unit_l153_2 == 24'h0);
  always @(*) begin
    _zz_i2fResult_2 = 8'h0;
    if(when_Fp32Unit_l161_2) begin
      _zz_i2fResult_2 = 8'h01;
    end else begin
      if(when_Fp32Unit_l163_2) begin
        _zz_i2fResult_2 = _zz__zz_i2fResult_2[7:0];
      end
    end
  end

  assign when_Fp32Unit_l161_2 = (($signed(_zz_when_Fp32Unit_l161_5) == $signed(10'h382)) && _zz_when_Fp32Unit_l153_2[23]);
  assign when_Fp32Unit_l163_2 = ($signed(10'h382) < $signed(_zz_when_Fp32Unit_l161_5));
  assign when_Fp32Unit_l155_2 = ($signed(10'h07f) < $signed(_zz_when_Fp32Unit_l161_5));
  assign _zz_u2fResult = 1'b0;
  always @(*) begin
    u2fResult = {_zz_u2fResult,31'h0};
    if(when_Fp32Unit_l177_1) begin
      u2fResult = _zz_u2fResult_1;
    end
  end

  assign when_Fp32Unit_l177_1 = (io_a != 32'h0);
  always @(*) begin
    _zz_when_Fp32Unit_l184_1 = 5'h0;
    if(when_Fp32Unit_l56_105) begin
      _zz_when_Fp32Unit_l184_1 = 5'h0;
    end
    if(when_Fp32Unit_l56_106) begin
      _zz_when_Fp32Unit_l184_1 = 5'h01;
    end
    if(when_Fp32Unit_l56_107) begin
      _zz_when_Fp32Unit_l184_1 = 5'h02;
    end
    if(when_Fp32Unit_l56_108) begin
      _zz_when_Fp32Unit_l184_1 = 5'h03;
    end
    if(when_Fp32Unit_l56_109) begin
      _zz_when_Fp32Unit_l184_1 = 5'h04;
    end
    if(when_Fp32Unit_l56_110) begin
      _zz_when_Fp32Unit_l184_1 = 5'h05;
    end
    if(when_Fp32Unit_l56_111) begin
      _zz_when_Fp32Unit_l184_1 = 5'h06;
    end
    if(when_Fp32Unit_l56_112) begin
      _zz_when_Fp32Unit_l184_1 = 5'h07;
    end
    if(when_Fp32Unit_l56_113) begin
      _zz_when_Fp32Unit_l184_1 = 5'h08;
    end
    if(when_Fp32Unit_l56_114) begin
      _zz_when_Fp32Unit_l184_1 = 5'h09;
    end
    if(when_Fp32Unit_l56_115) begin
      _zz_when_Fp32Unit_l184_1 = 5'h0a;
    end
    if(when_Fp32Unit_l56_116) begin
      _zz_when_Fp32Unit_l184_1 = 5'h0b;
    end
    if(when_Fp32Unit_l56_117) begin
      _zz_when_Fp32Unit_l184_1 = 5'h0c;
    end
    if(when_Fp32Unit_l56_118) begin
      _zz_when_Fp32Unit_l184_1 = 5'h0d;
    end
    if(when_Fp32Unit_l56_119) begin
      _zz_when_Fp32Unit_l184_1 = 5'h0e;
    end
    if(when_Fp32Unit_l56_120) begin
      _zz_when_Fp32Unit_l184_1 = 5'h0f;
    end
    if(when_Fp32Unit_l56_121) begin
      _zz_when_Fp32Unit_l184_1 = 5'h10;
    end
    if(when_Fp32Unit_l56_122) begin
      _zz_when_Fp32Unit_l184_1 = 5'h11;
    end
    if(when_Fp32Unit_l56_123) begin
      _zz_when_Fp32Unit_l184_1 = 5'h12;
    end
    if(when_Fp32Unit_l56_124) begin
      _zz_when_Fp32Unit_l184_1 = 5'h13;
    end
    if(when_Fp32Unit_l56_125) begin
      _zz_when_Fp32Unit_l184_1 = 5'h14;
    end
    if(when_Fp32Unit_l56_126) begin
      _zz_when_Fp32Unit_l184_1 = 5'h15;
    end
    if(when_Fp32Unit_l56_127) begin
      _zz_when_Fp32Unit_l184_1 = 5'h16;
    end
    if(when_Fp32Unit_l56_128) begin
      _zz_when_Fp32Unit_l184_1 = 5'h17;
    end
    if(when_Fp32Unit_l56_129) begin
      _zz_when_Fp32Unit_l184_1 = 5'h18;
    end
    if(when_Fp32Unit_l56_130) begin
      _zz_when_Fp32Unit_l184_1 = 5'h19;
    end
    if(when_Fp32Unit_l56_131) begin
      _zz_when_Fp32Unit_l184_1 = 5'h1a;
    end
    if(when_Fp32Unit_l56_132) begin
      _zz_when_Fp32Unit_l184_1 = 5'h1b;
    end
    if(when_Fp32Unit_l56_133) begin
      _zz_when_Fp32Unit_l184_1 = 5'h1c;
    end
    if(when_Fp32Unit_l56_134) begin
      _zz_when_Fp32Unit_l184_1 = 5'h1d;
    end
    if(when_Fp32Unit_l56_135) begin
      _zz_when_Fp32Unit_l184_1 = 5'h1e;
    end
    if(when_Fp32Unit_l56_136) begin
      _zz_when_Fp32Unit_l184_1 = 5'h1f;
    end
  end

  assign when_Fp32Unit_l56_105 = io_a[0];
  assign when_Fp32Unit_l56_106 = io_a[1];
  assign when_Fp32Unit_l56_107 = io_a[2];
  assign when_Fp32Unit_l56_108 = io_a[3];
  assign when_Fp32Unit_l56_109 = io_a[4];
  assign when_Fp32Unit_l56_110 = io_a[5];
  assign when_Fp32Unit_l56_111 = io_a[6];
  assign when_Fp32Unit_l56_112 = io_a[7];
  assign when_Fp32Unit_l56_113 = io_a[8];
  assign when_Fp32Unit_l56_114 = io_a[9];
  assign when_Fp32Unit_l56_115 = io_a[10];
  assign when_Fp32Unit_l56_116 = io_a[11];
  assign when_Fp32Unit_l56_117 = io_a[12];
  assign when_Fp32Unit_l56_118 = io_a[13];
  assign when_Fp32Unit_l56_119 = io_a[14];
  assign when_Fp32Unit_l56_120 = io_a[15];
  assign when_Fp32Unit_l56_121 = io_a[16];
  assign when_Fp32Unit_l56_122 = io_a[17];
  assign when_Fp32Unit_l56_123 = io_a[18];
  assign when_Fp32Unit_l56_124 = io_a[19];
  assign when_Fp32Unit_l56_125 = io_a[20];
  assign when_Fp32Unit_l56_126 = io_a[21];
  assign when_Fp32Unit_l56_127 = io_a[22];
  assign when_Fp32Unit_l56_128 = io_a[23];
  assign when_Fp32Unit_l56_129 = io_a[24];
  assign when_Fp32Unit_l56_130 = io_a[25];
  assign when_Fp32Unit_l56_131 = io_a[26];
  assign when_Fp32Unit_l56_132 = io_a[27];
  assign when_Fp32Unit_l56_133 = io_a[28];
  assign when_Fp32Unit_l56_134 = io_a[29];
  assign when_Fp32Unit_l56_135 = io_a[30];
  assign when_Fp32Unit_l56_136 = io_a[31];
  assign _zz_when_Fp32Unit_l148_16 = (_zz__zz_when_Fp32Unit_l148_16 <<< 3);
  always @(*) begin
    _zz_when_Fp32Unit_l148_17 = 27'h0;
    if(when_Fp32Unit_l184_1) begin
      _zz_when_Fp32Unit_l148_17 = _zz__zz_when_Fp32Unit_l148_17[26:0];
    end else begin
      _zz_when_Fp32Unit_l148_17 = _zz_when_Fp32Unit_l148_18;
    end
  end

  assign when_Fp32Unit_l184_1 = (_zz_when_Fp32Unit_l184_1 <= 5'h17);
  assign _zz_when_Fp32Unit_l67_4 = {1'd0, _zz__zz_when_Fp32Unit_l67_4};
  always @(*) begin
    _zz_when_Fp32Unit_l148_18 = 27'h0;
    if(when_Fp32Unit_l67_5) begin
      _zz_when_Fp32Unit_l148_18 = _zz_when_Fp32Unit_l148_16[26:0];
    end
    if(when_Fp32Unit_l72_158) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18 | _zz__zz_when_Fp32Unit_l148_18_2);
    end
    if(when_Fp32Unit_l72_159) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_4 | _zz__zz_when_Fp32Unit_l148_18_6);
    end
    if(when_Fp32Unit_l72_160) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_8 | _zz__zz_when_Fp32Unit_l148_18_10);
    end
    if(when_Fp32Unit_l72_161) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_12 | _zz__zz_when_Fp32Unit_l148_18_14);
    end
    if(when_Fp32Unit_l72_162) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_16 | _zz__zz_when_Fp32Unit_l148_18_18);
    end
    if(when_Fp32Unit_l72_163) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_20 | _zz__zz_when_Fp32Unit_l148_18_22);
    end
    if(when_Fp32Unit_l72_164) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_24 | _zz__zz_when_Fp32Unit_l148_18_26);
    end
    if(when_Fp32Unit_l72_165) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_28 | _zz__zz_when_Fp32Unit_l148_18_29);
    end
    if(when_Fp32Unit_l72_166) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_31 | _zz__zz_when_Fp32Unit_l148_18_33);
    end
    if(when_Fp32Unit_l72_167) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_35 | _zz__zz_when_Fp32Unit_l148_18_37);
    end
    if(when_Fp32Unit_l72_168) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_39 | _zz__zz_when_Fp32Unit_l148_18_41);
    end
    if(when_Fp32Unit_l72_169) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_43 | _zz__zz_when_Fp32Unit_l148_18_45);
    end
    if(when_Fp32Unit_l72_170) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_47 | _zz__zz_when_Fp32Unit_l148_18_49);
    end
    if(when_Fp32Unit_l72_171) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_51 | _zz__zz_when_Fp32Unit_l148_18_53);
    end
    if(when_Fp32Unit_l72_172) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_55 | _zz__zz_when_Fp32Unit_l148_18_57);
    end
    if(when_Fp32Unit_l72_173) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_59 | _zz__zz_when_Fp32Unit_l148_18_61);
    end
    if(when_Fp32Unit_l72_174) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_63 | _zz__zz_when_Fp32Unit_l148_18_65);
    end
    if(when_Fp32Unit_l72_175) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_67 | _zz__zz_when_Fp32Unit_l148_18_69);
    end
    if(when_Fp32Unit_l72_176) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_71 | _zz__zz_when_Fp32Unit_l148_18_73);
    end
    if(when_Fp32Unit_l72_177) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_75 | _zz__zz_when_Fp32Unit_l148_18_77);
    end
    if(when_Fp32Unit_l72_178) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_79 | _zz__zz_when_Fp32Unit_l148_18_81);
    end
    if(when_Fp32Unit_l72_179) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_83 | _zz__zz_when_Fp32Unit_l148_18_85);
    end
    if(when_Fp32Unit_l72_180) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_87 | _zz__zz_when_Fp32Unit_l148_18_89);
    end
    if(when_Fp32Unit_l72_181) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_91 | _zz__zz_when_Fp32Unit_l148_18_93);
    end
    if(when_Fp32Unit_l72_182) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_95 | _zz__zz_when_Fp32Unit_l148_18_97);
    end
    if(when_Fp32Unit_l72_183) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_99 | _zz__zz_when_Fp32Unit_l148_18_101);
    end
    if(when_Fp32Unit_l72_184) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_103 | _zz__zz_when_Fp32Unit_l148_18_105);
    end
    if(when_Fp32Unit_l72_185) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_107 | _zz__zz_when_Fp32Unit_l148_18_109);
    end
    if(when_Fp32Unit_l72_186) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_111 | _zz__zz_when_Fp32Unit_l148_18_113);
    end
    if(when_Fp32Unit_l72_187) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_115 | _zz__zz_when_Fp32Unit_l148_18_117);
    end
    if(when_Fp32Unit_l72_188) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_119 | _zz__zz_when_Fp32Unit_l148_18_121);
    end
    if(when_Fp32Unit_l72_189) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_123 | _zz__zz_when_Fp32Unit_l148_18_125);
    end
    if(when_Fp32Unit_l72_190) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_127 | _zz__zz_when_Fp32Unit_l148_18_129);
    end
    if(when_Fp32Unit_l72_191) begin
      _zz_when_Fp32Unit_l148_18 = (_zz__zz_when_Fp32Unit_l148_18_131 | _zz__zz_when_Fp32Unit_l148_18_133);
    end
    if(when_Fp32Unit_l83_5) begin
      _zz_when_Fp32Unit_l148_18 = {26'd0, _zz__zz_when_Fp32Unit_l148_18_135};
    end
  end

  assign when_Fp32Unit_l67_5 = (_zz_when_Fp32Unit_l67_4 == 6'h0);
  assign when_Fp32Unit_l72_158 = (_zz_when_Fp32Unit_l67_4 == 6'h01);
  assign when_Fp32Unit_l72_159 = (_zz_when_Fp32Unit_l67_4 == 6'h02);
  assign when_Fp32Unit_l72_160 = (_zz_when_Fp32Unit_l67_4 == 6'h03);
  assign when_Fp32Unit_l72_161 = (_zz_when_Fp32Unit_l67_4 == 6'h04);
  assign when_Fp32Unit_l72_162 = (_zz_when_Fp32Unit_l67_4 == 6'h05);
  assign when_Fp32Unit_l72_163 = (_zz_when_Fp32Unit_l67_4 == 6'h06);
  assign when_Fp32Unit_l72_164 = (_zz_when_Fp32Unit_l67_4 == 6'h07);
  assign when_Fp32Unit_l72_165 = (_zz_when_Fp32Unit_l67_4 == 6'h08);
  assign when_Fp32Unit_l72_166 = (_zz_when_Fp32Unit_l67_4 == 6'h09);
  assign when_Fp32Unit_l72_167 = (_zz_when_Fp32Unit_l67_4 == 6'h0a);
  assign when_Fp32Unit_l72_168 = (_zz_when_Fp32Unit_l67_4 == 6'h0b);
  assign when_Fp32Unit_l72_169 = (_zz_when_Fp32Unit_l67_4 == 6'h0c);
  assign when_Fp32Unit_l72_170 = (_zz_when_Fp32Unit_l67_4 == 6'h0d);
  assign when_Fp32Unit_l72_171 = (_zz_when_Fp32Unit_l67_4 == 6'h0e);
  assign when_Fp32Unit_l72_172 = (_zz_when_Fp32Unit_l67_4 == 6'h0f);
  assign when_Fp32Unit_l72_173 = (_zz_when_Fp32Unit_l67_4 == 6'h10);
  assign when_Fp32Unit_l72_174 = (_zz_when_Fp32Unit_l67_4 == 6'h11);
  assign when_Fp32Unit_l72_175 = (_zz_when_Fp32Unit_l67_4 == 6'h12);
  assign when_Fp32Unit_l72_176 = (_zz_when_Fp32Unit_l67_4 == 6'h13);
  assign when_Fp32Unit_l72_177 = (_zz_when_Fp32Unit_l67_4 == 6'h14);
  assign when_Fp32Unit_l72_178 = (_zz_when_Fp32Unit_l67_4 == 6'h15);
  assign when_Fp32Unit_l72_179 = (_zz_when_Fp32Unit_l67_4 == 6'h16);
  assign when_Fp32Unit_l72_180 = (_zz_when_Fp32Unit_l67_4 == 6'h17);
  assign when_Fp32Unit_l72_181 = (_zz_when_Fp32Unit_l67_4 == 6'h18);
  assign when_Fp32Unit_l72_182 = (_zz_when_Fp32Unit_l67_4 == 6'h19);
  assign when_Fp32Unit_l72_183 = (_zz_when_Fp32Unit_l67_4 == 6'h1a);
  assign when_Fp32Unit_l72_184 = (_zz_when_Fp32Unit_l67_4 == 6'h1b);
  assign when_Fp32Unit_l72_185 = (_zz_when_Fp32Unit_l67_4 == 6'h1c);
  assign when_Fp32Unit_l72_186 = (_zz_when_Fp32Unit_l67_4 == 6'h1d);
  assign when_Fp32Unit_l72_187 = (_zz_when_Fp32Unit_l67_4 == 6'h1e);
  assign when_Fp32Unit_l72_188 = (_zz_when_Fp32Unit_l67_4 == 6'h1f);
  assign when_Fp32Unit_l72_189 = (_zz_when_Fp32Unit_l67_4 == 6'h20);
  assign when_Fp32Unit_l72_190 = (_zz_when_Fp32Unit_l67_4 == 6'h21);
  assign when_Fp32Unit_l72_191 = (_zz_when_Fp32Unit_l67_4 == 6'h22);
  assign when_Fp32Unit_l83_5 = (6'h22 < _zz_when_Fp32Unit_l67_4);
  assign _zz_when_Fp32Unit_l124_2 = _zz__zz_when_Fp32Unit_l124_2;
  always @(*) begin
    _zz_u2fResult_1 = {_zz_u2fResult,31'h0};
    if(when_Fp32Unit_l153_3) begin
      _zz_u2fResult_1 = {_zz_u2fResult,31'h0};
    end else begin
      if(when_Fp32Unit_l155_3) begin
        _zz_u2fResult_1 = {{_zz_u2fResult,8'hff},23'h0};
      end else begin
        _zz_u2fResult_1 = {{_zz_u2fResult,_zz_u2fResult_2},_zz_when_Fp32Unit_l153_3[22 : 0]};
      end
    end
  end

  assign when_Fp32Unit_l124_3 = ($signed(_zz_when_Fp32Unit_l124_2) < $signed(10'h382));
  always @(*) begin
    _zz_when_Fp32Unit_l67_5 = 10'h0;
    if(when_Fp32Unit_l124_3) begin
      _zz_when_Fp32Unit_l67_5 = _zz__zz_when_Fp32Unit_l67_5;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_19 = _zz_when_Fp32Unit_l148_17;
    if(when_Fp32Unit_l124_3) begin
      _zz_when_Fp32Unit_l148_19 = _zz_when_Fp32Unit_l148_20;
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l148_20 = 27'h0;
    if(when_Fp32Unit_l67_6) begin
      _zz_when_Fp32Unit_l148_20 = _zz_when_Fp32Unit_l148_17;
    end
    if(when_Fp32Unit_l72_192) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20 | _zz__zz_when_Fp32Unit_l148_20_2);
    end
    if(when_Fp32Unit_l72_193) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_4 | _zz__zz_when_Fp32Unit_l148_20_6);
    end
    if(when_Fp32Unit_l72_194) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_8 | _zz__zz_when_Fp32Unit_l148_20_10);
    end
    if(when_Fp32Unit_l72_195) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_12 | _zz__zz_when_Fp32Unit_l148_20_14);
    end
    if(when_Fp32Unit_l72_196) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_16 | _zz__zz_when_Fp32Unit_l148_20_18);
    end
    if(when_Fp32Unit_l72_197) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_20 | _zz__zz_when_Fp32Unit_l148_20_22);
    end
    if(when_Fp32Unit_l72_198) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_24 | _zz__zz_when_Fp32Unit_l148_20_26);
    end
    if(when_Fp32Unit_l72_199) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_28 | _zz__zz_when_Fp32Unit_l148_20_30);
    end
    if(when_Fp32Unit_l72_200) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_32 | _zz__zz_when_Fp32Unit_l148_20_34);
    end
    if(when_Fp32Unit_l72_201) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_36 | _zz__zz_when_Fp32Unit_l148_20_38);
    end
    if(when_Fp32Unit_l72_202) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_40 | _zz__zz_when_Fp32Unit_l148_20_42);
    end
    if(when_Fp32Unit_l72_203) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_44 | _zz__zz_when_Fp32Unit_l148_20_46);
    end
    if(when_Fp32Unit_l72_204) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_48 | _zz__zz_when_Fp32Unit_l148_20_50);
    end
    if(when_Fp32Unit_l72_205) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_52 | _zz__zz_when_Fp32Unit_l148_20_54);
    end
    if(when_Fp32Unit_l72_206) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_56 | _zz__zz_when_Fp32Unit_l148_20_58);
    end
    if(when_Fp32Unit_l72_207) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_60 | _zz__zz_when_Fp32Unit_l148_20_62);
    end
    if(when_Fp32Unit_l72_208) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_64 | _zz__zz_when_Fp32Unit_l148_20_66);
    end
    if(when_Fp32Unit_l72_209) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_68 | _zz__zz_when_Fp32Unit_l148_20_70);
    end
    if(when_Fp32Unit_l72_210) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_72 | _zz__zz_when_Fp32Unit_l148_20_74);
    end
    if(when_Fp32Unit_l72_211) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_76 | _zz__zz_when_Fp32Unit_l148_20_78);
    end
    if(when_Fp32Unit_l72_212) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_80 | _zz__zz_when_Fp32Unit_l148_20_82);
    end
    if(when_Fp32Unit_l72_213) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_84 | _zz__zz_when_Fp32Unit_l148_20_86);
    end
    if(when_Fp32Unit_l72_214) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_88 | _zz__zz_when_Fp32Unit_l148_20_90);
    end
    if(when_Fp32Unit_l72_215) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_92 | _zz__zz_when_Fp32Unit_l148_20_94);
    end
    if(when_Fp32Unit_l72_216) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_96 | _zz__zz_when_Fp32Unit_l148_20_98);
    end
    if(when_Fp32Unit_l72_217) begin
      _zz_when_Fp32Unit_l148_20 = (_zz__zz_when_Fp32Unit_l148_20_100 | _zz__zz_when_Fp32Unit_l148_20_102);
    end
    if(when_Fp32Unit_l72_218) begin
      _zz_when_Fp32Unit_l148_20 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_104};
    end
    if(when_Fp32Unit_l72_219) begin
      _zz_when_Fp32Unit_l148_20 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_105};
    end
    if(when_Fp32Unit_l72_220) begin
      _zz_when_Fp32Unit_l148_20 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_106};
    end
    if(when_Fp32Unit_l72_221) begin
      _zz_when_Fp32Unit_l148_20 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_107};
    end
    if(when_Fp32Unit_l72_222) begin
      _zz_when_Fp32Unit_l148_20 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_108};
    end
    if(when_Fp32Unit_l83_6) begin
      _zz_when_Fp32Unit_l148_20 = {26'd0, _zz__zz_when_Fp32Unit_l148_20_109};
    end
  end

  assign when_Fp32Unit_l67_6 = (_zz_when_Fp32Unit_l67_5 == 10'h0);
  assign when_Fp32Unit_l72_192 = (_zz_when_Fp32Unit_l67_5 == 10'h001);
  assign when_Fp32Unit_l72_193 = (_zz_when_Fp32Unit_l67_5 == 10'h002);
  assign when_Fp32Unit_l72_194 = (_zz_when_Fp32Unit_l67_5 == 10'h003);
  assign when_Fp32Unit_l72_195 = (_zz_when_Fp32Unit_l67_5 == 10'h004);
  assign when_Fp32Unit_l72_196 = (_zz_when_Fp32Unit_l67_5 == 10'h005);
  assign when_Fp32Unit_l72_197 = (_zz_when_Fp32Unit_l67_5 == 10'h006);
  assign when_Fp32Unit_l72_198 = (_zz_when_Fp32Unit_l67_5 == 10'h007);
  assign when_Fp32Unit_l72_199 = (_zz_when_Fp32Unit_l67_5 == 10'h008);
  assign when_Fp32Unit_l72_200 = (_zz_when_Fp32Unit_l67_5 == 10'h009);
  assign when_Fp32Unit_l72_201 = (_zz_when_Fp32Unit_l67_5 == 10'h00a);
  assign when_Fp32Unit_l72_202 = (_zz_when_Fp32Unit_l67_5 == 10'h00b);
  assign when_Fp32Unit_l72_203 = (_zz_when_Fp32Unit_l67_5 == 10'h00c);
  assign when_Fp32Unit_l72_204 = (_zz_when_Fp32Unit_l67_5 == 10'h00d);
  assign when_Fp32Unit_l72_205 = (_zz_when_Fp32Unit_l67_5 == 10'h00e);
  assign when_Fp32Unit_l72_206 = (_zz_when_Fp32Unit_l67_5 == 10'h00f);
  assign when_Fp32Unit_l72_207 = (_zz_when_Fp32Unit_l67_5 == 10'h010);
  assign when_Fp32Unit_l72_208 = (_zz_when_Fp32Unit_l67_5 == 10'h011);
  assign when_Fp32Unit_l72_209 = (_zz_when_Fp32Unit_l67_5 == 10'h012);
  assign when_Fp32Unit_l72_210 = (_zz_when_Fp32Unit_l67_5 == 10'h013);
  assign when_Fp32Unit_l72_211 = (_zz_when_Fp32Unit_l67_5 == 10'h014);
  assign when_Fp32Unit_l72_212 = (_zz_when_Fp32Unit_l67_5 == 10'h015);
  assign when_Fp32Unit_l72_213 = (_zz_when_Fp32Unit_l67_5 == 10'h016);
  assign when_Fp32Unit_l72_214 = (_zz_when_Fp32Unit_l67_5 == 10'h017);
  assign when_Fp32Unit_l72_215 = (_zz_when_Fp32Unit_l67_5 == 10'h018);
  assign when_Fp32Unit_l72_216 = (_zz_when_Fp32Unit_l67_5 == 10'h019);
  assign when_Fp32Unit_l72_217 = (_zz_when_Fp32Unit_l67_5 == 10'h01a);
  assign when_Fp32Unit_l72_218 = (_zz_when_Fp32Unit_l67_5 == 10'h01b);
  assign when_Fp32Unit_l72_219 = (_zz_when_Fp32Unit_l67_5 == 10'h01c);
  assign when_Fp32Unit_l72_220 = (_zz_when_Fp32Unit_l67_5 == 10'h01d);
  assign when_Fp32Unit_l72_221 = (_zz_when_Fp32Unit_l67_5 == 10'h01e);
  assign when_Fp32Unit_l72_222 = (_zz_when_Fp32Unit_l67_5 == 10'h01f);
  assign when_Fp32Unit_l83_6 = (10'h01f < _zz_when_Fp32Unit_l67_5);
  always @(*) begin
    _zz_when_Fp32Unit_l161_6 = _zz_when_Fp32Unit_l124_2;
    if(when_Fp32Unit_l124_3) begin
      _zz_when_Fp32Unit_l161_6 = 10'h382;
    end
  end

  assign _zz_when_Fp32Unit_l148_21 = _zz_when_Fp32Unit_l148_19[26 : 3];
  assign _zz_when_Fp32Unit_l148_22 = (_zz__zz_when_Fp32Unit_l148_22 + _zz__zz_when_Fp32Unit_l148_22_1);
  always @(*) begin
    _zz_when_Fp32Unit_l153_3 = _zz_when_Fp32Unit_l148_22[23 : 0];
    if(when_Fp32Unit_l148_3) begin
      _zz_when_Fp32Unit_l153_3 = _zz_when_Fp32Unit_l148_22[24 : 1];
    end
  end

  always @(*) begin
    _zz_when_Fp32Unit_l161_7 = _zz_when_Fp32Unit_l161_6;
    if(when_Fp32Unit_l148_3) begin
      _zz_when_Fp32Unit_l161_7 = ($signed(_zz_when_Fp32Unit_l161_6) + $signed(10'h001));
    end
  end

  assign when_Fp32Unit_l148_3 = _zz_when_Fp32Unit_l148_22[24];
  assign when_Fp32Unit_l153_3 = (_zz_when_Fp32Unit_l153_3 == 24'h0);
  always @(*) begin
    _zz_u2fResult_2 = 8'h0;
    if(when_Fp32Unit_l161_3) begin
      _zz_u2fResult_2 = 8'h01;
    end else begin
      if(when_Fp32Unit_l163_3) begin
        _zz_u2fResult_2 = _zz__zz_u2fResult_2[7:0];
      end
    end
  end

  assign when_Fp32Unit_l161_3 = (($signed(_zz_when_Fp32Unit_l161_7) == $signed(10'h382)) && _zz_when_Fp32Unit_l153_3[23]);
  assign when_Fp32Unit_l163_3 = ($signed(10'h382) < $signed(_zz_when_Fp32Unit_l161_7));
  assign when_Fp32Unit_l155_3 = ($signed(10'h07f) < $signed(_zz_when_Fp32Unit_l161_7));
  always @(*) begin
    intMagnitude = 33'h0;
    if(when_Fp32Unit_l372) begin
      if(when_Fp32Unit_l373) begin
        intMagnitude = (_zz_intMagnitude <<< _zz_intMagnitude_1);
      end else begin
        intMagnitude = {9'd0, _zz_intMagnitude_4};
      end
    end
  end

  assign when_Fp32Unit_l372 = ((((! decA_isNaN) && (! decA_isInf)) && (! decA_isZero)) && ($signed(10'h0) <= $signed(decA_exp)));
  assign when_Fp32Unit_l373 = ($signed(10'h017) <= $signed(decA_exp));
  always @(*) begin
    f2iResult = 32'h0;
    if(decA_isNaN) begin
      f2iResult = 32'h0;
    end else begin
      if(decA_isInf) begin
        f2iResult = (decA_sign ? 32'h80000000 : 32'h7fffffff);
      end else begin
        if(when_Fp32Unit_l388) begin
          f2iResult = 32'h0;
        end else begin
          if(when_Fp32Unit_l390) begin
            if(when_Fp32Unit_l391) begin
              f2iResult = 32'h7fffffff;
            end else begin
              f2iResult = intMagnitude[31 : 0];
            end
          end else begin
            if(when_Fp32Unit_l397) begin
              f2iResult = 32'h80000000;
            end else begin
              f2iResult = _zz_f2iResult;
            end
          end
        end
      end
    end
  end

  assign when_Fp32Unit_l391 = (($signed(10'h01e) < $signed(decA_exp)) || (33'h07fffffff < intMagnitude));
  assign when_Fp32Unit_l397 = (($signed(10'h01f) < $signed(decA_exp)) || (33'h080000000 < intMagnitude));
  assign when_Fp32Unit_l388 = (decA_isZero || ($signed(decA_exp) < $signed(10'h0)));
  assign when_Fp32Unit_l390 = (! decA_sign);
  always @(*) begin
    f2uResult = 32'h0;
    if(decA_isNaN) begin
      f2uResult = 32'h0;
    end else begin
      if(decA_isInf) begin
        f2uResult = (decA_sign ? 32'h0 : 32'hffffffff);
      end else begin
        if(when_Fp32Unit_l410) begin
          f2uResult = 32'h0;
        end else begin
          if(when_Fp32Unit_l412) begin
            f2uResult = 32'hffffffff;
          end else begin
            f2uResult = intMagnitude[31 : 0];
          end
        end
      end
    end
  end

  assign when_Fp32Unit_l410 = ((decA_sign || decA_isZero) || ($signed(decA_exp) < $signed(10'h0)));
  assign when_Fp32Unit_l412 = (($signed(10'h01f) < $signed(decA_exp)) || (33'h0ffffffff < intMagnitude));
  always @(*) begin
    addClassResult = addResult;
    case(io_mode)
      5'h12 : begin
        addClassResult = addResult;
      end
      5'h13 : begin
        addClassResult = addResult;
      end
      5'h15 : begin
        addClassResult = maxMinResult;
      end
      5'h16 : begin
        addClassResult = maxMinResult;
      end
      5'h17 : begin
        addClassResult = i2fResult;
      end
      5'h19 : begin
        addClassResult = u2fResult;
      end
      5'h18 : begin
        addClassResult = f2iResult;
      end
      5'h1a : begin
        addClassResult = f2uResult;
      end
      default : begin
      end
    endcase
  end

  assign addBusy = (((addValids_0 || addValids_1) || addValids_2) || addValids_3);
  assign mulBusy = ((((mulValids_0 || mulValids_1) || mulValids_2) || mulValids_3) || mulValids_4);
  assign io_busy = (addBusy || mulBusy);
  assign io_done = (addValids_3 || mulValids_4);
  assign io_result = (mulValids_4 ? mulResults_4 : addResults_3);
  assign io_tagOut = (mulValids_4 ? mulTags_4 : addTags_3);
  assign when_Fp32Unit_l460 = (io_fire && (! io_busy));
  assign when_Fp32Unit_l461 = (io_mode == 5'h14);
  always @(posedge clk) begin
    if(reset) begin
      addValids_0 <= 1'b0;
      addValids_1 <= 1'b0;
      addValids_2 <= 1'b0;
      addValids_3 <= 1'b0;
      addResults_0 <= 32'h0;
      addResults_1 <= 32'h0;
      addResults_2 <= 32'h0;
      addResults_3 <= 32'h0;
      addTags_0 <= 11'h0;
      addTags_1 <= 11'h0;
      addTags_2 <= 11'h0;
      addTags_3 <= 11'h0;
      mulValids_0 <= 1'b0;
      mulValids_1 <= 1'b0;
      mulValids_2 <= 1'b0;
      mulValids_3 <= 1'b0;
      mulValids_4 <= 1'b0;
      mulResults_0 <= 32'h0;
      mulResults_1 <= 32'h0;
      mulResults_2 <= 32'h0;
      mulResults_3 <= 32'h0;
      mulResults_4 <= 32'h0;
      mulTags_0 <= 11'h0;
      mulTags_1 <= 11'h0;
      mulTags_2 <= 11'h0;
      mulTags_3 <= 11'h0;
      mulTags_4 <= 11'h0;
    end else begin
      addValids_3 <= addValids_2;
      addResults_3 <= addResults_2;
      addTags_3 <= addTags_2;
      addValids_2 <= addValids_1;
      addResults_2 <= addResults_1;
      addTags_2 <= addTags_1;
      addValids_1 <= addValids_0;
      addResults_1 <= addResults_0;
      addTags_1 <= addTags_0;
      addValids_0 <= 1'b0;
      mulValids_4 <= mulValids_3;
      mulResults_4 <= mulResults_3;
      mulTags_4 <= mulTags_3;
      mulValids_3 <= mulValids_2;
      mulResults_3 <= mulResults_2;
      mulTags_3 <= mulTags_2;
      mulValids_2 <= mulValids_1;
      mulResults_2 <= mulResults_1;
      mulTags_2 <= mulTags_1;
      mulValids_1 <= mulValids_0;
      mulResults_1 <= mulResults_0;
      mulTags_1 <= mulTags_0;
      mulValids_0 <= 1'b0;
      if(when_Fp32Unit_l460) begin
        if(when_Fp32Unit_l461) begin
          mulValids_0 <= 1'b1;
          mulResults_0 <= mulResult;
          mulTags_0 <= io_tagIn;
        end else begin
          addValids_0 <= 1'b1;
          addResults_0 <= addClassResult;
          addTags_0 <= io_tagIn;
        end
      end
    end
  end


endmodule

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
