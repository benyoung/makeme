mm=1;
in=25.4*mm;
$fn=32;

//real numbers
cup_rad = 4.625/2*in;
strip_length = 14.25*in;
cup_height = 1.5*in;
leather_th = 1/8*in;

//made up numbers
hole_inset = 3/16*in;

hole_rad = 1/16*in;
num_holes = 38;
side_holes = 4;

hole_sep = strip_length/num_holes;


// base

difference(){
    circle(cup_rad);
    for(hole = [0:num_holes-1]) {
        rotate(360/num_holes*hole)
        translate([cup_rad-hole_inset-leather_th,0])
        circle(hole_rad);
    }
}
    

// wall

translate([0,3*in])
difference(){
    translate([0,cup_height/2])
    square([strip_length, cup_height],center=true);

    translate([-strip_length/2+hole_sep/2,hole_inset])
    for(hole=[0:num_holes-1]){
        translate([hole*hole_sep, 0])
        circle(hole_rad);
        
    }
    for(side=[-1,1]){
        translate([side*(strip_length/2-hole_sep/2),hole_inset])
        for(hole=[1:side_holes]) {
            translate([0,hole*hole_sep])
            circle(hole_rad);
        }
    }

}
        


