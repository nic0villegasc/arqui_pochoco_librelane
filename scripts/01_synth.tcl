# Manual Yosys synthesis of pochoco_soc for gf180mcu (same steps as the ETH synthesis exercise)
# run:  yosys -c scripts/01_synth.tcl        (after: source scripts/env.sh)
set top    $::env(TOP)
set lib    $::env(LIB)
set period_ps [expr {int($::env(PERIOD_NS) * 1000)}]

yosys read_liberty -overwrite -setattr liberty_cell -lib $lib      ;# 1. what cells exist
yosys read_liberty -overwrite -setattr liberty_cell -lib $::env(SRAM_LIB)  ;# ...and the SRAM macro (a black box)
yosys read_verilog -defer -sv -I . {*}[glob rtl/*.v]                ;# 2. read the RTL
yosys hierarchy -check -top $top                                    ;# 3. elaborate
yosys proc                                                          ;# 4. always blocks -> muxes/flops
yosys tee -q -o out/stat_rtl.rpt stat -width

yosys flatten                                                       ;# 5. coarse-grain synthesis
yosys opt -noff
yosys fsm
yosys wreduce
yosys peepopt
yosys opt_clean
yosys share
yosys opt
yosys memory
yosys opt -full
yosys opt_dff -sat
yosys clean -purge
yosys tee -q -o out/stat_coarse.rpt stat -width

yosys techmap                                                       ;# 6. generic gates
yosys opt
yosys clean
yosys dfflibmap -liberty $lib                                       ;# 7. flip-flops -> gf180 cells
yosys opt

set fh [open out/abc.constr w]                                      ;# 8. constraints for ABC
puts $fh "set_driving_cell gf180mcu_fd_sc_mcu7t5v0__inv_1"
puts $fh "set_load 0.0729"
close $fh
yosys abc -liberty $lib -D $period_ps -constr out/abc.constr        ;# 9. logic -> gf180 cells
yosys clean -purge

yosys setundef -zero                                                ;# 10. prepare for OpenROAD
yosys splitnets
yosys clean -purge
yosys hilomap -singleton \
    -hicell gf180mcu_fd_sc_mcu7t5v0__tieh Z \
    -locell gf180mcu_fd_sc_mcu7t5v0__tiel ZN
yosys insbuf -buf gf180mcu_fd_sc_mcu7t5v0__buf_1 I Z

yosys tee -q -o out/stat_mapped.rpt stat -liberty $lib -liberty $::env(SRAM_LIB) -width
yosys write_verilog -noattr -noexpr -nohex -nodec out/$top.nl.v
puts "\nDone -> out/$top.nl.v   (report: out/stat_mapped.rpt)"
