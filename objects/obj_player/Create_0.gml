character_class = variable_global_exists("selected_character") ? global.selected_character : "knight";

element_affinity = variable_global_exists("selected_element") ? global.selected_element : "none";
archetype_name = tr("Cavaleiro");

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
sprite_index = -1;

// Sub-archetype parameters for Knight
paladin_aura_radius = 90;
paladin_aura_tick_timer = 0;
paladin_aura_tick_interval = 0.5;
paladin_barrier_active = 0;

duelist_combo_count = 0;
duelist_combo_timer = 0;
parry_flash_timer = 0;
parry_haste_timer = 0;
furia_ancestral_timer = 0;
knight_eco_ancestral_used = false;

// Valores padrao para todas as classes (a Maga sobrescreve abaixo). Sem isso, o Step le
// estas variaveis em Cavaleiro/Arqueiro/Assassino antes de existirem e o jogo trava.
mage_run_kills = 0;
estatica_charge = 0;
conflagracao_timer = 0;
cefiro_buff_timer = 0;
singularidade_timer = 0;
mage_fire_hits = 0;

switch (character_class) {
    case "knight":
        sprite_walk = -1;
        sprite_attack = -1;
        sprite_index = -1;

        switch (element_affinity) {
            case "water":
                archetype_name = tr("Lanceiro"); // Agua -> estilo Arqueiro
                body_colour = c_teal;
                defend_mode = "paladin_aura";
                defend_duration = 3.5;
                defend_cooldown_base = 5.0;
                break;

            case "fire":
                archetype_name = tr("Cavaleiro Runico"); // Fogo -> estilo Maga
                body_colour = c_orange;
                attack_duration = 0.25;
                defend_mode = "berserk_fury";
                defend_duration = 4.0;
                defend_cooldown_base = 6.0;
                break;

            case "wind":
                archetype_name = tr("Duelista");
                body_colour = c_yellow;
                nat_atk_spd_base = 1 / 0.20;
                nat_move_spd_base = 205;
                attack_duration = 0.12;
                defend_mode = "parry";
                defend_duration = 0.45;
                defend_cooldown_base = 3.0;
                break;

            case "earth":
                archetype_name = tr("Guardiao");
                body_colour = make_colour_rgb(160, 95, 45);
                nat_defesa_base = 12;
                nat_hp_base = 125;
                nat_move_spd_base = 165;
                attack_range = 24;
                defend_mode = "guardian_aegis";
                defend_duration = 3.0;
                defend_cooldown_base = 5.5;
                break;

            default:
                archetype_name = tr("Cavaleiro");
                body_colour = c_aqua;
                defend_mode = "block";
                defend_duration = 2.5;
                defend_cooldown_base = 4.0;
                break;
        }
        break;

    case "mage":
        nat_power_base = 14;
        nat_defesa_base = 3;
        nat_atk_spd_base = 1 / 0.9;
        nat_move_spd_base = 160;
        nat_hp_base = 70;
        attack_duration = 0.18;
        attack_object = obj_atk_fireball;
        attack_is_ranged = true;
        attack_damage_type = "magical";
        projectile_speed = 260;
        sprite_walk = -1;
        sprite_attack = -1;
        mage_run_kills = 0;
        estatica_charge = 0;
        conflagracao_timer = 0;
        cefiro_buff_timer = 0;
        singularidade_timer = 12.0;
        mage_fire_hits = 0;

        switch (element_affinity) {
            case "water":
                archetype_name = tr("Atiradora Arcana"); // Agua -> estilo Arqueiro
                body_colour = make_colour_rgb(100, 180, 255);
                defend_mode = "cryo_prison";
                defend_duration = 2.5;
                defend_cooldown_base = 5.0;
                break;

            case "fire":
                archetype_name = tr("Piromante");
                body_colour = make_colour_rgb(255, 90, 40);
                defend_mode = "pyro_blast";
                defend_duration = 0.4;
                defend_cooldown_base = 4.5;
                attack_duration = 0.16;
                break;

            case "wind":
                archetype_name = tr("Ilusionista");
                body_colour = make_colour_rgb(180, 220, 255);
                nat_move_spd_base = 185;
                nat_atk_spd_base = 1 / 0.75;
                defend_mode = "voltaic_blink";
                defend_duration = 0.2;
                defend_cooldown_base = 3.2;
                break;

            case "earth":
                archetype_name = tr("Templaria");
                body_colour = make_colour_rgb(190, 150, 90);
                nat_defesa_base = 7;
                nat_hp_base = 90;
                defend_mode = "basalt_pillar";
                defend_duration = 3.0;
                defend_cooldown_base = 5.5;
                break;

            default:
                archetype_name = tr("Arcano");
                body_colour = c_fuchsia;
                defend_mode = "manashield";
                defend_duration = 2.0;
                defend_cooldown_base = 5.0;
                break;
        }
        break;

    case "archer":
        nat_power_base = 8;
        nat_defesa_base = 4;
        nat_atk_spd_base = 1 / 0.38;
        nat_move_spd_base = 200;
        nat_hp_base = 80;
        attack_duration = 0.12;
        attack_object = obj_atk_arrow;
        attack_is_ranged = true;
        attack_damage_type = "physical";
        projectile_speed = 420;
        sprite_walk = -1;
        sprite_attack = -1;

        switch (element_affinity) {
            case "water":
                archetype_name = tr("Cacador das Mares");
                body_colour = make_colour_rgb(80, 200, 200);
                defend_mode = "mist_roll";
                defend_duration = 0.30;
                defend_roll_speed = 340;
                defend_cooldown_base = 3.0;
                break;

            case "fire":
                archetype_name = tr("Artilheiro Arcano");
                body_colour = make_colour_rgb(240, 110, 40);
                defend_mode = "fire_recoil";
                defend_duration = 0.25;
                defend_roll_speed = -280;
                defend_cooldown_base = 3.5;
                break;

            case "wind":
                archetype_name = tr("Cacador Furtivo");
                body_colour = make_colour_rgb(160, 255, 120);
                nat_atk_spd_base = 1 / 0.32;
                defend_mode = "cyclone_roll";
                defend_duration = 0.25;
                defend_roll_speed = 360;
                defend_cooldown_base = 2.8;
                break;

            case "earth":
                archetype_name = tr("Sentinela");
                body_colour = make_colour_rgb(140, 170, 70);
                nat_power_base = 11;
                nat_atk_spd_base = 1 / 0.45;
                nat_move_spd_base = 180;
                defend_mode = "earth_anchor";
                defend_duration = 3.0;
                defend_roll_speed = 0;
                defend_cooldown_base = 5.0;
                break;

            default:
                archetype_name = tr("Arqueiro");
                body_colour = c_lime;
                defend_mode = "roll";
                defend_duration = 0.25;
                defend_roll_speed = 320;
                defend_cooldown_base = 3.0;
                break;
        }
        break;

    case "assassin":
        nat_power_base = 6;
        nat_defesa_base = 2;
        nat_atk_spd_base = 1 / 0.15;
        nat_move_spd_base = 190;
        nat_hp_base = 60;
        attack_range = 16;
        attack_duration = 0.10;
        attack_object = obj_atk_dagger;
        attack_is_ranged = false;
        attack_damage_type = "physical";
        sprite_walk = -1;
        sprite_attack = -1;

        switch (element_affinity) {
            case "water":
                archetype_name = tr("Rastreador"); // Agua -> estilo Arqueiro
                body_colour = make_colour_rgb(90, 160, 220);
                defend_mode = "spectral_mist";
                defend_duration = 2.5;
                defend_cooldown_base = 5.0;
                break;

            case "fire":
                archetype_name = tr("Alquimista");
                body_colour = make_colour_rgb(220, 70, 50);
                defend_mode = "ash_bomb";
                defend_duration = 1.0;
                defend_cooldown_base = 4.5;
                break;

            case "wind":
                archetype_name = tr("Algoz do Tufao");
                body_colour = make_colour_rgb(200, 200, 255);
                nat_move_spd_base = 215;
                nat_atk_spd_base = 1 / 0.12;
                defend_mode = "shadowstep";
                defend_duration = 0.2;
                defend_cooldown_base = 3.5;
                break;

            case "earth":
                archetype_name = tr("Cavaleiro Sombrio");
                body_colour = make_colour_rgb(80, 80, 95);
                nat_defesa_base = 8;
                nat_hp_base = 80;
                defend_mode = "obsidian_skin";
                defend_duration = 2.5;
                defend_cooldown_base = 5.5;
                break;

            default:
                archetype_name = tr("Assassino");
                body_colour = c_gray;
                defend_mode = "invisible";
                defend_duration = 3.0;
                defend_cooldown_base = 6.0;
                break;
        }
        break;
}

