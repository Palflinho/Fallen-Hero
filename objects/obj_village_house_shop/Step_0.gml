var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

if (notice_timer > 0) notice_timer--;
if (interact_cooldown > 0) interact_cooldown -= delta_time / 1000000;

// -------------------------------------------------------------------------
// 1. Interação no Mundo (Aproximação do Empório)
// -------------------------------------------------------------------------
if (!modal_open) {
    if (is_world_paused()) exit;

    var _door_x = x;
    var _door_y = y + 42;
    var _dist = point_distance(_door_x, _door_y, _player.x, _player.y);

    if (_dist <= interact_radius && interact_cooldown <= 0) {
        var _interact = input_check_ui_confirm() || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_space);
        var _touch = touch_room_clicked(x - 36, y + 10, x + 36, y + 70);
        
        if (_interact || _touch) {
            open_shop_modal();
        }
    }
    exit;
}

// -------------------------------------------------------------------------
// 2. Navegação no Modal da Loja Permanente
// -------------------------------------------------------------------------
var _cn = array_length(classes);
var _pad = input_get_active_pad();

// Alternar abas de classes (Q / E ou Bumpers)
var _prev_tab = keyboard_check_pressed(ord("Q")) || (_pad != -1 && (gamepad_button_check_pressed(_pad, gp_shoulderl) || gamepad_button_check_pressed(_pad, gp_shoulderlb)));
var _next_tab = keyboard_check_pressed(ord("E")) || (_pad != -1 && (gamepad_button_check_pressed(_pad, gp_shoulderr) || gamepad_button_check_pressed(_pad, gp_shoulderrb)));

if (_prev_tab) {
    shop_tab_index = (shop_tab_index - 1 + _cn) mod _cn;
    shop_talent_index = 0;
    shop_grid_scroll_row = 0;
    sfx_play("menu_move");
}
if (_next_tab) {
    shop_tab_index = (shop_tab_index + 1) mod _cn;
    shop_talent_index = 0;
    shop_grid_scroll_row = 0;
    sfx_play("menu_move");
}

var _tab_talents = get_talents_for_character(classes[shop_tab_index]);
var _tn = array_length(_tab_talents);

if (_tn > 0) {
    var _cols = min(shop_grid_cols, _tn);
    if (_cols <= 0) _cols = 1;
    var _total_rows = ceil(_tn / _cols);

    // Navegação na Grade
    if (input_check_ui_right_pressed()) {
        shop_talent_index = (shop_talent_index + 1) mod _tn;
        sfx_play("menu_move");
    }
    if (input_check_ui_left_pressed()) {
        shop_talent_index = (shop_talent_index - 1 + _tn) mod _tn;
        sfx_play("menu_move");
    }
    if (input_check_ui_down_pressed()) {
        if (shop_talent_index + _cols < _tn) {
            shop_talent_index += _cols;
        } else {
            shop_talent_index = shop_talent_index mod _cols;
        }
        sfx_play("menu_move");
    }
    if (input_check_ui_up_pressed()) {
        if (shop_talent_index - _cols >= 0) {
            shop_talent_index -= _cols;
        } else {
            var _target = (_total_rows - 1) * _cols + (shop_talent_index mod _cols);
            if (_target >= _tn) _target = _tn - 1;
            shop_talent_index = _target;
        }
        sfx_play("menu_move");
    }

    // Scroll Automático do Cursor
    var _cur_row = shop_talent_index div _cols;
    if (_cur_row < shop_grid_scroll_row) {
        shop_grid_scroll_row = _cur_row;
    } else if (_cur_row >= shop_grid_scroll_row + shop_grid_visible_rows) {
        shop_grid_scroll_row = _cur_row - shop_grid_visible_rows + 1;
    }

    // Scroll com Roda do Mouse
    if (mouse_wheel_up() && shop_grid_scroll_row > 0) {
        shop_grid_scroll_row -= 1;
    }
    if (mouse_wheel_down() && (shop_grid_scroll_row + shop_grid_visible_rows < _total_rows)) {
        shop_grid_scroll_row += 1;
    }

    // Confirmar Compra de Talento (Z / Enter / Botão A / Clique)
    var _confirm_buy = input_check_ui_confirm() || keyboard_check_pressed(vk_enter);
    if (_confirm_buy) {
        var _cur_t = _tab_talents[shop_talent_index];
        if (talent_is_unlocked(_cur_t.id)) {
            notice_text = tr("Talento ja desbloqueado!");
            notice_timer = 50;
            sfx_play("stagger", 0.05, 0.4);
        } else if (talent_get_affinity(_cur_t) != "none" && !element_is_unlocked(talent_get_affinity(_cur_t), classes[shop_tab_index])) {
            notice_text = tr("Afinidade bloqueada! Conquiste o templo elemental correspondente.");
            notice_timer = 70;
            sfx_play("stagger", 0.05, 0.6);
        } else if (global.gold < _cur_t.cost) {
            notice_text = tr("Ouro insuficiente! Complete mais salas de masmorra.");
            notice_timer = 60;
            sfx_play("stagger", 0.05, 0.6);
        } else {
            talent_purchase(_cur_t.id);
            notice_text = tr("Talento '") + _cur_t.label + tr("' desbloqueado!");
            notice_timer = 60;
            sfx_play("gold", 0.05, 1.2);
            save_meta();
        }
    }
}

// Fechar / Cancelar (X / Esc / Botão B)
if (input_check_ui_cancel() || keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X"))) {
    close_shop_modal();
}
