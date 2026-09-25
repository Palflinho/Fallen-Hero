# Changelog — Fallen Hero

Todas as mudanças importantes do jogo ficam registradas aqui, da mais nova para a mais antiga.

**Como numerar (Versionamento Semântico):** `MAIOR.MENOR.CORREÇÃO` + estágio.
- **MENOR** sobe a cada entrega de conteúdo ou sistema para os testadores (0.2.0, 0.3.0…).
- **CORREÇÃO** sobe quando a entrega só corrige bugs (0.1.1, 0.1.2…).
- **MAIOR** vira 1 no lançamento (1.0.0).
- Estágios: Pre-Alpha → **Alpha** (tudo jogável, arte/música provisórias) → Beta (arte e som finais, só polimento) → Lançamento.

**Ao fechar uma versão:**
1. Troque `GAME_VERSION` / `GAME_STAGE` em `scripts/scr_version/scr_version.gml`.
2. Mova os itens de "Não lançado" para uma seção nova com o número e a data.
3. Faça o commit e crie a tag: `git tag v0.2.0` e depois `git push origin v0.2.0`.

---

## [Não lançado]
_(anote aqui o que for mudando até a próxima versão)_

---

## [0.1.0] Alpha — 2026-09-25
Primeira versão fechada para os testadores. O jogo é jogável da tela inicial aos créditos, com arte e música provisórias.

### Estrutura do jogo
- **Tela inicial:** Novo Jogo, Continuar, Opções e Sair, com 3 slots de save. A versão aparece no canto inferior direito.
- **Vila Subterrânea (hub):**
  - **Casa dos Heróis:** classe e afinidade.
  - **Empório da Fenda:** talentos permanentes.
  - **Portal da Fenda:** escolha dos 3 talentos da run.
  - Fogueira, Ancião, 4 moradores com falas que reagem à classe e ao elemento, pedestais e bonecos de treino.
- **5 templos** (Água, Fogo, Vento, Terra e o Santuário do Salvador), com 7 etapas cada: Exploração 1, Exploração 2, Mini-Chefe, Mercador, Exploração 3, Arena e Chefe.
- **Depois de cada chefe:** dois portais, um para voltar à vila (mantém 100% do ouro) e outro para avançar ao próximo templo.
- **3 finais** (Vingança, Conquistador e Síntese, este secreto), com epílogo e créditos.

### Heróis e combate
- 4 classes (Cavaleiro, Maga, Arqueiro, Assassino) × 4 afinidades = 16 especializações, incluindo as Maestrias.
- 211 talentos. São 3 slots escolhidos antes da run e 2 extras preenchidos durante a partida; os pontos de talento chegam a cerca de nível/3.
- **Água nas classes corpo a corpo** (Lanceiro, Rastreador): depois do golpe sai uma ponta d'água atrasada que vai no máximo 15% além da arma.
- Interações de classe: o Cavaleiro segura investidas, a Maga interrompe canalizações, o Arqueiro derruba voadores e o Assassino despista.

### Inimigos e chefes
- Inimigos elementais por templo, variantes Alfa e Campeão, e afixos de elite (Frenético, Baluarte, Esporo).
- 4 Espíritos Elementais nas arenas. Depois da arena, o jogador escolhe entre cura total e um baú de talento.
- 5 chefes com 3 fases cada. A vida trava no limite de cada fase e o chefe fica imune por 1,5s na troca.
- Chefes escalam com o nível do herói. A IA adaptativa resiste à classe que venceu os generais nas últimas runs.
- Inimigos não enxergam nem atiram através de paredes.

### Progressão e save
- Curva de XP `30 + 10n + 2n²`. A XP e a força dos inimigos sobem a cada templo.
- **Save roguelite** em só 2 pontos: ao entrar no portal da vila e ao fim da run.
  - Morte ou desistência perdem 40% do ouro da run.
  - Voltar pelo portal pós-chefe mantém tudo.
- Tela de derrota com estatísticas: dano causado e recebido (físico e mágico), cura, abates, maior golpe e quem matou o herói.

### Ensino e acessibilidade
- Nenhuma tela de tutorial. O jogo ensina com bonecos de treino, selos que acendem o portal e dicas de primeira vez.
- Os botões mostrados mudam com a entrada usada: teclado, Xbox, PlayStation ou toque.
- Idiomas: Português e Inglês.
- **Opções:** idioma, tela cheia, volumes (geral, efeitos, música), tremor de tela, vibração e controles.

### Áudio
- Efeitos sonoros e vozes dos personagens sintetizados em tempo real.
- Música procedural provisória para título, vila, masmorra e chefe. Arquivos `.ogg` colocados em `datafiles/bgm/` substituem a trilha.

### Ferramentas de desenvolvimento
- **Modo Dev:** [F1] na tela inicial.
- **Sandbox** ([F5] ou botão no menu):
  - spawn de inimigos, chefes, cenário e talentos;
  - troca de classe;
  - visualização de colisões ([F7]);
  - nada é salvo.

### Pendências conhecidas
- Arte final (sprites, tilesets, UI): o artista está produzindo; a especificação está em `docs/ESPECIFICACAO_DE_ARTE.md`.
- Música definitiva.
- Balanceamento por playtest.
- Nomes nos créditos.
