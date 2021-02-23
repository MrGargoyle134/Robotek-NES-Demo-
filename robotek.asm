  ;; ROBOTEK - MRGARGOYLE 2021 ;;
  
  .list
  .inesprg 1
  .ineschr 1
  .inesmir 0
  .inesmap 0
  .rsset $0000
  
pointerLo       .rs 1
pointerHi       .rs 1
frame_counter   .rs 1
state	      .rs 1
can_press_t     .rs 1
run_intro       .rs 1
text	      .rs 1
can_move        .rs 1
level	      .rs 1
palette_style   .rs 1
is_credits      .rs 1
pause	      .rs 1
;; Background ;;
scrollX	      .rs 1
scrollY	      .rs 1
;; Tmps ;;
tmp1	      .rs 1
talk            .rs 1
can_print_lifes .rs 1
;; Buttons ;;
a_button	      .rs 1
b_button        .rs 1
select	      .rs 1
start	      .rs 1
;; Player ;;
direction       .rs 1
is_moving       .rs 1
is_hiting       .rs 1
lifes	      .rs 1
is_hiding	      .rs 1
  
  .bank 0
  .org $C000
  
reset:
  sei ; Set interrupt flag
  cld ; Clear decimal flag
  ldx #$40
  stx $4017
  ldx #$ff
  txs
  inx
  stx $2000
  stx $2001
  stx $4010
  
wblank1:
  bit $2002
  bpl wblank1

clrmem:
  lda #$00
  sta $0000, x
  sta $0100, x
  sta $0300, x
  sta $0400, x
  sta $0500, x
  sta $0600, x
  sta $0700, x
  lda #$FE
  sta $0200, x
  inx
  bne clrmem
  
wblank2:
  bit $2002
  bpl wblank2
  
load_palette:
  lda $2002
  lda #$3F
  sta $2006
  ldx #$00
  stx $2006
  
load_palette_loop:
  lda palette1,x
  sta $2007
  inx
  cpx #$10
  bne load_palette_loop
  
load_credits_background:
  ldx #$00
  ldy #$00
  lda $2002
  lda #$20
  sta $2006
  stx $2006

  lda #LOW(credits)
  sta pointerLo
  lda #HIGH(credits)
  sta pointerHi

load_credits_background_loop:  
  lda [pointerLo],y
  sta $2007
  iny
  cpy #$00
  bne load_credits_background_loop
  inc pointerHi
  inx
  cpx #$04
  bne load_credits_background_loop
  
set_ppucnt:
  lda #%10001000
  sta $2000
  lda #%00011110
  sta $2001
  
;--Game--;
  ldx #$00
  
delay_background
  lda frame_counter
wait_background:
  cmp frame_counter
  beq wait_background
  inx
  cpx #$FF
  bne delay_background
  
  lda #$00
  sta $2001
load_main_menu_background:
  ldx #$00
  ldy #$00
  lda $2002
  lda #$20
  sta $2006
  stx $2006

  lda #LOW(main_menu)
  sta pointerLo
  lda #HIGH(main_menu)
  sta pointerHi

load_main_menu_background_loop:  
  lda [pointerLo],y
  sta $2007
  iny
  cpy #$00
  bne load_main_menu_background_loop
  inc pointerHi
  inx
  cpx #$04
  bne load_main_menu_background_loop
  
  lda #%00011110
  sta $2001
  
  lda #$01
  sta can_press_t
  
game_wait:
  lda state
  cmp #$01
  beq load_game
  cmp #$FF
  beq load_settings
  jmp game_wait
  
load_settings:
  lda #$00
  sta $2001 ; Disable PPU
  
load_settings_bkg:
  ldx #$00
  ldy #$00
  lda $2002
  lda #$20
  sta $2006
  stx $2006

  lda #LOW(settings_bkg)
  sta pointerLo
  lda #HIGH(settings_bkg)
  sta pointerHi

