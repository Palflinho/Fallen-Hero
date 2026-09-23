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
var _t1_struct = get_talent_def_by_id(_t1_id);
if (_t1_struct != undefined) {
    _t1_label = talent_get_label(_t1_struct);
    _t1_desc = _t1_struct.desc_value;
}

var _t2_label = "Talento Arcano";
var _t2_desc = "Aprimoramento de combate.";
var _t2_struct = get_talent_def_by_id(_t2_id);
if (_t2_struct != undefined) {
    _t2_label = talent_get_label(_t2_struct);
    _t2_desc = _t2_struct.desc_value;
}

items = [
    // 0: Pocao Menor
    {
        name: "Frasco de Vida Menor",
        category: "Vitalidade",
        desc: "Restaura 35% da sua Vida Maxima imediatamente.",
        cost: 55,
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
        cost: 115,
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
        cost: 95,
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
        cost: 95,
        type: "talent",
        talent_id: _t2_id,
        purchased: false,
        icon_col: make_colour_rgb(180, 140, 255)
    }
];

// Chance de compra de pontos de talento na loja (entra no lugar de um talento)
// Quantidade varia de 2 a 5 pontos, custo minimo 100 e maximo 250
if (random(1) < 0.50) {
    var _pts = irandom_range(2, 5);
    var _pts_cost = round(lerp(100, 250, (_pts - 2) / 3));
    items[3] = {
        name: "Tomo de Talentos (+" + string(_pts) + " Pts)",
        category: "Pontos de Talento",
        desc: "Concede imediatamente +" + string(_pts) + " Ponto(s) de Talento para evoluir seus slots de talento.",
        cost: _pts_cost,
        type: "talent_points",
        amount: _pts,
        purchased: false,
        icon_col: c_yellow
    };
}

var _all_blessings = [
    {
        name: "Bencao da Forca",
        category: "Atributos",
        desc: "Concede +3 de Poder de Ataque permanente nesta run.",
        cost: 75,
        type: "stat_power",
        amount: 3,
        purchased: false,
        icon_col: c_orange
    },
    {
        name: "Bencao da Couraca",
        category: "Atributos",
        desc: "Concede +3 de Defesa (mitigacao direta) permanente nesta run.",
        cost: 75,
        type: "stat_def",
        amount: 3,
        purchased: false,
        icon_col: make_colour_rgb(100, 180, 255)
    },
    {
        name: "Bencao da Vitalidade",
        category: "Atributos",
        desc: "Concede +25 de Vida Maxima permanente nesta run.",
        cost: 65,
        type: "stat_hp",
        amount: 25,
        purchased: false,
        icon_col: c_red
    },
    {
        name: "Bencao da Agilidade",
        category: "Atributos",
        desc: "Concede +15 de Velocidade de Movimento permanente nesta run.",
        cost: 65,
        type: "stat_speed",
        amount: 15,
        purchased: false,
        icon_col: c_yellow
    }
];

// Embaralha e seleciona 1 ou 2 atributos por loja (com limite estrito de 1 compra)
var _indices = [0, 1, 2, 3];
for (var _i = 3; _i > 0; _i--) {
    var _j = irandom(_i);
    var _temp = _indices[_i];
    _indices[_i] = _indices[_j];
    _indices[_j] = _temp;
}
var _num_blessings = choose(1, 2);
for (var _b = 0; _b < _num_blessings; _b++) {
    array_push(items, _all_blessings[_indices[_b]]);
}
