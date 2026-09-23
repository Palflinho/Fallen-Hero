// ---------------------------------------------------------------------
// GENERAL ZEPHYRUS - "CEU E CHAO"
//  1. NO AR: intangivel, orbita o jogador e atira leques de penas.
//  2. MERGULHO: a sombra persegue o jogador, TRAVA e ele despenca ali.
//  3. ASAS PRESAS: apos o ultimo mergulho fica preso 3.5s (janela +50%).
//  Fase 2: 2 mergulhos seguidos + 2 ciclones soltos na arena.
//  Fase 3: 3 mergulhos + VENDAVAIS que empurram o jogador pela arena.
// ---------------------------------------------------------------------
// Dispara Diálogo Narrativo de Confronto do Chefe ao entrar na arena dos ventos
if (!variable_global_exists("dialogue_boss3_shown") || !global.dialogue_boss3_shown) {
    global.dialogue_boss3_shown = true;
    dialogue_play_id("temple3_wind_boss");
}

event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

if (boss_update_phase() && boss_phase == 2) {
    var _cyc = asset_get_index("obj_wind_cyclone");
    if (_cyc != -1) {
        var _c1 = instance_create_layer(room_width * 0.25, room_height * 0.5, layer, _cyc);
        var _c2 = instance_create_layer(room_width * 0.75, room_height * 0.5, layer, _cyc);
        _c2.vx = -_c2.vx;
    }
}

rot_angle += ((state == "grounded") ? 40 : 240) * _dt;

// ---- Vendavais (fase 3, enquanto ele voa) ----
if (boss_phase >= 3 && (state == "air" || state == "dive_mark")) {
    gust_timer -= _dt;
    if (gust_timer <= 0 && gust_active <= 0) {
        gust_active = 1.4;
        gust_dir = choose(0, 90, 180, 270);
        gust_timer = 5.0;
        sfx_play("wind_gust", 0.05, 1.0);
    }
}
if (gust_active > 0) {
    gust_active -= _dt;
    if (_player != noone) with (_player) fh_move_and_collide(lengthdir_x(95 * _dt, other.gust_dir), lengthdir_y(95 * _dt, other.gust_dir));
}

// ---- Janela: asas presas no chao ----
if (vulnerable) {
    vulnerable_timer -= _dt;
    body_colour = c_lime;
    if (random(1) < 0.35) {
        var _sa = random(360);
        fx_spawn_sparks(x + lengthdir_x(32, _sa), y - body_radius - 10 + lengthdir_y(8, _sa), c_yellow, 2);
    }
    if (vulnerable_timer <= 0) {
        boss_close_window();
        state = "liftoff";
        state_timer = 0.6;
        // Rajada ao decolar: afasta quem estiver perto
        trigger_hitstop(0.06);
        fx_spawn_sparks(x, y, c_white, 18);
        sfx_play("wind_gust", 0.05, 1.0);
        if (_player != noone) {
            var _pd = point_distance(x, y, _player.x, _player.y);
            if (_pd <= 90) player_take_damage(14, "magical");
            if (_pd <= 180) elem_push_player(point_direction(x, y, _player.x, _player.y), 320);
        }
    }
    exit;
}

switch (state) {
    case "liftoff":
        state_timer -= _dt;
        draw_z = lerp(draw_z, air_height, 0.12);
        fh_untargetable = (draw_z > 30);
        body_colour = make_colour_rgb(180, 245, 255);
        if (state_timer <= 0) {
            state = "air";
            state_timer = (boss_phase >= 3) ? 3.5 : air_time;
            fh_untargetable = true;
        }
        break;

    case "air":
        fh_untargetable = true;
        draw_z = lerp(draw_z, air_height, 0.1);
        body_colour = make_colour_rgb(180, 245, 255);
        state_timer -= _dt;
        if (_player != noone) {
            // Orbita o jogador no alto (ignora paredes: esta voando)
            var _d = point_distance(x, y, _player.x, _player.y);
            var _to = point_direction(x, y, _player.x, _player.y);
            var _want = _to + (_d > 250 ? 20 * orbit_side : (_d < 200 ? 160 * orbit_side : 90 * orbit_side));
            x = clamp(x + lengthdir_x(move_speed * 1.6 * _dt, _want), 80, room_width - 80);
            y = clamp(y + lengthdir_y(move_speed * 1.6 * _dt, _want), 80, room_height - 80);
            facing_dir = _to;

            feather_timer -= _dt;
            if (feather_timer <= 0) {
                feather_timer = (boss_phase >= 3) ? 1.0 : 1.4;
                for (var _a = -2; _a <= 2; _a++) {
                    elem_spawn_projectile(x, y, _to + _a * 14, 300, 20, c_white, "projectile");
                }
                sfx_play("wind_gust", 0.1, 0.5);
            }
        }
        if (state_timer <= 0) {
            dives_left = boss_phase;
            state = "dive_mark";
            state_timer = 1.1;
            if (_player != noone) {
                dive_x = _player.x;
                dive_y = _player.y;
            }
        }
        break;

    case "dive_mark":
        // A sombra persegue o jogador por 0.6s e depois TRAVA
        state_timer -= _dt;
        fh_untargetable = true;
        draw_z = lerp(draw_z, air_height * 1.3, 0.1);
        if (_player != noone && state_timer > 0.5) {
            dive_x = lerp(dive_x, _player.x, 0.2);
            dive_y = lerp(dive_y, _player.y, 0.2);
        }
        x = lerp(x, dive_x, 0.25);
        y = lerp(y, dive_y, 0.25);
        if (state_timer <= 0) {
            var _pt = fh_find_free_spawn_pos(dive_x, dive_y, body_radius);
            dive_x = _pt.x;
            dive_y = _pt.y;
            state = "dive";
            state_timer = 0.28;
        }
        break;

    case "dive":
        state_timer -= _dt;
        x = dive_x;
        y = dive_y;
        draw_z = max(0, draw_z - 700 * _dt);
        if (state_timer <= 0) {
            draw_z = 0;
            fh_untargetable = false;
            elem_hit_player_circle(x, y, dive_radius, dive_damage, "physical");
            if (_player != noone && point_distance(x, y, _player.x, _player.y) <= dive_radius * 2) {
                elem_push_player(point_direction(x, y, _player.x, _player.y), 300);
            }
            fx_spawn_death_burst(x, y, c_white, 20);
            trigger_camera_shake(9);
            trigger_hitstop(0.06);
            sfx_play("slam", 0.05, 0.9);
            dives_left -= 1;
            if (dives_left > 0) {
                state = "reascend";
                state_timer = 0.45;
            } else {
                state = "grounded";
                boss_open_window(grounded_duration);
                fx_spawn_damage_popup(x, y - body_radius - 30, "ASAS PRESAS! ATAQUE!", true, c_yellow);
                scale_x = 1.2;
                scale_y = 0.8;
            }
        }
        break;

    case "reascend":
        state_timer -= _dt;
        draw_z = lerp(draw_z, air_height, 0.2);
        fh_untargetable = (draw_z > 30);
        if (state_timer <= 0) {
            state = "dive_mark";
            state_timer = 0.9;
            if (_player != noone) {
                dive_x = _player.x;
                dive_y = _player.y;
            }
        }
        break;

    default:
        state = "liftoff";
        state_timer = 0.6;
        break;
}
