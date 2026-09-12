var _dt = delta_time / 1000000;
lantern_timer += _dt;
if (message_timer > 0) message_timer -= _dt;

var _player = instance_find(obj_player, 0);

if (!global.midrun_shop_open) {
    if (_player != noone && point_distance(x, y, _player.x, _player.y) <= interact_radius) {
        prompt_active = true;
        if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) {
            global.midrun_shop_open = true;
            selected_index = 0;
            message_text = "";
        }
    } else {
        prompt_active = false;
    }
    exit;
}

// Loja aberta
var _len = array_length(items);

if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    selected_index = (selected_index - 1 + _len) % _len;
} else if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    selected_index = (selected_index + 1) % _len;
} else if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
    selected_index = max(0, selected_index - 2);
} else if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
    selected_index = min(_len - 1, selected_index + 2);
}

if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("C"))) {
    global.midrun_shop_open = false;
    exit;
}

if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(ord("Z"))) {
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
        } else if (_it.type == "stat_power") {
            global.shop_boost_power += _it.amount;
            if (_player != noone) {
                player_recompute_attributes(_player);
                fx_spawn_damage_popup(_player.x, _player.y - 15, "+3 PODER!", true, c_orange);
            }
            message_text = "Poder aumentado em +3 permanentemente nesta run!";
            message_colour = c_orange;
            message_timer = 1.5;
        } else if (_it.type == "stat_def") {
            global.shop_boost_defesa += _it.amount;
            if (_player != noone) {
                player_recompute_attributes(_player);
                fx_spawn_damage_popup(_player.x, _player.y - 15, "+3 DEFESA!", true, c_aqua);
            }
            message_text = "Defesa aumentada em +3 permanentemente nesta run!";
            message_colour = c_aqua;
            message_timer = 1.5;
        } else if (_it.type == "stat_hp") {
            global.shop_boost_hp += _it.amount;
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
