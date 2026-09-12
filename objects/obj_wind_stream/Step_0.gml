if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
anim_timer += _dt;

var _w = base_w * image_xscale;
var _h = base_h * image_yscale;

var _player = instance_find(obj_player, 0);
if (_player != noone) {
    if (_player.x >= x && _player.x <= x + _w && _player.y >= y && _player.y <= y + _h) {
        var _fx = lengthdir_x(force * _dt, dir);
        var _fy = lengthdir_y(force * _dt, dir);
        with (_player) {
            fh_move_and_collide(_fx, _fy);
        }

        if (random(1) < 0.15) {
            fx_spawn_sparks(_player.x, _player.y + 10, make_colour_rgb(200, 245, 255), 1);
        }
    }
}
