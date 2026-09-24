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
// Orbe Glacial (General da Agua): rebatido entre jogador e chefe
heading = 0;         // 0 = indo ao jogador, 1 = voltando ao chefe
returns = 0;         // quantas vezes o chefe ja devolveu
max_returns = 0;
// Onda de mare (General da Agua): faixa que varre a arena com uma brecha
wave_vertical = true; // true = faixa vertical que anda na horizontal
wave_pos = 0;
wave_sign = 1;
gap_center = 0;
gap_size = 120;
hit_done = false;
owner_obj = -1; // objeto de quem criou (estatisticas da partida)
