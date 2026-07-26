// Filament Storage - Sensor Case Shared Dimensions
// This file contains dimensions shared between the baseplate and cover

include <rj45_board.scad>

// -----------------------------
// Base plate dimensions
// -----------------------------
plate_width = 80;
plate_length = 100;
plate_thickness = 2;

// Base plate reference coordinates.
plate_left_x = -plate_width / 2;
plate_right_x = plate_width / 2;
plate_bottom_y = -plate_length / 2;
plate_top_y = plate_length / 2;

// -----------------------------
// Sensor dimensions
// -----------------------------
sensor_width = 16;
sensor_length = 27;
sensor_height = 7;
sensor_pedestal_height = 2;
sensor_distance = 2;
sensor_positions_x = [
    -sensor_width / 2 - sensor_distance - sensor_width,
    -sensor_width / 2,
    sensor_width / 2 + sensor_distance,
];

// -----------------------------
// Cover dimensions
// -----------------------------
cover_length = plate_length - sensor_length;
high_wall_height = 30;

// -----------------------------
// RJ45 board dimensions
// -----------------------------
rj45_position_x = 0;
rj45_position_y = plate_bottom_y + rj45_board_length / 2;
rj45_standoff_height = 3;

// -----------------------------
// Screw dimensions
// -----------------------------
screw_spacer_inner_diameter = 3.2;
screw_spacer_outer_diameter = screw_spacer_inner_diameter + 4;
screw_hole_positions_x = [
    -plate_width / 2 + plate_thickness + screw_spacer_outer_diameter / 2 + 1,
    plate_width / 2 - plate_thickness - screw_spacer_outer_diameter / 2 - 1
    ];
screw_hole_positions_y = [
    plate_top_y - plate_thickness - screw_spacer_outer_diameter / 2 - 1,
    plate_bottom_y + plate_thickness + screw_spacer_outer_diameter / 2 + 1
    ];
screw_hole_diameter = screw_spacer_inner_diameter + 3;
screw_hole_radius = screw_hole_diameter / 2;
screw_spacer_height = 2;
screw_standoff_height = high_wall_height - screw_spacer_height;
screw_standoff_hole_diameter = 4.5;