load_settings_bkg_loop:  
  lda [pointerLo],y
  sta $2007
  iny
  cpy #$00
  bne load_settings_bkg_loop
  inc pointerHi
  inx
  cpx #$04
  bne load_settings_bkg_loop
  
  lda #%00011110
  sta $2001 ; Enable PPU
  
game_wait2:
  lda state
  cmp #$01
  bne game_wait2
  
load_game:
  lda #$00
  sta $2001 ; Disable PPU
  
load_game_palette:
  ldx #$00
  lda $2002
  lda #$3F
  sta $2006
  stx $2006
  
  lda palette_style
  cmp #$02
  beq load_game_palette_loop2
  cmp #$01
  beq load_game_palette_loop1
  cmp #$00
  beq load_game_palette_loop0
  
load_game_palette_loop0:
  lda palette2,x
  sta $2007
  inx 
  cpx #$14
  bne load_game_palette_loop0
  jmp load_intro_background
  
load_game_palette_loop1:
  lda gb_palette,x
  sta $2007
  inx
  cpx #$14
  bne load_game_palette_loop1
  jmp load_intro_background
  
load_game_palette_loop2:
  lda bt_palette,x
  sta $2007
  inx
  cpx #$14
  bne load_game_palette_loop2
  
load_intro_background:
  ldx #$00
  ldy #$00
  lda $2002
  lda #$20
  sta $2006
  stx $2006

  lda #LOW(intro)
  sta pointerLo
  lda #HIGH(intro)
  sta pointerHi

load_intro_background_loop:  
  lda [pointerLo],y
  sta $2007
  iny
  cpy #$00
  bne load_intro_background_loop
  inc pointerHi
  inx
  cpx #$04 ; Intro
  bne load_intro_background_loop
  
load_level_1:
  ldx #$00
  ldy #$00
  lda $2002
  lda #$28
  sta $2006
  stx $2006

  lda #LOW(level1)
  sta pointerLo
  lda #HIGH(level1)
  sta pointerHi
  
load_level_1_loop:
  lda [pointerLo],y
  sta $2007
  iny
  cpy #$00
  bne load_level_1_loop
  inc pointerHi
  inx
  cpx #$04
  bne load_level_1_loop
  
  lda $2002
  lda #$2A
  sta $2006
  lda #$BB
  sta $2006
  lda #$23
  sta $2007
  
  lda #%00011110
  sta $2001 ; Enable PPU
  lda #%10001000
  sta $2000
  
  lda #$01
  sta run_intro
  ldx #$00
  
animate_intro:
  lda frame_counter
animate_intro_delay:
  cmp frame_counter
  beq animate_intro_delay
  inx
  cpx #$F0
  bne animate_intro
  
  lda #$00
  sta run_intro
  
  lda #%10001010
  sta $2000
  
load_player_sprite:
  ldx #$00
load_player_sprite_loop:
  lda player,x
  sta $0200,x ; Sprite address in RAM
  inx
  cpx #40
  bne load_player_sprite_loop
  
  lda #$03
  sta lifes
  
  ldx #$00
  
delay1:
  lda frame_counter
wait1:
  cmp frame_counter
  beq wait1
  inx
  cpx #60
  bne delay1
  
