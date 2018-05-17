* = $c000

;show titlepic
jsr titlepic
;main prg 
lda#$12   ;charset to $0800
sta$d018
jsr$e544  ;clear screen
lda#$00
sta$d020
sta$d021
;screen
scorestart
ldx#$00
scorecp
lda screen,x
sta$0400,x 
lda screen+$100,x
sta$0500,x
lda screen+$200,x
sta$0600,x
lda screen+$300,x
sta$0700,x 
dex
cpx #$00
bne scorecp
;sprite pointer
lda #$80
sta $07f8 ;0
lda #$81
sta $07f9 ;1
lda #$82
sta $07fa ;2
lda #$82
sta $07fb ;3
lda #$82
sta $07fc ;4
lda #$82
sta $07fd ;5
lda #$82
sta $07fe ;6
lda #$82
sta $07ff ;7
lda #$ff 
sta $d015 ;sprites on 
sta $d01c ;multicolor on 
lda #$07
sta $d025 ;colorsprite
lda #$04
sta $d026 ;colorsprite
lda #$02
sta $d027 ;colorsprite
;sprites x - y 
lda #$20
sta $d000 ;sprite 1
lda#$84
sta $d001 ;sprite 1
lda#$f0
sta $d004 ;sprite 2
sta $d006 ;sprite 3
sta $d008 ;sprite 4
sta $d00a ;sprite 5
sta $d00c ;sprite 6
sta $d00e ;sprite 7
lda#$32
sta $d005 ;sprite2 
lda#$56
sta $d007 ;sprite3 
lda#$7a
sta $d009 ;sprite4
lda#$9e
sta $d00b ;sprite5
lda#$c2
sta $d00d ;sprite6
lda#$e5
sta $d00f ;sprite7
;----------------------------------------------
;irq player by richard
             sei
             lda #<irq
             ldx #>irq
             sta $314
             stx $315
             lda #$1b
             ldx #$00
             ldy #$7f 
             sta $d011
             stx $d012
             sty $dc0d
             lda #$01
             sta $d01a
             sta $d019 ; ACK any raster IRQs
             lda #$00
             jsr $1000 ;Initialize Richard's music
             cli
hold         jmp loop ;We don't want to do anything else here. :)
              
irq
             lda #$01
             sta $d019 ; ACK any raster IRQs
             jsr $1006 ;Play the music
             jmp $ea31
;----------------------------------------------
loop

;                    sprite2
lda setsprite2store
cmp #$01
beq sprite2up
lda $d005
cmp#$e6
beq setsprite2
inc $d005
jmp sprite3check 
sprite2up
lda $d005
cmp #$31
beq setsprite2
dec $d005
jmp sprite3check 
setsprite2
lda setsprite2store
cmp#$00
bne setsprite2a
lda #$01
sta setsprite2store
jmp sprite3check
setsprite2a
lda #$00
sta setsprite2store
jmp sprite3check
;                    sprite3
sprite3check
lda setsprite2store+1
cmp #$01
beq sprite3up
lda $d007
cmp#$e6
beq setsprite3
inc $d007
jmp sprite4check
sprite3up
lda $d007
cmp #$31
beq setsprite3
dec $d007
jmp sprite4check
setsprite3
lda setsprite2store+1
cmp#$00
bne setsprite3a
lda #$01
sta setsprite2store+1
jmp sprite4check
setsprite3a
lda #$00
sta setsprite2store+1
jmp sprite4check
;                       sprite4
sprite4check
lda setsprite2store+2
cmp #$01
beq sprite4up
lda $d009
cmp#$e6
beq setsprite4
inc $d009
jmp sprite5check 
sprite4up
lda $d009
cmp #$31
beq setsprite4
dec $d009
jmp sprite5check 
setsprite4
lda setsprite2store+2
cmp#$00
bne setsprite4a
lda #$01
sta setsprite2store+2
jmp sprite5check
setsprite4a
lda #$00
sta setsprite2store+2
jmp sprite5check
;                       sprite5 
sprite5check
lda setsprite2store+3
cmp #$01
beq sprite5up
lda $d00b
cmp#$e6 
beq setsprite5
inc $d00b
jmp sprite6check 
sprite5up
lda $d00b
cmp #$31
beq setsprite5
dec $d00b
jmp sprite6check 
setsprite5
lda setsprite2store+3
cmp#$00
bne setsprite5a
lda #$01
sta setsprite2store+3
jmp sprite6check
setsprite5a
lda #$00
sta setsprite2store+3
jmp sprite6check
;                       sprite6
sprite6check
lda setsprite2store+4
cmp #$01
beq sprite6up
lda $d00d
cmp#$e6
beq setsprite6
inc $d00d
jmp sprite7check 
sprite6up
lda $d00d
cmp #$31
beq setsprite6
dec $d00d
jmp sprite7check 
setsprite6
lda setsprite2store+4
cmp#$00
bne setsprite6a
lda #$01
sta setsprite2store+4
jmp sprite7check
setsprite6a
lda #$00
sta setsprite2store+4
jmp sprite7check
;                       sprite7
sprite7check
lda setsprite2store+5
cmp #$01
beq sprite7up
lda $d00f
cmp#$e6
beq setsprite7
inc $d00f
jmp loop000
sprite7up
lda $d00f
cmp #$31
beq setsprite7
dec $d00f
jmp loop000
setsprite7
lda setsprite2store+5
cmp#$00
bne setsprite7a
lda #$01
sta setsprite2store+5
jmp loop000
setsprite7a
lda #$00
sta setsprite2store+5
jmp loop000
;-------------------------
setsprite2store: !byte $00,$00,$00,$00,$00,$00


