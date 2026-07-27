// Filament Storage - Microcontroller Case Cover

// Include shared dimensions
include <microcontroller_dimensions.scad>
use <standoff.scad>

// In assembled orientation, these standoffs extend downward from the cover and
// meet the tops of the baseplate spacers.
cover_support_standoff_diameter = 10;
cover_support_standoff_height = high_wall_height - spacer_height;

display_hole_width = 35;
display_hole_height = 19.5;
display_hole_wall_gap = 2;
display_hole_edge_gap = 9;
display_vertical_offset = 10;
display_hole_left_x = plate_left_x + plate_thickness + display_hole_wall_gap;
display_hole_bottom_y = plate_top_y - display_hole_edge_gap - display_hole_height - display_vertical_offset;
display_knob_diameter = 3;
display_knob_radius = display_knob_diameter / 2;
display_knob_height = 3;
display_knob_gap_upper = 1.5;
display_knob_gap_lower = 4.5;
display_knob_left_center_x = display_hole_left_x + display_knob_radius + 0.75;
display_knob_center_x = display_hole_left_x + display_hole_width - display_knob_radius - 0.75;
display_knob_bottom_center_y = display_hole_bottom_y - display_knob_radius - display_knob_gap_lower;
display_knob_top_center_y = display_hole_bottom_y + display_hole_height + display_knob_radius + display_knob_gap_upper;

difference() {
	union() {
		// Plate matching the baseplate base dimensions.
		translate([plate_left_x, plate_bottom_y, 0])
			cube([plate_width, plate_length, plate_thickness]);

		// Long-edge side walls matching the baseplate high wall height.
		translate([plate_left_x, plate_bottom_y + plate_thickness, plate_thickness])
			cube([plate_thickness, plate_length - 2 * plate_thickness - 0.5, high_wall_height]);

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

		translate([display_knob_center_x, display_knob_bottom_center_y, plate_thickness])
			cylinder(h = display_knob_height, r = display_knob_radius);

		translate([display_knob_center_x, display_knob_top_center_y, plate_thickness])
			cylinder(h = display_knob_height, r = display_knob_radius);

		translate([display_knob_left_center_x, display_knob_bottom_center_y, plate_thickness])
			cylinder(h = display_knob_height, r = display_knob_radius);

		translate([display_knob_left_center_x, display_knob_top_center_y, plate_thickness])
			cylinder(h = display_knob_height, r = display_knob_radius);

		for (p = hole_positions) {
			standoff(cover_support_standoff_height, [-p[0], p[1], plate_thickness], cover_support_standoff_diameter, cover_standoff_hole_diameter);
		}
	}

	translate([display_hole_left_x, display_hole_bottom_y, -0.1])
		cube([display_hole_width, display_hole_height, plate_thickness + 0.2]);
}
