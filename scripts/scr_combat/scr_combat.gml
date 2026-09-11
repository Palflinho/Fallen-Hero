// Brief shared freeze on an impactful hit (Sakurai's "feedback" principle: confirming an
// impact lands is one of the cheapest, highest-payoff things to add). Reuses
// is_world_paused() so every object that already gates on it freezes for free.
function trigger_hitstop(_duration) {
    global.hitstop_timer = max(global.hitstop_timer, _duration);
}

// -------------------------------------------------------------
// SAKURAI JUICE: Combat FX, Floating Numbers, Sparks & Particles
// -------------------------------------------------------------
if (!variable_global_exists("combat_popups")) {
    global.combat_popups = [];
}
if (!variable_global_exists("combat_particles")) {
    global.combat_particles = [];
}

function fx_spawn_damage_popup(_x, _y, _amount, _is_crit, _col) {
    if (is_undefined(_col)) _col = _is_crit ? c_yellow : c_white;
    var _txt = string(round(_amount));
    if (_is_crit) _txt += "!";
    var _popup = {
        x: _x + random_range(-6, 6),
        y: _y - 12 + random_range(-4, 4),
        text: _txt,
        colour: _col,
        is_crit: _is_crit,
        life: 0.7,
        life_max: 0.7,
        vy: _is_crit ? -55 : -35,
        vx: random_range(-12, 12),
        scale: _is_crit ? 1.35 : 1.0
    };
    array_push(global.combat_popups, _popup);
}

function fx_spawn_reward_popup(_x, _y, _exp, _gold) {
    if (_exp > 0) {
        array_push(global.combat_popups, {
            x: _x - 12,
            y: _y - 16,
            text: "+" + string(_exp) + " XP",
            colour: c_aqua,
            is_crit: false,
            life: 0.9,
            life_max: 0.9,
            vy: -40,
            vx: -8,
            scale: 1.1
        });
    }
    if (_gold > 0) {
        array_push(global.combat_popups, {
            x: _x + 12,
            y: _y - 20,
            text: "+" + string(_gold) + " Ouro",
            colour: c_yellow,
            is_crit: false,
            life: 0.9,
            life_max: 0.9,
            vy: -45,
            vx: 8,
            scale: 1.1
        });
    }
}

function fx_spawn_sparks(_x, _y, _colour, _count) {
    if (is_undefined(_colour)) _colour = c_yellow;
    if (is_undefined(_count)) _count = 5;
    for (var _i = 0; _i < _count; _i++) {
        var _ang = random(360);
        var _spd = random_range(30, 100);
        array_push(global.combat_particles, {
            x: _x,
            y: _y,
            vx: lengthdir_x(_spd, _ang),
            vy: lengthdir_y(_spd, _ang),
            colour: _colour,
            size: random_range(2, 4),
            life: random_range(0.2, 0.4),
            life_max: 0.4
        });
    }
}

function fx_spawn_death_burst(_x, _y, _colour, _count) {
    if (is_undefined(_colour)) _colour = c_white;
    if (is_undefined(_count)) _count = 14;
    for (var _i = 0; _i < _count; _i++) {
        var _ang = random(360);
        var _spd = random_range(50, 180);
        array_push(global.combat_particles, {
            x: _x,
            y: _y,
            vx: lengthdir_x(_spd, _ang),
            vy: lengthdir_y(_spd, _ang),
            colour: _colour,
            size: random_range(3, 6),
            life: random_range(0.3, 0.6),
            life_max: 0.6
        });
    }
}

