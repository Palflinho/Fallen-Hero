#ifndef _GAME_H_
#define _GAME_H_

#include <snes.h>

#define SCREEN_W 256
#define SCREEN_H 224

// Game States
typedef enum {
    STATE_VILLAGE = 0,
    STATE_PORTAL_CONFIRM,
    STATE_ALTAR_MENU,
    STATE_TALENTS_MENU,
    STATE_DUNGEON_CHAMBER,
    STATE_CHEST_OPEN,
    STATE_BOSS_CHAMBER,
    STATE_VICTORY
} GameState;

// As 4 Classes Reais do GameMaker
typedef enum {
    CLASS_KNIGHT = 0,    // Cavaleiro (Tatu / Terra): Espada + Bloqueio de Escudo
    CLASS_MAGE = 1,      // Maga (Lobo-Guara / Fogo): Magia a Distancia + Escudo de Mana
    CLASS_ARCHER = 2,    // Arqueiro (Lagarto / Agua): Flecha a Distancia + Rolamento Dash
    CLASS_ASSASSIN = 3   // Assassino (Urutau / Vento): Adagas Rapidas + Invisibilidade
} HeroClass;

// Elements
typedef enum {
    ELEM_TERRA = 0,
    ELEM_FOGO = 1,
    ELEM_AGUA = 2,
    ELEM_VENTO = 3
} ElementType;

// Modos de Defesa
typedef enum {
    DEF_NONE = 0,
    DEF_BLOCK = 1,       // Cavaleiro: Ergue escudo, imune a dano fisico
    DEF_MANA_SHIELD = 2, // Maga: Barreira de mana absorve dano
    DEF_ROLL = 3,        // Arqueiro: Dash rapido com I-frames
    DEF_STEALTH = 4      // Assassino: Invisivel, perde aggro
} DefendMode;

// Estrutura de Talento
typedef struct {
    u8 id;
    const char *name;
    const char *desc;
    u8 stat_type; // 0=HP, 1=Poder, 2=Defesa, 3=Vel, 4=Especial
    s8 stat_val;
} TalentDef;

// Player Structure
typedef struct {
    s16 x;
    s16 y;
    s16 vx;
    s16 vy;
    u8 dir;             // 0=Down, 1=Up, 2=Left, 3=Right
    HeroClass class_id;
    ElementType element;
    s16 hp;
    s16 max_hp;
    s16 power;
    s16 defense;
    u8 move_speed;
    
    // Ataque
    u8 atk_timer;
    u8 atk_cooldown;
    
    // Defesa / Especial
    DefendMode def_mode;
    u16 def_timer;
    u16 def_cooldown;
    
    u8 invuln_timer;
    u8 is_moving;
    u8 essences_rescued; // 0 a 4
    
    // 3 Slots de Talentos
    u8 talent_slots[3];
} Player;

// Pedestal de Classe na Vila (Fiel a obj_village_pedestal)
typedef struct {
    u16 x;
    u16 y;
    HeroClass class_id;
    const char *name;
    const char *role;
} VillagePedestal;

// Bau de Tesouro da Masmorra (Fiel a obj_chest)
typedef struct {
    s16 x;
    s16 y;
    u8 is_spawned;
    u8 is_open;
    u8 rolled_talent_id;
} DungeonChest;

// Chefe: General da Agua (Fase 1 do GDD)
typedef struct {
    s16 x;
    s16 y;
    s8 dir_x;
    s8 dir_y;
    s16 hp;
    s16 max_hp;
    u8 hit_flash;
    u8 shoot_timer;
    u8 slam_timer;
    u8 vuln_timer;      // Janela de vulnerabilidade após slam
    u8 state;           // 0: Movendo/Atirando, 1: Telegraph Slam, 2: Vulneravel
    u8 is_alive;
} BossGeneral;

// Elemental de Gelo (Inimigo a Distancia com Kiting)
typedef struct {
    s16 x;
    s16 y;
    s8 hp;
    u8 hit_flash;
    u8 shoot_timer;
    u8 is_alive;
} ElementalMob;

// Minion Slime
typedef struct {
    s16 x;
    s16 y;
    s8 hp;
    u8 hit_flash;
    u8 is_alive;
} SlimeMob;

// Projeteis
typedef struct {
    s16 x;
    s16 y;
    s8 vx;
    s8 vy;
    s8 damage;
    u8 is_active;
} GameProjectile;

#endif // _GAME_H_
