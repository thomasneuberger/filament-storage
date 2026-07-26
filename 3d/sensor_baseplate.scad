// Filament Storage - Sensor Case Baseplate

include <sensor_dimensions.scad>;
include <pins.scad>;
include <rj45_board.scad>;
use <standoff.scad>;

// Base plate
translate([plate_left_x, plate_bottom_y, 0])
    cube([plate_width, plate_length, plate_thickness]);

// Sensor pedestals
for (position_x = sensor_positions_x) {
    translate([position_x, plate_top_y - plate_thickness - sensor_length, plate_thickness])
        cube([sensor_width, sensor_length, sensor_pedestal_height]);
}

// RJ45 board
add_rj45_board_standoffs_and_preview(
    [rj45_position_x, rj45_position_y],
    plate_thickness,
    rj45_standoff_height,
    rj45_standoff_diameter,
    rj45_screwhole_diameter,
    show_preview = $preview
);

// Screw standoffs
for (sx = screw_hole_positions_x) {
    for (sy = screw_hole_positions_y) {
        standoff(
            screw_standoff_height,
            [sx, sy, plate_thickness],
            screw_spacer_outer_diameter,
            screw_standoff_hole_diameter
        );
    }
}

if($preview) {
    preview_sensor(0);
    preview_sensor(1);
    preview_sensor(2);
}

module preview_sensor(index) {
    position_x = sensor_positions_x[index];
    color([0.95, 0.95, 0.95, 0.9])
        translate([position_x, plate_top_y - plate_thickness - sensor_length, plate_thickness + sensor_pedestal_height])
            cube([sensor_width, sensor_length, sensor_height]);
    
    add_pin_bar_preview(
        [-position_x - sensor_width / 2, -plate_top_y + plate_thickness + sensor_length, plate_thickness + sensor_pedestal_height + 3.5 - pin_base_height],
        [0,0,180],
        "horizontal",
        4,
        sensor_width
    );
}