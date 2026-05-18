include <NopSCADlib/vitamins/extrusions.scad> 
include <NopSCADlib/vitamins/extrusion_brackets.scad> 
include <NopSCADlib/vitamins/stepper_motors.scad> 
include <NopSCADlib/vitamins/pulleys.scad> 

module holder(){
holder_lenght=100;
holder_width=10;
holder_base_width=45;
holder_base_lenght=35;
points=[
    [0,0],
    [holder_base_width,0],
    [holder_base_width+30,holder_base_lenght],
    [holder_base_width+30, holder_base_lenght+30],
    [holder_base_width/2 + holder_width/2, holder_base_lenght+30],
    [holder_base_width/2 + holder_width/2, holder_base_lenght+holder_lenght],
    [holder_base_width/2 - holder_width/2, holder_base_lenght+holder_lenght],
    [holder_base_width/2 - holder_width/2, holder_base_lenght],
    [-30,holder_base_lenght]];
    color("#444444")linear_extrude(2){
        minkowski() {
            polygon(points=points);
            circle(2);
        }
    }

};

module build(){

bracket_size = extrusion_corner_bracket_size((E20_corner_bracket))[0];
major_axis = 700;
beam_color = "#666666";
minor_axis_position = 140; 

translate([major_axis + NEMA_width(NEMA17_34)/2, bracket_size+35, 58]) rotate([90, 0, 0]) pulley(GT2x20_pulley_9);
translate([major_axis + NEMA_width(NEMA17_34)/2, bracket_size+40, 58]) rotate([90, 0, 0]) NEMA(NEMA17_34);

translate([20, bracket_size + 40, 40]) rotate([90, 0, 90]) extrusion_corner_bracket(E20_corner_bracket);
translate([20, bracket_size, 40]) rotate([90, 0, -90]) extrusion_corner_bracket(E20_corner_bracket);
translate([-20 + major_axis, bracket_size + 40, 40]) rotate([90, 0, 90]) extrusion_corner_bracket(E20_corner_bracket);
translate([-20 + major_axis, bracket_size, 40]) rotate([90, 0, -90]) extrusion_corner_bracket(E20_corner_bracket);

translate([minor_axis_position+45/2, 300, 78]) rotate([90, 0, 0]) color(beam_color) extrusion(E2020, 550);

translate([major_axis/2, bracket_size + 20, 50]) rotate([0, 90, 0]) color(beam_color) extrusion(E2040, major_axis);

translate([20, 150, 20]) rotate([90, 0, 0]) color(beam_color) extrusion(E4040, 300);
translate([major_axis-20, 150, 20]) rotate([90, 0, 0]) color(beam_color) extrusion(E4040, 300);
    
translate([minor_axis_position, -10, 65]) holder();
};

build();