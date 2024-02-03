;*********************************************************************************************
;**                       Eagleplayer scope Engine framework                                **
;** © 1998 Defect Softworks, written by Henryk "Buggs" Richter, tfa652@cks1.uni-rostock.de  **
;**                                                                                         **
;** requirements: any Amiga with OS 2.0, (not tested yet on 68000)                          **
;**               tested with ASM-One1.28, ASM-Pro, SAS Asm, PhxAss, DevPac                 **
;**                                                                                         **
;** Basic Instructions:                                                                     **
;** - watch the "TODO" statements, there you`ll have to add own handler code                **
;** - you`ll won`t have to care about any EP internal message related stuff, this will be   **
;**   done for you                                                                          **
;** - you don`t have to care about register trashing, this is already done                  **
;** - there are a few hooks in here for you:                                                **
;**    1.  _EH_INITSCOPE:      init your setup (libraries, locks, memory etc.)              **
;**    2.  _EH_OPENWINDOW:     open your window and return a signal mask                    **
;**                            (e.g. 1<<wd_UserPort->MP_SIGBIT)                             **
;**    3.  _EH_SIGNALRECEIVED: check out the messages for the window and return user related**
;**                            commands such as "eh_windowclosed"                           **
;**    4.  _EH_CLOSEWINDOW:    close your window                                            **
;**    5.  _EH_ENDSCOPE:       free all resources                                           **
;**   *6.  _EH_NEWMODULE:      called when a new module was loaded                          **
;**   *7.  _EH_KILLMODULE:     called when the current module was ejected from memory       **
;**   *8.  _EH_STARTPLAY:      called when EP starts to play the mod                        **
;**   *9.  _EH_STOPPLAY:       called when EP stops playing the mod                         **
;**   *10. _EH_INTERRUPT:      VBlank timed callup for calling your scope`s display handler **
;**                            (callup in Task mode, you don`t have to follow the interrupt **
;**                             conventions)                                                **
;**   11.  _EH_GETCONFIG:      Eagleplayer is about to save config or quit Engine, please   **
;**                            update now your settings                                     **
;**                                                                                         **
;**   *: optional callups                                                                   **
;**                                                                                         **
;**                                                                                         **
;** general notes:                                                                          **
;**-  to fetch the data (current address, current size, volume and period) from the UPS     **
;**   structure a function called "_FetchScopeData" is provided                             **
;**-  ALL ROUTINES (especially the openwindow and cleanup ones) might be called twice so    **
;**   make sure that they are RE-ENTRANT (clear pointers of already closed libs and         **
;**   free`d memory, test if window already open and initialized)                           **
;**-  store as many as possible of your preferences in the EUS Structure so that EP can     **
;**   maintain and automatically save them (EUS_WinX, EUS_WinY, EUS_Special, EUS_Special2,  **
;**   EUS_Special3)                                                                         **
;**-  EP`s Engines almost always have got pulldown menu options for "Hide" and "Quit", for  **
;**   scopes this isn`t nessesary, "Quit" should be sufficient (or simply "CloseWindow")    **
;**-!!by a mistake the flag definitions are sometimes mangled in the Eagleplayer.i and      **
;**   EagleplayerEngine.i, please watch includes if you might need to change any Engine     **
;**   related definitions                                                                   **
;*********************************************************************************************

;---------- Macros for version entries in "$VER:"-string and EUS Structure -------------------
ver:		MACRO
		dc.b	"1.00"
		ENDM
structver:	macro
		dc.w	1,00
		endm
date:		macro
		dc.b	"17-Jul-98"
		endm
structdate:	macro
		dc.b	17,07
		dc.w	1998
		endm
;--------------------------------- General Flags -----------------------------------------------
SETINCDIR	EQU	1	;set 1 for ASM-ONE/ASM-PRO, PhxAss, DevPac

;Eagleplayer	EQU	1	;for debugging purpses only, by setting to "0"
;				;no Eagleplayer specific initializations are done
debug 		EQU	1	;for debugging purposes only, by setting to "1"
				;you may start the Engine from shell/debugger etc.

;----------------------------------- Includes -------------------------------------------------
	IFNE	SETINCDIR
	incdir	include:
	ENDC

	include	"exec/exec_lib.i"
	include	"exec/libraries.i"
	include	"exec/memory.i"
	include	"exec/execbase.i"
	include	"misc/Eagleplayer.i"
	include	"misc/EagleplayerEngine.i"
	include	"misc/BuggsMacros.i"
	;
	include	"intuition/intuition.i"
	include	"intuition/intuition_LIB.i"
	include	"graphics/graphics_lib.i"
	;
;------------------------------- some definitions ----------------------------------------------
eh_windowclosed	EQU	2
;===============================================================================================

	section	program,code

;===============================================================================================
EUS_Structure:
		bra.w	StartEngine	;jump to start of the Program, BRA.W only !
		EUSN_Identifier		;macro in EagleplayerEngine.i
		dc.l	0		;EUS_Next (don`t touch)
	IFNE	debug
		dc.w	-2
	ELSE
		dc.w	0		;EUS_EngineNr (ID of this Engine, set by EP)
	ENDC
		dc.l	0		;EUS_EPBase (Eagleplayer`s base address, set by EP)
		dc.l	0		;EUS_FreeTable
		dc.l	0		;EUS_Taskadr (Pointer to this task, set by EP)
		dc.l	0		;EUS_Unused1
		dc.l	0		;EUS_unused2
		dc.l	0		;EUS_SpecialJumpTab, private Jumptab (e.g Amplifiers)
		dc.l	Tagliste	;EUS_TagList for special extension Tags
		dc.w	0		;EUS_Ticks
		dc.w	0		;EUS_TickCounter
		dc.l	EUIB_OnlyPlay!EUIB_OnlyActive	;EUS_TickFlags
							;can also be:
							;EUIB_Always
							;
		dc.l	USMB_NewModule!USMB_KillModule!USMB_ChangeInterrupt!USMB_ChangeConfig ;eus_msgflags
		dc.l	_ENG_ScopeName	;EUS_PName, process name
		dc.l	_ENG_AuthorName	;EUS_Creator, Author`s name
		dc.l	_ENG_Info	;EUS_AboutEngine, short info text
		dc.w	37		;EUS_Kickstart, required OS Version
		dc.l	EAGLEVERSION	;EUS_EPVersion, required Eagleplayer Version, EAGLEVERSION = current
		structver		;EUS_Version
		dc.l	_ENG_EngineName	;EUS_EngineName, name of the Engine

		dc.w	268		;EUS_Winx, use it for preferences storage
		dc.w	167		;eus_winy, use it for preferences storage
		dc.w	EUSB_Openwin	;
		dc.l	0		;EUS_Special, use it for preferences storage
		dc.l	0		;EUS_Special2, use it for preferences storage
		dc.l	0		;EUS_Special3, use it for preferences storage
		structdate		;EUS_Creatordate
		dc.b	-5		;EUS_Priority, task priority
		dc.b	EUTY_Scope	;EUS_Type, see includes
		dc.w	0
		dc.l	0		;EUS_AMIDNr, for Amplifiers only
		dc.l	0		;EUS_Reserved4
		dc.l	0		;EUS_AMUPSStruct, for Amplifiers only
		dc.l	0		;EUS_Reserved6

	dc.b	"$VER: Eagleplayer Example scope "
	ver
	dc.b	" ("
	date
	dc.b	")",0

EP_PortName:	dc.b	"EAGLEPLAYERPORT",0	;Name of the port for Engines
_ENG_ScopeName	dc.b	"EP_ExampleScope.1",0	;process name followed by ".1", important for enumeration
_ENG_EngineName	dc.b	"ExampleScope",0	;engine name
_ENG_AuthorName	dc.b	"gix gax",0		;author name
_ENG_Info	dc.b	"This is a simple example Eagleplayer scope.",10
		dc.b	"You may use linefeeds for this bunch of chars but"
		dc.b	" better is a long long long text autoclipped by EP",0

	cnop	0,4
Tagliste:
;		dc.l	EUT_AttnFlags,AFF_68020!AFF_68881 ;required CPU/FPU: e.g. for 020+881
;		dc.l	EUT_AttnFlags,AFF_68020           ;                  e.g. for 68020
							  ;if EUT_AttnFlags not defined, 
							  ;68000 compatibility assumed
		dc.l	TAG_DONE,0
;-----------------------------------------------------------------------------------------------
StartEngine:
	lea	datas,a5		;private Engine data, main pointer
	bsr	InitEngine		;init messageport and data area
	tst.l	d0
	beq	FailInit

	bsr	SendFirstMessage	;register running engine in EP
	tst.l	d0
	beq	FailInit		;fail if Eagleplayer not found, shouldn`t happen

	bsr	HandleActions

FailInit
	bsr	QuitEngine

	moveq	#0,d0
	rts
;***********************************************************************************************
;**                      init scope specific stuff (libs, memory, settings etc.)              **
;***********************************************************************************************
;Input:     A5 - base register for data area (see BSS definitions at end of file), 
;                add own stuff if you like
;Output:    D0 - success, return 0 in failure case, <>0 if ok
_EH_INITSCOPE:

		;Todo: add your initialization code here

		moveq	#1,d0
		rts

;***********************************************************************************************
;**                      free scope specific stuff (libs, memory, settings etc.)              **
;***********************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
_EH_ENDSCOPE:
		;Todo: add your cleanup code here
		rts

;***********************************************************************************************
;**                           open your window and return signal mask                         **
;***********************************************************************************************
;Input:     A5   - base register for data area, add own stuff if you like
;           A0   - ULONG* SignalMask, pointer to a signal mask for your windows, screens, etc.
;                  you have to return
;Output:    D0   - success, return 0 in failure case, <>0 if ok
;           (A0) - Signal mask or 0 if no window
_EH_OPENWINDOW: 

		;Todo: open window and set signal mask
		;
		;if possible, fetch x & y position, size from EUS structure
		;
		;Pubscreen pointer can be found in EPG_Pubscreen, e.g.
		;	move.l	EUS_Structure+EUS_EPBase,d0
		;	beq	nopub
		;	move.l	d0,a1
		;	move.l	EPG_PubScreen(a1),d0
		;nopub:	move.l	d0,a1
		
		clr.l	(a0)
		moveq	#1,d0
		rts

;***********************************************************************************************
;**                      close the window(s)/screen of the scope                              **
;***********************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
;Comments:  Signal mask will be deleted automatically by Engine frame
_EH_CLOSEWINDOW:

		;Todo: close window
		
		rts

;***********************************************************************************************
;**                            Update your configuration                                       *
;***********************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
_EH_GETCONFIG:

		;Todo: save your config (preferably to EUS_Structure entries, EUS_WinX, 
		;      EUS_WinY, EUS_Special, EUS_Special2, EUS_Special3)

		rts
;***********************************************************************************************
;**             signal received, e.g. window message arrived                                  **
;***********************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;           D0 - signal mask
;Output:    D0 =  0:                no messages arrived
;           D0 =  eh_windowclosed:  window is about to get closed, notify Eagleplayer 
;                                   (don`t close window yet, !)
_EH_SIGNALRECEIVED:

		;Todo: set up your message handler

		rts

