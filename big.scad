
in = 25.4;

steps = 100;
zsteps = 100;
zmax = 10;


function r_component(theta,zc) = 4 + 0.15*cos(7*theta) * cos(180*zc) + 1.5*sin(230 + zc / zmax * 270);
function xc(theta, zc) = r_component(theta,zc) * cos(theta);
function yc(theta, zc) = r_component(theta,zc) * sin(theta);

pointlist = [ 
    for (zinc =[0:zsteps-1])
    for (inc = [0:steps-1]) 

        [
            xc(360*inc/steps, zmax * zinc / zsteps), 
            yc(360*inc/steps, zmax*zinc/zsteps), 
            zmax * zinc / zsteps
        ] 
    ];
    
function point_index(xy_index, z_index) = z_index * steps + xy_index;

indices_1 = [
    for(xy_index = [0:steps-1])
    for(z_index = [0:zsteps-1])
    [
        point_index(xy_index, z_index), 
        point_index(xy_index, z_index+1),
        point_index((xy_index+1) % steps, z_index) 
    ]
];
    
indices_2 = [
    for(xy_index = [0:steps-1])
    for(z_index = [0:zsteps-1])
    [
        point_index(xy_index, z_index+1), 
        point_index((xy_index+1) % steps, z_index+1),
        point_index((xy_index+1) % steps, z_index) 
    ]
    
];

function cat(L1, L2) = [for (i=[0:len(L1)+len(L2)-1]) 
                        i < len(L1)? L1[i] : L2[i-len(L1)]] ;

top_face = [for(xy_index = [0:steps-1]) point_index(xy_index, zsteps-1)];
bottom_face = [for(xy_index = [0:steps-1]) point_index(steps-xy_index-1, 0)];
 
faces = cat(cat(cat([top_face], indices_1), indices_2), [bottom_face]);

//echo(faces);

resize([6*in, 6*in, 6*in])
polyhedron(pointlist, faces);

