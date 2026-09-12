// Ticks down regardless of any pause/UI state -- if this lived behind is_world_paused()
// itself, hitstop would freeze permanently the moment it started.
if (global.hitstop_timer > 0) global.hitstop_timer -= delta_time / 1000000;

var _player = instance_find(obj_player, 0);

if (!level_complete && boss_room && is_final_room && instance_number(obj_enemy_parent) == 0) {
    level_complete = true;
}

if (!boss_room && !mob_clear_chest_spawned && instance_number(obj_enemy_parent) == 0) {
    mob_clear_chest_spawned = true;
    if (_player != noone) {
        instance_create_layer(_player.x, _player.y, layer, obj_chest);
    }
}

if (!game_over && _player != noone && _player.state == "dead") {
    game_over = true;
    global.paused = false;
    global.attr_window_open = false;
    global.chest_reward_open = false;
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

if (global.chest_reward_open) {
    if (_player != noone) {
        if (keyboard_check_pressed(ord("1"))) equip_chest_talent(_player, 0);
        if (keyboard_check_pressed(ord("2"))) equip_chest_talent(_player, 1);
        if (keyboard_check_pressed(ord("3"))) equip_chest_talent(_player, 2);
        if (keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape)) skip_chest_reward();
    }
    exit;
}

if (global.attr_window_open) {
    if (keyboard_check_pressed(ord("T")) || keyboard_check_pressed(vk_escape)) {
        global.attr_window_open = false;
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
    } else if (keyboard_check_pressed(ord("M"))) {
        global.paused = false;
        save_checkpoint(room_get_name(room));
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("Q"))) {
        save_checkpoint(room_get_name(room));
        game_end();
    }
    exit;
}

if (keyboard_check_pressed(vk_escape)) {
    global.paused = true;
} else if (keyboard_check_pressed(ord("T"))) {
    global.attr_window_open = true;
}
