mm=1;
in=25.4*mm;

phi = (1+sqrt(5))/2;

kite_vertices = [
        [0,0],
        [cos(18), sin(18)],
        [0,phi],
        [-cos(18),sin(18)],
        [0,0]
];


dart_vertices = [
        [0,0],
        [cos(18), sin(18)],
        [0,-phi+2*sin(18)],
        [-cos(18),sin(18)],
        [0,0]
    ];

module kite() {
    polygon(points=kite_vertices);
}

module dart() {
    polygon(points=dart_vertices);
}
    
module ring() {
    difference() {
        union() {
            cylinder(r=0.75, h=0.10,$fn=10);
            
        }
        union(){
            translate([0,0,-0.10])
            cylinder(r=0.65, h=0.30,$fn=10);
            
            for(rot=[0:36:359])
            rotate(rot)
            for(v=[[0.1, 0.65,0],[-0.1,0.65,0.1]])
            translate(v)
            color("red")
            cube(0.15, center=true);
        
        }
    }
    
}



module subdivide_kite(order=1, off=-0.02,th=0.3) {
    if(order <= 1) {
        difference(){
            linear_extrude(height=0.1)
            difference(){
                offset(off)
                kite();
                offset(off-th)
                kite();
            }
            union(){
                rotate(18)
                translate([0.65,0.1,0])
                color("blue")
                cube(0.15,center=true);
                
                rotate(-18)
                translate([-0.65,0.1,0.1])
                color("blue")
                cube(0.15,center=true);
                
                translate([0,phi,0])
                rotate(-72)
                translate([0.65,0.1,0.1])
                color("blue")
                rotate(18)
                cube(0.15,center=true);
                
                translate([0,phi,0])
                rotate(72)
                translate([-0.65,0.1,0])
                color("blue")
                rotate(-18)
                cube(0.15,center=true);
            }
            
        }
        
        for(v = [[0,0],[0,phi]]) {
            translate(v)
            ring();
        }
        
    } else {
        for(rot=[108,-108])
        translate([0,1/phi])
        rotate(rot)
        scale(1/phi)
        subdivide_kite(order-1,off,th);
        
        translate([0,phi])
        rotate(144)
        scale(1/phi)
        translate([0,phi-2*sin(18)])
        subdivide_dart(order-1,off,th);
        
    }    
}

module subdivide_dart(order=1, off=-0.02,th=0.3) {
    if(order <= 1) {
        difference(){
            linear_extrude(height=0.1)
        
            difference(){
                offset(off)
                dart();
                offset(off-th)
                dart();
            }
            union(){
                rotate(18)
                translate([0.35,-0.1,0])
                color("blue")
                cube(0.15,center=true);
        
                translate([cos(18),sin(18)])
                rotate(36)
                translate(-[cos(18),sin(18)])
                rotate(18)
                translate([0.35,0.1,0.1])
                color("blue")
                cube(0.15,center=true);
                      
                rotate(-18)
                translate([-0.35,-0.1,0.1])
                color("blue")
                cube(0.15,center=true);
                
                translate([-cos(18),sin(18)])
                rotate(-36)
                translate(-[-cos(18),sin(18)])
                rotate(-18)
                translate([-0.35,0.1,0.0])
                color("blue")
                cube(0.15,center=true);
            }
        }


        
    } else {
        rotate(180)
        scale(1/phi)
        subdivide_kite(order-1,off,th);
        
        translate(1/phi*[-cos(18),-sin(18)])
        rotate(-144)
        scale(1/phi)
        subdivide_dart(order-1,off,th);
    }
}


//subdivide_dart(order=1,off=-0.05,th=0.1);

module chainmail(ord) {
    scale([1,1,1.5])
    for(rot = [0:72:288])
    rotate(rot)
    translate([0,-phi]) 
    subdivide_kite(order=ord,off=-0.05,th=0.1);
}


chainmail(3);

translate([0,0,0.01])
mirror([0,0,1])
chainmail(3);

