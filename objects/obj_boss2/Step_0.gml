// ---------------------------------------------------------------------
// GENERAL MAGMA - "TOURO DE MAGMA"
//  1. INVESTIDA: mira (linha de aviso) e dispara ate bater em algo.
//     Bateu na PAREDE -> CROSTA RACHADA 4s (janela +50%).
//     Bateu em VOCE -> ele para e nao fica exposto.
//     CAVALEIRO com escudo erguido segura a investida: janela de 2s (empurrado e com dano
//     reduzido). GUARDIAO segura sem recuar nem sofrer dano: janela cheia de 4s.
//  2. ERUPCAO: 3 (fase 3: 5) pontos marcados explodem e o chao queima.
//  3. LEQUE DE MAGMA (fase 2+): 5 tiros de fogo.
// ---------------------------------------------------------------------
event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

boss_update_phase();

if (_player != noone && !_player.invisible && state != "erupcao_windup" && state != "charge" && state != "charge_windup") {
    facing_dir = point_direction(x, y, _player.x, _player.y);
}

// ----------------------------------------------------
// JANELA DE DANO: CROSTA RACHADA
// ----------------------------------------------------
if (vulnerable) {
    vulnerable_timer -= _dt;
    body_colour = c_orange;
    scale_y = 0.75 + 0.05 * sin(current_time * 0.03);
    scale_x = 1.25 - 0.05 * sin(current_time * 0.03);
    if (random(1) < 0.6) {
        fx_spawn_sparks(x + random_range(-25, 25), y - body_radius * 0.5, c_white, 2);
        fx_spawn_sparks(x + random_range(-20, 20), y - body_radius * 0.5, c_yellow, 1);
    }
    if (vulnerable_timer <= 0) {
        boss_close_window();
        state = "recover";
        recover_timer = 1.2;
        body_colour = c_red;
        scale_x = 1.0;
        scale_y = 1.0;
        // A crosta se refaz com um jato de vapor: saia de perto
        trigger_hitstop(0.08);
        fx_spawn_sparks(x, y, c_red, 20);
        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= 140) {
            player_take_damage(24, "magical");
        }
    }
    exit;
}

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