load_bill:
  lda $2002
  lda #$2A
  sta $2006
  lda #$C0
  sta $2006
  lda #$96
  sta $2007
  lda #$97
  sta $2007
  sta $2007
  sta $2007
  sta $2007
  lda #$98
  sta $2007
  
  lda $2002
  lda #$2A
  sta $2006
  lda #$E0
  sta $2006
  
  lda #$9C
  sta $2007
  
  lda #$80
  sta $2007
  lda #$81
  sta $2007
  lda #$82
  sta $2007
  lda #$83
  sta $2007
  
  lda #$9D
  sta $2007
  
  lda $2002
  lda #$2B
  sta $2006
  lda #$00
  sta $2006
  
  lda #$9C
  sta $2007
  lda #$84
  sta $2007
  lda #$85
  sta $2007
  lda #$86
  sta $2007
  lda #$87
  sta $2007
  lda #$9D
  sta $2007
  
  lda $2002
  lda #$2B
  sta $2006
  lda #$20
  sta $2006
  
  lda #$9C
  sta $2007
  lda #$88
  sta $2007
  lda #$89
  sta $2007
  lda #$8A
  sta $2007
  lda #$8B
  sta $2007
  lda #$9D
  sta $2007
  
  lda $2002
  lda #$2B
  sta $2006
  lda #$40
  sta $2006
  
  lda #$9C
  sta $2007
  lda #$8C
  sta $2007
  lda #$8D
  sta $2007
  lda #$8E
  sta $2007
  lda #$8F
  sta $2007
  lda #$9D
  sta $2007
  
  lda #$2B
  sta $2006
  lda #$60
  sta $2006
  
  lda #$9C
  sta $2007
  lda #$90
  sta $2007
  lda #$91
  sta $2007
  lda #$92
  sta $2007
  lda #$93
  sta $2007
  lda #$9D
  sta $2007
  
  lda $2002
  lda #$2B
  sta $2006
  lda #$80
  sta $2006
  
  lda #$D3
  sta $2007
  
  lda #$D4
  sta $2007
  sta $2007
  sta $2007
  sta $2007
  lda #$D5
  sta $2007
  
load_text_1:
  lda $2002
  lda #$2B
  sta $2006
  lda #$06
  sta $2006
  ldx #$00
load_text_1_loop:
  lda text1,x
  cmp #$FF
  beq set_talk
  sta $2007
  inx
  jmp load_text_1_loop

set_talk:  
  lda #$01
  sta talk
  
wait_for_text2:
  lda text
  cmp #$01
  bne wait_for_text2
  
load_text_2:
  lda $2002
  lda #$2B
  sta $2006
  lda #$06
  sta $2006
  ldx #$00
load_text_2_loop:
  lda text2,x
  cmp #$FF
  beq load_text_2p1
  sta $2007
  inx
  jmp load_text_2_loop
  
load_text_2p1:
  lda $2002
  lda #$2B
  sta $2006
  lda #$26
  sta $2006
  ldx #$00
load_text_2p1_loop:
  lda text2p1,x
  cmp #$FF
  beq load_text_2p2
  sta $2007
  inx
  jmp load_text_2p1_loop
  
load_text_2p2:
  lda $2002
  lda #$2B
  sta $2006
  lda #$46
  sta $2006
  ldx #$00
load_text_2p2_loop:
  lda text2p2,x
  cmp #$FF
  beq wait_for_text3
  sta $2007
  inx
  jmp load_text_2p2_loop
  
  
wait_for_text3:
  lda text
  cmp #$02
  bne wait_for_text3
  
load_text_3:
  lda $2002
  lda #$2B
  sta $2006
  lda #$06
  sta $2006
  ldx #$00
  
load_text_3_loop:
  lda text3,x
  cmp #$FF
  beq load_text_3p1
  sta $2007
  inx
  jmp load_text_3_loop
  
load_text_3p1:
  lda $2002
  lda #$2B
  sta $2006
  lda #$26
  sta $2006
  ldx #$00
  
load_text_3p1_loop:
  lda text3p1,x
  cmp #$FF
  beq load_text_3p2
  sta $2007
  inx
  jmp load_text_3p1_loop
  
load_text_3p2:
  lda $2002
  lda #$2B
  sta $2006
  lda #$46
  sta $2006
  ldx #$00
  
load_text_3p2_loop:
  lda text3p2,x
  cmp #$FF
  beq wait_for_not_talk
  sta $2007
  inx
  jmp load_text_3p2_loop
  
