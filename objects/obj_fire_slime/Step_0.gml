event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "windup") ? c_yellow : c_orange;

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
        if (_seen != noone) {
            lost_sight_timer = 0;
            facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            lost_sight_timer += _dt;
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }

        if (_dist <= attack_range) {
            if (attack_cooldown_timer <= 0) {
                state = "windup";
                attack_windup_timer = attack_windup;
            }
        } else if (_player != noone) {
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
            _hit.damage_type = "physical";
            _hit.body_radius = attack_range + 6;
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
        }
        break;
}

ai_update_sprite_animation();
