// Checkpoint granularity is room-level: leaving char select checkpoints "Room1" (no
// stats yet, nothing collected), and passing the boss gate checkpoints "Room2" together
// with whatever the player currently has (pickup upgrades, but resources refill on load).

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

    global.save_hp_max = _p.hp_max;
    global.save_stamina_max = _p.stamina_max;
    global.save_mana_max = _p.mana_max;
    global.save_attack_damage = _p.attack_damage;
    global.save_attack_cooldown = _p.attack_cooldown;
    global.save_move_speed = _p.move_speed;
    global.save_pickup_damage_reduction = _p.pickup_damage_reduction;

    global.use_saved_stats = true;

    ini_open("save.ini");
    ini_write_string("save", "character", global.save_character);
    ini_write_string("save", "room", global.save_room);
    ini_write_real("save", "has_stats", 1);
    ini_write_real("save", "hp_max", global.save_hp_max);
    ini_write_real("save", "stamina_max", global.save_stamina_max);
    ini_write_real("save", "mana_max", global.save_mana_max);
    ini_write_real("save", "attack_damage", global.save_attack_damage);
    ini_write_real("save", "attack_cooldown", global.save_attack_cooldown);
    ini_write_real("save", "move_speed", global.save_move_speed);
    ini_write_real("save", "pickup_damage_reduction", global.save_pickup_damage_reduction);
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
    global.save_hp_max = ini_read_real("save", "hp_max", 100);
    global.save_stamina_max = ini_read_real("save", "stamina_max", 100);
    global.save_mana_max = ini_read_real("save", "mana_max", 0);
    global.save_attack_damage = ini_read_real("save", "attack_damage", 10);
    global.save_attack_cooldown = ini_read_real("save", "attack_cooldown", 0.3);
    global.save_move_speed = ini_read_real("save", "move_speed", 180);
    global.save_pickup_damage_reduction = ini_read_real("save", "pickup_damage_reduction", 1);
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
