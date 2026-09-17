.include "hdr.asm"
.accu 16
.index 16
.16bit
.define __get_hp_bar_locals 8
.define __clear_dialogue_box_locals 1
.define __clear_screen_text_locals 1
.define __draw_hud_locals 24
.define __main_locals 138

.SECTION ".apply_class_statstext_0x0" SUPERFREE

apply_class_stats:
lda 3 + 1,s
sta.w tccs_{WLA_FILENAME}_player + 10
lda 3 + 1,s
sta.w tccs_{WLA_FILENAME}_player + 12
lda 3 + 1,s
sta.b tcc__r0
cmp #0
beq +
brl __local_0
+
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 16
lda.w #12
sta.w tccs_{WLA_FILENAME}_player + 18
lda.w #8
sta.w tccs_{WLA_FILENAME}_player + 20
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 22
rep #$20
lda.w #1
sta.w tccs_{WLA_FILENAME}_player + 26
lda.w #2
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 35
rep #$20
jmp.w __local_1
__local_0:
lda 3 + 1,s
sta.b tcc__r0
cmp #1
beq +
brl __local_2
+
lda.w #70
sta.w tccs_{WLA_FILENAME}_player + 16
lda.w #18
sta.w tccs_{WLA_FILENAME}_player + 18
lda.w #3
sta.w tccs_{WLA_FILENAME}_player + 20
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 22
rep #$20
lda.w #2
sta.w tccs_{WLA_FILENAME}_player + 26
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 35
rep #$20
jmp.w __local_3
__local_2:
lda 3 + 1,s
sta.b tcc__r0
cmp #2
beq +
brl __local_4
+
lda.w #80
sta.w tccs_{WLA_FILENAME}_player + 16
lda.w #10
sta.w tccs_{WLA_FILENAME}_player + 18
lda.w #4
sta.w tccs_{WLA_FILENAME}_player + 20
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 22
rep #$20
lda.w #3
sta.w tccs_{WLA_FILENAME}_player + 26
lda.w #3
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 35
rep #$20
bra __local_5
__local_4:
lda.w #60
sta.w tccs_{WLA_FILENAME}_player + 16
lda.w #6
sta.w tccs_{WLA_FILENAME}_player + 18
lda.w #2
sta.w tccs_{WLA_FILENAME}_player + 20
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 22
rep #$20
lda.w #4
sta.w tccs_{WLA_FILENAME}_player + 26
lda.w #7
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 35
rep #$20
__local_5:
__local_3:
__local_1:
lda.w tccs_{WLA_FILENAME}_player + 16
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 14
rtl
.ENDS

.SECTION ".init_playertext_0x1" SUPERFREE

init_player:
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 0
lda.w #80
sta.w tccs_{WLA_FILENAME}_player + 2
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 4
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 6
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 24
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 28
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 34
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 36
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 37
rep #$20
pea.w 0
jsr.l apply_class_stats
pla
rtl
.ENDS

.SECTION ".init_custom_palettestext_0x2" SUPERFREE

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
pea.w 32
pea.w 208
pea.w :sprites_pal
pea.w sprites_pal + 0
jsr.l dmaCopyCGram
tsa
clc
adc #8
tas
pea.w 32
pea.w 224
pea.w :sprites_pal
pea.w sprites_pal + 0
jsr.l dmaCopyCGram
tsa
clc
adc #8
tas
pea.w 32
pea.w 240
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
lda.w #74
sep #$20
sta.l 8482
rep #$20
lda.w #49
sep #$20
sta.l 8482
rep #$20
lda.w #180
sep #$20
sta.l 8481
rep #$20
lda.w #148
sep #$20
sta.l 8482
rep #$20
lda.w #98
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
sep #$20
sta.l 8482
rep #$20
lda.w #211
sep #$20
sta.l 8481
rep #$20
lda.w #133
sep #$20
sta.l 8482
rep #$20
lda.w #126
sep #$20
sta.l 8482
rep #$20
lda.w #212
sep #$20
sta.l 8481
rep #$20
lda.w #143
sep #$20
sta.l 8482
rep #$20
lda.w #127
sep #$20
sta.l 8482
rep #$20
lda.w #227
sep #$20
sta.l 8481
rep #$20
lda.w #220
sep #$20
sta.l 8482
rep #$20
lda.w #18
sep #$20
sta.l 8482
rep #$20
lda.w #228
sep #$20
sta.l 8481
rep #$20
lda.w #159
sep #$20
sta.l 8482
rep #$20
lda.w #51
sep #$20
sta.l 8482
rep #$20
lda.w #243
sep #$20
sta.l 8481
rep #$20
lda.w #156
sep #$20
sta.l 8482
rep #$20
lda.w #16
sep #$20
sta.l 8482
rep #$20
lda.w #244
sep #$20
sta.l 8481
rep #$20
lda.w #95
sep #$20
sta.l 8482
rep #$20
lda.w #41
sta.b tcc__r0
sep #$20
sta.l 8482
rep #$20
rtl
.ENDS

.SECTION ".get_hp_bartext_0x3" SUPERFREE

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
brl __local_6
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
__local_6:
brl __local_7
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
__local_7:
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
brl __local_8
+
lda.w #0
sep #$20
lda 11 + __get_hp_bar_locals + 1,s
rep #$20
sta.b tcc__r0
sep #$20
sta -1 + __get_hp_bar_locals + 1,s
rep #$20
__local_8:
lda.w #0
sta.b tcc__r0
sep #$20
sta -2 + __get_hp_bar_locals + 1,s
rep #$20
__local_11:
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
brl __local_9
+
bra __local_10
__local_15:
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
jmp.w __local_11
__local_10:
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
brl __local_12
+
bra __local_13
__local_12:
lda.w #45
sta.b tcc__r0
bra __local_14
__local_13:
lda.w #61
sta.b tcc__r0
__local_14:
lda -8 + __get_hp_bar_locals + 1,s
sta.b tcc__r1
lda -6 + __get_hp_bar_locals + 1,s
sta.b tcc__r1h
sep #$20
lda.b tcc__r0
sta.b [tcc__r1]
rep #$20
jmp.w __local_15
__local_9:
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

.SECTION ".clear_dialogue_boxtext_0x4" SUPERFREE

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
__local_18:
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
brl __local_16
+
bra __local_17
__local_19:
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
jmp.w __local_18
__local_17:
lda.w #0
sep #$20
lda -1 + __clear_dialogue_box_locals + 1,s
rep #$20
sta.b tcc__r0
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53 + 0
pei (tcc__r0)
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_19
__local_16:
.ifgr __clear_dialogue_box_locals 0
tsa
clc
adc #__clear_dialogue_box_locals
tas
.endif
rtl
.ENDS

.SECTION ".clear_screen_texttext_0x5" SUPERFREE

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
__local_22:
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
brl __local_20
+
bra __local_21
__local_23:
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
bra __local_22
__local_21:
lda.w #0
sep #$20
lda -1 + __clear_screen_text_locals + 1,s
rep #$20
sta.b tcc__r0
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54 + 0
pei (tcc__r0)
pea.w 0
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_23
__local_20:
.ifgr __clear_screen_text_locals 0
tsa
clc
adc #__clear_screen_text_locals
tas
.endif
rtl
.ENDS

.SECTION ".enter_dungeon_chambertext_0x6" SUPERFREE

enter_dungeon_chamber:
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
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 28
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #60
sta.w tccs_{WLA_FILENAME}_slime1 + 0
lda.w #95
sta.w tccs_{WLA_FILENAME}_slime1 + 2
lda.w #30
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
lda.w #180
sta.w tccs_{WLA_FILENAME}_slime2 + 0
lda.w #95
sta.w tccs_{WLA_FILENAME}_slime2 + 2
lda.w #30
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
lda.w #120
sta.w tccs_{WLA_FILENAME}_elemental + 0
lda.w #65
sta.w tccs_{WLA_FILENAME}_elemental + 2
lda.w #45
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 4
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 5
rep #$20
lda.w #60
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 6
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
lda.w #120
sta.w tccs_{WLA_FILENAME}_chest + 0
lda.w #110
sta.w tccs_{WLA_FILENAME}_chest + 2
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_chest + 4
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_chest + 5
rep #$20
lda.w #4
sep #$20
sta.w tccs_{WLA_FILENAME}_chest + 6
rep #$20
lda.w #0
sep #$20
sta.l tccs_{WLA_FILENAME}_chamber1_cleared + 0
rep #$20
lda.w #0
sep #$20
sta.l tccs_{WLA_FILENAME}_dungeon_door_open + 0
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player_proj + 0
lda.w #240
sta.w tccs_{WLA_FILENAME}_player_proj + 2
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
lda.w #240
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj2 + 7
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_enemy_proj2 + 0
lda.w #240
sta.w tccs_{WLA_FILENAME}_enemy_proj2 + 2
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

.SECTION ".enter_boss_chambertext_0x7" SUPERFREE

enter_boss_chamber:
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
lda.w #6
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 0
lda.w #180
sta.w tccs_{WLA_FILENAME}_player + 2
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 28
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #120
sta.w tccs_{WLA_FILENAME}_boss + 0
lda.w #60
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
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 13
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 15
rep #$20
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
sta.l tccs_{WLA_FILENAME}_boss_portal_open + 0
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

.SECTION ".return_to_villagetext_0x8" SUPERFREE

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
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 16
sta.w tccs_{WLA_FILENAME}_player + 14
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 28
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
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
brl __local_24
+
lda.w #7
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_24:
rtl
.ENDS

