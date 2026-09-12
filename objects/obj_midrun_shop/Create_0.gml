interact_radius = 65;
prompt_active = false;
selected_index = 0;
global.midrun_shop_open = false;

lantern_timer = 0;
message_timer = 0;
message_text = "";
message_colour = c_white;

// Rolagem de talentos oferecidos para a run
var _t1_id = roll_chest_talent();
var _t2_id = roll_chest_talent();
if (_t2_id == _t1_id || _t2_id == "") {
    _t2_id = "general_vitalidade";
}

var _t1_label = "Talento Arcano";
var _t1_desc = "Aprimoramento de combate.";
var _t1_struct = talent_get_def(_t1_id);
if (_t1_struct != undefined) {
    _t1_label = _t1_struct.label;
    _t1_desc = _t1_struct.desc_value;
}

var _t2_label = "Talento Arcano";
var _t2_desc = "Aprimoramento de combate.";
var _t2_struct = talent_get_def(_t2_id);
if (_t2_struct != undefined) {
    _t2_label = _t2_struct.label;
    _t2_desc = _t2_struct.desc_value;
}

items = [
    // 0: Pocao Menor
    {
        name: "Frasco de Vida Menor",
        category: "Vitalidade",
        desc: "Restaura 35% da sua Vida Maxima imediatamente.",
        cost: 35,
        type: "heal",
        amount: 0.35,
        purchased: false,
        icon_col: c_lime
    },
    // 1: Pocao Maior
    {
        name: "Elixir da Vitalidade Plena",
        category: "Vitalidade",
        desc: "Restaura 80% da sua Vida Maxima imediatamente.",
        cost: 70,
        type: "heal",
        amount: 0.80,
        purchased: false,
        icon_col: make_colour_rgb(50, 240, 150)
    },
    // 2: Talento 1
    {
        name: _t1_label,
        category: "Talentos da Run",
        desc: _t1_desc,
        cost: 60,
        type: "talent",
        talent_id: _t1_id,
        purchased: false,
        icon_col: c_aqua
    },
    // 3: Talento 2
    {
        name: _t2_label,
        category: "Talentos da Run",
        desc: _t2_desc,
        cost: 60,
        type: "talent",
        talent_id: _t2_id,
        purchased: false,
        icon_col: make_colour_rgb(180, 140, 255)
    },
    // 4: Forca
    {
        name: "Bencao da Forca",
        category: "Atributos",
        desc: "Concede +3 de Poder de Ataque permanente nesta run.",
        cost: 45,
        type: "stat_power",
        amount: 3,
        purchased: false,
        icon_col: c_orange
    },
    // 5: Couraça
    {
        name: "Bencao da Couraca",
        category: "Atributos",
        desc: "Concede +3 de Defesa (mitigacao direta) permanente nesta run.",
        cost: 45,
        type: "stat_def",
        amount: 3,
        purchased: false,
        icon_col: make_colour_rgb(100, 180, 255)
    },
    // 6: Vitalidade Max
    {
        name: "Bencao da Vitalidade",
        category: "Atributos",
        desc: "Concede +25 de Vida Maxima permanente nesta run.",
        cost: 40,
        type: "stat_hp",
        amount: 25,
        purchased: false,
        icon_col: c_red
    },
    // 7: Agilidade
    {
        name: "Bencao da Agilidade",
        category: "Atributos",
        desc: "Concede +15 de Velocidade de Movimento permanente nesta run.",
        cost: 40,
        type: "stat_speed",
        amount: 15,
        purchased: false,
        icon_col: c_yellow
    }
];
