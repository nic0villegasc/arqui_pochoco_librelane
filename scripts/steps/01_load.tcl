# STEP 1 - Load the technology and the design. Nothing to see yet: the netlist has no geometry.
read_liberty $::env(LIB)       ;# cell TIMING  (.lib)
read_liberty $::env(SRAM_LIB)  ;# ...also for the SRAM macro
read_lef     $::env(TLEF)      ;# technology: metal layers, vias, spacing rules
read_lef     $::env(CLEF)      ;# cell SHAPES + pin positions
read_lef     $::env(SRAM_LEF)  ;# ...and the shape of the SRAM macro (a big block with pins)
read_verilog out/$::env(TOP).nl.v
link_design  $::env(TOP)       ;# connect the netlist to the cells in the LEF
create_clock -name clk -period $::env(PERIOD_NS) [get_ports clk_i]
puts "instances: [llength [get_cells *]]   nets: [llength [get_nets *]]   ports: [llength [get_ports *]]"
