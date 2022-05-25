////////////////////////////////////
//
// Parametric chastity cage, modified from this one: https://www.thingiverse.com/thing:2764421/
// Version 3, published August 2018

// V4 update: February 2019
//    - Added option to bend the base ring, for comfort
//    - Updated variables for Thingiverse Customizer

// V5 update: June 2019
//    - Rewrote as many functions as possible

// V6 update: January 2021
//    - Another major overhaul

//////////////////////////////////////

// Use abbreviations for translate() and rotate() operations
use <handyfunctions.scad>

// Use separate module for stealth lock shape
use <stealth_lock.scad>

// Use separate module for torus functions
use <torus.scad>

// Use separate module for computing points along the cage path
use <vec3math.scad>

// Render cage and ring separately
separateParts = 1; // [0: Together, 1: Separate]

// Cage diameter
cage_diameter=35; // [30:40]

// Length of cage from base ring to cage tip
penis_length=90; // [30:200]

// Base ring diameter
base_ring_diameter=45; // [30:55]

// Thickness of base ring 
base_ring_thickness=6; // [6:10]

// Add a "wave" to the base ring (contours to the body a little better)
wavyBase = 1; // [0: Flat, 1: Wavy]

// If the base ring has a wave, set the angle of the wave
waveAngle = 12; // [0:45]

// Gap between the bottom of the cage and the base ring
gap=10; // [10:20]

// Thickness of the rings of the cage
cage_bar_thickness=4; // [4:8]

// Number of vertical bars on the cage
cage_bar_count=8;

// Width of the slit at the front opening
slit_width=12; // [0:40]

// Tilt angle of the cage at the base ring
tilt=15; // [0:30]

// If your lock fits too tightly in the casing, add some space around it here
lock_margin = 0.1; // [0:0.01:1]

// If the two parts slide too stiffly, add some space here
part_margin = 0.4; // [0:0.01:1]

// X-axis coordinate of the bend point (the center of the arc the cage bends around)
bend_point_x=50; // [0:0.1:200]

// Z-axis coordinate of the bend point (the center of the arc the cage bends around)
bend_point_z=15; // [0:0.1:200]

/* [Hidden] */

// Glans cage height (minimum is cage radius)
glans_cage_height=cage_diameter/2; // [15:50]

// Variables affecting the lock case
lock_case_upper_radius = 9;
lock_case_lower_radius = 4;
base_lock_bridge_width = 11;
mount_width=5;
mount_height=18;
mount_length=24;

// Radius of rounded edges
rounding=.99;

// Square function for math
function sq(x) = pow(x, 2);


////////////////////////////////////
//
// Useful values calculated from parameters above
//

// Thickness of base ring of cage
cage_ring_thickness = 1.2*cage_bar_thickness;

// step: angle between cage bars
step = 360/cage_bar_count;

// R1: Inner radius of shaft of cage
// R2: Inner radius of base ring
R1 = cage_diameter/2;
R2 = base_ring_diameter/2;

// r1: cage bar radius
// r2: base ring radius
// r3: cage ring radius
r1 = cage_bar_thickness/2;
r2 = base_ring_thickness/2;
r3 = cage_ring_thickness/2;

// Length of cage
cage_length = max(penis_length-gap, glans_cage_height+(R1+r1)*sin(tilt));

// Vertical placement of lock hole
lock_vertical = mount_height/2+1.5;
// Horizontal placement of lock hole
lock_lateral = 5.6;

// P: bend point (assumed to be on the XZ plane)
// dP: distance from origin to bend point
P = [bend_point_x, 0, bend_point_z];
dP = norm(P);

// psi: angle from origin to bend point (in degrees)
psi = atan(P.z/P.x);

// dQ: length of straight cage segment
dQ = min(dP*cos(90-tilt-psi), cage_length-glans_cage_height);

// Q: upper endpoint of straight segment of cage
Q = [dQ*sin(tilt), 0, dQ*cos(tilt)];

