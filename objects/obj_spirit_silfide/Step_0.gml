// ---------------------------------------------------------------------
// SILFIDE, ESPIRITO DO VENTO (Chefe da Arena dos Ciclones)
//  - Fica INVISIVEL: so a POEIRA que ela levanta denuncia onde esta
//    (ela pode ser atingida mesmo invisivel!).
//  - RAJADA: aparece, marca uma linha e atravessa o arena -> fica EXPOSTA.
//  - ANEL DE BUMERANGUES: 4 (fase 2: 6) laminas de vento que vao e voltam.
//  - Fase 2 (50%): VORTICE - puxa o jogador para o olho do furacao.
// ---------------------------------------------------------------------
event_inherited();
if (is_world_paused() || hp <= 0) exit;

var _dt = delta_time / 1000000;
var _player = elem_player();

if (spirit_update_intro(_dt)) exit;
if (spirit_check_phase2()) move_speed *= 1.2;
if (state == "patrol" || state == "chase" || state == "idle") {
    state = "hidden";
    state_timer = phase2 ? 1.8 : 2.4;
}

switch (state) {
    case "hidden":
        state_timer -= _dt;
        // Revelada pela bomba de cinzas (Lamina Vulcanica)
        draw_alpha = lerp(draw_alpha, (fh_revealed > 0) ? 0.85 : 0.06, 0.15);
        if (_player != noone) {
            var _d = point_distance(x, y, _player.x, _player.y);
            var _to = point_direction(x, y, _player.x, _player.y);
            var _want = _to + (_d > 200 ? 0 : (_d < 150 ? 180 : 90 * orbit_side));
            ai_enemy_move(_want, move_speed_effective, _dt);
        }
        // Poeira: a unica pista de onde ela esta
        dust_timer -= _dt;
        if (dust_timer <= 0) {
            dust_timer = 0.07;
            fx_spawn_sparks(x + random_range(-8, 8), y + body_radius * 0.8, make_colour_rgb(215, 200, 170), 2);
        }
        if (state_timer <= 0) {
            move_cycle += 1;
            if (phase2 && move_cycle mod 3 == 0) {
                state = "vortex_windup";
                state_timer = 0.6;
            } else if (move_cycle mod 2 == 1) {
                state = "dash_windup";
                state_timer = 0.65;
                dash_dir = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : facing_dir;
            } else {
                state = "ring_windup";
                state_timer = 0.55;
            }
            sfx_play("wind_gust", 0.1, 0.5);
        }
        break;

    case "dash_windup":
        state_timer -= _dt;
        draw_alpha = lerp(draw_alpha, 1, 0.25);
        facing_dir = dash_dir;
        scale_x = 1.3;
        scale_y = 0.75;
        if (state_timer <= 0) {
            state = "dash";
            state_timer = 0.38;
            dash_hit = false;
        }
        break;

    case "dash":
        state_timer -= _dt;
        draw_alpha = 1;
        fh_move_and_collide(lengthdir_x(680 * _dt, dash_dir), lengthdir_y(680 * _dt, dash_dir));
        if (random(1) < 0.6) fx_spawn_sparks(x, y, c_white, 1);
        if (!dash_hit && _player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius + 6 && player_shield_tier(_player) > 0) {
            // Cavaleiro segura a rajada: ela rebate no escudo e fica exposta mais tempo
            dash_hit = true;
            var _st = player_shield_tier(_player);
            if (_st == 1) player_take_damage(elem_dmg(16), "physical");
            state = "exposed";
            state_timer = (_st >= 2) ? 2.8 : 2.0;
            fh_vuln_timer = state_timer;
            fx_spawn_damage_popup(x, y - 30, "REBATIDA NO ESCUDO!", true, c_yellow);
            trigger_hitstop(0.1);
            sfx_play("parry", 0.05, 0.9);
            break;
        }
        if (!dash_hit && _player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius + 6) {
            dash_hit = true;
            player_take_damage(elem_dmg(16), "physical");
            elem_push_player(dash_dir + 90 * choose(-1, 1), 340);
        }
        if (state_timer <= 0) {
            state = "exposed";
            state_timer = 1.2;
            fh_vuln_timer = 1.2;
        }
        break;

    case "ring_windup":
        state_timer -= _dt;
        draw_alpha = lerp(draw_alpha, 1, 0.25);
        scale_x = 1.2;
        scale_y = 1.2;
        if (state_timer <= 0) {
            var _n = phase2 ? 6 : 4;
            var _off = random(90);
            for (var _i = 0; _i < _n; _i++) {
                var _b = elem_spawn_missile(x, y, "boomerang", _off + _i * (360 / _n), 260, elem_dmg(11), elem_colour("wind"));
                _b.max_dist = 220;
                _b.life = 3.2;
                _b.radius = 9;
            }
            sfx_play("wind_gust", 0.05, 0.8);
            state = "exposed";
            state_timer = 0.8;
            fh_vuln_timer = 0.8;
        }
        break;

    case "vortex_windup":
        state_timer -= _dt;
        draw_alpha = lerp(draw_alpha, 1, 0.25);
        if (state_timer <= 0) {
            state = "vortex";
            state_timer = 2.4;
            vortex_tick = 0;
            sfx_play("wind_gust", 0.05, 1.0);
        }
        break;

    case "vortex":
        state_timer -= _dt;
        draw_alpha = 1;
        if (_player != noone) {
            var _pd = point_distance(x, y, _player.x, _player.y);
            if (_pd <= 320 && _pd > 16) {
                var _pull_dir = point_direction(_player.x, _player.y, x, y);
                var _pull = 75 * _dt;
                elem_pull_player(lengthdir_x(_pull, _pull_dir), lengthdir_y(_pull, _pull_dir));
            }
            if (vortex_tick > 0) vortex_tick -= _dt;
            if (_pd <= body_radius + 30 && vortex_tick <= 0) {
                player_take_damage(elem_dmg(8), "magical");
                vortex_tick = 0.5;
            }
        }
        elem_reflect_player_projectiles(x, y, 60, elem_colour("wind"));
        if (state_timer <= 0) {
            state = "exposed";
            state_timer = 1.5;
            fh_vuln_timer = 1.5;
        }
        break;

    case "exposed":
        state_timer -= _dt;
        draw_alpha = 1;
        scale_x = 1.15;
        scale_y = 0.85;
        if (state_timer <= 0) {
            state = "hidden";
            state_timer = phase2 ? 1.8 : 2.4;
            if (random(1) < 0.5) orbit_side = -orbit_side;
        }
        break;
}
