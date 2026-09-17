pulse_timer += 0.05;

var _p = instance_find(obj_player, 0);
is_near = (instance_exists(_p) && point_distance(x, y, _p.x, _p.y) <= interact_radius);

if (is_near && instance_exists(_p)) {
    var _pad = input_get_active_pad();
    var _gp_interact = (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face1));
    var _touch = touch_room_clicked(x - 45, y - 45, x + 45, y + 45);
    
    if (keyboard_check_pressed(ord("E")) || _gp_interact || _touch) {
        if (_p.character_class != target_class) {
            player_switch_class(target_class, "none");
            
            // Salva a classe no slot ativo
            if (variable_global_exists("current_save_slot")) {
                save_meta();
            }
        }
    }
}
