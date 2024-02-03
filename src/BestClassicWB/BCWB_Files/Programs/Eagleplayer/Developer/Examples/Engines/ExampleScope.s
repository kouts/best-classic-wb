;*********************************************************************************************
;**                         Eagleplayer example scope Engine                                **
;** featues: uses guigfx.library for a simple truecolor monoscope display including free    **
;**          window scaling and color fading                                                **
;**                                                                                         **
;** © 1998 Defect Softworks, written by Henryk "Buggs" Richter, tfa652@cks1.uni-rostock.de  **
;**                                                                                         **
;** requirements: Amiga with OS 3.0, MC 68020 CPU                                           **
;**               tested with ASM-One1.28, ASM-Pro, SAS Asm, PhxAss, DevPac                 **
;**                                                                                         **
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
	include	"guigfx/guigfx_lib.i"
	include	"guigfx/guigfx.i"
	include	"render/render.i"
	;
;------------------------------- some definitions ----------------------------------------------
eh_windowclosed	EQU	2

;------------------------------- engine specific definitions -----------------------------------
TrueWidth	EQU	100		;width of the truecolor buffer
TrueHeight	EQU	50		;height of the truecolor buffer
MinWinWidth	EQU	100		;min. innerwidth
MinWinHeight	EQU	40		;min. innerheight

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
		dc.w	39		;EUS_Kickstart, required OS Version
		dc.l	EAGLEVERSION	;EUS_EPVersion, required Eagleplayer Version, EAGLEVERSION = current
		structver		;EUS_Version
		dc.l	_ENG_EngineName	;EUS_EngineName, name of the Engine

		dc.w	20		;EUS_Winx, default window position
		dc.w	20		;eus_winy, default window position
		dc.w	EUSB_Openwin	;
		dc.l	0		;EUS_Special, use it for preferences storage
					;Here: WindowsizeX<<16!WindowsizeY
					
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
_ENG_AuthorName	dc.b	"Henryk Richter",0	;author name
_ENG_Info	dc.b	"This is a simple example Eagleplayer scope.",10
		dc.b	"It uses guigfx.library by Timm Müller to show "
		dc.b	"up a truecolor monoscope.",0

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
		lea	ggfx_name,a1
		moveq	#11,d0			;requires V11 of ggfx
		move.l	4,a6
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,S_GGFXBase(a5)
		beq	INIT_FAIL

		lea	intui_name,a1
		moveq	#39,d0			;Kick 3.0
		move.l	4,a6
		jsr	_LVOOpenLibrary(a6)
		move.l	d0,S_IntuiBase(a5)
		beq	INIT_FAIL
INIT_OK:
		moveq	#1,d0
		rts
INIT_FAIL:
		moveq	#0,d0
		rts
;***********************************************************************************************
;**                      free scope specific stuff (libs, memory, settings etc.)              **
;***********************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
_EH_ENDSCOPE:
		move.l	S_GGFXBase(a5),d0
		beq	END_NOGGFX
		move.l	d0,a1
		move.l	4,a6
		jsr	_LVOCloseLibrary(a6)
		clr.l	S_GGFXBase(a5)
END_NOGGFX:
		move.l	S_IntuiBase(a5),d0
		beq	END_NOINT
		move.l	d0,a1
		move.l	4,a6
		jsr	_LVOCloseLibrary(a6)
		clr.l	S_IntuiBase(a5)
END_NOINT:
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
		tst.l	S_winhandle(a5)		;test if window already open
		bne	OW_WINOPEN		;if yes->just pass the correct return values

		bsr	LockPubScreen
		tst.l	d0
		beq	OW_FAIL

		bsr	OpenWindow
		tst.l	d0
		beq	OW_FAIL

		bsr	MakeDrawHandle
		tst.l	d0
		beq	OW_FAIL

OW_WINOPEN:
		move.l	S_winhandle(a5),a1
		move.l	wd_UserPort(a1),a1
		move.b	MP_SIGBIT(a1),d0
		moveq	#0,d1
		bset	d0,d1
		move.l	d1,(a0)			;Return Signal Mask for Window

OW_OK:		moveq	#1,d0
		rts
OW_FAIL:
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	_EH_CLOSEWINDOW
		movem.l	(sp)+,d0-d7/a0-a6
		clr.l	(a0)
		moveq	#0,d0
		rts

