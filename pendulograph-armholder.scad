mm=1;
in=25.4;

module rodend() {
    difference(){
        union(){
            cube([12*mm, 20*mm, 12*mm], center=true);           
        }
        union(){
            cube([20*mm, 10*mm, 6.5*mm], center=true);
            cylinder(r=1.65*mm, h=20*mm,center=true,$fn=8);
            translate([0,0,5.5*mm])
            cylinder(r=3.4*mm, h=2.5*mm, center=true, $fn=6);
            rotate([-90,22.5,0])
            cylinder(r=3.6*mm,h=30*mm,$fn=8,center=true);

        }
    }
}

module post() {
    color("red")
    difference(){
        union(){
            cube([12*mm, 16*mm, 12*mm], center=true);
            translate([0,17/2*mm,0])
            rotate([0,45,0])
            cube([13.8*mm,3*mm, 3*mm], center=true);
            
        }
        union(){
            rotate([-90,22.5,0])
            cylinder(r=1.8*mm,h=30*mm,$fn=8,center=true);
            

        }
    }
    
}

rotate([0,90,0])
intersection(){
    union(){
        translate([0,-17*mm,0])
        rodend();
        post();
    }

}