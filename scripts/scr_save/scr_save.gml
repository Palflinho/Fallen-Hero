// Checkpoint granularity is room-level: leaving char select checkpoints "Room1" (level 1,
// no EXP yet), and passing the boss gate checkpoints "Room2" together with the player's
// current level/EXP/talent ranks -- natural attributes are derived from level, so that's
// all that needs to persist for those; synthetic attributes are re-derived from the
// talent slots + their ranks each time via player_recompute_synthetics.

function save_checkpoint_fresh(_character, _room_name, _element) {
    if (is_undefined(_element)) {
        _element = variable_global_exists("selected_element") ? global.selected_element : "none";
    }
    global.save_character = _character;
    global.save_room = _room_name;
    global.save_element = _element;
    global.save_has_stats = false;
    global.has_save = true;

    global.save_talent_ids = variable_global_exists("chosen_talent_ids") ? global.chosen_talent_ids : ["", "", ""];
    global.save_talent_ranks = [0, 0, 0];
    global.save_talent_pending = 0;

    ini_open("save.ini");
    ini_write_string("save", "character", _character);
    ini_write_string("save", "room", _room_name);
    ini_write_string("save", "element", _element);
    ini_write_real("save", "has_stats", 0);
    ini_write_string("save", "talent0", global.save_talent_ids[0]);
    ini_write_string("save", "talent1", global.save_talent_ids[1]);
    ini_write_string("save", "talent2", global.save_talent_ids[2]);
    ini_write_real("save", "rank0", 0);
    ini_write_real("save", "rank1", 0);
    ini_write_real("save", "rank2", 0);
    ini_write_real("save", "pending", 0);
    global.run_gold_earned = 0;
    ini_write_real("save", "run_gold", 0);
    ini_close();
}

function save_checkpoint(_room_name) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;

    global.save_character = _p.character_class;
    global.save_room = _room_name;
    global.save_element = variable_instance_exists(_p, "element_affinity") ? _p.element_affinity : "none";
    global.save_has_stats = true;
    global.has_save = true;

    global.save_level = _p.level;
    global.save_xp = _p.xp;
    global.save_talent_ids = _p.talent_slot_ids;
    global.save_talent_ranks = _p.talent_slot_ranks;
    global.save_talent_pending = _p.talent_pending_points;

    global.use_saved_stats = true;

    ini_open("save.ini");
    ini_write_string("save", "character", global.save_character);
    ini_write_string("save", "room", global.save_room);
    ini_write_string("save", "element", global.save_element);
    ini_write_real("save", "has_stats", 1);
    ini_write_real("save", "level", global.save_level);
    ini_write_real("save", "xp", global.save_xp);
    ini_write_string("save", "talent0", global.save_talent_ids[0]);
    ini_write_string("save", "talent1", global.save_talent_ids[1]);
    ini_write_string("save", "talent2", global.save_talent_ids[2]);
    ini_write_real("save", "rank0", global.save_talent_ranks[0]);
    ini_write_real("save", "rank1", global.save_talent_ranks[1]);
    ini_write_real("save", "rank2", global.save_talent_ranks[2]);
    ini_write_real("save", "pending", global.save_talent_pending);
    ini_write_real("save", "run_gold", variable_global_exists("run_gold_earned") ? global.run_gold_earned : 0);
    ini_write_real("save", "shop_pwr", variable_global_exists("shop_boost_power") ? global.shop_boost_power : 0);
    ini_write_real("save", "shop_def", variable_global_exists("shop_boost_defesa") ? global.shop_boost_defesa : 0);
    ini_write_real("save", "shop_hp", variable_global_exists("shop_boost_hp") ? global.shop_boost_hp : 0);
    ini_write_real("save", "shop_spd", variable_global_exists("shop_boost_speed") ? global.shop_boost_speed : 0);
    ini_close();
}

function load_save_from_disk() {
    global.has_save = false;
    if (!file_exists("save.ini")) return false;

    ini_open("save.ini");
    var _character = ini_read_string("save", "character", "");
    if (_character == "") {
        ini_close();
        return false;
    }

    global.save_character = _character;
    global.save_room = ini_read_string("save", "room", "Room1");
    global.save_element = ini_read_string("save", "element", "none");
    global.save_has_stats = (ini_read_real("save", "has_stats", 0) >= 1);
    global.save_level = ini_read_real("save", "level", 1);
    global.save_xp = ini_read_real("save", "xp", 0);
    global.save_talent_ids = [
        ini_read_string("save", "talent0", ""),
        ini_read_string("save", "talent1", ""),
        ini_read_string("save", "talent2", ""),
    ];
    global.save_talent_ranks = [
        ini_read_real("save", "rank0", 0),
        ini_read_real("save", "rank1", 0),
        ini_read_real("save", "rank2", 0),
    ];
    global.save_talent_pending = ini_read_real("save", "pending", 0);
    global.run_gold_earned = ini_read_real("save", "run_gold", 0);
    global.shop_boost_power = ini_read_real("save", "shop_pwr", 0);
    global.shop_boost_defesa = ini_read_real("save", "shop_def", 0);
    global.shop_boost_hp = ini_read_real("save", "shop_hp", 0);
    global.shop_boost_speed = ini_read_real("save", "shop_spd", 0);
    ini_close();

    global.has_save = true;
    return true;
}

