*-----------------------------------------------------------------------------*
*			Samplesaver for RAW-Sounds			      *
*-----------------------------------------------------------------------------*
			incdir	include:
			include	misc/eagleplayersamplesaver.i
			include	exec/exec_lib.i
			
	SAMPLESAVERHEADER	TAGS8

	dc.b	"RAW 8Bit-Mono Samplesaver V1.0",10
	dc.b	"done by Eagleeye/DFT 28.02.97",0
	even

AllMore:	dc.l	SS_Version,1<<16!0
		dc.l	SS_Creator,Creator
		dc.l	SS_SaveSample,SaveSample
		dc.l	SS_Flags,SSF_FrequencyVariable
		dc.l	0

Tags8:		dc.l	Tag_More,AllMore
		dc.l	SS_Formatname,Formatname8
		dc.l	SS_RAWFlags,USIB_8Bit
		dc.l	SS_DefFreqPtr,FreqPtr8
		dc.l	SS_NextSampleSaver,Tags8U
		dc.l	SS_DescriptionLNr,43
		dc.l	0

Tags8U:		dc.l	Tag_More,AllMore
		dc.l	SS_Formatname,Formatname8U
		dc.l	SS_RAWFlags,USIB_8Bit!USIB_Unsigned
		dc.l	SS_DefFreqPtr,FreqPtr8U
		dc.l	SS_NextSampleSaver,Tags16
		dc.l	0

Tags16:		dc.l	Tag_More,AllMore
		dc.l	SS_Formatname,Formatname16
		dc.l	SS_RAWFlags,USIB_16Bit
		dc.l	SS_DefFreqPtr,FreqPtr16
		dc.l	SS_NextSampleSaver,Tags16I
		dc.l	0

Tags16I:	dc.l	Tag_More,AllMore
		dc.l	SS_Formatname,Formatname16I
		dc.l	SS_RAWFlags,USIB_16Bit!USIB_Intel
		dc.l	SS_DefFreqPtr,FreqPtr16I
		dc.l	SS_NextSampleSaver,Tags16U
		dc.l	0

Tags16U:	dc.l	Tag_More,AllMore
		dc.l	SS_Formatname,Formatname16U
		dc.l	SS_RAWFlags,USIB_16Bit!USIB_Unsigned
		dc.l	SS_DefFreqPtr,FreqPtr16U
		dc.l	SS_NextSampleSaver,Tags16UI
		dc.l	0

Tags16UI:	dc.l	Tag_More,AllMore
		dc.l	SS_Formatname,Formatname16UI
		dc.l	SS_RAWFlags,USIB_16Bit!USIB_Unsigned!USIB_Intel
		dc.l	SS_DefFreqPtr,FreqPtr16UI
		dc.l	SS_DescriptionLNr,44
		dc.l	0


FreqPtr8:	dc.l	22000
FreqPtr8U:	dc.l	22000
FreqPtr16:	dc.l	22000
FreqPtr16I:	dc.l	22000
FreqPtr16U:	dc.l	22000
FreqPtr16UI:	dc.l	22000

Creator:	dc.b	"Pure sampled data, adapted by DEFECT",0
Formatname8:	dc.b	"RAW 8Bit-Mono",0
Formatname8U:	dc.b	"RAW 8Bit-Mono Unsigned",0
Formatname16:	dc.b	"RAW 16Bit-Mono ",0
Formatname16I:	dc.b	"RAW 16Bit-Mono Intel",0
Formatname16U:	dc.b	"RAW 16Bit-Mono Unsigned",0
Formatname16UI:	dc.b	"RAW 16Bit-Mono Unsigned Intel",0
		even

*-----------------------------------------------------------------------------*
* Input: a0=Adr der EP_SampleTabelle
*	 a1=Pfad
*	 a2=Jump to Saveroutine
* Output:d0=Error oder NULL
*-----------------------------------------------------------------------------*
SaveSample:	moveq	#EPR_ErrorInArguments,d7
		move.l	a0,a4
		moveq	#0,d6
		move.l	EPS_Adr(a4),d0
		beq.s	.Return
		move.l	d0,a0
		move.w	EPS_Type(a4),d0
		bne.s	.Return
		move.l	EPS_Length(a4),d0
		beq.s	.Return

		*-- Input: a0=Start of Memdata
		*--	   d0=Size of Mem
		*--	   a1=Pfad des Files
		*-- Output:d0=Error oder NULL
		jsr	(a2)
		move.l	d0,d7
.Return:	move.l	d7,d0
		tst.l	d0
		rts

