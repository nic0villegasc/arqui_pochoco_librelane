# PLACEMENT 1/2 - Global placement: "every building gets a spot".
# Spread all the standard cells over the free core area, keeping connected cells close.
# Macros and the power grid stay where we put them.

# Pass 1: rough placement, ignoring the pins (they were only spread along the edge in step 3)
global_placement -skip_io -density 0.45

# Now we know where the logic is: move each pin to the edge point closest to the cells it talks to
place_pins -hor_layers Metal3 -ver_layers Metal2

# Pass 2: the real placement, this time pulled by the pins
global_placement -density 0.45
# (cells are near their best spot, but not on the rows yet and may overlap slightly)
