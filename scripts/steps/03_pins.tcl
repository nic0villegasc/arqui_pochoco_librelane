# FLOORPLAN 2/3 - IO pins on the edge. "The roads that connect us to the outside."
# Nothing is placed yet, so the tool has no idea which cells each pin talks to:
# it just spreads the pins along the border. Step 6 moves them again once the cells have a rough place.
place_pins -hor_layers Metal3 -ver_layers Metal2
puts "pins placed: [llength [get_ports *]]"
# Note: the warning "Macro ... is not placed" is expected. The SRAM macros are placed in the
# NEXT step, so at this moment the pin placer just sees them as unplaced blocks.
