// =========================================================================
// SISTEMA DE SALVAMENTO MULTI-SLOT (3 SLOTS) & REGRAS ROGUELITE
// =========================================================================
// Pilares aplicados:
// 1. Miyamoto: Semiótica clara, 3 slots visuais distintos com feedback tátil.
// 2. Sakurai: O salvamento existe exclusivamente na Seleção de Personagens.
//             Runs são expedições autocontidas (sem mid-run checkpoints).
// 3. Iwata: Zero vazamento de texto, auto-escala protetora, e reset profundo
//           garantindo que "Novo Jogo" comece sempre do zero absoluto.

if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;

function format_playtime(_sec) {
    var _total_sec = floor(max(0, _sec));
    var _hrs = floor(_total_sec / 3600);
    var _mins = floor((_total_sec mod 3600) / 60);
    var _rem_sec = _total_sec mod 60;

    var _str_mins = (_mins < 10) ? ("0" + string(_mins)) : string(_mins);
    var _str_secs = (_rem_sec < 10) ? ("0" + string(_rem_sec)) : string(_rem_sec);

    if (_hrs > 0) {
        var _str_hrs = (_hrs < 10) ? ("0" + string(_hrs)) : string(_hrs);
        return _str_hrs + ":" + _str_mins + ":" + _str_secs;
    }
    return _str_mins + ":" + _str_secs;
}

function save_slot_section(_slot) {
    var _s = clamp(_slot, 1, 3);
    return "slot" + string(_s);
}

function get_hero_archetype_label(_char, _elem) {
    var _char_label = "Cavaleiro";
    switch (_char) {
        case "knight":
            switch (_elem) {
                case "water": _char_label = "Cavaleiro (Lanceiro)"; break;
                case "fire": _char_label = "Cavaleiro (Cavaleiro Runico)"; break;
                case "wind": _char_label = "Cavaleiro (Duelista)"; break;
                case "earth": _char_label = "Cavaleiro (Guardiao)"; break;
                default: _char_label = "Cavaleiro"; break;
            }
            break;
        case "mage":
            switch (_elem) {
                case "water": _char_label = "Mago (Atiradora Arcana)"; break;
                case "fire": _char_label = "Mago (Piromante)"; break;
                case "wind": _char_label = "Mago (Ilusionista)"; break;
                case "earth": _char_label = "Mago (Templaria)"; break;
                default: _char_label = "Mago (Arcano)"; break;
            }
            break;
        case "archer":
            switch (_elem) {
                case "water": _char_label = "Arqueiro (Cacador das Mares)"; break;
                case "fire": _char_label = "Arqueiro (Artilheiro Arcano)"; break;
                case "wind": _char_label = "Arqueiro (Cacador Furtivo)"; break;
                case "earth": _char_label = "Arqueiro (Sentinela)"; break;
                default: _char_label = "Arqueiro"; break;
            }
            break;
        case "assassin":
            switch (_elem) {
                case "water": _char_label = "Assassino (Rastreador)"; break;
                case "fire": _char_label = "Assassino (Alquimista)"; break;
                case "wind": _char_label = "Assassino (Algoz do Tufao)"; break;
                case "earth": _char_label = "Assassino (Veneno Tellurico)"; break;
                default: _char_label = "Assassino"; break;
            }
            break;
        default:
            _char_label = "Heroi";
            break;
    }
    return _char_label;
}

function save_slot_exists(_slot) {
    if (!file_exists("save.ini")) return false;

    var _sec = save_slot_section(_slot);
    ini_open("save.ini");
    var _occ = (ini_read_real(_sec, "occupied", 0) >= 1);
    var _char = ini_read_string(_sec, "character", "");

    // Retrocompatibilidade: importa save antigo do bloco [save] para o [slot1] uma unica vez
    if (!_occ && _char == "" && _slot == 1 && ini_section_exists("save")) {
        var _legacy_char = ini_read_string("save", "character", "");
        if (_legacy_char != "") {
            _occ = true;
            _char = _legacy_char;
            ini_write_real("slot1", "occupied", 1);
            ini_write_string("slot1", "character", _legacy_char);
            ini_write_string("slot1", "element", ini_read_string("save", "element", "none"));
            ini_write_string("slot1", "room", "Room1");
            ini_write_real("slot1", "level", ini_read_real("save", "level", 1));
            ini_write_real("slot1", "xp", ini_read_real("save", "xp", 0));
            ini_write_real("slot1", "playtime", ini_read_real("save", "playtime", 0));
            ini_write_string("slot1", "talent0", ini_read_string("save", "talent0", ""));
            ini_write_string("slot1", "talent1", ini_read_string("save", "talent1", ""));
            ini_write_string("slot1", "talent2", ini_read_string("save", "talent2", ""));
            ini_section_delete("save");
        }
    }
    ini_close();

    return (_occ || _char != "");
}

function any_save_slot_exists() {
    return save_slot_exists(1) || save_slot_exists(2) || save_slot_exists(3);
}