.SECTION ".draw_hudtext_0x9" SUPERFREE

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
brl __local_25
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
__local_25:
brl __local_26
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
__local_26:
brl __local_27
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #7
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_27:
brl __local_28
+
jmp.w __local_29
__local_28:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55 + 0
pea.w 1
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56 + 0
pea.w 2
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 10
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
lda.w tccs_{WLA_FILENAME}_player + 16
pha
lda.w tccs_{WLA_FILENAME}_player + 14
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
lda.w tccs_{WLA_FILENAME}_player + 34
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 16
pha
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-7 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57 + 0
pea.w 3
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #17
tas
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #0
beq +
brl __local_30
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_31
__local_30:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #1
beq +
brl __local_32
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61 + 0
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65 + 0
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66 + 0
pea.w 24
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}67
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}67 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}68
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}68 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_33
__local_32:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #2
beq +
brl __local_34
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}69
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}69 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}70
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}70 + 0
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}71
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}71 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 34
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
brl __local_35
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}72
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}72 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_36
__local_35:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}73
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}73 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_36:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 34
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
brl __local_37
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}74
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}74 + 0
pea.w 21
pea.w 14
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_37:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 34
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
brl __local_38
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}75
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}75 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_39
__local_38:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}76
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}76 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_39:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 34
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
brl __local_40
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}77
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}77 + 0
pea.w 22
pea.w 14
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_40:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}78
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}78 + 0
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}79
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}79 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}80
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}80 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_41
__local_34:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #7
beq +
brl __local_42
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}81
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}81 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}82
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}82 + 0
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}83
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}83 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}84
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}84 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}85
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}85 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}86
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}86 + 0
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}87
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}87 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}88
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}88 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_42:
__local_41:
__local_33:
__local_31:
jmp.w __local_43
__local_29:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #3
beq +
brl __local_44
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}89
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}89 + 0
pea.w 1
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}90
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}90 + 0
pea.w 3
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 10
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
pea.w 3
pea.w 9
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}91
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}91 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 10
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_class_specials
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_class_specials + 0
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
pea.w 4
pea.w 15
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 20
pha
lda.w tccs_{WLA_FILENAME}_player + 18
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}92
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}92 + 0
pea.w 6
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #13
tas
lda.w tccs_{WLA_FILENAME}_player + 16
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}93
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}93 + 0
pea.w 7
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #10
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}94
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}94 + 0
pea.w 9
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 35
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #4
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}95
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}95 + 0
pea.w 11
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 35
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #8
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}96
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}96 + 0
pea.w 12
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 36
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #4
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}97
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}97 + 0
pea.w 14
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 36
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #8
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}98
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}98 + 0
pea.w 15
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 37
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #4
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}99
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}99 + 0
pea.w 17
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 37
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #8
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}100
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}100 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}101
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}101 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}102
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}102 + 0
pea.w 25
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
cmp #4
beq +
brl __local_46
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}103
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}103 + 0
pea.w 1
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}104
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}104 + 0
pea.w 2
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 10
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
lda.w tccs_{WLA_FILENAME}_player + 16
pha
lda.w tccs_{WLA_FILENAME}_player + 14
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
lda.w tccs_{WLA_FILENAME}_player + 16
pha
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-8 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}105
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}105 + 0
pea.w 3
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #16
tas
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_chamber1_cleared + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_47
+
bra __local_48
__local_47:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}106
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}106 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_49
__local_48:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}107
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}107 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_49:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}108
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}108 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dungeon_door_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_50
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}109
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}109 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_51
__local_50:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}110
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}110 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_51:
jmp.w __local_52
__local_46:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #5
beq +
brl __local_53
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}111
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}111 + 0
pea.w 18
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}112
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}112 + 0
pea.w 19
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}113
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}113 + 0
pea.w 20
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_chest + 6
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #4
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}114
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}114 + 0
pea.w 21
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_chest + 6
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_talent_catalog
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_talent_catalog + 0
clc
adc.b tcc__r0
clc
adc.w #8
sta.b tcc__r1
ldy #0
lda.b [tcc__r1],y
sta.b tcc__r0
iny
iny
lda.b [tcc__r1],y
pha
pei (tcc__r0)
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}115
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}115 + 0
pea.w 22
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #12
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}116
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}116 + 0
pea.w 23
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}117
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}117 + 0
pea.w 24
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}118
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}118 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}119
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}119 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
jmp.w __local_54
__local_53:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #6
beq +
brl __local_55
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}120
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}120 + 0
pea.w 1
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}121
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}121 + 0
pea.w 2
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w tccs_{WLA_FILENAME}_player + 10
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
lda.w tccs_{WLA_FILENAME}_player + 16
pha
lda.w tccs_{WLA_FILENAME}_player + 14
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
lda.w tccs_{WLA_FILENAME}_player + 16
pha
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
pha
stz.b tcc__r0h
tsa
clc
adc #(-8 + __draw_hud_locals + 1)
pei (tcc__r0h)
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}122
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}122 + 0
pea.w 3
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #16
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 15
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_56
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
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_57
+
lda.w tccs_{WLA_FILENAME}_boss + 6
pha
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}123
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}123 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #10
tas
bra __local_58
__local_57:
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
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}124
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}124 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #16
tas
__local_58:
bra __local_59
__local_56:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}125
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}125 + 0
pea.w 4
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_59:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}126
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}126 + 0
pea.w 25
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_boss_portal_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_60
+
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}127
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}127 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
bra __local_61
__local_60:
pea.w :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}128
pea.w tccs_{WLA_FILENAME}_L.{WLA_FILENAME}128 + 0
pea.w 26
pea.w 1
jsr.l consoleDrawText
tsa
clc
adc #8
tas
__local_61:
__local_55:
__local_54:
__local_52:
__local_45:
__local_43:
.ifgr __draw_hud_locals 0
tsa
clc
adc #__draw_hud_locals
tas
.endif
rtl
.ENDS

