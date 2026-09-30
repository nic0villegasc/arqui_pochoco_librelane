# All floorplan..placement steps in one go (no GUI). Same files as scripts/steps/, in slide order.
foreach s {01_load 02_floorplan 03_pins 04_macros 05_pdn 06_global_place 07_detailed_place 08_report_save} {
  puts "\n=== $s ==="
  source scripts/steps/$s.tcl
}
puts "\nDone -> out/$::env(TOP).placed.odb"
