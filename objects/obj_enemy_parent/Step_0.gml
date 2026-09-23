if (is_world_paused()) exit;

if (!stats_scaled) enemy_ensure_scaling(id);

var _dt = delta_time / 1000000;

// Quebra de Postura (Stagger): paralisia temporaria
if (variable_instance_exists(id, "stagger_timer") && stagger_timer > 0) {
    stagger_timer -= _dt;
    scale_x = 1.15;
    scale_y = 0.85;
    exit;
}

// Modo Furia (Enrage) para Fase 3+ quando HP fica critico (< 30%)
if (variable_instance_exists(id, "can_enrage") && can_enrage && !is_enraged && hp <= hp_max * 0.30) {
    is_enraged = true;
    move_speed *= 1.30;
    fx_spawn_damage_popup(x, y - 24, "FURIA!", false, c_red);
    fx_spawn_sparks(x, y, c_red, 14);
}

facing_x = lengthdir_x(1, facing_dir);
facing_y = lengthdir_y(1, facing_dir);

// Histerese para orientação visual horizontal (elimina oscilação em paredes verticais)
if (facing_dir > 105 && facing_dir < 255) {
    facing_h = -1;
} else if (facing_dir < 75 || facing_dir > 285) {
    facing_h = 1;
}

if (hit_flash_timer > 0) {
    hit_flash_timer -= _dt;
    var _p_check = instance_find(obj_player, 0);
    if (_p_check != noone && !_p_check.invisible) {
        has_spotted_player = true;
        if (state == "patrol") state = "chase";
    }
}
if (spider_alert_timer > 0) spider_alert_timer -= _dt;

// Perda imediata e contínua de alvo quando o jogador estiver invisível
var _p_inst = instance_find(obj_player, 0);
if (_p_inst != noone && _p_inst.invisible) {
    has_spotted_player = false;
    lost_sight_timer = lost_sight_grace;
    if (state == "chase" || state == "windup" || state == "cast") {
        state = "patrol";
    }
}

// Sakurai Polish: Knockback Physics with Wall Collisions
if (abs(knockback_vx) > 1 || abs(knockback_vy) > 1) {
    var _on_ice = fh_place_on_ice(x, y);
    var _eff_friction = _on_ice ? 0.985 : knockback_friction;
    var _old_x = x;
    var _old_y = y;
    fh_move_and_collide(knockback_vx * _dt, knockback_vy * _dt);
    // Mage: 37 Espinhos Telúricos (impacto em paredes causa dano dobrado)
    if (point_distance(_old_x, _old_y, x, y) < point_distance(0, 0, knockback_vx * _dt, knockback_vy * _dt) * 0.3) {
        var _p = instance_find(obj_player, 0);
        if (instance_exists(_p) && variable_instance_exists(_p, "synth_geo_espinhos_teluricos") && _p.synth_geo_espinhos_teluricos > 0) {
            enemy_take_damage(id, 14, x, y, 0);
            fx_spawn_sparks(x, y, make_colour_rgb(160, 110, 60), 8);
            fx_spawn_damage_popup(x, y - 16, "ESPINHOS TELURICOS!", true, make_colour_rgb(200, 150, 80));
        }
        // Archer: 33 Flecha Arpão de Pedra (empurrão até parede causa atordoamento de 1s)
        if (instance_exists(_p) && variable_instance_exists(_p, "synth_archer_terra_flecha_arpao_pedra") && _p.synth_archer_terra_flecha_arpao_pedra > 0) {
            enemy_apply_slow(id, 0.0, 1.0);
            fx_spawn_damage_popup(x, y - 18, "ATORDOADO!", true, make_colour_rgb(180, 150, 90));
            fx_spawn_sparks(x, y, make_colour_rgb(180, 150, 90), 6);
        }
    }
    knockback_vx *= power(_eff_friction, _dt * 60);
    knockback_vy *= power(_eff_friction, _dt * 60);
    if (_on_ice && random(1) < 0.25) {
        fx_spawn_sparks(x, y + body_radius, make_colour_rgb(180, 235, 255), 1);
    }
} else {
    knockback_vx = 0;
    knockback_vy = 0;
}

