// Smoke-test tray for the Grok Build ↔ Grok Bot OpenSCAD loop.
// Outer 80 x 50 x 20 mm, 3 mm walls, 2 mm floor, four M3 clearance holes.

outer_x = 80;
outer_y = 50;
outer_z = 20;
wall = 3;
floor_z = 2;
hole_d = 3.4;
hole_inset = 8;
$fn = 64;

module smoke_tray() {
    difference() {
        cube([outer_x, outer_y, outer_z]);

        translate([wall, wall, floor_z])
            cube([
                outer_x - 2 * wall,
                outer_y - 2 * wall,
                outer_z - floor_z + 0.01
            ]);

        for (x = [hole_inset, outer_x - hole_inset])
            for (y = [hole_inset, outer_y - hole_inset])
                translate([x, y, -0.01])
                    cylinder(h = floor_z + 0.02, d = hole_d);
    }
}

smoke_tray();
