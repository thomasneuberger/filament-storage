bar_length = 220;
bar_width = 50;
bar_height = 10;
back_thickness = 2;

bar_hole_distance = 130;
bar_hole_diameter = 16;

knob_diameter = 2;
knob_height = 8;
knob_distance_x = 192;
knob_distance_y = 32;

bin_length = 180;
bin_width = 40;
bin_height = 40;
bin_thickness = 2;

bin_hole_distance_x = bin_length - bin_thickness * 2;
bin_hole_position_y = 10;
bin_hole_gap = 0.5;
bin_hole_width = bin_thickness + bin_hole_gap * 2;
bin_hole_positions_x = [bin_hole_distance_x/2, -bin_hole_distance_x/2 - bin_hole_width];

bin_airhole_diameter = 1;
bin_airhole_count_longside = (bin_length - 5) / 5;
bin_airhole_positions_longside = [for (i = [0 : bin_airhole_count_longside - 1]) 2.5 + i * 5];
bin_airhole_count_shortside = (bin_width - 5) / 5;
bin_airhole_positions_shortside = [for (i = [0 : bin_airhole_count_shortside - 1]) 2.5 + i * 5];
bin_airhole_count_vertical = (bin_height - 5) / 5;
bin_airhole_positions_vertical = [for (i = [0 : bin_airhole_count_vertical - 1]) 2.5 + i * 5];

hook_length = 10;