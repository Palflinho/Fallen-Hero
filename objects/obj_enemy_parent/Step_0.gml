if (is_world_paused()) exit;

var _dt = delta_time / 1000000;

if (hit_flash_timer > 0) hit_flash_timer -= _dt;

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

// Sakurai Polish: Squash & Stretch recovery back to 1.0
scale_x = lerp(scale_x, 1.0, squash_recovery);
scale_y = lerp(scale_y, 1.0, squash_recovery);

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

move_speed_effective = move_speed * (slow_active ? slow_multiplier : 1);

if (hp <= 0) {
    player_gain_exp(exp_reward);
    player_gain_gold(gold_reward);

    var _is_boss = (object_index == obj_boss || object_index == obj_boss2 || (object_exists(asset_get_index("obj_boss3")) && object_index == asset_get_index("obj_boss3")) || (object_exists(asset_get_index("obj_boss4")) && object_index == asset_get_index("obj_boss4")));
    if (_is_boss) trigger_hitstop(0.25);

    if (object_index == obj_boss) {
        element_unlock("water");
        fx_spawn_element_unlocked_popup(x, y, "water");
    } else if (object_index == obj_boss2) {
        element_unlock("fire");
        fx_spawn_element_unlocked_popup(x, y, "fire");
        // Após derrotar General Magma (Fim do Bioma Fogo), abre portal para Fase do Vento (Room5)
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.target_room = asset_get_index("Room5");
        _gate.reward_type = "heal";
        _gate.gate_label = "Avanco: Ruinas dos Ventos (Fase 3 - Cura 40% HP)";
        _gate.gate_colour = make_colour_rgb(180, 240, 255);
    } else if (object_exists(asset_get_index("obj_boss3")) && object_index == asset_get_index("obj_boss3")) {
        element_unlock("wind");
        fx_spawn_element_unlocked_popup(x, y, "wind");
        // Após derrotar General Zephyrus (Sala 6), abre portal para a Loja 2
        var _gate = instance_create_layer(x, y, layer, obj_stage_gate);
        _gate.trigger_mode = "clear_mobs";
        _gate.target_room = asset_get_index("room_shop");
        _gate.reward_type = "gold";
        _gate.reward_value = 100;
        _gate.gate_label = "Descanso: O Mercador Arcano (Intermissao 2 - +100 Ouro)";
        _gate.gate_colour = c_yellow;
    } else if (object_exists(asset_get_index("obj_boss4")) && object_index == asset_get_index("obj_boss4")) {
        element_unlock("earth");
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
