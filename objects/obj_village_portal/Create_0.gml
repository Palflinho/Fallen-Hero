vortex_timer = 0;
hum_sound_timer = 1.0;
portal_radius = 48;

// Bonecos de treino ao lado do caminho de saida da vila (ensinam ataque e defesa sem tutorial)
if (!instance_exists(obj_training_dummy)) {
    var _d1 = fh_find_free_spawn_pos(x - 230, y + 640, 20);
    var _dummy_a = instance_create_layer(_d1.x, _d1.y, layer, obj_training_dummy);
    _dummy_a.mode = "static";
    var _d2 = fh_find_free_spawn_pos(x + 230, y + 640, 20);
    var _dummy_b = instance_create_layer(_d2.x, _d2.y, layer, obj_training_dummy);
    _dummy_b.mode = "attacker";
}
