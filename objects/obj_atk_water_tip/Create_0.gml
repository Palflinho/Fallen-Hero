// Ponta d'agua: golpe atrasado das classes corpo a corpo com Agua (Lanceiro, Rastreador).
// Vai so um pouco alem da arma (ver player_queue_water_tip).
owner = noone;
damage = 0;
life = 0.12;
life_max = life;
body_radius = 6;
dir = 0;
slow = false;
hit_group = { ids: [] }; // compartilhado entre as pontas do mesmo leque: cada inimigo leva 1 acerto
