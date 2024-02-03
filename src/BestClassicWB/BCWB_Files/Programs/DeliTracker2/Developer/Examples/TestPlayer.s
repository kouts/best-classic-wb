**
**	Testplayer.s
**
**	A sample player that visually reports DeliTracker's actions
**	within external players.
**
**	Use the source as a skeleton model for your own players.
**	Refer to the sample sources for additional information.
**
**	Once assembled, load this player into DeliTracker, and try
**	playing the file 'testmodule'.  It is only a textfile with
**	the word "TEST" at the beginning.  Notice now that
**	DeliTracker's actions on the module are visible.  This should
**	aid you in your coding sequences.
**
**	Original source by Peter Kunath and Frank Riffel of Delirium.
**
**	English, comments, and general banter by Kevin Dackiw.
**
**	Have any problems/concerns/ideas?  Feel free to contact the
**	authors:
**
**	Frank Riffel
**	Merkstr. 27
**	82405 Wessobrunn
**	Germany
**

	incdir	"includes:"
	include	"dos/dos.i"
	include	"intuition/intuition.i"
	include	"misc/DevpacMacros.i"
	include	"misc/DeliPlayer.i"

;
;
	SECTION Player,Code
;
;

	PLAYERHEADER PlayerTagArray			; define start of header

	dc.b '$VER: TestPlayer 2.01 (15 Apr 94)',0	; for OS 2.0 version command
	even

PlayerTagArray
	dc.l	DTP_RequestDTVersion,16			; define all the tags
	dc.l	DTP_PlayerVersion,02<<16+01
	dc.l	DTP_PlayerName,PName			; for the player
	dc.l	DTP_Creator,CName
	dc.l	DTP_DeliBase,delibase
	dc.l	DTP_Check1,Chk				; omit any unused
	dc.l	DTP_Config,Config			; functions as
	dc.l	DTP_UserConfig,UserConfig		; needed!
	dc.l	DTP_SubSongRange,SubSong
	dc.l	DTP_Process,Begin
	dc.l	DTP_Priority,0
	dc.l	DTP_StackSize,4096
	dc.l	DTP_MsgPort,DeliPort
	dc.l	DTP_InitPlayer,InitPlay
	dc.l	DTP_EndPlayer,EndPlay
	dc.l	DTP_InitSound,InitSnd
	dc.l	DTP_EndSound,EndSnd
	dc.l	DTP_StartInt,StartSnd
	dc.l	DTP_StopInt,StopSnd
	dc.l	DTP_Volume,Volume
	dc.l	DTP_Balance,Balance
	dc.l	DTP_Faster,Faster
	dc.l	DTP_Slower,Slower
	dc.l	DTP_PrevPatt,PrevPatt
	dc.l	DTP_NextPatt,NextPatt
	dc.l	DTP_PrevSong,PrevSub
	dc.l	DTP_NextSong,NextSub
	dc.l	TAG_DONE				; signify end of tags

*-----------------------------------------------------------------------*
;
; Playername / creatorname
;
*-----------------------------------------------------------------------*

PName	dc.b	'TestPlayer',0
CName	dc.b	'Written by Delirium for Testpurposes',0
	even

*-----------------------------------------------------------------------*
;
; Player Task
;
*-----------------------------------------------------------------------*

Begin
	move.l	delibase,a5			; get DeliBase
	move.l	dtg_DOSBase(a5),_DOSBase
	move.l	dtg_IntuitionBase(a5),_IntuitionBase

	bsr	About				; display About-Requester

	move.l	#ConsoleName,d1
	move.l	#MODE_NEWFILE,d2
	CALLDOS Open
	move.l	d0,d1
	beq	Quit				; Error
	CALLDOS SelectOutput
	move.l	d0,_OldOutput

	lea	StartTxt0,a0			; fetch text
	bsr	WriteInfoTxt			; output

;--------------------------------------------------------------------------
;
; Mainloop

