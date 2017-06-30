layerHeight    = 0.20;
layerThickness = 0.40;



wallThickness  = 2 * layerThickness;
baseThickness  = 4 * layerHeight;


numberOfTray   =  1  ;
trayLength     = 37.0;
trayWidith     = 50.0;
trayHeight     = 17.0;
trayRounding   =  0.7;

coverThickness   =  1.5;
sideThickness    =  4 * layerThickness;
overlapThickness =  6 * layerHeight;
play             =  0.3;
chamferRadius    =  4.0;

Len    = numberOfTray * (trayLength+wallThickness) + wallThickness;
Height = trayHeight+baseThickness+coverThickness+play + overlapThickness;
Widith = trayWidith + 2*wallThickness + 2*sideThickness; 

echo("Lid dimensions");
echo(Len);
echo(trayWidith + 2*wallThickness-2*play);

translate([0,1.5*trayWidith,0])
cube([Len, trayWidith + 2*wallThickness-2*play, 3*layerThickness]);

module RoundedSquare(length, widith, height, ratio) {
	radius = height*ratio;
	difference() {
		union() {
			intersection() {
				hull() {
					translate([radius,        0, radius]) rotate([-90,  0, 0]) cylinder(r=radius, h=widith, $fn=80); 
					translate([length-radius, 0, radius]) rotate([-90,  0, 0]) cylinder(r=radius, h=widith, $fn=80); 
				}
				hull() {
					translate([0,        radius, radius]) rotate([  0, 90, 0]) cylinder(r=radius, h=length, $fn=80); 
					translate([0, widith-radius, radius]) rotate([  0, 90, 0]) cylinder(r=radius, h=length, $fn=80); 
				}
			}
			translate([0, 0, radius]) cube([length, widith, height-radius+1]);
		}
		translate([-1, -1, height]) cube([length+2, widith+2, height*2]);
	}
}


module pillModule() {
	difference() {
		cube([trayLength+2*wallThickness, trayWidith+2*wallThickness, trayHeight+baseThickness-0.01]);
		translate([wallThickness, wallThickness, baseThickness]) RoundedSquare(trayLength, trayWidith, trayHeight, trayRounding);
	}
}

module chamferVert(cr, cl) {
	translate([0,0,-1]) difference() {
		translate([-cr, -cr,  0]) cube([cr*2, cr*2, cl+2]);
		translate([ cr,  cr,  -1]) cylinder(r=cr, h=cl+4, $fn=30);
	}
}


module side() {
	union() {
		translate([0, -sideThickness,      0]) cube([Len, sideThickness, 	            Height]);
		translate([0, -sideThickness, Height-overlapThickness]) cube([Len, sideThickness+wallThickness, overlapThickness]);
	}
}

difference() {
	union() {
		for(i = [0:numberOfTray-1]) {
			translate([i*(trayLength+wallThickness+0.02), 0, 0]) pillModule();
		}
		side();
		translate([Len, Widith-2*sideThickness-0.01]) rotate([0, 0, 180]) side();
	}
	translate([  0,       -sideThickness, 0]) rotate([  0, 0,  0]) chamferVert(chamferRadius, Height);
	translate([Len,       -sideThickness, 0]) rotate([  0, 0, 90]) chamferVert(chamferRadius, Height);
	translate([  0, Widith-sideThickness, 0]) rotate([  0, 0,-90]) chamferVert(chamferRadius, Height);
	translate([Len, Widith-sideThickness, 0]) rotate([  0, 0,180]) chamferVert(chamferRadius, Height);

	translate([  0,        -sideThickness, Height]) rotate([  0, 90,  0]) chamferVert(chamferRadius*0.75, Len);
	translate([ Len, Widith-sideThickness, Height]) rotate([180, 90,  0]) chamferVert(chamferRadius*0.75, Len);
}

