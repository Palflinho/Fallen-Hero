var _dt = delta_time / 1000000;
lantern_timer += _dt;
if (message_timer > 0) message_timer -= _dt;

var _player = instance_find(obj_player, 0);

if (!global.midrun_shop_open) {
    if (_player != noone && point_distance(x, y, _player.x, _player.y) <= interact_radius) {
        prompt_active = true;
        var _touch_open = touch_room_clicked(x - 50, y - 60, x + 50, y + 40);
        if (input_check_ui_confirm() || _touch_open) {
            selected_index = 0;
            message_text = "";
            if (!variable_global_exists("dialogue_shop_shown") || !global.dialogue_shop_shown) {
                global.dialogue_shop_shown = true;
                if (room == asset_get_index("room_temple5_shop")) {
                    dialogue_play_id("temple5_shop_intro", function() {
                        global.midrun_shop_open = true;
                    });
                } else {
                    var _cls = (_player != noone) ? _player.character_class : "knight";
                    dialogue_start(dialogue_get_shop_lines(_cls), function() {
                        global.midrun_shop_open = true;
                    });
                }
            } else {
                global.midrun_shop_open = true;
            }
        }
    } else {
        prompt_active = false;
    }
    exit;
}

// Loja aberta
var _len = array_length(items);
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _box_w = 740;
var _box_h = 460;
var _bx = (_gw - _box_w) / 2;
var _by = (_gh - _box_h) / 2;
var _col_w = (_box_w - 70) / 2;
var _item_h = 48;
var _start_y = _by + 60;

var _touch_buy = false;

// Toque direto nos itens da loja
for (var _i = 0; _i < _len; _i++) {
    var _col = (_i >= 4) ? 1 : 0;
    var _row = (_i >= 4) ? (_i - 4) : _i;
    var _ix = _bx + 30 + _col * (_col_w + 10);
    var _iy = _start_y + _row * (_item_h + 8);

    if (touch_gui_clicked(_ix, _iy, _ix + _col_w, _iy + _item_h)) {
        if (selected_index == _i) {
            _touch_buy = true;
        } else {
            selected_index = _i;
        }
    }
}

// Botão de fechar [X] no topo ou toque fora da loja
if (touch_gui_clicked(_bx + _box_w - 44, _by + 10, _bx + _box_w - 12, _by + 40)
    || touch_gui_clicked(_bx + 30, _by + _box_h - 40, _bx + 160, _by + _box_h - 10)) {
    global.midrun_shop_open = false;
    exit;
}

// Botão [ Comprar ] no rodapé
if (touch_gui_clicked(_bx + _box_w - 190, _by + _box_h - 40, _bx + _box_w - 30, _by + _box_h - 10)) {
    _touch_buy = true;
}

if (input_check_ui_up_pressed()) {
    selected_index = (selected_index - 1 + _len) % _len;
} else if (input_check_ui_down_pressed()) {
    selected_index = (selected_index + 1) % _len;
} else if (input_check_ui_left_pressed()) {
    selected_index = max(0, selected_index - 2);
} else if (input_check_ui_right_pressed()) {
    selected_index = min(_len - 1, selected_index + 2);
}

if (input_check_ui_cancel() || keyboard_check_pressed(ord("C"))) {
    global.midrun_shop_open = false;
    exit;
}

if (input_check_ui_confirm() || _touch_buy) {
    var _it = items[selected_index];

    if (_it.purchased) {
        message_text = "Item unico ja adquirido nesta parada!";
        message_colour = c_orange;
        message_timer = 1.5;
    } else if (global.gold < _it.cost) {
        message_text = "Ouro insuficiente! Necessario: " + string(_it.cost) + " Ouro";
        message_colour = c_red;
        message_timer = 1.5;
    } else {
        global.gold -= _it.cost;
        fx_spawn_sparks(x, y, c_yellow, 12);

        if (_it.type == "heal") {
            if (_player != noone) {
                var _heal_val = round(_player.hp_max * _it.amount);
                _player.hp = min(_player.hp_max, _player.hp + _heal_val);
                fx_spawn_sparks(_player.x, _player.y, c_lime, 15);
                fx_spawn_damage_popup(_player.x, _player.y - 15, "CURA +" + string(_heal_val) + " HP", false, c_lime);
            }
            message_text = "Vida restaurada com sucesso!";
            message_colour = c_lime;
            message_timer = 1.5;
        } else if (_it.type == "talent") {
            _it.purchased = true;
            if (_player != noone) {
                open_chest_reward(_it.talent_id);
                global.midrun_shop_open = false;
                exit;
            }
        } else if (_it.type == "talent_points") {
            _it.purchased = true;
            if (_player != noone) {
                _player.talent_pending_points += _it.amount;
                fx_spawn_sparks(_player.x, _player.y, c_yellow, 20);
                fx_spawn_damage_popup(_player.x, _player.y - 15, "+" + string(_it.amount) + " PONTOS DE TALENTO!", true, c_yellow);
            }
            message_text = "Adquiriu +" + string(_it.amount) + " Ponto(s) de Talento!";
            message_colour = c_yellow;
            message_timer = 2.0;
        } else if (_it.type == "stat_power") {
            global.shop_boost_power += _it.amount;
            _it.purchased = true;
            if (_player != noone) {
                player_recompute_attributes(_player);
                fx_spawn_damage_popup(_player.x, _player.y - 15, "+3 PODER!", true, c_orange);
            }
            message_text = "Poder aumentado em +3 permanentemente nesta run!";
            message_colour = c_orange;
            message_timer = 1.5;
        } else if (_it.type == "stat_def") {
            global.shop_boost_defesa += _it.amount;
            _it.purchased = true;
            if (_player != noone) {
                player_recompute_attributes(_player);
                fx_spawn_damage_popup(_player.x, _player.y - 15, "+3 DEFESA!", true, c_aqua);
            }
            message_text = "Defesa aumentada em +3 permanentemente nesta run!";
            message_colour = c_aqua;
            message_timer = 1.5;
        } else if (_it.type == "stat_hp") {
            global.shop_boost_hp += _it.amount;
            _it.purchased = true;
            if (_player != noone) {
                player_recompute_attributes(_player);
                _player.hp += _it.amount;
                fx_spawn_damage_popup(_player.x, _player.y - 15, "+25 HP MAX!", true, c_red);
            }
            message_text = "Vida Maxima aumentada em +25 nesta run!";
            message_colour = c_red;
            message_timer = 1.5;
        } else if (_it.type == "stat_speed") {
            global.shop_boost_speed += _it.amount;
            _it.purchased = true;
            if (_player != noone) {
                player_recompute_attributes(_player);
                fx_spawn_damage_popup(_player.x, _player.y - 15, "+15 VELOCIDADE!", true, c_yellow);
            }
            message_text = "Velocidade de movimento aumentada em +15!";
            message_colour = c_yellow;
            message_timer = 1.5;
        }
    }
}