MainLoop
	move.l	#SIGBREAKF_CTRL_C,d0		; quit on CTRL-C

	move.l	DeliPort,a0
	move.b	MP_SIGBIT(a0),d1		; DeliMask holen
	bset.l	d1,d0

	CALLEXEC Wait				; Schlaf gut

	btst.l	#SIGBREAKB_CTRL_C,d0		; CTRL-C signal ?
	beq.s	DeliCollect			; nope !
	bsr	Exit				; suicide :)

DeliCollect					; collect DeliTracker msg's
	move.l	DeliPort,a0
	CALLEXEC GetMsg
	tst.l	d0				; Msg da ?
	beq.s	CollectDone			; Nein !
	move.l	d0,-(sp)			; store ^Msg
	move.l	d0,a0
	move.l	DTMN_Function(a0),a0		; get CMD
	jsr	(a0)				; Befehl ausführen
	move.l	(sp)+,a1			; restore ^Msg
	move.l	d0,DTMN_Result(a1)		; set Result
	CALLEXEC ReplyMsg			; return to sender
	bra.s	DeliCollect

CollectDone
	tst.w	QuitFlag			; schon Ende ?
	bne	MainLoop			; noch nicht !

;--------------------------------------------------------------------------
;
; quit Player

Cleanup
	lea	QuitTxt0,a0			; fetch text
	bra	WriteInfoTxt			; output

	move.l	_OldOutput,d1
	CALLDOS SelectOutput
	move.l	d0,d1
	CALLDOS Close
Quit
	rts


;--------------------------------------------------------------------------
;
; End Player

Exit
	clr.w	QuitFlag			; quit Player
	rts


;--------------------------------------------------------------------------
;
; About Gesülze

About
	sub.l	a0,a0
	lea	AboutReqStruct,a1		; EasyStruct
	sub.l	a2,a2
	sub.l	a3,a3
	CALLINT	EasyRequestArgs
	rts


*-----------------------------------------------------------------------*
;
; Check if the module is a TestPlayer-Module (THIS ROUTINE MUST EXIST!!!)
;
*-----------------------------------------------------------------------*

Chk
	move.l	delibase,a0			; ^DeliBase
	move.l	dtg_ChkData(a0),a0		; get module base from DT
	moveq	#0,d0				; clear register
	cmpi.l	#'TEST',(a0)			; supported type ?
	sne	d0				; no - signal false
	rts					; leave


*-----------------------------------------------------------------------*
;
; Initialize the player
;
*-----------------------------------------------------------------------*

InitPlay
	lea	InitTxt1,a0			; fetch text
	bsr	WriteInfoTxt			; output
	moveq	#0,d0				; no error
	rts


*-----------------------------------------------------------------------*
;
; Clean up the player
;
*-----------------------------------------------------------------------*

EndPlay
	lea	EndTxt1,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; Initialize the module
;
*-----------------------------------------------------------------------*

InitSnd
	lea	InitTxt2,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; End sound
;
*-----------------------------------------------------------------------*

EndSnd
	lea	EndTxt2,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; Start interrupts
;
*-----------------------------------------------------------------------*

StartSnd
	lea	StartTxt,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; Start interrupts
;
*-----------------------------------------------------------------------*

StopSnd
	lea	StopTxt,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; IMPORTANT NOTE:
;	There is a BIG difference between the »Config« and the
;	»UserConfig« Routine !!! The Config routine is immediately
;	called after that the Player is loaded. It is used to
;	configure player (e.g. load config file and set pathes)!
;	The UserConfig routine is only called if the User selects
;	the player in the PrefWindow and presses the Config Player
;	GADGET. This routine is thought as a method of getting
;	informations (playerspecific preferences) from the user
;	(e.g. pathes for instruments or maximum memory usage).
;	The difference between Config and InitPlayer is that
;	Config is called ONCE the player is loaded and that
;	InitPlayer is called every time a module is played.
;
*-----------------------------------------------------------------------*
;
; get/set playerspecific preferences (configuration routines)
;
*-----------------------------------------------------------------------*

