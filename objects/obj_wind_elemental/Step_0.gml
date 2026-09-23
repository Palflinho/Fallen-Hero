// ---------------------------------------------------------------------
// ELEMENTAL DE VENTO
//  - Arremessa BUMERANGUES que vao e voltam (acertam na ida e na volta).
//  - Se o jogador chega perto, ele se TELEPORTA para longe...
//    ...mas fica 0.5s atordoado apos reaparecer: e a janela para puni-lo.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
anim_rot += 240 * _dt;
body_colour = (state == "windup") ? c_white : make_colour_rgb(180, 245, 255);

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;
if (blink_cooldown > 0) blink_cooldown -= _dt;
if (blink_fx_timer > 0) blink_fx_timer -= _dt;

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
        if (_player == noone) break;
        facing_dir = point_direction(x, y, _player.x, _player.y);

        if (_dist <= blink_trigger && blink_cooldown <= 0) {
            // Teleporte defensivo
            blink_from_x = x;
            blink_from_y = y;
            var _pt = elem_find_point_around(_player.x, _player.y, 170, 230, body_radius);
            fx_spawn_sparks(x, y, c_white, 12);
            x = _pt.x;
            y = _pt.y;
            fx_spawn_sparks(x, y, c_white, 12);
            sfx_play("wind_gust", 0.1, 0.6);
            blink_cooldown = 3.5;
            blink_fx_timer = 0.3;
            state = "blink_recover";
            blink_recover = 0.5;
            fh_vuln_timer = 0.5;
        } else if (_dist <= attack_range && attack_cooldown_timer <= 0 && _seen != noone) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (_dist < preferred_range - 20) {
            ai_enemy_move(facing_dir + 180, move_speed_effective, _dt);
        } else if (_dist > preferred_range + 20) {
            ai_enemy_move(facing_dir, move_speed_effective, _dt);
        } else {
            // Orbita lateralmente como o vento
            ai_enemy_move(facing_dir + 90, move_speed_effective * 0.6, _dt);
        }
        break;

    case "blink_recover":
        blink_recover -= _dt;
        scale_x = 1.2 + 0.1 * sin(current_time * 0.05);
        scale_y = 0.8;
        if (blink_recover <= 0) state = "chase";
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.2;
        scale_y = 1.2;
        if (_player != noone) facing_dir = point_direction(x, y, _player.x, _player.y);
        if (attack_windup_timer <= 0) {
            var _count = is_greater_variant ? 2 : 1;
            for (var _i = 0; _i < _count; _i++) {
                var _a = facing_dir + (_count == 2 ? (_i == 0 ? -25 : 25) : 0);
                var _bm = elem_spawn_missile(x, y, "boomerang", _a, projectile_speed, elem_dmg(projectile_damage), make_colour_rgb(210, 250, 255));
                _bm.max_dist = min(260, attack_range);
                _bm.life = 3.0;
                _bm.radius = 8;
            }
            attack_cooldown_timer = attack_cooldown;
            state = "recover";
            recover_timer = 0.35;
            fx_spawn_sparks(x, y, c_white, 6);
            sfx_play("wind_gust", 0.1, 0.4);
        }
        break;

    case "recover":
        recover_timer -= _dt;
        if (recover_timer <= 0) state = "chase";
        break;
}

ai_update_sprite_animation();