wait_for_not_talk:
  lda text
  cmp #$03
  bne wait_for_not_talk
  
  lda #$00
  sta talk
  
 ; Now we clear all the text
 
clear_text1:
  lda $2002
  lda #$2B
  sta $2006
  lda #$06
  sta $2006
  
  jsr clear_text
  
  lda $2002
  lda #$2B
  sta $2006
  lda #$26
  sta $2006
  
  jsr clear_text
  
  lda $2002
  lda #$2B
  sta $2006
  lda #$46
  sta $2006
  
  jsr clear_text
  
  lda #$01
  sta can_move
  
loop1:
  lda #$01
  sta can_print_lifes
  
game_loop_level0:
  jsr hit_and_remove
  lda level
  cmp #$01
  bne game_loop_level0
  
  lda #$00
  sta $2001
  
load_level_2:
  ldx #$00
  ldy #$00
  lda $2002
  lda #$28
  sta $2006
  stx $2006
  
  lda #LOW(level2)
  sta pointerLo
  lda #HIGH(level2)
  sta pointerHi
  
load_level_2_loop:
  lda [pointerLo],y
  sta $2007
  iny
  cpy #$00
  bne load_level_2_loop
  inc pointerHi
  inx
  cpx #$04
  bne load_level_2_loop
  
  lda #%00011110
  sta $2001
  
load_ennemie1: ; First ennemie
  ldx #$00
load_ennemie1_loop:
  lda ennemie1,x
  sta $0230,x
  inx
  cpx #32
  bne load_ennemie1_loop
  
game_loop_level1:
  jsr hit_and_remove
  lda level
  cmp #$02
  bne game_loop_level1
  jsr move_ennemie1
  
  jmp *
  
move_ennemie1:
  rts
  
hit_and_remove:
  lda is_hiting
  cmp #$01
  bne l
  ldy #$00
  
hit_wait:
  lda frame_counter
hit_delay:
  cmp frame_counter
  beq hit_delay
  iny
  cpy #30
  bne hit_wait
  
  jsr remove_hit
l
  rts
  
clear_text:
  ldx #$00
cloop:
  lda #$FF
  sta $2007
  inx
  cpx #23
  bne cloop
  rts
  
nmi:
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  
  lda pause
  cmp #$01
  bne move_ennemie1_level1
  
  lda #$00
  sta $2005
  sta $2005
  rti 
  
move_ennemie1_level1:
  lda level
  cmp #$01
  bne s
  
  ; Move algorithm
  lda $200
  adc #48
  cmp $230
  bcc .next
  lda $203
  adc #48
  cmp $233
  bcc .next
  jsr ennemie1_move_right
  jmp .next2
.next:
  lda $200
  sbc #48
  cmp $230
  bcs .next2
  lda $203
  sbc #48
  cmp $233
  bcs .next2
  jsr ennemie1_move_left
  
.next2:
  lda $200
  sta $230
  lda $200+4
  sta $230+4
  lda $200+8
  sta $230+8
  lda $200+12
  sta $230+12
  lda $200+16
  sta $230+16
  lda $200+20
  sta $230+20
  lda $200+24
  sta $230+24
  lda $200+28
  sta $230+28
s:
  lda $207
  cmp #$FF
  bne print_lifes_condition
  
  inc level
  jsr goto_main_position
  
print_lifes_condition:  
  lda can_print_lifes
  cmp #$00
  beq animate_talk
  
print_life_string:
  lda $2002
  lda #$28
  sta $2006
  lda #$40
  sta $2006
  ldx #$00

print_life_string_loop:
  lda text_lifes,x
  cmp #$FF
  beq load_lifes_init
  sta $2007
  inx
  jmp print_life_string_loop
  
load_lifes_init:
  lda $2002
  lda #$28
  sta $2006
  lda #$48  
  sta $2006
  