function save_slot_get_info(_slot) {
    var _res = {
        slot: _slot,
        occupied: false,
        character: "",
        element: "none",
        level: 1,
        xp: 0,
        playtime: 0,
        talent_ids: ["", "", ""],
        hero_label: "[ SLOT VAZIO ]",
        progress_label: "Disponivel para Nova Jornada"
    };

    if (!file_exists("save.ini")) return _res;

    var _sec = save_slot_section(_slot);
    ini_open("save.ini");
    var _occ = (ini_read_real(_sec, "occupied", 0) >= 1);
    var _char = ini_read_string(_sec, "character", "");

    // Retrocompatibilidade slot 1
    if (!_occ && _char == "" && _slot == 1) {
        _char = ini_read_string("save", "character", "");
        if (_char != "") _occ = true;
    }

    if (!_occ && _char == "") {
        ini_close();
        return _res;
    }

    var _elem = ini_read_string(_sec, "element", "none");
    var _lvl = ini_read_real(_sec, "level", 1);
    var _xp = ini_read_real(_sec, "xp", 0);
    var _time = ini_read_real(_sec, "playtime", 0);
    var _t0 = ini_read_string(_sec, "talent0", "");
    var _t1 = ini_read_string(_sec, "talent1", "");
    var _t2 = ini_read_string(_sec, "talent2", "");
    ini_close();

    _res.occupied = true;
    _res.character = _char;
    _res.element = _elem;
    _res.level = _lvl;
    _res.xp = _xp;
    _res.playtime = _time;
    _res.talent_ids = [_t0, _t1, _t2];
    _res.hero_label = get_hero_archetype_label(_char, _elem);
    _res.progress_label = "Nivel " + string(_lvl) + "   *   Tempo: " + format_playtime(_time);

    return _res;
}

function save_slot_load(_slot) {
    if (!save_slot_exists(_slot)) return false;

    var _sec = save_slot_section(_slot);
    ini_open("save.ini");
    var _character = ini_read_string(_sec, "character", "");
    if (_character == "" && _slot == 1) {
        _character = ini_read_string("save", "character", "knight");
    }

    global.current_save_slot = _slot;
    global.save_character = _character;
    global.save_element = ini_read_string(_sec, "element", "none");
    global.save_room = "Room1"; // Expedições sempre se iniciam na Room1
    global.save_has_stats = false;
    global.use_saved_stats = false;
    global.save_level = ini_read_real(_sec, "level", 1);
    global.save_xp = ini_read_real(_sec, "xp", 0);
    global.save_talent_ids = [
        ini_read_string(_sec, "talent0", ""),
        ini_read_string(_sec, "talent1", ""),
        ini_read_string(_sec, "talent2", "")
    ];
    global.save_talent_ranks = [0, 0, 0];
    global.save_talent_pending = 0;
    global.run_gold_earned = 0;
    global.shop_boost_power = 0;
    global.shop_boost_defesa = 0;
    global.shop_boost_hp = 0;
    global.shop_boost_speed = 0;
    global.run_playtime = ini_read_real(_sec, "playtime", 0);
    global.temple_arena_layout = ini_read_real(_sec, "arena_layout", 0);
    global.temple_arena_biome = ini_read_string(_sec, "arena_biome", "water");
    ini_close();

    // Carrega meta-progresso exclusivo deste slot (ouro, elementos, talentos de loja)
    load_meta_from_disk();

    global.selected_character = global.save_character;
    global.selected_element = global.save_element;
    global.chosen_talent_ids = global.save_talent_ids;
    global.has_save = true;

    return true;
}

function save_slot_delete(_slot) {
    var _s = clamp(_slot, 1, 3);
    if (file_exists("save.ini")) {
        var _sec = save_slot_section(_s);
        ini_open("save.ini");
        ini_section_delete(_sec);
        if (_s == 1 && ini_section_exists("save")) {
            ini_section_delete("save");
        }
        ini_close();
    }

    // Apaga a meta progressao vinculada a este slot
    meta_slot_delete(_s);

    if (!any_save_slot_exists()) {
        global.has_save = false;
    }
}

function save_slot_init_new_game(_slot) {
    var _s = clamp(_slot, 1, 3);
    global.current_save_slot = _s;

    // Reset profundo de variáveis de run
    global.has_save = false;
    global.use_saved_stats = false;
    global.save_has_stats = false;
    global.save_character = "";
    global.save_element = "none";
    global.save_level = 1;
    global.save_xp = 0;
    global.save_room = "Room1";
    global.run_playtime = 0;
    global.run_gold_earned = 0;
    global.shop_boost_power = 0;
    global.shop_boost_defesa = 0;
    global.shop_boost_hp = 0;
    global.shop_boost_speed = 0;
    global.run_biome = "water";
    global.run_room_step = 1;
    global.temple_arena_layout = 0;
    global.temple_arena_biome = "water";
    global.boss_buttons_pressed = 0;
    global.chosen_talent_ids = ["", "", ""];
    global.save_talent_ranks = [0, 0, 0];
    global.save_talent_pending = 0;

    // Limpa tanto o save.ini quanto o meta.json deste slot
    save_slot_delete(_s);
    save_meta();
}

