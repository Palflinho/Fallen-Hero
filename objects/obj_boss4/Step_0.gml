// ---------------------------------------------------------------------
// TITA MONOLITO - "COSTAS EXPOSTAS"
//  - FRENTE blindada (ricochete). NUCLEO nas costas: rodeie-o.
//  - Gira devagar para te encarar (mais rapido a cada fase).
//  - VARREDURA: cone na frente dele.
//  - PISAO: so quando voce esta perto; onda de choque em anel e depois fica
//    PRESO AO CHAO 3.2s com a couraca aberta (janela +50% em qualquer lado).
//  - Fase 2: muralhas atras de si + pedregulhos. Fase 3: GIRO 360 se voce acampar nas costas.
// ---------------------------------------------------------------------
event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);
knockback_resistance = 1.0;

boss_update_phase();

if (attack_cd > 0) attack_cd -= _dt;
if (stomp_cd > 0) stomp_cd -= _dt;

// Onda de choque do pisao
if (ring_active) {
    ring_r += 280 * _dt;
    if (!ring_hit && _player != noone) {
        var _rd = point_distance(x, y, _player.x, _player.y);
        if (abs(_rd - ring_r) <= 12 + _player.body_radius) {
            ring_hit = true;
            player_take_damage(30, "physical");
            elem_push_player(point_direction(x, y, _player.x, _player.y), 280);
        }
    }
    if (ring_r >= ring_max) ring_active = false;
}

var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;
var _to = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : facing_dir;
var _off = abs(angle_difference(facing_dir, _to));
var _in_front = (_off <= 60);
if (_off > 110) behind_timer += _dt; else behind_timer = 0;

// ---- Janela: preso ao chao com a couraca aberta ----
if (vulnerable) {
    vulnerable_timer -= _dt;
    fh_shell_hits = 0;
    scale_x = 0.92;
    scale_y = 0.92;
    if (random(1) < 0.3) fx_spawn_sparks(x + random_range(-25, 25), y + random_range(-25, 25), c_yellow, 2);
    if (vulnerable_timer <= 0) {
        boss_close_window();
        fh_shell_hits = 99999;
        state = "chase";
        attack_cd = 0.8;
        stomp_cd = (boss_phase >= 2) ? 4.0 : 5.0;
        fx_spawn_death_burst(x, y, make_colour_rgb(140, 100, 60), 16);
        trigger_hitstop(0.08);
    }
    exit;
}

