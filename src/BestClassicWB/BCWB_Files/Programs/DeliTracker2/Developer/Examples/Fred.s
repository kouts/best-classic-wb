
	incdir	"Includes:"
	include	"misc/DeliPlayer.i"

;
;
	SECTION Player,Code
;
;

	PLAYERHEADER PlayerTagArray

	dc.b '$VER: Fred player module V1.5 (15 Mar 94)',0
	even

PlayerTagArray
	dc.l	DTP_RequestDTVersion,16
	dc.l	DTP_PlayerVersion,01<<16+50
	dc.l	DTP_PlayerName,PName
	dc.l	DTP_Creator,CName
	dc.l	DTP_Check2,Chk
	dc.l	DTP_Interrupt,Int
	dc.l	DTP_SubSongRange,SubSong
	dc.l	DTP_InitPlayer,InitPlay
	dc.l	DTP_EndPlayer,EndPlay
	dc.l	DTP_InitSound,InitSnd
	dc.l	DTP_EndSound,RemSnd
	dc.l	TAG_DONE

*-----------------------------------------------------------------------*
;
; Player/Creatorname und lokale Daten

PName	dc.b 'FredMonitor',0
CName	dc.b 'Frederic Hahn,',10
	dc.b 'adapted by Turbo/Infect & Delirium',0
	even
fr_data		dc.l 0

MaxSong		dc.w 0
MaxSong2	dc.w 0

*-----------------------------------------------------------------------*
;
;Interrupt für Replay

Int
	movem.l	d2-d7/a2-a6,-(sp)
	move.l	fr_data(pc),a0
	jsr	4(a0)				; DudelDiDum
	movem.l	(sp)+,d2-d7/a2-a6
	rts

*-----------------------------------------------------------------------*
;
; Testet auf Fred-Modul

Chk						; Fred ?
	move.l	dtg_ChkData(a5),a0
	moveq	#-1,d0				; Modul nicht erkannt (default)
	cmpi.w	#$4efa,$00(a0)
	bne.s	ChkEnd
	cmpi.w	#$4efa,$04(a0)
	bne.s	ChkEnd
	cmpi.w	#$4efa,$08(a0)
	bne.s	ChkEnd
	cmpi.w	#$4efa,$0c(a0)
	bne.s	ChkEnd
	add.w	2(a0),a0
	moveq	#4-1,d1
ChkLoop	cmpi.w	#$123a,2(a0)
	bne.s	ChkNext
	cmpi.w	#$b001,6(a0)
	beq.s	ChkSong
ChkNext	addq.l	#2,a0
	dbra	d1,ChkLoop
	bra.s	ChkEnd				; Modul nicht erkannt
ChkSong	add.w	4(a0),a0
	moveq	#0,d1
	move.b	4(a0),d1
	move.w	d1,MaxSong2
	moveq	#0,d0				; Modul erkannt
ChkEnd
	rts

*-----------------------------------------------------------------------*
;
; Set min. & max. subsong number

SubSong
	moveq	#0,d0				; min.
	move.w	MaxSong(pc),d1			; max.
	rts

*-----------------------------------------------------------------------*

; Init Player

InitPlay
	moveq	#0,d0
	move.l	dtg_GetListData(a5),a0		; Function
	jsr	(a0)
	move.l	a0,fr_data

	move.w	MaxSong2(pc),MaxSong		; copy buffer

	move.l	dtg_AudioAlloc(a5),a0		; Function
	jsr	(a0)				; returncode is already set !
	rts

*-----------------------------------------------------------------------*
;
; End Player

EndPlay
	move.l	dtg_AudioFree(a5),a0		; Function
	jsr	(a0)
	rts

*-----------------------------------------------------------------------*

; Init Sound

InitSnd
	move.l	a5,-(sp)
	moveq	#0,d0
	move.w	dtg_SndNum(a5),d0		; SoundNumber
	move.l	fr_data(pc),a0
	jsr	(a0)				; Init Sound
	move.l	(sp)+,a5
	rts

*-----------------------------------------------------------------------*
;
; Remove Sound

RemSnd
	move.l	a5,-(sp)
	moveq	#0,d1
	move.l	fr_data(pc),a0
	jsr	8(a0)				; End Sound
	move.l	(sp)+,a5

	moveq	#0,d0
	lea	$dff000,a0
	move.w	d0,$a8(a0)
	move.w	d0,$b8(a0)
	move.w	d0,$c8(a0)
	move.w	d0,$d8(a0)
	move.w	#$f,$96(a0)
	rts

*-----------------------------------------------------------------------*

