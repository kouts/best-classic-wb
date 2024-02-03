**
**  $Filename: misc/EaglePlayerFormatLoader.i
**  $Release: 2.00 $
**  $Revision: 1$
**  $Date: 24/02/97$
**
** Definitions and Macros for creating EaglePlayer Formatloadermodules
**
**	(C) Copyright 1993-97 by DEFECT
**	    All Rights Reserved
**
**

	IFND	EAGLEPLAYERFORMATLOADER_I
EAGLEPLAYERFORMATLOADER_I	SET	1


	IFND EXEC_PORTS_I
	    INCLUDE "exec/ports.i"
	ENDC

	IFND EXEC_TYPES_I
	    INCLUDE "exec/types.i"
	ENDC

	IFND UTILITY_TAGITEM_I
	    INCLUDE "utility/tagitem.i"
	ENDC


FORMATLOADERVERSION EQU	1		;Current Version of Formatloader


*---------------------------- Formatloadertags -------------------------------*
FL_TagBase	EQU	TAG_USER+"FL"


	ENUM	FL_TagBase		;EaglePlayer-TagBase

	EITEM	FL_Formatname
	EITEM	FL_Playername		;player to be used
	EITEM	FL_Version		;Version of external Formatloader
	EITEM	FL_EagleBase
	EITEM	FL_RequestFormatLoader	;Requested Version of Formatloadermain
	EITEM	FL_Creator
	EITEM	FL_Flags
	EITEM	FL_SampleType
	EITEM	FL_DefFreqPtr
	EITEM	FL_NumChannells
	EITEM	FL_Memtype

	;end of formatloaderdefinition



*- Flags -*
	BITDEF	FL,FrequencyVariable,0
	BITDEF	FL,Interleaved,1
	BITDEF	FL,MiSoundsystem,2	;MI_Soundsystem=real Name of Format



*- Sampletypes -*
FLST_8BitRAW		EQU	1
FLST_8BitUnsignedRaw	EQU	2
FLST_16BitRAW		EQU	3
FLST_16BitUnsignedRAW	EQU	4
FLST_16BitIntel		EQU	5
FLST_16BitIntelUnsigned	EQU	6



*-------------------------------- Formatheader -------------------------------*
FORMATHEADER MACRO
	moveq	#-1,d0				; this should return an error
	rts					; in case someone tried to
						; run it
	dc.l	\1				; Ptr to Taglist
	dc.b	"EP_FORMATMODULE",0		; identifier
	ENDM


	ENDC	; EAGLEPLAYERFORMATLOADER_I