LockPubScreen:
		movem.l	d1-d7/a0-a6,-(sp)

		lea	EUS_Structure,a0
		move.l	EUS_EPBase(a0),d0
		beq	LP_NOEPBASE
		move.l	d0,a0
		move.l	EPG_PubScreen(a0),d0
LP_NOEPBASE
		move.l	d0,a0
		move.l	S_IntuiBase(a5),a6
		jsr	_LVOLockPubScreen(a6)
		move.l	d0,S_mypubscreen(a5)
		movem.l	(sp)+,d1-d7/a0-a6
		rts
		
OpenWindow:
		movem.l	d1-d7/a0-a6,-(sp)

		lea	S_mytaglist(a5),a1
		lea	EUS_Structure,a2
		move.l	#WA_Left,(a1)+
		moveq	#0,d0
		move	EUS_WinX(a2),d0			;fetch win position from EUS Structure
		move.l	d0,(a1)+

		move.l	#WA_Top,(a1)+
		move	EUS_WinY(a2),d0			;fetch win position from EUS Structure
		move.l	d0,(a1)+

		move.l	#WA_InnerWidth,(a1)+
		move	EUS_Special(a2),d0		;fetch Winsize from EUS Structure
		cmp	#MinWinWidth,d0
		bge.s	OW_WIDTHOK
		move	#MinWinWidth,d0
OW_WIDTHOK
		move.l	d0,(a1)+

		move.l	#WA_InnerHeight,(a1)+
		move	EUS_Special+2(a2),d0		;fetch Winsize from EUS Structure
		cmp	#MinWinHeight,d0
		bge.s	OW_HEIGHTOK
		move	#MinWinHeight,d0
OW_HEIGHTOK
		move.l	d0,(a1)+

		move.l	#WA_Flags,(a1)+
		move.l	#WFLG_DRAGBAR!WFLG_SIZEGADGET!WFLG_SIZEBBOTTOM!WFLG_DEPTHGADGET!WFLG_CLOSEGADGET,(a1)+

		move.l	#WA_IDCMP,(a1)+
		move.l	#IDCMP_NEWSIZE!IDCMP_CHANGEWINDOW!IDCMP_CLOSEWINDOW,(a1)+

		move.l	#WA_PubScreen,(a1)+
		move.l	S_mypubscreen(a5),a0
		move.l	a0,(a1)+

		move.l	#WA_MinWidth,(a1)+
		moveq	#0,d0
		move.b	sc_WBorLeft(a0),d0
		add.b	sc_WBorRight(a0),d0
		add	#MinWinWidth,d0
		move.l	d0,(a1)+
		move.l	#WA_MinHeight,(a1)+
		moveq	#0,d0
		move.b	sc_WBorTop(a0),d0
		add.b	sc_WBorBottom(a0),d0
		add	#MinWinHeight,d0
		move.l	d0,(a1)+

		move.l	#WA_MaxWidth,(a1)+
		move.l	#2000,(a1)+
		move.l	#WA_MaxHeight,(a1)+
		move.l	#2000,(a1)+

		move.l	#WA_AutoAdjust,(a1)+
		move.l	#1,(a1)+

		move.l	#WA_ScreenTitle,(a1)+
		lea	wintitle_name,a0
		move.l	a0,(a1)+
		move.l	#WA_Title,(a1)+
		move.l	a0,(a1)+
		move.l	#TAG_DONE,(a1)+
		clr.l	(a1)

		lea	S_mytaglist(a5),a1
		suba.l	a0,a0
		move.l	S_IntuiBase(a5),a6
		jsr	_LVOOpenWindowTagList(a6)
		move.l	d0,S_winhandle(a5)
		movem.l	(sp)+,d1-d7/a0-a6
		rts