UserConfig
	lea	InfoTxt1,a0			; fetch text
	bra	WriteInfoTxt			; output

Config
	lea	InfoTxt2,a0			; fetch text
	bsr	WriteInfoTxt			; output
	moveq	#0,d0				; no error
	rts


*-----------------------------------------------------------------------*
;
; Patterncontrol
;
*-----------------------------------------------------------------------*

NextPatt
	lea	InfoTxt3,a0			; fetch text
	bra	WriteInfoTxt			; output

PrevPatt
	lea	InfoTxt4,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; Subsongcontrol
;
*-----------------------------------------------------------------------*

SubSong
	lea	InfoTxt9,a0			; fetch text
	bra	WriteInfoTxt			; output

NextSub
	lea	InfoTxt5,a0			; fetch text
	bra	WriteInfoTxt			; output

PrevSub
	lea	InfoTxt6,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; Speedcontrol
;
*-----------------------------------------------------------------------*

Faster
	lea	InfoTxt7,a0			; fetch text
	bra	WriteInfoTxt			; output

Slower
	lea	InfoTxt8,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; Volume & Balance Control
;
*-----------------------------------------------------------------------*

Volume
	lea	InfoTxt10,a0			; fetch text
	bra	WriteInfoTxt			; output

Balance
	lea	InfoTxt11,a0			; fetch text
	bra	WriteInfoTxt			; output


*-----------------------------------------------------------------------*
;
; Subroutines
;
*-----------------------------------------------------------------------*

WriteInfoTxt
	move.l	a0,d1
	CALLDOS PutStr
	rts


*-----------------------------------------------------------------------*

;
;
	SECTION PlayerDatas,Data
;
;

delibase:	dc.l 0
DeliPort:	dc.l 0

QuitFlag:	dc.w -1				; running

_DOSBase:	dc.l 0
_IntuitionBase:	dc.l 0

_OldOutput:	dc.l 0


*-----------------------------------------------------------------------*
;
; Various Texts
;
*-----------------------------------------------------------------------*


AboutReqStruct:
	dc.l	EasyStruct_SIZEOF		; size
	dc.l	0				; Flags
	dc.l	PName				; Title
	dc.l	AboutText			; TextFormat
	dc.l	OkText				; GadgetFormat


*-----------------------------------------------------------------------*
;
; Various Texts
;
*-----------------------------------------------------------------------*

AboutText	dc.b "           TestPlayer",10
		dc.b "© 1994 by Delirium Softdesign",10
		dc.b 10
		dc.b "An example player that visually",10
		dc.b "reports DeliTracker's actions",10
		dc.b "within external players.",10
		dc.b "The player is running as separte",10
		dc.b "process. Usually this is *not*",10
		dc.b "required.",0

OkText		dc.b	'  OK  ',0

ConsoleName	dc.b 'CON:20/20/600/160/TestPlayer_Debug',0

StartTxt0
	dc.b	27,"[1m",'Player process started.',27,"[0m",10
	dc.b	'Use CTRL-C or the remove function in the playerwindow',10
	dc.b	'to terminate',10
	dc.b	10,0

QuitTxt0
	dc.b	27,"[1m",'Player process terminated.',27,"[0m",10
	dc.b	10,0

InitTxt1
	dc.b	27,"[1m",'InitPlayer routine called.',27,"[0m",10
	dc.b	'This routine is called every time a new module is loaded.',10
	dc.b	'The audiochannels should be allocated here, and any',10
	dc.b	'player specific initialization should be performed.',10
	dc.b	10,0

