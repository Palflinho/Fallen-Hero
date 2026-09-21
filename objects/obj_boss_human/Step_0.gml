event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

// 1. Diálogo de Introdução Dramático
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

// 2. Estado de Vulnerabilidade (Exoesqueleto superaquecido)
if (state == "vulnerable") {
    vulnerable_timer -= _dt;
    damage_reduction = 1.0;
    vulnerable = true;
    body_colour = make_colour_rgb(180, 50, 50); // Alerta vermelho de superaquecimento

    // Faíscas e fumaça saindo das engrenagens
    if (random(1) < 0.4) {
        var _sa = random(360);
        var _sr = random_range(10, body_radius);
        fx_spawn_sparks(x + lengthdir_x(_sr, _sa), y + lengthdir_y(_sr, _sa), c_orange, 2);
    }

    if (vulnerable_timer <= 0) {
        vulnerable = false;
        damage_reduction = 0;
        state = "combat_hover";
        body_colour = make_colour_rgb(60, 75, 95);
        sfx_play("energy_shield", 0.06, 0.9);
        trigger_camera_shake(4);
        fx_spawn_sparks(x, y, accent_colour, 18);
    }
    exit;
}

// 3. Atualização de Drones Orbitais
drone_angle += 140 * _dt;
if (drones_active) {
    drone_shot_timer -= _dt;
    if (drone_shot_timer <= 0) {
        drone_shot_timer = 1.4;
        if (_player != noone && !_player.invisible) {
            for (var _d = 0; _d < 2; _d++) {
                var _da = drone_angle + _d * 180;
                var _dx = x + lengthdir_x(70, _da);
                var _dy = y + lengthdir_y(70, _da);
                var _proj_dir = point_direction(_dx, _dy, _player.x, _player.y);
                var _p = instance_create_layer(_dx, _dy, layer, obj_enemy_projectile);
                _p.owner = id;
                _p.damage = 16;
                _p.dir_x = lengthdir_x(1, _proj_dir);
                _p.dir_y = lengthdir_y(1, _proj_dir);
                _p.speed_px = 280;
                _p.colour = accent_colour;
                _p.damage_type = "magical";
            }
            sfx_play("laser_beam", 0.04, 1.4);
        }
    }
}

// 4. Temporizador de Escudo de Energia
if (shield_active) {
    shield_timer -= _dt;
    damage_reduction = 0.80; // Reduz dano em 80% enquanto o escudo vibra
    if (random(1) < 0.3) {
        fx_spawn_sparks(x + random_range(-50, 50), y + random_range(-50, 50), accent_colour, 1);
    }
    if (shield_timer <= 0) {
        shield_active = false;
        drones_active = false;
        damage_reduction = 0;
        // Ao fim do escudo, fica superaquecido brevemente!
        state = "vulnerable";
        vulnerable_timer = 2.5;
        sfx_play("thunder", 0.06, 1.2);
    }
} else {
    shield_cooldown_timer -= _dt;
    if (shield_cooldown_timer <= 0) {
        shield_cooldown_timer = shield_cooldown;
        shield_active = true;
        shield_timer = shield_max_duration;
        drones_active = true;
        sfx_play("energy_shield", 0.08, 0.7);
        fx_spawn_sparks(x, y, accent_colour, 24);
    }
}

// 5. Máquina de Combate
combat_timer += _dt;

switch (state) {
    case "combat_hover":
        if (_player != noone && !_player.invisible) {
            var _dist = point_distance(x, y, _player.x, _player.y);
            var _pdir = point_direction(x, y, _player.x, _player.y);
            facing_dir = _pdir;

            // Mantém distância média tática (200 - 320 px)
            if (_dist < 200) {
                // Afasta-se
                fh_move_and_collide(lengthdir_x(-move_speed * _dt, _pdir), lengthdir_y(-move_speed * _dt, _pdir));
            } else if (_dist > 320) {
                // Aproxima-se
                fh_move_and_collide(lengthdir_x(move_speed * _dt, _pdir), lengthdir_y(move_speed * _dt, _pdir));
            } else {
                // Órbita lateral
                var _strafe_dir = _pdir + 90;
                fh_move_and_collide(lengthdir_x(move_speed * 0.6 * _dt, _strafe_dir), lengthdir_y(move_speed * 0.6 * _dt, _strafe_dir));
            }

            // Disparo periódico de plasma padrão
            if (combat_timer >= 1.8) {
                combat_timer = 0;
                // Alterna entre disparar rajada tripla ou iniciar laser
                if (irandom(100) < 55) {
                    // Rajada de plasma tripla
                    for (var _i = -1; _i <= 1; _i++) {
                        var _ang = _pdir + _i * 18;
                        var _proj = instance_create_layer(x, y, layer, obj_enemy_projectile);
                        _proj.owner = id;
                        _proj.damage = 22;
                        _proj.dir_x = lengthdir_x(1, _ang);
                        _proj.dir_y = lengthdir_y(1, _ang);
                        _proj.speed_px = 320;
                        _proj.colour = c_aqua;
                        _proj.damage_type = "magical";
                    }
                    sfx_play("laser_beam", 0.05, 1.1);
                } else {
                    // Prepara disparo de Laser Pesado
                    state = "laser_charge";
                    laser_charge_timer = laser_charge_duration;
                    laser_target_x = _player.x;
                    laser_target_y = _player.y;
                    laser_angle = _pdir;
                    sfx_play("portal_hum", 0.06, 1.6);
                }
            }
        }
        break;

    case "laser_charge":
        laser_charge_timer -= _dt;
        // Trava a mira suavemente no jogador
        if (_player != noone) {
            var _desired_ang = point_direction(x, y, _player.x, _player.y);
            laser_angle += angle_difference(_desired_ang, laser_angle) * min(1.0, 3.5 * _dt);
            laser_target_x = x + lengthdir_x(800, laser_angle);
            laser_target_y = y + lengthdir_y(800, laser_angle);
        }

        // Faíscas no canhão
        if (random(1) < 0.6) {
            var _cx = x + lengthdir_x(36, laser_angle);
            var _cy = y + lengthdir_y(36, laser_angle);
            fx_spawn_sparks(_cx, _cy, c_red, 1);
        }

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

        // Efeito de feixe de laser constante
        var _lx1 = x + lengthdir_x(36, laser_angle);
        var _ly1 = y + lengthdir_y(36, laser_angle);
        var _lx2 = x + lengthdir_x(800, laser_angle);
        var _ly2 = y + lengthdir_y(800, laser_angle);

        // Checa colisão da linha com o jogador
        if (_player != noone && laser_damage_tick <= 0) {
            var _hit = collision_line(_lx1, _ly1, _lx2, _ly2, obj_player, false, false);
            if (_hit != noone) {
                laser_damage_tick = 0.2; // Dano em ticks contínuos
                player_take_damage(28, "magical");
                trigger_camera_shake(3);
                fx_spawn_sparks(_player.x, _player.y, c_aqua, 6);
            }
        }

        if (laser_fire_timer <= 0) {
            state = "combat_hover";
            combat_timer = 0;
        }
        break;
}
