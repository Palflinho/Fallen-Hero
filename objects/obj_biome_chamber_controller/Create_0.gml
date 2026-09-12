if (!variable_global_exists("run_biome")) global.run_biome = "water";
var _b = global.run_biome;

// Determina o tipo de sala atual
var _is_preboss = (room == asset_get_index("room_preboss"));
var _is_exp4 = (room == asset_get_index("room_exp4"));

if (_is_preboss) {
    if (_b == "water") {
        instance_create_layer(450, 450, layer, obj_elemental);
        instance_create_layer(950, 450, layer, obj_frost_caster);
        instance_create_layer(700, 350, layer, obj_ice_golem);
        instance_create_layer(700, 500, layer, obj_ice_patch);
    } else if (_b == "fire") {
        instance_create_layer(450, 450, layer, obj_fire_elemental);
        instance_create_layer(950, 450, layer, obj_magma_caster);
        instance_create_layer(700, 350, layer, obj_lava_golem);
        instance_create_layer(700, 500, layer, obj_lava_pool);
    } else if (_b == "wind") {
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        instance_create_layer(450, 450, layer, _we);
        instance_create_layer(950, 450, layer, _we);
        instance_create_layer(700, 350, layer, _we);
        instance_create_layer(700, 500, layer, asset_get_index("obj_wind_cyclone"));
    } else { // Earth
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        instance_create_layer(450, 450, layer, _ee);
        instance_create_layer(950, 450, layer, _ee);
        instance_create_layer(700, 350, layer, obj_ice_golem);
        instance_create_layer(700, 500, layer, asset_get_index("obj_earth_fissure"));
    }
} else if (_is_exp4) {
    // Sala 4: Exploração 3 (Pré-Boss Avançada)
    if (_b == "water") {
        instance_create_layer(400, 350, layer, obj_slime);
        instance_create_layer(1000, 350, layer, obj_slime);
        instance_create_layer(700, 300, layer, obj_frost_caster);
        instance_create_layer(400, 700, layer, obj_elemental);
        instance_create_layer(1000, 700, layer, obj_ice_golem);
        instance_create_layer(700, 500, layer, obj_ice_patch);
    } else if (_b == "fire") {
        instance_create_layer(400, 350, layer, obj_fire_slime);
        instance_create_layer(1000, 350, layer, obj_fire_slime);
        instance_create_layer(700, 300, layer, obj_magma_caster);
        instance_create_layer(400, 700, layer, obj_fire_elemental);
        instance_create_layer(1000, 700, layer, obj_lava_golem);
        instance_create_layer(700, 500, layer, obj_lava_pool);
    } else if (_b == "wind") {
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        instance_create_layer(400, 350, layer, _we);
        instance_create_layer(1000, 350, layer, _we);
        instance_create_layer(700, 300, layer, _we);
        instance_create_layer(400, 700, layer, _we);
        instance_create_layer(700, 500, layer, asset_get_index("obj_wind_cyclone"));
    } else { // Earth
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        instance_create_layer(400, 350, layer, _ee);
        instance_create_layer(1000, 350, layer, _ee);
        instance_create_layer(700, 300, layer, _ee);
        instance_create_layer(400, 700, layer, obj_ice_golem);
        instance_create_layer(700, 500, layer, asset_get_index("obj_earth_fissure"));
    }
} else {
    // Sala 2: Exploração 2
    if (_b == "water") {
        instance_create_layer(400, 400, layer, obj_slime);
        instance_create_layer(900, 400, layer, obj_slime);
        instance_create_layer(650, 300, layer, obj_elemental);
        instance_create_layer(650, 600, layer, obj_frost_caster);
        instance_create_layer(650, 450, layer, obj_ice_patch);
    } else if (_b == "fire") {
        instance_create_layer(400, 400, layer, obj_fire_slime);
        instance_create_layer(900, 400, layer, obj_fire_slime);
        instance_create_layer(650, 300, layer, obj_fire_elemental);
        instance_create_layer(650, 600, layer, obj_magma_caster);
        instance_create_layer(650, 450, layer, obj_lava_pool);
    } else if (_b == "wind") {
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        instance_create_layer(400, 400, layer, _we);
        instance_create_layer(900, 400, layer, _we);
        instance_create_layer(650, 300, layer, _we);
        instance_create_layer(650, 450, layer, asset_get_index("obj_wind_stream"));
    } else { // Earth
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        instance_create_layer(400, 400, layer, _ee);
        instance_create_layer(900, 400, layer, _ee);
        instance_create_layer(650, 300, layer, _ee);
        instance_create_layer(650, 450, layer, asset_get_index("obj_earth_fissure"));
    }
}
