
	incdir	"Includes:"
	include	"misc/DeliPlayer.i"

;
;
	SECTION Player,Code
;
;

	PLAYERHEADER PlayerTagArray

	dc.b '$VER: QuadraComposer 2.1 player module V1.1 (26 Apr 95)',0
	even

PlayerTagArray
	dc.l	DTP_RequestDTVersion,16
	dc.l	DTP_PlayerVersion,01<<16+10
	dc.l	DTP_PlayerName,PName
	dc.l	DTP_Creator,CName
	dc.l	DTP_DeliBase,delibase
	dc.l	DTP_Check2,Chk
	dc.l	DTP_CheckLen,ChkLen
	dc.l	DTP_Flags,PLYF_SONGEND
	dc.l	DTP_Interrupt,Int
	dc.l	DTP_InitPlayer,InitPlay
	dc.l	DTP_EndPlayer,EndPlay
	dc.l	DTP_InitSound,InitSnd
	dc.l	DTP_EndSound,EndSnd
	dc.l	DTP_Volume,SetVol
	dc.l	DTP_Balance,SetVol
	dc.l	TAG_DONE

*-----------------------------------------------------------------------*
;
; Player/Creatorname und lokale Daten

PName	dc.b 'QuadraComposer',0
CName	dc.b '© 1993-94 Technological ArtWork',10
	dc.b '(Bo Lincoln & Calle Englund)',10
	dc.b 'adapted by Delirium',0
	even
delibase	dc.l 0

*-----------------------------------------------------------------------*
;
; Interrupt für Replay

Int
	movem.l	d2-d7/a2-a6,-(sp)
	bsr	QC_music			; DudelDiDum
	movem.l	(sp)+,d2-d7/a2-a6
	rts

*-----------------------------------------------------------------------*
;
; Testet auf Modul

Chk						; QuadraComposer ?
	move.l	dtg_ChkData(a5),a0
	moveq	#-1,d0				; Modul nicht erkannt (default)
	cmp.l	#"FORM",(a0)
	bne.s	ChkEnd
	cmp.l	#"EMOD",8(a0)
	bne.s	ChkEnd
	cmp.l	#"EMIC",12(a0)
	bne.s	ChkEnd
	cmp.w	#1,20(a0)
	bne.s	ChkEnd
	moveq	#0,d0				; Modul erkannt
ChkEnd
	rts

ChkLen = *-Chk

*-----------------------------------------------------------------------*
;
; Init Player

InitPlay
	moveq	#0,d0
	move.l	dtg_GetListData(a5),a0		; Function
	jsr	(a0)

	bsr	QC_reloc			; relocate Module
	tst.l	d0
	bne.s	EndPlay2			; error !

	move.l	dtg_AudioAlloc(a5),a0		; Function
	jsr	(a0)				; returncode is already set !
	rts

*-----------------------------------------------------------------------*
;
; End Player

EndPlay
	move.l	dtg_AudioFree(a5),a0		; Function
	jsr	(a0)
EndPlay2
	moveq	#-1,d0
	rts

*-----------------------------------------------------------------------*
;
; Init Module

InitSnd
	bsr	QC_init
	rts

*-----------------------------------------------------------------------*
;
; Clean up Module

EndSnd
	bsr	QC_end
	rts

*-----------------------------------------------------------------------*
;
; Copy Volume and Balance Data to internal Buffer

SetVol
	move.w	dtg_SndLBal(a5),d0
	mulu	dtg_SndVol(a5),d0
	lsr.w	#6,d0
	lea	QC_chan1(pc),a0
	lea	$dff0a0,a1
	moveq	#2-1,d1
SetVolL
	move.w	d0,t_mainvol(a0)
	move.w	t_volume(a0),d2
	mulu	d0,d2
	lsr.w	#6,d2
	move.w	d2,t_realvol(a0)
	move.w	d2,8(a1)
	lea	QC_chan4-QC_chan1(a0),a0
	lea	$30(a1),a1
	dbra	d1,SetVolL

	move.w	dtg_SndRBal(a5),d0
	mulu	dtg_SndVol(a5),d0
	lsr.w	#6,d0
	lea	QC_chan2(pc),a0
	lea	$dff0b0,a1
	moveq	#2-1,d1
SetVolR
	move.w	d0,t_mainvol(a0)
	move.w	t_volume(a0),d2
	mulu	d0,d2
	lsr.w	#6,d2
	move.w	d2,t_realvol(a0)
	move.w	d2,8(a1)
	lea	QC_chan3-QC_chan2(a0),a0
	lea	$10(a1),a1
	dbra	d1,SetVolR
	rts

*-----------------------------------------------------------------------*
;
; QuadraComposer2.1-Replay

** This is a CIA replayroutine for EMOD's **
** It handles all commands and tempo      **
** You may include this in your own       **
** applications, if you wish...           **
** If you want to use this routinne in a  **
** player, you should write a "smart"     **
** load routine, which allocates a        **
** specific memory range for each sample  **
** and pattern etc.                       **
**                          /Bo Lincoln   **

QC_reloc:move.l a0,d1		;pointer to module
	cmp.l #"FORM",(a0)
	bne QC_initerr
	cmp.l #"EMOD",8(a0)
	bne QC_initerr
	cmp.l #"EMIC",12(a0)
	bne QC_initerr
	cmp.w #1,20(a0)
	bne QC_initerr

	move.w #256-1,d7
	lea QC_samplepointers,a1
QC_spclear:
	move.l #QC_quietsamp,(a1)+
	dbra d7,QC_spclear

	moveq #0,d7		;Get the adresses to the sampleinfos
	move.b 62(a0),QC_tempo+1
	move.b 63(a0),d7	;and init the real adresses in the infos
	subq #1,d7
	lea 64(a0),a0
	lea QC_samplepointers,a1
