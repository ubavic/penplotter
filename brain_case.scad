$fn = 200;

power_module_width = 115;
power_module_length = 215;
case_thickness = 3;
drill_gap = 150;
front_protrusion = -15;
case_length = power_module_length - front_protrusion;

case_gap = 1;

module case_side_wall() {
  difference() {
    cube([case_thickness, case_length, 40]);
    for (i = [1:15]) {
      translate([-2, 60 + i * 8, 20]) cube([10, 2, 21]);
    }
  }
}

module power_module_drill() {
  r = 5 / 2;
  translate([-10, r, r])
    rotate([0, 90, 0])
      cylinder(h=power_module_width + 20, r=r);
}

module power_supply() {
  difference() {
    color([0.8, 0.8, 0.8]) cube([power_module_width, power_module_length, 30]);
    translate([5 / 2, -2, 12]) cube([110, 20, 20]);
    translate([0, 30, 10]) power_module_drill();
    translate([0, 30 + drill_gap, 10]) power_module_drill();
  }
}

module case_front_wall() {
  difference() {
    cube([power_module_width + 4 * case_gap, 3, 30 + case_gap]);
    translate([power_module_width - 15, -10, -2]) cube([10, 30, 10]);
  }
}

module case_top_wall() {
  difference() {
    cube([power_module_width + 4 * case_gap, case_length, case_thickness]);
    for (i = [0:2]) {
      translate([10, 20 + i * 90, -2]) cube([5, 10 , 20]);
      translate([105, 20 + i * 90, -2]) cube([5, 10 , 20]);
    }
  }
}

module case() {
  difference() {
    union() {
      translate([-2 * case_gap, front_protrusion, 40])
        case_top_wall();

      translate([-case_thickness - case_gap, front_protrusion, case_thickness])
        case_side_wall();

      translate([power_module_width + case_gap, front_protrusion, case_thickness])
        case_side_wall();

      translate([-2 * case_gap, front_protrusion, 10])
        case_front_wall();
    }
    translate([0, 30, 10]) power_module_drill();
    translate([0, 30 + drill_gap, 10]) power_module_drill();
  }
}

case();
power_supply();
