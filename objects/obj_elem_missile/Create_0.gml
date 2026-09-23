// Projeteis e efeitos atrasados dos inimigos elementais.
// kind: "bubble" | "fire_shot" | "boomerang" | "stake" | "meteor" | "ice_cross" | "boulder"
kind = "bubble";
owner = noone;
dir = 0;
spd = 100;
damage = 8;
colour = c_aqua;
origin_x = x;
origin_y = y;
target_x = x;
target_y = y;
radius = 8;
life = 6;
timer = 0;
phase = 0;
delay = 0;
hit_cd = 0;
draw_z = 0;
turn_rate = 70;      // bolha: graus/s de perseguicao
max_dist = 200;      // bumerangue: alcance de ida
flight_time = 0.8;   // pedregulho: tempo de voo
cell_step = 36;      // cruz de gelo: espacamento das celulas
cell_arm = 3;        // cruz de gelo: celulas por braco
anim_seed = random(1000);
