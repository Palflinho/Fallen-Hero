// ---------------------------------------------------------------------
// CONJURADOR DE TERRA
//  - Ergue duas MURALHAS de pedra temporarias (4s) dos lados do jogador,
//    criando um corredor, e em seguida faz o chao TREMER sob ele.
//  - Saia pelo corredor antes do tremor. Depois fica EXAUSTO 0.8s.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "cast" || state == "windup") ? make_colour_rgb(200, 150, 80) : make_colour_rgb(150, 110, 60);
if (state == "exhausted") body_colour = make_colour_rgb(100, 75, 45);

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

        if (attack_cooldown_timer <= 0 && _dist <= 300 && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
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
        scale_y = 1.3;
        scale_x = 0.8;
        if (attack_windup_timer <= 0) {
            if (_player != noone) {
                // Corredor: muralhas paralelas a linha conjurador -> jogador
                var _dx = _player.x - x;
                var _dy = _player.y - y;
                var _off = 60;
                if (abs(_dx) >= abs(_dy)) {
                    elem_raise_wall(_player.x, _player.y - _off, 3, 1, wall_life);
                    elem_raise_wall(_player.x, _player.y + _off, 3, 1, wall_life);
                } else {
                    elem_raise_wall(_player.x - _off, _player.y, 1, 3, wall_life);
                    elem_raise_wall(_player.x + _off, _player.y, 1, 3, wall_life);
                }
                cast_target_x = _player.x;
                cast_target_y = _player.y;
                trigger_camera_shake(3);
                sfx_play("slam", 0.1, 0.5);
            } else {
                cast_target_x = x;
                cast_target_y = y;
            }
            state = "cast";
            cast_timer = telegraph_time + 0.2;
        }
        break;

    case "cast":
        cast_timer -= _dt;
        scale_y = 1.25;
        scale_x = 0.85;
        if (cast_timer <= 0) {
            elem_hit_player_circle(cast_target_x, cast_target_y, aoe_radius, elem_dmg(aoe_damage), "physical");
            fx_spawn_sparks(cast_target_x, cast_target_y, make_colour_rgb(160, 120, 70), 16);
            trigger_camera_shake(4);
            attack_cooldown_timer = attack_cooldown + 1.0;
            state = "exhausted";
            exhausted_timer = 0.8;
            fh_vuln_timer = 0.8;
        }
        break;

    case "exhausted":
        exhausted_timer -= _dt;
        scale_y = 0.8;
        scale_x = 1.2;
        if (exhausted_timer <= 0) state = "chase";
        break;
}

ai_update_sprite_animation();
