/*---------------------------------------------------------------------------------
    Fallen Hero - Super Nintendo (SNES) Native 16-Bit Edition
    Port 100% Fiel a Mecanica e Dinamica do GameMaker Studio 2
---------------------------------------------------------------------------------*/
#include <snes.h>
#include "game.h"
#include "sprites.h"

// IDs dos Sprites de Hardware na OAM (Multiplos de 4 obrigatorios no hardware SNES)
#define OAM_PLAYER         (0 * 4)   // 0: Heroi (quadrado com olhinhos)
#define OAM_ATK_SLASH      (1 * 4)   // 4: Arco de corte / golpe (Cavaleiro / Assassino)
#define OAM_SHIELD_DEF     (2 * 4)   // 8: Escudo / Barreira de Mana
#define OAM_PLAYER_PROJ    (3 * 4)   // 12: Projetil do Jogador (Maga / Arqueiro)
#define OAM_DUMMY          (4 * 4)   // 16: Boneco de Treino (Vila)
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

// Estado da Masmorra
static SlimeMob slime1;
static SlimeMob slime2;
static ElementalMob elemental;
static DungeonChest chest;
static u8 chamber1_cleared = 0;
static u8 dungeon_door_open = 0;

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
void enter_dungeon_chamber(void);
void enter_boss_chamber(void);
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

void enter_dungeon_chamber(void) {
    setFadeEffect(FADE_OUT);
    WaitForVBlank();
    clear_screen_text();

    current_state = STATE_DUNGEON_CHAMBER;
    player.x = 120;
    player.y = 180;
    player.dir = 1;
    player.atk_timer = 0;
    player.def_timer = 0;
    player.def_cooldown = 0;
    player.invuln_timer = 0;

    // Slimes
    slime1.x = 60;
    slime1.y = 95;
    slime1.hp = 30;
    slime1.hit_flash = 0;
    slime1.is_alive = 1;

    slime2.x = 180;
    slime2.y = 95;
    slime2.hp = 30;
    slime2.hit_flash = 0;
    slime2.is_alive = 1;

    // Elemental de Gelo (Atacante a Distancia do GM)
    elemental.x = 120;
    elemental.y = 65;
    elemental.hp = 45;
    elemental.hit_flash = 0;
    elemental.shoot_timer = 60;
    elemental.is_alive = 1;

    // Bau de Tesouro
    chest.x = 120;
    chest.y = 110;
    chest.is_spawned = 0;
    chest.is_open = 0;
    chest.rolled_talent_id = 4; // Vitalidade (+30 HP) ou Segundo Folego

    chamber1_cleared = 0;
    dungeon_door_open = 0;

    // Projeteis zerados
    player_proj.is_active = 0;
    player_proj.x = 0;
    player_proj.y = 240;

    enemy_proj1.is_active = 0;
    enemy_proj1.x = 0;
    enemy_proj1.y = 240;

    enemy_proj2.is_active = 0;
    enemy_proj2.x = 0;
    enemy_proj2.y = 240;

    hud_dirty = 1;
    WaitForVBlank();
    setFadeEffect(FADE_IN);
}

