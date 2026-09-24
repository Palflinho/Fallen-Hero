if (instance_exists(asset_get_index("obj_dungeon_generator"))) exit;

if (!variable_global_exists("run_biome")) global.run_biome = "water";
var _b = global.run_biome;

var _spawn_safe = function(_obj, _sx, _sy) {
    if (_obj == -1 || !object_exists(_obj)) return noone;
    var _safe = fh_find_free_spawn_pos(_sx, _sy, 24);
    return instance_create_layer(_safe.x, _safe.y, layer, _obj);
};

// Usado apenas na room_preboss (as exploracoes usam o obj_dungeon_generator)
var _is_preboss = (room == asset_get_index("room_preboss"));

if (_is_preboss) {
    // Sala 3 (Mini-Chefe): o golem do templo acompanhado de slimes, atiradores e um
    // fogo-fatuo. Conjuradoras e totens so aparecem depois do mercador.
    var _pb_slime, _pb_ranged, _pb_golem;
    if (_b == "water") {
        _pb_slime = obj_slime; _pb_ranged = obj_elemental; _pb_golem = obj_ice_golem;
    } else if (_b == "fire") {
        _pb_slime = obj_fire_slime; _pb_ranged = obj_fire_elemental; _pb_golem = obj_lava_golem;
    } else if (_b == "wind") {
        _pb_slime = asset_get_index("obj_wind_slime"); if (_pb_slime == -1) _pb_slime = obj_slime;
        _pb_ranged = asset_get_index("obj_wind_elemental"); if (_pb_ranged == -1) _pb_ranged = obj_elemental;
        _pb_golem = obj_storm_golem; // alterna solido/nevoa, tornado e fica tonto
    } else { // Earth
        _pb_slime = asset_get_index("obj_earth_slime"); if (_pb_slime == -1) _pb_slime = obj_slime;
        _pb_ranged = asset_get_index("obj_earth_elemental"); if (_pb_ranged == -1) _pb_ranged = obj_elemental;
        _pb_golem = obj_stone_golem; // inempurravel, armadura quebravel, pisao em anel
    }

    var _g = _spawn_safe(_pb_golem, 700, 250);
    if (_g != noone && _b == "water") _g.element_type = "water";
    _spawn_safe(_pb_slime, 300, 430);
    _spawn_safe(_pb_slime, 1100, 430);
    _spawn_safe(_pb_ranged, 450, 250);
    var _r2 = _spawn_safe(_pb_ranged, 950, 250);
    if (_r2 != noone) _r2.is_greater_variant = true;
    var _s3 = _spawn_safe(_pb_slime, 700, 450);
    if (_s3 != noone) _s3.is_greater_variant = true;
    _spawn_safe(obj_wisp, 620, 600);

    // Perigos do bioma
    if (_b == "water") {
        _spawn_safe(obj_ice_patch, 700, 500);
        _spawn_safe(asset_get_index("obj_water_puddle"), 700, 420);
    } else if (_b == "fire") {
        _spawn_safe(asset_get_index("obj_lava_pool_cycle"), 700, 500);
    } else if (_b == "wind") {
        _spawn_safe(asset_get_index("obj_wind_cyclone"), 700, 500);
        _spawn_safe(asset_get_index("obj_wind_stream"), 700, 420);
    } else {
        _spawn_safe(asset_get_index("obj_earth_fissure"), 700, 500);
        _spawn_safe(asset_get_index("obj_mud_quicksand"), 700, 420);
    }
}