switch (state) {
    case "chase":
        damage_reduction = boss_chip;
        if (_player == noone || _player.invisible) break;
        // Gira devagar para encarar o jogador
        facing_dir += clamp(angle_difference(_to, facing_dir), -turn_rates[boss_phase] * _dt, turn_rates[boss_phase] * _dt);
        facing_dir = (facing_dir + 360) mod 360;
        if (_dist > 120) fh_move_and_collide(lengthdir_x(move_speed * _dt, _to), lengthdir_y(move_speed * _dt, _to));

        if (attack_cd > 0) break;
        if (boss_phase >= 3 && behind_timer >= 1.2) {
            state = "spin_windup";
            action_timer = 0.6;
        } else if (_dist <= 210 && stomp_cd <= 0) {
            state = "windup";
            stomp_windup_timer = stomp_windup;
        } else if (_in_front && _dist <= sweep_radius) {
            state = "sweep_windup";
            action_timer = sweep_windup;
        } else if (boss_phase >= 2) {
            throw_toggle = !throw_toggle;
            state = throw_toggle ? "throw_windup" : "wall_windup";
            action_timer = 0.6;
        } else if (_dist > 220) {
            // Fase 1 a distancia: trio de pedregulhos rasteiros
            for (var _b = -1; _b <= 1; _b++) {
                elem_spawn_projectile(x, y, _to + _b * 22, 220, 28, make_colour_rgb(180, 140, 90), "physical");
            }
            attack_cd = 2.0;
        }
        break;

    case "sweep_windup":
        action_timer -= _dt;
        scale_x = 1.2;
        scale_y = 0.9;
        if (action_timer <= 0) {
            if (_player != noone && _dist <= sweep_radius + _player.body_radius && abs(angle_difference(facing_dir, _to)) <= sweep_arc) {
                player_take_damage(46, "physical");
                elem_push_player(_to, 340);
            }
            fx_spawn_sparks(x + lengthdir_x(sweep_radius * 0.7, facing_dir), y + lengthdir_y(sweep_radius * 0.7, facing_dir), make_colour_rgb(180, 130, 70), 16);
            trigger_camera_shake(5);
            sfx_play("slam", 0.1, 0.7);
            state = "recover";
            action_timer = 0.6;
        }
        break;

    case "windup":
        // Pisao (o "!" e o circulo vermelho avisam)
        stomp_windup_timer -= _dt;
        scale_x = 1.35;
        scale_y = 1.35;
        if (random(1) < 0.5) fx_spawn_sparks(x + random_range(-35, 35), y + body_radius, make_colour_rgb(160, 110, 60), 3);
        if (stomp_windup_timer <= 0) {
            trigger_hitstop(0.12);
            trigger_camera_shake(10);
            sfx_play("slam", 0.02, 1.0);
            fx_spawn_death_burst(x, y + body_radius, make_colour_rgb(180, 130, 70), 24);
            elem_hit_player_circle(x, y, stomp_hit_radius, stomp_damage, "physical");
            ring_active = true;
            ring_r = stomp_hit_radius;
            ring_hit = false;
            if (boss_phase >= 2) {
                for (var _a = 0; _a < 8; _a++) {
                    elem_spawn_projectile(x, y, _a * 45 + 22.5, 240, 30, make_colour_rgb(200, 160, 100), "physical");
                }
            }
            state = "stuck";
            boss_open_window(stuck_duration);
            fh_shell_hits = 0;
            fx_spawn_damage_popup(x, y - body_radius - 30, "PRESO AO CHAO! ATAQUE!", true, c_yellow);
            scale_x = 0.85;
            scale_y = 0.85;
        }
        break;

    case "throw_windup":
        action_timer -= _dt;
        scale_x = 1.1;
        scale_y = 1.25;
        if (action_timer <= 0) {
            if (_player != noone) {
                var _bl = elem_spawn_missile(x, y - body_radius, "boulder", 0, 0, 34, make_colour_rgb(170, 125, 70));
                _bl.target_x = _player.x;
                _bl.target_y = _player.y;
                _bl.flight_time = 0.9;
            }
            state = "recover";
            action_timer = 0.5;
        }
        break;

    case "wall_windup":
        action_timer -= _dt;
        scale_x = 1.25;
        scale_y = 0.8;
        if (action_timer <= 0) {
            // Muralhas diagonais atras de si: dificultam rodea-lo
            for (var _w = -1; _w <= 1; _w += 2) {
                var _wa = facing_dir + 180 + _w * 55;
                elem_raise_wall(x + lengthdir_x(body_radius + 60, _wa), y + lengthdir_y(body_radius + 60, _wa), 1, 2, 5.0);
            }
            trigger_camera_shake(4);
            sfx_play("slam", 0.1, 0.6);
            state = "recover";
            action_timer = 0.4;
        }
        break;

    case "spin_windup":
        action_timer -= _dt;
        scale_x = 1.3;
        scale_y = 0.8;
        facing_dir = (facing_dir + 60 * _dt) mod 360;
        if (action_timer <= 0) {
            elem_hit_player_circle(x, y, spin_radius, 40, "physical");
            if (_player != noone && _dist <= spin_radius + 40) elem_push_player(_to, 360);
            facing_dir = _to; // termina de frente para o jogador
            behind_timer = 0;
            fx_spawn_death_burst(x, y, make_colour_rgb(180, 130, 70), 18);
            trigger_camera_shake(6);
            sfx_play("slam", 0.05, 0.8);
            state = "recover";
            action_timer = 0.7;
        }
        break;

    case "recover":
        action_timer -= _dt;
        if (action_timer <= 0) {
            state = "chase";
            attack_cd = (boss_phase >= 3) ? 0.8 : 1.2;
        }
        break;

    default:
        state = "chase";
        break;
}
