module add_pin_bar_preview(
	position,
	orientation = [0, 0, 0],
	direction = "horizontal",
	pin_count = 8,
	bar_length = 20
) {
	base_height = 2.6;
	base_depth = 2.4;
	pin_diameter = 0.8;
	pin_height = 6;

	// Keep pins evenly distributed with half-pitch margin at both ends.
	resolved_pin_count = pin_count > 0 ? pin_count : 1;
	base_span = bar_length;
	pin_spacing = base_span / resolved_pin_count;
	pin_start = -base_span / 2 + pin_spacing / 2;

	rotate(orientation)
		translate(position) {
			if (direction == "vertical") {
				color([0.08, 0.08, 0.08, 0.9])
					translate([-base_depth / 2, -base_span / 2, 0])
						cube([base_depth, base_span, base_height]);

				for (i = [0 : pin_count - 1]) {
					pin_y = pin_start + i * pin_spacing;
					color([0.85, 0.68, 0.2, 0.9])
						translate([0, pin_y, base_height])
							cylinder(h = pin_height, d = pin_diameter, $fn = 16);
				}
			} else {
				color([0.08, 0.08, 0.08, 0.9])
					translate([-base_span / 2, -base_depth / 2, 0])
						cube([base_span, base_depth, base_height]);

				for (i = [0 : pin_count - 1]) {
					pin_x = pin_start + i * pin_spacing;
					color([0.85, 0.68, 0.2, 0.9])
						translate([pin_x, base_depth / 2, base_height / 2])
							rotate([-90, 0, 0])
								cylinder(h = pin_height, d = pin_diameter, $fn = 16);
				}
			}
		}
}
