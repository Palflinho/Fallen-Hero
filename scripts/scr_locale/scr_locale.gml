// =========================================================================
// SISTEMA DE LOCALIZACAO / MULTILINGUE (i18n) (Fallen Hero)
// =========================================================================
// Idiomas suportados:
// - "pt": Português (Brasil) [Padrão]
// - "en": English
// Textos de interface usam chaves (loc); textos soltos do jogo usam a propria
// frase em portugues como chave (tr) - ver scr_locale_en.
// =========================================================================

function locale_init() {
    if (variable_global_exists("locale_initialized") && global.locale_initialized) return;
    global.locale_initialized = true;

    if (!variable_global_exists("game_language")) {
        global.game_language = "pt";
    }

    global.loc_dict = {};

    // -------------------------------------------------------------
    // Dicionário Central de Termos e Textos de Interface
    // -------------------------------------------------------------
    loc_register("app_title", "Fallen Hero", "Fallen Hero");
    loc_register("press_start", "Pressione Espaço / Start", "Press Space / Start");
    loc_register("select_hero", "Selecione seu Herói", "Select your Hero");
    loc_register("language", "Idioma", "Language");
    loc_register("lang_name", "Português", "English");
    loc_register("continue", "[Espaço / A] Continuar »", "[Space / A] Continue »");
    loc_register("accelerate", "[Acelerar]", "[Fast Forward]");
    loc_register("action_btn", "AÇÃO", "ACT");
    
    // Termos do Hub (Vila Subterrânea)
    loc_register("village_title", "Vila Subterrânea dos Refugiados", "Underground Refuge Village");
    loc_register("portal_title", "Portal de Expedição", "Expedition Portal");
    loc_register("portal_prompt", "[Espaço / A] Entrar no Templo", "[Space / A] Enter Temple");
    loc_register("portal_temple5_prompt", "[Espaço / A] Entrar no Santuário Final (O Salvador)", "[Space / A] Enter Final Sanctum (The Savior)");
    loc_register("talk_prompt", "[Espaço / A] Conversar", "[Space / A] Talk");
    loc_register("bonfire_name", "Fogueira Acolhedora", "Cozy Bonfire");
    loc_register("bonfire_desc", "O fogo crepita calmamente, afastando o frio das cavernas.", "The flames crackle warmly, warding off the cavern chill.");

    // Pedestais Elementais
    loc_register("pedestal_water", "Pedestal da Água", "Water Pedestal");
    loc_register("pedestal_fire", "Pedestal do Fogo", "Fire Pedestal");
    loc_register("pedestal_wind", "Pedestal do Vento", "Wind Pedestal");
    loc_register("pedestal_earth", "Pedestal da Terra", "Earth Pedestal");
    loc_register("essence_reclaimed", "* Essência Restaurada *", "* Essence Restored *");
    loc_register("essence_missing", "* Vazio - Derrote o General *", "* Empty - Defeat the General *");

    // Classes e Atributos
    loc_register("class_knight", "Rinoceronte Cavaleiro", "Rhino Knight");
    loc_register("class_mage", "Raposa Maga", "Fox Mage");
    loc_register("class_archer", "Lagarto Arqueiro", "Lizard Archer");
    loc_register("class_assassin", "Urutau Assassino", "Potoo Assassin");

    loc_register("hp_label", "Vida", "Health");
    loc_register("gold_label", "Ouro", "Gold");
    loc_register("level_label", "Nível", "Level");
    loc_register("pause_title", "PAUSADO", "PAUSED");
    loc_register("victory_title", "VITÓRIA!", "VICTORY!");
    loc_register("defeat_title", "DERROTADO", "DEFEATED");

    // Chefes
    loc_register("boss_water_title", "General da Água [Guardião Corrompido]", "Water General [Corrupted Guardian]");
    loc_register("boss_wind_title", "General Zephyrus [Mestre dos Vendavais]", "General Zephyrus [Master of Gales]");
    loc_register("boss_human_title", "O Salvador [Cientista Humano]", "The Savior [Human Scientist]");
}

function loc_register(_key, _pt, _en) {
    global.loc_dict[$ _key] = {
        pt: _pt,
        en: _en
    };
}

function loc(_key, _fallback = "") {
    locale_init();
    if (!variable_struct_exists(global.loc_dict, _key)) {
        return (_fallback != "") ? _fallback : _key;
    }
    var _entry = global.loc_dict[$ _key];
    var _lang = variable_global_exists("game_language") ? global.game_language : "pt";
    if (variable_struct_exists(_entry, _lang)) {
        return _entry[$ _lang];
    }
    return _entry.pt;
}

// Traducao por frase: a chave e o proprio texto em portugues (dicionario em scr_locale_en).
// Em portugues devolve o texto como esta; em ingles procura a frase inteira e, se nao
// achar, troca os pedacos conhecidos (textos com numeros, ex.: "FASE 2!" -> "PHASE 2!").
function tr(_pt) {
    if (!is_string(_pt)) return _pt;
    if (loc_get_language() != "en") return _pt;
    locale_en_init();
    if (variable_struct_exists(global.tr_en, _pt)) return global.tr_en[$ _pt];
    var _out = _pt;
    for (var _i = 0; _i < array_length(global.tr_en_parts); _i++) {
        _out = string_replace_all(_out, global.tr_en_parts[_i][0], global.tr_en_parts[_i][1]);
    }
    return _out;
}

/// @function loc_prompt(key, fallback)
/// @desc Retorna o prompt traduzido adaptando a tag de botão caso controles touch estejam ativos
function loc_prompt(_key, _fallback = "") {
    var _str = loc(_key, _fallback);
    if (touch_controls_is_enabled()) {
        var _btn = "[" + loc("action_btn", "AÇÃO") + "]";
        _str = string_replace(_str, "[Espaço / A]", _btn);
        _str = string_replace(_str, "[Space / A]", _btn);
    }
    return _str;
}

function loc_get_language() {
    locale_init();
    var _l = variable_global_exists("game_language") ? global.game_language : "pt";
    return (_l == "en") ? "en" : "pt"; // saves antigos em "es"/"ja" caem para portugues
}

function loc_set_language(_lang_code) {
    locale_init();
    if (_lang_code == "pt" || _lang_code == "en") {
        global.game_language = _lang_code;
        if (variable_global_exists("meta_loaded") && global.meta_loaded) {
            save_meta();
        }
    }
}

function loc_next_language() {
    locale_init();
    var _curr = loc_get_language();
    loc_set_language((_curr == "pt") ? "en" : "pt");
    return loc_get_language();
}

function loc_get_language_label() {
    var _lang = loc_get_language();
    switch (_lang) {
        case "pt": return "Português";
        case "en": return "English";
        default:   return "Português";
    }
}

// Fonte da interface com acentos (Latin-1). Prioridade: asset "fnt_ui" criado no IDE,
// depois a Liberation Sans embutida em datafiles/fonts, e por fim a fonte padrão.
function ui_font() {
    if (!variable_global_exists("fnt_ui_cached")) {
        global.fnt_ui_cached = -1;
        var _asset = asset_get_index("fnt_ui");
        if (_asset != -1 && font_exists(_asset)) {
            global.fnt_ui_cached = _asset;
        } else {
            var _path = "fonts/LiberationSans-Regular.ttf";
            if (file_exists(_path)) {
                var _f = font_add(_path, 12, false, false, 32, 255);
                if (font_exists(_f)) global.fnt_ui_cached = _f;
            }
        }
    }
    return global.fnt_ui_cached;
}
