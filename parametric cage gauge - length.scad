// Parametric chastity cage - length gauge

//////////////////////////////////////

$fn=36;
r = 2;
R = 20;


difference() {
  rotate([0,180,0]) {
    union() {
      measuring_rod();
      cylinder(r=r+1.2, h=2, center=true);
    }
  }
  translate([-2.67, 0, 0]) {
    rotate([0,90,0]) cylinder(r=10,h=3,center=true);
  }
  cylinder(r=r+0.2, h=3, center=true);
}

module measuring_rod() {
  rotate([0,-90,0]) translate([-1,-2,0]) {
    cube([2,4,122]);
    for (dist = [0:10:100]) {
      translate([0,2,16+dist]) { // LIFEHACK: Take out the "16+" if you want to function as a real ruler
        translate([1,-1.7,0]) rotate([45,0, 0]) cube([2,2,2], center=true);
        rotate([90,-90,-90])
        linear_extrude(height=0.5) {
          text(text=str(dist), size=4, valign="center", halign="center", font = "Liberation Sans:style=Bold");
        }
      }
    }
  }
}