// Phi: arc length of curved segment of cage (in degrees)
curve_radius = norm(P-Q);
Phi = (cage_length - dQ - glans_cage_height)/curve_radius * 180/PI;

// R: endpoint of curved segment of cage
R = ry(Q-P, Phi) + P;

//slit_width = (R1+r1)*cos(step);

////////////////////////////////////
//
// Finally, here's where the modules begin
//
$fn=32;
make();

module make() {
  dx(40) dz(R1+cage_ring_thickness) rx(-90) difference() {
    cageA();
    translate(R) ry(Phi+tilt) dx(-R1-r1) {
      rx(-90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
    }
    dx(R1+r1) {
      rx(-90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
    }
  }
  dx(-40) dz(R1+cage_ring_thickness) rx(-90) difference() {
    cageB();
    rz(180) translate(R) ry(Phi+tilt) dx(R1+r1) {
      rx(90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
    }
    rz(180) dx(-R1-r1*1.5) {
      ry(tilt) {
        dz(r1) rx(90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
        dz(r1+10) rx(90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
      }
    }
  }
  dx(20) dy(-40) make_base();
}

module cageA() {
  
  intersection() {
    cage();
    xz();
  }
  translate(R) ry(Phi+tilt) dx(R1+r1) {
    intersection() {
      rx(90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
      rx(90) cylinder(h=r1*4, r=r1);
    }
  }
  dx(-R1-r1*1.5) {
    ry(tilt) {
      dz(r1) rx(90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
      dz(r1+10) rx(90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
    }
  }
}

module cageB() {
  intersection() {
    rz(180) cage();
    xz();
  }
  rz(180) translate(R) ry(Phi+tilt) dx(-R1-r1) {
    intersection() {
      rx(-90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
      rx(-90) cylinder(h=r1*4, r=r1);
    }
  }
  dx(-R1-r1) {
    intersection() {
      rx(90) cylinder(r1=r1*.75, r2=r1*.5,h=3);
      rx(90) cylinder(r=r1*1.2, h=r1*4);
    }
  }
}

module make_base() {
  baseOrigin = separateParts ? [-base_ring_diameter-cage_diameter, 0, gap] : [0, 0, 0];
  translate(baseOrigin) {
    base_ring();
    lock_dovetail_outer();
  }
}

// Generate a cylinder with rounded edges
module rounded_cylinder(r,h,n, center=false) {
  zshift = center ? -h/2 : 0;
  dz(zshift) rotate_extrude(convexity=1) {
    offset(r=n) offset(delta=-n) square([r,h]);
    square([n,h]);
  }
}

// Generate a cube with rounded edges
module rounded_cube(size, radius, center=false) {
  offset = center ? [0, 0, 0] : [radius, radius, radius];
	translate(offset) minkowski() {
		cube(size = [
			size[0] - (radius * 2),
			size[1] - (radius * 2),
			size[2] - (radius * 2)
		], center=center);
		sphere(r = radius);
	}
}

module cage() {
  cage_bar_segments(); // The bars
  glans_cap(); // The cap
  torus(R1+r1, r3);  // Cage base ring
  cage_lock(); // The part where the lock goes
}

module cage_bar_segments() {
  for (theta = [step/2:step:360-step/2]) {
    // Straight segment begins at a point along the base ring, and ends at a point a distance R1 from point Q
    straightSegStart = rz([R1+r1, 0, 0], theta);
    straightSegEnd = Q + ry(straightSegStart, tilt);
    curveSegEnd = ry(straightSegEnd-P, Phi)+P;
    
    // make a cylinder between straightSegStart and straightSegEnd
    segAngle = 90-atan2(straightSegEnd.z - straightSegStart.z, straightSegEnd.x - straightSegStart.x);
    segLength = norm(straightSegEnd - straightSegStart);
    translate(straightSegStart) ry(segAngle) cylinder(r=r1, h=segLength);
    
    // Make a torus between straightSegEnd and curveSegEnd, if necessary
    if (Phi>0) {
      // First, find the angle between the ends of the curve
      vec1 = [straightSegEnd.x, 0, straightSegEnd.z]-P;
      vec2 = [curveSegEnd.x, 0, curveSegEnd.z]-P;
      curveAngle = acos(dot(vec1, vec2)/(norm(vec1)*norm(vec2)));
      curveRad = norm(vec1);
      translate(straightSegEnd) ry(-180+tilt) dx(-curveRad) rx(90) torus(curveRad, r1, -curveAngle, rounded=true);
    }
  }
}

module glans_cap() {
  // First, ensure the slit width is within the bounds of the cage geometry
  real_slit_width = max(min(slit_width, cage_diameter), 0.1);
  translate(R) ry(Phi+tilt) {
    // Ring around base of glans cap
    torus(R1+r1, r1);
    // Calculate the start and end points of the bars that create the front slit
    slitRadius = (R1+r1)*cos(asin(real_slit_width/2/(R1+r1)));
    slitStart = [slitRadius, -real_slit_width/2, 0];
    slitEnd = mx(slitStart);
    
    // Draw slit bars
    dy(-real_slit_width/2) rx(90) torus(slitRadius, r1, 180);
    dy(real_slit_width/2) rx(90) torus(slitRadius, r1, 180);
    
    // Draw each cage bar (minus the part that would enter the slit area)
    for (theta = [step/2:step:180-step/2]) {
      // Do not calculate/draw the bar if the bar begins within the slit area
      if ((R1+r1)*sin(theta) > real_slit_width/2) {
        // Compute arc length of this side bar
        distanceInSlit = (real_slit_width/2)/sin(theta);
        arcLength = acos(distanceInSlit/(R1+r1));
        rz(theta) rx(90) torus(R1+r1, r1, arcLength);
        rz(180+theta) rx(90) torus(R1+r1, r1, arcLength);
      }
    }
  }
}

module cage_lock() {
  // Create the solid arc that interfaces with the mating parts
  mount_arc();
  // Create the flat plane on which the mating parts slide
  mount_flat();
  // Create the cage's piece of the lock
  lock_dovetail_inner();
}

module lock_dovetail_inner() {
  inner_dovetail_length = mount_length/3 - part_margin;
  difference() {
    union() {
      intersection() {
        dy(-9-part_margin) skewyx(-0.4) lock_case_shape(inner_dovetail_length+3.5);
        xz();
      }
      difference() {
        dy(9+part_margin) skewyx(0.4)  lock_case_shape(inner_dovetail_length+3.5);
        xz();
      }
    }
    // Ensure the lock body does not enter the cage itself
    dz(-r3) skewxz(tan(tilt)) cylinder(r=R1+r3, h=100, center=true);
    // Cut a cavity for the lock module
    dx(-R1-r3-mount_width/2-lock_lateral) ry(tilt) dz(lock_vertical) dy(18-mount_length/2) {
      stealth_lock(lock_margin);
      rx(-90) cylinder(r=3.1+lock_margin, h=mount_length-19);
    }
  }
}

module lock_dovetail_outer() {
  intersection () {
    difference() {
      union() {
        dy(mount_length/3) lock_case_shape(mount_length/3, outer=true);
        my() dy(mount_length/3) lock_case_shape(mount_length/3, outer=true);
      }
      // Cut a cavity for the lock module
      sy(1.01) dx(-R1-r3-mount_width/2-lock_lateral) ry(tilt) dz(lock_vertical) dy(18-mount_length/2) {
        stealth_lock(lock_margin);
        rx(-90) cylinder(r=3.1+lock_margin, h=mount_length-10, center=true);
      }
    }
    union() {
       dy(7.3) dz(-r3) skewyx(.4) skewxz(tan(tilt)) dz(-r3) mx() dx(R1+r3+mount_width/2 + part_margin) dy(-mount_length/2 - part_margin) rounded_cube([50, mount_length/3, mount_height*cos(tilt)+2*r3], rounding);
      my() dy(7.3) dz(-r3) skewyx(.4)  skewxz(tan(tilt)) dz(-r3) mx() dx(R1+r3+mount_width/2 + part_margin) dy(-mount_length/2 - part_margin) rounded_cube([50, mount_length/3, mount_height*cos(tilt)+2*r3], rounding);
    }
  }
  // Add a connecting block between the lock part and the base ring:
  hull() {
    dz(-2*r3) dy(-mount_length/2) mx() dx(R1+2*r3*sin(tilt)+part_margin) rounded_cube([base_lock_bridge_width, mount_length, r3-part_margin], (r3-part_margin)/2.01);
    dz(-gap) dx(-R1-r3-gap*sin(tilt)) rx(90) cylinder(r=r3/2, h=mount_length, center=true);
    dx(R2+2*r2-R1-r3-r2-gap*sin(tilt)) dz(-gap) rz(165) torus(R2+2*r2, r3/2, 30);
  }
}

// A hull of four rounded cylinders to create the main lock body. It extends down a bit more for the outer lock piece
module lock_case_shape(length, outer=false) {
  extra = outer ? r3 : 0;
  
  hull() {
    dx(-R1-r3-mount_width/2-lock_case_upper_radius+lock_case_lower_radius) dz(lock_case_lower_radius-r3-extra) rx(90) rounded_cylinder(lock_case_lower_radius, length, rounding, center=true);
    dx(-R1-r3-mount_width/2) dz(mount_height*cos(tilt) - lock_case_upper_radius) rx(90) rounded_cylinder(lock_case_upper_radius, length, rounding, center=true);
    dz(lock_case_lower_radius-r3-extra) rx(90) rounded_cylinder(lock_case_lower_radius, length, rounding, center=true);
    dz(mount_height*cos(tilt)-lock_case_lower_radius) rx(90) rounded_cylinder(lock_case_lower_radius, length, rounding, center=true);
  }
}

module mount_arc(arcLength=60) {
  skewxz(tan(tilt)) {
    rz(180-arcLength/2) {
      rotate_extrude(angle=arcLength) {
        dx(R1) offset(r=rounding) offset(delta=-rounding) square([cage_bar_thickness, mount_height*cos(tilt)]);
      }
      // Put smooth caps on the sides of the mount arc
      dx(R1+r1) rounded_cylinder(r1, mount_height*cos(tilt), rounding);
      rz(arcLength) dx(R1+r1) rounded_cylinder(r1, mount_height*cos(tilt), rounding);
    }
  }
}

module mount_flat() {
  dz(-r3) skewxz(tan(tilt)) difference() {
    translate([-R1-r3-mount_width/2, -mount_length/2, 0]) rounded_cube([mount_width, mount_length, mount_height*cos(tilt)+r3], rounding);
    cylinder(r=R1+r3, h=100);
  }
}

module base_ring() {
  if (wavyBase) {
    dz(-gap) dx(R2+r2-R1-r1-gap*tan(tilt)) wavy_torus(R2+r2, r2, waveAngle);
  } else {
    dz(-gap) dx(R2+r2-R1-r1-gap*tan(tilt)) torus(R2+r2, r2);
  }
}

module wavy_torus(R, r, pitch) {
  union() {
    translate([-sin(-45)*R*(1-cos(pitch)), 0, -R*sin(-45)*sin(pitch)]) ry(pitch) rz(-45) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
    translate([0, sin(45)*R*(1-cos(pitch)), -R*sin(45)*sin(pitch)]) rx(pitch) rz(45) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
    translate([-sin(135)*R*(1-cos(pitch)), 0, -R*sin(135)*sin(-pitch)]) ry(-pitch) rz(135) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
    translate([0, sin(-135)*R*(1-cos(pitch)), -R*sin(-135)*sin(-pitch)]) rx(-pitch) rz(-135) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
  }
}