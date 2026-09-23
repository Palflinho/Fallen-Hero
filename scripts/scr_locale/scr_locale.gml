// =========================================================================
// SISTEMA DE LOCALIZACAO / MULTILINGUE (i18n) (Fallen Hero)
// =========================================================================
// Suporte nativo a 4 idiomas:
// - "pt": Português (Brasil) [Padrão]
// - "en": English
// - "es": Español
// - "ja": 日本語 (Japonês)
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
    loc_register("app_title", "Fallen Hero", "Fallen Hero", "Fallen Hero", "Fallen Hero");
    loc_register("press_start", "Pressione Espaço / Start", "Press Space / Start", "Presiona Espacio / Start", "Space / Startを押す");
    loc_register("select_hero", "Selecione seu Herói", "Select your Hero", "Selecciona tu Héroe", "英雄を選択");
    loc_register("language", "Idioma", "Language", "Idioma", "言語");
    loc_register("lang_name", "Português", "English", "Español", "日本語");
    loc_register("continue", "[Espaço / A] Continuar »", "[Space / A] Continue »", "[Espacio / A] Continuar »", "[Space / A] 次へ »");
    loc_register("accelerate", "[Acelerar]", "[Fast Forward]", "[Acelerar]", "[早送り]");
    
    // Termos do Hub (Vila Subterrânea)
    loc_register("village_title", "Vila Subterrânea dos Refugiados", "Underground Refuge Village", "Aldea Subterránea de Refugiados", "地下の難民村");
    loc_register("portal_title", "Portal de Expedição", "Expedition Portal", "Portal de Expedición", "遠征の門");
    loc_register("portal_prompt", "[Espaço / A] Entrar no Templo", "[Space / A] Enter Temple", "[Espacio / A] Entrar al Templo", "[Space / A] 神殿に入る");
    loc_register("portal_temple5_prompt", "[Espaço / A] Entrar no Santuário Final (O Salvador)", "[Space / A] Enter Final Sanctum (The Savior)", "[Espacio / A] Entrar al Santuario Final (El Salvador)", "[Space / A] 最終聖域に入る (救済者)");
    loc_register("bonfire_name", "Fogueira Acolhedora", "Cozy Bonfire", "Hoguera Acogedora", "温かな篝火");
    loc_register("bonfire_desc", "O fogo crepita calmamente, afastando o frio das cavernas.", "The flames crackle warmly, warding off the cavern chill.", "El fuego crepita con calma, alejando el frío de las cavernas.", "炎がパチパチと温かく爆ぜ、洞窟の冷気を払う。");

    // Pedestais Elementais
    loc_register("pedestal_water", "Pedestal da Água", "Water Pedestal", "Pedestal del Agua", "水の台座");
    loc_register("pedestal_fire", "Pedestal do Fogo", "Fire Pedestal", "Pedestal del Fuego", "火の台座");
    loc_register("pedestal_wind", "Pedestal do Vento", "Wind Pedestal", "Pedestal del Viento", "風の台座");
    loc_register("pedestal_earth", "Pedestal da Terra", "Earth Pedestal", "Pedestal de la Tierra", "地の台座");
    loc_register("essence_reclaimed", "* Essência Restaurada *", "* Essence Restored *", "* Esencia Restaurada *", "* 精髄回復 *");
    loc_register("essence_missing", "* Vazio - Derrote o General *", "* Empty - Defeat the General *", "* Vacío - Derrota al General *", "* 空虚 - 将軍を討て *");

    // Classes e Atributos
    loc_register("class_knight", "Rinoceronte Cavaleiro", "Rhino Knight", "Rinoceronte Caballero", "サイ騎士");
    loc_register("class_mage", "Raposa Maga", "Fox Mage", "Zorra Maga", "キツネ魔術師");
    loc_register("class_archer", "Lagarto Arqueiro", "Lizard Archer", "Lagarto Arquero", "トカゲ弓兵");
    loc_register("class_assassin", "Urutau Assassino", "Potoo Assassin", "Urutaú Asesino", "ポトウ暗殺者");

    loc_register("hp_label", "Vida", "Health", "Salud", "HP");
    loc_register("gold_label", "Ouro", "Gold", "Oro", "ゴールド");
    loc_register("level_label", "Nível", "Level", "Nivel", "レベル");
    loc_register("pause_title", "PAUSADO", "PAUSED", "PAUSADO", "一時停止");
    loc_register("victory_title", "VITÓRIA!", "VICTORY!", "¡VICTORIA!", "勝利！");
    loc_register("defeat_title", "DERROTADO", "DEFEATED", "DERROTADO", "敗北");

    // Chefes
    loc_register("boss_water_title", "General da Água [Guardião Corrompido]", "Water General [Corrupted Guardian]", "General del Agua [Guardián Corrupto]", "水の将軍 [穢れた守護者]");
    loc_register("boss_wind_title", "General Zephyrus [Mestre dos Vendavais]", "General Zephyrus [Master of Gales]", "General Zephyrus [Maestro de Vendavales]", "風将ゼピュロス [疾風の覇者]");
    loc_register("boss_human_title", "O Salvador [Cientista Humano]", "The Savior [Human Scientist]", "El Salvador [Científico Humano]", "救済者 [人類の科学者]");
}

function loc_register(_key, _pt, _en, _es, _ja) {
    global.loc_dict[$ _key] = {
        pt: _pt,
        en: _en,
        es: _es,
        ja: _ja
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

function loc_get_language() {
    locale_init();
    return variable_global_exists("game_language") ? global.game_language : "pt";
}

function loc_set_language(_lang_code) {
    locale_init();
    if (_lang_code == "pt" || _lang_code == "en" || _lang_code == "es" || _lang_code == "ja") {
        global.game_language = _lang_code;
        if (variable_global_exists("meta_loaded") && global.meta_loaded) {
            save_meta();
        }
    }
}

function loc_next_language() {
    locale_init();
    var _curr = loc_get_language();
    switch (_curr) {
        case "pt": loc_set_language("en"); break;
        case "en": loc_set_language("es"); break;
        case "es": loc_set_language("ja"); break;
        case "ja": loc_set_language("pt"); break;
        default:   loc_set_language("pt"); break;
    }
    return loc_get_language();
}

function loc_get_language_label() {
    var _lang = loc_get_language();
    switch (_lang) {
        case "pt": return "Português";
        case "en": return "English";
        case "es": return "Español";
        case "ja": return "日本語";
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
