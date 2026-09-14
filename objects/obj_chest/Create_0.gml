radius = 22;

// Baús podem conceder talentos ou pontos de talento (máximo 3 pontos)
is_points = (random(1) < 0.40);
if (is_points) {
    points_amount = irandom_range(1, 3);
    talent_id = "";
} else {
    points_amount = 0;
    talent_id = roll_chest_talent();
}
