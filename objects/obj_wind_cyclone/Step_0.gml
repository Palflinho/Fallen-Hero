if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
rot_angle += 480 * _dt;

var _min_x = 48 + radius;
var _max_x = room_width - 48 - radius;
var _min_y = 48 + radius;
var _max_y = room_height - 48 - radius;

var _next_x = x + vx * _dt;
var _next_y = y + vy * _dt;
var _bounced = false;

// Rebatimento no eixo X contra limites da câmara e paredes
if (_next_x <= _min_x) {
    x = _min_x;
    vx = abs(vx);
    _bounced = true;
} else if (_next_x >= _max_x) {
    x = _max_x;
    vx = -abs(vx);
    _bounced = true;
} else if (place_meeting(_next_x, y, obj_wall)) {
    vx = -vx;
    _bounced = true;
} else {
    x = _next_x;
}

// Rebatimento no eixo Y contra limites da câmara e paredes
if (_next_y <= _min_y) {
    y = _min_y;
    vy = abs(vy);
    _bounced = true;
} else if (_next_y >= _max_y) {
    y = _max_y;
    vy = -abs(vy);
    _bounced = true;
} else if (place_meeting(x, _next_y, obj_wall)) {
    vy = -vy;
    _bounced = true;
} else {
    y = _next_y;
}

if (_bounced) {
    fx_spawn_sparks(x, y, make_colour_rgb(180, 240, 255), 5);
}

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
