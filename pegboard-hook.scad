use <fillet.scad>
use <MCAD/general/facets.scad>
include <MCAD/units/metric.scad>

peg_distance = 25;
peg_flange_thickness = 2;
peg_flange_d = 8.45;
peg_stem_length = 2;
peg_stem_d = 4.4;

peg_rounding_r = 0.5;

plate_width = 8.45;
plate_length = peg_distance + peg_flange_d;
plate_thickness = 2;

hook_thickness = 4;
hook_depth = 40;
hook_retainer_length = 20;

hook_rounding_r = 5;

peg_positions = [
    [0, 0],
    [0, peg_distance]
];

$fs = 0.2;
$fa = 1;

module round (r)
{
    offset (r = -r)
    offset (r = r)
    children ();
}

module peg ()
{
    fillet (r = rounding_r, steps = get_fragments_from_r (rounding_r) / 4) {
        peg_stem ();

        translate ([0, 0, -(peg_flange_thickness + peg_stem_length)])
        cylinder (d = peg_flange_d, h = peg_flange_thickness);
    }
}

module peg_stem ()
{
    total_length = peg_stem_length + peg_flange_thickness;

    translate ([0, 0, -peg_stem_length - epsilon])
    linear_extrude (height = peg_stem_length + epsilon * 2)
    intersection () {
        circle (d = peg_flange_d);

        hull () {
            circle (d = peg_stem_d);

            translate ([0, peg_flange_d])
            circle (d = peg_stem_d);
        }
    }
}

module place_peg (i = -1)
{
    if (i < 0) {
        for (j = [0 : len (peg_positions)])
        place_peg (j)
        children ();

    } else if (i >= 0) {
        translate (peg_positions[i])
        children ();
    }
}

module plate ()
{
    linear_extrude (height = plate_thickness)
    hull () {
        circle (d = plate_width);

        translate ([0, plate_length - plate_width])
        circle (d = plate_width);
    }

    *translate ([0, 0, plate_thickness / 2])
    cube ([plate_width, plate_length, plate_thickness], center = true);
}

module hook ()
{
    rotate (-90, Y)
    linear_extrude (hook_thickness, center = true)
    round (-1.5)
    round (1.5)
    union () {
        square ([hook_depth, hook_thickness]);

        translate ([hook_depth, 0])
        rotate (60, Z)
        square ([hook_retainer_length, hook_thickness]);
    }
}

place_peg ()
peg ();

plate ();

// plate fillet
for (i = [0 : len (peg_positions)])
fillet (r = peg_rounding_r, steps = get_fragments_from_r (peg_rounding_r) / 4,
    include = false) {

    plate ();

    place_peg (i)
    peg_stem ();
}

hook ();

fillet (r = hook_rounding_r, steps = get_fragments_from_r (hook_rounding_r) / 4,
    include = false) {

    plate ();
    hook ();
}
