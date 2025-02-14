include <BOSL2/std.scad>
include <BOSL2/gears.scad>


module 18x18x18(iDown=0, iFwd=0){
    %down(iDown) fwd(iFwd) cube(size=457.2,  anchor=FRONT+BOTTOM);
}

module cubic_barbell(s=100, anchor=CENTER, spin=0, orient=UP) {
    attachable(anchor,spin,orient, size=[s*3,s,s]) {
        union() {
            xcopies(2*s) cube(s, center=true);
            xcyl(h=2*s, d=s/4);
        }
        children();
    }
}

//modules
module onebyoneR(){
	ext_height = 3;
	onebyoneR_points = [[4.08,-6.359],[6.359, -4.08],[6.539,4.08],[4.08,6.539],[-4.08,6.539],[-6.539,4.08],[-6.539,-4.08],[-4.08,-6.539]];
	translate([6.36, 6.36,1.5]){
		difference() {
			linear_extrude(height = ext_height, center = true, convexity = 10, twist = 0){
				polygon(onebyoneR_points);
			}
				cube([4.574, 4.574, ext_height+ 1], center = true);
		}
	}
}

module onebyoneRSide(){
	translate([0, 12.72, 0]){
		rotate([0, 0, -90]){
			translate([0, 3, 0]) onebyoneR();
			translate ([10.439, 0, 0,]) rotate([0,0,90]) cube([3, 8.16, 3]);
			translate ([0, 3, 3]) rotate([90, 0, 0]) onebyoneR();
		}
	}
}

module onebyoneR_fill(length = 1, width = 1){
	for (i=[0:1:length - 1]){
		translate([0, i * 12.72, 0,]) onebyoneR();
		for (a=[0:1:width - 1]){
			translate([a*12.72,i * 12.72, 0]) onebyoneR();
		//echo("Finished one bottom loop");
		}
		//echo("finished one top loop");
	}
}
module onebyoneRSide_fill(length = 1, height = 1){
	for (i=[0:1:length - 1]){
		translate([0, i * 12.72, 0,]) onebyoneRSide();
	}
	translate([3, 0, 3]) rotate([0, -90, 0]) onebyoneR_fill(length = length, width = height);	
}

module 1x1x35_Angle(anchor=BACK+RIGHT+BOTTOM, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=holes(1,35,1)) {
        color("slategray") union(){
            fwd(hole(12.5)) onebyoneRSide_fill(35, 1);
        }
        children();
    }
}

//1x1x35_Angle();

// FIXME there is an extra row of holes in the middle
module 1x2x1x25_C_Channel(anchor=BACK+RIGHT+BOTTOM, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=holes(1,25,2)) {
        color("slategray") union(){
            fwd(hole(12.5)) onebyoneRSide_fill(25, 1);
            fwd(hole(12.5)) right(hole(2)) xflip() onebyoneRSide_fill(25, 1);}
        children();
    }
}


module test1(anchor=BACK+LEFT+BOTTOM, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=holes(2,25,1)) {
        color("green")
        translate(holes2(-1,12.5,-1, 0, 0, 2)) union(){
            #cube(holes2(2,25,1, 0, 0, 1));
            onebyoneRSide_fill(25, 1);
             right(hole(2)) xflip() onebyoneRSide_fill(25, 1);}
        children();
    }
}

test1();

//1x2x1x25_C_Channel();

module 1x1x1x25_C_Channel(anchor=BACK+RIGHT, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=holes(1,25,1)) {
        color("slategray") union(){
            yrot(90) cylinder(h=20, r=60);
            fwd(hole(12.5)) onebyoneRSide_fill(25, 1);
            fwd(hole(12.5)) right(hole(1)) xflip() onebyoneRSide_fill(25, 0);
        }
        children();
    }
}
//1x1x1x25_C_Channel();

module wheel(anchor=LEFT, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[20,120,120]) {
        union(){
            yrot(90) color("green") cylinder(h=20, r=60);
            color("gray")
            yrot(90) cylinder(h=20, r=50);
        }
        children();
    }
}


module gear36(anchor=LEFT, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[4,90,90]) {
        color("green") union(){
            yrot(90) spur_gear(4, 36, 5, 4);
        }
        children();
    }
}

//gear36();

module spacer(anchor=LEFT, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[5,5,5]) {
        color("white") union(){
            yrot(90) cylinder(h=5, r=5);
        }
        children();
    }
}
//spacer();

function hole(n)
    =12.72*n;

function holes(x,y,z)
    =[x*12.72, y*12.72, z*12.72];

function edge(x,y,z)
    =[x*1.5, y*1.5, z*1.5];

function holes2(x,y,z,a,b,c)
    =[(x*12.72)+(a*3), (y*12.72)+(b*3), (z*12.72+c*3)];


echo(holes2(1,1,1,0,0,0));