QC_sploop:moveq #0,d0
	move.b (a0),d0
	add.w d0,d0
	add.w d0,d0
	move.l a0,(a1,d0.w)
	add.l d1,30(a0)
	move.l 30(a0),a2
	clr.w (a2)
	lea 34(a0),a0
	dbf d7,QC_sploop

	lea QC_patternpointers,a1	;Get the patternadresses
	moveq #0,d7
	addq #1,a0
	move.b (a0)+,d7
	subq #1,d7
QC_pploop:moveq #0,d0
	move.b (a0),d0
	add.w d0,d0
	add.w d0,d0
	move.l a0,(a1,d0.w)
	add.l d1,22(a0)
	lea 26(a0),a0
	dbf d7,QC_pploop

	clr.w QC_nrofpos
	move.b (a0)+,QC_nrofpos+1	
	move.l a0,QC_posstart

	move.l #1776200,QC_ciaspeed

	moveq #0,d0
	rts
QC_initerr:moveq #-1,d0
	rts

QC_init:move.l QC_posstart(pc),a0
	lea QC_patternpointers,a1
	moveq #0,d0
	move.b (a0),d0
	add.w d0,d0
	add.w d0,d0
	move.l (a1,d0.w),a1
	move.l 22(a1),QC_currpattpointer	
	move.b 1(a1),QC_breakrow+1
	move.w #6,QC_speed
	move.w QC_speed(pc),QC_speedcount
	clr.b QC_newposflag
	clr.w QC_rowcount
	clr.w QC_pos
	or.b #1,QC_event
	move.w #1,t_length+QC_chan1
	move.w #1,t_length+QC_chan2
	move.w #1,t_length+QC_chan3
	move.w #1,t_length+QC_chan4
	move.w #1,t_replen+QC_chan1
	move.w #1,t_replen+QC_chan2
	move.w #1,t_replen+QC_chan3
	move.w #1,t_replen+QC_chan4

	st QC_introrow			;You must reset this every time 
					;you restart the module

	move.l a0,-(sp)
	move.l delibase(pc),a0			; added by Delirium
	move.l QC_ciaspeed,d0
	divu #125,d0
	move.w d0,dtg_Timer(a0)
	move.l (sp)+,a0

QC_end:	move.w #$f,$dff096
	clr.w $dff0a8
	clr.w $dff0b8
	clr.w $dff0c8
	clr.w $dff0d8
	rts		

**********************************************
;;******** Replayrutinen + interrupt *********
**********************************************

QC_music:						;Ny (hela replayen)
	addq #1,QC_speedcount
	move.w QC_speed,d0
	cmp.w QC_speedcount,d0
	bgt QC_nonew
	tst.b QC_pattwait
	beq QC_getnotes
	subq.b #1,QC_pattwait
	clr.w QC_speedcount

QC_nonew:
	lea QC_samplepointers,a4
	lea QC_periods(pc),a3
	lea QC_chan1(pc),a6
	lea $dff0a0,a5
	bsr QC_chkplayfx
	lea QC_chan2-QC_chan1(a6),a6
	lea $10(a5),a5
	bsr QC_chkplayfx
	lea QC_chan2-QC_chan1(a6),a6
	lea $10(a5),a5
	bsr QC_chkplayfx
	lea QC_chan2-QC_chan1(a6),a6
	lea $10(a5),a5
	bsr QC_chkplayfx

	tst.w QC_dmacon
	beq QC_mend
	move.w QC_dmacon(pc),$dff096
	move.l a0,-(sp)
	move.l delibase(pc),a0			; added by Delirium
	move.l dtg_WaitAudioDMA(a0),a0
	jsr (a0)
	move.l (sp)+,a0
	or.w #$8000,QC_dmacon
	move.w QC_dmacon(pc),$dff096
	move.l a0,-(sp)
	move.l delibase(pc),a0			; added by Delirium
	move.l dtg_WaitAudioDMA(a0),a0
	jsr (a0)
	move.l (sp)+,a0
	clr.w QC_dmacon
	lea QC_chan1+t_repeat(pc),a0
	lea $dff000,a5
	move.l (a0),d0
	cmp.l #$c00000,d0
	blt .ok1
	sub.l #$b80000,d0
.ok1:	move.l d0,$a0(a5)
	move.w 4(a0),$a4(a5)
	move.l QC_chan2-QC_chan1(a0),d0
	cmp.l #$c00000,d0
	blt .ok2
	sub.l #$b80000,d0
.ok2:	move.l d0,$b0(a5)
	move.w 4+QC_chan2-QC_chan1(a0),$b4(a5)
	move.l QC_chan3-QC_chan1(a0),d0
	cmp.l #$c00000,d0
	blt .ok3
	sub.l #$b80000,d0
.ok3:	move.l d0,$c0(a5)
	move.w 4+QC_chan3-QC_chan1(a0),$c4(a5)
	move.l QC_chan4-QC_chan1(a0),d0
	cmp.l #$c00000,d0
	blt .ok4
	sub.l #$b80000,d0
.ok4:	move.l d0,$d0(a5)
	move.w 4+QC_chan4-QC_chan1(a0),$d4(a5)
	rts


QC_chkplayfx:
	lea QC_playfx(pc),a2
	move.b t_cmd(a6),d0
	and.w #$f,d0
	add.w d0,d0
	add.w d0,d0
	move.l (a2,d0.w),a0
	jmp (a0)

QC_getnotes:
	tst.b QC_introrow
	bne QC_ok
	tst.b QC_event
	beq QC_tstnewpos
	btst #0,QC_event
	beq QC_tstnewpos
	and.b #$fe,QC_event
QC_settempo:
	move.l QC_ciaspeed,d0
	divu QC_tempo,d0
QC_ciab:move.l a0,-(sp)
	move.l delibase(pc),a0			; added by Delirium
	move.w d0,dtg_Timer(a0)
	move.l dtg_SetTimer(a0),a0
	jsr (a0)
	move.l (sp)+,a0
QC_tstnewpos:
	tst.b QC_newposflag
	beq QC_tstend
	clr.b QC_newposflag
	move.w QC_newposnr,QC_pos			;Ny
	bra QC_newpos
