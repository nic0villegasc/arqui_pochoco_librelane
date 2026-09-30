// SPDX-License-Identifier: SHL-0.51
//
// Data RAM built from the gf180mcu 5V SRAM hard macro (64 words x 8 bits, 432 x 233 um).
// A 32-bit word needs four of them: one per byte lane.  Same ports as the old flop-based
// version, so pochoco_soc.v did not change.  The macro is a black box for synthesis
// (Yosys reads its .lib); its layout (.lef) is placed in the floorplan.
//
//   CEN  chip enable, active low      GWEN global write enable, active low
//   WEN  per-bit write enable, active low (all 8 bits of a lane move together here)
//   Q    registered read data
module pochoco_dram #(
  parameter NumWords = 64          // the macro has 64 words (only addr_i[7:2] is used)
) (
  input  wire        clk_i,
  input  wire        req_i,
  input  wire        we_i,
  input  wire [3:0]  be_i,
  input  wire [31:0] addr_i,
  input  wire [31:0] wdata_i,
  output wire [31:0] rdata_o
);

  genvar i;
  generate
    for (i = 0; i < 4; i = i + 1) begin : lane
      gf180mcu_fd_ip_sram__sram64x8m8wm1 u_sram (
        .CLK  (clk_i),
        .CEN  (~req_i),
        .GWEN (~we_i),
        .WEN  ({8{~be_i[i]}}),
        .A    (addr_i[7:2]),
        .D    (wdata_i[8*i +: 8]),
        .Q    (rdata_o[8*i +: 8])
      );
    end
  endgenerate

endmodule
