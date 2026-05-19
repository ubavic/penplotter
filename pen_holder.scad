$fn = 200;

hole_edge_distance = 10;
track_distance = 40.5;
holder_lenght = 2 * hole_edge_distance + track_distance;
holder_small_lenght = holder_lenght;
holder_width = 100;
hole_radius = 2.6;
plate_thickness = 2;
wall_thickness = 5;
belt_hloder_length = 20;
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
  difference() {
    linear_extrude(plate_thickness) {
      polygon(points=points);
    }
    translate([holder_width / 2, hole_edge_distance, 0])
      drill();
    translate(
      [
        holder_width / 4,
        holder_lenght - hole_edge_distance,
        0,
      ]
    )
      drill();
    translate(
      [
        3 * holder_width / 4,
        holder_lenght - hole_edge_distance,
        0,
      ]
    )
      drill();
  }
}

module belt_holder() {
  mirror([0, 0, 1]) difference() {
      cube([belt_hloder_length, wall_thickness, height]);
      translate([belt_hloder_length / 2, 2, 20]) cube([2, 2 * wall_thickness, height + 2], center=true);
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

module rail_holder() {
  base_length = 42;
  holder_length = 18;
  holder_height = 32;
  width = 14;
  difference_pad=5;

  difference() {
    color("#AAA") union() {
        cube([base_length, width, 6]);
        translate([base_length / 2 - holder_length / 2, 0, 0])
          cube([holder_length, width, holder_height]);
      }
    translate([base_length / 2, 3 / 2 * width, 20]) rotate([90, 0, 0]) cylinder(2 * width, r=4);
    translate([difference_pad,width/2,-20]) cylinder(r=3, h=100);
    translate([base_length-difference_pad,width/2,-20]) cylinder(r=3, h=100);
  }
}

plate_height = distancer_height * 2 + wheel_height;

module pen_holder() {
  translate([holder_width / 2, hole_edge_distance, 0]) axle();
  translate([holder_width / 4, holder_lenght - hole_edge_distance, 0]) axle();
  translate([3 * holder_width / 4, holder_lenght - hole_edge_distance, 0]) axle();

  translate([2,0,-14])  rotate([90, 0, 0]) rail_holder();

  union() {
    plate();
    translate([0, 0, -15]) wall(wall_thickness);
    translate([holder_width - 46, 0, -15]) wall(wall_thickness);
  }

  translate([0, 0, plate_height + plate_thickness]) union() {
      plate();
      belt_holder();
      translate([holder_width - belt_hloder_length, 0, 0]) belt_holder();
    }
}

pen_holder();
