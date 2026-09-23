if (instance_exists(asset_get_index("obj_dungeon_generator"))) exit;

if (!variable_global_exists("run_biome")) global.run_biome = "water";
var _b = global.run_biome;

var _spawn_safe = function(_obj, _sx, _sy) {
    if (_obj == -1 || !object_exists(_obj)) return noone;
    var _safe = fh_find_free_spawn_pos(_sx, _sy, 24);
    return instance_create_layer(_safe.x, _safe.y, layer, _obj);
};

// Determina o tipo de sala atual
var _is_preboss = (room == asset_get_index("room_preboss"));
var _is_exp4 = (room == asset_get_index("room_exp4"));

if (_is_preboss) {
    // Sala 5 (Pré-Boss): Onde residem exclusivamente os Mini-Chefes (Quadrados Grandes Guardiões)
    if (_b == "water") {
        _spawn_safe(obj_elemental, 450, 450);
        _spawn_safe(obj_frost_caster, 950, 450);
        var _g = _spawn_safe(obj_ice_golem, 700, 350);
        if (_g != noone) _g.element_type = "water";
        _spawn_safe(obj_ice_patch, 700, 500);
        _spawn_safe(asset_get_index("obj_water_puddle"), 700, 420);
    } else if (_b == "fire") {
        _spawn_safe(obj_fire_elemental, 450, 450);
        _spawn_safe(obj_magma_caster, 950, 450);
        _spawn_safe(obj_lava_golem, 700, 350);
        _spawn_safe(asset_get_index("obj_lava_pool_cycle"), 700, 500);
    } else if (_b == "wind") {
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        var _wc = asset_get_index("obj_wind_caster");
        if (_wc == -1) _wc = obj_frost_caster;
        _spawn_safe(_we, 450, 450);
        _spawn_safe(_wc, 950, 450);
        // Golem de Tempestade: alterna solido/nevoa, tornado e fica tonto
        _spawn_safe(obj_storm_golem, 700, 350);
        _spawn_safe(asset_get_index("obj_wind_cyclone"), 700, 500);
        _spawn_safe(asset_get_index("obj_wind_stream"), 700, 420);
    } else { // Earth
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        var _ec = asset_get_index("obj_earth_caster");
        if (_ec == -1) _ec = obj_frost_caster;
        _spawn_safe(_ee, 450, 450);
        _spawn_safe(_ec, 950, 450);
        // Golem de Pedra: inempurravel, armadura quebravel, pisao em anel e pedregulhos
        _spawn_safe(obj_stone_golem, 700, 350);
        _spawn_safe(asset_get_index("obj_earth_fissure"), 700, 500);
        _spawn_safe(asset_get_index("obj_mud_quicksand"), 700, 420);
    }
} else if (_is_exp4) {
    // Sala 4: Exploração 3 (Pré-Boss Avançada) - Apenas Mobs Normais e Variantes Maiores de Elite (Sem Mini-Chefes)
    // Totem Elemental no centro: fortalece quem estiver na aura (derrube-o primeiro)
    _spawn_safe(obj_elem_totem, 700, 380);
    if (_b == "water") {
        _spawn_safe(obj_slime, 400, 350);
        var _s2 = _spawn_safe(obj_slime, 1000, 350);
        if (_s2 != noone) _s2.is_greater_variant = true;
        _spawn_safe(obj_frost_caster, 700, 300);
        _spawn_safe(obj_elemental, 400, 700);
        var _c2 = _spawn_safe(obj_frost_caster, 1000, 700);
        if (_c2 != noone) _c2.is_greater_variant = true;
        _spawn_safe(obj_ice_patch, 700, 500);
        _spawn_safe(asset_get_index("obj_water_puddle"), 700, 420);
    } else if (_b == "fire") {
        _spawn_safe(obj_fire_slime, 400, 350);
        var _s2 = _spawn_safe(obj_fire_slime, 1000, 350);
        if (_s2 != noone) _s2.is_greater_variant = true;
        _spawn_safe(obj_magma_caster, 700, 300);
        _spawn_safe(obj_fire_elemental, 400, 700);
        var _c2 = _spawn_safe(obj_magma_caster, 1000, 700);
        if (_c2 != noone) _c2.is_greater_variant = true;
        _spawn_safe(asset_get_index("obj_lava_pool_cycle"), 700, 500);
    } else if (_b == "wind") {
        var _ws = asset_get_index("obj_wind_slime");
        if (_ws == -1) _ws = obj_slime;
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        var _wc = asset_get_index("obj_wind_caster");
        if (_wc == -1) _wc = obj_frost_caster;

        _spawn_safe(_ws, 400, 350);
        var _s2 = _spawn_safe(_ws, 1000, 350);
        if (_s2 != noone) _s2.is_greater_variant = true;
        _spawn_safe(_wc, 700, 300);
        _spawn_safe(_we, 400, 700);
        var _c2 = _spawn_safe(_wc, 1000, 700);
        if (_c2 != noone) _c2.is_greater_variant = true;
        _spawn_safe(asset_get_index("obj_wind_cyclone"), 700, 500);
        _spawn_safe(asset_get_index("obj_wind_stream"), 700, 380);
    } else { // Earth
        var _es = asset_get_index("obj_earth_slime");
        if (_es == -1) _es = obj_slime;
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        var _ec = asset_get_index("obj_earth_caster");
        if (_ec == -1) _ec = obj_frost_caster;

        _spawn_safe(_es, 400, 350);
        var _s2 = _spawn_safe(_es, 1000, 350);
        if (_s2 != noone) _s2.is_greater_variant = true;
        _spawn_safe(_ec, 700, 300);
        _spawn_safe(_ee, 400, 700);
        var _c2 = _spawn_safe(_ec, 1000, 700);
        if (_c2 != noone) _c2.is_greater_variant = true;
        _spawn_safe(asset_get_index("obj_earth_fissure"), 700, 500);
        _spawn_safe(asset_get_index("obj_mud_quicksand"), 700, 420);
    }
} else {
    // Sala 2: Exploração 2
    // Fogo-fatuo: tenta infundir um aliado e transforma-lo em elite
    _spawn_safe(obj_wisp, 650, 520);
    if (_b == "water") {
        _spawn_safe(obj_slime, 280, 400);
        _spawn_safe(obj_slime, 860, 400);
        _spawn_safe(obj_elemental, 650, 300);
        _spawn_safe(obj_frost_caster, 650, 600);
        _spawn_safe(obj_ice_patch, 650, 450);
        _spawn_safe(asset_get_index("obj_water_puddle"), 280, 520);
        _spawn_safe(asset_get_index("obj_water_puddle"), 860, 520);
    } else if (_b == "fire") {
        _spawn_safe(obj_fire_slime, 280, 400);
        _spawn_safe(obj_fire_slime, 860, 400);
        _spawn_safe(obj_fire_elemental, 650, 300);
        _spawn_safe(obj_magma_caster, 650, 600);
        _spawn_safe(obj_lava_pool, 650, 450);
    } else if (_b == "wind") {
        var _ws = asset_get_index("obj_wind_slime");
        if (_ws == -1) _ws = obj_slime;
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        var _wc = asset_get_index("obj_wind_caster");
        if (_wc == -1) _wc = obj_frost_caster;

        _spawn_safe(_ws, 280, 400);
        _spawn_safe(_ws, 860, 400);
        _spawn_safe(_we, 650, 300);
        _spawn_safe(_wc, 650, 600);
        _spawn_safe(asset_get_index("obj_wind_stream"), 650, 450);
    } else { // Earth
        var _es = asset_get_index("obj_earth_slime");
        if (_es == -1) _es = obj_slime;
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        var _ec = asset_get_index("obj_earth_caster");
        if (_ec == -1) _ec = obj_frost_caster;

        _spawn_safe(_es, 280, 400);
        _spawn_safe(_es, 860, 400);
        _spawn_safe(_ee, 650, 300);
        _spawn_safe(_ec, 650, 600);
        _spawn_safe(asset_get_index("obj_earth_fissure"), 650, 450);
        _spawn_safe(asset_get_index("obj_mud_quicksand"), 280, 520);
        _spawn_safe(asset_get_index("obj_mud_quicksand"), 860, 520);
    }
}
