# Fallen Hero — Interações de Classe

Princípio: **cada herói lê o mesmo inimigo de um jeito diferente**. Toda classe tem um **verbo base** (vale para todas as especializações) e cada **especialização** tem uma interação própria, geralmente contra o elemento oposto ao seu.

Código: `class_interaction_on_hit()` e helpers em `scripts/scr_elemental_ai`; ganchos nos inimigos (`fh_air`, `fh_mist_cut`, `fh_channeling`, `fh_pierce_next`, `fh_force_emerge`, `fh_revealed`).

## Verbos base

| Classe | Verbo | O que faz |
|---|---|---|
| **Cavaleiro (Rinoceronte)** | **SEGURAR** | Com o escudo erguido, segura **investidas**: General Magma, rolamento do Slime de Terra, rajada da Sílfide. Escudo comum/aura = segura parcial (arrastado, dano reduzido, janela curta). Guardião/Duelista = segura total (sem dano, janela cheia). |
| **Maga (Raposa)** | **INTERROMPER** | Magia acertando quem está **canalizando** cancela: chuva de meteoros do Conjurador de Magma, barreira do Conjurador de Vento, cura da Ondina. O inimigo fica exausto (+50% de dano). |
| **Arqueiro (Lagarto)** | **DERRUBAR** | Flechas acertam o que está **no ar**: Slime de Vento saltando cai tonto (1 flecha); **Zephyrus** voando cai após **5 flechas** (contador "PENAS x/5"); Fogo-fátuo morre com 1 flecha. |
| **Assassino (Urutau)** | **SOMBRA** | Invisível, tudo que **persegue perde o alvo**: bolha, Orbe Glacial, marcador da estaca, meteoros (erram), sombra do mergulho do Zephyrus, Gnomo/Salamandra sob a terra. Golpes no **núcleo do Titã** pelas costas causam **dano dobrado**. |

## Especializações

| Especialização | Interação |
|---|---|
| Cavaleiro | Verbo base (escudo segura parcial). |
| **Lanceiro** (Água) | Depois de cada golpe, uma **ponta d'água** atrasada vai um pouco além da lança (até +15% de alcance) e **derruba voadores**. A aura **purifica o chão**: apaga fogo e derrete gelo dentro do raio. Segura investidas (parcial). |
| **Cavaleiro Rúnico** (Fogo → Maga) | Todo golpe que acerta detona uma **runa de fogo em área**, que também **interrompe canalizações**. **Fúria inabalável**: durante a Fúria não é empurrado, puxado, lento nem preso em bolhas. |
| **Duelista** (Vento) | **Aparar** no momento do impacto segura investidas por completo ("APARADO!"). |
| **Guardião** (Terra) | **Muralha viva**: segura investidas sem recuar nem sofrer dano; carapaça do Slime de Terra estilhaça no escudo. |
| Arcano | Verbo base. |
| **Atiradora Arcana** (Água → Arqueiro) | **Lanças de gelo** rápidas e perfurantes (+30% em alvos lentos) que **derrubam voadores**. **Gelo apaga fogo**: magias apagam chão em chamas e **desarmam o Slime de Fogo inchado**; a Prisão Criogênica **congela o General Magma** no meio da investida. |
| **Piromante** (Fogo) | **Fogo derrete gelo**: magias derretem chão escorregadio; General da Água **congelado** recebe +30%. |
| **Ilusionista** (Vento) | **Vento não reflete vento**: projéteis ignoram barreiras de vento (Conjurador, Totem, vórtice da Sílfide). |
| **Templária** (Terra) | **Terra atravessa terra**: magias passam por carapaças (50% do dano, rachando 2 placas), inclusive a frente do Titã; o **Pilar de Basalto arranca Gnomo e Salamandra do subsolo** (expostos 2,5s). |
| Arqueiro | Verbo base. |
| **Caçador das Marés** (Água) | **Pisa firme no gelo**: não escorrega em gelo nem em chão escorregadio. |
| **Artilheiro Arcano** (Fogo) | **Detonador**: flechas explodem na hora o Slime de Fogo inchado — a explosão só fere inimigos. |
| **Caçador Furtivo** (Vento) | **Vento não reflete vento** (igual ao Ilusionista). |
| **Sentinela** (Terra) | **Ancorado**: com a âncora ativa ignora empurrões e puxões (vórtices, vendavais, ondas, pousos). |
| Assassino | Verbo base. |
| **Rastreador** (Água) | Depois de todo 3º golpe, **3 pontas d'água** em leque vão um pouco além das adagas, marcam (+50% de dano) e **derrubam voadores**. **Vê através de ilusões**: clones da Ondina aparecem marcados com X e a Sílfide fica visível. |
| **Alquimista** (Fogo) | **Bomba de cinzas cega**: interrompe canalizações ("CEGADO!") e revela a Sílfide por 4s. |
| **Algoz do Tufão** (Vento) | **Corta o vento**: adagas acertam o Golem de Tempestade na névoa e o Slime de Vento no ar. |
| **Cavaleiro Sombrio** (Terra) | **Obsidiana corta pedra**: adagas passam por carapaças (50%, rachando 2 placas), inclusive a frente do Titã. |

## Cobertura por chefe

| Chefe | Quem tem vantagem |
|---|---|
| General da Água | Todos rebatem o orbe; Piromante (+30% congelado); Assassino (orbe perde o alvo). |
| General Magma | Cavaleiro (segura a investida), Guardião/Duelista (total), Atiradora Arcana (congela a investida). |
| General Zephyrus | Arqueiro e especializações de Água (derrubam com 5 acertos), Assassino (sombra perde o alvo), Sentinela/Cavaleiro Rúnico (ignoram vendavais). |
| Titã Monolito | Assassino (núcleo ×2), Templária e Carrasco (atravessam a frente). |
| O Salvador | Todos (drones); Assassino (ataque orbital erra). |
| Ondina | Maga e Alquimista (interrompem a cura), Rastreador (vê os clones). |
| Salamandra / Gnomo | Templária (Pilar de Basalto arranca do subsolo), Assassino (perdem o alvo). |
| Sílfide | Cavaleiro (rebate a rajada), Rastreador e Alquimista (revelam), Ilusionista/Caçador Furtivo (vórtice não reflete), Sentinela/Cavaleiro Rúnico (não são puxados). |
