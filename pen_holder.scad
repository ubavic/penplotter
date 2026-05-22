$fn = 200;

hole_edge_distance = 10;
track_distance = 40.5;
holder_length = 2 * hole_edge_distance + track_distance;
holder_small_length = hole_edge_distance + track_distance;
holder_width = 110;
hole_radius = 2.6;
plate_thickness = 2;
wall_thickness = 5;
belt_holder_length = 20;

module wall(wall_thickness) {
  height = 16;
  width = 46;
  radius = 3;

  drill_offset = (width - 31) / 2;

  module drill() {
    rotate([90, 0, 0]) cylinder(h=10 + wall_thickness, r1=radius, r2=3, center=true);
  }

  difference() {
    cube([width, wall_thickness, height]);
    translate([drill_offset, 5, height / 2]) drill();
    translate([width - drill_offset, 5, height / 2]) drill();
  }
}

module plate() {
  module drill() {
    cylinder(h=10, r=hole_radius, center=true);
  }

  points = [
    [0, 0],
    [holder_width, 0],
    [holder_width, holder_small_length],
    [holder_width / 2 + 3 / 2 * hole_edge_distance, holder_small_length],
    [holder_width / 2 + hole_edge_distance, holder_length],
    [holder_width / 2 - hole_edge_distance, holder_length],
    [holder_width / 2 - 3 / 2 * hole_edge_distance, holder_small_length],
    [0, holder_small_length],
  ];

  difference() {
    translate([0, holder_length, plate_thickness]) rotate([180, 0, 0]) linear_extrude(plate_thickness) {
          polygon(points=points);
        }
    translate([holder_width / 2, hole_edge_distance, 0])
      drill();
    translate(
      [
        holder_width / 4,
        holder_length - hole_edge_distance,
        0,
      ]
    )
      drill();
    translate(
      [
        3 * holder_width / 4,
        holder_length - hole_edge_distance,
        0,
      ]
    )
      drill();
  }
}

belt_holder_height = 25;
module belt_holder() {
  translate([0, wall_thickness / 2, belt_holder_height / 2]) difference() {
      cube([belt_holder_length, 2 * wall_thickness, belt_holder_height], center=true);
      cube([3, 4 * wall_thickness, 12], center=true);
    }
}

wheel_height = 11;
module wheel() {
  color("#333") difference() {
      cylinder(r=12, h=wheel_height, center=true);
      cylinder(r=3, h=15, center=true);
    }
}

distancer_height = 8.5;
module distancer() {
  color("#CCC") difference() {
      cylinder(r=4, h=distancer_height, center=true);
      cylinder(r=3, h=10, center=true);
    }
}

module axle() {
  translate([0, 0, plate_thickness + distancer_height + wheel_height / 2]) wheel();

  translate([0, 0, plate_thickness + distancer_height / 2])
    distancer();

  translate([0, 0, plate_thickness + wheel_height + 3 * distancer_height / 2])
    distancer();
}

rail_holder_base_length = 42;
module rail_holder() {

  holder_length = 18;
  holder_height = 32;
  width = 14;
  difference_pad = 5;

  difference() {
    color("#AAA") union() {
        cube([rail_holder_base_length, width, 6]);
        translate([rail_holder_base_length / 2 - holder_length / 2, 0, 0])
          cube([holder_length, width, holder_height]);
      }
    translate([rail_holder_base_length / 2, 3 / 2 * width, 20]) rotate([90, 0, 0]) cylinder(2 * width, r=4);
    translate([difference_pad, width / 2, -20]) cylinder(r=3, h=100);
    translate([rail_holder_base_length - difference_pad, width / 2, -20]) cylinder(r=3, h=100);
  }
}

module rail() {
  color("#EEE") cylinder(h=80, r=4);
}

module slider() {
  slider_width = 34;
  small_height = 18;
  height = 21;
  hole_edge_distance = 3;
  length = 30;
  length_gap = 4;

  module drill() {
    r = 3 / 2;
    rotate([90, 0, 0]) cylinder(3 * small_height, r=r, center=true);
  }

