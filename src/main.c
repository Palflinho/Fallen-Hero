/*---------------------------------------------------------------------------------
    Fallen Hero - Super Nintendo (SNES) Native 16-Bit Edition
    Ciclo de 7 Salas por Templo Fiel ao GameMaker Studio 2:
    1: Exploracao 1 (Mobs) -> 2: Exploracao 2 (Mobs + Bau) -> 3: Arena (Ondas)
    -> 4: Mercado (Loja) -> 5: Exploracao 3 -> 6: Pre-Chefe -> 7: General da Agua
---------------------------------------------------------------------------------*/
#include <snes.h>
#include "game.h"
#include "sprites.h"

// IDs dos Sprites de Hardware na OAM (Multiplos de 4 obrigatorios no hardware SNES)
#define OAM_PLAYER         (0 * 4)   // 0: Heroi (quadrado com olhinhos)
#define OAM_ATK_SLASH      (1 * 4)   // 4: Arco de corte / golpe (Cavaleiro / Assassino)
#define OAM_SHIELD_DEF     (2 * 4)   // 8: Escudo / Barreira de Mana
#define OAM_PLAYER_PROJ    (3 * 4)   // 12: Projetil do Jogador (Maga / Arqueiro)
#define OAM_DUMMY          (4 * 4)   // 16: Boneco (Vila) / Mercador (Loja) / Fonte (Pre-Chefe)
#define OAM_PEDESTAL0      (5 * 4)   // 20: Pedestal Cavaleiro (Tatu)
#define OAM_PEDESTAL1      (6 * 4)   // 24: Pedestal Maga (Lobo-Guara)
#define OAM_PEDESTAL2      (7 * 4)   // 28: Pedestal Arqueiro (Lagarto)
#define OAM_PEDESTAL3      (8 * 4)   // 32: Pedestal Assassino (Urutau)
#define OAM_ALTAR          (9 * 4)   // 36: Altar das Essencias (Vila)
#define OAM_PORTAL         (10 * 4)  // 40: Portal Dimensional (Vila)
#define OAM_CHEST          (11 * 4)  // 44: Bau de Tesouro (Masmorra)
#define OAM_SLIME1         (12 * 4)  // 48: Slime 1 (Masmorra)
#define OAM_SLIME2         (13 * 4)  // 52: Slime 2 (Masmorra)
#define OAM_ELEMENTAL      (14 * 4)  // 56: Elemental de Gelo (Masmorra)
#define OAM_BOSS           (15 * 4)  // 60: General da Agua / Chefe
#define OAM_ENEMY_PROJ1    (16 * 4)  // 64: Projetil Inimigo 1
#define OAM_ENEMY_PROJ2    (17 * 4)  // 68: Projetil Inimigo 2
#define OAM_ESSENCE        (18 * 4)  // 72: Orbe da Essencia Elemental

// Instancias Globais
static Player player;
static GameState current_state;
static u16 pad_held = 0;
static u16 pad_down = 0;
static u8 hud_dirty = 1;

// Estado da Vila
static u8 dummy_hit_flash = 0;
static u16 dummy_damage = 0;

// Os 4 Pedestais da Vila (Fiel a obj_village_pedestal do GM)
static const VillagePedestal pedestals[4] = {
    { 45,  120, CLASS_KNIGHT,   "Cavaleiro (Tatu)",   "Espada + Bloqueio" },
    { 95,  120, CLASS_MAGE,     "Maga (Lobo-Guara)",  "Magia + Barreira"  },
    { 145, 120, CLASS_ARCHER,   "Arqueiro (Lagarto)", "Flecha + Rolamento"},
    { 195, 120, CLASS_ASSASSIN, "Assassino (Urutau)", "Adagas + Invisivel"}
};

// Catalogo de Talentos Fiéis ao GDD
static const TalentDef talent_catalog[8] = {
    { 0, "Nenhum",           "Slot vazio",                    0, 0 },
    { 1, "Golpe Pesado",     "+4 Poder de Ataque",            1, 4 },
    { 2, "Postura Firme",    "+4 Defesa Fisica",              2, 4 },
    { 3, "Passo Leve",       "+1 Velocidade de Passo",        3, 1 },
    { 4, "Vitalidade",       "+30 HP Maximo",                 0, 30 },
    { 5, "Segundo Folego",   "Cura 25 HP se em perigo",       4, 25 },
    { 6, "Flechas Velozes",  "+6 Dano de Projetil",           1, 6 },
    { 7, "Lamina Venenosa",  "Veneno continuo no golpe",      4, 5 }
};

// Titulos das 7 Salas do Templo (Fiel a scr_progression.gml)
static const char* room_titles[8] = {
    "",
    "SALA 1/7 [EXPLORACAO 1]",
    "SALA 2/7 [EXPLORACAO 2]",
    "SALA 3/7 [ARENA]",
    "SALA 4/7 [MERCADO]",
    "SALA 5/7 [EXPLORACAO 3]",
    "SALA 6/7 [PRE-CHEFE]",
    "SALA 7/7 [GENERAL DA AGUA]"
};

// Estado da Masmorra
static SlimeMob slime1;
static SlimeMob slime2;
static ElementalMob elemental;
static DungeonChest chest;
static u8 room_cleared = 0;
static u8 door_open = 0;
static u8 arena_wave = 1;
static u8 fountain_used = 0;
static const char *shop_feedback = "";

// Estado do Chefe
static BossGeneral boss;
static GameProjectile player_proj;
static GameProjectile enemy_proj1;
static GameProjectile enemy_proj2;
static u8 essence_spawned = 0;
static u8 essence_collected = 0;
static u8 boss_portal_open = 0;

// Textos de Classes
static const char* class_names[4] = {
    "CAVALEIRO (TATU)",
    "MAGA (LOBO-GUARA)",
    "ARQUEIRO (LAGARTO)",
    "ASSASSINO (URUTAU)"
};

static const char* class_specials[4] = {
    "BLOQUEIO (ESCUDO)",
    "ESCUDO DE MANA",
    "ROLAMENTO (DASH)",
    "INVISIBILIDADE"
};

// Prototipos de Funcoes
void apply_class_stats(HeroClass cls);
void load_current_room(void);
void advance_to_next_room(void);
void return_to_village(u8 won);
void clear_screen_text(void);
void clear_dialogue_box(void);

void apply_class_stats(HeroClass cls) {
    player.class_id = cls;
    player.element = (ElementType)cls;

    if (cls == CLASS_KNIGHT) {
        player.max_hp = 100;
        player.power = 12;
        player.defense = 8;
        player.move_speed = 2;
        player.def_mode = DEF_BLOCK;
        player.talent_slots[0] = 2; // Postura Firme
    } else if (cls == CLASS_MAGE) {
        player.max_hp = 70;
        player.power = 18;
        player.defense = 3;
        player.move_speed = 2;
        player.def_mode = DEF_MANA_SHIELD;
        player.talent_slots[0] = 1; // Golpe Pesado
    } else if (cls == CLASS_ARCHER) {
        player.max_hp = 80;
        player.power = 10;
        player.defense = 4;
        player.move_speed = 2;
        player.def_mode = DEF_ROLL;
        player.talent_slots[0] = 3; // Passo Leve
    } else { // ASSASSIN
        player.max_hp = 60;
        player.power = 6;
        player.defense = 2;
        player.move_speed = 2;
        player.def_mode = DEF_STEALTH;
        player.talent_slots[0] = 7; // Lamina Venenosa
    }

    player.hp = player.max_hp;
}

void init_player(void) {
    player.x = 120;
    player.y = 80;
    player.vx = 0;
    player.vy = 0;
    player.dir = 0;
    player.atk_timer = 0;
    player.atk_cooldown = 0;
    player.def_timer = 0;
    player.def_cooldown = 0;
    player.invuln_timer = 0;
    player.is_moving = 0;
    player.essences_rescued = 0;
    player.gold = 0;
    player.run_room_step = 1;
    player.talent_slots[1] = 0;
    player.talent_slots[2] = 0;

    apply_class_stats(CLASS_KNIGHT);
}

