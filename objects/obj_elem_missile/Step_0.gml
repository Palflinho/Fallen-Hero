if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
var _p = elem_player();
if (hit_cd > 0) hit_cd -= _dt;

switch (kind) {
    // ---------------------------------------------------------------
    // AGUA: bolha lenta teleguiada que prende o jogador por 1s.
    // Pode ser estourada por qualquer ataque do jogador.
    // ---------------------------------------------------------------
    case "bubble":
        life -= _dt;
        if (_p != noone) {
            var _want = point_direction(x, y, _p.x, _p.y);
            dir += clamp(angle_difference(_want, dir), -turn_rate * _dt, turn_rate * _dt);
        }
        x += lengthdir_x(spd * _dt, dir);
        y += lengthdir_y(spd * _dt, dir);

        if (elem_player_attack_near(x, y, radius + 4)) {
            fx_spawn_sparks(x, y, colour, 10);
            fx_spawn_damage_popup(x, y - 12, "POP!", false, colour);
            instance_destroy();
            exit;
        }
        if (_p != noone && point_distance(x, y, _p.x, _p.y) <= radius + _p.body_radius) {
            player_take_damage(damage, "magical");
            player_apply_slow(0, 1.0);
            fx_spawn_damage_popup(_p.x, _p.y - 24, "PRESO NA BOLHA!", false, colour);
            fx_spawn_sparks(_p.x, _p.y, colour, 12);
            instance_destroy();
            exit;
        }
        if (life <= 0 || !fh_place_free_of_walls(x, y, radius * 0.5)) {
            fx_spawn_sparks(x, y, colour, 6);
            instance_destroy();
        }
        break;

    // ---------------------------------------------------------------
    // FOGO: tiro reto; o ponto de impacto vira chao em chamas por 3s.
    // ---------------------------------------------------------------
    case "fire_shot":
        life -= _dt;
        var _nx = x + lengthdir_x(spd * _dt, dir);
        var _ny = y + lengthdir_y(spd * _dt, dir);
        var _end = false;
        if (!fh_place_free_of_walls(_nx, _ny, radius * 0.5)) {
            _end = true;
        } else {
            x = _nx;
            y = _ny;
        }
        if (_p != noone && point_distance(x, y, _p.x, _p.y) <= radius + _p.body_radius) {
            player_take_damage(damage, "magical");
            _end = true;
        }
        if (life <= 0) _end = true;
        if (_end) {
            var _g = elem_spawn_ground(x, y, "fire", 22, 3.0);
            _g.damage = max(3, round(damage * 0.45));
            fx_spawn_sparks(x, y, colour, 6);
            instance_destroy();
        }
        break;

    // ---------------------------------------------------------------
    // VENTO: bumerangue - vai, desacelera e volta ao dono atravessando paredes.
    // ---------------------------------------------------------------
    case "boomerang":
        life -= _dt;
        timer += _dt;
        var _tx = origin_x;
        var _ty = origin_y;
        if (instance_exists(owner)) {
            _tx = owner.x;
            _ty = owner.y;
        }
        if (phase == 0) {
            var _travel = point_distance(origin_x, origin_y, x, y);
            var _slow = clamp(1 - _travel / max_dist, 0.25, 1);
            x += lengthdir_x(spd * _slow * _dt, dir);
            y += lengthdir_y(spd * _slow * _dt, dir);
            if (_travel >= max_dist) phase = 1;
        } else {
            var _back = point_direction(x, y, _tx, _ty);
            x += lengthdir_x(spd * 1.1 * _dt, _back);
            y += lengthdir_y(spd * 1.1 * _dt, _back);
            if (point_distance(x, y, _tx, _ty) <= 18) {
                instance_destroy();
                exit;
            }
        }
        if (_p != noone && hit_cd <= 0 && point_distance(x, y, _p.x, _p.y) <= radius + _p.body_radius) {
            player_take_damage(damage, "projectile");
            hit_cd = 0.5;
        }
        if (life <= 0) instance_destroy();
        break;

    // ---------------------------------------------------------------
    // TERRA: estaca atrasada - afunda, marca o chao sob o jogador e irrompe 0.8s depois.
    // ---------------------------------------------------------------
    case "stake":
        timer += _dt;
        if (phase == 0) {
            // afundando no chao ao lado do conjurador
            if (timer >= 0.25) {
                phase = 1;
                timer = 0;
                if (_p != noone) {
                    target_x = _p.x;
                    target_y = _p.y;
                }
                fx_spawn_sparks(x, y, colour, 6);
            }
        } else if (phase == 1) {
            // marcador segue o jogador por 0.35s, depois trava por 0.45s
            if (timer < 0.35 && _p != noone) {
                target_x = lerp(target_x, _p.x, 0.25);
                target_y = lerp(target_y, _p.y, 0.25);
            }
            if (timer >= 0.8) {
                phase = 2;
                timer = 0;
                elem_hit_player_circle(target_x, target_y, 24, damage, "physical");
                fx_spawn_sparks(target_x, target_y, colour, 14);
                trigger_camera_shake(3);
                sfx_play("slam", 0.1, 0.5);
            }
        } else if (timer >= 0.3) {
            instance_destroy();
        }
        break;

    // ---------------------------------------------------------------
    // FOGO: meteoro - espera o atraso, marca o jogador e cai.
    // ---------------------------------------------------------------
    case "meteor":
        if (delay > 0) {
            delay -= _dt;
            if (delay <= 0) {
                phase = 1;
                timer = 0;
                if (_p != noone) {
                    target_x = _p.x;
                    target_y = _p.y;
                }
            }
            break;
        }
        if (phase == 0) {
            phase = 1;
            timer = 0;
            if (_p != noone) {
                target_x = _p.x;
                target_y = _p.y;
            }
        }
        timer += _dt;
        if (timer >= 0.85) {
            elem_hit_player_circle(target_x, target_y, 34, damage, "magical");
            var _mg = elem_spawn_ground(target_x, target_y, "fire", 26, 2.5);
            _mg.damage = max(3, round(damage * 0.35));
            fx_spawn_sparks(target_x, target_y, colour, 16);
            trigger_camera_shake(4);
            sfx_play("slam", 0.1, 0.6);
            instance_destroy();
        }
        break;

    // ---------------------------------------------------------------
    // AGUA: cruz de gelo "+" a partir do ponto marcado -> chao escorregadio por 6s.
    // ---------------------------------------------------------------
    case "ice_cross":
        timer += _dt;
        if (timer >= 0.75) {
            var _hit = false;
            var _dirs = [0, 90, 180, 270];
            for (var _k = 0; _k <= 4 * cell_arm; _k++) {
                var _cx = target_x;
                var _cy = target_y;
                if (_k > 0) {
                    var _d = _dirs[(_k - 1) mod 4];
                    var _n = 1 + floor((_k - 1) / 4);
                    _cx += lengthdir_x(_n * cell_step, _d);
                    _cy += lengthdir_y(_n * cell_step, _d);
                }
                if (!fh_place_free_of_walls(_cx, _cy, 4)) continue;
                elem_spawn_ground(_cx, _cy, "slick", 20, 6.0);
                fx_spawn_sparks(_cx, _cy, colour, 3);
                if (!_hit && _p != noone && point_distance(_cx, _cy, _p.x, _p.y) <= 18 + _p.body_radius) {
                    _hit = true;
                    player_take_damage(damage, "magical");
                    player_apply_slow(0.5, 1.2);
                }
            }
            sfx_play("parry", 0.1, 0.5);
            instance_destroy();
        }
        break;

    // ---------------------------------------------------------------
    // TERRA: pedregulho arremessado em arco; vira obstaculo ao pousar.
    // ---------------------------------------------------------------
    case "boulder":
        timer += _dt;
        var _t = clamp(timer / flight_time, 0, 1);
        x = lerp(origin_x, target_x, _t);
        y = lerp(origin_y, target_y, _t);
        draw_z = sin(_t * pi) * 70;
        if (_t >= 1) {
            elem_hit_player_circle(x, y, 30, damage, "physical");
            if (_p != noone && point_distance(x, y, _p.x, _p.y) <= 70) {
                elem_push_player(point_direction(x, y, _p.x, _p.y), 260);
            }
            elem_raise_wall(x, y, 1, 1, 7.0);
            fx_spawn_sparks(x, y, colour, 14);
            trigger_camera_shake(4);
            sfx_play("slam", 0.1, 0.6);
            instance_destroy();
        }
        break;
}
