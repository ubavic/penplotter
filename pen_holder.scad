module pen_holder() {
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

  module wheel() {
    color("#333") difference() {
      cylinder(r=12, h=11, center=true);
      cylinder(r=3, h=15, center=true);
    }
  }

  translate([holder_width / 2, hole_edge_distance + track_distance, 12]) wheel();

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
};

pen_holder();