void init_custom_palettes(void) {
    setPalette(&sprites_pal, 128 + 0 * 16, 16 * 2); // Pal 0: Cavaleiro (Tan/Bronze)
    setPalette(&sprites_pal, 128 + 1 * 16, 16 * 2); // Pal 1: Maga (Laranja/Ouro)
    setPalette(&sprites_pal, 128 + 2 * 16, 16 * 2); // Pal 2: Arqueiro (Verde/Lima) / Slimes
    setPalette(&sprites_pal, 128 + 3 * 16, 16 * 2); // Pal 3: Assassino (Cinza/Prata)
    setPalette(&sprites_pal, 128 + 4 * 16, 16 * 2); // Pal 4: Flash Impacto (Branco)
    setPalette(&sprites_pal, 128 + 5 * 16, 16 * 2); // Pal 5: Elemental Gelo (Azul/Ciano)
    setPalette(&sprites_pal, 128 + 6 * 16, 16 * 2); // Pal 6: Bau / Ouro
    setPalette(&sprites_pal, 128 + 7 * 16, 16 * 2); // Pal 7: Chefe General (Vermelho)

    // Pal 1: Maga (Lobo-Guara)
    setPaletteColor(128 + 16 * 1 + 3, RGB5(30, 14, 2));
    setPaletteColor(128 + 16 * 1 + 4, RGB5(31, 26, 8));

    // Pal 2: Arqueiro (Lagarto)
    setPaletteColor(128 + 16 * 2 + 3, RGB5(4, 22, 10));
    setPaletteColor(128 + 16 * 2 + 4, RGB5(14, 30, 16));

    // Pal 3: Assassino (Urutau)
    setPaletteColor(128 + 16 * 3 + 3, RGB5(10, 10, 12));
    setPaletteColor(128 + 16 * 3 + 4, RGB5(20, 20, 24));

    // Pal 4: Flash Branco Puro
    setPaletteColor(128 + 16 * 4 + 3,  RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 4,  RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 8,  RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 10, RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 11, RGB5(31, 31, 31));
    setPaletteColor(128 + 16 * 4 + 14, RGB5(31, 31, 31));

    // Pal 5: Elemental de Gelo (Ciano e Azul)
    setPaletteColor(128 + 16 * 5 + 3,  RGB5(5, 20, 31));
    setPaletteColor(128 + 16 * 5 + 4,  RGB5(15, 28, 31));

    // Pal 6: Bau de Tesouro (Ouro reluzente)
    setPaletteColor(128 + 16 * 6 + 3,  RGB5(28, 22, 4));
    setPaletteColor(128 + 16 * 6 + 4,  RGB5(31, 28, 12));

    // Pal 7: Chefe General da Agua (Vermelho e Escarlate)
    setPaletteColor(128 + 16 * 7 + 3,  RGB5(28, 4, 4));
    setPaletteColor(128 + 16 * 7 + 4,  RGB5(31, 10, 10));
}

void get_hp_bar(char *out, s16 cur, s16 max, u8 len) {
    u8 filled = 0;
    u8 i;
    if (cur > 0 && max > 0) {
        filled = (u8)(((s32)cur * len) / max);
    }
    if (filled > len) filled = len;
    for (i = 0; i < len; i++) {
        out[i] = (i < filled) ? '=' : '-';
    }
    out[len] = '\0';
}

void clear_dialogue_box(void) {
    u8 y;
    for (y = 18; y <= 26; y++) {
        consoleDrawText(1, y, "                              ");
    }
}

void clear_screen_text(void) {
    u8 y;
    for (y = 0; y < 28; y++) {
        consoleDrawText(0, y, "                                ");
    }
}

void load_current_room(void) {
    // Reseta projeteis
    player_proj.is_active = 0;
    player_proj.x = 0;
    player_proj.y = 240;

    enemy_proj1.is_active = 0;
    enemy_proj1.x = 0;
    enemy_proj1.y = 240;

    enemy_proj2.is_active = 0;
    enemy_proj2.x = 0;
    enemy_proj2.y = 240;

    // Padrao de Bau
    chest.x = 120;
    chest.y = 110;
    chest.is_spawned = 0;
    chest.is_open = 0;
    chest.rolled_talent_id = 4; // Vitalidade

    // Configuracao individual das 7 Salas
    if (player.run_room_step == 1) {
        // SALA 1: EXPLORACAO 1 (2 Slimes)
        current_state = STATE_DUNGEON_CHAMBER;
        slime1.x = 70; slime1.y = 100; slime1.hp = 25; slime1.hit_flash = 0; slime1.is_alive = 1;
        slime2.x = 170; slime2.y = 100; slime2.hp = 25; slime2.hit_flash = 0; slime2.is_alive = 1;
        elemental.is_alive = 0;
        room_cleared = 0;
        door_open = 0;
    } else if (player.run_room_step == 2) {
        // SALA 2: EXPLORACAO 2 (1 Slime + 1 Elemental de Gelo + Bau)
        current_state = STATE_DUNGEON_CHAMBER;
        slime1.x = 80; slime1.y = 110; slime1.hp = 30; slime1.hit_flash = 0; slime1.is_alive = 1;
        slime2.is_alive = 0;
        elemental.x = 120; elemental.y = 65; elemental.hp = 40; elemental.hit_flash = 0; elemental.shoot_timer = 50; elemental.is_alive = 1;
        chest.rolled_talent_id = 5; // Segundo Folego
        room_cleared = 0;
        door_open = 0;
    } else if (player.run_room_step == 3) {
        // SALA 3: ARENA DE COMBATE (Ondas)
        current_state = STATE_DUNGEON_CHAMBER;
        arena_wave = 1;
        slime1.x = 60; slime1.y = 90; slime1.hp = 30; slime1.hit_flash = 0; slime1.is_alive = 1;
        slime2.x = 180; slime2.y = 90; slime2.hp = 30; slime2.hit_flash = 0; slime2.is_alive = 1;
        elemental.is_alive = 0;
        chest.rolled_talent_id = 1; // Golpe Pesado
        room_cleared = 0;
        door_open = 0;
    } else if (player.run_room_step == 4) {
        // SALA 4: MERCADO / LOJA (Segura, Balcao de Vendas com Ouro)
        current_state = STATE_DUNGEON_CHAMBER;
        slime1.is_alive = 0;
        slime2.is_alive = 0;
        elemental.is_alive = 0;
        chest.is_spawned = 0;
        room_cleared = 1;
        door_open = 1; // Porta ja aberta para seguir quando quiser
        shop_feedback = "";
    } else if (player.run_room_step == 5) {
        // SALA 5: EXPLORACAO 3 (Mobs intensos: 2 Elementais + 1 Slime)
        current_state = STATE_DUNGEON_CHAMBER;
        slime1.x = 120; slime1.y = 130; slime1.hp = 35; slime1.hit_flash = 0; slime1.is_alive = 1;
        slime2.is_alive = 0;
        elemental.x = 120; elemental.y = 65; elemental.hp = 45; elemental.hit_flash = 0; elemental.shoot_timer = 40; elemental.is_alive = 1;
        chest.rolled_talent_id = 6; // Flechas Velozes / Sobrecarga
        room_cleared = 0;
        door_open = 0;
    } else if (player.run_room_step == 6) {
        // SALA 6: PRE-CHEFE (Santuario, Bau Final e Fonte de Cura)
        current_state = STATE_DUNGEON_CHAMBER;
        slime1.is_alive = 0;
        slime2.is_alive = 0;
        elemental.is_alive = 0;
        chest.x = 120;
        chest.y = 95;
        chest.is_spawned = 1; // Bau ja pronto para fechar a build
        chest.is_open = 0;
        chest.rolled_talent_id = 4; // Vitalidade
        fountain_used = 0;
        room_cleared = 1;
        door_open = 1; // Portal para o General
    } else if (player.run_room_step == 7) {
        // SALA 7: CAMARA DO GENERAL DA AGUA (Chefe)
        current_state = STATE_BOSS_CHAMBER;
        boss.x = 120;
        boss.y = 60;
        boss.dir_x = 1;
        boss.dir_y = 0;
        boss.max_hp = 350;
        boss.hp = 350;
        boss.hit_flash = 0;
        boss.shoot_timer = 60;
        boss.slam_timer = 0;
        boss.vuln_timer = 0;
        boss.state = 0;
        boss.is_alive = 1;
        essence_spawned = 0;
        essence_collected = 0;
        boss_portal_open = 0;
    }
}

void advance_to_next_room(void) {
    setFadeEffect(FADE_OUT);
    WaitForVBlank();
    clear_screen_text();

    player.run_room_step++;
    player.x = 120;
    player.y = 180;
    player.dir = 1;
    player.atk_timer = 0;
    player.def_timer = 0;
    player.invuln_timer = 0;

    load_current_room();
    hud_dirty = 1;

    WaitForVBlank();
    setFadeEffect(FADE_IN);
}

void return_to_village(u8 won) {
    setFadeEffect(FADE_OUT);
    WaitForVBlank();
    clear_screen_text();

    current_state = STATE_VILLAGE;
    player.x = 120;
    player.y = 65;
    player.dir = 0;
    player.hp = player.max_hp;
    player.atk_timer = 0;
    player.def_timer = 0;
    player.def_cooldown = 0;
    player.invuln_timer = 0;
    player.run_room_step = 1;

    hud_dirty = 1;
    WaitForVBlank();
    setFadeEffect(FADE_IN);

    if (won) {
        current_state = STATE_VICTORY;
        hud_dirty = 1;
    }
}

