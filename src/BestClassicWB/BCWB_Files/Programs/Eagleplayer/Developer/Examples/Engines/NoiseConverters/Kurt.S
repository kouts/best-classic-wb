*-----------------------------------------------------------------------------*
*			Noiseconverter V1.0				      *
*				Kurt					      *
*-----------------------------------------------------------------------------*
			incdir	include:
			include	misc/eagleplayerconverter.i
			include	exec/exec_lib.i
			
	CONVERTERHEADER	TAGS

	dc.b	"Noiseconverter-Kurt V1.0",10
	dc.b	"done by Eagleeye/DFT 28.02.97",0
	even

Tags:		dc.l	CV_Convertername,Convertername
		dc.l	CV_Convert,Convert
		dc.l	CV_RequestConverter,1
		dc.l	CV_Version,1<<16!0
		dc.l	CV_Creator,Creator
		dc.l	0


Creator:	dc.b	"???, adapted by DEFECT",0
Convertername:	dc.b	"Kurt",0
		even

*-----------------------------------------------------------------------------*
* Input: a0=Adr der Datei
*	 d0=Size der Datei
* Output:d0=ConvertSize oder NULL
*	 d1=Flags
*	 d2=Memsize or NULL
*	 a0=ConvertAdr
*	 a1=Formatname
*	 a2=SamplePtr (für Protrackerclones) oder NULL
Convert:	move.l	a0,a4
		cmp.l	#"KURT",$438(a0)
		bne.s	.Error
		move.l	#"M.K.",$438(a0)
		move.l	d0,d5

		bsr.w	BerechPattern
		move.l	d0,d6

		move.l	#1024/4,d4		;are Longwords)
		mulu	d6,d4
		subq.l	#1,d4
		lea	$43c(a4),a1
		lea	Temp(pc),a2
		lea	My_Periods(pc),a3
.Prun_Change:	move.l	(a1),(a2)
		move.b	(a2),d2			;Samplenummer
		moveq	#0,d3
		move.b	1(a2),d3		;Nummer des Period-Wertes
		add.w	d3,d3			;da Worte
		move.w	(a3,d3.w),d3		;Periode holen
		move.w	d3,(a2)			;sichern
		move.b	d2,d3
		and.b	#$f0,d2
		or.b	d2,(a2)
		lsl.b	#4,d3
		and.b	#$f0,d3
		or.b	d3,2(a2)
		move.l	(a2),(a1)+
		dbf	d4,.Prun_Change

		move.l	a4,a0
		move.l	d5,d0
		moveq	#0,d1
		sub.l	a2,a2
		lea	Convertername(pc),a1
		moveq	#0,d2				;kein neuer Mem
		tst.l	d0
		rts

.Error:		moveq	#0,d0
		rts

Temp:		dc.l	0
*-----------------------------------------------------------------------------*
BerechPattern:	movem.l	d1-a6,-(a7)
BerechPattern3:	lea	$3B8(a0),a1		;Patternnummern
		moveq	#$7F,d2
		moveq	#0,d0
.NR_Check2:
		cmp.b	(A1)+,d0
		bge.s	.hi
		move.b	-1(a1),d0
.hi		dbf	d2,.NR_Check2
		addq.w	#1,d0
		movem.l	(a7)+,d1-a6
		rts

My_Periods:
Pro_Myperiods	dc.w	0
ProPC_Periods
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113
	dc.w	$6b,$5f,$55,$50,$47,$477,$2fb,$23b,$11e,0
