var _player = instance_find(obj_player, 0);

if (!level_complete && boss_room && instance_number(obj_enemy_parent) == 0) {
    level_complete = true;
}

if (!game_over && _player != noone && _player.state == "dead") {
    game_over = true;
    if (global.paused) {
        global.paused = false;
        instance_activate_all();
    }
    if (global.attr_window_open) {
        global.attr_window_open = false;
        instance_activate_all();
    }
}

if (game_over) {
    if (keyboard_check_pressed(ord("R"))) {
        goto_checkpoint();
    } else if (keyboard_check_pressed(ord("M"))) {
        room_goto(room_char_select);
    }
    exit;
}

if (level_complete) {
    if (keyboard_check_pressed(ord("Z"))) {
        clear_save();
        room_goto(room_char_select);
    }
    exit;
}

if (global.attr_window_open) {
    if (keyboard_check_pressed(ord("T")) || keyboard_check_pressed(vk_escape)) {
        global.attr_window_open = false;
        instance_activate_all();
    } else if (_player != noone) {
        if (keyboard_check_pressed(ord("1"))) player_apply_talent_point(_player, 0);
        if (keyboard_check_pressed(ord("2"))) player_apply_talent_point(_player, 1);
        if (keyboard_check_pressed(ord("3"))) player_apply_talent_point(_player, 2);
    }
    exit;
}

if (global.paused) {
    if (keyboard_check_pressed(vk_escape)) {
        global.paused = false;
        instance_activate_all();
    } else if (keyboard_check_pressed(ord("M"))) {
        instance_activate_all();
        global.paused = false;
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("Q"))) {
        game_end();
    }
    exit;
}

if (keyboard_check_pressed(vk_escape)) {
    global.paused = true;
    instance_deactivate_all(true);
} else if (keyboard_check_pressed(ord("T"))) {
    global.attr_window_open = true;
    instance_deactivate_all(true);
}
