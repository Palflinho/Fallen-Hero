// Script de Geracao Procedural Modular de Masmorra (Estilo The Binding of Isaac)
// Desenvolvido para o Fallen Hero: Grid 3x3 de camaras com corredores largos (180px)

function dungeon_spawn_wall(_x, _y, _w, _h) {
    if (_w <= 0 || _h <= 0) return noone;
    var _layer_id = layer_get_id("Instances");
    if (_layer_id == -1) _layer_id = layer_create(0, "Instances");
    var _wall = instance_create_layer(_x, _y, _layer_id, obj_wall);
    _wall.image_xscale = _w / _wall.base_size;
    _wall.image_yscale = _h / _wall.base_size;
    return _wall;
}

function dungeon_spawn_door(_x, _y, _w, _h) {
    if (_w <= 0 || _h <= 0) return noone;
    var _layer_id = layer_get_id("Instances");
    if (_layer_id == -1) _layer_id = layer_create(0, "Instances");
    var _door = instance_create_layer(_x, _y, _layer_id, obj_boss_door);
    _door.image_xscale = _w / _door.base_size;
    _door.image_yscale = _h / _door.base_size;
    return _door;
}

// Composicao de monstros por sala do templo (aplicada sobre o que o chunk pede):
//  - Exploracao 1: so slimes corpo a corpo e no maximo 3 atiradores (sem conjuradoras,
//    totens ou fogos-fatuos) - a sala ensina o basico.
//  - Exploracao 2: mistura atiradores com corpo a corpo; fogos-fatuos ja aparecem,
//    conjuradoras ainda nao (viram atiradores).
//  - Exploracao 3 (depois do mercador): conjuradoras acompanhadas de totens.
#macro DUNGEON_STEP1_MAX_RANGED 3

function dungeon_spawn_enemy(_biome, _type, _x, _y) {
    var _layer_id = layer_get_id("Instances");
    if (_layer_id == -1) _layer_id = layer_create(0, "Instances");

    var _step = variable_global_exists("run_room_step") ? global.run_room_step : 1;
    if (!variable_global_exists("dg_ranged_count")) global.dg_ranged_count = 0;
    if (_step == 1) {
        if (_type == "caster") _type = "ranged";
        if (_type == "ranged") {
            if (global.dg_ranged_count >= DUNGEON_STEP1_MAX_RANGED) _type = "slime";
            else global.dg_ranged_count += 1;
        }
    } else {
        if (_step < 5 && _type == "caster") _type = "ranged";
        if (_type == "slime" && random(1) < 0.35) _type = "ranged";
    }
    
    var _obj = -1;
    var _make_greater = false;
    if (_biome == "water") {
        if (_type == "slime") _obj = obj_slime;
        else if (_type == "ranged") _obj = obj_elemental;
        else if (_type == "caster") _obj = obj_frost_caster;
        else if (_type == "tank") { _obj = obj_elemental; _make_greater = true; }
        else if (_type == "hazard") _obj = asset_get_index("obj_water_puddle");
    } else if (_biome == "fire") {
        if (_type == "slime") _obj = obj_fire_slime;
        else if (_type == "ranged") _obj = obj_fire_elemental;
        else if (_type == "caster") _obj = obj_magma_caster;
        else if (_type == "tank") { _obj = obj_fire_elemental; _make_greater = true; }
        else if (_type == "hazard") _obj = asset_get_index("obj_lava_pool");
    } else if (_biome == "wind") {
        var _we = asset_get_index("obj_wind_elemental");
        if (_we == -1) _we = obj_elemental;
        var _ws = asset_get_index("obj_wind_slime");
        if (_ws == -1) _ws = obj_slime;
        var _wc = asset_get_index("obj_wind_caster");
        if (_wc == -1) _wc = obj_frost_caster;
        if (_type == "slime") _obj = _ws;
        else if (_type == "ranged") _obj = _we;
        else if (_type == "caster") _obj = _wc;
        else if (_type == "tank") { _obj = _we; _make_greater = true; }
        else if (_type == "hazard") _obj = asset_get_index("obj_wind_cyclone");
    } else { // earth
        var _ee = asset_get_index("obj_earth_elemental");
        if (_ee == -1) _ee = obj_elemental;
        var _es = asset_get_index("obj_earth_slime");
        if (_es == -1) _es = obj_slime;
        var _ec = asset_get_index("obj_earth_caster");
        if (_ec == -1) _ec = obj_frost_caster;
        if (_type == "slime") _obj = _es;
        else if (_type == "ranged") _obj = _ee;
        else if (_type == "caster") _obj = _ec;
        else if (_type == "tank") { _obj = _ee; _make_greater = true; }
        else if (_type == "hazard") _obj = asset_get_index("obj_mud_quicksand");
    }
    
    if (_obj == -1 || !object_exists(_obj)) return noone;
    
    var _safe = fh_find_free_spawn_pos(_x, _y, 24);
    var _inst = instance_create_layer(_safe.x, _safe.y, _layer_id, _obj);
    if (_inst != noone && _make_greater) {
        _inst.is_greater_variant = true;
    }

    // Suportes elementais: conjuradores vem com um Totem; atiradores as vezes com um Fogo-fatuo
    // (nada disso na Exploracao 1)
    if (_step == 1) return _inst;
    if (_inst != noone && _type == "caster" && random(1) < 0.65) {
        var _tp = fh_find_free_spawn_pos(_safe.x + choose(-60, 60), _safe.y + choose(-50, 50), 20);
        instance_create_layer(_tp.x, _tp.y, _layer_id, obj_elem_totem);
    } else if (_inst != noone && _type == "ranged" && random(1) < 0.20) {
        var _wp = fh_find_free_spawn_pos(_safe.x + choose(-50, 50), _safe.y + choose(-40, 40), 12);
        instance_create_layer(_wp.x, _wp.y, _layer_id, obj_wisp);
    }
    return _inst;
}

