/// scr_village.gml
/// Sistema de lógica, troca de classe e Altar das Essências da Vila dos Sobreviventes.

function player_apply_class_data(_p, _class, _elem) {
    if (!instance_exists(_p)) return;
    
    _p.character_class = _class;
    if (_elem != undefined && _elem != "") {
        _p.element_affinity = _elem;
    } else if (!variable_instance_exists(_p, "element_affinity") || _p.element_affinity == "") {
        _p.element_affinity = "none";
    }

    _p.attack_is_ranged = false;
    _p.attack_damage_type = "physical";
    _p.projectile_speed = 0;
    _p.defend_roll_speed = 0;

    switch (_p.character_class) {
        case "knight":
            _p.nat_power_base = 12;
            _p.nat_defesa_base = 8;
            _p.nat_atk_spd_base = 1 / 0.28;
            _p.nat_move_spd_base = 180;
            _p.nat_hp_base = 100;
            _p.attack_duration = 0.22;
            _p.attack_range = 30;
            _p.attack_object = obj_atk_knight;
            _p.sprite_walk = -1;
            _p.sprite_attack = -1;
            _p.sprite_index = -1;

            switch (_p.element_affinity) {
                case "water":
                    _p.archetype_name = "Paladino";
                    _p.body_colour = c_teal;
                    _p.defend_mode = "paladin_aura";
                    _p.defend_duration = 3.5;
                    _p.defend_cooldown_base = 5.0;
                    break;
                case "fire":
                    _p.archetype_name = "Berserker";
                    _p.body_colour = c_orange;
                    _p.attack_range = 42;
                    _p.attack_duration = 0.25;
                    _p.defend_mode = "berserk_fury";
                    _p.defend_duration = 4.0;
                    _p.defend_cooldown_base = 6.0;
                    break;
                case "wind":
                    _p.archetype_name = "Duelista";
                    _p.body_colour = c_yellow;
                    _p.nat_atk_spd_base = 1 / 0.20;
                    _p.nat_move_spd_base = 205;
                    _p.attack_duration = 0.12;
                    _p.defend_mode = "parry";
                    _p.defend_duration = 0.45;
                    _p.defend_cooldown_base = 3.0;
                    break;
                case "earth":
                    _p.archetype_name = "Guardiao";
                    _p.body_colour = make_colour_rgb(160, 95, 45);
                    _p.nat_defesa_base = 12;
                    _p.nat_hp_base = 125;
                    _p.nat_move_spd_base = 165;
                    _p.attack_range = 24;
                    _p.defend_mode = "guardian_aegis";
                    _p.defend_duration = 3.0;
                    _p.defend_cooldown_base = 5.5;
                    break;
                default:
                    _p.archetype_name = "Cavaleiro";
                    _p.body_colour = c_aqua;
                    _p.defend_mode = "block";
                    _p.defend_duration = 2.5;
                    _p.defend_cooldown_base = 4.0;
                    break;
            }
            break;

        case "mage":
            _p.nat_power_base = 14;
            _p.nat_defesa_base = 3;
            _p.nat_atk_spd_base = 1 / 0.9;
            _p.nat_move_spd_base = 160;
            _p.nat_hp_base = 70;
            _p.attack_duration = 0.18;
            _p.attack_object = obj_atk_fireball;
            _p.attack_is_ranged = true;
            _p.attack_damage_type = "magical";
            _p.projectile_speed = 260;
            _p.sprite_walk = -1;
            _p.sprite_attack = -1;

            switch (_p.element_affinity) {
                case "water":
                    _p.archetype_name = "Criomante";
                    _p.body_colour = make_colour_rgb(100, 180, 255);
                    _p.defend_mode = "cryo_prison";
                    _p.defend_duration = 2.5;
                    _p.defend_cooldown_base = 5.0;
                    break;
                case "fire":
                    _p.archetype_name = "Piromante";
                    _p.body_colour = make_colour_rgb(255, 90, 40);
                    _p.defend_mode = "pyro_blast";
                    _p.defend_duration = 0.4;
                    _p.defend_cooldown_base = 4.5;
                    _p.attack_duration = 0.16;
                    break;
                case "wind":
                    _p.archetype_name = "Aeromante";
                    _p.body_colour = make_colour_rgb(180, 220, 255);
                    _p.nat_move_spd_base = 185;
                    _p.nat_atk_spd_base = 1 / 0.75;
                    _p.defend_mode = "voltaic_blink";
                    _p.defend_duration = 0.2;
                    _p.defend_cooldown_base = 3.2;
                    break;
                case "earth":
                    _p.archetype_name = "Geomante";
                    _p.body_colour = make_colour_rgb(190, 150, 90);
                    _p.nat_defesa_base = 7;
                    _p.nat_hp_base = 90;
                    _p.defend_mode = "basalt_pillar";
                    _p.defend_duration = 3.0;
                    _p.defend_cooldown_base = 5.5;
                    break;
                default:
                    _p.archetype_name = "Arcano";
                    _p.body_colour = c_fuchsia;
                    _p.defend_mode = "manashield";
                    _p.defend_duration = 2.0;
                    _p.defend_cooldown_base = 5.0;
                    break;
            }
            break;

        case "archer":
            _p.nat_power_base = 8;
            _p.nat_defesa_base = 4;
            _p.nat_atk_spd_base = 1 / 0.38;
            _p.nat_move_spd_base = 200;
            _p.nat_hp_base = 80;
            _p.attack_duration = 0.12;
            _p.attack_object = obj_atk_arrow;
            _p.attack_is_ranged = true;
            _p.attack_damage_type = "physical";
            _p.projectile_speed = 420;
            _p.sprite_walk = -1;
            _p.sprite_attack = -1;

            switch (_p.element_affinity) {
                case "water":
                    _p.archetype_name = "Cacador das Mares";
                    _p.body_colour = make_colour_rgb(80, 200, 200);
                    _p.defend_mode = "mist_roll";
                    _p.defend_duration = 0.30;
                    _p.defend_roll_speed = 340;
                    _p.defend_cooldown_base = 3.0;
                    break;
                case "fire":
                    _p.archetype_name = "Balistico Infernal";
                    _p.body_colour = make_colour_rgb(240, 110, 40);
                    _p.defend_mode = "fire_recoil";
                    _p.defend_duration = 0.25;
                    _p.defend_roll_speed = -280;
                    _p.defend_cooldown_base = 3.5;
                    break;
                case "wind":
                    _p.archetype_name = "Mestre do Vendaval";
                    _p.body_colour = make_colour_rgb(160, 255, 120);
                    _p.nat_atk_spd_base = 1 / 0.32;
                    _p.defend_mode = "cyclone_roll";
                    _p.defend_duration = 0.25;
                    _p.defend_roll_speed = 360;
                    _p.defend_cooldown_base = 2.8;
                    break;
                case "earth":
                    _p.archetype_name = "Balista da Terra";
                    _p.body_colour = make_colour_rgb(140, 170, 70);
                    _p.nat_power_base = 11;
                    _p.nat_atk_spd_base = 1 / 0.45;
                    _p.nat_move_spd_base = 180;
                    _p.defend_mode = "earth_anchor";
                    _p.defend_duration = 3.0;
                    _p.defend_roll_speed = 0;
                    _p.defend_cooldown_base = 5.0;
                    break;
                default:
                    _p.archetype_name = "Arqueiro";
                    _p.body_colour = c_lime;
                    _p.defend_mode = "roll";
                    _p.defend_duration = 0.25;
                    _p.defend_roll_speed = 320;
                    _p.defend_cooldown_base = 3.0;
                    break;
            }
            break;

        case "assassin":
            _p.nat_power_base = 6;
            _p.nat_defesa_base = 2;
            _p.nat_atk_spd_base = 1 / 0.15;
            _p.nat_move_spd_base = 190;
            _p.nat_hp_base = 60;
            _p.attack_range = 16;
            _p.attack_duration = 0.10;
            _p.attack_object = obj_atk_dagger;
            _p.attack_is_ranged = false;
            _p.attack_damage_type = "physical";
            _p.sprite_walk = -1;
            _p.sprite_attack = -1;

            switch (_p.element_affinity) {
                case "water":
                    _p.archetype_name = "Lamina Espectral";
                    _p.body_colour = make_colour_rgb(90, 160, 220);
                    _p.defend_mode = "spectral_mist";
                    _p.defend_duration = 2.5;
                    _p.defend_cooldown_base = 5.0;
                    break;
                case "fire":
                    _p.archetype_name = "Lamina Vulcanica";
                    _p.body_colour = make_colour_rgb(220, 70, 50);
                    _p.defend_mode = "ash_bomb";
                    _p.defend_duration = 1.0;
                    _p.defend_cooldown_base = 4.5;
                    break;
                case "wind":
                    _p.archetype_name = "Algoz do Tufao";
                    _p.body_colour = make_colour_rgb(200, 200, 255);
                    _p.nat_move_spd_base = 215;
                    _p.nat_atk_spd_base = 1 / 0.12;
                    _p.defend_mode = "shadowstep";
                    _p.defend_duration = 0.2;
                    _p.defend_cooldown_base = 3.5;
                    break;
                case "earth":
                    _p.archetype_name = "Carrasco de Obsidiana";
                    _p.body_colour = make_colour_rgb(80, 80, 95);
                    _p.nat_defesa_base = 8;
                    _p.nat_hp_base = 80;
                    _p.defend_mode = "obsidian_skin";
                    _p.defend_duration = 2.5;
                    _p.defend_cooldown_base = 5.5;
                    break;
                default:
                    _p.archetype_name = "Assassino";
                    _p.body_colour = c_gray;
                    _p.defend_mode = "invisible";
                    _p.defend_duration = 3.0;
                    _p.defend_cooldown_base = 6.0;
                    break;
            }
            break;
    }

    _p.nat_power_growth = (_p.character_class == "mage") ? 1.5 : 2;
    _p.nat_defesa_growth = 1.5;
    _p.nat_atk_spd_growth = 0.05;
    _p.nat_move_spd_growth = 3;
    _p.nat_hp_growth = 12;
    _p.attack_duration_current = _p.attack_duration;

    player_recompute_attributes(_p);
    _p.hp = _p.hp_max;
}

