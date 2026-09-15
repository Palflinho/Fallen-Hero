// =========================================================================
// SISTEMA CENTRAL DE INPUT UNIFICADO (CONTROLE, TECLADO E MOBILE)
// =========================================================================

// Variaveis globais de inicializacao
if (!variable_global_exists("input_active_gamepad")) global.input_active_gamepad = -1;
if (!variable_global_exists("input_last_used")) {
    global.input_last_used = (input_get_active_pad() != -1) ? "gamepad" : "keyboard";
}
if (!variable_global_exists("input_rumble_timer")) global.input_rumble_timer = 0;

/// @function input_get_active_pad()
/// @desc Retorna o indice do controle conectado ativo (0..11) ou -1 se nenhum encontrado
function input_get_active_pad() {
    if (global.input_active_gamepad != -1 && gamepad_is_connected(global.input_active_gamepad)) {
        return global.input_active_gamepad;
    }
    
    // Procura o primeiro controle plugado
    for (var _p = 0; _p < 12; _p++) {
        if (gamepad_is_connected(_p)) {
            global.input_active_gamepad = _p;
            gamepad_set_axis_deadzone(_p, 0.22);
            return _p;
        }
    }
    
    global.input_active_gamepad = -1;
    return -1;
}

/// @function input_has_gamepad_connected()
/// @desc Retorna true se houver algum controle fisico conectado
function input_has_gamepad_connected() {
    return (input_get_active_pad() != -1);
}

/// @function input_is_gamepad_active()
/// @desc Retorna true se um controle estiver conectado e tiver sido o ultimo dispositivo usado
function input_is_gamepad_active() {
    var _pad = input_get_active_pad();
    return (_pad != -1 && global.input_last_used == "gamepad");
}

/// @function input_get_device_type()
/// @desc Retorna "keyboard", "xbox" ou "ps" dependendo do dispositivo ativo
function input_get_device_type() {
    var _pad = input_get_active_pad();
    if (_pad == -1) return "keyboard";
    if (global.input_last_used == "keyboard") return "keyboard";
    
    var _desc = string_lower(gamepad_get_description(_pad));
    if (string_pos("sony", _desc) > 0 || string_pos("playstation", _desc) > 0 
        || string_pos("dualshock", _desc) > 0 || string_pos("dualsense", _desc) > 0 
        || string_pos("ps4", _desc) > 0 || string_pos("ps5", _desc) > 0 
        || string_pos("wireless controller", _desc) > 0) {
        return "ps";
    }
    return "xbox";
}

/// @function input_update_device()
/// @desc Atualiza automaticamente se o dispositivo ativo e teclado ou controle
function input_update_device() {
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        var _buttons = [
            gp_face1, gp_face2, gp_face3, gp_face4,
            gp_shoulderl, gp_shoulderr, gp_shoulderlb, gp_shoulderrb,
            gp_select, gp_start, gp_stickl, gp_stickr,
            gp_padu, gp_padd, gp_padl, gp_padr
        ];
        for (var _b = 0; _b < array_length(_buttons); _b++) {
            if (gamepad_button_check(_pad, _buttons[_b])) {
                global.input_last_used = "gamepad";
                return;
            }
        }
        if (abs(gamepad_axis_value(_pad, gp_axislh)) > 0.25 || abs(gamepad_axis_value(_pad, gp_axislv)) > 0.25) {
            global.input_last_used = "gamepad";
            return;
        }
    }
    
    if (keyboard_check(vk_anykey) || mouse_check_button(mb_left) || mouse_check_button(mb_right)) {
        global.input_last_used = "keyboard";
    }
}

