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
