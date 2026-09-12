if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
rot_angle += 360 * _dt;

// Movimento e repulsão nas paredes
x += vx * _dt;
y += vy * _dt;

if (place_meeting(x + vx * _dt, y, obj_wall)) vx = -vx;
if (place_meeting(x, y + vy * _dt, obj_wall)) vy = -vy;

// Dano e repulsão no jogador
if (tick_timer > 0) tick_timer -= _dt;

var _player = instance_find(obj_player, 0);
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= radius + _player.body_radius) {
    if (tick_timer <= 0) {
        tick_timer = tick_interval;
        player_take_damage(damage, "physical");
        var _push_dir = point_direction(x, y, _player.x, _player.y);
        _player.vx += lengthdir_x(200, _push_dir);
        _player.vy += lengthdir_y(200, _push_dir);
        fx_spawn_sparks(_player.x, _player.y, make_colour_rgb(210, 245, 255), 8);
    }
}
