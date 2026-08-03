event_inherited();
var _dt = delta_time / 1000000;

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

if (shield_active_timer > 0) {
    shield_active_timer -= _dt;
    damage_reduction = 0.25;
    if (shield_active_timer <= 0) {
        damage_reduction = 1;
        shield_timer = shield_interval;
    }
} else {
    shield_timer -= _dt;
    if (shield_timer <= 0) {
        shield_active_timer = shield_duration;
    }
}

body_colour = (shield_active_timer > 0) ? c_white : ((state == "windup") ? c_orange : c_silver);

var _player = instance_find(obj_player, 0);
var _player_visible = (_player != noone && !_player.invisible);
var _dist = _player_visible ? point_distance(x, y, _player.x, _player.y) : infinity;

switch (state) {
    case "idle":
        if (_dist <= aggro_range) state = "chase";
        break;

    case "chase":
        if (_dist > aggro_range * 1.3) {
            state = "idle";
        } else if (_dist <= attack_range) {
            if (attack_cooldown_timer <= 0) {
                state = "windup";
                attack_windup_timer = attack_windup;
            }
        } else {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        if (attack_windup_timer <= 0) {
            var _hit = instance_create_layer(x, y, layer, obj_enemy_melee_hit);
            _hit.owner = id;
            _hit.damage = contact_damage;
            _hit.body_radius = attack_range + 6;
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
        }
        break;
}
