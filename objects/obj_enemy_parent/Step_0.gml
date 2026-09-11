if (is_world_paused()) exit;

var _dt = delta_time / 1000000;

if (hit_flash_timer > 0) hit_flash_timer -= _dt;

// Sakurai Polish: Knockback Physics with Wall Collisions
if (abs(knockback_vx) > 1 || abs(knockback_vy) > 1) {
    fh_move_and_collide(knockback_vx * _dt, knockback_vy * _dt);
    knockback_vx *= power(knockback_friction, _dt * 60);
    knockback_vy *= power(knockback_friction, _dt * 60);
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

move_speed_effective = move_speed * (slow_active ? slow_multiplier : 1);

if (hp <= 0) {
    player_gain_exp(exp_reward);
    player_gain_gold(gold_reward);
    if (object_index == obj_boss) {
        element_unlock("water");
    } else if (object_index == obj_boss2) {
        element_unlock("fire");
    }

    // Sakurai Juice: tactile death burst and floating rewards
    fx_spawn_death_burst(x, y, body_colour, 16);
    fx_spawn_reward_popup(x, y, exp_reward, gold_reward);

    instance_destroy();
}
