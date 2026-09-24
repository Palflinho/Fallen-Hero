lines = [];
line_index = 0;
on_finish = undefined;

current_speaker = "knight";
current_name = tr("Herói");
current_alien = "";
current_text = "";
current_portrait = -1;

typewriter_pos = 0;
typewriter_speed = 42; // letras por segundo
typewriter_done = false;
char_sound_cooldown = 0;

box_alpha = 0;

dialogue_setup_current_line = function() {
    if (line_index >= array_length(lines)) {
        global.dialogue_active = false;
        global.dialogue_just_closed_timer = 0.35;
        keyboard_clear(vk_space);
        keyboard_clear(vk_enter);
        keyboard_clear(ord("Z"));
        io_clear();
        var _cb = on_finish;
        instance_destroy();
        if (!is_undefined(_cb) && is_method(_cb)) {
            _cb();
        }
        return;
    }

    var _line = lines[line_index];
    current_speaker = variable_struct_exists(_line, "speaker") ? _line.speaker : "knight";
    current_name = variable_struct_exists(_line, "name") ? _line.name : tr("Herói");
    current_alien = variable_struct_exists(_line, "alien") ? _line.alien : "";
    current_text = variable_struct_exists(_line, "text") ? _line.text : "";

    if (variable_struct_exists(_line, "portrait") && _line.portrait != -1) {
        current_portrait = _line.portrait;
    } else {
        switch (current_speaker) {
            case "knight": current_portrait = spr_portrait_knight; break;
            case "mage": current_portrait = spr_portrait_mage; break;
            case "archer": current_portrait = spr_portrait_archer; break;
            case "assassin": current_portrait = spr_portrait_assassin; break;
            default: current_portrait = -1; break;
        }
    }

    typewriter_pos = 0;
    typewriter_done = false;
    char_sound_cooldown = 0;
};
