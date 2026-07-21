// Reusable hole and spacer geometry helpers for baseplates.

module add_baseplate_hole_cutout(
    position,
    plate_thickness,
    hole_diameter,
    fn = 48
) {
    translate([position[0], position[1], -0.1])
        cylinder(h = plate_thickness + 0.2, d = hole_diameter, $fn = fn);
}

module add_hole_with_spacer(
    position,
    plate_thickness,
    spacer_height,
    spacer_outer_diameter,
    spacer_inner_diameter,
    outer_fn = 48,
    inner_fn = 32
) {
    difference() {
        translate([position[0], position[1], plate_thickness])
            cylinder(h = spacer_height, d = spacer_outer_diameter, $fn = outer_fn);

        translate([position[0], position[1], plate_thickness - 0.1])
            cylinder(h = spacer_height + 0.2, d = spacer_inner_diameter, $fn = inner_fn);
    }
}
