.include "hdr.asm"
.accu 16
.index 16
.16bit
.define __get_hp_bar_locals 8
.define __clear_dialogue_box_locals 1
.define __clear_screen_text_locals 1
.define __check_village_interactions_locals 14
.define __draw_hud_locals 28
.define __main_locals 54

.SECTION ".init_playertext_0x0" SUPERFREE

init_player:
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 0
lda.w #110
sta.w tccs_{WLA_FILENAME}_player + 2
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 6
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 8
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 12
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 17
rep #$20
rtl
.ENDS

.SECTION ".init_custom_palettestext_0x1" SUPERFREE

init_custom_palettes:
pea.w 32
pea.w 128
pea.w :sprites_pal
pea.w sprites_pal + 0
jsr.l dmaCopyCGram
tsa
clc
adc #8
tas
pea.w 32
pea.w 144
pea.w :sprites_pal
pea.w sprites_pal + 0
jsr.l dmaCopyCGram
tsa
clc
adc #8
tas
pea.w 32
pea.w 160
pea.w :sprites_pal
pea.w sprites_pal + 0
jsr.l dmaCopyCGram
tsa
clc
adc #8
tas
pea.w 32
pea.w 176
pea.w :sprites_pal
pea.w sprites_pal + 0
jsr.l dmaCopyCGram
tsa
clc
adc #8
tas
pea.w 32
pea.w 192
pea.w :sprites_pal
pea.w sprites_pal + 0
jsr.l dmaCopyCGram
tsa
clc
adc #8
tas
lda.w #147
sep #$20
sta.l 8481
rep #$20
lda.w #222
sep #$20
sta.l 8482
rep #$20
lda.w #9
sep #$20
sta.l 8482
rep #$20
lda.w #148
sep #$20
sta.l 8481
rep #$20
lda.w #95
sep #$20
sta.l 8482
rep #$20
lda.w #35
sep #$20
sta.l 8482
rep #$20
lda.w #163
sep #$20
sta.l 8481
rep #$20
lda.w #196
sep #$20
sta.l 8482
rep #$20
lda.w #42
sep #$20
sta.l 8482
rep #$20
lda.w #164
sep #$20
sta.l 8481
rep #$20
lda.w #206
sep #$20
sta.l 8482
rep #$20
lda.w #67
sep #$20
sta.l 8482
rep #$20
lda.w #179
sep #$20
sta.l 8481
rep #$20
lda.w #173
sep #$20
sta.l 8482
rep #$20
lda.w #61
sep #$20
sta.l 8482
rep #$20
lda.w #180
sep #$20
sta.l 8481
rep #$20
lda.w #23
sep #$20
sta.l 8482
rep #$20
lda.w #107
sep #$20
sta.l 8482
rep #$20
lda.w #195
sep #$20
sta.l 8481
rep #$20
lda.w #255
sep #$20
sta.l 8482
rep #$20
lda.w #127
sep #$20
sta.l 8482
rep #$20
lda.w #196
sep #$20
sta.l 8481
rep #$20
lda.w #255
sep #$20
sta.l 8482
rep #$20
lda.w #127
sep #$20
sta.l 8482
rep #$20
lda.w #200
sep #$20
sta.l 8481
rep #$20
lda.w #255
sep #$20
sta.l 8482
rep #$20
lda.w #127
sep #$20
sta.l 8482
rep #$20
lda.w #202
sep #$20
sta.l 8481
rep #$20
lda.w #255
sep #$20
sta.l 8482
rep #$20
lda.w #127
sep #$20
sta.l 8482
rep #$20
lda.w #203
sep #$20
sta.l 8481
rep #$20
lda.w #255
sep #$20
sta.l 8482
rep #$20
lda.w #127
sep #$20
sta.l 8482
rep #$20
lda.w #206
sep #$20
sta.l 8481
rep #$20
lda.w #255
sep #$20
sta.l 8482
rep #$20
lda.w #127
sta.b tcc__r0
sep #$20
sta.l 8482
rep #$20
rtl
.ENDS

.SECTION ".get_hp_bartext_0x2" SUPERFREE

get_hp_bar:
.ifgr __get_hp_bar_locals 0
tsa
sec
sbc #__get_hp_bar_locals
tas
.endif
lda.w #0
sep #$20
sta -1 + __get_hp_bar_locals + 1,s
rep #$20
lda 7 + __get_hp_bar_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_0
+
lda 9 + __get_hp_bar_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_0:
brl __local_1
+
lda 7 + __get_hp_bar_locals + 1,s
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
lda.b tcc__r1
ldy.w #15
-
cmp #$8000
ror a
dey
bne -
+
sta.b tcc__r1
lda.w #0
sep #$20
lda 11 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r2
sta.b tcc__r3
lda.b tcc__r2h
sta.b tcc__r3h
lda.b tcc__r3
ldy.w #15
-
cmp #$8000
ror a
dey
bne -
+
sta.b tcc__r3
lda.b tcc__r0
sta.b tcc__r9
stz.b tcc__r9h
lda.b tcc__r2
sta.b tcc__r10
stz.b tcc__r10h
jsr.l tcc__mull
stx.b tcc__r4
sty.b tcc__r5
lda.b tcc__r3
sta.b tcc__r9
lda.b tcc__r0
sta.b tcc__r10
jsr.l tcc__mul
sta.b tcc__r0
lda.b tcc__r2
sta.b tcc__r9
lda.b tcc__r1
sta.b tcc__r10
jsr.l tcc__mul
clc
adc.b tcc__r0
clc
adc.b tcc__r4
sta.b tcc__r4
lda 9 + __get_hp_bar_locals + 1,s
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
lda.b tcc__r1
ldy.w #15
-
cmp #$8000
ror a
dey
bne -
+
sta.b tcc__r1
pha
pei (tcc__r0)
pei (tcc__r4)
pei (tcc__r5)
jsr.l tcc__divdi3
tsa
clc
adc #8
tas
lda.w #255
sta.b tcc__r2
stz.b tcc__r3
lda.b tcc__r0
and.b tcc__r2
sta.b tcc__r0
lda.b tcc__r1
and.b tcc__r3
sta.b tcc__r1
sep #$20
lda.b tcc__r0
sta -1 + __get_hp_bar_locals + 1,s
rep #$20
__local_1:
lda.w #0
sep #$20
lda -1 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda 11 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_2
+
lda.w #0
sep #$20
lda 11 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
sep #$20
sta -1 + __get_hp_bar_locals + 1,s
rep #$20
__local_2:
lda.w #0
sta.b tcc__r0
sep #$20
sta -2 + __get_hp_bar_locals + 1,s
rep #$20
__local_5:
lda.w #0
sep #$20
lda -2 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda 11 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_3
+
bra __local_4
__local_9:
lda.w #0
sep #$20
lda -2 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta -2 + __get_hp_bar_locals + 1,s
rep #$20
jmp.w __local_5
__local_4:
lda.w #0
sep #$20
lda -2 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
lda 3 + __get_hp_bar_locals + 1,s
sta.b tcc__r1
lda 5 + __get_hp_bar_locals + 1,s
sta.b tcc__r1h
clc
lda.b tcc__r1
adc.b tcc__r0
sta.b tcc__r1
lda.w #0
sep #$20
lda -2 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #0
sep #$20
lda -1 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r2
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r2
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
lda.b tcc__r1
sta -8 + __get_hp_bar_locals + 1,s
lda.b tcc__r1h
sta -6 + __get_hp_bar_locals + 1,s
lda.b tcc__r5 ; DON'T OPTIMIZE
bne +
brl __local_6
+
bra __local_7
__local_6:
lda.w #45
sta.b tcc__r0
bra __local_8
__local_7:
lda.w #61
sta.b tcc__r0
__local_8:
lda -8 + __get_hp_bar_locals + 1,s
sta.b tcc__r1
lda -6 + __get_hp_bar_locals + 1,s
sta.b tcc__r1h
sep #$20
lda.b tcc__r0
sta.b [tcc__r1]
rep #$20
jmp.w __local_9
__local_3:
lda.w #0
sep #$20
lda 11 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
lda 3 + __get_hp_bar_locals + 1,s
sta.b tcc__r1
lda 5 + __get_hp_bar_locals + 1,s
sta.b tcc__r1h
clc
lda.b tcc__r1
adc.b tcc__r0
sta.b tcc__r1
lda.w #0
sta.b tcc__r0
sep #$20
sta.b [tcc__r1]
rep #$20
.ifgr __get_hp_bar_locals 0
tsa
clc
adc #__get_hp_bar_locals
tas
.endif
rtl
.ENDS

