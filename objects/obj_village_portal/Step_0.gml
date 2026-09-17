pulse_timer += 0.05;

if (transitioning) {
    transition_alpha += 0.04;
    if (transition_alpha >= 1) {
        room_goto(Room1);
    }
    exit;
}

var _p = instance_find(obj_player, 0);
is_near = (instance_exists(_p) && point_distance(x, y, _p.x, _p.y) <= interact_radius);

if (is_near && instance_exists(_p)) {
    var _pad = input_get_active_pad();
    var _gp_enter = (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face1));
    var _touch = touch_room_clicked(x - 50, y - 50, x + 50, y + 50);
    
    // Entrar ao pressionar E, confirmar com controle/touch ou ao caminhar diretamente no centro
    if (keyboard_check_pressed(ord("E")) || _gp_enter || _touch || point_distance(x, y, _p.x, _p.y) < 30) {
        transitioning = true;
        input_rumble_trigger(0.35, 0.35, 250);
    }
}