.SECTION ".maintext_0xa" SUPERFREE

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
lda.w #0
sta.b tcc__r0
sep #$20
sta -1 + __main_locals + 1,s
rep #$20
__local_64:
lda.w #0
sep #$20
lda -1 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
sec
sbc.w #19
bvc +
eor #$8000
+
bmi +
brl __local_62
+
bra __local_63
__local_65:
lda.w #0
sep #$20
lda -1 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta -1 + __main_locals + 1,s
rep #$20
bra __local_64
__local_63:
lda.w #0
sep #$20
lda -1 + __main_locals + 1,s
rep #$20
asl a
asl a
sta.b tcc__r0
pea.w (0 * 256 + 0)
sep #$20
rep #$20
pei (tcc__r0)
jsr.l oamSetEx
tsa
clc
adc #4
tas
bra __local_65
__local_62:
jsr.l init_player
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jsr.l setScreenOn
__local_592:
lda.l pad_keys + 0
sta.l tccs_{WLA_FILENAME}_pad_held + 0
lda.l pad_keysdown + 0
sta.l tccs_{WLA_FILENAME}_pad_down + 0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 23
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
brl __local_66
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 23
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
__local_66:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 24
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
brl __local_67
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 24
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 24
rep #$20
__local_67:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_68
+
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
clc
lda.b tcc__r0
adc.w #65535
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 28
__local_68:
lda.w tccs_{WLA_FILENAME}_player + 30
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_69
+
lda.w tccs_{WLA_FILENAME}_player + 30
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
clc
lda.b tcc__r0
adc.w #65535
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
__local_69:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
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
brl __local_70
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
__local_70:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #0
beq +
brl __local_71
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #2048
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_72
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
brl __local_73
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 2
__local_73:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_72:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #1024
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_74
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sec
sbc.w #185
bvc +
eor #$8000
+
bmi +
brl __local_75
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 2
__local_75:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_74:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #512
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_76
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
brl __local_77
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 0
__local_77:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_76:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #256
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_78
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
sec
sbc.w #225
bvc +
eor #$8000
+
bmi +
brl __local_79
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 0
__local_79:
lda.w #3
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_78:
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
brl __local_80
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
__local_80:
brl __local_81
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
__local_81:
brl __local_82
+
lda.w #1
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_82:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #64
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_83
+
lda.w #3
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_screen_text
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_83:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #16384
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_84
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 24
rep #$20
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
bne +
__local_84:
brl __local_85
+
lda.w #12
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
lda.w #18
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 24
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 10
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
brl __local_86
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
__local_86:
brl __local_87
+
jmp.w __local_88
__local_87:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 0
sta.w tccs_{WLA_FILENAME}_player_proj + 0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player_proj + 2
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 18
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 6
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_89
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #4
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
jmp.w __local_90
__local_89:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_91
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #-4
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
jmp.w __local_92
__local_91:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_93
+
lda.w #-4
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
bra __local_94
__local_93:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_95
+
lda.w #4
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
__local_95:
__local_94:
__local_92:
__local_90:
__local_88:
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #120
sta -4 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #165
sta -6 + __main_locals + 1,s
lda -4 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_96
+
stz.b tcc__r0
lda -4 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -4 + __main_locals + 1,s
__local_96:
lda -6 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_97
+
stz.b tcc__r0
lda -6 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -6 + __main_locals + 1,s
__local_97:
lda -4 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #24
bvc +
eor #$8000
+
bmi +
brl __local_98
+
lda -6 + __main_locals + 1,s
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
__local_98:
brl __local_99
+
lda.w #10
sep #$20
sta.l tccs_{WLA_FILENAME}_dummy_hit_flash + 0
rep #$20
lda.l tccs_{WLA_FILENAME}_dummy_damage + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 18
sta.b tcc__r1
clc
adc.b tcc__r0
sta.l tccs_{WLA_FILENAME}_dummy_damage + 0
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_99:
__local_85:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_100
+
lda.w tccs_{WLA_FILENAME}_player + 30
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
bne +
__local_100:
brl __local_101
+
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #1
beq +
brl __local_102
+
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #200
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
jmp.w __local_103
__local_102:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #2
beq +
brl __local_104
+
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #240
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
jmp.w __local_105
__local_104:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #3
beq +
brl __local_106
+
lda.w #15
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #15
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #120
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
bra __local_107
__local_106:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #4
beq +
brl __local_108
+
lda.w #150
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #260
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
__local_108:
__local_107:
__local_105:
__local_103:
__local_101:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_109
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_109:
brl __local_110
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_111
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #185
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
__local_111:
brl __local_112
+
lda.w tccs_{WLA_FILENAME}_player + 2
clc
adc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_112:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_113
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
__local_113:
brl __local_114
+
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_114:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_115
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
__local_115:
brl __local_116
+
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_116:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_117
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #225
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
__local_117:
brl __local_118
+
lda.w tccs_{WLA_FILENAME}_player + 0
clc
adc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_118:
__local_110:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_119
+
lda.w #0
sta.b tcc__r0
sep #$20
sta -7 + __main_locals + 1,s
rep #$20
__local_122:
lda.w #0
sep #$20
lda -7 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
sec
sbc.w #4
bvc +
eor #$8000
+
bmi +
brl __local_120
+
bra __local_121
__local_128:
lda.w #0
sep #$20
lda -7 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta -7 + __main_locals + 1,s
rep #$20
bra __local_122
__local_121:
lda.w #0
sep #$20
lda -7 + __main_locals + 1,s
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_pedestals
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_pedestals + 0
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
sta -10 + __main_locals + 1,s
lda.w #0
sep #$20
lda -7 + __main_locals + 1,s
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_pedestals
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_pedestals + 0
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
sta -12 + __main_locals + 1,s
lda -10 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_123
+
stz.b tcc__r0
lda -10 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -10 + __main_locals + 1,s
__local_123:
lda -12 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_124
+
stz.b tcc__r0
lda -12 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -12 + __main_locals + 1,s
__local_124:
lda -10 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #22
bvc +
eor #$8000
+
bmi +
brl __local_125
+
lda -12 + __main_locals + 1,s
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
__local_125:
brl __local_126
+
lda.w #0
sep #$20
lda -7 + __main_locals + 1,s
rep #$20
asl a
asl a
asl a
asl a
sta.b tcc__r0
lda.w #:tccs_{WLA_FILENAME}_pedestals
sta.b tcc__r1h
lda.w #tccs_{WLA_FILENAME}_pedestals + 0
clc
adc.b tcc__r0
clc
adc.w #4
sta.b tcc__r1
lda.b [tcc__r1]
pha
jsr.l apply_class_stats
pla
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
bra __local_127
__local_126:
jmp.w __local_128
__local_120:
__local_127:
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #120
sta -14 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #75
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
sbc.w #22
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
__local_131:
brl __local_132
+
lda.w #2
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_132:
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #120
sta -18 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #35
sta -20 + __main_locals + 1,s
lda -18 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_133
+
stz.b tcc__r0
lda -18 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -18 + __main_locals + 1,s
__local_133:
lda -20 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_134
+
stz.b tcc__r0
lda -20 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -20 + __main_locals + 1,s
__local_134:
lda -18 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #24
bvc +
eor #$8000
+
bmi +
brl __local_135
+
lda -20 + __main_locals + 1,s
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
__local_135:
brl __local_136
+
lda.w #1
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_136:
__local_119:
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
brl __local_137
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
__local_137:
jmp.w __local_138
__local_71:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #1
beq +
brl __local_139
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_140
+
jsr.l enter_dungeon_chamber
bra __local_141
__local_140:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_142
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
__local_142:
__local_141:
jmp.w __local_143
__local_139:
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
brl __local_144
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #7
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_144:
brl __local_145
+
bra __local_146
__local_145:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
brl __local_147
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
__local_147:
brl __local_148
+
bra __local_149
__local_148:
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_149:
jmp.w __local_150
__local_146:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #3
beq +
brl __local_151
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
brl __local_152
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
__local_152:
brl __local_153
+
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #64
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
beq +
__local_153:
brl __local_154
+
bra __local_155
__local_154:
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_screen_text
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_155:
jmp.w __local_156
__local_151:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #4
beq +
brl __local_157
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #2048
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_158
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
brl __local_159
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 2
__local_159:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_158:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #1024
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_160
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sec
sbc.w #185
bvc +
eor #$8000
+
bmi +
brl __local_161
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 2
__local_161:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_160:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #512
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_162
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #18
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
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 0
__local_163:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_162:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #256
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_164
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
sec
sbc.w #222
bvc +
eor #$8000
+
bmi +
brl __local_165
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 0
__local_165:
lda.w #3
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_164:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_166
+
lda.w tccs_{WLA_FILENAME}_player + 30
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
bne +
__local_166:
brl __local_167
+
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #1
beq +
brl __local_168
+
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #200
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
jmp.w __local_169
__local_168:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #2
beq +
brl __local_170
+
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #240
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
jmp.w __local_171
__local_170:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #3
beq +
brl __local_172
+
lda.w #15
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #15
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #120
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
bra __local_173
__local_172:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #4
beq +
brl __local_174
+
lda.w #150
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #260
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
__local_174:
__local_173:
__local_171:
__local_169:
__local_167:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_175
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_175:
brl __local_176
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_177
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #185
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
__local_177:
brl __local_178
+
lda.w tccs_{WLA_FILENAME}_player + 2
clc
adc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_178:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_179
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
__local_179:
brl __local_180
+
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_180:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_181
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #18
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
__local_181:
brl __local_182
+
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_182:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_183
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #222
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
__local_183:
brl __local_184
+
lda.w tccs_{WLA_FILENAME}_player + 0
clc
adc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_184:
__local_176:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #16384
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_185
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 24
rep #$20
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
bne +
__local_185:
brl __local_186
+
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
cmp #3
beq +
brl __local_187
+
bra __local_188
__local_187:
lda.w #12
sta.b tcc__r0
bra __local_189
__local_188:
lda.w #6
sta.b tcc__r0
__local_189:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
cmp #3
beq +
brl __local_190
+
bra __local_191
__local_190:
lda.w #18
sta.b tcc__r0
bra __local_192
__local_191:
lda.w #10
sta.b tcc__r0
__local_192:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 24
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 10
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
brl __local_193
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
__local_193:
brl __local_194
+
jmp.w __local_195
__local_194:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 0
sta.w tccs_{WLA_FILENAME}_player_proj + 0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player_proj + 2
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 18
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 6
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_196
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #5
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
jmp.w __local_197
__local_196:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_198
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #-5
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
jmp.w __local_199
__local_198:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_200
+
lda.w #-5
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
bra __local_201
__local_200:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_202
+
lda.w #5
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
__local_202:
__local_201:
__local_199:
__local_197:
__local_195:
lda.w tccs_{WLA_FILENAME}_player + 10
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
brl __local_203
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
__local_203:
brl __local_204
+
jmp.w __local_205
__local_204:
lda.w tccs_{WLA_FILENAME}_player + 0
sta -22 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta -24 + __main_locals + 1,s
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_206
+
lda -24 + __main_locals + 1,s
clc
adc.w #14
sta.b tcc__r0
sta -24 + __main_locals + 1,s
__local_206:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_207
+
lda -24 + __main_locals + 1,s
sec
sbc.w #14
sta.b tcc__r0
sta -24 + __main_locals + 1,s
__local_207:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_208
+
lda -22 + __main_locals + 1,s
sec
sbc.w #14
sta.b tcc__r0
sta -22 + __main_locals + 1,s
__local_208:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_209
+
lda -22 + __main_locals + 1,s
clc
adc.w #14
sta.b tcc__r0
sta -22 + __main_locals + 1,s
__local_209:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_210
+
lda -22 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -26 + __main_locals + 1,s
lda -24 + __main_locals + 1,s
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
brl __local_211
+
stz.b tcc__r0
lda -26 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -26 + __main_locals + 1,s
__local_211:
lda -28 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_212
+
stz.b tcc__r0
lda -28 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -28 + __main_locals + 1,s
__local_212:
lda -26 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #16
bvc +
eor #$8000
+
bmi +
brl __local_213
+
lda -28 + __main_locals + 1,s
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
__local_213:
brl __local_214
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
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 18
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 4
rep #$20
lda.w #8
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
brl __local_215
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
__local_215:
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_214:
__local_210:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_216
+
lda -22 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -30 + __main_locals + 1,s
lda -24 + __main_locals + 1,s
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
brl __local_217
+
stz.b tcc__r0
lda -30 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -30 + __main_locals + 1,s
__local_217:
lda -32 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_218
+
stz.b tcc__r0
lda -32 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -32 + __main_locals + 1,s
__local_218:
lda -30 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #16
bvc +
eor #$8000
+
bmi +
brl __local_219
+
lda -32 + __main_locals + 1,s
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
__local_219:
brl __local_220
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
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 18
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 4
rep #$20
lda.w #8
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
brl __local_221
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
__local_221:
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_220:
__local_216:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_222
+
lda -22 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -34 + __main_locals + 1,s
lda -24 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 2
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
brl __local_223
+
stz.b tcc__r0
lda -34 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -34 + __main_locals + 1,s
__local_223:
lda -36 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_224
+
stz.b tcc__r0
lda -36 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -36 + __main_locals + 1,s
__local_224:
lda -34 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #16
bvc +
eor #$8000
+
bmi +
brl __local_225
+
lda -36 + __main_locals + 1,s
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
__local_225:
brl __local_226
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 18
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 4
rep #$20
lda.w #8
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 5
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 4
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
brl __local_227
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
__local_227:
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_226:
__local_222:
__local_205:
__local_186:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_228
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player_proj + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player_proj + 0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player_proj + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player_proj + 2
lda.w tccs_{WLA_FILENAME}_player_proj + 0
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
brl __local_229
+
lda.w tccs_{WLA_FILENAME}_player_proj + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #235
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
__local_229:
brl __local_230
+
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #25
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
__local_230:
brl __local_231
+
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #200
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
__local_231:
brl __local_232
+
bra __local_233
__local_232:
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
__local_233:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_234
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_234:
brl __local_235
+
lda.w tccs_{WLA_FILENAME}_player_proj + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -38 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -40 + __main_locals + 1,s
lda -38 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_236
+
stz.b tcc__r0
lda -38 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -38 + __main_locals + 1,s
__local_236:
lda -40 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_237
+
stz.b tcc__r0
lda -40 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -40 + __main_locals + 1,s
__local_237:
lda -38 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #14
bvc +
eor #$8000
+
bmi +
brl __local_238
+
lda -40 + __main_locals + 1,s
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
__local_238:
brl __local_239
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
sta.b tcc__r0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 6
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 4
rep #$20
lda.w #8
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
brl __local_240
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
__local_240:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_239:
__local_235:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_241
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_241:
brl __local_242
+
lda.w tccs_{WLA_FILENAME}_player_proj + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -42 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -44 + __main_locals + 1,s
lda -42 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_243
+
stz.b tcc__r0
lda -42 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -42 + __main_locals + 1,s
__local_243:
lda -44 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_244
+
stz.b tcc__r0
lda -44 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -44 + __main_locals + 1,s
__local_244:
lda -42 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #14
bvc +
eor #$8000
+
bmi +
brl __local_245
+
lda -44 + __main_locals + 1,s
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
__local_245:
brl __local_246
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
sta.b tcc__r0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 6
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 4
rep #$20
lda.w #8
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
brl __local_247
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
__local_247:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_246:
__local_242:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_248
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_248:
brl __local_249
+
lda.w tccs_{WLA_FILENAME}_player_proj + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -46 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -48 + __main_locals + 1,s
lda -46 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_250
+
stz.b tcc__r0
lda -46 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -46 + __main_locals + 1,s
__local_250:
lda -48 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_251
+
stz.b tcc__r0
lda -48 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -48 + __main_locals + 1,s
__local_251:
lda -46 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #14
bvc +
eor #$8000
+
bmi +
brl __local_252
+
lda -48 + __main_locals + 1,s
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
__local_252:
brl __local_253
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 6
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 4
rep #$20
lda.w #8
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 5
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 4
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
brl __local_254
+
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
__local_254:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_253:
__local_249:
__local_228:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_255
+
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
ldx #1
sec
sbc #4
tay
beq +
dex
+
stx.b tcc__r5
txa
bne +
__local_255:
brl __local_256
+
jmp.w __local_257
__local_256:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_258
+
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_259
+
lda.w tccs_{WLA_FILENAME}_slime1 + 0
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 0
bra __local_260
__local_259:
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
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
brl __local_261
+
lda.w tccs_{WLA_FILENAME}_slime1 + 0
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 0
__local_261:
__local_260:
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_262
+
lda.w tccs_{WLA_FILENAME}_slime1 + 2
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 2
bra __local_263
__local_262:
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
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
brl __local_264
+
lda.w tccs_{WLA_FILENAME}_slime1 + 2
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime1 + 2
__local_264:
__local_263:
__local_258:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_265
+
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_266
+
lda.w tccs_{WLA_FILENAME}_slime2 + 0
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 0
bra __local_267
__local_266:
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
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
brl __local_268
+
lda.w tccs_{WLA_FILENAME}_slime2 + 0
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 0
__local_268:
__local_267:
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_269
+
lda.w tccs_{WLA_FILENAME}_slime2 + 2
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 2
bra __local_270
__local_269:
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
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
brl __local_271
+
lda.w tccs_{WLA_FILENAME}_slime2 + 2
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_slime2 + 2
__local_271:
__local_270:
__local_265:
__local_257:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_272
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -50 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -52 + __main_locals + 1,s
lda -50 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_273
+
stz.b tcc__r0
lda -50 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -50 + __main_locals + 1,s
__local_273:
lda -52 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_274
+
stz.b tcc__r0
lda -52 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -52 + __main_locals + 1,s
__local_274:
lda -50 + __main_locals + 1,s
sta.b tcc__r0
lda -52 + __main_locals + 1,s
sta.b tcc__r1
clc
adc.b tcc__r0
sta -54 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #50
bvc +
eor #$8000
+
bmi +
brl __local_275
+
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_276
+
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #25
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
__local_276:
brl __local_277
+
lda.w tccs_{WLA_FILENAME}_elemental + 0
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_elemental + 0
jmp.w __local_278
__local_277:
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
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
brl __local_279
+
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #215
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
__local_279:
brl __local_280
+
lda.w tccs_{WLA_FILENAME}_elemental + 0
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_elemental + 0
__local_280:
__local_278:
lda.w tccs_{WLA_FILENAME}_elemental + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r1
lda.b tcc__r0
sec
sbc.b tcc__r1
bvc +
eor #$8000
+
bmi +
brl __local_281
+
lda.w tccs_{WLA_FILENAME}_elemental + 2
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
__local_281:
brl __local_282
+
lda.w tccs_{WLA_FILENAME}_elemental + 2
dec a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_elemental + 2
jmp.w __local_283
__local_282:
lda.w tccs_{WLA_FILENAME}_elemental + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
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
brl __local_284
+
lda.w tccs_{WLA_FILENAME}_elemental + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #165
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
__local_284:
brl __local_285
+
lda.w tccs_{WLA_FILENAME}_elemental + 2
inc a
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_elemental + 2
__local_285:
__local_283:
__local_275:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 6
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
brl __local_286
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 6
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_elemental + 6
rep #$20
__local_286:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 6
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_287
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_288
+
jmp.w __local_289
__local_288:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_290
+
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
ldx #1
sec
sbc #4
tay
beq +
dex
+
stx.b tcc__r5
txa
bne +
__local_290:
brl __local_291
+
jmp.w __local_292
__local_291:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
lda.w tccs_{WLA_FILENAME}_elemental + 2
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 0
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
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
brl __local_293
+
bra __local_294
__local_293:
lda.w #65533
sta.b tcc__r0
bra __local_295
__local_294:
lda.w #3
sta.b tcc__r0
__local_295:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 4
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_elemental + 2
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
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
brl __local_296
+
bra __local_297
__local_296:
lda.w #65534
sta.b tcc__r0
bra __local_298
__local_297:
lda.w #2
sta.b tcc__r0
__local_298:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 5
rep #$20
lda.w #12
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 6
rep #$20
lda.w #75
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_elemental + 6
rep #$20
__local_287:
__local_289:
__local_292:
__local_272:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_299
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 5
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
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
brl __local_300
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #235
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
__local_300:
brl __local_301
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #25
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
__local_301:
brl __local_302
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #200
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
__local_302:
brl __local_303
+
bra __local_304
__local_303:
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
__local_304:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_305
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -56 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -58 + __main_locals + 1,s
lda -56 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_306
+
stz.b tcc__r0
lda -56 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -56 + __main_locals + 1,s
__local_306:
lda -58 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_307
+
stz.b tcc__r0
lda -58 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -58 + __main_locals + 1,s
__local_307:
lda -56 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #12
bvc +
eor #$8000
+
bmi +
brl __local_308
+
lda -58 + __main_locals + 1,s
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
__local_308:
brl __local_309
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 6
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta -60 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_310
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_310:
brl __local_311
+
stz.b tcc__r0
lda.b tcc__r0
sta -60 + __main_locals + 1,s
__local_311:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_312
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_312:
brl __local_313
+
lda -60 + __main_locals + 1,s
sta.b tcc__r0
tax
lda.w #2
jsr.l tcc__div
lda.b tcc__r9
sta.b tcc__r0
sta -60 + __main_locals + 1,s
__local_313:
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
lda -60 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 14
lda.w #30
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_309:
__local_305:
__local_299:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_314
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_315
+
lda.w tccs_{WLA_FILENAME}_slime1 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -62 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_slime1 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -64 + __main_locals + 1,s
lda -62 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_316
+
stz.b tcc__r0
lda -62 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -62 + __main_locals + 1,s
__local_316:
lda -64 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_317
+
stz.b tcc__r0
lda -64 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -64 + __main_locals + 1,s
__local_317:
lda -62 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #14
bvc +
eor #$8000
+
bmi +
brl __local_318
+
lda -64 + __main_locals + 1,s
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
__local_318:
brl __local_319
+
lda.w #10
sta -66 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_320
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_320:
brl __local_321
+
stz.b tcc__r0
lda.b tcc__r0
sta -66 + __main_locals + 1,s
__local_321:
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
lda -66 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 14
lda.w #30
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_319:
__local_315:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_322
+
lda.w tccs_{WLA_FILENAME}_slime2 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -68 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_slime2 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -70 + __main_locals + 1,s
lda -68 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_323
+
stz.b tcc__r0
lda -68 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -68 + __main_locals + 1,s
__local_323:
lda -70 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_324
+
stz.b tcc__r0
lda -70 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -70 + __main_locals + 1,s
__local_324:
lda -68 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #14
bvc +
eor #$8000
+
bmi +
brl __local_325
+
lda -70 + __main_locals + 1,s
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
__local_325:
brl __local_326
+
lda.w #10
sta -72 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_327
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_327:
brl __local_328
+
stz.b tcc__r0
lda.b tcc__r0
sta -72 + __main_locals + 1,s
__local_328:
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
lda -72 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 14
lda.w #30
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_326:
__local_322:
__local_314:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_329
+
jmp.w __local_330
__local_329:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_331
+
jmp.w __local_332
__local_331:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_333
+
jmp.w __local_334
__local_333:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_chamber1_cleared + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_335
+
bra __local_336
__local_335:
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_chamber1_cleared + 0
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_chest + 4
rep #$20
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_dungeon_door_open + 0
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_330:
__local_332:
__local_334:
__local_336:
lda.w tccs_{WLA_FILENAME}_player + 14
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
brl __local_337
+
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 14
sep #$20
lda #0
pha
rep #$20
jsr.l return_to_village
tsa
clc
adc #1
tas
__local_337:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_chest + 4
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_338
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_chest + 5
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_339
+
bra __local_340
__local_339:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_338:
__local_340:
brl __local_341
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_chest + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -74 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_chest + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -76 + __main_locals + 1,s
lda -74 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_342
+
stz.b tcc__r0
lda -74 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -74 + __main_locals + 1,s
__local_342:
lda -76 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_343
+
stz.b tcc__r0
lda -76 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -76 + __main_locals + 1,s
__local_343:
lda -74 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #22
bvc +
eor #$8000
+
bmi +
brl __local_344
+
lda -76 + __main_locals + 1,s
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
__local_344:
brl __local_345
+
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_chest + 5
rep #$20
lda.w #5
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_345:
__local_341:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_dungeon_door_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_346
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
__local_346:
brl __local_347
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
__local_347:
brl __local_348
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
__local_348:
brl __local_349
+
jsr.l enter_boss_chamber
__local_349:
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
brl __local_350
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
__local_350:
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
brl __local_351
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
__local_351:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 5
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
brl __local_352
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 5
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_elemental + 5
rep #$20
__local_352:
jmp.w __local_353
__local_157:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #5
beq +
brl __local_354
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_chest + 6
sta -77 + __main_locals + 1,s
rep #$20
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #16384
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_355
+
lda.w #0
sep #$20
lda -77 + __main_locals + 1,s
sta.w tccs_{WLA_FILENAME}_player + 35
rep #$20
lda.w #0
sep #$20
lda -77 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
cmp #4
beq +
brl __local_356
+
lda.w tccs_{WLA_FILENAME}_player + 16
clc
adc.w #30
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 16
__local_356:
lda.w #4
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jmp.w __local_357
__local_355:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #64
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_358
+
lda.w #0
sep #$20
lda -77 + __main_locals + 1,s
sta.w tccs_{WLA_FILENAME}_player + 36
rep #$20
lda.w #0
sep #$20
lda -77 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
cmp #4
beq +
brl __local_359
+
lda.w tccs_{WLA_FILENAME}_player + 16
clc
adc.w #30
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 16
__local_359:
lda.w #4
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jmp.w __local_360
__local_358:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #128
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_361
+
lda.w #0
sep #$20
lda -77 + __main_locals + 1,s
sta.w tccs_{WLA_FILENAME}_player + 37
rep #$20
lda.w #0
sep #$20
lda -77 + __main_locals + 1,s
rep #$20
sta.b tcc__r0
cmp #4
beq +
brl __local_362
+
lda.w tccs_{WLA_FILENAME}_player + 16
clc
adc.w #30
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 16
__local_362:
lda.w #4
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
bra __local_363
__local_361:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_364
+
lda.w #4
sta.w tccs_{WLA_FILENAME}_current_state + 0
jsr.l clear_dialogue_box
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_364:
__local_363:
__local_360:
__local_357:
jmp.w __local_365
__local_354:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #6
beq +
brl __local_366
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #2048
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_367
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
brl __local_368
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 2
__local_368:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_367:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #1024
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_369
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sec
sbc.w #185
bvc +
eor #$8000
+
bmi +
brl __local_370
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 2
__local_370:
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_369:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #512
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_371
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
brl __local_372
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 0
__local_372:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_371:
lda.l tccs_{WLA_FILENAME}_pad_held + 0
and.w #256
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_373
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
sec
sbc.w #220
bvc +
eor #$8000
+
bmi +
brl __local_374
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 22
rep #$20
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 0
__local_374:
lda.w #3
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 8
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 33
rep #$20
__local_373:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #32768
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_375
+
lda.w tccs_{WLA_FILENAME}_player + 30
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
bne +
__local_375:
brl __local_376
+
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #1
beq +
brl __local_377
+
lda.w #120
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #200
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
jmp.w __local_378
__local_377:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #2
beq +
brl __local_379
+
lda.w #100
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #240
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
jmp.w __local_380
__local_379:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #3
beq +
brl __local_381
+
lda.w #15
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #15
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #120
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
bra __local_382
__local_381:
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #4
beq +
brl __local_383
+
lda.w #150
sta.w tccs_{WLA_FILENAME}_player + 28
lda.w #260
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 30
__local_383:
__local_382:
__local_380:
__local_378:
__local_376:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_384
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_384:
brl __local_385
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_386
+
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #185
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
__local_386:
brl __local_387
+
lda.w tccs_{WLA_FILENAME}_player + 2
clc
adc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_387:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_388
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
__local_388:
brl __local_389
+
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 2
__local_389:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_390
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
__local_390:
brl __local_391
+
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_391:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_392
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #220
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
__local_392:
brl __local_393
+
lda.w tccs_{WLA_FILENAME}_player + 0
clc
adc.w #4
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 0
__local_393:
__local_385:
lda.l tccs_{WLA_FILENAME}_pad_down + 0
and.w #16384
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_394
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 24
rep #$20
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
bne +
__local_394:
brl __local_395
+
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
cmp #3
beq +
brl __local_396
+
bra __local_397
__local_396:
lda.w #12
sta.b tcc__r0
bra __local_398
__local_397:
lda.w #6
sta.b tcc__r0
__local_398:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 23
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
cmp #3
beq +
brl __local_399
+
bra __local_400
__local_399:
lda.w #18
sta.b tcc__r0
bra __local_401
__local_400:
lda.w #10
sta.b tcc__r0
__local_401:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 24
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 10
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
brl __local_402
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
__local_402:
brl __local_403
+
jmp.w __local_404
__local_403:
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 0
sta.w tccs_{WLA_FILENAME}_player_proj + 0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player_proj + 2
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 18
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 6
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_405
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #5
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
jmp.w __local_406
__local_405:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_407
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #-5
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
jmp.w __local_408
__local_407:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_409
+
lda.w #-5
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
bra __local_410
__local_409:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_411
+
lda.w #5
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
__local_411:
__local_410:
__local_408:
__local_406:
__local_404:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 15
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_412
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
brl __local_413
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
__local_413:
brl __local_414
+
jmp.w __local_415
__local_414:
lda.w tccs_{WLA_FILENAME}_player + 0
sta -80 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta -82 + __main_locals + 1,s
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_416
+
lda -82 + __main_locals + 1,s
clc
adc.w #14
sta.b tcc__r0
sta -82 + __main_locals + 1,s
__local_416:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_417
+
lda -82 + __main_locals + 1,s
sec
sbc.w #14
sta.b tcc__r0
sta -82 + __main_locals + 1,s
__local_417:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_418
+
lda -80 + __main_locals + 1,s
sec
sbc.w #14
sta.b tcc__r0
sta -80 + __main_locals + 1,s
__local_418:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_419
+
lda -80 + __main_locals + 1,s
clc
adc.w #14
sta.b tcc__r0
sta -80 + __main_locals + 1,s
__local_419:
lda -80 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -84 + __main_locals + 1,s
lda -82 + __main_locals + 1,s
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -86 + __main_locals + 1,s
lda -84 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_420
+
stz.b tcc__r0
lda -84 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -84 + __main_locals + 1,s
__local_420:
lda -86 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_421
+
stz.b tcc__r0
lda -86 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -86 + __main_locals + 1,s
__local_421:
lda -84 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #20
bvc +
eor #$8000
+
bmi +
brl __local_422
+
lda -86 + __main_locals + 1,s
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
__local_422:
brl __local_423
+
lda.w tccs_{WLA_FILENAME}_player + 18
sta -88 + __main_locals + 1,s
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_424
+
lda -88 + __main_locals + 1,s
asl a
sta.b tcc__r0
sta -88 + __main_locals + 1,s
__local_424:
lda.w tccs_{WLA_FILENAME}_boss + 6
sta.b tcc__r0
lda -88 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.w tccs_{WLA_FILENAME}_boss + 6
lda.w #8
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_423:
__local_412:
__local_415:
__local_395:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_425
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player_proj + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player_proj + 0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 5
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player_proj + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player_proj + 2
lda.w tccs_{WLA_FILENAME}_player_proj + 0
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
brl __local_426
+
lda.w tccs_{WLA_FILENAME}_player_proj + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #235
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
__local_426:
brl __local_427
+
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #25
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
__local_427:
brl __local_428
+
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #200
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
__local_428:
brl __local_429
+
bra __local_430
__local_429:
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
__local_430:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 15
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_431
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_431:
brl __local_432
+
lda.w tccs_{WLA_FILENAME}_player_proj + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -90 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player_proj + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -92 + __main_locals + 1,s
lda -90 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_433
+
stz.b tcc__r0
lda -90 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -90 + __main_locals + 1,s
__local_433:
lda -92 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_434
+
stz.b tcc__r0
lda -92 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -92 + __main_locals + 1,s
__local_434:
lda -90 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #18
bvc +
eor #$8000
+
bmi +
brl __local_435
+
lda -92 + __main_locals + 1,s
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
__local_435:
brl __local_436
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 6
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta -94 + __main_locals + 1,s
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_437
+
lda -94 + __main_locals + 1,s
asl a
sta.b tcc__r0
sta -94 + __main_locals + 1,s
__local_437:
lda.w tccs_{WLA_FILENAME}_boss + 6
sta.b tcc__r0
lda -94 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.w tccs_{WLA_FILENAME}_boss + 6
lda.w #8
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_436:
__local_432:
__local_425:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 15
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_438
+
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
brl __local_439
+
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_boss + 6
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 15
rep #$20
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_essence_spawned + 0
rep #$20
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_boss_portal_open + 0
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
jmp.w __local_440
__local_439:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_441
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
sec
sbc.w #50
bvc +
eor #$8000
+
bmi +
brl __local_442
+
lda.w #50
sta.w tccs_{WLA_FILENAME}_boss + 0
lda.w #1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
__local_442:
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #190
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
brl __local_443
+
lda.w #190
sta.w tccs_{WLA_FILENAME}_boss + 0
lda.w #-1
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 4
rep #$20
__local_443:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 11
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
brl __local_444
+
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
__local_444:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_445
+
lda.w #80
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
lda.w tccs_{WLA_FILENAME}_boss + 2
clc
adc.w #8
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
ldx #1
lda.b tcc__r0
sec
sbc.b tcc__r1
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
brl __local_446
+
bra __local_447
__local_446:
lda.w #65534
sta.b tcc__r0
bra __local_448
__local_447:
lda.w #2
sta.b tcc__r0
__local_448:
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 4
rep #$20
lda.w #3
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 5
rep #$20
lda.w #15
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 6
rep #$20
__local_445:
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -96 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -98 + __main_locals + 1,s
lda -96 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_449
+
stz.b tcc__r0
lda -96 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -96 + __main_locals + 1,s
__local_449:
lda -98 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_450
+
stz.b tcc__r0
lda -98 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -98 + __main_locals + 1,s
__local_450:
lda -96 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #45
bvc +
eor #$8000
+
bmi +
brl __local_451
+
lda -98 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #45
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
__local_451:
brl __local_452
+
lda.w #1
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
lda.w #50
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_452:
jmp.w __local_453
__local_441:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_454
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
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
brl __local_455
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
__local_455:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 10
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 12
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_456
+
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -100 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_boss + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -102 + __main_locals + 1,s
lda -100 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_457
+
stz.b tcc__r0
lda -100 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -100 + __main_locals + 1,s
__local_457:
lda -102 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_458
+
stz.b tcc__r0
lda -102 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -102 + __main_locals + 1,s
__local_458:
lda -100 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #38
bvc +
eor #$8000
+
bmi +
brl __local_459
+
lda -102 + __main_locals + 1,s
sta.b tcc__r0
ldx #1
sec
sbc.w #38
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
__local_459:
brl __local_460
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
rep #$20
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
bne +
__local_460:
brl __local_461
+
lda.w #25
sta -104 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_462
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_462:
brl __local_463
+
lda.w #5
sta.b tcc__r0
sta -104 + __main_locals + 1,s
__local_463:
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
lda -104 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 14
lda.w #40
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_461:
lda.w #2
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
lda.w #110
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 13
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_456:
jmp.w __local_464
__local_454:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_465
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 13
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
brl __local_466
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 13
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
dec.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_boss + 13
rep #$20
__local_466:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 13
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_467
+
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
lda.w #60
sep #$20
sta.w tccs_{WLA_FILENAME}_boss + 11
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_467:
__local_465:
__local_464:
__local_453:
__local_440:
__local_438:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_468
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 4
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 5
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
clc
adc.b tcc__r0
sta.b tcc__r1
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
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
brl __local_469
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
sta.b tcc__r0
ldx #1
sec
sbc.w #235
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
__local_469:
brl __local_470
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #25
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
__local_470:
brl __local_471
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
sta.b tcc__r0
ldx #1
sec
sbc.w #200
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
__local_471:
brl __local_472
+
bra __local_473
__local_472:
lda.w #0
sta.b tcc__r0
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
__local_473:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_474
+
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 0
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -106 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
sta.b tcc__r0
lda.w tccs_{WLA_FILENAME}_player + 2
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta -108 + __main_locals + 1,s
lda -106 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_475
+
stz.b tcc__r0
lda -106 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -106 + __main_locals + 1,s
__local_475:
lda -108 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_476
+
stz.b tcc__r0
lda -108 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -108 + __main_locals + 1,s
__local_476:
lda -106 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #12
bvc +
eor #$8000
+
bmi +
brl __local_477
+
lda -108 + __main_locals + 1,s
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
__local_477:
brl __local_478
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 6
rep #$20
xba
xba
bpl +
ora.w #$ff00
+
sta -110 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_479
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_479:
brl __local_480
+
stz.b tcc__r0
lda.b tcc__r0
sta -110 + __main_locals + 1,s
__local_480:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_481
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
bne +
__local_481:
brl __local_482
+
lda -110 + __main_locals + 1,s
sta.b tcc__r0
tax
lda.w #2
jsr.l tcc__div
lda.b tcc__r9
sta.b tcc__r0
sta -110 + __main_locals + 1,s
__local_482:
lda.w tccs_{WLA_FILENAME}_player + 14
sta.b tcc__r0
lda -110 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.w tccs_{WLA_FILENAME}_player + 14
lda.w #35
sep #$20
sta.w tccs_{WLA_FILENAME}_player + 32
rep #$20
lda.w #0
sep #$20
sta.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_478:
__local_474:
__local_468:
lda.w tccs_{WLA_FILENAME}_player + 14
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
brl __local_483
+
stz.b tcc__r0
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 14
sep #$20
lda #0
pha
rep #$20
jsr.l return_to_village
tsa
clc
adc #1
tas
__local_483:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_spawned + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_484
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_collected + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_485
+
jmp.w __local_486
__local_485:
lda.w tccs_{WLA_FILENAME}_player + 0
sec
sbc.w #120
sta -112 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sec
sbc.w #110
sta -114 + __main_locals + 1,s
lda -112 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_487
+
stz.b tcc__r0
lda -112 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -112 + __main_locals + 1,s
__local_487:
lda -114 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #0
bvc +
eor #$8000
+
bmi +
brl __local_488
+
stz.b tcc__r0
lda -114 + __main_locals + 1,s
sta.b tcc__r1
sec
lda.b tcc__r0
sbc.b tcc__r1
sta.b tcc__r0
sta -114 + __main_locals + 1,s
__local_488:
lda -112 + __main_locals + 1,s
sta.b tcc__r0
sec
sbc.w #18
bvc +
eor #$8000
+
bmi +
brl __local_489
+
lda -114 + __main_locals + 1,s
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
__local_489:
brl __local_490
+
lda.w #1
sep #$20
sta.l tccs_{WLA_FILENAME}_essence_collected + 0
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 34
rep #$20
sta.b tcc__r0
sec
sbc.w #4
bvc +
eor #$8000
+
bmi +
brl __local_491
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 34
rep #$20
sta.b tcc__r0
sta.b tcc__r1
lda.b tcc__r0h
sta.b tcc__r1h
inc.b tcc__r0
sep #$20
lda.b tcc__r0
sta.w tccs_{WLA_FILENAME}_player + 34
rep #$20
__local_491:
lda.w #1
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_490:
__local_484:
__local_486:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_boss_portal_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_492
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
__local_492:
brl __local_493
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
__local_493:
brl __local_494
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
__local_494:
brl __local_495
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
__local_495:
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
brl __local_496
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
__local_496:
__local_366:
__local_365:
__local_353:
__local_156:
__local_150:
__local_143:
__local_138:
stz.b tcc__r0
lda.b tcc__r0
sta -116 + __main_locals + 1,s
lda.w #0
sep #$20
sta -117 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_497
+
lda.w #2
sta.b tcc__r0
sta -116 + __main_locals + 1,s
jmp.w __local_498
__local_497:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_499
+
lda.w #4
sta -116 + __main_locals + 1,s
lda.w #1
sta.b tcc__r0
sep #$20
sta -117 + __main_locals + 1,s
rep #$20
bra __local_500
__local_499:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_501
+
lda.w #4
sta -116 + __main_locals + 1,s
lda.w #0
sta.b tcc__r0
sep #$20
sta -117 + __main_locals + 1,s
rep #$20
__local_501:
__local_500:
__local_498:
lda.w tccs_{WLA_FILENAME}_player + 10
and.w #255
sep #$20
sta -118 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
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
brl __local_502
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 32
rep #$20
and.w #2
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_502:
brl __local_503
+
lda.w #4
sta.b tcc__r0
sep #$20
sta -118 + __main_locals + 1,s
rep #$20
__local_503:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_504
+
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
ldx #1
sec
sbc #4
tay
beq +
dex
+
stx.b tcc__r5
txa
bne +
__local_504:
brl __local_505
+
lda.w tccs_{WLA_FILENAME}_player + 28
and.w #4
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
__local_505:
brl __local_506
+
lda.w #4
sta.b tcc__r0
sep #$20
sta -118 + __main_locals + 1,s
rep #$20
__local_506:
lda.w #0
sep #$20
lda -118 + __main_locals + 1,s
pha
rep #$20
lda -115 + __main_locals + 1,s
pha
sep #$20
lda #0
pha
rep #$20
lda.w #0
sep #$20
lda -113 + __main_locals + 1,s
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
lda.w tccs_{WLA_FILENAME}_player + 23
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
brl __local_507
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
brl __local_508
+
lda.w tccs_{WLA_FILENAME}_player + 10
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
__local_508:
brl __local_509
+
jmp.w __local_510
__local_509:
lda.w tccs_{WLA_FILENAME}_player + 0
sta -120 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta -122 + __main_locals + 1,s
lda.w #0
sep #$20
sta -123 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_511
+
lda -122 + __main_locals + 1,s
clc
adc.w #12
sta.b tcc__r0
sta -122 + __main_locals + 1,s
jmp.w __local_512
__local_511:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_513
+
lda -122 + __main_locals + 1,s
sec
sbc.w #12
sta.b tcc__r0
sta -122 + __main_locals + 1,s
jmp.w __local_514
__local_513:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_515
+
lda -120 + __main_locals + 1,s
sec
sbc.w #12
sta -120 + __main_locals + 1,s
lda.w #1
sta.b tcc__r0
sep #$20
sta -123 + __main_locals + 1,s
rep #$20
bra __local_516
__local_515:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_517
+
lda -120 + __main_locals + 1,s
clc
adc.w #12
sta.b tcc__r0
sta -120 + __main_locals + 1,s
__local_517:
__local_516:
__local_514:
__local_512:
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
lda -119 + __main_locals + 1,s
pha
lda #3
pha
rep #$20
lda -116 + __main_locals + 1,s
pha
lda -112 + __main_locals + 1,s
pha
pea.w 4
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_518
__local_507:
__local_510:
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
__local_518:
lda.w tccs_{WLA_FILENAME}_player + 28
sta.b tcc__r0
ldx #1
sec
sbc.w #0
tay
beq +
bcs ++
+ dex
++
stx.b tcc__r5
txa
bne +
brl __local_519
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
brl __local_520
+
lda.w tccs_{WLA_FILENAME}_player + 26
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
__local_520:
brl __local_521
+
jmp.w __local_522
__local_521:
lda.w tccs_{WLA_FILENAME}_player + 0
sta -126 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 2
sta -128 + __main_locals + 1,s
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #2
beq +
brl __local_523
+
bra __local_524
__local_523:
lda.w #0
sta.b tcc__r0
bra __local_525
__local_524:
lda.w #5
sta.b tcc__r0
__local_525:
sep #$20
lda.b tcc__r0
sta -129 + __main_locals + 1,s
rep #$20
lda.w tccs_{WLA_FILENAME}_player + 26
sta.b tcc__r0
cmp #1
beq +
brl __local_526
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #0
beq +
brl __local_527
+
lda -128 + __main_locals + 1,s
clc
adc.w #8
sta.b tcc__r0
sta -128 + __main_locals + 1,s
__local_527:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #1
beq +
brl __local_528
+
lda -128 + __main_locals + 1,s
sec
sbc.w #8
sta.b tcc__r0
sta -128 + __main_locals + 1,s
__local_528:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #2
beq +
brl __local_529
+
lda -126 + __main_locals + 1,s
sec
sbc.w #8
sta.b tcc__r0
sta -126 + __main_locals + 1,s
__local_529:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player + 8
rep #$20
sta.b tcc__r0
cmp #3
beq +
brl __local_530
+
lda -126 + __main_locals + 1,s
clc
adc.w #8
sta.b tcc__r0
sta -126 + __main_locals + 1,s
__local_530:
__local_526:
lda.w #0
sep #$20
lda -129 + __main_locals + 1,s
pha
rep #$20
pea.w 14
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda -122 + __main_locals + 1,s
pha
lda -118 + __main_locals + 1,s
pha
pea.w 8
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_531
__local_519:
__local_522:
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
__local_531:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_532
+
lda.w tccs_{WLA_FILENAME}_player + 10
sta.b tcc__r0
cmp #1
beq +
brl __local_533
+
bra __local_534
__local_533:
lda.w #2
sta.b tcc__r0
bra __local_535
__local_534:
lda.w #1
sta.b tcc__r0
__local_535:
sep #$20
lda.b tcc__r0
sta -130 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -130 + __main_locals + 1,s
pha
rep #$20
pea.w 12
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_player_proj + 2
pha
lda.w tccs_{WLA_FILENAME}_player_proj + 0
pha
pea.w 12
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_536
__local_532:
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
__local_536:
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
brl __local_537
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
__local_537:
brl __local_538
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
__local_538:
brl __local_539
+
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #7
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
__local_539:
brl __local_540
+
jmp.w __local_541
__local_540:
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
brl __local_542
+
bra __local_543
__local_542:
lda.w #0
sta.b tcc__r0
bra __local_544
__local_543:
lda.w #4
sta.b tcc__r0
__local_544:
sep #$20
lda.b tcc__r0
sta -131 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -131 + __main_locals + 1,s
pha
rep #$20
pea.w 10
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 165
pea.w 120
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
pea.w 32
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_pedestals + 2
pha
lda.l tccs_{WLA_FILENAME}_pedestals + 0
pha
pea.w 20
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #1
pha
rep #$20
pea.w 32
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_pedestals + 18
pha
lda.l tccs_{WLA_FILENAME}_pedestals + 16
pha
pea.w 24
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #2
pha
rep #$20
pea.w 32
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_pedestals + 34
pha
lda.l tccs_{WLA_FILENAME}_pedestals + 32
pha
pea.w 28
jsr.l oamSet
tsa
clc
adc #12
tas
sep #$20
lda #3
pha
rep #$20
pea.w 32
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.l tccs_{WLA_FILENAME}_pedestals + 50
pha
lda.l tccs_{WLA_FILENAME}_pedestals + 48
pha
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
pea.w 40
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 75
pea.w 120
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
pea.w 42
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
pea.w 35
pea.w 120
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
pea.w 60
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
pea.w 64
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
pea.w 68
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
pea.w 72
jsr.l oamSet
tsa
clc
adc #12
tas
jmp.w __local_545
__local_541:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #3
beq +
brl __local_546
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
pea.w 0
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
pea.w 60
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
pea.w 64
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
pea.w 68
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
pea.w 72
jsr.l oamSet
tsa
clc
adc #12
tas
jmp.w __local_547
__local_546:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
ldx #1
sec
sbc #4
tay
beq +
dex
+
stx.b tcc__r5
txa
beq +
brl __local_548
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
__local_548:
brl __local_549
+
jmp.w __local_550
__local_549:
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
pea.w 60
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
pea.w 72
jsr.l oamSet
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime1 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_551
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
brl __local_552
+
bra __local_553
__local_552:
lda.w #2
sta.b tcc__r0
bra __local_554
__local_553:
lda.w #4
sta.b tcc__r0
__local_554:
sep #$20
lda.b tcc__r0
sta -132 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -132 + __main_locals + 1,s
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
pea.w 48
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_555
__local_551:
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
__local_555:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_slime2 + 6
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_556
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
brl __local_557
+
bra __local_558
__local_557:
lda.w #2
sta.b tcc__r0
bra __local_559
__local_558:
lda.w #4
sta.b tcc__r0
__local_559:
sep #$20
lda.b tcc__r0
sta -133 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -133 + __main_locals + 1,s
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
pea.w 52
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_560
__local_556:
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
__local_560:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_561
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 5
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
brl __local_562
+
bra __local_563
__local_562:
lda.w #5
sta.b tcc__r0
bra __local_564
__local_563:
lda.w #4
sta.b tcc__r0
__local_564:
sep #$20
lda.b tcc__r0
sta -134 + __main_locals + 1,s
rep #$20
lda.w #0
sep #$20
lda -134 + __main_locals + 1,s
pha
rep #$20
pea.w 38
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_elemental + 2
pha
lda.w tccs_{WLA_FILENAME}_elemental + 0
pha
pea.w 56
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_565
__local_561:
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
__local_565:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_chest + 4
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_566
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_chest + 5
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_567
+
bra __local_568
__local_567:
lda.w #34
sta.b tcc__r0
bra __local_569
__local_568:
lda.w #36
sta.b tcc__r0
__local_569:
lda.b tcc__r0
sta -136 + __main_locals + 1,s
sep #$20
lda #6
pha
rep #$20
lda -135 + __main_locals + 1,s
pha
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_chest + 2
pha
lda.w tccs_{WLA_FILENAME}_chest + 0
pha
pea.w 44
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_570
__local_566:
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
__local_570:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_571
+
sep #$20
lda #5
pha
rep #$20
pea.w 12
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
pha
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
pha
pea.w 64
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_572
__local_571:
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
pea.w 64
jsr.l oamSet
tsa
clc
adc #12
tas
__local_572:
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
pea.w 68
jsr.l oamSet
tsa
clc
adc #12
tas
jmp.w __local_573
__local_550:
lda.w tccs_{WLA_FILENAME}_current_state + 0
sta.b tcc__r0
cmp #6
beq +
brl __local_574
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
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 15
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_575
+
lda.w #7
sta.b tcc__r0
sep #$20
sta -137 + __main_locals + 1,s
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
brl __local_576
+
bra __local_577
__local_576:
lda.w #0
sta.b tcc__r0
bra __local_578
__local_577:
lda.w #1
sta.b tcc__r0
__local_578:
sep #$20
lda.b tcc__r0
sta -138 + __main_locals + 1,s
rep #$20
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
beq +
brl __local_579
+
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_boss + 14
rep #$20
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
__local_579:
brl __local_580
+
bra __local_581
__local_580:
lda.w #4
sta.b tcc__r0
sep #$20
sta -137 + __main_locals + 1,s
rep #$20
__local_581:
lda.w #0
sep #$20
lda -137 + __main_locals + 1,s
pha
rep #$20
pea.w 8
sep #$20
lda #0
pha
rep #$20
lda.w #0
sep #$20
lda -134 + __main_locals + 1,s
pha
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_boss + 2
pha
lda.w tccs_{WLA_FILENAME}_boss + 0
pha
pea.w 60
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_582
__local_575:
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
pea.w 60
jsr.l oamSet
tsa
clc
adc #12
tas
__local_582:
lda.w #0
sep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 7
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_583
+
sep #$20
lda #5
pha
rep #$20
pea.w 12
pea.w (0 * 256 + 0)
sep #$20
lda #3
pha
rep #$20
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 2
pha
lda.w tccs_{WLA_FILENAME}_enemy_proj1 + 0
pha
pea.w 64
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_584
__local_583:
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
pea.w 64
jsr.l oamSet
tsa
clc
adc #12
tas
__local_584:
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
pea.w 68
jsr.l oamSet
tsa
clc
adc #12
tas
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_spawned + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_585
+
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_essence_collected + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_586
+
bra __local_587
__local_586:
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
pea.w 72
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_588
__local_585:
__local_587:
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
pea.w 72
jsr.l oamSet
tsa
clc
adc #12
tas
__local_588:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_boss_portal_open + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_589
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
pea.w 40
jsr.l oamSet
tsa
clc
adc #12
tas
bra __local_590
__local_589:
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
__local_590:
__local_574:
__local_573:
__local_547:
__local_545:
lda.w #0
sep #$20
lda.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
sta.b tcc__r0
lda.b tcc__r0 ; DON'T OPTIMIZE
bne +
brl __local_591
+
jsr.l draw_hud
lda.w #0
sta.b tcc__r0
sep #$20
sta.l tccs_{WLA_FILENAME}_hud_dirty + 0
rep #$20
__local_591:
jsr.l WaitForVBlank
jmp.w __local_592
lda.w #0
sta.b tcc__r0
__local_593:
.ifgr __main_locals 0
tsa
clc
adc #__main_locals
tas
.endif
rtl
.ENDS
.RAMSECTION "ram{WLA_FILENAME}.data" APPENDTO "globram.data"

