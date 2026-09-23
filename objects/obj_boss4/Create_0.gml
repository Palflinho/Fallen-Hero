event_inherited();

// Sincroniza a arquitetura do chefe com o layout sorteado para a arena deste templo
var _layout = arena_ensure_temple_layout("earth");
arena_setup_chamber(_layout, true, "earth");

body_colour = make_colour_rgb(130, 95, 60);
body_radius = 54;
hp_max = 2900;
hp = hp_max;
move_speed = 36;
contact_damage = 44;

// Imune por padrão -- só recebe dano na janela de vulnerabilidade (Filosofia Sakurai)
damage_reduction = 0;
knockback_resistance = 1.0;

vision_range = 9999;
vision_angle = 360;

state = "chase"; // "chase" | "windup" | "vulnerable" | "recover"
stomp_cooldown = 2.4;
stomp_cooldown_timer = 1.5;
stomp_windup = 1.0;
stomp_windup_timer = 0;
stomp_hit_radius = 160;
stomp_damage = 64;
stomp_count = 0;
max_stomps = 2;

boulder_timer = 1.2;

vulnerable = false;
vulnerable_timer = 0;
vulnerable_duration = 3.8;

exp_reward = 600;
gold_reward = 60;

// ---------------------------------------------------------------------
// REDESENHO: "COSTAS EXPOSTAS"
// Mecanica central: a FRENTE e blindada (golpes ricocheteiam). O NUCLEO fica nas
// COSTAS e ele gira devagar para te encarar - rodeie-o! O PISAO o prende ao chao:
// a couraca inteira se abre (janela de dano).
// Fase 2: gira mais rapido, ergue muralhas atras de si e arremessa pedregulhos.
// Fase 3: gira ainda mais rapido e da um GIRO DE 360 se voce ficar nas costas.
// ---------------------------------------------------------------------
hp_max = 2400;
hp = hp_max;
boss_init_common(0.55);        // dano nas costas fora da janela
fh_shell_hits = 99999;         // frente sempre blindada
fh_shell_arc = 100;            // 200 graus de frente, 160 de costas
turn_rates = [70, 70, 100, 135];
attack_cd = 1.5;
stomp_cd = 3.0;
behind_timer = 0;
sweep_radius = 175;
sweep_arc = 70;
sweep_windup = 0.7;
spin_radius = 150;
stuck_duration = 3.2;
action_timer = 0;
throw_toggle = false;
ring_active = false;
ring_r = 0;
ring_max = 340;
ring_hit = false;

// IA Adaptativa: o General aprende contra a classe que o derrotou nas ultimas runs
adaptation = adaptive_ai_get_boss_adaptation("earth");