************************************************************************************************
** (optional)        called when EP starts to play the mod                                    **
************************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;           A0 - Pointer to UPS_Structure or 0 if none available
;Output:    -
_EH_STARTPLAY:

		;Todo: prepare your Engine to be able doing it`s job displaying some data

		rts

************************************************************************************************
** (optional)        called when EP stops playing the mod (pause, stop, eject module)         **
************************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
;Comments:  from this point the UPS Structure passed to EH_Startplay isn`t longer valid
_EH_STOPPLAY:

		;Todo: prevent your Engine from further accesses to UPS struct

		rts

************************************************************************************************
** (optional)        VBlank timed callup for calling your scope`s display handler             **
************************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;           A0 - Pointer to UPS_Structure or 0 if none available
;Output:    -
_EH_INTERRUPT:

		;Todo: show what you`ve got to show

		rts

;***********************************************************************************************
;** (optional)      Eagleplayer successfully loaded a new module                              **
;***********************************************************************************************
;Input:    A5 - base register for data area
;Output:   -
_EH_NEWMODULE:

		;Todo: do some initializations for a new module if you like

		rts

;***********************************************************************************************
;** (optional)      Eagleplayer ejected the current module                                    **
;***********************************************************************************************
;Input:    A5 - base register for data area
;Output:   -
_EH_KILLMODULE:

		;Todo: add your handler code if you like

		rts


		XDEF	_FetchScopeData

