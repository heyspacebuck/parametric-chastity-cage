module dx(n) {
  translate([n, 0, 0]) children();
}

module dy(n) {
  translate([0, n, 0]) children();
}

module dz(n) {
  translate([0, 0, n]) children();
}

module mx() {
  mirror([1, 0, 0]) children();
}

module my() {
  mirror([0, 1, 0]) children();
}

module mz() {
  mirror([0, 0, 1]) children();
}

module rx(n) {
  rotate([n, 0, 0]) children();
}

module ry(n) {
  rotate([0, n, 0]) children();
}

module rz(n) {
  rotate([0, 0, n]) children();
}

module sx(n) {
  scale([n, 1, 1]) children();
}

module sy(n) {
  scale([1, n, 1]) children();
}

module sz(n) {
  scale([1, 1, n]) children();
}

module skewxy(n) {
  multmatrix(m = [[1, n, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0]]) children();
}

module skewxz(n) {
  multmatrix(m = [[1, 0, n, 0], [0, 1, 0, 0], [0, 0, 1, 0]]) children();
}

module skewyx(n) {
  multmatrix(m = [[1, 0, 0, 0], [n, 1, 0, 0], [0, 0, 1, 0]]) children();
}

module skewyz(n) {
  multmatrix(m = [[1, 0, 0, 0], [0, 1, n, 0], [0, 0, 1, 0]]) children();
}

module skewzx(n) {
  multmatrix(m = [[1, 0, 0, 0], [0, 1, 0, 0], [n, 0, 1, 0]]) children();
}

module skewzy(n) {
  multmatrix(m = [[1, 0, 0, 0], [0, 1, 0, 0], [0, n, 1, 0]]) children();
}

module xy() {
  dz(1e3) cube(center=true, 2e3);
}

module xz() {
  dy(1e3) cube(center=true, 2e3);
}

module yz() {
  dx(1e3) cube(center=true, 2e3);
}