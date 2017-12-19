$fn=60;

slop = 0.4;
rod_radius = 18.3/2 + slop - 0.3;
post_radius = 10.2/2 + slop/2 ; 
rod_post_spacing = 6.2 + slop - 0.4;

showerhead_upper_radius = 22.8/2 ; 
showerhead_lower_radius = 20.9/2 ; 
showerhead_slope_len = 28.0;

showerhead_taper = showerhead_upper_radius - showerhead_lower_radius;
showerhead_height = sqrt(showerhead_slope_len*showerhead_slope_len - showerhead_taper*showerhead_taper);

height_at_rod = 18.2 - 5 - 4;
height_at_post = 25.5 - 5;

wall = 5;

total_x = rod_radius + 2*post_radius + 2*rod_post_spacing + 1.5*showerhead_upper_radius;
total_y = 2*(wall + showerhead_upper_radius);
total_z = height_at_post;

block_taper_x = total_x -(rod_radius + rod_post_spacing + post_radius);
block_taper_y = height_at_post - height_at_rod;
taper_angle = atan2(block_taper_y, block_taper_x);

module showerblock_raw(){
    difference(){
        translate([-(rod_radius + rod_post_spacing + post_radius), -total_y/2, 0])
        cube([total_x, total_y, total_z]);

        rotate([0, taper_angle, 0])
        translate([-50,-50,-20])
        cube([100, 100, 20]);
    }
}


rotate([180,0,0])
difference() {
    color("blue")
    showerblock_raw();
    cylinder(r=post_radius, h = 60, center=true);
    
    translate([-(post_radius + rod_radius + rod_post_spacing),0,0])
    cylinder(r=rod_radius, h=60, center=true);
    
    translate([(post_radius + rod_radius + rod_post_spacing),0,-1])
    cylinder(r1=showerhead_lower_radius,r2=showerhead_upper_radius,h=showerhead_height);
}

