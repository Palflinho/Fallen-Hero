// Espirais rotativas de vento
draw_set_alpha(0.35 + 0.15 * sin(current_time / 70));
draw_set_color(make_colour_rgb(180, 240, 255));
draw_circle(x, y, radius, false);

draw_set_alpha(0.7);
draw_set_color(c_white);

for (var _a = 0; _a < 4; _a++) {
    var _ang = rot_angle + _a * 90;
    var _r = radius * 0.7;
    var _cx = x + lengthdir_x(_r, _ang);
    var _cy = y + lengthdir_y(_r, _ang);
    draw_circle(_cx, _cy, 4, false);
}

draw_set_color(make_colour_rgb(140, 225, 255));
draw_circle(x, y, radius, true);

draw_set_alpha(1);
draw_set_color(c_white);
