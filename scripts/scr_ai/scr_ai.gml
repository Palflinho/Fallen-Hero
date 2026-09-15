function ai_detect_player(_vision_range, _vision_angle, _spider_range) {
    var _player = instance_find(obj_player, 0);
    if (_player == noone || _player.invisible || _player.hp <= 0) {
        if (variable_instance_exists(id, "has_spotted_player")) has_spotted_player = false;
        return noone;
    }

    // Se ja avistou o jogador e esta em combate, mantem o foco continuo
    if (variable_instance_exists(id, "has_spotted_player") && has_spotted_player) {
        return _player;
    }

    var _dist = point_distance(x, y, _player.x, _player.y);
    var _max_range = max(_vision_range, _spider_range);
    if (_dist > _max_range) return noone;

    // Linha de visao bloqueada por paredes (nao enxerga atraves de paredes)
    if (collision_line(x, y, _player.x, _player.y, obj_wall, false, true) != noone) {
        return noone;
    }

    var _dir_to_player = point_direction(x, y, _player.x, _player.y);
    var _angle_diff = abs(angle_difference(facing_dir, _dir_to_player));

    // 1. CONE FRONTAL DE VISAO: Inimigo enxerga o jogador diretamente a frente
    if (_angle_diff <= _vision_angle * 0.5 && _dist <= _vision_range) {
        has_spotted_player = true;
        facing_dir = _dir_to_player;
        facing_x = lengthdir_x(1, facing_dir);
        facing_y = lengthdir_y(1, facing_dir);
        return _player;
    }

    // 2. SENTIDO ARANHA LATERAL: Jogador muito proximo pelos flancos laterais
    // O inimigo pressente a aproximacao lateral (entre o cone frontal e 125 graus),
    // vira rapidamente na direcao do jogador e passa a detecta-lo!
    if (_dist <= _spider_range && _angle_diff > (_vision_angle * 0.5) && _angle_diff <= 125) {
        has_spotted_player = true;
        facing_dir = _dir_to_player;
        facing_x = lengthdir_x(1, facing_dir);
        facing_y = lengthdir_y(1, facing_dir);
        spider_alert_timer = 0.6; // Dispara efeito visual/sonoro de sentido aranha
        fx_spawn_sparks(x, y - body_radius - 6, c_yellow, 4);
        return _player;
    }

    // 3. PONTO CEGO TRASEIRO: Se o jogador chegar por tras (> 125 graus), NAO e detectado!
    // Permite que o jogador execute aproximacoes furtivas (stealth/backstab).
    return noone;
}

function ai_can_see_player(_vision_range, _vision_angle) {
    var _spider = variable_instance_exists(id, "spider_sense_range") ? spider_sense_range : 60;
    return ai_detect_player(_vision_range, _vision_angle, _spider);
}