.SECTION ".clear_dialogue_boxtext_0x3" SUPERFREE

clear_dialogue_box:
.ifgr __clear_dialogue_box_locals 0
tsa
sec
sbc #__clear_dialogue_box_locals
tas
.endif
lda.w #18
sta.b tcc__r0
sep #$20
sta -1 + __clear_dialogue_box_locals + 1,s
rep #$20
__local_12:
lda.w #0
sep #$20
lda -1 + __clear_dialogue_box_locals + 1,s
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #26
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_10
+
bra __local_11
__local_13:
lda.w #0
sep #$20
lda -1 + __clear_dialogue_box_locals + 1,s
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta -1 + __clear_dialogue_box_locals + 1,s
rep #$20
jmp.w __local_12
__local_11:
lda.w #0
sep #$20
lda -1 + __clear_dialogue_box_locals + 1,s
rep #$20
sta.b tcc__r0
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45 + 0
pei (tcc__r0)
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_13
__local_10:
.ifgr __clear_dialogue_box_locals 0
tsa
clc
adc #__clear_dialogue_box_locals
tas
.endif
rtl
.ENDS

.SECTION ".clear_screen_texttext_0x4" SUPERFREE

clear_screen_text:
.ifgr __clear_screen_text_locals 0
tsa
sec
sbc #__clear_screen_text_locals
tas
.endif
lda.w #0
sta.b tcc__r0
sep #$20
sta -1 + __clear_screen_text_locals + 1,s
rep #$20
__local_16:
lda.w #0
sep #$20
lda -1 + __clear_screen_text_locals + 1,s
rep #$20
sta.b tcc__r0
sec
sbc.w #28
bvc +
eor #$8000
+
bmi +
brl __local_14
+
bra __local_15
__local_17:
lda.w #0
sep #$20
lda -1 + __clear_screen_text_locals + 1,s
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta -1 + __clear_screen_text_locals + 1,s
rep #$20
bra __local_16
__local_15:
lda.w #0
sep #$20
lda -1 + __clear_screen_text_locals + 1,s
rep #$20
sta.b tcc__r0
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46 + 0
pei (tcc__r0)
pea.w 0
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_17
__local_14:
.ifgr __clear_screen_text_locals 0
tsa
clc
adc #__clear_screen_text_locals
tas
.endif
rtl
.ENDS

.SECTION ".check_village_interactionstext_0x5" SUPERFREE

check_village_interactions:
.ifgr __check_village_interactions_locals 0
tsa
sec
sbc #__check_village_interactions_locals
tas
.endif
lda.w #0
sta.b tcc__r0
sep #$20
sta -1 + __check_village_interactions_locals + 1,s
rep #$20
__local_20:
lda.w #0
sep #$20
lda -1 + __check_village_interactions_locals + 1,s
rep #$20
sta.b tcc__r0
sec
sbc.w #4
bvc +
eor #$8000
+
bmi +
brl __local_18
+
bra __local_19
__local_26:
lda.w #0
sep #$20
lda -1 + __check_village_interactions_locals + 1,s
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta -1 + __check_village_interactions_locals + 1,s
rep #$20
bra __local_20
__local_19:
lda.w #0
sep #$20
lda -1 + __check_village_interactions_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #24
sta.b tcc__r9
lda.b tcc__r0
sta.b tcc__r10
jsr.l tcc__mul
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_npcs
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_npcs + 0
clc
adc.b tcc__r0
sta.b tcc__r1
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.b [tcc__r1]
sta.b tcc__r2
sec
lda.b tcc__r0
sbc.b tcc__r2
sta -4 + __check_village_interactions_locals + 1,s
lda.w #0
sep #$20
lda -1 + __check_village_interactions_locals + 1,s
rep #$20
sta.b tcc__r0
lda.w #24
sta.b tcc__r9
lda.b tcc__r0
sta.b tcc__r10
jsr.l tcc__mul
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_npcs
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_npcs + 0
clc
adc.b tcc__r0
inc a
inc a
sta.b tcc__r1
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.b [tcc__r1]
sta.b tcc__r2
sec
lda.b tcc__r0
sbc.b tcc__r2
sta -6 + __check_village_interactions_locals + 1,s
lda -4 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_21
+
stz.b tcc__r0
lda -4 + __check_village_interactions_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -4 + __check_village_interactions_locals + 1,s
__local_21:
lda -6 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_22
+
stz.b tcc__r0
lda -6 + __check_village_interactions_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -6 + __check_village_interactions_locals + 1,s
__local_22:
lda -4 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #22
bvc +
eor #$8000
+
bmi +
brl __local_23
+
lda -6 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #22
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_23:
brl __local_24
+
lda.w #0
sep #$20
lda -1 + __check_village_interactions_locals + 1,s
sta.l tccs_{WLA_FILENAME}_selected_npc + 0
rep #$20
lda.w #1
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jmp.w __local_25
__local_24:
jmp.w __local_26
__local_18:
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #120
sta -8 + __check_village_interactions_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #70
sta -10 + __check_village_interactions_locals + 1,s
lda -8 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_27
+
stz.b tcc__r0
lda -8 + __check_village_interactions_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -8 + __check_village_interactions_locals + 1,s
__local_27:
lda -10 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_28
+
stz.b tcc__r0
lda -10 + __check_village_interactions_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -10 + __check_village_interactions_locals + 1,s
__local_28:
lda -8 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #22
bvc +
eor #$8000
+
bmi +
brl __local_29
+
lda -10 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #22
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_29:
brl __local_30
+
lda.w #3
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jmp.w __local_31
__local_30:
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #120
sta -12 + __check_village_interactions_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #35
sta -14 + __check_village_interactions_locals + 1,s
lda -12 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_32
+
stz.b tcc__r0
lda -12 + __check_village_interactions_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -12 + __check_village_interactions_locals + 1,s
__local_32:
lda -14 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_33
+
stz.b tcc__r0
lda -14 + __check_village_interactions_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -14 + __check_village_interactions_locals + 1,s
__local_33:
lda -12 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
sec
sbc.w #24
bvc +
eor #$8000
+
bmi +
brl __local_34
+
lda -14 + __check_village_interactions_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #24
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_34:
brl __local_35
+
lda.w #2
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_35:
__local_25:
__local_31:
__local_36:
.ifgr __check_village_interactions_locals 0
tsa
clc
adc #__check_village_interactions_locals
tas
.endif
rtl
.ENDS

.SECTION ".enter_dungeontext_0x6" SUPERFREE