load_lifes:
  lda lifes
  lsr a
  lsr a
  lsr a
  lsr a
  adc #'0'
  sta $2007
  
  lda $2002
  lda #$28
  sta $2006
  lda #$49
  sta $2006
  
  lda lifes
  and #%00001111
  adc #'0'
  sta $2007
  
animate_talk:  
  lda talk
  cmp #$01
  bne controllers
  
  lda frame_counter
  and #$10
  bne talk2
  
talk1:
  lda $2002
  lda #$2B
  sta $2006
  lda #$62
  sta $2006
  
  lda #$91
  sta $2007
  lda #$92
  sta $2007
  jmp controllers
talk2:
  lda $2002
  lda #$2B
  sta $2006
  lda #$62
  sta $2006
  
  lda #$94
  sta $2007
  lda #$95
  sta $2007
  
controllers:
  lda #$01
  sta $4016
  lda #$00
  sta $4016
  lda #$00
  sta is_moving
  
a_pressed:
  lda $4016
  and #$01
  beq a_finish
  
  lda a_button
  cmp #$00
  bne b_pressed
  
  lda #$01
  sta a_button
  
  lda state
  cmp #$FF
  bne .next
  
  lda #$01
  sta palette_style
  lda #$01
  sta state
  
  jmp b_pressed
.next:
  lda talk
  cmp #$01
  bne b_pressed
  
  lda text
  cmp #$03
  beq b_pressed
  
  inc text
  
  jmp b_pressed
  
a_finish:
  lda #$00
  sta a_button

b_pressed:
  lda $4016
  and #$01
  beq b_finish
  
  lda b_button
  cmp #$00
  bne s_pressed
  
  lda #$01
  sta b_button
  
  lda state
  cmp #$FF
  bne .next
  lda #$02
  sta palette_style
  lda #$01
  sta state
  jmp s_pressed
.next:
  lda can_move
  cmp #$01
  bne s_pressed
  
  lda is_moving
  cmp #$00
  bne s_pressed
  
  jsr hit
  
  jmp s_pressed
  
b_finish:
  lda #$00
  sta b_button
  
s_pressed:
  lda $4016
  and #$01
  beq s_finish
  
  lda select
  cmp #$00
  bne t_pressed
  
  lda #$01
  sta select
  
  lda state
  cmp #$00
  bne .next
  
  lda #$FF
  sta state
  
  jmp t_pressed
  
.next:
  lda can_move
  cmp #$01
  bne s_finish
  
  lda $21C
  cmp #$4F
  bne t_pressed
  
  lda is_hiding
  cmp #$01
  bne hide
  
show:
  lda #$00
  sta is_hiding
  jsr front_bkg
  jmp t_pressed
  
hide:
  lda #$01
  sta is_hiding
  jsr behind_bkg
  jmp t_pressed
  
s_finish:
  lda #$00
  sta select
t_pressed:
  lda $4016
  and #$01
  beq t_finish
  
  lda start
  cmp #$01
  beq u_pressed
  
  lda #$01
  sta start
  
  lda state
  cmp #$01 ; Game
  beq game_start_button
  
  lda can_press_t
  cmp #$01
  bne u_pressed
  
  lda state
  cmp #$00
  bne u_pressed
  
  lda #$01 ; Game
  sta state
  jmp u_pressed
  
game_start_button:
  lda pause
  cmp #$00
  bne unpause
 
set_pause:
  lda #$01
  sta pause
  jmp u_pressed
  
unpause:
  lda #$00
  sta pause
  jmp u_pressed
  
t_finish:
  lda #$00
  sta start

u_pressed:
  lda $4016
  and #$01
  beq u_finish
  
  lda can_move
  cmp #$01
  bne u_finish
  
  lda is_hiding
  cmp #$00
  bne u_finish
  
  lda #$01
  sta is_moving
  jsr move_up
  
