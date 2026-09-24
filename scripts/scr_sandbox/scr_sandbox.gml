// =========================================================================
// SANDBOX DO DESENVOLVEDOR (room_sandbox)
// Sala livre para testar classes, talentos, inimigos, chefes, perigos,
// armadilhas e colisoes sem jogar a campanha. Entra pela tela inicial com o
// Modo Dev ligado ([F5] ou botao "Sandbox (Dev)").
// Nada do que acontece aqui e salvo (save_meta ignora enquanto sandbox_active).
// =========================================================================

function sandbox_enter() {
    global.sandbox_active = true;
    global.run_in_progress = true;
    global.inrun_saved_stats = false;
    global.use_saved_stats = false;
    if (!variable_global_exists("selected_character")) global.selected_character = "knight";
    if (!variable_global_exists("selected_element")) global.selected_element = "none";
    global.chosen_talent_ids = ["", "", ""];
    global.run_biome = "water";
    global.run_room_step = 1;
    global.boss_buttons_pressed = 0;
    global.dialogue_boss3_shown = true; // sem cutscene ao criar o Zephyrus
    run_stats_reset();
    room_goto(asset_get_index("room_sandbox"));
}

function sandbox_exit() {
    global.sandbox_active = false;
    global.run_in_progress = false;
    global.inrun_saved_stats = false;
    global.paused = false;
    global.char_select_direct = false;
    room_goto(room_char_select); // a tela inicial recarrega o meta do disco (descarta o sandbox)
}

// Catalogo do que pode ser colocado com o mouse
function sandbox_catalog(_tab) {
    switch (_tab) {
        case "enemies": return [
            {label: tr("Slime da Agua"), obj: "obj_slime"},
            {label: tr("Slime de Fogo"), obj: "obj_fire_slime"},
            {label: tr("Slime de Vento"), obj: "obj_wind_slime"},
            {label: tr("Slime de Terra"), obj: "obj_earth_slime"},
            {label: tr("Elemental da Agua"), obj: "obj_elemental"},
            {label: tr("Elemental de Fogo"), obj: "obj_fire_elemental"},
            {label: tr("Elemental de Vento"), obj: "obj_wind_elemental"},
            {label: tr("Elemental de Terra"), obj: "obj_earth_elemental"},
            {label: tr("Conjuradora de Gelo"), obj: "obj_frost_caster"},
            {label: tr("Conjuradora de Magma"), obj: "obj_magma_caster"},
            {label: tr("Conjuradora dos Ventos"), obj: "obj_wind_caster"},
            {label: tr("Conjuradora da Terra"), obj: "obj_earth_caster"},
            {label: tr("Golem de Gelo"), obj: "obj_ice_golem"},
            {label: tr("Golem de Lava"), obj: "obj_lava_golem"},
            {label: tr("Golem da Tempestade"), obj: "obj_storm_golem"},
            {label: tr("Golem de Pedra"), obj: "obj_stone_golem"},
            {label: tr("Totem Elemental"), obj: "obj_elem_totem"},
            {label: tr("Fogo-Fatuo"), obj: "obj_wisp"},
            {label: tr("Boneco de Treino (parado)"), obj: "obj_training_dummy", mode: "static"},
            {label: tr("Boneco de Treino (ataca)"), obj: "obj_training_dummy", mode: "attacker"}
        ];
        case "bosses": return [
            {label: tr("General da Água"), obj: "obj_boss"},
            {label: tr("General Magma"), obj: "obj_boss2"},
            {label: tr("General Zephyrus"), obj: "obj_boss3"},
            {label: tr("Tita Monolito"), obj: "obj_boss4"},
            {label: tr("O Salvador"), obj: "obj_boss_human"},
            {label: tr("Ondina"), obj: "obj_spirit_ondina"},
            {label: tr("Salamandra"), obj: "obj_spirit_salamandra"},
            {label: tr("Silfide"), obj: "obj_spirit_silfide"},
            {label: tr("Gnomo"), obj: "obj_spirit_gnomo"}
        ];
        case "props": return [
            {label: tr("Parede 64x64"), obj: "wall", w: 64, h: 64},
            {label: tr("Parede 192x32"), obj: "wall", w: 192, h: 32},
            {label: tr("Parede 32x192"), obj: "wall", w: 32, h: 192},
            {label: tr("Selo"), obj: "obj_boss_button"},
            {label: tr("Bau de Talento"), obj: "obj_chest"},
            {label: tr("Orbe de Cura"), obj: "obj_reward_heal"},
            {label: tr("Gelo Escorregadio"), obj: "obj_ice_patch"},
            {label: tr("Poca de Agua"), obj: "obj_water_puddle"},
            {label: tr("Poca de Lava"), obj: "obj_lava_pool"},
            {label: tr("Lava Ciclica"), obj: "obj_lava_pool_cycle"},
            {label: tr("Areia Movedica"), obj: "obj_mud_quicksand"},
            {label: tr("Ciclone"), obj: "obj_wind_cyclone"},
            {label: tr("Corrente de Vento"), obj: "obj_wind_stream"},
            {label: tr("Fissura da Terra"), obj: "obj_earth_fissure"},
            {label: tr("Armadilha de Espinhos"), obj: "obj_trap_spike"},
            {label: tr("Armadilha de Gas"), obj: "obj_trap_gas"},
            {label: tr("Esmagador"), obj: "obj_trap_crusher"},
            {label: tr("Armadilha de Dardos"), obj: "obj_trap_dart"}
        ];
    }
    return [];
}

