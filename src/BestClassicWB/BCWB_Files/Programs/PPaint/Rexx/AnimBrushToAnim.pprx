/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: AnimBrushToAnim.pprx 1.2 */

/** ENG
  This script converts the current anim-brush into an animation, creating
  the animation in the current environment.

  This script performs a format conversion. It does not "paste" all
  anim-brush frames to a specific position of the current animation,
  as can be done by pressing a mouse button when <Caps Lock> is on.
*/

/** DEU
  Dieses Skript wandelt den aktuellen AnimBrush in eine Animation um. Dabei
  wird die aktuelle Arbeitsumgebung verwendet.

  Dieses Skript führt eine Formatkonvertierung durch. Dabei werden jedoch
  nicht alle Einzelbilder eines Animationspinsels an eine bestimmte Position
  einer Animation kopiert; hierzu ist bei aktiver <Caps lock>-Taste eine
  Maustaste zu drücken.
*/

/** ITA
  Questo script converte l'anim-brush corrente in un'animazione, creando
  l'animazione nell'ambiente attivo.

  Questo script effettua una conversione di formato. Non "incolla" tutti i
  fotogrammi di anim-brush in una specifica posizione dell'animazione corrente,
  come si può fare premendo un tasto del mouse quando <Caps Lock> è
  attivo.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT
ELSE
	PPPORT = 'PPAINT'

IF ~SHOW('P', PPPORT) THEN DO
	IF EXISTS('PPaint:PPaint') THEN DO
		ADDRESS COMMAND 'Run >NIL: PPaint:PPaint'
		DO 30 WHILE ~SHOW('P',PPPORT)
			 ADDRESS COMMAND 'Wait >NIL: 1 SEC'
		END
	END
	ELSE DO
		SAY "Personal Paint could not be loaded."
		EXIT 10
	END
END

IF ~SHOW('P', PPPORT) THEN DO
	SAY 'Personal Paint Rexx port could not be opened'
	EXIT 10
END

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

Get 'LANG'
IF RESULT = 1 THEN DO		/* Deutsch */
	txt_err_nofrm     = 'Frameerstellung für Umgebung_nicht möglich'
	txt_err_nofmt     = 'Einstellung des Umgebungsformats_nicht möglich.'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO		/* Italiano */
	txt_err_nofrm     = 'Impossibile trovare fotogrammi'
	txt_err_nofmt     = 'Impossibile impostare formato'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO		/* English */
	txt_err_nofrm     = 'Environment frames_cannot be created'
	txt_err_nofmt     = 'Environment format_cannot be set'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

FreeEnvironment 'QUERY'
IF RC ~= 0 THEN
	EXIT RC


LockGUI
loaded = 0
GetBrushAttributes 'FRAMES'
frnum = RESULT
IF frnum = 0 THEN DO
	LoadAnimBrush
	IF RC = 0 THEN DO
		GetBrushAttributes 'FRAMES'
		frnum = RESULT
		loaded = 1
	END
END
IF frnum > 0 THEN DO
	GetBrushAttributes 'WIDTH'
	bw = RESULT
	GetBrushAttributes 'HEIGHT'
	bh = RESULT
	GetBrushAttributes 'COLORS'
	bcol = RESULT
	GetBrushAttributes 'DISPLAY'
	bdisp = RESULT
	GetBrushAttributes 'HANDLEX'
	bhx = RESULT
	GetBrushAttributes 'HANDLEY'
	bhy = RESULT
	GetBrushAttributes 'LENGTH'
	bfl = RESULT
	GetBrushAttributes 'FRAMEPOSITION'
	bfp = RESULT

	GetVideoModeInfo bdisp
	IF RC ~= 0 THEN DO
		GetBestVideoMode 'WIDTH' bw 'HEIGHT' bh 'COLORS' bcol 'ANIMATION'
		PARSE VAR RESULT bdisp .
	END

	Get 'GCLIP'
	saveclip = RESULT
	Set '"GCLIP=0"'

	DeleteFrames 'ALL FORCE'
	ClearImage 'FORCE'
	del_anim = 1

	Set '"IMAGEW='bw'" "IMAGEH='bh'" "COLORS='bcol'" "DISPLAY='bdisp'" "SCREENW='bw'" "SCREENH='bh'" "ASCROLL=0"'
	IF RC ~= 0 THEN DO
		GetBestVideoMode 'WIDTH' bw 'HEIGHT' bh 'COLORS' bcol
		PARSE VAR RESULT bdisp .
		Set '"IMAGEW='bw'" "IMAGEH='bh'" "COLORS='bcol'" "DISPLAY='bdisp'" "SCREENW='bw'" "SCREENH='bh'" "ASCROLL=0"'
	END
	IF RC = 0 THEN DO
		UseBrushPalette
		AddFrames frnum
		SetFrameDelay 0 'ALL'
		IF RC = 0 THEN DO
			SetFramePosition 1
			SetBrushAttributes 'HANDLEX 0 HANDLEY 0 LENGTH' frnum 'FRAMEPOSITION 1'
			SetPaintMode 'REPLACE'
			DO frm = 1 TO frnum
				PutBrush 0 0
				UseBrushPalette
				SetFramePosition 'NEXT'
			END
			SaveAnimation
			IF RC = 5 THEN
				del_anim = 0
		END
		ELSE
			RequestNotify 'PROMPT "'txt_err_nofrm'"'
	END
	ELSE
		RequestNotify 'PROMPT "'txt_err_nofmt'"'

	SetBrushAttributes 'HANDLEX' bhx 'HANDLEY' bhy 'LENGTH' bfl 'FRAMEPOSITION' bfp

	IF del_anim THEN DO
		DeleteFrames 'ALL FORCE'
		ClearImage 'FORCE'
	END
	Set '"GCLIP='saveclip'"'
END
IF loaded THEN
	FreeBrush 'FORCE'

UnlockGUI
