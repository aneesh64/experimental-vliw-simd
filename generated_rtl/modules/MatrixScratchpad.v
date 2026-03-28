// Generator : SpinalHDL v1.10.2a    git head : a348a60b7e8b6a455c72e1536ec3d74a2ea16935
// Component : MatrixScratchpad
// Git hash  : 414aef5ea78ca06f57c39f378ed640d967e9cf6d

`timescale 1ns/1ps

module MatrixScratchpad (
  input  wire [7:0]    io_matrixPort_addr,
  input  wire          io_matrixPort_en,
  input  wire          io_matrixPort_we,
  input  wire [7:0]    io_matrixPort_wrData,
  output wire [7:0]    io_matrixPort_rdData,
  input  wire [7:0]    io_systemPort_addr,
  input  wire          io_systemPort_en,
  input  wire          io_systemPort_we,
  input  wire [7:0]    io_systemPort_wrData,
  output wire [7:0]    io_systemPort_rdData,
  input  wire          clk,
  input  wire          reset
);

  wire       [7:0]    mem_io_matrixPort_rdData;
  wire       [7:0]    mem_io_systemPort_rdData;

  MatrixLocalMemory mem (
    .io_matrixPort_addr   (io_matrixPort_addr[7:0]      ), //i
    .io_matrixPort_en     (io_matrixPort_en             ), //i
    .io_matrixPort_we     (io_matrixPort_we             ), //i
    .io_matrixPort_wrData (io_matrixPort_wrData[7:0]    ), //i
    .io_matrixPort_rdData (mem_io_matrixPort_rdData[7:0]), //o
    .io_systemPort_addr   (io_systemPort_addr[7:0]      ), //i
    .io_systemPort_en     (io_systemPort_en             ), //i
    .io_systemPort_we     (io_systemPort_we             ), //i
    .io_systemPort_wrData (io_systemPort_wrData[7:0]    ), //i
    .io_systemPort_rdData (mem_io_systemPort_rdData[7:0]), //o
    .clk                  (clk                          ), //i
    .reset                (reset                        )  //i
  );
  assign io_matrixPort_rdData = mem_io_matrixPort_rdData;
  assign io_systemPort_rdData = mem_io_systemPort_rdData;

endmodule

module MatrixLocalMemory (
  input  wire [7:0]    io_matrixPort_addr,
  input  wire          io_matrixPort_en,
  input  wire          io_matrixPort_we,
  input  wire [7:0]    io_matrixPort_wrData,
  output wire [7:0]    io_matrixPort_rdData,
  input  wire [7:0]    io_systemPort_addr,
  input  wire          io_systemPort_en,
  input  wire          io_systemPort_we,
  input  wire [7:0]    io_systemPort_wrData,
  output wire [7:0]    io_systemPort_rdData,
  input  wire          clk,
  input  wire          reset
);

  reg        [7:0]    mem_spinal_port0;
  reg        [7:0]    mem_spinal_port1;
  wire       [7:0]    _zz_io_matrixPort_rdData;
  wire       [7:0]    _zz_io_systemPort_rdData;
  reg [7:0] mem [0:255];

  always @(posedge clk) begin
    if(io_matrixPort_en) begin
      mem_spinal_port0 <= mem[io_matrixPort_addr];
    end
  end

  always @(posedge clk) begin
    if(io_matrixPort_en && io_matrixPort_we ) begin
      mem[io_matrixPort_addr] <= _zz_io_matrixPort_rdData;
    end
  end

  always @(posedge clk) begin
    if(io_systemPort_en) begin
      mem_spinal_port1 <= mem[io_systemPort_addr];
    end
  end

  always @(posedge clk) begin
    if(io_systemPort_en && io_systemPort_we ) begin
      mem[io_systemPort_addr] <= _zz_io_systemPort_rdData;
    end
  end

  assign _zz_io_matrixPort_rdData = io_matrixPort_wrData;
  assign io_matrixPort_rdData = mem_spinal_port0;
  assign _zz_io_systemPort_rdData = io_systemPort_wrData;
  assign io_systemPort_rdData = mem_spinal_port1;

endmodule
