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
    _p.attack_cooldown = (1 / (_p.nat_atk_spd + _p.synth_atk_spd_bonus)) * _cdr_mult;
    _p.defend_cooldown = _p.defend_cooldown_base * _cdr_mult;

    var _pwr_synth = (_p.attack_damage_type == "physical") ? _p.synth_pwr_fisica : _p.synth_pwr_magica;
    _p.attack_damage = _p.nat_power + _pwr_synth + global.shop_boost_power;

    _p.xp_to_next = 40 + 20 * (_p.level - 1);

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
        _p.talent_pending_points += 1;
        player_recompute_attributes(_p);
    }
}

function player_gain_gold(_amount) {
    if (_amount <= 0) return;
    ensure_meta_loaded();

    var _mult = get_mastery_gold_multiplier();
    var _final = round(_amount * _mult);

    global.gold += _final;
    if (!variable_global_exists("run_gold_earned")) global.run_gold_earned = 0;
    global.run_gold_earned += _final;

    save_meta();
}