// =========================================================================
// SISTEMA MODULAR DE MATRIZ DE CHUNKS (ESTILO HADES / DEAD CELLS / ISAAC)
// Cada câmara do grid 3x3 mede 720x540 px e é composta por 16x12 tiles (45x45 px).
//
// TABELA DE DIMENSÕES EM PIXELS DE CADA SÍMBOLO:
//   Tile Base: 45 x 45 px (largura x altura)
//   Jogador (referência): Diâmetro 24 px (Raio de colisão = 12 px)
//   Vão das Portas (N/S/L/O): 180 px (exatamente 4 tiles de largura)
//
//   '.' = Chão Livre            -> Espaço vazio (45 x 45 px)
//   '#' = Parede Sólida         -> Bloco sólido (45 x 45 px por tile, funde horizontalmente)
//   'B' = Botão do Selo         -> Círculo de ativação (Raio 20 px / Diâmetro 40 px)
//   'T' = Baú de Tesouro        -> Baú interativo (Raio 22 px / Diâmetro 44 px)
//   'G' = Portão de Saída       -> Círculo do Portal (Raio 40 px / Diâmetro 80 px)
//   'D' = Porta Selada do Chefe -> Barricada de porta (tiles x 45 px de larg. por 45 px de alt.)
//   'S' = Armadilha de Espinho  -> Quadrado de 32 x 32 px (centralizado no tile de 45 px)
//   'H' = Perigo Elemental      ->
//           - Água (Gelo): Quadrado de 32 x 32 px (desliza o herói)
//           - Fogo (Lava): Quadrado de 32 x 32 px (dano de queimadura cíclico)
//           - Vento (Ciclone): Círculo móvel de Diâmetro 48 px (Raio = 24 px)
//           - Terra (Movediça): Quadrado de 48 x 48 px (reduz velocidade em 50%)
//   'm' = Monstro Slime         -> Corpo circular (Raio 14 px / Diâmetro 28 px)
//   'r' = Monstro Ranged        -> Corpo circular (Raio 14 px / Diâmetro 28 px)
//   'c' = Monstro Conjurador    -> Corpo circular (Raio 14 px, Área de feitiço = Raio 60-70 px)
//   'E' = Guardião de Elite     -> Variante Grande (Raio 18 a 32 px / Diâmetro 36 a 64 px)
// =========================================================================

function dungeon_get_chunks_entrance() {
    return [
        // 0: O Grande Átrio (Pilares Monumentais nos Cantos)
        [
            "................",
            "...##......##...",
            "...##......##...",
            "................",
            "................",
            "................",
            "................",
            "................",
            "................",
            "...##......##...",
            "...##......##...",
            "................"
        ],
        // 1: Pátio Cerimonial (Pilares Ornamentais Duplos)
        [
            "................",
            "..##........##..",
            "................",
            "....##....##....",
            "................",
            "................",
            "................",
            "................",
            "....##....##....",
            "................",
            "..##........##..",
            "................"
        ]
    ];
}

function dungeon_get_chunks_exit() {
    return [
        // 0: O Santuário do Guardião (Portão ao Norte no Altar, Porta Trancada e Guardião de Elite)
        [
            "................",
            "...##......##...",
            "....########....",
            "....#..G...#....",
            "....###DD###....",
            "................",
            ".......E........",
            "................",
            "................",
            "...##......##...",
            "...##......##...",
            "................"
        ],
        // 1: O Altar dos Bastiões (Colunatas com Retaguarda)
        [
            "................",
            "..##........##..",
            "....########....",
            "....#..G...#....",
            "....###DD###....",
            "................",
            "....m..E...m....",
            "................",
            "....##....##....",
            "................",
            "..##........##..",
            "................"
        ]
    ];
}

function dungeon_get_chunks_button() {
    return [
        // 0: A Arena dos Quatro Bastiões (Cobertura e Kiting)
        [
            "................",
            "...##......##...",
            "...##...c..##...",
            "................",
            "................",
            ".......B........",
            ".......S........",
            "................",
            "....m......m....",
            "...##......##...",
            "...##......##...",
            "................"
        ],
        // 1: O Sanctum da Alcova Protegida
        [
            "................",
            ".....######.....",
            ".....#....#.....",
            ".....#.B..#.....",
            ".....#.S..#.....",
            "................",
            "..m..........m..",
            "................",
            "...##......##...",
            "...##..c...##...",
            "................",
            "................"
        ],
        // 2: A Encruzilhada Simétrica
        [
            "................",
            "....##....##....",
            "....##....##....",
            "................",
            ".......m........",
            "..##...B....##..",
            "..##...S....##..",
            ".......r........",
            "................",
            "....##....##....",
            "....##....##....",
            "................"
        ],
        // 3: O Anel Elemental
        [
            "................",
            "................",
            "...##......##...",
            ".....H....H.....",
            "................",
            ".......B........",
            "................",
            ".....H....H.....",
            "...##......##...",
            ".......c........",
            "....m......m....",
            "................"
        ],
        // 4: As Colunatas Gêmeas
        [
            "................",
            "...##......##...",
            "...##......##...",
            "...##...B..##...",
            "...##...S..##...",
            "................",
            ".......c........",
            "................",
            "...##..m...##...",
            "...##......##...",
            "...##......##...",
            "................"
        ],
        // 5: O Pátio dos Espinhos Rítmicos
        [
            "................",
            "................",
            "..##........##..",
            "....S......S....",
            "................",
            ".......B........",
            "................",
            "....S......S....",
            "..##........##..",
            ".......r........",
            ".....m....m.....",
            "................"
        ]
    ];
}

