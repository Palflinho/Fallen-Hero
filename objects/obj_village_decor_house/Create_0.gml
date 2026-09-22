// =========================================================================
// EDIFICAÇÕES DECORATIVAS & OFÍCIOS DA VILA (Fallen Hero)
// =========================================================================

if (!variable_instance_exists(id, "house_type") || house_type == "") {
    if (x < 600) {
        if (y < 500) house_type = "scout";
        else house_type = "blacksmith";
    } else {
        if (y < 500) house_type = "oracle";
        else house_type = "alchemist";
    }
}

chimney_timer = random(10);
sign_swing = random(360);
