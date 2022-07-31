mm=1;
cm=10*mm;

module tab(length, width, extend) {
        difference(){
            union(){
                translate([-width/2-length/2,-extend])
                square([length+width, width/2+extend]);
                
                translate([width/2-length/2, -extend])
                square([length-width, width+extend]);
                
                translate([length/2-width/2, width/2])
                circle(width/2);
                
                translate([-length/2+width/2, width/2])
                circle(width/2);

            }
            union(){
                translate([length/2+width/2, width/2])
                circle(width/2);
                
                translate([-length/2-width/2, width/2])
                circle(width/2);
                
            }
        }   
}


module legtab(leglen, legwidth, tablen, tabwidth, extend) {
    translate([0,extend])
    union(){
        tab(tablen, tabwidth, extend);
        translate([0, tabwidth/2-legwidth/2])
        square([leglen, legwidth]);
    }
}

module holetab(slop, legwidth, tablen, tabwidth, extend) {
    translate([0,extend])
    difference() {
        tab(tablen, tabwidth, extend);
        translate([0, tabwidth/2])
        square([slop, legwidth+slop], center=true);
    }
}


leglen=6*cm;
legwidth=0.5*cm;
tablen=3*cm;
tabwidth=1*cm;
stripwidth=1*cm;
th = 0.5*mm;
slop=1*mm;
module tabpair(which_strip) {
    translate([0,stripwidth/2])
    legtab(leglen, legwidth, tablen, tabwidth, which_strip*th);
    translate([0,-stripwidth/2])
    mirror([0,1])
    holetab(slop, legwidth, tablen, tabwidth, which_strip*th);    
}




tabpair(5);