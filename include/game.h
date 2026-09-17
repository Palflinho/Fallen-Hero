#ifndef _GAME_H_
#define _GAME_H_

#include <snes.h>

#define SCREEN_W 256
#define SCREEN_H 224

// Game States
typedef enum {
    STATE_VILLAGE = 0,
    STATE_DIALOGUE,
    STATE_PORTAL_CONFIRM,
    STATE_ALTAR_MENU,
    STATE_DUNGEON,
    STATE_VICTORY
} GameState;

// Classes (Os 4 Herois)
typedef enum {
    CLASS_TATU = 0,     // Guerreiro / Terra (Armadura pesada, escudo)
    CLASS_GUARA = 1,    // Maga / Fogo (Chamas arcanas)
    CLASS_LAGARTO = 2,  // Arqueiro / Agua (Flechas e agilidade)
    CLASS_URUTAU = 3    // Assassino / Vento (Adagas duplas, furtivo)
} HeroClass;

// Elements
typedef enum {
    ELEM_TERRA = 0,
    ELEM_FOGO = 1,
    ELEM_AGUA = 2,
    ELEM_VENTO = 3
} ElementType;

// Player Structure
typedef struct {
    s16 x;
    s16 y;
    u8 dir;             // 0=Down, 1=Up, 2=Left, 3=Right
    HeroClass class_id;
    ElementType element;
    s16 hp;
    s16 max_hp;
    u8 atk_timer;
    u8 invuln_timer;
    u8 is_moving;
    u8 essences_rescued; // 0 a 4
} Player;

// NPC Structure for Village Storytellers
typedef struct {
    u16 x;
    u16 y;
    const char *name;
    const char *country;
    const char *line1;
    const char *line2;
    const char *line3;
} VillageNPC;

// Boss Structure (O Guardiao Corrompido com Olhinhos Ameacadores)
typedef struct {
    s16 x;
    s16 y;
    s8 dir_x;
    s8 dir_y;
    s16 hp;
    s16 max_hp;
    u8 hit_flash;
    u8 shoot_timer;
    u8 is_alive;
} Boss;

// Minion Structure (Slimes com olhinhos)
typedef struct {
    s16 x;
    s16 y;
    s8 hp;
    u8 hit_flash;
    u8 is_alive;
} Minion;

// Projectile Structure (Disparos magicos)
typedef struct {
    s16 x;
    s16 y;
    s8 vx;
    s8 vy;
    u8 is_active;
} Projectile;

#endif // _GAME_H_
