// Sequencia final: revelacao do Salvador -> escolha do final -> epilogo -> creditos.
// Criado quando O Salvador cai (obj_enemy_parent).
state = "delay";        // delay | revelation | choice | epilogue | credits | finish
state_timer = 2.2;      // deixa a explosao do chefe terminar
cursor = 0;
options = ending_get_options();
chosen = "";
pages = [];
page_index = 0;
page_alpha = 0;
credits = ending_get_credits();
credits_y = 0;
credits_done_timer = 0;
fade = 0;
finished = false;
deny_timer = 0;
global.ending_active = false;
