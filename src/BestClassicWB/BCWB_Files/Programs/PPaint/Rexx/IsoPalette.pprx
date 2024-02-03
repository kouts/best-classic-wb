/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: IsoPalette.pprx 1.0 */

/** ENG
  This script generates an iso-palette composed of equally-spaced colors
  in the color cube (color mode) or a grayscale palette (gray mode).
*/

/** DEU
 Dieses Skript dient zum Erzeugen einer sog. "ISO-Palette", d. h.
 einer Farbpalette, in der alle Farbtöne gleichmäßig über den Farbraum
 des Farbwürfels (im Farbmodus) oder der Graustufenpalette (im 
 Graustufenmodus) verteilt sind.
*/

/** ITA
  Questo script genera una iso-palette composta da colori disposti a distanza
  eguale nello spazio cubico dei colori (modo colore) o una tavolozza a toni di
  grigio (modo grigio).
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT graymode
ELSE DO
	PPPORT = 'PPAINT'
	graymode = 0
END

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

LockGUI

/*         Entries  R G B  Clrs Grays  */
/*         --------------------------  */
colorset.0 = '256   7 7 5  245   11'
colorset.1 = '128   5 6 4  120   8 '
colorset.2 = '64    4 5 3   60   4 '
colorset.3 = '32    3 3 3   27   5 '
colorset.4 = '16    2 3 2   12   4 '
colorset.5 = '8     2 2 2    8   0 '


Get 'COLORS'
cnum = RESULT
DO set = 0 to 5
	PARSE VAR colorset.set cn rbits gbits bbits . gnum .
	IF cn = cnum THEN
		LEAVE
END
IF set > 5 THEN
	graymode = 1

palette = ''
IF graymode = 0 THEN DO
	rstep = 255 / (rbits - 1)
	gstep = 255 / (gbits - 1)
	bstep = 255 / (bbits - 1)

	DO red = 0 TO 255 BY rstep
		DO green = 0 TO 255 BY gstep
			DO blue = 0 TO 255 BY bstep
				palette = palette TRUNC(red + 0.5) TRUNC(green + 0.5) TRUNC(blue + 0.5)
			END
		END
	END
	IF gnum > 0 THEN DO
		gstep = 255 / (gnum + 1)
		DO gry = gstep TO 255-gstep BY gstep
			igry = TRUNC(gry + 0.5)
			palette = palette igry igry igry
		END
	END
END
ELSE DO
	gstep = 255 / (cnum - 1)
	DO gry = 0 TO 255 BY gstep
		igry = TRUNC(gry + 0.5)
		palette = palette igry igry igry
	END
END

SetColors 'COLORS "'palette'"'

UnlockGUI
