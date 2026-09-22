var _player = instance_find(obj_player, 0);
if (_player == noone) exit;

if (notice_timer > 0) notice_timer--;
if (interact_cooldown > 0) interact_cooldown -= delta_time / 1000000;

// -------------------------------------------------------------------------
// 1. Interação do Jogador no Mundo (Aproximação da Porta)
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
            open_heroes_modal();
        }
    }
    exit;
}

// -------------------------------------------------------------------------
// 2. Navegação no Modal de Heróis
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

// Confirmar Mudança de Classe (Z / Enter / Botão A)
var _confirm_btn = input_check_ui_confirm() || keyboard_check_pressed(vk_enter);
if (_confirm_btn) {
    var _chosen_class = classes[selected_class_idx];
    var _chosen_elem = elements[selected_element_idx];

    if (!element_is_unlocked(_chosen_elem, _chosen_class)) {
        notice_text = "Afinidade bloqueada! Conquiste-a na masmorra correspondente.";
        notice_timer = 75;
        sfx_play("stagger", 0.05, 0.7);
    } else {
        var _applied_talents = variable_global_exists("chosen_talent_ids") ? global.chosen_talent_ids : ["", "", ""];
        player_change_class(_player, _chosen_class, _chosen_elem, _applied_talents);
        close_heroes_modal();
    }
}

// Fechar / Cancelar (X / Esc / Botão B)
if (input_check_ui_cancel() || keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("X"))) {
    close_heroes_modal();
}
