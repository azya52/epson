;   
;	T-Rex game
;
	PORG                            equ 0B816h
	STBY                            equ 41C8h
	GETKEY                          equ	4090H
	
	scrWidth                        equ 42

	defaultDelayCactus              equ 15
	minDelayCactus                  equ 38
	additionDelayCactus             equ minDelayCactus-8
	maxCactusWidth                  equ 13
	
	trexWidth						equ 11
	jumpTrajectorySize				equ 13
	
	org PORG
	
main:
	db 0
	db " T-REX "
	db "by azya"
	jr newGame
	db 0
	dw main
	dw prgend-main

newGame:
	ld hl, 0
	ld (score), hl
	call drawScore
	ld hl, TrexDefault
	ld (TrexSpriteCur), hl
	ld hl, jumpTrajectorySize
	ld (jumpTrajectoryPos), hl
	ld hl, defaultDelayCactus
	ld (cactusShift), hl
	ld hl, screenData1
	ld de, screenData1+1
	ld (hl),0
	ld bc, scrWidth*2-1
	ldir
	call drawTrexOnBkg
	call updateScreenAndKeyScan
waitKey:
	call GETKEY
	JP Z,waitKey

mainLoop:
	ld hl, counter
	inc (hl)

	call shiftClouds
	call shiftCactuses
	call updateTrex
	call drawTrexOnBkg
	jp nz, gameOver
	call updateTrexFoot
	call addScore
	call updateScreenAndKeyScan
	CP 1
	jp Z, jumpTrex
	CP 68
	jp Z, tiltTrex
	
	ld hl,  TrexDefault
	ld (TrexSpriteCur), hl
	jp mainLoop
	
tiltTrex:
	ld a, (jumpTrajectoryPos)
	cp jumpTrajectorySize
	jp c, mainLoop
	ld hl,  TrexTilt
	ld (TrexSpriteCur), hl
	jp mainLoop

jumpTrex:
	ld a, (jumpTrajectoryPos)
	cp jumpTrajectorySize
	jp c, mainLoop
	sub a
	ld (jumpTrajectoryPos), a
	jp mainLoop
	
updateScreenAndKeyScan: 
	in a,(0x20)  ;comment to fast but truble
	ld de, 0xFF40
	ld hl,screenData3
    ld bc, scrWidth
	in a,(0x22)
    ldir
	
	ld e, 0x00
	ld c, trexWidth
	ld hl,ScreenTrexAndBkg2
    in a,(0x22)
	ldir
	ld c, scrWidth-trexWidth
	ld hl,screenData2+trexWidth
	ldir
	
	ld e, 0x00
	ld c, trexWidth
	ld hl,ScreenTrexAndBkg1
	in a,(0x21)
	ldir
	ld c, scrWidth-trexWidth
	ld hl,screenData1+trexWidth
	ldir

	ld e, 0x40
	ld c, trexWidth
    ld hl,ScreenTrexAndBkg0
	in a,(0x21)
	ldir
	ld c, scrWidth-trexWidth
	ld hl,screenData0+trexWidth
    ldir

	in a,(0x40)
	ld c, a
	in a,(0x00)
	ld a, c
	ret
	
gameOver:
	call updateScreenAndKeyScan
	call STBY
	jp newGame
	
shiftCactuses:
	ld bc, (speed)
	ld hl, screenData1
	add hl, bc
	ld de, screenData1
	ld bc, scrWidth*2
	ldir
	
	ld a, (speed)
	ld b, a
	ld iy, screenData1
main_dec:
	dec iy
	djnz main_dec
	ld b, a
main_addCharacterBytes:
	call cactusUpdate
	ld (iy+scrWidth), a
	ld (iy+scrWidth*2), d
	inc iy
	djnz main_addCharacterBytes
	ret
	
cactusUpdate:
	ld hl, cactusShift
	ld a, (hl)
	cp minDelayCactus
	jp c, cactus_copyCheckBounds
cactus_new:
	call xrnd
	rra
	jp c, cactus_addDelayForNewChar
	ld (hl), 0
	and 01110000b
	ld (cactus), a	
	jp cactus_copyCheckBounds
cactus_addDelayForNewChar:
	ld (hl), additionDelayCactus
cactus_copyCheckBounds:
	inc (hl)
	ld a, (hl)
	cp maxCactusWidth
	jp c, cactus_copyNextByte
	sub a
	ld d, a
	ret
