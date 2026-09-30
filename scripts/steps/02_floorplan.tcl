# FLOORPLAN 1/3 - Die area and rows. "Set the border of the city."
#   utilization 35 % -> core area = cell area / 0.35, then a square die around it
initialize_floorplan -utilization 35 -aspect_ratio 1 -core_space 10 -site GF018hv5v_mcu_sc7
# Same thing with explicit numbers (try it!):
#   initialize_floorplan -die_area {0 0 700 700} -core_area {10 10 690 690} -site GF018hv5v_mcu_sc7
make_tracks            ;# the grid the router will snap wires to later
puts "die  = [ord::get_die_area] um"
puts "core = [ord::get_core_area] um"