QC_tstend:tst.b QC_jumpbreakflag
	beq QC_tstend2
	clr.b QC_jumpbreakflag
	move.w QC_looprow(pc),d0
	cmp.w QC_breakrow(pc),d0
	bgt QC_ok
	move.w d0,QC_rowcount
	bra QC_ok
QC_tstend2:
	addq.w #1,QC_rowcount
	move.w QC_rowcount(pc),d0
	cmp.w QC_breakrow(pc),d0
	ble QC_ok
	tst.b QC_playpatt
	bne QC_nonewpatt
	addq.w #1,QC_pos
QC_newpos:
	move.w QC_pos(pc),d0
	cmp.w QC_nrofpos(pc),d0
	blt QC_getpos
	clr.w QC_pos
	move.l a0,-(sp)
	move.l delibase(pc),a0			; added by Delirium
	move.l dtg_SongEnd(a0),a0
	jsr (a0)
	move.l (sp)+,a0
	moveq #0,d0
QC_getpos:
	move.w d0,-(sp)
	move.w QC_pos,d0
	move.w (sp)+,d0
	move.l QC_posstart,a0
	move.b (a0,d0.w),d0
	move.w d0,QC_currpatt
	add.w d0,d0
	add.w d0,d0
	lea QC_patternpointers,a0
	move.l (a0,d0.w),a0
	move.l 22(a0),QC_currpattpointer
	move.b 1(a0),QC_breakrow+1
	move.w QC_newrow(pc),QC_rowcount
	clr.w QC_newrow
	move.w QC_breakrow,d0
	cmp.w QC_rowcount,d0
	bge QC_ok
	move.w d0,QC_rowcount
	bra QC_ok
QC_nonewpatt:
	clr.w QC_rowcount
QC_ok:	sf QC_introrow
	clr.w QC_speedcount
	move.l QC_currpattpointer(pc),a0
	move.w QC_rowcount(pc),d0
	asl.w #4,d0
	add.w d0,a0
	lea QC_samplepointers,a4
	lea QC_periods(pc),a3

	lea $dff0a0,a5
	lea QC_chan1(pc),a6
	bsr QC_playnote
	lea $10(a5),a5
	lea QC_chan2-QC_chan1(a6),a6
	bsr QC_playnote
	lea $10(a5),a5
	lea QC_chan2-QC_chan1(a6),a6
	bsr QC_playnote
	lea $10(a5),a5
	lea QC_chan2-QC_chan1(a6),a6
	bsr QC_playnote
	tst.w QC_dmacon
	beq QC_update

	move.w QC_dmacon(pc),$dff096
	move.l a0,-(sp)
	move.l delibase(pc),a0			; added by Delirium
	move.l dtg_WaitAudioDMA(a0),a0
	jsr (a0)
	move.l (sp)+,a0
	or.w #$8000,QC_dmacon
	move.w QC_dmacon(pc),$dff096
	move.l a0,-(sp)
	move.l delibase(pc),a0			; added by Delirium
	move.l dtg_WaitAudioDMA(a0),a0
	jsr (a0)
	move.l (sp)+,a0
	clr.w QC_dmacon
	lea QC_chan1+t_repeat(pc),a0
	lea $dff000,a5
	move.l (a0),d0
	cmp.l #$c00000,d0
	blt .ok1
	sub.l #$b80000,d0
.ok1:	move.l d0,$a0(a5)
	move.w 4(a0),$a4(a5)
	move.l QC_chan2-QC_chan1(a0),d0
	cmp.l #$c00000,d0
	blt .ok2
	sub.l #$b80000,d0
.ok2:	move.l d0,$b0(a5)
	move.w 4+QC_chan2-QC_chan1(a0),$b4(a5)
	move.l QC_chan3-QC_chan1(a0),d0
	cmp.l #$c00000,d0
	blt .ok3
	sub.l #$b80000,d0
.ok3:	move.l d0,$c0(a5)
	move.w 4+QC_chan3-QC_chan1(a0),$c4(a5)
	move.l QC_chan4-QC_chan1(a0),d0
	cmp.l #$c00000,d0
	blt .ok4
	sub.l #$b80000,d0
.ok4:	move.l d0,$d0(a5)
	move.w 4+QC_chan4-QC_chan1(a0),$d4(a5)
QC_update:
QC_mend:rts

QC_playnote:move.l (a0)+,(a6)
	moveq #0,d0
	move.b (a6),d0
	beq QC_isnote
	add.w d0,d0
	add.w d0,d0
	move.l (a4,d0.w),a1
	move.b 1(a1),t_volume+1(a6)
	move.w 2(a1),t_length(a6)
	move.b 25(a1),d0
	and.w #$f,d0
	add.w d0,d0
	add.w d0,d0
	move.l (a3,d0.w),t_finetune(a6)
	move.l 30(a1),d1
	move.l d1,t_start(a6)
	move.l d1,t_realstart(a6)
	clr.w 8(a5)
	tst.b t_enable(a6)
	beq .novol
	move.w t_volume(a6),d0
	mulu t_mainvol(a6),d0
	lsr.w #6,d0
	move.w d0,t_realvol(a6)
	move.w d0,8(a5)
.novol:	btst #0,24(a1)
	beq .noloop
	moveq #0,d0
	move.w 26(a1),d0
	move.w d0,t_rep(a6)
	add.l d0,d1
	add.l d0,d1
	move.l d1,t_repeat(a6)
	moveq #0,d0
	move.w 26(a1),d0
	moveq #0,d1
	move.w 28(a1),d1
	add.l d0,d1
	move.w d1,t_length(a6)
	move.w 28(a1),t_replen(a6)
	bra QC_isnote
.noloop	move.l #QC_quiet,t_repeat(a6)
	clr.w t_rep(a6)
	move.w #$1,t_replen(a6)
