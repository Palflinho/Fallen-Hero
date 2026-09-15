event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "cast") ? c_yellow : c_maroon;

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
            if (attack_cooldown_timer <= 0) facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            lost_sight_timer += _dt;
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }

        if (attack_cooldown_timer <= 0) {
            state = "cast";
            cast_target_x = _player.x;
            cast_target_y = _player.y;
            cast_timer = telegraph_time;
        } else if (_player != noone && _dist > preferred_range) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            ai_enemy_move(_dir, move_speed_effective, _dt);
        }
        break;

    case "cast":
        cast_timer -= _dt;
        // Sakurai Polish: Levitating magical channeling
        scale_y = 1.25;
        scale_x = 0.85;
        if (cast_timer <= 0) {
            if (_player != noone && !_player.invisible && point_distance(cast_target_x, cast_target_y, _player.x, _player.y) <= aoe_radius) {
                player_take_damage(aoe_damage, "magical");
                player_apply_poison(burn_damage, burn_tick_interval, burn_duration);
            }
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            // Detonation impact squash and sparks
            scale_y = 0.85;
            scale_x = 1.15;
            fx_spawn_sparks(cast_target_x, cast_target_y, c_orange, 12);
        }
        break;
}
