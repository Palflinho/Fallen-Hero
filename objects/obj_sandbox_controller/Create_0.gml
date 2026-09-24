// Controlador do Sandbox do Desenvolvedor (ver scr_sandbox).
//  Painel a direita ([F6] mostra/esconde), [F7] mostra colisoes.
//  Mouse: esquerdo coloca o item escolhido, direito apaga o que estiver embaixo.
global.sandbox_active = true;
global.run_in_progress = true;

sandbox_class = variable_global_exists("selected_character") ? global.selected_character : "knight";
sandbox_element = variable_global_exists("selected_element") ? global.selected_element : "none";
sandbox_level = 1;
sandbox_slots = array_create(TALENT_SLOTS_TOTAL, "");
sandbox_slot_sel = 0;

tab = "hero";
tool = undefined;
variant = "normal";
panel_visible = true;
show_collisions = false;
god_mode = true;
scroll = 0;
scroll_max = 0;
panel_w = 330;
panel_rows = [];
player_applied = false;
toast_text = "";
toast_timer = 0;