u_finish:
d_pressed:
  lda $4016
  and #$01
  beq d_finish
  
  lda can_move
  cmp #$01
  bne d_finish

  lda is_hiding
  cmp #$00
  bne d_finish
  
  lda #$01
  sta is_moving
  jsr move_down
  
d_finish:
l_pressed:
  lda $4016
  and #$01
  beq l_finish
  
  lda can_move
  cmp #$01
  bne l_finish
  
  lda is_hiding
  cmp #$00
  bne l_finish
  
  lda #$01
  sta is_moving
  jsr move_left
  
l_finish:
r_pressed:
  lda $4016
  and #$01
  beq r_finish
  
  lda can_move
  cmp #$01
  bne r_finish
  
  lda is_hiding
  cmp #$00
  bne r_finish
  
  lda #$01
  sta is_moving
  jsr move_right
  
r_finish:

  lda run_intro
  cmp #$01
  beq background_scrolling

  
no_background_scrolling:
  lda #$00
  sta scrollX
  sta scrollY
  jmp set_background_scroll
  
background_scrolling:
  inc scrollY
  jmp set_background_scroll

set_background_scroll:
  lda scrollX
  sta $2005
  lda scrollY
  sta $2005  
inc_frame_counter:
  inc frame_counter
  rti
  
move_up:
  lda $21C
  cmp #$4F
  bne .move
  rts
.move:
  dec $200
  dec $204
  dec $208
  dec $20C
  dec $210
  dec $214
  dec $218
  dec $21C
  dec $220
  dec $224
  rts
  
move_down:
  lda level
  cmp #$00
  bne check_down_collision_2
  lda $21C
  cmp #$A8
  bne mov_down
  rts
check_down_collision_2:
  lda $21C
  cmp #$E0
  bne mov_down
  rts
mov_down:
  inc $200
  inc $204
  inc $208
  inc $20C
  inc $210
  inc $214
  inc $218
  inc $21C
  inc $220
  inc $224
  rts
move_left:
  lda #'L' ; Left
  sta direction
  
  lda is_hiting
  cmp #$00
  bne .move
  
  jsr flip ; Flip
  
  lda #$01
  sta $201
  lda #$00
  sta $205
  lda #$03
  sta $209
  lda #$02
  sta $20D
  lda #$05
  sta $211
  lda #$04
  sta $215
  lda #$07
  sta $219
  lda #$06
  sta $21D
  
  lda $203
  cmp #$00
  bne .move
  
  rts
  
.move:
  dec $203
  dec $207
  dec $20B
  dec $20F
  dec $213
  dec $217
  dec $21B
  dec $21F
  dec $223
  dec $227
  rts
move_right:
  lda #'R'
  sta direction
  
  lda is_hiting
  cmp #$00
  bne .move
 
  jsr no_flip ; No flip
  
  lda #$00
  sta $201
  lda #$01
  sta $205
  lda #$02
  sta $209
  lda #$03
  sta $20D
  lda #$04
  sta $211
  lda #$05
  sta $215
  lda #$06
  sta $219
  lda #$07
  sta $21D
  
.move:
  inc $203
  inc $207
  inc $20B
  inc $20F
  inc $213
  inc $217
  inc $21B
  inc $21F
  inc $223
  inc $227
  rts
  
hit:
  lda #$01
  sta is_hiting
  
  lda direction
  cmp #'R'
  bne hit_left
  
hit_right:
  jsr no_flip
  lda #$0E
  sta $201
  lda #$0F
  sta $205
  
  lda #$10
  sta $209
  lda #$11
  sta $20D
  
  lda #$12
  sta $211
  lda #$13
  sta $215
  
  lda #$0C
  sta $219
  lda #$0D
  sta $21D
  
  lda #$14
  sta $221
  lda #$FF
  sta $225
  rts
  
