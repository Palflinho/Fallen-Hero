if (!variable_instance_exists(id, "element_id")) {
    if (x < 680) element_id = "water";
    else if (x < 800) element_id = "fire";
    else if (x < 920) element_id = "wind";
    else element_id = "earth";
}
glow_timer = random(10);
