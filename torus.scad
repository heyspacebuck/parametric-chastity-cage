include <handyfunctions.scad>;

module torus(R, r, phi=360, rounded=false, center=false) {
  offset = center ? -phi/2 : 0;
  if (version_num() > 20151231) {
    rz(offset) union() {
      rotate_extrude(convexity=4, angle=phi) {
        difference() {
          dx(R) circle(r);
          projection() mx() yz();
        }
      }
      if (rounded) {
        dx(R) sphere(r);
        rz(phi) dx(R) sphere(r);
      }
    }
  } else {
    echo("Using a deprecated method for torus(); consider updating to OpenSCAD 2016 or newer");
    if (phi <= 180) {
      rz(offset) difference() {
        rotate_extrude(convexity=4) {
          dx(R) circle(r);
        }
        dy(-R-r) cube([3*R+3*r,2*(R+r),3*r], center=true);
        rz(phi-180) dy(-R-r) cube([3*R+3*r,2*(R+r),3*r], center=true);
      }
    } else if (phi <= 360 ) {
      rotate_extrude(convexity=4) {
        dx(R) circle(r);
      }
    } else if (phi < 360) {
      rz(offset) rz(180)
      difference() {
        torus(R,r,360);// full torus
        torus(R,r,360-phi);//partial torus
      }
    }
  }
}