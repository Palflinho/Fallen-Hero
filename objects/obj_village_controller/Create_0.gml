// Paredes limítrofes da Vila
var _w_top = instance_create_layer(0, 0, "Instances", obj_wall);
if (_w_top != noone) { _w_top.image_xscale = 50; _w_top.image_yscale = 1; }

var _w_bot = instance_create_layer(0, 1168, "Instances", obj_wall);
if (_w_bot != noone) { _w_bot.image_xscale = 50; _w_bot.image_yscale = 1; }

var _w_lft = instance_create_layer(0, 0, "Instances", obj_wall);
if (_w_lft != noone) { _w_lft.image_xscale = 1; _w_lft.image_yscale = 37.5; }

var _w_rgt = instance_create_layer(1568, 0, "Instances", obj_wall);
if (_w_rgt != noone) { _w_rgt.image_xscale = 1; _w_rgt.image_yscale = 37.5; }

// Portal Dimensional ao Norte
portal_inst = instance_create_layer(800, 150, "Instances", obj_village_portal);

// Altar das Essências no Centro
altar_inst = instance_create_layer(800, 380, "Instances", obj_village_altar);

// 4 Pedestais de Troca de Classe no Pátio de Treino
var _ped_classes = ["knight", "mage", "archer", "assassin"];
var _ped_labels = ["Cavaleiro (Tatu)", "Maga (Lobo-Guara)", "Arqueiro (Lagarto)", "Assassino (Urutau)"];
var _ped_colors = [c_aqua, c_fuchsia, c_lime, c_gray];
var _ped_x = [470, 690, 910, 1130];

for (var i = 0; i < 4; i++) {
    var _ped = instance_create_layer(_ped_x[i], 640, "Instances", obj_village_pedestal);
    if (_ped != noone) {
        _ped.target_class = _ped_classes[i];
        _ped.class_label = _ped_labels[i];
        _ped.class_color = _ped_colors[i];
    }
}

// Boneco de Treino no Pátio Sul
dummy_inst = instance_create_layer(800, 880, "Instances", obj_training_dummy);

// Restaura vida e recursos do jogador ao chegar à Vila
var _p = instance_find(obj_player, 0);
if (instance_exists(_p)) {
    _p.hp = _p.hp_max;
    _p.invisible = false;
    _p.defend_timer = 0;
    _p.invulnerable_timer = 0;
}
