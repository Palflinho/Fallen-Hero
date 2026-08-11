var _n = array_length(classes);

if (keyboard_check_pressed(vk_right)) selected_index = (selected_index + 1) mod _n;
if (keyboard_check_pressed(vk_left)) selected_index = (selected_index - 1 + _n) mod _n;

if (keyboard_check_pressed(ord("Z"))) {
    global.selected_character = classes[selected_index];
    global.use_saved_stats = false;
    save_checkpoint_fresh(global.selected_character, "Room1");
    room_goto(Room1);
}

if (global.has_save && keyboard_check_pressed(ord("C"))) {
    goto_checkpoint();
}
