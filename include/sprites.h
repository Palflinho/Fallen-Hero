#ifndef _SPRITES_H_
#define _SPRITES_H_

#include <snes.h>

extern unsigned char sprites_til, sprites_tilend;
extern unsigned char sprites_pal, sprites_palend;

// ?ndices de Tiles dos Sprites de 16x16 (Linha 1: 0, 2, 4, 6, 8, 10, 12, 14)
#define SPR_HERO_DOWN     0   // Quadrado com olhinhos para baixo
#define SPR_HERO_UP       2   // Quadrado com costas / olhando para cima
#define SPR_HERO_RIGHT    4   // Quadrado com olhinhos para a direita (use hflip para esquerda!)
#define SPR_ATTACK_SLASH  6   // Arco de golpe / corte de espada
#define SPR_BOSS_ENEMY    8   // O Chefe/Monstro do GameMaker: quadrado com olhinhos amea?adores!
#define SPR_TRAINING_DUMMY 10 // Boneco de Treino com alvo bullseye no peito
#define SPR_PROJECTILE    12  // Orbe / flecha
#define SPR_SHIELD        14  // Escudo de defesa

// Linha 2 (Tiles iniciam em 32)
#define SPR_NPC_TANUKI    32  // Morador Tanuki (Jap?o)
#define SPR_NPC_CASTOR    34  // Morador Castor (Canad?)
#define SPR_NPC_BISAO     36  // Morador Bis?o (EUA)
#define SPR_NPC_ORNITOR   38  // Morador Ornitorrinco (Austr?lia)
#define SPR_ALTAR         40  // Altar das Ess?ncias
#define SPR_PORTAL        42  // Portal Dimensional

#endif // _SPRITES_H_
