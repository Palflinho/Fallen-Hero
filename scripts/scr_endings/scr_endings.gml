// =========================================================================
// OS TRES FINAIS DE FALLEN HERO
//  - Vinganca (padrao): leva as Essencias para casa; a Terra definha.
//  - Conquistador: fica no novo mundo e reina sobre os humanos.
//  - Sintese (verdadeiro): une os dois mundos com a propria forca vital.
//    Requer jogar com a Maestria da classe (classe no proprio elemento:
//    Guardiao, Piromante, Cacador das Mares, Algoz do Tufao) e ja ter visto
//    ao menos um final.
// =========================================================================

// Elemento de Maestria de cada classe
function class_mastery_element(_class) {
    switch (_class) {
        case "knight": return "earth";
        case "mage": return "fire";
        case "archer": return "water";
        case "assassin": return "wind";
    }
    return "none";
}

function endings_ensure() {
    if (!variable_global_exists("meta_endings") || !is_struct(global.meta_endings)) {
        global.meta_endings = { vinganca: false, conquistador: false, sintese: false };
    }
}

function endings_seen_count() {
    endings_ensure();
    var _n = 0;
    if (global.meta_endings.vinganca) _n++;
    if (global.meta_endings.conquistador) _n++;
    if (global.meta_endings.sintese) _n++;
    return _n;
}

function ending_mark_seen(_id) {
    ensure_meta_loaded();
    endings_ensure();
    global.meta_endings[$ _id] = true;
    save_meta();
}

function ending_synthesis_on_mastery() {
    var _pl = instance_find(obj_player, 0);
    if (_pl == noone) return false;
    return (_pl.element_affinity == class_mastery_element(_pl.character_class));
}

function ending_synthesis_available() {
    return ending_synthesis_on_mastery() && endings_seen_count() >= 1;
}

// Texto no idioma atual a partir de {pt, en}
function ending_txt(_s) {
    return (loc_get_language() == "en") ? _s.en : _s.pt;
}

// Opcoes da escolha final
function ending_get_options() {
    return [
        {
            id: "vinganca",
            title: { pt: "Levar as Essências para casa", en: "Take the Essences home" },
            desc: { pt: "Seu povo volta a viver. A Terra fica sem nada.", en: "Your people live again. Earth is left with nothing." }
        },
        {
            id: "conquistador",
            title: { pt: "Ficar e reinar sobre este mundo", en: "Stay and rule this world" },
            desc: { pt: "O paraíso é seu. Os humanos se curvam ou caem.", en: "Paradise is yours. The humans kneel or fall." }
        },
        {
            id: "sintese",
            title: { pt: "Unir os dois mundos", en: "Bind the two worlds" },
            desc: { pt: "Entregar parte da sua própria vida para que ninguém precise morrer.", en: "Give part of your own life so that no one has to die." }
        }
    ];
}

// Paginas do epilogo de cada final (a ultima e o titulo do final)
function ending_get_pages(_id) {
    var _p = [];
    switch (_id) {
        case "vinganca":
            _p = [
                { pt: "Você ergue as quatro Essências. Elas pulsam em suas mãos como corações antigos... e você dá as costas ao homem caído.",
                  en: "You raise the four Essences. They pulse in your hands like ancient hearts... and you turn your back on the fallen man." },
                { pt: "Na Vila Subterrânea, os pedestais se acendem. Os rios voltam a correr, as florestas despertam e o seu povo vê o céu azul outra vez.",
                  en: "In the Underground Village, the pedestals light up. The rivers flow again, the forests awaken and your people see the blue sky once more." },
                { pt: "Muito longe dali, nos abrigos da Terra, as luzes se apagam uma a uma. Seu povo nunca saberá o nome da menina que não voltou a respirar.",
                  en: "Far away, in the shelters of Earth, the lights go out one by one. Your people will never know the name of the girl who did not breathe again." },
                { pt: "FINAL DA VINGANÇA\nSeu mundo vive. O preço foi outro mundo.",
                  en: "ENDING OF VENGEANCE\nYour world lives. The price was another world." }
            ];
            break;
        case "conquistador":
            _p = [
                { pt: "Você olha para o homem caído, depois para o planeta verde lá embaixo. As Essências queimam em suas mãos... e você não volta para casa.",
                  en: "You look at the fallen man, then at the green planet below. The Essences burn in your hands... and you do not go home." },
                { pt: "A cúpula dos sobreviventes cai em uma única noite. Os humanos que restam se ajoelham diante do novo guardião do paraíso.",
                  en: "The survivors' dome falls in a single night. The humans who remain kneel before the new guardian of paradise." },
                { pt: "Na escuridão da Vila Subterrânea, seu povo continua olhando para um portal que nunca mais se acende.",
                  en: "In the darkness of the Underground Village, your people keep staring at a portal that never lights up again." },
                { pt: "FINAL DO CONQUISTADOR\nVocê se tornou aquilo que veio destruir.",
                  en: "ENDING OF THE CONQUEROR\nYou became what you came to destroy." }
            ];
            break;
        case "sintese":
            _p = [
                { pt: "Você se ajoelha ao lado do humano e coloca as quatro Essências entre vocês dois. \"Não precisa haver um só vencedor.\"",
                  en: "You kneel beside the human and place the four Essences between you. \"There does not have to be only one winner.\"" },
                { pt: "Nos pedestais da Vila, você entrega parte da sua própria força vital. Os quatro elementos se entrelaçam e abrem uma ponte que nunca se fecha.",
                  en: "At the Village pedestals, you give up part of your own life force. The four elements intertwine and open a bridge that never closes." },
                { pt: "A vida passa a correr pelos dois mundos. Pouca, frágil, dividida... mas suficiente. Pela primeira vez, uma criança humana e um filhote do seu povo olham para o mesmo céu.",
                  en: "Life begins to flow through both worlds. Little, fragile, shared... but enough. For the first time, a human child and a cub of your people look at the same sky." },
                { pt: "FINAL DA SÍNTESE\nO verdadeiro herói foi aquele que se recusou a escolher quem morreria.",
                  en: "ENDING OF SYNTHESIS\nThe true hero was the one who refused to choose who would die." }
            ];
            break;
    }
    return _p;
}

// Creditos (edite livremente). Linhas vazias viram espaco.
function ending_get_credits() {
    return [
        "FALLEN HERO",
        tr("As Cronicas dos Elementos"),
        "",
        "",
        tr("CRIACAO, DIRECAO E GAME DESIGN"),
        "Palflinho",
        "",
        tr("PROGRAMACAO"),
        "Palflinho",
        "",
        tr("ARTE"),
        tr("(a definir)"),
        "",
        tr("MUSICA E EFEITOS SONOROS"),
        tr("Sintese procedural - (a definir)"),
        "",
        tr("FONTE"),
        "Liberation Sans (SIL Open Font License)",
        "",
        tr("FEITO COM"),
        "GameMaker",
        "",
        "",
        tr("Obrigado por jogar!")
    ];
}
