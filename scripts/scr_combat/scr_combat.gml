// Brief shared freeze on an impactful hit (Sakurai's "feedback" principle: confirming an
// impact lands is one of the cheapest, highest-payoff things to add). Reuses
// is_world_paused() so every object that already gates on it freezes for free.
function trigger_hitstop(_duration) {
    global.hitstop_timer = max(global.hitstop_timer, _duration);
    var _rumble_mag = clamp(_duration * 3.5, 0.2, 0.7);
    input_rumble(_rumble_mag, _rumble_mag, _duration);
}

function trigger_camera_shake(_amount) {
    if (!variable_global_exists("camera_shake")) global.camera_shake = 0;
    global.camera_shake = max(global.camera_shake, _amount);
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
    draw_set_font(ui_font());
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

// Chefes principais (Generais + O Salvador). Espiritos das arenas NAO entram aqui:
// eles usam o escalonamento normal de bioma.
function enemy_is_boss(_inst) {
    if (!instance_exists(_inst)) return false;
    var _o = _inst.object_index;
    return (_o == obj_boss || _o == obj_boss2 || _o == obj_boss3 || _o == obj_boss4 || _o == obj_boss_human);
}

function enemy_ensure_scaling(_inst) {
    if (!instance_exists(_inst)) return;
    if (variable_instance_exists(_inst, "stats_scaled") && _inst.stats_scaled) return;
    _inst.stats_scaled = true;

    var _is_boss = enemy_is_boss(_inst);
    if (_is_boss) return;

    var _b = variable_global_exists("run_biome") ? global.run_biome : "water";
    var _hp_mult = 1.0;
    var _atk_mult = 1.0;
    var _def_bonus = 0;
    var _red_mult = 1.0;

    // Escalonamento sequencial progressivo dos 4 Templos
    if (_b == "water") {
        _hp_mult = 1.00;
        _atk_mult = 1.00;
        _def_bonus = 0;
        _red_mult = 1.00;
    } else if (_b == "fire") {
        _hp_mult = 1.50;
        _atk_mult = 1.30;
        _def_bonus = 2;
        _red_mult = 0.90;
    } else if (_b == "wind") {
        _hp_mult = 2.10;
        _atk_mult = 1.65;
        _def_bonus = 4;
        _red_mult = 0.85;
        _inst.move_speed = round(_inst.move_speed * 1.15);
        _inst.move_speed_effective = _inst.move_speed;
    } else if (_b == "earth") {
        _hp_mult = 2.85;
        _atk_mult = 2.10;
        _def_bonus = 6;
        _red_mult = 0.80;
        _inst.knockback_resistance = min(0.9, _inst.knockback_resistance + 0.30);
    }

    if (variable_instance_exists(_inst, "is_rare_mob") && _inst.is_rare_mob) {
        _hp_mult *= 1.45;
        _atk_mult *= 1.25;
        _def_bonus += 2;
    }

    if (variable_instance_exists(_inst, "is_greater_variant") && _inst.is_greater_variant) {
        _hp_mult *= 1.55;
        _atk_mult *= 1.30;
        _def_bonus += 3;
    }

    _inst.hp_max = max(1, round(_inst.hp_max * _hp_mult));
    _inst.hp = _inst.hp_max;
    _inst.contact_damage = max(_inst.contact_damage + 1, round(_inst.contact_damage * _atk_mult));
    _inst.defense = _def_bonus;
    _inst.damage_reduction = _inst.damage_reduction * _red_mult;
    _inst.hp_lag = _inst.hp_max;
    _inst.atk_scale = _atk_mult;
}

function enemy_take_damage(_inst, _amount, _source_x, _source_y, _knockback_force, _is_crit) {
    if (!instance_exists(_inst)) return;
    if (is_undefined(_knockback_force)) _knockback_force = 160;
    if (is_undefined(_is_crit)) _is_crit = false;

    if (variable_instance_exists(_inst, "stats_scaled") && !_inst.stats_scaled) {
        enemy_ensure_scaling(_inst);
    }

    // Ganchos elementais: intangivel (no ar / nevoa / enterrado), salvo interacao de classe
    if (variable_instance_exists(_inst, "fh_untargetable") && _inst.fh_untargetable) {
        if (_inst.fh_bypass_untargetable) _inst.fh_bypass_untargetable = false;
        else return;
    }

    // Carapaca frontal (Slime de Terra, Golem de Pedra): golpes pela frente ricocheteiam
    if (variable_instance_exists(_inst, "fh_shell_hits") && _inst.fh_shell_hits > 0 && !is_undefined(_source_x) && !is_undefined(_source_y)) {
        var _from = point_direction(_inst.x, _inst.y, _source_x, _source_y);
        if (abs(angle_difference(_inst.facing_dir, _from)) <= _inst.fh_shell_arc && _inst.fh_pierce_next > 0) {
            // Templaria / Cavaleiro Sombrio: atravessa a carapaca com dano reduzido e racha 2 placas
            _amount *= _inst.fh_pierce_next;
            _inst.fh_pierce_next = 0;
            if (_inst.fh_shell_hits < 9999) {
                _inst.fh_shell_hits = max(0, _inst.fh_shell_hits - 2);
                if (_inst.fh_shell_hits <= 0) {
                    fx_spawn_damage_popup(_inst.x, _inst.y - 26, "CARAPACA QUEBRADA!", true, c_yellow);
                    _inst.fh_vuln_timer = max(_inst.fh_vuln_timer, 2.5);
                    _inst.defense = 0;
                }
            }
            if (random(1) < 0.35) fx_spawn_damage_popup(_inst.x, _inst.y - 22, "ATRAVESSOU!", false, make_colour_rgb(200, 160, 100));
        } else if (abs(angle_difference(_inst.facing_dir, _from)) <= _inst.fh_shell_arc) {
            _inst.fh_shell_hits -= 1;
            sfx_play("parry", 0.08, 0.7);
            fx_spawn_sparks(_inst.x + lengthdir_x(_inst.body_radius, _from), _inst.y + lengthdir_y(_inst.body_radius, _from), c_ltgray, 6);
            if (_inst.fh_shell_hits <= 0) {
                fx_spawn_damage_popup(_inst.x, _inst.y - 26, "CARAPACA QUEBRADA!", true, c_yellow);
                fx_spawn_sparks(_inst.x, _inst.y, make_colour_rgb(170, 125, 70), 16);
                _inst.fh_vuln_timer = max(_inst.fh_vuln_timer, 2.5);
                _inst.defense = 0;
                _inst.knockback_resistance = max(0, _inst.knockback_resistance - 0.35);
                trigger_hitstop(0.06);
                trigger_camera_shake(4);
            } else {
                fx_spawn_damage_popup(_inst.x, _inst.y - 22, "RICOCHETE!", false, c_ltgray);
            }
            return;
        }
    }

    if (variable_instance_exists(_inst, "fh_pierce_next")) _inst.fh_pierce_next = 0;

    // Escudo de pedra concedido pelo Totem de Terra
    if (variable_instance_exists(_inst, "fh_totem_shield") && _inst.fh_totem_shield > 0) {
        _inst.fh_totem_shield -= 1;
        sfx_play("parry", 0.08, 0.5);
        fx_spawn_damage_popup(_inst.x, _inst.y - 22, "ESCUDO DE PEDRA!", false, make_colour_rgb(200, 160, 100));
        fx_spawn_sparks(_inst.x, _inst.y, make_colour_rgb(200, 160, 100), 6);
        return;
    }

    // Janela de vulnerabilidade apos golpes fortes: +50% de dano
    if (variable_instance_exists(_inst, "fh_vuln_timer") && _inst.fh_vuln_timer > 0) {
        _amount *= 1.5;
    }

    var _is_boss = enemy_is_boss(_inst);

    var _actual_dmg = 0;
    if (_is_boss) {
        if (_inst.damage_reduction <= 0) {
            _actual_dmg = 0;
            fx_spawn_sparks(_inst.x, _inst.y, c_ltgray, 4);
        } else {
            var _mult = _inst.damage_reduction;
            // IA Adaptativa: aplica modificadores de resistencia e fraqueza da mutacao
            if (variable_instance_exists(_inst, "adaptation") && is_struct(_inst.adaptation) && _inst.adaptation.active) {
                var _p = instance_find(obj_player, 0);
                if (_p != noone) {
                    var _is_magic = (_p.character_class == "mage");
                    if (_is_magic) {
                        _mult *= (1 - _inst.adaptation.magic_damage_reduction) * _inst.adaptation.magic_damage_vulnerability;
                    } else {
                        _mult *= (1 - _inst.adaptation.phys_damage_reduction) * _inst.adaptation.phys_damage_vulnerability;
                        // Retaliação de espinhos colados se tiver mutação anti-cavaleiro
                        if (_inst.adaptation.thorns_reflect_damage > 0 && point_distance(_inst.x, _inst.y, _p.x, _p.y) <= 70) {
                            player_take_damage(_inst.adaptation.thorns_reflect_damage, "physical");
                            fx_spawn_sparks(_p.x, _p.y, c_red, 4);
                        }
                    }
                }
            }
            _actual_dmg = max(1, round(_amount * _mult));
        }
    } else {
        var _def = variable_instance_exists(_inst, "defense") ? _inst.defense : 0;
        var _red = variable_instance_exists(_inst, "damage_reduction") ? _inst.damage_reduction : 1.0;
        // Formula de defesa suave com retornos decrescentes:
        // Evita invulnerabilidade mas garante solidez defensiva conforme os templos avancam
        var _def_reduc = (_def > 0) ? (_def / (_def + 18)) : 0;
        var _net = _amount * (1 - _def_reduc) * _red;
        // Piso de dano: todo ataque efetivo causa no minimo 25% do impacto base (minimo 1 de dano)
        var _min_hit = max(1, ceil(_amount * 0.25));
        _actual_dmg = max(_min_hit, round(_net));

        // Afixo de Elite: Baluarte (absorve os primeiros 3 golpes)
        if (variable_instance_exists(_inst, "bulwark_hits") && _inst.bulwark_hits > 0) {
            _inst.bulwark_hits -= 1;
            _actual_dmg = 0;
            sfx_play("parry", 0.05);
            fx_spawn_damage_popup(_inst.x, _inst.y - 20, "BARREIRA ABSORVEU!", false, make_colour_rgb(60, 190, 255));
            fx_spawn_sparks(_inst.x, _inst.y, make_colour_rgb(60, 190, 255), 8);
        }

        // Taticas de Bando: Alerta em cadeia para monstros aliados proximos
        if (_actual_dmg > 0) {
            with (obj_enemy_parent) {
                if (id != _inst && point_distance(x, y, _inst.x, _inst.y) <= 160) {
                    has_spotted_player = true;
                    if (state == "patrol") state = "chase";
                }
            }
        }

        // Quebra de Postura (Stagger) ativada nos mobs a partir da Fase 3
        if (_actual_dmg > 0 && variable_instance_exists(_inst, "has_poise") && _inst.has_poise && _inst.stagger_timer <= 0) {
            _inst.poise_current -= 1;
            if (_inst.poise_current <= 0) {
                _inst.stagger_timer = 1.2;
                _inst.poise_current = _inst.poise_max;
                fx_spawn_damage_popup(_inst.x, _inst.y - 24, "POSTURA QUEBRADA!", true, c_yellow);
                trigger_hitstop(0.08);
                trigger_camera_shake(6);
                sfx_play("stagger", 0.04);
                fx_spawn_sparks(_inst.x, _inst.y, c_yellow, 12);
            }
        }
    }

    if (_actual_dmg > 0) {
        sfx_play("hit", 0.08);
        if (_is_crit) trigger_camera_shake(5);
    }

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
    var _eff_dur = _duration;
    var _p = instance_find(obj_player, 0);
    // Assassin: 42 Mercúrio Líquido (Venenos duram o dobro do tempo e causam 20% de lentidão constante)
    if (_p != noone && _p.character_class == "assassin" && variable_instance_exists(_p, "synth_assassin_obsid_mercurio_liquido") && _p.synth_assassin_obsid_mercurio_liquido > 0) {
        _eff_dur *= 2.0;
        enemy_apply_slow(_inst, 0.80, _eff_dur);
    }
    _inst.poison_active = true;
    _inst.poison_damage = _dmg_per_tick;
    _inst.poison_tick_interval = _tick_interval;
    _inst.poison_tick_timer = _tick_interval;
    _inst.poison_duration = _eff_dur;
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

function player_apply_slow(_multiplier, _duration) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;
    if (variable_instance_exists(_p, "synth_vontade_indomavel") && _p.synth_vontade_indomavel > 0) return;
    // Cavaleiro Runico em Furia nao e contido (imune a lentidao e aprisionamento)
    if (_p.state == "defend" && _p.defend_active && _p.defend_mode == "berserk_fury") return;
    _p.slow_active = true;
    _p.slow_multiplier = _multiplier;
    _p.slow_duration = max(_p.slow_duration, _duration);
    fx_spawn_sparks(_p.x, _p.y, make_colour_rgb(160, 230, 255), 6);
}

// Central place every player attack (melee hitbox or projectile) routes a confirmed hit
// through, so talents that react to "the player damaged an enemy" (execute bonus,
// lifesteal, on-hit poison) only need to be written once.
function player_on_hit_enemy(_owner, _enemy, _base_damage) {
    if (!instance_exists(_enemy)) return;
    // Interacoes de classe (derrubar voadores, interromper, cortar o vento, nucleo...)
    if (instance_exists(_owner) && variable_instance_exists(_owner, "character_class") && variable_instance_exists(_enemy, "fh_air")) {
        _base_damage = class_interaction_on_hit(_owner, _enemy, _base_damage);
        if (_base_damage < 0) return;
    }
    // No ar / na nevoa / enterrado: o golpe atravessa sem efeitos de acerto
    if (variable_instance_exists(_enemy, "fh_untargetable") && _enemy.fh_untargetable && !_enemy.fh_bypass_untargetable) return;

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

        // 39 Peso Esmagador: Criticos de espada causam mini-terremoto atordoando inimigos ao redor
        if (variable_instance_exists(_owner, "synth_guardiao_peso_esmagador") && _owner.synth_guardiao_peso_esmagador > 0 && _is_crit) {
            trigger_hitstop(0.08);
            fx_spawn_sparks(_enemy.x, _enemy.y, make_colour_rgb(160, 100, 50), 16);
            fx_spawn_damage_popup(_enemy.x, _enemy.y - 16, "TREMOR!", false, make_colour_rgb(210, 170, 100));
            with (obj_enemy_parent) {
                if (id != _enemy && point_distance(x, y, _enemy.x, _enemy.y) <= 70) {
                    enemy_take_damage(id, _owner.attack_damage * 0.40, _enemy.x, _enemy.y, 120);
                    enemy_apply_slow(id, 0, 0.4);
                }
            }
        }

        // 46 Tempestade Ignea: Criticos soltam labaredas em circulo (360)
        if (variable_instance_exists(_owner, "synth_lendario_tempestade_ignea") && _owner.synth_lendario_tempestade_ignea > 0 && _is_crit) {
            fx_spawn_death_burst(_enemy.x, _enemy.y, c_orange, 14);
            fx_spawn_damage_popup(_enemy.x, _enemy.y - 20, "LABAREDA!", false, c_orange);
            with (obj_enemy_parent) {
                if (id != _enemy && point_distance(x, y, _enemy.x, _enemy.y) <= 85) {
                    enemy_take_damage(id, _owner.attack_damage * 0.45, _enemy.x, _enemy.y, 160);
                    enemy_apply_poison(id, 4, 0.5, 2.5);
                }
            }
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
    } else if (_owner.character_class == "assassin") {
        _force = 130;
        // Assassin Backstab check BEFORE damage application
        var _efx = variable_instance_exists(_enemy, "facing_x") ? _enemy.facing_x : (variable_instance_exists(_enemy, "facing_dir") ? lengthdir_x(1, _enemy.facing_dir) : 0);
        var _efy = variable_instance_exists(_enemy, "facing_y") ? _enemy.facing_y : (variable_instance_exists(_enemy, "facing_dir") ? lengthdir_y(1, _enemy.facing_dir) : 1);
        var _dot = (_enemy.x - _owner.x) * _efx + (_enemy.y - _owner.y) * _efy;
        if (_dot > 0) {
            _base_damage *= 1.50; // Backstab +50%
            if (variable_instance_exists(_owner, "synth_assassin_golpe_jugular") && _owner.synth_assassin_golpe_jugular > 0) {
                _base_damage *= 1.75;
            }
            fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 12, "BACKSTAB!", true, c_teal);
            trigger_hitstop(0.08);

            // 49 Lamina da Guilhotina (executa alvos com menos de 15% de HP nas costas)
            if (variable_instance_exists(_owner, "synth_assassin_lamina_guilhotina") && _owner.synth_assassin_lamina_guilhotina > 0) {
                if (_enemy.hp_max > 0 && (_enemy.hp / _enemy.hp_max) <= 0.15) {
                    var _is_b = enemy_is_boss(_enemy);
                    if (_is_b) {
                        _base_damage = max(_base_damage, _enemy.hp_max * 0.25);
                    } else {
                        _base_damage = _enemy.hp + 9999;
                    }
                    trigger_hitstop(0.18);
                    fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 18, "* GUILHOTINA! *", true, c_red);
                    fx_spawn_death_burst(_enemy.x, _enemy.y, c_maroon, 20);
                }
            }
        }
        // Cavaleiro Sombrio: bônus massivo contra vida cheia (+60%)
        if (_owner.element_affinity == "earth" && _enemy.hp_max > 0 && (_enemy.hp / _enemy.hp_max) >= 0.85) {
            _base_damage *= 1.60;
            fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 8, "FRATURA", true, c_gray);
        }

        // 08 Execucao Fria (menos de 25% de vida sofrem o dobro de dano)
        if (variable_instance_exists(_owner, "synth_assassin_execucao_fria") && _owner.synth_assassin_execucao_fria > 0) {
            if (_enemy.hp_max > 0 && (_enemy.hp / _enemy.hp_max) <= 0.25) {
                _base_damage *= 2.0;
                fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 14, "EXECUÇÃO FRIA!", true, c_teal);
                fx_spawn_sparks(_enemy.x, _enemy.y, c_teal, 8);
            }
        }

        // 36 Corte de Obsidiana (ignora armadura fisica de elites e chefes)
        if (variable_instance_exists(_owner, "synth_assassin_obsid_corte_obsidiana") && _owner.synth_assassin_obsid_corte_obsidiana > 0) {
            var _is_elite_or_boss = (variable_instance_exists(_enemy, "is_rare_mob") && _enemy.is_rare_mob) || (variable_instance_exists(_enemy, "is_champion") && _enemy.is_champion) || enemy_is_boss(_enemy);
            if (_is_elite_or_boss) {
                _enemy.damage_reduction = 0;
                fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 16, "OBSIDIANA PURA!", true, c_dkgray);
            }
        }

        // 23 Lamina de Magma (dano magico de fogo ignorando armadura fisica)
        if (variable_instance_exists(_owner, "synth_assassin_vulcan_lamina_magma") && _owner.synth_assassin_vulcan_lamina_magma > 0) {
            _enemy.damage_reduction = 0;
            enemy_apply_poison(_enemy, 4, 0.5, 2.5);
            fx_spawn_sparks(_enemy.x, _enemy.y, c_orange, 6);
        }
    } else if (_owner.character_class == "archer") {
        if (_owner.element_affinity == "earth") _force = 220;
        else _force = 150;
        // 08 Flecha Pesada (+50% knockback)
        if (variable_instance_exists(_owner, "synth_archer_flecha_pesada") && _owner.synth_archer_flecha_pesada > 0) {
            _force *= 1.50;
        }
    } else if (_owner.character_class == "mage") {
        if (_owner.element_affinity == "earth") _force = 220;
        else if (_owner.element_affinity == "fire") _force = 180;
        else _force = 140;

        // Mage: 17 Lança de Zero Absoluto (+35% de chance de crítico contra alvos lentos/imobilizados)
        if (variable_instance_exists(_owner, "synth_crio_lanca_zero_absoluto") && _owner.synth_crio_lanca_zero_absoluto > 0) {
            if ((variable_instance_exists(_enemy, "slow_active") && _enemy.slow_active) || (variable_instance_exists(_enemy, "slow_timer") && _enemy.slow_timer > 0)) {
                if (!_is_crit && random(1) < 0.35) {
                    _is_crit = true;
                    _base_damage *= _owner.synth_crit_mult;
                    fx_spawn_damage_popup(_enemy.x, _enemy.y - 18, "ZERO ABSOLUTO!", true, c_aqua);
                }
            }
        }
    }

    var _dmg = _base_damage;
    if (_owner.synth_execute_bonus > 0 && _enemy.hp_max > 0 && (_enemy.hp / _enemy.hp_max) <= 0.3) {
        if (variable_instance_exists(_owner, "synth_fio_carrasco") && _owner.synth_fio_carrasco > 0) {
            fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 12, "CARRASCO!", true, c_red);
        }
        _dmg *= (1 + _owner.synth_execute_bonus);
    }

    // Marca Espectral (Rastreador / Assassino de Água): +50% dano sofrido
    if (variable_instance_exists(_enemy, "spectral_mark") && _enemy.spectral_mark > 0) {
        _dmg *= 1.50;
        fx_spawn_sparks(_enemy.x, _enemy.y, c_teal, 6);
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
    var _orig_def = variable_instance_exists(_enemy, "defense") ? _enemy.defense : 0;
    if (variable_instance_exists(_owner, "synth_piro_ponto_fusao") && _owner.synth_piro_ponto_fusao > 0 && (_is_fire_hit || _owner.character_class == "mage")) {
        _enemy.defense = _orig_def * 0.5;
    }
    enemy_take_damage(_enemy, _dmg, _owner.x, _owner.y, _force, _is_crit);
    _enemy.defense = _orig_def;
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
        // Cavaleiro Runico (Cavaleiro + Fogo -> estilo Maga): o golpe que acerta detona uma runa de fogo em area.
        // Uma runa por golpe; na Furia a runa e maior e mais forte. Como magia, interrompe canalizacoes.
        if (_owner.element_affinity == "fire" && current_time - _owner.rune_blast_last >= 150) {
            _owner.rune_blast_last = current_time;
            var _fury = (_owner.state == "defend" && _owner.defend_active && _owner.defend_mode == "berserk_fury");
            var _rr = _fury ? 72 : 54;
            var _rd = _dmg * (_fury ? 0.50 : 0.35);
            // Talento Runa Ampliada: +40% de raio e +25% de dano
            if (variable_instance_exists(_owner, "synth_berserk_arco_incendiario") && _owner.synth_berserk_arco_incendiario > 0) {
                _rr *= 1.4;
                _rd *= 1.25;
            }
            var _chain = (variable_instance_exists(_owner, "synth_berserk_frenesi_ardente") && _owner.synth_berserk_frenesi_ardente > 0);
            var _rx = _enemy.x;
            var _ry = _enemy.y;
            for (var _rb = 0; _rb < 2; _rb++) {
                var _kill_x = -1;
                var _kill_y = -1;
                with (obj_enemy_parent) {
                    if (hp > 0 && !fh_untargetable && point_distance(x, y, _rx, _ry) <= _rr + body_radius) {
                        enemy_take_damage(id, _rd, _rx, _ry, 120);
                        enemy_apply_poison(id, 2, 0.5, 1.5);
                        if (fh_channeling && !fh_interrupt) {
                            fh_interrupt = true;
                            fx_spawn_damage_popup(x, y - body_radius - 26, "INTERROMPIDO!", true, c_orange);
                        }
                        if (hp <= 0 && _kill_x < 0) {
                            _kill_x = x;
                            _kill_y = y;
                        }
                    }
                }
                fx_spawn_death_burst(_rx, _ry, c_orange, _fury ? 16 : 10);
                // Talento Runa em Cadeia: um abate pela runa acende uma nova runa (1 vez por golpe)
                if (!_chain || _rb > 0 || _kill_x < 0) break;
                _rx = _kill_x;
                _ry = _kill_y;
                fx_spawn_damage_popup(_rx, _ry - 20, "RUNA EM CADEIA!", false, c_orange);
            }
            fx_spawn_sparks(_rx, _ry, c_yellow, 6);
            sfx_play("slam", 0.1, 0.3);
        }

        // 22 Sede de Sangue: Criticos recuperam 15% de vida (max 6 HP) e prolongam Furia
        if (variable_instance_exists(_owner, "synth_berserk_sede_sangue") && _owner.synth_berserk_sede_sangue > 0 && _is_crit && _dealt > 0) {
            _owner.hp = min(_owner.hp_max, _owner.hp + min(6, _dealt * 0.15));
            if (_owner.state == "defend" && _owner.defend_mode == "berserk_fury") {
                _owner.defend_timer += 0.5;
            }
        }

        // 43 Vapor Sagrado (Queimadura + Cura a cada tick)
        if (variable_instance_exists(_owner, "synth_lendario_vapor_sagrado") && _owner.synth_lendario_vapor_sagrado > 0) {
            enemy_apply_poison(_enemy, 5, 0.5, 2.5);
            _owner.hp = min(_owner.hp_max, _owner.hp + 2);
        }

        var _mag_scale = variable_instance_exists(_owner, "synth_pwr_magica") ? _owner.synth_pwr_magica : 0;
        if (_owner.element_affinity == "fire") {
            enemy_apply_poison(_enemy, 4 + _owner.synth_berserk_burn + round(_mag_scale * 0.5), 0.5, 2.0);
            if (_owner.synth_berserk_lifesteal > 0 && _dealt > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + min(5, _dealt * _owner.synth_berserk_lifesteal));
            }
        } else if (_owner.element_affinity == "water") {
            if (_owner.synth_paladin_heal_hit > 0 && _dealt > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + min(8, _owner.synth_paladin_heal_hit + round(_mag_scale * 0.4)));
            }
        }

        // Abate de inimigo (Kill triggers)
        if (_enemy.hp <= 0 && _before_hp > 0) {
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
        // Atiradora Arcana / Agua
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

        // Ilusionista / Vento
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

        // Templaria / Terra
        if (_owner.element_affinity == "earth" || (variable_instance_exists(_owner, "synth_geo_projetil_rochoso") && _owner.synth_geo_projetil_rochoso > 0)) {
            var _ang = point_direction(_owner.x, _owner.y, _enemy.x, _enemy.y);
            _enemy.x += lengthdir_x(20, _ang);
            _enemy.y += lengthdir_y(20, _ang);
        }

        // Mage: 05 Sobrecarga de Feitiço (crítico causa mini-explosão de 50px de raio com 40% dano)
        if (_is_crit && variable_instance_exists(_owner, "synth_mage_sobrecarga_feitico") && _owner.synth_mage_sobrecarga_feitico > 0) {
            var _sc_dmg = _dmg * 0.40;
            var _sc_x = _enemy.x;
            var _sc_y = _enemy.y;
            fx_spawn_sparks(_sc_x, _sc_y, c_fuchsia, 10);
            fx_spawn_damage_popup(_sc_x, _sc_y - 16, "SOBRECARGA!", true, c_fuchsia);
            with (obj_enemy_parent) {
                if (id != _enemy && point_distance(x, y, _sc_x, _sc_y) <= 50) {
                    enemy_take_damage(id, _sc_dmg, _sc_x, _sc_y, 100);
                }
            }
        }

        // Mage: 18 Meteoro Menor (a cada 5 acertos mágicos, despenca meteoro causando 20 de dano em área)
        if (variable_instance_exists(_owner, "synth_piro_meteoro_menor") && _owner.synth_piro_meteoro_menor > 0) {
            if ((_owner.mage_consecutive_hits mod 5) == 0) {
                var _met_x = _enemy.x;
                var _met_y = _enemy.y;
                fx_spawn_death_burst(_met_x, _met_y, c_red, 14);
                fx_spawn_damage_popup(_met_x, _met_y - 20, "METEORO!", true, c_red);
                trigger_hitstop(0.08);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _met_x, _met_y) <= 60) {
                        enemy_take_damage(id, 20, _met_x, _met_y, 140);
                        enemy_apply_poison(id, 3, 0.5, 2.0);
                    }
                }
            }
        }

        // Mage: 28 Condutividade Letal (inimigos lentos ou molhados sofrem dano dobrado de choque)
        if (variable_instance_exists(_owner, "synth_aero_condutividade_letal") && _owner.synth_aero_condutividade_letal > 0) {
            if (_enemy.slow_active || (variable_instance_exists(_enemy, "slow_timer") && _enemy.slow_timer > 0) || fh_place_on_water_puddle(_enemy.x, _enemy.y)) {
                if (_is_wind_hit || _owner.element_affinity == "wind") {
                    enemy_take_damage(_enemy, _dmg, _owner.x, _owner.y, 80);
                    fx_spawn_sparks(_enemy.x, _enemy.y, c_yellow, 12);
                    fx_spawn_damage_popup(_enemy.x, _enemy.y - 16, "CONDUTIVIDADE!", true, c_yellow);
                    enemy_apply_slow(_enemy, 0.2, 3.0);
                }
            }
        }

        // Mage: 38 Coração de Areia (ganha barreira igual a 5% do dano de terra)
        if (variable_instance_exists(_owner, "synth_geo_coracao_areia") && _owner.synth_geo_coracao_areia > 0 && (_is_earth_hit || _owner.element_affinity == "earth")) {
            var _bar_gain = max(1, _dmg * 0.05);
            _owner.paladin_barrier_active = true;
            _owner.paladin_barrier_hp = min(_owner.hp_max * 0.5, _owner.paladin_barrier_hp + _bar_gain);
            _owner.paladin_barrier_timer = 5.0;
            fx_spawn_sparks(_owner.x, _owner.y, make_colour_rgb(210, 180, 110), 4);
        }

        // Mage: 42 Vapor Fulminante (inimigos queimados e congelados liberam vapor fervente)
        if (variable_instance_exists(_owner, "synth_mage_vapor_fulminante") && _owner.synth_mage_vapor_fulminante > 0) {
            if ((_enemy.poison_active && _enemy.slow_active) || (_is_fire_hit && _enemy.slow_active) || (_is_water_hit && _enemy.poison_active)) {
                var _vx = _enemy.x;
                var _vy = _enemy.y;
                fx_spawn_sparks(_vx, _vy, c_white, 14);
                fx_spawn_damage_popup(_vx, _vy - 20, "VAPOR FULMINANTE!", true, c_ltgray);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _vx, _vy) <= 75) {
                        enemy_take_damage(id, _dmg * 0.50, _vx, _vy, 60);
                        enemy_apply_poison(id, 4, 0.4, 2.5);
                    }
                }
            }
        }

        // Mage: 44 Gelo Fendido (impactos de gelo petrificam o chão e congelam inimigos)
        if (variable_instance_exists(_owner, "synth_mage_gelo_fendido") && _owner.synth_mage_gelo_fendido > 0 && (_is_water_hit || _owner.element_affinity == "water")) {
            enemy_apply_slow(_enemy, 0.0, 3.0);
            fx_spawn_sparks(_enemy.x, _enemy.y, c_aqua, 12);
            fx_spawn_damage_popup(_enemy.x, _enemy.y - 18, "GELO FENDIDO!", true, c_aqua);
        }

        // Mage: 45 Tempestade de Plasma (relâmpagos inflamam alvos e soltam arcos em cascata)
        if (variable_instance_exists(_owner, "synth_mage_tempestade_plasma") && _owner.synth_mage_tempestade_plasma > 0 && (_is_wind_hit || _owner.element_affinity == "wind")) {
            enemy_apply_poison(_enemy, 4, 0.5, 2.5);
            var _plasma_source_x = _enemy.x;
            var _plasma_source_y = _enemy.y;
            var _arcs = 0;
            with (obj_enemy_parent) {
                if (id != _enemy && point_distance(x, y, _plasma_source_x, _plasma_source_y) <= 120 && _arcs < 3) {
                    _arcs++;
                    enemy_take_damage(id, _dmg * 0.45, _plasma_source_x, _plasma_source_y, 70);
                    enemy_apply_poison(id, 3, 0.5, 2.0);
                    fx_spawn_sparks(x, y, c_fuchsia, 6);
                }
            }
            if (_arcs > 0) {
                fx_spawn_damage_popup(_plasma_source_x, _plasma_source_y - 20, "PLASMA!", true, c_fuchsia);
            }
        }

        // Mage: 49 Chuva de Cometas (críticos convocam cometas gigantescos esmagando em área)
        if (variable_instance_exists(_owner, "synth_mage_chuva_cometas") && _owner.synth_mage_chuva_cometas > 0 && _is_crit) {
            var _cx = _enemy.x;
            var _cy = _enemy.y;
            fx_spawn_death_burst(_cx, _cy, c_orange, 20);
            fx_spawn_damage_popup(_cx, _cy - 24, "COMETA GIGANTE!", true, c_orange);
            trigger_hitstop(0.12);
            with (obj_enemy_parent) {
                if (point_distance(x, y, _cx, _cy) <= 90) {
                    enemy_take_damage(id, _owner.attack_damage * 1.5, _cx, _cy, 180);
                    enemy_apply_poison(id, 5, 0.5, 3.0);
                }
            }
        }

        // Abate de inimigo (Mage)
        if (_enemy.hp <= 0 && _before_hp > 0) {
            if (variable_instance_exists(_owner, "synth_mage_sifao_alma") && _owner.synth_mage_sifao_alma > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + 3);
            }
            // Talento Lanca Estilhacante: o inimigo abatido estilhaca em 4 fragmentos de gelo
            if (variable_instance_exists(_owner, "synth_crio_orvalho_restaurador") && _owner.synth_crio_orvalho_restaurador > 0 && _owner.element_affinity == "water") {
                for (var _fr = 0; _fr < 4; _fr++) {
                    var _frag = instance_create_layer(_enemy.x, _enemy.y, _owner.layer, obj_atk_fireball);
                    _frag.owner = _owner;
                    _frag.damage = _dmg * 0.6;
                    _frag.dir_x = lengthdir_x(1, _fr * 90 + 45);
                    _frag.dir_y = lengthdir_y(1, _fr * 90 + 45);
                    _frag.speed_px = 300;
                    _frag.life = 0.35;
                    _frag.body_radius = 5;
                    _frag.hit_list = [_enemy];
                }
                fx_spawn_sparks(_enemy.x, _enemy.y, c_aqua, 12);
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

            // Mage: 10 Conhecimento Ancestral (+2 Poder Mágico a cada 15 abates)
            if (variable_instance_exists(_owner, "synth_mage_conhecimento_ancestral") && _owner.synth_mage_conhecimento_ancestral > 0) {
                if (variable_instance_exists(_owner, "mage_run_kills")) {
                    _owner.mage_run_kills++;
                    if ((_owner.mage_run_kills mod 15) == 0 && _owner.mage_run_kills <= 90) {
                        _owner.nat_power += 2;
                        _owner.attack_damage += 2;
                        fx_spawn_damage_popup(_owner.x, _owner.y - 20, "+2 PODER!", true, c_aqua);
                    }
                }
            }

            // Mage: 40 Estilhaço de Basalto (abates de terra explodem em 4 fragmentos)
            if (variable_instance_exists(_owner, "synth_geo_estilhaco_basalto") && _owner.synth_geo_estilhaco_basalto > 0 && (_is_earth_hit || _owner.element_affinity == "earth")) {
                var _ex_x = _enemy.x;
                var _ex_y = _enemy.y;
                fx_spawn_sparks(_ex_x, _ex_y, make_colour_rgb(150, 100, 60), 10);
                fx_spawn_damage_popup(_ex_x, _ex_y - 16, "ESTILHACOS!", true, make_colour_rgb(180, 130, 80));
                var _dirs = [0, 90, 180, 270];
                for (var _di = 0; _di < 4; _di++) {
                    var _frag = instance_create_layer(_ex_x, _ex_y, layer, obj_atk_fireball);
                    _frag.owner = _owner;
                    _frag.damage = 12;
                    _frag.dir_x = lengthdir_x(1, _dirs[_di]);
                    _frag.dir_y = lengthdir_y(1, _dirs[_di]);
                    _frag.speed_px = 220;
                    _frag.pierce_remaining = 3;
                }
            }
        }
    } else if (_owner.character_class == "archer") {
        if (_is_crit && variable_instance_exists(_owner, "synth_archer_pontas_farpadas") && _owner.synth_archer_pontas_farpadas > 0) {
            enemy_apply_poison(_enemy, _dmg * 0.20, 0.5, 2.0);
        }
        if (_is_crit && _owner.element_affinity == "water") {
            _owner.hp = min(_owner.hp_max, _owner.hp + 3);
            fx_spawn_sparks(_owner.x, _owner.y, c_aqua, 4);
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

        // Archer: 10 Saque Rápido (crítico reduz recarga do rolamento em 15%)
        if (_is_crit && variable_instance_exists(_owner, "synth_archer_saque_rapido") && _owner.synth_archer_saque_rapido > 0) {
            _owner.defend_cooldown_timer = max(0, _owner.defend_cooldown_timer - _owner.defend_cooldown * 0.15);
            fx_spawn_damage_popup(_owner.x, _owner.y - 18, "SAQUE RAPIDO!", false, c_yellow);
        }

        // Archer: 14 Flecha Arpão (divide dano com até 2 monstros adjacentes)
        if (variable_instance_exists(_owner, "synth_archer_glacial_flecha_arpao") && _owner.synth_archer_glacial_flecha_arpao > 0) {
            var _ax = _enemy.x;
            var _ay = _enemy.y;
            var _count = 0;
            with (obj_enemy_parent) {
                if (id != _enemy && point_distance(x, y, _ax, _ay) <= 100 && _count < 2) {
                    _count++;
                    enemy_take_damage(id, _dmg * 0.35, _ax, _ay, 40);
                    fx_spawn_sparks(x, y, c_aqua, 5);
                }
            }
            if (_count > 0) fx_spawn_damage_popup(_ax, _ay - 18, "ARPAO!", true, c_aqua);
        }

        // Archer: 17 Perfurador Glacial (dano dobrado em monstros lentos/congelados)
        if (variable_instance_exists(_owner, "synth_archer_glacial_perfurador_glacial") && _owner.synth_archer_glacial_perfurador_glacial > 0) {
            if (_enemy.slow_active || (variable_instance_exists(_enemy, "slow_timer") && _enemy.slow_timer > 0)) {
                _dmg *= 2.0;
                fx_spawn_sparks(_enemy.x, _enemy.y, c_aqua, 12);
                fx_spawn_damage_popup(_enemy.x, _enemy.y - 20, "PERFURADOR!", true, c_aqua);
            }
        }

        // Archer: 19 Tiro de Fragmentação (3º disparo explode fagulhas)
        if (variable_instance_exists(_owner, "synth_archer_balist_tiro_fragmentacao") && _owner.synth_archer_balist_tiro_fragmentacao > 0 && (_owner.archer_shot_counter mod 3 == 0)) {
            var _fx = _enemy.x;
            var _fy = _enemy.y;
            fx_spawn_death_burst(_fx, _fy, c_orange, 10);
            fx_spawn_damage_popup(_fx, _fy - 18, "FRAGMENTACAO!", true, c_orange);
            with (obj_enemy_parent) {
                if (id != _enemy && point_distance(x, y, _fx, _fy) <= 65) {
                    enemy_take_damage(id, 15, _fx, _fy, 80);
                    enemy_apply_poison(id, 3, 0.5, 2.0);
                }
            }
        }

        // Archer: 20 Marca do Purgatório (críticos em chamas detonam em cadeia)
        if (variable_instance_exists(_owner, "synth_archer_balist_marca_purgatorio") && _owner.synth_archer_balist_marca_purgatorio > 0 && _is_crit && _enemy.poison_active) {
            var _mx = _enemy.x;
            var _my = _enemy.y;
            fx_spawn_death_burst(_mx, _my, c_red, 16);
            fx_spawn_damage_popup(_mx, _my - 22, "PURGATORIO!", true, c_red);
            trigger_hitstop(0.08);
            with (obj_enemy_parent) {
                if (point_distance(x, y, _mx, _my) <= 80) {
                    enemy_take_damage(id, _dmg * 0.50, _mx, _my, 120);
                    enemy_apply_poison(id, 4, 0.5, 3.0);
                }
            }
        }

        // Archer: 34 Flecha Enraizadora (a cada 4 acertos prende monstro por 2s)
        if (variable_instance_exists(_owner, "synth_archer_terra_flecha_enraizadora") && _owner.synth_archer_terra_flecha_enraizadora > 0) {
            if (!variable_instance_exists(_enemy, "enraizador_hits")) _enemy.enraizador_hits = 0;
            _enemy.enraizador_hits++;
            if (_enemy.enraizador_hits >= 4) {
                _enemy.enraizador_hits = 0;
                enemy_apply_slow(_enemy, 0.0, 2.0);
                fx_spawn_sparks(_enemy.x, _enemy.y, make_colour_rgb(140, 180, 80), 10);
                fx_spawn_damage_popup(_enemy.x, _enemy.y - 18, "ENRAIZADO!", true, make_colour_rgb(140, 180, 80));
            }
        }

        // Archer: 36 Balista de Obsidiana (35% chance de despedaçar armadura)
        if (variable_instance_exists(_owner, "synth_archer_terra_balista_obsidiana") && _owner.synth_archer_terra_balista_obsidiana > 0 && random(1) < 0.35) {
            _enemy.defense = max(0, _enemy.defense * 0.5);
            _enemy.damage_reduction = min(1.0, _enemy.damage_reduction * 1.35);
            fx_spawn_damage_popup(_enemy.x, _enemy.y - 18, "ARMADURA QUEBRADA!", true, c_dkgray);
        }

        // Archer: 38 Raízes Sanguíneas (+30% dano contra monstros enraizados)
        if (variable_instance_exists(_owner, "synth_archer_terra_raizes_sanguineas") && _owner.synth_archer_terra_raizes_sanguineas > 0) {
            if (_enemy.slow_active && _enemy.slow_multiplier <= 0.1) {
                _dmg *= 1.30;
                fx_spawn_damage_popup(_enemy.x, _enemy.y - 16, "RAIZES SANGUINEAS!", true, c_maroon);
            }
        }

        // Archer: 45 Chuva de Lodo Ácido (dissolve resistências e cura com dano)
        if (variable_instance_exists(_owner, "synth_archer_lodo_acido") && _owner.synth_archer_lodo_acido > 0) {
            _enemy.damage_reduction = min(1.0, _enemy.damage_reduction * 1.25);
            _owner.hp = min(_owner.hp_max, _owner.hp + max(1, _dmg * 0.10));
            fx_spawn_sparks(_owner.x, _owner.y, c_lime, 3);
        }

        // Archer: 47 Olho do Falcão Cósmico (críticos disparam flechas celestes adicionais)
        if (variable_instance_exists(_owner, "synth_archer_falcao_cosmico") && _owner.synth_archer_falcao_cosmico > 0 && _is_crit) {
            var _fcx = _enemy.x;
            var _fcy = _enemy.y;
            fx_spawn_sparks(_fcx, _fcy, c_aqua, 12);
            fx_spawn_damage_popup(_fcx, _fcy - 22, "FALCAO COSMICO!", true, c_aqua);
            with (obj_enemy_parent) {
                if (point_distance(x, y, _fcx, _fcy) <= 85) {
                    enemy_take_damage(id, 25, _fcx, _fcy, 100);
                }
            }
        }

        // Archer: 50 Flecha do Julgamento (a cada 10 tiros lança divina executa com <30% HP)
        if (variable_instance_exists(_owner, "synth_archer_flecha_julgamento") && _owner.synth_archer_flecha_julgamento > 0 && (_owner.archer_shot_counter mod 10 == 0)) {
            fx_spawn_damage_popup(_enemy.x, _enemy.y - 24, "JULGAMENTO DIVINO!", true, c_yellow);
            trigger_hitstop(0.12);
            if (_enemy.hp_max > 0 && (_enemy.hp / _enemy.hp_max) <= 0.30) {
                _dmg = _enemy.hp + 999;
            } else {
                _dmg *= 2.5;
            }
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
        var _efx = variable_instance_exists(_enemy, "facing_x") ? _enemy.facing_x : (variable_instance_exists(_enemy, "facing_dir") ? lengthdir_x(1, _enemy.facing_dir) : 0);
        var _efy = variable_instance_exists(_enemy, "facing_y") ? _enemy.facing_y : (variable_instance_exists(_enemy, "facing_dir") ? lengthdir_y(1, _enemy.facing_dir) : 1);
        var _dot = (_enemy.x - _owner.x) * _efx + (_enemy.y - _owner.y) * _efy;
        if (_dot > 0) {
            _is_backstab = true;
            if (variable_instance_exists(_owner, "synth_assassin_espect_gota_hemofagica") && _owner.synth_assassin_espect_gota_hemofagica > 0) {
                _owner.hp = min(_owner.hp_max, _owner.hp + 4);
            }
            if (variable_instance_exists(_owner, "synth_assassin_obsid_fratura_ossea") && _owner.synth_assassin_obsid_fratura_ossea > 0) {
                enemy_apply_slow(_enemy, 0.4, 2.0);
            }
        }

        // Rastreador (Agua): Marca Espectral (+50% dano sofrido por 4s)
        if (_owner.element_affinity == "water") {
            _enemy.spectral_mark = 4.0;
        }

        // Cavaleiro Sombrio (Terra): Fragmenta armadura do alvo
        if (_owner.element_affinity == "earth") {
            _enemy.damage_reduction = min(1.0, _enemy.damage_reduction * 1.3);
        }

        if (_is_crit && variable_instance_exists(_owner, "synth_assassin_adaga_envenenada") && _owner.synth_assassin_adaga_envenenada > 0) {
            enemy_apply_poison(_enemy, 4, 0.5, 4.0);
        }
        if (_owner.element_affinity == "fire" || (variable_instance_exists(_owner, "synth_assassin_vulcan_corte_incandescente") && _owner.synth_assassin_vulcan_corte_incandescente > 0)) {
            enemy_apply_poison(_enemy, 4, 0.5, 3.0);
        }
        if (_owner.element_affinity == "water") {
            enemy_apply_slow(_enemy, 0.40, 2.0);
        }

        // 13 Afogamento Sombrio (ataques furtivos silenciam e desarmam com bolha d'agua)
        if ((_is_backstab || (variable_instance_exists(_owner, "invisible") && _owner.invisible)) && variable_instance_exists(_owner, "synth_assassin_espect_afogamento_sombrio") && _owner.synth_assassin_espect_afogamento_sombrio > 0) {
            enemy_apply_slow(_enemy, 0.0, 1.5);
            if (variable_instance_exists(_enemy, "attack_timer")) _enemy.attack_timer = max(_enemy.attack_timer, 1.5);
            if (variable_instance_exists(_enemy, "state") && (_enemy.state == "windup" || _enemy.state == "cast")) _enemy.state = "patrol";
            fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 14, "AFOGAMENTO!", true, c_aqua);
            fx_spawn_sparks(_enemy.x, _enemy.y, c_teal, 8);
        }

        // 15 Estocada de Gelo Fino (backstab em alvos lentos congela por 1.5s)
        if (_is_backstab && variable_instance_exists(_owner, "synth_assassin_espect_estocada_gelo_fino") && _owner.synth_assassin_espect_estocada_gelo_fino > 0) {
            if ((variable_instance_exists(_enemy, "slow_active") && _enemy.slow_active) || (variable_instance_exists(_enemy, "slow_timer") && _enemy.slow_timer > 0)) {
                enemy_apply_slow(_enemy, 0.0, 1.5);
                fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 12, "GELO FINO!", true, c_aqua);
                fx_spawn_sparks(_enemy.x, _enemy.y, c_aqua, 10);
            }
        }

        // 19 Estalo de Polvora (3o golpe consecutivo no mesmo alvo explode 25 dano)
        if (variable_instance_exists(_owner, "synth_assassin_vulcan_estalo_polvora") && _owner.synth_assassin_vulcan_estalo_polvora > 0) {
            if (_owner.assassin_last_hit_enemy == _enemy) {
                _owner.assassin_consecutive_hits++;
            } else {
                _owner.assassin_last_hit_enemy = _enemy;
                _owner.assassin_consecutive_hits = 1;
            }
            if (_owner.assassin_consecutive_hits >= 3) {
                _owner.assassin_consecutive_hits = 0;
                enemy_take_damage(_enemy, 25, _owner.x, _owner.y, 140);
                fx_spawn_death_burst(_enemy.x, _enemy.y, c_orange, 12);
                fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 16, "ESTALO!", true, c_orange);
                trigger_hitstop(0.08);
            }
        }

        // 33 Pressao Eolica (cortes de vento reduzem precisao dos alvos)
        if (variable_instance_exists(_owner, "synth_assassin_tufao_pressao_eolica") && _owner.synth_assassin_tufao_pressao_eolica > 0) {
            _enemy.wind_exposed = 3.0;
            fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 12, "PRESSÃO EÓLICA", false, make_colour_rgb(180, 230, 255));
        }

        // 44 Danca do Vapor Letal (queimar alvos envenenados gera vapor corrosivo derretendo armaduras)
        if (variable_instance_exists(_owner, "synth_assassin_vapor_letal") && _owner.synth_assassin_vapor_letal > 0 && _enemy.poison_active) {
            with (obj_enemy_parent) {
                if (point_distance(x, y, _enemy.x, _enemy.y) <= 95) {
                    enemy_take_damage(id, 22, _enemy.x, _enemy.y, 100);
                    damage_reduction = min(1.0, damage_reduction * 1.4);
                }
            }
            fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 14, "VAPOR LETAL!", true, make_colour_rgb(200, 100, 255));
            fx_spawn_death_burst(_enemy.x, _enemy.y, make_colour_rgb(160, 80, 200), 14);
        }

        // 45 Tempestade de Cristal (vento quebra pedras de obsidiana espalhando estilhacos 360)
        if (variable_instance_exists(_owner, "synth_assassin_tempestade_cristal") && _owner.synth_assassin_tempestade_cristal > 0) {
            if ((variable_instance_exists(_enemy, "earth_fracture") && _enemy.earth_fracture > 0) || (_enemy.slow_active)) {
                for (var _tci = 0; _tci < 8; _tci++) {
                    var _tcang = _tci * 45;
                    var _tcarr = instance_create_layer(_enemy.x, _enemy.y, _owner.layer, obj_atk_arrow);
                    _tcarr.owner = _owner;
                    _tcarr.damage = 18;
                    _tcarr.dir_x = lengthdir_x(1, _tcang);
                    _tcarr.dir_y = lengthdir_y(1, _tcang);
                    _tcarr.speed_px = 380;
                    _tcarr.pierce_remaining = 2;
                }
                fx_spawn_damage_popup(_enemy.x, _enemy.y - _enemy.body_radius - 14, "TEMPESTADE DE CRISTAL!", true, make_colour_rgb(220, 240, 255));
                fx_spawn_sparks(_enemy.x, _enemy.y, c_white, 16);
            }
        }

        // 48 Lamina de Plasma Igneo (criticos inflamam e aceleram taxa de ataque em +50% por 3s)
        if (variable_instance_exists(_owner, "synth_assassin_plasma_igneo") && _owner.synth_assassin_plasma_igneo > 0 && _is_crit) {
            enemy_apply_poison(_enemy, 4, 0.5, 3.0);
            _owner.assassin_plasma_buff_timer = 3.0;
            fx_spawn_damage_popup(_owner.x, _owner.y - 24, "PLASMA ÍGNEO!", true, c_yellow);
            fx_spawn_sparks(_owner.x, _owner.y, c_yellow, 10);
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
            // 22 Combustao Fatal (abater com ataques furtivos detona explosao em cadeia)
            if (_is_backstab && variable_instance_exists(_owner, "synth_assassin_vulcan_combustao_fatal") && _owner.synth_assassin_vulcan_combustao_fatal > 0) {
                fx_spawn_death_burst(_enemy.x, _enemy.y, c_red, 16);
                fx_spawn_damage_popup(_enemy.x, _enemy.y - 18, "COMBUSTÃO FATAL!", true, c_red);
                with (obj_enemy_parent) {
                    if (id != _enemy && point_distance(x, y, _enemy.x, _enemy.y) <= 85) {
                        enemy_take_damage(id, 28, _enemy.x, _enemy.y, 120);
                        enemy_apply_poison(id, 4, 0.5, 3.0);
                    }
                }
            }
            // 31 Passo das Sombras (Shadowstep recarrega se o golpe abater o alvo)
            if (variable_instance_exists(_owner, "synth_assassin_tufao_passo_sombras") && _owner.synth_assassin_tufao_passo_sombras > 0) {
                if (_owner.defend_mode == "shadowstep" || _is_backstab) {
                    _owner.defend_cooldown_timer = 0;
                    fx_spawn_damage_popup(_owner.x, _owner.y - 26, "PASSO DAS SOMBRAS!", true, c_fuchsia);
                    fx_spawn_sparks(_owner.x, _owner.y, c_purple, 10);
                }
            }
        }
    }
}

