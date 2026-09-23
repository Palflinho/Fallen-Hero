var _dt = delta_time / 1000000;
box_alpha = min(1.0, box_alpha + _dt * 5);

// Datetime typing
if (!typewriter_done) {
    var _len = string_length(current_text);
    var _prev_pos = floor(typewriter_pos);
    typewriter_pos += typewriter_speed * _dt;
    var _cur_pos = min(_len, floor(typewriter_pos));

    if (_cur_pos > _prev_pos) {
        char_sound_cooldown -= (_cur_pos - _prev_pos);
        if (char_sound_cooldown <= 0) {
            char_sound_cooldown = 3;
            var _voice_key = "voice_" + current_speaker;
            sfx_play(_voice_key, 0.08, 0.45);
        }
    }

    if (typewriter_pos >= _len) {
        typewriter_pos = _len;
        typewriter_done = true;
    }
}

// User advance input
var _touch_tap = false;
for (var _i = 0; _i < 5; _i++) {
    if (device_mouse_check_button_pressed(_i, mb_left)) {
        _touch_tap = true;
        break;
    }
}
if (input_check_ui_confirm() || _touch_tap) {
    if (!typewriter_done) {
        typewriter_pos = string_length(current_text);
        typewriter_done = true;
    } else {
        line_index += 1;
        dialogue_setup_current_line();
    }
}
