*-----------------------------------------------------------------------------*
*			Noiseconverter V1.0				      *
*-----------------------------------------------------------------------------*
			incdir	include:
			include	misc/eagleplayerconverter.i
			include	exec/exec_lib.i
			
	CONVERTERHEADER	TAGS

	dc.b	"Noiseconverter-Example V1.0",10
	dc.b	"done by Eagleeye/DFT 28.02.97",0
	even

Tags:		dc.l	CV_Convertername,Convertername
		dc.l	CV_Convert,Convert
		dc.l	CV_RequestConverter,1
		dc.l	CV_Version,1<<16!0
		dc.l	CV_Next,EXAM2
		dc.l	0


Convertername:	dc.b	"Example",0
Formatname:	dc.b	"Noissi",0
		even

*-----------------------------------------------------------------------------*
* Input: a0=Adr der Datei
*	 d0=Size der Datei
* Output:d0=ConvertSize oder NULL
*	 d1=Flags
*	 d2=Memsize
*	 a0=ConvertAdr
*	 a1=Formatname
*	 a2=SamplePtr (für Protrackerclones) oder NULL
Convert:	move.l	a0,a3
		cmp.l	#"EXAM",$438(a3)
		bne.s	.Error
		move.l	d0,d4
		move.l	#$10001,d1
		add.l	#SecurityMem,d0			;Memdrauf muss sein!!!
		move.l	4,a6
		jsr	_LVOAllocMem(a6)
		tst.l	d0
		beq.s	.Error
		move.l	d0,a4
		move.l	d0,a1
		move.l	d4,d1
.CopyIt:	move.b	(a3)+,(a1)+
		subq.l	#1,d1
		bne.s	.CopyIt
		move.l	a4,a0
		move.l	#"M.K.",$438(a4)
		move.l	d4,d0
		move.l	d4,d2
		add.l	#SecurityMem,d2
		moveq	#0,d1
		sub.l	a2,a2
		lea	Formatname(pc),a1
		tst.l	d0
		rts

.Error:		moveq	#0,d0
		rts

*-----------------------------------------------------------------------------*
*-----------------------------------------------------------------------------*
*-----------------------------------------------------------------------------*
Exam2:		dc.l	CV_Convertername,Convertername2
		dc.l	CV_Convert,Convert2
		dc.l	CV_RequestConverter,1
		dc.l	CV_Version,1<<16!1
		dc.l	0


Convertername2:	dc.b	"Example2",0
Formatname2:	dc.b	"Noissi2",0
		even


*-----------------------------------------------------------------------------*
* Input: a0=Adr der Datei
*	 d0=Size der Datei
* Output:d0=ConvertSize oder NULL
*	 d1=Flags
*	 d2=Memsize
*	 a0=ConvertAdr
*	 a1=Formatname
*	 a2=SamplePtr (für Protrackerclones) oder NULL
Convert2:	move.l	a0,a3
		cmp.l	#"EXA2",$438(a3)
		bne.s	.Error
		move.l	d0,d4
		move.l	#$10001,d1
		add.l	#SecurityMem,d0			;Memdrauf muss sein!!!
		move.l	4,a6
		jsr	_LVOAllocMem(a6)
		tst.l	d0
		beq.s	.Error
		move.l	d0,a4
		move.l	d0,a1
		move.l	d4,d1
.CopyIt:	move.b	(a3)+,(a1)+
		subq.l	#1,d1
		bne.s	.CopyIt
		move.l	a4,a0
		move.l	#"M.K.",$438(a4)
		move.l	d4,d0
		move.l	d4,d2
		add.l	#SecurityMem,d2
		moveq	#0,d1
		sub.l	a2,a2
		lea	Formatname2(pc),a1
		tst.l	d0
		rts

.Error:		moveq	#0,d0
		rts
