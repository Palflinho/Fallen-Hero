// =========================================================================
// EMPÓRIO DA FENDA (Loja Permanente de Meta-Progressão) - Fallen Hero
// =========================================================================
// Edificação diegética na Vila Subterrânea onde o jogador gasta seu ouro
// resgatado das expedições para desbloquear talentos permanentemente.
// =========================================================================

interact_radius = 65;
modal_open = false;

classes = ["knight", "mage", "archer", "assassin"];
class_labels = ["Cavaleiro", "Mago", "Arqueiro", "Assassino"];
class_colors = [c_aqua, c_fuchsia, c_lime, make_colour_rgb(180, 180, 200)];

shop_tab_index = 0;
shop_talent_index = 0;
shop_grid_cols = 6;
shop_grid_scroll_row = 0;
shop_grid_visible_rows = 3;

talent_card_w = 145;
talent_card_h = 105;
talent_card_gap_x = 14;
talent_card_gap_y = 12;

interact_cooldown = 0;
notice_timer = 0;
notice_text = "";

function open_shop_modal() {
    modal_open = true;
    global.village_modal_open = true;
    notice_timer = 0;
    notice_text = "";

    with (obj_player) {
        defend_active = false;
        defend_timer = 0;
        attack_buffer_timer = 0;
        state = "idle";
    }
    keyboard_clear(ord("X"));
    keyboard_clear(vk_space);
    keyboard_clear(vk_enter);
    keyboard_clear(ord("Z"));
    io_clear();

    var _p_char = variable_global_exists("selected_character") ? global.selected_character : "knight";
    for (var _k = 0; _k < array_length(classes); _k++) {
        if (classes[_k] == _p_char) { shop_tab_index = _k; break; }
    }

    shop_talent_index = 0;
    shop_grid_scroll_row = 0;
    sfx_play("door_open");
}

function close_shop_modal() {
    modal_open = false;
    global.village_modal_open = false;
    interact_cooldown = 0.4;
    with (obj_player) {
        defend_active = false;
        defend_timer = 0;
        attack_buffer_timer = 0;
        state = "idle";
    }
    keyboard_clear(ord("X"));
    keyboard_clear(vk_space);
    keyboard_clear(vk_enter);
    keyboard_clear(ord("Z"));
    io_clear();
    save_meta();
    sfx_play("menu_select");
}

