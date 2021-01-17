function dot(u, v) = u.x*v.x + u.y*v.y + u.z*v.z;

function dx(v, n) = [n, 0, 0] + v;

function dy(v, n) = [0, n, 0] + v;

function dz(v, n) = [0, 0, n] + v;

function mx(v) = [-v.x, v.y, v.z];

function my(v) = [v.x, -v.y, v.z];

function mz(v) = [v.x, v.y, -v.z];

function rx(v, n) = (
  [[1, 0, 0], [0, cos(n), -sin(n)], [0, sin(n), cos(n)]]*v
);

function ry(v, n) = (
  [[cos(n), 0, sin(n)], [0, 1, 0], [-sin(n), 0, cos(n)]]*v
);

function rz(v, n) = (
  [[cos(n), -sin(n), 0], [sin(n), cos(n), 0], [0, 0, 1]]*v
);

function sx(v, n) = [n*v.x, v.y, v.z];

function sy(v, n) = [v.x, n*v.y, v.z];

function sz(v, n) = [v.x, v.y, n*v.z];

function skewxy(v, n) = [[1, n, 0], [0, 1, 0], [0, 0, 1]]*v;

function skewxz(v, n) = [[1, 0, n], [0, 1, 0], [0, 0, 1]]*v;

function skewyx(v, n) = [[1, 0, 0], [n, 1, 0], [0, 0, 1]]*v;

function skewyz(v, n) = [[1, 0, 0], [0, 1, n], [0, 0, 1]]*v;

function skewzx(v, n) = [[1, 0, 0], [0, 1, 0], [n, 0, 1]]*v;

function skewzy(v, n) = [[1, 0, 0], [0, 1, 0], [0, n, 1]]*v;