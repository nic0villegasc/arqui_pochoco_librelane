# Helper for 04_macros.tcl (you can read it, but you don't need to).
proc macro_instances {} {
  set list {}
  foreach inst [[ord::get_db_block] getInsts] {
    if {[[$inst getMaster] isBlock]} { lappend list $inst }
  }
  return $list
}

# Put the macros in a 2-column grid in the top-left corner of the core and freeze them (FIRM).
proc place_macros_2x2 {gap} {
  set block [ord::get_db_block]
  set dbu   [[ord::get_db_tech] getDbUnitsPerMicron]
  set core  [$block getCoreArea]
  set x0 [expr {[$core xMin] / double($dbu) + $gap}]
  set y1 [expr {[$core yMax] / double($dbu) - $gap}]
  set macros [macro_instances]
  puts "macro instances in the design: [llength $macros]"
  set n 0
  foreach inst $macros {
    set m  [$inst getMaster]
    set w  [expr {[$m getWidth]  / double($dbu)}]
    set h  [expr {[$m getHeight] / double($dbu)}]
    set col [expr {$n % 2}]
    set row [expr {$n / 2}]
    set x [expr {$x0 + $col * ($w + $gap)}]
    set y [expr {$y1 - ($row + 1) * $h - $row * $gap}]
    $inst setOrient R0
    $inst setLocation [expr {int($x * $dbu)}] [expr {int($y * $dbu)}]
    $inst setPlacementStatus FIRM
    puts [format "  %-28s %6.1f x %5.1f um at (%.1f, %.1f)  FIRM" [$inst getName] $w $h $x $y]
    incr n
  }
}
