// ---------------------------------------------------------------------
// O SALVADOR - "PROTOCOLO DE DRONES"
//  - ESCUDO: ativo enquanto houver DRONES vivos (recebe so 10% do dano).
//    Destrua todos os drones -> SOBRECARGA 4.5s (janela +50%).
//  - PLASMA: rajada tripla.
//  - LASER: mira e dispara. Fase 2 o feixe VARRE; fase 3 sao DOIS feixes girando.
//  - ATAQUE ORBITAL (fase 2+): 5 impactos marcados que seguem o jogador.
// ---------------------------------------------------------------------
event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

// 1. Dialogo de introducao dramatico
if (!dialogue_triggered) {
    dialogue_triggered = true;
    state = "dialogue_wait";
    dialogue_play_id("temple5_human_boss", function() {
        if (instance_exists(obj_boss_human)) {
            with (obj_boss_human) {
                state = "combat_hover";
                combat_timer = 0;
                sfx_play("laser_beam", 0.08, 1.2);
                trigger_camera_shake(6);
            }
        }
    });
    exit;
}

if (dialogue_is_active()) exit;

boss_update_phase();
drone_angle += 140 * _dt;
drones_active = false; // drones agora sao objetos reais (obj_boss_drone)

// 2. Sobrecarga (janela de dano)
if (vulnerable) {
    vulnerable_timer -= _dt;
    shield_active = false;
    body_colour = make_colour_rgb(180, 50, 50);
    if (random(1) < 0.4) {
        var _sa = random(360);
        var _sr = random_range(10, body_radius);
        fx_spawn_sparks(x + lengthdir_x(_sr, _sa), y + lengthdir_y(_sr, _sa), c_orange, 2);
    }
    if (vulnerable_timer <= 0) {
        boss_close_window();
        state = "combat_hover";
        combat_timer = 0;
        body_colour = make_colour_rgb(60, 75, 95);
        deploy_timer = 1.0;
        sfx_play("energy_shield", 0.06, 0.9);
        trigger_camera_shake(4);
        fx_spawn_sparks(x, y, accent_colour, 18);
    }
    exit;
}

// 3. Escudo alimentado pelos drones
var _drones = instance_number(obj_boss_drone);
shield_active = (_drones > 0);
if (drones_deployed && _drones == 0) {
    // Todos os drones destruidos: SOBRECARGA!
    drones_deployed = false;
    state = "overload";
    laser_charging = false;
    boss_open_window(overload_duration);
    fx_spawn_damage_popup(x, y - body_radius - 30, "SOBRECARGA! ESCUDO CAIU!", true, c_yellow);
    fx_spawn_death_burst(x, y, accent_colour, 24);
    trigger_hitstop(0.12);
    trigger_camera_shake(8);
    sfx_play("thunder", 0.06, 1.2);
    exit;
}
if (!drones_deployed) {
    deploy_timer -= _dt;
    if (deploy_timer <= 0) {
        drones_deployed = true;
        var _n = 1 + boss_phase;
        for (var _d = 0; _d < _n; _d++) {
            var _dr = instance_create_layer(x, y, layer, obj_boss_drone);
            _dr.owner = id;
            _dr.orbit_angle = drone_angle + _d * (360 / _n);
        }
        sfx_play("energy_shield", 0.08, 0.7);
        fx_spawn_sparks(x, y, accent_colour, 24);
    }
}
damage_reduction = shield_active ? boss_chip : 0.5;
if (shield_active && random(1) < 0.3) fx_spawn_sparks(x + random_range(-50, 50), y + random_range(-50, 50), accent_colour, 1);

// 4. Maquina de combate
combat_timer += _dt;

