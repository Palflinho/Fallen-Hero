// GDD: "ao chegar na sala do chefao, os pocos de lava comecam a subir e a diminuir de
// acordo com o tempo" -- always cycling, no button needed, independent of the boss fight.
base_size = 32;
is_up = false;
cycle_down_time = 3.0;
cycle_up_time = 2.2;
cycle_timer = random_range(0, cycle_down_time);
tick_damage = 8;
tick_interval = 0.5;
tick_timer = 0;
