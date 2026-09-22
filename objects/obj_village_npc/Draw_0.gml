var _t = current_time * 0.001;
var _player = instance_find(obj_player, 0);

// -------------------------------------------------------------------------
// 1. Sombra Suave no Chão
// -------------------------------------------------------------------------
draw_set_colour(c_black);
draw_set_alpha(0.35);
draw_ellipse(x - 11, y + 6, x + 11, y + 12, false);
draw_set_alpha(1.0);

var _breath = sin(_t * 3.5 + anim_timer) * 1.0;

// -------------------------------------------------------------------------
// 2. Sprite Procedural Chibi da Fauna Brasileira
// -------------------------------------------------------------------------
switch (npc_id) {
    // =====================================================================
    // A. MESTRE CARAPÁCIO (Tatu-Bola Ferreiro)
    // =====================================================================
    case "blacksmith":
        // Carapaça marrom robusta
        draw_set_colour(make_colour_rgb(115, 85, 60));
        draw_circle(x - 2, y - 6 + _breath, 11, false);
        draw_set_colour(make_colour_rgb(75, 55, 40));
        draw_arc_sim(x - 2, y - 6 + _breath, 11, -1);

        // Avental de couro de ferreiro
        draw_set_colour(make_colour_rgb(60, 42, 28));
        draw_rectangle(x - 6, y - 4, x + 6, y + 7, false);

        // Cabeça com focinho de tatu
        draw_set_colour(make_colour_rgb(140, 105, 75));
        draw_circle(x + 2, y - 10 + _breath, 7, false);

        // Bigode grisalho de ferreiro
        draw_set_colour(make_colour_rgb(220, 220, 230));
        draw_line(x + 3, y - 8 + _breath, x + 8, y - 6 + _breath);

        // Olho focado
        draw_set_colour(c_black);
        draw_circle(x + 4, y - 11 + _breath, 1.5, false);

        // Martelo de forja na mão
        draw_set_colour(make_colour_rgb(100, 70, 45));
        draw_line_width(x + 8, y - 4 + _breath, x + 8, y + 6 + _breath, 2);
        draw_set_colour(make_colour_rgb(50, 55, 65));
        draw_rectangle(x + 5, y - 8 + _breath, x + 12, y - 4 + _breath, false);
        break;

    // =====================================================================
    // B. CURANDEIRA KALINA (Lobo-Guará Alquimista)
    // =====================================================================
    case "alchemist":
        // Corpo esguio com manto xamânico verde-musgo
        draw_set_colour(make_colour_rgb(45, 80, 55));
        draw_triangle(x, y - 14 + _breath, x - 8, y + 7, x + 8, y + 7, false);

        // Cabeça de Lobo-Guará (Laranja-avermelhado)
        draw_set_colour(make_colour_rgb(215, 95, 40));
        draw_circle(x, y - 12 + _breath, 7.5, false);

        // Orelhas longas com ponta preta
        draw_set_colour(make_colour_rgb(25, 25, 30));
        draw_triangle(x - 6, y - 16 + _breath, x - 2, y - 14 + _breath, x - 7, y - 24 + _breath, false);
        draw_triangle(x + 6, y - 16 + _breath, x + 2, y - 14 + _breath, x + 7, y - 24 + _breath, false);

        // Focinho afilado com nariz preto
        draw_set_colour(make_colour_rgb(230, 130, 75));
        draw_circle(x + 3, y - 10 + _breath, 3.5, false);
        draw_set_colour(c_black);
        draw_circle(x + 5, y - 10 + _breath, 1.2, false);

        // Olhos âmbar bondosos
        draw_set_colour(make_colour_rgb(255, 200, 50));
        draw_circle(x + 2, y - 13 + _breath, 1.8, false);
        draw_set_colour(c_black);
        draw_circle(x + 2.5, y - 13 + _breath, 0.9, false);

        // Bolsa de ervas com frasco brilhante na cintura
        draw_set_colour(make_colour_rgb(75, 50, 30));
        draw_circle(x - 5, y + 1, 3.5, false);
        draw_set_colour(make_colour_rgb(80, 240, 180));
        draw_circle(x - 4, y + 1, 1.8, false);
        break;

    // =====================================================================
    // C. RASTREADOR TICO (Lagarto Teiú Batedor)
    // =====================================================================
    case "scout":
        // Cauda musculosa com listras
        draw_set_colour(make_colour_rgb(45, 110, 60));
        draw_line_width(x - 2, y + 2, x - 12, y + 5, 3);
        draw_set_colour(make_colour_rgb(25, 65, 35));
        draw_line(x - 6, y + 3, x - 6, y + 5);

        // Corpo ágil de réptil
        draw_set_colour(make_colour_rgb(60, 135, 75));
        draw_ellipse(x - 6, y - 8 + _breath, x + 6, y + 5 + _breath, false);

        // Cabeça achatada e atenta
        draw_set_colour(make_colour_rgb(75, 155, 88));
        draw_circle(x + 2, y - 9 + _breath, 6.5, false);

        // Olhos telescópicos de caçador
        draw_set_colour(c_yellow);
        draw_circle(x + 4, y - 11 + _breath, 2.2, false);
        draw_set_colour(c_black);
        draw_line(x + 4, y - 13 + _breath, x + 4, y - 9 + _breath);

        // Aljava de flechas nas costas
        draw_set_colour(make_colour_rgb(90, 65, 45));
        draw_rectangle(x - 8, y - 14 + _breath, x - 4, y + 2 + _breath, false);
        draw_set_colour(c_white);
        draw_line(x - 6, y - 17 + _breath, x - 6, y - 13 + _breath);
        break;

    // =====================================================================
    // D. GUARDIÃO DO VÉU (Pássaro Urutau Eremita)
    // =====================================================================
    case "oracle":
        // Penugem camuflada em padrão de casca de árvore
        draw_set_colour(make_colour_rgb(85, 72, 60));
        draw_triangle(x, y - 16 + _breath, x - 9, y + 8, x + 9, y + 8, false);
        draw_set_colour(make_colour_rgb(55, 45, 38));
        draw_line(x - 3, y - 6, x + 3, y - 6);
        draw_line(x - 5, y + 2, x + 5, y + 2);

        // Cabeça arredondada com bico curto
        draw_set_colour(make_colour_rgb(105, 90, 78));
        draw_circle(x, y - 13 + _breath, 7.5, false);

        // Bico achatado
        draw_set_colour(make_colour_rgb(45, 38, 30));
        draw_triangle(x + 3, y - 12 + _breath, x + 9, y - 11 + _breath, x + 3, y - 10 + _breath, false);

        // Olhos gigantescos místicos de Urutau
        var _eye_glow = 0.8 + 0.2 * sin(_t * 4);
        draw_set_colour(make_colour_rgb(255, 225, 40));
        draw_set_alpha(0.95 * _eye_glow);
        draw_circle(x + 2, y - 14 + _breath, 3.2, false);
        draw_set_colour(c_black);
        draw_circle(x + 2.5, y - 14 + _breath, 1.4, false);
        draw_set_alpha(1.0);

        // Cajado arcano com orbe mística flutuante
        draw_set_colour(make_colour_rgb(60, 48, 40));
        draw_line_width(x - 9, y - 18, x - 9, y + 8, 2);
        draw_set_colour(make_colour_rgb(200, 100, 255));
        draw_circle(x - 9, y - 20 + sin(_t * 4) * 2, 2.5, false);
        break;
}

// -------------------------------------------------------------------------
// 3. Prompt Flutuante de Conversa
// -------------------------------------------------------------------------
if (_player != noone && point_distance(x, y, _player.x, _player.y) <= interact_radius) {
    var _prompt = "[Espaco / A] " + npc_get_display_name();
    draw_set_font(-1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);

    var _box_w = string_width(_prompt) + 16;
    var _box_h = 22;
    var _by = y - 32;

    draw_set_colour(make_colour_rgb(10, 14, 24));
    draw_set_alpha(0.85);
    draw_rectangle(x - _box_w * 0.5, _by - _box_h, x + _box_w * 0.5, _by, false);
    draw_set_colour(make_colour_rgb(255, 215, 80));
    draw_rectangle(x - _box_w * 0.5, _by - _box_h, x + _box_w * 0.5, _by, true);

    draw_set_alpha(1.0);
    draw_set_colour(c_white);
    draw_text(x, _by - 4, _prompt);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