function player_switch_class(_new_class, _new_elem) {
    var _p = instance_find(obj_player, 0);
    if (!instance_exists(_p)) return;

    if (_new_elem == undefined) {
        _new_elem = variable_global_exists("selected_element") ? global.selected_element : "none";
    }

    player_apply_class_data(_p, _new_class, _new_elem);

    global.selected_character = _new_class;
    global.selected_element = _new_elem;

    // Efeito de feedback lúdico (Sakurai)
    _p.hitstop_timer = 0.08;
    input_rumble_trigger(0.3, 0.3, 120);

    var _label = "Classe";
    switch (_new_class) {
        case "knight": _label = "Cavaleiro (Tatu)"; break;
        case "mage": _label = "Maga (Lobo-Guara)"; break;
        case "archer": _label = "Arqueiro (Lagarto)"; break;
        case "assassin": _label = "Assassino (Urutau)"; break;
    }

    // Cria efeito de texto flutuante informativo
    if (object_exists(obj_damage_number)) {
        var _fx = instance_create_layer(_p.x, _p.y - 40, "Instances", obj_damage_number);
        if (_fx != noone) {
            _fx.damage_text = "+ " + _label + "!";
            _fx.text_colour = _p.body_colour;
        }
    }
}

function village_get_essence_stats() {
    ensure_meta_loaded();

    var _w = false;
    var _f = false;
    var _wi = false;
    var _e = false;

    if (variable_global_exists("meta_elements") && is_struct(global.meta_elements)) {
        if (variable_struct_exists(global.meta_elements, "water")) _w = (global.meta_elements.water == true);
        if (variable_struct_exists(global.meta_elements, "fire")) _f = (global.meta_elements.fire == true);
        if (variable_struct_exists(global.meta_elements, "wind")) _wi = (global.meta_elements.wind == true);
        if (variable_struct_exists(global.meta_elements, "earth")) _e = (global.meta_elements.earth == true);
    }

    var _count = (_w ? 1 : 0) + (_f ? 1 : 0) + (_wi ? 1 : 0) + (_e ? 1 : 0);
    var _pct = round((_count / 4) * 100);

    return {
        total: _count,
        water: _w,
        fire: _f,
        wind: _wi,
        earth: _e,
        percent: _pct
    };
}

function village_get_restoration_lore(_count) {
    switch (_count) {
        case 0:
            return "Planeta Desolado. Vento seco, areia vermelha e ruinas estereis. O portal aguarda sua primeira incursao.";
        case 1:
            return "Primeira Centelha. Nuvens de chuva se formam e riachos timidos voltam a brotar nos pantanos dos Lagartos.";
        case 2:
            return "Renascimento Termico. O solo aquece e as primeiras sementes de flores verdes rebrotam nas planicies dos Tatus.";
        case 3:
            return "O Grande Sopro. Ventos celestes dispersam a poeira e as arvores voltam a respirar nas florestas dos Urutais.";
        case 4:
            return "Harmonia Total! O planeta dos quatro povos respira em pleno vigor! Mas na orbita... a Terra definha em silencio.";
        default:
            return "As essencias elementais ressoam no altar ancestral.";
    }
}
