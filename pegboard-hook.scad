use <fillet.scad>
use <MCAD/general/facets.scad>
include <MCAD/units/metric.scad>

use <peg.scad>

plate_width = 8.45;
plate_length = 20;
plate_thickness = 3.5;

hook_thickness = 10;
hook_width = 4;
hook_length = 40;
hook_retainer_length = 20;
hook_retainer_thickness = 7.1;

hook_rounding_r = 5;

peg_positions = [
    [0, 0]
    // [0, peg_distance]
];

plate_offset = [0, -plate_length / 2];
hook_offset = [0, -plate_length / 2 + 1];

$fs = 0.2;
$fa = 1;

module round (r)
{
    offset (r = -r)
    offset (r = r)
    children ();
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
    translate (plate_offset)
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
    translate (hook_offset)
    rotate (-90, Y)
    linear_extrude (hook_width, center = true)
    round (-1.5)
    round (1.5)
    union () {
        square ([hook_length, hook_thickness]);

        translate ([hook_length, 0])
        rotate (45, Z)
        square ([hook_retainer_length, hook_retainer_thickness]);
    }
}

place_peg ()
peg ();

plate ();

hook ();

fillet (r = hook_rounding_r, steps = get_fragments_from_r (hook_rounding_r) / 4,
    include = false) {

    plate ();
    hook ();
}