enter_dungeon:
sep #$20
lda #1
pha
rep #$20
jsr.l setFadeEffect
tsa
clc
adc #1
tas
jsr.l WaitForVBlank
jsr.l clear_screen_text
lda.w #4
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 0
lda.w #180
sta.w tccs_{WLA_FILENAME}_player + 2
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 12
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #120
sta.w tccs_{WLA_FILENAME}_boss + 0
lda.w #65
sta.w tccs_{WLA_FILENAME}_boss + 2
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 5
rep #$20
lda.w #300
sta.w tccs_{WLA_FILENAME}_boss + 8
lda.w #300
sta.w tccs_{WLA_FILENAME}_boss + 6
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
lda.w #60
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
lda.w #55
sta.w tccs_{WLA_FILENAME}_slime1 + 0
lda.w #120
sta.w tccs_{WLA_FILENAME}_slime1 + 2
lda.w #50
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 4
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 5
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
lda.w #185
sta.w tccs_{WLA_FILENAME}_slime2 + 0
lda.w #120
sta.w tccs_{WLA_FILENAME}_slime2 + 2
lda.w #50
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 4
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 5
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_proj + 6
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_proj + 0
lda.w #240
sta.w tccs_{WLA_FILENAME}_proj + 2
lda.w #0
sep #$20
sta.l tccs_{WLA_FILENAME}_essence_spawned + 0
rep #$20
lda.w #0
sep #$20
sta.l tccs_{WLA_FILENAME}_essence_collected + 0
rep #$20
lda.w #0
sep #$20
sta.l tccs_{WLA_FILENAME}_dungeon_portal_open + 0
rep #$20
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jsr.l WaitForVBlank
sep #$20
lda #2
pha
rep #$20
jsr.l setFadeEffect
tsa
clc
adc #1
tas
rtl
.ENDS

.SECTION ".return_to_villagetext_0x7" SUPERFREE

return_to_village:
sep #$20
lda #1
pha
rep #$20
jsr.l setFadeEffect
tsa
clc
adc #1
tas
jsr.l WaitForVBlank
jsr.l clear_screen_text
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 0
lda.w #65
sta.w tccs_{WLA_FILENAME}_player + 2
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 12
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jsr.l WaitForVBlank
sep #$20
lda #2
pha
rep #$20
jsr.l setFadeEffect
tsa
clc
adc #1
tas
lda.w #0
sep #$20
lda 3 + 1,s
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_37
+
lda.w #5
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_37:
rtl
.ENDS

.SECTION ".draw_hudtext_0x8" SUPERFREE

draw_hud:
.ifgr __draw_hud_locals 0
tsa
sec
sbc #__draw_hud_locals
tas
.endif
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #0
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
brl __local_38
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #1
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_38:
brl __local_39
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #2
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_39:
brl __local_40
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #3
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_40:
brl __local_41
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #5
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_41:
brl __local_42
+
jmp.w __local_43
__local_42:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47 + 0
pea.w 1
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48 + 0
pea.w 2
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 6
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_names
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_names + 0
clc
adc.b tcc__r0
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w 2
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49 + 0
pea.w 3
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 6
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_weapons
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_weapons + 0
clc
adc.b tcc__r0
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w 3
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
sep #$20
lda #8
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 12
pha
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-7 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
jsr.l get_hp_bar
tsa
clc
adc #9
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 17
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-9 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #15
tas
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #0
beq +
brl __local_44
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_45
__local_44:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #1
beq +
brl __local_46
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_selected_npc + 0
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #4
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_46:
brl __local_47
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_selected_npc + 0
rep #$20
sta.b tcc__r0
lda.w #24
sta.b tcc__r9
lda.b tcc__r0
sta.b tcc__r10
jsr.l tcc__mul
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_npcs
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_npcs + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta -28 + __draw_hud_locals + 1,s
lda.b tcc__r1h
sta -26 + __draw_hud_locals + 1,s
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -28 + __draw_hud_locals + 1,s
sta.b tcc__r0
lda -26 + __draw_hud_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #4
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -28 + __draw_hud_locals + 1,s
sta.b tcc__r0
lda -26 + __draw_hud_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #8
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 19
pea.w 22
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -28 + __draw_hud_locals + 1,s
sta.b tcc__r0
lda -26 + __draw_hud_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #12
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -28 + __draw_hud_locals + 1,s
sta.b tcc__r0
lda -26 + __draw_hud_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #16
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda -28 + __draw_hud_locals + 1,s
sta.b tcc__r0
lda -26 + __draw_hud_locals + 1,s
sta.b tcc__r0h
clc
lda.b tcc__r0
adc.w #20
sta.b tcc__r0
ldy #0
lda.b [tcc__r0],y
sta.b tcc__r1
iny
iny
lda.b [tcc__r0],y
pha
pei (tcc__r1)
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_48
__local_47:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #2
beq +
brl __local_49
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58 + 0
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62 + 0
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63 + 0
pea.w 24
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_50
__local_49:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #3
beq +
brl __local_51
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}67
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}67 + 0
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}68
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}68 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 17
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #1
tay
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_52
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}69
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}69 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_53
__local_52:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}70
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}70 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_53:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 17
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #2
tay
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_54
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}71
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}71 + 0
pea.w 21
pea.w 14
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_54:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 17
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #3
tay
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_55
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}72
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}72 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_56
__local_55:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}73
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}73 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_56:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 17
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #4
tay
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_57
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}74
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}74 + 0
pea.w 22
pea.w 14
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_57:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}75
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}75 + 0
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}76
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}76 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}77
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}77 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_58
__local_51:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #5
beq +
brl __local_59
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}78
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}78 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}79
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}79 + 0
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}80
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}80 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}81
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}81 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}82
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}82 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}83
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}83 + 0
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}84
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}84 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}85
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}85 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_59:
__local_58:
__local_50:
__local_48:
__local_45:
jmp.w __local_60
__local_43:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #4
beq +
brl __local_61
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}86
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}86 + 0
pea.w 1
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}87
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}87 + 0
pea.w 2
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 6
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_names
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_names + 0
clc
adc.b tcc__r0
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w 2
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
sep #$20
lda #8
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 12
pha
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-7 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
jsr.l get_hp_bar
tsa
clc
adc #9
tas
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-10 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}88
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}88 + 0
pea.w 3
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #14
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_62
+
sep #$20
lda #8
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_boss + 8
pha
lda.w tccs_{WLA_FILENAME}_boss + 6
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-19 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
jsr.l get_hp_bar
tsa
clc
adc #9
tas
lda.w tccs_{WLA_FILENAME}_boss + 8
pha
lda.w tccs_{WLA_FILENAME}_boss + 6
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-20 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}89
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}89 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #16
tas
bra __local_63
__local_62:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}90
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}90 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_63:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}91
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}91 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dungeon_portal_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_64
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}92
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}92 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_65
__local_64:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}93
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}93 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_65:
__local_61:
__local_60:
.ifgr __draw_hud_locals 0
tsa
clc
adc #__draw_hud_locals
tas
.endif
rtl
.ENDS

.SECTION ".maintext_0x9" SUPERFREE

