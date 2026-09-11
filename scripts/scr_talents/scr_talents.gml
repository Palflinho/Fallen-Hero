// Shop talents per class -- cost 0 means unlocked from the start, cost > 0 must be bought
// with gold in the shop before it can be picked at the pre-run talent-selection screen.
//
// General talents (character: "general") are never sold in a shop and never offered at
// the pre-run screen -- they're only found in chests during a run (see roll_chest_talent
// / equip_chest_talent below), and are always "unlocked" the moment they're found.
//
// Each synth_field has exactly one class-specific source (stronger, chosen deliberately)
// and, where it makes sense across classes, one general/chest source (weaker, found at
// random) -- no synth_field should have two talents competing for the same role in the
// same class.
//
// Numbers here (per_rank, cost) are placeholders, easy to retune.
function get_talent_defs() {
    return [
        // ---- Cavaleiro (Knight) - Fundamentais ----
        {id: "knight_def_fisica", character: "knight", label: "Def Fisica", synth_field: "synth_def_fisica", per_rank: 3, cost: 0},
        {id: "knight_hp_max", character: "knight", label: "HP Maximo", synth_field: "synth_armor_hp", per_rank: 15, cost: 40},
        {id: "knight_golpe_pesado", character: "knight", label: "Golpe Pesado", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
        {id: "knight_retaliacao", character: "knight", label: "Retaliacao", synth_field: "synth_thorns_dmg", per_rank: 5, cost: 0},
        {id: "knight_folego_aco", character: "knight", label: "Folego de Aco", synth_field: "synth_hp_reg", per_rank: 1.5, cost: 0},
        {id: "knight_escudo_inabalavel", character: "knight", label: "Escudo Inabalavel", synth_field: "synth_block_reduction", per_rank: 0.08, cost: 50},

        // ---- Cavaleiro + Agua (Paladino) ----
        {id: "knight_paladino_aura", character: "knight", label: "Aura Revigorante", synth_field: "synth_paladin_aura_heal", per_rank: 2, cost: 50},
        {id: "knight_paladino_sobrevida", character: "knight", label: "Bencao da Sobrevida", synth_field: "synth_paladin_barrier", per_rank: 25, cost: 60},
        {id: "knight_paladino_golpe_sagrado", character: "knight", label: "Golpe Sagrado", synth_field: "synth_paladin_heal_hit", per_rank: 2, cost: 70},

        // ---- Cavaleiro + Fogo (Berserker) ----
        {id: "knight_berserk_furia", character: "knight", label: "Furia Devastadora", synth_field: "synth_berserk_dmg_bonus", per_rank: 0.20, cost: 50},
        {id: "knight_berserk_chamas", character: "knight", label: "Laminas Flamejantes", synth_field: "synth_berserk_burn", per_rank: 4, cost: 60},
        {id: "knight_berserk_sede_sangue", character: "knight", label: "Sede de Sangue", synth_field: "synth_berserk_lifesteal", per_rank: 0.03, cost: 70},

        // ---- Cavaleiro + Ar (Duelista) ----
        {id: "knight_duelista_parry_cd", character: "knight", label: "Reflexo do Vento", synth_field: "synth_duelist_parry_bonus", per_rank: 1, cost: 50},
        {id: "knight_duelista_contra_ataque", character: "knight", label: "Riposte Letal", synth_field: "synth_duelist_counter_mult", per_rank: 0.40, cost: 60},
        {id: "knight_duelista_combo_veloz", character: "knight", label: "Passo da Tempestade", synth_field: "synth_duelist_speed", per_rank: 0.08, cost: 70},

        // ---- Cavaleiro + Terra (Guardiao) ----
        {id: "knight_guardiao_bastiao", character: "knight", label: "Fortaleza de Rocha", synth_field: "synth_guardian_duration", per_rank: 1.0, cost: 50},
        {id: "knight_guardiao_casca_rocha", character: "knight", label: "Casca de Pedra", synth_field: "synth_guardian_def", per_rank: 4, cost: 60},
        {id: "knight_guardiao_taunt_choque", character: "knight", label: "Onda Sismica", synth_field: "synth_guardian_taunt_shock", per_rank: 12, cost: 70},

        // ---- Arqueiro (Archer) ----
        {id: "archer_pwr_fisica", character: "archer", label: "Power Fisico", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
        {id: "archer_mira_precisa", character: "archer", label: "Mira Precisa", synth_field: "synth_crit_chance", per_rank: 0.03, cost: 0},
        {id: "archer_fluxo_flechas", character: "archer", label: "Fluxo de Flechas", synth_field: "synth_atk_spd_bonus", per_rank: 0.05, cost: 0},
        {id: "archer_passo_leve", character: "archer", label: "Passo Leve", synth_field: "synth_move_spd_bonus", per_rank: 3, cost: 0},
        {id: "archer_flechas_perfurantes", character: "archer", label: "Flechas Perfurantes", synth_field: "synth_pierce_count", per_rank: 1, cost: 70},
        {id: "archer_instinto_cacador", character: "archer", label: "Instinto Cacador", synth_field: "synth_execute_bonus", per_rank: 0.08, cost: 70},

        // ---- Mago (Mage) ----
        {id: "mage_couraca_magica", character: "mage", label: "Couraca Magica", synth_field: "synth_def_magica", per_rank: 2, cost: 0},
        {id: "mage_fluxo_arcano", character: "mage", label: "Fluxo Arcano", synth_field: "synth_cdr", per_rank: 0.03, cost: 0},
        {id: "mage_vigor_arcano", character: "mage", label: "Vigor Arcano", synth_field: "synth_hp_reg", per_rank: 1.5, cost: 0},
        {id: "mage_sobrecarga", character: "mage", label: "Sobrecarga", synth_field: "synth_pwr_magica", per_rank: 3, cost: 70},
        {id: "mage_explosao_perfurante", character: "mage", label: "Explosao Perfurante", synth_field: "synth_pierce_count", per_rank: 1, cost: 70},

        // ---- Assassino (Assassin) ----
        {id: "assassin_move_spd", character: "assassin", label: "Velocidade de Movimento", synth_field: "synth_move_spd_bonus", per_rank: 5, cost: 50},
        {id: "assassin_instinto_assassino", character: "assassin", label: "Instinto Assassino", synth_field: "synth_execute_bonus", per_rank: 0.08, cost: 0},
        {id: "assassin_reflexos_sombrios", character: "assassin", label: "Reflexos Sombrios", synth_field: "synth_dodge", per_rank: 0.02, cost: 0},
        {id: "assassin_laminas_envenenadas", character: "assassin", label: "Laminas Envenenadas", synth_field: "synth_poison_on_hit", per_rank: 1, cost: 0},
        {id: "assassin_vampirismo_sombrio", character: "assassin", label: "Vampirismo Sombrio", synth_field: "synth_lifesteal", per_rank: 0.02, cost: 70},
        {id: "assassin_sombra_mortal", character: "assassin", label: "Sombra Mortal", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 70},

        // ---- Talentos Gerais (Baús) ----
        {id: "general_vigor", character: "general", label: "Vigor", synth_field: "synth_hp_reg", per_rank: 2, cost: 0},
        {id: "general_fortuna", character: "general", label: "Fortuna", synth_field: "synth_gold_bonus", per_rank: 0.15, cost: 0},
        {id: "general_reflexos", character: "general", label: "Reflexos", synth_field: "synth_dodge", per_rank: 0.025, cost: 0},
        {id: "general_folego_extra", character: "general", label: "Folego Extra", synth_field: "synth_second_wind", per_rank: 1, cost: 0},
        {id: "general_impeto", character: "general", label: "Impeto", synth_field: "synth_cdr", per_rank: 0.03, cost: 0},
        {id: "general_presteza", character: "general", label: "Presteza", synth_field: "synth_atk_spd_bonus", per_rank: 0.08, cost: 0},
        {id: "general_precisao", character: "general", label: "Precisao", synth_field: "synth_crit_chance", per_rank: 0.05, cost: 0},
        {id: "general_essencia", character: "general", label: "Essencia Arcana", synth_field: "synth_pwr_magica", per_rank: 3, cost: 0},
        {id: "general_aura", character: "general", label: "Aura Protetora", synth_field: "synth_def_magica", per_rank: 3, cost: 0},
        {id: "general_forca", character: "general", label: "Forca Bruta", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
    ];
}

function element_get_name(_elem) {
    switch (_elem) {
        case "water": return "Agua";
        case "fire": return "Fogo";
        case "wind": return "Ar";
        case "earth": return "Terra";
        default: return "Neutro";
    }
}

function knight_get_archetype_name(_elem) {
    switch (_elem) {
        case "water": return "Paladino";
        case "fire": return "Berserker";
        case "wind": return "Duelista";
        case "earth": return "Guardiao";
        default: return "Cavaleiro";
    }
}

function knight_get_archetype_desc(_elem) {
    switch (_elem) {
        case "water": return "Paladino: Especial gera Aura de Sobrevida em area que cura/protege.";
        case "fire": return "Berserker: Ataque amplo devastador. Especial entra em Furia Ardente (+50% dano/+regen).";
        case "wind": return "Duelista: Ataque duplo veloz em combo. Especial e Aparar (Parry com contra-ataque de 360).";
        case "earth": return "Guardiao: Ataque concentrado. Especial Bastiao bloqueia 100% dano fisico e magico + Taunt.";
        default: return "Cavaleiro: Espada de medio alcance e escudo com bloqueio fisico tradicional.";
    }
}

function get_talents_for_character(_character) {
    var _all = get_talent_defs();
    var _out = [];
    for (var i = 0; i < array_length(_all); i++) {
        if (_all[i].character == _character) array_push(_out, _all[i]);
    }
    return _out;
}

function get_general_talent_defs() {
    return get_talents_for_character("general");
}

function get_talent_def_by_id(_id) {
    var _all = get_talent_defs();
    for (var i = 0; i < array_length(_all); i++) {
        if (_all[i].id == _id) return _all[i];
    }
    return undefined;
}

function ensure_meta_loaded() {
    if (!variable_global_exists("gold")) load_meta_from_disk();
}

function talent_is_unlocked(_id) {
    ensure_meta_loaded();
    var _def = get_talent_def_by_id(_id);
    if (is_undefined(_def)) return false;
    if (_def.cost <= 0) return true;
    return variable_struct_exists(global.meta_unlocked, _id);
}

function element_is_unlocked(_elem) {
    if (_elem == "none") return true;
    ensure_meta_loaded();
    if (variable_global_exists("meta_elements") && variable_struct_exists(global.meta_elements, _elem)) {
        return global.meta_elements[$ _elem];
    }
    return true; // Default unlocked for testing & play
}

function element_unlock(_elem) {
    ensure_meta_loaded();
    if (!variable_global_exists("meta_elements")) global.meta_elements = {};
    global.meta_elements[$ _elem] = true;
    save_meta();
}

function load_meta_from_disk() {
    global.meta_unlocked = {};
    global.gold = 0;
    global.meta_elements = { "water": true, "fire": true, "wind": true, "earth": true };

    if (!file_exists("meta.ini")) return;

    ini_open("meta.ini");
    global.gold = ini_read_real("meta", "gold", 0);

    var _all = get_talent_defs();
    for (var i = 0; i < array_length(_all); i++) {
        var _id = _all[i].id;
        if (ini_read_real("unlocks", _id, 0) >= 1) {
            global.meta_unlocked[$ _id] = true;
        }
    }

    global.meta_elements.water = (ini_read_real("elements", "water", 1) >= 1);
    global.meta_elements.fire  = (ini_read_real("elements", "fire", 1) >= 1);
    global.meta_elements.wind  = (ini_read_real("elements", "wind", 1) >= 1);
    global.meta_elements.earth = (ini_read_real("elements", "earth", 1) >= 1);

    ini_close();
}

function save_meta() {
    ensure_meta_loaded();
    ini_open("meta.ini");
    ini_write_real("meta", "gold", global.gold);

    var _all = get_talent_defs();
    for (var i = 0; i < array_length(_all); i++) {
        var _id = _all[i].id;
        ini_write_real("unlocks", _id, talent_is_unlocked(_id) ? 1 : 0);
    }

    if (variable_global_exists("meta_elements")) {
        ini_write_real("elements", "water", (variable_struct_exists(global.meta_elements, "water") && global.meta_elements.water) ? 1 : 0);
        ini_write_real("elements", "fire",  (variable_struct_exists(global.meta_elements, "fire") && global.meta_elements.fire) ? 1 : 0);
        ini_write_real("elements", "wind",  (variable_struct_exists(global.meta_elements, "wind") && global.meta_elements.wind) ? 1 : 0);
        ini_write_real("elements", "earth", (variable_struct_exists(global.meta_elements, "earth") && global.meta_elements.earth) ? 1 : 0);
    }
    ini_close();
}

function talent_purchase(_id) {
    ensure_meta_loaded();
    var _def = get_talent_def_by_id(_id);
    if (is_undefined(_def)) return false;
    if (talent_is_unlocked(_id)) return false;
    if (global.gold < _def.cost) return false;

    global.gold -= _def.cost;
    global.meta_unlocked[$ _id] = true;
    save_meta();
    return true;
}

function player_gain_gold(_amount) {
    ensure_meta_loaded();
    var _p = instance_find(obj_player, 0);
    var _mult = (_p != noone) ? (1 + _p.synth_gold_bonus) : 1;
    global.gold += round(_amount * _mult);
    save_meta();
}

// Rebuilds every synth_* field from scratch based on the 3 chosen talent slots and their
// current in-run rank. Call after any rank change, before player_recompute_attributes.
function player_recompute_synthetics(_p) {
    _p.synth_hp_reg = 0;
    _p.synth_crit_chance = 0;
    _p.synth_cdr = 0;
    _p.synth_dodge = 0;
    _p.synth_armor_hp = 0;
    _p.synth_pwr_fisica = 0;
    _p.synth_pwr_magica = 0;
    _p.synth_def_fisica = 0;
    _p.synth_def_magica = 0;
    _p.synth_atk_spd_bonus = 0;
    _p.synth_move_spd_bonus = 0;
    _p.synth_lifesteal = 0;
    _p.synth_thorns_dmg = 0;
    _p.synth_block_reduction = 0;
    _p.synth_pierce_count = 0;
    _p.synth_execute_bonus = 0;
    _p.synth_poison_on_hit = 0;
    _p.synth_gold_bonus = 0;
    _p.synth_second_wind = 0;

    // Paladino
    _p.synth_paladin_aura_heal = 0;
    _p.synth_paladin_barrier = 0;
    _p.synth_paladin_heal_hit = 0;

    // Berserker
    _p.synth_berserk_dmg_bonus = 0;
    _p.synth_berserk_burn = 0;
    _p.synth_berserk_lifesteal = 0;

    // Duelista
    _p.synth_duelist_parry_bonus = 0;
    _p.synth_duelist_counter_mult = 0;
    _p.synth_duelist_speed = 0;

    // Guardiao
    _p.synth_guardian_duration = 0;
    _p.synth_guardian_def = 0;
    _p.synth_guardian_taunt_shock = 0;

    for (var i = 0; i < array_length(_p.talent_slot_ids); i++) {
        var _id = _p.talent_slot_ids[i];
        if (_id == "") continue;
        var _rank = _p.talent_slot_ranks[i];
        if (_rank <= 0) continue;

        var _def = get_talent_def_by_id(_id);
        if (is_undefined(_def)) continue;

        var _field = _def.synth_field;
        variable_instance_set(_p, _field, variable_instance_get(_p, _field) + _def.per_rank * _rank);
    }
}

function player_apply_talent_point(_p, _slot_index) {
    if (_p.talent_pending_points <= 0) return;
    if (_slot_index < 0 || _slot_index >= array_length(_p.talent_slot_ids)) return;
    if (_p.talent_slot_ids[_slot_index] == "") return;

    _p.talent_slot_ranks[_slot_index] += 1;
    _p.talent_pending_points -= 1;

    player_recompute_synthetics(_p);
    player_recompute_attributes(_p);
}

// ---- Chests: found during a run, grant one random general talent. The player picks
// which of their 3 slots to put it in (discarding that slot's current rank), or skips.
function roll_chest_talent() {
    var _pool = get_general_talent_defs();
    if (array_length(_pool) == 0) return "";
    return _pool[irandom(array_length(_pool) - 1)].id;
}

function open_chest_reward(_talent_id) {
    global.chest_reward_talent_id = _talent_id;
    global.chest_reward_open = true;
}

function equip_chest_talent(_p, _slot_index) {
    if (!global.chest_reward_open) return;
    if (_slot_index < 0 || _slot_index >= array_length(_p.talent_slot_ids)) return;

    // Rank belongs to the slot, not to whichever talent currently occupies it -- swapping
    // in a new talent keeps the rank already earned in that slot.
    _p.talent_slot_ids[_slot_index] = global.chest_reward_talent_id;

    player_recompute_synthetics(_p);
    player_recompute_attributes(_p);

    global.chest_reward_open = false;
}

function skip_chest_reward() {
    global.chest_reward_open = false;
}

// Single source of truth for "is the world frozen right now" -- covers full-screen UI
// (pause/attribute window/chest reward) AND the brief hit-stop freeze on impactful hits.
// Every Step event that matters checks this instead of the individual flags directly.
function is_world_paused() {
    return global.paused || global.attr_window_open || global.chest_reward_open || global.hitstop_timer > 0;
}