// Sakurai Polish: Squash & Stretch com pulso suave de respiração viva
var _seed = variable_instance_exists(id, "anim_seed") ? anim_seed : (x * 13 + y * 17);
var _breath = (state == "patrol" || state == "idle") ? (0.04 * sin((current_time + _seed * 60) * 0.005)) : 0;
scale_x = lerp(scale_x, 1.0 + _breath, squash_recovery);
scale_y = lerp(scale_y, 1.0 - _breath, squash_recovery);

// Dynamic Combat Health Bar: Timer & Lagging yellow damage bar
if (hp_bar_timer > 0) hp_bar_timer -= _dt;
if (hp_lag > hp) {
    hp_lag = lerp(hp_lag, hp, hp_lag_speed);
} else {
    hp_lag = hp;
}

if (poison_active) {
    poison_duration -= _dt;
    var _tick_mult = 1.0;
    var _p = instance_find(obj_player, 0);
    // Assassin: 47 Gelo Venenoso (Monstros congelados sofrem dano de veneno 3x mais rápido sem descongelar)
    if (_p != noone && variable_instance_exists(_p, "synth_assassin_gelo_venenoso") && _p.synth_assassin_gelo_venenoso > 0) {
        if (slow_active && slow_multiplier <= 0.5) {
            _tick_mult = 3.0;
        }
    }
    poison_tick_timer -= _dt * _tick_mult;
    if (poison_tick_timer <= 0) {
        hp -= poison_damage;
        poison_tick_timer = poison_tick_interval;
        hit_flash_timer = hit_flash_duration;
        hp_bar_timer = hp_bar_duration;
        fx_spawn_damage_popup(x, y - body_radius, poison_damage, false, c_lime);
        fx_spawn_sparks(x, y, c_lime, 3);

        // Assassin: 38 Veneno Petrificante (Inimigos envenenados acumulam toxina até ficarem petrificados por 2s)
        if (_p != noone && variable_instance_exists(_p, "synth_assassin_obsid_veneno_petrificante") && _p.synth_assassin_obsid_veneno_petrificante > 0) {
            if (!variable_instance_exists(id, "petrify_stacks")) petrify_stacks = 0;
            petrify_stacks++;
            if (petrify_stacks >= 3) {
                petrify_stacks = 0;
                enemy_apply_slow(id, 0.0, 2.0);
                fx_spawn_damage_popup(x, y - body_radius - 14, "PETRIFICADO!", true, c_gray);
                fx_spawn_sparks(x, y, c_dkgray, 10);
            }
        }
    }
    if (poison_duration <= 0) poison_active = false;
}

if (slow_active) {
    slow_duration -= _dt;
    if (slow_duration <= 0) {
        slow_active = false;
        slow_multiplier = 1;
    }
}

if (variable_instance_exists(id, "wind_exposed") && wind_exposed > 0) wind_exposed -= _dt;
if (variable_instance_exists(id, "earth_fracture") && earth_fracture > 0) earth_fracture -= _dt;
if (variable_instance_exists(id, "spectral_mark") && spectral_mark > 0) spectral_mark -= _dt;

if (fh_vuln_timer > 0) fh_vuln_timer -= _dt;
if (fh_revealed > 0) fh_revealed -= _dt;
fh_bypass_untargetable = false;

move_speed_effective = move_speed * (slow_active ? slow_multiplier : 1);
if (fh_haste_timer > 0) {
    fh_haste_timer -= _dt;
    move_speed_effective *= 1.35;
}

