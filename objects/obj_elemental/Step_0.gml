// ---------------------------------------------------------------------
// ELEMENTAL DE AGUA
//  - Mantem distancia e solta uma BOLHA lenta que persegue o jogador.
//  - Se tocar: dano + preso por 1s. Qualquer ataque do jogador estoura a bolha.
//  - A partir da Fase 3: Onda de Repulsao se o jogador colar.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup") ? c_white : make_colour_rgb(80, 200, 255);

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;
if (repulsion_cooldown > 0) repulsion_cooldown -= _dt;

var _player = instance_find(obj_player, 0);
var _seen = ai_can_see_player(vision_range, vision_angle);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

switch (state) {
    case "patrol":
        ai_patrol(_dt);
        if (_seen != noone) {
            state = "chase";
            lost_sight_timer = 0;
            attack_cooldown_timer = max(attack_cooldown_timer, 0.65);
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

        // Onda de Repulsao (Fase 3+ quando o jogador cola)
        if (can_enrage && _dist <= 52 && repulsion_cooldown <= 0) {
            repulsion_cooldown = 5.0;
            elem_push_player(point_direction(x, y, _player.x, _player.y), 340);
            fx_spawn_sparks(x, y, c_aqua, 18);
            fx_spawn_damage_popup(x, y - 20, "ONDA DE REPULSAO!", false, c_aqua);
            trigger_hitstop(0.06);
        }

        if (_dist <= attack_range && attack_cooldown_timer <= 0 && _seen != noone && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            state = "windup";
            attack_windup_timer = attack_windup;
        } else if (_dist < preferred_range - 20) {
            ai_enemy_move(point_direction(x, y, _player.x, _player.y) + 180, move_speed_effective, _dt);
        } else if (_dist > preferred_range + 20) {
            ai_enemy_move(point_direction(x, y, _player.x, _player.y), move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        scale_x = 1.25 + 0.05 * sin(current_time * 0.03);
        scale_y = scale_x;
        if (attack_windup_timer <= 0) {
            var _dir = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : facing_dir;
            var _b = elem_spawn_missile(x + lengthdir_x(body_radius + 6, _dir), y + lengthdir_y(body_radius + 6, _dir), "bubble", _dir, 75, elem_dmg(8), make_colour_rgb(90, 200, 255));
            _b.radius = 11;
            _b.life = 6;
            attack_cooldown_timer = attack_cooldown;
            state = "recover";
            recover_timer = 0.4;
            scale_x = 0.8;
            scale_y = 0.8;
            sfx_play("magic", 0.1, 0.5);
        }
        break;

    case "recover":
        recover_timer -= _dt;
        if (recover_timer <= 0) state = "chase";
        break;
}

ai_update_sprite_animation();
