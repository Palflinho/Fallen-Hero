var _dt = delta_time / 1000000;
anim_timer += _dt;
crackle_timer -= _dt;

if (crackle_timer <= 0) {
    crackle_timer = 2.0 + random(2.5);
    sfx_play_at("bonfire_crackle", x, y, 350, 0.08, 0.5);
}

if (random(1) < 0.25) {
    var _ox = random_range(-8, 8);
    var _oy = random_range(-14, -6);
    fx_spawn_sparks(x + _ox, y + _oy, c_orange, 1);
}
