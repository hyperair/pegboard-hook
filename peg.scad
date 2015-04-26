include <MCAD/units/metric.scad>
use <MCAD/general/facets.scad>
use <fillet.scad>

include <configuration.scad>


module peg ()
{
    peg_fillet_steps = get_fragments_from_r (peg_rounding_r,
        $fs = 0.1, $fn = 0) / 4;

    fillet (r = peg_rounding_r, steps = peg_fillet_steps) {
        peg_stem ();
        peg_flange ();
    }

    fillet (r = peg_rounding_r, steps = peg_fillet_steps, include = false) {
        peg_stem ();
        peg_base_stub ();
    }
}

module peg_base_stub ()
{
    cylinder (d = peg_flange_d + peg_rounding_r * 2, h = 1);
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

module peg_flange ()
{
    translate ([0, 0, -(peg_flange_thickness + peg_stem_length)])
    cylinder (d = peg_flange_d, h = peg_flange_thickness);
}

peg ();
