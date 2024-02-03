**
**  $Filename: misc/EaglePlayerSamplesaver.i
**  $Release: 2.00 $
**  $Revision: 1$
**  $Date: 24/02/97$
**
** Definitions and Macros for creating EaglePlayer Samplesavers
**
**	(C) Copyright 1993-97 by DEFECT
**	    All Rights Reserved
**
**

	IFND	EAGLEPLAYERSAMPLESAVER_I
EAGLEPLAYERSAMPLESAVER_I	SET	1


	IFND EXEC_PORTS_I
	    INCLUDE "exec/ports.i"
	ENDC

	IFND EXEC_TYPES_I
	    INCLUDE "exec/types.i"
	ENDC

	IFND UTILITY_TAGITEM_I
	    INCLUDE "utility/tagitem.i"
	ENDC

	IFND	EAGLEPLAYER_I
		INCLUDE "Misc/EaglePlayer.i"
	ENDC


SAMPLESAVERVERSION EQU	1		;Current Version of Samplesaver


*------------------------------ Samplesaver --------------------------------*
SS_TagBase	EQU	TAG_USER+"SS"


	ENUM	SS_TagBase		;EaglePlayer-TagBase

	EITEM	SS_Formatname
	EITEM	SS_Version		;Version of external Samplesaver
	EITEM	SS_EagleBase
	EITEM	SS_RequestSampleSaver	;Requested Version of Samplesaver
	EITEM	SS_Creator
	EITEM	SS_Flags
	EITEM	SS_SaveSample		;Input: a0=EP_Sampletable (see eagleplayer.i)
					;	a1=Path of File
					;	a2=Ptr to Saveprogram
					;Output:d0=EPR_Error oder NULL
	EITEM	SS_RAWFlags		;what raw does the saver need? USIF-Flags
					;EPS_Structure
	EITEM	SS_DefFreqPtr
	EITEM	SS_NextSamplesaver
	EITEM	SS_Description
	EITEM	SS_DescriptionLNr		;Localemr in Samplesavercatalog

	;end of Samplesaverdefinition



*- Flags -*
	BITDEF	SS,FrequencyVariable,0

**- RAWFlags -*
*	BITDEF	SSS,8Bit,0
*	BITDEF	SSS,16Bit,1
*	BITDEF	SSS,Interleaved,2
*	BITDEF	SSS,Unsigned,3
*	BITDEF	SSS,Intel,4
*




*----------------------------- Samplesaverheader -----------------------------*
SAMPLESAVERHEADER MACRO
	moveq	#-1,d0				; this should return an error
	rts					; in case someone tried to
						; run it
	dc.l	\1				; Ptr to Taglist
	dc.b	"EP_SAMPLESAVER",0,0		; identifier
	ENDM


	ENDC	; EAGLEPLAYERSAMPLESAVER

