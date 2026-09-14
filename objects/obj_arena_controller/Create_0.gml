if (!variable_global_exists("run_biome")) global.run_biome = "water";
biome = global.run_biome;

// Escalonamento de ondas conforme a fase (Água: 3, Fogo: 4, Vento: 4, Terra: 5)
if (biome == "water") {
    total_waves = 3;
    theme_colour = make_colour_rgb(100, 210, 255);
    biome_title = "ARENA GLACIAL";
} else if (biome == "fire") {
    total_waves = 4;
    theme_colour = make_colour_rgb(255, 120, 40);
    biome_title = "ARENA VULCANICA";
} else if (biome == "wind") {
    total_waves = 4;
    theme_colour = make_colour_rgb(180, 240, 255);
    biome_title = "ARENA DOS CICLONES";
} else {
    total_waves = 5;
    theme_colour = make_colour_rgb(190, 150, 90);
    biome_title = "COLISEU SISMICO";
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

// Função para enfileirar inimigos da onda
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
        {x: _cx, y: _cy + 180}
    ];

    if (_biome == "water") {
        if (_wave == 1) {
            array_push(spawn_queue, {obj: obj_slime, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: obj_slime, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: obj_elemental, x: _pts[4].x, y: _pts[4].y});
        } else if (_wave == 2) {
            array_push(spawn_queue, {obj: obj_elemental, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: obj_frost_caster, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: obj_slime, x: _pts[2].x, y: _pts[2].y});
            array_push(spawn_queue, {obj: obj_slime, x: _pts[3].x, y: _pts[3].y});
        } else {
            array_push(spawn_queue, {obj: obj_elemental, x: _pts[4].x, y: _pts[4].y, greater: true});
            array_push(spawn_queue, {obj: obj_frost_caster, x: _pts[0].x, y: _pts[0].y, greater: true});
            array_push(spawn_queue, {obj: obj_elemental, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: obj_slime, x: _pts[2].x, y: _pts[2].y});
        }
    } else if (_biome == "fire") {
        if (_wave == 1) {
            array_push(spawn_queue, {obj: obj_fire_slime, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: obj_fire_slime, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: obj_fire_elemental, x: _pts[4].x, y: _pts[4].y});
        } else if (_wave == 2) {
            array_push(spawn_queue, {obj: obj_fire_elemental, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: obj_magma_caster, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: obj_fire_slime, x: _pts[2].x, y: _pts[2].y});
        } else if (_wave == 3) {
            array_push(spawn_queue, {obj: obj_fire_elemental, x: _pts[4].x, y: _pts[4].y, greater: true});
            array_push(spawn_queue, {obj: obj_fire_slime, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: obj_magma_caster, x: _pts[1].x, y: _pts[1].y});
        } else {
            array_push(spawn_queue, {obj: obj_magma_caster, x: _pts[4].x, y: _pts[4].y, greater: true});
            array_push(spawn_queue, {obj: obj_magma_caster, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: obj_fire_elemental, x: _pts[1].x, y: _pts[1].y, greater: true});
            array_push(spawn_queue, {obj: obj_fire_elemental, x: _pts[3].x, y: _pts[3].y});
        }
    } else if (_biome == "wind") {
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        var _ws = asset_get_index("obj_wind_slime");
        if (_ws == -1) _ws = obj_slime;
        var _wc = asset_get_index("obj_wind_caster");
        if (_wc == -1) _wc = obj_frost_caster;

        if (_wave == 1) {
            array_push(spawn_queue, {obj: _ws, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _ws, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _we, x: _pts[4].x, y: _pts[4].y});
        } else if (_wave == 2) {
            array_push(spawn_queue, {obj: _we, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _wc, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _ws, x: _pts[4].x, y: _pts[4].y});
        } else if (_wave == 3) {
            array_push(spawn_queue, {obj: _ws, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _wc, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _we, x: _pts[2].x, y: _pts[2].y});
            array_push(spawn_queue, {obj: _we, x: _pts[4].x, y: _pts[4].y, greater: true});
        } else {
            array_push(spawn_queue, {obj: _we, x: _pts[0].x, y: _pts[0].y, greater: true});
            array_push(spawn_queue, {obj: _ws, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _we, x: _pts[2].x, y: _pts[2].y});
            array_push(spawn_queue, {obj: _ws, x: _pts[3].x, y: _pts[3].y});
            array_push(spawn_queue, {obj: _wc, x: _pts[4].x, y: _pts[4].y, greater: true});
        }
    } else { // Earth
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        var _es = asset_get_index("obj_earth_slime");
        if (_es == -1) _es = obj_slime;
        var _ec = asset_get_index("obj_earth_caster");
        if (_ec == -1) _ec = obj_frost_caster;

        if (_wave == 1) {
            array_push(spawn_queue, {obj: _es, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _es, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _ee, x: _pts[4].x, y: _pts[4].y});
        } else if (_wave == 2) {
            array_push(spawn_queue, {obj: _ee, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _ec, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _es, x: _pts[4].x, y: _pts[4].y});
        } else if (_wave == 3) {
            array_push(spawn_queue, {obj: _es, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _ec, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _ee, x: _pts[4].x, y: _pts[4].y, greater: true});
        } else if (_wave == 4) {
            array_push(spawn_queue, {obj: _ee, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _es, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _ec, x: _pts[2].x, y: _pts[2].y});
            array_push(spawn_queue, {obj: _ee, x: _pts[4].x, y: _pts[4].y, greater: true});
        } else {
            array_push(spawn_queue, {obj: _ee, x: _pts[0].x, y: _pts[0].y});
            array_push(spawn_queue, {obj: _es, x: _pts[1].x, y: _pts[1].y});
            array_push(spawn_queue, {obj: _ee, x: _pts[2].x, y: _pts[2].y, greater: true});
            array_push(spawn_queue, {obj: _es, x: _pts[4].x, y: _pts[4].y, greater: true});
            array_push(spawn_queue, {obj: _ec, x: _pts[5].x, y: _pts[5].y, greater: true});
        }
    }
}
