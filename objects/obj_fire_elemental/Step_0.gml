// ---------------------------------------------------------------------
// ELEMENTAL DE FOGO
//  - Leque de 3 tiros (seta = projetil). Onde cada tiro bate, o chao queima 3s.
//  - Depois do disparo fica 0.6s parado recuperando (janela para atacar).
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup") ? c_yellow : c_red;

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
            attack_cooldown_timer = max(attack_cooldown_timer, 0.60);
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
            if (lost_sight_timer >= 1.5) {
                consecutive_shots = 0;
            }
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }
        if (_player == noone) break;
        facing_dir = point_direction(x, y, _player.x, _player.y);

        if (_dist <= attack_range && attack_cooldown_timer <= 0 && _seen != noone && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (_dist < preferred_range - 20) {
            ai_enemy_move(facing_dir + 180, move_speed_effective, _dt);
        } else if (_dist > preferred_range + 20) {
            ai_enemy_move(facing_dir, move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.25 + 0.05 * sin(current_time * 0.03);
        scale_y = scale_x;
        // Mira acompanha o jogador e TRAVA nos ultimos 35% do aviso (da para esquivar)
        if (_player != noone && attack_windup_timer > attack_windup * 0.35) {
            facing_dir = point_direction(x, y, _player.x, _player.y);
        } else if (locked_aim_dir == -1) {
            locked_aim_dir = facing_dir;
            fx_spawn_sparks(x + lengthdir_x(14, facing_dir), y + lengthdir_y(14, facing_dir), c_orange, 2);
        }
        if (attack_windup_timer <= 0) {
            for (var _f = -1; _f <= 1; _f++) {
                var _a = facing_dir + _f * fan_spread;
                var _s = elem_spawn_missile(x, y, "fire_shot", _a, projectile_speed, elem_dmg(projectile_damage), make_colour_rgb(255, 130, 40));
                _s.life = 1.1;
                _s.radius = 7;
            }
            locked_aim_dir = -1;
            attack_cooldown_timer = attack_cooldown;
            state = "recover";
            recover_timer = 0.6;
            scale_x = 0.8;
            scale_y = 0.8;
            fx_spawn_sparks(x, y, c_orange, 6);
            sfx_play("magic", 0.1, 0.5);
        }
        break;

    case "recover":
        recover_timer -= _dt;
        if (recover_timer <= 0) state = "chase";
        break;
}

ai_update_sprite_animation();
