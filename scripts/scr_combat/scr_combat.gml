function enemy_take_damage(_inst, _amount) {
    if (!instance_exists(_inst)) return;
    _inst.hp -= _amount * _inst.damage_reduction;
    _inst.hit_flash_timer = _inst.hit_flash_duration;
    if (_inst.hp < 0) _inst.hp = 0;
}

function enemy_apply_poison(_inst, _dmg_per_tick, _tick_interval, _duration) {
    if (!instance_exists(_inst)) return;
    _inst.poison_active = true;
    _inst.poison_damage = _dmg_per_tick;
    _inst.poison_tick_interval = _tick_interval;
    _inst.poison_tick_timer = _tick_interval;
    _inst.poison_duration = _duration;
}

function enemy_apply_slow(_inst, _multiplier, _duration) {
    if (!instance_exists(_inst)) return;
    _inst.slow_active = true;
    _inst.slow_multiplier = _multiplier;
    _inst.slow_duration = _duration;
}

function player_perform_attack() {
    if (attack_is_ranged) {
        var _sx = x + facing_x * 14;
        var _sy = y + facing_y * 14;
        var _p = instance_create_layer(_sx, _sy, layer, attack_object);
        _p.owner = id;
        _p.damage = attack_damage;
        _p.dir_x = facing_x;
        _p.dir_y = facing_y;
        _p.speed_px = projectile_speed;
    } else {
        var _hx = x + facing_x * attack_range * 0.6;
        var _hy = y + facing_y * attack_range * 0.6;
        var _hit = instance_create_layer(_hx, _hy, layer, attack_object);
        _hit.owner = id;
        _hit.damage = attack_damage;
        _hit.body_radius = attack_range * 0.7;
    }
}

function player_take_damage(_amount) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;
    if (_p.invuln_timer > 0) return;

    var _defending = (_p.state == "defend" && _p.defend_active);

    if (_defending && _p.defend_mode == "block") {
        if (_p.stamina >= _p.defend_block_cost) {
            _p.stamina -= _p.defend_block_cost;
            _p.hit_flash_timer = _p.hit_flash_duration;
            _p.stamina_regen_timer = _p.stamina_regen_delay;
        } else {
            _p.hp -= max(1, _amount - _p.stamina);
            _p.stamina = 0;
            _p.hit_flash_timer = _p.hit_flash_duration;
            _p.invuln_timer = _p.invuln_duration;
            _p.stamina_regen_timer = _p.stamina_regen_delay;
        }
    } else if (_defending && _p.defend_mode == "manashield") {
        if (_p.mana > 0) {
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else {
            _p.hp -= _amount;
            _p.hit_flash_timer = _p.hit_flash_duration;
            _p.invuln_timer = _p.invuln_duration;
            _p.state = "hurt";
        }
    } else {
        _p.hp -= _amount;
        _p.hit_flash_timer = _p.hit_flash_duration;
        _p.invuln_timer = _p.invuln_duration;
        _p.state = "hurt";
    }

    _p.hp = max(0, _p.hp);
}