main:
.ifgr __main_locals 0
tsa
sec
sbc #__main_locals
tas
.endif
jsr.l dmaClearVram
sep #$20
lda #0
pha
rep #$20
pea.w 0
jsr.l oamClear
tsa
clc
adc #3
tas
sep #$20
lda #0
pha
rep #$20
jsr.l consoleInitDefaultText
tsa
clc
adc #1
tas
pea.w 12288
sep #$20
lda #0
pha
rep #$20
jsr.l bgSetGfxPtr
tsa
clc
adc #3
tas
sep #$20
lda #0
pha
rep #$20
pea.w 26624
sep #$20
lda #0
pha
rep #$20
jsr.l bgSetMapPtr
tsa
clc
adc #4
tas
pea.w (0 * 256 + 1)
sep #$20
rep #$20
jsr.l setMode
pla
sep #$20
lda #1
pha
rep #$20
jsr.l bgSetDisable
tsa
clc
adc #1
tas
sep #$20
lda #2
pha
rep #$20
jsr.l bgSetDisable
tsa
clc
adc #1
tas
lda.w #:sprites_tilend
sta.b tcc__r0h
lda.w #sprites_tilend + 0
sta.b tcc__r0
lda.w #:sprites_til
lda.w #sprites_til + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
lda.w #:sprites_palend
lda.w #sprites_palend + 0
sta.b tcc__r1
lda.w #:sprites_pal
lda.w #sprites_pal + 0
sta.b tcc__r2
sec
lda.b tcc__r1
sbc.b tcc__r2
sta.b tcc__r1
sep #$20
lda #96
pha
rep #$20
pea.w 0
sep #$20
lda #0
pha
rep #$20
pei (tcc__r1)
pea.w :sprites_pal
pea.w sprites_pal + 0
pei (tcc__r0)
pea.w :sprites_til
pea.w sprites_til + 0
jsr.l oamInitGfxSet
tsa
clc
adc #16
tas
jsr.l init_custom_palettes
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 0
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 4
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 8
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 12
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 16
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 20
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 24
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 28
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 32
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 36
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 40
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 44
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 48
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 52
jsr.l oamSetEx
tsa
clc
adc #4
tas
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pea.w 56
jsr.l oamSetEx
tsa
clc
adc #4
tas
jsr.l init_player
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jsr.l setScreenOn
__local_265:
lda.l pad_keys + 0
sta.l tccs_{WLA_FILENAME}_pad_held + 0
lda.l pad_keysdown + 0
sta.l tccs_{WLA_FILENAME}_pad_down + 0
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #0
beq +
brl __local_66
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #2048
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_67
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #36
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_68
+
lda.w tccs_{WLA_FILENAME}_player + 2
dec a
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_68:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_67:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #1024
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_69
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sec
sbc.w #185
bvc +
eor #$8000
+
bmi +
brl __local_70
+
lda.w tccs_{WLA_FILENAME}_player + 2
inc a
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_70:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_69:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #512
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_71
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #16
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_72
+
lda.w tccs_{WLA_FILENAME}_player + 0
dec a
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_72:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_71:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #256
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_73
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
sec
sbc.w #225
bvc +
eor #$8000
+
bmi +
brl __local_74
+
lda.w tccs_{WLA_FILENAME}_player + 0
inc a
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_74:
lda.w #3
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_73:
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #42
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_75
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #110
tay
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_75:
brl __local_76
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #130
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_76:
brl __local_77
+
lda.w #2
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_77:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #64
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_78
+
lda.w tccs_{WLA_FILENAME}_player + 6
sta.b tcc__r0
inc.b tcc__r0
ldx.b tcc__r0
lda.w #4
jsr.l tcc__div
txa
sta.w tccs_{WLA_FILENAME}_player + 6
lda.w tccs_{WLA_FILENAME}_player + 6
sta.w tccs_{WLA_FILENAME}_player + 8
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_78:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #16384
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_79
+
lda.w #12
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #180
sta -2 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #140
sta -4 + __main_locals + 1,s
lda -2 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_80
+
stz.b tcc__r0
lda -2 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -2 + __main_locals + 1,s
__local_80:
lda -4 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_81
+
stz.b tcc__r0
lda -4 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -4 + __main_locals + 1,s
__local_81:
lda -2 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #22
bvc +
eor #$8000
+
bmi +
brl __local_82
+
lda -4 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #22
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_82:
brl __local_83
+
lda.w #10
sep #$20
sta.l tccs_{WLA_FILENAME}_dummy_hit_flash + 0
rep #$20
lda.l tccs_{WLA_FILENAME}_dummy_damage + 0
clc
adc.w #25
sta.l tccs_{WLA_FILENAME}_dummy_damage + 0
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_83:
__local_79:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_84
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
__local_84:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dummy_hit_flash + 0
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_85
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dummy_hit_flash + 0
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.l tccs_{WLA_FILENAME}_dummy_hit_flash + 0
rep #$20
__local_85:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_86
+
jsr.l check_village_interactions
__local_86:
jmp.w __local_87
__local_66:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #2
beq +
brl __local_88
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_89
+
jsr.l enter_dungeon
bra __local_90
__local_89:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_91
+
lda.w #52
sta.w tccs_{WLA_FILENAME}_player + 2
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_91:
__local_90:
jmp.w __local_92
__local_88:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #1
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
brl __local_93
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #3
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_93:
brl __local_94
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #5
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_94:
brl __local_95
+
jmp.w __local_96
__local_95:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
brl __local_97
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
__local_97:
brl __local_98
+
bra __local_99
__local_98:
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #255
sep #$20
sta.l tccs_{WLA_FILENAME}_selected_npc + 0
rep #$20
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_99:
jmp.w __local_100
__local_96:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #4
beq +
brl __local_101
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #2048
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_102
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #45
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_103
+
lda.w tccs_{WLA_FILENAME}_player + 2
dec a
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_103:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_102:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #1024
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_104
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sec
sbc.w #185
bvc +
eor #$8000
+
bmi +
brl __local_105
+
lda.w tccs_{WLA_FILENAME}_player + 2
inc a
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_105:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_104:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #512
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_106
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #20
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_107
+
lda.w tccs_{WLA_FILENAME}_player + 0
dec a
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_107:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_106:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #256
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_108
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
sec
sbc.w #220
bvc +
eor #$8000
+
bmi +
brl __local_109
+
lda.w tccs_{WLA_FILENAME}_player + 0
inc a
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_109:
lda.w #3
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 4
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 16
rep #$20
__local_108:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #64
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_110
+
lda.w tccs_{WLA_FILENAME}_player + 6
sta.b tcc__r0
inc.b tcc__r0
ldx.b tcc__r0
lda.w #4
jsr.l tcc__div
txa
sta.w tccs_{WLA_FILENAME}_player + 6
lda.w tccs_{WLA_FILENAME}_player + 6
sta.w tccs_{WLA_FILENAME}_player + 8
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_110:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #16384
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_111
+
lda.w #12
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 0
sta -6 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta -8 + __main_locals + 1,s
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_112
+
lda -8 + __main_locals + 1,s
clc
adc.w #14
sta.b tcc__r0
sta -8 + __main_locals + 1,s
jmp.w __local_113
__local_112:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_114
+
lda -8 + __main_locals + 1,s
sec
sbc.w #14
sta.b tcc__r0
sta -8 + __main_locals + 1,s
jmp.w __local_115
__local_114:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_116
+
lda -6 + __main_locals + 1,s
sec
sbc.w #14
sta.b tcc__r0
sta -6 + __main_locals + 1,s
bra __local_117
__local_116:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_118
+
lda -6 + __main_locals + 1,s
clc
adc.w #14
sta.b tcc__r0
sta -6 + __main_locals + 1,s
__local_118:
__local_117:
__local_115:
__local_113:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_119
+
lda -6 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -10 + __main_locals + 1,s
lda -8 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -12 + __main_locals + 1,s
lda -10 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_120
+
stz.b tcc__r0
lda -10 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -10 + __main_locals + 1,s
__local_120:
lda -12 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_121
+
stz.b tcc__r0
lda -12 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -12 + __main_locals + 1,s
__local_121:
lda -10 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #20
bvc +
eor #$8000
+
bmi +
brl __local_122
+
lda -12 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #20
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_122:
brl __local_123
+
lda.w tccs_{WLA_FILENAME}_boss + 6
sec
sbc.w #25
sta.w tccs_{WLA_FILENAME}_boss + 6
lda.w #10
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_124
+
bra __local_125
__local_124:
lda.w #6
sta.b tcc__r0
bra __local_126
__local_125:
lda.w #65530
sta.b tcc__r0
__local_126:
lda.w tccs_{WLA_FILENAME}_boss + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_boss + 0
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
lda.w tccs_{WLA_FILENAME}_boss + 6
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_127
+
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_boss + 6
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_essence_spawned + 0
rep #$20
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_dungeon_portal_open + 0
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_127:
__local_123:
__local_119:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_128
+
lda -6 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -14 + __main_locals + 1,s
lda -8 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -16 + __main_locals + 1,s
lda -14 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_129
+
stz.b tcc__r0
lda -14 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -14 + __main_locals + 1,s
__local_129:
lda -16 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_130
+
stz.b tcc__r0
lda -16 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -16 + __main_locals + 1,s
__local_130:
lda -14 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #16
bvc +
eor #$8000
+
bmi +
brl __local_131
+
lda -16 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #16
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_131:
brl __local_132
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sec
sbc.w #25
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 4
rep #$20
lda.w #10
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 5
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_133
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
__local_133:
__local_132:
__local_128:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_134
+
lda -6 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -18 + __main_locals + 1,s
lda -8 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -20 + __main_locals + 1,s
lda -18 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_135
+
stz.b tcc__r0
lda -18 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -18 + __main_locals + 1,s
__local_135:
lda -20 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_136
+
stz.b tcc__r0
lda -20 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -20 + __main_locals + 1,s
__local_136:
lda -18 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #16
bvc +
eor #$8000
+
bmi +
brl __local_137
+
lda -20 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #16
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_137:
brl __local_138
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sec
sbc.w #25
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 4
rep #$20
lda.w #10
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 5
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_139
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
__local_139:
__local_138:
__local_134:
__local_111:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_140
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 14
rep #$20
__local_140:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 15
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_141
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 15
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
__local_141:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_142
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_boss + 0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #195
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_143
+
lda.w #-1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
__local_143:
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r0
sec
sbc.w #45
bvc +
eor #$8000
+
bmi +
brl __local_144
+
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
__local_144:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_145
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
__local_145:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_146
+
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.w tccs_{WLA_FILENAME}_proj + 0
lda.w tccs_{WLA_FILENAME}_boss + 2
clc
adc.w #8
sta.w tccs_{WLA_FILENAME}_proj + 2
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_147
+
bra __local_148
__local_147:
lda.w #65534
sta.b tcc__r0
bra __local_149
__local_148:
lda.w #2
sta.b tcc__r0
__local_149:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_proj + 4
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 2
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_150
+
bra __local_151
__local_150:
lda.w #1
sta.b tcc__r0
bra __local_152
__local_151:
lda.w #2
sta.b tcc__r0
__local_152:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_proj + 5
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_proj + 6
rep #$20
lda.w #90
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
__local_146:
__local_142:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_153
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 5
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_154
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 5
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 5
rep #$20
__local_154:
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_155
+
lda.w tccs_{WLA_FILENAME}_slime1 + 0
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 0
bra __local_156
__local_155:
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_157
+
lda.w tccs_{WLA_FILENAME}_slime1 + 0
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 0
__local_157:
__local_156:
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_158
+
lda.w tccs_{WLA_FILENAME}_slime1 + 2
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 2
bra __local_159
__local_158:
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_160
+
lda.w tccs_{WLA_FILENAME}_slime1 + 2
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 2
__local_160:
__local_159:
__local_153:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_161
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 5
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_162
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 5
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 5
rep #$20
__local_162:
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_163
+
lda.w tccs_{WLA_FILENAME}_slime2 + 0
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 0
bra __local_164
__local_163:
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_165
+
lda.w tccs_{WLA_FILENAME}_slime2 + 0
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 0
__local_165:
__local_164:
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_166
+
lda.w tccs_{WLA_FILENAME}_slime2 + 2
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 2
bra __local_167
__local_166:
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_168
+
lda.w tccs_{WLA_FILENAME}_slime2 + 2
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 2
__local_168:
__local_167:
__local_161:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_proj + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_169
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_proj + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_proj + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_proj + 0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_proj + 5
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_proj + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_proj + 2
lda.w tccs_{WLA_FILENAME}_proj + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #10
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
beq +
brl __local_170
+
lda.w tccs_{WLA_FILENAME}_proj + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #245
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
beq +
__local_170:
brl __local_171
+
lda.w tccs_{WLA_FILENAME}_proj + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #30
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
beq +
__local_171:
brl __local_172
+
lda.w tccs_{WLA_FILENAME}_proj + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #215
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
beq +
__local_172:
brl __local_173
+
bra __local_174
__local_173:
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_proj + 6
rep #$20
__local_174:
__local_169:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 15
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_175
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_176
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -22 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -24 + __main_locals + 1,s
lda -22 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_177
+
stz.b tcc__r0
lda -22 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -22 + __main_locals + 1,s
__local_177:
lda -24 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_178
+
stz.b tcc__r0
lda -24 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -24 + __main_locals + 1,s
__local_178:
lda -22 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #16
bvc +
eor #$8000
+
bmi +
brl __local_179
+
lda -24 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #16
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_179:
brl __local_180
+
lda.w tccs_{WLA_FILENAME}_player + 10
sec
sbc.w #20
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #40
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_180:
__local_176:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_181
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -26 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -28 + __main_locals + 1,s
lda -26 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_182
+
stz.b tcc__r0
lda -26 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -26 + __main_locals + 1,s
__local_182:
lda -28 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_183
+
stz.b tcc__r0
lda -28 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -28 + __main_locals + 1,s
__local_183:
lda -26 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #14
bvc +
eor #$8000
+
bmi +
brl __local_184
+
lda -28 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #14
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_184:
brl __local_185
+
lda.w tccs_{WLA_FILENAME}_player + 10
sec
sbc.w #10
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #30
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_185:
__local_181:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_186
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -30 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -32 + __main_locals + 1,s
lda -30 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_187
+
stz.b tcc__r0
lda -30 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -30 + __main_locals + 1,s
__local_187:
lda -32 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_188
+
stz.b tcc__r0
lda -32 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -32 + __main_locals + 1,s
__local_188:
lda -30 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #14
bvc +
eor #$8000
+
bmi +
brl __local_189
+
lda -32 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #14
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_189:
brl __local_190
+
lda.w tccs_{WLA_FILENAME}_player + 10
sec
sbc.w #10
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #30
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_190:
__local_186:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_proj + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_191
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_proj + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -34 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_proj + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -36 + __main_locals + 1,s
lda -34 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_192
+
stz.b tcc__r0
lda -34 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -34 + __main_locals + 1,s
__local_192:
lda -36 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_193
+
stz.b tcc__r0
lda -36 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -36 + __main_locals + 1,s
__local_193:
lda -34 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #12
bvc +
eor #$8000
+
bmi +
brl __local_194
+
lda -36 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #12
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_194:
brl __local_195
+
lda.w tccs_{WLA_FILENAME}_player + 10
sec
sbc.w #15
sta.w tccs_{WLA_FILENAME}_player + 10
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_proj + 6
rep #$20
lda.w #35
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 15
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_195:
__local_191:
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_196
+
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 10
sep #$20
lda #0
pha
rep #$20
jsr.l return_to_village
tsa
clc
adc #1
tas
__local_196:
__local_175:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_spawned + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_197
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_collected + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_198
+
jmp.w __local_199
__local_198:
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #120
sta -38 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #110
sta -40 + __main_locals + 1,s
lda -38 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_200
+
stz.b tcc__r0
lda -38 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -38 + __main_locals + 1,s
__local_200:
lda -40 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_201
+
stz.b tcc__r0
lda -40 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -40 + __main_locals + 1,s
__local_201:
lda -38 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #18
bvc +
eor #$8000
+
bmi +
brl __local_202
+
lda -40 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #18
tay
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_202:
brl __local_203
+
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_essence_collected + 0
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 17
rep #$20
sta.b tcc__r0
sec
sbc.w #4
bvc +
eor #$8000
+
bmi +
brl __local_204
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 17
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 17
rep #$20
__local_204:
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_203:
__local_197:
__local_199:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dungeon_portal_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_205
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #42
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_206
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #110
tay
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_206:
brl __local_207
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #130
tay
beq +++
bvc +
eor #$8000
+
bmi +++
++
dex
+++
stx.b tcc__r5
txa
bne +
__local_207:
brl __local_208
+
sep #$20
lda #1
pha
rep #$20
jsr.l return_to_village
tsa
clc
adc #1
tas
__local_208:
__local_205:
__local_101:
__local_100:
__local_92:
__local_87:
stz.b tcc__r0
lda.b tcc__r0
sta -42 + __main_locals + 1,s
lda.w #0
sep #$20
sta -43 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_209
+
lda.w #2
sta.b tcc__r0
sta -42 + __main_locals + 1,s
jmp.w __local_210
__local_209:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_211
+
lda.w #4
sta -42 + __main_locals + 1,s
lda.w #1
sta.b tcc__r0
sep #$20
sta -43 + __main_locals + 1,s
rep #$20
bra __local_212
__local_211:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_213
+
lda.w #4
sta -42 + __main_locals + 1,s
lda.w #0
sta.b tcc__r0
sep #$20
sta -43 + __main_locals + 1,s
rep #$20
__local_213:
__local_212:
__local_210:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 15
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_214
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 15
rep #$20
and.w #2
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_214:
brl __local_215
+
bra __local_216
__local_215:
lda.w tccs_{WLA_FILENAME}_player + 6
sta.b tcc__r0
bra __local_217
__local_216:
lda.w #4
sta.b tcc__r0
__local_217:
sep #$20
lda.b tcc__r0
sta -44 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -44 + __main_locals + 1,s
pha
rep #$20
lda -41 + __main_locals + 1,s
pha
sep #$20
lda #0
pha
rep #$20
lda.w #0
sep #$20
lda -39 + __main_locals + 1,s
pha
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 2
pha
lda.w tccs_{WLA_FILENAME}_player + 0
pha
pea.w 0
jsr.l oamSet
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 14
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_218
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta -46 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta -48 + __main_locals + 1,s
lda.w #0
sep #$20
sta -49 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_219
+
lda -48 + __main_locals + 1,s
clc
adc.w #12
sta.b tcc__r0
sta -48 + __main_locals + 1,s
jmp.w __local_220
__local_219:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_221
+
lda -48 + __main_locals + 1,s
sec
sbc.w #12
sta.b tcc__r0
sta -48 + __main_locals + 1,s
jmp.w __local_222
__local_221:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_223
+
lda -46 + __main_locals + 1,s
sec
sbc.w #12
sta -46 + __main_locals + 1,s
lda.w #1
sta.b tcc__r0
sep #$20
sta -49 + __main_locals + 1,s
rep #$20
bra __local_224
__local_223:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 4
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_225
+
lda -46 + __main_locals + 1,s
clc
adc.w #12
sta.b tcc__r0
sta -46 + __main_locals + 1,s
__local_225:
__local_224:
__local_222:
__local_220:
sep #$20
lda #0
pha
rep #$20
pea.w 6
sep #$20
lda #0
pha
rep #$20
lda.w #0
sep #$20
lda -45 + __main_locals + 1,s
pha
lda #3
pha
rep #$20
lda -42 + __main_locals + 1,s
pha
lda -38 + __main_locals + 1,s
pha
pea.w 4
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_226
__local_218:
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 4
jsr.l oamSet
tsa
clc
adc #12
tas
__local_226:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #0
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
brl __local_227
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #1
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_227:
brl __local_228
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #2
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_228:
brl __local_229
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #3
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_229:
brl __local_230
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #5
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_230:
brl __local_231
+
jmp.w __local_232
__local_231:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dummy_hit_flash + 0
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_233
+
bra __local_234
__local_233:
lda.w #0
sta.b tcc__r0
bra __local_235
__local_234:
lda.w #4
sta.b tcc__r0
__local_235:
sep #$20
lda.b tcc__r0
sta -50 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -50 + __main_locals + 1,s
pha
rep #$20
pea.w 10
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 140
pea.w 180
pea.w 8
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 32
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_npcs + 2
pha
lda.l tccs_{WLA_FILENAME}_npcs + 0
pha
pea.w 12
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 34
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_npcs + 26
pha
lda.l tccs_{WLA_FILENAME}_npcs + 24
pha
pea.w 16
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 36
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_npcs + 50
pha
lda.l tccs_{WLA_FILENAME}_npcs + 48
pha
pea.w 20
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 38
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_npcs + 74
pha
lda.l tccs_{WLA_FILENAME}_npcs + 72
pha
pea.w 24
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 40
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 70
pea.w 120
pea.w 28
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 42
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 35
pea.w 120
pea.w 32
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 36
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 40
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 44
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 48
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 52
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 56
jsr.l oamSet
tsa
clc
adc #12
tas
jmp.w __local_236
__local_232:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #4
beq +
brl __local_237
+
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 8
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 12
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 16
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 20
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 24
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 28
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 32
jsr.l oamSet
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_238
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_239
+
bra __local_240
__local_239:
lda.w #0
sta.b tcc__r0
bra __local_241
__local_240:
lda.w #4
sta.b tcc__r0
__local_241:
sep #$20
lda.b tcc__r0
sta -51 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_242
+
bra __local_243
__local_242:
lda.w #0
sta.b tcc__r0
bra __local_244
__local_243:
lda.w #1
sta.b tcc__r0
__local_244:
sep #$20
lda.b tcc__r0
sta -52 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -51 + __main_locals + 1,s
pha
rep #$20
pea.w 8
sep #$20
lda #0
pha
rep #$20
lda.w #0
sep #$20
lda -48 + __main_locals + 1,s
pha
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_boss + 2
pha
lda.w tccs_{WLA_FILENAME}_boss + 0
pha
pea.w 36
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_245
__local_238:
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 36
jsr.l oamSet
tsa
clc
adc #12
tas
__local_245:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_246
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 5
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_247
+
bra __local_248
__local_247:
lda.w #2
sta.b tcc__r0
bra __local_249
__local_248:
lda.w #4
sta.b tcc__r0
__local_249:
sep #$20
lda.b tcc__r0
sta -53 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -53 + __main_locals + 1,s
pha
rep #$20
pea.w 44
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 2
pha
lda.w tccs_{WLA_FILENAME}_slime1 + 0
pha
pea.w 40
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_250
__local_246:
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 40
jsr.l oamSet
tsa
clc
adc #12
tas
__local_250:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_251
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 5
rep #$20
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq ++
bvc +
eor #$8000
+
bpl +++
++
dex
+++
stx.b tcc__r5
txa
bne +
brl __local_252
+
bra __local_253
__local_252:
lda.w #2
sta.b tcc__r0
bra __local_254
__local_253:
lda.w #4
sta.b tcc__r0
__local_254:
sep #$20
lda.b tcc__r0
sta -54 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -54 + __main_locals + 1,s
pha
rep #$20
pea.w 44
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 2
pha
lda.w tccs_{WLA_FILENAME}_slime2 + 0
pha
pea.w 44
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_255
__local_251:
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 44
jsr.l oamSet
tsa
clc
adc #12
tas
__local_255:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_proj + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_256
+
sep #$20
lda #1
pha
rep #$20
pea.w 12
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_proj + 2
pha
lda.w tccs_{WLA_FILENAME}_proj + 0
pha
pea.w 48
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_257
__local_256:
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 48
jsr.l oamSet
tsa
clc
adc #12
tas
__local_257:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_spawned + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_258
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_collected + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_259
+
bra __local_260
__local_259:
sep #$20
lda #0
pha
rep #$20
pea.w 46
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 110
pea.w 120
pea.w 52
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_261
__local_258:
__local_260:
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 52
jsr.l oamSet
tsa
clc
adc #12
tas
__local_261:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dungeon_portal_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_262
+
sep #$20
lda #0
pha
rep #$20
pea.w 42
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 35
pea.w 120
pea.w 56
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_263
__local_262:
sep #$20
lda #0
pha
rep #$20
pea.w 0
pea.w (0 * 256 + 0)
sep #$20
lda #0
pha
rep #$20
pea.w 240
pea.w 0
pea.w 56
jsr.l oamSet
tsa
clc
adc #12
tas
__local_263:
__local_237:
__local_236:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_264
+
jsr.l draw_hud
lda.w #0
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_264:
jsr.l WaitForVBlank
jmp.w __local_265
lda.w #0
sta.b tcc__r0
__local_266:
.ifgr __main_locals 0
tsa
clc
adc #__main_locals
tas
.endif
rtl
.ENDS
.RAMSECTION "ram{WLA_FILENAME}.data" APPENDTO "globram.data"

