event_inherited();
if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _player = instance_find(obj_player, 0);

if (_player != noone && !_player.invisible && state != "erupcao_windup" && state != "charge") {
    facing_dir = point_direction(x, y, _player.x, _player.y);
}

// ----------------------------------------------------
// JANELA DE VULNERABILIDADE: SUPERAQUECIMENTO
// ----------------------------------------------------
if (state == "overheat") {
    vulnerable_timer -= _dt;
    vulnerable = true;
    damage_reduction = 1.25; // Toma 125% de dano durante o superaquecimento!
    body_colour = c_orange;
    scale_y = 0.75 + 0.05 * sin(current_time * 0.03);
    scale_x = 1.25 - 0.05 * sin(current_time * 0.03);

    // Efeito de vapor e faíscas escapando
    if (random(1) < 0.6) {
        fx_spawn_sparks(x + random_range(-25, 25), y - body_radius * 0.5, c_white, 2);
        fx_spawn_sparks(x + random_range(-20, 20), y - body_radius * 0.5, c_yellow, 1);
    }

    if (vulnerable_timer <= 0) {
        vulnerable = false;
        damage_reduction = 0;
        state = "recover";
        recover_timer = 1.2;
        combo_cycle = 0;
        body_colour = c_red;
        scale_x = 1.0;
        scale_y = 1.0;

        // Erupção de resfriamento / Onda de choque de vapor
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
        damage_reduction = 0;
        if (_player != noone && !_player.invisible) {
            var _dist = point_distance(x, y, _player.x, _player.y);
            if (_dist > 220) {
                var _dir = point_direction(x, y, _player.x, _player.y);
                fh_move_and_collide(lengthdir_x(move_speed * _dt, _dir), lengthdir_y(move_speed * _dt, _dir));
            }

            if (attack_cooldown_timer <= 0 && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
                if (combo_cycle mod 2 == 0) {
                    // Ataque 1: Inicia Erupção de Magma Tripla
                    state = "erupcao_windup";
                    erupcao_timer = erupcao_telegraph;
                    scale_y = 1.35;
                    scale_x = 0.85;

                    // Marca 3 posições: no jogador e ao redor dele
                    var _pdir = point_direction(x, y, _player.x, _player.y);
                    erupcao_targets_x[0] = _player.x;
                    erupcao_targets_y[0] = _player.y;
                    erupcao_targets_x[1] = _player.x + lengthdir_x(90, _pdir + 60);
                    erupcao_targets_y[1] = _player.y + lengthdir_y(90, _pdir + 60);
                    erupcao_targets_x[2] = _player.x + lengthdir_x(90, _pdir - 60);
                    erupcao_targets_y[2] = _player.y + lengthdir_y(90, _pdir - 60);
                } else {
                    // Ataque 2: Carga de Fúria em Linha Reta
                    state = "charge_windup";
                    charge_windup_timer = charge_windup;
                    scale_y = 1.35;
                    scale_x = 1.35;
                    body_colour = c_yellow;
                }
            }
        }
        break;

    case "erupcao_windup":
        erupcao_timer -= _dt;
        body_colour = c_orange;
        if (random(1) < 0.4) {
            fx_spawn_sparks(x, y, c_yellow, 2);
        }

        if (erupcao_timer <= 0) {
            // Detonação das erupções de magma nos 3 pontos telegrafados
            trigger_hitstop(0.06);
            for (var _i = 0; _i < 3; _i++) {
                var _tx = erupcao_targets_x[_i];
                var _ty = erupcao_targets_y[_i];
                fx_spawn_sparks(_tx, _ty, c_red, 16);
                fx_spawn_sparks(_tx, _ty, c_orange, 12);
                if (_player != noone && point_distance(_player.x, _player.y, _tx, _ty) <= erupcao_radius && !fh_line_intersects_wall(_tx, _ty, _player.x, _player.y)) {
                    player_take_damage(erupcao_damage, "magical");
                    player_apply_poison(4, 0.5, 3.0);
                }
            }

            combo_cycle++;
            state = "chase";
            attack_cooldown_timer = 0.6;
        }
        break;

    case "charge_windup":
        charge_windup_timer -= _dt;
        if (charge_windup_timer <= 0) {
            state = "charge";
            charge_timer = 0.40;
            var _cdir = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : facing_dir;
            charge_vx = lengthdir_x(520, _cdir);
            charge_vy = lengthdir_y(520, _cdir);
            fx_spawn_sparks(x, y, c_red, 12);
        }
        break;

    case "charge":
        charge_timer -= _dt;
        fh_move_and_collide(charge_vx * _dt, charge_vy * _dt);

        if (random(1) < 0.6) {
            fx_spawn_sparks(x, y, c_orange, 3);
        }

        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            player_take_damage(charge_damage, "physical");
            player_apply_poison(4, 0.5, 3.0);
        }

        if (charge_timer <= 0) {
            combo_cycle++;
            trigger_hitstop(0.08);
            fx_spawn_sparks(x, y, c_red, 14);

            // Após completar 4 etapas (2 erupções + 2 cargas), entra em Superaquecimento!
            if (combo_cycle >= 4) {
                state = "overheat";
                vulnerable = true;
                vulnerable_timer = vulnerable_duration;
                damage_reduction = 1.25;
            } else {
                state = "recover";
                recover_timer = 0.7;
            }
        }
        break;
}
