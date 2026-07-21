// Filament Storage - Microcontroller Case Baseplate

use <standoff.scad>
use <pins.scad>
use <hole.scad>
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

rj45_center_dx = (rj45_board_width + rj45_board_gap) / 2;
rj45_center_y = plate_bottom_y + rj45_board_length / 2;
rj45_outer_left_x = rj45_pair_center_x - rj45_center_dx - rj45_board_width / 2;
rj45_outer_right_x = rj45_pair_center_x + rj45_center_dx + rj45_board_width / 2;

opposite_wall_height = max(0, rj45_standoff_height - rj45_board_clearance_to_wall);
rj45_top_clearance_wall_height =
    rj45_standoff_height + rj45_board_thickness + rj45_top_wall_extra_clearance;

end_extension_inner_left_x = rj45_outer_left_x - rj45_end_wall_clearance;
end_extension_inner_right_x = rj45_outer_right_x + rj45_end_wall_clearance;
left_end_extension_width = max(0, end_extension_inner_left_x - plate_left_x);
right_end_extension_width = max(0, plate_right_x - end_extension_inner_right_x);

// -----------------------------
// Baseplate hole and spacer geometry
// -----------------------------
hole_diameter = 5;
hole_radius = hole_diameter / 2;
spacer_height = 2;
spacer_outer_diameter = hole_radius + 2;
spacer_inner_diameter = hole_radius / 2;

higher_wall_inner_y = plate_top_y - plate_thickness;
plate_side_inset = plate_thickness + 1;
// Keep the previous edge clearance to side walls when changing hole diameter.
side_hole_clearance = plate_side_inset - 1.5;

// Hole near the board/wall corner: 5 mm from board edge and 1 mm from higher wall.
hole_board_wall_x = board_right_x + 5 + hole_radius;
hole_board_wall_y = higher_wall_inner_y - 1 - hole_radius;

// Hole in the plate corner near the higher wall and side.
hole_high_wall_corner_x = plate_right_x - side_hole_clearance - hole_radius;
hole_high_wall_corner_y = higher_wall_inner_y - 1 - hole_radius;

// Side holes: constant side-edge clearance and 3 mm behind RJ45 boards.
rj45_holes_y = rj45_center_y + rj45_board_length / 2 + 3 + hole_radius;
hole_rj45_left_x = plate_left_x + side_hole_clearance + hole_radius;
hole_rj45_right_x = plate_right_x - side_hole_clearance - hole_radius;

hole_positions = [
    [hole_board_wall_x, hole_board_wall_y],
    [hole_high_wall_corner_x, hole_high_wall_corner_y],
    [hole_rj45_left_x, rj45_holes_y],
    [hole_rj45_right_x, rj45_holes_y]
];

// Base plate
difference() {
    translate([plate_left_x, plate_bottom_y, 0])
        cube([plate_width, plate_length, plate_thickness]);

    for (p = hole_positions) {
        add_baseplate_hole_cutout(p, plate_thickness, hole_diameter);
    }
}

// Spacers on top of each baseplate hole.
for (p = hole_positions) {
    add_hole_with_spacer(
        p,
        plate_thickness,
        spacer_height,
        spacer_outer_diameter,
        spacer_inner_diameter
    );
}

// Side wall on one short edge
translate([plate_left_x, plate_top_y - plate_thickness, plate_thickness])
    cube([lower_wall_length, plate_thickness, lower_wall_height]);

translate([plate_left_x + lower_wall_length, plate_top_y - plate_thickness, plate_thickness])
    cube([plate_width - lower_wall_length, plate_thickness, high_wall_height]);

// Full-width wall on the opposite short edge, 1 mm below RJ45 boards
translate([plate_left_x, plate_bottom_y, plate_thickness])
    cube([plate_width, plate_thickness, opposite_wall_height]);

// Taller wall extensions at both ends up to RJ45 top + 1 mm,
// stopping 1 mm before the outer sides of the RJ45 boards.
translate([plate_left_x, plate_bottom_y, plate_thickness])
    cube([left_end_extension_width, plate_thickness, rj45_top_clearance_wall_height]);

translate([end_extension_inner_right_x, plate_bottom_y, plate_thickness])
    cube([right_end_extension_width, plate_thickness, rj45_top_clearance_wall_height]);

// Board standoffs
for (sx = [-mount_dx / 2, mount_dx / 2]) {
    for (sy = [-mount_dy / 2]) {
        standoff(
            standoff_height,
            [board_center_x + sx, board_center_y + sy, plate_thickness],
            standoff_diameter,
            screw_hole_diameter
        );
    }
}

module preview_board() {
    usb_c_width = 9;
    usb_c_depth = 7;
    usb_c_height = 3.2;
    corner_block_over_wall = 4;
    corner_block_over_open_side = 6;
    corner_block_height = 2;
    pin_bar_length = 20;
    pin_bar_depth = 2.4;
    pin_bar_count = 8;

    board_x0 = board_center_x - board_width / 2;
    board_y0 = board_center_y - board_length / 2;
    board_z0 = plate_thickness + standoff_height;

    color([0.1, 0.6, 0.1, 0.6])
        translate([
            board_x0,
            board_y0,
            board_z0
        ])
            cube([board_width, board_length, board_thickness]);

    // USB-C connector preview on board underside at wall-facing edge
    color([0.8, 0.8, 0.8, 0.8])
        translate([
            board_center_x - usb_c_width / 2,
            board_center_y + board_length / 2 - usb_c_depth,
            board_z0 - usb_c_height
        ])
            cube([usb_c_width, usb_c_depth, usb_c_height]);

    // White support block on underside near the wall/open-side corner
    color([1, 1, 1, 1])
        translate([
            board_x0,
            board_y0 + board_length - corner_block_over_wall,
            board_z0 - corner_block_height
        ])
            cube([corner_block_over_open_side, corner_block_over_wall, corner_block_height]);

    // Pin bars on left/right board edges, pins facing upward.
    add_pin_bar_preview(
        position = [
            board_x0 + pin_bar_depth / 2,
            board_center_y,
            board_z0 + board_thickness
        ],
        orientation = [0, 0, 0],
        direction = "vertical",
        pin_count = pin_bar_count,
        bar_length = pin_bar_length
    );

    add_pin_bar_preview(
        position = [
            board_x0 + board_width - pin_bar_depth / 2,
            board_center_y,
            board_z0 + board_thickness
        ],
        orientation = [0, 0, 0],
        direction = "vertical",
        pin_count = pin_bar_count,
        bar_length = pin_bar_length
    );
}

if ($preview)
    preview_board();

// Two RJ45 boards on the short side opposite the existing wall (negative Y)
for (cx = [rj45_pair_center_x - rj45_center_dx, rj45_pair_center_x + rj45_center_dx]) {
    add_rj45_board_standoffs_and_preview(
        [cx, rj45_center_y],
        plate_thickness,
        rj45_standoff_height,
        standoff_diameter,
        rj45_screwhole_diameter,
        rj45_board_thickness,
        $preview
    );
}