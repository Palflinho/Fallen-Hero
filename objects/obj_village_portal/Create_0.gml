// =========================================================================
// PORTAL DA FENDA (obj_village_portal) - Fallen Hero
// =========================================================================
// Ponto de partida para a expedição roguelite pelas catacumbas.
// Ao interagir com o portal, abre a tela de preparação e seleção de herói.
// =========================================================================

vortex_timer = 0;
hum_sound_timer = 1.0;
portal_radius = 48;

modal_open = false;
interact_cooldown = 0;
notice_timer = 0;
notice_text = "";

classes = ["knight", "mage", "archer", "assassin"];
class_labels = ["Cavaleiro", "Mago", "Arqueiro", "Assassino"];
class_weapons = ["Espada Longa", "Cajado Arcano", "Arco Curto", "Adagas Gemeas"];
class_roles = ["Tanque / Melee", "Dano Magico / Area", "Mobilidade / Alcance", "Dano Critico / Evasao"];
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

function open_portal_modal() {
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

    // Sincroniza com as escolhas ativas
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

    sfx_play("portal_hum", 0.05, 0.6);
}

function close_portal_modal() {
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

function start_expedition() {
    var _chosen_class = classes[selected_class_idx];
    var _chosen_elem = elements[selected_element_idx];

    if (!element_is_unlocked(_chosen_elem, _chosen_class)) {
        notice_text = "Afinidade bloqueada! Conquiste-a na masmorra correspondente.";
        notice_timer = 75;
        sfx_play("stagger", 0.05, 0.7);
        return;
    }

    var _player = instance_find(obj_player, 0);
    if (_player != noone) {
        var _applied_talents = variable_global_exists("chosen_talent_ids") ? global.chosen_talent_ids : ["", "", ""];
        player_change_class(_player, _chosen_class, _chosen_elem, _applied_talents);
    }

    modal_open = false;
    global.village_modal_open = false;

    sfx_play("magic", 0.05, 0.8);
    trigger_camera_shake(5);

    if (all_elements_reclaimed()) {
        // Todas as essencias recuperadas! Abre passagem ao Templo 5 (O Humano)
        global.run_biome = "human";
        global.run_room_step = 1;
        room_goto(asset_get_index("room_temple5_shop"));
    } else {
        // Inicia Expedicao pelos Templos Elementais (começando pelo Templo da Agua)
        global.run_biome = "water";
        global.run_room_step = 1;
        global.temple_arena_layout = irandom(3);
        global.temple_arena_biome = "water";
        room_goto(Room1);
    }
}
