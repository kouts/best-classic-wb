/* Personal Paint Amiga Rexx script - Copyright © 1997 Cloanto Italia srl */

/* $VER: DefineAnimGif.pprx 1.0 */

/** ENG
 This tool works exactly like the Define Anim-Brush tool which is part
 of the Personal Paint tool bar (three clicks on Define Brush), but it
 additionally stores frame timing information in the anim-brush in a
 format compatible with GIF animations, which can then be saved by the
 SaveAnimGif script.
*/

/** DEU
 Dieser nützliche Helfer arbeitet genau wie die Funktion zum Erstellen eines
 Animationspinsels in der Werkzeugleiste von Personal Paint (dreifacher
 Mausklick auf das Symbol "Pinsel definieren"). Im Gegensatz zu diesem werden
 jedoch zusätzlich Informationen zum Einzelbildtiming in einem zu
 GIF-Animationen kompatiblen Format mitgespeichert, welche anschließend sich
 mit dem Skript SaveAnimGif sichern lassen.
*/

/** ITA
 Questo strumento funziona esattamente come quello Definire Anim-Brush,
 che fa parte della barra degli strumenti di Personal Paint (tre click
 su Definire pennello), ma in più immagazzina informazioni sulla
 temporizzazione dei fotogrammi all'interno dell'anim-brush, in un formato
 compatibile con le animazioni GIF, che si può poi salvare tramite lo script
 SaveAnimGif.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT button x0 y0 rwidth rheight .
ELSE
	EXIT 0  /* macro execution only */

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

Get 'LANG'
IF RESULT = 1 THEN DO		/* Deutsch */
	txt_title_req     = "GIF Anim-Pinsel definieren"
	txt_gad_getf      = "_Einzelbilder:"
	txt_gad_dir       = "_Richtung:"
	txt_gad_dir0      = "Vorwärts"
	txt_gad_dir1      = "Rückwärts"
	txt_err_noanim    = "Umgebung enthält_keine Animation"
	txt_err_oldclient = "Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich"
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_req     = "Creare Anim-Brush GIF"
	txt_gad_getf      = "_Fotogrammi:"
	txt_gad_dir       = "Di_rezione:"
	txt_gad_dir0      = "Avanti"
	txt_gad_dir1      = "Indietro"
	txt_err_noanim    = "L'ambiente attuale_non contiene un'animazione"
	txt_err_oldclient = "Questa procedura richiede_una versione più recente_di Personal Paint"
END
ELSE DO				/* English */
	txt_title_req     = "Define GIF Anim-Brush"
	txt_gad_getf      = "Get _frames:"
	txt_gad_dir       = "_Direction:"
	txt_gad_dir0      = "Forward"
	txt_gad_dir1      = "Backward"
	txt_err_noanim    = "The current environment_does not contain an animation"
	txt_err_oldclient = "This script requires a newer_version of Personal Paint"
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

LockGUI
GetFrames
frnum = RESULT
IF frnum > 0 THEN DO
	Request '"'txt_title_req'" ' ||,
	         '"INTSTR = ""'txt_gad_getf'"", 1, 'frnum', 'frnum' ' ||,
	         ' CYCLE = ""'txt_gad_dir'"", 2, 0, ""'txt_gad_dir0'"", ""'txt_gad_dir1'"" "'
	IF RC = 0 THEN DO
		get_fnum = RESULT.1
		IF RESULT.2 = 1 THEN DO
			get_dir = 'BACK'
			get_step = -1
		END
		ELSE DO
			get_dir = ''
			get_step = 1
		END

		Version 'PROGRAM'
		PARSE VAR RESULT pver'.'prev
		IF pver < 7 | (pver = 7 & prev < 1) THEN
			button = button + 1

		IF button = 3 THEN
			get_mode = 'ERASE'
		ELSE
			get_mode = ''
		DefineBrush x0 y0 x0+rwidth-1 y0+rheight-1 'FRAMES' get_fnum get_dir get_mode

		GetFramePosition
		pos = RESULT
		delays = ''
		DO frm = pos FOR get_fnum BY get_step
			IF frm = 0 THEN
				frm = frnum
			ELSE IF frm > frnum THEN
				frm = 1
			GetFrameDelay 'FRAME' frm
			delays = delays TRUNC((RESULT * 100/60) + 0.5)
		END
		SetBrushInfo 'ANNOTATION "LOOP -1 DELAY' delays'"'
	END
END
ELSE RequestNotify 'PROMPT "'txt_err_noanim'"'

UnlockGUI
