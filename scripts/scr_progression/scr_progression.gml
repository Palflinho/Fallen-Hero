// Recomputes every derived stat (hp_max, move_speed, attack_cooldown, defend_cooldown,
// attack_damage) from level + per-class base/growth + synthetic bonuses. Called once at
// spawn and again every time the player levels up.
function player_recompute_attributes(_p) {
    var _lv = _p.level - 1;
    var _old_hp_max = _p.hp_max;

    _p.nat_power = _p.nat_power_base + _p.nat_power_growth * _lv;
    _p.nat_defesa = _p.nat_defesa_base + _p.nat_defesa_growth * _lv;
    _p.nat_atk_spd = _p.nat_atk_spd_base + _p.nat_atk_spd_growth * _lv;
    _p.nat_move_spd = _p.nat_move_spd_base + _p.nat_move_spd_growth * _lv;
    _p.nat_hp = _p.nat_hp_base + _p.nat_hp_growth * _lv;

    if (!variable_global_exists("shop_boost_power")) global.shop_boost_power = 0;
    if (!variable_global_exists("shop_boost_defesa")) global.shop_boost_defesa = 0;
    if (!variable_global_exists("shop_boost_hp")) global.shop_boost_hp = 0;
    if (!variable_global_exists("shop_boost_speed")) global.shop_boost_speed = 0;

    var _cdr_mult = max(0.2, 1 - _p.synth_cdr);

    _p.hp_max = _p.nat_hp + _p.synth_armor_hp + global.shop_boost_hp;
    _p.move_speed = _p.nat_move_spd + _p.synth_move_spd_bonus + global.shop_boost_speed;
    _p.attack_cooldown = (1 / _p.nat_atk_spd) / max(0.2, 1 + _p.synth_atk_spd_bonus) * _cdr_mult;
    _p.defend_cooldown = _p.defend_cooldown_base * _cdr_mult;

    // NOVO SISTEMA UNIFICADO:
    // Poder Fisico (synth_pwr_fisica) escala diretamente o Auto-Ataque (AA) basico com a arma de qualquer heroi
    _p.attack_damage = _p.nat_power + _p.synth_pwr_fisica + global.shop_boost_power;

    // Curva quadratica: cada nivel pede cada vez mais XP (30, 42, 58, 78, 102...)
    _p.xp_to_next = 30 + 10 * _lv + 2 * _lv * _lv;

    // Leveling never removes HP you already have -- the extra max HP is added on top,
    // it doesn't force a heal-to-full either.
    var _hp_delta = _p.hp_max - _old_hp_max;
    if (_hp_delta > 0) _p.hp += _hp_delta;
    _p.hp = clamp(_p.hp, 0, _p.hp_max);
}

function player_gain_exp(_amount) {
    var _p = instance_find(obj_player, 0);
    if (_p == noone) return;

    _p.xp += _amount;
    while (_p.xp >= _p.xp_to_next) {
        _p.xp -= _p.xp_to_next;
        _p.level += 1;
        _p.talent_pending_points += talent_points_for_level(_p.level);
        player_recompute_attributes(_p);
    }
}

function player_gain_gold(_amount) {
    if (_amount <= 0) return;
    ensure_meta_loaded();

    var _mult = get_mastery_gold_multiplier();
    var _final = round(_amount * _mult);

    sfx_play("gold", 0.08);

    global.gold += _final;
    if (!variable_global_exists("run_gold_earned")) global.run_gold_earned = 0;
    global.run_gold_earned += _final;

    save_meta();
}

function run_update_current_room_state() {
    if (!variable_global_exists("run_biome")) global.run_biome = "water";
    if (!variable_global_exists("run_room_step")) global.run_room_step = 1;

    if (room == Room1) {
        global.run_biome = "water";
        global.run_room_step = 1;
    } else if (room == Room3) {
        global.run_biome = "fire";
        global.run_room_step = 1;
    } else if (room == Room5) {
        global.run_biome = "wind";
        global.run_room_step = 1;
    } else if (room == Room7) {
        global.run_biome = "earth";
        global.run_room_step = 1;
    } else if (room == asset_get_index("room_exp2")) {
        global.run_room_step = 2;
    } else if (room == asset_get_index("room_arena")) {
        global.run_room_step = 2.5;
    } else if (room == asset_get_index("room_shop")) {
        global.run_room_step = 3;
    } else if (room == asset_get_index("room_exp4")) {
        global.run_room_step = 4;
    } else if (room == asset_get_index("room_preboss")) {
        global.run_room_step = 5;
    } else if (room == Room2) {
        global.run_biome = "water";
        global.run_room_step = 6;
    } else if (room == Room4) {
        global.run_biome = "fire";
        global.run_room_step = 6;
    } else if (room == Room6) {
        global.run_biome = "wind";
        global.run_room_step = 6;
    } else if (room == Room8) {
        global.run_biome = "earth";
        global.run_room_step = 6;
    }
    global.run_room_index = global.run_room_step;
}

function run_get_biome_name(_b) {
    if (_b == "water") return tr("AGUA");
    if (_b == "fire") return tr("FOGO");
    if (_b == "wind") return tr("VENTO");
    if (_b == "earth") return tr("TERRA");
    return tr("DESCONHECIDO");
}

function run_get_room_title(_step) {
    if (_step == 1) return tr("Exploracao 1");
    if (_step == 2) return tr("Exploracao 2");
    if (_step == 2.5) return tr("Arena");
    if (_step == 3) return tr("Mercado");
    if (_step == 4) return tr("Exploracao 3");
    if (_step == 5) return tr("Pre-Chefe");
    if (_step == 6) return tr("Chefe");
    return tr("Sala");
}
