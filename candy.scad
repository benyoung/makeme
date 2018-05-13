mm=1;
cm=10*mm;
in=25.4*mm;

trough_rad = 22*mm; 
tray_depth = 16*mm;
trough_depth=1*in;
trough_length = 1.5*in;
trough_angle = 35;   
wall = 3*mm;
eps=0.01;


difference(){
    translate([0,0,-wall])
    union(){
        translate([-trough_rad-wall,0,0])
        cube([2*trough_rad+2*wall, trough_length, trough_depth]);
        cylinder(r=trough_rad+wall, h=trough_depth);
    }
    union(){
        difference(){
            cylinder(r=trough_rad,h=trough_depth);
            translate([-2*trough_rad,0,0])
            cube(4*trough_rad);
        }
        intersection(){
            translate([-2*trough_rad,-eps,0])
            cube(4*trough_rad);
            translate([-trough_rad,0,0])
            rotate([trough_angle,0,0])
            cube([2*trough_rad, trough_length, trough_depth]);
        }
    }
    
}