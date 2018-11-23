mm=1;
in=25.4*mm;

module dimers(grid_size, dimer_length, dimer_width) {
    translate(grid_size*[0, -0.25])
    square([dimer_length, dimer_width], center=true);

    translate(grid_size*[0, 0.25])
    square([dimer_length, dimer_width], center=true);
}


slop = 0.018*in; // tight
//slop=0.05*in; // loose
wall = 0.07*in;

grid_size = 1*in;


block_size = grid_size - slop;

neg_dimer_length = block_size - 2*wall-slop;
neg_dimer_width = block_size/2 - 2*wall-slop;

pos_dimer_length = neg_dimer_length+slop;
pos_dimer_width = neg_dimer_width+slop;

//top_extend = 0;        // mill out just what's needed
top_extend = 0.1*in;   // mill out a bit more for deburring

module block_top() {
    difference(){
        square(grid_size-slop+top_extend,center=true);
        dimers(grid_size, neg_dimer_length, neg_dimer_width);
    }
}

module block_bottom() {
    mirror([1,1])
    dimers(grid_size, pos_dimer_length, pos_dimer_width);
}

module block_outline() {
    difference(){
        square(block_size+2*mill_diameter+2*mill_tolerance, center=true);
        square(block_size, center=true);
    }
}


// tiny test to see how things fit, assuming cut with a 1/16in mill 
// you should see a pac-man basically
/*
intersection() {
    rotate(90)
    block_top();
    block_bottom();
    translate([0.395*in,0.39*in]) 
    circle(1/32*in,$fn=16);
}
*/

mill_tolerance = 0.01*in;
mill_diameter = 1/16*in;
mill_grid_size = grid_size + mill_diameter + mill_tolerance;
pin_hole_dia = 1/4*in; // check this
pin_x_offset = 0.3*in;

module plate(which_bit = "top", m, n) {
    for(row = [0:m-1]) {
        for(col = [0:n-1]) {
            translation_x = (col-(n-1)/2)*mill_grid_size;
            translation_y = (row-(m-1)/2)*mill_grid_size;
            translate([translation_x, translation_y])
            if(which_bit == "top") {
                block_top();
            } else if(which_bit == "bottom") {
                block_bottom();
            } else if(which_bit == "outline") {
                block_outline();
            }
        }
    }
    if((which_bit=="bottom") || (which_bit == "none")) {
        for(side=[-1,1])
        translate(side*[mill_grid_size*n/2+pin_x_offset,0])
        circle(pin_hole_dia/2);
    }
}

//plate("none",4,9);    
//plate("bottom",4,9);
//plate("top",4,9);
plate("outline",4,9);

// waste board:
// cut holes into the waste board in the position of the carvey mount points
// bolt the waste board down through those holes
// cut the "none" plate into the waste board, to hold the pins
//
// then, for each oak board: 
// 1) cut the bottom plate, 1/8 in deep
// 2) put dowels in the pin holes and flip over
// 3) cut the top plate 1/8 in deep
// 4) cut the outline plate, not quite 1/2 in deep
// **** 5) cut a yet-to-be-designed tab plate, 1/2 in deep



