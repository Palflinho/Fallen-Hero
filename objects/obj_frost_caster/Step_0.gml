event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "cast") ? c_purple : c_blue;

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

var _player = instance_find(obj_player, 0);
var _player_visible = (_player != noone && !_player.invisible);
var _dist = _player_visible ? point_distance(x, y, _player.x, _player.y) : infinity;

switch (state) {
    case "idle":
        if (_dist <= aggro_range) state = "chase";
        break;

    case "chase":
        if (_dist > aggro_range * 1.4) {
            state = "idle";
        } else if (attack_cooldown_timer <= 0) {
            state = "cast";
            cast_target_x = _player.x;
            cast_target_y = _player.y;
            cast_timer = telegraph_time;
        } else if (_dist > preferred_range) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
        }
        break;

    case "cast":
        cast_timer -= _dt;
        if (cast_timer <= 0) {
            if (_player_visible && point_distance(cast_target_x, cast_target_y, _player.x, _player.y) <= aoe_radius) {
                player_take_damage(aoe_damage);
            }
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
        }
        break;
}
