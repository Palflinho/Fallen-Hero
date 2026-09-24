// Orbe verde flutuante com uma cruz de cura
var _fy = y + sin(bob_t * 3) * 3;
var _pulse = 0.5 + 0.5 * sin(bob_t * 5);

draw_set_alpha(0.25 + 0.15 * _pulse);
draw_set_color(c_lime);
draw_circle(x, _fy, radius + 8, false);
draw_set_alpha(1);

draw_set_color(make_colour_rgb(30, 120, 60));
draw_circle(x, _fy, radius, false);
draw_set_color(make_colour_rgb(140, 255, 170));
draw_circle(x, _fy, radius, true);

draw_set_color(c_white);
draw_rectangle(x - 3, _fy - 11, x + 3, _fy + 11, false);
draw_rectangle(x - 11, _fy - 3, x + 11, _fy + 3, false);