function dungeon_get_chunks_treasure() {
    return [
        // 0: O Cofre do Altar
        [
            "................",
            "................",
            "....########....",
            "....#......#....",
            "....#..T...#....",
            "................",
            "................",
            "................",
            "...##......##...",
            "...##..m...##...",
            "................",
            "................"
        ],
        // 1: O Pedestal do Oásis
        [
            "................",
            "...##......##...",
            "...##......##...",
            ".......H........",
            "................",
            ".......T........",
            "................",
            ".......H........",
            "...##......##...",
            "...##......##...",
            "................",
            "................"
        ],
        // 2: Câmara dos Espelhos
        [
            "................",
            "..##........##..",
            "................",
            "....##....##....",
            "................",
            ".......T........",
            "................",
            "....##....##....",
            "................",
            "..##........##..",
            "................",
            "................"
        ]
    ];
}

function dungeon_get_chunks_combat() {
    return [
        // 0: A Grande Rotunda de Duelo
        [
            "................",
            "...##......##...",
            "...##......##...",
            ".......r........",
            "................",
            ".......H........",
            "................",
            ".......c........",
            "...##......##...",
            "...##......##...",
            ".....m....m.....",
            "................"
        ],
        // 1: O Labirinto dos Pilares Cruzados
        [
            "................",
            "....##....##....",
            "....##....##....",
            "................",
            "..m..........m..",
            ".......##.......",
            ".......##.......",
            "..r..........r..",
            "................",
            "....##....##....",
            "....##....##....",
            "................"
        ],
        // 2: A Trilha dos Bastiões
        [
            "................",
            "...####..####...",
            "................",
            ".......c........",
            "................",
            "....##....##....",
            "....##....##....",
            "................",
            ".......m........",
            "................",
            "...####..####...",
            "................"
        ],
        // 3: A Arena Aberta dos Conjuradores
        [
            "................",
            "................",
            "..##........##..",
            ".......m........",
            "................",
            "....c......c....",
            "................",
            ".......r........",
            "..##........##..",
            "................",
            "................",
            "................"
        ]
    ];
}

// Instanciador do Chunk na coordenada (ox, oy) com salvaguarda de portas
function dungeon_instantiate_chunk(_ox, _oy, _chunk_lines, _type, _biome, _layer_id, _conn_n, _conn_s, _conn_w, _conn_e) {
    var _tile_w = 45;
    var _tile_h = 45;
    var _num_rows = array_length(_chunk_lines);
    var _num_cols = 16;
    
    // Matriz de caracteres 16x12
    var _grid = array_create(_num_rows);
    for (var _r = 0; _r < _num_rows; _r++) {
        _grid[_r] = array_create(_num_cols, ".");
        var _line = _chunk_lines[_r];
        var _len = string_length(_line);
        for (var _c = 0; _c < _num_cols; _c++) {
            if (_c < _len) {
                _grid[_r][_c] = string_char_at(_line, _c + 1);
            }
        }
    }
    
    // -------------------------------------------------------------
    // SALVAGUARDA DE ENTRADA MIYAMOTO/IWATA (DOORWAY SAFETY SHIELD)
    // Garante passagem livre de paredes (#) e espinhos (S) em portas ativas
    // -------------------------------------------------------------
    if (_conn_n) {
        for (var _c = 6; _c <= 9; _c++) {
            for (var _r = 0; _r <= 1; _r++) {
                if (_grid[_r][_c] == "#" || _grid[_r][_c] == "S") _grid[_r][_c] = ".";
            }
        }
    }
    if (_conn_s) {
        for (var _c = 6; _c <= 9; _c++) {
            for (var _r = 10; _r <= 11; _r++) {
                if (_grid[_r][_c] == "#" || _grid[_r][_c] == "S") _grid[_r][_c] = ".";
            }
        }
    }
    if (_conn_w) {
        for (var _r = 4; _r <= 7; _r++) {
            for (var _c = 0; _c <= 1; _c++) {
                if (_grid[_r][_c] == "#" || _grid[_r][_c] == "S") _grid[_r][_c] = ".";
            }
        }
    }
    if (_conn_e) {
        for (var _r = 4; _r <= 7; _r++) {
            for (var _c = 14; _c <= 15; _c++) {
                if (_grid[_r][_c] == "#" || _grid[_r][_c] == "S") _grid[_r][_c] = ".";
            }
        }
    }
    
    // -------------------------------------------------------------
    // INSTANCIAÇÃO DAS PAREDES E PORTAS COM OTIMIZAÇÃO HORIZONTAL
    // -------------------------------------------------------------
    for (var _r = 0; _r < _num_rows; _r++) {
        var _c = 0;
        while (_c < _num_cols) {
            if (_grid[_r][_c] == "#") {
                var _span = 1;
                while (_c + _span < _num_cols && _grid[_r][_c + _span] == "#") {
                    _span++;
                }
                dungeon_spawn_wall(_ox + _c * _tile_w, _oy + _r * _tile_h, _span * _tile_w, _tile_h);
                _c += _span;
            } else if (_grid[_r][_c] == "D") {
                var _dspan = 1;
                while (_c + _dspan < _num_cols && _grid[_r][_c + _dspan] == "D") {
                    _dspan++;
                }
                dungeon_spawn_door(_ox + _c * _tile_w, _oy + _r * _tile_h, _dspan * _tile_w, _tile_h);
                _c += _dspan;
            } else {
                _c++;
            }
        }
    }
    
    // -------------------------------------------------------------
    // INSTANCIAÇÃO DOS ELEMENTOS INTERATIVOS E INIMIGOS
    // -------------------------------------------------------------
    for (var _r = 0; _r < _num_rows; _r++) {
        for (var _c = 0; _c < _num_cols; _c++) {
            var _ch = _grid[_r][_c];
            if (_ch == "." || _ch == "#" || _ch == "D") continue;
            
            var _tx = _ox + _c * _tile_w;
            var _ty = _oy + _r * _tile_h;
            var _cx = _tx + _tile_w * 0.5;
            var _cy = _ty + _tile_h * 0.5;
            
            switch (_ch) {
                case "B":
                    var _btn = instance_create_layer(_cx, _cy, _layer_id, obj_boss_button);
                    _btn.pressed = false;
                    break;
                    
                case "T":
                    instance_create_layer(_cx, _cy, _layer_id, obj_chest);
                    break;
                    
                case "G":
                    instance_create_layer(_cx, _cy, _layer_id, obj_stage_gate);
                    break;
                    
                case "S":
                    instance_create_layer(_tx + 6.5, _ty + 6.5, _layer_id, obj_trap_spike);
                    break;
                    
                case "H":
                    if (_biome == "water") {
                        instance_create_layer(_tx + 6.5, _ty + 6.5, _layer_id, obj_ice_patch);
                    } else if (_biome == "fire") {
                        instance_create_layer(_tx + 6.5, _ty + 6.5, _layer_id, obj_lava_pool_cycle);
                    } else if (_biome == "wind") {
                        instance_create_layer(_cx, _cy, _layer_id, asset_get_index("obj_wind_cyclone"));
                    } else { // earth
                        instance_create_layer(_tx - 1.5, _ty - 1.5, _layer_id, asset_get_index("obj_mud_quicksand"));
                    }
                    break;
                    
                case "m":
                    dungeon_spawn_enemy(_biome, "slime", _cx, _cy);
                    break;
                    
                case "r":
                    dungeon_spawn_enemy(_biome, "ranged", _cx, _cy);
                    break;
                    
                case "c":
                    dungeon_spawn_enemy(_biome, "caster", _cx, _cy);
                    break;
                    
                case "E":
                    var _elite_step = variable_global_exists("run_room_step") ? global.run_room_step : 1;
                    var _elite = dungeon_spawn_enemy(_biome, (_elite_step == 1) ? "slime" : "ranged", _cx, _cy);
                    if (_elite != noone) {
                        _elite.is_greater_variant = true;
                        _elite.scale_x = 1.42;
                        _elite.scale_y = 1.42;
                        _elite.body_radius = round(_elite.body_radius * 1.30);
                        _elite.hp_max = round(_elite.hp_max * 1.60);
                        _elite.hp = _elite.hp_max;
                        _elite.contact_damage = round(_elite.contact_damage * 1.30);
                    }
                    break;
            }
        }
    }
}

