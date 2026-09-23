function fh_place_free_of_walls(_x, _y, _radius) {
    var _free = true;
    with (obj_wall) {
        var _w = base_size * image_xscale;
        var _h = base_size * image_yscale;
        var _cx = clamp(_x, x, x + _w);
        var _cy = clamp(_y, y, y + _h);
        if (point_distance(_x, _y, _cx, _cy) < _radius) {
            _free = false;
        }
    }
    return _free;
}

function fh_move_and_collide(_amount_x, _amount_y) {
    if (_amount_x != 0) {
        var _nx = x + _amount_x;
        if (fh_place_free_of_walls(_nx, y, body_radius)) {
            x = _nx;
        }
    }
    if (_amount_y != 0) {
        var _ny = y + _amount_y;
        if (fh_place_free_of_walls(x, _ny, body_radius)) {
            y = _ny;
        }
    }
}

function fh_place_on_ice(_x, _y) {
    var _on = false;
    // Gelo temporario criado por inimigos de agua (rastro do slime, cruz de gelo)
    with (obj_elem_ground) {
        if (kind == "slick" && point_distance(_x, _y, x, y) <= radius) _on = true;
    }
    with (obj_ice_patch) {
        if (active) {
            var _w = base_size * image_xscale;
            var _h = base_size * image_yscale;
            if (_x >= x && _x <= x + _w && _y >= y && _y <= y + _h) {
                _on = true;
            }
        }
    }
    return _on;
}

function fh_place_on_water_puddle(_x, _y) {
    var _on = false;
    var _obj = asset_get_index("obj_water_puddle");
    if (_obj == -1 || !instance_exists(_obj)) return false;
    with (obj_water_puddle) {
        if (active) {
            var _w = base_size * image_xscale;
            var _h = base_size * image_yscale;
            var _cx = x + _w * 0.5;
            var _cy = y + _h * 0.5;
            var _rx = _w * 0.5;
            var _ry = _h * 0.5;
            if (_rx > 0 && _ry > 0) {
                var _dx = (_x - _cx) / _rx;
                var _dy = (_y - _cy) / _ry;
                if (_dx * _dx + _dy * _dy <= 1.0) {
                    _on = true;
                    break;
                }
            }
        }
    }
    return _on;
}

function fh_place_on_mud(_x, _y) {
    var _on = false;
    var _obj = asset_get_index("obj_mud_quicksand");
    if (_obj == -1 || !instance_exists(_obj)) return false;
    with (obj_mud_quicksand) {
        if (active) {
            var _w = base_size * image_xscale;
            var _h = base_size * image_yscale;
            var _cx = x + _w * 0.5;
            var _cy = y + _h * 0.5;
            var _rx = _w * 0.5;
            var _ry = _h * 0.5;
            if (_rx > 0 && _ry > 0) {
                var _dx = (_x - _cx) / _rx;
                var _dy = (_y - _cy) / _ry;
                if (_dx * _dx + _dy * _dy <= 1.0) {
                    _on = true;
                    break;
                }
            }
        }
    }
    return _on;
}

function fh_find_free_spawn_pos(_x, _y, _radius = 24) {
    _x = clamp(_x, 60, room_width - 60);
    _y = clamp(_y, 60, room_height - 60);

    if (fh_place_free_of_walls(_x, _y, _radius)) {
        return { x: _x, y: _y };
    }

    // Procura posição livre mais próxima em círculos concêntricos (32px a 192px)
    var _distances = [32, 48, 64, 80, 96, 128, 160, 192];
    var _angles = [0, 45, 90, 135, 180, 225, 270, 315];

    for (var _d = 0; _d < array_length(_distances); _d++) {
        var _dist = _distances[_d];
        for (var _a = 0; _a < array_length(_angles); _a++) {
            var _ang = _angles[_a];
            var _test_x = clamp(_x + lengthdir_x(_dist, _ang), 60, room_width - 60);
            var _test_y = clamp(_y + lengthdir_y(_dist, _ang), 60, room_height - 60);
            if (fh_place_free_of_walls(_test_x, _test_y, _radius)) {
                return { x: _test_x, y: _test_y };
            }
        }
    }

    // Se nenhuma posição for encontrada, posiciona com segurança no centro da sala
    return { x: room_width / 2, y: room_height / 2 };
}

// =========================================================================
// SISTEMA DE CONTROLES MULTI-TOUCH MOBILE (ANDROID / IOS / SIMULAÇÃO PC)
// =========================================================================

