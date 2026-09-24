// =========================================================================
// TABELA MODULAR CENTRALIZADA DE DIALOGOS (Fallen Hero)
// =========================================================================
// Este arquivo contem TODOS os dialogos narrativos do jogo.
//
// FORMATO DE CADA CENA:
// global.dialogue_db[$ "id_da_cena"] = [
//     {
//         speaker: "hero" (classe jogada) | "knight" | "mage" | "archer" | "assassin" | "merchant" | "general" | "elder" | "human" | "spirit",
//         by_class: { knight: {...}, mage: {...}, archer: {...}, assassin: {...} } (opcional, so com speaker "hero")
//         name: { pt: "Nome PT", en: "Name EN" }  // ou string simples
//         alien: "« Texto na lingua dos bichinhos »", // opcional
//         text: {
//             pt: "Texto em Portugues",
//             en: "Text in English"
//         }
//     }
// ];
//
// PARA DISPARAR QUALQUER DIALOGO NO JOGO:
// dialogue_play_id("id_da_cena", callback_opcional);
// =========================================================================

function dialogue_db_init() {
    if (variable_global_exists("dialogue_db_initialized") && global.dialogue_db_initialized) return;
    global.dialogue_db_initialized = true;
    global.dialogue_db = {};

    // ---------------------------------------------------------------------
    // 1. VILA SUBTERRÂNEA: ANCIÃO E PEDESTAIS
    // ---------------------------------------------------------------------
    global.dialogue_db[$ "village_elder_intro"] = [
        {
            speaker: "elder",
            name: { pt: "Ancião Tatupóba", en: "Elder Tatupoba" },
            alien: "« Kuru-vahn... tor'ma zek-kahn... »",
            text: {
                pt: "Herói... Você despertou sob as raízes da terra ancestral. A superfície sucumbiu após o roubo das Quatro Essências. Os Quatro Pedestais ao norte choram por seu retorno!",
                en: "Hero... You awaken beneath the roots of the ancestral earth. The surface fell after the Four Essences were stolen. The Four Pedestals to the north weep for their return!"
            }
        },
        {
            speaker: "elder",
            name: { pt: "Ancião Tatupóba", en: "Elder Tatupoba" },
            alien: "« Sha-vortex mor lumina kupo! »",
            text: {
                pt: "Adentre o Portal de Expedição. Derrote os Generais guardiões de cada templo e traga os núcleos. Quando os 4 pedestais brilharem juntos, o portal revelará a câmara do misterioso usurpador!",
                en: "Step into the Expedition Portal. Defeat the guardian Generals of each temple and bring back their cores. When all 4 pedestals blaze together, the portal will reveal the chamber of the mysterious usurper!"
            }
        }
    ];

    global.dialogue_db[$ "village_pedestals_hint"] = [
        {
            speaker: "elder",
            name: { pt: "Ancião Tatupóba", en: "Elder Tatupoba" },
            alien: "« Vahr-altar astra lok! »",
            text: {
                pt: "Estes são os Quatro Pedestais Sagrados: Água, Fogo, Vento e Terra. Conforme libertar cada bioma, o respectivo altar despertará com o fogo elemental puro.",
                en: "These are the Four Sacred Pedestals: Water, Fire, Wind, and Earth. As you liberate each biome, the corresponding altar will awaken with pure elemental fire."
            }
        }
    ];

    // ---------------------------------------------------------------------
    // 2. TEMPLO 1: TEMPLO DA ÁGUA
    // ---------------------------------------------------------------------
    // Fala de abertura: "speaker: hero" + "by_class" escolhe a versao da classe jogada;
    // o nome e montado automaticamente com a especializacao (ex.: "Rinoceronte Cavaleiro [Lanceiro]").
    global.dialogue_db[$ "temple1_water_intro"] = [
        {
            speaker: "hero",
            by_class: {
                knight: {
                    alien: "« Kro-tash! Zuk-zuk vahr tor'kahn! »",
                    text: {
                        pt: "As ruínas do Templo da Água... Sinto a umidade pesada e o lodo corrompido adiante. Minha couraça e minha lâmina não vacilarão!",
                        en: "The ruins of the Water Temple... Heavy moisture and corrupted mire pulse ahead. My hide and blade shall not falter!"
                    }
                },
                mage: {
                    alien: "« Asha-riil... vom mystic vahn lumina! »",
                    text: {
                        pt: "As correntes arcanas deste santuário foram completamente distorcidas. O General da Água deve estar guardando o núcleo corrompido.",
                        en: "The arcane currents of this sanctuary have been completely twisted. The Water General must be guarding the corrupted core."
                    }
                },
                archer: {
                    alien: "« Sssss-kree! Zzzt lok-dar skree! »",
                    text: {
                        pt: "O vento sopra úmido entre as colunas submersas. Meus olhos já rastreiam as sombras... Minhas flechas encontrarão cada ponto fraco.",
                        en: "A damp wind blows between the sunken pillars. My eyes already track the shadows... My arrows will find every weak point."
                    }
                },
                assassin: {
                    alien: "« Hu-ruuu... kwi-chi sha mor-gath... »",
                    text: {
                        pt: "O reflexo das águas esconde passos silenciosos. Nenhum ruído escapará antes da lâmina atingir o coração da corrupção.",
                        en: "The water's reflection hides silent steps. Not a sound will escape before my blade reaches the heart of the corruption."
                    }
                }
            }
        }
    ];

    global.dialogue_db[$ "temple1_water_boss"] = [
        {
            speaker: "general",
            name: { pt: "General da Água [Guardião Corrompido]", en: "Water General [Corrupted Guardian]" },
            alien: "« GORR-ZUL! KRAKATOA VORTEX NAL-MOR! »",
            text: {
                pt: "Tolos mortais... Vocês rastejam até aqui se achando heróis?! Vocês não entendem o sacrifício! A Terra está morrendo e este poder a salvará!",
                en: "Foolish mortals... You crawl here thinking yourselves heroes?! You do not comprehend the sacrifice! Earth is dying, and this power shall save it!"
            }
        },
        {
            speaker: "hero",
            alien: "« Zuk-kahn tor'valasha! »",
            text: {
                pt: "A ganância e o medo cegam seu propósito, General! O Templo da Água será purificado!",
                en: "Greed and fear have blinded your purpose, General! The Water Temple shall be cleansed!"
            }
        },
        {
            speaker: "general",
            name: { pt: "General da Água [Guardião Corrompido]", en: "Water General [Corrupted Guardian]" },
            alien: "« SKRAAA-VORTEX! DROWN IN TIDES! »",
            text: {
                pt: "Então afoguem-se sob o peso esmagador das profundezas abissais!",
                en: "Then drown beneath the crushing weight of the abyssal depths!"
            }
        }
    ];

    // ---------------------------------------------------------------------
    // 3. TEMPLO 3: TEMPLO DO VENTO (FASE 3)
    // ---------------------------------------------------------------------
    global.dialogue_db[$ "temple3_wind_intro"] = [
        {
            speaker: "hero",
            by_class: {
                knight: {
                    alien: "« Kro-tash val-drak! Tok-tok! »",
                    text: {
                        pt: "O Templo do Vento... As rajadas tentam me derrubar a cada passo. Mas nenhum vendaval move um Rinoceronte plantado no chão!",
                        en: "The Wind Temple... The gusts try to knock me down with every step. But no gale can move a Rhino rooted to the ground!"
                    }
                },
                mage: {
                    alien: "« Asha-lumina riil-kor! »",
                    text: {
                        pt: "O Templo do Vento... O ar aqui é puro fluxo arcano, mas está envenenado. Vou desatar cada ciclone, fio por fio.",
                        en: "The Wind Temple... The air here is pure arcane flow, yet it has been poisoned. I will unravel every cyclone, thread by thread."
                    }
                },
                archer: {
                    alien: "« Sssss-kree! Zzzt lok-dar skree! »",
                    text: {
                        pt: "O Templo do Vento... Ciclones cortantes e vendavais rugem entre as fendas aéreas. Meus olhos de réptil acompanharão cada rajada!",
                        en: "The Wind Temple... Razor cyclones and howling gales roar through aerial chasms. My reptilian eyes shall trace every gust!"
                    }
                },
                assassin: {
                    alien: "« Hu-ruuu... sha-vortex mor! »",
                    text: {
                        pt: "O Templo do Vento... Este é o céu do meu povo. Cada corrente de ar aqui já me carregou um dia. Agora ela vai esconder a minha lâmina.",
                        en: "The Wind Temple... This is my people's sky. Every current here once carried me. Now it will hide my blade."
                    }
                }
            }
        }
    ];

    global.dialogue_db[$ "temple3_wind_boss"] = [
        {
            speaker: "general",
            name: { pt: "General Zephyrus [Mestre dos Vendavais]", en: "General Zephyrus [Master of Gales]" },
            alien: "« ZEPHYR-KRAAA! TEMPEST VOID SHRED! »",
            text: {
                pt: "Quem ousa desafiar os céus roubados?! O ar deste mundo não pertence mais a vocês... Cada rajada impulsiona a salvação da nossa espécie!",
                en: "Who dares defy the stolen skies?! The atmosphere of this world no longer belongs to you... Every gale fuels the salvation of our kind!"
            }
        },
        {
            speaker: "hero",
            alien: "« Sssss-lok vahr gale! »",
            text: {
                pt: "Você roubou o fôlego da nossa fauna e espalhou tempestades! Suas asas cairão aqui, Zephyrus!",
                en: "You choked the breath of our creatures and unleashed tempests! Your wings shall fall right here, Zephyrus!"
            }
        },
        {
            speaker: "general",
            name: { pt: "General Zephyrus [Mestre dos Vendavais]", en: "General Zephyrus [Master of Gales]" },
            alien: "« HURRICANE-RAZOR BLADES! »",
            text: {
                pt: "Testem a fúria do vácuo absoluto! Nenhuma flecha voará contra o meu furacão!",
                en: "Taste the fury of absolute vacuum! No arrow shall fly against my hurricane!"
            }
        }
    ];

    // ---------------------------------------------------------------------
    // 4. TEMPLO 5: MERCADOR PRE-CHEFE & O CONFRONTO HUMANO
    // ---------------------------------------------------------------------
    global.dialogue_db[$ "temple5_shop_intro"] = [
        {
            speaker: "merchant",
            name: { pt: "Mercador das Marés", en: "Tide Merchant" },
            alien: "« Ooo-la... Omni-gem finalis... »",
            text: {
                pt: "Herói... Você reuniu os Quatro Elementos. Além daquela porta blindada não há mais monstros... Apenas o artífice por trás de toda essa tragédia. Use seu ouro. Compre tudo o que precisar.",
                en: "Hero... You have gathered the Four Elements. Beyond that armored blast-door lie no beasts... Only the architect behind this entire tragedy. Spend your gold. Take all you require."
            }
        }
    ];

    global.dialogue_db[$ "temple5_human_boss"] = [
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]" },
            alien: "",
            text: {
                pt: "Então foram vocês... Os guardiões deste planeta primitivo conseguiram romper todas as minhas defesas de contenção.",
                en: "So it was you... The guardians of this primitive planet managed to breach all of my containment barriers."
            }
        },
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]" },
            alien: "",
            text: {
                pt: "Vocês me olham como um monstro, não é? Mas sabem o que está em jogo? A Terra, o meu lar, secou. Bilhões de vidas humanas estão sufocando na escuridão! As suas essências eram a nossa única esperança de reiniciar a biosfera!",
                en: "You look at me as if I were a monster, don't you? But do you understand the stakes? Earth, my home, has withered away. Billions of human souls are suffocating in the dark! Your essences were our sole hope to reignite our biosphere!"
            }
        },
        {
            speaker: "hero",
            alien: "« Tor-vahr terra... non extinguish nos! »",
            text: {
                pt: "Destruir a vida de um mundo para salvar outro não é salvação... É apenas condenar inocentes ao mesmo destino. Devolva as essências!",
                en: "Extinguishing one world to save another is not salvation... It is merely dooming innocents to the very same fate. Surrender the essences!"
            }
        },
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]" },
            alien: "",
            text: {
                pt: "Não posso recuar. Não quando estou tão perto. Ativar exoesqueleto de combate! Protocolo de Defesa Máxima!",
                en: "I cannot turn back. Not when I am this close. Combat exoskeleton engaged! Maximum Defense Protocol initiated!"
            }
        }
    ];

    // Derrota do Salvador: a couraca estilhaca e revela um homem comum
    global.dialogue_db[$ "temple5_human_defeat"] = [
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]" },
            alien: "",
            text: {
                pt: "Vocês... conseguiram... Nosso mundo, a Terra... nós a destruímos séculos atrás. A ganância dos meus antepassados esgotou o ar, secou os oceanos e cobriu nossos filhos de cinzas.",
                en: "You... did it... Our world, Earth... we destroyed it centuries ago. My ancestors' greed drained the air, dried the oceans and buried our children in ash."
            }
        },
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]" },
            alien: "",
            text: {
                pt: "Quando descobri o mundo de vocês, tão cheio de vida... eu vi uma chance. Eu não queria que a minha filha morresse sufocada num abrigo subterrâneo. Aceitei ser a besta... para que eles vissem o céu azul mais uma vez.",
                en: "When I found your world, so full of life... I saw a chance. I did not want my daughter to suffocate in an underground shelter. I accepted becoming the beast... so they could see the blue sky one more time."
            }
        },
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]" },
            alien: "",
            text: {
                pt: "E agora vocês vieram pegar tudo de volta. Me diga, guerreiro... quando o meu povo morrer de sede amanhã... qual de nós dois é o herói?",
                en: "And now you have come to take it all back. Tell me, warrior... when my people die of thirst tomorrow... which of us is the hero?"
            }
        }
    ];

    // Espirito da arena libertado: agradece e encoraja o heroi antes do chefe
    global.dialogue_db[$ "spirit_freed_water"] = [
        {
            speaker: "spirit",
            name: { pt: "Ondina, Espírito da Água", en: "Undine, Spirit of Water" },
            alien: "",
            text: {
                pt: "Ahh... a corrente volta a correr limpa. Por tanto tempo eu fui uma prisioneira nas minhas próprias águas...",
                en: "Ahh... the current runs clear again. For so long I was a prisoner in my own waters..."
            }
        },
        {
            speaker: "spirit",
            name: { pt: "Ondina, Espírito da Água", en: "Undine, Spirit of Water" },
            alien: "",
            text: {
                pt: "O General da Água ainda guarda o coração do templo. Não tenha medo das marés, pequeno guardião. Liberte-nos a todos!",
                en: "The Water General still guards the heart of the temple. Do not fear the tides, little guardian. Set us all free!"
            }
        }
    ];

    // Espirito da arena libertado: agradece e encoraja o heroi antes do chefe
    global.dialogue_db[$ "spirit_freed_fire"] = [
        {
            speaker: "spirit",
            name: { pt: "Salamandra, Espírito do Fogo", en: "Salamander, Spirit of Fire" },
            alien: "",
            text: {
                pt: "Minha chama... ela é minha de novo! Eles a usavam como uma fornalha para as máquinas deles.",
                en: "My flame... it is mine again! They used it as a furnace for their machines."
            }
        },
        {
            speaker: "spirit",
            name: { pt: "Salamandra, Espírito do Fogo", en: "Salamander, Spirit of Fire" },
            alien: "",
            text: {
                pt: "O General Magma espera nas forjas. Que o seu coração queime mais forte que o dele! Liberte o templo!",
                en: "General Magma waits in the forges. Let your heart burn brighter than his! Free the temple!"
            }
        }
    ];

    // Espirito da arena libertado: agradece e encoraja o heroi antes do chefe
    global.dialogue_db[$ "spirit_freed_wind"] = [
        {
            speaker: "spirit",
            name: { pt: "Sílfide, Espírito do Vento", en: "Sylph, Spirit of Wind" },
            alien: "",
            text: {
                pt: "Consigo respirar... o vento canta outra vez entre as colunas. Obrigada, viajante.",
                en: "I can breathe... the wind sings between the columns once more. Thank you, traveler."
            }
        },
        {
            speaker: "spirit",
            name: { pt: "Sílfide, Espírito do Vento", en: "Sylph, Spirit of Wind" },
            alien: "",
            text: {
                pt: "Zephyrus prendeu o céu inteiro. Siga o sopro que eu te dou e derrube-o! Devolva o ar ao nosso povo!",
                en: "Zephyrus has caged the whole sky. Follow the breath I give you and bring him down! Return the air to our people!"
            }
        }
    ];

    // Espirito da arena libertado: agradece e encoraja o heroi antes do chefe
    global.dialogue_db[$ "spirit_freed_earth"] = [
        {
            speaker: "spirit",
            name: { pt: "Gnomo, Espírito da Terra", en: "Gnome, Spirit of Earth" },
            alien: "",
            text: {
                pt: "Hmm-hmm... as raízes voltam a me ouvir. A pedra lembra do seu nome, guardião.",
                en: "Hmm-hmm... the roots can hear me again. The stone remembers your name, guardian."
            }
        },
        {
            speaker: "spirit",
            name: { pt: "Gnomo, Espírito da Terra", en: "Gnome, Spirit of Earth" },
            alien: "",
            text: {
                pt: "O Titã Monolito é o último cadeado deste mundo. Firme os pés e não recue! Liberte a última essência!",
                en: "The Monolith Titan is the last lock on this world. Plant your feet and do not falter! Free the last essence!"
            }
        }
    ];
}

