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

    // Mantem 60% do ouro ganho na partida
    if (!variable_global_exists("run_gold_earned")) global.run_gold_earned = 0;
    death_gold_earned = global.run_gold_earned;
    death_gold_kept = round(death_gold_earned * 0.60);
    death_gold_lost = death_gold_earned - death_gold_kept;

    ensure_meta_loaded();
    global.gold = max(0, global.gold - death_gold_lost);
    save_meta();

    global.run_gold_earned = 0;
    clear_save();
}

if (game_over) {
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("C"))) {
        global.char_select_direct = true;
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("M"))) {
        global.char_select_direct = false;
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("R"))) {
        goto_checkpoint();
    }
    exit;
}

if (!variable_global_exists("run_victory")) global.run_victory = false;

if (global.run_victory || level_complete) {
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("C"))) {
        clear_save();
        global.run_victory = false;
        level_complete = false;
        global.char_select_direct = true;
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

if (global.paused || global.attr_window_open) {
    if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("T"))) {
        global.paused = false;
        global.attr_window_open = false;
    } else if (_player != noone) {
        if (keyboard_check_pressed(ord("1"))) player_apply_talent_point(_player, 0);
        if (keyboard_check_pressed(ord("2"))) player_apply_talent_point(_player, 1);
        if (keyboard_check_pressed(ord("3"))) player_apply_talent_point(_player, 2);
    }

    if (keyboard_check_pressed(ord("C"))) {
        global.paused = false;
        global.attr_window_open = false;
        global.char_select_direct = true;
        save_checkpoint(room_get_name(room));
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("M"))) {
        global.paused = false;
        global.attr_window_open = false;
        save_checkpoint(room_get_name(room));
        room_goto(room_char_select);
    } else if (keyboard_check_pressed(ord("Q"))) {
        save_checkpoint(room_get_name(room));
        game_end();
    }
    exit;
}

if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("T"))) {
    global.paused = true;
    global.attr_window_open = true;
} else if (keyboard_check_pressed(vk_f1)) {
    global.char_select_direct = true;
    room_goto(room_char_select);
}
