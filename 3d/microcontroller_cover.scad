// Filament Storage - Microcontroller Case Cover

// Include shared dimensions
include <microcontroller_dimensions.scad>

// Plate matching the baseplate base dimensions.
translate([plate_left_x, plate_bottom_y, 0])
	cube([plate_width, plate_length, plate_thickness]);

// Long-edge side walls matching the baseplate high wall height.
translate([plate_left_x, plate_bottom_y + plate_thickness, plate_thickness])
	cube([plate_thickness, plate_length - 2 * plate_thickness, high_wall_height]);

translate([plate_right_x - plate_thickness, plate_bottom_y + plate_thickness, plate_thickness])
	cube([plate_thickness, plate_length - 2 * plate_thickness, high_wall_height]);

// Short-edge wall: as wide as the lower wall and as high as high wall minus lower wall.
translate([plate_right_x - lower_wall_length, plate_top_y - plate_thickness, plate_thickness])
	cube([lower_wall_length, plate_thickness, high_wall_height - lower_wall_height - board_hover_height  - board_thickness]);

// RJ45-side corner walls: extend from the outer corners to the jack edges.
translate([plate_left_x, plate_bottom_y, plate_thickness])
	cube([left_end_extension_width + rj45_end_wall_clearance + rj45_board_width / 2 - rj45_jack_width / 2 - 1, plate_thickness, high_wall_height - rj45_top_clearance_wall_height]);

translate([plate_right_x - (right_end_extension_width + rj45_end_wall_clearance + rj45_board_width / 2 - rj45_jack_width / 2 - 1), plate_bottom_y, plate_thickness])
	cube([right_end_extension_width + rj45_end_wall_clearance + rj45_board_width / 2 - rj45_jack_width / 2 - 1, plate_thickness, high_wall_height - rj45_top_clearance_wall_height]);

translate([rj45_pair_center_x - rj45_board_gap / 2 - rj45_board_width / 2 + rj45_jack_width / 2 + 1, plate_bottom_y, plate_thickness])
    cube([rj45_board_width - rj45_jack_width - 2 + rj45_board_gap, plate_thickness, high_wall_height - rj45_top_clearance_wall_height]);

translate([rj45_pair_center_x + rj45_board_gap / 2 + rj45_jack_width / 2 - 1, plate_bottom_y, plate_thickness])
    cube([rj45_jack_width + rj45_board_gap + 2, plate_thickness, high_wall_height - rj45_top_clearance_wall_height - rj45_jack_height - 1]);

translate([plate_left_x + left_end_extension_width + rj45_end_wall_clearance + rj45_board_width / 2 - rj45_jack_width / 2 - 1, plate_bottom_y, plate_thickness])
    cube([rj45_jack_width + rj45_board_gap + 2, plate_thickness, high_wall_height - rj45_top_clearance_wall_height - rj45_jack_height - 1]);
