;
;   ***** SYSTEM SUBROUTHINE *****
;
STBY	EQU	41C8H	;	Z-80 Standby & Key Restart Set
INT     EQU	41A2H	;	Interupt Code Set
Z80END	EQU	409AH	;	Z-80 Control End
LORE    EQU 40C6H	;   Load All Reg ster From Stack
SARE	EQU	40B6H	;	Save All Reslster Into Stack
ERROR	EQU	428DH	;	Display Of Error Code
;
INKEY	EQU	43A3H	;	Inkey (Scan & Key Data Input)
PUTKEY	EQU	4391H	;	Put Key
GETKEY	EQU	4090H	;	Get key
KEYIN	EQU	4352H	;	Key	In (Load Of Input Key Data)
DEKEY	EQU	40A1H	;	Decode Of Key Data
KDISP1	EQU	413BH	;	Key	Dlsplay1
KDISP2	EQU	4152H	;	Key	Dlsplay2
KDISP3	EQU	4169H	;	Key	Dlsplay3
KALDIS	EQU	4112H	;	Key	Of All Display (1-3	Page)
KHYP23	EQU	4115H	;	Key	Of 2-3 Page Display
KHYPI	EQU	41F3H	;	Key Of 1 Page Display
KHYP2	EQU	41F7H	;	Key Of 2 Page Display
KHYP3	EQU	41FBH	;	Key Of 3 Page Display
;
MUSIC	EQU	42AEH	;	Music
TIMER	EQU	5FE8H	;	Soft Timer (CS ADD --> 411BH)
RSOUT	EQU	4320H	;	RS-232C Output
RSIN	EQU	4310H	;	RS-232C Input
RSVERD	EQU	42E0H	;	Verify Of RS-232C Input	Data(1)
RSVERI	EQU	42E5H	;	Verify Of RS-232C Input	Data(2)
;
HYOGI	EQU	4106H	;	Display Of All Page
HY0123	EQU	4109H	;	Display Of 1-3 Page
HYO23	EQU	410CH	;	Display Of 2-3 Page
HYO0	EQU	421AH	;	Display	Of 0 Page
HYO1	EQU	422IH	;	Display	Of 1 Page
HYO2	EQU	4228H	;	Display	Of 2 Page
HYO3	EQU	422FH	;	Display	Of 3 Page
WHIAL	EQU	426AH	;	Display	Clear Of All Page
WHI01	EQU	4257H	;	Display	Clear Of 0-1 Page
WHI23	EQU	4281H	;	Display	Clear Of 2-3 Page
WHI0	EQU	4247H	;	Display	Clear Of 0 Page
WHI1	EQU	425AH	;	Display	Clear Of 1 Page
WHI2	EQU	4263H	;	Display	Clear Of 2 Page
WHI3	EQU	4284H	;	Display	Clear Of 3 Page
ASCII	EQU	40D0H	;	ASCII Convert (0-9)
ACIBC	EQU	4081H	;	ASCII Convert By BCD
BUFCL	EQU	43C1H	;	Character Buffer Clear
DISPCL	EQU	43B6H	;	Display Buffer Clear
CHARA	EQU	4041H	;	Charactor Of Display
DISP	EQU	41ICH	;	Transfer Dot RAM <—	VRAM
;
CONVT1	EQU	5A31H	;	Number Convert (ASCII<—HEX)
CONVT2	EQU	5BC7H	;	Character Convert (ASCII<—HEX)
ADDNUM	EQU	589FH	;	FPACC<--ABCDE+FPACC
SUBNUM	EQU	58A8H	;	FPACC<--ABCDE-FPACC
MULTPL	EQU	572BH	;	FPACC<--ABCDE*FPACC
DIVIDE	EQU	57C6H	;	FPACC<--ABCDE/FPACC
NEGSIN	EQU	5720H	;	FPACC<--0-FPACC
INVERT	EQU	5F66H	;	FPACC<--1/FPACC
RANDOM	EQU	5F70H	;	FPACC<--Random Number
;
;   ***** SYSTEM WORK AREA *****
;
FTPAD	EQU	0BFABH	;	File Data Top Address
FEDAD	EQU	0BFADH	;	File Data End Address
FLNGT	EQU	0BFAFH	;	Lengh Of Record
FRDCT	EQU	0BFB0H	;	Nunber Of Record
SAHL	EQU	0BFB2H	;	Stack Area HL reg.
INTSET	EQU	0BFB4H	;	Interupt Set Area
KEYBU	EQU	0BFB5H	;	Key Data Buffer reg.
ALFLAG	EQU	0BFB6H	;	Alarm Flag
INTBF	EQU	0BFB7H	;	1/64HZ Jump Table
INTFL	EQU	0BFB9H	;	Interupt flag
VRAM	EQU	0BFBAH	;	V-RAM Address
DBUFF	EQU	0BFE4H	;	Graphic Display Buffer Address
DBUFF0	EQU	DBUFF	;	Page 0 Address
DBUFF1	EQU	DBUFF0+7	;	Page 1 Address
DBUFF2	EQU	DBUFF1+7	;	Page 2 Address
DBUFF3	EQU	DBUFF2+7	;	Page 3 Address
;
;   ***** USER WORK AREA *****
;
FPACC	EQU	0BF70H	; Floating Acc. Top Address
CHRBUF  EQU	0BF75H	; Character Code Buffer Top Address
;
;	***** I/O ADDRESS *****
;
STW     EQU	0010H	;	1/10 1/100 sec	Data Input
WA1     EQU	0030H	;	Watch Data Input sec
WA2     EQU	0031H	;	Watch Data Input min
WA3     EQU	0032H	;	Watch Data Input hour
WA4     EQU	0033H	;	Watch Data Input A/P & week
WA5     EQU	0034H	;	Watch Data Input day
WA6     EQU	0035H	;	Watch Data Input month
WA7     EQU	0036H	;	Watch Data Input year
PKEYIN	EQU	0040H	;	Key Data Input
PMUSIC  EQU	0050H	;	Music data Output
PINKEY	EQU	0060H	;	Inkey (Scan & Data)
PEND	EQU	00E0H	;	Z-80 Mode End