;-----------------------------------------------------------------------------------------------
;----------- fetch rest address, rest size, volume and period values from UPS-structure --------
;-----------------------------------------------------------------------------------------------
;Input: d0 = Channel (0...3)
;       a1 = UPS_Structure
;(       a2 = extra volume table (words, one for each channel, 0...64) ), not enabled at the moment
;
;Output:
;(         a2 = pointer to master volume for next channel (word)       ), not enabled at the moment
;         a0 = address of the sample or 0 if channel off
;         d0 = left size in Bytes
;         d1 = volume
;         d3 = period
_FetchScopeData:
		movem.l	d4/a1/a3,-(a7)
		move	d0,d1
		lsl	#2,d1
		lea	datas+Permerk,a3
		add.w	d1,a3

		suba.l	a0,a0

		move.w	UPS_Flags(a1),d1
		and.w	#UPSB_DMACon,d1		;channel  on/off supported ?
		beq.s	FSD_nodmacon

		move.w	UPS_DMACon(a1),d4	;get DMA mask
		btst	d0,d4
		beq.w	FSD_no
FSD_nodmacon
		move	d0,d1
		mulu	#UPS_Modulo,d1
		lea	(a1,d1.w),a1

		move.l	UPS_Voice1Adr(a1),d1
		beq.s	FSD_null
		move.l	d1,A0
		move.w	UPS_Voice1Per(a1),d3
		beq.s	FSD_ok
		move.w	d3,(a3)
		clr.w	2(a3)

		moveq	#0,d4
		moveq	#0,d0
		move.w	UPS_Voice1Len(a1),d0
		add.l	d0,d0		;Samplelänge Words -> Samplelänge Bytes
		bra.s	FSD_cbm_ok		;bra.s	.copyto
