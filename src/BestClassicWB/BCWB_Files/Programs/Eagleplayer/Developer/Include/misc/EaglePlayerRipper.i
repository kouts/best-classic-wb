**
**  $Filename: misc/EaglePlayerRipper.i
**  $Release: 2.00 $
**  $Revision: 1$
**  $Date: 24/02/97$
**
** Definitions and Macros for creating EaglePlayer Rippermodules
**
**	(C) Copyright 1993-97 by DEFECT
**	    All Rights Reserved
**
**

	IFND	EAGLEPLAYERRIPPER_I
EAGLEPLAYERRIPPER_I	SET	1


	IFND EXEC_PORTS_I
	    INCLUDE "exec/ports.i"
	ENDC

	IFND EXEC_TYPES_I
	    INCLUDE "exec/types.i"
	ENDC

	IFND UTILITY_TAGITEM_I
	    INCLUDE "utility/tagitem.i"
	ENDC


RIPPERVERSION EQU	1			;Current Version of Ripper

*------------------------------ Rippertags --------------------------------*
RPT_TagBase	EQU	TAG_USER+"ER"


	ENUM	RPT_TagBase		;EaglePlayer-TagBase

	EITEM	RPT_Formatname
	EITEM	RPT_Ripp1		;Ptr to Ripp Pass1
					* Input: a0=Adr (start of memory)
					*	 d0=Size (size of memory)
					*	 a1=current adr
					*	 d1=(a1.l)
					* Output:d0=Error oder NULL
					*	 d1=Size
					*	 a0=Startadr (data)
			*#####################################################
			*Attention!!! Don't change th following registers:
			*	  d3-d7/a3-a6 !!!!!!!!!!!!!!!!!!!!!!!
			*
			*#####################################################
	EITEM	RPT_Ripp2		;Ptr to Ripp Pass2
	EITEM	RPT_Ripp3		;Ptr to Ripp Pass3
	EITEM	RPT_ExtRipp		;for Samplesearch (not implemented)

	EITEM	RPT_Version		;Version of Ripper
	EITEM	RPT_RequestRipper	;Requested Version of Eagleripper
	EITEM	RPT_EagleBase
	EITEM	RPT_Creator
	EITEM	RPT_Flags
	EITEM	RPT_Next		* Ptr to next Rippertaglist
	EITEM	RPT_GetModulename	* Output: a0=Ptr to name
	EITEM	RPT_Playername		* needed Player (in EP:Eagleplayers)
	EITEM	RPT_Prefix		* Prefix for Playerbatch
	EITEM	RPT_ExtSave		* Saves extended data

	;end of Ripperdefinition





*-------------------------------- Ripperheader -------------------------------*
RIPPERHEADER MACRO
	moveq	#-1,d0				; this should return an error
	rts					; in case someone tried to
						; run it
	dc.l	\1				; Ptr to Taglist
	dc.b	"EP_RIPPERMODULE",0		; identifier
	ENDM


	ENDC	; EAGLEPLAYERRIPPER_I



*------------------- Ripperstruct (returned bei EUT_Ripp) --------------------*
	STRUCTURE EagleRipper,0
	APTR	ERPSS_Position			*while ripping
	APTR	ERPSS_MemStart			*Start ripping
	ULONG	ERPSS_MemSize			*Size ripping
	APTR	ERPSS_Segment			*Start of first Segment
	APTR	ERPSS_CurrentSegmentPosition
	APTR	ERPSS_CurrentSegmentSize
	APTR	ERPSS_Tags
	APTR	ERPSS_Formatname
	APTR	ERPSS_Modulename
	APTR	ERPSS_Comment
	APTR	ERPSS_FilePtr			*current Adr
	LONG	ERPSS_FileSize
	LONG	ERPSS_FileNr
	LONG	ERPSS_EngineNr			*filled by Eagleplayer
	LONG	ERPSS_FormatId			*private for Ripper
	LONG	ERPSS_Ripperstruct		*private for Ripper
	LONG	ERPSS_Private1			*private for Ripper
	LONG	ERPSS_Private2			*private for Ripper
	LONG	ERPSS_Private3			*private for Ripper
	LABEL	ERPSS_SizeOf			*to be extended!

