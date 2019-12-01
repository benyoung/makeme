hpitch = 12.75;
vpitch = 12.5;
//thk = 0.1;
llkeypos = [6,9,0];
cols = 4;
//cols = 3;
width = (cols == 3 ) ? 46 : 58;
//projection(cut=false) {


keylab = [
     ["_[\x22", "ghi", "mno", "abc"],
     ["0./", "vwx", "mno", "def"],
     ["ENT", "yz]", "pqr", "ghi"],
     ["-->", "<--", "-.\x5c", "SHFT"]
    ];
//keylab = [
//     ["CLR", " ", " ", " "],
//     [" ", " ", " ", " "],
//     [".", " ", " ", " "],
//     ["=", "*", "-", "+"]
//    ];
//keylab = [
//     ["CLR", "C", "B", "A"],
//     ["0", "F", "E", "D"],
//     [" ", "SQRT", "MOD", "/"],
//     ["=", "*", "-", "+"]
//    ];

difference( ){
    square([width,63],0);
    for( ix=[0:1:cols-1] ) {
      for( iy=[0:1:3] ){
 //   translate(llkeypos)cube([8.5,7,thk]);
        translate(llkeypos+[ix*hpitch,iy*vpitch,0])square([8.5,7],0);
        translate(llkeypos+[ix*hpitch+4.25,iy*vpitch+8,0])text(keylab[ix][iy],font="Source Code Pro:style=Regular",size=3.5,halign="center");
      };
  };
};

//};