FSD_ok
		move	(a3),d3		;überhaupt keine Sampleperiod übergeben ?
		bne.s	FSD_copyto
FSD_null
		suba.l	a0,a0		;lea	nulls(a5),a0
		moveq	#0,d0		;move.w	#700,d0
		moveq	#0,d1
		bra.s	FSD_no
FSD_copyto
		moveq	#0,d0
		move.w	UPS_Voice1Len(a1),d0
		add.l	d0,d0		;Samplelänge Words -> Samplelänge Bytes

		moveq	#0,d4
		move.w	2(a3),d4
		cmp.w	#$180,d4	;nur zur Sicherheit
		blo.s	FSD_hi1
		clr.w	2(A3)
		clr.w	d4
FSD_hi1
		swap	d4		;=d4*65535
		lsr.l	#2,d4
		divu	(a3),d4		;durch Sampleperiod
		and.l	#$ffff,d4
		lsl.l	#2,d4
		cmp.l	d0,d4		;größer als Samplelänge ?
		blo.s	FSD_cbm_ok

		tst.w	UPS_Voice1Repeat(a1)
		beq.s	FSD_cbm_loop

		suba.l	a0,a0
		subq.w	#1,2(a3)
		clr.w	(a3)
		moveq	#0,d4
		moveq	#0,d0
		bra.s	FSD_cbm_ok
FSD_cbm_loop
		tst.l	d0
		bne.s	FSD_divu
		clr.w	2(a3)
		moveq	#0,d4
		move.w	#700,d0
		bra.s	FSD_cbm_ok
FSD_divu
		divu	d0,d4
		swap	d4
;		clr.w	2(a3)		;bloss raus lassen, dann sieht es
					;nochmal so gut aus !!
		and.l	#$ffff,d4
