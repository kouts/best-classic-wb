/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: AnimToAnimBrush.pprx 1.1 */

/** ENG
  This script converts the current animation into an anim-brush.

  Please note that this script is not equivalent to the "Define
  Brush/Anim-Brush" tool in the toolbar, which is used to create
  an anim-brush of any size. This script creates an anim-brush
  as large as the current animation.
*/

/** DEU
  Dieses Skript dient zur Umwandlung der aktuellen Animation in einen
  Anim-Brush.

  Hinweis: Dieses Skript unterscheidet sich insofern von der Funktion
  "Pinsel/Animationspinsel definieren" in der Werkzeugleiste, als daß es
  keinen Animationspinsel beliebiger Größe erstellen kann. Vielmehr ist die
  Größe der mit diesem Skript erstellten Animationspinsel immer identisch
  mit der der aktuellen Animation.

*/

/** ITA
  Questo script converte l'animazione attuale in un anim-brush.

  Si noti che questo script non equivale allo strumento "Definire
  pennello/Anim-Brush" della barra degli strumenti, che si può usare per
  creare un anim-brush di dimensione qualsiasi. Questo script crea un
  anim-brush avente dimensioni pari a quelle dell'animazione corrente.
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
	SAY 'Personal Paint Rexx port could not be opened.'
	EXIT 10
END

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

Get 'LANG'
IF RESULT = 1 THEN DO		/* Deutsch */
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO				/* English */
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END


FreeBrush
IF RC ~= 0 THEN
	EXIT RC


LockGUI
loaded = 0
GetFrames
frnum = RESULT
IF frnum = 0 THEN DO
	LoadAnimation 'NEW'
	IF RC = 0 THEN DO
		GetFrames
		frnum = RESULT
		loaded = 1
	END
END
IF frnum > 0 THEN DO
	Get 'IMAGEW'
	x1 = RESULT - 1
	Get 'IMAGEH'
	y1 = RESULT - 1

	GetFramePosition
	fpos = RESULT
	SetFramePosition 1
	DefineBrush 0 0 x1 y1 'FRAMES' frnum
	SetFramePosition fpos
	IF RC = 0 THEN
		SaveAnimBrush
	FreeBrush 'FORCE'
END
IF loaded THEN DO
	DeleteFrames 'ALL FORCE'
	ClearImage 'FORCE'
END
UnlockGUI
