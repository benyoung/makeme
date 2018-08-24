mm=1;
in=25.4*mm;

face_size = 4*in;
corner_size = 1.3*in;
gap_size = 1/4*in;
circle_rad = 1.2*in;
heart_size = 0.3*in;

heart_inset = 1/32*in;

material_thickness = 3/8*in;

$fn=60;


module heart() {
    translate([0,-0.4*heart_size])
        rotate(45)
        union(){
            square(2*heart_size,center=true);
            translate([heart_size,0])
            circle(heart_size);
            translate([0,heart_size])
            circle(heart_size);
        }
}


module cube_surface() {
    difference(){    
        for(i=[0:3])
        rotate(90*i)
        union() {
            translate([-face_size/2, -face_size/2])
            square(corner_size);
        
            translate([-face_size/4, 0])
            square([face_size/2, face_size-2*gap_size-2*corner_size], center=true);
        }
        circle(circle_rad + gap_size);
        heart();
    }
    
    difference(){
        circle(circle_rad);
        
    }
}

module cube_outline() {
    union() {
        cube_surface();
        square(face_size - 2*gap_size, center=true);
    }
}

cube_surface();

translate([face_size + 4*gap_size, 0])
cube_outline();

*
linear_extrude(height=material_thickness)
offset(-heart_inset)
heart();




