// BONECO DE TREINO (vila). Nao morre, nao da XP/ouro e nao causa dano.
//  mode "static":   fica parado - ensina o ataque ([Z] Atacar).
//  mode "attacker": arma um golpe lento e visivel - ensina defesa/esquiva ([X]).
event_inherited();
elem_strip_elite();
is_training_dummy = true;
stats_scaled = true;
mode = "static";

hp_max = 9999;
hp = hp_max;
move_speed = 0;
move_speed_effective = 0;
contact_damage = 0;
exp_reward = 0;
gold_reward = 0;
knockback_resistance = 1.0;
has_poise = false;
can_enrage = false;
body_radius = 16;
element_type = "none";

swing_state = "idle";  // idle | windup | recover
swing_timer = 2.0;
swing_windup = 1.3;    // tempo de aviso antes do golpe
swing_radius = 90;
swing_angle = 0;
hits_taken = 0;
result_timer = 0;
result_ok = false;