function player_perform_attack() {
    var _eff_crit_chance = min(0.40, synth_crit_chance);
    var _is_crit = (random(1) < _eff_crit_chance);

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
        sfx_play("slash", 0.08);
    } else if (character_class == "mage") {
        sfx_play("magic", 0.08);
    } else if (character_class == "archer") {
        sfx_play("arrow", 0.08);
    } else if (character_class == "assassin") {
        sfx_play("dagger", 0.08);
    }

    if (character_class == "knight") {
        if (variable_instance_exists(id, "synth_lendario_avatar_elemental") && synth_lendario_avatar_elemental > 0) {
            _dmg *= 1.25;
        }
        if (variable_instance_exists(id, "furia_ancestral_timer") && furia_ancestral_timer > 0) {
            _dmg *= 2.0; // Dano dobrado durante Fúria Ancestral (Eco dos Ancestrais)
        }
        if (element_affinity == "fire" && state == "defend" && defend_mode == "berserk_fury") {
            var _mag_bonus = variable_instance_exists(id, "synth_pwr_magica") ? synth_pwr_magica : 0;
            var _fury_mult = 1.5 + synth_berserk_dmg_bonus + (_mag_bonus * 0.05);
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
        if (character_class == "archer") {
            archer_shot_counter++;
            if (variable_instance_exists(id, "earth_anchored") && earth_anchored) {
                _eff_pierce += 99;
            }
            // 18 Balista Piromante: imóvel acumula calor -> velocidade extrema e perfura tudo
            if (variable_instance_exists(id, "synth_archer_balist_balista_piromante") && synth_archer_balist_balista_piromante > 0 && archer_stationary_timer >= 1.5) {
                _eff_pierce += 99;
                _dmg *= 1.35;
                fx_spawn_sparks(x, y - 8, c_orange, 6);
                fx_spawn_damage_popup(x, y - 20, "BALISTA PIROMANTE!", true, c_orange);
            }
        }

        var _sx = x + facing_x * 14;
        var _sy = y + facing_y * 14;
        var _spd = projectile_speed;
        if (variable_instance_exists(id, "synth_archer_venda_tiro_supersonico") && synth_archer_venda_tiro_supersonico > 0) _spd *= 1.6;
        if (character_class == "archer" && variable_instance_exists(id, "synth_archer_balist_balista_piromante") && synth_archer_balist_balista_piromante > 0 && archer_stationary_timer >= 1.5) {
            _spd *= 1.80;
        }
        if (variable_instance_exists(id, "synth_mage_fluxo_conduzido") && synth_mage_fluxo_conduzido > 0) _spd *= 1.25;

        if (character_class == "archer" && variable_instance_exists(id, "synth_archer_venda_tempestade_mil_tiros") && synth_archer_venda_tempestade_mil_tiros > 0 && (archer_shot_counter mod 5 == 0)) {
            // 25 Tempestade de Mil Tiros: torrente de 9 flechas ultrarrápidas em cone
            fx_spawn_damage_popup(x, y - 20, "MIL TIROS!", true, c_lime);
            for (var _fi = -4; _fi <= 4; _fi++) {
                var _ang = point_direction(0, 0, facing_x, facing_y) + _fi * 7;
                var _p = instance_create_layer(_sx, _sy, layer, attack_object);
                _p.owner = id;
                _p.damage = _dmg * 0.35;
                _p.dir_x = lengthdir_x(1, _ang);
                _p.dir_y = lengthdir_y(1, _ang);
                _p.speed_px = _spd * 1.3;
                _p.pierce_remaining = _eff_pierce;
            }
        } else if (character_class == "archer" && variable_instance_exists(id, "synth_archer_terra_tiro_cataclismico") && synth_archer_terra_tiro_cataclismico > 0 && (archer_shot_counter mod 6 == 0)) {
            // 32 Tiro Cataclísmico: flecha colossal perfurante
            var _p = instance_create_layer(_sx, _sy, layer, attack_object);
            _p.owner = id;
            _p.damage = _dmg * 1.75;
            _p.dir_x = facing_x;
            _p.dir_y = facing_y;
            _p.speed_px = _spd * 1.1;
            _p.body_radius = 16;
            _p.pierce_remaining = 99;
            fx_spawn_death_burst(_sx, _sy, make_colour_rgb(160, 110, 50), 16);
            fx_spawn_damage_popup(x, y - 20, "CATACLISMO!", true, make_colour_rgb(180, 140, 70));
            trigger_hitstop(0.08);
        } else if (character_class == "archer" && variable_instance_exists(id, "synth_archer_venda_disparo_leque") && synth_archer_venda_disparo_leque > 0) {
            for (var _fi = -1; _fi <= 1; _fi++) {
                var _ang = point_direction(0, 0, facing_x, facing_y) + _fi * 18;
                var _p = instance_create_layer(_sx, _sy, layer, attack_object);
                _p.owner = id;
                _p.damage = _dmg * 0.40;
                _p.dir_x = lengthdir_x(1, _ang);
                _p.dir_y = lengthdir_y(1, _ang);
                _p.speed_px = _spd;
                _p.pierce_remaining = _eff_pierce;
            }
        } else if (character_class == "mage" && variable_instance_exists(id, "synth_piro_sopro_dragao") && synth_piro_sopro_dragao > 0) {
            // Mage: 22 Sopro de Dragão (cone contínuo a curto alcance)
            for (var _fi = -1; _fi <= 1; _fi++) {
                var _ang = point_direction(0, 0, facing_x, facing_y) + _fi * 15;
                var _p = instance_create_layer(_sx, _sy, layer, attack_object);
                _p.owner = id;
                _p.damage = _dmg * 0.55;
                _p.dir_x = lengthdir_x(1, _ang);
                _p.dir_y = lengthdir_y(1, _ang);
                _p.speed_px = _spd * 1.15;
                _p.life = 0.45;
                _p.pierce_remaining = _eff_pierce + 1;
                fx_spawn_sparks(_sx, _sy, c_orange, 3);
            }
        } else {
            var _p = instance_create_layer(_sx, _sy, layer, attack_object);
            _p.owner = id;
            _p.damage = _dmg;
            _p.dir_x = facing_x;
            _p.dir_y = facing_y;
            _p.speed_px = _spd;
            _p.pierce_remaining = _eff_pierce;
            // Atiradora Arcana (Maga + Agua -> estilo Arqueiro): lancas de gelo rapidas, perfurantes e de longo alcance
            if (character_class == "mage" && element_affinity == "water") {
                _p.speed_px *= 1.35;
                _p.pierce_remaining += 1;
                _p.life *= 1.25;
                // Talento Mira Firme: 1s parada carrega a lanca (+80%, critico, atravessa todos)
                if (variable_instance_exists(id, "synth_crio_armadura_gelo_negro") && synth_crio_armadura_gelo_negro > 0 && archer_stationary_timer >= 1.0) {
                    _p.damage *= 1.8;
                    _p.pierce_remaining = 99;
                    _p.body_radius += 3;
                    last_attack_was_crit = true;
                    archer_stationary_timer = 0;
                    fx_spawn_damage_popup(x, y - 22, "MIRA FIRME!", true, c_aqua);
                    fx_spawn_sparks(_sx, _sy, c_white, 8);
                }
            }
            if (character_class == "archer" && variable_instance_exists(id, "synth_archer_falcao_cosmico") && synth_archer_falcao_cosmico > 0) {
                _p.life = 10.0;
            }
        }

        // 44 Tempestade Ígnea Aérea: cria 3 tornados de fogo móveis a cada 3 tiros
        if (character_class == "archer" && variable_instance_exists(id, "synth_archer_tempestade_ignea") && synth_archer_tempestade_ignea > 0 && (archer_shot_counter mod 3 == 0)) {
            for (var _ti = -1; _ti <= 1; _ti++) {
                var _tang = point_direction(0, 0, facing_x, facing_y) + _ti * 25;
                var _torn = instance_create_layer(_sx, _sy, layer, obj_atk_fireball);
                _torn.owner = id;
                _torn.damage = _dmg * 0.50;
                _torn.dir_x = lengthdir_x(1, _tang);
                _torn.dir_y = lengthdir_y(1, _tang);
                _torn.speed_px = 160;
                _torn.pierce_remaining = 5;
            }
            fx_spawn_sparks(_sx, _sy, c_orange, 10);
            fx_spawn_damage_popup(x, y - 20, "TORNADO IGNEO!", true, c_orange);
        }

        // 47 Atirador Fantasma: clone translúcido atira junto por 3s
        if (character_class == "archer" && variable_instance_exists(id, "archer_phantom_timer") && archer_phantom_timer > 0) {
            var _p2 = instance_create_layer(archer_phantom_x, archer_phantom_y, layer, attack_object);
            _p2.owner = id;
            _p2.damage = _dmg * 0.50;
            _p2.dir_x = facing_x;
            _p2.dir_y = facing_y;
            _p2.speed_px = _spd;
            _p2.pierce_remaining = _eff_pierce;
            fx_spawn_sparks(archer_phantom_x, archer_phantom_y, c_teal, 3);
        }

        // Mage: 24 Passo Céfiro (buff de +10% velocidade pós feitiço por 2s)
        if (character_class == "mage" && variable_instance_exists(id, "synth_aero_passo_cefiro") && synth_aero_passo_cefiro > 0) {
            cefiro_buff_timer = 2.0;
        }

        // Mage: 48 Singularidade Dimensional (a cada 12s, buraco negro desintegra projéteis e suga)
        if (character_class == "mage" && variable_instance_exists(id, "synth_mage_singularidade_dimensional") && synth_mage_singularidade_dimensional > 0 && singularidade_timer <= 0) {
            singularidade_timer = 12.0;
            var _sing_x = x + facing_x * 90;
            var _sing_y = y + facing_y * 90;
            fx_spawn_death_burst(_sing_x, _sing_y, c_purple, 22);
            fx_spawn_damage_popup(_sing_x, _sing_y - 20, "SINGULARIDADE!", true, c_purple);
            trigger_hitstop(0.10);
            with (obj_enemy_projectile) {
                if (point_distance(x, y, _sing_x, _sing_y) <= 120) {
                    fx_spawn_sparks(x, y, c_purple, 4);
                    instance_destroy();
                }
            }
            with (obj_enemy_parent) {
                if (point_distance(x, y, _sing_x, _sing_y) <= 120) {
                    var _sdir = point_direction(x, y, _sing_x, _sing_y);
                    x += lengthdir_x(50, _sdir);
                    y += lengthdir_y(50, _sdir);
                    enemy_take_damage(id, other.attack_damage * 0.6, _sing_x, _sing_y, 0);
                    enemy_apply_slow(id, 0.2, 1.5);
                }
            }
        }

        // ==========================================
        // REFORMULAÇÃO CRIATIVA: MAGO (3º GOLPE)
        // ==========================================
        if (character_class == "mage") {
            mage_consecutive_hits++;

            // 3º Golpe Elemental do Mago
            if (mage_consecutive_hits mod 3 == 0) {
                if (element_affinity == "water" || (variable_instance_exists(id, "synth_crio_onda_torrencial") && synth_crio_onda_torrencial > 0)) {
                    // Atiradora Arcana / 14 Onda Torrencial: arrasta monstros por 150px
                    var _wave_x = x + facing_x * 50;
                    var _wave_y = y + facing_y * 50;
                    var _nova = instance_create_layer(_wave_x, _wave_y, layer, obj_atk_knight);
                    _nova.owner = id;
                    _nova.damage = _dmg * 1.20;
                    _nova.body_radius = 75;
                    _nova.life = 0.35;
                    fx_spawn_sparks(_wave_x, _wave_y, c_aqua, 18);
                    fx_spawn_damage_popup(_wave_x, _wave_y - 18, "ONDA TORRENCIAL!", true, c_aqua);
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, _wave_x, _wave_y) <= 90) {
                            var _push_dist = (variable_instance_exists(other, "synth_crio_onda_torrencial") && other.synth_crio_onda_torrencial > 0) ? 150 : 60;
                            var _nx = x + other.facing_x * _push_dist;
                            var _ny = y + other.facing_y * _push_dist;
                            if (fh_place_free_of_walls(_nx, _ny, 10)) {
                                x = _nx;
                                y = _ny;
                            }
                            enemy_apply_slow(id, 0.0, 2.0);
                        }
                    }
                    trigger_hitstop(0.08);
                } else if (element_affinity == "fire") {
                    // Piromante: Meteoro de Magma devastador com tremor
                    var _met = instance_create_layer(_sx, _sy, layer, obj_atk_fireball);
                    _met.owner = id;
                    _met.damage = _dmg * 1.40;
                    _met.dir_x = facing_x;
                    _met.dir_y = facing_y;
                    _met.speed_px = _spd * 1.25;
                    _met.body_radius = 22;
                    _met.pierce_remaining = 3;
                    fx_spawn_death_burst(_sx, _sy, c_orange, 12);
                    trigger_hitstop(0.08);
                } else if (element_affinity == "wind" || (variable_instance_exists(id, "synth_aero_vortice_cortante") && synth_aero_vortice_cortante > 0)) {
                    // Ilusionista / 27 Vórtice Cortante: puxa inimigos próximos
                    var _vx = x + facing_x * 60;
                    var _vy = y + facing_y * 60;
                    var _vort = instance_create_layer(_vx, _vy, layer, obj_atk_knight);
                    _vort.owner = id;
                    _vort.damage = _dmg * 1.10;
                    _vort.body_radius = 80;
                    _vort.life = 0.30;
                    fx_spawn_sparks(_vx, _vy, c_yellow, 16);
                    fx_spawn_damage_popup(_vx, _vy - 18, "VORTICE CORTANTE!", true, c_yellow);
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, _vx, _vy) <= 130) {
                            var _pa = point_direction(x, y, _vx, _vy);
                            x += lengthdir_x(40, _pa);
                            y += lengthdir_y(40, _pa);
                            enemy_take_damage(id, other.attack_damage * 0.45, _vx, _vy, 0);
                        }
                    }
                } else if (element_affinity == "earth") {
                    // Templaria: Ruptura Sísmica linear perfurante
                    for (var _step = 1; _step <= 3; _step++) {
                        var _rx = x + facing_x * (30 * _step);
                        var _ry = y + facing_y * (30 * _step);
                        if (fh_place_free_of_walls(_rx, _ry, 10)) {
                            var _rup = instance_create_layer(_rx, _ry, layer, obj_atk_knight);
                            _rup.owner = id;
                            _rup.damage = _dmg * 0.80;
                            _rup.body_radius = 32;
                            _rup.life = 0.20;
                            fx_spawn_sparks(_rx, _ry, make_colour_rgb(180, 140, 70), 6);
                        }
                    }
                    trigger_hitstop(0.06);
                }
            }

            // Talento Eco Magico
            if (variable_instance_exists(id, "synth_mage_eco_magico") && synth_mage_eco_magico > 0 && (mage_consecutive_hits mod 4 == 0)) {
                var _rep = instance_create_layer(_sx, _sy, layer, attack_object);
                _rep.owner = id;
                _rep.damage = _dmg * 0.50;
                _rep.dir_x = facing_x;
                _rep.dir_y = facing_y;
                _rep.speed_px = _spd * 1.1;
                _rep.pierce_remaining = 0;
            }
        }

        // ==========================================
        // REFORMULAÇÃO CRIATIVA: ARQUEIRO (3º TIRO)
        // ==========================================
        if (character_class == "archer") {
            archer_shot_counter++;

            // 3º Tiro Elemental do Arqueiro
            if (archer_shot_counter mod 3 == 0) {
                if (element_affinity == "water") {
                    // Cacador das Mares: Disparo Geada Duplo + poca desaceleradora
                    for (var _ti = -1; _ti <= 1; _ti += 2) {
                        var _tang = point_direction(0, 0, facing_x, facing_y) + _ti * 14;
                        var _casc = instance_create_layer(_sx, _sy, layer, obj_atk_arrow);
                        _casc.owner = id;
                        _casc.damage = _dmg * 0.35;
                        _casc.dir_x = lengthdir_x(1, _tang);
                        _casc.dir_y = lengthdir_y(1, _tang);
                        _casc.speed_px = _spd * 1.1;
                        _casc.pierce_remaining = 1;
                    }
                    fx_spawn_sparks(_sx, _sy, c_aqua, 8);
                    if (!instance_exists(obj_water_puddle) || instance_number(obj_water_puddle) < 6) {
                        if (fh_place_free_of_walls(x, y, 8)) {
                            instance_create_layer(x, y, layer, obj_water_puddle);
                        }
                    }
                } else if (element_affinity == "fire") {
                    // Artilheiro Arcano: Morteiro Incendiario + fagulhas
                    var _mort = instance_create_layer(_sx, _sy, layer, obj_atk_fireball);
                    _mort.owner = id;
                    _mort.damage = _dmg * 0.65;
                    _mort.dir_x = facing_x;
                    _mort.dir_y = facing_y;
                    _mort.speed_px = _spd * 0.90;
                    _mort.body_radius = 16;
                    _mort.pierce_remaining = 0;
                    fx_spawn_death_burst(_sx, _sy, c_orange, 6);
                    for (var _mi = -1; _mi <= 1; _mi += 2) {
                        var _mang = point_direction(0, 0, facing_x, facing_y) + _mi * 22;
                        var _sub = instance_create_layer(_sx, _sy, layer, obj_atk_fireball);
                        _sub.owner = id;
                        _sub.damage = _dmg * 0.20;
                        _sub.dir_x = lengthdir_x(1, _mang);
                        _sub.dir_y = lengthdir_y(1, _mang);
                        _sub.speed_px = _spd * 0.95;
                        _sub.pierce_remaining = 0;
                    }
                } else if (element_affinity == "wind") {
                    // Cacador Furtivo: Flecha do Vendaval Perfurante
                    var _son = instance_create_layer(_sx, _sy, layer, obj_atk_arrow);
                    _son.owner = id;
                    _son.damage = _dmg * 0.70;
                    _son.dir_x = facing_x;
                    _son.dir_y = facing_y;
                    _son.speed_px = _spd * 1.5;
                    _son.pierce_remaining = 2;
                    trigger_hitstop(0.04);
                    fx_spawn_sparks(_sx, _sy, c_lime, 8);
                } else if (element_affinity == "earth") {
                    // Sentinela: Virote Sismico com fissura concentrada
                    var _harp = instance_create_layer(_sx, _sy, layer, obj_atk_arrow);
                    _harp.owner = id;
                    _harp.damage = _dmg * 0.75;
                    _harp.dir_x = facing_x;
                    _harp.dir_y = facing_y;
                    _harp.speed_px = _spd * 0.95;
                    _harp.pierce_remaining = 0;
                    var _shock = instance_create_layer(_sx + facing_x * 18, _sy + facing_y * 18, layer, obj_atk_knight);
                    _shock.owner = id;
                    _shock.damage = _dmg * 0.35;
                    _shock.body_radius = 36;
                    _shock.life = 0.18;
                    trigger_hitstop(0.04);
                    fx_spawn_sparks(_sx, _sy, make_colour_rgb(160, 130, 70), 8);
                }
            }

            // Talento Chuva Torrencial
            if (variable_instance_exists(id, "synth_archer_glacial_chuva_torrencial") && synth_archer_glacial_chuva_torrencial > 0 && (archer_shot_counter mod 5 == 0)) {
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
    } else {
        var _range_mult = 0.6;
        var _radius_mult = 0.7;

        if (character_class == "knight") {
            if (element_affinity == "earth") {
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

        // Lanceiro (Cavaleiro + Agua -> estilo Arqueiro): cada golpe solta uma lamina d'agua de longo alcance
        if (character_class == "knight" && element_affinity == "water") {
            // Talento Lamina Perfurante: atravessa +1 e vai 40% mais longe
            var _pierce_t = (variable_instance_exists(id, "synth_paladino_golpe_nascente") && synth_paladino_golpe_nascente > 0);
            // Talento Mare de Laminas: todo 3o golpe dispara 3 laminas em leque
            var _fan_t = (variable_instance_exists(id, "synth_paladino_correnteza_dilacerante") && synth_paladino_correnteza_dilacerante > 0 && ((hit_streak_count + 1) mod 3 == 0));
            var _bdir = point_direction(0, 0, facing_x, facing_y);
            var _bcount = _fan_t ? 3 : 1;
            for (var _bi = 0; _bi < _bcount; _bi++) {
                var _ba = _bdir + (_bcount == 3 ? (_bi - 1) * 15 : 0);
                var _blade = instance_create_layer(x + facing_x * 16, y + facing_y * 16, layer, obj_atk_arrow);
                _blade.owner = id;
                _blade.damage = _dmg * 0.40;
                _blade.dir_x = lengthdir_x(1, _ba);
                _blade.dir_y = lengthdir_y(1, _ba);
                _blade.speed_px = 420;
                _blade.life = _pierce_t ? 0.59 : 0.42;
                _blade.pierce_remaining = _pierce_t ? 1 : 0;
            }
        }

        // Assassin: Laminas Gemeas (segundo corte imediato)
        if (character_class == "assassin" && variable_instance_exists(id, "synth_assassin_laminas_gemeas") && synth_assassin_laminas_gemeas > 0) {
            var _hit2 = instance_create_layer(_hx + facing_x * 4, _hy + facing_y * 4, layer, attack_object);
            _hit2.owner = id;
            _hit2.damage = _dmg * 0.60;
            _hit2.body_radius = attack_range * _radius_mult * 0.9;
        }

        // ==========================================
        // REFORMULAÇÃO CRIATIVA: ASSASSINO (3º GOLPE)
        // ==========================================
        if (character_class == "assassin") {
            assassin_combo_counter++;

            // 32 Reflexos Celere (golpes de adaga destroem projeteis inimigos proximos)
            if (variable_instance_exists(id, "synth_assassin_tufao_reflexos_celere") && synth_assassin_tufao_reflexos_celere > 0) {
                with (obj_enemy_projectile) {
                    if (point_distance(x, y, _hx, _hy) <= other.attack_range * _radius_mult + 18) {
                        fx_spawn_sparks(x, y, c_white, 6);
                        fx_spawn_damage_popup(x, y - 12, "DEFLETIDO!", false, c_white);
                        instance_destroy();
                    }
                }
            }

            // 50 Eco dos Assassinos (critico conjura sombra clone que repete o golpe)
            if (_is_crit && variable_instance_exists(id, "synth_assassin_eco_assassinos") && synth_assassin_eco_assassinos > 0) {
                var _echo = instance_create_layer(_hx + facing_x * 8, _hy + facing_y * 8, layer, attack_object);
                _echo.owner = id;
                _echo.damage = _dmg;
                _echo.body_radius = attack_range * _radius_mult;
                fx_spawn_damage_popup(_hx, _hy - 24, "ECO SOMBRIO!", true, c_purple);
                fx_spawn_sparks(_hx, _hy, c_purple, 10);
            }

            // 31 Tornado de Adagas (a cada 6 ataques dispara vendaval cortante frontal)
            if (variable_instance_exists(id, "synth_assassin_tufao_tornado_adagas") && synth_assassin_tufao_tornado_adagas > 0 && (assassin_combo_counter mod 6 == 0)) {
                var _torn = instance_create_layer(x + facing_x * 18, y + facing_y * 18, layer, obj_atk_arrow);
                _torn.owner = id;
                _torn.damage = _dmg * 1.5;
                _torn.dir_x = facing_x;
                _torn.dir_y = facing_y;
                _torn.speed_px = 420;
                _torn.pierce_remaining = 6;
                fx_spawn_damage_popup(x, y - 26, "TORNADO DE ADAGAS!", true, make_colour_rgb(200, 255, 240));
                fx_spawn_sparks(x, y, c_white, 12);
            }

            // 17 Mare da Ceifa (a cada 4 ataques dispara 8 cortes circulares em 360)
            if (variable_instance_exists(id, "synth_assassin_espect_mare_ceifa") && synth_assassin_espect_mare_ceifa > 0 && (assassin_combo_counter mod 4 == 0)) {
                for (var _mci = 0; _mci < 8; _mci++) {
                    var _mcang = _mci * 45;
                    var _mcl = instance_create_layer(x + lengthdir_x(26, _mcang), y + lengthdir_y(26, _mcang), layer, obj_atk_dagger);
                    _mcl.owner = id;
                    _mcl.damage = _dmg * 0.85;
                    _mcl.dir_x = lengthdir_x(1, _mcang);
                    _mcl.dir_y = lengthdir_y(1, _mcang);
                    _mcl.body_radius = 28;
                    _mcl.life = 0.22;
                }
                fx_spawn_damage_popup(x, y - 28, "MARE DA CEIFA!", true, c_aqua);
                fx_spawn_sparks(x, y, c_teal, 16);
            }

            // 43 Golpe Tectonico (a cada 3 ataques crava adagas gerando terremoto que esmaga e atordoa ao redor)
            if (variable_instance_exists(id, "synth_assassin_obsid_golpe_tectonico") && synth_assassin_obsid_golpe_tectonico > 0 && (assassin_combo_counter mod 3 == 0)) {
                var _tec = instance_create_layer(x, y, layer, obj_atk_knight);
                _tec.owner = id;
                _tec.damage = _dmg * 1.6;
                _tec.body_radius = 65;
                _tec.life = 0.28;
                trigger_hitstop(0.10);
                fx_spawn_damage_popup(x, y - 28, "GOLPE TECTÔNICO!", true, make_colour_rgb(140, 110, 70));
                fx_spawn_sparks(x, y, make_colour_rgb(120, 100, 60), 14);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, other.x, other.y) <= 70) {
                        enemy_apply_slow(id, 0.0, 0.8);
                    }
                }
            }

            // 35 Mil Cortes Invisiveis (a cada 9 ataques fatiamento fulminante em todos os monstros)
            if (variable_instance_exists(id, "synth_assassin_tufao_mil_cortes_invisiveis") && synth_assassin_tufao_mil_cortes_invisiveis > 0 && (assassin_combo_counter mod 9 == 0)) {
                var _cut_targets = [];
                with (obj_enemy_parent) {
                    if (point_distance(other.x, other.y, x, y) <= 240) {
                        array_push(_cut_targets, id);
                        if (array_length(_cut_targets) >= 4) break;
                    }
                }
                if (array_length(_cut_targets) > 0) {
                    fx_spawn_damage_popup(x, y - 32, "* MIL CORTES! *", true, make_colour_rgb(220, 240, 255));
                    trigger_hitstop(0.14);
                    for (var _ti = 0; _ti < array_length(_cut_targets); _ti++) {
                        var _tgt = _cut_targets[_ti];
                        for (var _sk = 0; _sk < 3; _sk++) {
                            var _cut = instance_create_layer(_tgt.x, _tgt.y, layer, obj_atk_dagger);
                            _cut.owner = id;
                            _cut.damage = _dmg * 1.1;
                            _cut.body_radius = 32;
                            _cut.life = 0.2;
                        }
                        fx_spawn_sparks(_tgt.x, _tgt.y, c_white, 8);
                    }
                }
            }

            // 3º Golpe Elemental do Assassino
            if (assassin_combo_counter mod 3 == 0) {
                if (element_affinity == "water") {
                    // Rastreador (Assassino + Agua -> estilo Arqueiro): arremessa 3 facas espectrais em leque.
                    // Cada acerto aplica a Marca Espectral (+50% de dano sofrido por 4s).
                    var _kdir = point_direction(0, 0, facing_x, facing_y);
                    // Talento Leque de Facas: 5 facas em vez de 3
                    var _kn = (variable_instance_exists(id, "synth_assassin_espect_corte_fluido") && synth_assassin_espect_corte_fluido > 0) ? 2 : 1;
                    for (var _k = -_kn; _k <= _kn; _k++) {
                        var _knife = instance_create_layer(x + facing_x * 12, y + facing_y * 12, layer, obj_atk_arrow);
                        _knife.owner = id;
                        _knife.damage = _dmg * 0.9;
                        _knife.dir_x = lengthdir_x(1, _kdir + _k * 10);
                        _knife.dir_y = lengthdir_y(1, _kdir + _k * 10);
                        _knife.speed_px = 460;
                        _knife.life = 0.5;
                        _knife.pierce_remaining = 1;
                    }
                    fx_spawn_sparks(x, y, c_teal, 10);
                    sfx_play("dagger", 0.1, 0.9);
                } else if (element_affinity == "fire") {
                    // Alquimista: Detonação de Pólvora em chamas
                    var _det = instance_create_layer(_hx, _hy, layer, obj_atk_knight);
                    _det.owner = id;
                    _det.damage = _dmg * 1.85;
                    _det.body_radius = 58;
                    _det.life = 0.22;
                    fx_spawn_death_burst(_hx, _hy, c_orange, 14);
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, _hx, _hy) <= 65) {
                            enemy_apply_poison(id, 5, 0.5, 3.0);
                        }
                    }
                    trigger_hitstop(0.09);
                } else if (element_affinity == "wind") {
                    // Algoz do Tufão: Lança Crescentes de Vácuo Voadoras duplas
                    for (var _vi = -1; _vi <= 1; _vi += 2) {
                        var _vang = point_direction(0, 0, facing_x, facing_y) + _vi * 16;
                        var _vac = instance_create_layer(x + facing_x * 12, y + facing_y * 12, layer, obj_atk_arrow);
                        _vac.owner = id;
                        _vac.damage = _dmg * 0.95;
                        _vac.dir_x = lengthdir_x(1, _vang);
                        _vac.dir_y = lengthdir_y(1, _vang);
                        _vac.speed_px = 460;
                        _vac.pierce_remaining = 3;
                    }
                    fx_spawn_sparks(x, y, c_white, 8);
                    trigger_hitstop(0.05);
                } else if (element_affinity == "earth") {
                    // Cavaleiro Sombrio: Fratura Craniana esmagadora
                    var _cst = instance_create_layer(_hx, _hy, layer, obj_atk_knight);
                    _cst.owner = id;
                    _cst.damage = _dmg * 2.4;
                    _cst.body_radius = 50;
                    _cst.life = 0.25;
                    trigger_hitstop(0.12);
                    fx_spawn_sparks(_hx, _hy, c_dkgray, 12);
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, _hx, _hy) <= 55) {
                            enemy_apply_slow(id, 0.25, 2.5);
                        }
                    }
                }
            }
        }

        if (character_class == "knight") {
            hit_streak_count++;

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

    // Mage: 29 Olho do Furacão (+15% esquiva de projéteis em movimento)
    if (_damage_type == "projectile" && _p.character_class == "mage" && variable_instance_exists(_p, "synth_aero_olho_furacao") && _p.synth_aero_olho_furacao > 0 && point_distance(0, 0, _p.vx, _p.vy) > 20) {
        if (random(1) < 0.15) {
            _p.invuln_timer = max(_p.invuln_timer, 0.45);
            fx_spawn_damage_popup(_p.x, _p.y - 20, "ESQUIVA VENTO!", true, make_colour_rgb(180, 240, 255));
            fx_spawn_sparks(_p.x, _p.y, make_colour_rgb(180, 240, 255), 8);
            return;
        }
    }

    // Mage: 32 Armadura de Granito (+6 Defesa Física e imunidade a cortes fracos)
    if (_p.character_class == "mage" && variable_instance_exists(_p, "synth_geo_armadura_granito") && _p.synth_geo_armadura_granito > 0) {
        if (_amount <= 5) {
            fx_spawn_damage_popup(_p.x, _p.y - 20, "GRANITO!", false, c_gray);
            fx_spawn_sparks(_p.x, _p.y, c_gray, 4);
            return;
        }
    }

    if (random(1) < _p.synth_dodge) {
        _p.invuln_timer = max(_p.invuln_timer, 0.45);
        fx_spawn_damage_popup(_p.x, _p.y - 20, "ESQUIVOU!", false, c_aqua);
        fx_spawn_sparks(_p.x, _p.y, c_aqua, 8);
        // Archer: 23 Dança dos Ventos (esquivar concede +100% de vel. ataque para as próximas 2 flechas)
        if (_p.character_class == "archer" && variable_instance_exists(_p, "synth_archer_venda_danca_ventos") && _p.synth_archer_venda_danca_ventos > 0) {
            _p.archer_wind_dance_shots = 2;
            fx_spawn_damage_popup(_p.x, _p.y - 32, "DANCA DOS VENTOS!", true, make_colour_rgb(180, 240, 255));
        }
        // Assassin: 06 Esquiva Reflexa (esquivar recarrega 1s de Invisibilidade)
        if (_p.character_class == "assassin" && variable_instance_exists(_p, "synth_assassin_esquiva_reflexa") && _p.synth_assassin_esquiva_reflexa > 0) {
            if (_p.defend_cooldown_timer > 0) {
                _p.defend_cooldown_timer = max(0, _p.defend_cooldown_timer - 1.0);
                fx_spawn_damage_popup(_p.x, _p.y - 28, "RECARGA SOMBRIA!", false, c_purple);
            }
        }
        // Assassin: 32 Esquiva Espectral (reposiciona instantaneamente nas costas do agressor)
        if (_p.character_class == "assassin" && variable_instance_exists(_p, "synth_assassin_tufao_esquiva_espectral") && _p.synth_assassin_tufao_esquiva_espectral > 0) {
            var _nearest = noone;
            var _ndist = 200;
            with (obj_enemy_parent) {
                var _d = point_distance(_p.x, _p.y, x, y);
                if (_d < _ndist) {
                    _ndist = _d;
                    _nearest = id;
                }
            }
            if (_nearest != noone) {
                var _nfx = variable_instance_exists(_nearest, "facing_x") ? _nearest.facing_x : 0;
                var _nfy = variable_instance_exists(_nearest, "facing_y") ? _nearest.facing_y : 1;
                var _nx = _nearest.x - _nfx * 24;
                var _ny = _nearest.y - _nfy * 24;
                if (fh_place_free_of_walls(_nx, _ny, _p.body_radius)) {
                    _p.x = _nx;
                    _p.y = _ny;
                    _p.facing_x = _nfx;
                    _p.facing_y = _nfy;
                }
                _p.last_attack_was_crit = true;
                fx_spawn_damage_popup(_p.x, _p.y - 24, "ESQUIVA ESPECTRAL!", true, make_colour_rgb(180, 240, 255));
                fx_spawn_sparks(_p.x, _p.y, c_white, 8);
            }
        }
        return;
    }

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

        // 44 Tempestade de Poeira: Bloquear golpes levanta poeira e desorienta atacantes proximos
        if (_p.character_class == "knight" && variable_instance_exists(_p, "synth_lendario_tempestade_poeira") && _p.synth_lendario_tempestade_poeira > 0) {
            fx_spawn_sparks(_p.x, _p.y, make_colour_rgb(180, 170, 140), 12);
            with (obj_enemy_parent) {
                if (point_distance(x, y, _p.x, _p.y) <= 90) {
                    enemy_apply_slow(id, 0.25, 1.5);
                }
            }
        }

        if (_p.defend_mode == "parry") {
            // Duelista: Aparar bem-sucedido! Anula 100% de dano e desfere contra-ataque de 360 graus
            _final = 0;
            _blocked_fully = true;
            _p.parry_flash_timer = 0.25;
            _p.defend_timer = 0;
            _p.last_attack_was_crit = true;
            trigger_hitstop(0.12);
            trigger_camera_shake(6);
            sfx_play("parry", 0.04);

            // 29 Reflexos Celere: Parry concede +25% de velocidade de ataque por 3s
            if (variable_instance_exists(_p, "synth_duelista_reflexos_celere") && _p.synth_duelista_reflexos_celere > 0) {
                _p.parry_haste_timer = 3.0;
                fx_spawn_damage_popup(_p.x, _p.y - 18, "CELERIDADE!", false, c_yellow);
            }

            // 45 Gelo Fendido: Parry projeta estilhacos de gelo contra atacantes proximos
            if (variable_instance_exists(_p, "synth_lendario_gelo_fendido") && _p.synth_lendario_gelo_fendido > 0) {
                fx_spawn_sparks(_p.x, _p.y, c_aqua, 16);
                fx_spawn_damage_popup(_p.x, _p.y - 24, "GELO FENDIDO!", false, c_aqua);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _p.x, _p.y) <= 140) {
                        enemy_take_damage(id, _p.attack_damage * 0.70, _p.x, _p.y, 100);
                        enemy_apply_slow(id, 0.15, 2.0);
                    }
                }
            }

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

            // 27 Riposte Perfeito (escala tambem com synth_pwr_magica)
            var _mag_bonus = variable_instance_exists(_p, "synth_pwr_magica") ? _p.synth_pwr_magica : 0;
            var _mult = 2.2 + _p.synth_duelist_counter_mult + (_mag_bonus * 0.08);
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
                // 39 Armadura Sismica (Carapaca de Obsidiana reflete 50% de dano corpo a corpo)
                if (variable_instance_exists(_p, "synth_assassin_obsid_armadura_sismica") && _p.synth_assassin_obsid_armadura_sismica > 0) {
                    fx_spawn_damage_popup(_p.x, _p.y - 24, "ARMADURA SÍSMICA!", true, c_gray);
                    fx_spawn_sparks(_p.x, _p.y, c_dkgray, 10);
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
            _p.hit_flash_timer = _p.hit_flash_duration;
        }
    }

    if (!_blocked_fully) {
        _p.clean_kills_count = 0;

        // Mitigacao Tatica Inteligente:
        // Dano "physical" (Melee, espinhos, esmagadores, mordidas, investidas) -> mitigado por synth_def_fisica
        // Dano "magical"  (Ranged, projeteis balisticos, pocaws de lava, gas, ciclones) -> mitigado por synth_def_magica
        var _def_bonus = (_damage_type == "physical") ? _p.synth_def_fisica : _p.synth_def_magica;
        var _mitigation = _p.nat_defesa + _def_bonus + (variable_global_exists("shop_boost_defesa") ? global.shop_boost_defesa : 0);
        if (_p.character_class == "knight") {
            if (_p.synth_guardian_def > 0) _mitigation += _p.synth_guardian_def;
            if (variable_instance_exists(_p, "synth_aco_temperado") && _p.synth_aco_temperado > 0) {
                // Aço Temperado: reforço de armadura proporcional ao ouro
            }
            if (variable_instance_exists(_p, "synth_guardiao_carapaca_granito") && _p.synth_guardiao_carapaca_granito > 0) {
                // Carapaça de Granito: armadura pétrea de guardião
            }
        } else if (_p.character_class == "assassin") {
            if (variable_instance_exists(_p, "synth_assassin_obsid_pele_petrea") && _p.synth_assassin_obsid_pele_petrea > 0) {
                // Pele Pétrea: robustez física de obsidiana (+8 defesa física)
            }
        }

        // Fórmula de Armadura com Retornos Decrescentes (Acaba com a invencibilidade mas preserva o papel tanque)
        // Redução percentual suave: def 10 = ~24%, def 20 = ~38%, def 35 = ~52%, teto máximo 68%
        var _reduc = min(0.68, _mitigation / (_mitigation + 32));
        _final = _final * (1 - _reduc);

        // 21 Marca do Enxofre (inimigos queimados causam 30% a menos de dano contra o assassino)
        if (_p.character_class == "assassin" && variable_instance_exists(_p, "synth_assassin_vulcan_marca_enxofre") && _p.synth_assassin_vulcan_marca_enxofre > 0) {
            _final *= 0.70;
        }
        // Piso de Dano Mínimo: Um golpe nunca causa menos que 20% do impacto original (mínimo de 2 de dano)
        // a não ser que tenha sido bloqueado ativamente com escudo ou parry
        var _min_dmg = max(2, ceil(_amount * 0.20));
        _final = max(_min_dmg, round(_final));

        // Absorção de Sobrevida (Barreira Sagrada / Lanceiro)
        if (variable_instance_exists(_p, "paladin_barrier_active") && _p.paladin_barrier_active > 0 && _final > 0) {
            if (_p.paladin_barrier_active >= _final) {
                _p.paladin_barrier_active -= _final;
                _final = 0;
                fx_spawn_damage_popup(_p.x, _p.y - 24, "SOBREVIDA!", false, c_aqua);
                fx_spawn_sparks(_p.x, _p.y, c_aqua, 8);
                trigger_hitstop(0.04);
                input_rumble(0.3, 0.3, 0.12);
            } else {
                _final -= _p.paladin_barrier_active;
                _p.paladin_barrier_active = 0;
                fx_spawn_damage_popup(_p.x, _p.y - 24, "ESCUDO QUEBROU!", false, c_orange);
                fx_spawn_sparks(_p.x, _p.y, c_aqua, 16);
                trigger_hitstop(0.06);
                input_rumble(0.5, 0.5, 0.18);

                // 16 Escudo Espelhado: barreira explode ao quebrar por dano
                if (variable_instance_exists(_p, "synth_paladino_escudo_espelhado") && _p.synth_paladino_escudo_espelhado > 0) {
                    with (obj_enemy_parent) {
                        if (point_distance(x, y, _p.x, _p.y) <= 120) {
                            enemy_take_damage(id, 15, _p.x, _p.y, 200);
                            enemy_apply_slow(id, 0.2, 1.2);
                        }
                    }
                    fx_spawn_sparks(_p.x, _p.y, c_white, 16);
                }
            }
        }

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

        // 50 Eco dos Ancestrais (Cavaleiro Lendario): revive com Furia Ancestral (1x por run)
        if (_p.character_class == "knight" && variable_instance_exists(_p, "synth_lendario_eco_ancestrais") && _p.synth_lendario_eco_ancestrais > 0 && variable_instance_exists(_p, "knight_eco_ancestral_used") && !_p.knight_eco_ancestral_used) {
            if ((_p.hp - _final) <= 0) {
                _p.knight_eco_ancestral_used = true;
                _final = 0;
                _p.hp = 1;
                _p.invuln_timer = 3.5;
                _p.furia_ancestral_timer = 3.5;
                trigger_hitstop(0.20);
                fx_spawn_sparks(_p.x, _p.y, c_yellow, 30);
                fx_spawn_damage_popup(_p.x, _p.y - 24, "FURIA ANCESTRAL!", false, c_yellow);
                with (obj_enemy_parent) {
                    if (point_distance(x, y, _p.x, _p.y) <= 120) {
                        enemy_take_damage(id, 35, _p.x, _p.y, 220, true);
                    }
                }
                return;
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
            trigger_camera_shake(8);
            sfx_play("hit", 0.06);
            input_rumble(0.6, 0.7, 0.22);
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

/// @function player_enter_stealth()
/// @desc Ativa a invisibilidade do jogador e faz todos os inimigos perderem o foco/alvo imediatamente
function player_enter_stealth() {
    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        _player.invisible = true;
    }
    with (obj_enemy_parent) {
        has_spotted_player = false;
        lost_sight_timer = lost_sight_grace;
        if (state == "chase" || state == "windup" || state == "cast") {
            state = "patrol";
        }
    }
}
