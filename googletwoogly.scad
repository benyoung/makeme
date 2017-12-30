mm=1;
cm=10*mm;
in=25.4*mm;

slop=0.1;
magnet_rad = 1.5*cm/2 + slop; // made-up number
magnet_th=5*mm+slop;        // made-up number
hole_rad = 1*mm;       // made-up number

wall = 2*mm;

eyestalk_len = 2*in;
eyestalk_rad = 4*mm;

eyestalk_ang = 20;

eyeball_rad = 14*mm;
googly_rad = 8*mm; // made-up number
hole_depth = 3*mm;

eps=0.01;

module eyestalk() {
    translate([0,0,eyeball_rad/sin(eyestalk_ang) - eyestalk_rad /tan(eyestalk_ang)+ eyestalk_len])
    difference(){
        union(){
            translate([0,0,-eyeball_rad/sin(eyestalk_ang)])
            cylinder(r1=0,r2=eyeball_rad * cos(eyestalk_ang), h = eyeball_rad * cos(eyestalk_ang) /tan(eyestalk_ang));
            sphere(eyeball_rad);
        }
        union(){
            rotate([0,90,0])
            translate([0,0,eyeball_rad-hole_depth])
            cylinder(r=googly_rad,h=hole_depth+eps);
        }
    }
    cylinder(r=eyestalk_rad,h=eyestalk_len);
    
}

module base() {
    difference(){
        union() {
            translate([0,0,-eps])
            cylinder(r=magnet_rad+wall, h=magnet_th+wall+eps);
            translate([0,0,magnet_th+wall])
            scale([1,1,0.7])
            sphere(magnet_rad+wall);

            translate([0,-magnet_th,magnet_th])
            rotate([20,0,0])
            eyestalk();
            translate([0,magnet_th,magnet_th])
            rotate([-20,0,0])
            eyestalk();

        }
        union() {
            mirror([0,0,-1])
            cylinder(r=2*magnet_rad,h=2*magnet_rad);
            translate([0,0,-2*eps])
            cylinder(r=magnet_rad,h=magnet_th);
            
        }
    }
}

base();