// Coloca um item do catalogo em (_x, _y). Retorna a instancia criada (ou noone).
function sandbox_place(_item, _x, _y, _variant) {
    var _layer = layer_get_id("Instances");
    if (_layer == -1) _layer = layer_create(0, "Instances");

    if (_item.obj == "wall") {
        return dungeon_spawn_wall(_x - _item.w / 2, _y - _item.h / 2, _item.w, _item.h);
    }
    var _obj = asset_get_index(_item.obj);
    if (_obj == -1 || !object_exists(_obj)) return noone;

    var _inst = instance_create_layer(_x, _y, _layer, _obj);
    if (!instance_exists(_inst)) return noone;
    if (variable_struct_exists(_item, "mode")) _inst.mode = _item.mode;
    if (_item.obj == "obj_chest") {
        _inst.is_points = false;
        _inst.points_amount = 0;
        if (_inst.talent_id == "") _inst.talent_id = roll_chest_talent();
    }
    // Variante escolhida no painel (so inimigos comuns)
    if (object_is_ancestor(_obj, obj_enemy_parent) && !enemy_is_boss(_inst) && !variable_instance_exists(_inst, "is_training_dummy")) {
        if (_variant == "alpha") _inst.is_greater_variant = true;
        else if (_variant == "rare") { _inst.is_rare_mob = true; _inst.is_greater_variant = false; }
        else { _inst.is_rare_mob = false; _inst.is_greater_variant = false; _inst.elite_affix = "none"; _inst.bulwark_hits = 0; }
    }
    return _inst;
}

// Aplica nivel e talentos do sandbox ao heroi
function sandbox_apply_player(_p) {
    if (!instance_exists(_p)) return;
    _p.level = sandbox_level;
    _p.xp = 0;
    player_normalize_talent_slots(_p);
    for (var _i = 0; _i < TALENT_SLOTS_TOTAL; _i++) {
        var _id = sandbox_slots[_i];
        _p.talent_slot_ids[_i] = _id;
        _p.talent_slot_ranks[_i] = (_id != "") ? talent_get_max_rank(_id) : 0;
    }
    player_recompute_synthetics(_p);
    player_recompute_attributes(_p);
    _p.hp = _p.hp_max;
    _p.stats_hp_prev = _p.hp;
}

// Recria o heroi com a classe/elemento escolhidos (mantem a posicao)
function sandbox_respawn_player() {
    var _old = instance_find(obj_player, 0);
    var _x = (_old != noone) ? _old.x : room_width / 2;
    var _y = (_old != noone) ? _old.y : room_height / 2;
    global.selected_character = sandbox_class;
    global.selected_element = sandbox_element;
    global.chosen_talent_ids = ["", "", ""];
    global.inrun_saved_stats = false;
    global.use_saved_stats = false;
    with (obj_player) instance_destroy();
    var _layer = layer_get_id("Instances");
    if (_layer == -1) _layer = layer_create(0, "Instances");
    var _p = instance_create_layer(_x, _y, _layer, obj_player);
    sandbox_apply_player(_p);
}

// Pode ser apagado com o botao direito?
function sandbox_is_removable(_inst) {
    if (!instance_exists(_inst)) return false;
    var _o = _inst.object_index;
    if (_o == obj_player || _o == obj_hud || _o == obj_sandbox_controller) return false;
    if (_o == obj_wall) {
        // Nao apaga as paredes da borda da sala
        return !(_inst.bbox_left <= 0 || _inst.bbox_top <= 0 || _inst.bbox_right >= room_width - 1 || _inst.bbox_bottom >= room_height - 1);
    }
    return true;
}

// -------------------------------------------------------------------------
// PAINEL (roda no escopo do obj_sandbox_controller)
// -------------------------------------------------------------------------
function sandbox_row(_x1, _y1, _x2, _y2, _label, _action, _arg, _active) {
    return { x1: _x1, y1: _y1, x2: _x2, y2: _y2, label: _label, action: _action, arg: _arg,
             active: _active, visible: true, centered: false, header_col: make_colour_rgb(150, 190, 230) };
}