// Construtor modular de templates arquitetonicos para as camaras do labirinto
function dungeon_build_chamber_template(_ox, _oy, _template_idx, _type, _biome, _layer_id, _cn_n, _cn_s, _cn_w, _cn_e) {
    if (is_undefined(_cn_n)) _cn_n = false;
    if (is_undefined(_cn_s)) _cn_s = false;
    if (is_undefined(_cn_w)) _cn_w = false;
    if (is_undefined(_cn_e)) _cn_e = false;
    
    var _lib = [];
    if (_type == "entrance") {
        _lib = dungeon_get_chunks_entrance();
    } else if (_type == "exit") {
        _lib = dungeon_get_chunks_exit();
    } else if (_type == "button") {
        _lib = dungeon_get_chunks_button();
    } else if (_type == "treasure") {
        _lib = dungeon_get_chunks_treasure();
    } else { // "combat"
        _lib = dungeon_get_chunks_combat();
    }
    
    var _count = array_length(_lib);
    if (_count == 0) return;
    var _chunk = _lib[abs(_template_idx) mod _count];
    
    dungeon_instantiate_chunk(_ox, _oy, _chunk, _type, _biome, _layer_id, _cn_n, _cn_s, _cn_w, _cn_e);
}

function dungeon_generate_modular() {
    randomize();
    
    // Dimensões do mapa modular (3 colunas x 3 linhas)
    room_width = 2160;
    room_height = 1620;
    
    global.boss_buttons_pressed = 0;
    global.dg_ranged_count = 0;
    
    if (room == Room1) {
        global.run_biome = "water";
        global.run_room_step = 1;
    } else if (room == Room3) {
        global.run_biome = "fire";
        global.run_room_step = 1;
    } else if (room == Room5) {
        global.run_biome = "wind";
        global.run_room_step = 1;
    } else if (room == Room7) {
        global.run_biome = "earth";
        global.run_room_step = 1;
    } else if (room == asset_get_index("room_exp2")) {
        global.run_room_step = 2;
    } else if (room == asset_get_index("room_exp4")) {
        global.run_room_step = 5;
    }
    
    if (!variable_global_exists("run_biome")) global.run_biome = "water";
    var _biome = global.run_biome;
    
    var _layer_id = layer_get_id("Instances");
    if (_layer_id == -1) _layer_id = layer_create(0, "Instances");
    
    // Limpeza de instâncias antigas para garantir criação puramente procedural
    with (obj_wall) {
        if (object_index == obj_wall) instance_destroy();
    }
    with (obj_boss_button) instance_destroy();
    with (obj_boss_door) instance_destroy();
    with (obj_stage_gate) instance_destroy();
    with (obj_enemy_parent) instance_destroy();
    with (obj_trap_spike) instance_destroy();
    with (obj_chest) instance_destroy();
    var _wp = asset_get_index("obj_water_puddle");
    if (_wp != -1) with (_wp) instance_destroy();
    var _lp = asset_get_index("obj_lava_pool");
    if (_lp != -1) with (_lp) instance_destroy();
    var _mq = asset_get_index("obj_mud_quicksand");
    if (_mq != -1) with (_mq) instance_destroy();
    var _wc = asset_get_index("obj_wind_cyclone");
    if (_wc != -1) with (_wc) instance_destroy();
    var _ip = asset_get_index("obj_ice_patch");
    if (_ip != -1) with (_ip) instance_destroy();
    
    var _cw = 720;
    var _ch = 540;
    var _wall_t = 32;
    var _door_w = 180;
    
    // Matriz de conexões
    // _h_conn[x][y]: conecta (x, y) com (x + 1, y) -> x in [0, 1], y in [0, 2]
    var _h_conn = array_create(2);
    for (var _i = 0; _i < 2; _i++) {
        _h_conn[_i] = array_create(3, false);
    }
    // _v_conn[x][y]: conecta (x, y) com (x, y + 1) -> x in [0, 2], y in [0, 1]
    var _v_conn = array_create(3);
    for (var _i = 0; _i < 3; _i++) {
        _v_conn[_i] = array_create(2, false);
    }
    
    // 1. Sorteia o Canto de Entrada (aleatorio entre os 4 cantos da grid 3x3)
    var _corners = [[0, 0], [2, 0], [0, 2], [2, 2]];
    var _chosen_corner = _corners[irandom(3)];
    var _start_gx = _chosen_corner[0];
    var _start_gy = _chosen_corner[1];
    
    // Gerador de Spanning Tree via DFS a partir da Entrada sorteada
    var _visited = array_create(3);
    for (var _i = 0; _i < 3; _i++) {
        _visited[_i] = array_create(3, false);
    }
    
    var _stack_x = [];
    var _stack_y = [];
    
    _visited[_start_gx][_start_gy] = true;
    array_push(_stack_x, _start_gx);
    array_push(_stack_y, _start_gy);
    
    while (array_length(_stack_x) > 0) {
        var _cx_curr = _stack_x[array_length(_stack_x) - 1];
        var _cy_curr = _stack_y[array_length(_stack_y) - 1];
        
        var _dirs = []; // 0: N, 1: S, 2: W, 3: E
        if (_cy_curr > 0 && !_visited[_cx_curr][_cy_curr - 1]) array_push(_dirs, 0);
        if (_cy_curr < 2 && !_visited[_cx_curr][_cy_curr + 1]) array_push(_dirs, 1);
        if (_cx_curr > 0 && !_visited[_cx_curr - 1][_cy_curr]) array_push(_dirs, 2);
        if (_cx_curr < 2 && !_visited[_cx_curr + 1][_cy_curr]) array_push(_dirs, 3);
        
        if (array_length(_dirs) > 0) {
            var _chosen = _dirs[irandom(array_length(_dirs) - 1)];
            var _nx = _cx_curr;
            var _ny = _cy_curr;
            
            if (_chosen == 0) { // N
                _ny = _cy_curr - 1;
                _v_conn[_cx_curr][_ny] = true;
            } else if (_chosen == 1) { // S
                _ny = _cy_curr + 1;
                _v_conn[_cx_curr][_cy_curr] = true;
            } else if (_chosen == 2) { // W
                _nx = _cx_curr - 1;
                _h_conn[_nx][_cy_curr] = true;
            } else if (_chosen == 3) { // E
                _nx = _cx_curr + 1;
                _h_conn[_cx_curr][_cy_curr] = true;
            }
            
            _visited[_nx][_ny] = true;
            array_push(_stack_x, _nx);
            array_push(_stack_y, _ny);
        } else {
            array_pop(_stack_x);
            array_pop(_stack_y);
        }
    }
    
    // Adiciona 1 loop adicional para rota alternativa sem quebrar a progressao de labirinto
    var _loops = 1;
    var _tries = 0;
    while (_loops > 0 && _tries < 30) {
        _tries++;
        if (irandom(1) == 0) {
            var _rx = irandom(1);
            var _ry = irandom(2);
            if (!_h_conn[_rx][_ry]) {
                _h_conn[_rx][_ry] = true;
                _loops--;
            }
        } else {
            var _rx = irandom(2);
            var _ry = irandom(1);
            if (!_v_conn[_rx][_ry]) {
                _v_conn[_rx][_ry] = true;
                _loops--;
            }
        }
    }
    
    // --- CONSTRUCAO DAS PAREDES DO LABIRINTO ---
    
    // 1. Paredes Externas (Bordas)
    dungeon_spawn_wall(0, 0, room_width, _wall_t); // Top
    dungeon_spawn_wall(0, room_height - _wall_t, room_width, _wall_t); // Bottom
    dungeon_spawn_wall(0, 0, _wall_t, room_height); // Left
    dungeon_spawn_wall(room_width - _wall_t, 0, _wall_t, room_height); // Right
    
    // 2. Divisorias Verticais (em x = 720 e x = 1440)
    for (var _gx = 0; _gx < 2; _gx++) {
        var _wx = (_gx + 1) * _cw - (_wall_t * 0.5);
        for (var _gy = 0; _gy < 3; _gy++) {
            var _y_start = _gy * _ch;
            var _y_end = (_gy + 1) * _ch;
            var _cy = _y_start + _ch * 0.5;
            
            if (_h_conn[_gx][_gy]) {
                var _gap_top = _cy - _door_w * 0.5;
                var _gap_bot = _cy + _door_w * 0.5;
                dungeon_spawn_wall(_wx, _y_start, _wall_t, _gap_top - _y_start);
                dungeon_spawn_wall(_wx, _gap_bot, _wall_t, _y_end - _gap_bot);
            } else {
                dungeon_spawn_wall(_wx, _y_start, _wall_t, _ch);
            }
        }
    }
    
    // 3. Divisorias Horizontais (em y = 540 e y = 1080)
    for (var _gy = 0; _gy < 2; _gy++) {
        var _wy = (_gy + 1) * _ch - (_wall_t * 0.5);
        for (var _gx = 0; _gx < 3; _gx++) {
            var _x_start = _gx * _cw;
            var _x_end = (_gx + 1) * _cw;
            var _cx = _x_start + _cw * 0.5;
            
            if (_v_conn[_gx][_gy]) {
                var _gap_left = _cx - _door_w * 0.5;
                var _gap_right = _cx + _door_w * 0.5;
                dungeon_spawn_wall(_x_start, _wy, _gap_left - _x_start, _wall_t);
                dungeon_spawn_wall(_gap_right, _wy, _x_end - _gap_right, _wall_t);
            } else {
                dungeon_spawn_wall(_x_start, _wy, _cw, _wall_t);
            }
        }
    }
    
    // --- DISTRIBUICAO DINAMICA E EMBARALHADA DAS CAMARAS ---
    
    // 2. Calcula distancia em passos no labirinto a partir da Entrada (BFS)
    var _dist_map = array_create(3);
    for (var _i = 0; _i < 3; _i++) {
        _dist_map[_i] = array_create(3, -1);
    }
    _dist_map[_start_gx][_start_gy] = 0;
    var _q_x = [_start_gx];
    var _q_y = [_start_gy];
    
    while (array_length(_q_x) > 0) {
        var _qx = _q_x[0];
        var _qy = _q_y[0];
        array_delete(_q_x, 0, 1);
        array_delete(_q_y, 0, 1);
        var _d = _dist_map[_qx][_qy];
        
        // N
        if (_qy > 0 && _v_conn[_qx][_qy - 1] && _dist_map[_qx][_qy - 1] == -1) {
            _dist_map[_qx][_qy - 1] = _d + 1;
            array_push(_q_x, _qx); array_push(_q_y, _qy - 1);
        }
        // S
        if (_qy < 2 && _v_conn[_qx][_qy] && _dist_map[_qx][_qy + 1] == -1) {
            _dist_map[_qx][_qy + 1] = _d + 1;
            array_push(_q_x, _qx); array_push(_q_y, _qy + 1);
        }
        // W
        if (_qx > 0 && _h_conn[_qx - 1][_qy] && _dist_map[_qx - 1][_qy] == -1) {
            _dist_map[_qx - 1][_qy] = _d + 1;
            array_push(_q_x, _qx - 1); array_push(_q_y, _qy);
        }
        // E
        if (_qx < 2 && _h_conn[_qx][_qy] && _dist_map[_qx + 1][_qy] == -1) {
            _dist_map[_qx + 1][_qy] = _d + 1;
            array_push(_q_x, _qx + 1); array_push(_q_y, _qy);
        }
    }
    
    // Lista todas as outras 8 salas
    var _other_rooms = [];
    for (var _x = 0; _x < 3; _x++) {
        for (var _y = 0; _y < 3; _y++) {
            if (_x == _start_gx && _y == _start_gy) continue;
            array_push(_other_rooms, {gx: _x, gy: _y, dist: _dist_map[_x][_y]});
        }
    }
    
    // Ordena as outras 8 salas pela distancia decrescente (mais distantes primeiro)
    for (var _i = 0; _i < array_length(_other_rooms) - 1; _i++) {
        for (var _j = _i + 1; _j < array_length(_other_rooms); _j++) {
            if (_other_rooms[_j].dist > _other_rooms[_i].dist) {
                var _tmp = _other_rooms[_i];
                _other_rooms[_i] = _other_rooms[_j];
                _other_rooms[_j] = _tmp;
            }
        }
    }
    
    // Atribuicao dos papeis:
    // Sala mais distante: Saida / Portal
    var _exit_room = _other_rooms[0];
    
    // As proximas 4 salas mais distantes: Os 4 Selos Antigos (Botoes)
    var _button_rooms = [_other_rooms[1], _other_rooms[2], _other_rooms[3], _other_rooms[4]];
    
    // Das 3 salas restantes: 1 vira Tesouro (Bau), 2 viram Combate / Desafio
    var _treasure_room = _other_rooms[5];
    var _combat_room1 = _other_rooms[6];
    var _combat_room2 = _other_rooms[7];
    
    // Posiciona o Jogador no Hall de Entrada
    var _spawn_px = _start_gx * _cw + 360;
    var _spawn_py = _start_gy * _ch + 270;
    
    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        _player.x = _spawn_px;
        _player.y = _spawn_py;
        _player.xprevious = _spawn_px;
        _player.yprevious = _spawn_py;
    } else {
        instance_create_layer(_spawn_px, _spawn_py, _layer_id, obj_player);
    }
    
    if (view_enabled && view_visible[0]) {
        var _cam = view_camera[0];
        var _vw = camera_get_view_width(_cam);
        var _vh = camera_get_view_height(_cam);
        camera_set_view_pos(_cam, clamp(_spawn_px - _vw * 0.5, 0, max(0, room_width - _vw)), clamp(_spawn_py - _vh * 0.5, 0, max(0, room_height - _vh)));
    }
    
    // Constroi a arquitetura do Hall de Entrada
    var _cn_n = (_start_gy > 0) ? _v_conn[_start_gx][_start_gy - 1] : false;
    var _cn_s = (_start_gy < 2) ? _v_conn[_start_gx][_start_gy] : false;
    var _cn_w = (_start_gx > 0) ? _h_conn[_start_gx - 1][_start_gy] : false;
    var _cn_e = (_start_gx < 2) ? _h_conn[_start_gx][_start_gy] : false;
    dungeon_build_chamber_template(_start_gx * _cw, _start_gy * _ch, irandom(10), "entrance", _biome, _layer_id, _cn_n, _cn_s, _cn_w, _cn_e);
    
    // Constroi a Camara de Saida
    var _ex_n = (_exit_room.gy > 0) ? _v_conn[_exit_room.gx][_exit_room.gy - 1] : false;
    var _ex_s = (_exit_room.gy < 2) ? _v_conn[_exit_room.gx][_exit_room.gy] : false;
    var _ex_w = (_exit_room.gx > 0) ? _h_conn[_exit_room.gx - 1][_exit_room.gy] : false;
    var _ex_e = (_exit_room.gx < 2) ? _h_conn[_exit_room.gx][_exit_room.gy] : false;
    dungeon_build_chamber_template(_exit_room.gx * _cw, _exit_room.gy * _ch, irandom(10), "exit", _biome, _layer_id, _ex_n, _ex_s, _ex_w, _ex_e);
    
    // Constroi as 4 Camaras de Selo (Botoes) com templates aleatorios e variados
    var _btn_tmpl = [0, 1, 2, 3, 4, 5];
    for (var _ti = 0; _ti < array_length(_btn_tmpl); _ti++) {
        var _swap_idx = irandom_range(_ti, array_length(_btn_tmpl) - 1);
        var _stmp = _btn_tmpl[_ti];
        _btn_tmpl[_ti] = _btn_tmpl[_swap_idx];
        _btn_tmpl[_swap_idx] = _stmp;
    }
    for (var _b = 0; _b < 4; _b++) {
        var _br = _button_rooms[_b];
        var _b_n = (_br.gy > 0) ? _v_conn[_br.gx][_br.gy - 1] : false;
        var _b_s = (_br.gy < 2) ? _v_conn[_br.gx][_br.gy] : false;
        var _b_w = (_br.gx > 0) ? _h_conn[_br.gx - 1][_br.gy] : false;
        var _b_e = (_br.gx < 2) ? _h_conn[_br.gx][_br.gy] : false;
        dungeon_build_chamber_template(_br.gx * _cw, _br.gy * _ch, _btn_tmpl[_b], "button", _biome, _layer_id, _b_n, _b_s, _b_w, _b_e);
    }
    
    // Constroi o Santuario do Tesouro
    var _tr_n = (_treasure_room.gy > 0) ? _v_conn[_treasure_room.gx][_treasure_room.gy - 1] : false;
    var _tr_s = (_treasure_room.gy < 2) ? _v_conn[_treasure_room.gx][_treasure_room.gy] : false;
    var _tr_w = (_treasure_room.gx > 0) ? _h_conn[_treasure_room.gx - 1][_treasure_room.gy] : false;
    var _tr_e = (_treasure_room.gx < 2) ? _h_conn[_treasure_room.gx][_treasure_room.gy] : false;
    dungeon_build_chamber_template(_treasure_room.gx * _cw, _treasure_room.gy * _ch, irandom(10), "treasure", _biome, _layer_id, _tr_n, _tr_s, _tr_w, _tr_e);
    
    // Constroi as duas Camaras de Combate / Cruzamento
    var _c1_n = (_combat_room1.gy > 0) ? _v_conn[_combat_room1.gx][_combat_room1.gy - 1] : false;
    var _c1_s = (_combat_room1.gy < 2) ? _v_conn[_combat_room1.gx][_combat_room1.gy] : false;
    var _c1_w = (_combat_room1.gx > 0) ? _h_conn[_combat_room1.gx - 1][_combat_room1.gy] : false;
    var _c1_e = (_combat_room1.gx < 2) ? _h_conn[_combat_room1.gx][_combat_room1.gy] : false;
    dungeon_build_chamber_template(_combat_room1.gx * _cw, _combat_room1.gy * _ch, irandom(10), "combat", _biome, _layer_id, _c1_n, _c1_s, _c1_w, _c1_e);
    
    var _c2_n = (_combat_room2.gy > 0) ? _v_conn[_combat_room2.gx][_combat_room2.gy - 1] : false;
    var _c2_s = (_combat_room2.gy < 2) ? _v_conn[_combat_room2.gx][_combat_room2.gy] : false;
    var _c2_w = (_combat_room2.gx > 0) ? _h_conn[_combat_room2.gx - 1][_combat_room2.gy] : false;
    var _c2_e = (_combat_room2.gx < 2) ? _h_conn[_combat_room2.gx][_combat_room2.gy] : false;
    dungeon_build_chamber_template(_combat_room2.gx * _cw, _combat_room2.gy * _ch, (irandom(1) == 0 ? 1 : 2), "combat", _biome, _layer_id, _c2_n, _c2_s, _c2_w, _c2_e);
}

