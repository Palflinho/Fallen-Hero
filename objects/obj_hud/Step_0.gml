if (!level_complete && instance_number(obj_enemy_parent) == 0) {
    level_complete = true;
}

if (level_complete && keyboard_check_pressed(ord("Z"))) {
    room_goto(room_char_select);
}