function ai_enemy_move(_target_dir, _spd, _dt) {
    if (_spd <= 0 || _dt <= 0) return false;
    var _step = _spd * _dt;
    var _rad = variable_instance_exists(id, "body_radius") ? body_radius : 14;
    
    if (!variable_instance_exists(id, "wall_avoid_timer")) wall_avoid_timer = 0;
    if (!variable_instance_exists(id, "wall_avoid_heading")) wall_avoid_heading = _target_dir;
    if (!variable_instance_exists(id, "wall_avoid_bias")) wall_avoid_bias = (random(1) < 0.5) ? 1 : -1;
    
    // 1. Se estiver em manobra ativa de contorno tangencial (bloqueio frontal anterior)
    if (wall_avoid_timer > 0) {
        wall_avoid_timer -= _dt;
        var _av_dx = lengthdir_x(_step, wall_avoid_heading);
        var _av_dy = lengthdir_y(_step, wall_avoid_heading);
        
        if (fh_place_free_of_walls(x + _av_dx, y + _av_dy, _rad)) {
            x += _av_dx;
            y += _av_dy;
            facing_dir = wall_avoid_heading;
            facing_x = lengthdir_x(1, facing_dir);
            facing_y = lengthdir_y(1, facing_dir);
            
            // Só cancela a manobra se o caminho direto para o alvo estiver realmente livre por distância segura
            var _check_dist = max(_rad * 2.0, _step * 4);
            if (fh_place_free_of_walls(x + lengthdir_x(_check_dist, _target_dir), y + lengthdir_y(_check_dist, _target_dir), _rad)) {
                var _player = instance_find(obj_player, 0);
                if (_player != noone && collision_line(x, y, _player.x, _player.y, obj_wall, false, true) == noone) {
                    wall_avoid_timer = 0;
                }
            }
            return true;
        } else {
            // Se encontrou quina durante a manobra, ajusta o ângulo mantendo o mesmo sentido de contorno
            wall_avoid_heading = (wall_avoid_heading + wall_avoid_bias * 45 + 360) % 360;
            wall_avoid_timer = max(wall_avoid_timer, 0.40);
        }
    }
    
    // 2. Movimento direto desimpedido na direção desejada
    var _dx = lengthdir_x(_step, _target_dir);
    var _dy = lengthdir_y(_step, _target_dir);
    
    if (fh_place_free_of_walls(x + _dx, y + _dy, _rad)) {
        x += _dx;
        y += _dy;
        facing_dir = _target_dir;
        facing_x = lengthdir_x(1, facing_dir);
        facing_y = lengthdir_y(1, facing_dir);
        wall_avoid_timer = 0;
        return true;
    }
    
    // 3. Deslize ortogonal clássico (impede travar ou tremer em paredes retas)
    var _can_x = (abs(_dx) > 0.001) && fh_place_free_of_walls(x + _dx, y, _rad);
    var _can_y = (abs(_dy) > 0.001) && fh_place_free_of_walls(x, y + _dy, _rad);
    
    if (_can_x && !_can_y) {
        x += _dx;
        facing_dir = (_dx > 0) ? 0 : 180;
        facing_x = lengthdir_x(1, facing_dir);
        facing_y = 0;
        wall_avoid_timer = 0;
        return true;
    }
    
    if (_can_y && !_can_x) {
        y += _dy;
        facing_dir = (_dy > 0) ? 270 : 90;
        facing_x = 0;
        facing_y = lengthdir_y(1, facing_dir);
        wall_avoid_timer = 0;
        return true;
    }
    
    if (_can_x && _can_y) {
        if (abs(_dx) >= abs(_dy)) {
            x += _dx;
            facing_dir = (_dx > 0) ? 0 : 180;
            facing_x = lengthdir_x(1, facing_dir);
            facing_y = 0;
        } else {
            y += _dy;
            facing_dir = (_dy > 0) ? 270 : 90;
            facing_x = 0;
            facing_y = lengthdir_y(1, facing_dir);
        }
        wall_avoid_timer = 0;
        return true;
    }
    
    // 4. Bloqueio frontal total em quina ou parede perpendicular: inicia contorno tangencial firme
    var _tan_a = (_target_dir + 90 * wall_avoid_bias + 360) % 360;
    var _tan_b = (_target_dir - 90 * wall_avoid_bias + 360) % 360;
    
    var _adx = lengthdir_x(_step, _tan_a);
    var _ady = lengthdir_y(_step, _tan_a);
    if (fh_place_free_of_walls(x + _adx, y + _ady, _rad)) {
        x += _adx;
        y += _ady;
        facing_dir = _tan_a;
        facing_x = lengthdir_x(1, facing_dir);
        facing_y = lengthdir_y(1, facing_dir);
        wall_avoid_heading = _tan_a;
        wall_avoid_timer = 0.50;
        return true;
    }
    
    var _bdx = lengthdir_x(_step, _tan_b);
    var _bdy = lengthdir_y(_step, _tan_b);
    if (fh_place_free_of_walls(x + _bdx, y + _bdy, _rad)) {
        x += _bdx;
        y += _bdy;
        facing_dir = _tan_b;
        facing_x = lengthdir_x(1, facing_dir);
        facing_y = lengthdir_y(1, facing_dir);
        wall_avoid_heading = _tan_b;
        wall_avoid_bias = -wall_avoid_bias;
        wall_avoid_timer = 0.50;
        return true;
    }
    
    // 5. Teste de leque diagonal secundário se as tangentes diretas estiverem bloqueadas
    var _diag_angles = [45, -45, 135, -135];
    for (var _d = 0; _d < array_length(_diag_angles); _d++) {
        var _diag_dir = (_target_dir + _diag_angles[_d] * wall_avoid_bias + 360) % 360;
        var _ddx = lengthdir_x(_step, _diag_dir);
        var _ddy = lengthdir_y(_step, _diag_dir);
        if (fh_place_free_of_walls(x + _ddx, y + _ddy, _rad)) {
            x += _ddx;
            y += _ddy;
            facing_dir = _diag_dir;
            facing_x = lengthdir_x(1, facing_dir);
            facing_y = lengthdir_y(1, facing_dir);
            wall_avoid_heading = _diag_dir;
            wall_avoid_timer = 0.40;
            return true;
        }
    }
    
    return false;
}

function ai_patrol(_dt) {
    if (point_distance(x, y, patrol_target_x, patrol_target_y) < 8) {
        if (patrol_wait_timer > 0) {
            patrol_wait_timer -= _dt;
        } else {
            var _ang = random(360);
            var _r = random(patrol_radius);
            patrol_target_x = clamp(home_x + lengthdir_x(_r, _ang), 60, room_width - 60);
            patrol_target_y = clamp(home_y + lengthdir_y(_r, _ang), 60, room_height - 60);
            patrol_wait_timer = random_range(1, 2.5);
        }
    } else {
        var _dir = point_direction(x, y, patrol_target_x, patrol_target_y);
        facing_dir = _dir;
        facing_x = lengthdir_x(1, facing_dir);
        facing_y = lengthdir_y(1, facing_dir);
        var _moved = ai_enemy_move(_dir, move_speed_effective * 0.5, _dt);
        if (!_moved) {
            // Se bateu na parede e não conseguiu avançar, muda de rota imediatamente!
            patrol_wait_timer = random_range(0.5, 1.2);
            var _ang = random(360);
            var _r = random_range(40, patrol_radius);
            patrol_target_x = clamp(x + lengthdir_x(_r, _ang), 60, room_width - 60);
            patrol_target_y = clamp(y + lengthdir_y(_r, _ang), 60, room_height - 60);
        }
    }
}

function ai_update_sprite_animation() {
    if (sprite_index != -1) {
        var _moving = (x != xprevious || y != yprevious);
        image_speed = _moving ? 1 : 0;
        if (!_moving) image_index = 0;
    }
}
