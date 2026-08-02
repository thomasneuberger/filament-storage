bar_length = 220;
bar_width = 50;
bar_height = 10;
back_thickness = 2;

bar_distance = 130;
bar_diameter = 16;

knob_diameter = 2;
knob_height = 8;
knob_distance_x = 192;
knob_distance_y = 32;

difference() {
    // The bar holder itself
    cube([bar_length, bar_width, bar_height], center = true);
    
    union() {
        // The holes for the bars
        translate([bar_distance/2, bar_width/2, -bar_height / 2 - 1])
            cylinder(h = bar_height - back_thickness + 1, d = bar_diameter);
        
        translate([-bar_distance/2, bar_width/2, -bar_height / 2 - 1])
            cylinder(h = bar_height - back_thickness + 1, d = bar_diameter);
    }
}

for (knob_x = [-knob_distance_x/2, knob_distance_x/2]) {
    for (knob_y = [-knob_distance_y/2, knob_distance_y/2]) {
        translate([knob_x, knob_y, bar_height / 2])
            cylinder(h = knob_height, d = knob_diameter);
    }
}