loop000:
lda l3      ;sprite1 an? 
cmp #$01
bne loop00
lda $d01e
ror
ror
;cmp #$02
bcc loop01
jmp treffer ;shot hit
loop01
inc $d002   ;shot forward
lda $d002
cmp#$00
bne loop00
lda#$00     ;shot reach end
sta l3
lda #$fd
sta $d015
;           loop slow down sprites
loop00  
ldy#$00    
ldx#$00
loop0
lda$0400,x
inx
bne loop0 
iny
cpy #$06      ;sprites speed
bne loop0

;             joystick up
lda$dc00
cmp#$7e 
bne loop2

ldx#$00
loop1a
lda$0400,x
inx
bne loop1a

lda$d001
cmp#$31
beq loopjmp
dec$d001
loopjmp:
jmp loop
;             joystick down
loop2
cmp#$7d
bne loop3

ldx#$00
loop2a
lda$0400,x
inx
bne loop2a

lda $d001
cmp #$e6
beq loopjmp
inc $d001
bne loopjmp
;             fire
loop3
cmp #$6f
bne loopjmp 
lda l3      ;sprite1 an? 
cmp #$01
beq loopjmp 
lda shots
cmp#$30
beq shots1
dec shots
jmp shotsende
shots1
lda shots-1
cmp#$30
beq shotsgameover
dec shots-1
lda #$39
sta shots
jmp shotsende
shotsgameover
jmp gameover
shotsende
ldx #$00
loop3a
lda $0400,x
inx
bne loop3a
lda#$01
sta l3
lda $d001
sta $d003
lda $d000
adc #$0d 
sta $d002 
lda #$ff
sta $d015
sta $d01c
jmp loop

l3: !byte $00



treffer:
lda#$00     ;shot hit supernova
sta l3
lda #$fd
sta $d015
inc $0400+120+38
lda $0400+120+38
cmp#$3a
bne trefferende
;                   10
lda #$30
sta $0400+120+38
inc $0400+120+37
lda $0400+120+37
cmp #$3a
bne trefferende
;                   100
lda #$30
sta $0400+120+37
inc $0400+120+36
lda $0400+120+36
cmp #$3a
bne trefferende
;                   1000
lda #$30
sta $0400+120+36
inc $0400+120+35
lda $0400+120+35
cmp #$3a 
bne trefferende
;                   10000
lda #$30
sta $0400+120+35
inc $0400+120+34
lda $0400+120+34
;
trefferende
      jmp loop
;----------------------------------------------
titlepic
; picture viewer by TMR
; Set the VIC-II up and change bank
      lda #$3b
      sta $d011
      lda #$18
      sta $d016
      lda #$78
      sta $d018
      lda #$00
      sta $d020
      lda $8710
      sta $d021
      lda #$02  
      sta $dd00 

; Copy the colours
      ldx #$00
picture_setup   
      lda $7f40,x ;screenram
      sta $5c00,x
      lda $8040,x
      sta $5d00,x
      lda $8140,x
      sta $5e00,x
      lda $8228,x
      sta $5ee8,x
      lda $8328,x ;colorram
      sta $d800,x
      lda $8428,x
      sta $d900,x
      lda $8528,x
      sta $da00,x
      lda $8610,x
      sta $dae8,x
      inx
      bne picture_setup 

;selfcode.....
nospace:
          lda #$7f
          sta $dc00
          lda $dc01
          cmp #$ef  ;waiting for space 
          bne nospace
          jsr$fda3  ;Initialise I/O
          jsr$e5a0  ;Set I/O Defaults
          jmp $c003 ;jmp game 


;------------------data

shots    = $058e 
screen   = $24fe
gameover = $c000

*=$2000      
;sprite0    
!byte  $00,$00,$00,$00,$00,$00,$3f,$ff
!byte  $fc,$00,$3f,$00,$00,$33,$00,$00
!byte  $ff,$c0,$03,$ff,$f0,$03,$ff,$f0
!byte  $13,$ff,$f0,$17,$ff,$f8,$17,$ff
!byte  $f8,$17,$ff,$f8,$13,$ff,$f0,$03
!byte  $ff,$f0,$03,$ff,$f0,$00,$ff,$c0
!byte  $00,$33,$c0,$00,$3f,$00,$3f,$ff
!byte  $fc,$00,$00,$00,$00,$00,$00,$82


*=$2040
;sprite1 - shot 
!byte  $00,$00,$00,$00,$00,$00,$00,$00
!byte  $00,$00,$00,$00,$00,$00,$00,$00
!byte  $00,$00,$00,$00,$00,$00,$00,$00
!byte  $00,$00,$00,$00,$00,$00,$00,$1a
!byte  $aa,$00,$00,$00,$00,$00,$00,$00
!byte  $00,$00,$00,$00,$00,$00,$00,$00
!byte  $00,$00,$00,$00,$00,$00,$00,$00
!byte  $00,$00,$00,$00,$00,$00,$00,$82

*=$2080
;sprite2 - supernova
!byte  $00,$00,$00,$00,$00,$00,$00,$00
!byte  $00,$00,$3c,$00,$00,$ff,$00,$03
!byte  $d7,$c0,$03,$55,$c0,$0f,$55,$f0
!byte  $0d,$55,$70,$3d,$55,$7c,$35,$55
!byte  $5c,$3d,$55,$7c,$0d,$55,$70,$0f
!byte  $55,$f0,$03,$55,$c0,$03,$d7,$c0
!byte  $00,$ff,$00,$00,$3c,$00,$00,$00
!byte  $00,$00,$00,$00,$00,$00,$00,$81

*=$0800
!bin "charset.prg",,2  
;Future Fighter Menu Sid by Gábor Gaspar
*=$1000 
!bin "future_Fighter_menu_sid.prg",,2
*=$2500
!bin "gamescreen.bin",,2  
*=$6000    
!bin "bild7.kla",,2
