$fn = $preview ? 50 : 150;

collar_diameter = 62;
collar_wall_thickness = 4;
collar_depth = 80;
collar_top_lip = 5;

module mirror_copy(normal) {
    children();

    mirror(normal)
    children();
}

module collar(
    diameter,
    depth,
    wall_thickness,
    top_lip,
    standoff_size = 0.8,
    standoff_height = 30,
    standoff_count = 8,
) {
    internal_diameter = diameter - 2*wall_thickness;

    $fn=400;

    difference() {

        union() {
            cylinder(d=diameter, h=depth);
            cylinder(
                d1=diameter + 2*top_lip,
                d2=diameter + 2*top_lip + 2*wall_thickness,
                h=wall_thickness
            );

            if (standoff_size > 0) {
                for (i = [0:standoff_count-1]) {
                    rotate([0, 0, i*360/standoff_count])
                    union() {
                        translate([diameter/2, 0, wall_thickness])
                        cylinder(r=standoff_size, h=standoff_height, $fn=50);

                        translate([diameter/2, 0, wall_thickness + standoff_height])
                        sphere(r=standoff_size, $fn=50);
                    }
                }
            }
        }

        translate([0, 0, -1])
        cylinder(d=diameter - 2*wall_thickness, h=depth + 2);

        cylinder(d1=internal_diameter + 2*wall_thickness, d2 = internal_diameter, h=wall_thickness);
    }
}

module cable_clip(
    gap = 3,
    diameter = 8,
    thickness = 1.5,
    height = 5,
    r = 0.5,
) {
    translate([0, diameter/2 + thickness, 0])
    linear_extrude(height=height)
    offset(r=r)
    difference() {

        union() {
            circle(d=diameter + 2*thickness - 2*r);

            translate([-(diameter - 2*r)/2, -diameter, 0])
            square([diameter - 2*r, diameter - 2*r]);
        }
        circle(d=diameter + 2*r);

        translate([-gap/2 - r, 0, 0])
        square([gap + 2*r, diameter]);
    }
}

module cable_clip_2(
    gap = 3,
    cable_thickness = 5,
    thickness = 1.5,
    slot_length = 10,
    height = 10,
    angle = 20,
    r=0.5,
) {
    difference() {
        translate([cable_thickness/2, 0, 0])
        linear_extrude(height=height)
        offset(r=r)
        difference() {
            hull() {
                square([cable_thickness + 2*thickness - 2*r, cable_thickness + 2*thickness - 2*r], center=true);
                translate([slot_length, 0, 0])
                    circle(d=cable_thickness + 2*thickness - 2*r);
            }

            hull() {
                circle(d=cable_thickness + 2*r);
                translate([slot_length, 0, 0])
                    circle(d=cable_thickness + 2*r);
            }

            translate([-cable_thickness/4, -cable_thickness, 0])
                square([gap + 2*r, gap]);
        }

        translate([0, -(cable_thickness + 2*thickness + 2)/2, height])
        rotate([0, 20, 0])
        cube([slot_length * 2, cable_thickness + 2*thickness + 2, slot_length]);
    }
}

module clip_shaft(
    height = 80,
    clip_count = 6,
    diameter = 20,
) {
    translate([0, 0, height])
    rotate([180, 0, 0])
    union() {
        rotate([0, 0, 30])
        cylinder(d=diameter, h=height);

        for (i = [0:clip_count-1]) {
            rotate([0, 0, i * 360/clip_count])
            translate([diameter/2, 0, 0])
            cable_clip_2();
        }
    }
}

module handle_cutout(diameter = 30, grip_thickness = 6) {
    mirror_copy([1, 0, 0])
    difference() {
        resize([diameter, diameter, diameter/2])
        sphere(d=diameter);

        translate([grip_thickness/2, 0, 0])
        rotate([0, -10, 0])
        translate([-diameter/2, 0, 0])
        cube([diameter, diameter, diameter], center=true);
    }
}

module cable_slot_cutout(width = 20, height=40) {
    linear_extrude(height = height)
    hull() {
        circle(d=width);

        translate([100, 0])
        square([width, width], center=true);
    }
}

module cable_holder(
    collar_internal_diameter = collar_diameter - 2*collar_wall_thickness,
    collar_wall_thickness = collar_wall_thickness,
    clip_shaft_diameter = 20,
    flat_edge_height = 20,
    taper_height = 20,
    tolerance = 0.2,
) {
    difference() {
        union() {
            translate([0, 0, collar_wall_thickness])
            cylinder(
                d = collar_internal_diameter - 2*tolerance,
                h = flat_edge_height
            );

            translate([0, 0, collar_wall_thickness + flat_edge_height])
            cylinder(
                d1=collar_internal_diameter - 2*tolerance,
                d2= clip_shaft_diameter,
                h = taper_height
            );

            cylinder(
                d1=collar_internal_diameter + 2*collar_wall_thickness - 2*tolerance,
                d2=collar_internal_diameter - 2*tolerance,
                h=collar_wall_thickness
            );

            clip_shaft(diameter = clip_shaft_diameter);
        }

        rotate([0, 0, 90])
        handle_cutout();

        translate([collar_internal_diameter/2, 0, -1])
        cable_slot_cutout();
    }
}

/* collar( */
/*     collar_diameter, */
/*     collar_depth, */
/*     collar_wall_thickness, */
/*     collar_top_lip, */
/* ); */

/* cable_holder(); */