function save_slot_save_character_select(_slot, _character, _element, _talent_ids) {
    var _s = clamp(_slot, 1, 3);
    if (is_undefined(_element) || _element == "") _element = "none";
    if (is_undefined(_talent_ids) || !is_array(_talent_ids)) _talent_ids = ["", "", ""];

    var _t0 = (array_length(_talent_ids) > 0) ? _talent_ids[0] : "";
    var _t1 = (array_length(_talent_ids) > 1) ? _talent_ids[1] : "";
    var _t2 = (array_length(_talent_ids) > 2) ? _talent_ids[2] : "";

    var _sec = save_slot_section(_s);
    ini_open("save.ini");
    ini_write_real(_sec, "occupied", 1);
    ini_write_string(_sec, "character", _character);
    ini_write_string(_sec, "element", _element);
    ini_write_string(_sec, "room", "Room1");
    ini_write_real(_sec, "level", 1);
    ini_write_real(_sec, "xp", 0);
    ini_write_real(_sec, "has_stats", 0);
    ini_write_string(_sec, "talent0", _t0);
    ini_write_string(_sec, "talent1", _t1);
    ini_write_string(_sec, "talent2", _t2);
    ini_write_real(_sec, "rank0", 0);
    ini_write_real(_sec, "rank1", 0);
    ini_write_real(_sec, "rank2", 0);
    ini_write_real(_sec, "pending", 0);
    ini_write_real(_sec, "run_gold", 0);
    ini_write_real(_sec, "playtime", variable_global_exists("run_playtime") ? global.run_playtime : 0);
    ini_write_real(_sec, "arena_layout", variable_global_exists("temple_arena_layout") ? global.temple_arena_layout : 0);
    ini_write_string(_sec, "arena_biome", variable_global_exists("temple_arena_biome") ? global.temple_arena_biome : "water");
    ini_close();

    global.current_save_slot = _s;
    global.save_character = _character;
    global.save_element = _element;
    global.save_room = "Room1";
    global.save_has_stats = false;
    global.use_saved_stats = false;
    global.chosen_talent_ids = [_t0, _t1, _t2];
    global.has_save = true;
}

// Checkpoint no-op durante a run (Sakurai roguelite rule: sem saves intermediários)
function save_checkpoint(_room_name) {
    return;
}

function save_checkpoint_fresh(_character, _room_name, _element) {
    if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;
    var _talents = variable_global_exists("chosen_talent_ids") ? global.chosen_talent_ids : ["", "", ""];
    save_slot_save_character_select(global.current_save_slot, _character, _element, _talents);
}

function load_save_from_disk() {
    global.has_save = false;
    if (!file_exists("save.ini")) return false;

    if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;

    // Se o slot atual existir, carrega ele
    if (save_slot_exists(global.current_save_slot)) {
        return save_slot_load(global.current_save_slot);
    }

    // Caso contrário, busca o primeiro slot existente
    for (var _i = 1; _i <= 3; _i++) {
        if (save_slot_exists(_i)) {
            return save_slot_load(_i);
        }
    }

    return false;
}

function clear_save() {
    // Sakurai Roguelite Rule:
    // Limpa apenas o progresso volátil da expedição in-run atual (fase, ouro da run, boosts de loja)
    // JAMAIS deleta o perfil do herói salvo no slot nem apaga o save.ini!
    global.inrun_saved_stats = false;
    global.use_saved_stats = false;
    global.run_room_step = 1;
    global.run_room_index = 1;
    global.boss_buttons_pressed = 0;
    global.run_gold_earned = 0;
    global.shop_boost_power = 0;
    global.shop_boost_defesa = 0;
    global.shop_boost_hp = 0;
    global.shop_boost_speed = 0;
    if (variable_global_exists("current_save_slot") && save_slot_exists(global.current_save_slot)) {
        global.has_save = true;
    }
}

function goto_checkpoint() {
    if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;
    if (!save_slot_exists(global.current_save_slot)) {
        if (!load_save_from_disk()) return;
    } else {
        save_slot_load(global.current_save_slot);
    }

    global.selected_character = global.save_character;
    global.selected_element = variable_global_exists("save_element") ? global.save_element : "none";
    global.use_saved_stats = false;
    global.chosen_talent_ids = global.save_talent_ids;
    room_goto(Room1);
}

function get_save_hero_label() {
    if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;
    var _info = save_slot_get_info(global.current_save_slot);
    if (!_info.occupied) return "";
    return _info.hero_label + "   *   Nivel " + string(_info.level);
}

function get_save_progress_label() {
    if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;
    var _info = save_slot_get_info(global.current_save_slot);
    if (!_info.occupied) return "";
    return "Fase de Preparacao   *   Tempo: " + format_playtime(_info.playtime);
}

function get_save_summary() {
    if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;
    var _info = save_slot_get_info(global.current_save_slot);
    if (!_info.occupied) return "";
    return _info.hero_label + "   -   " + _info.progress_label;
}
