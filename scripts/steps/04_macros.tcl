# FLOORPLAN 3/3 - Macros inside the border. "The mall, the university, the clinic."
# Pochoco's data RAM is 4 SRAM macros (one per byte). They are big, fixed blocks: we place
# them FIRST and freeze them; the standard cells will flow around them later.
source scripts/macros.tcl        ;# small helper: lists the macros and puts them in a 2x2 block
place_macros_2x2 20              ;# 20 um gap between them and to the core edge
