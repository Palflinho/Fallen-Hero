if (!variable_global_exists("run_biome")) global.run_biome = "water";
biome = global.run_biome;

// Configura o layout sorteado para a Arena do Templo atual
var _layout = arena_ensure_temple_layout(biome);
arena_setup_chamber(_layout, false, biome);

// Escalonamento de ondas conforme a fase (Agua: 2, Fogo: 3, Vento: 3, Terra: 4)
// Depois da ultima onda desperta o ESPIRITO ELEMENTAL do templo (chefe da arena).
if (biome == "water") {
    total_waves = 2;
    theme_colour = make_colour_rgb(100, 210, 255);
    biome_title = tr("ARENA GLACIAL");
    spirit_obj = obj_spirit_ondina;
    spirit_name = tr("ONDINA");
} else if (biome == "fire") {
    total_waves = 3;
    theme_colour = make_colour_rgb(255, 120, 40);
    biome_title = tr("ARENA VULCANICA");
    spirit_obj = obj_spirit_salamandra;
    spirit_name = tr("SALAMANDRA");
} else if (biome == "wind") {
    total_waves = 3;
    theme_colour = make_colour_rgb(180, 240, 255);
    biome_title = tr("ARENA DOS CICLONES");
    spirit_obj = obj_spirit_silfide;
    spirit_name = tr("SILFIDE");
} else {
    total_waves = 4;
    theme_colour = make_colour_rgb(190, 150, 90);
    biome_title = tr("COLISEU SISMICO");
    spirit_obj = obj_spirit_gnomo;
    spirit_name = tr("GNOMO");
}

arena_state = "waiting"; // "waiting" | "starting" | "active" | "wave_cleared" | "victory"
current_wave = 1;
trigger_radius = 280;
arena_barrier_active = false;
arena_barrier_radius = 420;

wave_delay_timer = 0;
spawn_timer = 0;
spawn_queue = [];
banner_timer = 0;
banner_text = "";
reward_spawned = false;
spirit_inst = noone;

reward_heal_inst = noone;
reward_chest_inst = noone;

// Monstros do templo usados nas ondas: slime, atirador, conjuradora e golem
arena_mob_slime = obj_slime;
arena_mob_ranged = obj_elemental;
arena_mob_caster = obj_frost_caster;
arena_mob_golem = obj_ice_golem;
arena_tier = 1;
if (biome == "fire") {
    arena_mob_slime = obj_fire_slime;
    arena_mob_ranged = obj_fire_elemental;
    arena_mob_caster = obj_magma_caster;
    arena_mob_golem = obj_lava_golem;
    arena_tier = 2;
} else if (biome == "wind") {
    var _ws = asset_get_index("obj_wind_slime");
    var _we = asset_get_index("obj_wind_elemental");
    var _wc = asset_get_index("obj_wind_caster");
    if (_ws != -1) arena_mob_slime = _ws;
    if (_we != -1) arena_mob_ranged = _we;
    if (_wc != -1) arena_mob_caster = _wc;
    arena_mob_golem = obj_storm_golem;
    arena_tier = 3;
} else if (biome == "earth") {
    var _es = asset_get_index("obj_earth_slime");
    var _ee = asset_get_index("obj_earth_elemental");
    var _ec = asset_get_index("obj_earth_caster");
    if (_es != -1) arena_mob_slime = _es;
    if (_ee != -1) arena_mob_ranged = _ee;
    if (_ec != -1) arena_mob_caster = _ec;
    arena_mob_golem = obj_stone_golem;
    arena_tier = 4;
}

// Função para enfileirar inimigos da onda.
// A arena vem depois do mercador: ondas cheias, com conjuradoras, e a ULTIMA onda
// sempre traz um golem do templo. Templos mais avancados somam mobs extras.
function queue_wave_spawns(_biome, _wave) {
    spawn_queue = [];
    var _cx = x;
    var _cy = y;

    // Pontos táticos ao redor da arena
    var _pts = [
        {x: _cx - 220, y: _cy - 140},
        {x: _cx + 220, y: _cy - 140},
        {x: _cx - 240, y: _cy + 120},
        {x: _cx + 240, y: _cy + 120},
        {x: _cx, y: _cy - 200},
        {x: _cx, y: _cy + 180},
        {x: _cx - 120, y: _cy - 220},
        {x: _cx + 120, y: _cy + 220}
    ];

    // Lista de [objeto, alfa?]
    var _list = [];
    var _last = (_wave >= total_waves);
    if (_wave == 1) {
        _list = [[arena_mob_slime, false], [arena_mob_slime, false], [arena_mob_slime, false],
                 [arena_mob_ranged, false], [arena_mob_ranged, false], [arena_mob_caster, false]];
    } else if (!_last) {
        _list = [[arena_mob_slime, false], [arena_mob_slime, true], [arena_mob_ranged, false],
                 [arena_mob_ranged, true], [arena_mob_caster, false], [arena_mob_caster, false]];
    } else {
        _list = [[arena_mob_golem, false], [arena_mob_slime, false], [arena_mob_slime, false],
                 [arena_mob_ranged, false], [arena_mob_caster, true]];
    }
    // Templos avancados: +1 mob por templo alem da Agua (alternando slime/atirador)
    for (var _e = 0; _e < arena_tier - 1; _e++) {
        array_push(_list, [(_e mod 2 == 0) ? arena_mob_slime : arena_mob_ranged, false]);
    }

    for (var _i = 0; _i < array_length(_list); _i++) {
        var _pt = _pts[_i mod array_length(_pts)];
        var _item = {obj: _list[_i][0], x: _pt.x, y: _pt.y};
        if (_list[_i][1]) _item.greater = true;
        if (_list[_i][0] == arena_mob_golem) { _item.x = _cx; _item.y = _cy - 200; }
        array_push(spawn_queue, _item);
    }

    // Suportes: Fogo-fatuo (infunde aliados) e Totem Elemental (aura) na ultima onda
    if (_wave >= 2) array_push(spawn_queue, {obj: obj_wisp, x: _pts[4].x + 40, y: _pts[4].y});
    if (_last) array_push(spawn_queue, {obj: obj_elem_totem, x: _pts[5].x, y: _pts[5].y});
}
