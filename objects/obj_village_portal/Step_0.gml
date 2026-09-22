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
        sfx_play("portal_hum", 0.05, 0.35);
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
// 2. Navegação no Modal de Preparação da Expedição
// -------------------------------------------------------------------------
var _n_classes = array_length(classes);
var _n_elements = array_length(elements);

// Alternar Classe (Esquerda / Direita)
if (input_check_ui_left_pressed() || keyboard_check_pressed(ord("A"))) {
    selected_class_idx = (selected_class_idx - 1 + _n_classes) mod _n_classes;
    sfx_play("menu_move");
}
if (input_check_ui_right_pressed() || keyboard_check_pressed(ord("D"))) {
    selected_class_idx = (selected_class_idx + 1) mod _n_classes;
    sfx_play("menu_move");
}

// Alternar Afinidade Elemental (Q / E ou Bumpers ou Cima / Baixo)
var _pad = input_get_active_pad();
var _prev_elem = keyboard_check_pressed(ord("Q")) || input_check_ui_up_pressed() || keyboard_check_pressed(ord("W")) || (_pad != -1 && (gamepad_button_check_pressed(_pad, gp_shoulderl) || gamepad_button_check_pressed(_pad, gp_shoulderlb)));
var _next_elem = keyboard_check_pressed(ord("E")) || input_check_ui_down_pressed() || keyboard_check_pressed(ord("S")) || (_pad != -1 && (gamepad_button_check_pressed(_pad, gp_shoulderr) || gamepad_button_check_pressed(_pad, gp_shoulderrb)));

if (_prev_elem) {
    selected_element_idx = (selected_element_idx - 1 + _n_elements) mod _n_elements;
    sfx_play("menu_move");
}
if (_next_elem) {
    selected_element_idx = (selected_element_idx + 1) mod _n_elements;
    sfx_play("menu_move");
}

// Confirmar e Iniciar Expedição (Z / Enter / Botão A)
var _confirm_btn = input_check_ui_confirm() || keyboard_check_pressed(vk_enter);
if (_confirm_btn) {
    start_expedition();
}

// Fechar / Cancelar (X / Esc / Botão B)
if (input_check_ui_cancel() || keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X"))) {
    close_portal_modal();
}
