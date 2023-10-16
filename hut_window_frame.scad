mm=1;
cm=10*mm;
in=25.4*mm;


module window_silhouette(width, height){
    union(){
        translate([0,-height/2])
        square([width, height],center=true);
        rotate(45)
        square(sqrt(2)/2*width, center=true);
        
    }
}

hole_width=1.7*in;
hole_height=2.05*in;
board_width = 1/4*in;
board_th = 1/16*in;
attic_wall_th = 0.4*in;
wood_wall_th = 0.5*in;



module window_frame(){
    inner_width = hole_width-2*board_th;
    inner_height = hole_height - (1+sqrt(2)/4)*board_th;
    
    outer_width = hole_width+2*board_width;
    outer_height = hole_height + (1+sqrt(2)/4)*board_width;
    windowsill_width=board_th + attic_wall_th/2;
    
    difference(){
        union(){
            translate([0,+sqrt(2)/4*board_width],0)
            linear_extrude(board_th)
            window_silhouette(outer_width, outer_height);
            linear_extrude(windowsill_width)
            window_silhouette(hole_width, hole_height);
        }
        translate([0,-sqrt(2)/4*board_th],0)
        linear_extrude(4*windowsill_width,center=true)
        window_silhouette(inner_width, inner_height);
    }
    
}

module round_side_window_frame(round_hole_dia, wall_th) {
    $fn=64;
    hole_rad = round_hole_dia/2;
    inner_hole_rad= hole_rad-board_th;
    outer_hole_rad = hole_rad + board_width;
    windowsill_width=board_th + wall_th/2;
    
    difference(){
        
        
        union(){
            cylinder(r=hole_rad,h=windowsill_width);
            cylinder(r=outer_hole_rad,h=board_th);
        }
        cylinder(r=inner_hole_rad,h=4*windowsill_width, center=true);
    }
}

window_frame();

translate([-3*in,0,0])
round_side_window_frame(1.775*in, 0.5*in);

translate([3*in,0,0])
round_side_window_frame(1*in, 0.25*in);