hit_left:
  jsr flip
  lda #$0F
  sta $201
  lda #$0E
  sta $205
  
  lda #$11
  sta $209
  lda #$10
  sta $20D
  
  lda #$13
  sta $211
  lda #$12
  sta $215
  
  lda #$0D
  sta $219
  lda #$0C
  sta $21D
  
  lda #$FF
  sta $221
  lda #$14
  sta $225
  
hit_end:
  rts
  
remove_hit:
  lda #$00
  sta is_hiting
  lda direction
  cmp #'R'
  bne remove_hit_left
remove_hit_right:
  jsr no_flip
  lda #$00
  sta $201
  lda #$01
  sta $205
  lda #$02
  sta $209
  lda #$03
  sta $20D
  lda #$04
  sta $211
  lda #$05
  sta $215
  lda #$06
  sta $219
  lda #$07
  sta $21D
  lda #$FF
  sta $221
  sta $225
  rts
remove_hit_left:
  jsr flip
  lda #$01
  sta $201
  lda #$00
  sta $205
  lda #$03
  sta $209
  lda #$02
  sta $20D
  lda #$05
  sta $211
  lda #$04
  sta $215
  lda #$07
  sta $219
  lda #$06
  sta $21D
  lda #$FF
  sta $221
  sta $225
  rts
  
flip:
  ; Flip
  lda $202
  ora #%01000000
  sta $202
  lda $206
  ora #%01000000
  sta $206
  lda $20A
  ora #%01000000
  sta $20A
  lda $20E
  ora #%01000000
  sta $20E
  lda $212
  ora #%01000000
  sta $212
  lda $216
  ora #%01000000
  sta $216
  lda $21A
  ora #%01000000
  sta $21A
  lda $21E
  ora #%01000000
  sta $21E
  lda $222
  ora #%01000000
  sta $222
  lda $226
  ora #%01000000
  sta $226
  rts
  
no_flip:
  ; Flip
  lda $202
  and #%10111111
  sta $202
  lda $206
  and #%10111111
  sta $206
  lda $20A
  and #%10111111
  sta $20A
  lda $20E
  and #%10111111
  sta $20E
  lda $212
  and #%10111111
  sta $212
  lda $216
  and #%10111111
  sta $216
  lda $21A
  and #%10111111
  sta $21A
  lda $21E
  and #%10111111
  sta $21E
  lda $222
  and #%10111111
  sta $222
  lda $226
  and #%10111111
  sta $226
  rts
  
front_bkg:
  lda $202
  and #%11011111
  sta $202
  lda $206
  and #%11011111
  sta $206
  lda $20A
  and #%11011111
  sta $20A
  lda $20E
  and #%11011111
  sta $20E
  lda $212
  and #%11011111
  sta $212
  lda $216
  and #%11011111
  sta $216
  lda $21A
  and #%11011111
  sta $21A
  lda $21E
  and #%11011111
  sta $21E
  lda $222
  and #%11011111
  sta $222
  lda $226
  and #%11011111
  sta $226
  rts
  
behind_bkg:
  lda $202
  ora #%00100000
  sta $202
  lda $206
  ora #%00100000
  sta $206
  lda $20A
  ora #%00100000
  sta $20A
  lda $20E
  ora #%00100000
  sta $20E
  lda $212
  ora #%00100000
  sta $212
  lda $216
  ora #%00100000
  sta $216
  lda $21A
  ora #%00100000
  sta $21A
  lda $21E
  ora #%00100000
  sta $21E
  lda $222
  ora #%00100000
  sta $222
  lda $226
  ora #%00100000
  sta $226
  rts
  
goto_main_position:
  lda #100
  sta $200
  lda #8
  sta $203
  lda #100
  sta $204
  lda #16
  sta $207
  lda #108
  sta $208
  lda #8
  sta $20B
  lda #108
  sta $20C
  lda #16
  sta $20F
  lda #116
  sta $210
  lda #8
  sta $213
  lda #116
  sta $214
  lda #16
  sta $217
  lda #124
  sta $218
  lda #8
  sta $21B
  lda #124
  sta $21C
  lda #16
  sta $21F
  lda #108
  sta $220
  lda #24
  sta $223
  lda #108
  sta $224
  lda #0
  sta $227
  rts
  
