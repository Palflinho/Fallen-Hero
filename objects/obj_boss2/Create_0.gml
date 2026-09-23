event_inherited();

// Sincroniza a arquitetura do chefe com o layout sorteado para a arena deste templo
var _layout = arena_ensure_temple_layout("fire");
arena_setup_chamber(_layout, true, "fire");

// General Magma -- Mestre das Chamas e Erupções
body_colour = c_red;
body_radius = 62;
hp_max = 1500;
hp = hp_max;
move_speed = 36;
contact_damage = 36;

// Invulneravel fora da janela de vulnerabilidade; toma 125% em Superaquecimento!
damage_reduction = 0;
knockback_resistance = 1.0;

vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
facing_dir = 180;

state = "chase";
combo_cycle = 0;

// 1. Erupção de Magma (Meteoro Triplo)
erupcao_timer = 0;
erupcao_telegraph = 0.9;
erupcao_targets_x = [0, 0, 0, 0, 0];
erupcao_targets_y = [0, 0, 0, 0, 0];
erupcao_count = 3;
erupcao_radius = 60;
erupcao_damage = 44;

// 2. Carga Vulcânica
charge_windup = 0.50;
charge_windup_timer = 0;
charge_timer = 0;
charge_vx = 0;
charge_vy = 0;
charge_damage = 52;

// 3. Superaquecimento (Janela de Vulnerabilidade Única)
vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 3.8;

// Repouso e recarga
recover_timer = 0;
attack_cooldown_timer = 1.0;

exp_reward = 450;
gold_reward = 35;

// ---------------------------------------------------------------------
// REDESENHO: "TOURO DE MAGMA"
// Mecanica central: a INVESTIDA so para quando bate em algo. Desvie no ultimo
// instante e deixe-o se chocar contra a parede -> CROSTA RACHADA (janela de dano).
// Se a investida acertar voce, ele nao fica exposto.
// Fase 2: rastro de fogo na investida + leque de magma + pedras caem ao se chocar.
// Fase 3: ricocheteia uma vez na parede antes de ficar exposto; 5 erupcoes.
// ---------------------------------------------------------------------
hp_max = 1600;
hp = hp_max;
boss_init_common(0.2);
charge_speed = 560;
charge_max_time = 1.7;
charge_dir = 0;
charge_hit = false;
crash_duration = 4.0;
rebound_done = false;
fire_trail_timer = 0;
attack_order = 0;

// IA Adaptativa: o General aprende contra a classe que o derrotou nas ultimas runs
adaptation = adaptive_ai_get_boss_adaptation("fire");