void enter_boss_chamber(void) {
    setFadeEffect(FADE_OUT);
    WaitForVBlank();
    clear_screen_text();

    current_state = STATE_BOSS_CHAMBER;
    player.x = 120;
    player.y = 180;
    player.dir = 1;
    player.atk_timer = 0;
    player.def_timer = 0;
    player.def_cooldown = 0;
    player.invuln_timer = 0;

    // General da Agua (Chefe com padrao Sakurai)
    boss.x = 120;
    boss.y = 60;
    boss.dir_x = 1;
    boss.dir_y = 0;
    boss.max_hp = 300;
    boss.hp = 300;
    boss.hit_flash = 0;
    boss.shoot_timer = 60;
    boss.slam_timer = 0;
    boss.vuln_timer = 0;
    boss.state = 0;
    boss.is_alive = 1;

    essence_spawned = 0;
    essence_collected = 0;
    boss_portal_open = 0;

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
        consoleDrawText(1, 3, "HP:[%s] %d/%d  ESSENCIA:%d/4", hp_buf, player.hp, player.max_hp, player.essences_rescued);

        if (current_state == STATE_VILLAGE) {
            consoleDrawText(1, 25, "D-Pad:Andar  Y:Atacar  B:Especial");
            consoleDrawText(1, 26, "A:Pedestal/Altar  X:Ficha/Talentos");
        } else if (current_state == STATE_PORTAL_CONFIRM) {
            consoleDrawText(1, 18, "==============================");
            consoleDrawText(1, 19, "PORTAL DIMENSIONAL (ROOM 1)   ");
            consoleDrawText(1, 20, "------------------------------");
            consoleDrawText(1, 21, "Entrar na Masmorra de Agua?   ");
            consoleDrawText(1, 22, "Enfrente os monstros da fase  ");
            consoleDrawText(1, 23, "e alcance o General da Agua!  ");
            consoleDrawText(1, 24, "------------------------------");
            consoleDrawText(1, 25, "[A] ENTRAR NA MASMORRA        ");
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
            consoleDrawText(1, 19, "VITORIA! ESSENCIA RESGATADA!  ");
            consoleDrawText(1, 20, "------------------------------");
            consoleDrawText(1, 21, "O General foi purificado!     ");
            consoleDrawText(1, 22, "A agua limipida corre na vila!");
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

        consoleDrawText(1, 6, "PODER:%d  DEFESA:%d  VEL:%d", player.power, player.defense, player.move_speed);
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
        consoleDrawText(1, 1, "== MASMORRA (SALA 1 DE MOBS) ==");
        consoleDrawText(1, 2, "CLASSE: ");
        consoleDrawText(9, 2, (char*)class_names[player.class_id]);

        get_hp_bar(hp_buf, player.hp, player.max_hp, 8);
        consoleDrawText(1, 3, "HP:[%s] %d/%d  ESP:[B]", hp_buf, player.hp, player.max_hp);

        if (!chamber1_cleared) {
            consoleDrawText(1, 4, "INIMIGOS: Derrote os monstros! ");
        } else {
            consoleDrawText(1, 4, "SALA LIMPA! Abra o Bau / Porta ");
        }

        consoleDrawText(1, 25, "Y:Ataque  B:Especial  A:Bau    ");
        if (dungeon_door_open) {
            consoleDrawText(1, 26, "PORTA DO CHEFE ABERTA AO NORTE ");
        } else {
            consoleDrawText(1, 26, "Limpe a sala para avancar!     ");
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
    } else if (current_state == STATE_BOSS_CHAMBER) {
        consoleDrawText(1, 1, "== CAMARA DO GENERAL DA AGUA ==");
        consoleDrawText(1, 2, "CLASSE: ");
        consoleDrawText(9, 2, (char*)class_names[player.class_id]);

        get_hp_bar(hp_buf, player.hp, player.max_hp, 8);
        consoleDrawText(1, 3, "HP HEROI: [%s] %d/%d", hp_buf, player.hp, player.max_hp);

        if (boss.is_alive) {
            get_hp_bar(boss_buf, boss.hp, boss.max_hp, 8);
            if (boss.state == 2) {
                consoleDrawText(1, 4, "CHEFE: [VULNERAVEL!] %d/300", boss.hp);
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
        // ESTADO 1: A VILA (Hub Seguro - Fiel ao GameMaker)
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

            // Entrar no Portal ao caminhar diretamente no topo (120, 35)
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

                // Se for Arqueiro ou Maga, atira projetil
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

                // Colisao com Boneco de Treino (120, 165)
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

            // Habilidade de Defesa / Especial (Botao B)
            if ((pad_down & KEY_B) && player.def_cooldown == 0) {
                if (player.def_mode == DEF_BLOCK) {
                    player.def_timer = 120; // 2 segundos de escudo
                    player.def_cooldown = 200;
                } else if (player.def_mode == DEF_MANA_SHIELD) {
                    player.def_timer = 100;
                    player.def_cooldown = 240;
                } else if (player.def_mode == DEF_ROLL) {
                    player.def_timer = 15;  // 0.25s de dash veloz
                    player.invuln_timer = 15;
                    player.def_cooldown = 120;
                } else if (player.def_mode == DEF_STEALTH) {
                    player.def_timer = 150; // 2.5s invisivel
                    player.def_cooldown = 260;
                }
            }

            // Movimento do Rolamento (Dash do Arqueiro)
            if (player.def_timer > 0 && player.def_mode == DEF_ROLL) {
                if (player.dir == 0 && player.y < 185) player.y += 4;
                if (player.dir == 1 && player.y > 36)  player.y -= 4;
                if (player.dir == 2 && player.x > 16)  player.x -= 4;
                if (player.dir == 3 && player.x < 225) player.x += 4;
            }

            // Interagir com Pedestais de Classe, Altar ou Portal (Botao A)
            if (pad_down & KEY_A) {
                u8 p;
                // 1. Checa os 4 Pedestais
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

                // 2. Checa o Altar (120, 75)
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

                // 3. Checa o Portal (120, 35)
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
                enter_dungeon_chamber(); // Entra na Camara 1 da Masmorra!
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
                current_state = STATE_VILLAGE;
                clear_screen_text();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 5: CAMARA 1 DA MASMORRA (Slimes + Elemental de Gelo)
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

            // Movimento do Rolamento (Dash do Arqueiro)
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

                // Maga e Arqueiro disparam projetil
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

                // Cavaleiro e Assassino: Golpe corpo-a-corpo
                if (player.class_id == CLASS_KNIGHT || player.class_id == CLASS_ASSASSIN) {
                    s16 atk_cx = player.x;
                    s16 atk_cy = player.y;
                    if (player.dir == 0) atk_cy += 14;
                    if (player.dir == 1) atk_cy -= 14;
                    if (player.dir == 2) atk_cx -= 14;
                    if (player.dir == 3) atk_cx += 14;

                    // Acerto em Slime 1
                    if (slime1.is_alive) {
                        s16 dx = atk_cx - slime1.x;
                        s16 dy = atk_cy - slime1.y;
                        if (dx < 0) dx = -dx;
                        if (dy < 0) dy = -dy;
                        if (dx < 16 && dy < 16) {
                            slime1.hp -= player.power;
                            slime1.hit_flash = 8;
                            if (slime1.hp <= 0) slime1.is_alive = 0;
                            hud_dirty = 1;
                        }
                    }

                    // Acerto em Slime 2
                    if (slime2.is_alive) {
                        s16 dx = atk_cx - slime2.x;
                        s16 dy = atk_cy - slime2.y;
                        if (dx < 0) dx = -dx;
                        if (dy < 0) dy = -dy;
                        if (dx < 16 && dy < 16) {
                            slime2.hp -= player.power;
                            slime2.hit_flash = 8;
                            if (slime2.hp <= 0) slime2.is_alive = 0;
                            hud_dirty = 1;
                        }
                    }

                    // Acerto em Elemental
                    if (elemental.is_alive) {
                        s16 dx = atk_cx - elemental.x;
                        s16 dy = atk_cy - elemental.y;
                        if (dx < 0) dx = -dx;
                        if (dy < 0) dy = -dy;
                        if (dx < 16 && dy < 16) {
                            elemental.hp -= player.power;
                            elemental.hit_flash = 8;
                            if (elemental.hp <= 0) elemental.is_alive = 0;
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

                // Colisao com Slime 1
                if (slime1.is_alive && player_proj.is_active) {
                    s16 dx = player_proj.x - slime1.x;
                    s16 dy = player_proj.y - slime1.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        slime1.hp -= player_proj.damage;
                        slime1.hit_flash = 8;
                        if (slime1.hp <= 0) slime1.is_alive = 0;
                        player_proj.is_active = 0;
                        hud_dirty = 1;
                    }
                }

                // Colisao com Slime 2
                if (slime2.is_alive && player_proj.is_active) {
                    s16 dx = player_proj.x - slime2.x;
                    s16 dy = player_proj.y - slime2.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        slime2.hp -= player_proj.damage;
                        slime2.hit_flash = 8;
                        if (slime2.hp <= 0) slime2.is_alive = 0;
                        player_proj.is_active = 0;
                        hud_dirty = 1;
                    }
                }

                // Colisao com Elemental
                if (elemental.is_alive && player_proj.is_active) {
                    s16 dx = player_proj.x - elemental.x;
                    s16 dy = player_proj.y - elemental.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        elemental.hp -= player_proj.damage;
                        elemental.hit_flash = 8;
                        if (elemental.hp <= 0) elemental.is_alive = 0;
                        player_proj.is_active = 0;
                        hud_dirty = 1;
                    }
                }
            }

            // IA dos Slimes (Perseguem o heroi se ele nao estiver invisivel)
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

            // IA do Elemental (Kiting + Disparo de Gelo fiel ao GM)
            if (elemental.is_alive) {
                s16 edx = player.x - elemental.x;
                s16 edy = player.y - elemental.y;
                s16 dist_sq;
                if (edx < 0) edx = -edx;
                if (edy < 0) edy = -edy;
                dist_sq = edx + edy;

                // Kiting: se o jogador chegar muito perto (< 50px), o elemental se afasta
                if (dist_sq < 50) {
                    if (elemental.x < player.x && elemental.x > 25) elemental.x -= 1;
                    else if (elemental.x > player.x && elemental.x < 215) elemental.x += 1;
                    if (elemental.y < player.y && elemental.y > 45) elemental.y -= 1;
                    else if (elemental.y > player.y && elemental.y < 165) elemental.y += 1;
                }

                // Disparo de Gelo a cada 75 frames
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

            // Movimento do Projetil do Elemental
            if (enemy_proj1.is_active) {
                enemy_proj1.x += enemy_proj1.vx;
                enemy_proj1.y += enemy_proj1.vy;
                if (enemy_proj1.x < 10 || enemy_proj1.x > 235 || enemy_proj1.y < 25 || enemy_proj1.y > 200) {
                    enemy_proj1.is_active = 0;
                }

                // Dano no Jogador
                if (player.invuln_timer == 0) {
                    s16 dx = enemy_proj1.x - player.x;
                    s16 dy = enemy_proj1.y - player.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 12 && dy < 12) {
                        s16 dmg = enemy_proj1.damage;
                        if (player.def_timer > 0 && player.def_mode == DEF_MANA_SHIELD) dmg = 0; // Mana Shield absorve!
                        if (player.def_timer > 0 && player.def_mode == DEF_BLOCK) dmg /= 2;

                        player.hp -= dmg;
                        player.invuln_timer = 30;
                        enemy_proj1.is_active = 0;
                        hud_dirty = 1;
                    }
                }
            }

            // Dano por contato de Slimes
            if (player.invuln_timer == 0) {
                if (slime1.is_alive) {
                    s16 dx = slime1.x - player.x;
                    s16 dy = slime1.y - player.y;
                    if (dx < 0) dx = -dx;
                    if (dy < 0) dy = -dy;
                    if (dx < 14 && dy < 14) {
                        s16 dmg = 10;
                        if (player.def_timer > 0 && player.def_mode == DEF_BLOCK) dmg = 0; // Escudo bloqueia contato fisico!
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

            // Checa se a sala foi limpa
            if (!slime1.is_alive && !slime2.is_alive && !elemental.is_alive && !chamber1_cleared) {
                chamber1_cleared = 1;
                chest.is_spawned = 1;
                dungeon_door_open = 1;
                hud_dirty = 1;
            }

            // Morte do Jogador
            if (player.hp <= 0) {
                player.hp = 0;
                return_to_village(0);
            }

            // Interagir com o Bau de Tesouro (Botao A)
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

            // Passar para a Camara do Chefe pela porta ao Norte (x: 110-130, y <= 40)
            if (dungeon_door_open && player.y <= 42 && player.x >= 110 && player.x <= 130) {
                enter_boss_chamber();
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
            if (pad_down & KEY_Y) { // Equipar no Slot 1
                player.talent_slots[0] = new_t;
                if (new_t == 4) player.max_hp += 30;
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            } else if (pad_down & KEY_X) { // Equipar no Slot 2
                player.talent_slots[1] = new_t;
                if (new_t == 4) player.max_hp += 30;
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            } else if (pad_down & KEY_A) { // Equipar no Slot 3
                player.talent_slots[2] = new_t;
                if (new_t == 4) player.max_hp += 30;
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            } else if (pad_down & KEY_B) { // Descartar
                current_state = STATE_DUNGEON_CHAMBER;
                clear_dialogue_box();
                hud_dirty = 1;
            }
        }
        // =========================================================================
        // ESTADO 7: CAMARA DO GENERAL DA AGUA (Chefe)
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
                            if (boss.state == 2) dmg *= 2; // Vulneravel: Dano dobrado!
                            boss.hp -= dmg;
                            boss.hit_flash = 8;
                            hud_dirty = 1;
                        }
                    }
                }
            }

            // Projetil do Jogador contra o Chefe
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

            // IA do General da Agua (Padrao Sakurai de Fases e Telegraph)
            if (boss.is_alive) {
                // Checa morte do Chefe
                if (boss.hp <= 0) {
                    boss.hp = 0;
                    boss.is_alive = 0;
                    essence_spawned = 1;
                    boss_portal_open = 1;
                    hud_dirty = 1;
                } else {
                    // Estado 0: Patrulha e Disparos
                    if (boss.state == 0) {
                        boss.x += boss.dir_x;
                        if (boss.x < 50)  { boss.x = 50;  boss.dir_x = 1; }
                        if (boss.x > 190) { boss.x = 190; boss.dir_x = -1; }

                        // Disparo periodico
                        if (boss.shoot_timer > 0) boss.shoot_timer--;
                        if (boss.shoot_timer == 0) {
                            boss.shoot_timer = 80;
                            enemy_proj1.is_active = 1;
                            enemy_proj1.x = boss.x;
                            enemy_proj1.y = boss.y + 8;
                            enemy_proj1.vx = (player.x >= boss.x) ? 2 : -2;
                            enemy_proj1.vy = 3;
                            enemy_proj1.damage = 15;
                        }

                        // Risco x Recompensa: Se o jogador se aproximar a menos de 45px, aciona o Slam!
                        {
                            s16 pdx = player.x - boss.x;
                            s16 pdy = player.y - boss.y;
                            if (pdx < 0) pdx = -pdx;
                            if (pdy < 0) pdy = -pdy;
                            if (pdx < 45 && pdy < 45) {
                                boss.state = 1; // Entra em Telegraph de Slam
                                boss.slam_timer = 50;
                                hud_dirty = 1;
                            }
                        }
                    }
                    // Estado 1: Telegraph do Slam (Pisca de alerta)
                    else if (boss.state == 1) {
                        if (boss.slam_timer > 0) boss.slam_timer--;
                        boss.hit_flash = 2; // Pisca em alerta
                        if (boss.slam_timer == 0) {
                            // Executa o Slam!
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
                            boss.state = 2; // Fica Vulneravel!
                            boss.vuln_timer = 110;
                            hud_dirty = 1;
                        }
                    }
                    // Estado 2: Janela de Vulnerabilidade
                    else if (boss.state == 2) {
                        if (boss.vuln_timer > 0) boss.vuln_timer--;
                        if (boss.vuln_timer == 0) {
                            boss.state = 0; // Retorna a patrulhar
                            boss.shoot_timer = 60;
                            hud_dirty = 1;
                        }
                    }
                }
            }

            // Movimento do Projetil do Chefe
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

            // Morte do Heroi
            if (player.hp <= 0) {
                player.hp = 0;
                return_to_village(0);
            }

            // Coleta do Orbe da Essencia
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

            // Portal de Retorno a Vila (ao tocar no topo)
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
                hero_pal = 4; // Pisca em branco
            }
            if (player.def_timer > 0 && player.def_mode == DEF_STEALTH && (player.def_timer & 4)) {
                // Invisivel pisca
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

        // CENARIO 1: A VILA (Hub Seguro)
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

            // Oculta Masmorra
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
            // Oculta todos os outros sprites
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
        // CENARIO 3: MASMORRA (Sala 1 de Mobs + Bau)
        else if (current_state == STATE_DUNGEON_CHAMBER || current_state == STATE_CHEST_OPEN) {
            // Oculta Vila e Chefe
            oamSet(OAM_DUMMY,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL0,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL1,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL2,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PEDESTAL3,   0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ALTAR,       0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_PORTAL,      0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_BOSS,        0, 240, 0, 0, 0, 0, 0);
            oamSet(OAM_ESSENCE,     0, 240, 0, 0, 0, 0, 0);

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
        // CENARIO 4: CAMARA DO CHEFE (General da Agua)
        else if (current_state == STATE_BOSS_CHAMBER) {
            // Oculta Vila, Slimes e Bau
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

            // General da Agua (Chefe)
            if (boss.is_alive) {
                u8 boss_pal = 7;
                u8 boss_hflip = (boss.dir_x < 0) ? 1 : 0;
                if (boss.hit_flash > 0 || boss.state == 2) boss_pal = 4; // Flash ou Vulneravel
                oamSet(OAM_BOSS, boss.x, boss.y, 3, boss_hflip, 0, SPR_BOSS_ENEMY, boss_pal);
            } else {
                oamSet(OAM_BOSS, 0, 240, 0, 0, 0, 0, 0);
            }

            // Projetil do Chefe
            if (enemy_proj1.is_active) {
                oamSet(OAM_ENEMY_PROJ1, enemy_proj1.x, enemy_proj1.y, 3, 0, 0, SPR_PROJECTILE, 5);
            } else {
                oamSet(OAM_ENEMY_PROJ1, 0, 240, 0, 0, 0, 0, 0);
            }
            oamSet(OAM_ENEMY_PROJ2, 0, 240, 0, 0, 0, 0, 0);

            // Orbe da Essencia
            if (essence_spawned && !essence_collected) {
                oamSet(OAM_ESSENCE, 120, 110, 3, 0, 0, SPR_ESSENCE, 0);
            } else {
                oamSet(OAM_ESSENCE, 0, 240, 0, 0, 0, 0, 0);
            }

            // Portal de Retorno
            if (boss_portal_open) {
                oamSet(OAM_PORTAL, 120, 35, 3, 0, 0, SPR_PORTAL, 0);
            } else {
                oamSet(OAM_PORTAL, 0, 240, 0, 0, 0, 0, 0);
            }
        }

        // Atualizacao do HUD apenas quando dirty (60 FPS fluidos)
        if (hud_dirty) {
            draw_hud();
            hud_dirty = 0;
        }

        WaitForVBlank();
    }

    return 0;
}
