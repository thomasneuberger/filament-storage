thickness = 2;
hole_diameter = 53;
hole_radius = hole_diameter / 2;
cap_diameter = hole_diameter + 10;
cap_radius = cap_diameter / 2;
cap_height = 5;
slit_width = 10 ;
slit_depth = cap_radius - hole_radius + thickness + slit_width;

total_height = thickness + cap_height;
slit_radius = slit_width / 2;

difference() {
    union() {
        cylinder(h=thickness, r=cap_radius, $fn=120);

        translate([0, 0, thickness])
            difference() {
                cylinder(h=cap_height, r=hole_radius, $fn=120);
                cylinder(h=cap_height + 1, r=(hole_radius - thickness), $fn=120);
            }
    }

    // Side slit with rounded inner end.
    translate([cap_radius - slit_depth, -slit_radius, -0.5])
        union() {
            cube([slit_depth + 1, slit_width, total_height + 1]);
            translate([0, slit_radius, 0])
                cylinder(h=total_height + 1, r=slit_radius, $fn=60);
        }
    }