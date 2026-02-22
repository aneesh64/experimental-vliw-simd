// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : UnsignedDivider

`timescale 1ns/1ps

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
