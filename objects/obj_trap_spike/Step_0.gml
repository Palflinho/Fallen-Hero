var _dt = delta_time / 1000000;
var _w = base_size * image_xscale;
var _h = base_size * image_yscale;

var _player = instance_find(obj_player, 0);
var _player_on = false;
if (_player != noone) {
    var _cx = clamp(_player.x, x, x + _w);
    var _cy = clamp(_player.y, y, y + _h);
    _player_on = (point_distance(_player.x, _player.y, _cx, _cy) < _player.body_radius);
}

switch (state) {
    case "hidden":
        if (_player_on) {
            state = "delay";
            delay_timer = delay_time;
        }
        break;

    case "delay":
        delay_timer -= _dt;
        if (delay_timer <= 0) {
            state = "erupt";
            erupt_timer = erupt_time;
            has_hit = false;
        }
        break;

    case "erupt":
        erupt_timer -= _dt;
        if (!has_hit && _player_on) {
            player_take_damage(damage);
            has_hit = true;
        }
        if (erupt_timer <= 0) {
            state = "cooldown";
            cooldown_timer = cooldown_time;
        }
        break;

    case "cooldown":
        cooldown_timer -= _dt;
        if (cooldown_timer <= 0) {
            state = "hidden";
        }
        break;
}
