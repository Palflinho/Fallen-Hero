var _dt = delta_time / 1000000;

if (hit_flash_timer > 0) hit_flash_timer -= _dt;

if (poison_active) {
    poison_duration -= _dt;
    poison_tick_timer -= _dt;
    if (poison_tick_timer <= 0) {
        hp -= poison_damage;
        poison_tick_timer = poison_tick_interval;
        hit_flash_timer = hit_flash_duration;
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
    instance_destroy();
}
