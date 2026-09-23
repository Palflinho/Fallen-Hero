event_inherited();

// Sincroniza a arquitetura do chefe com o layout sorteado para a arena deste templo
var _layout = arena_ensure_temple_layout("water");
arena_setup_chamber(_layout, true, "water");
if (instance_number(obj_stage_gate2) == 0 && object_exists(asset_get_index("obj_stage_gate2"))) {
    instance_create_layer(600, 120, layer, obj_stage_gate2);
}

body_colour = c_maroon;
body_radius = 60;
hp_max = 1200;
hp = hp_max;
move_speed = 20;
contact_damage = 32;

// Immune by default -- only takes damage while `vulnerable` is true.
damage_reduction = 0;
knockback_resistance = 1.0;

vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
facing_dir = 180;

// Ranged barrage -- same idea as obj_elemental, but a multi-shot fan and bigger scale.
// This is the boss's default, constant behaviour whenever the player keeps their distance.
barrage_shots_total = 5;
barrage_shots_fired = 0;
barrage_shot_timer = 0.6;
barrage_shot_interval = 0.16;
barrage_volley_pause = 0.45;
barrage_spread = 60;
projectile_damage = 18;
projectile_speed = 260;

// Melee AoE slam -- same idea as slime/golem windup hits, but huge. Only triggers when
// the player pushes deep into melee_range (past half of it); otherwise the boss never
// stops shooting. The windup is deliberately generous: even the slowest class can walk
// into that inner ring and walk back out again before it lands, so the slam is always
// avoidable and never a "free hit" -- it's purely a bait for the vulnerability window.
melee_range = 260;
melee_trigger_dist = melee_range * 0.5;
slam_windup = 1.5;
slam_windup_timer = 0;
slam_hit_radius = 190;
slam_damage = 52;

vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 4.0;

// After the vulnerability window closes, the boss idles for a moment before it can act
// again (ranged or melee) -- a guaranteed breather so a slam is never immediately chained
// into another slam check, even if the player stayed in melee_trigger_dist the whole time.
post_slam_recover = 1.3;
recover_timer = 0;

exp_reward = 300;
gold_reward = 25;

// IA Adaptativa: Carrega mutação de contra-ataque do General da Água
adaptation = adaptive_ai_get_boss_adaptation("water");
if (adaptation.active) {
    if (adaptation.extra_projectile_speed > 0) {
        projectile_speed += adaptation.extra_projectile_speed;
    }
}

state = "barrage";

// ---------------------------------------------------------------------
// REDESENHO: "TENIS GLACIAL"
// Mecanica central: o General lanca um ORBE GLACIAL lento. Rebata-o com qualquer
// ataque; se ele voltar e o General nao conseguir devolver, ele fica CONGELADO.
// Fase 1: nao devolve | Fase 2: devolve 1x + ONDA DE MARE | Fase 3: devolve 2x + ondas duplas
// Fora da janela recebe apenas 20% do dano.
// ---------------------------------------------------------------------
hp_max = 1400;
hp = hp_max;
boss_init_common(0.2);
orb_active = false;
orb_freeze_request = false;
orb_cooldown = 5.0;
orb_timer = 3.0;
orb_windup = 1.0;
orb_windup_timer = 0;
frozen_duration = 4.5;
slam_window = 2.0;
tide_cooldown = 9.0;
tide_timer = 2.0;
