// SPDX-License-Identifier: SHL-0.51
//
// ASIC port note: the upstream pochoco_soc uses a single unified RAM
// ($readmemh-loaded) for both instructions and data (rtl/pochoco_ram.v).
// $readmemh only sets simulation initial values -- it has no effect on
// real silicon, where flip-flops power up in an unknown state. A chip
// built that way would boot into garbage.
//
// This ASIC build instead splits memory into a read-only instruction ROM
// (this module) and a small data RAM (pochoco_dram.v). The program is
// pulled in from sw/program.vh (generated from a .hex file by
// sw/hex_to_vh.py) as plain `mem[i] = 32'h...;` assignments rather than via
// $readmemh, so it does not depend on the simulator/synthesizer's working
// directory. Because this module has no write port, Yosys constant-folds
// `mem` into fixed combinational logic during synthesis -- the program is
// baked into the gates themselves, so it is present and correct the instant
// power is applied. The tradeoff: the program is now fixed at tapeout and
// can no longer be changed by rewriting RAM at runtime.
module pochoco_irom #(
  parameter NumWords = 64
) (
  input  wire        clk_i,
  input  wire        req_i,
  input  wire [31:0] addr_i,
  output reg  [31:0] rdata_o
);

  localparam AddrW = $clog2(NumWords);

  reg [31:0] mem [0:NumWords-1];

  integer k;
  initial begin
    for (k = 0; k < NumWords; k = k + 1) mem[k] = 32'h0;
`include "sw/program.vh"
  end

  wire [AddrW-1:0] word = addr_i[AddrW+1:2];

  always @(posedge clk_i) begin
    if (req_i) rdata_o <= mem[word];
  end

endmodule
