// ---------------------------------------------------------------------
// GENERAL DA AGUA - "TENIS GLACIAL"
//  1. ORBE GLACIAL: lento e teleguiado. Qualquer ataque rebate de volta.
//     Se o General nao devolver -> CONGELADO 4.5s (janela de dano +50%).
//     Fase 2 ele devolve 1x, fase 3 devolve 2x (cada vez mais rapido).
//  2. RAJADA: leque de tiros (pausa enquanto o orbe esta em jogo).
//  3. PISAO: pune quem gruda nele; fase 2+ congela o chao em cruz.
//  4. ONDA DE MARE (fase 2+): faixa que varre a arena - passe pela brecha.
// ---------------------------------------------------------------------
if (is_world_paused()) exit;

event_inherited();
var _dt = delta_time / 1000000;

var _player = instance_find(obj_player, 0);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

if (boss_update_phase()) {
    tide_timer = 1.0;
    orb_timer = min(orb_timer, 2.0);
}

if (_player != noone && !_player.invisible && state != "slam_windup") {
    var _lead_acc = (variable_instance_exists(id, "adaptation") && is_struct(adaptation)) ? adaptation.barrage_lead_accuracy : 0.35;
    // Calibração progressiva da rajada: os primeiros tiros iniciam mais brandos, afinando o arco
    var _total_shots = variable_instance_exists(id, "barrage_shots_total") ? barrage_shots_total : 6;
    var _volley_prog = (_total_shots > 1) ? min(1.0, barrage_shots_fired / (_total_shots - 1)) : 1.0;
    var _cur_acc = lerp(_lead_acc * 0.30, _lead_acc, _volley_prog);
    facing_dir = adaptive_ai_get_lead_aim_dir(x, y, _player, projectile_speed, _cur_acc, 20.0);
}

// O orbe voltou e ele nao conseguiu devolver: CONGELADO
if (orb_freeze_request) {
    orb_freeze_request = false;
    state = "frozen";
    boss_open_window(frozen_duration);
    fx_spawn_damage_popup(x, y - body_radius - 30, "CONGELADO! ATAQUE!", true, c_aqua);
    fx_spawn_death_burst(x, y, c_aqua, 24);
    trigger_hitstop(0.12);
    trigger_camera_shake(10);
    sfx_play("stagger", 0.04);
}