FSD_cbm_ok
		add.l	d4,a0			;Sampleadr
						;D0: Samplelen
						;D3: SamplePer

		move.w	UPS_Voice1Vol(a1),d1	;

;		mulu	(A2)+,d1		;Mastervolume
;		lsr.w	#6,d1			;kann normalerweise auch rausgelassen werden

		cmp	#64,d1
		bls.s	FSD_vol_ok
		moveq	#64,d1
FSD_vol_ok
		addq.w	#1,2(a3)
FSD_no
		movem.l	(a7)+,d4/a1/a3
		rts

;-----------------------------------------------------------------------------------------------
; private Engine functions

;*************************************************************************************
;*                                generic initializations                            *
;*************************************************************************************
;Input:  A5
;Output: D0 = 0 -> failure
InitEngine:
		movem.l	d1-d7/a0-a6,-(sp)

		move.l	a5,a0
		move.w	#DatasLen-1,d0
EInit_clrdata:
		clr.b	(a0)+
		dbf	d0,EInit_clrdata
	
		move.l	4,a6
		moveq	#-1,d0
		jsr	_LVOAllocSignal(a6)	;obtain a signal for EH_INTERRUPT
		move.l	d0,Mysignal(a5)
		bpl	EInit_Signal
		moveq	#0,d0
		bra.s	EInit_Error
EInit_Signal:
		jsr	_LVOCreateMsgPort(a6)	;get a message port
		move.l	d0,EngineMSGPort(a5)
		beq	EInit_Error

		suba.l	A1,A1
		JSR	_LVOFindTask(A6)
		move.l	d0,Mytask(a5)

		jsr	_EH_INITSCOPE
EInit_Error:
		movem.l	(sp)+,d1-d7/a0-a6
		rts

;*************************************************************************************
;*                                cleanup                                            *
;*************************************************************************************
;Input:  A5
;Output: -
QuitEngine:
		movem.l	d0-d7/a0-a6,-(sp)

		move.l	EngineMSGPort(a5),d0
		beq.s	EQuit_NoPort
		move.l	d0,a0
		move.l	4,a6
		jsr	_LVODeleteMsgPort(a6)
EQuit_NoPort:
		clr.l	EngineMSGPort(a5)

		move.l	Mysignal(a5),d0
		moveq	#-1,d1
		move.l	d1,Mysignal(A5)
		cmp.l	d1,d0
		beq	EQuit_NoSignal
		move.l	4,a6
		jsr	_LVOFreeSignal(a6)
EQuit_NoSignal:

		jsr	_EH_ENDSCOPE
		movem.l	(sp)+,d0-d7/a0-a6
		rts

********************************************************************
*           Init Message Structure and tell EP that we are here    *
********************************************************************
SendFirstMessage:
		movem.l	d1-d7/a0-a6,-(sp)

		move.l	4.w,a6
		lea	EP_PortName(pc),a1
		jsr	_LVOFindPort(a6)
		tst.l	d0
		beq.s	SFM_Error

		move.l	d0,a0			;Port address

		move.l	EngineMSGPort(a5),d3
		move.l	Mytask(a5),d4
		move.l	Mysignal(a5),d5
		move.w	#USClass_NewEngine,d6

	IFNE	debug
		bsr	allocmsg
		beq.s	SFM_Error
		move.l	d0,a1			;Messageadresse

		move.w	#UM_SizeOf-20,MN_LENGTH(a1)
		move.b	#NT_MESSAGE,LN_TYPE(a1) ;Message-Typ
		lea	EUS_Structure,a2
		move.l	a2,UM_Result(a1)
		move.w	#-2,UM_UserNr(a1)
		move.l	#USM_Engine,UM_Type(a1)

		move.l	d3,MN_REPLYPORT(a1)	;Portadresse,an die
						;zurückgesendet wird
		move.l	d3,UM_UserPort(a1)
		move.l	d4,UM_TaskAdr(a1)
		move.l	d5,UM_Signal(a1)
		move.w	d6,UM_Class(a1)

		move.l	4,a6
		jsr	_LVOPutMsg(a6)
	ELSE
		bsr	SendMessage
	ENDC
		movem.l	(sp)+,d1-d7/a0-a6
		moveq	#1,d0
		rts