QC_isnote:
	tst.b t_notenr(a6)
	blt QC_chkfirstfx
	move.b t_notenr(a6),t_notenr2+1(a6)			;Ny (flyttad)
	move.w t_cmd(a6),d0
	and.w #$ff0,d0
	cmp.w #$e50,d0
	beq QC_setfinetunefirst
	and.w #$f00,d0
	cmp.w #$300,d0
	beq QC_settoneport
	cmp.w #$500,d0
	beq QC_settoneport
QC_getper:move.w t_notenr2(a6),d0
	add.w d0,d0
	move.l t_finetune(a6),a2
	move.w (a2,d0.w),t_period(a6)
	move.w t_cmd(a6),d0
	and.w #$ff0,d0
	cmp.w #$ed0,d0
	beq QC_notedelay
	move.w t_dmabit(a6),d0
	or.w d0,QC_dmacon
	move.l t_start(a6),d0
	cmp.l #$c00000,d0
	blt .ok
	sub.l #$b80000,d0
.ok:	move.l d0,(a5)
	clr.l t_adrcount(a6)
	move.b (a6),t_samplenr(a6)
	move.w t_length(a6),t_reallength(a6)
	sf t_looping(a6)
	st t_going(a6)
	move.w t_length(a6),4(a5)
	move.w t_period(a6),6(a5)
QC_chkfirstfx:
	lea QC_fxaftersetperiod(pc),a2
	moveq #0,d0
	move.b t_cmd(a6),d0
	add.w d0,d0
	add.w d0,d0
	move.l (a2,d0.w),a2
	jmp (a2)


QC_setfinetunefirst:
	move.b t_cmdarg(a6),d0
	add.w d0,d0
	add.w d0,d0
	move.l (a3,d0.w),t_finetune(a6)
	bra QC_getper

QC_ecommands:
	lea QC_efx(pc),a2
	move.b t_cmdarg(a6),d0
	and.w #$f0,d0
	lsr.w #2,d0
	move.l (a2,d0.w),a2
	jmp (a2)

QC_playecommands:
	lea QC_playefx(pc),a2
	move.b t_cmdarg(a6),d0
	and.w #$f0,d0
	lsr.w #2,d0
	move.l (a2,d0.w),a2
	jmp (a2)

********** Effect commands **********

QC_arpeggio:					;Ny
	tst.b t_cmdarg(a6)
	beq QC_mend
	lea QC_arptbl,a2
	move.w QC_speedcount,d0
	tst.b (a2,d0.w)
	beq QC_arp2
	blt QC_arp1
	move.b t_cmdarg(a6),d0
	and.w #$f,d0
	add.w t_notenr2(a6),d0
	add.w d0,d0
	move.l t_finetune(a6),a2
	move.w (a2,d0.w),6(a5)
	rts
QC_arp1:move.w t_period(a6),6(a5)
	rts
QC_arp2:moveq #0,d0
	move.b t_cmdarg(a6),d0
	lsr.w #4,d0
	add.w t_notenr2(a6),d0
	add.w d0,d0
	move.l t_finetune(a6),a2
	move.w (a2,d0.w),6(a5)
	rts

QC_slideup:
	moveq #0,d0
	move.b t_cmdarg(a6),d0
	sub.w d0,t_period(a6)
	cmp.w #113,t_period(a6)
	bgt QC_sunotlow
	move.w #113,t_period(a6)
QC_sunotlow:
	move.w t_period(a6),6(a5)
	rts

QC_slidedown:
	moveq #0,d0
	move.b t_cmdarg(a6),d0
	add.w d0,t_period(a6)
	cmp.w #856,t_period(a6)
	blt QC_sdnothigh
	move.w #856,t_period(a6)
QC_sdnothigh:
	move.w t_period(a6),6(a5)
	rts

QC_settoneport:
	move.w t_notenr2(a6),d0
	add.w d0,d0
	move.l t_finetune(a6),a2
	move.w (a2,d0.w),d0
	move.w d0,t_wantedperiod(a6)
	cmp.w t_period(a6),d0
	bgt QC_setportdown
	clr.b t_portdir(a6)
	rts
QC_setportdown:
	move.b #1,t_portdir(a6)
	rts

QC_toneport:
	tst.w t_wantedperiod(a6)
	beq QC_mend
	moveq #0,d0
	move.b t_cmdarg(a6),d0
	beq QC_tpold
	move.b d0,t_portspeed(a6)
	tst.b t_portdir(a6)			
	bne QC_portdown				
	sub.w d0,t_period(a6)			
	move.w t_wantedperiod(a6),d0		
	cmp.w t_period(a6),d0
	blt QC_notyetwanted
	move.w d0,6(a5)
	move.w d0,t_period(a6)	
	clr.w t_wantedperiod(a6)
	rts
QC_tpold:move.b t_portspeed(a6),d0
	tst.b t_portdir(a6)
	bne QC_portdown
	sub.w d0,t_period(a6)
	move.w t_wantedperiod(a6),d0
	cmp.w t_period(a6),d0
	blt QC_notyetwanted
	move.w d0,6(a5)
	move.w d0,t_period(a6)
	clr.w t_wantedperiod(a6)
	rts
QC_portdown:
	add.w d0,t_period(a6)
	move.w t_wantedperiod(a6),d0
	cmp.w t_period(a6),d0
	bgt QC_notyetwanted
	move.w d0,6(a5)
	move.w d0,t_period(a6)
	clr.w t_wantedperiod(a6)
	rts
QC_notyetwanted:
	tst.b t_glisscont(a6)
	beq QC_nogliss
	move.l t_finetune(a6),a2
	move.w t_period(a6),d0
QC_glissloop:
	cmp.w (a2)+,d0
	blt QC_glissloop
	move.w -2(a2),6(a5)
	rts
QC_nogliss:
	move.w t_period(a6),6(a5)
	rts

