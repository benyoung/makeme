mm = 1;
in = 25.4*mm;

$fn=64;

tool_length =27.16*mm;
tool_rad = 13.8/2*mm;

nose_len=3*mm;

ring_rad = 17.8/2*mm;
ring_th = 1.5*mm;

tool_butt_height = 13.4*mm;

eps=0.01*mm;

insert_rad=2.6*mm/2;
insert_len=3*in;

total_len = nose_len + tool_length + tool_butt_height;
echo(total_len);

difference(){
    translate([0,0,-total_len+insert_len])
    union(){
        cylinder(r=tool_rad,h=tool_butt_height+eps);
        
        translate([0,0,tool_butt_height-ring_th])
        cylinder(r=ring_rad,h=ring_th);
        translate([0,0,tool_butt_height]);
        
        translate([0,0,tool_butt_height])
        cylinder(r=tool_rad,h=tool_length+eps);
        
        translate([0,0,tool_butt_height+tool_length])
        cylinder(r1=tool_rad,r2=0,h=nose_len);
            
    }
    union(){
        cylinder(r=insert_rad,h=insert_len+eps);
    }
}