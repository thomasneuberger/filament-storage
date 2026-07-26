// Filament Storage - Microcontroller Case Baseplate

use <standoff.scad>
use <pins.scad>
use <hole.scad>
include <rj45_board.scad>
include <microcontroller_dimensions.scad>

// Baseplate-specific dimensions
// ...

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