tccs_{WLA_FILENAME}_selected_npc dsb 2
tccs_{WLA_FILENAME}_pad_held dsb 2
tccs_{WLA_FILENAME}_pad_down dsb 2
tccs_{WLA_FILENAME}_hud_dirty dsb 1
tccs_{WLA_FILENAME}_dummy_hit_flash dsb 1
tccs_{WLA_FILENAME}_dummy_damage dsb 2
tccs_{WLA_FILENAME}_essence_spawned dsb 1
tccs_{WLA_FILENAME}_essence_collected dsb 1
tccs_{WLA_FILENAME}_dungeon_portal_open dsb 4
tccs_{WLA_FILENAME}_class_names dsb 16
tccs_{WLA_FILENAME}_class_weapons dsb 16

.ENDS

.SECTION "{WLA_FILENAME}.data" APPENDTO "glob.data"

.db $ff,$0
.db $0,$0
.db $0,$0
.db $1
.db $0
.db $0,$0
.db $0
.db $0
.db $0,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37 + 0, :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41 + 0, :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44
.ENDS

.SECTION ".rodata" SUPERFREE

tccs_{WLA_FILENAME}_npcs: .db $40,$0,$64,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}17 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}17
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}18 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}18
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}19 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}19
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}20 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}20
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21
.db $b9,$0,$64,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26
.db $32,$0,$a0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31
.db $78,$0,$a5,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}17: .db $41,$6e,$63,$69,$61,$6f,$20,$54,$61,$6e,$75,$6b,$69,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}18: .db $4a,$41,$50,$41,$4f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}19: .db $4f,$20,$6d,$75,$6e,$64,$6f,$20,$72,$65,$73,$70,$69,$72,$61,$76,$61,$20,$65,$6d,$20,$34,$20,$65,$6c,$65,$6d,$65,$6e,$74,$6f,$73,$2e,$2e,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}20: .db $41,$74,$65,$20,$6f,$20,$75,$73,$75,$72,$70,$61,$64,$6f,$72,$20,$61,$72,$72,$61,$6e,$63,$61,$72,$20,$6f,$73,$20,$67,$75,$61,$72,$64,$69,$6f,$65,$73,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21: .db $52,$65,$75,$6e,$69,$6d,$6f,$73,$20,$74,$6f,$64,$61,$20,$61,$20,$6d,$61,$67,$69,$61,$20,$6e,$65,$73,$74,$65,$20,$61,$6c,$74,$61,$72,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22: .db $43,$61,$73,$74,$6f,$72,$20,$43,$6f,$6e,$73,$74,$72,$75,$74,$6f,$72,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23: .db $43,$41,$4e,$41,$44,$41,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24: .db $45,$73,$74,$61,$20,$76,$69,$6c,$61,$20,$65,$20,$6f,$20,$75,$6c,$74,$69,$6d,$6f,$20,$61,$62,$72,$69,$67,$6f,$20,$6e,$61,$20,$70,$6f,$65,$69,$72,$61,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25: .db $41,$20,$61,$67,$75,$61,$20,$64,$6f,$73,$20,$70,$6f,$63,$6f,$73,$20,$65,$73,$74,$61,$20,$71,$75,$61,$73,$65,$20,$6e,$6f,$20,$66,$69,$6d,$2e,$2e,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26: .db $53,$65,$20,$76,$6f,$63,$65,$20,$66,$61,$6c,$68,$61,$72,$2c,$20,$6f,$20,$6d,$75,$6e,$64,$6f,$20,$6d,$6f,$72,$72,$65,$20,$63,$6f,$6d,$20,$61,$20,$67,$65,$6e,$74,$65,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27: .db $42,$69,$73,$61,$6f,$20,$56,$65,$74,$65,$72,$61,$6e,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28: .db $45,$55,$41,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29: .db $4e,$61,$6f,$20,$68,$65,$73,$69,$74,$65,$20,$64,$69,$61,$6e,$74,$65,$20,$64,$6f,$20,$70,$65,$72,$69,$67,$6f,$2c,$20,$6a,$6f,$76,$65,$6d,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30: .db $54,$65,$73,$74,$65,$20,$73,$65,$75,$73,$20,$67,$6f,$6c,$70,$65,$73,$20,$65,$20,$68,$6f,$6e,$72,$65,$20,$6f,$73,$20,$34,$20,$70,$6f,$76,$6f,$73,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31: .db $41,$70,$65,$72,$74,$65,$20,$58,$20,$70,$61,$72,$61,$20,$61,$6c,$74,$65,$72,$6e,$61,$72,$20,$65,$6e,$74,$72,$65,$20,$61,$73,$20,$34,$20,$63,$6c,$61,$73,$73,$65,$73,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32: .db $4f,$72,$6e,$69,$74,$6f,$72,$72,$69,$6e,$63,$6f,$20,$4d,$69,$73,$74,$69,$63,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33: .db $41,$55,$53,$54,$52,$41,$4c,$49,$41,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34: .db $4f,$20,$70,$6f,$72,$74,$61,$6c,$20,$65,$73,$74,$61,$20,$65,$73,$74,$61,$76,$65,$6c,$2e,$2e,$2e,$20,$6d,$61,$73,$20,$65,$20,$75,$6d,$20,$6d,$69,$73,$74,$65,$72,$69,$6f,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35: .db $4e,$65,$6e,$68,$75,$6d,$20,$73,$65,$72,$20,$76,$69,$76,$6f,$20,$63,$72,$75,$7a,$6f,$75,$20,$61,$6e,$74,$65,$73,$20,$64,$65,$20,$76,$6f,$63,$65,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36: .db $56,$6f,$63,$65,$20,$73,$65,$72,$61,$20,$6f,$20,$70,$72,$69,$6d,$65,$69,$72,$6f,$20,$61,$20,$76,$65,$72,$20,$6f,$20,$6f,$75,$74,$72,$6f,$20,$6c,$61,$64,$6f,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37: .db $54,$41,$54,$55,$20,$28,$54,$45,$52,$52,$41,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38: .db $4c,$4f,$42,$4f,$47,$55,$41,$52,$41,$20,$28,$46,$4f,$47,$4f,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39: .db $4c,$41,$47,$41,$52,$54,$4f,$20,$28,$41,$47,$55,$41,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40: .db $55,$52,$55,$54,$41,$55,$20,$28,$56,$45,$4e,$54,$4f,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41: .db $45,$73,$70,$61,$64,$61,$20,$26,$20,$45,$73,$63,$75,$64,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42: .db $43,$61,$6a,$61,$64,$6f,$20,$53,$6f,$6c,$61,$72,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43: .db $41,$72,$63,$6f,$20,$26,$20,$46,$6c,$65,$63,$68,$61,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44: .db $41,$64,$61,$67,$61,$73,$20,$44,$75,$70,$6c,$61,$73,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45: .db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46: .db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47: .db $3d,$3d,$20,$46,$41,$4c,$4c,$45,$4e,$20,$48,$45,$52,$4f,$20,$28,$53,$4e,$45,$53,$20,$31,$36,$2d,$42,$49,$54,$29,$20,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48: .db $43,$4c,$41,$53,$53,$45,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49: .db $41,$52,$4d,$41,$3a,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50: .db $48,$50,$3a,$5b,$25,$73,$5d,$20,$25,$64,$2f,$31,$30,$30,$20,$45,$53,$53,$45,$4e,$43,$49,$41,$3a,$25,$64,$2f,$34,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51: .db $44,$2d,$50,$61,$64,$3a,$41,$6e,$64,$61,$72,$20,$20,$59,$3a,$41,$74,$61,$71,$75,$65,$20,$20,$58,$3a,$43,$6c,$61,$73,$73,$65,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52: .db $41,$3a,$49,$6e,$74,$65,$72,$61,$67,$69,$72,$20,$28,$4e,$50,$43,$2f,$41,$6c,$74,$61,$72,$2f,$50,$6f,$72,$74,$61,$6c,$29,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55: .db $5b,$41,$20,$2f,$20,$42,$5d,$20,$46,$65,$63,$68,$61,$72,$20,$63,$6f,$6e,$76,$65,$72,$73,$61,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58: .db $50,$4f,$52,$54,$41,$4c,$20,$44,$49,$4d,$45,$4e,$53,$49,$4f,$4e,$41,$4c,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60: .db $4f,$20,$70,$6f,$72,$74,$61,$6c,$20,$72,$65,$73,$73,$6f,$61,$20,$63,$6f,$6d,$20,$65,$6e,$65,$72,$67,$69,$61,$2e,$2e,$2e,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61: .db $43,$72,$75,$7a,$61,$72,$65,$6d,$6f,$73,$20,$70,$61,$72,$61,$20,$6f,$20,$6f,$75,$74,$72,$6f,$20,$6c,$61,$64,$6f,$21,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62: .db $45,$6e,$74,$72,$61,$72,$20,$6e,$6f,$20,$54,$65,$6d,$70,$6c,$6f,$20,$64,$6f,$20,$47,$75,$61,$72,$64,$69,$61,$6f,$3f,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64: .db $5b,$41,$5d,$20,$41,$54,$52,$41,$56,$45,$53,$53,$41,$52,$20,$50,$4f,$52,$54,$41,$4c,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65: .db $5b,$42,$5d,$20,$46,$69,$63,$61,$72,$20,$6e,$61,$20,$56,$69,$6c,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}67: .db $41,$4c,$54,$41,$52,$20,$44,$4f,$53,$20,$34,$20,$45,$4c,$45,$4d,$45,$4e,$54,$4f,$53,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}68: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}69: .db $54,$45,$52,$52,$41,$3a,$20,$5b,$4f,$4b,$5d,$20,$20,$46,$4f,$47,$4f,$3a,$20,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}70: .db $54,$45,$52,$52,$41,$3a,$20,$5b,$2d,$2d,$5d,$20,$20,$46,$4f,$47,$4f,$3a,$20,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}71: .db $46,$4f,$47,$4f,$3a,$20,$5b,$4f,$4b,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}72: .db $41,$47,$55,$41,$3a,$20,$20,$5b,$4f,$4b,$5d,$20,$20,$56,$45,$4e,$54,$4f,$3a,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}73: .db $41,$47,$55,$41,$3a,$20,$20,$5b,$2d,$2d,$5d,$20,$20,$56,$45,$4e,$54,$4f,$3a,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}74: .db $56,$45,$4e,$54,$4f,$3a,$5b,$4f,$4b,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}75: .db $52,$65,$73,$74,$61,$75,$72,$65,$20,$6f,$73,$20,$34,$20,$67,$75,$61,$72,$64,$69,$6f,$65,$73,$21,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}76: .db $5b,$41,$20,$2f,$20,$42,$5d,$20,$46,$65,$63,$68,$61,$72,$20,$41,$6c,$74,$61,$72,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}77: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}78: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}79: .db $56,$49,$54,$4f,$52,$49,$41,$21,$20,$45,$53,$53,$45,$4e,$43,$49,$41,$20,$52,$45,$53,$47,$41,$54,$41,$44,$41,$21,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}80: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}81: .db $4f,$20,$47,$75,$61,$72,$64,$69,$61,$6f,$20,$66,$6f,$69,$20,$70,$75,$72,$69,$66,$69,$63,$61,$64,$6f,$21,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}82: .db $41,$20,$6d,$61,$67,$69,$61,$20,$65,$6c,$65,$6d,$65,$6e,$74,$61,$6c,$20,$76,$6f,$6c,$74,$6f,$75,$21,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}83: .db $41,$20,$76,$69,$6c,$61,$20,$63,$65,$6c,$65,$62,$72,$61,$20,$6f,$20,$73,$65,$75,$20,$72,$65,$74,$6f,$72,$6e,$6f,$21,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}84: .db $5b,$41,$20,$2f,$20,$42,$5d,$20,$43,$6f,$6e,$74,$69,$6e,$75,$61,$72,$20,$65,$78,$70,$6c,$6f,$72,$61,$6e,$64,$6f,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}85: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}86: .db $3d,$3d,$20,$54,$45,$4d,$50,$4c,$4f,$20,$45,$4c,$45,$4d,$45,$4e,$54,$41,$4c,$20,$28,$4d,$41,$53,$4d,$4f,$52,$52,$41,$29,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}87: .db $43,$4c,$41,$53,$53,$45,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}88: .db $48,$50,$20,$48,$45,$52,$4f,$49,$3a,$20,$5b,$25,$73,$5d,$20,$25,$64,$2f,$31,$30,$30,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}89: .db $43,$48,$45,$46,$45,$3a,$20,$20,$20,$20,$5b,$25,$73,$5d,$20,$25,$64,$2f,$25,$64,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}90: .db $43,$48,$45,$46,$45,$3a,$20,$5b,$20,$44,$45,$52,$52,$4f,$54,$41,$44,$4f,$21,$20,$5d,$20,$54,$4f,$51,$55,$45,$20,$4f,$52,$42,$45,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}91: .db $44,$2d,$50,$61,$64,$3a,$41,$6e,$64,$61,$72,$20,$20,$59,$3a,$41,$74,$61,$71,$75,$65,$20,$20,$58,$3a,$43,$6c,$61,$73,$73,$65,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}92: .db $50,$4f,$52,$54,$41,$4c,$20,$41,$42,$45,$52,$54,$4f,$21,$20,$54,$6f,$71,$75,$65,$20,$6e,$6f,$20,$74,$6f,$70,$6f,$21,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}93: .db $44,$65,$72,$72,$6f,$74,$65,$20,$6f,$20,$47,$75,$61,$72,$64,$69,$61,$6f,$20,$43,$6f,$72,$72,$6f,$6d,$70,$69,$64,$6f,$21,$20,$0
.ENDS

