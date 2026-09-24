// ---------------------------------------------------------------------
// CONJURADOR DE MAGMA
//  - Canaliza 3 METEOROS encadeados: cada um marca a posicao atual do
//    jogador e cai 0.85s depois. Nao pare de se mover!
//  - Enquanto canaliza fica parado; depois fica EXAUSTO 1s (+50% de dano).
// ---------------------------------------------------------------------
event_inherited();
if (elem_ai_blocked()) exit;

var _dt = delta_time / 1000000;
body_colour = (state == "windup" || state == "channel") ? c_yellow : c_maroon;
if (state == "exhausted") body_colour = make_colour_rgb(90, 40, 40);

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

        if (attack_cooldown_timer <= 0 && _dist <= 340 && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
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
            var _n = is_greater_variant ? meteor_count + 1 : meteor_count;
            for (var _i = 0; _i < _n; _i++) {
                var _m = elem_spawn_missile(x, y, "meteor", 0, 0, elem_dmg(meteor_damage), make_colour_rgb(255, 120, 30));
                _m.delay = 0.01 + _i * meteor_gap;
            }
            state = "channel";
            channel_timer = 0.85 + (_n - 1) * meteor_gap;
            sfx_play("magic", 0.1, 0.6);
        }
        break;

    case "channel":
        fh_channeling = true;
        channel_timer -= _dt;
        if (fh_interrupt) {
            // Maga interrompeu: os meteoros que ainda nao cairam se desfazem
            with (obj_elem_missile) {
                if (owner == other.id && kind == "meteor" && (delay > 0 || phase == 0)) instance_destroy();
            }
            channel_timer = 0;
            fh_vuln_timer = 1.5;
        }
        scale_y = 1.3 + 0.05 * sin(current_time * 0.04);
        scale_x = 0.8;
        if (random(1) < 0.3) fx_spawn_sparks(x, y - body_radius, c_orange, 1);
        if (channel_timer <= 0) {
            state = "exhausted";
            exhausted_timer = fh_interrupt ? 1.5 : 1.0;
            fh_vuln_timer = exhausted_timer;
            fh_channeling = false;
            fh_interrupt = false;
            attack_cooldown_timer = attack_cooldown;
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
