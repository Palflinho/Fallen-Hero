event_inherited();

body_colour = make_colour_rgb(180, 245, 255);
hp_max = 44;
hp = hp_max;
move_speed = 78;
contact_damage = 8;
preferred_range = 160;
attack_range = 240;
attack_cooldown = 1.5;
attack_cooldown_timer = 0;
attack_windup = 0.28;
attack_windup_timer = 0;
projectile_damage = 9;
projectile_speed = 300;
state = "patrol";
vision_range = 280;
vision_angle = 110;
spider_sense_range = 85;
patrol_radius = 160;
exp_reward = 30;
gold_reward = 1;
knockback_resistance = 0.15;
anim_rot = 0;

// --- Elemental de Vento: teleporta quando o jogador se aproxima + bumerangues ---
attack_cooldown = 1.9;
blink_trigger = 75;
blink_cooldown = 0;
blink_recover = 0;
blink_from_x = x;
blink_from_y = y;
blink_fx_timer = 0;
recover_timer = 0;