SFM_Error:
		movem.l	(sp)+,d1-d7/a0-a6
		moveq	#0,d0
		rts
;********************************************************************************************
;*                             messages to Eagleplayer                                      *
;********************************************************************************************
;Input:  D0 - Message Class
;Output: -
SendMess:
		movem.l	d0-d7/a0-a6,-(sp)
		move.l	d0,d6

		move.l	4,a6
		lea	EP_PortName(pc),a1
		jsr	_LVOFindPort(a6)
		tst.l	d0
		beq.s	SMS_Error
		move.l	d0,a0

		move.l	EngineMSGPort(a5),d3
		move.l	Mytask(a5),d4
		move.l	Mysignal(a5),d5

		bsr	SendMessage
SMS_Error:
		movem.l	(sp)+,d0-d7/a0-a6
		rts
;********************************************************************************************
;*                             messages to Eagleplayer                                      *
;********************************************************************************************
;Inputs: A0 - Eagleplayer`s port, FindPort("EAGLEPLAYERPORT")
;        D3 - reply port of this Engine
;        D4 - this task, FindTask(NULL)
;        D5 - Signal for "EH_INTERRUPT" callup
;        D6 - Message class
SendMessage:
		movem.l	d0-d7/a0-a6,-(sp)

		bsr	allocmsg
		beq.s	SMS_Fail

		move.l	d0,a1			;Messageadresse

		move.w	#UM_SizeOf-20,MN_LENGTH(a1)
		move.b	#NT_MESSAGE,LN_TYPE(a1) ;Message-Typ
		lea	EUS_Structure,a2

		ifne	debug
		move.w	saveusernr(a5),UM_UserNr(a1)
		else
		move.w	EUS_UserNr(A2),UM_UserNr(a1)
		endc

		move.l	#USM_Engine,UM_Type(a1)

		move.l	d3,MN_REPLYPORT(a1)	;Portadresse,an die
						;zurückgesendet wird
		move.l	d3,UM_UserPort(a1)
		move.l	d4,UM_TaskAdr(a1)
		move.l	d5,UM_Signal(a1)
		move.w	d6,UM_Class(a1)

		clr.l	UM_Command(a1)
		clr.l	UM_Result(A1)
		clr.l	UM_Argstring(A1)

		move.l	4.w,a6
		jsr	_LVOPutMsg(a6)
SMS_Fail:
		movem.l	(sp)+,d0-d7/a0-a6
		rts

;*****************************************************************
allocmsg:
		movem.l	d1-d7/a0-a6,-(sp)

		move.l	4.w,a6
		moveq	#UM_SizeOf,d0
		move.l	#MEMF_PUBLIC!MEMF_CLEAR,d1
		jsr	_LVOAllocMem(A6)
		movem.l	(sp)+,d1-d7/a0-a6
		tst.l	d0
		rts

;*****************************************************************
freemsg:
		moveq	#UM_SizeOf,d0
		move.l	4.w,a6
		jsr	_LVOFreeMem(A6)
		rts

;******************************************************************************************
;*           main message handler                                                         *
;******************************************************************************************
HandleActions:
		movem.l	d0-d7/a0-a6,-(sp)

		moveq	#0,d0
HAC_Loop:
		move.l	Win_SignalMask(a5),d1
		and.l	d0,d1
		beq.s	HAC_NoWin

		move.l	d0,d7
		movem.l	d1-d7/a0-a6,-(sp)
		move.l	d1,d0			;masked Signal Set
		jsr	_EH_SIGNALRECEIVED
		movem.l	(sp)+,d1-d7/a0-a6

		cmp.l	#eh_windowclosed,d0
		bne	HAC_Win_noclose

		move.l	#USClass_DeActivate,d0
		bsr	SendMess
HAC_Win_noclose:

		move.l	d7,d0
HAC_NoWin:

		move.l	Mysignal(a5),d3
		btst	d3,d0
		beq.s	HAC_NoSig

		movem.l	d0-d7/a0-a6,-(sp)
		move.l	UPS_Structure(a5),a0
		jsr	_EH_INTERRUPT
		movem.l	(sp)+,d0-d7/a0-a6
HAC_NoSig:

		bsr	EngineMessages
		bmi	HAC_Exit

		moveq	#0,d0
		move.l	EngineMSGPort(a5),a0
		move.b	MP_SIGBIT(a0),d1
		bset	d1,d0

		move.l	Mysignal(a5),d1
		bset	d1,d0

		or.l	Win_SignalMask(a5),d0

		move.l	4,a6
		jsr	_LVOWait(a6)
		bra	HAC_Loop
HAC_Exit:
		movem.l	(sp)+,d0-d7/a0-a6
		rts

;******************************************************************************************
;*           Engine message handler                                                       *
;******************************************************************************************
;Input:  -
;Output: D0 =  0 -> ok
;        D0 = -1 -> exit program
EngineMessages:
		movem.l	d1-d7/a0-a6,-(sp)
EMS_NextMessage:				;a next message received ?
		move.l	EngineMSGPort(a5),a0
		move.l	4,a6
		jsr	_LVOGetMsg(a6)
		tst.l	d0
		beq	EMS_NoMessage
		move.l	d0,a1

		move.l	EngineMSGPort(a5),UM_UserPort(a1)
	ifne	debug
		move.w	UM_UserNr(a1),saveusernr(A5)
	else
		lea	EUS_Structure,a2
		move.w	EUS_UserNr(A2),UM_UserNr(a1)
	endc
		move.l	Mytask(a5),UM_TaskAdr(a1)
		move.l	Mysignal(a5),d1
		move.l	d1,UM_Signal(a1)

		move.w	UM_Class(a1),d3
		move.l	UM_Type(a1),d7
		move.w	UM_Signal(a1),d5
		move.l	UM_StructAdr(a1),d6
		move.l	d6,UPS_Structure(a5)

		lea	USClasstable1(pc),a3
EMS_classloop1:
		movem.l	(a3)+,d0/a0
		tst.l	d0
		beq.s	EMS_notfound1
		cmp	d3,d0
		bne.w	EMS_classloop1
		moveq	#0,d0
		movem.l	d1-d7/a0-a6,-(sp)
		jsr	(A0)			;jump into routine
		movem.l	(sp)+,d1-d7/a0-a6
		bra.w	EMS_Next
EMS_notfound1:
		move	#USClass_Dummy,UM_Class(a1)
EMS_Next:
		move.l	MN_REPLYPORT(a1),d0
		cmp.l	EngineMSGPort(a5),d0	;one of our messages ?
		beq.s	EMS_noreply
		move.l	4,a6
		jsr	_LVOReplyMsg(a6)
EMS_noreply:
		cmp.l	#USM_Eagleplayer,d7	;one of Eagleplayer`s messages ?
		beq	EMS_mess
		bsr	freemsg