// Flat per-level growth -- differentiation lives in the bases and archetype scalings.
nat_power_growth = (character_class == "mage") ? 1.5 : 2;
nat_defesa_growth = 1.5;
nat_atk_spd_growth = 0.05;
nat_move_spd_growth = 3;
nat_hp_growth = 12;
attack_duration_current = attack_duration;

// ---- Level / EXP ----
level = 1;
xp = 0;
xp_to_next = 30;

// ---- Talents chosen for this run (picked at the char-select talent screen, or restored
// from a checkpoint). 3 slots chosen pre-run + 2 extra slots filled in-run (chests);
// ranks grow in-run from level-up points (level N grants N points).
talent_slot_ids = array_create(TALENT_SLOTS_TOTAL, "");
talent_slot_ranks = array_create(TALENT_SLOTS_TOTAL, 0);
talent_pending_points = 0;

if (variable_global_exists("inrun_saved_stats") && global.inrun_saved_stats) {
    level = global.inrun_level;
    xp = global.inrun_xp;
    talent_slot_ids = global.inrun_talent_slot_ids;
    talent_slot_ranks = global.inrun_talent_slot_ranks;
    talent_pending_points = global.inrun_talent_pending;
} else if (variable_global_exists("use_saved_stats") && global.use_saved_stats) {
    level = global.save_level;
    xp = global.save_xp;
    talent_slot_ids = global.save_talent_ids;
    talent_slot_ranks = global.save_talent_ranks;
    talent_pending_points = global.save_talent_pending;
} else {
    // Fresh run: level 1 already grants its point.
    if (variable_global_exists("chosen_talent_ids")) talent_slot_ids = global.chosen_talent_ids;
    talent_pending_points = talent_points_for_level(level);
}
player_normalize_talent_slots(id);

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

