// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : FetchUnit
// Git hash  : 2b1c34e10fcfebdb7017c9a507f6d279f35a00fa

`timescale 1ns/1ps

module FetchUnit (
  output wire [9:0]    io_imemAddr,
  input  wire [255:0]  io_imemData,
  output wire [255:0]  io_exBundle,
  output wire          io_exValid,
  input  wire          io_jump_valid,
  input  wire [9:0]    io_jump_payload,
  input  wire          io_halt,
  input  wire          io_start,
  input  wire          io_stall,
  output wire [9:0]    io_pc,
  output wire          io_running,
  output wire          io_halted,
  input  wire          clk,
  input  wire          reset
);
  localparam CoreState_IDLE = 2'd0;
  localparam CoreState_RUNNING = 2'd1;
  localparam CoreState_HALTED = 2'd2;

  reg        [1:0]    state;
  reg        [9:0]    pc;
  wire                cycleActive;
  reg        [255:0]  exBundleReg;
  reg                 exValidReg;
  reg                 startupBubble;
  wire                when_FetchUnit_l90;
  `ifndef SYNTHESIS
  reg [55:0] state_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(state)
      CoreState_IDLE : state_string = "IDLE   ";
      CoreState_RUNNING : state_string = "RUNNING";
      CoreState_HALTED : state_string = "HALTED ";
      default : state_string = "???????";
    endcase
  end
  `endif

  assign cycleActive = (state == CoreState_RUNNING);
  assign io_imemAddr = pc;
  assign when_FetchUnit_l90 = (! io_stall);
  assign io_exBundle = exBundleReg;
  assign io_exValid = exValidReg;
  assign io_pc = pc;
  assign io_running = cycleActive;
  assign io_halted = (state == CoreState_HALTED);
  always @(posedge clk) begin
    if(reset) begin
      state <= CoreState_IDLE;
      pc <= 10'h0;
      exBundleReg <= 256'h0;
      exValidReg <= 1'b0;
      startupBubble <= 1'b0;
    end else begin
      case(state)
        CoreState_IDLE : begin
          if(io_start) begin
            state <= CoreState_RUNNING;
            pc <= 10'h0;
            startupBubble <= 1'b1;
          end
        end
        CoreState_RUNNING : begin
          if(io_halt) begin
            state <= CoreState_HALTED;
          end
        end
        default : begin
          if(io_start) begin
            state <= CoreState_RUNNING;
            pc <= 10'h0;
            startupBubble <= 1'b1;
          end
        end
      endcase
      if(when_FetchUnit_l90) begin
        if(cycleActive) begin
          if(startupBubble) begin
            startupBubble <= 1'b0;
            exValidReg <= 1'b0;
            pc <= (pc + 10'h001);
          end else begin
            if(io_jump_valid) begin
              pc <= io_jump_payload;
              exValidReg <= 1'b0;
              exBundleReg <= 256'h0;
            end else begin
              if(io_halt) begin
                exValidReg <= 1'b0;
              end else begin
                exBundleReg <= io_imemData;
                exValidReg <= 1'b1;
                pc <= (pc + 10'h001);
              end
            end
          end
        end else begin
          exValidReg <= 1'b0;
        end
      end
    end
  end


endmodule
