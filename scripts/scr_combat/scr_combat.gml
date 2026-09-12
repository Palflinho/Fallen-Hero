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
    var _txt = is_string(_amount) ? _amount : (string(round(_amount)) + (_is_crit ? "!" : ""));
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

function fx_spawn_element_unlocked_popup(_x, _y, _elem) {
    var _name = element_get_name(_elem);
    var _col = c_white;
    switch (_elem) {
        case "water": _col = c_aqua; break;
        case "fire":  _col = c_orange; break;
        case "wind":  _col = make_colour_rgb(180, 240, 255); break;
        case "earth": _col = make_colour_rgb(170, 130, 80); break;
    }
    array_push(global.combat_popups, {
        x: _x,
        y: _y - 45,
        text: "ELEMENTO " + string_upper(_name) + " DESBLOQUEADO!",
        colour: _col,
        is_crit: true,
        life: 2.2,
        life_max: 2.2,
        vy: -25,
        vx: 0,
        scale: 1.35
    });
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
    if (variable_instance_exists(_p, "synth_crio_coracao_geada") && _p.synth_crio_coracao_geada > 0) return;
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

        // 03 Golpe Pesado (+80% knockback no critico e atordoamento de 0.3s)
        if (variable_instance_exists(_owner, "synth_golpe_pesado") && _owner.synth_golpe_pesado > 0 && _is_crit) {
            _force *= 1.8;
            enemy_apply_slow(_enemy, 0, 0.3);
        }

        // 34 Estocada Fulminante: atinge as costas = 2.5x dano
        if (variable_instance_exists(_owner, "synth_duelista_estocada_fulminante") && _owner.synth_duelista_estocada_fulminante > 0) {
            var _edx = variable_instance_exists(_enemy, "dir_x") ? _enemy.dir_x : 0;
            var _edy = variable_instance_exists(_enemy, "dir_y") ? _enemy.dir_y : 0;
            if (_owner.facing_x * _edx + _owner.facing_y * _edy > 0.4) {
                _base_damage *= 2.5;
            }
        }

        // 24 Lamina em Brasa: ignora reducao de dano de inimigos com armadura
        if (variable_instance_exists(_owner, "synth_berserk_lamina_brasa") && _owner.synth_berserk_lamina_brasa > 0) {
            _base_damage *= 1.25;
        }
    }

    var _dmg = _base_damage;
    if (_owner.synth_execute_bonus > 0 && _enemy.hp_max > 0 && (_enemy.hp / _enemy.hp_max) <= 0.3) {
        _dmg *= (1 + _owner.synth_execute_bonus);
    }

    // Matriz de Reações Elementais dos 4 Elementos (Sinergia Iwata)
    var _is_fire_hit = (_owner.element_affinity == "fire" || (variable_instance_exists(_owner, "synth_berserk_lamina_brasa") && _owner.synth_berserk_lamina_brasa > 0) || (variable_instance_exists(_owner, "synth_piro_centelha_incandescente") && _owner.synth_piro_centelha_incandescente > 0) || (variable_instance_exists(_owner, "synth_archer_balist_flecha_incendiaria") && _owner.synth_archer_balist_flecha_incendiaria > 0));
    var _is_water_hit = (_owner.element_affinity == "water" || (variable_instance_exists(_owner, "synth_crio_geada_penetrante") && _owner.synth_crio_geada_penetrante > 0) || (variable_instance_exists(_owner, "synth_archer_glacial_flecha_estalactite") && _owner.synth_archer_glacial_flecha_estalactite > 0));
    var _is_wind_hit = (_owner.element_affinity == "wind" || (variable_instance_exists(_owner, "synth_duelista_passo_eolico") && _owner.synth_duelista_passo_eolico > 0) || (variable_instance_exists(_owner, "synth_aero_arco_eletrico") && _owner.synth_aero_arco_eletrico > 0) || (variable_instance_exists(_owner, "synth_archer_vendaval_disparo_leque") && _owner.synth_archer_vendaval_disparo_leque > 0));
    var _is_earth_hit = (_owner.element_affinity == "earth" || (variable_instance_exists(_owner, "synth_guardiao_fissura_telurica") && _owner.synth_guardiao_fissura_telurica > 0) || (variable_instance_exists(_owner, "synth_geo_projetil_rochoso") && _owner.synth_geo_projetil_rochoso > 0) || (variable_instance_exists(_owner, "synth_archer_terra_flecha_arpao") && _owner.synth_archer_terra_flecha_arpao > 0));

    var _has_wind = variable_instance_exists(_enemy, "wind_exposed") && (_enemy.wind_exposed > 0);
    var _has_earth = variable_instance_exists(_enemy, "earth_fracture") && (_enemy.earth_fracture > 0);

    // 1. Choque Térmico (Fogo + Água)
    if ((_is_fire_hit && _enemy.slow_active) || (_is_water_hit && _enemy.poison_active)) {
        _dmg *= 1.50;
        _is_crit = true;
        trigger_hitstop(0.10);
        fx_spawn_sparks(_enemy.x, _enemy.y, c_orange, 8);
        fx_spawn_sparks(_enemy.x, _enemy.y, c_aqua, 8);
        fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 10, "CHOQUE TERMICO", true, c_orange);
        _enemy.damage_reduction = min(1.0, _enemy.damage_reduction * 1.4);
    }
    // 2. Tormenta Ígnea (Vento + Fogo)
    else if ((_is_wind_hit && _enemy.poison_active) || (_is_fire_hit && _has_wind)) {
        _dmg *= 1.30;
        trigger_hitstop(0.08);
        fx_spawn_sparks(_enemy.x, _enemy.y, c_yellow, 12);
        fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 10, "TORMENTA IGNEA", true, c_yellow);
        var _ex = _enemy.x;
        var _ey = _enemy.y;
        with (obj_enemy_parent) {
            if (id != _enemy && point_distance(x, y, _ex, _ey) <= 100) {
                enemy_take_damage(id, 18, _ex, _ey, 140);
                enemy_apply_poison(id, 4, 0.4, 2.0);
            }
        }
    }
    // 3. Nevasca Congelante (Vento + Água)
    else if ((_is_wind_hit && _enemy.slow_active) || (_is_water_hit && _has_wind)) {
        _dmg *= 1.25;
        _enemy.slow_active = true;
        _enemy.slow_amount = 0.05;
        _enemy.slow_timer = 2.0;
        trigger_hitstop(0.08);
        fx_spawn_sparks(_enemy.x, _enemy.y, c_aqua, 14);
        fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 10, "NEVASCA", true, c_aqua);
    }
    // 4. Rocha Fundida (Terra + Fogo)
    else if ((_is_earth_hit && _enemy.poison_active) || (_is_fire_hit && _has_earth)) {
        _dmg *= 1.40;
        _enemy.damage_reduction = min(1.0, _enemy.damage_reduction * 1.5);
        trigger_hitstop(0.08);
        fx_spawn_sparks(_enemy.x, _enemy.y, make_colour_rgb(255, 120, 20), 10);
        fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 10, "ROCHA FUNDIDA", true, make_colour_rgb(255, 120, 20));
    }
    // 5. Lamaçal Telúrico (Terra + Água)
    else if ((_is_earth_hit && _enemy.slow_active) || (_is_water_hit && _has_earth)) {
        _enemy.slow_active = true;
        _enemy.slow_amount = 0.0; // Enraizamento completo
        _enemy.slow_timer = 2.0;
        trigger_hitstop(0.08);
        fx_spawn_sparks(_enemy.x, _enemy.y, make_colour_rgb(120, 170, 80), 10);
        fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 10, "LAMACAL", true, make_colour_rgb(120, 170, 80));
    }
    // 6. Tempestade de Areia (Terra + Vento)
    else if ((_is_earth_hit && _has_wind) || (_is_wind_hit && _has_earth)) {
        _dmg *= 1.20;
        _enemy.knockback_vx += random_range(-140, 140);
        _enemy.knockback_vy += random_range(-140, 140);
        trigger_hitstop(0.08);
        fx_spawn_sparks(_enemy.x, _enemy.y, make_colour_rgb(230, 210, 140), 10);
        fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 10, "AREIA CEGA", true, make_colour_rgb(230, 210, 140));
    }

    if (_is_wind_hit) _enemy.wind_exposed = 3.0;
    if (_is_earth_hit) _enemy.earth_fracture = 3.0;

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
        // 20 Frenesi Ardente (+5% vel ataque ate 6 stacks por 3s)
        if (variable_instance_exists(_owner, "synth_berserk_frenesi_ardente") && _owner.synth_berserk_frenesi_ardente > 0) {
            _owner.frenesi_stacks = min(6, _owner.frenesi_stacks + 1);
            _owner.frenesi_timer = 3.0;
        }

        // 22 Sede de Sangue: Criticos recuperam 15% de vida e prolongam Furia
        if (variable_instance_exists(_owner, "synth_berserk_sede_sangue") && _owner.synth_berserk_sede_sangue > 0 && _is_crit && _dealt > 0) {
            _owner.hp = min(_owner.hp_max, _owner.hp + _dealt * 0.15);
            if (_owner.state == "defend" && _owner.defend_mode == "berserk_fury") {
                _owner.defend_timer += 0.5;
            }
        }

        // 43 Vapor Sagrado (Queimadura + Cura a cada tick)
        if (variable_instance_exists(_owner, "synth_lendario_vapor_sagrado") && _owner.synth_lendario_vapor_sagrado > 0) {
            enemy_apply_poison(_enemy, 5, 0.5, 2.5);
            _owner.hp = min(_owner.hp_max, _owner.hp + 2);
        }

        if (_owner.element_affinity == "fire") {
            enemy_apply_poison(_enemy, 4 + _owner.synth_berserk_burn, 0.5, 2.0);
            if (_owner.synth_berserk_lifesteal > 0 && _dealt > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + _dealt * _owner.synth_berserk_lifesteal);
            }
        } else if (_owner.element_affinity == "water") {
            if (_owner.synth_paladin_heal_hit > 0 && _dealt > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + _owner.synth_paladin_heal_hit);
            }
        }

        // Abate de inimigo (Kill triggers)
        if (_enemy.hp <= 0 && _before_hp > 0) {
            // 13 Gota Purificadora: Remove veneno/queimadura e cura 8 HP
            if (variable_instance_exists(_owner, "synth_paladino_gota_purificadora") && _owner.synth_paladino_gota_purificadora > 0) {
                _owner.poison_active = false;
                _owner.hp = min(_owner.hp_max, _owner.hp + 8);
            }

            // 21 Combustao Espontanea: Inimigos sob Queimadura explodem
            if (variable_instance_exists(_owner, "synth_berserk_combustao_espontanea") && _owner.synth_berserk_combustao_espontanea > 0) {
                var _ex_dmg = _dmg * 0.60;
                var _ex_x = _enemy.x;
                var _ex_y = _enemy.y;
                with (obj_enemy_parent) {
                    if (id != _enemy && point_distance(x, y, _ex_x, _ex_y) <= 80) {
                        enemy_take_damage(id, _ex_dmg, _ex_x, _ex_y, 140);
                        enemy_apply_poison(id, 3, 0.5, 2.0);
                    }
                }
            }

            // 30 Danca das Laminas: +25% velocidade por 2s
            if (variable_instance_exists(_owner, "synth_duelista_danca_laminas") && _owner.synth_duelista_danca_laminas > 0) {
                _owner.dance_speed_timer = 2.0;
            }

            // 48 Cavaleiro do Apocalipse: contador de abates sem sofrer dano
            if (variable_instance_exists(_owner, "synth_lendario_cavaleiro_apocalipse") && _owner.synth_lendario_cavaleiro_apocalipse > 0) {
                _owner.clean_kills_count++;
            }
        }
    } else if (_owner.character_class == "mage") {
        // Criomante / Agua
        if (_owner.element_affinity == "water" || (variable_instance_exists(_owner, "synth_crio_geada_penetrante") && _owner.synth_crio_geada_penetrante > 0)) {
            var _slow = (variable_instance_exists(_owner, "synth_crio_geada_penetrante") && _owner.synth_crio_geada_penetrante > 0) ? 0.30 : 0.20;
            enemy_apply_slow(_enemy, _slow, 2.0);
            if (variable_instance_exists(_owner, "synth_crio_pico_glacial") && _owner.synth_crio_pico_glacial > 0) {
                enemy_apply_slow(_enemy, 0.0, 1.5);
            }
        }

        // Piromante / Fogo
        if (_owner.element_affinity == "fire" || (variable_instance_exists(_owner, "synth_piro_centelha_incandescente") && _owner.synth_piro_centelha_incandescente > 0)) {
            enemy_apply_poison(_enemy, 4, 0.5, 3.0);
        }

        // Aeromante / Vento
        if (_owner.element_affinity == "wind" || (variable_instance_exists(_owner, "synth_aero_arco_eletrico") && _owner.synth_aero_arco_eletrico > 0)) {
            var _chain_dmg = _dmg * 0.40;
            var _ex = _enemy.x;
            var _ey = _enemy.y;
            with (obj_enemy_parent) {
                if (id != _enemy && point_distance(x, y, _ex, _ey) <= 90) {
                    enemy_take_damage(id, _chain_dmg, _ex, _ey, 80);
                    fx_spawn_sparks(x, y, c_yellow, 5);
                    break;
                }
            }
        }

        // Geomante / Terra
        if (_owner.element_affinity == "earth" || (variable_instance_exists(_owner, "synth_geo_projetil_rochoso") && _owner.synth_geo_projetil_rochoso > 0)) {
            var _ang = point_direction(_owner.x, _owner.y, _enemy.x, _enemy.y);
            _enemy.x += lengthdir_x(20, _ang);
            _enemy.y += lengthdir_y(20, _ang);
        }

        // Abate de inimigo (Mage)
        if (_enemy.hp <= 0 && _before_hp > 0) {
            if (variable_instance_exists(_owner, "synth_mage_sifao_alma") && _owner.synth_mage_sifao_alma > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + 3);
            }
            if (variable_instance_exists(_owner, "synth_crio_orvalho_restaurador") && _owner.synth_crio_orvalho_restaurador > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + 8);
            }
            if (variable_instance_exists(_owner, "synth_piro_inferno_expansivo") && _owner.synth_piro_inferno_expansivo > 0) {
                var _ex_x = _enemy.x;
                var _ex_y = _enemy.y;
                var _ex_dmg = _dmg * 0.50;
                with (obj_enemy_parent) {
                    if (id != _enemy && point_distance(x, y, _ex_x, _ex_y) <= 80) {
                        enemy_take_damage(id, _ex_dmg, _ex_x, _ex_y, 120);
                        enemy_apply_poison(id, 3, 0.5, 2.0);
                    }
                }
            }
        }
    } else if (_owner.character_class == "archer") {
        if (_is_crit && variable_instance_exists(_owner, "synth_archer_pontas_farpadas") && _owner.synth_archer_pontas_farpadas > 0) {
            enemy_apply_poison(_enemy, _dmg * 0.20, 0.5, 2.0);
        }
        if (_owner.element_affinity == "water" || (variable_instance_exists(_owner, "synth_archer_glacial_flecha_estalactite") && _owner.synth_archer_glacial_flecha_estalactite > 0)) {
            enemy_apply_slow(_enemy, 0.35, 2.0);
        }
        if (_owner.element_affinity == "fire" || (variable_instance_exists(_owner, "synth_archer_balist_flecha_incendiaria") && _owner.synth_archer_balist_flecha_incendiaria > 0)) {
            enemy_apply_poison(_enemy, 4, 0.5, 3.0);
        }
        if (_owner.element_affinity == "earth" || (variable_instance_exists(_owner, "synth_archer_terra_tremores_impacto") && _owner.synth_archer_terra_tremores_impacto > 0)) {
            enemy_apply_slow(_enemy, 0.30, 1.5);
        }

        // Abate de inimigo (Archer)
        if (_enemy.hp <= 0 && _before_hp > 0) {
            if (variable_instance_exists(_owner, "synth_archer_glacial_brisa_curativa") && _owner.synth_archer_glacial_brisa_curativa > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + 4);
            }
            if (variable_instance_exists(_owner, "synth_archer_saraivada_eterna") && _owner.synth_archer_saraivada_eterna > 0) {
                _owner.defend_cooldown_timer = 0;
            }
        }
    } else if (_owner.character_class == "assassin") {
        var _is_backstab = false;
        var _dot = (_enemy.x - _owner.x) * _enemy.facing_x + (_enemy.y - _owner.y) * _enemy.facing_y;
        if (_dot > 0) {
            _is_backstab = true;
            if (variable_instance_exists(_owner, "synth_assassin_golpe_jugular") && _owner.synth_assassin_golpe_jugular > 0) {
                _dealt *= 1.75;
            }
            if (variable_instance_exists(_owner, "synth_assassin_espect_gota_hemofagica") && _owner.synth_assassin_espect_gota_hemofagica > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + 4);
            }
            if (variable_instance_exists(_owner, "synth_assassin_obsid_fratura_ossea") && _owner.synth_assassin_obsid_fratura_ossea > 0) {
                enemy_apply_slow(_enemy, 0.4, 2.0);
            }
        }

        if (_is_crit && variable_instance_exists(_owner, "synth_assassin_adaga_envenenada") && _owner.synth_assassin_adaga_envenenada > 0) {
            enemy_apply_poison(_enemy, 4, 0.5, 4.0);
        }
        if (_owner.element_affinity == "fire" || (variable_instance_exists(_owner, "synth_assassin_vulcan_corte_incandescente") && _owner.synth_assassin_vulcan_corte_incandescente > 0)) {
            enemy_apply_poison(_enemy, 4, 0.5, 3.0);
        }
        if (_owner.element_affinity == "water" || (variable_instance_exists(_owner, "synth_assassin_espect_adaga_criogenica") && _owner.synth_assassin_espect_adaga_criogenica > 0)) {
            enemy_apply_slow(_enemy, 0.40, 2.0);
        }

        // Abate de inimigo (Assassin)
        if (_enemy.hp <= 0 && _before_hp > 0) {
            if (variable_instance_exists(_owner, "synth_assassin_frenesi_sangue") && _owner.synth_assassin_frenesi_sangue > 0) {
                _owner.dance_speed_timer = 3.0;
            }
            if (variable_instance_exists(_owner, "synth_assassin_ceifador_cosmico") && _owner.synth_assassin_ceifador_cosmico > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + _owner.hp_max * 0.10);
                _owner.invuln_timer = 1.0;
            }
        }
    }
}

