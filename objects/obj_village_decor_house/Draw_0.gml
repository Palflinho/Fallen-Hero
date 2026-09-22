var _t = current_time * 0.001;

// -------------------------------------------------------------------------
// 1. Sombra Comum no Solo
// -------------------------------------------------------------------------
draw_set_colour(c_black);
draw_set_alpha(0.40);
draw_ellipse(x - 70, y + 22, x + 70, y + 42, false);
draw_set_alpha(1.0);

var _swing_ang = sin(_t * 2.5 + sign_swing) * 4.0;

switch (house_type) {
    // =====================================================================
    // A. OFICINA DE FORJA (Mestre Carapácio)
    // =====================================================================
    case "blacksmith":
        // Paredes de rocha vulcânica escura
        draw_set_colour(make_colour_rgb(45, 40, 42));
        draw_rectangle(x - 60, y - 40, x + 60, y + 30, false);
        draw_set_colour(make_colour_rgb(75, 68, 70));
        draw_rectangle(x - 60, y - 40, x + 60, y + 30, true);

        // Chaminé com fumaça
        draw_set_colour(make_colour_rgb(35, 32, 34));
        draw_rectangle(x + 36, y - 68, x + 54, y - 35, false);
        draw_set_colour(make_colour_rgb(60, 55, 58));
        draw_rectangle(x + 34, y - 72, x + 56, y - 66, false);

        // Brasas na chaminé
        var _smoke_pulse = 0.7 + 0.3 * sin(_t * 6);
        draw_set_colour(make_colour_rgb(255, 120, 30));
        draw_set_alpha(0.8 * _smoke_pulse);
        draw_circle(x + 45, y - 70, 3, false);
        draw_set_alpha(1.0);

        // Telhado de ardósia rústica
        draw_set_colour(make_colour_rgb(65, 55, 55));
        draw_triangle(x - 68, y - 38, x + 68, y - 38, x, y - 75, false);
        draw_set_colour(make_colour_rgb(95, 80, 80));
        draw_triangle(x - 68, y - 38, x + 68, y - 38, x, y - 75, true);

        // Fornalha incandescente visível no centro
        var _fire_pulse = 0.85 + 0.15 * sin(_t * 8);
        draw_set_colour(make_colour_rgb(20, 16, 18));
        draw_rectangle(x - 18, y - 2, x + 18, y + 30, false);
        draw_set_colour(make_colour_rgb(255, 90, 20));
        draw_set_alpha(0.8 * _fire_pulse);
        draw_ellipse(x - 14, y + 4, x + 14, y + 28, false);
        draw_set_colour(c_yellow);
        draw_set_alpha(0.9 * _fire_pulse);
        draw_ellipse(x - 8, y + 10, x + 8, y + 26, false);
        draw_set_alpha(1.0);

        // Bigorna externa em toco de carvalho
        draw_set_colour(make_colour_rgb(70, 50, 30));
        draw_rectangle(x - 48, y + 16, x - 34, y + 32, false);
        draw_set_colour(make_colour_rgb(30, 32, 38));
        draw_rectangle(x - 52, y + 10, x - 30, y + 16, false);
        draw_set_colour(make_colour_rgb(70, 75, 85));
        draw_rectangle(x - 52, y + 10, x - 30, y + 16, true);

        // Placa entalhada com Martelo
        var _sign_x = x - 34;
        var _sign_y = y - 48;
        draw_set_colour(make_colour_rgb(90, 65, 45));
        draw_rectangle(_sign_x - 10, _sign_y, _sign_x + 10, _sign_y + 14, false);
        draw_set_colour(make_colour_rgb(255, 215, 80));
        // Desenho do Martelo
        draw_line_width(_sign_x - 4, _sign_y + 10, _sign_x + 4, _sign_y + 4, 2);
        draw_rectangle(_sign_x + 2, _sign_y + 2, _sign_x + 7, _sign_y + 7, false);
        break;

    // =====================================================================
    // B. HERBÁRIO & ALQUIMIA (Curandeira Kalina)
    // =====================================================================
    case "alchemist":
        // Paredes de argila e pedra de rio
        draw_set_colour(make_colour_rgb(45, 52, 48));
        draw_rectangle(x - 55, y - 35, x + 55, y + 30, false);
        draw_set_colour(make_colour_rgb(65, 80, 72));
        draw_rectangle(x - 55, y - 35, x + 55, y + 30, true);

        // Telhado de colmo com musgo
        draw_set_colour(make_colour_rgb(40, 68, 45));
        draw_triangle(x - 64, y - 33, x + 64, y - 33, x, y - 68, false);
        draw_set_colour(make_colour_rgb(65, 105, 75));
        draw_triangle(x - 64, y - 33, x + 64, y - 33, x, y - 68, true);

        // Cogumelos bioluminescentes no beiral
        var _shroom_glow = 0.8 + 0.2 * sin(_t * 4);
        draw_set_colour(make_colour_rgb(50, 220, 180));
        draw_set_alpha(0.85 * _shroom_glow);
        draw_circle(x - 42, y - 34, 4, false);
        draw_circle(x - 36, y - 37, 3, false);
        draw_circle(x + 38, y - 34, 4.5, false);
        draw_circle(x + 46, y - 36, 3, false);
        draw_set_alpha(1.0);

        // Porta arredondada de madeira nobre
        draw_set_colour(make_colour_rgb(80, 50, 35));
        draw_rectangle(x - 12, y, x + 12, y + 30, false);
        draw_set_colour(make_colour_rgb(110, 75, 50));
        draw_ellipse(x - 12, y - 8, x + 12, y + 8, false);

        // Vitrine com poções iluminadas
        draw_set_colour(make_colour_rgb(20, 30, 28));
        draw_rectangle(x + 22, y + 2, x + 44, y + 20, false);
        draw_set_colour(make_colour_rgb(60, 90, 80));
        draw_rectangle(x + 22, y + 2, x + 44, y + 20, true);

        // Frasquinhos coloridos
        draw_set_colour(make_colour_rgb(255, 80, 80));
        draw_circle(x + 28, y + 14, 3, false);
        draw_set_colour(make_colour_rgb(80, 180, 255));
        draw_circle(x + 38, y + 14, 3, false);

        // Placa entalhada com Frasco de Poção
        var _sign_x = x - 32;
        var _sign_y = y - 44;
        draw_set_colour(make_colour_rgb(90, 65, 45));
        draw_rectangle(_sign_x - 10, _sign_y, _sign_x + 10, _sign_y + 14, false);
        draw_set_colour(make_colour_rgb(80, 230, 160));
        draw_circle(_sign_x, _sign_y + 8, 3.5, false);
        draw_rectangle(_sign_x - 1.5, _sign_y + 2, _sign_x + 1.5, _sign_y + 5, false);
        break;

    // =====================================================================
    // C. POSTO DE SENTINELA DOS ERMOS (Rastreador Tico)
    // =====================================================================
    case "scout":
        // Vigas de sustentação da torreta
        draw_set_colour(make_colour_rgb(70, 52, 38));
        draw_line_width(x - 40, y + 28, x - 30, y - 30, 4);
        draw_line_width(x + 40, y + 28, x + 30, y - 30, 4);
        draw_line_width(x - 30, y + 28, x - 22, y - 30, 3);
        draw_line_width(x + 30, y + 28, x + 22, y - 30, 3);

        // Travessas em X de reforço
        draw_set_colour(make_colour_rgb(90, 68, 50));
        draw_line(x - 35, y + 16, x + 35, y - 8);
        draw_line(x - 35, y - 8, x + 35, y + 16);

        // Plataforma superior de vigia
        draw_set_colour(make_colour_rgb(60, 45, 32));
        draw_rectangle(x - 45, y - 35, x + 45, y - 26, false);
        draw_set_colour(make_colour_rgb(95, 75, 55));
        draw_rectangle(x - 45, y - 35, x + 45, y - 26, true);

        // Toldo camuflado
        draw_set_colour(make_colour_rgb(55, 65, 45));
        draw_triangle(x - 48, y - 35, x + 48, y - 35, x, y - 62, false);
        draw_set_colour(make_colour_rgb(85, 98, 70));
        draw_triangle(x - 48, y - 35, x + 48, y - 35, x, y - 62, true);

        // Luneta / Telescópio de Latão
        draw_set_colour(make_colour_rgb(220, 180, 70));
        draw_line_width(x + 10, y - 38, x + 30, y - 48, 3.5);
        draw_circle(x + 30, y - 48, 2.5, false);

        // Placa entalhada com Arco e Flecha
        var _sign_x = x - 28;
        var _sign_y = y - 46;
        draw_set_colour(make_colour_rgb(85, 60, 40));
        draw_rectangle(_sign_x - 10, _sign_y, _sign_x + 10, _sign_y + 14, false);
        draw_set_colour(make_colour_rgb(240, 220, 90));
        draw_arc_sim(_sign_x - 2, _sign_y + 7, 5, 1);
        draw_line(_sign_x - 5, _sign_y + 7, _sign_x + 5, _sign_y + 7);
        break;

    // =====================================================================
    // D. SANTUÁRIO DOS MURMÚRIOS (Guardião do Véu)
    // =====================================================================
    case "oracle":
        // Base de pedra obsidiana e pedras esculpidas
        draw_set_colour(make_colour_rgb(25, 20, 36));
        draw_rectangle(x - 50, y - 30, x + 50, y + 28, false);
        draw_set_colour(make_colour_rgb(60, 48, 85));
        draw_rectangle(x - 50, y - 30, x + 50, y + 28, true);

        // Colunas arcanas laterais
        draw_set_colour(make_colour_rgb(42, 34, 58));
        draw_rectangle(x - 56, y - 42, x - 42, y + 30, false);
        draw_rectangle(x + 42, y - 42, x + 56, y + 30, false);
        draw_set_colour(make_colour_rgb(78, 62, 105));
        draw_rectangle(x - 56, y - 42, x - 42, y + 30, true);
        draw_rectangle(x + 42, y - 42, x + 56, y + 30, true);

        // Cristais flutuantes violeta
        var _cry_y = y - 55 + sin(_t * 3) * 4;
        var _cry_pulse = 0.8 + 0.2 * sin(_t * 5);
        draw_set_colour(make_colour_rgb(180, 70, 255));
        draw_set_alpha(0.85 * _cry_pulse);
        draw_circle(x, _cry_y, 7, false);
        draw_set_colour(c_white);
        draw_circle(x - 1, _cry_y - 2, 2.5, false);

        // Pequenos estilhaços orbitando o cristal
        var _ang1 = _t * 2;
        var _ang2 = _ang1 + pi;
        draw_set_colour(make_colour_rgb(220, 140, 255));
        draw_circle(x + cos(_ang1) * 16, _cry_y + sin(_ang1) * 6, 2, false);
        draw_circle(x + cos(_ang2) * 16, _cry_y + sin(_ang2) * 6, 2, false);
        draw_set_alpha(1.0);

        // Tochas violeta nos pilares
        draw_set_colour(make_colour_rgb(200, 100, 255));
        draw_set_alpha(0.7 * _cry_pulse);
        draw_circle(x - 49, y - 44, 4, false);
        draw_circle(x + 49, y - 44, 4, false);
        draw_set_alpha(1.0);

        // Placa entalhada com Olho Místico
        var _sign_x = x - 28;
        var _sign_y = y - 42;
        draw_set_colour(make_colour_rgb(50, 38, 70));
        draw_rectangle(_sign_x - 10, _sign_y, _sign_x + 10, _sign_y + 14, false);
        draw_set_colour(make_colour_rgb(210, 140, 255));
        draw_ellipse(_sign_x - 6, _sign_y + 4, _sign_x + 6, _sign_y + 10, false);
        draw_set_colour(c_black);
        draw_circle(_sign_x, _sign_y + 7, 2, false);
        break;
}

draw_set_colour(c_white);
draw_set_alpha(1.0);
