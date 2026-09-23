event_inherited();

// Sincroniza a arquitetura do chefe com o layout sorteado para a arena deste templo
var _layout = arena_ensure_temple_layout("wind");
arena_setup_chamber(_layout, true, "wind");

body_colour = make_colour_rgb(180, 245, 255);
body_radius = 46;
hp_max = 1000;
hp = hp_max;
move_speed = 65;
contact_damage = 28;

// Imune quase totalmente durante voo de ataque; vulnerabilidade total após o ciclo de dashes
damage_reduction = 0;
knockback_resistance = 0.85;

vision_range = 9999;
vision_angle = 360;

state = "chase";
attack_cooldown_timer = 1.0;
attack_cooldown = 2.0;
dash_windup_timer = 0;
dash_windup = 0.42;
dash_vx = 0;
dash_vy = 0;

dash_count = 0;
dash_max = 3;

vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 3.5;

rot_angle = 0;
exp_reward = 350;
gold_reward = 45;

// ---------------------------------------------------------------------
// REDESENHO: "CEU E CHAO"
// Mecanica central: no AR ele e intangivel (so a sombra fica no chao) e dispara penas.
// Depois marca o jogador com a SOMBRA e MERGULHA. Ao pousar do ultimo mergulho
// as asas ficam PRESAS NO CHAO -> janela de dano.
// Fase 1: 1 mergulho | Fase 2: 2 mergulhos + ciclones | Fase 3: 3 mergulhos + vendavais.
// ---------------------------------------------------------------------
hp_max = 1300;
hp = hp_max;
boss_init_common(0.2);
state = "liftoff";
state_timer = 0.8;
air_height = 90;
air_time = 5.0;
feather_timer = 1.4;
orbit_side = choose(-1, 1);
dive_x = x;
dive_y = y;
dives_left = 0;
dive_radius = 72;
dive_damage = 38;
grounded_duration = 3.5;
gust_timer = 4.0;
gust_active = 0;
gust_dir = 0;

// IA Adaptativa: o General aprende contra a classe que o derrotou nas ultimas runs
adaptation = adaptive_ai_get_boss_adaptation("wind");
