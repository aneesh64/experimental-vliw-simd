// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : AluEngine
// Git hash  : 2b1c34e10fcfebdb7017c9a507f6d279f35a00fa

`timescale 1ns/1ps

module AluEngine (
  input  wire          io_slots_0_valid,
  input  wire [3:0]    io_slots_0_opcode,
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
  wire                unsignedDivider_1_io_done;
  wire                unsignedDivider_1_io_busy;
  wire       [31:0]   unsignedDivider_1_io_quotient;
  wire       [31:0]   unsignedDivider_1_io_remainder;
  wire       [31:0]   _zz_io_dividend;
  wire       [31:0]   _zz_io_dividend_1;
  wire       [63:0]   _zz__zz_io_writeReqs_0_payload_data_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_payload_data_1_1;
  wire       [0:0]    _zz__zz_io_writeReqs_0_payload_data_1_2;
  wire                _zz_io_writeReqs_0_valid;
  reg        [10:0]   _zz_io_writeReqs_0_payload_addr;
  reg        [1:0]    _zz_io_writeReqs_0_payload_data;
  wire                _zz_io_writeReqs_0_valid_1;
  wire                when_AluEngine_l61;
  wire                when_AluEngine_l63;
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
  assign _zz_io_writeReqs_0_valid = (io_slots_0_valid && io_valid);
  assign _zz_io_writeReqs_0_valid_1 = (((io_slots_0_opcode == 4'b1010) || (io_slots_0_opcode == 4'b1011)) || (io_slots_0_opcode == 4'b1100));
  assign unsignedDivider_1_io_start = ((_zz_io_writeReqs_0_valid && _zz_io_writeReqs_0_valid_1) && (! unsignedDivider_1_io_busy));
  assign unsignedDivider_1_io_dividend = ((io_slots_0_opcode == 4'b1100) ? _zz_io_dividend : io_operandA_0);
  assign when_AluEngine_l61 = (io_slots_0_opcode == 4'b1010);
  assign when_AluEngine_l63 = (io_slots_0_opcode == 4'b1011);
  always @(*) begin
    _zz_io_writeReqs_0_payload_data_1 = 32'h0;
    case(io_slots_0_opcode)
      4'b0000 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 + io_operandB_0);
      end
      4'b0001 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 - io_operandB_0);
      end
      4'b0010 : begin
        _zz_io_writeReqs_0_payload_data_1 = _zz__zz_io_writeReqs_0_payload_data_1[31:0];
      end
      4'b0011 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 ^ io_operandB_0);
      end
      4'b0100 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 & io_operandB_0);
      end
      4'b0101 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 | io_operandB_0);
      end
      4'b0110 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 <<< io_operandB_0[4 : 0]);
      end
      4'b0111 : begin
        _zz_io_writeReqs_0_payload_data_1 = (io_operandA_0 >>> io_operandB_0[4 : 0]);
      end
      4'b1000 : begin
        _zz_io_writeReqs_0_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_payload_data_1_1};
      end
      4'b1001 : begin
        _zz_io_writeReqs_0_payload_data_1 = {31'd0, _zz__zz_io_writeReqs_0_payload_data_1_2};
      end
      default : begin
      end
    endcase
  end

  assign io_writeReqs_0_valid = (unsignedDivider_1_io_done || (_zz_io_writeReqs_0_valid && (! _zz_io_writeReqs_0_valid_1)));
  assign io_writeReqs_0_payload_addr = (unsignedDivider_1_io_done ? _zz_io_writeReqs_0_payload_addr : io_slots_0_dest);
  assign io_writeReqs_0_payload_data = (unsignedDivider_1_io_done ? ((_zz_io_writeReqs_0_payload_data == 2'b00) ? unsignedDivider_1_io_remainder : unsignedDivider_1_io_quotient) : _zz_io_writeReqs_0_payload_data_1);
  always @(posedge clk) begin
    if(reset) begin
      _zz_io_writeReqs_0_payload_addr <= 11'h0;
      _zz_io_writeReqs_0_payload_data <= 2'b00;
    end else begin
      if(unsignedDivider_1_io_start) begin
        _zz_io_writeReqs_0_payload_addr <= io_slots_0_dest;
        if(when_AluEngine_l61) begin
          _zz_io_writeReqs_0_payload_data <= 2'b00;
        end else begin
          if(when_AluEngine_l63) begin
            _zz_io_writeReqs_0_payload_data <= 2'b01;
          end else begin
            _zz_io_writeReqs_0_payload_data <= 2'b10;
          end
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
