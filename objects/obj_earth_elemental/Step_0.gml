// ---------------------------------------------------------------------
// ELEMENTAL DE TERRA
//  - Crava uma ESTACA no chao: um marcador segue o jogador e trava;
//    0.8s depois a estaca irrompe ali. Continue se movendo!
//  - Enquanto crava fica 0.6s enraizado (janela para atacar).
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup") ? make_colour_rgb(190, 150, 90) : make_colour_rgb(145, 110, 75);

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
            attack_cooldown_timer = max(attack_cooldown_timer, 0.70);
            consecutive_shots = 0;
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

        if (_dist <= attack_range && attack_cooldown_timer <= 0 && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (_dist < preferred_range - 30) {
            ai_enemy_move(facing_dir + 180, move_speed_effective, _dt);
        } else if (_dist > preferred_range + 30) {
            ai_enemy_move(facing_dir, move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.3;
        scale_y = 0.75;
        if (attack_windup_timer <= 0) {
            var _count = is_greater_variant ? 2 : 1;
            for (var _i = 0; _i < _count; _i++) {
                var _st = elem_spawn_missile(x + lengthdir_x(body_radius + 4, facing_dir), y + lengthdir_y(body_radius + 4, facing_dir), "stake", facing_dir, 0, elem_dmg(stake_damage), make_colour_rgb(170, 125, 70));
                // a segunda estaca (variante alfa) trava com atraso extra
                if (_i == 1) _st.timer = -0.4;
            }
            fx_spawn_sparks(x, y + body_radius, make_colour_rgb(160, 120, 70), 8);
            sfx_play("slam", 0.1, 0.4);
            attack_cooldown_timer = attack_cooldown;
            state = "recover";
            recover_timer = 0.6;
        }
        break;

    case "recover":
        recover_timer -= _dt;
        scale_x = 0.9;
        scale_y = 1.1;
        if (recover_timer <= 0) state = "chase";
        break;
}

ai_update_sprite_animation();
