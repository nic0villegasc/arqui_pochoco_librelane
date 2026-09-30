# STEP 8 - Check timing (ideal clock, estimated wires) and save a checkpoint.
estimate_parasitics -placement
report_checks -path_delay max -format full
report_wns
report_tns
write_db  out/$::env(TOP).placed.odb
write_def out/$::env(TOP).placed.def
