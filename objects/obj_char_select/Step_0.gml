var _n = array_length(classes);

if (keyboard_check_pressed(vk_right)) selected_index = (selected_index + 1) mod _n;
if (keyboard_check_pressed(vk_left)) selected_index = (selected_index - 1 + _n) mod _n;

if (keyboard_check_pressed(ord("Z"))) {
    global.selected_character = classes[selected_index];
    room_goto(Room1);
}
