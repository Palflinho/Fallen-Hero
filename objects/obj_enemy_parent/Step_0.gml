if (is_world_paused()) exit;

if (!stats_scaled) enemy_ensure_scaling(id);

var _dt = delta_time / 1000000;

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
    fh_move_and_collide(knockback_vx * _dt, knockback_vy * _dt);
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
    poison_tick_timer -= _dt;
    if (poison_tick_timer <= 0) {
        hp -= poison_damage;
        poison_tick_timer = poison_tick_interval;
        hit_flash_timer = hit_flash_duration;
        hp_bar_timer = hp_bar_duration;
        fx_spawn_damage_popup(x, y - body_radius, poison_damage, false, c_lime);
        fx_spawn_sparks(x, y, c_lime, 3);
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

move_speed_effective = move_speed * (slow_active ? slow_multiplier : 1);

if (hp <= 0) {
    player_gain_exp(exp_reward);
    player_gain_gold(gold_reward);

    // Drop raro de Baú de Talento para Monstros Raros / Campeões
    if (variable_instance_exists(id, "is_rare_mob") && is_rare_mob) {
        var _chance = variable_instance_exists(id, "rare_chest_drop_chance") ? rare_chest_drop_chance : 0.20;
        if (random(1) < _chance) {
            var _chest = instance_create_layer(x, y, layer, obj_chest);
            fx_spawn_sparks(x, y, c_yellow, 30);
            fx_spawn_damage_popup(x, y - 24, "✦ BAU DE TALENTO RARO! ✦", false, c_yellow);
        }
    }

    var _is_boss = (object_index == obj_boss || object_index == obj_boss2 || (object_exists(asset_get_index("obj_boss3")) && object_index == asset_get_index("obj_boss3")) || (object_exists(asset_get_index("obj_boss4")) && object_index == asset_get_index("obj_boss4")));
    if (_is_boss) trigger_hitstop(0.25);

    var _killer_class = (instance_exists(obj_player) ? obj_player.character_class : (variable_global_exists("selected_character") ? global.selected_character : "knight"));

    if (object_index == obj_boss) {
        element_unlock("water", _killer_class);
        adaptive_ai_record_boss_defeat("water", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "water");
    } else if (object_index == obj_boss2) {
        element_unlock("fire", _killer_class);
        adaptive_ai_record_boss_defeat("fire", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "fire");
        // Após derrotar General Magma (Fim do Bioma Fogo), abre portal para Fase do Vento (Room5)
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.target_room = asset_get_index("Room5");
        _gate.reward_type = "heal";
        _gate.gate_label = "Avanco: Ruinas dos Ventos (Fase 3 - Cura 40% HP)";
        _gate.gate_colour = make_colour_rgb(180, 240, 255);
    } else if (object_exists(asset_get_index("obj_boss3")) && object_index == asset_get_index("obj_boss3")) {
        element_unlock("wind", _killer_class);
        adaptive_ai_record_boss_defeat("wind", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "wind");
        // Apos derrotar General Zephyrus (Sala 6), abre portal para Fase da Terra (Room7)
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.target_room = asset_get_index("Room7");
        _gate.reward_type = "heal";
        _gate.reward_value = 0;
        _gate.gate_label = "Avanco: Santuario da Terra (Fase 4 - Cura 40% HP)";
        _gate.gate_colour = make_colour_rgb(120, 220, 100);
    } else if (object_exists(asset_get_index("obj_boss4")) && object_index == asset_get_index("obj_boss4")) {
        element_unlock("earth", _killer_class);
        mastery_unlock(_killer_class, "earth");
        adaptive_ai_record_boss_defeat("earth", _killer_class);
        fx_spawn_element_unlocked_popup(x, y, "earth");
        // Derrota do Chefe Final Supremo (Titã Monólito): Vitória Suprema!
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.reward_type = "victory";
        _gate.gate_label = "TRIUNFO SUPREMO: Concluir Expedicao (Vitoria)";
        _gate.gate_colour = c_yellow;
    }

    // Sakurai Juice: tactile death burst and floating rewards
    fx_spawn_death_burst(x, y, body_colour, 16);
    fx_spawn_reward_popup(x, y, exp_reward, gold_reward);

    instance_destroy();
}
