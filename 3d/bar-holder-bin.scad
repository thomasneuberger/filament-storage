include <bar-holder_dimensions.scad>

difference(){
    // The outer bin shell
    cube([bin_length, bin_width, bin_height], center = true);

    union() {
        // The inner bin shell
        translate([0, 0, bin_thickness])
            cube([bin_length - bin_thickness * 2, bin_width - bin_thickness * 2, bin_height], center = true);
        
        // The holes for the air
        for (x = bin_airhole_positions_longside) {
            for(z = bin_airhole_positions_vertical) {
                translate([x - bin_length / 2 + bin_thickness, 0, z - bin_height / 2 + bin_thickness])
                    rotate([90, 0, 0])
                        cylinder(h = bin_width, d = bin_airhole_diameter);
            }
        }

        for (y = bin_airhole_positions_shortside) {
            for(z = bin_airhole_positions_vertical) {
                translate([-bin_length / 2 - 1, y - bin_width / 2 + bin_thickness, z - bin_height / 2 + bin_thickness])
                    rotate([0, 90, 0])
                        cylinder(h = bin_length + 2, d = bin_airhole_diameter);
            }
        }

        for (x = bin_airhole_positions_longside) {
            for(y = bin_airhole_positions_shortside) {
                translate([x - bin_length / 2 + bin_thickness, y - bin_width / 2 + bin_thickness, -bin_height / 2 - 1])
                    cylinder(h = bin_height + 2, d = bin_airhole_diameter);
            }
        }
    }
}

// hooks
hook_upper_corner_y = bin_width / 2 - bin_thickness - bar_height;
hook_width = bin_thickness * 2;
hook_upper_corner_z = bin_height / 2 + bin_hole_position_y + hook_length + hook_width;
hook_positions_x = [bin_length / 2 - bin_thickness, -bin_length / 2];
for (hook_x = hook_positions_x) {
    translate([hook_x, bin_width / 2 - bin_thickness - bar_height - 10, bin_height / 2])
        cube([bin_thickness, 10, hook_upper_corner_z - (bin_height / 2)], center = false);
    translate([hook_x, hook_upper_corner_y, hook_upper_corner_z])
        rotate([-135, 0, 0])
            cube([bin_thickness, hook_width, hook_length], center = false);
}
