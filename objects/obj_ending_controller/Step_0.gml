var _dt = delta_time / 1000000;
if (deny_timer > 0) deny_timer -= _dt;

switch (state) {
    case "delay":
        state_timer -= _dt;
        if (state_timer <= 0) {
            state = "revelation";
            global.ending_active = true;
            dialogue_play_id("temple5_human_defeat", function() {
                with (obj_ending_controller) state = "choice";
            });
        }
        break;

    case "revelation":
        // Aguardando o dialogo da revelacao terminar
        break;

    case "choice":
        if (dialogue_is_active()) break;
        var _n = array_length(options);
        if (input_check_ui_up_pressed()) { cursor = (cursor - 1 + _n) mod _n; sfx_play("menu_select", 0.05, 1.1); }
        if (input_check_ui_down_pressed()) { cursor = (cursor + 1) mod _n; sfx_play("menu_select", 0.05, 1.1); }

        // Toque / clique nos cards (mesmo layout do Draw GUI)
        var _gw = display_get_gui_width();
        var _gh = display_get_gui_height();
        var _cw = min(720, _gw - 60);
        var _ch = 74;
        var _cx = (_gw - _cw) / 2;
        var _cy0 = _gh / 2 - 60;
        var _pick = false;
        for (var _i = 0; _i < _n; _i++) {
            var _yy = _cy0 + _i * (_ch + 14);
            if (touch_gui_clicked(_cx, _yy, _cx + _cw, _yy + _ch)) { cursor = _i; _pick = true; }
        }

        if (input_check_ui_confirm() || _pick) {
            var _opt = options[cursor];
            if (_opt.id == "sintese" && !ending_synthesis_available()) {
                deny_timer = 1.2;
                sfx_play("parry", 0.05, 0.6);
            } else {
                chosen = _opt.id;
                pages = ending_get_pages(chosen);
                page_index = 0;
                page_alpha = 0;
                state = "epilogue";
                sfx_play("magic", 0.05, 0.8);
            }
        }
        break;

    case "epilogue":
        page_alpha = min(1, page_alpha + _dt * 0.9);
        if (input_check_ui_confirm() || touch_gui_clicked(0, 0, display_get_gui_width(), display_get_gui_height())) {
            if (page_alpha < 1) {
                page_alpha = 1;
            } else {
                page_index += 1;
                page_alpha = 0;
                if (page_index >= array_length(pages)) {
                    state = "credits";
                    credits_y = display_get_gui_height() + 20;
                }
            }
        }
        break;

    case "credits":
        var _speed = (keyboard_check(vk_enter) || keyboard_check(ord("Z")) || keyboard_check(vk_space) || mouse_check_button(mb_left)) ? 180 : 45;
        credits_y -= _speed * _dt;
        var _total_h = array_length(credits) * 34;
        if (credits_y + _total_h < display_get_gui_height() * 0.5) {
            credits_done_timer += _dt;
            if (credits_done_timer > 2.5 || (credits_done_timer > 0.5 && input_check_ui_confirm())) {
                state = "finish";
            }
        }
        break;

    case "finish":
        fade = min(1, fade + _dt * 1.2);
        if (fade >= 1 && !finished) {
            finished = true;
            ending_mark_seen(chosen);
            var _pl = instance_find(obj_player, 0);
            if (_pl != noone) mastery_unlock(_pl.character_class, _pl.element_affinity);
            global.ending_active = false;
            global.inrun_saved_stats = false;
            clear_save();
            global.run_victory = false;
            global.char_select_direct = false;
            room_goto(room_char_select);
        }
        break;
}
