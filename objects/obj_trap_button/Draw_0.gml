var _player = instance_find(obj_player, 0);
if (_player == noone) exit;
if (point_distance(x, y, _player.x, _player.y) > reveal_radius) exit;

draw_set_alpha(0.7);
draw_set_color(c_dkgray);
draw_rectangle(x - 10, y - 10, x + 10, y + 10, false);
draw_set_color(triggered ? c_lime : c_white);
draw_rectangle(x - 10, y - 10, x + 10, y + 10, true);
draw_set_alpha(1);