function fx_system_update(_dt) {
    // Update Popups
    for (var _i = array_length(global.combat_popups) - 1; _i >= 0; _i--) {
        var _p = global.combat_popups[_i];
        _p.life -= _dt;
        _p.x += _p.vx * _dt;
        _p.y += _p.vy * _dt;
        _p.vy += 30 * _dt;
        if (_p.life <= 0) {
            array_delete(global.combat_popups, _i, 1);
        }
    }

    // Update Particles
    for (var _j = array_length(global.combat_particles) - 1; _j >= 0; _j--) {
        var _pt = global.combat_particles[_j];
        _pt.life -= _dt;
        _pt.x += _pt.vx * _dt;
        _pt.y += _pt.vy * _dt;
        _pt.vx *= power(0.86, _dt * 60);
        _pt.vy *= power(0.86, _dt * 60);
        if (_pt.life <= 0) {
            array_delete(global.combat_particles, _j, 1);
        }
    }
}

function fx_system_draw() {
    // Draw Particles
    for (var _j = 0; _j < array_length(global.combat_particles); _j++) {
        var _pt = global.combat_particles[_j];
        var _alpha = clamp(_pt.life / _pt.life_max, 0, 1);
        draw_set_alpha(_alpha);
        draw_set_color(_pt.colour);
        draw_circle(_pt.x, _pt.y, max(1, _pt.size * _alpha), false);
    }

    // Draw Popups
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    for (var _i = 0; _i < array_length(global.combat_popups); _i++) {
        var _p = global.combat_popups[_i];
        var _alpha = clamp(_p.life / (_p.life_max * 0.4), 0, 1);
        draw_set_alpha(_alpha);

        // Draw shadow
        draw_set_color(c_black);
        draw_text_transformed(_p.x + 1, _p.y + 1, _p.text, _p.scale, _p.scale, 0);

        // Draw text
        draw_set_color(_p.colour);
        draw_text_transformed(_p.x, _p.y, _p.text, _p.scale, _p.scale, 0);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function enemy_take_damage(_inst, _amount, _source_x, _source_y, _knockback_force, _is_crit) {
    if (!instance_exists(_inst)) return;
    if (is_undefined(_knockback_force)) _knockback_force = 160;
    if (is_undefined(_is_crit)) _is_crit = false;

    var _actual_dmg = _amount * _inst.damage_reduction;
    _inst.hp -= _actual_dmg;
    _inst.hit_flash_timer = _inst.hit_flash_duration;
    if (_inst.hp < 0) _inst.hp = 0;

    // Dynamic HP bar refresh
    if (variable_instance_exists(_inst, "hp_bar_timer")) {
        _inst.hp_bar_timer = _inst.hp_bar_duration;
    }

    // Squash & Stretch impact reaction
    if (variable_instance_exists(_inst, "scale_x")) {
        _inst.scale_x = 1.28;
        _inst.scale_y = 0.72;
    }

    // Knockback Impulse
    if (!is_undefined(_source_x) && !is_undefined(_source_y) && variable_instance_exists(_inst, "knockback_vx")) {
        var _kdir = point_direction(_source_x, _source_y, _inst.x, _inst.y);
        var _res = variable_instance_exists(_inst, "knockback_resistance") ? _inst.knockback_resistance : 0;
        var _effective_force = _knockback_force * (1 - _res);
        _inst.knockback_vx += lengthdir_x(_effective_force, _kdir);
        _inst.knockback_vy += lengthdir_y(_effective_force, _kdir);
    }

    // Visual feedback: sparks and damage number
    if (_actual_dmg > 0) {
        fx_spawn_damage_popup(_inst.x, _inst.y - _inst.body_radius, _actual_dmg, _is_crit, _is_crit ? c_yellow : c_white);
        fx_spawn_sparks(_inst.x, _inst.y, _is_crit ? c_yellow : c_white, _is_crit ? 8 : 4);
    }
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

// Central place every player attack (melee hitbox or projectile) routes a confirmed hit
// through, so talents that react to "the player damaged an enemy" (execute bonus,
// lifesteal, on-hit poison) only need to be written once.
function player_on_hit_enemy(_owner, _enemy, _base_damage) {
    if (!instance_exists(_enemy)) return;

    if (!instance_exists(_owner)) {
        enemy_take_damage(_enemy, _base_damage);
        return;
    }

    var _is_crit = variable_instance_exists(_owner, "last_attack_was_crit") ? _owner.last_attack_was_crit : false;
    var _force = 180;
    if (_owner.character_class == "knight") {
        if (_owner.element_affinity == "fire") _force = 240;
        else if (_owner.element_affinity == "wind") _force = 200;
        else if (_owner.element_affinity == "earth") _force = 220;
    }

    var _dmg = _base_damage;
    if (_owner.synth_execute_bonus > 0 && _enemy.hp_max > 0 && (_enemy.hp / _enemy.hp_max) <= 0.3) {
        _dmg *= (1 + _owner.synth_execute_bonus);
    }

    var _before_hp = _enemy.hp;
    enemy_take_damage(_enemy, _dmg, _owner.x, _owner.y, _force, _is_crit);
    var _dealt = max(0, _before_hp - _enemy.hp);

    if (_dealt > 0) trigger_hitstop(_is_crit ? 0.09 : 0.06);

    if (_owner.synth_lifesteal > 0 && _dealt > 0) {
        _owner.hp = min(_owner.hp_max, _owner.hp + _dealt * _owner.synth_lifesteal);
    }

    if (_owner.synth_poison_on_hit > 0) {
        enemy_apply_poison(_enemy, 3, 0.5, 2);
    }

    // Elemental On-Hit Effects for Knight
    if (_owner.character_class == "knight") {
        if (_owner.element_affinity == "fire") {
            // Apply Burn
            enemy_apply_poison(_enemy, 4 + _owner.synth_berserk_burn, 0.5, 2.0);
            if (_owner.synth_berserk_lifesteal > 0 && _dealt > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + _dealt * _owner.synth_berserk_lifesteal);
            }
        } else if (_owner.element_affinity == "water") {
            // Holy/Water restore
            if (_owner.synth_paladin_heal_hit > 0 && _dealt > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + _owner.synth_paladin_heal_hit);
            }
        }
    }
}

function player_perform_attack() {
    var _is_crit = (random(1) < synth_crit_chance);
    last_attack_was_crit = _is_crit;
    var _dmg = attack_damage * (_is_crit ? synth_crit_mult : 1);

    if (character_class == "knight") {
        if (element_affinity == "fire" && state == "defend" && defend_mode == "berserk_fury") {
            _dmg *= (1.5 + synth_berserk_dmg_bonus);
        } else if (element_affinity == "wind" && duelist_combo_count == 1) {
            _dmg *= 1.25;
        } else if (element_affinity == "earth") {
            _dmg *= 1.15;
        }
    }

    if (attack_is_ranged) {
        var _sx = x + facing_x * 14;
        var _sy = y + facing_y * 14;
        var _p = instance_create_layer(_sx, _sy, layer, attack_object);
        _p.owner = id;
        _p.damage = _dmg;
        _p.dir_x = facing_x;
        _p.dir_y = facing_y;
        _p.speed_px = projectile_speed;
        _p.pierce_remaining = synth_pierce_count;
    } else {
        var _range_mult = 0.6;
        var _radius_mult = 0.7;

        if (character_class == "knight") {
            if (element_affinity == "fire") {
                _range_mult = 0.75;
                _radius_mult = 1.05; // Larger fiery arc!
            } else if (element_affinity == "earth") {
                _range_mult = 0.5;
                _radius_mult = 0.75; // Heavy compact strike
            }
        }

        var _hx = x + facing_x * attack_range * _range_mult;
        var _hy = y + facing_y * attack_range * _range_mult;
        if (!fh_place_free_of_walls(_hx, _hy, 4)) {
            _hx = x + facing_x * body_radius;
            _hy = y + facing_y * body_radius;
        }
        var _hit = instance_create_layer(_hx, _hy, layer, attack_object);
        _hit.owner = id;
        _hit.damage = _dmg;
        _hit.body_radius = attack_range * _radius_mult;
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
    var _block_mult = max(0.15, 0.5 - _p.synth_block_reduction);

    if (_defending) {
        if (_p.defend_mode == "parry") {
            // Duelista: Aparar bem-sucedido! Anula 100% de dano e desfere contra-ataque de 360 graus
            _final = 0;
            _blocked_fully = true;
            _p.parry_flash_timer = 0.25;
            _p.defend_timer = 0;
            _p.last_attack_was_crit = true;
            trigger_hitstop(0.12);

            var _counter_dmg = _p.attack_damage * (2.2 + _p.synth_duelist_counter_mult);
            var _counter = instance_create_layer(_p.x, _p.y, _p.layer, obj_atk_knight);
            _counter.owner = _p;
            _counter.damage = _counter_dmg;
            _counter.body_radius = 55;
            _counter.life = 0.18;
            _counter.is_counter = true;
        } else if (_p.defend_mode == "guardian_aegis") {
            // Guardião: Bloqueia 100% tanto fisico quanto magico!
            _final = 0;
            _blocked_fully = true;
            _p.hit_flash_timer = _p.hit_flash_duration;
            trigger_hitstop(0.06);
        } else if (_p.defend_mode == "paladin_aura") {
            // Paladino: Barreira de sobrevida absorve primeiro
            if (_p.paladin_barrier_active > 0) {
                if (_p.paladin_barrier_active >= _final) {
                    _p.paladin_barrier_active -= _final;
                    _final = 0;
                    _blocked_fully = true;
                } else {
                    _final -= _p.paladin_barrier_active;
                    _p.paladin_barrier_active = 0;
                }
            }
            if (_final > 0) {
                _final *= 0.60; // 40% de reducao na aura
            }
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else if (_p.defend_mode == "berserk_fury") {
            // Berserker: Reducao leve de 20%, foca em agressao
            _final *= 0.80;
        } else if (_p.defend_mode == "block") {
            // Cavaleiro Padrao: Imune a fisico, reduz magico
            if (_damage_type == "physical") {
                _final = 0;
                _blocked_fully = true;
            } else {
                _final *= _block_mult;
            }
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else if (_p.defend_mode == "manashield") {
            // Mago: Imune a magico, reduz fisico
            if (_damage_type == "magical") {
                _final = 0;
                _blocked_fully = true;
            } else {
                _final *= _block_mult;
            }
            _p.hit_flash_timer = _p.hit_flash_duration;
        }
    }

    if (!_blocked_fully) {
        var _mitigation = _p.nat_defesa + ((_damage_type == "physical") ? _p.synth_def_fisica : _p.synth_def_magica);
        if (_p.character_class == "knight" && _p.synth_guardian_def > 0) {
            _mitigation += _p.synth_guardian_def;
        }

        _final = max(1, _final - _mitigation);

        // "Folego Extra" talent: once every 45s, a hit that would kill instead leaves 1 HP.
        if (_p.synth_second_wind > 0 && _p.second_wind_cooldown_timer <= 0 && (_p.hp - _final) <= 0) {
            _final = max(0, _p.hp - 1);
            _p.second_wind_cooldown_timer = 45;
        }

        _p.hp -= _final;
        _p.hit_flash_timer = _p.hit_flash_duration;
        _p.invuln_timer = _p.invuln_duration;
        if (_final > 0) {
            _p.state = "hurt";
            trigger_hitstop(0.05);
        }

        // "Retaliacao" talent: physical hits that actually land trigger a burst around the player
        if (_p.synth_thorns_dmg > 0 && _damage_type == "physical") {
            with (obj_enemy_parent) {
                if (point_distance(x, y, _p.x, _p.y) <= 90) {
                    enemy_take_damage(id, _p.synth_thorns_dmg, _p.x, _p.y, 140);
                }
            }
        }
    }

    _p.hp = max(0, _p.hp);
}