  points = [
    [0, 0],
    [slider_width, 0],
    [slider_width, small_height],
    [slider_width / 2 + 2 * hole_edge_distance, small_height],
    [slider_width / 2 + hole_edge_distance, height],
    [slider_width / 2 - hole_edge_distance, height],
    [slider_width / 2 - 2 * hole_edge_distance, small_height],
    [0, small_height],
  ];

  translate([-slider_width / 2, -height / 2, 0]) difference() {
      union() {

        linear_extrude(length) {
          difference() {
            polygon(points=points);
            translate([slider_width / 2, height / 2]) circle(r=15 / 2);
          }
        }

        translate([0, 0, length_gap / 2]) color("#222") linear_extrude(length - length_gap) {
              difference() {
                translate([slider_width / 2, height / 2]) circle(r=15 / 2);
                translate([slider_width / 2, height / 2]) circle(r=8 / 2);
              }
            }
      }
      translate([slider_width / 2 + 12, 0, length / 2 + 10]) drill();
      translate([slider_width / 2 + 12, 0, length / 2 - 10]) drill();
      translate([slider_width / 2 - 12, 0, length / 2 + 10]) drill();
      translate([slider_width / 2 - 12, 0, length / 2 - 10]) drill();
    }
}

module pen_fixer(drill_offset = 20, drill_vertical_gap = 20, drill_horizontal_gap = 24) {
  height = 35;
  hole_edge_distance = 3;
  length = 105;
  length_gap = 4;
  thickness = 2;
  holder_radius = 8;
  holder_thickness = 2;
  drill_height = 3;

  module drill() {
    r = 3 / 2;
    rotate([90, 0, 0]) cylinder(3 * thickness, r=r, center=true);
  }

  module side_triangle() {
    rotate([-90, 0, 90]) linear_extrude(height=thickness) {
        polygon(points=[[0, 0], [20, 0], [0, height - thickness]], paths=[[0, 1, 2]]);
      }
  }

  color("#2266AA") {
    difference() {
      translate([0, 0, -10]) linear_extrude(height + 10) {
          difference() {
            square([length, thickness], true);
            circle(holder_radius - 0.5);
          }

          difference() {
            circle(holder_radius);
            circle(holder_radius - holder_thickness);
            translate([-holder_radius, 1]) square(2 * holder_radius, false);
          }

          hull() {
            translate([0, holder_radius - holder_thickness / 2, 0]) circle(holder_thickness / 2);
            translate([-holder_radius, 0, 0]) circle(holder_thickness / 2);
          }

          hull() {
            translate([0, holder_radius - holder_thickness / 2, 0]) circle(holder_thickness / 2);
            translate([holder_radius, 0, 0]) circle(holder_thickness / 2);
          }
        }

      translate([0, -holder_radius, height / 2]) drill();
      translate([0, -holder_radius, 0]) drill();

      translate([drill_offset, 0, drill_height]) drill();
      translate([-drill_offset, 0, drill_height]) drill();
      translate([drill_offset, 0, drill_height + drill_vertical_gap]) drill();
      translate([-drill_offset, 0, drill_height + drill_vertical_gap]) drill();
      translate([drill_offset + drill_horizontal_gap, 0, drill_height]) drill();
      translate([-drill_offset - drill_horizontal_gap, 0, drill_height]) drill();
      translate([drill_offset + drill_horizontal_gap, 0, drill_height + drill_vertical_gap]) drill();
      translate([-drill_offset - drill_horizontal_gap, 0, drill_height + drill_vertical_gap]) drill();
    }

    difference() {
      translate([-length / 2, -thickness / 2, height - thickness]) cube([length, 29, thickness]);
      translate([drill_offset + drill_horizontal_gap / 2, 12, height]) cylinder(r=6, h=10, center=true);
      translate([-drill_offset - drill_horizontal_gap / 2, 12, height]) cylinder(r=6, h=10, center=true);
      translate([0, -thickness / 2, height - 2 * thickness]) linear_extrude(height=100) {
          hull() {
            translate([0, holder_radius - holder_thickness / 2, 0]) circle(holder_thickness / 2);
            translate([-holder_radius, 0, 0]) circle(holder_thickness / 2);
            translate([holder_radius, 0, 0]) circle(holder_thickness / 2);
          }
        }
    }

    translate([-length / 2 + thickness, -thickness / 2, height - thickness]) side_triangle();
    translate([length / 2, -thickness / 2, height - thickness]) side_triangle();
  }
}