/// @function input_get_btn_label(action)
/// @desc Retorna o texto formatado do botao para o dispositivo ativo
function input_get_btn_label(_action) {
    var _type = input_get_device_type();
    
    if (_action == "attack") {
        if (_type == "ps") return "[X]";
        if (_type == "xbox") return "[A]";
        return "[Z]";
    }
    if (_action == "defend") {
        if (_type == "ps") return "[Quadrado]";
        if (_type == "xbox") return "[X]";
        return "[X]";
    }
    if (_action == "confirm" || _action == "interact" || _action == "accept") {
        if (_type == "ps") return "[X]";
        if (_type == "xbox") return "[A]";
        return "[Z]";
    }
    if (_action == "cancel" || _action == "back" || _action == "refuse") {
        if (_type == "ps") return "[O]";
        if (_type == "xbox") return "[B]";
        return "[X]";
    }
    if (_action == "save") {
        if (_type == "ps") return "[Triangulo]";
        if (_type == "xbox") return "[Y]";
        return "[G]";
    }
    if (_action == "shop") {
        if (_type == "ps") return "[Quadrado]";
        if (_type == "xbox") return "[X]";
        return "[S]";
    }
    if (_action == "aux" || _action == "talent") {
        if (_type == "ps") return "[Triangulo]";
        if (_type == "xbox") return "[Y]";
        return "[G]";
    }
    if (_action == "pause") {
        if (_type == "ps") return "[Options]";
        if (_type == "xbox") return "[Start]";
        return "[ESC]";
    }
    if (_action == "menu_nav") {
        if (_type == "ps" || _type == "xbox") return "D-Pad";
        return "Setas";
    }
    if (_action == "move") {
        if (_type == "ps" || _type == "xbox") return "Analogico";
        return "Setas / WASD";
    }
    if (_action == "shoulder_left" || _action == "shoulder_l" || _action == "prev_tab") {
        if (_type == "ps") return "L1";
        if (_type == "xbox") return "LB";
        return "Q";
    }
    if (_action == "shoulder_right" || _action == "shoulder_r" || _action == "next_tab") {
        if (_type == "ps") return "R1";
        if (_type == "xbox") return "RB";
        return "E";
    }
    
    return "";
}

// =========================================================================
// MOVIMENTO DO JOGADOR: ANALOGICO APENAS NO CONTROLE (SEM D-PAD)
// =========================================================================

/// @function input_get_h()
/// @desc Retorna o eixo horizontal (-1.0 a +1.0) para movimento do heroi
function input_get_h() {
    var _key_l = keyboard_check(vk_left)  || keyboard_check(ord("A"));
    var _key_r = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var _key_h = _key_r - _key_l;
    
    var _pad = input_get_active_pad();
    var _pad_h = 0;
    if (_pad != -1) {
        // Apenas o analogico esquerdo move o personagem
        var _axis_h = gamepad_axis_value(_pad, gp_axislh);
        if (abs(_axis_h) > 0.05) {
            _pad_h = _axis_h;
            global.input_last_used = "gamepad";
        }
    }
    
    if (_key_h != 0) {
        global.input_last_used = "keyboard";
    }
    
    var _touch_h = (variable_global_exists("touch_input_h")) ? global.touch_input_h : 0;
    if (_touch_h != 0) return _touch_h;
    
    if (abs(_pad_h) > 0.05) return _pad_h;
    return _key_h;
}

/// @function input_get_v()
/// @desc Retorna o eixo vertical (-1.0 a +1.0) para movimento do heroi
function input_get_v() {
    var _key_u = keyboard_check(vk_up)   || keyboard_check(ord("W"));
    var _key_d = keyboard_check(vk_down) || keyboard_check(ord("S"));
    var _key_v = _key_d - _key_u;
    
    var _pad = input_get_active_pad();
    var _pad_v = 0;
    if (_pad != -1) {
        // Apenas o analogico esquerdo move o personagem
        var _axis_v = gamepad_axis_value(_pad, gp_axislv);
        if (abs(_axis_v) > 0.05) {
            _pad_v = _axis_v;
            global.input_last_used = "gamepad";
        }
    }
    
    if (_key_v != 0) {
        global.input_last_used = "keyboard";
    }
    
    var _touch_v = (variable_global_exists("touch_input_v")) ? global.touch_input_v : 0;
    if (_touch_v != 0) return _touch_v;
    
    if (abs(_pad_v) > 0.05) return _pad_v;
    return _key_v;
}

// =========================================================================
// COMBATE FIXO:
//   A / Cruz (gp_face1) = Ataca e Aceita
//   X / Quadrado (gp_face3) = Defende
//   B / Circulo (gp_face2) = Recusa / Cancela
//   Y / Triangulo (gp_face4) = Auxiliar / Talentos
//   Start / Menu (gp_start) = Pausa
// =========================================================================

/// @function input_check_attack_pressed()
/// @desc A / Cruz ataca
function input_check_attack_pressed() {
    var _kb = keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("J"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_face1)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    
    var _touch = (variable_global_exists("touch_attack_pressed") && global.touch_attack_pressed);
    return _touch;
}

