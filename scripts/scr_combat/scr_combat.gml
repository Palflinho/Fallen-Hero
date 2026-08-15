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

function player_apply_poison(_dmg_per_tick, _tick_interval, _duration) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;
    _p.poison_active = true;
    _p.poison_damage = _dmg_per_tick;
    _p.poison_tick_interval = _tick_interval;
    _p.poison_tick_timer = _tick_interval;
    _p.poison_duration = _duration;
}

function player_perform_attack() {
    var _is_crit = (random(1) < synth_crit_chance);
    var _dmg = attack_damage * (_is_crit ? synth_crit_mult : 1);

    if (attack_is_ranged) {
        var _sx = x + facing_x * 14;
        var _sy = y + facing_y * 14;
        var _p = instance_create_layer(_sx, _sy, layer, attack_object);
        _p.owner = id;
        _p.damage = _dmg;
        _p.dir_x = facing_x;
        _p.dir_y = facing_y;
        _p.speed_px = projectile_speed;
    } else {
        var _hx = x + facing_x * attack_range * 0.6;
        var _hy = y + facing_y * attack_range * 0.6;
        if (!fh_place_free_of_walls(_hx, _hy, 4)) {
            _hx = x + facing_x * body_radius;
            _hy = y + facing_y * body_radius;
        }
        var _hit = instance_create_layer(_hx, _hy, layer, attack_object);
        _hit.owner = id;
        _hit.damage = _dmg;
        _hit.body_radius = attack_range * 0.7;
    }
}

function player_take_damage(_amount, _damage_type) {
    if (is_undefined(_damage_type)) _damage_type = "physical";

    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;
    if (_p.invuln_timer > 0) return;

    if (random(1) < _p.synth_dodge) return;

    var _defending = (_p.state == "defend" && _p.defend_active);
    var _final = _amount;
    var _blocked_fully = false;

    if (_defending && _p.defend_mode == "block") {
        // Knight: immune to physical attacks, reduced damage from magical attacks.
        if (_damage_type == "physical") {
            _final = 0;
            _blocked_fully = true;
        } else {
            _final *= 0.5;
        }
        _p.hit_flash_timer = _p.hit_flash_duration;
    } else if (_defending && _p.defend_mode == "manashield") {
        // Mage: immune to magical attacks, reduced damage from physical attacks.
        if (_damage_type == "magical") {
            _final = 0;
            _blocked_fully = true;
        } else {
            _final *= 0.5;
        }
        _p.hit_flash_timer = _p.hit_flash_duration;
    }

    if (!_blocked_fully) {
        var _mitigation = _p.nat_defesa + ((_damage_type == "physical") ? _p.synth_def_fisica : _p.synth_def_magica);
        _final = max(1, _final - _mitigation);

        _p.hp -= _final;
        _p.hit_flash_timer = _p.hit_flash_duration;
        _p.invuln_timer = _p.invuln_duration;
        if (_final > 0) _p.state = "hurt";
    }

    _p.hp = max(0, _p.hp);
}
