// A board with a RJ45 port and the pins on the opposite side. The RJ45 port is on the front side of the board when the pins are facing outward

use <pins.scad>

rj45_board_width = 34;
rj45_board_length = 28;
rj45_board_thickness = 1.6;

rj45_screwhole_diameter = 3.1;
rj45_screwhole_positions_x = [-rj45_board_width / 2 + 3.4, rj45_board_width / 2 - 3.4];
rj45_screwhole_positions_y = [-rj45_board_length / 2 + 5.1, rj45_board_length / 2 - 12];

module add_rj45_board_standoffs_and_preview(
	center,
	base_z,
	standoff_height,
	standoff_diameter = 6,
	screw_hole_diameter = rj45_screwhole_diameter,
	board_thickness = rj45_board_thickness,
	show_preview = true
) {
	// Mounting standoffs at board screw-hole positions
	for (sx = rj45_screwhole_positions_x) {
		for (sy = rj45_screwhole_positions_y) {
			standoff(
				standoff_height,
				[center[0] + sx, center[1] + sy, base_z],
				standoff_diameter,
				screw_hole_diameter
			);
		}
	}

	if (show_preview) {
		board_x0 = center[0] - rj45_board_width / 2;
		board_y0 = center[1] - rj45_board_length / 2;
		board_z0 = base_z + standoff_height;

		// PCB preview
		color([0.0, 0.55, 0.1, 0.6])
			translate([board_x0, board_y0, board_z0])
				cube([rj45_board_width, rj45_board_length, board_thickness]);

		// RJ45 jack preview on the front side (negative Y edge)
		rj45_jack_width = 16;
		rj45_jack_depth = 13;
		rj45_jack_height = 13;
		color([0.75, 0.75, 0.75, 0.85])
			translate([
				center[0] - rj45_jack_width / 2,
				board_y0,
				board_z0 + board_thickness
			])
				cube([rj45_jack_width, rj45_jack_depth, rj45_jack_height]);

		// Pin-header side preview at opposite board edge
		pin_header_overlap = 4.6;
		add_pin_bar_preview(
			position = [
				center[0],
				board_y0 + rj45_board_length - pin_header_overlap + 4,
				board_z0 + board_thickness
			],
			orientation = [0, 0, 0],
			direction = "horizontal",
			pin_count = 9,
			bar_length = 23
		);
	}
}