EMS_mess:
		lea	USClasstable2(pc),a3
EMS_classloop2:
		movem.l	(a3)+,d0/a0
		tst.l	d0
		beq.s	EMS_notfound2
		cmp	d3,d0
		bne	EMS_classloop2
		moveq	#0,d0
		movem.l	d1-d7/a0-a6,-(sp)
		jsr	(A0)			;jump into routine
		movem.l	(sp)+,d1-d7/a0-a6
EMS_notfound2:
		tst.l	d0
		beq	EMS_NextMessage
EMS_NoMessage:
		movem.l	(sp)+,d1-d7/a0-a6
		tst.l	d0
		rts

;--------------------------------------------------------------------------------------------
;------------------------- table of message classes -----------------------------------------
; all registers may get trashed
;
; Inputs for the functions below:
;  A5 - data area
;  A1 - pointer to UM message
;  A2 - pointer to EUS structure
;
; Return of functions below:
;  according to the class UM_Class(a1) will be deleted
;
;--- table 1 for actions before replying the message
USClasstable1:
		dc.l	USClass_getconfig,EMS_ConfigPrepare
		dc.l	USClass_Exit,EMS_ExitPrepare
		dc.l	USClass_Activate,EMS_ShowWindow
		dc.l	USClass_Show,EMS_ShowWindow
		dc.l	USClass_Hide,EMS_CloseWin
		dc.l	USClass_DeActivate,EMS_CloseWin
		dc.l	USClass_KillModule,EMS_KillModule
		dc.l	USClass_NewModule,EMS_NewModule
		dc.l	USClass_StartInt,EMS_StartPlay
		dc.l	USClass_StopInt,EMS_StopPlay
		dc.l	0,0

