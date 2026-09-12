radius = 40;
target_room = Room2;
trigger_mode = "buttons"; // "buttons" | "boss_dead" | "clear_mobs" | "always_open"
reward_type = "boss"; // "gold" | "talent" | "heal" | "boss" | "victory"
reward_value = 40;
gate_label = "Santuario do Chefe";
gate_colour = make_colour_rgb(110, 210, 255);
sparkle_timer = 0;

if (room == Room1 || room == Room3 || room == Room5 || room == Room7) {
    trigger_mode = "buttons";
    gate_label = "Avanco: Exploracao 2 (Sala 2)";
    gate_colour = make_colour_rgb(110, 210, 255);
    reward_type = "gold";
    reward_value = 40;
} else if (room == asset_get_index("room_exp2")) {
    trigger_mode = "buttons";
    gate_label = "Desafio: A Arena Elemental (Sala 2.5)";
    gate_colour = make_colour_rgb(255, 180, 50);
    reward_type = "heal";
} else if (room == asset_get_index("room_shop")) {
    trigger_mode = "always_open";
    gate_label = "Avanco: Exploracao 3 (Sala 4)";
    gate_colour = c_aqua;
    reward_type = "heal";
} else if (room == asset_get_index("room_exp4")) {
    trigger_mode = "buttons";
    gate_label = "Desafio: O Santuario Pre-Chefe (Sala 5)";
    gate_colour = make_colour_rgb(200, 100, 255);
    reward_type = "talent";
} else if (room == asset_get_index("room_preboss")) {
    trigger_mode = "clear_mobs";
    gate_label = "Avanco: Camara do General (Chefe)";
    gate_colour = make_colour_rgb(230, 80, 255);
    reward_type = "boss";
    reward_value = 50;
}

