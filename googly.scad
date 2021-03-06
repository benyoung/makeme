mm=1;
in=25.4*mm;

can_rad = 11.5*in/2;
can_h = 1.55*in;


yogurt_lid_rad=95*mm/2;
yogurt_lid_rim=10.65*mm - 1.2*mm;
yogurt_lid_rim_inset = 4.3*mm;
depth = 0.5*in;
eps=0.01*mm;

slop = 0.2*mm;
magnet_x = 9.60*mm+slop; // made-up number
magnet_y = 4.71*mm+slop; // made-up number
magnet_z = 19.51*mm+slop; //made-up number
magnet_fudge = 0.5*mm;
magnet_z_lower=1*mm;

cutout_x=1.13*in;
bb_x = 2.07*in;
bb_y = 12*in;
bb_z = 5*in;

bridge_x=cutout_x + eps;
bridge_y = 1*mm;
bridge_z = 0.6*in;
bridge_lift = 0.75*in;
bridge_secondstory_narrow = 0.2*in;
bridge_secondstory_th = 0.7*mm;

rotate([90,0,0])
translate([0,can_rad+yogurt_lid_rim_inset,-bridge_lift])
union(){
    intersection(){
        color("green")
        cube([bb_x,bb_y,bb_z], center=true);
        difference(){
            union(){
                translate([0,-can_rad+depth-yogurt_lid_rim_inset,yogurt_lid_rim])
                rotate([90,0,0])
                translate([0,yogurt_lid_rad,0])
                cylinder(r=yogurt_lid_rad,h=depth,$fn=120);
            }
            union(){
                translate([0,0,can_h-eps])
                cylinder(r=can_rad+depth, h=2*yogurt_lid_rad);
                
                color("gray")
                cylinder(r=can_rad, h=can_h, $fn=120);
                color("red")
                for(side=([-1,1])) {
                    rotate([0,0,side*8])
                    translate([-magnet_x/2,-can_rad-magnet_y+magnet_fudge,can_h-magnet_z-magnet_z_lower])
                    cube([magnet_x,magnet_y,magnet_z]);  
                }
                
                cube([cutout_x,bb_y,bb_z],center=true);
    
            }
        }
    }
    translate([-bridge_x/2, -can_rad-yogurt_lid_rim_inset, bridge_lift])
    cube([bridge_x,bridge_y,bridge_z]);
    translate([-bridge_x/2, -can_rad-yogurt_lid_rim_inset, bridge_lift+bridge_secondstory_narrow])
    cube([bridge_x,bridge_y+bridge_secondstory_th,bridge_z-2*bridge_secondstory_narrow]);

}
