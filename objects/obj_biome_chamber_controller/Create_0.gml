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
