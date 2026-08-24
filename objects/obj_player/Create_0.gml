character_class = variable_global_exists("selected_character") ? global.selected_character : "knight";

// ---- Class identity: level-1 natural attribute bases + attack identity (Cavaleiro / Knight) ----
nat_power_base = 12;
nat_defesa_base = 8;
nat_atk_spd_base = 1 / 0.28;
nat_move_spd_base = 180;
nat_hp_base = 100;
body_colour = c_aqua;

attack_duration = 0.22;
attack_range = 30;
attack_object = obj_atk_knight;
attack_is_ranged = false;
attack_damage_type = "physical";
projectile_speed = 0;

defend_mode = "block";
defend_duration = 2.5;
defend_cooldown_base = 4.0;
defend_roll_speed = 0;

sprite_walk = -1;
sprite_attack = -1;

switch (character_class) {
    case "mage":
        nat_power_base = 18;
        nat_defesa_base = 3;
        nat_atk_spd_base = 1 / 0.9;
        nat_move_spd_base = 160;
        nat_hp_base = 70;
        body_colour = c_fuchsia;

        attack_duration = 0.18;
        attack_object = obj_atk_fireball;
        attack_is_ranged = true;
        attack_damage_type = "magical";
        projectile_speed = 260;

        defend_mode = "manashield";
        defend_duration = 2.0;
        defend_cooldown_base = 5.0;

        sprite_walk = -1;
        sprite_attack = -1;
        break;

    case "archer":
        nat_power_base = 10;
        nat_defesa_base = 4;
        nat_atk_spd_base = 1 / 0.35;
        nat_move_spd_base = 200;
        nat_hp_base = 80;
        body_colour = c_lime;

        attack_duration = 0.12;
        attack_object = obj_atk_arrow;
        attack_is_ranged = true;
        attack_damage_type = "physical";
        projectile_speed = 420;

        defend_mode = "roll";
        defend_duration = 0.25;
        defend_cooldown_base = 3.0;
        defend_roll_speed = 320;

        sprite_walk = -1;
        sprite_attack = -1;
        break;

    case "assassin":
        nat_power_base = 6;
        nat_defesa_base = 2;
        nat_atk_spd_base = 1 / 0.15;
        nat_move_spd_base = 190;
        nat_hp_base = 60;
        body_colour = c_gray;
        attack_range = 16;

        attack_duration = 0.1;
        attack_object = obj_atk_dagger;
        attack_is_ranged = false;
        attack_damage_type = "physical";

        defend_mode = "invisible";
        defend_duration = 3.0;
        defend_cooldown_base = 6.0;

        sprite_walk = -1;
        sprite_attack = -1;
        break;

    case "knight":
    default:
        break;
}

// Flat per-level growth -- identical across classes; differentiation lives in the bases above.
nat_power_growth = 2;
nat_defesa_growth = 1.5;
nat_atk_spd_growth = 0.05;
nat_move_spd_growth = 3;
nat_hp_growth = 12;

// ---- Level / EXP ----
level = 1;
xp = 0;
xp_to_next = 40;

// ---- Talents chosen for this run (picked at the char-select talent screen, or restored
// from a checkpoint). Up to 3 slots; ranks grow in-run from level-up points.
talent_slot_ids = ["", "", ""];
talent_slot_ranks = [0, 0, 0];
talent_pending_points = 0;

if (variable_global_exists("use_saved_stats") && global.use_saved_stats) {
    level = global.save_level;
    xp = global.save_xp;
    talent_slot_ids = global.save_talent_ids;
    talent_slot_ranks = global.save_talent_ranks;
    talent_pending_points = global.save_talent_pending;
} else if (variable_global_exists("chosen_talent_ids")) {
    talent_slot_ids = global.chosen_talent_ids;
}

// ---- Synthetic attributes -- only ever granted by talents. Recomputed from the talent
// slots above right below; anything not covered by a chosen talent stays at 0.
synth_hp_reg = 0;
synth_crit_chance = 0;
synth_crit_mult = 1.5;
synth_cdr = 0;
synth_dodge = 0;
synth_armor_hp = 0;
synth_pwr_fisica = 0;
synth_pwr_magica = 0;
synth_def_fisica = 0;
synth_def_magica = 0;
synth_atk_spd_bonus = 0;
synth_move_spd_bonus = 0;
synth_lifesteal = 0;
synth_thorns_dmg = 0;
synth_block_reduction = 0;
synth_pierce_count = 0;
synth_execute_bonus = 0;
synth_poison_on_hit = 0;
synth_gold_bonus = 0;
synth_second_wind = 0;
second_wind_cooldown_timer = 0;

hp_max = 0;
hp = 0;
player_recompute_synthetics(id);
player_recompute_attributes(id);
hp = hp_max;

facing_x = 0;
facing_y = 1;
input_h = 0;
input_v = 0;

state = "idle";

attack_timer = 0;
attack_cooldown_timer = 0;
attack_has_fired = false;

defend_active = false;
defend_timer = 0;
defend_cooldown_timer = 0;

hit_flash_timer = 0;
hit_flash_duration = 0.15;
invuln_timer = 0;
invuln_duration = 0.5;

invisible = false;

body_radius = 14;

vx = 0;
vy = 0;
on_ice = false;

poison_active = false;
poison_damage = 0;
poison_tick_interval = 0;
poison_tick_timer = 0;
poison_duration = 0;