switch (state) {
    case "recover":
        recover_timer -= _dt;
        body_colour = c_maroon;
        if (recover_timer <= 0) {
            state = "chase";
            attack_cooldown_timer = 0.6;
        }
        break;

    case "chase":
        body_colour = c_red;
        if (_player == noone || _player.invisible) break;
        var _dist = point_distance(x, y, _player.x, _player.y);
        if (_dist > 220) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            fh_move_and_collide(lengthdir_x(move_speed * _dt, _dir), lengthdir_y(move_speed * _dt, _dir));
        }
        if (attack_cooldown_timer > 0) break;

        // Ordem dos golpes por fase (a investida sempre fecha o ciclo)
        var _order = (boss_phase == 1) ? ["erupcao", "charge"] : ["erupcao", "fan", "charge"];
        var _next = _order[attack_order mod array_length(_order)];
        attack_order += 1;

        if (_next == "erupcao") {
            state = "erupcao_windup";
            erupcao_timer = erupcao_telegraph;
            erupcao_count = (boss_phase >= 3) ? 5 : 3;
            scale_y = 1.35;
            scale_x = 0.85;
            var _pdir = point_direction(x, y, _player.x, _player.y);
            erupcao_targets_x[0] = _player.x;
            erupcao_targets_y[0] = _player.y;
            for (var _e = 1; _e < erupcao_count; _e++) {
                var _ea = _pdir + ((_e mod 2 == 0) ? -1 : 1) * (40 + 40 * floor((_e - 1) / 2));
                var _ed = 90 + 30 * floor((_e - 1) / 2);
                erupcao_targets_x[_e] = _player.x + lengthdir_x(_ed, _ea);
                erupcao_targets_y[_e] = _player.y + lengthdir_y(_ed, _ea);
            }
        } else if (_next == "fan") {
            state = "fan_windup";
            charge_windup_timer = 0.5;
        } else {
            state = "charge_windup";
            charge_windup_timer = (boss_phase >= 3) ? 0.75 : 0.95;
            charge_dir = point_direction(x, y, _player.x, _player.y);
            rebound_done = false;
        }
        break;

    case "erupcao_windup":
        erupcao_timer -= _dt;
        body_colour = c_orange;
        if (random(1) < 0.4) fx_spawn_sparks(x, y, c_yellow, 2);
        if (erupcao_timer <= 0) {
            trigger_hitstop(0.06);
            var _hit_once = false;
            for (var _i = 0; _i < erupcao_count; _i++) {
                var _tx = erupcao_targets_x[_i];
                var _ty = erupcao_targets_y[_i];
                fx_spawn_sparks(_tx, _ty, c_red, 16);
                fx_spawn_sparks(_tx, _ty, c_orange, 12);
                var _g = elem_spawn_ground(_tx, _ty, "fire", 40, 4.0);
                _g.damage = 6;
                if (!_hit_once && _player != noone && point_distance(_player.x, _player.y, _tx, _ty) <= erupcao_radius) {
                    _hit_once = true;
                    player_take_damage(erupcao_damage, "magical");
                    player_apply_poison(4, 0.5, 3.0);
                }
            }
            sfx_play("slam", 0.05, 0.8);
            state = "recover";
            recover_timer = 0.6;
        }
        break;

    case "fan_windup":
        charge_windup_timer -= _dt;
        body_colour = c_yellow;
        if (charge_windup_timer <= 0) {
            for (var _f = -2; _f <= 2; _f++) {
                var _s = elem_spawn_missile(x, y, "fire_shot", facing_dir + _f * 14, 280, 24, make_colour_rgb(255, 120, 30));
                _s.life = 1.6;
                _s.radius = 10;
            }
            sfx_play("magic", 0.05, 0.9);
            state = "recover";
            recover_timer = 0.5;
        }
        break;

    case "charge_windup":
        charge_windup_timer -= _dt;
        body_colour = c_yellow;
        scale_y = 0.8;
        scale_x = 1.3;
        // Mira acompanha o jogador ate os ultimos 0.35s, depois TRAVA
        if (_player != noone && charge_windup_timer > 0.35) {
            charge_dir += clamp(angle_difference(point_direction(x, y, _player.x, _player.y), charge_dir), -180 * _dt, 180 * _dt);
        }
        facing_dir = charge_dir;
        if (random(1) < 0.5) fx_spawn_sparks(x - lengthdir_x(body_radius, charge_dir), y - lengthdir_y(body_radius, charge_dir), c_orange, 1);
        if (charge_windup_timer <= 0) {
            state = "charge";
            charge_timer = charge_max_time;
            charge_hit = false;
            sfx_play("slam", 0.1, 0.5);
            fx_spawn_sparks(x, y, c_red, 12);
        }
        break;

    case "charge":
        charge_timer -= _dt;
        var _ox = x;
        var _oy = y;
        var _step = charge_speed * _dt;
        fh_move_and_collide(lengthdir_x(_step, charge_dir), lengthdir_y(_step, charge_dir));
        if (random(1) < 0.6) fx_spawn_sparks(x, y, c_orange, 3);

        // Fase 2+: rastro de fogo
        if (boss_phase >= 2) {
            fire_trail_timer -= _dt;
            if (fire_trail_timer <= 0) {
                fire_trail_timer = 0.07;
                var _tg = elem_spawn_ground(x, y, "fire", 26, 3.0);
                _tg.damage = 5;
            }
        }

        // Cavaleiro com o ESCUDO erguido segura a investida
        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius
            && _player.character_class == "knight" && _player.state == "defend" && _player.defend_active
            && (_player.defend_mode == "block" || _player.defend_mode == "guardian_aegis")) {
            trigger_hitstop(0.15);
            trigger_camera_shake(12);
            sfx_play("parry", 0.02, 1.0);
            sfx_play("slam", 0.02, 0.8);
            fx_spawn_death_burst(_player.x, _player.y, c_yellow, 20);
            if (_player.defend_mode == "guardian_aegis") {
                // Guardiao: muralha viva - nao recua, nao sofre dano, o General fica atordoado como se batesse na parede
                state = "crashed";
                boss_open_window(crash_duration);
                fx_spawn_damage_popup(x, y - body_radius - 30, "MURALHA INABALAVEL! ATAQUE!", true, c_yellow);
            } else {
                // Cavaleiro comum: segura, mas e arrastado e sente o impacto (dano reduzido pelo bloqueio)
                player_take_damage(charge_damage, "physical");
                elem_push_player(charge_dir, 420);
                state = "crashed";
                boss_open_window(2.0);
                fx_spawn_damage_popup(x, y - body_radius - 30, "INVESTIDA CONTIDA!", true, c_yellow);
            }
            break;
        }

        // Acertou o jogador: para e NAO fica exposto
        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius) {
            player_take_damage(charge_damage, "physical");
            player_apply_poison(4, 0.5, 3.0);
            elem_push_player(charge_dir + choose(-90, 90), 380);
            fx_spawn_damage_popup(x, y - body_radius - 30, "ESMAGADO!", false, c_red);
            state = "recover";
            recover_timer = 1.0;
            break;
        }

        // Bateu na parede?
        var _moved = point_distance(_ox, _oy, x, y);
        if (_moved < _step * 0.75) {
            trigger_hitstop(0.12);
            trigger_camera_shake(12);
            sfx_play("slam", 0.02, 1.0);
            fx_spawn_death_burst(x + lengthdir_x(body_radius, charge_dir), y + lengthdir_y(body_radius, charge_dir), c_orange, 24);
            if (boss_phase >= 3 && !rebound_done) {
                // Fase 3: ricocheteia e investe de novo
                rebound_done = true;
                state = "charge_windup";
                charge_windup_timer = 0.5;
                charge_dir = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : charge_dir + 180;
                fx_spawn_damage_popup(x, y - body_radius - 30, "RICOCHETE!", true, c_orange);
            } else {
                state = "crashed";
                boss_open_window(crash_duration);
                fx_spawn_damage_popup(x, y - body_radius - 30, "CROSTA RACHADA! ATAQUE!", true, c_yellow);
                // Fase 2+: o impacto derruba pedras incandescentes do teto
                if (boss_phase >= 2 && _player != noone) {
                    for (var _m = 0; _m < 3; _m++) {
                        var _met = elem_spawn_missile(x, y, "meteor", 0, 0, 18, make_colour_rgb(255, 120, 30));
                        _met.delay = 0.3 + _m * 0.6;
                    }
                }
            }
            break;
        }

        if (charge_timer <= 0) {
            state = "recover";
            recover_timer = 0.9;
        }
        break;
}