tccs_{WLA_FILENAME}_pad_held dsb 2
tccs_{WLA_FILENAME}_pad_down dsb 2
tccs_{WLA_FILENAME}_hud_dirty dsb 1
tccs_{WLA_FILENAME}_dummy_hit_flash dsb 1
tccs_{WLA_FILENAME}_dummy_damage dsb 2
tccs_{WLA_FILENAME}_chamber1_cleared dsb 1
tccs_{WLA_FILENAME}_dungeon_door_open dsb 1
tccs_{WLA_FILENAME}_essence_spawned dsb 1
tccs_{WLA_FILENAME}_essence_collected dsb 1
tccs_{WLA_FILENAME}_boss_portal_open dsb 4
tccs_{WLA_FILENAME}_class_names dsb 16
tccs_{WLA_FILENAME}_class_specials dsb 16

.ENDS

.SECTION "{WLA_FILENAME}.data" APPENDTO "glob.data"

.db $0,$0
.db $0,$0
.db $1
.db $0
.db $0,$0
.db $0
.db $0
.db $0
.db $0
.db $0,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45 + 0, :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49 + 0, :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52
.ENDS

.SECTION ".rodata" SUPERFREE

tccs_{WLA_FILENAME}_pedestals: .db $2d,$0,$78,$0,$0,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22
.db $5f,$0,$78,$0,$1,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24
.db $91,$0,$78,$0,$2,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26
.db $c3,$0,$78,$0,$3,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}21: .db $43,$61,$76,$61,$6c,$65,$69,$72,$6f,$20,$28,$54,$61,$74,$75,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}22: .db $45,$73,$70,$61,$64,$61,$20,$2b,$20,$42,$6c,$6f,$71,$75,$65,$69,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}23: .db $4d,$61,$67,$61,$20,$28,$4c,$6f,$62,$6f,$2d,$47,$75,$61,$72,$61,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}24: .db $4d,$61,$67,$69,$61,$20,$2b,$20,$42,$61,$72,$72,$65,$69,$72,$61,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}25: .db $41,$72,$71,$75,$65,$69,$72,$6f,$20,$28,$4c,$61,$67,$61,$72,$74,$6f,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}26: .db $46,$6c,$65,$63,$68,$61,$20,$2b,$20,$52,$6f,$6c,$61,$6d,$65,$6e,$74,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}27: .db $41,$73,$73,$61,$73,$73,$69,$6e,$6f,$20,$28,$55,$72,$75,$74,$61,$75,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}28: .db $41,$64,$61,$67,$61,$73,$20,$2b,$20,$49,$6e,$76,$69,$73,$69,$76,$65,$6c,$0,$0,$0
tccs_{WLA_FILENAME}_talent_catalog: .db $0,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30
.db $0,$0,$0,$0,$1,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32
.db $1,$4,$0,$0,$2,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34
.db $2,$4,$0,$0,$3,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36
.db $3,$1,$0,$0,$4,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38
.db $0,$1e,$0,$0,$5,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40
.db $4,$19,$0,$0,$6,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42
.db $1,$6,$0,$0,$7,$0,$0,$0
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43
.dw tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44 + 0
.dw :tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44
.db $4,$5,$0,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}29: .db $4e,$65,$6e,$68,$75,$6d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}30: .db $53,$6c,$6f,$74,$20,$76,$61,$7a,$69,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}31: .db $47,$6f,$6c,$70,$65,$20,$50,$65,$73,$61,$64,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}32: .db $2b,$34,$20,$50,$6f,$64,$65,$72,$20,$64,$65,$20,$41,$74,$61,$71,$75,$65,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}33: .db $50,$6f,$73,$74,$75,$72,$61,$20,$46,$69,$72,$6d,$65,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}34: .db $2b,$34,$20,$44,$65,$66,$65,$73,$61,$20,$46,$69,$73,$69,$63,$61,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}35: .db $50,$61,$73,$73,$6f,$20,$4c,$65,$76,$65,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}36: .db $2b,$31,$20,$56,$65,$6c,$6f,$63,$69,$64,$61,$64,$65,$20,$64,$65,$20,$50,$61,$73,$73,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}37: .db $56,$69,$74,$61,$6c,$69,$64,$61,$64,$65,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}38: .db $2b,$33,$30,$20,$48,$50,$20,$4d,$61,$78,$69,$6d,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}39: .db $53,$65,$67,$75,$6e,$64,$6f,$20,$46,$6f,$6c,$65,$67,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}40: .db $43,$75,$72,$61,$20,$32,$35,$20,$48,$50,$20,$73,$65,$20,$65,$6d,$20,$70,$65,$72,$69,$67,$6f,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}41: .db $46,$6c,$65,$63,$68,$61,$73,$20,$56,$65,$6c,$6f,$7a,$65,$73,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}42: .db $2b,$36,$20,$44,$61,$6e,$6f,$20,$64,$65,$20,$50,$72,$6f,$6a,$65,$74,$69,$6c,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}43: .db $4c,$61,$6d,$69,$6e,$61,$20,$56,$65,$6e,$65,$6e,$6f,$73,$61,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}44: .db $56,$65,$6e,$65,$6e,$6f,$20,$63,$6f,$6e,$74,$69,$6e,$75,$6f,$20,$6e,$6f,$20,$67,$6f,$6c,$70,$65,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}45: .db $43,$41,$56,$41,$4c,$45,$49,$52,$4f,$20,$28,$54,$41,$54,$55,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}46: .db $4d,$41,$47,$41,$20,$28,$4c,$4f,$42,$4f,$2d,$47,$55,$41,$52,$41,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}47: .db $41,$52,$51,$55,$45,$49,$52,$4f,$20,$28,$4c,$41,$47,$41,$52,$54,$4f,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}48: .db $41,$53,$53,$41,$53,$53,$49,$4e,$4f,$20,$28,$55,$52,$55,$54,$41,$55,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}49: .db $42,$4c,$4f,$51,$55,$45,$49,$4f,$20,$28,$45,$53,$43,$55,$44,$4f,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}50: .db $45,$53,$43,$55,$44,$4f,$20,$44,$45,$20,$4d,$41,$4e,$41,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}51: .db $52,$4f,$4c,$41,$4d,$45,$4e,$54,$4f,$20,$28,$44,$41,$53,$48,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}52: .db $49,$4e,$56,$49,$53,$49,$42,$49,$4c,$49,$44,$41,$44,$45,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}53: .db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}54: .db $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}55: .db $3d,$3d,$20,$56,$49,$4c,$41,$20,$44,$4f,$53,$20,$45,$4c,$45,$4d,$45,$4e,$54,$4f,$53,$20,$28,$53,$4e,$45,$53,$29,$20,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}56: .db $43,$4c,$41,$53,$53,$45,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}57: .db $48,$50,$3a,$5b,$25,$73,$5d,$20,$25,$64,$2f,$25,$64,$20,$20,$45,$53,$53,$45,$4e,$43,$49,$41,$3a,$25,$64,$2f,$34,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}58: .db $44,$2d,$50,$61,$64,$3a,$41,$6e,$64,$61,$72,$20,$20,$59,$3a,$41,$74,$61,$63,$61,$72,$20,$20,$42,$3a,$45,$73,$70,$65,$63,$69,$61,$6c,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}59: .db $41,$3a,$50,$65,$64,$65,$73,$74,$61,$6c,$2f,$41,$6c,$74,$61,$72,$20,$20,$58,$3a,$46,$69,$63,$68,$61,$2f,$54,$61,$6c,$65,$6e,$74,$6f,$73,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}60: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}61: .db $50,$4f,$52,$54,$41,$4c,$20,$44,$49,$4d,$45,$4e,$53,$49,$4f,$4e,$41,$4c,$20,$28,$52,$4f,$4f,$4d,$20,$31,$29,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}62: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}63: .db $45,$6e,$74,$72,$61,$72,$20,$6e,$61,$20,$4d,$61,$73,$6d,$6f,$72,$72,$61,$20,$64,$65,$20,$41,$67,$75,$61,$3f,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}64: .db $45,$6e,$66,$72,$65,$6e,$74,$65,$20,$6f,$73,$20,$6d,$6f,$6e,$73,$74,$72,$6f,$73,$20,$64,$61,$20,$66,$61,$73,$65,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}65: .db $65,$20,$61,$6c,$63,$61,$6e,$63,$65,$20,$6f,$20,$47,$65,$6e,$65,$72,$61,$6c,$20,$64,$61,$20,$41,$67,$75,$61,$21,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}66: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}67: .db $5b,$41,$5d,$20,$45,$4e,$54,$52,$41,$52,$20,$4e,$41,$20,$4d,$41,$53,$4d,$4f,$52,$52,$41,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}68: .db $5b,$42,$5d,$20,$46,$69,$63,$61,$72,$20,$6e,$61,$20,$56,$69,$6c,$61,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}69: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}70: .db $41,$4c,$54,$41,$52,$20,$44,$41,$53,$20,$34,$20,$45,$53,$53,$45,$4e,$43,$49,$41,$53,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}71: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}72: .db $41,$47,$55,$41,$3a,$20,$20,$5b,$4f,$4b,$5d,$20,$20,$46,$4f,$47,$4f,$3a,$20,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}73: .db $41,$47,$55,$41,$3a,$20,$20,$5b,$2d,$2d,$5d,$20,$20,$46,$4f,$47,$4f,$3a,$20,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}74: .db $46,$4f,$47,$4f,$3a,$20,$5b,$4f,$4b,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}75: .db $54,$45,$52,$52,$41,$3a,$20,$5b,$4f,$4b,$5d,$20,$20,$56,$45,$4e,$54,$4f,$3a,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}76: .db $54,$45,$52,$52,$41,$3a,$20,$5b,$2d,$2d,$5d,$20,$20,$56,$45,$4e,$54,$4f,$3a,$5b,$2d,$2d,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}77: .db $56,$45,$4e,$54,$4f,$3a,$5b,$4f,$4b,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}78: .db $52,$65,$73,$74,$61,$75,$72,$65,$20,$6f,$73,$20,$34,$20,$67,$65,$6e,$65,$72,$61,$69,$73,$21,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}79: .db $5b,$41,$20,$2f,$20,$42,$5d,$20,$46,$65,$63,$68,$61,$72,$20,$41,$6c,$74,$61,$72,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}80: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}81: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}82: .db $56,$49,$54,$4f,$52,$49,$41,$21,$20,$45,$53,$53,$45,$4e,$43,$49,$41,$20,$52,$45,$53,$47,$41,$54,$41,$44,$41,$21,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}83: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}84: .db $4f,$20,$47,$65,$6e,$65,$72,$61,$6c,$20,$66,$6f,$69,$20,$70,$75,$72,$69,$66,$69,$63,$61,$64,$6f,$21,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}85: .db $41,$20,$61,$67,$75,$61,$20,$6c,$69,$6d,$69,$70,$69,$64,$61,$20,$63,$6f,$72,$72,$65,$20,$6e,$61,$20,$76,$69,$6c,$61,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}86: .db $4f,$20,$41,$6c,$74,$61,$72,$20,$72,$65,$63,$65,$62,$65,$75,$20,$61,$20,$45,$73,$73,$65,$6e,$63,$69,$61,$21,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}87: .db $5b,$41,$20,$2f,$20,$42,$5d,$20,$43,$6f,$6e,$74,$69,$6e,$75,$61,$72,$20,$65,$78,$70,$6c,$6f,$72,$61,$6e,$64,$6f,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}88: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}89: .db $3d,$3d,$20,$46,$49,$43,$48,$41,$20,$44,$4f,$20,$48,$45,$52,$4f,$49,$20,$45,$20,$54,$41,$4c,$45,$4e,$54,$4f,$53,$20,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}90: .db $43,$4c,$41,$53,$53,$45,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}91: .db $45,$53,$50,$45,$43,$49,$41,$4c,$20,$5b,$42,$5d,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}92: .db $50,$4f,$44,$45,$52,$3a,$25,$64,$20,$20,$44,$45,$46,$45,$53,$41,$3a,$25,$64,$20,$20,$56,$45,$4c,$3a,$25,$64,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}93: .db $48,$50,$20,$4d,$41,$58,$49,$4d,$4f,$3a,$20,$25,$64,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}94: .db $2d,$2d,$2d,$20,$53,$4c,$4f,$54,$53,$20,$44,$45,$20,$54,$41,$4c,$45,$4e,$54,$4f,$53,$20,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}95: .db $53,$4c,$4f,$54,$20,$31,$3a,$20,$25,$73,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}96: .db $20,$20,$20,$20,$20,$20,$20,$20,$28,$25,$73,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}97: .db $53,$4c,$4f,$54,$20,$32,$3a,$20,$25,$73,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}98: .db $20,$20,$20,$20,$20,$20,$20,$20,$28,$25,$73,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}99: .db $53,$4c,$4f,$54,$20,$33,$3a,$20,$25,$73,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}100: .db $20,$20,$20,$20,$20,$20,$20,$20,$28,$25,$73,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}101: .db $41,$62,$72,$61,$20,$62,$61,$75,$73,$20,$6e,$61,$20,$6d,$61,$73,$6d,$6f,$72,$72,$61,$20,$70,$2f,$20,$6d,$61,$69,$73,$21,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}102: .db $5b,$41,$20,$2f,$20,$42,$20,$2f,$20,$58,$5d,$20,$46,$65,$63,$68,$61,$72,$20,$46,$69,$63,$68,$61,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}103: .db $3d,$3d,$20,$4d,$41,$53,$4d,$4f,$52,$52,$41,$20,$28,$53,$41,$4c,$41,$20,$31,$20,$44,$45,$20,$4d,$4f,$42,$53,$29,$20,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}104: .db $43,$4c,$41,$53,$53,$45,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}105: .db $48,$50,$3a,$5b,$25,$73,$5d,$20,$25,$64,$2f,$25,$64,$20,$20,$45,$53,$50,$3a,$5b,$42,$5d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}106: .db $49,$4e,$49,$4d,$49,$47,$4f,$53,$3a,$20,$44,$65,$72,$72,$6f,$74,$65,$20,$6f,$73,$20,$6d,$6f,$6e,$73,$74,$72,$6f,$73,$21,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}107: .db $53,$41,$4c,$41,$20,$4c,$49,$4d,$50,$41,$21,$20,$41,$62,$72,$61,$20,$6f,$20,$42,$61,$75,$20,$2f,$20,$50,$6f,$72,$74,$61,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}108: .db $59,$3a,$41,$74,$61,$71,$75,$65,$20,$20,$42,$3a,$45,$73,$70,$65,$63,$69,$61,$6c,$20,$20,$41,$3a,$42,$61,$75,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}109: .db $50,$4f,$52,$54,$41,$20,$44,$4f,$20,$43,$48,$45,$46,$45,$20,$41,$42,$45,$52,$54,$41,$20,$41,$4f,$20,$4e,$4f,$52,$54,$45,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}110: .db $4c,$69,$6d,$70,$65,$20,$61,$20,$73,$61,$6c,$61,$20,$70,$61,$72,$61,$20,$61,$76,$61,$6e,$63,$61,$72,$21,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}111: .db $3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}112: .db $42,$41,$55,$20,$44,$45,$20,$54,$45,$53,$4f,$55,$52,$4f,$20,$41,$42,$45,$52,$54,$4f,$21,$20,$20,$20,$20,$20,$20,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}113: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}114: .db $54,$41,$4c,$45,$4e,$54,$4f,$3a,$20,$25,$73,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}115: .db $28,$25,$73,$29,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}116: .db $2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$2d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}117: .db $5b,$59,$5d,$20,$45,$71,$75,$69,$70,$61,$72,$20,$6e,$6f,$20,$53,$6c,$6f,$74,$20,$31,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}118: .db $5b,$58,$5d,$20,$45,$71,$75,$69,$70,$61,$72,$20,$6e,$6f,$20,$53,$6c,$6f,$74,$20,$32,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}119: .db $5b,$41,$5d,$20,$45,$71,$75,$69,$70,$61,$72,$20,$6e,$6f,$20,$53,$6c,$6f,$74,$20,$33,$20,$20,$5b,$42,$5d,$20,$53,$61,$69,$72,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}120: .db $3d,$3d,$20,$43,$41,$4d,$41,$52,$41,$20,$44,$4f,$20,$47,$45,$4e,$45,$52,$41,$4c,$20,$44,$41,$20,$41,$47,$55,$41,$20,$3d,$3d,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}121: .db $43,$4c,$41,$53,$53,$45,$3a,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}122: .db $48,$50,$20,$48,$45,$52,$4f,$49,$3a,$20,$5b,$25,$73,$5d,$20,$25,$64,$2f,$25,$64,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}123: .db $43,$48,$45,$46,$45,$3a,$20,$5b,$56,$55,$4c,$4e,$45,$52,$41,$56,$45,$4c,$21,$5d,$20,$25,$64,$2f,$33,$30,$30,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}124: .db $43,$48,$45,$46,$45,$3a,$20,$20,$20,$20,$5b,$25,$73,$5d,$20,$25,$64,$2f,$25,$64,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}125: .db $43,$48,$45,$46,$45,$3a,$20,$44,$45,$52,$52,$4f,$54,$41,$44,$4f,$21,$20,$50,$45,$47,$55,$45,$20,$41,$20,$4f,$52,$42,$45,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}126: .db $59,$3a,$41,$74,$61,$71,$75,$65,$20,$20,$42,$3a,$45,$73,$70,$65,$63,$69,$61,$6c,$20,$20,$58,$3a,$46,$69,$63,$68,$61,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}127: .db $50,$4f,$52,$54,$41,$4c,$20,$41,$42,$45,$52,$54,$4f,$21,$20,$54,$6f,$71,$75,$65,$20,$6e,$6f,$20,$74,$6f,$70,$6f,$21,$20,$20,$0
tccs_{WLA_FILENAME}_L.{WLA_FILENAME}128: .db $43,$75,$69,$64,$61,$64,$6f,$20,$63,$6f,$6d,$20,$6f,$20,$53,$6c,$61,$6d,$20,$64,$6f,$20,$43,$68,$65,$66,$65,$21,$20,$20,$20,$0
.ENDS