.RAMSECTION ".bss" BANK $7e SLOT 2
tccs_{WLA_FILENAME}_player dsb 18
tccs_{WLA_FILENAME}_current_state dsb 2
tccs_{WLA_FILENAME}_boss dsb 14
tccs_{WLA_FILENAME}_slime1 dsb 8
tccs_{WLA_FILENAME}_slime2 dsb 8
tccs_{WLA_FILENAME}_proj dsb 8
.ENDS
.SECTION ".rel.rodata" SUPERFREE

.db $4,$0,$0,$0,$1,$12,$0,$0,$8,$0,$0,$0,$1,$13,$0,$0,$c,$0,$0,$0,$1,$14,$0,$0,$10,$0,$0,$0,$1,$15,$0,$0,$14,$0,$0,$0,$1,$16,$0,$0,$1c,$0,$0,$0,$1,$17,$0,$0,$20,$0,$0,$0,$1,$18,$0,$0,$24,$0,$0,$0,$1,$19,$0,$0,$28,$0,$0,$0,$1,$1a,$0,$0,$2c,$0,$0,$0,$1,$1b,$0,$0,$34,$0,$0,$0,$1,$1c,$0,$0,$38,$0,$0,$0,$1,$1d,$0,$0,$3c,$0,$0,$0,$1,$1e,$0,$0,$40,$0,$0,$0,$1,$1f,$0,$0,$44,$0,$0,$0,$1,$20,$0,$0,$4c,$0,$0,$0,$1,$21,$0,$0,$50,$0,$0,$0,$1,$22,$0,$0,$54,$0,$0,$0,$1,$23,$0,$0,$58,$0,$0,$0,$1,$24,$0,$0,$5c,$0,$0,$0,$1,$25,$0,$0
.ENDS

