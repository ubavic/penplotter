include <NopSCADlib/vitamins/extrusions.scad>
include <NopSCADlib/vitamins/extrusion_brackets.scad>
include <NopSCADlib/vitamins/stepper_motors.scad>
include <NopSCADlib/vitamins/pulleys.scad>

$fn = 200;

module small_holder() {
  hole_edge_distance = 5;
  track_distance = 40;
  holder_lenght = 2 * hole_edge_distance + track_distance;
  holder_small_lenght = track_distance;
  holder_width = 115;
  hole_radius = 2.6;
  plate_thickness = 2;
  wall_thickness = 5;
  height = 20;

  points = [
    [0, 0],
    [holder_width, 0],
    [holder_width, holder_small_lenght],
    [holder_width / 2 + 2 * hole_edge_distance, holder_small_lenght],
    [holder_width / 2 + hole_edge_distance, holder_lenght],
    [holder_width / 2 - hole_edge_distance, holder_lenght],
    [holder_width / 2 - 2 * hole_edge_distance, holder_small_lenght],
    [0, holder_small_lenght],
  ];

  module drill() {
    cylinder(h=10, r=hole_radius, center=true);
  }

  module plate() {
    difference() {
      linear_extrude(plate_thickness) {

        polygon(points=points);
      }
      translate([holder_width / 2, holder_lenght - hole_edge_distance, 0])
        drill();
      translate(
        [
          holder_width / 4,
          hole_edge_distance,
          0,
        ]
      )
        drill();
      translate(
        [
          3 * holder_width / 4,
          hole_edge_distance,
          0,
        ]
      )
        drill();
    }
  }
  module wall() {
    height = 20;

    width = 42;
    radius = 3;
    module drill() {
      rotate([90, 0, 0]) cylinder(h=10 + wall_thickness, r1=radius, r2=3, center=true);
    }

    translate([0, -wall_thickness, 0]) difference() {
        cube([42, wall_thickness, height]);
        translate([4 + radius, 5, height / 2]) drill();
        translate([width - 4 - radius, 5, height / 2]) drill();
      }
  }
  ;

  *translate([holder_width / 2, hole_edge_distance + track_distance, 12]) difference() {
      cylinder(r=12, h=11, center=true);
      cylinder(r=3, h=15, center=true);
    }

  module belt_holder() {
    difference() {
      cube([10, wall_thickness, height]);
      translate([5, 2, 10]) cube([2, 2 * wall_thickness, 5], center=true);
    }
  }

  union() {
    plate();
    translate([0, 0, height]) plate();
    translate([0, holder_small_lenght, plate_thickness - 0.2]) wall();
    translate([holder_width - 42, holder_small_lenght, plate_thickness - 0.2]) rotate([0, 0, 0]) wall();
    belt_holder();
    translate([105, 0, 0]) belt_holder();
  }
}
;

!small_holder();

module holder() {
  holder_lenght = 100;
  holder_width = 10;
  holder_base_width = 45;
  holder_base_lenght = 35;
  points = [
    [0, 0],
    [holder_base_width, 0],
    [holder_base_width + 30, holder_base_lenght],
    [holder_base_width + 30, holder_base_lenght + 30],
    [holder_base_width / 2 + holder_width / 2, holder_base_lenght + 30],
    [holder_base_width / 2 + holder_width / 2, holder_base_lenght + holder_lenght],
    [holder_base_width / 2 - holder_width / 2, holder_base_lenght + holder_lenght],
    [holder_base_width / 2 - holder_width / 2, holder_base_lenght],
    [-30, holder_base_lenght],
  ];
  
  color("#444444") linear_extrude(2) {
      minkowski() {
        polygon(points=points);
        circle(2);
      }
    }
}
;

module build() {

  bracket_size = extrusion_corner_bracket_size((E20_corner_bracket))[0];
  major_axis = 700;
  beam_color = "#666666";
  minor_axis_position = 140;

  translate([major_axis + NEMA_width(NEMA17_34) / 2, bracket_size + 35, 58]) rotate([90, 0, 0]) pulley(GT2x20_pulley_9);
  translate([major_axis + NEMA_width(NEMA17_34) / 2, bracket_size + 40, 58]) rotate([90, 0, 0]) NEMA(NEMA17_34);

  translate([20, bracket_size + 40, 40]) rotate([90, 0, 90]) extrusion_corner_bracket(E20_corner_bracket);
  translate([20, bracket_size, 40]) rotate([90, 0, -90]) extrusion_corner_bracket(E20_corner_bracket);
  translate([-20 + major_axis, bracket_size + 40, 40]) rotate([90, 0, 90]) extrusion_corner_bracket(E20_corner_bracket);
  translate([-20 + major_axis, bracket_size, 40]) rotate([90, 0, -90]) extrusion_corner_bracket(E20_corner_bracket);

  translate([minor_axis_position + 45 / 2, 300, 78]) rotate([90, 0, 0]) color(beam_color) extrusion(E2020, 550);

  translate([major_axis / 2, bracket_size + 20, 50]) rotate([0, 90, 0]) color(beam_color) extrusion(E2040, major_axis);

  translate([20, 150, 20]) rotate([90, 0, 0]) color(beam_color) extrusion(E4040, 300);
  translate([major_axis - 20, 150, 20]) rotate([90, 0, 0]) color(beam_color) extrusion(E4040, 300);

  translate([minor_axis_position, -10, 65]) holder();
}
;

build();
