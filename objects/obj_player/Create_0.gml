character_class = variable_global_exists("selected_character") ? global.selected_character : "knight";

// Defaults (Cavaleiro / Knight)
hp_max = 100;
stamina_max = 100;
stamina_regen = 25;
mana_max = 0;
mana_regen = 0;
move_speed = 180;
body_colour = c_aqua;

attack_duration = 0.22;
attack_cooldown = 0.28;
attack_range = 30;
attack_damage = 12;
attack_object = obj_atk_knight;
attack_is_ranged = false;
projectile_speed = 0;

defend_mode = "block";
defend_block_cost = 20;
defend_mana_drain = 0;
defend_roll_speed = 0;
defend_roll_duration = 0;
defend_cooldown = 0;

pickup_damage_reduction = 1;

sprite_walk = -1;
sprite_attack = -1;

switch (character_class) {
    case "mage":
        hp_max = 70;
        stamina_max = 40;
        mana_max = 100;
        mana_regen = 12;
        move_speed = 160;
        body_colour = c_fuchsia;

        attack_duration = 0.18;
        attack_cooldown = 0.9;
        attack_damage = 18;
        attack_object = obj_atk_fireball;
        attack_is_ranged = true;
        projectile_speed = 260;

        defend_mode = "manashield";
        defend_mana_drain = 30;

        sprite_walk = -1;
        sprite_attack = -1;
        break;

    case "archer":
        hp_max = 80;
        stamina_max = 100;
        move_speed = 200;
        body_colour = c_lime;

        attack_duration = 0.12;
        attack_cooldown = 0.35;
        attack_damage = 10;
        attack_object = obj_atk_arrow;
        attack_is_ranged = true;
        projectile_speed = 420;

        defend_mode = "roll";
        defend_block_cost = 25;
        defend_roll_speed = 320;
        defend_roll_duration = 0.25;
        defend_cooldown = 0.4;

        sprite_walk = -1;
        sprite_attack = -1;
        break;

    case "assassin":
        hp_max = 60;
        stamina_max = 60;
        mana_max = 60;
        mana_regen = 10;
        move_speed = 190;
        body_colour = c_gray;

        attack_duration = 0.1;
        attack_cooldown = 0.15;
        attack_range = 16;
        attack_damage = 6;
        attack_object = obj_atk_dagger;
        attack_is_ranged = false;

        defend_mode = "invisible";
        defend_mana_drain = 25;

        sprite_walk = -1;
        sprite_attack = -1;
        break;

    case "knight":
    default:
        break;
}

// Persisted progress from an earlier room/checkpoint (pickup upgrades) overrides the
// pure class defaults above. Current resources still refill to full below -- a room
// transition is a checkpoint, not a mid-fight save.
if (variable_global_exists("use_saved_stats") && global.use_saved_stats) {
    hp_max = global.save_hp_max;
    stamina_max = global.save_stamina_max;
    mana_max = global.save_mana_max;
    attack_damage = global.save_attack_damage;
    attack_cooldown = global.save_attack_cooldown;
    move_speed = global.save_move_speed;
    pickup_damage_reduction = global.save_pickup_damage_reduction;
}

hp = hp_max;
stamina = stamina_max;
mana = mana_max;

stamina_regen_delay = 0.6;
stamina_regen_timer = 0;
mana_regen_delay = 0.6;
mana_regen_timer = 0;

facing_x = 0;
facing_y = 1;
input_h = 0;
input_v = 0;

state = "idle";

attack_timer = 0;
attack_cooldown_timer = 0;
attack_has_fired = false;

defend_active = false;
defend_cooldown_timer = 0;
roll_timer = 0;

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
