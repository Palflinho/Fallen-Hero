input_rumble_stop();
global.paused = false;
global.attr_window_open = false;
global.chest_reward_open = false;
global.midrun_shop_open = false;
global.run_victory = false;
global.ending_active = false;
global.run_in_progress = false;
global.sandbox_active = false;
global.hitstop_timer = 0;
global.run_playtime = 0;
if (!variable_global_exists("dev_mode")) global.dev_mode = false;
if (!variable_global_exists("current_save_slot")) global.current_save_slot = 1;

load_save_from_disk();
load_meta_from_disk();
settings_load();

reset_notice_timer = 0;
save_notice_timer = 0;
save_notice_text = "";

// A escolha de heroi, talentos e loja fica na vila (Casa dos Herois, Emporio e Portal)
state = "main_menu"; // main_menu | save_slots | options | controls
global.char_select_direct = false;

main_menu_options = [tr("Novo Jogo"), tr("Continuar"), tr("Opcoes"), tr("Sair")];
if (global.dev_mode) array_push(main_menu_options, tr("Sandbox (Dev)"));

// Tela de Opcoes
options_cursor = 0;
options_count = 9; // idioma, tela cheia, vol geral, vol efeitos, vol musica, tremor, vibracao, controles, voltar
main_menu_cursor = any_save_slot_exists() ? 1 : 0;
main_menu_btn_w = 340;
main_menu_btn_h = 52;
main_menu_btn_gap = 16;

settings_init();


// Parâmetros da tela dedicada de Save Slots (Segunda Tela)
save_slot_action = "new_game"; // "new_game" | "continue"
save_slot_cursor = 0; // 0, 1, 2 correspondentes a Slot 1, 2, 3
save_slot_delete_confirm = -1;
save_card_w = 260;
save_card_h = 340;
save_card_gap = 36;
