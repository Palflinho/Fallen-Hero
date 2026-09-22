event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "windup") ? c_orange : c_lime;

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
            if (_dist <= attack_range) facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            lost_sight_timer += _dt;
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }

        var _eff_atk_range = attack_range + (variable_instance_exists(id, "is_enraged") && is_enraged ? 24 : 0);
        if (_dist <= _eff_atk_range && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            if (attack_cooldown_timer <= 0) {
                state = "windup";
                attack_windup_timer = attack_windup * (variable_instance_exists(id, "is_enraged") && is_enraged ? 0.70 : 1.0);
            }
        } else if (_player != noone) {
            var _dir = point_direction(x, y, _player.x, _player.y) + adaptive_ai_get_flank_offset(_player);

            // Taticas de Bando: Guarda-Costas interpondo-se na frente de Casters
            var _caster = instance_nearest(x, y, obj_frost_caster);
            if (_caster == noone) _caster = instance_nearest(x, y, obj_magma_caster);
            if (_caster != noone && point_distance(x, y, _caster.x, _caster.y) < 220) {
                var _mid_x = (_caster.x + _player.x) * 0.5;
                var _mid_y = (_caster.y + _player.y) * 0.5;
                if (point_distance(x, y, _mid_x, _mid_y) > 30) {
                    _dir = point_direction(x, y, _mid_x, _mid_y);
                }
            }

            ai_enemy_move(_dir, move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        // Sakurai Polish: Squash coiling before leap
        scale_x = 1.35;
        scale_y = 0.65;
        if (attack_windup_timer <= 0) {
            var _hit = instance_create_layer(x, y, layer, obj_enemy_melee_hit);
            _hit.owner = id;
            _hit.damage = contact_damage;
            _hit.damage_type = "physical";
            _hit.body_radius = attack_range + 6;
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            // Stretch forward on attack leap
            scale_x = 0.8;
            scale_y = 1.3;
        }
        break;
}

ai_update_sprite_animation();
