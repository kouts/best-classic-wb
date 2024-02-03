/* Personal Paint Amiga Rexx script - Copyright © 1997 Cloanto Italia srl */

/* $VER: LightTool.pprx 1.0 */

/** ENG
 This tool lightens (left mouse button) or darkens
 (right mouse button) the image area it is used on.

 The tool uses the current brush. The predefined
 one-pixel brush is ideal for use on single pixels.
 Different "oil painting" effects can be achieved
 with brushes in different sizes and shapes.
*/

/** DEU
 Durch die Anwendung dieses Skripts auf einen  bestimmten Bildbereich läßt
 sich dieser wahlweise abdunkeln (linke Maustaste) oder aufhellen (Rechte
 Maustaste).

 Zur Ausführung dieses Werkzeugs wird der aktuelle Pinsel verwendet. Der
 vordefinierte, einen Punkt große Pinsel ist zur Bearbeitung einzelner Pixel
 ideal geeignet. Mit Pinseln unterschiedlicher Größen und Formen lassen sich
 unterschiedliche "Ölgemälde"-Effekte erzielen. */

/** ITA
 Questo strumento schiarisce (tasto sinistro del mouse) o scurisce
 (tasto delstro del mouse) l'area dell'immagine su cui è usato.

 Lo strumento utilizza il pennello attuale. Il pennello predefinito
 di un pixel è l'ideale per l'uso su pixel singoli.
 Si possono ottenere diversi effetti a "pittura a olio" con pennelli
 aventi forme e dimensioni varie.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT button x0 y0 .
ELSE
	EXIT 0  /* macro execution only */

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000

Version 'REXX'
IF RESULT < 7 THEN DO
	Get 'LANG'
	IF RESULT = 1 THEN		/* Deutsch */
		txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	ELSE IF RESULT = 2 THEN		/* Italiano */
		txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	ELSE				/* English */
		txt_err_oldclient = 'This script requires a newer_version of Personal Paint'

	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

prev_xp = x0
prev_yp = y0
drawn = 0
GetPaintMode
svpmode = RESULT
GetPen 'FOREGROUND'
svfpen = RESULT
SetPaintMode 'COLOR'
Get 'COLORS'
cnum = RESULT
light. = ''
dark. = ''

DO FOREVER
	GetMousePosition
	PARSE VAR RESULT xp yp .

	IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
		IF ~drawn THEN DO
			xp = x0
			yp = y0
		END
		GetPixel xp yp
		pxcol = RESULT
		GetColors 'FROM' pxcol 'TO' pxcol 'HSV'
		PARSE VAR RESULT hue sat val .
		excl = pxcol
		exnum = 1
		newpxcol = -1
		IF button = 1 THEN DO
			IF light.pxcol = '' THEN DO
				IF val < 100 THEN DO
					val = val + 1
					DO FOREVER
						FindColor 'COLOR "'hue sat val'" HSV EXCLUDE "'excl'"'
						col = RESULT
						GetColors 'FROM' col 'TO' col 'HSV'
						PARSE VAR RESULT hue2 sat2 val2 .
						dhue = DeltaHue(hue, hue2)
						IF val2 > val & dhue < 20 THEN DO
							newpxcol = col
							LEAVE
						END
						excl = excl col
						exnum = exnum + 1
						IF exnum = cnum THEN
							LEAVE
					END
				END
				light.pxcol = newpxcol
			END
			ELSE newpxcol = light.pxcol
		END
		ELSE DO
			IF dark.pxcol = '' THEN DO
				IF val > 0 THEN DO
					val = val - 1
					DO FOREVER
						FindColor 'COLOR "'hue sat val'" HSV EXCLUDE "'excl'"'
						col = RESULT
						GetColors 'FROM' col 'TO' col 'HSV'
						PARSE VAR RESULT hue2 sat2 val2 .
						dhue = DeltaHue(hue, hue2)
						IF val2 < val & dhue < 20 THEN DO
							newpxcol = col
							LEAVE
						END
						excl = excl col
						exnum = exnum + 1
						IF exnum = cnum THEN
							LEAVE
					END
				END
				dark.pxcol = newpxcol
			END
			ELSE newpxcol = dark.pxcol
		END
		IF newpxcol >= 0 THEN DO
			SetPen 'FOREGROUND' newpxcol
			PutBrush xp yp
		END
		prev_xp = xp
		prev_yp = yp
		drawn = 1
	END
	ELSE WaitForEvent

	GetMouseButton
	IF RESULT ~= button THEN
		LEAVE
END

SetPen 'FOREGROUND' svfpen
SetPaintMode svpmode

EXIT



DeltaHue: PROCEDURE

	h1 = ARG(1)
	h2 = ARG(2)
	d1 = ABS(h1-h2)
	d2 = 360 - MAX(h1,h2) + MIN(h1,h2)

	RETURN MIN(d1,d2)