function touch_controls_is_enabled() {
    if (os_type == os_android || os_type == os_ios) return true;
    if (variable_global_exists("dev_touch_mode") && global.dev_touch_mode) return true;
    return false;
}

function touch_controls_init() {
    if (!variable_global_exists("dev_touch_mode")) {
        global.dev_touch_mode = (os_type == os_android || os_type == os_ios);
    }
    
    global.touch_input_h = 0;
    global.touch_input_v = 0;
    global.touch_attack_pressed = false;
    global.touch_attack_held = false;
    global.touch_defend_pressed = false;
    global.touch_defend_held = false;
    global.touch_dash_pressed = false;
    global.touch_dash_held = false;
    global.touch_action_pressed = false;
    global.touch_action_held = false;
    global.touch_pause_pressed = false;
    
    global.touch_stick_active = false;
    global.touch_stick_device = -1;
    global.touch_stick_base_x = 150;
    global.touch_stick_base_y = 620;
    global.touch_stick_curr_x = 150;
    global.touch_stick_curr_y = 620;
    global.touch_stick_radius = 65;
    global.touch_stick_thumb_radius = 28;
}

function touch_controls_update() {
    if (!variable_global_exists("touch_stick_active")) {
        touch_controls_init();
    }
    
    // Reseta entradas acionadas neste frame
    global.touch_attack_pressed = false;
    global.touch_defend_pressed = false;
    global.touch_dash_pressed = false;
    global.touch_action_pressed = false;
    global.touch_pause_pressed = false;
    
    // Reseta estados contínuos (serão revalidados se dedos continuarem sobre os botões)
    global.touch_attack_held = false;
    global.touch_defend_held = false;
    global.touch_dash_held = false;
    global.touch_action_held = false;

    if (!touch_controls_is_enabled()) {
        global.touch_input_h = 0;
        global.touch_input_v = 0;
        global.touch_stick_active = false;
        global.touch_stick_device = -1;
        return;
    }

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Posição base padrão do analógico quando inativo
    var _default_stick_x = clamp(150, 80, _gw * 0.3);
    var _default_stick_y = clamp(_gh - 140, 100, _gh - 50);

    // Coordenadas e raios dos botões de ação tátil
    var _btn_atk_x = _gw - 95;
    var _btn_atk_y = _gh - 95;
    var _btn_atk_r = 46;

    var _btn_def_x = _gw - 195;
    var _btn_def_y = _gh - 85;
    var _btn_def_r = 38;

    var _btn_dash_x = _gw - 105;
    var _btn_dash_y = _gh - 195;
    var _btn_dash_r = 36;

    var _btn_act_x = _gw - 195;
    var _btn_act_y = _gh - 185;
    var _btn_act_r = 38;

    var _btn_pause_x = _gw - 44;
    var _btn_pause_y = 44;
    var _btn_pause_r = 24;

    // 1. Atualiza joystick caso já esteja ativo com um dedo
    if (global.touch_stick_active) {
        if (global.touch_stick_device >= 0 && device_mouse_check_button(global.touch_stick_device, mb_left)) {
            var _smx = device_mouse_x_to_gui(global.touch_stick_device);
            var _smy = device_mouse_y_to_gui(global.touch_stick_device);
            var _dist = point_distance(global.touch_stick_base_x, global.touch_stick_base_y, _smx, _smy);
            var _dir = point_direction(global.touch_stick_base_x, global.touch_stick_base_y, _smx, _smy);
            var _clamped_dist = min(_dist, global.touch_stick_radius);
            global.touch_stick_curr_x = global.touch_stick_base_x + lengthdir_x(_clamped_dist, _dir);
            global.touch_stick_curr_y = global.touch_stick_base_y + lengthdir_y(_clamped_dist, _dir);

            var _deadzone = 10;
            if (_dist > _deadzone) {
                var _norm = (_clamped_dist - _deadzone) / (global.touch_stick_radius - _deadzone);
                global.touch_input_h = lengthdir_x(_norm, _dir);
                global.touch_input_v = lengthdir_y(_norm, _dir);
            } else {
                global.touch_input_h = 0;
                global.touch_input_v = 0;
            }
        } else {
            // Dedo levantado: reseta analógico
            global.touch_stick_active = false;
            global.touch_stick_device = -1;
            global.touch_input_h = 0;
            global.touch_input_v = 0;
            global.touch_stick_base_x = _default_stick_x;
            global.touch_stick_base_y = _default_stick_y;
            global.touch_stick_curr_x = _default_stick_x;
            global.touch_stick_curr_y = _default_stick_y;
        }
    } else {
        global.touch_stick_base_x = _default_stick_x;
        global.touch_stick_base_y = _default_stick_y;
        global.touch_stick_curr_x = _default_stick_x;
        global.touch_stick_curr_y = _default_stick_y;
    }

    // 2. Varre todos os dedos multi-touch (dispositivos 0 a 4)
    for (var _dev = 0; _dev < 5; _dev++) {
        var _down = device_mouse_check_button(_dev, mb_left);
        var _pressed = device_mouse_check_button_pressed(_dev, mb_left);
        
        if (!_down && !_pressed) continue;

        var _mx = device_mouse_x_to_gui(_dev);
        var _my = device_mouse_y_to_gui(_dev);

        // Botão de pausa no canto superior direito
        if (point_distance(_mx, _my, _btn_pause_x, _btn_pause_y) <= _btn_pause_r + 8) {
            if (_pressed) global.touch_pause_pressed = true;
            continue;
        }

        // Se o jogo estiver pausado ou janelas modais abertas, bloqueia controles de ação/gameplay
        if (global.paused || global.attr_window_open || global.chest_reward_open || (variable_global_exists("midrun_shop_open") && global.midrun_shop_open)) {
            continue;
        }

        // Se este dedo já está controlando o analógico, ignora detecção de botões para ele
        if (global.touch_stick_active && _dev == global.touch_stick_device) {
            continue;
        }

        // Botão de Ataque
        if (point_distance(_mx, _my, _btn_atk_x, _btn_atk_y) <= _btn_atk_r + 8) {
            if (_pressed) global.touch_attack_pressed = true;
            global.touch_attack_held = true;
            continue;
        }

        // Botão de Habilidade / Defesa
        if (point_distance(_mx, _my, _btn_def_x, _btn_def_y) <= _btn_def_r + 8) {
            if (_pressed) global.touch_defend_pressed = true;
            global.touch_defend_held = true;
            continue;
        }

        // Botão de Esquiva / Dash
        if (point_distance(_mx, _my, _btn_dash_x, _btn_dash_y) <= _btn_dash_r + 8) {
            if (_pressed) global.touch_dash_pressed = true;
            global.touch_dash_held = true;
            continue;
        }

        // Botão de Ação / Interagir / Confirmar
        if (point_distance(_mx, _my, _btn_act_x, _btn_act_y) <= _btn_act_r + 8) {
            if (_pressed) global.touch_action_pressed = true;
            global.touch_action_held = true;
            continue;
        }

        // Toque no lado esquerdo da tela ativa o analógico flutuante
        if (!global.touch_stick_active && _mx < _gw * 0.45 && _my > _gh * 0.25) {
            global.touch_stick_active = true;
            global.touch_stick_device = _dev;
            global.touch_stick_base_x = _mx;
            global.touch_stick_base_y = _my;
            global.touch_stick_curr_x = _mx;
            global.touch_stick_curr_y = _my;
            global.touch_input_h = 0;
            global.touch_input_v = 0;
        }
    }
}

