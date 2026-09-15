event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "windup") ? c_white : make_colour_rgb(180, 245, 255);

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
            ai_enemy_move(_dir, move_speed_effective, _dt);
            if (random(1) < 0.15) {
                fx_spawn_sparks(x, y + 6, c_white, 1);
            }
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
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
            scale_x = 0.8;
            scale_y = 1.3;
            fx_spawn_sparks(x, y, make_colour_rgb(200, 245, 255), 6);
        }
        break;
}

ai_update_sprite_animation();
