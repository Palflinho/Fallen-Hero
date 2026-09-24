// Efeito de chao elemental temporario (circulo = area).
// kind: "slick" (gelo escorregadio), "fire" (chamas que queimam), "mist" (poeira/nevoa visual)
kind = "fire";
radius = 24;
life = 3;
life_max = 3;
damage = 5;
tick_interval = 0.5;
tick_timer = 0;
colour = c_orange;
anim_seed = random(1000);
depth = layer_get_depth(layer) + 20; // desenha sob os personagens
owner_obj = -1; // objeto de quem criou (estatisticas da partida)