QC_vibrato:
	moveq #0,d0
	move.b t_vibwave(a6),d0
	asl.w #7,d0
	lea QC_vibtables(pc),a2
	add.w d0,a2
	moveq #0,d0
	move.b t_cmdarg(a6),d0
	beq QC_vib
	move.w d0,d1
	and.b #$f,d0
	beq QC_vibusespeed
	and.b #$f0,t_vibcmd(a6)
	or.b d0,t_vibcmd(a6)
QC_vibusespeed:
	and.b #$f0,d1
	beq QC_vib
	and.b #$f,t_vibcmd(a6)
	or.b d1,t_vibcmd(a6)
QC_vib:	move.b t_vibcmd(a6),d0
	lsr.w #3,d0
	add.w d0,t_vibpos(a6)
	and.w #$7e,t_vibpos(a6)
	move.w t_vibpos(a6),d0
	move.w t_period(a6),d1
	move.w (a2,d0.w),d0
	move.b t_vibcmd(a6),d2
	and.w #$f,d2
	muls d2,d0
	add.l d0,d0
	add.l d0,d0
	swap d0
	add.w d0,d1
	cmp.w #856,d1
	blt QC_vibnothigh
	move.w #856,6(a5)
	rts
QC_vibnothigh:
	cmp.w #113,d1
	bgt QC_vibnotlow
	move.w #113,6(a5)
	rts
QC_vibnotlow:
	move.w d1,6(a5)
	rts

QC_toneportandvolslide:
	tst.w t_wantedperiod(a6)
	beq QC_volslide
	bsr QC_tpold
	bra QC_volslide

QC_vibratoandvolslide:
	bsr QC_vib
	bra QC_volslide

QC_tremolo:
	moveq #0,d0
	move.b t_tremwave(a6),d0
	asl.w #7,d0
	lea QC_vibtables(pc),a2
	add.w d0,a2
	moveq #0,d0
	move.b t_cmdarg(a6),d0
	beq QC_trem
	move.w d0,d1
	and.b #$f,d0
	beq QC_tremusespeed
	and.b #$f0,t_tremcmd(a6)
	or.b d0,t_tremcmd(a6)
QC_tremusespeed:
	and.b #$f0,d1
	beq QC_trem
	and.b #$f,t_tremcmd(a6)
	or.b d1,t_tremcmd(a6)
QC_trem:move.b t_tremcmd(a6),d0
	lsr.w #3,d0
	add.w d0,t_trempos(a6)
	and.w #$7e,t_trempos(a6)
	move.w t_trempos(a6),d0
	move.w t_volume(a6),d1
	move.w (a2,d0.w),d0
	move.b t_tremcmd(a6),d2
	and.w #$f,d2
	muls d2,d0
	asl.l #3,d0
	swap d0
	add.w d0,d1
	cmp.w #$40,d1
	blt QC_tremnothigh
	tst.b t_enable(a6)
	beq QC_mend
	move.w t_mainvol(a6),t_realvol(a6)
	move.w t_mainvol(a6),8(a5)
	rts
QC_tremnothigh:
	tst.w d1
	bgt QC_tremnotlow
	tst.b t_enable(a6)
	beq QC_mend
	clr.w 8(a5)
	rts
QC_tremnotlow:
	tst.b t_enable(a6)
	beq QC_mend
	mulu t_mainvol(a6),d1
	lsr.w #6,d1
	move.w d1,t_realvol(a6)
	move.w d1,8(a5)
	rts

QC_sampleoffset:
	moveq #0,d0
	move.b t_cmdarg(a6),d0
	beq QC_sook
	move.b d0,t_sampleoffset(a6)
QC_sook:move.b t_sampleoffset(a6),d0
	asl.w #8,d0
	moveq #0,d1
	move.w t_length(a6),d1
	move.w d1,t_reallength(a6)
	move.l d0,t_adrcount(a6)
	sub.l d0,d1
	ble QC_sotoolong
	move.w d1,t_length(a6)
	add.l d0,d0
	add.l d0,t_start(a6)
	move.l t_start(a6),d0
	cmp.l #$c00000,d0
	blt .ok
	sub.l #$b80000,d0
.ok:	move.l d0,(a5)
	move.b (a6),t_samplenr(a6)
	sf t_looping(a6)
	st t_going(a6)
	move.w t_length(a6),4(a5)
	rts
QC_sotoolong:
	move.w #1,t_length(a6)
	move.w t_length(a6),4(a5)
	rts

QC_volslide:
	moveq #0,d0
	move.b t_cmdarg(a6),d0
	lsr.w #4,d0
	beq QC_volslidedown
	add.w d0,t_volume(a6)
	cmp.w #$40,t_volume(a6)
	blt QC_setvol
	move.w #$40,t_volume(a6)
QC_setvol:
	tst.b t_enable(a6)
	beq QC_mend
	move.w t_volume(a6),d0
	mulu t_mainvol(a6),d0
	lsr.w #6,d0
	move.w d0,t_realvol(a6)
	move.w d0,8(a5)
	rts
QC_volslidedown:
	move.b t_cmdarg(a6),d0
	sub.w d0,t_volume(a6)
	tst.w t_volume(a6)
	bgt QC_setvol
	clr.w t_volume(a6)
	tst.b t_enable(a6)
	beq QC_mend
	clr.w 8(a5)
	rts

QC_posjump:				;Ny
	move.b t_cmdarg(a6),d0
	move.b d0,QC_newposnr+1
	move.b #1,QC_newposflag
	clr.w QC_newrow
	rts

QC_volumechange:
	move.b t_cmdarg(a6),d0
	cmp.b #$40,d0
	blo QC_volchhigh
	move.w #$40,t_volume(a6)
	tst.b t_enable(a6)
	beq QC_mend
	move.w t_mainvol(a6),t_realvol(a6)
	move.w t_mainvol(a6),8(a5)
	rts
QC_volchhigh:
	move.b d0,t_volume+1(a6)
	tst.b t_enable(a6)
	beq QC_mend
	move.w t_volume(a6),d0
	mulu t_mainvol(a6),d0
	lsr.w #6,d0
	move.w d0,t_realvol(a6)
	move.w d0,8(a5)
	rts

