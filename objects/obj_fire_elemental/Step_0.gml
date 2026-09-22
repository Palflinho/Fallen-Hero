event_inherited();
var _dt = delta_time / 1000000;

body_colour = (state == "windup") ? c_yellow : c_red;

if (attack_cooldown_timer > 0) attack_cooldown_timer -= _dt;

var _player = instance_find(obj_player, 0);
var _seen = ai_can_see_player(vision_range, vision_angle);
var _dist = (_player != noone) ? point_distance(x, y, _player.x, _player.y) : infinity;

switch (state) {
    case "patrol":
        ai_patrol(_dt);
        if (_seen != noone) {
            state = "chase";
            lost_sight_timer = 0;
            attack_cooldown_timer = max(attack_cooldown_timer, 0.60);
            consecutive_shots = 0;
        }
        break;

    case "chase":
        if (_player != noone && _player.invisible) {
            state = "patrol";
            break;
        }
        if (_seen != noone) {
            lost_sight_timer = 0;
            if (_dist <= attack_range && attack_cooldown_timer <= 0) facing_dir = point_direction(x, y, _player.x, _player.y);
        } else {
            lost_sight_timer += _dt;
            if (lost_sight_timer >= 1.5) {
                consecutive_shots = 0;
            }
            if (lost_sight_timer >= lost_sight_grace) {
                state = "patrol";
                break;
            }
        }

        if (_dist <= attack_range && attack_cooldown_timer <= 0 && !fh_line_intersects_wall(x, y, _player.x, _player.y)) {
            state = "windup";
            attack_windup_timer = attack_windup;
            locked_aim_dir = -1;
        } else if (_player != noone && _dist < preferred_range - 20) {
            var _dir = point_direction(x, y, _player.x, _player.y) + 180;
            ai_enemy_move(_dir, move_speed_effective, _dt);
        } else if (_player != noone && _dist > preferred_range + 20) {
            var _dir = point_direction(x, y, _player.x, _player.y);
            ai_enemy_move(_dir, move_speed_effective, _dt);
        }
        break;

    case "windup":
        attack_windup_timer -= _dt;
        // Sakurai Polish: Pulsating magical charge
        scale_x = 1.25 + 0.05 * sin(current_time * 0.03);
        scale_y = 1.25 + 0.05 * sin(current_time * 0.03);

        // Fase 1 do windup (> 35% restante): Inimigo gira acompanhando o jogador
        if (attack_windup_timer > attack_windup * 0.35) {
            if (_player != noone && !_player.invisible) {
                facing_dir = point_direction(x, y, _player.x, _player.y);
            }
        }
        // Fase 2 do windup (ultimos 35% ~0.14s): TRAVA DE MIRA (Permite esquiva reativa e finta!)
        else {
            if (locked_aim_dir == -1 && _player != noone && !_player.invisible) {
                var _base_acc = 0.50;
                var _eff_acc = 0.0;
                if (consecutive_shots == 0) {
                    _eff_acc = 0.0; // Primeiro tiro é SEMPRE direto (sem telemetria preditiva)
                } else if (consecutive_shots == 1) {
                    _eff_acc = _base_acc * 0.40; // Segundo tiro calibra levemente
                } else {
                    _eff_acc = _base_acc; // A partir do 3º tiro, telemetria completa
                }

                locked_aim_dir = adaptive_ai_get_lead_aim_dir(x, y, _player, projectile_speed, _eff_acc, 18.0);
                facing_dir = locked_aim_dir;

                // Sakurai Polish: Faisca de mira travada (dica visual para o jogador mudar de direcao!)
                fx_spawn_sparks(x + lengthdir_x(14, facing_dir), y + lengthdir_y(14, facing_dir), c_orange, 2);
            }
        }

        if (attack_windup_timer <= 0) {
            var _pdir = (locked_aim_dir != -1) ? locked_aim_dir : point_direction(x, y, _player.x, _player.y);
            if (_player != noone && !_player.invisible) {
                var _p = instance_create_layer(x, y, layer, obj_enemy_projectile);
                _p.owner = id;
                _p.damage = projectile_damage;
                _p.dir_x = lengthdir_x(1, _pdir);
                _p.dir_y = lengthdir_y(1, _pdir);
                _p.speed_px = projectile_speed;
                _p.colour = c_red;
                _p.damage_type = "magical";
                consecutive_shots += 1;
            }
            locked_aim_dir = -1;
            attack_cooldown_timer = attack_cooldown;
            state = "chase";
            // Recoil & fiery spark burst on projectile launch
            scale_x = 0.8;
            scale_y = 0.8;
            fx_spawn_sparks(x, y, c_orange, 5);
        }
        break;
}

ai_update_sprite_animation();
