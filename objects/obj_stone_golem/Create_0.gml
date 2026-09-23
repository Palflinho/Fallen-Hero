event_inherited();
elem_strip_elite();

// Mini-chefe da Sala Pre-Boss do Templo da Terra: GOLEM DE PEDRA
// Inempurravel. Armadura quebravel (postura): 6 golpes -> ARMADURA QUEBRADA (atordoado + vulneravel).
body_colour = make_colour_rgb(125, 100, 75);
body_radius = 34;
hp_max = 300;
hp = hp_max;
move_speed = 30;
contact_damage = 20;
knockback_resistance = 1.0;
vision_range = 9999;
vision_angle = 360;
patrol_radius = 0;
has_poise = false;
can_enrage = false;
exp_reward = 150;
gold_reward = 10;

armor_max = 6;
armor_hp = armor_max;
armor_regen_timer = 0;
armored_reduction = 0.35;
damage_reduction = armored_reduction;
last_hp = hp;
broken_timer = 0;

state = "walk";
attack_cooldown = 2.0;
attack_cooldown_timer = 1.5;
next_attack = "boulder";
windup_timer = 0;
recover_timer = 0;

// Onda de choque do pisao (anel que se expande)
ring_active = false;
ring_r = 0;
ring_max = 230;
ring_speed = 240;
ring_hit = false;
