*-----------------------------------------------------------------------------*
*			Formatloader for RAW				      *
*-----------------------------------------------------------------------------*
			incdir	include:
			include	misc/eagleplayerformatloader.i
			include	exec/exec_lib.i
			
	FORMATHEADER	TAGS

	dc.b	"RAW Formatloader V1.0",10
	dc.b	"done by Eagleeye/DFT 28.02.97",0
	even

Tags:		dc.l	FL_Formatname,Formatname
		dc.l	FL_Playername,Playername
		dc.l	FL_Version,1<<16!0
		dc.l	FL_Creator,Creator
		dc.l	FL_Flags,FLF_FrequencyVariable
		dc.l	FL_DefFreqPtr,FreqPtr
		dc.l	FL_SampleType,FLST_8BitRAW
		dc.l	FL_NumChannells,1
		dc.l	0


FreqPtr:	dc.l	10000
Creator:	dc.b	"???, adapted by DEFECT",0
Playername:	dc.b	"AIFF",0
Formatname:	dc.b	"RAW 8Bit-Mono",0
