// Desenha caminhos de pedra conectando o pátio central, os pedestais e o portal
draw_set_alpha(0.18);
draw_set_colour(make_colour_rgb(180, 190, 210));

// Caminho vertical: Portal -> Altar -> Treino
draw_roundrect(770, 160, 830, 920, false);

// Caminho horizontal: Pedestais
draw_roundrect(420, 615, 1180, 665, false);

// Pátio central sob o Altar
draw_circle(800, 380, 95, false);

// Pátio de treino ao sul
draw_circle(800, 880, 75, false);

draw_set_alpha(1.0);

// Rótulos de ambientação da vila
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(fnt_title);
draw_set_colour(make_colour_rgb(160, 175, 195));
draw_text(800, 50, "VILA DOS SOBREVIVENTES");

draw_set_font(fnt_regular);
draw_set_colour(make_colour_rgb(120, 135, 155));
draw_text(800, 570, "Patio de Treinamento e Troca de Classes");
