// Checkpoint granularity is room-level: leaving char select checkpoints "Room1" (level 1,
// no EXP yet), and passing the boss gate checkpoints "Room2" together with the player's
// current level/EXP -- natural attributes are derived from level, so that's all that
// needs to persist (synthetic attributes stay at 0 until talents exist).

function save_checkpoint_fresh(_character, _room_name) {
    global.save_character = _character;
    global.save_room = _room_name;
    global.save_has_stats = false;
    global.has_save = true;

    ini_open("save.ini");
    ini_write_string("save", "character", _character);
    ini_write_string("save", "room", _room_name);
    ini_write_real("save", "has_stats", 0);
    ini_close();
}

function save_checkpoint(_room_name) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;

    global.save_character = _p.character_class;
    global.save_room = _room_name;
    global.save_has_stats = true;
    global.has_save = true;

    global.save_level = _p.level;
    global.save_xp = _p.xp;

    global.use_saved_stats = true;

    ini_open("save.ini");
    ini_write_string("save", "character", global.save_character);
    ini_write_string("save", "room", global.save_room);
    ini_write_real("save", "has_stats", 1);
    ini_write_real("save", "level", global.save_level);
    ini_write_real("save", "xp", global.save_xp);
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
    global.save_has_stats = (ini_read_real("save", "has_stats", 0) >= 1);
    global.save_level = ini_read_real("save", "level", 1);
    global.save_xp = ini_read_real("save", "xp", 0);
    ini_close();

    global.has_save = true;
    return true;
}

function clear_save() {
    global.has_save = false;
    if (file_exists("save.ini")) {
        file_delete("save.ini");
    }
}

function goto_checkpoint() {
    if (!global.has_save) return;

    global.selected_character = global.save_character;
    global.use_saved_stats = global.save_has_stats;

    if (global.save_room == "Room2") {
        room_goto(Room2);
    } else {
        room_goto(Room1);
    }
}