void draw_hud(void) {
    char hp_buf[12];
    char boss_buf[12];

    if (current_state == STATE_VILLAGE || current_state == STATE_PORTAL_CONFIRM ||
        current_state == STATE_ALTAR_MENU || current_state == STATE_VICTORY) {

        consoleDrawText(1, 1, "== VILA DOS ELEMENTOS (SNES) ==");
        consoleDrawText(1, 2, "CLASSE: ");
        consoleDrawText(9, 2, (char*)class_names[player.class_id]);

        get_hp_bar(hp_buf, player.hp, player.max_hp, 8);
        consoleDrawText(1, 3, "HP:[%s] %d/%d  OURO:%d", hp_buf, player.hp, player.max_hp, player.gold);

        if (current_state == STATE_VILLAGE) {
            consoleDrawText(1, 25, "D-Pad:Andar  Y:Atacar  B:Especial");
            consoleDrawText(1, 26, "A:Pedestal/Altar  X:Ficha/Talentos");
        } else if (current_state == STATE_PORTAL_CONFIRM) {
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, "PORTAL DO TEMPLO DA AGUA      ");
            consoleDrawText(1, 20, "------------------------------");
            consoleDrawText(1, 21, "Iniciando expedicao (7 salas) ");
            consoleDrawText(1, 22, "Exploracao -> Arena -> Loja   ");
            consoleDrawText(1, 23, "Pre-Chefe e General da Agua!  ");
            consoleDrawText(1, 24, "------------------------------");
            consoleDrawText(1, 25, "[A] ATRAVESSAR PORTAL         ");
            consoleDrawText(1, 26, "[B] Ficar na Vila             ");
        } else if (current_state == STATE_ALTAR_MENU) {
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, "ALTAR DAS 4 ESSENCIAS         ");
            consoleDrawText(1, 20, "------------------------------");
            if (player.essences_rescued >= 1) {
                consoleDrawText(1, 21, "AGUA:  [OK]  FOGO: [--]");
            } else {
                consoleDrawText(1, 21, "AGUA:  [--]  FOGO: [--]");
            }
            if (player.essences_rescued >= 2) {
                consoleDrawText(14, 21, "FOGO: [OK]");
            }
            if (player.essences_rescued >= 3) {
                consoleDrawText(1, 22, "TERRA: [OK]  VENTO:[--]");
            } else {
                consoleDrawText(1, 22, "TERRA: [--]  VENTO:[--]");
            }
            if (player.essences_rescued >= 4) {
                consoleDrawText(14, 22, "VENTO:[OK]");
            }
            consoleDrawText(1, 23, "Restaure os 4 generais!       ");
            consoleDrawText(1, 25, "[A / B] Fechar Altar          ");
            consoleDrawText(1, 26, "==============================");
        } else if (current_state == STATE_VICTORY) {
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, "TEMPLO CONCLUIDO COM VITORIA! ");
            consoleDrawText(1, 20, "------------------------------");
            consoleDrawText(1, 21, "As 7 salas foram superadas!   ");
            consoleDrawText(1, 22, "O General da Agua foi purificado");
            consoleDrawText(1, 23, "O Altar recebeu a Essencia!   ");
            consoleDrawText(1, 25, "[A / B] Continuar explorando  ");
            consoleDrawText(1, 26, "==============================");
        }
    } else if (current_state == STATE_TALENTS_MENU) {
        consoleDrawText(1, 1, "== FICHA DO HEROI E TALENTOS ==");
        consoleDrawText(1, 3, "CLASSE: ");
        consoleDrawText(9, 3, (char*)class_names[player.class_id]);
        consoleDrawText(1, 4, "ESPECIAL [B]: ");
        consoleDrawText(15, 4, (char*)class_specials[player.class_id]);

        consoleDrawText(1, 6, "PODER:%d  DEFESA:%d  OURO:%d", player.power, player.defense, player.gold);
        consoleDrawText(1, 7, "HP MAXIMO: %d", player.max_hp);
        consoleDrawText(1, 9, "--- SLOTS DE TALENTOS ---");
        consoleDrawText(1, 11, "SLOT 1: %s", talent_catalog[player.talent_slots[0]].name);
        consoleDrawText(1, 12, "        (%s)", talent_catalog[player.talent_slots[0]].desc);
        consoleDrawText(1, 14, "SLOT 2: %s", talent_catalog[player.talent_slots[1]].name);
        consoleDrawText(1, 15, "        (%s)", talent_catalog[player.talent_slots[1]].desc);
        consoleDrawText(1, 17, "SLOT 3: %s", talent_catalog[player.talent_slots[2]].name);
        consoleDrawText(1, 18, "        (%s)", talent_catalog[player.talent_slots[2]].desc);

        consoleDrawText(1, 22, "Abra baus na masmorra p/ mais!");
        consoleDrawText(1, 25, "[A / B / X] Fechar Ficha      ");
    } else if (current_state == STATE_DUNGEON_CHAMBER) {
        consoleDrawText(1, 1, (char*)room_titles[player.run_room_step]);
        consoleDrawText(1, 2, "CLASSE: ");
        consoleDrawText(9, 2, (char*)class_names[player.class_id]);

        get_hp_bar(hp_buf, player.hp, player.max_hp, 8);
        consoleDrawText(1, 3, "HP:[%s] %d/%d  OURO:%d", hp_buf, player.hp, player.max_hp, player.gold);

        if (player.run_room_step == 4) {
            consoleDrawText(1, 4, "MERCADO: Fale c/ Balcao [A]    ");
            consoleDrawText(1, 25, "Suba ao balcao para comprar!   ");
            consoleDrawText(1, 26, "Porta Norte aberta p/ avancar! ");
        } else if (player.run_room_step == 6) {
            consoleDrawText(1, 4, "SANTUARIO: Toque Fonte/Bau [A] ");
            consoleDrawText(1, 25, "Prepare-se para o confronto!   ");
            consoleDrawText(1, 26, "Avance ao Norte para o General!");
        } else {
            if (!room_cleared) {
                consoleDrawText(1, 4, "INIMIGOS: Derrote os monstros! ");
                consoleDrawText(1, 25, "Y:Ataque  B:Especial  X:Ficha  ");
                consoleDrawText(1, 26, "Porta trancada ate limpar sala!");
            } else {
                consoleDrawText(1, 4, "SALA LIMPA! Avance ao Norte    ");
                consoleDrawText(1, 25, "Pegue o Bau e siga pela Porta! ");
                consoleDrawText(1, 26, "PORTA NORTE DESTRANCADA!       ");
            }
        }
    } else if (current_state == STATE_CHEST_OPEN) {
        consoleDrawText(1, 18, "==============================");
        consoleDrawText(1, 19, "BAU DE TESOURO ABERTO!        ");
        consoleDrawText(1, 20, "------------------------------");
        consoleDrawText(1, 21, "TALENTO: %s", talent_catalog[chest.rolled_talent_id].name);
        consoleDrawText(1, 22, "(%s)", talent_catalog[chest.rolled_talent_id].desc);
        consoleDrawText(1, 23, "------------------------------");
        consoleDrawText(1, 24, "[Y] Equipar no Slot 1");
        consoleDrawText(1, 25, "[X] Equipar no Slot 2");
        consoleDrawText(1, 26, "[A] Equipar no Slot 3  [B] Sair");
    } else if (current_state == STATE_SHOP_MENU) {
        consoleDrawText(1, 18, "==============================");
        consoleDrawText(1, 19, "MERCADO DA MASMORRA           ");
        consoleDrawText(1, 20, "------------------------------");
        consoleDrawText(1, 21, "[Y] Pocao Vida (+35 HP)    40g");
        consoleDrawText(1, 22, "[X] Bencao Forca (+4 Dmg)  60g");
        consoleDrawText(1, 23, "[A] Bencao Escudo (+4 Def) 60g");
        consoleDrawText(1, 24, "------------------------------");
        consoleDrawText(1, 25, (char*)shop_feedback);
        consoleDrawText(1, 26, "[B] Sair do Balcao            ");
    } else if (current_state == STATE_BOSS_CHAMBER) {
        consoleDrawText(1, 1, "== CAMARA DO GENERAL DA AGUA ==");
        consoleDrawText(1, 2, "CLASSE: ");
        consoleDrawText(9, 2, (char*)class_names[player.class_id]);

        get_hp_bar(hp_buf, player.hp, player.max_hp, 8);
        consoleDrawText(1, 3, "HP HEROI: [%s] %d/%d", hp_buf, player.hp, player.max_hp);

        if (boss.is_alive) {
            get_hp_bar(boss_buf, boss.hp, boss.max_hp, 8);
            if (boss.state == 2) {
                consoleDrawText(1, 4, "CHEFE: [VULNERAVEL!] %d/350", boss.hp);
            } else {
                consoleDrawText(1, 4, "CHEFE:    [%s] %d/%d", boss_buf, boss.hp, boss.max_hp);
            }
        } else {
            consoleDrawText(1, 4, "CHEFE: DERROTADO! PEGUE A ORBE");
        }

        consoleDrawText(1, 25, "Y:Ataque  B:Especial  X:Ficha  ");
        if (boss_portal_open) {
            consoleDrawText(1, 26, "PORTAL ABERTO! Toque no topo!  ");
        } else {
            consoleDrawText(1, 26, "Cuidado com o Slam do Chefe!   ");
        }
    }
}

