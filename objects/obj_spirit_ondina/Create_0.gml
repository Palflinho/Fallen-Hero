event_inherited();
spirit_init(tr("ONDINA, ESPIRITO DA AGUA"), "water", 380);
body_radius = 20;
move_speed = 70;
contact_damage = 12;

is_clone = false;
master = noone;
clone_life = 0;
clone_cd = 3.0;
heal_cd = 6.0;
heal_timer = 0;
heal_tick = 0;
heal_dmg_taken = 0;
last_hp = hp_max;
orbit_side = choose(-1, 1);
