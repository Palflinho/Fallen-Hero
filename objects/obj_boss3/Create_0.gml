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
