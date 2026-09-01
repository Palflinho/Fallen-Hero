// Shop talents: 8 per class (3 original + 5 new), 5 free / 3 locked per class -- cost 0
// means unlocked from the start, cost > 0 must be bought with gold in the shop before it
// can be picked at the pre-run talent-selection screen.
//
// General talents (character: "general") are never sold in a shop and never offered at
// the pre-run screen -- they're only found in chests during a run (see roll_chest_talent
// / equip_chest_talent below), and are always "unlocked" the moment they're found.
//
// Numbers here (per_rank, cost) are placeholders, easy to retune.
function get_talent_defs() {
    return [
        {id: "knight_hp_regen", character: "knight", label: "HP Regen", synth_field: "synth_hp_reg", per_rank: 1.5, cost: 0},
        {id: "knight_def_fisica", character: "knight", label: "Def Fisica", synth_field: "synth_def_fisica", per_rank: 3, cost: 0},
        {id: "knight_hp_max", character: "knight", label: "HP Maximo", synth_field: "synth_armor_hp", per_rank: 15, cost: 50},
        {id: "knight_golpe_pesado", character: "knight", label: "Golpe Pesado", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
        {id: "knight_retaliacao", character: "knight", label: "Retaliacao", synth_field: "synth_thorns_dmg", per_rank: 5, cost: 0},
        {id: "knight_folego_aco", character: "knight", label: "Folego de Aco", synth_field: "synth_hp_reg", per_rank: 1.5, cost: 0},
        {id: "knight_vampirismo", character: "knight", label: "Vampirismo", synth_field: "synth_lifesteal", per_rank: 0.02, cost: 60},
        {id: "knight_escudo_inabalavel", character: "knight", label: "Escudo Inabalavel", synth_field: "synth_block_reduction", per_rank: 0.08, cost: 80},

        {id: "archer_atk_spd", character: "archer", label: "Velocidade de Ataque", synth_field: "synth_atk_spd_bonus", per_rank: 0.08, cost: 0},
        {id: "archer_pwr_fisica", character: "archer", label: "Power Fisico", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
        {id: "archer_crit", character: "archer", label: "Critico", synth_field: "synth_crit_chance", per_rank: 0.05, cost: 50},
        {id: "archer_mira_precisa", character: "archer", label: "Mira Precisa", synth_field: "synth_crit_chance", per_rank: 0.03, cost: 0},
        {id: "archer_fluxo_flechas", character: "archer", label: "Fluxo de Flechas", synth_field: "synth_atk_spd_bonus", per_rank: 0.05, cost: 0},
        {id: "archer_passo_leve", character: "archer", label: "Passo Leve", synth_field: "synth_move_spd_bonus", per_rank: 3, cost: 0},
        {id: "archer_flechas_perfurantes", character: "archer", label: "Flechas Perfurantes", synth_field: "synth_pierce_count", per_rank: 1, cost: 70},
        {id: "archer_instinto_cacador", character: "archer", label: "Instinto Cacador", synth_field: "synth_execute_bonus", per_rank: 0.08, cost: 70},

        {id: "mage_pwr_magica", character: "mage", label: "Power Magico", synth_field: "synth_pwr_magica", per_rank: 3, cost: 0},
        {id: "mage_def_magica", character: "mage", label: "Def Magica", synth_field: "synth_def_magica", per_rank: 3, cost: 0},
        {id: "mage_cdr", character: "mage", label: "Reducao de Recarga", synth_field: "synth_cdr", per_rank: 0.04, cost: 50},
        {id: "mage_fluxo_arcano", character: "mage", label: "Fluxo Arcano", synth_field: "synth_cdr", per_rank: 0.03, cost: 0},
        {id: "mage_couraca_magica", character: "mage", label: "Couraca Magica", synth_field: "synth_def_magica", per_rank: 2, cost: 0},
        {id: "mage_vigor_arcano", character: "mage", label: "Vigor Arcano", synth_field: "synth_hp_reg", per_rank: 1.5, cost: 0},
        {id: "mage_sobrecarga", character: "mage", label: "Sobrecarga", synth_field: "synth_pwr_magica", per_rank: 3, cost: 70},
        {id: "mage_explosao_perfurante", character: "mage", label: "Explosao Perfurante", synth_field: "synth_pierce_count", per_rank: 1, cost: 70},

        {id: "assassin_power", character: "assassin", label: "Power", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
        {id: "assassin_dodge", character: "assassin", label: "Dodge", synth_field: "synth_dodge", per_rank: 0.03, cost: 0},
        {id: "assassin_move_spd", character: "assassin", label: "Velocidade de Movimento", synth_field: "synth_move_spd_bonus", per_rank: 5, cost: 50},
        {id: "assassin_instinto_assassino", character: "assassin", label: "Instinto Assassino", synth_field: "synth_execute_bonus", per_rank: 0.08, cost: 0},
        {id: "assassin_reflexos_sombrios", character: "assassin", label: "Reflexos Sombrios", synth_field: "synth_dodge", per_rank: 0.02, cost: 0},
        {id: "assassin_laminas_envenenadas", character: "assassin", label: "Laminas Envenenadas", synth_field: "synth_poison_on_hit", per_rank: 1, cost: 0},
        {id: "assassin_vampirismo_sombrio", character: "assassin", label: "Vampirismo Sombrio", synth_field: "synth_lifesteal", per_rank: 0.02, cost: 70},
        {id: "assassin_sombra_mortal", character: "assassin", label: "Sombra Mortal", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 70},

        {id: "general_vigor", character: "general", label: "Vigor", synth_field: "synth_hp_reg", per_rank: 2, cost: 0},
        {id: "general_fortuna", character: "general", label: "Fortuna", synth_field: "synth_gold_bonus", per_rank: 0.15, cost: 0},
        {id: "general_reflexos", character: "general", label: "Reflexos", synth_field: "synth_dodge", per_rank: 0.025, cost: 0},
        {id: "general_folego_extra", character: "general", label: "Folego Extra", synth_field: "synth_second_wind", per_rank: 1, cost: 0},
        {id: "general_impeto", character: "general", label: "Impeto", synth_field: "synth_cdr", per_rank: 0.03, cost: 0},
    ];
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

function load_meta_from_disk() {
    global.meta_unlocked = {};
    global.gold = 0;

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

// Single source of truth for "is the world frozen for a full-screen UI right now" --
// every Step event that matters checks this instead of the individual flags directly.
function is_world_paused() {
    return global.paused || global.attr_window_open || global.chest_reward_open;
}
