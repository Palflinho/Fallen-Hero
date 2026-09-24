var _dt = delta_time / 1000000;
vortex_timer += _dt;
hum_sound_timer -= _dt;

if (notice_timer > 0) notice_timer--;
if (interact_cooldown > 0) interact_cooldown -= _dt;

var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

// -------------------------------------------------------------------------
// 1. Interação do Jogador no Mundo da Vila
// -------------------------------------------------------------------------
if (!modal_open) {
    if (is_world_paused()) exit;

    var _dist = point_distance(x, y, _player.x, _player.y);

    if (_dist <= 160 && hum_sound_timer <= 0) {
        hum_sound_timer = 3.2;
        sfx_play_at("portal_hum", x, y, 300, 0.05, 0.6);
    }

    if (_dist <= (portal_radius + _player.body_radius) && interact_cooldown <= 0) {
        var _interact = input_check_ui_confirm() || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space);
        var _touch = touch_room_clicked(x - 36, y - 36, x + 36, y + 36);

        if (_interact || _touch) {
            open_portal_modal();
        }
    }
    exit;
}

// -------------------------------------------------------------------------
// 2. Navegação no Modal de Seleção de Talentos da Run
// -------------------------------------------------------------------------
var _n_talents = array_length(talent_select_list);
var _pad = input_get_active_pad();

// Navegação na Grade de Talentos (3 colunas)
if (_n_talents > 0) {
    if (input_check_ui_left_pressed() || keyboard_check_pressed(ord("A"))) {
        talent_cursor = max(0, talent_cursor - 1);
        sfx_play("menu_move");
    }
    if (input_check_ui_right_pressed() || keyboard_check_pressed(ord("D"))) {
        talent_cursor = min(_n_talents - 1, talent_cursor + 1);
        sfx_play("menu_move");
    }
    if (input_check_ui_up_pressed() || keyboard_check_pressed(ord("W"))) {
        if (talent_cursor >= 3) {
            talent_cursor -= 3;
            sfx_play("menu_move");
        }
    }
    if (input_check_ui_down_pressed() || keyboard_check_pressed(ord("S"))) {
        if (talent_cursor + 3 < _n_talents) {
            talent_cursor += 3;
            sfx_play("menu_move");
        }
    }

    // Rolagem da grade conforme o cursor
    var _row = floor(talent_cursor / 3);
    if (_row < scroll_row) scroll_row = _row;
    if (_row >= scroll_row + 3) scroll_row = _row - 2;
}

// Interação por Teclado/Controle: [Espaço] ou [X no controle] para equipar/desequipar
var _equip_btn = keyboard_check_pressed(vk_space) || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face3));
if (_equip_btn && _n_talents > 0 && talent_cursor < _n_talents) {
    var _tid = talent_select_list[talent_cursor].id;
    toggle_equip_talent(_tid);
}

// Interação por Mouse / Touch na Interface
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _m_click = mouse_check_button_pressed(mb_left);

var _panel_w = min(1040, _gw - 60);
var _panel_h = 540;
var _px = round((_gw - _panel_w) * 0.5);
var _py = round((_gh - _panel_h) * 0.5);

// Clique nos Slots Equipados Superiores (Unequip direto)
var _slot_w = 260;
var _slot_h = 56;
var _slots_total_w = 3 * _slot_w + 2 * 20;
var _slots_x0 = _px + (_panel_w - _slots_total_w) * 0.5;
var _slots_y0 = _py + 58;

for (var _s = 0; _s < max_equipped_slots; _s++) {
    var _sbx = _slots_x0 + _s * (_slot_w + 20);
    if (_m_click && _mx >= _sbx && _mx <= _sbx + _slot_w && _my >= _slots_y0 && _my <= _slots_y0 + _slot_h) {
        if (_s < array_length(talent_selected_ids)) {
            toggle_equip_talent(talent_selected_ids[_s]);
        }
    }
}

// Clique nos Cards da Grade
var _cols = 3;
var _card_w = 270;
var _card_h = 50;
var _cgap_x = 16;
var _cgap_y = 10;
var _grid_x0 = _px + (_panel_w - (_cols * _card_w + (_cols - 1) * _cgap_x)) * 0.5;
var _grid_y0 = _py + 142;

var _visible_start = scroll_row * _cols;
var _visible_end = min(_n_talents, _visible_start + 9);

for (var _i = _visible_start; _i < _visible_end; _i++) {
    var _local_idx = _i - _visible_start;
    var _col = _local_idx mod _cols;
    var _r = floor(_local_idx / _cols);
    var _cx = _grid_x0 + _col * (_card_w + _cgap_x);
    var _cy = _grid_y0 + _r * (_card_h + _cgap_y);

    if (_mx >= _cx && _mx <= _cx + _card_w && _my >= _cy && _my <= _cy + _card_h) {
        talent_cursor = _i;
        if (_m_click) {
            toggle_equip_talent(talent_select_list[_i].id);
        }
    }
}

// Clique no Botão "Descer às Catacumbas!"
var _btn_w = 320;
var _btn_h = 44;
var _btn_x = _px + (_panel_w - _btn_w) * 0.5;
var _btn_y = _py + _panel_h - 56;
if (_m_click && _mx >= _btn_x && _mx <= _btn_x + _btn_w && _my >= _btn_y && _my <= _btn_y + _btn_h) {
    start_expedition();
}

// Confirmar e Iniciar Expedição (Z / Enter / Botão A no controle)
var _confirm_btn = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z")) || (_pad != -1 && gamepad_button_check_pressed(_pad, gp_face1));
if (_confirm_btn) {
    start_expedition();
}

// Fechar / Cancelar (X / Esc / Botão B no controle)
if (input_check_ui_cancel() || keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X"))) {
    close_portal_modal();
}
