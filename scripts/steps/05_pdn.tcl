# POWER DELIVERY - "We need electricity from somewhere."
# 1) Well taps + end caps: tie the silicon wells to VDD/VSS every 20 um (latch-up protection)
tapcell -distance 20 \
        -tapcell_master gf180mcu_fd_sc_mcu7t5v0__filltie \
        -endcap_master  gf180mcu_fd_sc_mcu7t5v0__endcap
# 2) Which pins of which cells are power / ground
add_global_connection -net VDD -pin_pattern {^VDD$} -power
add_global_connection -net VDD -pin_pattern {^VNW$} -power
add_global_connection -net VSS -pin_pattern {^VSS$} -ground
add_global_connection -net VSS -pin_pattern {^VPW$} -ground
# 3) The grid: thin rails at the cells, wide straps on the top layers feeding them
set_voltage_domain -name CORE -power VDD -ground VSS
define_pdn_grid -name core_grid -voltage_domains CORE
add_pdn_stripe  -grid core_grid -layer Metal1 -width 0.6 -followpins          ;# thin rails, one per row
add_pdn_stripe  -grid core_grid -layer Metal4 -width 1.6 -pitch 40 -offset 5  ;# wide vertical straps
add_pdn_stripe  -grid core_grid -layer Metal5 -width 1.6 -pitch 40 -offset 5  ;# wide horizontal straps
add_pdn_connect -grid core_grid -layers {Metal1 Metal4}
add_pdn_connect -grid core_grid -layers {Metal4 Metal5}
# 4) The SRAM macros get their own small grid: it joins the top-layer straps to the macro's power pins
define_pdn_grid -macro -default -name macro_grid -starts_with POWER -halo {5 5}
add_pdn_connect -grid macro_grid -layers {Metal4 Metal3}
pdngen
