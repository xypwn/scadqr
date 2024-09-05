// This demo shows how to use the QR code generator to generate a tag (ie. for a dog collar)
// with size derived from the amount of data to encode.

include <QR.scad>;

/* [Print options] */
// The minimum printable module ("pixel") size, based on the printer's resolution
module_size = 1;

/* [Tag options] */
// The data to encode
data = "Hello, world!";
// Error correction level (L, M, Q, H)
error_correction = "M"; // [L, M, Q, H]
// Thickness of the tag base
base_thickness = 2;
// Thickness of the embossed code
code_thickness = .4;
// Space between the QR code and the tag's edge
padding = 2;
// Diameter of the hole for the tag's ring; set to 0 to disable
hole_diameter = 3;
// Tag corner radius
corner_radius = 2;

/* [Hidden] */
$fn = 32;
modules = qr_size(message = data);
size = modules * module_size + padding * 2;

// Create the baseplate
color("#ccc") linear_extrude(height = base_thickness) difference() {
    // Outer shape
    hull() {
        translate([corner_radius, corner_radius]) circle(r = corner_radius);
        translate([size - corner_radius, corner_radius]) circle(r = corner_radius);
        translate([corner_radius, size - corner_radius]) circle(r = corner_radius);
        translate([size - corner_radius, size - corner_radius]) circle(r = corner_radius);
        if(hole_diameter > 0) translate([size / 2, size + hole_diameter / 2]) circle(d = hole_diameter + 2 * padding);
    }
    if(hole_diameter > 0) translate([size / 2, size + hole_diameter / 2]) circle(d = hole_diameter);
}

// Create the QR code
color("#333")
translate([padding, padding, base_thickness]) qr(message = data, error_correction = error_correction, width = module_size * modules, height = module_size * modules, thickness = code_thickness);