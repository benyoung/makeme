hpitch = 12.75;
vpitch = 12.5;
thk = 0.1;
llkeypos = [6,9,0];
cols = 4;
//cols = 3;
width = (cols == 3 ) ? 46 : 58;
projection(cut=false) {
difference( ){
    cube([width,63,thk]);
    for( ix=[0:1:cols-1] ) {
      for( iy=[0:1:3] ){
 //   translate(llkeypos)cube([8.5,7,thk]);
        translate(llkeypos+[ix*hpitch,iy*vpitch,0])cube([8.5,7,thk]);
      };
  };
};

};
