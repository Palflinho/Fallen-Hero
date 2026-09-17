pulse_timer += 0.05;

var _p = instance_find(obj_player, 0);
is_near = (instance_exists(_p) && point_distance(x, y, _p.x, _p.y) <= interact_radius);

if (show_modal) {
    modal_anim = min(1, modal_anim + 0.1);
    
    // Fechar com ESC, B do gamepad ou clique fora
    var _pad = input_get_active_pad();
    var _gp_close = (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face2));
    var _close_pressed = keyboard_check_pressed(vk_escape) || _gp_close;
    
    var _gui_w = display_get_gui_width();
    var _gui_h = display_get_gui_height();
    var _close_btn_x = _gui_w / 2 - 90;
    var _close_btn_y = _gui_h / 2 + 180;
    
    if (_close_pressed || touch_room_clicked(_close_btn_x, _close_btn_y, _close_btn_x + 180, _close_btn_y + 45)) {
        show_modal = false;
    }
} else {
    modal_anim = max(0, modal_anim - 0.1);
    
    if (is_near) {
        var _pad = input_get_active_pad();
        var _gp_interact = (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face1));
        var _touch = touch_room_clicked(x - 60, y - 60, x + 60, y + 60);
        
        if (keyboard_check_pressed(ord("E")) || _gp_interact || _touch) {
            show_modal = true;
            input_rumble_trigger(0.2, 0.2, 80);
        }
    }
}
