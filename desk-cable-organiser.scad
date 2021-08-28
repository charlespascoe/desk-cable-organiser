include <variables.scad>;

$fn=100;

module collar(
    diameter,
    depth,
    wall_thickness,
    top_lip,
    standoff_size = 0.5,
    standoff_height = 10,
    standoff_count = 6
) {
    internal_diameter = diameter - 2*wall_thickness;

    $fn=400;

    difference() {

        union() {
            cylinder(d=diameter, h=depth);
            cylinder(d=diameter + 2*top_lip, h=wall_thickness);

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

module cable_holder(collar_internal_diameter, collar_wall_thickness, tolerance=0.2) {
    translate([0, 0, collar_wall_thickness])
    cylinder(
        d1=collar_internal_diameter - 2*tolerance,
        d2=collar_internal_diameter - 5 - 2*tolerance,
        h = 10
    );

    cylinder(
        d1=collar_internal_diameter - 2*tolerance,
        d2=collar_internal_diameter - 5 - 2*tolerance,
        h = 10
    );

    cylinder(
        d1=collar_internal_diameter + 2*collar_wall_thickness - 2*tolerance,
        d2=collar_internal_diameter - 2*tolerance,
        h=collar_wall_thickness
    );

    clip_shaft();
}

/* collar( */
/*     collar_diameter, */
/*     /1* collar_depth, *1/ */
/*     15, */
/*     collar_wall_thickness, */
/*     collar_top_lip, */
/*     standoff_size = 1, */
/*     standoff_height = 6, */
/*     standoff_count = 8 */
/* ); */

/* cable_holder( */
/*     collar_diameter - 2*collar_wall_thickness, */
/*     collar_wall_thickness */
/* ); */

/* cable_clip(); */

clip_shaft();

/* cable_clip_2(); */
