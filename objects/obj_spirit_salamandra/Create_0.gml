event_inherited();
spirit_init("SALAMANDRA, ESPIRITO DO FOGO", "fire", 300);
body_radius = 18;
move_speed = 120;
contact_damage = 14;

// Corpo de serpente: historico de posicoes para desenhar os segmentos
trail_len = 48;
trail_x = array_create(trail_len, x);
trail_y = array_create(trail_len, y);
fire_drop_timer = 0;
wiggle = 0;
contact_cd = 0;
dive_count = 0;
next_move = "spit";
target_x = x;
target_y = y;
