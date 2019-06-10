// Parametric chastity cage - ring gauges

//////////////////////////////////////

$fn=36;
r = 2;

difference() {
  union() {
    for(R = [15:5:30]) {
      torus(R+r, r);
      translate([0, R+r]) linear_extrude(height=r+1) {
        text(text=str(R*2), size=4, valign="center", halign="center", font = "Liberation Sans:style=Bold");
      }
    }
    translate([80,0,0]) {
      for(R = [17.5:5:32.5]) {
        torus(R+r, r);
        translate([0, R+r]) linear_extrude(height=r+1) {
          text(text=str(R*2), size=4, valign="center", halign="center", font = "Liberation Sans:style=Bold");
        }
      }
    }
  }
  translate([0,0,-1.67]) cylinder(center=true, r=200, h=2);
}




//r=45;
//torus(22, 2);
//torus(27, 2);

module torus(R, r, phi=360, rounded=false) {
  if (version_num() > 20151231) {
    union() {
      rotate_extrude(convexity=4, angle=phi) {
        translate([R,0,0]) circle(r);
      }
      if (rounded) {
        translate([R,0,0]) sphere(r);
        rotate([0,0,phi]) translate([R,0,0]) sphere(r);
      }
    }
  } else {
    echo("Using a deprecated method for torus(); consider updating to OpenSCAD 2016 or newer");
    if (phi <= 180) {
      difference() {
        rotate_extrude(convexity=4) {
          translate([R,0,0]) circle(r);
        }
        translate([0,-(R+r),0])
          cube([3*R+3*r,2*(R+r),3*r], center=true);
        rotate([0, 0, phi - 180])
          translate([0,-(R+r),0])
            cube([3*R+3*r,2*(R+r),3*r], center=true);
      }
    } else if (phi <= 360 ) {
      rotate_extrude(convexity=4) {
        translate([R,0,0]) circle(r);
      }
    } else if (phi < 360) {
      rotate([0,0,180])
      difference() {
        torus(R,r,360);// full torus
        torus(R,r,360-phi);//partial torus
      }
    }
  }
}