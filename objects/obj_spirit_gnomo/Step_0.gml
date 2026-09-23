// ---------------------------------------------------------------------
// GNOMO, ESPIRITO DA TERRA (Chefe do Coliseu Sismico)
//  - ESCAVA: afunda (intangivel), um monte de terra corre ate o jogador
//    e ele EMERGE embaixo dele apos um aviso circular -> fica EXPOSTO 1.5s.
//  - PEDREGULHOS: arremessa rochas que viram obstaculos.
//  - ESTACAS: 3 estacas atrasadas que irrompem sob o jogador.
//  - Fase 2 (50%): emergir levanta um anel de estacas e arremessa 2 rochas.
// ---------------------------------------------------------------------
event_inherited();
if (is_world_paused() || hp <= 0) exit;

var _dt = delta_time / 1000000;
var _player = elem_player();

if (spirit_update_intro(_dt)) exit;
spirit_check_phase2();
if (state == "patrol" || state == "chase") state = "idle";

// Geomante: o Pilar de Basalto arranca o espirito de baixo da terra (sem ataque, fica exposto)
if (fh_force_emerge) {
    fh_force_emerge = false;
    if (state == "under" || state == "emerge_warn" || state == "dive" || state == "burrow") {
        var _fe = fh_find_free_spawn_pos(x, y, body_radius);
        x = _fe.x;
        y = _fe.y;
        fh_untargetable = false;
        draw_alpha = 1;
        state = "exposed";
        state_timer = 2.5;
        fh_vuln_timer = 2.5;
        fx_spawn_damage_popup(x, y - body_radius - 30, "ARRANCADO DO SUBSOLO!", true, c_yellow);
        fx_spawn_death_burst(x, y, elem_colour(element), 16);
        trigger_hitstop(0.1);
    }
}

switch (state) {
    case "idle":
        state = "surface";
        state_timer = phase2 ? 1.0 : 1.5;
        break;

    case "surface":
        state_timer -= _dt;
        body_colour = elem_colour("earth");
        if (_player != noone) {
            facing_dir = point_direction(x, y, _player.x, _player.y);
            if (point_distance(x, y, _player.x, _player.y) > 90) ai_enemy_move(facing_dir, move_speed_effective, _dt);
        }
        if (state_timer <= 0) {
            move_cycle += 1;
            var _pick = move_cycle mod 4;
            if (_pick == 1 || _pick == 3) {
                state = "burrow";
                state_timer = 0.5;
            } else if (_pick == 2) {
                state = "throw_windup";
                state_timer = 0.6;
            } else {
                state = "stake_windup";
                state_timer = 0.5;
            }
        }
        break;

    case "throw_windup":
        state_timer -= _dt;
        scale_x = 1.2;
        scale_y = 1.15;
        if (state_timer <= 0) {
            if (_player != noone) {
                var _n = phase2 ? 2 : 1;
                for (var _i = 0; _i < _n; _i++) {
                    var _b = elem_spawn_missile(x, y - body_radius, "boulder", 0, 0, elem_dmg(16), elem_colour("earth"));
                    // a segunda rocha mira adiante do movimento do jogador
                    _b.target_x = _player.x + (_i == 1 ? _player.vx * 0.6 : 0);
                    _b.target_y = _player.y + (_i == 1 ? _player.vy * 0.6 : 0);
                    _b.flight_time = 0.8 + _i * 0.15;
                }
            }
            sfx_play("slam", 0.1, 0.4);
            state = "exposed";
            state_timer = 0.6;
        }
        break;

    case "stake_windup":
        state_timer -= _dt;
        scale_x = 1.3;
        scale_y = 0.75;
        if (state_timer <= 0) {
            for (var _s = 0; _s < 3; _s++) {
                var _st = elem_spawn_missile(x, y, "stake", 0, 0, elem_dmg(14), elem_colour("earth"));
                _st.timer = -_s * 0.35;
            }
            fx_spawn_sparks(x, y + body_radius, elem_colour("earth"), 10);
            sfx_play("slam", 0.1, 0.5);
            state = "exposed";
            state_timer = 0.7;
        }
        break;

    case "burrow":
        state_timer -= _dt;
        scale_x = 1.4;
        scale_y = 0.5;
        draw_alpha = clamp(state_timer / 0.5, 0, 1);
        if (random(1) < 0.5) fx_spawn_sparks(x, y + body_radius, elem_colour("earth"), 1);
        if (state_timer <= 0) {
            state = "under";
            state_timer = phase2 ? 1.2 : 1.6;
            fh_untargetable = true;
            draw_alpha = 0;
        }
        break;

    case "under":
        state_timer -= _dt;
        fh_untargetable = true;
        draw_alpha = 0;
        var _trk = elem_player_tracking();
        if (_trk != noone) ai_enemy_move(point_direction(x, y, _trk.x, _trk.y), 170, _dt);
        mound_timer -= _dt;
        if (mound_timer <= 0) {
            mound_timer = 0.08;
            fx_spawn_sparks(x + random_range(-10, 10), y + random_range(-6, 6), elem_colour("earth"), 1);
        }
        if (state_timer <= 0) {
            state = "emerge_warn";
            state_timer = 0.7;
            var _pt = (_player != noone) ? fh_find_free_spawn_pos(_player.x, _player.y, body_radius) : { x: x, y: y };
            target_x = _pt.x;
            target_y = _pt.y;
            trigger_camera_shake(2);
        }
        break;

    case "emerge_warn":
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
            elem_hit_player_circle(x, y, 48, elem_dmg(22), "physical");
            if (_player != noone && point_distance(x, y, _player.x, _player.y) <= 90) {
                elem_push_player(point_direction(x, y, _player.x, _player.y), 300);
            }
            if (phase2) {
                for (var _r = 0; _r < 4; _r++) {
                    var _rs = elem_spawn_missile(x + lengthdir_x(80, _r * 90 + 45), y + lengthdir_y(80, _r * 90 + 45), "stake", 0, 0, elem_dmg(12), elem_colour("earth"));
                    _rs.phase = 1;
                    _rs.timer = 0.35; // pula a perseguicao: irrompe no ponto fixo
                    _rs.target_x = _rs.x;
                    _rs.target_y = _rs.y;
                }
            }
            fx_spawn_death_burst(x, y, elem_colour("earth"), 20);
            trigger_camera_shake(7);
            trigger_hitstop(0.05);
            sfx_play("slam", 0.05, 1.0);
            scale_x = 0.7;
            scale_y = 1.5;
            state = "exposed";
            state_timer = 1.5;
            fh_vuln_timer = 1.5;
        }
        break;

    case "exposed":
        state_timer -= _dt;
        if (state_timer <= 0) state = "idle";
        break;
}

if (state != "burrow" && state != "under" && state != "emerge_warn") {
    fh_untargetable = false;
    draw_alpha = 1;
}