function touch_controls_draw_gui() {
    if (!touch_controls_is_enabled()) return;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    // Top Right: Botão de Pausa / Ficha
    var _btn_pause_x = _gw - 44;
    var _btn_pause_y = 44;
    var _btn_pause_r = 24;

    draw_set_alpha(0.65);
    draw_set_color(make_colour_rgb(16, 22, 34));
    draw_circle(_btn_pause_x, _btn_pause_y, _btn_pause_r, false);
    draw_set_alpha(1.0);
    draw_set_color(make_colour_rgb(215, 175, 60));
    draw_circle(_btn_pause_x, _btn_pause_y, _btn_pause_r, true);

    // Ícone de pausa (duas barras verticais)
    draw_set_color(c_white);
    draw_rectangle(_btn_pause_x - 7, _btn_pause_y - 8, _btn_pause_x - 3, _btn_pause_y + 8, false);
    draw_rectangle(_btn_pause_x + 3, _btn_pause_y - 8, _btn_pause_x + 7, _btn_pause_y + 8, false);

    // Indicador dev no PC (apenas no modo dev para não poluir tela de jogadores)
    if (os_type != os_android && os_type != os_ios && variable_global_exists("dev_mode") && global.dev_mode) {
        draw_set_font(ui_font());
        draw_set_halign(fa_right);
        draw_set_valign(fa_top);
        draw_set_color(c_aqua);
        draw_text(_gw - 80, 20, "[F4] Touch: ON");
        draw_set_halign(fa_left);
    }

    // Controles de gameplay ocultos se janelas estiverem abertas
    var _hide_gameplay_touch = (global.paused || global.attr_window_open || global.chest_reward_open || (variable_global_exists("midrun_shop_open") && global.midrun_shop_open));
    if (_hide_gameplay_touch) return;

    // 1. Analógico Virtual
    var _bx = global.touch_stick_base_x;
    var _by = global.touch_stick_base_y;
    var _cx = global.touch_stick_curr_x;
    var _cy = global.touch_stick_curr_y;
    var _br = global.touch_stick_radius;
    var _tr = global.touch_stick_thumb_radius;

    // Base do Analógico
    draw_set_alpha(global.touch_stick_active ? 0.35 : 0.20);
    draw_set_color(make_colour_rgb(20, 28, 44));
    draw_circle(_bx, _by, _br, false);
    draw_set_alpha(global.touch_stick_active ? 0.70 : 0.40);
    draw_set_color(make_colour_rgb(70, 150, 220));
    draw_circle(_bx, _by, _br, true);
    draw_circle(_bx, _by, _br - 8, true);

    // Linhas guias cardinais sutis
    draw_set_alpha(0.25);
    draw_line(_bx - _br + 12, _by, _bx + _br - 12, _by);
    draw_line(_bx, _by - _br + 12, _bx, _by + _br - 12);

    // Thumb stick
    draw_set_alpha(global.touch_stick_active ? 0.75 : 0.45);
    draw_set_color(global.touch_stick_active ? make_colour_rgb(50, 170, 240) : make_colour_rgb(40, 70, 110));
    draw_circle(_cx, _cy, _tr, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_circle(_cx, _cy, _tr, true);
    draw_circle(_cx, _cy, 5, false);

    // 2. Botões de Ação
    var _btn_atk_x = _gw - 95;
    var _btn_atk_y = _gh - 95;
    var _btn_atk_r = 46;

    var _btn_def_x = _gw - 195;
    var _btn_def_y = _gh - 85;
    var _btn_def_r = 38;

    var _btn_dash_x = _gw - 105;
    var _btn_dash_y = _gh - 195;
    var _btn_dash_r = 36;

    var _btn_act_x = _gw - 195;
    var _btn_act_y = _gh - 185;
    var _btn_act_r = 38;

    // Botão de Ataque
    var _atk_held = global.touch_attack_held;
    draw_set_alpha(_atk_held ? 0.85 : 0.50);
    draw_set_color(_atk_held ? make_colour_rgb(220, 60, 50) : make_colour_rgb(140, 30, 25));
    draw_circle(_btn_atk_x, _btn_atk_y, _atk_held ? _btn_atk_r - 2 : _btn_atk_r, false);
    draw_set_alpha(1.0);
    draw_set_color(make_colour_rgb(255, 200, 70));
    draw_circle(_btn_atk_x, _btn_atk_y, _atk_held ? _btn_atk_r - 2 : _btn_atk_r, true);
    draw_circle(_btn_atk_x, _btn_atk_y, _atk_held ? _btn_atk_r - 5 : _btn_atk_r - 3, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_talent_icon("sword", _btn_atk_x, _btn_atk_y - 6, 26, c_white);
    draw_set_color(c_white);
    draw_text_transformed(_btn_atk_x, _btn_atk_y + 14, "ATK", 1.05, 1.05, 0);

    // Botão de Habilidade / Defesa
    var _def_held = global.touch_defend_held;
    var _player = instance_find(obj_player, 0);
    var _on_cd = (_player != noone && _player.defend_cooldown_timer > 0);

    draw_set_alpha(_def_held ? 0.85 : 0.50);
    draw_set_color(_on_cd ? make_colour_rgb(30, 35, 45) : (_def_held ? make_colour_rgb(40, 140, 230) : make_colour_rgb(25, 70, 140)));
    draw_circle(_btn_def_x, _btn_def_y, _def_held ? _btn_def_r - 2 : _btn_def_r, false);
    draw_set_alpha(1.0);
    draw_set_color(_on_cd ? make_colour_rgb(80, 95, 115) : make_colour_rgb(80, 200, 255));
    draw_circle(_btn_def_x, _btn_def_y, _def_held ? _btn_def_r - 2 : _btn_def_r, true);

    draw_talent_icon("shield", _btn_def_x, _btn_def_y - 6, 22, _on_cd ? c_gray : c_white);
    draw_set_color(_on_cd ? c_gray : c_white);
    if (_on_cd) {
        var _sec_left = string(round(_player.defend_cooldown_timer * 10) / 10);
        draw_text_transformed(_btn_def_x, _btn_def_y + 12, _sec_left + "s", 0.95, 0.95, 0);
    } else {
        draw_text_transformed(_btn_def_x, _btn_def_y + 12, "HAB", 0.95, 0.95, 0);
    }

    // Botão de Esquiva / Dash
    var _dash_held = global.touch_dash_held;
    draw_set_alpha(_dash_held ? 0.85 : 0.50);
    draw_set_color(_dash_held ? make_colour_rgb(40, 190, 100) : make_colour_rgb(20, 110, 55));
    draw_circle(_btn_dash_x, _btn_dash_y, _dash_held ? _btn_dash_r - 2 : _btn_dash_r, false);
    draw_set_alpha(1.0);
    draw_set_color(make_colour_rgb(100, 255, 160));
    draw_circle(_btn_dash_x, _btn_dash_y, _dash_held ? _btn_dash_r - 2 : _btn_dash_r, true);

    draw_talent_icon("haste", _btn_dash_x, _btn_dash_y - 6, 22, c_white);
    draw_set_color(c_white);
    draw_text_transformed(_btn_dash_x, _btn_dash_y + 12, "DASH", 0.95, 0.95, 0);

    // Botão de Ação / Interagir / Confirmar
    var _act_held = global.touch_action_held;
    var _near_interact = false;
    if (_player != noone) {
        if (instance_exists(obj_village_elder) && point_distance(_player.x, _player.y, obj_village_elder.x, obj_village_elder.y) <= 140) _near_interact = true;
        if (instance_exists(obj_village_portal) && point_distance(_player.x, _player.y, obj_village_portal.x, obj_village_portal.y) <= 160) _near_interact = true;
        if (instance_exists(obj_midrun_shop) && point_distance(_player.x, _player.y, obj_midrun_shop.x, obj_midrun_shop.y) <= 140) _near_interact = true;
        if (instance_exists(obj_pedestal_element) && point_distance(_player.x, _player.y, instance_nearest(_player.x, _player.y, obj_pedestal_element).x, instance_nearest(_player.x, _player.y, obj_pedestal_element).y) <= 120) _near_interact = true;
    }

    var _act_pulse = _near_interact ? (0.22 + 0.15 * sin(current_time * 0.01)) : 0;
    draw_set_alpha((_act_held ? 0.90 : 0.50) + _act_pulse);
    draw_set_color(_act_held ? make_colour_rgb(230, 160, 40) : (_near_interact ? make_colour_rgb(180, 120, 25) : make_colour_rgb(50, 45, 65)));
    draw_circle(_btn_act_x, _btn_act_y, _act_held ? _btn_act_r - 2 : _btn_act_r, false);
    
    draw_set_alpha(1.0);
    draw_set_color(_near_interact ? make_colour_rgb(255, 230, 100) : make_colour_rgb(200, 180, 120));
    draw_circle(_btn_act_x, _btn_act_y, _act_held ? _btn_act_r - 2 : _btn_act_r, true);
    if (_near_interact) {
        draw_circle(_btn_act_x, _btn_act_y, _btn_act_r + 4 + sin(current_time * 0.01) * 3, true);
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_near_interact ? c_yellow : c_white);
    draw_text_transformed(_btn_act_x, _btn_act_y - 6, "A", 1.4, 1.4, 0);
    draw_set_color(c_white);
    draw_text_transformed(_btn_act_x, _btn_act_y + 12, loc("action_btn", "AÇÃO"), 0.85, 0.85, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
}

// Auxiliares de detecção de toque em retângulos (GUI e Sala)
function touch_gui_clicked(_x1, _y1, _x2, _y2) {
    for (var _i = 0; _i < 5; _i++) {
        if (device_mouse_check_button_pressed(_i, mb_left)) {
            var _mx = device_mouse_x_to_gui(_i);
            var _my = device_mouse_y_to_gui(_i);
            if (_mx >= _x1 && _mx <= _x2 && _my >= _y1 && _my <= _y2) {
                return true;
            }
        }
    }
    return false;
}

function touch_room_clicked(_x1, _y1, _x2, _y2) {
    for (var _i = 0; _i < 5; _i++) {
        if (device_mouse_check_button_pressed(_i, mb_left)) {
            var _mx = device_mouse_x(_i);
            var _my = device_mouse_y(_i);
            if (_mx >= _x1 && _mx <= _x2 && _my >= _y1 && _my <= _y2) {
                return true;
            }
        }
    }
    return false;
}