.RAMSECTION ".bss" BANK $7e SLOT 2
tccs_{WLA_FILENAME}_player dsb 38
tccs_{WLA_FILENAME}_current_state dsb 2
tccs_{WLA_FILENAME}_slime1 dsb 8
tccs_{WLA_FILENAME}_slime2 dsb 8
tccs_{WLA_FILENAME}_elemental dsb 8
tccs_{WLA_FILENAME}_chest dsb 8
tccs_{WLA_FILENAME}_boss dsb 16
tccs_{WLA_FILENAME}_player_proj dsb 8
tccs_{WLA_FILENAME}_enemy_proj1 dsb 8
tccs_{WLA_FILENAME}_enemy_proj2 dsb 8
.ENDS
.SECTION ".rel.rodata" SUPERFREE

.db $8,$0,$0,$0,$1,$a,$0,$0,$c,$0,$0,$0,$1,$b,$0,$0,$18,$0,$0,$0,$1,$c,$0,$0,$1c,$0,$0,$0,$1,$d,$0,$0,$28,$0,$0,$0,$1,$e,$0,$0,$2c,$0,$0,$0,$1,$f,$0,$0,$38,$0,$0,$0,$1,$10,$0,$0,$3c,$0,$0,$0,$1,$11,$0,$0,$d8,$0,$0,$0,$1,$13,$0,$0,$dc,$0,$0,$0,$1,$14,$0,$0,$e8,$0,$0,$0,$1,$15,$0,$0,$ec,$0,$0,$0,$1,$16,$0,$0,$f8,$0,$0,$0,$1,$17,$0,$0,$fc,$0,$0,$0,$1,$18,$0,$0,$8,$1,$0,$0,$1,$19,$0,$0,$c,$1,$0,$0,$1,$1a,$0,$0,$18,$1,$0,$0,$1,$1b,$0,$0,$1c,$1,$0,$0,$1,$1c,$0,$0,$28,$1,$0,$0,$1,$1d,$0,$0,$2c,$1,$0,$0,$1,$1e,$0,$0,$38,$1,$0,$0,$1,$1f,$0,$0,$3c,$1,$0,$0,$1,$20,$0,$0,$48,$1,$0,$0,$1,$21,$0,$0,$4c,$1,$0,$0,$1,$22,$0,$0
.ENDS