int main(void) {
    u8 i;

    // 1. Limpa VRAM e OAM
    dmaClearVram();
    oamClear(0, 0);

    // 2. Inicializa o console de texto (BG0)
    consoleInitDefaultText(0);
    bgSetGfxPtr(0, 0x3000);
    bgSetMapPtr(0, 0x6800, SC_32x32);
    setMode(BG_MODE1, 0);
    bgSetDisable(1);
    bgSetDisable(2);

    // 3. Inicializa os Sprites de Hardware (OAM) com tamanho 16x16
    oamInitGfxSet(&sprites_til, (&sprites_tilend - &sprites_til), &sprites_pal, (&sprites_palend - &sprites_pal), 0, 0x0000, OBJ_SIZE16_L32);

    // 4. Configura as paletas dos herois e monstros
    init_custom_palettes();

    // 5. Configura tamanho OBJ_SMALL e visibilidade OBJ_SHOW UMA UNICA VEZ para os 19 sprites
    for (i = 0; i < 19; i++) {
        oamSetEx(i * 4, OBJ_SMALL, OBJ_SHOW);
    }

    init_player();
    current_state = STATE_VILLAGE;
    hud_dirty = 1;

    setScreenOn();

    while (1) {
        pad_held = padsCurrent(0);
        pad_down = padsDown(0);

        // Cooldowns e Timers Gerais do Jogador
        if (player.atk_timer > 0) player.atk_timer--;
        if (player.atk_cooldown > 0) player.atk_cooldown--;
        if (player.def_timer > 0) player.def_timer--;
        if (player.def_cooldown > 0) player.def_cooldown--;
        if (player.invuln_timer > 0) player.invuln_timer--;

        // =========================================================================
        // ESTADO 1: A VILA (Hub Seguro)
        // =========================================================================
        if (current_state == STATE_VILLAGE) {
            player.is_moving = 0;
            if (pad_held & KEY_UP) {
                if (player.y > 36) player.y -= player.move_speed;
                player.dir = 1;
                player.is_moving = 1;
            }
            if (pad_held & KEY_DOWN) {
                if (player.y < 185) player.y += player.move_speed;
                player.dir = 0;
                player.is_moving = 1;
            }
            if (pad_held & KEY_LEFT) {
                if (player.x > 16) player.x -= player.move_speed;
                player.dir = 2;
                player.is_moving = 1;
            }
            if (pad_held & KEY_RIGHT) {
                if (player.x < 225) player.x += player.move_speed;
                player.dir = 3;
                player.is_moving = 1;
            }

            // Entrar no Portal (120, 35)
            if (player.y <= 42 && player.x >= 110 && player.x <= 130) {
                current_state = STATE_PORTAL_CONFIRM;
                clear_dialogue_box();
                hud_dirty = 1;
            }

            // Abrir Menu de Ficha / Talentos (Botao X)
            if (pad_down & KEY_X) {
                current_state = STATE_TALENTS_MENU;
                clear_screen_text();
                hud_dirty = 1;
            }

            // Ataque de Treino (Botao Y)
            if ((pad_down & KEY_Y) && player.atk_cooldown == 0) {
                player.atk_timer = 12;
                player.atk_cooldown = 18;

                if (player.class_id == CLASS_MAGE || player.class_id == CLASS_ARCHER) {
                    player_proj.is_active = 1;
                    player_proj.x = player.x;
                    player_proj.y = player.y;
                    player_proj.damage = player.power;
                    if (player.dir == 0) { player_proj.vx = 0; player_proj.vy = 4; }
                    else if (player.dir == 1) { player_proj.vx = 0; player_proj.vy = -4; }
                    else if (player.dir == 2) { player_proj.vx = -4; player_proj.vy = 0; }
                    else if (player.dir == 3) { player_proj.vx = 4; player_proj.vy = 0; }
                }

                // Boneco de Treino (120, 165)
                {
                    s16 ddx = player.x - 120;
                    s16 ddy = player.y - 165;
                    if (ddx < 0) ddx = -ddx;
                    if (ddy < 0) ddy = -ddy;
                    if (ddx < 24 && ddy < 24) {
                        dummy_hit_flash = 10;
                        dummy_damage += player.power;
                        hud_dirty = 1;
                    }
                }
            }

            // Habilidade de Defesa (Botao B)
            if ((pad_down & KEY_B) && player.def_cooldown == 0) {
                if (player.def_mode == DEF_BLOCK) {
                    player.def_timer = 120;
                    player.def_cooldown = 200;
                } else if (player.def_mode == DEF_MANA_SHIELD) {
                    player.def_timer = 100;
                    player.def_cooldown = 240;
                } else if (player.def_mode == DEF_ROLL) {
                    player.def_timer = 15;
                    player.invuln_timer = 15;
                    player.def_cooldown = 120;
                } else if (player.def_mode == DEF_STEALTH) {
                    player.def_timer = 150;
                    player.def_cooldown = 260;
                }
            }

            if (player.def_timer > 0 && player.def_mode == DEF_ROLL) {
                if (player.dir == 0 && player.y < 185) player.y += 4;
                if (player.dir == 1 && player.y > 36)  player.y -= 4;
                if (player.dir == 2 && player.x > 16)  player.x -= 4;
                if (player.dir == 3 && player.x < 225) player.x += 4;
            }

            // Interacoes com Pedestais, Altar ou Portal (Botao A)
            if (pad_down & KEY_A) {
                u8 p;
                for (p = 0; p < 4; p++) {
                    s16 dx = player.x - (s16)pedestals[p].x;
                    s16 dy = player.y - (s16)pedestals[p].y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 22 && dy < 22) {
                        apply_class_stats(pedestals[p].class_id);
                        hud_dirty = 1;
                        break;
                    }
                }

                // Altar (120, 75)
                {
                    s16 dx = player.x - 120;
                    s16 dy = player.y - 75;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 22 && dy < 22) {
                        current_state = STATE_ALTAR_MENU;
                        clear_dialogue_box();
                        hud_dirty = 1;
                    }
                }

                // Portal (120, 35)
                {
                    s16 dx = player.x - 120;
                    s16 dy = player.y - 35;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 24 && dy < 24) {
                        current_state = STATE_PORTAL_CONFIRM;
                        clear_dialogue_box();
                        hud_dirty = 1;
                    }
                }
            }

            if (dummy_hit_flash > 0) dummy_hit_flash--;
        }
        // =========================================================================
        // ESTADO 2: CONFIRMACAO DO PORTAL DIMENSIONAL
        // =========================================================================
        else if (current_state == STATE_PORTAL_CONFIRM) {
            if (pad_down & KEY_A) {
                setFadeEffect(FADE_OUT);
                WaitForVBlank();
                clear_screen_text();

                player.run_room_step = 1; // Inicia na Sala 1/7
                player.x = 120;
                player.y = 180;
                player.dir = 1;
                load_current_room();
                hud_dirty = 1;

                WaitForVBlank();
                setFadeEffect(FADE_IN);
            } else if (pad_down & KEY_B) {
                player.y = 52;
                current_state = STATE_VILLAGE;
                clear_dialogue_box();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 3: ALTAR / VITORIA
        // =========================================================================
        else if (current_state == STATE_ALTAR_MENU || current_state == STATE_VICTORY) {
            if ((pad_down & KEY_B) || (pad_down & KEY_A)) {
                current_state = STATE_VILLAGE;
                clear_dialogue_box();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 4: FICHA DO HEROI E TALENTOS (Botao X)
        // =========================================================================
        else if (current_state == STATE_TALENTS_MENU) {
            if ((pad_down & KEY_B) || (pad_down & KEY_A) || (pad_down & KEY_X)) {
                current_state = (player.run_room_step >= 1 && player.run_room_step <= 6) ? STATE_DUNGEON_CHAMBER : STATE_VILLAGE;
                clear_screen_text();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 5: SALAS DE 1 A 6 DA MASMORRA (Exploracao, Arena, Loja, Pre-Chefe)
        // =========================================================================
        else if (current_state == STATE_DUNGEON_CHAMBER) {
            player.is_moving = 0;
            if (pad_held & KEY_UP) {
                if (player.y > 36) player.y -= player.move_speed;
                player.dir = 1;
                player.is_moving = 1;
            }
            if (pad_held & KEY_DOWN) {
                if (player.y < 185) player.y += player.move_speed;
                player.dir = 0;
                player.is_moving = 1;
            }
            if (pad_held & KEY_LEFT) {
                if (player.x > 18) player.x -= player.move_speed;
                player.dir = 2;
                player.is_moving = 1;
            }
            if (pad_held & KEY_RIGHT) {
                if (player.x < 222) player.x += player.move_speed;
                player.dir = 3;
                player.is_moving = 1;
            }

            // Ficha de Talentos (Botao X)
            if (pad_down & KEY_X) {
                current_state = STATE_TALENTS_MENU;
                clear_screen_text();
                hud_dirty = 1;
            }

            // Habilidade de Defesa / Especial (Botao B)
            if ((pad_down & KEY_B) && player.def_cooldown == 0) {
                if (player.def_mode == DEF_BLOCK) {
                    player.def_timer = 120;
                    player.def_cooldown = 200;
                } else if (player.def_mode == DEF_MANA_SHIELD) {
                    player.def_timer = 100;
                    player.def_cooldown = 240;
                } else if (player.def_mode == DEF_ROLL) {
                    player.def_timer = 15;
                    player.invuln_timer = 15;
                    player.def_cooldown = 120;
                } else if (player.def_mode == DEF_STEALTH) {
                    player.def_timer = 150;
                    player.def_cooldown = 260;
                }
            }

            if (player.def_timer > 0 && player.def_mode == DEF_ROLL) {
                if (player.dir == 0 && player.y < 185) player.y += 4;
                if (player.dir == 1 && player.y > 36)  player.y -= 4;
                if (player.dir == 2 && player.x > 18)  player.x -= 4;
                if (player.dir == 3 && player.x < 222) player.x += 4;
            }

            // Ataque do Heroi (Botao Y)
            if ((pad_down & KEY_Y) && player.atk_cooldown == 0) {
                player.atk_timer = (player.class_id == CLASS_ASSASSIN) ? 6 : 12;
                player.atk_cooldown = (player.class_id == CLASS_ASSASSIN) ? 10 : 18;

                if (player.class_id == CLASS_MAGE || player.class_id == CLASS_ARCHER) {
                    player_proj.is_active = 1;
                    player_proj.x = player.x;
                    player_proj.y = player.y;
                    player_proj.damage = player.power;
                    if (player.dir == 0) { player_proj.vx = 0; player_proj.vy = 5; }
                    else if (player.dir == 1) { player_proj.vx = 0; player_proj.vy = -5; }
                    else if (player.dir == 2) { player_proj.vx = -5; player_proj.vy = 0; }
                    else if (player.dir == 3) { player_proj.vx = 5; player_proj.vy = 0; }
                }

                if (player.class_id == CLASS_KNIGHT || player.class_id == CLASS_ASSASSIN) {
                    s16 atk_cx = player.x;
                    s16 atk_cy = player.y;
                    if (player.dir == 0) atk_cy += 14;
                    if (player.dir == 1) atk_cy -= 14;
                    if (player.dir == 2) atk_cx -= 14;
                    if (player.dir == 3) atk_cx += 14;

                    if (slime1.is_alive) {
                        s16 dx = atk_cx - slime1.x;
                        s16 dy = atk_cy - slime1.y;
                        if (dx < 0) dx = -dx;
                        if (dy < 0) dy = -dy;
                        if (dx < 16 && dy < 16) {
                            slime1.hp -= player.power;
                            slime1.hit_flash = 8;
                            if (slime1.hp <= 0) { slime1.is_alive = 0; player.gold += 15; }
                            hud_dirty = 1;
                        }
                    }

                    if (slime2.is_alive) {
                        s16 dx = atk_cx - slime2.x;
                        s16 dy = atk_cy - slime2.y;
                        if (dx < 0) dx = -dx;
                        if (dy < 0) dy = -dy;
                        if (dx < 16 && dy < 16) {
                            slime2.hp -= player.power;
                            slime2.hit_flash = 8;
                            if (slime2.hp <= 0) { slime2.is_alive = 0; player.gold += 15; }
                            hud_dirty = 1;
                        }
                    }

                    if (elemental.is_alive) {
                        s16 dx = atk_cx - elemental.x;
                        s16 dy = atk_cy - elemental.y;
                        if (dx < 0) dx = -dx;
                        if (dy < 0) dy = -dy;
                        if (dx < 16 && dy < 16) {
                            elemental.hp -= player.power;
                            elemental.hit_flash = 8;
                            if (elemental.hp <= 0) { elemental.is_alive = 0; player.gold += 25; }
                            hud_dirty = 1;
                        }
                    }
                }
            }

            // Atualizacao do Projetil do Jogador
            if (player_proj.is_active) {
                player_proj.x += player_proj.vx;
                player_proj.y += player_proj.vy;

                if (player_proj.x < 10 || player_proj.x > 235 || player_proj.y < 25 || player_proj.y > 200) {
                    player_proj.is_active = 0;
                }

                if (slime1.is_alive && player_proj.is_active) {
                    s16 dx = player_proj.x - slime1.x;
                    s16 dy = player_proj.y - slime1.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        slime1.hp -= player_proj.damage;
                        slime1.hit_flash = 8;
                        if (slime1.hp <= 0) { slime1.is_alive = 0; player.gold += 15; }
                        player_proj.is_active = 0;
                        hud_dirty = 1;
                    }
                }

                if (slime2.is_alive && player_proj.is_active) {
                    s16 dx = player_proj.x - slime2.x;
                    s16 dy = player_proj.y - slime2.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        slime2.hp -= player_proj.damage;
                        slime2.hit_flash = 8;
                        if (slime2.hp <= 0) { slime2.is_alive = 0; player.gold += 15; }
                        player_proj.is_active = 0;
                        hud_dirty = 1;
                    }
                }

                if (elemental.is_alive && player_proj.is_active) {
                    s16 dx = player_proj.x - elemental.x;
                    s16 dy = player_proj.y - elemental.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        elemental.hp -= player_proj.damage;
                        elemental.hit_flash = 8;
                        if (elemental.hp <= 0) { elemental.is_alive = 0; player.gold += 25; }
                        player_proj.is_active = 0;
                        hud_dirty = 1;
                    }
                }
            }

            // IA dos Inimigos
            if (!(player.def_timer > 0 && player.def_mode == DEF_STEALTH)) {
                if (slime1.is_alive) {
                    if (slime1.x < player.x) slime1.x += 1;
                    else if (slime1.x > player.x) slime1.x -= 1;
                    if (slime1.y < player.y) slime1.y += 1;
                    else if (slime1.y > player.y) slime1.y -= 1;
                }
                if (slime2.is_alive) {
                    if (slime2.x < player.x) slime2.x += 1;
                    else if (slime2.x > player.x) slime2.x -= 1;
                    if (slime2.y < player.y) slime2.y += 1;
                    else if (slime2.y > player.y) slime2.y -= 1;
                }
            }

            if (elemental.is_alive) {
                s16 edx = player.x - elemental.x;
                s16 edy = player.y - elemental.y;
                s16 dist_sq;
                if (edx < 0) edx = -edx;
                if (edy < 0) edy = -edy;
                dist_sq = edx + edy;

                if (dist_sq < 50) {
                    if (elemental.x < player.x && elemental.x > 25) elemental.x -= 1;
                    else if (elemental.x > player.x && elemental.x < 215) elemental.x += 1;
                    if (elemental.y < player.y && elemental.y > 45) elemental.y -= 1;
                    else if (elemental.y > player.y && elemental.y < 165) elemental.y += 1;
                }

                if (elemental.shoot_timer > 0) elemental.shoot_timer--;
                if (elemental.shoot_timer == 0 && !enemy_proj1.is_active && !(player.def_timer > 0 && player.def_mode == DEF_STEALTH)) {
                    enemy_proj1.is_active = 1;
                    enemy_proj1.x = elemental.x;
                    enemy_proj1.y = elemental.y;
                    enemy_proj1.vx = (player.x >= elemental.x) ? 3 : -3;
                    enemy_proj1.vy = (player.y >= elemental.y) ? 2 : -2;
                    enemy_proj1.damage = 12;
                    elemental.shoot_timer = 75;
                }
            }

            if (enemy_proj1.is_active) {
                enemy_proj1.x += enemy_proj1.vx;
                enemy_proj1.y += enemy_proj1.vy;
                if (enemy_proj1.x < 10 || enemy_proj1.x > 235 || enemy_proj1.y < 25 || enemy_proj1.y > 200) {
                    enemy_proj1.is_active = 0;
                }

                if (player.invuln_timer == 0) {
                    s16 dx = enemy_proj1.x - player.x;
                    s16 dy = enemy_proj1.y - player.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 12 && dy < 12) {
                        s16 dmg = enemy_proj1.damage;
                        if (player.def_timer > 0 && player.def_mode == DEF_MANA_SHIELD) dmg = 0;
                        if (player.def_timer > 0 && player.def_mode == DEF_BLOCK) dmg /= 2;

                        player.hp -= dmg;
                        player.invuln_timer = 30;
                        enemy_proj1.is_active = 0;
                        hud_dirty = 1;
                    }
                }
            }

            if (player.invuln_timer == 0) {
                if (slime1.is_alive) {
                    s16 dx = slime1.x - player.x;
                    s16 dy = slime1.y - player.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        s16 dmg = 10;
                        if (player.def_timer > 0 && player.def_mode == DEF_BLOCK) dmg = 0;
                        player.hp -= dmg;
                        player.invuln_timer = 30;
                        hud_dirty = 1;
                    }
                }
                if (slime2.is_alive) {
                    s16 dx = slime2.x - player.x;
                    s16 dy = slime2.y - player.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        s16 dmg = 10;
                        if (player.def_timer > 0 && player.def_mode == DEF_BLOCK) dmg = 0;
                        player.hp -= dmg;
                        player.invuln_timer = 30;
                        hud_dirty = 1;
                    }
                }
            }

            // Gerenciamento de Vitoria da Sala
            if (!slime1.is_alive && !slime2.is_alive && !elemental.is_alive && !room_cleared) {
                // Caso seja Arena e esteja na onda 1, inicia onda 2
                if (player.run_room_step == 3 && arena_wave == 1) {
                    arena_wave = 2;
                    slime1.x = 70; slime1.y = 80; slime1.hp = 30; slime1.hit_flash = 0; slime1.is_alive = 1;
                    elemental.x = 120; elemental.y = 60; elemental.hp = 40; elemental.hit_flash = 0; elemental.shoot_timer = 40; elemental.is_alive = 1;
                    hud_dirty = 1;
                } else {
                    room_cleared = 1;
                    door_open = 1;
                    if (player.run_room_step == 2 || player.run_room_step == 3 || player.run_room_step == 5) {
                        chest.is_spawned = 1;
                    }
                    if (player.run_room_step == 3) player.gold += 50; // Bonus da Arena
                    hud_dirty = 1;
                }
            }

            // Morte do Jogador
            if (player.hp <= 0) {
                player.hp = 0;
                return_to_village(0);
            }

            // Interacao com o Bau de Tesouro (Botao A)
            if (chest.is_spawned && !chest.is_open && (pad_down & KEY_A)) {
                s16 cdx = player.x - chest.x;
                s16 cdy = player.y - chest.y;
                if (cdx < 0) cdx = -cdx;
                if (cdy < 0) cdy = -cdy;
                if (cdx < 22 && cdy < 22) {
                    chest.is_open = 1;
                    current_state = STATE_CHEST_OPEN;
                    clear_dialogue_box();
                    hud_dirty = 1;
                }
            }

            // Interacao no Mercado (Sala 4): Balcao do Mercador
            if (player.run_room_step == 4 && (pad_down & KEY_A)) {
                s16 mdx = player.x - 120;
                s16 mdy = player.y - 95;
                if (mdx < 0) mdx = -mdx;
                if (mdy < 0) mdy = -mdy;
                if (mdx < 25 && mdy < 25) {
                    current_state = STATE_SHOP_MENU;
                    shop_feedback = "Selecione o que deseja comprar";
                    clear_dialogue_box();
                    hud_dirty = 1;
                }
            }

            // Interacao no Pre-Chefe (Sala 6): Fonte de Cura
            if (player.run_room_step == 6 && !fountain_used) {
                s16 fdx = player.x - 120;
                s16 fdy = player.y - 145;
                if (fdx < 0) fdx = -fdx;
                if (fdy < 0) fdy = -fdy;
                if (fdx < 22 && fdy < 22) {
                    fountain_used = 1;
                    player.hp = player.max_hp; // Cura total no santuario!
                    hud_dirty = 1;
                }
            }

            // Avanco para a Proxima Sala pela Porta Norte (x: 110-130, y <= 40)
            if (door_open && player.y <= 42 && player.x >= 110 && player.x <= 130) {
                advance_to_next_room();
            }

            if (slime1.hit_flash > 0) slime1.hit_flash--;
            if (slime2.hit_flash > 0) slime2.hit_flash--;
            if (elemental.hit_flash > 0) elemental.hit_flash--;
        }
        // =========================================================================
        // ESTADO 6: TELA DO BAU DE TESOURO (Escolha de Talentos)
        // =========================================================================
        else if (current_state == STATE_CHEST_OPEN) {
            u8 new_t = chest.rolled_talent_id;
            if (pad_down & KEY_Y) {
                player.talent_slots[0] = new_t;
                if (new_t == 4) player.max_hp += 30;
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            } else if (pad_down & KEY_X) {
                player.talent_slots[1] = new_t;
                if (new_t == 4) player.max_hp += 30;
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            } else if (pad_down & KEY_A) {
                player.talent_slots[2] = new_t;
                if (new_t == 4) player.max_hp += 30;
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            } else if (pad_down & KEY_B) {
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 7: TELA DA LOJA DO MERCADOR (Mercado - Sala 4)
        // =========================================================================
        else if (current_state == STATE_SHOP_MENU) {
            if (pad_down & KEY_Y) { // Pocao de Vida (40g)
                if (player.gold >= 40) {
                    player.gold -= 40;
                    player.hp = (player.hp + 35 > player.max_hp) ? player.max_hp : player.hp + 35;
                    shop_feedback = "Pocao comprada! +35 HP!   ";
                } else {
                    shop_feedback = "Ouro insuficiente! (40g)   ";
                }
                hud_dirty = 1;
            } else if (pad_down & KEY_X) { // Bencao de Forca (60g)
                if (player.gold >= 60) {
                    player.gold -= 60;
                    player.power += 4;
                    shop_feedback = "Bencao comprada! +4 Poder! ";
                } else {
                    shop_feedback = "Ouro insuficiente! (60g)   ";
                }
                hud_dirty = 1;
            } else if (pad_down & KEY_A) { // Bencao de Escudo (60g)
                if (player.gold >= 60) {
                    player.gold -= 60;
                    player.defense += 4;
                    shop_feedback = "Bencao comprada! +4 Defesa!";
                } else {
                    shop_feedback = "Ouro insuficiente! (60g)   ";
                }
                hud_dirty = 1;
            } else if (pad_down & KEY_B) {
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 8: SALA 7/7 - CAMARA DO GENERAL DA AGUA (Chefe)
        // =========================================================================
        else if (current_state == STATE_BOSS_CHAMBER) {
            player.is_moving = 0;
            if (pad_held & KEY_UP) {
                if (player.y > 45) player.y -= player.move_speed;
                player.dir = 1;
                player.is_moving = 1;
            }
            if (pad_held & KEY_DOWN) {
                if (player.y < 185) player.y += player.move_speed;
                player.dir = 0;
                player.is_moving = 1;
            }
            if (pad_held & KEY_LEFT) {
                if (player.x > 20) player.x -= player.move_speed;
                player.dir = 2;
                player.is_moving = 1;
            }
            if (pad_held & KEY_RIGHT) {
                if (player.x < 220) player.x += player.move_speed;
                player.dir = 3;
                player.is_moving = 1;
            }

            // Defesa / Especial (Botao B)
            if ((pad_down & KEY_B) && player.def_cooldown == 0) {
                if (player.def_mode == DEF_BLOCK) {
                    player.def_timer = 120;
                    player.def_cooldown = 200;
                } else if (player.def_mode == DEF_MANA_SHIELD) {
                    player.def_timer = 100;
                    player.def_cooldown = 240;
                } else if (player.def_mode == DEF_ROLL) {
                    player.def_timer = 15;
                    player.invuln_timer = 15;
                    player.def_cooldown = 120;
                } else if (player.def_mode == DEF_STEALTH) {
                    player.def_timer = 150;
                    player.def_cooldown = 260;
                }
            }

            if (player.def_timer > 0 && player.def_mode == DEF_ROLL) {
                if (player.dir == 0 && player.y < 185) player.y += 4;
                if (player.dir == 1 && player.y > 45)  player.y -= 4;
                if (player.dir == 2 && player.x > 20)  player.x -= 4;
                if (player.dir == 3 && player.x < 220) player.x += 4;
            }

            // Ataque do Heroi (Botao Y)
            if ((pad_down & KEY_Y) && player.atk_cooldown == 0) {
                player.atk_timer = (player.class_id == CLASS_ASSASSIN) ? 6 : 12;
                player.atk_cooldown = (player.class_id == CLASS_ASSASSIN) ? 10 : 18;

                if (player.class_id == CLASS_MAGE || player.class_id == CLASS_ARCHER) {
                    player_proj.is_active = 1;
                    player_proj.x = player.x;
                    player_proj.y = player.y;
                    player_proj.damage = player.power;
                    if (player.dir == 0) { player_proj.vx = 0; player_proj.vy = 5; }
                    else if (player.dir == 1) { player_proj.vx = 0; player_proj.vy = -5; }
                    else if (player.dir == 2) { player_proj.vx = -5; player_proj.vy = 0; }
                    else if (player.dir == 3) { player_proj.vx = 5; player_proj.vy = 0; }
                }

                if (boss.is_alive && (player.class_id == CLASS_KNIGHT || player.class_id == CLASS_ASSASSIN)) {
                    s16 atk_cx = player.x;
                    s16 atk_cy = player.y;
                    if (player.dir == 0) atk_cy += 14;
                    if (player.dir == 1) atk_cy -= 14;
                    if (player.dir == 2) atk_cx -= 14;
                    if (player.dir == 3) atk_cx += 14;

                    {
                        s16 bdx = atk_cx - boss.x;
                        s16 bdy = atk_cy - boss.y;
                        if (bdx < 0) bdx = -bdx;
                        if (bdy < 0) bdy = -bdy;
                        if (bdx < 20 && bdy < 20) {
                            s16 dmg = player.power;
                            if (boss.state == 2) dmg *= 2;
                            boss.hp -= dmg;
                            boss.hit_flash = 8;
                            hud_dirty = 1;
                        }
                    }
                }
            }

            if (player_proj.is_active) {
                player_proj.x += player_proj.vx;
                player_proj.y += player_proj.vy;

                if (player_proj.x < 10 || player_proj.x > 235 || player_proj.y < 25 || player_proj.y > 200) {
                    player_proj.is_active = 0;
                }

                if (boss.is_alive && player_proj.is_active) {
                    s16 bdx = player_proj.x - boss.x;
                    s16 bdy = player_proj.y - boss.y;
                    if (bdx < 0) bdx = -bdx;
                    if (bdy < 0) bdy = -bdy;
                    if (bdx < 18 && bdy < 18) {
                        s16 dmg = player_proj.damage;
                        if (boss.state == 2) dmg *= 2;
                        boss.hp -= dmg;
                        boss.hit_flash = 8;
                        player_proj.is_active = 0;
                        hud_dirty = 1;
                    }
                }
            }

            // IA do General da Agua
            if (boss.is_alive) {
                if (boss.hp <= 0) {
                    boss.hp = 0;
                    boss.is_alive = 0;
                    essence_spawned = 1;
                    boss_portal_open = 1;
                    hud_dirty = 1;
                } else {
                    if (boss.state == 0) {
                        boss.x += boss.dir_x;
                        if (boss.x < 50)  { boss.x = 50;  boss.dir_x = 1; }
                        if (boss.x > 190) { boss.x = 190; boss.dir_x = -1; }

                        if (boss.shoot_timer > 0) boss.shoot_timer--;
                        if (boss.shoot_timer == 0) {
                            boss.shoot_timer = 75;
                            enemy_proj1.is_active = 1;
                            enemy_proj1.x = boss.x;
                            enemy_proj1.y = boss.y + 8;
                            enemy_proj1.vx = (player.x >= boss.x) ? 2 : -2;
                            enemy_proj1.vy = 3;
                            enemy_proj1.damage = 15;
                        }

                        {
                            s16 pdx = player.x - boss.x;
                            s16 pdy = player.y - boss.y;
                            if (pdx < 0) pdx = -pdx;
                            if (pdy < 0) pdy = -pdy;
                            if (pdx < 45 && pdy < 45) {
                                boss.state = 1;
                                boss.slam_timer = 50;
                                hud_dirty = 1;
                            }
                        }
                    } else if (boss.state == 1) {
                        if (boss.slam_timer > 0) boss.slam_timer--;
                        boss.hit_flash = 2;
                        if (boss.slam_timer == 0) {
                            s16 pdx = player.x - boss.x;
                            s16 pdy = player.y - boss.y;
                            if (pdx < 0) pdx = -pdx;
                            if (pdy < 0) pdy = -pdy;
                            if (pdx < 38 && pdy < 38 && player.invuln_timer == 0) {
                                s16 dmg = 25;
                                if (player.def_timer > 0 && player.def_mode == DEF_BLOCK) dmg = 5;
                                player.hp -= dmg;
                                player.invuln_timer = 40;
                                hud_dirty = 1;
                            }
                            boss.state = 2;
                            boss.vuln_timer = 110;
                            hud_dirty = 1;
                        }
                    } else if (boss.state == 2) {
                        if (boss.vuln_timer > 0) boss.vuln_timer--;
                        if (boss.vuln_timer == 0) {
                            boss.state = 0;
                            boss.shoot_timer = 60;
                            hud_dirty = 1;
                        }
                    }
                }
            }

            if (enemy_proj1.is_active) {
                enemy_proj1.x += enemy_proj1.vx;
                enemy_proj1.y += enemy_proj1.vy;
                if (enemy_proj1.x < 10 || enemy_proj1.x > 235 || enemy_proj1.y < 25 || enemy_proj1.y > 200) {
                    enemy_proj1.is_active = 0;
                }

                if (player.invuln_timer == 0) {
                    s16 dx = enemy_proj1.x - player.x;
                    s16 dy = enemy_proj1.y - player.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 12 && dy < 12) {
                        s16 dmg = enemy_proj1.damage;
                        if (player.def_timer > 0 && player.def_mode == DEF_MANA_SHIELD) dmg = 0;
                        if (player.def_timer > 0 && player.def_mode == DEF_BLOCK) dmg /= 2;

                        player.hp -= dmg;
                        player.invuln_timer = 35;
                        enemy_proj1.is_active = 0;
                        hud_dirty = 1;
                    }
                }
            }

            if (player.hp <= 0) {
                player.hp = 0;
                return_to_village(0);
            }

            if (essence_spawned && !essence_collected) {
                s16 edx = player.x - 120;
                s16 edy = player.y - 110;
                if (edx < 0) edx = -edx;
                if (edy < 0) edy = -edy;
                if (edx < 18 && edy < 18) {
                    essence_collected = 1;
                    if (player.essences_rescued < 4) {
                        player.essences_rescued++;
                    }
                    hud_dirty = 1;
                }
            }

            if (boss_portal_open && player.y <= 42 && player.x >= 110 && player.x <= 130) {
                return_to_village(1);
            }

            if (boss.hit_flash > 0) boss.hit_flash--;
        }

        // =========================================================================
        // ATUALIZACAO DOS 19 SPRITES DE HARDWARE (OAM)
        // =========================================================================

        // 1. Heroi (OAM_PLAYER = 0)
        {
            u16 spr_tile = SPR_HERO_DOWN;
            u8 spr_hflip = 0;
            u8 hero_pal;

            if (player.dir == 1) {
                spr_tile = SPR_HERO_UP;
            } else if (player.dir == 2) {
                spr_tile = SPR_HERO_RIGHT;
                spr_hflip = 1;
            } else if (player.dir == 3) {
                spr_tile = SPR_HERO_RIGHT;
                spr_hflip = 0;
            }

            hero_pal = player.class_id;
            if (player.invuln_timer > 0 && (player.invuln_timer & 2)) {
                hero_pal = 4;
            }
            if (player.def_timer > 0 && player.def_mode == DEF_STEALTH && (player.def_timer & 4)) {
                hero_pal = 4;
            }
            oamSet(OAM_PLAYER, player.x, player.y, 3, spr_hflip, 0, spr_tile, hero_pal);
        }

        // 2. Arco de Ataque Melee (OAM_ATK_SLASH = 4)
        if (player.atk_timer > 0 && (player.class_id == CLASS_KNIGHT || player.class_id == CLASS_ASSASSIN)) {
            s16 atk_x = player.x;
            s16 atk_y = player.y;
            u8 atk_hflip = 0;
            if (player.dir == 0) atk_y += 12;
            else if (player.dir == 1) atk_y -= 12;
            else if (player.dir == 2) { atk_x -= 12; atk_hflip = 1; }
            else if (player.dir == 3) { atk_x += 12; }
            oamSet(OAM_ATK_SLASH, atk_x, atk_y, 3, atk_hflip, 0, SPR_ATTACK_SLASH, 0);
        } else {
            oamSet(OAM_ATK_SLASH, 0, 240, 0, 0, 0, 0, 0);
        }

        // 3. Escudo / Barreira Defensiva (OAM_SHIELD_DEF = 8)
        if (player.def_timer > 0 && (player.def_mode == DEF_BLOCK || player.def_mode == DEF_MANA_SHIELD)) {
            s16 def_x = player.x;
            s16 def_y = player.y;
            u8 def_pal = (player.def_mode == DEF_MANA_SHIELD) ? 5 : 0;
            if (player.def_mode == DEF_BLOCK) {
                if (player.dir == 0) def_y += 8;
                if (player.dir == 1) def_y -= 8;
                if (player.dir == 2) def_x -= 8;
                if (player.dir == 3) def_x += 8;
            }
            oamSet(OAM_SHIELD_DEF, def_x, def_y, 3, 0, 0, SPR_SHIELD, def_pal);
        } else {
            oamSet(OAM_SHIELD_DEF, 0, 240, 0, 0, 0, 0, 0);
        }

        // 4. Projetil do Jogador (OAM_PLAYER_PROJ = 12)
        if (player_proj.is_active) {
            u8 proj_pal = (player.class_id == CLASS_MAGE) ? 1 : 2;
            oamSet(OAM_PLAYER_PROJ, player_proj.x, player_proj.y, 3, 0, 0, SPR_PROJECTILE, proj_pal);
        } else {
            oamSet(OAM_PLAYER_PROJ, 0, 240, 0, 0, 0, 0, 0);
        }

        // CENARIO 1: A VILA
        if (current_state == STATE_VILLAGE || current_state == STATE_PORTAL_CONFIRM ||
            current_state == STATE_ALTAR_MENU || current_state == STATE_VICTORY) {

            u8 dummy_pal = (dummy_hit_flash > 0) ? 4 : 0;
            oamSet(OAM_DUMMY,     120, 165, 3, 0, 0, SPR_TRAINING_DUMMY, dummy_pal);
            oamSet(OAM_PEDESTAL0, pedestals[0].x, pedestals[0].y, 3, 0, 0, SPR_PEDESTAL, 0);
            oamSet(OAM_PEDESTAL1, pedestals[1].x, pedestals[1].y, 3, 0, 0, SPR_PEDESTAL, 1);
            oamSet(OAM_PEDESTAL2, pedestals[2].x, pedestals[2].y, 3, 0, 0, SPR_PEDESTAL, 2);
            oamSet(OAM_PEDESTAL3, pedestals[3].x, pedestals[3].y, 3, 0, 0, SPR_PEDESTAL, 3);
            oamSet(OAM_ALTAR,     120, 75,  3, 0, 0, SPR_ALTAR, 0);
            oamSet(OAM_PORTAL,    120, 35,  3, 0, 0, SPR_PORTAL, 0);

            oamSet(OAM_CHEST,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME1,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME2,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ELEMENTAL,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_BOSS,        0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ENEMY_PROJ1, 0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ENEMY_PROJ2, 0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ESSENCE,     0, 240, 0, 0, 0, 0, 0);
        }
        // CENARIO 2: FICHA DE TALENTOS
        else if (current_state == STATE_TALENTS_MENU) {
            oamSet(OAM_PLAYER,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_DUMMY,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL0,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL1,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL2,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL3,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ALTAR,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PORTAL,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_CHEST,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME1,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME2,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ELEMENTAL,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_BOSS,        0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ENEMY_PROJ1, 0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ENEMY_PROJ2, 0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ESSENCE,     0, 240, 0, 0, 0, 0, 0);
        }
        // CENARIO 3: SALAS DE 1 A 6 DA MASMORRA
        else if (current_state == STATE_DUNGEON_CHAMBER || current_state == STATE_CHEST_OPEN || current_state == STATE_SHOP_MENU) {
            oamSet(OAM_PEDESTAL0,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL1,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL2,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL3,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ALTAR,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_BOSS,        0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ESSENCE,     0, 240, 0, 0, 0, 0, 0);

            // Sala 4 (Mercado) ou Sala 6 (Pre-Chefe: Fonte)
            if (player.run_room_step == 4) {
                // Balcao do Mercador
                oamSet(OAM_DUMMY, 120, 95, 3, 0, 0, SPR_TRAINING_DUMMY, 0);
            } else if (player.run_room_step == 6) {
                // Fonte de Cura Sagrada
                u8 fountain_pal = (fountain_used) ? 0 : 5;
                oamSet(OAM_DUMMY, 120, 145, 3, 0, 0, SPR_PEDESTAL, fountain_pal);
            } else {
                oamSet(OAM_DUMMY, 0, 240, 0, 0, 0, 0, 0);
            }

            // Portal de Saida ao Norte (desenhado no topo quando a porta abre)
            if (door_open) {
                oamSet(OAM_PORTAL, 120, 35, 3, 0, 0, SPR_PORTAL, 0);
            } else {
                oamSet(OAM_PORTAL, 0, 240, 0, 0, 0, 0, 0);
            }

            // Slime 1
            if (slime1.is_alive) {
                u8 s1_pal = (slime1.hit_flash > 0) ? 4 : 2;
                oamSet(OAM_SLIME1, slime1.x, slime1.y, 3, 0, 0, SPR_SLIME, s1_pal);
            } else {
                oamSet(OAM_SLIME1, 0, 240, 0, 0, 0, 0, 0);
            }

            // Slime 2
            if (slime2.is_alive) {
                u8 s2_pal = (slime2.hit_flash > 0) ? 4 : 2;
                oamSet(OAM_SLIME2, slime2.x, slime2.y, 3, 0, 0, SPR_SLIME, s2_pal);
            } else {
                oamSet(OAM_SLIME2, 0, 240, 0, 0, 0, 0, 0);
            }

            // Elemental de Gelo
            if (elemental.is_alive) {
                u8 elem_pal = (elemental.hit_flash > 0) ? 4 : 5;
                oamSet(OAM_ELEMENTAL, elemental.x, elemental.y, 3, 0, 0, SPR_ELEMENTAL, elem_pal);
            } else {
                oamSet(OAM_ELEMENTAL, 0, 240, 0, 0, 0, 0, 0);
            }

            // Bau de Tesouro
            if (chest.is_spawned) {
                u16 chest_tile = chest.is_open ? SPR_CHEST_OPENED : SPR_CHEST_CLOSED;
                oamSet(OAM_CHEST, chest.x, chest.y, 3, 0, 0, chest_tile, 6);
            } else {
                oamSet(OAM_CHEST, 0, 240, 0, 0, 0, 0, 0);
            }

            // Projetil Inimigo (Gelo)
            if (enemy_proj1.is_active) {
                oamSet(OAM_ENEMY_PROJ1, enemy_proj1.x, enemy_proj1.y, 3, 0, 0, SPR_PROJECTILE, 5);
            } else {
                oamSet(OAM_ENEMY_PROJ1, 0, 240, 0, 0, 0, 0, 0);
            }
            oamSet(OAM_ENEMY_PROJ2, 0, 240, 0, 0, 0, 0, 0);
        }
        // CENARIO 4: SALA 7/7 - CAMARA DO GENERAL DA AGUA
        else if (current_state == STATE_BOSS_CHAMBER) {
            oamSet(OAM_DUMMY,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL0,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL1,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL2,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL3,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ALTAR,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_CHEST,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME1,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_SLIME2,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ELEMENTAL,   0, 240, 0, 0, 0, 0, 0);

            if (boss.is_alive) {
                u8 boss_pal = 7;
                u8 boss_hflip = (boss.dir_x < 0) ? 1 : 0;
                if (boss.hit_flash > 0 || boss.state == 2) boss_pal = 4;
                oamSet(OAM_BOSS, boss.x, boss.y, 3, boss_hflip, 0, SPR_BOSS_ENEMY, boss_pal);
            } else {
                oamSet(OAM_BOSS, 0, 240, 0, 0, 0, 0, 0);
            }

            if (enemy_proj1.is_active) {
                oamSet(OAM_ENEMY_PROJ1, enemy_proj1.x, enemy_proj1.y, 3, 0, 0, SPR_PROJECTILE, 5);
            } else {
                oamSet(OAM_ENEMY_PROJ1, 0, 240, 0, 0, 0, 0, 0);
            }
            oamSet(OAM_ENEMY_PROJ2, 0, 240, 0, 0, 0, 0, 0);

            if (essence_spawned && !essence_collected) {
                oamSet(OAM_ESSENCE, 120, 110, 3, 0, 0, SPR_ESSENCE, 0);
            } else {
                oamSet(OAM_ESSENCE, 0, 240, 0, 0, 0, 0, 0);
            }

            if (boss_portal_open) {
                oamSet(OAM_PORTAL, 120, 35, 3, 0, 0, SPR_PORTAL, 0);
            } else {
                oamSet(OAM_PORTAL, 0, 240, 0, 0, 0, 0, 0);
            }
        }

        if (hud_dirty) {
            draw_hud();
            hud_dirty = 0;
        }

        WaitForVBlank();
    }

    return 0;
}
