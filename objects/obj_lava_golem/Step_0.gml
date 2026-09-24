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
if (state == "vulnerable") {
    vulnerable_timer -= _dt;
    vulnerable = true;
    damage_reduction = 1.0; // 100% de dano sofrido!
    body_colour = c_lime;
    scale_y = 0.80;
    scale_x = 1.20;

    if (random(1) < 0.35) {
        fx_spawn_sparks(x + random_range(-15, 15), y - body_radius - 8, c_yellow, 1);
        fx_spawn_sparks(x + random_range(-15, 15), y - body_radius - 8, c_white, 1);
    }

    if (vulnerable_timer <= 0) {
        vulnerable = false;
        damage_reduction = 0.35;
        state = "chase";
        combo_count = 0;
        attack_cooldown_timer = 1.5;
        body_colour = c_maroon;
        scale_x = 1.0;
        scale_y = 1.0;

        trigger_hitstop(0.05);
        fx_spawn_sparks(x, y, c_red, 14);
    }
    exit;
}

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

switch (state) {
    case "chase":
        body_colour = c_maroon;
        damage_reduction = 0.35;
        if (_player != noone && !_player.invisible) {
            var _dist = point_distance(x, y, _player.x, _player.y);
            var _dir = point_direction(x, y, _player.x, _player.y);

            if (_dist > 120) {
                ai_enemy_move(_dir, move_speed * _dt * 60, _dt);
            }

            if (attack_cooldown_timer <= 0 && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
                if (combo_count == 0) {
                    // 1. Erupção Magmática Telegrafada
                    state = "erupcao_windup";
                    erupcao_timer = erupcao_telegraph;
                    scale_y = 1.30;
                    scale_x = 0.90;
                    body_colour = c_orange;

                    var _pdir = point_direction(x, y, _player.x, _player.y);
                    erupcao_targets_x[0] = _player.x;
                    erupcao_targets_y[0] = _player.y;
                    erupcao_targets_x[1] = _player.x + lengthdir_x(70, _pdir + 45);
                    erupcao_targets_y[1] = _player.y + lengthdir_y(70, _pdir + 45);
                } else {
                    // 2. Carga Vulcânica Incandescente
                    state = "charge_windup";
                    charge_windup_timer = charge_windup;
                    scale_y = 1.30;
                    scale_x = 1.30;
                    body_colour = c_yellow;
                }
            }
        }
        break;

    case "erupcao_windup":
        erupcao_timer -= _dt;
        if (random(1) < 0.3) fx_spawn_sparks(x, y, c_yellow, 1);

        if (erupcao_timer <= 0) {
            trigger_hitstop(0.05);
            for (var _i = 0; _i < 2; _i++) {
                var _tx = erupcao_targets_x[_i];
                var _ty = erupcao_targets_y[_i];
                fx_spawn_sparks(_tx, _ty, c_red, 12);
                fx_spawn_sparks(_tx, _ty, c_orange, 8);
                if (_player != noone && point_distance(_player.x, _player.y, _tx, _ty) <= erupcao_radius && !fh_line_intersects_wall(_tx, _ty, _player.x, _player.y)) {
                    player_take_damage(erupcao_damage, "magical");
                    player_apply_poison(3, 0.5, 2.5);
                }
            }
            combo_count = 1;
            state = "chase";
            attack_cooldown_timer = 0.8;
        }
        break;

    case "charge_windup":
        charge_windup_timer -= _dt;
        if (charge_windup_timer <= 0) {
            state = "charge";
            charge_timer = 0.45;
            var _cdir = (_player != noone) ? point_direction(x, y, _player.x, _player.y) : facing_dir;
            charge_vx = lengthdir_x(480, _cdir);
            charge_vy = lengthdir_y(480, _cdir);
            fx_spawn_sparks(x, y, c_red, 10);
        }
        break;

    case "charge":
        charge_timer -= _dt;
        fh_move_and_collide(charge_vx * _dt, charge_vy * _dt);

        if (random(1) < 0.5) fx_spawn_sparks(x, y, c_orange, 2);

        if (_player != noone && point_distance(x, y, _player.x, _player.y) <= body_radius + _player.body_radius && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            player_take_damage(charge_damage, "physical");
            player_apply_poison(3, 0.5, 2.5);
        }

        if (charge_timer <= 0) {
            // Após a carga vulcânica: Superaquece e entra na Janela de Vulnerabilidade!
            state = "vulnerable";
            vulnerable = true;
            vulnerable_timer = vulnerable_duration;
            damage_reduction = 1.0;

            scale_y = 0.70;
            scale_x = 1.35;
            fx_spawn_sparks(x, y, c_lime, 14);
            trigger_hitstop(0.08);
        }
        break;
}
