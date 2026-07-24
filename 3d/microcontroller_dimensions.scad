// Filament Storage - Microcontroller Case Shared Dimensions
// This file contains dimensions shared between the baseplate and cover

include <rj45_board.scad>

// -----------------------------
// Base plate dimensions
// -----------------------------
plate_width = 80;
plate_length = 100;
plate_thickness = 2;
high_wall_height = 30;

// Base plate reference coordinates.
plate_left_x = -plate_width / 2;
plate_right_x = plate_width / 2;
plate_bottom_y = -plate_length / 2;
plate_top_y = plate_length / 2;

// -----------------------------
// D1 mini board dimensions and mounting
// -----------------------------
board_width = 25.6;
board_length = 34.2;
board_thickness = 1.6;

mount_dx = 20;
mount_dy = 28;

standoff_diameter = 6;
screw_hole_diameter = 2.2;

// -----------------------------
// Board placement and support geometry
// -----------------------------
board_edge_clearance = plate_thickness + 1;
board_to_high_wall_gap = 1;

lower_wall_height = 2;
board_hover_height = 4.4;
standoff_height = lower_wall_height + board_hover_height;

board_center_x = plate_left_x + board_edge_clearance + board_width / 2;
board_center_y = plate_top_y - board_length / 2;
board_left_x = board_center_x - board_width / 2;
board_right_x = board_center_x + board_width / 2;

lower_wall_length = board_right_x - plate_left_x + board_to_high_wall_gap;

// -----------------------------
// RJ45 board placement and end-wall geometry
// -----------------------------
rj45_standoff_height = 3;
rj45_board_gap = 2;
rj45_pair_center_x = 0;
rj45_board_clearance_to_wall = 1;
rj45_end_wall_clearance = 1;
rj45_top_wall_extra_clearance = 1;
rj45_jack_width = 16;

rj45_center_dx = (rj45_board_width + rj45_board_gap) / 2;
rj45_center_y = plate_bottom_y + rj45_board_length / 2;
rj45_outer_left_x = rj45_pair_center_x - rj45_center_dx - rj45_board_width / 2;
rj45_outer_right_x = rj45_pair_center_x + rj45_center_dx + rj45_board_width / 2;
rj45_jack_left_x = rj45_pair_center_x - rj45_jack_width / 2;
rj45_jack_right_x = rj45_pair_center_x + rj45_jack_width / 2;

opposite_wall_height = max(0, rj45_standoff_height - rj45_board_clearance_to_wall);
rj45_top_clearance_wall_height =
    rj45_standoff_height + rj45_board_thickness + rj45_top_wall_extra_clearance;

end_extension_inner_left_x = rj45_outer_left_x - rj45_end_wall_clearance;
end_extension_inner_right_x = rj45_outer_right_x + rj45_end_wall_clearance;
left_end_extension_width = max(0, end_extension_inner_left_x - plate_left_x);
right_end_extension_width = max(0, plate_right_x - end_extension_inner_right_x);