ennemie1_move_up:
  dec $230
  dec $230+4
  dec $230+8
  dec $230+12
  dec $230+16
  dec $230+20
  dec $230+24
  dec $230+28
  rts
ennemie1_move_down:
  inc $230
  inc $230+4
  inc $230+8
  inc $230+12
  inc $230+16
  inc $230+20
  inc $230+24
  inc $230+28
  rts
ennemie1_move_left:
  dec $233
  dec $233+4
  dec $233+8
  dec $233+12
  dec $233+16
  dec $233+20
  dec $233+24
  dec $233+28
  rts
ennemie1_move_right:
  inc $233
  inc $233+4
  inc $233+8
  inc $233+12
  inc $233+16
  inc $233+20
  inc $233+24
  inc $233+28
  rts
  
  .bank 1
  .org $E000
  
;--Palettes--;
palette1:
  .incbin "palette1.pal"
palette2:
  .incbin "palette2.pal"
  ; Sprite palette:
  .db $0F,$1D,$01,$36
  
gb_palette:
  .db $0A,$1A,$2A,$3A
  .db $0A,$1A,$2A,$3A
  .db $0A,$1A,$2A,$3A
  .db $0A,$1A,$2A,$3A
  
  .db $0A,$1A,$2A,$3A
bt_palette:
  .db $0F,$30,$30,$30
  .db $0F,$1D,$30,$30
  .db $0F,$1D,$1D,$30
  .db $0F,$30,$1D,$30
  
  .db $0F,$1D,$1D,$30
  
;--Sprites--;
player:
  ; $0200
  .db 100,$00,$00,8  ; Head 1
  ; $0204
  .db 100,$01,$00,16 ; Head 2
  
  ; $0208
  .db 108,$02,$00,8  ; Torso 1
  ; $020C
  .db 108,$03,$00,16 ; Torso 2
  
  ; $0210
  .db 116,$04,$00,8  ; Belly 1
  ; $0214
  .db 116,$05,$00,16 ; Belly 2
  
  ; $0218
  .db 124,$06,$00,8   ; Legs 1
  ; $021C
  .db 124,$07,$00,16  ; Legs 2
  
  ; $0220
  .db 108,$FF,$00,24  ; Arm 1
  ; $0224
  .db 108,$FF,$00,0   ; Arm 2
  
ennemie1:
  ; $0230
  .db 90,$15,$00,200
  .db 90,$16,$00,208
  
  .db 98,$17,$00,200
  .db 98,$18,$00,208
  
  .db 106,$19,$00,200
  .db 106,$1A,$00,208
  
  .db 114,$1B,$00,200
  .db 114,$1C,$00,208

;--Backgrounds--;
credits:
  .incbin "credits.nam"
main_menu:
  .incbin "main_menu.nam"
intro:
  .incbin "binary.nam"
  
settings_bkg:
  .incbin "settings.nam"
  
; Levels:
level1:
  .incbin "level1.nam"
level2:
  .incbin "level2.nam"
  
;--Other--;
text1:
  .db " Hello John.",$FF
text2:
  .db " You're actually in the",$FF
text2p1:
  .db " island Cocos, in Costa",$FF
text2p2:
  .db " Rica. There are robots",$FF
text3:
  .db " who want to destroy   ",$FF
text3p1:
  .db " the humantity! You    ",$FF
text3p2:
  .db " must beat them. Bye.  ",$FF
  
text_lifes:
  .db " LIFES: ",$FF
  
  .org $FFFA
  .dw nmi
  .dw reset
  .dw 0 ; IRQ
  
  .bank 2
  .incbin "bkg_tiles.chr"
  .incbin "spr_tiles.chr"