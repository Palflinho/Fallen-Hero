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
    // 1B. VILA SUBTERRÂNEA: NOVOS MORADORES & DIÁLOGOS REATIVOS
    // ---------------------------------------------------------------------

    // --- FERREIRO: MESTRE CARAPÁCIO ---
    global.dialogue_db[$ "village_blacksmith_knight"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Klink-kahn! Tor-kro brokel! »",
            text: {
                pt: "Irmao de carapaca! Seu broquel suportou bem os golpes dos corrompidos? Lembre-se: uma espada pesada de tatu nao corta apenas carne; ela carrega o peso sagrado da nossa montanha!",
                en: "Shell-brother! Has your buckler withstood the corrupted blows? Remember: a heavy armadillo blade doesn't just cut flesh; it bears the sacred weight of our mountains!"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_mage"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Zzz-shok follis astra! »",
            text: {
                pt: "Saudacoes, xama da matilha! Cuidado ao canalizar tantas faiscas arcanas perto dos meus foles de couro, ou faremos voar a caverna inteira pelos ares!",
                en: "Greetings, pack shaman! Careful channeling all those arcane sparks near my leather bellows, or we will blast this entire cavern to the skies!"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_archer"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Taktik ferrum teiu-bow! »",
            text: {
                pt: "Olha so, o cacador teiu de sangue frio! Traga restos de ferro das profundezas se quiser que eu reforce a empunhadura e as roldanas do seu arco!",
                en: "Look here, cold-blooded teiu hunter! Bring back iron scraps from the depths if you want me to reinforce the grip and pulleys of your bow!"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_assassin"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Shh-vorn umbra feather! »",
            text: {
                pt: "Silencioso como um espectro, urutau voador... Suas laminas de penugem precisam de amolacao na pedra-pomes ou apenas de sombras para fazer o estrago?",
                en: "Silent as a specter, flying urutau... Do your down-feather blades need sharpening on pumice, or just darkness to wreak havoc?"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_elem_water"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Aqua-tempera purissim! »",
            text: {
                pt: "Gracas aos deuses antigos! A Essencia da Agua pura reabasteceu nosso tanque de tempera. O aco das armas agora esfria com perfeicao sem trincar!",
                en: "Praise the ancient gods! The pure Water Essence has replenished our quenching trough. The weapon steel cools perfectly now without cracking!"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_elem_fire"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« IGNIS AURA VULCAN! »",
            text: {
                pt: "Pelos ancestrais! O Fogo Sagrado voltou a rugir nas grelhas da forja! O calor e a esperanca de forjar armas divinas retornaram a este abrigo!",
                en: "By the ancestors! The Sacred Fire roars once more in the forge grates! Heat and the hope of crafting divine arms have returned to this shelter!"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_elem_wind"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Zephyr ventilus turbo! »",
            text: {
                pt: "O vento das catacumbas voltou a fluir com vigor pelas tubulacoes! Nem preciso forcar meus bracos nos foles, a fornalha queima sozinha!",
                en: "The catacomb wind flows with vigor through the pipes again! I barely need to pump the bellows, the hearth feeds itself!"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_elem_earth"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Terra mineralis grandis! »",
            text: {
                pt: "A Rocha-Mae despertou! As paredes da caverna estao pulsando veios de ferro titanico e obsidiana pura! Podemos forjar o melhor arsenal de todos os tempos!",
                en: "The Mother Rock has awakened! The cave walls pulse with titanic iron and pure obsidian! We can forge the greatest arsenal of all time!"
            }
        }
    ];

    global.dialogue_db[$ "village_blacksmith_default"] = [
        {
            speaker: "blacksmith",
            name: { pt: "Mestre Carapacio", en: "Master Carapacio" },
            alien: "« Ferrum et silex resiste! »",
            text: {
                pt: "As forjas ancestrais resistem, mesmo com a superficie reduzida a cinzas. Se cruzar o portal, golpeie com decisao e proteja seu peito!",
                en: "The ancestral forges endure, even with the surface turned to ash. If you step through the portal, strike with conviction and guard your chest!"
            }
        }
    ];

    // --- ALQUIMISTA: CURANDEIRA KALINA ---
    global.dialogue_db[$ "village_alchemist_knight"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Salve bastio... ungüent herba. »",
            text: {
                pt: "Bravo cavaleiro... Toda essa pesada carapaca de pedra nao impede seus musculos de se desgastarem. Beba meus extratos de raiz quando voltar da fenda.",
                en: "Brave knight... All that heavy stone armor does not prevent muscle fatigue. Drink my root extracts when you return from the rift."
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_mage"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Lupus soror... mana estatica. »",
            text: {
                pt: "Irma da matilha! Sinto a estatica arcana dancando em sua pelagem avermelhada. Nossos unguentos curativos e seus feiticos nasceram da mesma seiva primordial.",
                en: "Pack sister! I sense the arcane static dancing on your red fur. Our healing salves and your spells were born of the same primordial sap."
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_archer"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Teiu oculus... herba venandi. »",
            text: {
                pt: "Vejo seus dedos calejados pela corda do arco, teiu. Nao deixe a solidao e o veneno dos ermos congelarem seu coracao vigilante.",
                en: "I see your calloused fingers from the bowstring, teiu. Do not let the wasteland's venom freeze your watchful heart."
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_assassin"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Avis umbralis... lunaris elixir. »",
            text: {
                pt: "Seus passos nem tocam a poeira, voador urutau... Misturei essencias de orvalho lunar para cicatrizar as feridas escondidas sob sua penugem.",
                en: "Your steps barely stir the dust, flying urutau... I blended lunar dew essences to mend the wounds hidden under your feathers."
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_elem_water"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Fons vivus resurgit! »",
            text: {
                pt: "O poço de liquens voltou a verter agua pura e fresca! Nossos refugiados feridos nao sofrem mais de sede e os cogumelos medicinais voltaram a brotar!",
                en: "The lichen well flows with pure, fresh water once more! Our wounded refugees thirst no longer, and medicinal mosses are sprouting again!"
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_elem_fire"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Caldor sanitas calor! »",
            text: {
                pt: "O frio gélido e sepulcral que assolava os leitos se dissipou! Com a Essencia do Fogo, meus caldeiroes fervem infusões revigorantes que reanimam os caidos.",
                en: "The grave cold that afflicted our sickbeds has lifted! With the Fire Essence, my cauldrons brew invigorating infusions to revive the fallen."
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_elem_wind"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Aura munda respiratio! »",
            text: {
                pt: "O ar estagnado e sufocante das cavernas foi varrido por uma brisa pura! O mofo cinzento recuou dos nossos estoques de ervas.",
                en: "The stagnant, suffocating cavern air has been swept clean by a pure breeze! Grey rot has retreated from our herb stores."
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_elem_earth"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Terra germinat vita! »",
            text: {
                pt: "A Terra Mãe restabeleceu a fertilidade do subsolo! Cogumelos dourados florescem diretamente nas fendas da rocha. Nosso povo nao perecera!",
                en: "Mother Earth has restored underground vitality! Golden mushrooms bloom straight from rock crevices. Our kin shall not perish!"
            }
        }
    ];

    global.dialogue_db[$ "village_alchemist_default"] = [
        {
            speaker: "alchemist",
            name: { pt: "Curandeira Kalina", en: "Healer Kalina" },
            alien: "« Pax tibi herba fides. »",
            text: {
                pt: "Preserve sua forca e seu foco nas catacumbas. As anomalias parasitarias que tomaram os templos drenam nao apenas a vida, mas a determinacao.",
                en: "Preserve your strength and focus in the catacombs. The parasitic anomalies that seized the temples drain not just life, but resolve."
            }
        }
    ];

    // --- BATEDOR: RASTREADOR TICO ---
    global.dialogue_db[$ "village_scout_knight"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Eko carapax! Schild-bloq! »",
            text: {
                pt: "E ai, casca-grossa! Seus passos ecoam pelos tuneis feito trovão. Contra os monstros voadores e lodos ageis, plante o escudo no chao e deixe que quebrem a cara!",
                en: "Hey there, tough-shell! Your strides echo through the tunnels like thunder. Against fast fliers and agile slimes, plant that shield and let them shatter themselves!"
            }
        }
    ];

    global.dialogue_db[$ "village_scout_mage"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Spark-lupus procul vis! »",
            text: {
                pt: "Maga! Do alto da guarita vejo as explosoes dos seus raios na entrada do portal. Mantenha distancia segura dos golens antes de disparar suas centelhas!",
                en: "Mage! From atop the watchpost I see your lightning flashes at the portal mouth. Keep a safe distance from golems before unleashing your sparks!"
            }
        }
    ];

    global.dialogue_db[$ "village_scout_archer"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Frater teiu! Telum oculis! »",
            text: {
                pt: "Parceiro de escamas! A flecha certa sempre perfura o núcleo do lodo. Fique atento as pocas de veneno e fogo que os chefes espalham no solo das arenas.",
                en: "Scale-mate! The right arrow always pierces the slime core. Watch the venom and fire pools that bosses scatter across arena floors."
            }
        }
    ];

    global.dialogue_db[$ "village_scout_assassin"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Aaaah urutau! Tergo krits! »",
            text: {
                pt: "Caramba, urutau! Quase caí da torre com voce pousando sem respirar. Seus ataques pelas costas aplicam dano critico devastador... continue atacando nas sombras!",
                en: "Whoa, urutau! You almost made me fall off the tower landing without a sound. Backstabs deal devastating critical damage... keep striking from darkness!"
            }
        }
    ];

    global.dialogue_db[$ "village_scout_elem_water"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Sector aqua limpidus! »",
            text: {
                pt: "Relatório da sentinela: a mare corrupta do Templo 1 cessou! As criaturas de lodo na entrada do portal estao desorientadas sem o controle do Rei Slime!",
                en: "Sentry report: the corrupted tide of Temple 1 has ceased! Slime beasts at the portal gate wander confused without the Slime King's sway!"
            }
        }
    ];

    global.dialogue_db[$ "village_scout_elem_fire"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Fumus fumo clarus! »",
            text: {
                pt: "A fumaça asfixiante do setor leste dispersou! Consigo ver as trilhas de basalto claramente pelo binoculo. Os monstros igneos recuaram!",
                en: "The choking smoke of the eastern sector has cleared! I can spot basalt pathways clearly through the glass. Magma beasts have pulled back!"
            }
        }
    ];

    global.dialogue_db[$ "village_scout_elem_wind"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Ventus vortex silex! »",
            text: {
                pt: "As rajadas cortantes do terceiro templo se calmaram! Os furacoes que arrancavam pontes foram domados com o retorno da Essencia do Vento!",
                en: "The shearing gales of the third temple have quieted! Tornadoes that shredded bridges are tamed now that Wind's Essence is back!"
            }
        }
    ];

    global.dialogue_db[$ "village_scout_elem_earth"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Terra stabila via patet! »",
            text: {
                pt: "Os tremores colossais cessaram! A rota ao norte para o Santuário Orbital esta desimpedida. O caminho para o confronto final esta aberto!",
                en: "The colossal quakes have ceased! The northern route to the Orbital Sanctuary is clear. The way to the final confrontation lies open!"
            }
        }
    ];

    global.dialogue_db[$ "village_scout_default"] = [
        {
            speaker: "scout",
            name: { pt: "Rastreador Tico", en: "Scout Tico" },
            alien: "« Oculis vigiles ad portas! »",
            text: {
                pt: "Os horizontes da fenda estao infestados de ameacas. Estude o padrao de ataque de cada criatura e nao hesite em recuar para esquivar!",
                en: "The rift horizons are infested with threats. Study each creature's attack patterns and never hesitate to roll and evade!"
            }
        }
    ];

    // --- ORÁCULO: GUARDIÃO DO VÉU ---
    global.dialogue_db[$ "village_oracle_knight"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Murmur saxum... tragicus pondus. »",
            text: {
                pt: "Guerreiro inabalavel... Voce carrega a esperanca de todos os cascos e tocas, mas sera capaz de suportar a verdade amarga que jaz no final da sua espada?",
                en: "Unshakable warrior... You bear the hopes of every burrow and shell, but will you endure the bitter truth waiting at the tip of your blade?"
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_mage"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Astra flens... duae stellae. »",
            text: {
                pt: "Xama dos horizontes... Seus olhos buscam a luz elemental, mas as sombras celestes revelam que quem usurpou nosso mundo tambem chorava de desespero.",
                en: "Shaman of the horizons... Your eyes seek elemental light, yet celestial shadows reveal that the one who stole from us also wept in despair."
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_archer"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Telum fatum... homo exul. »",
            text: {
                pt: "Cacador silencioso... Sua flecha enxerga o alvo fisico, mas sua alma ainda nao fitou o rosto do homem exilado que ergueu a cupula de ferro.",
                en: "Silent hunter... Your arrow spots the physical target, yet your soul has not gazed upon the face of the exiled man who built the iron dome."
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_assassin"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Urutau cognatus... sanguis et aether. »",
            text: {
                pt: "Irmao de asas noturnas... Conhecemos a solidao do camuflado. A faca que ceifar o invasor pode estar sentenciando criancas de outro firmamento.",
                en: "Night-winged kin... We know the camouflage of loneliness. The knife that fells the invader may well condemn children under another sky."
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_elem_water"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Lacrima oceani reversa... »",
            text: {
                pt: "A primeira lagrima primordial retornou ao pedestal... Porem, no eco do éter, ouco o choro asfixiado de uma biosfera distante que comeca a ressecar.",
                en: "The first primordial tear has returned to the pedestal... Yet through the ether, I hear the choked weeping of a distant biosphere beginning to parch."
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_elem_fire"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Flamma gemina ardet... »",
            text: {
                pt: "A centelha sacra queima nos altares. Contudo, a chama que nos aquece aqui subtrai o calor dos geradores que mantinham viva a ultima colonia humana.",
                en: "The sacred spark burns on our altars. Yet the flame warming us here siphons heat from the generators keeping the last human colony alive."
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_elem_wind"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Zephyrus veritas loquitur... »",
            text: {
                pt: "O sopro da vida canta nas grutas. Nao ha monstros demoniacos nesta guerra, heroi... Ha apenas dois povos agonizantes disputando a mesma gota de orvalho.",
                en: "The breath of life sings in the grottos. There are no demonic fiends in this war, hero... Only two dying peoples fighting over the very same dewdrop."
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_elem_earth"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Quattuor stelae consummatio! »",
            text: {
                pt: "Os Quatro Pilares estao acesos! A abobada superior agora escancara sua porta. Va, heroi... Va e encare o espelho que a humanidade preparou para voce.",
                en: "The Four Pillars are alight! The upper vault now flings its doors wide. Go, hero... Go and face the mirror humanity has prepared for you."
            }
        }
    ];

    global.dialogue_db[$ "village_oracle_default"] = [
        {
            speaker: "oracle",
            name: { pt: "Guardiao do Veu", en: "Veil Guardian" },
            alien: "« Fatum duobus mundis ligatum... »",
            text: {
                pt: "O abismo escuta seus passos. Cada golpe desferido nos templos altera nao apenas o nosso passado, mas a respiracao do cosmo inteiro.",
                en: "The abyss listens to your footsteps. Every blow struck in the temples alters not only our past, but the breath of the cosmos itself."
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
// HIGIENIZAÇÃO DE TEXTO PARA FONTES ASCII DO GAMEMAKER
// -------------------------------------------------------------------------
function loc_clean_text(_str) {
    if (!is_string(_str) || _str == "") return _str;
    
    var _s = _str;
    _s = string_replace_all(_s, "á", "a");
    _s = string_replace_all(_s, "à", "a");
    _s = string_replace_all(_s, "ã", "a");
    _s = string_replace_all(_s, "â", "a");
    _s = string_replace_all(_s, "ä", "a");
    _s = string_replace_all(_s, "Á", "A");
    _s = string_replace_all(_s, "À", "A");
    _s = string_replace_all(_s, "Ã", "A");
    _s = string_replace_all(_s, "Â", "A");
    _s = string_replace_all(_s, "Ä", "A");
    
    _s = string_replace_all(_s, "é", "e");
    _s = string_replace_all(_s, "è", "e");
    _s = string_replace_all(_s, "ê", "e");
    _s = string_replace_all(_s, "ë", "e");
    _s = string_replace_all(_s, "É", "E");
    _s = string_replace_all(_s, "È", "E");
    _s = string_replace_all(_s, "Ê", "E");
    
    _s = string_replace_all(_s, "í", "i");
    _s = string_replace_all(_s, "ì", "i");
    _s = string_replace_all(_s, "î", "i");
    _s = string_replace_all(_s, "ï", "i");
    _s = string_replace_all(_s, "Í", "I");
    _s = string_replace_all(_s, "Ì", "I");
    _s = string_replace_all(_s, "Î", "I");
    
    _s = string_replace_all(_s, "ó", "o");
    _s = string_replace_all(_s, "ò", "o");
    _s = string_replace_all(_s, "õ", "o");
    _s = string_replace_all(_s, "ô", "o");
    _s = string_replace_all(_s, "ö", "o");
    _s = string_replace_all(_s, "Ó", "O");
    _s = string_replace_all(_s, "Ò", "O");
    _s = string_replace_all(_s, "Õ", "O");
    _s = string_replace_all(_s, "Ô", "O");
    
    _s = string_replace_all(_s, "ú", "u");
    _s = string_replace_all(_s, "ù", "u");
    _s = string_replace_all(_s, "û", "u");
    _s = string_replace_all(_s, "ü", "u");
    _s = string_replace_all(_s, "Ú", "U");
    _s = string_replace_all(_s, "Ù", "U");
    _s = string_replace_all(_s, "Û", "U");
    
    _s = string_replace_all(_s, "ç", "c");
    _s = string_replace_all(_s, "Ç", "C");
    _s = string_replace_all(_s, "ñ", "n");
    _s = string_replace_all(_s, "Ñ", "N");
    
    return _s;
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
            name: loc_clean_text(_name),
            alien: _alien,
            text: loc_clean_text(_text),
            portrait: _portrait
        });
    }

    dialogue_start(_resolved_lines, _on_finish);
}

// -------------------------------------------------------------------------
// Resolvedor de Diálogo Reativo para NPCs da Vila Subterrânea
// -------------------------------------------------------------------------
function village_get_npc_dialogue_id(_npc_id) {
    dialogue_db_init();

    // 1. Obtem a classe ativa do jogador
    var _char = "knight";
    var _p = instance_find(obj_player, 0);
    if (_p != noone && variable_instance_exists(_p, "character_class")) {
        _char = _p.character_class;
    } else if (variable_global_exists("selected_character")) {
        _char = global.selected_character;
    }

    // 2. Avalia essencias resgatadas
    var _has_water = element_is_reclaimed("water");
    var _has_fire = element_is_reclaimed("fire");
    var _has_wind = element_is_reclaimed("wind");
    var _has_earth = element_is_reclaimed("earth");

    // 3. Alternancia de turnos por NPC
    if (!variable_global_exists("npc_dialogue_turn")) global.npc_dialogue_turn = {};
    if (!variable_struct_exists(global.npc_dialogue_turn, _npc_id)) global.npc_dialogue_turn[$ _npc_id] = 0;
    var _turn = global.npc_dialogue_turn[$ _npc_id];
    global.npc_dialogue_turn[$ _npc_id] = (_turn + 1) mod 2;

    if (_turn == 0) {
        // Turno de reacao ao progresso elemental da vila
        if (_has_earth) return "village_" + _npc_id + "_elem_earth";
        if (_has_wind) return "village_" + _npc_id + "_elem_wind";
        if (_has_fire) return "village_" + _npc_id + "_elem_fire";
        if (_has_water) return "village_" + _npc_id + "_elem_water";
        return "village_" + _npc_id + "_default";
    } else {
        // Turno de reacao a classe especifica do heroi
        return "village_" + _npc_id + "_" + _char;
    }
}

