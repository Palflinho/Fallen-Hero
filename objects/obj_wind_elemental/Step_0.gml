event_inherited();

var _dt = delta_time / 1000000;
anim_rot += 240 * _dt;

body_colour = (state == "windup") ? c_white : make_colour_rgb(180, 245, 255);
