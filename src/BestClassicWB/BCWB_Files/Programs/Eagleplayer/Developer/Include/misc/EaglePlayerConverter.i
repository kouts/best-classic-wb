**
**  $Filename: misc/EaglePlayerConverter.i
**  $Release: 2.00 $
**  $Revision: 1$
**  $Date: 24/02/97$
**
** Definitions and Macros for creating EaglePlayer Noiseconvertermodules
**
**	(C) Copyright 1993-97 by DEFECT
**	    All Rights Reserved
**
**

	IFND	EAGLEPLAYERCONVERTER_I
EAGLEPLAYERCONVERTER_I	SET	1


	IFND EXEC_PORTS_I
	    INCLUDE "exec/ports.i"
	ENDC

	IFND EXEC_TYPES_I
	    INCLUDE "exec/types.i"
	ENDC

	IFND UTILITY_TAGITEM_I
	    INCLUDE "utility/tagitem.i"
	ENDC


CONVERTERVERSION EQU	1			;Current Version of Converter
SecurityMem	 EQU	2000

*------------------------------ Convertertags --------------------------------*
CV_TagBase	EQU	TAG_USER+"EC"


	ENUM	CV_TagBase		;EaglePlayer-TagBase

	EITEM	CV_Convertername
	EITEM	CV_Convert		;Ptr to ConvertCode
					* Input: a0=Adr der Datei
					*	 d0=Size der Datei
					* Output:d0=ConvertSize oder NULL
					*	 d1=Flags
					*	 d2=MemSize
					*	 a0=ConvertAdr
					*	 a1=Formatname
					*	 a2=SamplePtr (für Protrackerclones) oder NULL

	EITEM	CV_Version		;Version of Converter
	EITEM	CV_RequestConverter	;Requested Version of Noiseconverter
	EITEM	CV_EagleBase
	EITEM	CV_Creator
	EITEM	CV_Flags
	EITEM	CV_Next			* Ptr to next Convertertaglist
					* of converted module

	;end of converterdefinition



; --- various flags, returned by CV_Convert in d1

	BITDEF	CV,FreeOriginal,0		; free original data



*----------------------------- Converterheader -----------------------------*
CONVERTERHEADER MACRO
	moveq	#-1,d0				; this should return an error
	rts					; in case someone tried to
						; run it
	dc.l	\1				; Ptr to Taglist
	dc.b	"EP_CONVERTERMODULE",0,0	; identifier
	ENDM


	ENDC	; EAGLEPLAYERCONVERTER_I