/// @function input_check_defend_pressed()
/// @desc X / Quadrado defende
function input_check_defend_pressed() {
    var _kb = keyboard_check_pressed(ord("X")) || keyboard_check_pressed(ord("K")) || keyboard_check_pressed(vk_space);
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_face3)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    
    var _touch = (variable_global_exists("touch_defend_pressed") && global.touch_defend_pressed) 
              || (variable_global_exists("touch_dash_pressed") && global.touch_dash_pressed);
    return _touch;
}

/// @function input_check_pause_pressed()
/// @desc Start / Menu pausa
function input_check_pause_pressed() {
    var _kb = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("T"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_start)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

/// @function input_check_ui_confirm()
/// @desc A / Cruz confirma / interage
function input_check_ui_confirm() {
    var _kb = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_face1)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

/// @function input_check_ui_cancel()
/// @desc B / Circulo cancela / volta / recusa
function input_check_ui_cancel() {
    var _kb = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_face2)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

/// @function input_check_ui_aux_pressed()
/// @desc Y / Triangulo como auxiliar para talentos / acoes secundarias
function input_check_ui_aux_pressed() {
    var _kb = keyboard_check_pressed(ord("Y")) || keyboard_check_pressed(ord("M"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_face4)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

// =========================================================================
// NAVEGACAO DE MENUS: DIRECIONAL (D-PAD) APENAS NO CONTROLE (SEM ANALOGICO)
// =========================================================================

/// @function input_check_ui_up_pressed()
/// @desc D-Pad Cima apenas no controle
function input_check_ui_up_pressed() {
    var _kb = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_padu)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

/// @function input_check_ui_down_pressed()
/// @desc D-Pad Baixo apenas no controle
function input_check_ui_down_pressed() {
    var _kb = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_padd)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

/// @function input_check_ui_left_pressed()
/// @desc D-Pad Esquerda apenas no controle
function input_check_ui_left_pressed() {
    var _kb = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_padl)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

/// @function input_check_ui_right_pressed()
/// @desc D-Pad Direita apenas no controle
function input_check_ui_right_pressed() {
    var _kb = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
    if (_kb) {
        global.input_last_used = "keyboard";
        return true;
    }
    
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        if (gamepad_button_check_pressed(_pad, gp_padr)) {
            global.input_last_used = "gamepad";
            return true;
        }
    }
    return false;
}

/// @function input_check_slot_number_pressed(slot_index)
/// @desc Atalhos numericos do teclado (1, 2, 3)
function input_check_slot_number_pressed(_slot_index) {
    var _key_code = ord(string(_slot_index + 1));
    if (keyboard_check_pressed(_key_code)) {
        global.input_last_used = "keyboard";
        return true;
    }
    return false;
}

/// @function input_check_slot_pressed(slot_index)
/// @desc Atalho para selecionar/ativar slot especifico
function input_check_slot_pressed(_slot_index) {
    return input_check_slot_number_pressed(_slot_index);
}

/// @function input_check_slot_discard_pressed()
/// @desc Descartar recompensa de bau (B / Bolinha no controle, ESC ou X no teclado)
function input_check_slot_discard_pressed() {
    return input_check_ui_cancel();
}

// =========================================================================
// SISTEMA DE VIBRACAO COM PARADA SEGURA E ZERO RESIDUOS
// =========================================================================

/// @function input_rumble(left_motor, right_motor, duration)
/// @desc Aciona vibracao haptica no controle conectado
function input_rumble(_left_motor, _right_motor, _duration) {
    var _pad = input_get_active_pad();
    if (_pad != -1) {
        gamepad_set_vibration(_pad, clamp(_left_motor, 0, 1), clamp(_right_motor, 0, 1));
        global.input_rumble_timer = max(global.input_rumble_timer, _duration);
    }
}

/// @function input_rumble_stop()
/// @desc Desliga forcadamente todos os motores de todos os controles imediatamente
function input_rumble_stop() {
    global.input_rumble_timer = 0;
    for (var _p = 0; _p < 12; _p++) {
        if (gamepad_is_connected(_p)) {
            gamepad_set_vibration(_p, 0, 0);
        }
    }
}

/// @function input_rumble_update(delta_time_sec)
/// @desc Atualiza o temporizador de vibracao e desliga os motores quando expirar
function input_rumble_update(_dt) {
    if (global.input_rumble_timer > 0) {
        global.input_rumble_timer -= _dt;
        if (global.input_rumble_timer <= 0) {
            input_rumble_stop();
        }
    }
}
