// 3 talents per class. cost 0 = unlocked from the start; cost > 0 must be bought in the
// shop with gold before it can be picked at the pre-run talent-selection screen. Exactly
// one talent per class starts locked (for testing the purchase flow) -- the third one
// listed for each class. Numbers here (per_rank, cost) are placeholders, easy to retune.
function get_talent_defs() {
    return [
        {id: "knight_hp_regen", character: "knight", label: "HP Regen", synth_field: "synth_hp_reg", per_rank: 1.5, cost: 0},
        {id: "knight_def_fisica", character: "knight", label: "Def Fisica", synth_field: "synth_def_fisica", per_rank: 3, cost: 0},
        {id: "knight_hp_max", character: "knight", label: "HP Maximo", synth_field: "synth_armor_hp", per_rank: 15, cost: 50},

        {id: "archer_atk_spd", character: "archer", label: "Velocidade de Ataque", synth_field: "synth_atk_spd_bonus", per_rank: 0.08, cost: 0},
        {id: "archer_pwr_fisica", character: "archer", label: "Power Fisico", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
        {id: "archer_crit", character: "archer", label: "Critico", synth_field: "synth_crit_chance", per_rank: 0.05, cost: 50},

        {id: "mage_pwr_magica", character: "mage", label: "Power Magico", synth_field: "synth_pwr_magica", per_rank: 3, cost: 0},
        {id: "mage_def_magica", character: "mage", label: "Def Magica", synth_field: "synth_def_magica", per_rank: 3, cost: 0},
        {id: "mage_cdr", character: "mage", label: "Reducao de Recarga", synth_field: "synth_cdr", per_rank: 0.04, cost: 50},

        {id: "assassin_power", character: "assassin", label: "Power", synth_field: "synth_pwr_fisica", per_rank: 3, cost: 0},
        {id: "assassin_dodge", character: "assassin", label: "Dodge", synth_field: "synth_dodge", per_rank: 0.03, cost: 0},
        {id: "assassin_move_spd", character: "assassin", label: "Velocidade de Movimento", synth_field: "synth_move_spd_bonus", per_rank: 5, cost: 50},
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
    global.gold += _amount;
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