// =========================================================================
// SISTEMA DE RODÍZIO DE ARENA E CHEFE SINCRONIZADOS POR TEMPLO
// (Filosofia Sakurai/Miyamoto: O desafio da Arena funciona como prévia tática da Sala do Chefe)
// =========================================================================

/// @function arena_ensure_temple_layout(biome)
/// @desc Garante que um layout aleatório (0 a 3) seja sorteado para o templo atual e mantido consistente
function arena_ensure_temple_layout(_biome) {
    if (!variable_global_exists("run_biome")) global.run_biome = "water";
    var _cur_biome = is_undefined(_biome) ? global.run_biome : _biome;
    
    if (!variable_global_exists("temple_arena_layout") || !variable_global_exists("temple_arena_biome") || global.temple_arena_biome != _cur_biome) {
        global.temple_arena_layout = irandom(3);
        global.temple_arena_biome = _cur_biome;
    }
    return global.temple_arena_layout;
}

/// @function arena_setup_chamber(layout_idx, is_boss, biome)
/// @desc Constrói a arquitetura interna sincronizada da arena/chefe com cobertura tática e perigos
function arena_setup_chamber(_layout_idx, _is_boss, _biome) {
    if (is_undefined(_biome)) {
        if (!variable_global_exists("run_biome")) global.run_biome = "water";
        _biome = global.run_biome;
    }
    if (is_undefined(_layout_idx) || _layout_idx < 0) {
        _layout_idx = arena_ensure_temple_layout(_biome);
    }
    global.temple_arena_layout = _layout_idx;
    global.temple_arena_biome = _biome;

    var _layer_id = layer_get_id("Instances");
    if (_layer_id == -1) _layer_id = layer_create(0, "Instances");

    // 1. Limpeza de paredes internas (preservando as paredes de borda 1200x900)
    with (obj_wall) {
        if (x > 32 && x < 1160 && y > 32 && y < 860) {
            instance_destroy();
        }
    }

    // 2. Limpeza de perigos e armadilhas anteriores
    with (obj_trap_spike) instance_destroy();
    var _wp = asset_get_index("obj_water_puddle");
    if (_wp != -1) with (_wp) instance_destroy();
    var _lp = asset_get_index("obj_lava_pool_cycle");
    if (_lp != -1) with (_lp) instance_destroy();
    var _lp2 = asset_get_index("obj_lava_pool");
    if (_lp2 != -1) with (_lp2) instance_destroy();
    var _wc = asset_get_index("obj_wind_cyclone");
    if (_wc != -1) with (_wc) instance_destroy();
    var _mq = asset_get_index("obj_mud_quicksand");
    if (_mq != -1) with (_mq) instance_destroy();
    var _ip = asset_get_index("obj_ice_patch");
    if (_ip != -1) with (_ip) instance_destroy();
    var _ef = asset_get_index("obj_earth_fissure");
    if (_ef != -1) with (_ef) instance_destroy();

    // Helper para gerar perigo elemental condizente
    var _spawn_hazard = function(_hx, _hy, _b, _lid) {
        if (_b == "water") {
            instance_create_layer(_hx, _hy, _lid, obj_ice_patch);
            var _puddle = asset_get_index("obj_water_puddle");
            if (_puddle != -1) instance_create_layer(_hx + 8, _hy + 8, _lid, _puddle);
        } else if (_b == "fire") {
            instance_create_layer(_hx, _hy, _lid, obj_lava_pool_cycle);
        } else if (_b == "wind") {
            var _wind = asset_get_index("obj_wind_cyclone");
            if (_wind != -1) instance_create_layer(_hx, _hy, _lid, _wind);
        } else { // earth
            var _fissure = asset_get_index("obj_earth_fissure");
            if (_fissure != -1) instance_create_layer(_hx, _hy, _lid, _fissure);
            var _mud = asset_get_index("obj_mud_quicksand");
            if (_mud != -1) instance_create_layer(_hx + 8, _hy + 8, _lid, _mud);
        }
    };

    // 3. Construção da geometria dos 4 layouts modulares
    switch (_layout_idx mod 4) {
        case 0:
            // Layout 0: Pilares Gêmeos Centrais & Flancos Táticos (Clássico Hades/Isaac)
            dungeon_spawn_wall(350, 380, 64, 64);
            dungeon_spawn_wall(786, 380, 64, 64);
            dungeon_spawn_wall(190, 560, 48, 48);
            dungeon_spawn_wall(962, 560, 48, 48);

            instance_create_layer(250, 300, _layer_id, obj_trap_spike);
            instance_create_layer(886, 300, _layer_id, obj_trap_spike);
            instance_create_layer(450, 660, _layer_id, obj_trap_spike);
            instance_create_layer(690, 660, _layer_id, obj_trap_spike);

            _spawn_hazard(180, 250, _biome, _layer_id);
            _spawn_hazard(940, 250, _biome, _layer_id);
            _spawn_hazard(300, 490, _biome, _layer_id);
            _spawn_hazard(830, 490, _biome, _layer_id);
            break;

        case 1:
            // Layout 1: Os Quatro Bastiões Angulares (Arena de Kiting Circular)
            dungeon_spawn_wall(290, 230, 64, 64);
            dungeon_spawn_wall(846, 230, 64, 64);
            dungeon_spawn_wall(290, 590, 64, 64);
            dungeon_spawn_wall(846, 590, 64, 64);

            instance_create_layer(290, 410, _layer_id, obj_trap_spike);
            instance_create_layer(846, 410, _layer_id, obj_trap_spike);
            instance_create_layer(568, 290, _layer_id, obj_trap_spike);
            instance_create_layer(568, 610, _layer_id, obj_trap_spike);

            _spawn_hazard(180, 410, _biome, _layer_id);
            _spawn_hazard(950, 410, _biome, _layer_id);
            _spawn_hazard(420, 410, _biome, _layer_id);
            _spawn_hazard(716, 410, _biome, _layer_id);
            break;

        case 2:
            // Layout 2: Trincheiras Horizontais & Barricadas de Linha de Visão
            dungeon_spawn_wall(270, 434, 160, 32);
            dungeon_spawn_wall(770, 434, 160, 32);
            dungeon_spawn_wall(568, 290, 64, 48);
            dungeon_spawn_wall(568, 570, 64, 48);

            instance_create_layer(270, 350, _layer_id, obj_trap_spike);
            instance_create_layer(870, 350, _layer_id, obj_trap_spike);
            instance_create_layer(270, 520, _layer_id, obj_trap_spike);
            instance_create_layer(870, 520, _layer_id, obj_trap_spike);

            _spawn_hazard(180, 260, _biome, _layer_id);
            _spawn_hazard(940, 260, _biome, _layer_id);
            _spawn_hazard(180, 610, _biome, _layer_id);
            _spawn_hazard(940, 610, _biome, _layer_id);
            break;

        case 3:
            // Layout 3: A Encruzilhada dos Altares (Chicane Tático)
            dungeon_spawn_wall(420, 250, 32, 160);
            dungeon_spawn_wall(748, 490, 32, 160);
            dungeon_spawn_wall(210, 420, 64, 64);
            dungeon_spawn_wall(926, 420, 64, 64);

            instance_create_layer(340, 420, _layer_id, obj_trap_spike);
            instance_create_layer(800, 420, _layer_id, obj_trap_spike);
            instance_create_layer(568, 410, _layer_id, obj_trap_spike);
            instance_create_layer(568, 490, _layer_id, obj_trap_spike);

            _spawn_hazard(280, 250, _biome, _layer_id);
            _spawn_hazard(860, 650, _biome, _layer_id);
            _spawn_hazard(420, 610, _biome, _layer_id);
            _spawn_hazard(748, 290, _biome, _layer_id);
            break;
    }

    // 4. Posicionamento seguro do jogador
    var _player = instance_find(obj_player, 0);
    var _target_py = _is_boss ? 760 : 720;
    if (_player != noone) {
        _player.x = 600;
        _player.y = _target_py;
        _player.xprevious = 600;
        _player.yprevious = _target_py;
    }
}