QC_patternbreak:			;Ny
	move.w QC_pos,d0
	addq.w #1,d0
	move.w d0,QC_newposnr
	move.b t_cmdarg(a6),QC_newrow+1
	move.b #1,QC_newposflag
	rts

QC_setspeed:
	move.b t_cmdarg(a6),d0
	beq QC_setspeed1
	cmp.b #$1f,d0
	bhi QC_temposet
	move.b d0,QC_speed+1
	clr.w QC_speedcount
	rts
QC_setspeed1:
	move.w #1,QC_speed
	clr.w QC_speedcount
	rts
QC_temposet:
	move.b d0,QC_tempo+1
	or.b #$1,QC_event
	rts

QC_setfilter:
	move.b t_cmdarg(a6),d0
	and.b #1,d0
	add.b d0,d0
	and.b #$fd,$bfe001
	or.b d0,$bfe001
	rts

QC_fineslideup:
	move.b t_cmdarg(a6),d0
	and.w #$f,d0
	sub.w d0,t_period(a6)
	cmp.w #113,t_period(a6)
	bgt QC_fsunotlow
	move.w #113,t_period(a6)
QC_fsunotlow:
	move.w t_period(a6),6(a5)
	rts

QC_fineslidedown:
	move.b t_cmdarg(a6),d0
	and.w #$f,d0
	add.w d0,t_period(a6)
	cmp.w #856,t_period(a6)
	blt QC_fsdnothigh
	move.w #856,t_period(a6)
QC_fsdnothigh:
	move.w t_period(a6),6(a5)
	rts

QC_glisscontrol:
	move.b t_cmdarg(a6),t_glisscont(a6)
	and.b #$f,t_glisscont(a6)
	rts

QC_vibratowave:
	move.b t_cmdarg(a6),t_vibwave(a6)
	and.b #$f,t_vibwave(a6)
	rts

QC_finetune:
	move.b t_cmdarg(a6),d0
	and.w #$f,d0
	add.w d0,d0
	add.w d0,d0
	move.l (a3,d0.w),t_finetune(a6)
	rts

QC_jumploop:
	move.b t_cmdarg(a6),d0
	and.w #$f,d0
	beq QC_saveloop
	tst.b QC_loopcount
	beq QC_newloop
	subq.b #1,QC_loopcount
	beq QC_mend
	move.b #1,QC_jumpbreakflag
	rts
QC_newloop:
	move.b d0,QC_loopcount
	move.b #1,QC_jumpbreakflag
	rts
QC_saveloop:
	move.w QC_rowcount(pc),QC_looprow
	rts

QC_tremolowave:
	move.b t_cmdarg(a6),t_tremwave(a6)
	and.b #$f,t_tremwave(a6)
	rts

QC_initretrig:
	clr.b t_retrig(a6)
QC_retrignote:
	addq.b #1,t_retrig(a6)
	move.b t_cmdarg(a6),d0
	and.b #$f,d0
	cmp.b t_retrig(a6),d0
	bgt QC_mend
	clr.b t_retrig(a6)
	move.w t_dmabit(a6),d0
	or.w d0,QC_dmacon
	move.l t_start(a6),d0
	cmp.l #$c00000,d0
	blt .ok
	sub.l #$b80000,d0
.ok:	move.l d0,(a5)
	clr.l t_adrcount(a6)
	move.b (a6),t_samplenr(a6)
	sf t_looping(a6)
	st t_going(a6)
	move.w t_length(a6),4(a5)
	move.w t_period(a6),6(a5)
	rts

QC_volumefineup:
	move.b t_cmdarg(a6),d0
	and.w #$f,d0
	add.w d0,t_volume(a6)
	cmp.w #$40,t_volume(a6)
	blt QC_vfuset
	move.w #$40,t_volume(a6)
	tst.b t_enable(a6)
	beq QC_mend
	move.w t_mainvol(a6),t_realvol(a6)
	move.w t_mainvol(a6),8(a5)
	rts
QC_vfuset:
	tst.b t_enable(a6)
	beq QC_mend
	move.w t_volume(a6),d0
	mulu t_mainvol(a6),d0
	lsr.w #6,d0
	move.w d0,t_realvol(a6)
	move.w d0,8(a5)
	rts

QC_volumefinedown:
	move.b t_cmdarg(a6),d0
	and.w #$f,d0
	sub.w d0,t_volume(a6)
	bge QC_vfdset
	clr.w t_volume(a6)
	tst.b t_enable(a6)
	beq QC_mend
	clr.w 8(a5)
	rts
QC_vfdset:
	tst.b t_enable(a6)
	beq QC_mend
	move.w t_volume(a6),d0
	mulu t_mainvol(a6),d0
	lsr.w #6,d0
	move.w d0,t_realvol(a6)
	move.w d0,8(a5)
	rts

QC_notecut:
	moveq #0,d1
	move.b t_cmdarg(a6),d1
	and.b #$f,d1
	cmp.w QC_speedcount(pc),d1
	bgt QC_mend
	clr.w t_volume(a6)
	tst.b t_enable(a6)
	beq QC_mend
	clr.w 8(a5)
	rts

QC_notedelay:
	moveq #0,d1
	tst.b t_notenr(a6)
	blt QC_mend
	move.b t_cmdarg(a6),d1
	and.b #$f,d1
	cmp.w QC_speedcount(pc),d1
	bne QC_mend
	move.w t_dmabit(a6),d0
	or.w d0,QC_dmacon
	move.l t_start(a6),d0
	cmp.l #$c00000,d0
	blt .ok
	sub.l #$b80000,d0
.ok:	move.l d0,(a5)
	clr.l t_adrcount(a6)
	move.b (a6),t_samplenr(a6)
	sf t_looping(a6)
	st t_going(a6)
	move.w t_length(a6),4(a5)
	move.w t_period(a6),6(a5)
	rts

