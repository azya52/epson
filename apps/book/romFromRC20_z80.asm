;   *rs232c*
;   transfer rom content by rs232c.
;
	;maclib z80
	porg    equ 0b816h
	whial   equ 426ah
	dispb   equ 0bfe4h
	hyogi   equ 4106h
	hyo0    equ 421ah
	getkey  equ 4090h
	z80end  equ 409ah
	baud    equ 08h ;2400
	rsout   equ 4320h
	kdisp3  equ 4169h
	
	org porg

main:
	db 0
	db "rs232c        "

start:
	call whial
	ld hl, data1
	ld de, dispb
	ld bc, 28
	ldir
	call hyogi
	
loop1:
	call getkey
	cp 34h
	jp nz,loop1
	ld hl, data2
	ld de, dispb
	ld bc, 7
	ldir
	call hyo0

loopy:
	call kdisp3
	call getkey
	jr z, loopy
	cp 1
	jr z, ln00
	cp 2
	jr z, ln01
	cp 3
	jr z, ln02
	cp 4
	jr z, ln03
	cp 5
	jr z, ln04
	cp 6
	jr z, ln05
	cp 11h
	jr z, ln06
	cp 12h
	jr z, ln07
	jr loopy
ln00:
	ld a,'0'
	ld hl,4000h
	jr loop2
ln01:
	ld a,'1'
	ld hl,4400h
	jr loop2
ln02:	
	ld a,'2'
	ld hl,4800h
	jr loop2
ln03:
	ld a,'3'
	ld hl,4c00h
	jr loop2
ln04:
	ld a,'4'
	ld hl,5000h
	jr loop2
ln05:
	ld a,'5'
	ld hl,5400h
	jr loop2
ln06:
	ld a,'6'
	ld hl,5800h
	jr loop2
ln07:
	ld a,'7'
	ld hl,5c00h
	
loop2:
	ld (work),hl 
	ld (dispb+6), a
	call hyo0
	ld hl,(work)
	ld de, buff
	ld bc, 0400h
	ldir
	call output
	jp start
	
output:
	ld a, baud
	ld hl, buff
	ld de, buff+0400h-1
	call rsout
	ret

data1:
	db "*data transfer start ok?    "
data2:
	db "*mode= "
work:
	dw 0
buff:
	ds 0
	end
