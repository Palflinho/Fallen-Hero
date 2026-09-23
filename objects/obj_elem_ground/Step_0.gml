if (is_world_paused()) exit;

var _dt = delta_time / 1000000;
life -= _dt;
if (life <= 0) {
    instance_destroy();
    exit;
}

// Interacoes: Criomante apaga fogo, Piromante derrete gelo, aura do Paladino purifica o chao
var _pl = instance_find(obj_player, 0);
if (_pl != noone && (kind == "fire" || kind == "slick")) {
    var _counter = (kind == "fire") ? "water" : "fire";
    if (_pl.character_class == "mage" && _pl.element_affinity == _counter) {
        var _fb = instance_nearest(x, y, obj_atk_fireball);
        if (_fb != noone && point_distance(x, y, _fb.x, _fb.y) <= radius + _fb.body_radius) {
            fx_spawn_sparks(x, y, (kind == "fire") ? c_white : c_orange, 6);
            instance_destroy();
            exit;
        }
    }
    if (_pl.state == "defend" && _pl.defend_active && _pl.defend_mode == "paladin_aura" && point_distance(x, y, _pl.x, _pl.y) <= _pl.paladin_aura_radius + radius) {
        fx_spawn_sparks(x, y, c_aqua, 4);
        instance_destroy();
        exit;
    }
}

if (kind == "fire") {
    if (tick_timer > 0) tick_timer -= _dt;
    var _p = elem_player();
    if (_p != noone && tick_timer <= 0 && point_distance(x, y, _p.x, _p.y) <= radius + _p.body_radius * 0.5) {
        player_take_damage(damage, "magical");
        tick_timer = tick_interval;
    }
    if (random(1) < 0.15) fx_spawn_sparks(x + random_range(-radius, radius) * 0.6, y + random_range(-radius, radius) * 0.6, c_orange, 1);
}