// Lanceiro
synth_paladin_aura_heal = 0;
synth_paladin_barrier = 0;
synth_paladin_heal_hit = 0;

// Cavaleiro Runico
synth_berserk_dmg_bonus = 0;
synth_berserk_burn = 0;
synth_berserk_lifesteal = 0;

// Duelista
synth_duelist_parry_bonus = 0;
synth_duelist_counter_mult = 0;
synth_duelist_speed = 0;

// Guardiao
synth_guardian_duration = 0;
synth_guardian_def = 0;
synth_guardian_taunt_shock = 0;

// Variáveis de controle de combate para talentos do Cavaleiro
attack_idle_timer = 0;
hit_streak_count = 0;
rune_blast_last = 0; // Cavaleiro Runico: controle de uma explosao por golpe
frenesi_stacks = 0;
frenesi_timer = 0;
flame_revenge_cooldown = 0;
clean_kills_count = 0;
dash_free_available = false;
dance_speed_timer = 0;
segundo_folego_cooldown = 0;
paladin_barrier_active = 0;
parry_flash_timer = 0;
duelist_combo_count = 0;

// Variáveis de controle de combate para talentos do Mago
mage_consecutive_hits = 0;
mage_static_charge = 0;
mage_fenix_used = false;
cryo_prison_absorb = 0;

// Variáveis de controle de combate para talentos do Arqueiro
archer_stationary_timer = 0;
archer_shot_counter = 0;
archer_anchor_active = false;
archer_recuo_cooldown = 0;
archer_hunter_reflex_timer = 0;
archer_wind_dance_shots = 0;
archer_phantom_timer = 0;
archer_phantom_x = 0;
archer_phantom_y = 0;

// Variáveis de controle de combate para talentos do Assassino
assassin_combo_counter = 0;
assassin_smoke_timer = 0;
assassin_entered_room_timer = 2.0;
assassin_free_evade_cooldown = 0;
assassin_last_hit_enemy = noone;
assassin_consecutive_hits = 0;
assassin_plasma_buff_timer = 0;
assassin_adrenalina_spd = 0;

hp_max = 0;
hp = 0;
player_recompute_synthetics(id);
player_recompute_attributes(id);
hp = hp_max;
if (variable_global_exists("inrun_saved_stats") && global.inrun_saved_stats && variable_global_exists("inrun_hp")) {
    hp = clamp(global.inrun_hp, 1, hp_max);
}

facing_x = 0;
facing_y = 1;
move_dir = 270;
input_h = 0;
input_v = 0;

state = "idle";

attack_timer = 0;
attack_cooldown_timer = 0;
attack_has_fired = false;

// Input buffering: a Z press is remembered for a short window even if it lands slightly
// before the cooldown clears (or mid-animation), instead of being silently dropped.
attack_buffer_timer = 0;
attack_buffer_duration = 0.12;

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

slow_active = false;
slow_multiplier = 1;
slow_duration = 0;
