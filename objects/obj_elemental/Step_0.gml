event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "windup") ? c_yellow : c_aqua;

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
        } else if (_dist <= attack_range && attack_cooldown_timer <= 0) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (_dist < preferred_range - 20) {
            var _dir = point_direction(x, y, _player.x, _player.y) + 180;
            fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
        } else if (_dist > preferred_range + 20) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        if (attack_windup_timer <= 0) {
            if (_player_visible) {
                var _pdir = point_direction(x, y, _player.x, _player.y);
                var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _p.owner = id;
                _p.damage = projectile_damage;
                _p.dir_x = lengthdir_x(1, _pdir);
                _p.dir_y = lengthdir_y(1, _pdir);
                _p.speed_px = projectile_speed;
                _p.colour = c_aqua;
            }
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
        }
        break;
}
