function ai_detect_player(_vision_range, _vision_angle, _spider_range) {
    var _player = instance_find(obj_player, 0);
    if (_player == noone || _player.invisible || _player.hp <= 0) return noone;

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
        return _player;
    }

    // 2. SENTIDO ARANHA LATERAL: Jogador muito proximo pelos flancos laterais
    // O inimigo pressente a aproximacao lateral (entre o cone frontal e 125 graus),
    // vira rapidamente na direcao do jogador e passa a detecta-lo!
    if (_dist <= _spider_range && _angle_diff > (_vision_angle * 0.5) && _angle_diff <= 125) {
        has_spotted_player = true;
        facing_dir = _dir_to_player;
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

function ai_patrol(_dt) {
    if (point_distance(x, y, patrol_target_x, patrol_target_y) < 8) {
        if (patrol_wait_timer > 0) {
            patrol_wait_timer -= _dt;
        } else {
            var _ang = random(360);
            var _r = random(patrol_radius);
            patrol_target_x = clamp(home_x + lengthdir_x(_r, _ang), 40, room_width - 40);
            patrol_target_y = clamp(home_y + lengthdir_y(_r, _ang), 40, room_height - 40);
            patrol_wait_timer = random_range(1, 2.5);
        }
    } else {
        var _dir = point_direction(x, y, patrol_target_x, patrol_target_y);
        facing_dir = _dir;
        fh_move_and_collide(lengthdir_x(move_speed_effective * 0.5 * _dt, _dir), lengthdir_y(move_speed_effective * 0.5 * _dt, _dir));
    }
}

function ai_update_sprite_animation() {
    if (sprite_index != -1) {
        var _moving = (x != xprevious || y != yprevious);
        image_speed = _moving ? 1 : 0;
        if (!_moving) image_index = 0;
    }
}