MakeDrawHandle:
		movem.l	d0-d7/a0-a6,-(sp)

		bsr	FreeDrawHandle

		move.l	S_winhandle(a5),d0
		beq	MD_FAIL
		move.l	d0,a1

		lea	S_mytaglist(a5),a3
		move.l	#TAG_DONE,(a3)		;no special Tags

		move.l	S_mypubscreen(a5),a2
		lea.l	sc_ViewPort(a2),a2	;Viewport
		lea	vp_ColorMap(a2),a2	;Viewport.ColorMap
		move.l	wd_RPort(a1),a1		;Rastport
		suba.l	a0,a0			;no PenShareMap
		move.l	S_GGFXBase(a5),a6
		jsr	_LVOObtainDrawHandleA(a6)
		move.l	d0,S_drawhandle(a5)
		beq	MD_FAIL

		move.l	d0,a0			;drawhandle
		suba.l	a1,a1			;Tags

		move.l	#TrueWidth,d0		;Source Width
		move.l	#TrueHeight,d1		;Source Height

		moveq	#0,d2
		move.l	S_winhandle(a5),a2
		moveq	#0,d2
		move.b	wd_BorderLeft(a2),d2
		add.b	wd_BorderRight(a2),d2
		neg.w	d2
		add.w	wd_Width(a2),d2		;Window width - Border Width = Dest Width

		moveq	#0,d3
		add.b	wd_BorderTop(a2),d3
		add.b	wd_BorderBottom(a2),d3
		neg.w	d3
		add.w	wd_Height(a2),d3	;Window height - Border height = Dest Height
		subq	#1,d3

		move.l	S_GGFXBase(a5),a6
		jsr	_LVOCreateDirectDrawHandleA(a6)
		move.l	d0,S_ddrawhandle(a5)
		beq	MD_FAIL

		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#1,d0
		rts
MD_FAIL:
		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#0,d0
		rts

FreeDrawHandle:
		move.l	S_ddrawhandle(a5),d0
		beq	FD_NODDRAW
		move.l	d0,a0
		move.l	S_GGFXBase(a5),a6
		jsr	_LVODeleteDirectDrawHandle(A6)
		clr.l	S_ddrawhandle(a5)
FD_NODDRAW:
		move.l	S_drawhandle(a5),d0
		beq	FD_NODRAW
		move.l	d0,a0
		move.l	S_GGFXBase(a5),a6
		jsr	_LVOReleaseDrawHandle(A6)
		clr.l	S_drawhandle(a5)
FD_NODRAW:
		rts

;***********************************************************************************************
;**                      close the window(s)/screen of the scope                              **
;***********************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
;Comments:  Signal mask will be deleted automatically by Engine frame
_EH_CLOSEWINDOW:
		bsr	FreeDrawHandle
		bsr	MyCloseWindow
		bsr	MyUnlockPubScreen
		rts

MyUnlockPubScreen:
		move.l	S_mypubscreen(a5),d0
		beq.s	UP_NOPUB
		move.l	d0,a1
		suba.l	a0,a0
		jsr	_LVOUnlockPubScreen(a6)
		clr.l	S_mypubscreen(a5)
UP_NOPUB:
		rts
MyCloseWindow:
		move.l	S_winhandle(a5),d0
		beq.s	CW_NOWIN
		move.l	d0,a0
	;------------before closing, save the window coordinates-------------------------
		lea	EUS_Structure,a2
		move	wd_LeftEdge(a0),EUS_WinX(a2)
		move	wd_TopEdge(a0),EUS_WinY(a2)
		moveq	#0,d0
		move.b	wd_BorderLeft(a0),d0
		add.b	wd_BorderRight(a0),d0
		neg.w	d0
		add.w	wd_Width(a0),d0		;Window width - Border Width
		move	d0,EUS_Special(a2)	;=InnerWidth

		moveq	#0,d0
		move.b	wd_BorderTop(a0),d0
		add.b	wd_BorderBottom(a0),d0
		neg.w	d0
		add.w	wd_Height(a0),d0	;Window height - Border height
		move	d0,EUS_Special+2(a2)	;=InnerHeight
	;--------------------------------------------------------------------------------
		move.l	S_IntuiBase(a5),a6
		jsr	_LVOCloseWindow(a6)
		clr.l	S_winhandle(A5)
CW_NOWIN:
		rts
;***********************************************************************************************
;**                            Update your configuration                                       *
;***********************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
_EH_GETCONFIG:
		move.l	S_winhandle(a5),d0
		beq.s	GC_NOWIN
		move.l	d0,a0

		lea	EUS_Structure,a2
		move	wd_LeftEdge(a0),EUS_WinX(a2)
		move	wd_TopEdge(a0),EUS_WinY(a2)
		moveq	#0,d0
		move.b	wd_BorderLeft(a0),d0
		add.b	wd_BorderRight(a0),d0
		neg.w	d0
		add.w	wd_Width(a0),d0		;Window width - Border Width
		move	d0,EUS_Special(a2)	;=InnerWidth

		moveq	#0,d0
		move.b	wd_BorderTop(a0),d0
		add.b	wd_BorderBottom(a0),d0
		neg.w	d0
		add.w	wd_Height(a0),d0	;Window height - Border height
		move	d0,EUS_Special+2(a2)	;=InnerHeight
