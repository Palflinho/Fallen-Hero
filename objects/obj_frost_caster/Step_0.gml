// ---------------------------------------------------------------------
// CONJURADOR DE GELO
//  - Marca o chao sob o jogador e congela em CRUZ "+" (3 celulas por braco).
//  - As celulas viram gelo escorregadio por 6s: o campo de batalha muda.
//  - Saia na DIAGONAL: a cruz nao cobre as diagonais.
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup") ? c_white : make_colour_rgb(60, 110, 230);

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
        if (_player == noone) break;
        facing_dir = point_direction(x, y, _player.x, _player.y);

        if (attack_cooldown_timer <= 0 && _dist <= 320) {
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
        scale_y = 1.25;
        scale_x = 0.85;
        if (attack_windup_timer <= 0) {
            if (_player != noone) {
                var _c = elem_spawn_missile(_player.x, _player.y, "ice_cross", 0, 0, elem_dmg(cross_damage), make_colour_rgb(170, 230, 255));
                _c.target_x = _player.x;
                _c.target_y = _player.y;
                _c.cell_arm = is_greater_variant ? 4 : 3;
            }
            attack_cooldown_timer = attack_cooldown;
            state = "recover";
            recover_timer = 0.6;
            fx_spawn_sparks(x, y, c_aqua, 8);
        }
        break;

    case "recover":
        recover_timer -= _dt;
        if (recover_timer <= 0) state = "chase";
        break;
}

ai_update_sprite_animation();
