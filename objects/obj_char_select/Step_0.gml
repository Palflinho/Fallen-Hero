switch (state) {
    case "select":
        var _n = array_length(classes);

        if (keyboard_check_pressed(vk_right)) selected_index = (selected_index + 1) mod _n;
        if (keyboard_check_pressed(vk_left)) selected_index = (selected_index - 1 + _n) mod _n;

        if (keyboard_check_pressed(ord("Z"))) {
            var _character = classes[selected_index];
            var _all = get_talents_for_character(_character);
            var _unlocked = [];
            for (var i = 0; i < array_length(_all); i++) {
                if (talent_is_unlocked(_all[i].id)) array_push(_unlocked, _all[i]);
            }
            talent_select_list = _unlocked;
            talent_select_cursor = 0;
            talent_selected_ids = [];
            state = "select_talents";
        }

        if (global.has_save && keyboard_check_pressed(ord("C"))) {
            goto_checkpoint();
        }

        if (keyboard_check_pressed(ord("S"))) {
            shop_tab_index = selected_index;
            shop_talent_index = 0;
            state = "shop";
        }
        break;

    case "select_talents":
        var _m = array_length(talent_select_list);

        if (_m > 0) {
            if (keyboard_check_pressed(vk_down)) talent_select_cursor = (talent_select_cursor + 1) mod _m;
            if (keyboard_check_pressed(vk_up)) talent_select_cursor = (talent_select_cursor - 1 + _m) mod _m;

            if (keyboard_check_pressed(vk_space)) {
                var _id = talent_select_list[talent_select_cursor].id;
                var _idx = -1;
                for (var i = 0; i < array_length(talent_selected_ids); i++) {
                    if (talent_selected_ids[i] == _id) {
                        _idx = i;
                        break;
                    }
                }
                if (_idx >= 0) {
                    array_delete(talent_selected_ids, _idx, 1);
                } else if (array_length(talent_selected_ids) < 3) {
                    array_push(talent_selected_ids, _id);
                }
            }
        }

        if (keyboard_check_pressed(ord("Z"))) {
            global.selected_character = classes[selected_index];
            global.use_saved_stats = false;

            global.chosen_talent_ids = ["", "", ""];
            for (var i = 0; i < array_length(talent_selected_ids); i++) {
                global.chosen_talent_ids[i] = talent_selected_ids[i];
            }

            save_checkpoint_fresh(global.selected_character, "Room1");
            room_goto(Room1);
        }

        if (keyboard_check_pressed(ord("X"))) {
            state = "select";
        }
        break;

    case "shop":
        var _cn = array_length(classes);
        if (keyboard_check_pressed(vk_right)) {
            shop_tab_index = (shop_tab_index + 1) mod _cn;
            shop_talent_index = 0;
        }
        if (keyboard_check_pressed(vk_left)) {
            shop_tab_index = (shop_tab_index - 1 + _cn) mod _cn;
            shop_talent_index = 0;
        }

        var _tab_talents = get_talents_for_character(classes[shop_tab_index]);
        var _tn = array_length(_tab_talents);
        if (_tn > 0) {
            if (keyboard_check_pressed(vk_down)) shop_talent_index = (shop_talent_index + 1) mod _tn;
            if (keyboard_check_pressed(vk_up)) shop_talent_index = (shop_talent_index - 1 + _tn) mod _tn;

            if (keyboard_check_pressed(ord("Z"))) {
                talent_purchase(_tab_talents[shop_talent_index].id);
            }
        }

        if (keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_escape)) {
            state = "select";
        }
        break;
}