if (hp <= 0) {
    player_gain_exp(exp_reward);
    player_gain_gold(gold_reward);

    // Drop raro de Baú de Talento para Monstros Raros / Campeões
    if (variable_instance_exists(id, "is_rare_mob") && is_rare_mob) {
        var _chance = variable_instance_exists(id, "rare_chest_drop_chance") ? rare_chest_drop_chance : 0.20;
        if (random(1) < _chance) {
            var _chest = instance_create_layer(x, y, layer, obj_chest);
            fx_spawn_sparks(x, y, c_yellow, 30);
            fx_spawn_damage_popup(x, y - 24, "* BAU DE TALENTO RARO! *", false, c_yellow);
        }
    }

    // Explosão póstuma de afixo de elite "spore"
    if (variable_instance_exists(id, "elite_affix") && elite_affix == "spore") {
        if (object_exists(asset_get_index("obj_lava_pool"))) {
            instance_create_layer(x, y, layer, asset_get_index("obj_lava_pool"));
            fx_spawn_sparks(x, y, c_orange, 15);
        }
    }

    var _is_boss = enemy_is_boss(id);
    if (_is_boss) {
        trigger_hitstop(0.25);
        // Ajudantes do chefe (orbes, drones) somem junto com ele
        with (obj_boss_drone) instance_destroy();
        with (obj_elem_missile) instance_destroy();
    }

    var _killer_class = (instance_exists(obj_player) ? obj_player.character_class : (variable_global_exists("selected_character") ? global.selected_character : "knight"));

    if (object_index == obj_boss) {
        element_unlock("water", _killer_class);
        reclaim_element("water");
        adaptive_ai_record_boss_defeat("water", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "water");
    } else if (object_index == obj_boss2) {
        element_unlock("fire", _killer_class);
        reclaim_element("fire");
        adaptive_ai_record_boss_defeat("fire", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "fire");
        // Após derrotar General Magma (Fim do Bioma Fogo), abre portal para Fase do Vento (Room5)
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.target_room = asset_get_index("Room5");
        _gate.reward_type = "heal";
        _gate.gate_label = tr("Avanco: Ruinas dos Ventos (Fase 3 - Cura 40% HP)");
        _gate.gate_colour = make_colour_rgb(180, 240, 255);
    } else if (object_exists(asset_get_index("obj_boss3")) && object_index == asset_get_index("obj_boss3")) {
        element_unlock("wind", _killer_class);
        reclaim_element("wind");
        adaptive_ai_record_boss_defeat("wind", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "wind");
        // Apos derrotar General Zephyrus (Sala 6), abre portal para Fase da Terra (Room7)
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.target_room = asset_get_index("Room7");
        _gate.reward_type = "heal";
        _gate.reward_value = 0;
        _gate.gate_label = tr("Avanco: Santuario da Terra (Fase 4 - Cura 40% HP)");
        _gate.gate_colour = make_colour_rgb(120, 220, 100);
    } else if (object_exists(asset_get_index("obj_boss4")) && object_index == asset_get_index("obj_boss4")) {
        element_unlock("earth", _killer_class);
        reclaim_element("earth");
        mastery_unlock(_killer_class, "earth");
        adaptive_ai_record_boss_defeat("earth", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "earth");
        // Derrota do Chefe Titã Monólito: abre portal de retorno à Vila Subterrânea para acessar o Templo 5
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.target_room = asset_get_index("room_village");
        _gate.reward_type = "heal";
        _gate.gate_label = tr("Retorno Ancestral: Vila Subterranea (Abrir Templo 5)");
        _gate.gate_colour = c_yellow;
    } else if (object_exists(asset_get_index("obj_boss_human")) && object_index == asset_get_index("obj_boss_human")) {
        // Conquista final: O Salvador foi vencido!
        global.run_victory = true;
        sfx_play("victory", 0.08, 1.0);
        trigger_camera_shake(8);
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.reward_type = "victory";
        _gate.gate_label = tr("TRIUNFO SUPREMO: Concluir Expedicao (Vitoria)");
        _gate.gate_colour = c_yellow;
    } else {
        sfx_play_at("enemy_death", x, y, 450, 0.08);
    }

    // Sakurai Juice: tactile death burst and floating rewards
    fx_spawn_death_burst(x, y, body_colour, 16);
    fx_spawn_reward_popup(x, y, exp_reward, gold_reward);

    instance_destroy();
}
