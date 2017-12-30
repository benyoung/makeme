mm=1;
cm=10*mm;
in=25.4*mm;

slop=0.1;
bar_len = 3*in;

wall = 2*mm;

magnet_rad = 2.2*cm/2 + slop; 
magnet_th=7*mm+slop;        
hole_rad = 1.2*mm+slop;       



eyestalk_len = 2*in;
eyestalk_rad = 4*mm;

eyestalk_ang = 20;

eyeball_rad = 10*mm;
googly_rad = 15.5*mm/2; 
hole_depth = 5*mm;

eps=0.01;

cutout=4*mm; // made_up
cutout_width=44*mm;

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
            translate([0,0,(magnet_th+wall-cutout)/2])
            cube([2*magnet_rad+2*wall,bar_len,magnet_th+wall+cutout],center=true);
                
            translate([0,bar_len/2,(magnet_th+wall-cutout)/2])
            cylinder(r=magnet_rad+wall,h=magnet_th+wall+cutout,center=true);

            translate([0,-bar_len/2,(magnet_th+wall-cutout)/2])
            cylinder(r=magnet_rad+wall,h=magnet_th+wall+cutout,center=true);


            translate([0,bar_len/2,0])
            eyestalk();
            translate([0,-bar_len/2,0])
            eyestalk();

        }
        union() {
            mirror([0,0,-1])
            translate([-2*magnet_rad,-cutout_width/2,0])
            cube([4*magnet_rad,cutout_width,2*cutout]);
            translate([0,0,-2*eps])
            cylinder(r=magnet_rad,h=magnet_th);
            
        }
    }
}

base();