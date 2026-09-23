input_rumble_stop();
global.paused = false;
global.attr_window_open = false;
global.chest_reward_open = false;
global.midrun_shop_open = false;
global.run_victory = false;
global.hitstop_timer = 0;
global.run_playtime = 0;
if (!variable_global_exists("dev_mode")) global.dev_mode = false;
if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;

load_save_from_disk();
load_meta_from_disk();

locked_warning_timer = 0;
reset_notice_timer = 0;
save_notice_timer = 0;
save_notice_text = "";

classes = ["knight", "mage", "archer", "assassin"];
labels = ["Cavaleiro", "Mago", "Arqueiro", "Assassino"];
colours = [c_aqua, c_fuchsia, c_lime, c_gray];
selected_index = 0;

box_w = 180;
box_h = 220;
box_gap = 40;

if (variable_global_exists("char_select_direct") && global.char_select_direct) {
    state = "select";
    global.char_select_direct = false;
} else {
    state = "main_menu"; // main_menu | save_slots | select | shop | select_talents
}

main_menu_options = ["Novo Jogo", "Continuar", "Sair"];
main_menu_cursor = any_save_slot_exists() ? 1 : 0;
main_menu_btn_w = 340;
main_menu_btn_h = 54;
main_menu_btn_gap = 18;

// Parâmetros da tela dedicada de Save Slots (Segunda Tela)
save_slot_action = "new_game"; // "new_game" | "continue"
save_slot_cursor = 0; // 0, 1, 2 correspondentes a Slot 1, 2, 3
save_slot_delete_confirm = -1;
save_card_w = 260;
save_card_h = 340;
save_card_gap = 36;

shop_tab_index = 0;
shop_talent_index = 0;

talent_select_list = [];
talent_select_cursor = 0;
talent_selected_ids = [];

elements = ["none", "water", "fire", "wind", "earth"];
element_labels = ["Neutro (Cavaleiro)", "Agua (Lanceiro)", "Fogo (Cavaleiro Runico)", "Ar (Duelista)", "Terra (Guardiao)"];
selected_element_index = 0;

// Configurações visuais da grade de talentos
talent_card_w = 152;
talent_card_h = 104;
talent_card_gap_x = 16;
talent_card_gap_y = 14;
talent_grid_cols = 6;
talent_grid_scroll_row = 0;
talent_grid_visible_rows = 3;
shop_grid_cols = 6;
shop_grid_scroll_row = 0;
shop_grid_visible_rows = 3;
