/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: XTool.pprx 1.0 */

/** ENG
 This is a example of a "tool script". This tool, entirely created in
 Rexx, draws an "X" on the image, using the current brush, foreground
 color and paint mode.
*/

/** DEU
 Dies ist ein Beispiel für ein "Tool Skript". Dieses ausschließlich
 in Rexx geschriebene Tool zeichnet ein "X" auf das Bild, wobei die
 aktuellen Einstellungen für Brush, Vordergrundfarbe und Malmodus
 verwendet werden.
*/

/** ITA
 Questo è un esempio di "strumento realizzato tramite script". Questo
 strumento, scritto totalmente in Rexx, traccia una "X" sull'immagine,
 usando il pennello, il colore di primo piano e il modo di disegno attuali.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT button x0 y0 .
ELSE
	EXIT 0  /* macro execution only */

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

Get 'LANG'
IF RESULT = 1 THEN DO		/* Deutsch */
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN		/* Italiano */
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
ELSE				/* English */
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

prev_xp = x0
prev_yp = y0
drawn = 0

DO FOREVER
	GetMousePosition
	PARSE VAR RESULT xp yp .

	IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
		IF drawn THEN
			Undo 2
		DrawLine x0 y0 xp yp
		DrawLine xp y0 x0 yp
		prev_xp = xp
		prev_yp = yp
		drawn = 1
	END
	ELSE WaitForEvent

	GetMouseButton
	IF RESULT ~= button THEN
		LEAVE
END