QC_patterndelay:
	move.b t_cmdarg(a6),QC_pattwait
	and.b #$f,QC_pattwait
	rts

QC_arptbl:rept 86		;if your assembler doensn't want to handle
	dc.b -1,0,1		;the "rept" command, you'll have to write
	endr			;a list incl. 256 numbers like this:
				;-1,0,1,-1,0,1,-1.. and so on.

QC_playfx:dc.l QC_arpeggio
	dc.l QC_slideup
	dc.l QC_slidedown
	dc.l QC_toneport
	dc.l QC_vibrato
	dc.l QC_toneportandvolslide
	dc.l QC_vibratoandvolslide
	dc.l QC_tremolo
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_volslide
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_playecommands
	dc.l QC_mend

QC_playefx:dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_retrignote
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_notecut
	dc.l QC_notedelay
	dc.l QC_mend
	dc.l QC_mend

QC_efx:	dc.l QC_setfilter
	dc.l QC_fineslideup
	dc.l QC_fineslidedown
	dc.l QC_glisscontrol
	dc.l QC_vibratowave
	dc.l QC_finetune
	dc.l QC_jumploop
	dc.l QC_tremolowave
	dc.l QC_mend
	dc.l QC_initretrig
	dc.l QC_volumefineup
	dc.l QC_volumefinedown
	dc.l QC_notecut
	dc.l QC_notedelay
	dc.l QC_patterndelay
	dc.l QC_mend


QC_fxaftersetperiod:
	dc.l QC_arpeggio
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_mend
	dc.l QC_sampleoffset
	dc.l QC_mend
	dc.l QC_posjump
	dc.l QC_volumechange
	dc.l QC_patternbreak
	dc.l QC_ecommands
	dc.l QC_setspeed


QC_vibtables:
	dc.w 0,3211,6392,9511,12539,15446,18204,20787,23169,25329
	dc.w 27244,28897,30272,31356,32137,32609,32767,32609,32137
	dc.w 31356,30272,28897,27244,25329,23169,20787,18204,15446
	dc.w 12539,9511,6392,3211
	dc.w 0,-3211,-6392,-9511,-12539,-15446,-18204,-20787,-23169,-25329
	dc.w -27244,-28897,-30272,-31356,-32137,-32609,-32767,-32609,-32137
	dc.w -31356,-30272,-28897,-27244,-25329,-23169,-20787,-18204,-15446
	dc.w -12539,-9511,-6392,-3211

	dc.w 32767,31744,30720,29696,28672,27648,26624,25600,24576,23552
	dc.w 22528,21504,20480,19456,18432,17408,16384,15360,14336,13312
	dc.w 12288,11264,10240,9216,8192,7168,6144,5120,4096,3072,2048,1024
	dc.w 0,-1024,-2048,-3072,-4096,-5120,-6144,-8168,-8192,-9216,-10240
	dc.w -11264,-12288,-13312,-14336,-15360,-16384,-17408,-18432,-19456
	dc.w -20480,-21504,-22528,-23552,-24576,-25600,-26624,-27648,-28672
	dc.w -29696,-30720,-31744,-32768

	dc.w 32767,32767,32767,32767,32767,32767,32767,32767,32767,32767
	dc.w 32767,32767,32767,32767,32767,32767,32767,32767,32767,32767
	dc.w 32767,32767,32767,32767,32767,32767,32767,32767,32767,32767
	dc.w 32767,32767
	dc.w -32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767
	dc.w -32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767
	dc.w -32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767,-32767
	dc.w -32767,-32767




QC_periods:dc.l QC_periodtable
	dc.l QC_periodtable+72
	dc.l QC_periodtable+144
	dc.l QC_periodtable+216
	dc.l QC_periodtable+288
	dc.l QC_periodtable+360
	dc.l QC_periodtable+432
	dc.l QC_periodtable+504
	dc.l QC_periodtable+576
	dc.l QC_periodtable+648
	dc.l QC_periodtable+720
	dc.l QC_periodtable+792
	dc.l QC_periodtable+864
	dc.l QC_periodtable+936
	dc.l QC_periodtable+1008
	dc.l QC_periodtable+1080


QC_periodtable:
	dc.w	856,808,762,720,678,640,604,570,538,508,480,453
	dc.w	428,404,381,360,339,320,302,285,269,254,240,226
	dc.w	214,202,190,180,170,160,151,143,135,127,120,113

	dc.w	850,802,757,715,674,637,601,567,535,505,477,450
	dc.w	425,401,379,357,337,318,300,284,268,253,239,225
	dc.w	213,201,189,179,169,159,150,142,134,126,119,113

	dc.w	844,796,752,709,670,632,597,563,532,502,474,447
	dc.w	422,398,376,355,335,316,298,282,266,251,237,224
	dc.w	211,199,188,177,167,158,149,141,133,125,118,112

	dc.w	838,791,746,704,665,628,592,559,528,498,470,444
	dc.w	419,395,373,352,332,314,296,280,264,249,235,222
	dc.w	209,198,187,176,166,157,148,140,132,125,118,111

	dc.w	832,785,741,699,660,623,588,555,524,495,467,441
	dc.w	416,392,370,350,330,312,294,278,262,247,233,220
	dc.w	208,196,185,175,165,156,147,139,131,124,117,110

	dc.w	826,779,736,694,655,619,584,551,520,491,463,437
	dc.w	413,390,368,347,328,309,292,276,260,245,232,219
	dc.w	206,195,184,174,164,155,146,138,130,123,116,109

	dc.w	820,774,730,689,651,614,580,547,516,487,460,434
	dc.w	410,387,365,345,325,307,290,274,258,244,230,217
	dc.w	205,193,183,172,163,154,145,137,129,122,115,109

	dc.w	814,768,725,684,646,610,575,543,513,484,457,431
	dc.w	407,384,363,342,323,305,288,272,256,242,228,216
	dc.w	204,192,181,171,161,152,144,136,128,121,114,108

	dc.w	907,856,808,762,720,678,640,604,570,538,508,480
	dc.w	453,428,404,381,360,339,320,302,285,269,254,240
	dc.w	226,214,202,190,180,170,160,151,143,135,127,120

	dc.w	900,850,802,757,715,675,636,601,567,535,505,477
	dc.w	450,425,401,379,357,337,318,300,284,268,253,238
	dc.w	225,212,200,189,179,169,159,150,142,134,126,119

	dc.w	894,844,796,752,709,670,632,597,563,532,502,474
	dc.w	447,422,398,376,355,335,316,298,282,266,251,237
	dc.w	223,211,199,188,177,167,158,149,141,133,125,118

	dc.w	887,838,791,746,704,665,628,592,559,528,498,470
	dc.w	444,419,395,373,352,332,314,296,280,264,249,235
	dc.w	222,209,198,187,176,166,157,148,140,132,125,118

	dc.w	881,832,785,741,699,660,623,588,555,524,494,467
	dc.w	441,416,392,370,350,330,312,294,278,262,247,233
	dc.w	220,208,196,185,175,165,156,147,139,131,123,117

	dc.w	875,826,779,736,694,655,619,584,551,520,491,463
	dc.w	437,413,390,368,347,328,309,292,276,260,245,232
	dc.w	219,206,195,184,174,164,155,146,138,130,123,116

	dc.w	868,820,774,730,689,651,614,580,547,516,487,460
	dc.w	434,410,387,365,345,325,307,290,274,258,244,230
	dc.w	217,205,193,183,172,163,154,145,137,129,122,115

	dc.w	862,814,768,725,684,646,610,575,543,513,484,457
	dc.w	431,407,384,363,342,323,305,288,272,256,242,228
	dc.w	216,203,192,181,171,161,152,144,136,128,121,114