module servo() {
  height = 20;
  hole_gap = 5;
  hole_horizontal_distance = 48 / 2;

  color("#333") {
    translate([-20, 0, 0]) cube([40, 38, height]);
    difference() {
      translate([-55 / 2, 5, 0]) cube([55, 3, height]);
      translate([-hole_horizontal_distance, 10, hole_gap]) rotate([90, 0, 0]) cylinder(10, r=5 / 2);
      translate([hole_horizontal_distance, 10, hole_gap]) rotate([90, 0, 0]) cylinder(10, r=5 / 2);
      translate([-hole_horizontal_distance, 10, height - hole_gap]) rotate([90, 0, 0]) cylinder(10, r=5 / 2);
      translate([hole_horizontal_distance, 10, height - hole_gap]) rotate([90, 0, 0]) cylinder(10, r=5 / 2);
    }
  }
  translate([-10, 0, height / 2]) rotate([90, 0, 0]) color("#e2d780") cylinder(6, r=5 / 2);
}

plate_height = distancer_height * 2 + wheel_height;
wall_edge_distance = 18;
k = 20;

module top_plate() {
  base_width = 42;

  module servo_holder() {
    width = 7;

    module drill() {
      translate([0, -5, 0]) rotate([-90, 0, 0]) cylinder(20, r=2);
    }

    difference() {
      translate([-width/2, 0, 0]) cube([width, 10, 25]);
      translate([0, 0, 8]) drill();
      translate([0, 0, 18]) drill();
    }
  }

  plate();
  translate([0, -17, -belt_holder_height]) translate([holder_width / 2, holder_length, 0]) belt_holder();
  translate([holder_width / 2 - base_width / 2, 25, plate_thickness - 1]) cube([base_width, 25, 2 + 1]);
  translate([holder_width / 2 + base_width / 2 + 3, 24, plate_thickness - 1]) servo_holder();
  translate([holder_width / 2 - base_width / 2 - 3, 24, plate_thickness - 1]) servo_holder();
}


module pen_holder() {
  translate([holder_width / 2, hole_edge_distance, 0]) axle();
  translate([holder_width / 4, holder_length - hole_edge_distance, 0]) axle();
  translate([3 * holder_width / 4, holder_length - hole_edge_distance, 0]) axle();

  translate([2, wall_edge_distance, -14]) rotate([90, 0, 0]) rail_holder();
  translate([2 + rail_holder_base_length / 2, wall_edge_distance - 20, -14]) rail();
  translate([holder_width - 44 + rail_holder_base_length / 2, wall_edge_distance - 20, -14]) rail();
  translate([holder_width - 44, wall_edge_distance, -14]) rotate([90, 0, 0]) rail_holder();

  translate([2 + rail_holder_base_length / 2, wall_edge_distance - 20, k]) slider();
  translate([holder_width - 44 + rail_holder_base_length / 2, wall_edge_distance - 20, k]) slider();

  union() {
    plate();
    translate([0, wall_edge_distance, -15]) wall(wall_thickness);
    translate([holder_width - 46, wall_edge_distance, -15]) wall(wall_thickness);
  }

  translate([holder_width / 2, wall_edge_distance - 32, k + 2]) pen_fixer();

  translate([0, 0, plate_height + plate_thickness]) top_plate();

  //rotate([0, 0, -90]) translate([-35, 40, plate_height + 2 * plate_thickness]) servo();
  translate([holder_width / 2, 16, plate_height + 2 * plate_thickness + 2]) servo();
}

pen_holder();
