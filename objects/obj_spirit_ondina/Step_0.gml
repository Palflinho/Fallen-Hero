// ---------------------------------------------------------------------
// ONDINA, ESPIRITO DA AGUA (Chefe da Arena Glacial)
//  - Leque de agua (5 gotas).
//  - CLONES DE AGUA: cria 2 copias e troca de lugar com uma delas.
//    Clones morrem com 1 golpe. Dica: a verdadeira brilha mais forte.
//  - Fase 2 (50%): CURA canalizada (interrompa com dano! -> atordoada)
//    e cruz de gelo "+" sob o jogador.
// ---------------------------------------------------------------------
if (!is_world_paused() && hp <= 0 && !is_clone) {
    with (obj_spirit_ondina) if (is_clone) instance_destroy();
}

event_inherited();
if (is_world_paused() || hp <= 0) exit;

var _dt = delta_time / 1000000;
var _player = elem_player();

// ---- Clone: gotas fracas, some sozinho ----
if (is_clone) {
    clone_life -= _dt;
    draw_alpha = 0.78 + 0.1 * sin(current_time * 0.02);
    if (!instance_exists(master) || clone_life <= 0) {
        fx_spawn_sparks(x, y, c_aqua, 10);
        instance_destroy();
        exit;
    }
}

if (spirit_update_intro(_dt)) exit;
if (!is_clone && spirit_check_phase2()) {
    action_timer = 0.6;
}

if (clone_cd > 0) clone_cd -= _dt;
if (heal_cd > 0) heal_cd -= _dt;
if (state == "patrol" || state == "chase") state = "idle";

var _dmg_this_frame = max(0, last_hp - hp);
last_hp = hp;

switch (state) {
    case "idle":
        body_colour = elem_colour("water");
        if (_player == noone) break;
        facing_dir = point_direction(x, y, _player.x, _player.y);
        // desliza orbitando o jogador a meia distancia
        var _d = point_distance(x, y, _player.x, _player.y);
        var _want = facing_dir + (_d > 190 ? 0 : (_d < 140 ? 180 : 90 * orbit_side));
        ai_enemy_move(_want, move_speed_effective, _dt);
        if (random(1) < 0.005) orbit_side = -orbit_side;

        action_timer -= _dt;
        if (action_timer <= 0) {
            if (is_clone) {
                state = "fan_windup";
                state_timer = 0.7;
            } else if (phase2 && heal_cd <= 0 && hp < hp_max * 0.7) {
                state = "heal";
                heal_timer = 2.2;
                heal_tick = 0;
                heal_dmg_taken = 0;
                fx_spawn_damage_popup(x, y - 40, "ONDINA ESTA SE CURANDO!", true, c_aqua);
                sfx_play("pedestal_light", 0.05, 0.7);
            } else if (clone_cd <= 0 && instance_number(obj_spirit_ondina) <= 1) {
                state = "clone_windup";
                state_timer = 0.8;
            } else if (phase2 && random(1) < 0.4) {
                state = "cross_windup";
                state_timer = 0.5;
            } else {
                state = "fan_windup";
                state_timer = 0.5;
            }
        }
        break;

    case "fan_windup":
        state_timer -= _dt;
        body_colour = c_white;
        scale_x = 1.2;
        scale_y = 1.2;
        if (state_timer <= 0) {
            if (_player != noone) {
                var _base = point_direction(x, y, _player.x, _player.y);
                var _n = phase2 ? 7 : 5;
                var _dmg = is_clone ? elem_dmg(5) : elem_dmg(10);
                for (var _i = 0; _i < _n; _i++) {
                    var _a = _base + (_i - (_n - 1) * 0.5) * 14;
                    elem_spawn_projectile(x, y, _a, 230, _dmg, is_clone ? make_colour_rgb(160, 220, 255) : c_aqua, "magical");
                }
            }
            sfx_play("magic", 0.1, 0.5);
            state = "idle";
            action_timer = is_clone ? 2.2 : (phase2 ? 1.1 : 1.5);
        }
        break;

    case "clone_windup":
        state_timer -= _dt;
        body_colour = c_white;
        scale_x = 0.8;
        scale_y = 1.3;
        if (state_timer <= 0) {
            var _spots = [];
            for (var _c = 0; _c < 2; _c++) {
                var _pt = (_player != noone) ? elem_find_point_around(_player.x, _player.y, 150, 210, body_radius) : elem_find_point_around(x, y, 120, 180, body_radius);
                var _cl = instance_create_layer(_pt.x, _pt.y, layer, obj_spirit_ondina);
                _cl.is_clone = true;
                _cl.master = id;
                _cl.clone_life = 9.0;
                _cl.stats_scaled = true;
                _cl.atk_scale = atk_scale;
                _cl.hp_max = 1;
                _cl.hp = 1;
                _cl.hp_lag = 1;
                _cl.exp_reward = 0;
                _cl.gold_reward = 0;
                _cl.is_spirit_boss = false;
                _cl.state = "intro";
                _cl.state_timer = 0.4;
                _cl.action_timer = 1.0 + _c * 0.6;
                array_push(_spots, _cl);
            }
            // Troca de lugar com um dos clones (confunde o jogador)
            var _swap = _spots[irandom(1)];
            var _ox = x;
            var _oy = y;
            x = _swap.x;
            y = _swap.y;
            _swap.x = _ox;
            _swap.y = _oy;
            fx_spawn_sparks(x, y, c_aqua, 14);
            fx_spawn_sparks(_ox, _oy, c_aqua, 14);
            sfx_play("magic", 0.05, 0.7);
            clone_cd = phase2 ? 9.0 : 12.0;
            state = "exposed";
            state_timer = 1.0;
            fh_vuln_timer = 1.0;
        }
        break;

    case "cross_windup":
        state_timer -= _dt;
        body_colour = c_white;
        if (state_timer <= 0) {
            if (_player != noone) {
                var _cr = elem_spawn_missile(_player.x, _player.y, "ice_cross", 0, 0, elem_dmg(14), make_colour_rgb(170, 230, 255));
                _cr.target_x = _player.x;
                _cr.target_y = _player.y;
                _cr.cell_arm = 4;
            }
            state = "idle";
            action_timer = 1.0;
        }
        break;

    case "heal":
        heal_timer -= _dt;
        heal_tick -= _dt;
        heal_dmg_taken += _dmg_this_frame;
        body_colour = merge_colour(c_aqua, c_white, 0.5 + 0.5 * sin(current_time * 0.02));
        if (heal_tick <= 0) {
            heal_tick = 0.25;
            var _h = max(1, round(hp_max * 0.025));
            hp = min(hp_max, hp + _h);
            last_hp = hp;
            fx_spawn_damage_popup(x, y - 30, "+" + string(_h), false, c_aqua);
        }
        if (heal_dmg_taken >= hp_max * 0.08) {
            // Interrompida!
            state = "exposed";
            state_timer = 2.0;
            fh_vuln_timer = 2.0;
            heal_cd = 12.0;
            fx_spawn_damage_popup(x, y - 44, "INTERROMPIDA!", true, c_yellow);
            trigger_hitstop(0.08);
            sfx_play("stagger", 0.04);
        } else if (heal_timer <= 0) {
            state = "idle";
            action_timer = 1.0;
            heal_cd = 12.0;
        }
        break;

    case "exposed":
        state_timer -= _dt;
        scale_x = 1.15;
        scale_y = 0.85;
        if (state_timer <= 0) {
            state = "idle";
            action_timer = 0.8;
        }
        break;
}