function sandbox_build_panel() {
    panel_rows = [];
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _x1 = _gw - panel_w + 10;
    var _x2 = _gw - 10;
    var _w = _x2 - _x1;

    // Titulo
    var _t = sandbox_row(_x1, 6, _x2, 28, tr("SANDBOX (DEV)"), "", 0, false);
    _t.header_col = c_yellow;
    array_push(panel_rows, _t);

    // Abas
    var _tabs = ["hero", "enemies", "bosses", "props", "talents"];
    var _tab_names = [tr("Heroi"), tr("Inimigos"), tr("Chefes"), tr("Cenario"), tr("Talentos")];
    var _tw = (_w - 4 * 4) / 5;
    for (var _i = 0; _i < 5; _i++) {
        var _bx = _x1 + _i * (_tw + 4);
        var _tr = sandbox_row(_bx, 32, _bx + _tw, 58, _tab_names[_i], "tab", _tabs[_i], tab == _tabs[_i]);
        _tr.centered = true;
        array_push(panel_rows, _tr);
    }

    // Rodape fixo
    var _foot = [
        [god_mode ? tr("Vida infinita: LIGADA") : tr("Vida infinita: DESLIGADA"), "god"],
        [show_collisions ? tr("Colisoes: LIGADAS [F7]") : tr("Colisoes: DESLIGADAS [F7]"), "collide"],
        [tr("Remover inimigos"), "kill"],
        [tr("Limpar cenario"), "clear"],
        [tr("Sair do sandbox"), "exit"]
    ];
    var _foot_top = _gh - array_length(_foot) * 28 - 8;
    for (var _f = 0; _f < array_length(_foot); _f++) {
        var _fy = _foot_top + _f * 28;
        var _fr = sandbox_row(_x1, _fy, _x2, _fy + 24, _foot[_f][0], _foot[_f][1], 0, false);
        _fr.centered = true;
        array_push(panel_rows, _fr);
    }

    // Conteudo da aba (rolavel)
    var _top = 66;
    var _bottom = _foot_top - 6;
    var _y = _top - scroll;
    var _rh = 24;
    var _gap = 3;
    var _content = [];

    switch (tab) {
        case "hero":
            array_push(_content, ["h", tr("CLASSE")]);
            var _cls = ["knight", "mage", "archer", "assassin"];
            var _cls_n = [tr("Cavaleiro"), tr("Mago"), tr("Arqueiro"), tr("Assassino")];
            for (var _c = 0; _c < 4; _c++) array_push(_content, ["r", _cls_n[_c], "class", _cls[_c], sandbox_class == _cls[_c]]);
            array_push(_content, ["h", tr("ELEMENTO (ESPECIALIZACAO)")]);
            var _els = ["none", "water", "fire", "wind", "earth"];
            for (var _e = 0; _e < 5; _e++) {
                var _lbl = element_get_name(_els[_e]) + "  -  " + class_get_archetype_name(sandbox_class, _els[_e]);
                array_push(_content, ["r", _lbl, "element", _els[_e], sandbox_element == _els[_e]]);
            }
            array_push(_content, ["h", tr("NIVEL")]);
            array_push(_content, ["r", "<  " + tr("Nivel ") + string(sandbox_level) + "  >   " + tr("(esq. -, dir. +)"), "level", 0, false]);
            array_push(_content, ["r", tr("+10 pontos de talento"), "points", 0, false]);
            array_push(_content, ["r", tr("Curar"), "heal", 0, false]);
            array_push(_content, ["h", tr("ESCALA DOS INIMIGOS (TEMPLO)")]);
            var _bs = ["water", "fire", "wind", "earth"];
            for (var _b = 0; _b < 4; _b++) array_push(_content, ["r", element_get_name(_bs[_b]), "biome", _bs[_b], global.run_biome == _bs[_b]]);
            break;

        case "enemies":
        case "bosses":
        case "props":
            if (tab == "enemies") {
                array_push(_content, ["h", tr("VARIANTE")]);
                array_push(_content, ["r", tr("Normal"), "variant", "normal", variant == "normal"]);
                array_push(_content, ["r", tr("Alfa (maior)"), "variant", "alpha", variant == "alpha"]);
                array_push(_content, ["r", tr("Campeao Raro"), "variant", "rare", variant == "rare"]);
            }
            array_push(_content, ["h", tr("CLIQUE E COLOQUE COM O MOUSE")]);
            var _cat = sandbox_catalog(tab);
            for (var _k = 0; _k < array_length(_cat); _k++) {
                var _sel = !is_undefined(tool) && tool.label == _cat[_k].label;
                array_push(_content, ["r", _cat[_k].label, "tool", _cat[_k], _sel]);
            }
            break;

        case "talents":
            array_push(_content, ["h", tr("SLOTS (clique para escolher)")]);
            for (var _s = 0; _s < TALENT_SLOTS_TOTAL; _s++) {
                var _sid = sandbox_slots[_s];
                var _sdef = (_sid != "") ? get_talent_def_by_id(_sid) : undefined;
                var _sname = is_undefined(_sdef) ? tr("(vazio)") : talent_get_label(_sdef);
                array_push(_content, ["r", tr("Slot ") + string(_s + 1) + ": " + _sname, "slot", _s, sandbox_slot_sel == _s]);
            }
            array_push(_content, ["r", tr("Esvaziar slot escolhido"), "slot_clear", 0, false]);
            array_push(_content, ["h", tr("TALENTOS (rank maximo)")]);
            var _list = get_talents_for_character(sandbox_class);
            var _gen = get_general_talent_defs();
            for (var _g = 0; _g < array_length(_gen); _g++) array_push(_list, _gen[_g]);
            for (var _t2 = 0; _t2 < array_length(_list); _t2++) {
                var _def = _list[_t2];
                var _aff = (_def.character == "general") ? tr("Geral") : element_get_name(_def.affinity);
                if (_def.affinity == "hybrid") _aff = tr("Hibrido");
                if (_def.affinity == "legendary") _aff = tr("Lendario");
                var _equipped = talent_list_has(sandbox_slots, _def.id);
                array_push(_content, ["r", talent_get_label(_def) + "  [" + _aff + "]", "talent", _def.id, _equipped]);
            }
            break;
    }

    var _total = 0;
    for (var _n = 0; _n < array_length(_content); _n++) {
        var _it = _content[_n];
        var _row;
        if (_it[0] == "h") {
            _row = sandbox_row(_x1, _y, _x2, _y + 20, _it[1], "", 0, false);
            _y += 20 + _gap;
            _total += 20 + _gap;
        } else {
            _row = sandbox_row(_x1, _y, _x2, _y + _rh, _it[1], _it[2], _it[3], _it[4]);
            _y += _rh + _gap;
            _total += _rh + _gap;
        }
        _row.visible = (_row.y1 >= _top && _row.y2 <= _bottom);
        array_push(panel_rows, _row);
    }
    scroll_max = max(0, _total - (_bottom - _top));
    scroll = clamp(scroll, 0, scroll_max);
}

