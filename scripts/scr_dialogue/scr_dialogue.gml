// =========================================================================
// SISTEMA DE DIALOGOS E LINGUA DOS BICHINHOS (Fallen Hero)
// =========================================================================
// Controla caixas de dialogo cinemáticas com efeito Typewriter,
// fonemas sintetizados proceduralmente e legendas bilingues (Marciano/PT-BR).
// =========================================================================

function dialogue_start(_lines_array, _on_finish_callback = undefined) {
    if (!variable_global_exists("dialogue_active")) global.dialogue_active = false;
    global.dialogue_active = true;

    var _box = noone;
    if (instance_exists(obj_dialogue_box)) {
        _box = instance_find(obj_dialogue_box, 0);
    } else {
        _box = instance_create_depth(0, 0, -9999, obj_dialogue_box);
    }

    _box.lines = _lines_array;
    _box.line_index = 0;
    _box.on_finish = _on_finish_callback;
    _box.dialogue_setup_current_line();
}

function dialogue_is_active() {
    return (variable_global_exists("dialogue_active") && global.dialogue_active);
}

// -------------------------------------------------------------------------
// Roteiros Narrativos do MVP (Templo da Agua)
// -------------------------------------------------------------------------

function dialogue_get_intro_lines(_class) {
    switch (_class) {
        case "knight":
            return [
                {
                    speaker: "knight",
                    name: "Rinoceronte Cavaleiro [Guardião]",
                    alien: "« Kro-tash! Zuk-zuk vahr tor'kahn! »",
                    text: "As ruínas do Templo da Água... Sinto a umidade pesada e o lodo corrompido adiante. Minha couraça e minha espada não vacilarão!"
                }
            ];
        case "mage":
            return [
                {
                    speaker: "mage",
                    name: "Raposa Maga [Criomante]",
                    alien: "« Asha-riil... vom mystic vahn lumina! »",
                    text: "As correntes arcanas deste santuário foram completamente distorcidas. O General da Água deve estar guardando o núcleo corrompido."
                }
            ];
        case "archer":
            return [
                {
                    speaker: "archer",
                    name: "Lagarto Arqueiro [Franco-Atirador]",
                    alien: "« Sssss-kree! Zzzt lok-dar skree! »",
                    text: "O vento sopra úmido entre as colunas submersas. Meus olhos já rastreiam as sombras... Minhas flechas encontrarão cada ponto fraco."
                }
            ];
        case "assassin":
            return [
                {
                    speaker: "assassin",
                    name: "Urutau Assassino [Espectro]",
                    alien: "« Hu-ruuu... kwi-chi sha mor-gath... »",
                    text: "O reflexo das águas esconde passos silenciosos. Nenhum ruído escapará antes da lâmina atingir o coração da corrupção."
                }
            ];
    }
    return [
        {
            speaker: "knight",
            name: "Herói",
            alien: "« Vahr lok-dar! »",
            text: "O Templo da Água nos aguarda. Vamos em frente!"
        }
    ];
}

function dialogue_get_shop_lines(_class) {
    var _hero_resp = {
        speaker: _class,
        name: "Herói",
        alien: "« Kro-vahn zek! »",
        text: "Suas relíquias podem ser a diferença entre a vitória e o afogamento. Mostre o que tem."
    };

    return [
        {
            speaker: "merchant",
            name: "Mercador das Marés",
            alien: "« Ooo-la! Tik-tok shiny-gem kupo?! »",
            text: "Saudações, nobre viajante! As águas profundas devoram os descuidados, mas minhas relíquias garantem a sobrevivência... Ouro vivo por poder ancestral!"
        },
        _hero_resp
    ];
}

function dialogue_get_boss_intro_lines(_class) {
    var _hero_name = "Herói";
    var _hero_speech = "A corrupção cega seu juízo, General! Nós viemos libertar a essência sagrada!";
    var _hero_alien = "« Zuk-kahn tor'valasha! »";

    switch (_class) {
        case "knight":
            _hero_name = "Rinoceronte Cavaleiro";
            _hero_speech = "Seu domínio de tirania termina aqui, General! Nenhum maremoto romperá o meu escudo!";
            _hero_alien = "« Kro-tash val-drak! Tok-tok! »";
            break;
        case "mage":
            _hero_name = "Raposa Maga";
            _hero_speech = "Eu sinto a essência sufocada em seu peito. Entregue o núcleo antes que seja tarde!";
            _hero_alien = "« Asha-lumina riil-kor! »";
            break;
        case "archer":
            _hero_name = "Lagarto Arqueiro";
            _hero_speech = "Sua carapaça tem frestas suficientes para uma dúzia de virotes. Prepare-se!";
            _hero_alien = "« Sssss-kree lok! »";
            break;
        case "assassin":
            _hero_name = "Urutau Assassino";
            _hero_speech = "Você pode controlar as marés, mas nunca verá a lâmina cortar a sua sombra.";
            _hero_alien = "« Hu-ruuu sha-kahn... »";
            break;
    }

    return [
        {
            speaker: "general",
            name: "General da Água [Guardião Corrompido]",
            alien: "« GORR-ZUL! KRAKATOA VORTEX NAL-MOR! »",
            text: "Tolos... Vocês rastejam até aqui se achando 'heróis'?! Vocês não entendem o que está em jogo... A Terra está morrendo e este poder a salvará!"
        },
        {
            speaker: _class,
            name: _hero_name,
            alien: _hero_alien,
            text: _hero_speech
        },
        {
            speaker: "general",
            name: "General da Água [Guardião Corrompido]",
            alien: "« SKRAAA-VORTEX! DROWN IN TIDES! »",
            text: "Então afoguem-se sob a fúria das profundezas!"
        }
    ];
}
