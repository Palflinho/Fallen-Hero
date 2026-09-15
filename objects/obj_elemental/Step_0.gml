event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "windup") ? c_yellow : c_aqua;

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

var _player = instance_find(obj_player, 0);
var _seen = ai_can_see_player(vision_range, vision_angle);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

switch (state) {
    case "patrol":
        ai_patrol(_dt);
        if (_seen != noone) {
            state = "chase";
            lost_sight_timer = 0;
        }
        break;

    case "chase":
        if (_player != noone && _player.invisible) {
            state = "patrol";
            break;
        }
        if (_seen != noone) {
            lost_sight_timer = 0;
            if (_dist <= attack_range && attack_cooldown_timer <= 0) facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            lost_sight_timer += _dt;
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }

        if (_dist <= attack_range && attack_cooldown_timer <= 0) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (_player != noone && _dist < preferred_range - 20) {
            var _dir = point_direction(x, y, _player.x, _player.y) + 180;
            ai_enemy_move(_dir, move_speed_effective, _dt);
        } else if (_player != noone && _dist > preferred_range + 20) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            ai_enemy_move(_dir, move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        // Sakurai Polish: Pulsating magical charge
        scale_x = 1.25 + 0.05 * sin(current_time * 0.03);
        scale_y = 1.25 + 0.05 * sin(current_time * 0.03);
        if (attack_windup_timer <= 0) {
            if (_player != noone && !_player.invisible) {
                var _pdir = point_direction(x, y, _player.x, _player.y);
                var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _p.owner = id;
                _p.damage = projectile_damage;
                _p.dir_x = lengthdir_x(1, _pdir);
                _p.dir_y = lengthdir_y(1, _pdir);
                _p.speed_px = projectile_speed;
                _p.colour = c_aqua;
                _p.damage_type = "magical";
            }
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            // Recoil & spark burst on projectile launch
            scale_x = 0.8;
            scale_y = 0.8;
            fx_spawn_sparks(x, y, c_aqua, 5);
        }
        break;
}

ai_update_sprite_animation();
