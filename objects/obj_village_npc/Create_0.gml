// =========================================================================
// PERSONAGEM NPC DA VILA SUBTERRÂNEA (Fallen Hero)
// =========================================================================

if (!variable_instance_exists(id, "npc_id") || npc_id == "") {
    if (x < 600) {
        if (y < 500) npc_id = "scout";
        else npc_id = "blacksmith";
    } else {
        if (y < 500) npc_id = "oracle";
        else npc_id = "alchemist";
    }
}

interact_radius = 56;
talk_cooldown = 0;
anim_timer = random(10);

function npc_get_display_name() {
    switch (npc_id) {
        case "blacksmith": return "Mestre Carapacio";
        case "alchemist":  return "Curandeira Kalina";
        case "scout":      return "Rastreador Tico";
        case "oracle":     return "Guardiao do Veu";
        default:           return tr("Morador");
    }
}