GC_NOWIN:
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

SR_LOOP:
		move.l	S_winhandle(a5),d0
		beq	SR_NONE
		move.l	d0,a0
		move.l	wd_UserPort(a0),a0
		move.l	4,a6
		jsr	_LVOGetMsg(a6)
		tst.l	d0
		beq	SR_NONE
		move.l	d0,a1
		move.l	im_Class(a1),d7
		jsr	_LVOReplyMsg(a6)

		cmp.l	#IDCMP_CLOSEWINDOW,d7
		bne	SR_NOCLOSE
		moveq	#eh_windowclosed,d0
		bra	SR_RETURN
SR_NOCLOSE:
		cmp.l	#IDCMP_NEWSIZE,d7
		bne	SR_NOSIZE

		bsr	MakeDrawHandle
		movem.l	d0-d7/a0-a6,-(sp)
		bsr	ShowData
		movem.l	(sp)+,d0-d7/a0-a6
		bra	SR_LOOP
SR_NOSIZE:
		bra	SR_LOOP
SR_NONE:
		moveq	#0,d0
SR_RETURN:
		rts
************************************************************************************************
** (optional)        called when EP starts to play the mod                                    **
************************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;           A0 - Pointer to UPS_Structure or 0 if none available
;Output:    -
_EH_STARTPLAY:
		move.l	a0,S_UPS(a5)

		bsr	ClearBuffer
		rts

************************************************************************************************
** (optional)        called when EP stops playing the mod (pause, stop, eject module)         **
************************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;Output:    -
;Comments:  from this point the UPS Structure passed to EH_Startplay isn`t longer valid
_EH_STOPPLAY:
		clr.l	S_UPS(a5)

		bsr	ClearBuffer
		bsr	ShowData
		rts

************************************************************************************************
** (optional)        VBlank timed callup for calling your scope`s display handler             **
************************************************************************************************
;Input:     A5 - base register for data area, add own stuff if you like
;           A0 - Pointer to UPS_Structure or 0 if none available
;Output:    -
_EH_INTERRUPT:
		tst.l	S_winhandle(a5)		;window opened ?
		beq	INT_FAIL		;no, fail

		move.l	S_UPS(a5),d0		;Scope struct ? (alternatively just check A0)
		beq	INT_FAIL		;no, fail
		move.l	d0,a1

		bsr	FadeBuffer
		
		bsr	ClearSampleBuffer
		moveq	#0,d0			;1st left
		bsr	_FetchScopeData
		bsr	FillSampleBuffer

		moveq	#3,d0			;2nd left
		bsr	_FetchScopeData
		bsr	FillSampleBuffer

		move.l	#$0000ff00,d0		;Color (green)
		bsr	ShowSampleBuffer	;draw stuff

		bsr	ClearSampleBuffer
		moveq	#1,d0			;1st right
		bsr	_FetchScopeData
		bsr	FillSampleBuffer

		moveq	#2,d0			;2nd right
		bsr	_FetchScopeData
		bsr	FillSampleBuffer

		move.l	#$00ff0000,d0		;Color (red)
		bsr	ShowSampleBuffer	;draw stuff

		bsr	ShowData
INT_FAIL:
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
;******************************************************************
;* Scope routines
;******************************************************************
ClearBuffer:	;not time critical, a slow routine is ok
		lea	TrueBuffer,a0
		move.l	#TrueWidth*TrueHeight,d0
CB_LOOP:
		clr.l	(a0)+
		subq.l	#1,d0
		bne	CB_LOOP
		rts
;		
; fade old 32 bit data by Factor 4, not very fast but hey! this is 
; an example, not a coding contest
FadeBuffer:
		lea	TrueBuffer,a0
		move.w	#TrueWidth*TrueHeight/4-1,d0
FB_Loop:
		movem.l	(a0),d1-d4
		lsr.l	#1,d1
		lsr.l	#1,d2
		lsr.l	#1,d3
		lsr.l	#1,d4
		and.l	#$007f7f7f,d1
		and.l	#$007f7f7f,d2
		and.l	#$007f7f7f,d3
		and.l	#$007f7f7f,d4
		movem.l	d1-d4,(a0)
		adda.l	#4*4,a0
		dbf	d0,FB_Loop
		rts