cactus_copyNextByte:
	ld hl, (cactus)
	ld de, cactuses-1
	add hl, de
	ld de, (cactusShift)
	add hl, de
	ld a, (cactus)
	cp 01110000b
	jp c, cactus_bottom_line
	ld a, (hl)
	ld d, 0
	ret
cactus_bottom_line:	
	ld d, (hl)
	sub a
	ret
	
shiftClouds:
	ld hl, screenData0+1
	ld de, screenData0
	ld bc, scrWidth-1
	ld a, (de)
	ldir
	ld (de), a
	ret
	
updateTrex:
	ld a, (jumpTrajectoryPos)
	cp jumpTrajectorySize
	ret z
updateTrex_shift:
	ld hl, (jumpTrajectoryPos)
	add hl, hl
	ld de, jumpTrajectory
	add hl, de
	ld e, (hl)
	inc hl
	ld d, (hl)
	ld (TrexSpriteCur), de
	ld hl, jumpTrajectoryPos
	inc (hl)
	ret

updateTrexFoot:
	ld a, (jumpTrajectoryPos)
	cp jumpTrajectorySize
	ret nz
	ld hl, ScreenTrexAndBkg0+trexWidth*2+2
	ld de, ScreenTrexAndBkg0+trexWidth*2+5
	ld a, (counter)
	and 00000010b
	jp z, updateTrexFoot_accept
	ex de, hl
  updateTrexFoot_accept:
	ld a, (hl)
	and 11111110b
	ld (hl), a
	inc hl
	ld a, (hl)
	and 11111110b
	or 00000010b
	ld (hl), a

	ld a, (de)
	or 00000001b
	ld (de), a
	inc de
	ld a, (de)
	and 11111101b
	or 00000001b
	ld (de), a
	ret
	
drawTrexOnBkg:	
	ld de, ScreenTrexAndBkg0
	ld hl, screenData0
	ld bc, trexWidth
	ldir
	ld hl, screenData1
	ld bc, trexWidth
	ldir
	ld hl, screenData2
	ld bc, trexWidth
	ldir

	ld hl, ScreenTrexAndBkg0
	ld de, (TrexSpriteCur)
	ld b, trexWidth
  drawTrex:
	ld a, (de)
	or (hl)
	ld (hl), a
	inc hl
	inc de
	djnz drawTrex

	ld b, trexWidth*2
	ld c, 0
  drawTrexAndChkCollision:
	ld a, (de)
	and (hl)
	or c
	ld c, a
	ld a, (de)
	or (hl)
	ld (hl), a
	inc hl
	inc de
	djnz drawTrexAndChkCollision
	ld a, c
	and a
	ret
	
xrnd:
	ld a, 1
	ld c, a 
	rrca
	rrca
	rrca
	xor 0x1f
	add a, c
	sbc a, 255
	ld (xrnd+1), a
	ret
	
addScore:
	ld a, (counter)
	and 00000001b
	ret z
	ld b, 0 
	ld a, (score)
	inc a
	daa
	ld (score), a
	ld a, (score+1)
	adc a, b
	daa
	ld (score+1), a
drawScore:
	ld b,0            
	ld de, screenData3+13
	ld a, (score+1)
	call drawDigitWithSRL
	ld a, (score+1)
	call drawDigit
	ld a, (score)
	call drawDigitWithSRL
	ld a, (score)
	call drawDigit
	ret
	
drawDigitWithSRL:	
	RRA
	RRA
	RRA
	RRA
drawDigit:
	and 0x0F
	ld hl, digit0
	ld c,a   
	add a, a
	add a, c
	ld c, a
	add hl,bc
	ld c, 3
	ldir
	inc de
	ret
	
ScreenTrexAndBkg0:
	db 0,0,0,0,0,0,0,0,0,0,0
ScreenTrexAndBkg1:
	db 0,0,0,0,0,0,0,0,0,0,0
ScreenTrexAndBkg2:
	db 0,0,0,0,0,0,0,0,0,0,0
	
screenData0:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0x08,0x14,0x14,0x14,0x24,0x44,0x44,0x44,0x24,0x14,0x14,0x08,0,0,0,0,0
screenData1:
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
screenData2:	
	db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
screenData3:	
	db 0x84,0x8C,0x9C,0x8C,0x84,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80
	db 0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x90,0x98,0x9C,0x98,0x90
	
cactuses:
cactus0:
	db 0x18,0x04,0x7F,0x08,0x30,0,0,0,0,0,0,0,0,0,0,0
	