QC_posstart:dc.l 0
QC_currpattpointer:dc.l 0
QC_currpatt:dc.w 0
QC_nrofpos:dc.w 0
QC_pos:	dc.w 0
QC_newposnr:dc.w 0
QC_speed:dc.w 6
QC_speedcount:dc.w 0
QC_breakrow:dc.w 0
QC_newrow:dc.w 0
QC_rowcount:dc.w 0
QC_arpcount:dc.w 0
QC_looprow:dc.w 0
QC_tempo:dc.w 125
QC_dmacon:dc.w 0
QC_newposflag:dc.b 0
QC_jumpbreakflag:dc.b 0
QC_loopcount:dc.b 0
QC_pattwait:dc.b 0
QC_introrow:dc.b 0,0
QC_ciaspeed:dc.l 0
QC_event:dc.b 0			;bit 0 = check vblank
QC_playpatt:dc.b 0

QC_quietsamp:
	dc.w 0,1
	dcb.b 20,0
	dc.w 0
	dc.w 1
	dc.l QC_quiet

t_notenr = 1
t_cmd = 2
t_cmdarg = 3
t_repeat = 4
t_replen = 8
t_period = 10
t_volume = 12
t_length = 14
t_finetune = 42
t_start = 18
t_dmabit = 22
t_notenr2 = 24
t_wantedperiod = 26
t_portdir = 28
t_vibwave = 29
t_glisscont = 30
t_vibcmd = 31
t_vibpos = 32
t_tremwave = 34
t_tremcmd = 35
t_trempos = 36
t_sampleoffset = 38
t_retrig = 39
t_portspeed = 40
t_adrcount = 46
t_looping = 41
t_going = 50
t_rep = 52
t_samplenr =51
t_reallength = 54
t_realstart = 56
t_enable = 60
t_mainvol = 62
t_realvol = 64

	even
QC_chan1:dc.l 0			;The note and command
	dc.l 0			;Repeat
	dc.w 0			;Replen
	dc.w 0			;Period
	dc.w 0			;Volume
	dc.w 0			;Length
	dc.w 0			;Unused
	dc.l 0			;Start
	dc.w 1			;DMAbit
	dc.w 0			;NoteNr2
	dc.w 0			;WantedPeriod
	dc.b 0			;Portdir
	dc.b 0			;VibWave
	dc.b 0			;Glisscont
	dc.b 0			;Vibcmd
	dc.w 0			;VibPos
	dc.b 0			;Tremwave
	dc.b 0			;Tremcmd
	dc.w 0			;Trempos
	dc.b 0			;Sampleoffset
	dc.b 0			;Retrig
	dc.b 0			;Portspeed
	dc.b 0			;Looping
	dc.l 0			;Finetune
	dc.l 0			;AdrCounter
	dc.b 0			;Going
	dc.b 0			;Samplenr
	dc.w 0			;Repeat in words
	dc.w 0			;Allways the length in words
	dc.l 0			;Real startpos
	dc.b $ff		;True = playable
	dc.b 0
	dc.w $40		;Mainvol
	dc.w 0			;Realvol

	even
QC_chan2:dc.l 0
	dc.l 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.l 0
	dc.w 2
	dc.w 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.l 0
	dc.l 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.w 0
	dc.l 0
	dc.b $ff
	dc.b 0
	dc.w $40		;Mainvol
	dc.w 0

	even
QC_chan3:dc.l 0
	dc.l 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.l 0
	dc.w 4
	dc.w 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.l 0
	dc.l 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.w 0
	dc.l 0
	dc.b $ff
	dc.b 0
	dc.w $40		;Mainvol
	dc.w 0

	even
QC_chan4:dc.l 0
	dc.l 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.w 0
	dc.l 0
	dc.w 8
	dc.w 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.b 0
	dc.l 0
	dc.l 0
	dc.b 0
	dc.b 0
	dc.w 0
	dc.w 0
	dc.l 0
	dc.b $ff
	dc.b 0
	dc.w $40		;Mainvol
	dc.w 0


	SECTION Tables,BSS

QC_samplepointers:	ds.l 256
QC_patternpointers:	ds.l 256


	SECTION Sound,Data_C

QC_quiet:dc.l 0