EndTxt1
	dc.b	27,"[1m",'EndPlayer routine called.',27,"[0m",10
	dc.b	'This routine is called every time a module is killed',10
	dc.b	'(removed from memory).  Player specific cleanup routines',10
	dc.b	'are performed here, and the audiochannels should be',10
	dc.b	'released at this point.',10
	dc.b	10,0

InitTxt2
	dc.b	27,"[1m",'InitSound routine called.',27,"[0m",10
	dc.b	'This routine handles the initialization of the module.',10
	dc.b	10,0

EndTxt2
	dc.b	27,"[1m",'EndSound routine called.',27,"[0m",10
	dc.b	'This routine clears the audioregisters.',10
	dc.b	10,0

StartTxt
	dc.b	27,"[1m",'StartSound routine called.',27,"[0m",10
	dc.b	'This code must start the sound interrupts.',10
	dc.b	'If you use the internal DeliTracker routines, you must',10
	dc.b	'omit this entry from the TagArray.',10
	dc.b	10,0

StopTxt
	dc.b	27,"[1m",'StopSound routine called.',27,"[0m",10
	dc.b	'This code must stop the sound interrupts.',10
	dc.b	'If you use the internal DeliTracker routines, you must',10
	dc.b	'omit this entry from the TagArray.',10
	dc.b	10,0

InfoTxt1
	dc.b	27,"[1m",'UserConfig routine called.',27,"[0m",10
	dc.b	'This routine is for the use of advanced players.',10
	dc.b	'For example, if your player needs access to a directory',10
	dc.b	'of instruments, this routine could prompt the user with',10
	dc.b	'a requester for the path to the instruments.  Additionally',10
	dc.b	'the path could then be saved in a custom config file, such',10
	dc.b	'as PROGDIR:DeliConfig/TestPlayer.prefs.  Any future runs of the',10
	dc.b	'player would only then have to fetch the path from its config file.',10
	dc.b	'This custom config file must be accessed from the Config routine.',10
	dc.b	10,0

InfoTxt2
	dc.b	27,"[1m",'ConfigPlayer routine called.',27,"[0m",10
	dc.b	'This routine is entered after the player is loaded.',10
	dc.b	'At this point you may load a custom config file to fetch',10
	dc.b	'such things as a default instrument path, and the like.',10
	dc.b	10,0

InfoTxt3
	dc.b	27,"[1m",'NextPattern routine called.',27,"[0m",10
	dc.b	'This routine skips ahead one pattern in the module.',10
	dc.b	10,0

InfoTxt4
	dc.b	27,"[1m",'PrevPattern routine called.',27,"[0m",10
	dc.b	'This routine skips back one pattern in the module.',10
	dc.b	10,0

InfoTxt5
	dc.b	27,"[1m",'NextSubsong routine called.',27,"[0m",10
	dc.b	'This routine jumps to the next subsong (if supported).',10
	dc.b	10,0

InfoTxt6
	dc.b	27,"[1m",'PrevSubsong routine called.',27,"[0m",10
	dc.b	'This routine jumps to the previous subsong (if supported).',10
	dc.b	10,0

InfoTxt7
	dc.b	27,"[1m",'PlayFaster routine called.',27,"[0m",10
	dc.b	'This routine increases the playspeed.',10
	dc.b	10,0

InfoTxt8
	dc.b	27,"[1m",'PlaySlower routine called.',27,"[0m",10
	dc.b	'This routine decreases the playspeed.',10
	dc.b	10,0

InfoTxt9
	dc.b	27,"[1m",'SubSong routine called.',27,"[0m",10
	dc.b	'This routine must determine the min & max subsong number.',10
	dc.b	10,0

InfoTxt10
	dc.b	27,"[1m",'Volume routine called.',27,"[0m",10
	dc.b	'This routine controls the volume.',10
	dc.b	10,0

InfoTxt11
	dc.b	27,"[1m",'Balance routine called.',27,"[0m",10
	dc.b	'This routine controls the balance.',10
	dc.b	10,0


*-----------------------------------------------------------------------*


	END