cactus1:
	db 0x38,0x04,0x7F,0x08,0x30,0x08,0x7F,0x04,0x18,0,0,0,0,0,0,0
	
cactus2:
	db 0x18,0x04,0x7F,0x08,0x34,0x0F,0x74,0x08,0x7F,0x08,0x30,0,0,0,0,0
	
cactus3:
	db 0x78,0x0C,0xFF,0xFF,0x18,0x70,0,0,0,0,0,0,0,0,0,0
	
cactus4:
	db 0x78,0x0C,0xFF,0xFF,0x18,0x70,0x18,0xFF,0x18,0x70,0,0,0,0,0,0

cactus5:
	db 0x78,0x0C,0xFF,0xFF,0x18,0x74,0x0F,0x34,0x18,0xFF,0x18,0x70,0,0,0,0
	
bird0:
	db 0x10,0x10,0x30,0x38,0x0C,0x7C,0x3C,0x1C,0x0C,0x08,0,0,0,0,0,0
	
bird1:
	db 0x04,0x04,0x0C,0x0E,0x03,0x1F,0x0F,0x07,0x03,0x02,0,0,0,0,0,0
		
cactus:
	dw 00
	
cactusShift:
	dw 0
	
TrexSpriteCur:	
	dw TrexDefault
	
TrexJump2:
	db 0x00,0x00,0x00,0x00,0x01,0x07,0x0B,0x0F,0x0F,0x07,0x00
	db 0x60,0x30,0x7C,0xF4,0xF0,0xFC,0xC4,0x60,0x00,0x00,0x00

TrexTilt:
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	db 0x10,0x18,0x1F,0x1D,0x1C,0x1F,0x1D,0x28,0x3C,0x3C,0x1C
	
TrexJump3:
	db 0x01,0x00,0x01,0x03,0x07,0x1F,0x2F,0x3D,0x3C,0x1C,0x00
	db 0x80,0xC0,0xF0,0xD0,0xC0,0xF0,0x10,0x80,0x00,0x00,0x00
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
		
TrexJump4:
	db 0x03,0x01,0x03,0x07,0x0F,0x3F,0x5E,0x7B,0x78,0x38,0x00
	db 0x00,0x80,0xE0,0xA0,0x80,0xE0,0x20,0x00,0x00,0x00,0x00
	
TrexJump1:
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	db 0x06,0x03,0x07,0x0F,0x1F,0x7F,0xBC,0xF6,0xF0,0x70,0x00
	db 0x00,0x00,0xC0,0x40,0x00,0xC0,0x40,0x00,0x00,0x00,0x00
	
TrexJump5:
	db 0x06,0x03,0x07,0x0F,0x1F,0x7F,0xBC,0xF6,0xF0,0x70,0x00
	db 0x00,0x00,0xC0,0x40,0x00,0xC0,0x40,0x00,0x00,0x00,0x00
	
TrexDefault:
	db 0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
	db 0x00,0x00,0x00,0x00,0x00,0x01,0x02,0x03,0x03,0x01,0x00
	db 0x18,0x0C,0x1F,0x3D,0x7C,0xFF,0xF1,0xD8,0xC0,0xC0,0x00
	
	
jumpTrajectory:
	dw TrexJump1,TrexJump2,TrexJump3,TrexJump4,TrexJump5,TrexJump5,TrexJump5,TrexJump5,TrexJump4,TrexJump3,TrexJump2,TrexJump1,TrexDefault
	
jumpTrajectoryPos:
	dw jumpTrajectorySize
	
counter:
	db 0
	
score:
	dw 0
	
speed:
	dw 2
	
digit0:
	db 10111110b
	db 10100010b
	db 10111110b
digit1:
	db 10010010b
	db 10111110b
	db 10000010b
digit2:
	db 10101110b
	db 10101010b
	db 10111010b
digit3:
	db 10100010b
	db 10101010b
	db 10111110b
digit4:
	db 10111000b
	db 10001000b
	db 10111110b
digit5:
	db 10111010b
	db 10101010b
	db 10101110b
digit6:
	db 10111110b
	db 10101010b
	db 10101110b
digit7:
	db 10100000b
	db 10101110b
	db 10110000b
digit8:
	db 10111110b
	db 10101010b
	db 10111110b
digit9:
	db 10111010b
	db 10101010b
	db 10111110b
	
prgend:
	end