if (vulnerable) {
    vulnerable_timer -= _dt;
    if (vulnerable_timer <= 0) {
        boss_close_window();
        if (state == "frozen") fx_spawn_sparks(x, y, c_white, 20);
        state = "recover";
        recover_timer = post_slam_recover;
    }
} else {
    switch (state) {
        case "recover":
            recover_timer -= _dt;
            if (recover_timer <= 0) {
                state = "barrage";
                barrage_shots_fired = 0;
                barrage_shot_timer = barrage_volley_pause;
            }
            break;

        case "barrage":
            if (_player == noone || _player.invisible) break;

            // Pisao: so quando o jogador gruda nele
            if (_dist <= melee_trigger_dist) {
                state = "slam_windup";
                slam_windup_timer = slam_windup;
                if (variable_instance_exists(id, "adaptation") && is_struct(adaptation) && adaptation.slam_bait_chance > 0) {
                    if (random(1) < adaptation.slam_bait_chance) {
                        slam_windup_timer += 0.35;
                        fx_spawn_sparks(x, y - 40, c_yellow, 6);
                    }
                }
                break;
            }

            if (_dist > 320) {
                var _dir = point_direction(x, y, _player.x, _player.y);
                fh_move_and_collide(lengthdir_x(move_speed_effective * _dt, _dir), lengthdir_y(move_speed_effective * _dt, _dir));
            }

            // Orbe Glacial
            if (!orb_active) {
                orb_timer -= _dt;
                if (orb_timer <= 0) {
                    state = "orb_windup";
                    orb_windup_timer = orb_windup;
                    sfx_play("magic", 0.05, 0.8);
                    break;
                }
            }

            // Onda de Mare (fase 2+)
            if (boss_phase >= 2) {
                tide_timer -= _dt;
                if (tide_timer <= 0) {
                    tide_timer = (boss_phase >= 3) ? 7.0 : tide_cooldown;
                    var _waves = (boss_phase >= 3) ? 2 : 1;
                    var _first_vert = choose(true, false);
                    for (var _w = 0; _w < _waves; _w++) {
                        var _vert = (_w == 0) ? _first_vert : !_first_vert;
                        var _wave = elem_spawn_missile(0, 0, "tidal_wave", 0, 250, 30, make_colour_rgb(80, 170, 255));
                        _wave.wave_vertical = _vert;
                        _wave.wave_sign = choose(-1, 1);
                        _wave.wave_pos = (_wave.wave_sign > 0) ? 0 : (_vert ? room_width : room_height);
                        _wave.gap_size = 130;
                        _wave.gap_center = random_range(120, (_vert ? room_height : room_width) - 120);
                        _wave.timer = -_w * 1.4; // segunda onda chega depois
                    }
                    sfx_play("wind_gust", 0.05, 0.8);
                }
            }

            // Rajada: pausa enquanto o orbe esta em jogo (o jogador foca no rebate)
            if (!orb_active) {
                barrage_shot_timer -= _dt;
                if (barrage_shot_timer <= 0) {
                    if (barrage_shots_fired < barrage_shots_total) {
                        var _t = (barrage_shots_total > 1) ? (barrage_shots_fired / (barrage_shots_total - 1)) : 0.5;
                        var _ang = facing_dir + barrage_spread * (_t - 0.5);
                        var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
                        _p.owner = id;
                        _p.damage = projectile_damage;
                        _p.dir_x = lengthdir_x(1, _ang);
                        _p.dir_y = lengthdir_y(1, _ang);
                        _p.speed_px = projectile_speed;
                        _p.colour = c_maroon;
                        _p.body_radius = 10;
                        _p.damage_type = "magical";
                        barrage_shots_fired += 1;
                        barrage_shot_timer = barrage_shot_interval;
                    } else {
                        barrage_shots_fired = 0;
                        barrage_shot_timer = barrage_volley_pause + ((boss_phase >= 3) ? 0 : 0.3);
                    }
                }
            }
            break;

        case "orb_windup":
            orb_windup_timer -= _dt;
            scale_x = 1.15;
            scale_y = 1.15;
            if (orb_windup_timer <= 0) {
                var _odir = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : facing_dir;
                var _orb = elem_spawn_missile(x + lengthdir_x(body_radius + 20, _odir), y + lengthdir_y(body_radius + 20, _odir), "glacial_orb", _odir, 150, 28, make_colour_rgb(120, 210, 255));
                _orb.radius = 16;
                _orb.life = 14;
                _orb.turn_rate = 55;
                _orb.max_returns = boss_phase - 1;
                orb_active = true;
                orb_timer = orb_cooldown;
                state = "barrage";
                barrage_shots_fired = 0;
                scale_x = 0.85;
                scale_y = 0.85;
                sfx_play("magic", 0.05, 1.0);
            }
            break;

        case "slam_windup":
            slam_windup_timer -= _dt;
            scale_y = 1.35;
            scale_x = 0.85;
            if (slam_windup_timer <= 0) {
                var _hit = instance_create_layer(x, y, layer, obj_enemy_melee_hit);
                _hit.owner = id;
                _hit.damage = slam_damage;
                _hit.damage_type = "physical";
                _hit.body_radius = slam_hit_radius;

                // Fase 2+: o impacto congela o chao em cruz ao redor dele
                if (boss_phase >= 2) {
                    var _cr = elem_spawn_missile(x, y, "ice_cross", 0, 0, 20, make_colour_rgb(170, 230, 255));
                    _cr.target_x = x;
                    _cr.target_y = y;
                    _cr.cell_arm = 6;
                    _cr.timer = 0.45;
                }

                state = "slam_recover";
                boss_open_window(slam_window);
                scale_y = 0.65;
                scale_x = 1.45;
                fx_spawn_sparks(x, y, c_aqua, 24);
                trigger_hitstop(0.08);
                trigger_camera_shake(14);
                sfx_play("slam");
            }
            break;
    }
}

if (state == "frozen") {
    body_colour = make_colour_rgb(200, 240, 255);
} else if (vulnerable) {
    body_colour = c_lime;
} else if (state == "slam_windup" || state == "orb_windup") {
    body_colour = c_yellow;
} else if (state == "recover") {
    body_colour = c_silver;
} else {
    body_colour = c_maroon;
}
