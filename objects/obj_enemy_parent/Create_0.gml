hp_max = 40;
hp = hp_max;
hit_flash_timer = 0;
hit_flash_duration = 0.12;
move_speed = 60;
contact_damage = 8;
state = "idle";
body_radius = 14;
body_colour = c_lime;
sprite_index = -1;

// Sakurai Polish: Knockback Physics
knockback_vx = 0;
knockback_vy = 0;
knockback_friction = 0.85;
knockback_resistance = 0.0;

// Sakurai Polish: Squash & Stretch Animation
scale_x = 1.0;
scale_y = 1.0;
squash_recovery = 0.18;
anim_seed = random(1000);

// Dynamic Combat Health Bar (Clutter reduction + Souls-like lagging damage bar)
hp_bar_timer = 0;
hp_bar_duration = 2.8;
hp_lag = hp_max;
hp_lag_speed = 0.08;

// Miyamoto Polish: Attack Telegraphing
telegraph_alert_timer = 0;

poison_active = false;
poison_damage = 0;
poison_tick_interval = 0;
poison_tick_timer = 0;
poison_duration = 0;

slow_active = false;
slow_multiplier = 1;
slow_duration = 0;

move_speed_effective = move_speed;

damage_reduction = 1;
defense = 0;
stats_scaled = false;
spectral_mark = 0;

exp_reward = 10;
gold_reward = 1;

home_x = x;
home_y = y;
patrol_radius = 150;
patrol_target_x = x;
patrol_target_y = y;
patrol_wait_timer = random_range(0, 1.5);
facing_dir = random(360);
facing_x = lengthdir_x(1, facing_dir);
facing_y = lengthdir_y(1, facing_dir);
facing_h = (facing_dir > 90 && facing_dir < 270) ? -1 : 1;
vision_range = 180;
vision_angle = 110;
lost_sight_timer = 0;
lost_sight_grace = 1.5;
spider_sense_range = 65;
spider_alert_timer = 0;
has_spotted_player = false;

// Sistema de Monstros Raros, Variantes Maiores e Drops de Baús
is_rare_mob = false;
is_greater_variant = false;
rare_chest_drop_chance = 0.0;

// Chance de ~12% de um monstro padrão surgir como Campeão Raro (exceto chefes)
var _is_boss = (object_index == obj_boss || object_index == obj_boss2 || (object_exists(asset_get_index("obj_boss3")) && object_index == asset_get_index("obj_boss3")) || (object_exists(asset_get_index("obj_boss4")) && object_index == asset_get_index("obj_boss4")));
if (!_is_boss && random(1) < 0.12) {
    is_rare_mob = true;
    rare_chest_drop_chance = 0.20;
    gold_reward = round(gold_reward * 1.5) + 1;
    exp_reward = round(exp_reward * 1.5);
}

// Afixos de Elite (Frenetico, Baluarte, Esporo)
elite_affix = "none";
bulwark_hits = 0;
affix_colour = c_white;

if (!_is_boss && random(1) < 0.22) {
    var _affixes = ["frenzied", "bulwark", "spore"];
    elite_affix = _affixes[irandom(2)];
    if (elite_affix == "frenzied") {
        move_speed *= 1.25;
        move_speed_effective = move_speed;
        affix_colour = make_colour_rgb(255, 70, 70); // Vermelho vivo
    } else if (elite_affix == "bulwark") {
        bulwark_hits = 3;
        affix_colour = make_colour_rgb(60, 190, 255); // Azul etereo
    } else if (elite_affix == "spore") {
        affix_colour = make_colour_rgb(255, 170, 40); // Laranja venenoso
    }
    gold_reward = round(gold_reward * 2.0);
    exp_reward = round(exp_reward * 1.5);
}

// Quebra de Postura (Stagger) e Modo Furia (Enrage) - Ativados nos mobs a partir da Fase 3
var _is_phase3_or_higher = (variable_global_exists("run_biome") && (global.run_biome == "wind" || global.run_biome == "earth")) || (room == asset_get_index("Room5") || room == asset_get_index("Room6") || room == asset_get_index("Room7") || room == asset_get_index("Room8"));
has_poise = (!_is_boss && _is_phase3_or_higher);
poise_max = 3;
poise_current = poise_max;
stagger_timer = 0;

can_enrage = (!_is_boss && _is_phase3_or_higher);
is_enraged = false;
repulsion_cooldown = 0;

// Chance de ~18% de surgir como Variante Maior / Alfa (mobs simples mais resistentes e imponentes)
var _is_simple = (object_index == obj_slime || object_index == obj_fire_slime || object_index == obj_elemental || object_index == obj_fire_elemental || (object_exists(asset_get_index("obj_wind_elemental")) && object_index == asset_get_index("obj_wind_elemental")) || (object_exists(asset_get_index("obj_earth_elemental")) && object_index == asset_get_index("obj_earth_elemental")) || (object_exists(asset_get_index("obj_wind_slime")) && object_index == asset_get_index("obj_wind_slime")) || (object_exists(asset_get_index("obj_earth_slime")) && object_index == asset_get_index("obj_earth_slime")));
if (!_is_boss && !is_rare_mob && _is_simple && random(1) < 0.18) {
    is_greater_variant = true;
    scale_x = 1.38;
    scale_y = 1.38;
    body_radius = round(body_radius * 1.30);
    exp_reward = round(exp_reward * 1.40);
    gold_reward = round(gold_reward * 1.2) + 1;
}

// Salvaguarda anti-parede: se for instanciado dentro de colisao, move para ponto livre
if (!fh_place_free_of_walls(x, y, body_radius)) {
    var _safe_pos = fh_find_free_spawn_pos(x, y, body_radius);
    x = _safe_pos.x;
    y = _safe_pos.y;
    home_x = x;
    home_y = y;
    patrol_target_x = x;
    patrol_target_y = y;
}