;--- table 2 for actions after replying the Message
; Inputs for the functions below:
;  A5 - data area
;  A2 - pointer to EUS structure
;
;- Return D0 = 0  -> ok
;- Return D0 = -1 -> quit program
USClasstable2:
		dc.l	USClass_Exit,EMS_DoExit
		dc.l	0,0

;------------------------------------ the routines -------------------------------------------
EMS_ConfigPrepare:
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	_EH_GETCONFIG
		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#0,d0
		rts

EMS_ExitPrepare:
		clr.l	UM_Signal(a1)			;nix mehr da !
		clr.l	UM_TaskAdr(a1)
		move	#USClass_Dummy,UM_Class(a1)
		moveq	#0,d0
		rts
EMS_DoExit:
		bsr	EMS_StopPlay
		bsr	EMS_KillModule
		bsr	EMS_CloseWin
		moveq	#-1,d0
		rts
EMS_ShowWindow:
		move.l	EUS_Structure+EUS_EPBase(pc),a0
		move.l	EPG_SomePrefs(a0),d0
		btst	#EGPRF_Iconify,d0
		bne.s	EMSS_Iconify

		lea	Win_SignalMask(a5),a0

		movem.l	d1-d7/a0-a6,-(sp)
		jsr	_EH_OPENWINDOW
		movem.l	(sp)+,d1-d7/a0-a6

		move.l	d0,-(sp)
		tst.l	UPS_Structure(a5)
		beq	EMSS_noplay
		bsr	EMS_StartPlay
EMSS_noplay:
		move.l	(sp)+,d0

		tst.l	d0
		bne.s	EMSS_Iconify			;ok, Window opened
		move	#USClass_Dummy,UM_Class(a1)	;error: couldn`t open window
EMSS_Iconify:
		moveq	#0,d0
		rts
EMS_CloseWin:
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	_EH_CLOSEWINDOW
		movem.l	(sp)+,d0-d7/a0-a6

		clr.l	Win_SignalMask(a5)
		moveq	#0,d0
		rts
EMS_StartPlay:
		movem.l	d0-d7/a0-a6,-(sp)
		move.l	UPS_Structure(a5),a0
		jsr	_EH_STARTPLAY
		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#0,d0
		rts
EMS_StopPlay:
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	_EH_STOPPLAY
		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#0,d0
		rts
EMS_NewModule:
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	_EH_NEWMODULE
		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#0,d0
		rts
EMS_KillModule:
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	_EH_KILLMODULE
		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#0,d0
		rts

;*****************************************************************************
;*                        Data area                                          *
;*****************************************************************************

;********************** empty tables for BSS-hunk) ***************************
		section	data,BSS
datas:
	RS_RESET
;--------------------------- Engine specific stuff ---------------------------------------------
	IFNE	debug
	RS_WORD	saveusernr,1
	ENDC
	RS_LONG	EngineMSGPort,1	;Engine message port
	RS_LONG	Mysignal,1	;Signal for "EH_INTERRUPT" callup
	RS_LONG	Mytask,1	;this Task
	RS_LONG	UPS_Structure,1	;Scope structure, passed to "EH_INTERRUPT" and
				;"EH_STARTPLAY" callups if present
	RS_LONG	Permerk,4	;sampleperiod and play time 1/50s

	RS_LONG	Win_SignalMask,1 ;signal mask from belonging window(s)

;-----------------------------------------------------------------------------------------------
; add your custom data (e.g. library pointers,...) here


;-----------------------------------------------------------------------------------------------
	RS_WORD	DatasLen,0

	ds.b	DatasLen
	end
