// Filament Storage - Sensor Case Cover

include <sensor_dimensions.scad>;
include <rj45_board.scad>;
include <hole.scad>;

// Base plate
difference() {
    translate([plate_left_x, plate_bottom_y, 0])
        cube([plate_width, cover_length, plate_thickness]);

    for (sx = screw_hole_positions_x) {
        for (sy = screw_hole_positions_y) {
            add_baseplate_hole_cutout(
                [sx, sy],
                plate_thickness,
                screw_hole_diameter
            );
        }
    }
}


// Long-edge side walls matching the baseplate high wall height.
translate([plate_left_x, plate_bottom_y + plate_thickness, plate_thickness])
    cube([plate_thickness, cover_length - plate_thickness * 2, high_wall_height]);

translate([plate_right_x - plate_thickness, plate_bottom_y + plate_thickness, plate_thickness])
    cube([plate_thickness, cover_length - plate_thickness * 2, high_wall_height]);

// Short-edge wall sensor side: as wide as the baseplate and as high wall minus sensor height.
short_lower_wall_sensor_side_position = [plate_left_x, plate_bottom_y + cover_length - plate_thickness, plate_thickness];
short_lower_wall_sensor_side_size = [plate_width, plate_thickness, high_wall_height - sensor_height - sensor_pedestal_height];
translate(short_lower_wall_sensor_side_position)
    cube(short_lower_wall_sensor_side_size);

short_upper_wall_sensor_left_side_position = [
    plate_left_x,
    short_lower_wall_sensor_side_position[1],
    short_lower_wall_sensor_side_position[2] + short_lower_wall_sensor_side_size[2]];
short_upper_wall_sensor_side_size = [
    - plate_left_x + sensor_positions_x[0],
    plate_thickness,
    high_wall_height - short_lower_wall_sensor_side_size[2]];
translate(short_upper_wall_sensor_left_side_position)
    cube(short_upper_wall_sensor_side_size);

short_upper_wall_sensor_right_side_position = [
    plate_right_x - short_upper_wall_sensor_side_size[0],
    short_lower_wall_sensor_side_position[1],
    short_upper_wall_sensor_left_side_position[2]];
translate(short_upper_wall_sensor_right_side_position)
    cube(short_upper_wall_sensor_side_size);

// Short-edge wall RJ45 side: as wide as the board and as high wall minus rj45 height.
translate([plate_left_x, plate_bottom_y, plate_thickness])
    cube([plate_width, plate_thickness, high_wall_height - rj45_standoff_height - rj45_board_thickness - rj45_jack_height]);

translate([plate_left_x, plate_bottom_y, plate_thickness + high_wall_height - rj45_standoff_height - rj45_board_thickness - rj45_jack_height])
    cube([plate_width / 2 - rj45_jack_width / 2 - 1, plate_thickness, rj45_jack_height - 1]);

translate([rj45_jack_width / 2 + 1, plate_bottom_y, plate_thickness + high_wall_height - rj45_standoff_height - rj45_board_thickness - rj45_jack_height])
    cube([plate_width / 2 - rj45_jack_width / 2 - 1, plate_thickness, rj45_jack_height - 1]);

// Screw hole spacers
for (sx = screw_hole_positions_x) {
    for (sy = screw_hole_positions_y) {
        add_hole_with_spacer(
            [sx, sy],
            plate_thickness,
            screw_spacer_height,
            screw_spacer_outer_diameter,
            screw_spacer_inner_diameter
        );
    }
}