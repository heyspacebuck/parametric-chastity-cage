include <handyfunctions.scad>

module stealth_lock(slop=0) {
  union() {
    rx(90) cylinder(r=3.1+slop, h=19);
    dx(-1.6-slop) dy(-19) dz(-8.1-slop) cube([3.2+2*slop, 19, 8.1+slop]);
    ry(90) rx(90) rotate_extrude(angle=-75) {
      square([8.1+slop, 7+slop]);
    }
  }
}