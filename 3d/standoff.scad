$fn = 48;

standoff_diameter = 6;
screw_hole_diameter = 2.2;

module standoff(
    height,
    position,
    diameter = standoff_diameter,
    hole_diameter = screw_hole_diameter
) {
    translate(position) {
        difference() {
            cylinder(h = height, d = diameter);
            translate([0, 0, -0.1])
                cylinder(h = height + 0.2, d = hole_diameter);
        }
    }
}