function sandbox_panel_action(_r, _gx) {
    var _p = instance_find(obj_player, 0);
    switch (_r.action) {
        case "tab":
            tab = _r.arg;
            scroll = 0;
            break;
        case "class":
            sandbox_class = _r.arg;
            sandbox_slots = array_create(TALENT_SLOTS_TOTAL, ""); // talentos sao da classe
            sandbox_respawn_player();
            break;
        case "element":
            sandbox_element = _r.arg;
            sandbox_respawn_player();
            break;
        case "level":
            if (_gx < (_r.x1 + _r.x2) / 2) sandbox_level = max(1, sandbox_level - 1);
            else sandbox_level = min(40, sandbox_level + 1);
            if (_p != noone) sandbox_apply_player(_p);
            break;
        case "points":
            if (_p != noone) _p.talent_pending_points += 10;
            break;
        case "heal":
            if (_p != noone) _p.hp = _p.hp_max;
            break;
        case "biome":
            global.run_biome = _r.arg;
            toast_text = tr("Novos inimigos usarao a escala do templo: ") + element_get_name(_r.arg);
            toast_timer = 2.5;
            break;
        case "variant":
            variant = _r.arg;
            break;
        case "tool":
            tool = _r.arg;
            break;
        case "slot":
            sandbox_slot_sel = _r.arg;
            break;
        case "slot_clear":
            sandbox_slots[sandbox_slot_sel] = "";
            if (_p != noone) sandbox_apply_player(_p);
            break;
        case "talent":
            // Nao repete o mesmo talento em dois slots
            for (var _i = 0; _i < TALENT_SLOTS_TOTAL; _i++) if (sandbox_slots[_i] == _r.arg) sandbox_slots[_i] = "";
            sandbox_slots[sandbox_slot_sel] = _r.arg;
            sandbox_slot_sel = min(TALENT_SLOTS_TOTAL - 1, sandbox_slot_sel + 1);
            if (_p != noone) sandbox_apply_player(_p);
            break;
        case "god":
            god_mode = !god_mode;
            break;
        case "collide":
            show_collisions = !show_collisions;
            break;
        case "kill":
            with (obj_enemy_parent) if (!variable_instance_exists(id, "is_training_dummy")) instance_destroy();
            with (obj_boss_drone) instance_destroy();
            break;
        case "clear":
            with (all) {
                if (!sandbox_is_removable(id)) continue;
                if (object_is_ancestor(object_index, obj_enemy_parent) || object_index == obj_enemy_parent) continue;
                instance_destroy();
            }
            break;
        case "exit":
            sandbox_exit();
            break;
    }
}