function player_perform_attack() {
    var _is_crit = (random(1) < synth_crit_chance);

    // 02 Lamina Afiada: Primeiro golpe apos 2s sem atacar garante 100% critico
    if (variable_instance_exists(id, "synth_lamina_afiada") && synth_lamina_afiada > 0) {
        if (variable_instance_exists(id, "attack_idle_timer") && attack_idle_timer >= 2.0) {
            _is_crit = true;
        }
    }

    // Archer: 09 Tiro Concentrado (1.5s parado garante 100% critico)
    if (character_class == "archer" && variable_instance_exists(id, "synth_archer_tiro_concentrado") && synth_archer_tiro_concentrado > 0) {
        if (variable_instance_exists(id, "archer_stationary_timer") && archer_stationary_timer >= 1.5) {
            _is_crit = true;
        }
    }

    // Assassin: 05 Saque Rapido Letal (100% critico nos primeiros 2s de combate)
    if (character_class == "assassin" && variable_instance_exists(id, "synth_assassin_saque_rapido_letal") && synth_assassin_saque_rapido_letal > 0) {
        if (variable_instance_exists(id, "assassin_entered_room_timer") && assassin_entered_room_timer > 0) {
            _is_crit = true;
        }
    }

    // Assassin: golpe vindo de invisibilidade garante critico com multiplicador elevado
    if (character_class == "assassin" && invisible) {
        _is_crit = true;
        invisible = false;
        if (variable_instance_exists(id, "synth_assassin_emboscada_perfeita") && synth_assassin_emboscada_perfeita > 0) {
            with (obj_enemy_parent) {
                if (point_distance(x, y, other.x, other.y) <= other.attack_range * 2.5) {
                    enemy_apply_slow(id, 0.0, 1.5);
                }
            }
        }
    }

    attack_idle_timer = 0;
    last_attack_was_crit = _is_crit;
    var _dmg = attack_damage * (_is_crit ? synth_crit_mult : 1);

    if (character_class == "knight") {
        if (variable_instance_exists(id, "synth_lendario_avatar_elemental") && synth_lendario_avatar_elemental > 0) {
            _dmg *= 1.25;
        }
        if (element_affinity == "fire" && state == "defend" && defend_mode == "berserk_fury") {
            var _fury_mult = 1.5 + synth_berserk_dmg_bonus;
            if (variable_instance_exists(id, "synth_berserk_cinzas_sacrificio") && synth_berserk_cinzas_sacrificio > 0) {
                if (defend_duration - defend_timer <= 3.0) _fury_mult *= 1.5;
            }
            _dmg *= _fury_mult;
        } else if (element_affinity == "wind" && duelist_combo_count == 1) {
            _dmg *= 1.25;
        } else if (element_affinity == "earth") {
            _dmg *= 1.15;
        }
    } else if (character_class == "mage") {
        if (variable_instance_exists(id, "synth_mage_mente_cristalina") && synth_mage_mente_cristalina > 0 && attack_idle_timer >= 4.0) {
            _dmg *= (1 + synth_mage_mente_cristalina);
        }
        if (variable_instance_exists(id, "synth_mage_avatar_arcano") && synth_mage_avatar_arcano > 0) {
            _dmg *= 1.30;
        }
    } else if (character_class == "archer") {
        if (variable_instance_exists(id, "earth_anchored") && earth_anchored) {
            _dmg *= 1.60;
        }
    } else if (character_class == "assassin") {
        if (variable_instance_exists(id, "synth_assassin_sombra_suprema") && synth_assassin_sombra_suprema > 0 && invisible) {
            _dmg *= 1.50;
        }
    }

    if (attack_is_ranged) {
        var _eff_pierce = synth_pierce_count;
        if (character_class == "archer" && variable_instance_exists(id, "earth_anchored") && earth_anchored) {
            _eff_pierce += 99;
        }

        if (character_class == "archer" && variable_instance_exists(id, "synth_archer_venda_disparo_leque") && synth_archer_venda_disparo_leque > 0) {
            for (var _fi = -1; _fi <= 1; _fi++) {
                var _ang = point_direction(0, 0, facing_x, facing_y) + _fi * 18;
                var _p = instance_create_layer(x + facing_x * 14, y + facing_y * 14, layer, attack_object);
                _p.owner = id;
                _p.damage = _dmg * 0.40;
                _p.dir_x = lengthdir_x(1, _ang);
                _p.dir_y = lengthdir_y(1, _ang);
                _p.speed_px = projectile_speed;
                _p.pierce_remaining = _eff_pierce;
            }
        } else {
            var _sx = x + facing_x * 14;
            var _sy = y + facing_y * 14;
            var _p = instance_create_layer(_sx, _sy, layer, attack_object);
            _p.owner = id;
            _p.damage = _dmg;
            _p.dir_x = facing_x;
            _p.dir_y = facing_y;
            var _spd = projectile_speed;
            if (variable_instance_exists(id, "synth_archer_venda_tiro_supersonico") && synth_archer_venda_tiro_supersonico > 0) _spd *= 1.6;
            if (variable_instance_exists(id, "synth_mage_fluxo_conduzido") && synth_mage_fluxo_conduzido > 0) _spd *= 1.25;
            _p.speed_px = _spd;
            _p.pierce_remaining = _eff_pierce;

            // Mage Eco Magico
            if (character_class == "mage" && variable_instance_exists(id, "synth_mage_eco_magico") && synth_mage_eco_magico > 0) {
                mage_consecutive_hits++;
                if (mage_consecutive_hits mod 4 == 0) {
                    var _rep = instance_create_layer(_sx, _sy, layer, attack_object);
                    _rep.owner = id;
                    _rep.damage = _dmg * 0.50;
                    _rep.dir_x = facing_x;
                    _rep.dir_y = facing_y;
                    _rep.speed_px = _spd * 1.1;
                    _rep.pierce_remaining = 0;
                }
            }

            // Archer Chuva Torrencial
            if (character_class == "archer" && variable_instance_exists(id, "synth_archer_glacial_chuva_torrencial") && synth_archer_glacial_chuva_torrencial > 0) {
                archer_shot_counter++;
                if (archer_shot_counter mod 5 == 0) {
                    for (var _ci = -2; _ci <= 2; _ci++) {
                        if (_ci == 0) continue;
                        var _cang = point_direction(0, 0, facing_x, facing_y) + _ci * 12;
                        var _cp = instance_create_layer(_sx, _sy, layer, attack_object);
                        _cp.owner = id;
                        _cp.damage = _dmg * 0.35;
                        _cp.dir_x = lengthdir_x(1, _cang);
                        _cp.dir_y = lengthdir_y(1, _cang);
                        _cp.speed_px = _spd * 0.95;
                        _cp.pierce_remaining = 0;
                    }
                }
            }
        }
    } else {
        var _range_mult = 0.6;
        var _radius_mult = 0.7;

        if (character_class == "knight") {
            if (element_affinity == "fire" || (variable_instance_exists(id, "synth_berserk_arco_incendiario") && synth_berserk_arco_incendiario > 0)) {
                _range_mult = 0.8;
                _radius_mult = 1.2; // Arco Incendiario (+40% area)
            } else if (element_affinity == "earth") {
                _range_mult = 0.5;
                _radius_mult = 0.75;
            }
        } else if (character_class == "assassin") {
            if (variable_instance_exists(id, "synth_assassin_tufao_lamina_vacuo") && synth_assassin_tufao_lamina_vacuo > 0) {
                _range_mult = 1.2;
                _radius_mult = 1.0;
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

        // Assassin: Laminas Gemeas (segundo corte imediato)
        if (character_class == "assassin" && variable_instance_exists(id, "synth_assassin_laminas_gemeas") && synth_assassin_laminas_gemeas > 0) {
            var _hit2 = instance_create_layer(_hx + facing_x * 4, _hy + facing_y * 4, layer, attack_object);
            _hit2.owner = id;
            _hit2.damage = _dmg * 0.60;
            _hit2.body_radius = attack_range * _radius_mult * 0.9;
        }

        if (character_class == "knight") {
            hit_streak_count++;

            // 15 Golpe da Nascente: cada 3o golpe libera onda curativa
            if (variable_instance_exists(id, "synth_paladino_golpe_nascente") && synth_paladino_golpe_nascente > 0 && (hit_streak_count mod 3 == 0)) {
                var _wave = instance_create_layer(x + facing_x * 20, y + facing_y * 20, layer, obj_atk_fireball);
                _wave.owner = id;
                _wave.damage = _dmg * 0.75;
                _wave.dir_x = facing_x;
                _wave.dir_y = facing_y;
                _wave.speed_px = 320;
                _wave.pierce_remaining = 3;
            }

            // 39 Fissura Telurica: cada 4o golpe racha o chao e atordoa
            if (variable_instance_exists(id, "synth_guardiao_fissura_telurica") && synth_guardiao_fissura_telurica > 0 && (hit_streak_count mod 4 == 0)) {
                var _fis = instance_create_layer(x + facing_x * 35, y + facing_y * 35, layer, obj_atk_knight);
                _fis.owner = id;
                _fis.damage = _dmg * 0.9;
                _fis.body_radius = 45;
                _fis.life = 0.25;
                trigger_hitstop(0.08);
            }

            // 29 Combo Vendaval: segundo golpe dispara rajada cortante de vento
            if (variable_instance_exists(id, "synth_duelista_combo_vendaval") && synth_duelista_combo_vendaval > 0 && duelist_combo_count == 1) {
                var _wind = instance_create_layer(x + facing_x * 20, y + facing_y * 20, layer, obj_atk_arrow);
                _wind.owner = id;
                _wind.damage = _dmg * 0.8;
                _wind.dir_x = facing_x;
                _wind.dir_y = facing_y;
                _wind.speed_px = 380;
                _wind.pierce_remaining = 2;
            }

            // 48 Cavaleiro do Apocalipse: 10 abates sem dano invocam meteoro
            if (variable_instance_exists(id, "synth_lendario_cavaleiro_apocalipse") && synth_lendario_cavaleiro_apocalipse > 0 && clean_kills_count >= 10) {
                clean_kills_count = 0;
                var _met = instance_create_layer(_hx, _hy, layer, obj_atk_knight);
                _met.owner = id;
                _met.damage = _dmg * 3.5;
                _met.body_radius = 90;
                _met.life = 0.35;
                trigger_hitstop(0.15);
            }
        }
    }
}

function player_take_damage(_amount, _damage_type) {
    if (is_undefined(_damage_type)) _damage_type = "physical";

    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;
    if (_p.invuln_timer > 0) return;

    // Nevoa Ilusoria (Assassino): esquiva garantida a cada 20s ao sofrer dano
    if (_p.character_class == "assassin" && variable_instance_exists(_p, "synth_assassin_espect_nevoa_ilusoria") && _p.synth_assassin_espect_nevoa_ilusoria > 0 && variable_instance_exists(_p, "assassin_free_evade_cooldown") && _p.assassin_free_evade_cooldown <= 0) {
        _p.assassin_free_evade_cooldown = 20;
        _p.invuln_timer = 0.5;
        fx_spawn_sparks(_p.x, _p.y, c_aqua, 10);
        return;
    }

    if (random(1) < _p.synth_dodge) return;

    var _defending = (_p.state == "defend" && _p.defend_active);
    var _final = _amount;
    var _blocked_fully = false;
    var _block_mult = max(0.15, 0.5 - _p.synth_block_reduction);

    if (_defending) {
        // 04 Escudo de Choque: descarrega onda conica ao defender
        if (_p.character_class == "knight" && variable_instance_exists(_p, "synth_escudo_choque") && _p.synth_escudo_choque > 0) {
            with (obj_enemy_parent) {
                if (point_distance(x, y, _p.x, _p.y) <= 130) {
                    var _dot = (x - _p.x) * _p.facing_x + (y - _p.y) * _p.facing_y;
                    if (_dot > 0) {
                        enemy_take_damage(id, 10, _p.x, _p.y, 220);
                        enemy_apply_slow(id, 0.4, 0.6);
                    }
                }
            }
        }

        // 40 Bastiao Inabalavel: bloqueio converte 15% em cura
        if (_p.character_class == "knight" && variable_instance_exists(_p, "synth_guardiao_bastiao_inabalavel") && _p.synth_guardiao_bastiao_inabalavel > 0) {
            _p.hp = min(_p.hp_max, _p.hp + _amount * 0.15);
        }

        if (_p.defend_mode == "parry") {
            // Duelista: Aparar bem-sucedido! Anula 100% de dano e desfere contra-ataque de 360 graus
            _final = 0;
            _blocked_fully = true;
            _p.parry_flash_timer = 0.25;
            _p.defend_timer = 0;
            _p.last_attack_was_crit = true;
            trigger_hitstop(0.12);

            // 31 Aparar em Cadeia: reseta cooldown do parry
            if (variable_instance_exists(_p, "synth_duelista_aparar_cadeia") && _p.synth_duelista_aparar_cadeia > 0) {
                _p.defend_cooldown_timer = 0;
            }

            // 32 Vacuo Cortante: puxa inimigos proximos
            if (variable_instance_exists(_p, "synth_duelista_vacuo_cortante") && _p.synth_duelista_vacuo_cortante > 0) {
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _p.x, _p.y) <= 120) {
                        var _ang = point_direction(x, y, _p.x, _p.y);
                        x += lengthdir_x(25, _ang);
                        y += lengthdir_y(25, _ang);
                    }
                }
            }

            // 27 Riposte Perfeito
            var _mult = 2.2 + _p.synth_duelist_counter_mult;
            if (variable_instance_exists(_p, "synth_duelista_riposte_perfeito") && _p.synth_duelista_riposte_perfeito > 0) {
                _mult += 1.0;
            }
            var _counter_dmg = _p.attack_damage * _mult;
            var _counter = instance_create_layer(_p.x, _p.y, _p.layer, obj_atk_knight);
            _counter.owner = _p;
            _counter.damage = _counter_dmg;
            _counter.body_radius = 55;
            _counter.life = 0.18;
            _counter.is_counter = true;
        } else if (_p.defend_mode == "guardian_aegis") {
            _final = 0;
            _blocked_fully = true;
            _p.hit_flash_timer = _p.hit_flash_duration;
            trigger_hitstop(0.06);
        } else if (_p.defend_mode == "paladin_aura") {
            // 12 Bastiao Liquido: absorve 100% de projeteis
            if (variable_instance_exists(_p, "synth_paladino_bastiao_liquido") && _p.synth_paladino_bastiao_liquido > 0 && _damage_type == "projectile") {
                _final = 0;
                _blocked_fully = true;
            }

            if (_p.paladin_barrier_active > 0 && !_blocked_fully) {
                if (_p.paladin_barrier_active >= _final) {
                    _p.paladin_barrier_active -= _final;
                    _final = 0;
                    _blocked_fully = true;
                } else {
                    _final -= _p.paladin_barrier_active;
                    _p.paladin_barrier_active = 0;

                    // 16 Escudo Espelhado: barreira explode ao quebrar
                    if (variable_instance_exists(_p, "synth_paladino_escudo_espelhado") && _p.synth_paladino_escudo_espelhado > 0) {
                        with (obj_enemy_parent) {
                            if (point_distance(x, y, _p.x, _p.y) <= 120) {
                                enemy_take_damage(id, 15, _p.x, _p.y, 200);
                                enemy_apply_slow(id, 0.2, 1.2);
                            }
                        }
                    }
                }
            }
            if (_final > 0 && !_blocked_fully) {
                _final *= 0.60;
            }
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else if (_p.defend_mode == "berserk_fury") {
            _final *= 0.80;
        } else if (_p.defend_mode == "cryo_prison") {
            _final = 0;
            _blocked_fully = true;
            if (variable_instance_exists(_p, "cryo_prison_absorb")) _p.cryo_prison_absorb += _amount;
            _p.hp = min(_p.hp_max, _p.hp + _amount * 0.25);
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else if (_p.defend_mode == "spectral_mist") {
            _final = 0;
            _blocked_fully = true;
        } else if (_p.defend_mode == "obsidian_skin") {
            _final *= 0.20;
            if (_damage_type == "physical") {
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _p.x, _p.y) <= 80) {
                        enemy_take_damage(id, _amount * 0.50, _p.x, _p.y, 160);
                    }
                }
            }
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else if (_p.defend_mode == "earth_anchor") {
            _final *= 0.35;
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else if (_p.defend_mode == "ash_bomb" || _p.defend_mode == "shadowstep") {
            _final = 0;
            _blocked_fully = true;
        } else if (_p.defend_mode == "roll" || _p.defend_mode == "mist_roll" || _p.defend_mode == "cyclone_roll" || _p.defend_mode == "fire_recoil") {
            _final = 0;
            _blocked_fully = true;
        } else if (_p.defend_mode == "block") {
            if (_damage_type == "physical") {
                _final = 0;
                _blocked_fully = true;
            } else {
                _final *= _block_mult;
            }
            _p.hit_flash_timer = _p.hit_flash_duration;
        } else if (_p.defend_mode == "manashield") {
            var _ms_mult = _block_mult;
            if (variable_instance_exists(_p, "synth_mage_ressonancia_foco") && _p.synth_mage_ressonancia_foco > 0) {
                _ms_mult *= 0.75;
            }
            if (_damage_type == "magical") {
                _final = 0;
                _blocked_fully = true;
            } else {
                _final *= _ms_mult;
            }
            if (variable_instance_exists(_p, "synth_crio_armadura_gelo_negro") && _p.synth_crio_armadura_gelo_negro > 0) {
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _p.x, _p.y) <= 70) {
                        enemy_apply_slow(id, 0.1, 1.5);
                    }
                }
            }
            _p.hit_flash_timer = _p.hit_flash_duration;
        }
    }

    if (!_blocked_fully) {
        _p.clean_kills_count = 0;

        var _mitigation = _p.nat_defesa + ((_damage_type == "physical") ? _p.synth_def_fisica : _p.synth_def_magica) + (variable_global_exists("shop_boost_defesa") ? global.shop_boost_defesa : 0);
        if (_p.character_class == "knight" && _p.synth_guardian_def > 0) {
            _mitigation += _p.synth_guardian_def;
        }

        _final = max(1, _final - _mitigation);

        // 26 Furia Imortal: nao morre durante Furia Ardente
        if (_p.defend_mode == "berserk_fury" && variable_instance_exists(_p, "synth_berserk_furia_imortal") && _p.synth_berserk_furia_imortal > 0) {
            if ((_p.hp - _final) <= 0) {
                _final = max(0, _p.hp - 1);
            }
        }

        // 05 Segundo Folego: regenera 20% ao cair para <25% HP
        if (variable_instance_exists(_p, "synth_segundo_folego") && _p.synth_segundo_folego > 0 && _p.segundo_folego_cooldown <= 0) {
            if ((_p.hp - _final) < _p.hp_max * 0.25 && _p.hp > 0) {
                _p.hp = min(_p.hp_max, _p.hp + _p.hp_max * 0.20);
                _p.segundo_folego_cooldown = 60;
                trigger_hitstop(0.12);
            }
        }

        // Fenix Imortal (Mago Piromante): reviver com 35% de HP (1x por run)
        if (_p.character_class == "mage" && variable_instance_exists(_p, "synth_piro_fenix_imortal") && _p.synth_piro_fenix_imortal > 0 && variable_instance_exists(_p, "mage_fenix_used") && !_p.mage_fenix_used) {
            if ((_p.hp - _final) <= 0) {
                _p.mage_fenix_used = true;
                _final = 0;
                _p.hp = min(_p.hp_max, _p.hp_max * 0.35);
                _p.invuln_timer = 1.5;
                trigger_hitstop(0.20);
                fx_spawn_sparks(_p.x, _p.y, c_orange, 25);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _p.x, _p.y) <= 180) {
                        enemy_take_damage(id, 45, _p.x, _p.y, 250, true);
                        enemy_apply_poison(id, 6, 0.4, 3.0);
                    }
                }
                return;
            }
        }

        // Folego Extra geral
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
            global.screen_damage_flash = 0.35;
        }

        // Protecao Mana-Reativa (Mago): repele inimigos em 120px ao perder >= 15% HP
        if (_p.character_class == "mage" && variable_instance_exists(_p, "synth_mage_protecao_mana_reativa") && _p.synth_mage_protecao_mana_reativa > 0) {
            if (_final >= _p.hp_max * 0.15) {
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _p.x, _p.y) <= 120) {
                        var _kdir = point_direction(_p.x, _p.y, x, y);
                        if (variable_instance_exists(id, "knockback_vx")) {
                            knockback_vx += lengthdir_x(260, _kdir);
                            knockback_vy += lengthdir_y(260, _kdir);
                        }
                    }
                }
                trigger_hitstop(0.08);
                fx_spawn_sparks(_p.x, _p.y, c_fuchsia, 12);
            }
        }

        // Recuo de Emergencia (Arqueiro): repele agressor 90px ao sofrer dano fisico
        if (_p.character_class == "archer" && variable_instance_exists(_p, "synth_archer_recuo_emergencia") && _p.synth_archer_recuo_emergencia > 0 && _damage_type == "physical" && variable_instance_exists(_p, "archer_recuo_cooldown") && _p.archer_recuo_cooldown <= 0) {
            _p.archer_recuo_cooldown = 8.0;
            with (obj_enemy_parent) {
                if (point_distance(x, y, _p.x, _p.y) <= 90) {
                    var _kdir = point_direction(_p.x, _p.y, x, y);
                    if (variable_instance_exists(id, "knockback_vx")) {
                        knockback_vx += lengthdir_x(240, _kdir);
                        knockback_vy += lengthdir_y(240, _kdir);
                    }
                }
            }
            fx_spawn_sparks(_p.x, _p.y, c_lime, 8);
        }

        // 25 Vinganca Flamejante: anel de fogo ao sofrer dano
        if (variable_instance_exists(_p, "synth_berserk_vinganca_flamejante") && _p.synth_berserk_vinganca_flamejante > 0 && _damage_type == "physical") {
            with (obj_enemy_parent) {
                if (point_distance(x, y, _p.x, _p.y) <= 70) {
                    enemy_take_damage(id, 18, _p.x, _p.y, 120);
                    enemy_apply_poison(id, 4, 0.5, 1.5);
                }
            }
        }

        // 38 Retaliacao Sismica: devolve 50% de dano
        if (variable_instance_exists(_p, "synth_guardiao_retaliacao_sismica") && _p.synth_guardiao_retaliacao_sismica > 0) {
            var _ret_dmg = _final * 0.50;
            with (obj_enemy_parent) {
                if (point_distance(x, y, _p.x, _p.y) <= 90) {
                    enemy_take_damage(id, _ret_dmg, _p.x, _p.y, 140);
                }
            }
        }

        // Retaliacao classica
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