switch (state) {
    case "combat_hover":
        if (_player == noone || _player.invisible) break;
        var _dist = point_distance(x, y, _player.x, _player.y);
        var _pdir = point_direction(x, y, _player.x, _player.y);
        facing_dir = _pdir;

        // Mantem distancia media tatica (200 - 320 px)
        if (_dist < 200) {
            fh_move_and_collide(lengthdir_x(-move_speed * _dt, _pdir), lengthdir_y(-move_speed * _dt, _pdir));
        } else if (_dist > 320) {
            fh_move_and_collide(lengthdir_x(move_speed * _dt, _pdir), lengthdir_y(move_speed * _dt, _pdir));
        } else {
            var _strafe_dir = _pdir + 90;
            fh_move_and_collide(lengthdir_x(move_speed * 0.6 * _dt, _strafe_dir), lengthdir_y(move_speed * 0.6 * _dt, _strafe_dir));
        }

        if (combat_timer >= ((boss_phase >= 3) ? 1.4 : 1.8)) {
            combat_timer = 0;
            var _roll = irandom(99);
            if (boss_phase >= 2 && _roll < 25) {
                // Ataque orbital: impactos marcados em sequencia sobre o jogador
                for (var _o = 0; _o < orbital_count; _o++) {
                    var _met = elem_spawn_missile(x, y, "meteor", 0, 0, 24, accent_colour);
                    _met.delay = 0.01 + _o * 0.35;
                }
                sfx_play("portal_hum", 0.06, 1.4);
                fx_spawn_damage_popup(x, y - body_radius - 30, "ATAQUE ORBITAL!", false, accent_colour);
            } else if (_roll < 60) {
                for (var _i = -1; _i <= 1; _i++) {
                    elem_spawn_projectile(x, y, _pdir + _i * 18, 320, 22, c_aqua, "magical");
                }
                sfx_play("laser_beam", 0.05, 1.1);
            } else {
                state = "laser_charge";
                laser_charge_timer = laser_charge_duration;
                laser_angle = _pdir;
                laser_sweep_dir = choose(-1, 1);
                sfx_play("portal_hum", 0.06, 1.6);
            }
        }
        break;

    case "laser_charge":
        laser_charge_timer -= _dt;
        if (_player != noone) {
            var _desired_ang = point_direction(x, y, _player.x, _player.y);
            // Na fase 2+ mira um pouco ao lado: o feixe vai varrer ATE o jogador
            if (boss_phase >= 2) _desired_ang -= laser_sweep_dir * 40;
            laser_angle += angle_difference(_desired_ang, laser_angle) * min(1.0, 3.5 * _dt);
        }
        if (random(1) < 0.6) fx_spawn_sparks(x + lengthdir_x(36, laser_angle), y + lengthdir_y(36, laser_angle), c_red, 1);
        if (laser_charge_timer <= 0) {
            state = "laser_fire";
            laser_fire_timer = laser_fire_duration;
            laser_damage_tick = 0;
            sfx_play("laser_beam", 0.09, 0.7);
            trigger_camera_shake(5);
        }
        break;

    case "laser_fire":
        laser_fire_timer -= _dt;
        laser_damage_tick -= _dt;
        if (boss_phase >= 2) laser_angle += laser_sweep_dir * ((boss_phase >= 3) ? 75 : 60) * _dt;

        if (_player != noone && laser_damage_tick <= 0) {
            var _beams = (boss_phase >= 3) ? 2 : 1;
            for (var _b = 0; _b < _beams; _b++) {
                var _ba = laser_angle + _b * 180;
                var _d2 = elem_point_segment_dist(_player.x, _player.y, x + lengthdir_x(36, _ba), y + lengthdir_y(36, _ba), x + lengthdir_x(900, _ba), y + lengthdir_y(900, _ba));
                if (_d2 <= 8 + _player.body_radius) {
                    laser_damage_tick = 0.25;
                    player_take_damage(26, "magical");
                    trigger_camera_shake(3);
                    fx_spawn_sparks(_player.x, _player.y, c_aqua, 6);
                    break;
                }
            }
        }
        if (laser_fire_timer <= 0) {
            state = "combat_hover";
            combat_timer = 0;
        }
        break;

    default:
        state = "combat_hover";
        break;
}
