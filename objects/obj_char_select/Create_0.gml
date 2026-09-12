if (!variable_global_exists("paused")) global.paused = false;
if (!variable_global_exists("attr_window_open")) global.attr_window_open = false;
if (!variable_global_exists("chest_reward_open")) global.chest_reward_open = false;
if (!variable_global_exists("hitstop_timer")) global.hitstop_timer = 0;
load_save_from_disk();
load_meta_from_disk();

classes = ["knight", "mage", "archer", "assassin"];
labels = ["Cavaleiro", "Mago", "Arqueiro", "Assassino"];
colours = [c_aqua, c_fuchsia, c_lime, c_gray];
selected_index = 0;

box_w = 180;
box_h = 220;
box_gap = 40;

state = "main_menu"; // main_menu | select | shop | select_talents

main_menu_options = ["Novo Jogo", "Continuar", "Sair"];
main_menu_cursor = global.has_save ? 1 : 0;
main_menu_btn_w = 340;
main_menu_btn_h = 54;
main_menu_btn_gap = 18;

shop_tab_index = 0;
shop_talent_index = 0;

talent_select_list = [];
talent_select_cursor = 0;
talent_selected_ids = [];

elements = ["none", "water", "fire", "wind", "earth"];
element_labels = ["Neutro (Cavaleiro)", "Agua (Paladino)", "Fogo (Berserker)", "Ar (Duelista)", "Terra (Guardiao)"];
selected_element_index = 0;

// Configurações visuais da grade de talentos
talent_card_w = 152;
talent_card_h = 104;
talent_card_gap_x = 16;
talent_card_gap_y = 14;
talent_grid_cols = 6;
talent_grid_scroll_row = 0;
talent_grid_visible_rows = 3;
shop_grid_scroll_row = 0;
shop_grid_visible_rows = 3;