ShowData:
		move.l	S_winhandle(A5),d0
		beq	SD_FAIL
		move.l	d0,a0

		moveq	#0,d0
		moveq	#0,d1
		move.b	wd_BorderLeft(a0),d0	;x
		move.b	wd_BorderTop(a0),d1	;y

		move.l	S_ddrawhandle(a5),a0	;Handle (exists always when a winhandle is valid in this program)
		lea	TrueBuffer,a1		;Buffer
		suba.l	a2,a2			;Tags
		move.l	S_GGFXBase(a5),a6
		jsr	_LVODirectDrawTrueColorA(a6)	;DirectDrawTrueColorA(ddh,array,x,y,tags)(a0,a1,d0,d1,a2)
SD_FAIL:
		rts

ClearSampleBuffer:
		movem.l	d0/a1,-(sp)
		lea	SampleBuffer,a1
		moveq	#TrueWidth/2-1,d0
CSB_CLEAR:
		clr.l	(a1)+
		dbf	d0,CSB_CLEAR
		movem.l	(sp)+,d0/a1
		rts
;Input:
;         a0 = address of the sample or 0 if channel off
;         d0 = left size in Bytes
;         d1 = volume
;         d3 = period
FillSampleBuffer:
		movem.l	d0-d2/a0-a1,-(sp)

		move.l	a0,d2			;A0 = 0 ?
		beq	FSB_NO
		lea	SampleBuffer,a1

		cmp	#TrueWidth,d0
		blt.s	FSB_LESS
		moveq	#TrueWidth,d0
FSB_LESS:
		subq	#1,d0
		bmi	FSB_NO
FSB_COPY:
		;hell slow on 060 due to Pipeline stalls, please don`t do such things
		move.b	(a0)+,d2
		ext.w	d2
		muls	d1,d2
		asr	#6,d2
		add.w	d2,(a1)+
		dbf	d0,FSB_COPY
FSB_NO:
		movem.l	(sp)+,d0-d2/a0-a1
		rts
;truecolor drawing Routines
;Input: D0 = Color
ShowSampleBuffer:
		movem.l	d0-d3/a0-a1,-(sp)

		lea	SampleBuffer,a1			;max. Amplitude: 128*2=256
		lea	TrueBuffer,a0
		add.l	#TrueWidth*TrueHeight*4/2,a0	;middle of data

		move	#TrueWidth-1,d1
SSB_LOOP:
		move.w	(a1)+,d2
		muls	#TrueHeight/2,d2
		asr	#8,d2				;1<<8 = 256
		muls	#TrueWidth*4,d2			;width of one line
		or.l	d0,(a0,d2.l)
		addq.l	#4,a0
		dbf	d1,SSB_LOOP

		movem.l	(sp)+,d0-d3/a0-a1
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
		add.l	d1,a1

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
		dc.l	USClass_GetConfig,EMS_ConfigPrepare
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
EMS_ConfigPrepare:
		movem.l	d0-d7/a0-a6,-(sp)
		jsr	_EH_GETCONFIG
		movem.l	(sp)+,d0-d7/a0-a6
		moveq	#0,d0
		rts
;*****************************************************************************
;*                        Data area                                          *
;*****************************************************************************

		section	stuff,DATA
ggfx_name:	dc.b	"guigfx.library",0
intui_name:	dc.b	"intuition.library",0
wintitle_name:	dc.b	"Example Scope",0
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
	RS_LONG	S_GGFXBase,1
	RS_LONG	S_IntuiBase,1
	RS_LONG	S_mypubscreen,1
	RS_LONG	S_winhandle,1
	RS_LONG	S_mytaglist,40
	RS_LONG	S_drawhandle,1
	RS_LONG	S_ddrawhandle,1
	RS_LONG	S_UPS,1
	
;-----------------------------------------------------------------------------------------------
	RS_WORD	DatasLen,0
	ds.b	DatasLen


		ds.l	TrueWidth		;2 extra lines security buffer
TrueBuffer:	ds.l	TrueWidth*TrueHeight
		ds.l	TrueWidth

SampleBuffer:	ds.w	TrueWidth
	end
