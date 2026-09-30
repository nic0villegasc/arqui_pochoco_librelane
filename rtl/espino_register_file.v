// SPDX-License-Identifier: SHL-0.51
//
// ASIC port of espino_register_file.
//
// The upstream FPGA version (pochoco_soc, rtl/espino_core/espino_register_file.v)
// instantiates the iCE40-specific SB_RAM40_4K primitive. That primitive does not
// exist in gf180mcu (or any ASIC standard-cell library), so it cannot be carried
// over as-is. This file replaces it with plain behavioral register arrays that
// Yosys maps onto flip-flops, keeping the same port list and the same one-cycle
// registered-read timing as the original so espino_id_stage does not need to
// change.
//
// Second, less obvious port issue this surfaced: x0 (register 0) is
// write-protected (see `wr` below) but was otherwise never initialized, so it
// held simulation 'x' forever and corrupted the first `bne ... x0` comparison
// in sw/blink.s. On the original SB_RAM40_4K primitive this was invisible,
// because iCE40 block RAMs simulate with their `INIT_0` parameter (0 here) as
// power-up content -- a behavior specific to that FPGA RAM model, not
// something a behavioral register array (or, for that matter, a real ASIC
// flip-flop, which powers up in a genuinely unknown state) gives you for
// free. Explicitly resetting the whole bank fixes it correctly for both
// simulation and silicon.
module espino_regbank32 (
  input  wire        clk_i,
  input  wire        rst_ni,
  input  wire [3:0]  raddr_i,
  output reg  [31:0] rdata_o,
  input  wire [3:0]  waddr_i,
  input  wire [31:0] wdata_i,
  input  wire        we_i
);
  reg [31:0] mem [0:15];
  integer k;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      for (k = 0; k < 16; k = k + 1) mem[k] <= 32'h0;
      rdata_o <= 32'h0;
    end else begin
      if (we_i) mem[waddr_i] <= wdata_i;
      rdata_o <= mem[raddr_i];
    end
  end
endmodule

module espino_register_file (
  input  wire        clk_i,
  input  wire        rst_ni,
  input  wire [3:0]  raddr_a_i,
  output wire [31:0] rdata_a_o,
  input  wire [3:0]  raddr_b_i,
  output wire [31:0] rdata_b_o,
  input  wire [3:0]  waddr_i,
  input  wire [31:0] wdata_i,
  input  wire        we_i
);
  wire wr = we_i & (waddr_i != 4'd0);

  espino_regbank32 u_bankA (   // serves read port A
    .clk_i (clk_i), .rst_ni (rst_ni),
    .raddr_i (raddr_a_i), .rdata_o (rdata_a_o),
    .waddr_i (waddr_i), .wdata_i (wdata_i), .we_i (wr)
  );

  espino_regbank32 u_bankB (   // serves read port B
    .clk_i (clk_i), .rst_ni (rst_ni),
    .raddr_i (raddr_b_i), .rdata_o (rdata_b_o),
    .waddr_i (waddr_i), .wdata_i (wdata_i), .we_i (wr)
  );
endmodule
