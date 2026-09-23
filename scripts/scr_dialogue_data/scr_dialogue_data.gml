// =========================================================================
// TABELA MODULAR CENTRALIZADA DE DIALOGOS (Fallen Hero)
// =========================================================================
// Este arquivo contem TODOS os dialogos narrativos do jogo.
//
// FORMATO DE CADA CENA:
// global.dialogue_db[$ "id_da_cena"] = [
//     {
//         speaker: "knight" | "mage" | "archer" | "assassin" | "merchant" | "general" | "elder" | "human",
//         name: { pt: "Nome PT", en: "Name EN", es: "Nombre ES", ja: "名前 JA" }  // ou string simples
//         alien: "« Texto na lingua dos bichinhos »", // opcional
//         text: {
//             pt: "Texto em Portugues",
//             en: "Text in English",
//             es: "Texto en Español",
//             ja: "日本語のテキスト"
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
            name: { pt: "Ancião Tatupóba", en: "Elder Tatupoba", es: "Anciano Tatupoba", ja: "長老タトゥポバ" },
            alien: "« Kuru-vahn... tor'ma zek-kahn... »",
            text: {
                pt: "Herói... Você despertou sob as raízes da terra ancestral. A superfície sucumbiu após o roubo das Quatro Essências. Os Quatro Pedestais ao norte choram por seu retorno!",
                en: "Hero... You awaken beneath the roots of the ancestral earth. The surface fell after the Four Essences were stolen. The Four Pedestals to the north weep for their return!",
                es: "Héroe... Despertaste bajo las raíces de la tierra ancestral. La superficie sucumbió tras el robo de las Cuatro Esencias. ¡Los Cuatro Pedestales al norte lloran por su regreso!",
                ja: "英雄よ...そなたは先祖伝来の大地の根元で目覚めた。四つの精髄が奪われ、地上は崩壊した。北にある四つの台座がそなたの帰還を待っておる！"
            }
        },
        {
            speaker: "elder",
            name: { pt: "Ancião Tatupóba", en: "Elder Tatupoba", es: "Anciano Tatupoba", ja: "長老タトゥポバ" },
            alien: "« Sha-vortex mor lumina kupo! »",
            text: {
                pt: "Adentre o Portal de Expedição. Derrote os Generais guardiões de cada templo e traga os núcleos. Quando os 4 pedestais brilharem juntos, o portal revelará a câmara do misterioso usurpador!",
                en: "Step into the Expedition Portal. Defeat the guardian Generals of each temple and bring back their cores. When all 4 pedestals blaze together, the portal will reveal the chamber of the mysterious usurper!",
                es: "Entra al Portal de Expedición. Derrota a los Generales guardianes de cada templo y trae sus núcleos. ¡Cuando los 4 pedestales brillen juntos, el portal revelará la cámara del usurpador!",
                ja: "遠征の門へ進むのじゃ。各神殿の守護将軍を倒し、核を持ち帰れ。四つの台座が再び輝く時、謎の簒奪者が待つ部屋への扉が開かれよう！"
            }
        }
    ];

    global.dialogue_db[$ "village_pedestals_hint"] = [
        {
            speaker: "elder",
            name: { pt: "Ancião Tatupóba", en: "Elder Tatupoba", es: "Anciano Tatupoba", ja: "長老タトゥポバ" },
            alien: "« Vahr-altar astra lok! »",
            text: {
                pt: "Estes são os Quatro Pedestais Sagrados: Água, Fogo, Vento e Terra. Conforme libertar cada bioma, o respectivo altar despertará com o fogo elemental puro.",
                en: "These are the Four Sacred Pedestals: Water, Fire, Wind, and Earth. As you liberate each biome, the corresponding altar will awaken with pure elemental fire.",
                es: "Estos son los Cuatro Pedestales Sagrados: Agua, Fuego, Viento y Tierra. A medida que liberes cada bioma, el altar correspondiente despertará con fuego elemental puro.",
                ja: "これらは四つの聖なる台座じゃ：水、火、風、そして地。各地域を解放するたび、対応する祭壇が純粋な属性の炎を灯すであろう。"
            }
        }
    ];

    // ---------------------------------------------------------------------
    // 2. TEMPLO 1: TEMPLO DA ÁGUA
    // ---------------------------------------------------------------------
    global.dialogue_db[$ "temple1_water_intro"] = [
        {
            speaker: "knight",
            name: { pt: "Rinoceronte Cavaleiro [Guardião]", en: "Rhino Knight [Guardian]", es: "Rinoceronte Caballero [Guardián]", ja: "サイ騎士 [守護者]" },
            alien: "« Kro-tash! Zuk-zuk vahr tor'kahn! »",
            text: {
                pt: "As ruínas do Templo da Água... Sinto a umidade pesada e o lodo corrompido adiante. Minha couraça e minha lâmina não vacilarão!",
                en: "The ruins of the Water Temple... Heavy moisture and corrupted mire pulse ahead. My hide and blade shall not falter!",
                es: "Las ruinas del Templo del Agua... Siento la pesada humedad y el lodo corrupto más adelante. ¡Mi coraza y mi espada no vacilarán!",
                ja: "水の神殿の遺跡...重い湿気と穢れた泥が渦巻いている。我が鎧皮と刃は決して屈せぬ！"
            }
        }
    ];

    global.dialogue_db[$ "temple1_water_boss"] = [
        {
            speaker: "general",
            name: { pt: "General da Água [Guardião Corrompido]", en: "Water General [Corrupted Guardian]", es: "General del Agua [Guardián Corrupto]", ja: "水の将軍 [穢れた守護者]" },
            alien: "« GORR-ZUL! KRAKATOA VORTEX NAL-MOR! »",
            text: {
                pt: "Tolos mortais... Vocês rastejam até aqui se achando heróis?! Vocês não entendem o sacrifício! A Terra está morrendo e este poder a salvará!",
                en: "Foolish mortals... You crawl here thinking yourselves heroes?! You do not comprehend the sacrifice! Earth is dying, and this power shall save it!",
                es: "¡Necios mortales!... ¿Se arrastran hasta aquí creyéndose héroes? ¡No comprenden el sacrificio! ¡La Tierra está muriendo y este poder la salvará!",
                ja: "愚かな者どもめ...自らを英雄と思い込んでここまで這い寄ったか？！貴様らには真の犠牲が理解できぬ！滅びゆく地球はこの力で救われるのだ！"
            }
        },
        {
            speaker: "knight",
            name: { pt: "Herói", en: "Hero", es: "Héroe", ja: "英雄" },
            alien: "« Zuk-kahn tor'valasha! »",
            text: {
                pt: "A ganância e o medo cegam seu propósito, General! O Templo da Água será purificado!",
                en: "Greed and fear have blinded your purpose, General! The Water Temple shall be cleansed!",
                es: "¡La codicia y el miedo ciegan tu propósito, General! ¡El Templo del Agua será purificado!",
                ja: "恐れと執着がお前の目を曇らせたのだ、将軍！水の神殿は我らが浄化する！"
            }
        },
        {
            speaker: "general",
            name: { pt: "General da Água [Guardião Corrompido]", en: "Water General [Corrupted Guardian]", es: "General del Agua [Guardián Corrupto]", ja: "水の将軍 [穢れた守護者]" },
            alien: "« SKRAAA-VORTEX! DROWN IN TIDES! »",
            text: {
                pt: "Então afoguem-se sob o peso esmagador das profundezas abissais!",
                en: "Then drown beneath the crushing weight of the abyssal depths!",
                es: "¡Entonces ahóguense bajo el peso aplastante de las profundidades abisales!",
                ja: "ならば深淵の圧倒的な重圧に沈み、溺れるがよい！"
            }
        }
    ];

    // ---------------------------------------------------------------------
    // 3. TEMPLO 3: TEMPLO DO VENTO (FASE 3)
    // ---------------------------------------------------------------------
    global.dialogue_db[$ "temple3_wind_intro"] = [
        {
            speaker: "archer",
            name: { pt: "Lagarto Arqueiro [Franco-Atirador]", en: "Lizard Archer [Marksman]", es: "Lagarto Arquero [Tirador]", ja: "トカゲ弓兵 [狙撃手]" },
            alien: "« Sssss-kree! Zzzt lok-dar skree! »",
            text: {
                pt: "O Templo do Vento... Ciclones cortantes e vendavais rugem entre as fendas aéreas. Meus olhos de réptil acompanharão cada rajada!",
                en: "The Wind Temple... Razor cyclones and howling gales roar through aerial chasms. My reptilian eyes shall trace every gust!",
                es: "El Templo del Viento... Ciclones afilados y vendavales rugen entre las grietas aéreas. ¡Mis ojos de reptil seguirán cada ráfaga!",
                ja: "風の神殿...空中回廊を切り裂く旋風と怒号の嵐。我が爬虫類の眼は、いかなる突風の軌道も見逃しはせぬ！"
            }
        }
    ];

    global.dialogue_db[$ "temple3_wind_boss"] = [
        {
            speaker: "general",
            name: { pt: "General Zephyrus [Mestre dos Vendavais]", en: "General Zephyrus [Master of Gales]", es: "General Zephyrus [Maestro de Vendavales]", ja: "風将ゼピュロス [疾風の覇者]" },
            alien: "« ZEPHYR-KRAAA! TEMPEST VOID SHRED! »",
            text: {
                pt: "Quem ousa desafiar os céus roubados?! O ar deste mundo não pertence mais a vocês... Cada rajada impulsiona a salvação da nossa espécie!",
                en: "Who dares defy the stolen skies?! The atmosphere of this world no longer belongs to you... Every gale fuels the salvation of our kind!",
                es: "¡¿Quién osa desafiar los cielos robados?! El aire de este mundo ya no les pertenece... ¡Cada ráfaga impulsa la salvación de nuestra especie!",
                ja: "奪われし蒼穹に仇なす者は誰だ？！この大気はもはや貴様らのものではない...すべての風が、我ら人類の救済を加速させているのだ！"
            }
        },
        {
            speaker: "archer",
            name: { pt: "Herói", en: "Hero", es: "Héroe", ja: "英雄" },
            alien: "« Sssss-lok vahr gale! »",
            text: {
                pt: "Você roubou o fôlego da nossa fauna e espalhou tempestades! Suas asas cairão aqui, Zephyrus!",
                en: "You choked the breath of our creatures and unleashed tempests! Your wings shall fall right here, Zephyrus!",
                es: "¡Robaste el aliento de nuestra fauna y desataste tempestades! ¡Tus alas caerán aquí, Zephyrus!",
                ja: "生きとし生けるものの息吹を奪い、嵐を撒き散らした罪は重い！お前の翼はここで地に堕ちるぞ、ゼピュロス！"
            }
        },
        {
            speaker: "general",
            name: { pt: "General Zephyrus [Mestre dos Vendavais]", en: "General Zephyrus [Master of Gales]", es: "General Zephyrus [Maestro de Vendavales]", ja: "風将ゼピュロス [疾風の覇者]" },
            alien: "« HURRICANE-RAZOR BLADES! »",
            text: {
                pt: "Testem a fúria do vácuo absoluto! Nenhuma flecha voará contra o meu furacão!",
                en: "Taste the fury of absolute vacuum! No arrow shall fly against my hurricane!",
                es: "¡Prueben la furia del vacío absoluto! ¡Ninguna flecha volará contra mi huracán!",
                ja: "絶対真空の猛威を味わうがよい！我が暴風に向かって飛べる矢など存在せぬ！"
            }
        }
    ];

    // ---------------------------------------------------------------------
    // 4. TEMPLO 5: MERCADOR PRE-CHEFE & O CONFRONTO HUMANO
    // ---------------------------------------------------------------------
    global.dialogue_db[$ "temple5_shop_intro"] = [
        {
            speaker: "merchant",
            name: { pt: "Mercador das Marés", en: "Tide Merchant", es: "Mercader de las Mareas", ja: "潮の商人" },
            alien: "« Ooo-la... Omni-gem finalis... »",
            text: {
                pt: "Herói... Você reuniu os Quatro Elementos. Além daquela porta blindada não há mais monstros... Apenas o artífice por trás de toda essa tragédia. Use seu ouro. Compre tudo o que precisar.",
                en: "Hero... You have gathered the Four Elements. Beyond that armored blast-door lie no beasts... Only the architect behind this entire tragedy. Spend your gold. Take all you require.",
                es: "Héroe... Has reunido los Cuatro Elementos. Más allá de esa puerta blindada no hay monstruos... Solo el artífice detrás de toda esta tragedia. Usa tu oro. Compra todo lo que necesites.",
                ja: "英雄よ...四つの属性をすべて集めたのだな。あの防壁扉の向こうに魔物はもうおらぬ...この悲劇を仕組んだ張本人が待つのみじゃ。残る金をすべて使い、必要な力を蓄えよ。"
            }
        }
    ];

    global.dialogue_db[$ "temple5_human_boss"] = [
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]", es: "El Salvador [Dr. Victor - Humano]", ja: "救済者 [ヴィクター博士 - 人類]" },
            alien: "",
            text: {
                pt: "Então foram vocês... Os guardiões deste planeta primitivo conseguiram romper todas as minhas defesas de contenção.",
                en: "So it was you... The guardians of this primitive planet managed to breach all of my containment barriers.",
                es: "Así que fueron ustedes... Los guardianes de este planeta primitivo lograron romper todas mis barreras de contención.",
                ja: "貴様らだったのか...この原生惑星の守護者どもが、私のすべての隔離防壁を突破してくるとはな。"
            }
        },
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]", es: "El Salvador [Dr. Victor - Humano]", ja: "救済者 [ヴィクター博士 - 人類]" },
            alien: "",
            text: {
                pt: "Vocês me olham como um monstro, não é? Mas sabem o que está em jogo? A Terra, o meu lar, secou. Bilhões de vidas humanas estão sufocando na escuridão! As suas essências eram a nossa única esperança de reiniciar a biosfera!",
                en: "You look at me as if I were a monster, don't you? But do you understand the stakes? Earth, my home, has withered away. Billions of human souls are suffocating in the dark! Your essences were our sole hope to reignite our biosphere!",
                es: "¿Me miran como si fuera un monstruo, verdad? ¿Pero saben lo que está en juego? La Tierra, mi hogar, se marchitó. ¡Miles de millones de almas se asfixian en la oscuridad! ¡Sus esencias eran nuestra única esperanza de revivir la biosfera!",
                ja: "私を怪物を見るような目で見ているな？だが何が懸かっているか分かっているのか？私の故郷、地球は干上がった。何十億もの人類が暗闇の中で息絶えようとしている！貴様らの精髄こそが、生物圏を再起動する唯一の希望なのだ！"
            }
        },
        {
            speaker: "knight",
            name: { pt: "Herói", en: "Hero", es: "Héroe", ja: "英雄" },
            alien: "« Tor-vahr terra... non extinguish nos! »",
            text: {
                pt: "Destruir a vida de um mundo para salvar outro não é salvação... É apenas condenar inocentes ao mesmo destino. Devolva as essências!",
                en: "Extinguishing one world to save another is not salvation... It is merely dooming innocents to the very same fate. Surrender the essences!",
                es: "Destruir la vida de un mundo para salvar otro no es salvación... Es solo condenar inocentes al mismo destino. ¡Devuelve las esencias!",
                ja: "一つの世界を滅ぼして別の世界を救うことなど救済ではない...それは無実の命を同じ絶望に突き落とすだけだ。精髄を返してもらう！"
            }
        },
        {
            speaker: "human",
            name: { pt: "O Salvador [Dr. Victor - Humano]", en: "The Savior [Dr. Victor - Human]", es: "El Salvador [Dr. Victor - Humano]", ja: "救済者 [ヴィクター博士 - 人類]" },
            alien: "",
            text: {
                pt: "Não posso recuar. Não quando estou tão perto. Ativar exoesqueleto de combate! Protocolo de Defesa Máxima!",
                en: "I cannot turn back. Not when I am this close. Combat exoskeleton engaged! Maximum Defense Protocol initiated!",
                es: "No puedo retroceder. No estando tan cerca. ¡Exoesqueleto de combate activado! ¡Protocolo de Defensa Máxima iniciado!",
                ja: "引き返すことなどできぬ。ここまで近づいた今となってはな。戦闘用外骨格起動！最大防衛プロトコルを開始する！"
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

    for (var _i = 0; _i < array_length(_raw_lines); _i++) {
        var _raw = _raw_lines[_i];
        
        // Resolve nome no idioma ativo
        var _name = "Herói";
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
        var _speaker = variable_struct_exists(_raw, "speaker") ? _raw.speaker : "knight";
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