function clear_save() {
    global.has_save = false;
    global.shop_boost_power = 0;
    global.shop_boost_defesa = 0;
    global.shop_boost_hp = 0;
    global.shop_boost_speed = 0;
    if (file_exists("save.ini")) {
        file_delete("save.ini");
    }
}

function goto_checkpoint() {
    if (!global.has_save) return;

    global.selected_character = global.save_character;
    global.selected_element = variable_global_exists("save_element") ? global.save_element : "none";
    global.use_saved_stats = global.save_has_stats;
    global.chosen_talent_ids = global.save_talent_ids;

    var _target = asset_get_index(global.save_room);
    if (_target != -1) {
        room_goto(_target);
    } else {
        room_goto(Room1);
    }
}

function get_save_summary() {
    if (!variable_global_exists("has_save") || !global.has_save) return "";

    var _char_label = "Cavaleiro";
    switch (global.save_character) {
        case "knight":
            var _elem = variable_global_exists("save_element") ? global.save_element : "none";
            switch (_elem) {
                case "water": _char_label = "Cavaleiro (Paladino)"; break;
                case "fire": _char_label = "Cavaleiro (Berserker)"; break;
                case "wind": _char_label = "Cavaleiro (Duelista)"; break;
                case "earth": _char_label = "Cavaleiro (Guardiao)"; break;
                default: _char_label = "Cavaleiro"; break;
            }
            break;
        case "mage":
            var _elem = variable_global_exists("save_element") ? global.save_element : "none";
            switch (_elem) {
                case "water": _char_label = "Mago (Criomante)"; break;
                case "fire": _char_label = "Mago (Piromante)"; break;
                case "wind": _char_label = "Mago (Aeromante)"; break;
                case "earth": _char_label = "Mago (Geomante)"; break;
                default: _char_label = "Mago (Arcano)"; break;
            }
            break;
        case "archer":
            var _elem = variable_global_exists("save_element") ? global.save_element : "none";
            switch (_elem) {
                case "water": _char_label = "Arqueiro (Cacador das Mares)"; break;
                case "fire": _char_label = "Arqueiro (Balistico Infernal)"; break;
                case "wind": _char_label = "Arqueiro (Mestre do Vendaval)"; break;
                case "earth": _char_label = "Arqueiro (Balista da Terra)"; break;
                default: _char_label = "Arqueiro"; break;
            }
            break;
        case "assassin":
            var _elem = variable_global_exists("save_element") ? global.save_element : "none";
            switch (_elem) {
                case "water": _char_label = "Assassino (Lamina Espectral)"; break;
                case "fire": _char_label = "Assassino (Lamina Vulcanica)"; break;
                case "wind": _char_label = "Assassino (Algoz do Tufao)"; break;
                case "earth": _char_label = "Assassino (Veneno Tellurico)"; break;
                default: _char_label = "Assassino"; break;
            }
            break;
    }

    var _room_label = "Fase 1 (Arena Glacial)";
    switch (global.save_room) {
        case "Room1": _room_label = "Fase 1 (Arena Glacial)"; break;
        case "Room2": _room_label = "Fase 1 (General Glacial)"; break;
        case "Room3": _room_label = "Fase 2 (Forjas de Magma)"; break;
        case "Room4": _room_label = "Fase 2 (General Magma)"; break;
        case "Room5": _room_label = "Fase 3 (Ruinas dos Ventos)"; break;
        case "Room6": _room_label = "Fase 3 (General Zephyrus)"; break;
        case "Room7": _room_label = "Fase 4 (Caverna de Granito)"; break;
        case "Room8": _room_label = "Fase 4 (Tita Monolito)"; break;
        case "room_shop": _room_label = "Intermissao (O Mercador Arcano)"; break;
        default: _room_label = global.save_room; break;
    }

    var _lvl = variable_global_exists("save_level") ? string(global.save_level) : "1";
    return _char_label + "   -   Nivel " + _lvl + "   -   " + _room_label;
}