// -------------------------------------------------------------------------
// FUNÇÃO UTILITÁRIA PARA DISPARAR QUALQUER DIÁLOGO DA TABELA
// -------------------------------------------------------------------------
function dialogue_play_id(_dialogue_id, _on_finish = undefined) {
    dialogue_db_init();
    if (!variable_struct_exists(global.dialogue_db, _dialogue_id)) {
        show_debug_message("Dialogue ID nao encontrado: " + string(_dialogue_id));
        if (!is_undefined(_on_finish) && is_method(_on_finish)) _on_finish();
        return;
    }

    var _raw_lines = global.dialogue_db[$ _dialogue_id];
    var _resolved_lines = [];
    var _lang = loc_get_language();

    // Classe e especializacao de quem esta jogando (para as falas do heroi)
    var _pl = instance_find(obj_player, 0);
    var _cls = (_pl != noone) ? _pl.character_class : (variable_global_exists("selected_character") ? global.selected_character : "knight");
    var _el = (_pl != noone) ? _pl.element_affinity : (variable_global_exists("selected_element") ? global.selected_element : "none");
    var _hero_label = loc("class_" + _cls, "Herói") + " [" + class_get_archetype_name(_cls, _el) + "]";

    for (var _i = 0; _i < array_length(_raw_lines); _i++) {
        var _raw = _raw_lines[_i];
        var _is_hero = (variable_struct_exists(_raw, "speaker") && _raw.speaker == "hero");
        // Versao da fala especifica da classe jogada
        if (_is_hero && variable_struct_exists(_raw, "by_class")) {
            if (variable_struct_exists(_raw.by_class, _cls)) _raw = _raw.by_class[$ _cls];
            else _raw = _raw.by_class.knight;
        }

        // Resolve nome no idioma ativo
        var _name = _is_hero ? _hero_label : "Herói";
        if (variable_struct_exists(_raw, "name")) {
            if (is_struct(_raw.name)) {
                _name = variable_struct_exists(_raw.name, _lang) ? _raw.name[$ _lang] : _raw.name.pt;
            } else {
                _name = string(_raw.name);
            }
        }

        // Resolve texto de fala no idioma ativo
        var _text = "";
        if (variable_struct_exists(_raw, "text")) {
            if (is_struct(_raw.text)) {
                _text = variable_struct_exists(_raw.text, _lang) ? _raw.text[$ _lang] : _raw.text.pt;
            } else {
                _text = string(_raw.text);
            }
        }

        var _alien = variable_struct_exists(_raw, "alien") ? _raw.alien : "";
        var _speaker = _is_hero ? _cls : (variable_struct_exists(_raw, "speaker") ? _raw.speaker : "knight");
        var _portrait = variable_struct_exists(_raw, "portrait") ? _raw.portrait : -1;

        array_push(_resolved_lines, {
            speaker: _speaker,
            name: _name,
            alien: _alien,
            text: _text,
            portrait: _portrait
        });
    }

    dialogue_start(_resolved_lines, _on_finish);
}
