var _dt = delta_time / 1000000;

// Calcula dano sofrido antes de restaurar HP
if (hp < hp_max) {
    var _dmg = hp_max - hp;
    dps_accum += _dmg;
    dps_timer = 2.5;
    shake_timer = 0.15;
    hp = hp_max;
    hp_lag = hp_max;
}

if (dps_timer > 0) {
    dps_timer -= _dt;
    if (dps_timer <= 0) {
        last_dps = round(dps_accum / 2.5);
        dps_accum = 0;
    }
}

if (shake_timer > 0) shake_timer -= _dt;

state = "idle";
knockback_vx = 0;
knockback_vy = 0;

event_inherited();

hp = hp_max;
hp_lag = hp_max;
