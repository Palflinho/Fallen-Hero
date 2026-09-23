// ---------------------------------------------------------------------
// SALAMANDRA, ESPIRITO DO FOGO (Chefe da Arena Vulcanica)
//  - SERPENTEIA atras do jogador deixando um rastro de fogo no chao.
//  - CUSPE: leque de 3 tiros de fogo (o impacto vira chamas).
//  - MERGULHO: some na lava (intangivel), persegue por baixo e EMERGE sob
//    o jogador apos um aviso circular -> fica EXPOSTA 1.3s (+50% de dano).
//  - Fase 2 (50%): mais rapida, rastro mais longo, mergulha 2x seguidas
//    e a erupcao solta um anel de fogo.
// ---------------------------------------------------------------------
event_inherited();
if (is_world_paused() || hp <= 0) exit;

var _dt = delta_time / 1000000;
var _player = elem_player();
if (contact_cd > 0) contact_cd -= _dt;

// Atualiza o historico da serpente (a cabeca e o proprio x/y)
for (var _i = trail_len - 1; _i > 0; _i--) {
    trail_x[_i] = trail_x[_i - 1];
    trail_y[_i] = trail_y[_i - 1];
}
trail_x[0] = x;
trail_y[0] = y;

if (spirit_update_intro(_dt)) exit;
if (spirit_check_phase2()) move_speed *= 1.25;
if (state == "patrol" || state == "chase") state = "idle";

var _trail_life = phase2 ? 3.5 : 2.5;

switch (state) {
    case "idle":
        state = "slither";
        state_timer = phase2 ? 2.6 : 3.2;
        break;

    case "slither":
        state_timer -= _dt;
        body_colour = elem_colour("fire");
        if (_player != noone) {
            wiggle += _dt * 6;
            var _dir = point_direction(x, y, _player.x, _player.y) + sin(wiggle) * 45;
            ai_enemy_move(_dir, move_speed_effective, _dt);
            if (contact_cd <= 0 && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
                player_take_damage(contact_damage, "physical");
                contact_cd = 0.8;
            }
        }
        fire_drop_timer -= _dt;
        if (fire_drop_timer <= 0) {
            fire_drop_timer = 0.12;
            var _g = elem_spawn_ground(x, y, "fire", 15, _trail_life);
            _g.damage = elem_dmg(4);
        }
        if (state_timer <= 0) {
            if (next_move == "dive") {
                state = "dive";
                state_timer = 0.45;
                dive_count = phase2 ? 2 : 1;
                next_move = "spit";
            } else {
                state = "spit_windup";
                state_timer = 0.5;
                next_move = "dive";
            }
        }
        break;

    case "spit_windup":
        state_timer -= _dt;
        body_colour = c_yellow;
        if (_player != noone) facing_dir = point_direction(x, y, _player.x, _player.y);
        if (state_timer <= 0) {
            for (var _f = -1; _f <= 1; _f++) {
                var _s = elem_spawn_missile(x, y, "fire_shot", facing_dir + _f * 18, 260, elem_dmg(12), elem_colour("fire"));
                _s.life = 1.3;
            }
            sfx_play("magic", 0.1, 0.6);
            state = "exposed";
            state_timer = 0.6;
        }
        break;

    case "dive":
        // afundando na lava
        state_timer -= _dt;
        scale_x = 1.4;
        scale_y = 0.4;
        draw_alpha = clamp(state_timer / 0.45, 0, 1);
        if (state_timer <= 0) {
            state = "under";
            state_timer = 1.2;
            fh_untargetable = true;
            draw_alpha = 0;
            fx_spawn_sparks(x, y, c_orange, 14);
            sfx_play("slam", 0.1, 0.4);
        }
        break;

    case "under":
        state_timer -= _dt;
        fh_untargetable = true;
        draw_alpha = 0;
        if (_player != noone) ai_enemy_move(point_direction(x, y, _player.x, _player.y), 200, _dt);
        if (random(1) < 0.5) fx_spawn_sparks(x + random_range(-10, 10), y + random_range(-10, 10), c_orange, 1);
        if (state_timer <= 0) {
            state = "erupt_warn";
            state_timer = 0.7;
            target_x = (_player != noone) ? _player.x : x;
            target_y = (_player != noone) ? _player.y : y;
            var _pt = fh_find_free_spawn_pos(target_x, target_y, body_radius);
            target_x = _pt.x;
            target_y = _pt.y;
        }
        break;

    case "erupt_warn":
        state_timer -= _dt;
        fh_untargetable = true;
        draw_alpha = 0;
        x = lerp(x, target_x, 0.3);
        y = lerp(y, target_y, 0.3);
        if (state_timer <= 0) {
            x = target_x;
            y = target_y;
            fh_untargetable = false;
            draw_alpha = 1;
            elem_hit_player_circle(x, y, 50, elem_dmg(20), "magical");
            var _ring = phase2 ? 8 : 0;
            for (var _r = 0; _r < _ring; _r++) {
                var _rs = elem_spawn_missile(x, y, "fire_shot", _r * 45, 200, elem_dmg(9), elem_colour("fire"));
                _rs.life = 0.9;
            }
            fx_spawn_death_burst(x, y, c_orange, 20);
            trigger_camera_shake(6);
            sfx_play("slam", 0.05, 0.9);
            scale_x = 0.7;
            scale_y = 1.5;
            dive_count -= 1;
            if (dive_count > 0) {
                state = "dive";
                state_timer = 0.45;
            } else {
                state = "exposed";
                state_timer = 1.3;
                fh_vuln_timer = 1.3;
            }
        }
        break;

    case "exposed":
        state_timer -= _dt;
        body_colour = make_colour_rgb(150, 60, 30);
        if (state_timer <= 0) state = "idle";
        break;
}

if (state != "dive" && state != "under" && state != "erupt_warn") {
    fh_untargetable = false;
    draw_alpha = (state == "intro") ? draw_alpha : 1;
}
