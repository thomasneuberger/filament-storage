include <bar-holder_dimensions.scad>

difference() {
    // The bar holder itself
    cube([bar_length, bar_width, bar_height], center = true);
    
    union() {
        // The holes for the bars
        translate([bar_hole_distance/2, bar_width/2, -bar_height / 2 - 1])
            cylinder(h = bar_height - back_thickness + 1, d = bar_hole_diameter);
        
        translate([-bar_hole_distance/2, bar_width/2, -bar_height / 2 - 1])
            cylinder(h = bar_height - back_thickness + 1, d = bar_hole_diameter);
        
        // The holes for the silicagel bin
        translate([bin_hole_positions_x[0], -bin_hole_position_y + 10, -bar_height / 2 - 1 - 10])
            rotate([45, 0, 0])
                cube([bin_hole_width, bar_height, 30], center = false);

        translate([bin_hole_positions_x[1], -bin_hole_position_y + 10, -bar_height / 2 - 1 - 10])
            rotate([45, 0, 0])
                cube([bin_hole_width, bar_height, 30], center = false);
    }
}

if($preview) {
    translate([bin_hole_positions_x[0], -bin_hole_position_y, -bar_height / 2 - 1])
        color("red")
            cube([1, 1, 1], center = false);
    translate([bin_hole_positions_x[1], -bin_hole_position_y, -bar_height / 2 - 1])
        color("red")
            cube([1, 1, 1], center = false);
}

for (knob_x = [-knob_distance_x/2, knob_distance_x/2]) {
    for (knob_y = [-knob_distance_y/2, knob_distance_y/2]) {
        translate([knob_x, knob_y, bar_height / 2])
            cylinder(h = knob_height, d = knob_diameter);
    }
}