// =========================================================================
// CASA DOS HERÓIS (Alojamento dos Campeões) - Fallen Hero
// =========================================================================
// Edificação diegética na Vila onde o jogador interage com a porta
// para abrir o modal de seleção e troca de classe, afinidade e talentos.
// =========================================================================

interact_radius = 65;
interact_cooldown = 0;
modal_open = false;

classes = ["knight", "mage", "archer", "assassin"];
class_labels = ["Cavaleiro", "Mago", "Arqueiro", "Assassino"];
class_subtitles = [
    "Defesa robusta, combate corpo a corpo e bloqueio resoluto.",
    "Ataques magicos de longo alcance e escudos elementais arcanos.",
    "Alta mobilidade, cadencia de tiro e esquiva com rolamento.",
    "Velocidade fulminante, evasao e dano critico devastador."
];
class_colors = [c_aqua, c_fuchsia, c_lime, make_colour_rgb(180, 180, 200)];

elements = ["none", "water", "fire", "wind", "earth"];
element_labels = ["Neutro", "Agua", "Fogo", "Vento", "Terra"];
element_colors = [c_white, make_colour_rgb(90, 180, 255), make_colour_rgb(255, 110, 60), make_colour_rgb(240, 230, 90), make_colour_rgb(190, 140, 80)];

selected_class_idx = 0;
selected_element_idx = 0;

talent_select_list = [];
talent_selected_ids = [];
talent_cursor = 0;

notice_timer = 0;
notice_text = "";

// Sincroniza com as escolhas atuais do jogador
function refresh_talents_list() {
    var _char = classes[selected_class_idx];
    var _elem = elements[selected_element_idx];
    ensure_meta_loaded();

    if (element_is_unlocked(_elem, _char)) {
        var _unlocked = [];
        var _all = get_talents_for_character_and_affinity(_char, _elem);
        for (var _i = 0; _i < array_length(_all); _i++) {
            var _t = _all[_i];
            if (talent_is_unlocked(_t.id)) {
                array_push(_unlocked, _t);
            }
        }
        talent_select_list = _unlocked;
    } else {
        talent_select_list = [];
    }
    talent_cursor = 0;
}

function open_heroes_modal() {
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

    // Sincroniza com a classe atual
    var _p_char = variable_global_exists("selected_character") ? global.selected_character : "knight";
    var _p_elem = variable_global_exists("selected_element") ? global.selected_element : "none";
    
    selected_class_idx = 0;
    for (var _k = 0; _k < array_length(classes); _k++) {
        if (classes[_k] == _p_char) { selected_class_idx = _k; break; }
    }
    selected_element_idx = 0;
    for (var _e = 0; _e < array_length(elements); _e++) {
        if (elements[_e] == _p_elem) { selected_element_idx = _e; break; }
    }

    talent_selected_ids = [];
    if (variable_global_exists("chosen_talent_ids") && is_array(global.chosen_talent_ids)) {
        for (var _t = 0; _t < array_length(global.chosen_talent_ids); _t++) {
            if (global.chosen_talent_ids[_t] != "") array_push(talent_selected_ids, global.chosen_talent_ids[_t]);
        }
    }

    refresh_talents_list();
    sfx_play("door_open");
}

function close_heroes_modal() {
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
    sfx_play("menu_select");
}
