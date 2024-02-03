/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: EmbossAnim.pprx 1.0 */

/** ENG
 This script applies the emboss filter to the current animation. This
 script is mainly intended as a component that can be modified, extended
 or otherwise integrated with other programs.
*/

/** DEU
 Mit diesem Skript läßt sich der Relieffilter auf die aktuelle
 Animation anwenden. Es läßt sich darüber hinaus auch als Komponente
 für andere Operationen verwenden und entsprechend modifizieren,
 erweitern oder auf anderem Wege mit anderen Programmen nutzen.
*/

/** ITA
 Questo script applica il filtro a sbalzo (emboss) all'animazione corrente.
 Si può considerare questo script come un componente che si può modificare,
 estendere o integrare in altri modi all'interno di altri programmi.
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
	txt_req_load      = 'Animation auswählen'
	txt_err_abort     = 'Verarbeitung wurde abgebrochen'
	txt_err_proc      = 'Fehler bei der Verarbeitung: '
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO		/* Italiano */
	txt_req_load      = 'Selezionare animazione'
	txt_err_abort     = 'Elaborazione annullata'
	txt_err_proc      = 'Errore nell''elaborazione: '
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO		/* English */
	txt_req_load      = 'Select Animation'
	txt_err_abort     = 'User abort during processing'
	txt_err_proc      = 'Error during processing: '
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

/*
   Change the variable below to use another filter
   and/or edit and use a Set command such as the following one
*/

filtername = 'Emboss High'

/*
   Set '"FILTER = ""Emboss High"", 0, 0,0,0,0,0, 0,0,0,0,0, 0,0,1,1,0, 0,0,1,0,-1,  0,0,0,-1,-1,  1, 204,0,0"'
*/

LockGUI
GetFrames
frames = RESULT
IF frames = 0 THEN DO
	RequestFile '"'txt_req_load'"'
	IF RC = 0 THEN DO
		LoadAnimation RESULT 'NEW'
		GetFrames
		frames = RESULT
	END
END
IF frames > 0 THEN DO
	GetFramePosition
	savepos = RESULT
	errcode = 0
	SetFramePosition 1
	DO fnum = 1 TO frames
		Process '"'filtername'"'
		IF RC ~= 0 THEN DO
			IF RC = 5 THEN
				errmess = txt_err_abort
			ELSE
				errmess = txt_err_proc || RC
			errcode = RC
			LEAVE
		END
		SetFramePosition 'NEXT'
	END
	IF errcode > 0 THEN
		RequestNotify 'PROMPT "'errmess'"'

	SetFramePosition savepos
END
UnlockGUI
