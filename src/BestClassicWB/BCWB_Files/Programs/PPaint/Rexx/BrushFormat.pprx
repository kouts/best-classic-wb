/* Personal Paint Amiga Rexx script - Copyright © 1997 Cloanto Italia srl */

/* $VER: BrushFormat.pprx 1.1 */

/** ENG
 This script makes it possible to exactly set a new brush
 format (size and number of colors).

 The new brush size can be specified in pixels or in
 percentage of the original size. A value of 0 in one of
 the two fields indicates that the original aspect ratio
 should be preserved.

 If the brush size is reduced and the number of colors
 is increased, and the "Color Average Resize" setting
 is enabled, then the brush palette is extended with new
 colors. This results in better antialiasing.
*/

/** DEU
 Dieses Skript ermöglicht die präzise Einstellung eines Pinselformats (d. h.
 Größe und Anzahl der Farben).

 Der neue Größenwert läßt sich wahlweise in Pixeln oder in Prozent der
 ursprünglichen Größe angeben. Wird in eines der beiden Felder der Wert 0
 eingetragen, so bedeutet dies, daß das ursprüngliche Höhen-/
 Breitenverhältnis erhalten bleiben soll.

 Wenn die Pinselgröße verringert, die Anzahl der Farben gleichzeitig erhöht
 und die Option "Farben mit Größe ändern" aktiviert wird, werden der
 Pinselpalette neue Farben hinzugefügt, um eine bessere Kantenglättung zu
 ermöglichen.
*/

/** ITA
 Con questo script è possibile impostare con precisione il formato di
 un nuovo pennello (dimensioni e numero di colori).

 Si possono specificare le dimensioni del nuovo pennello in pixel o come
 percentuale delle dimensioni originali. Un valore di 0 in uno dei due
 campi indica al programma di conservare l'aspetto originale (rapporto
 larghezza/altezza).

 Se si riducono le dimensioni del pennello e si aumenta il numero di colori,
 ed è attivo il parametro "Rimodellamento con media", la tavolozza del
 pennello sarà ampliata con nuovi colori. Ciò consente un miglior effetto
 di smorzamento seghettature (antialiasing).
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
	txt_title_format  = "Pinselformat"
	txt_gad_width     = "_Breite:"
	txt_gad_height    = "_Höhe:"
	txt_gad_unit      = "_Einheit:"
	txt_gad_unit0     = "Pixel"
	txt_gad_unit1     = "Prozent"
	txt_gad_colors    = "_Farben:"
	txt_err_oldclient = "Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich"
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_format  = "Formato pennello"
	txt_gad_width     = "_Larghezza:"
	txt_gad_height    = "Al_tezza:"
	txt_gad_unit      = "_Unità:"
	txt_gad_unit0     = "Pixel"
	txt_gad_unit1     = "Percentuale"
	txt_gad_colors    = "C_olori:"
	txt_err_oldclient = "Questa procedura richiede_una versione più recente_di Personal Paint"
END
ELSE DO			/* English */
	txt_title_format  = "Brush Format"
	txt_gad_width     = "_Width:"
	txt_gad_height    = "_Height:"
	txt_gad_unit      = "_Unit:"
	txt_gad_unit0     = "Pixels"
	txt_gad_unit1     = "Percentage"
	txt_gad_colors    = "C_olors:"
	txt_err_oldclient = "This script requires a newer_version of Personal Paint"
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

LockGUI
GetCurrentBrush
currbsh = RESULT
custombsh = (WORD(currbsh, 1) = 'BRUSH')

GetBrushAttributes 'WIDTH'
bwidth = RESULT
GetBrushAttributes 'HEIGHT'
bheight = RESULT

req = ,
   'INTSTR = ""'txt_gad_width'"", 0, 32000, 'bwidth' ' ||,
   'INTSTR = ""'txt_gad_height'"", 0, 32000, 'bheight' ' ||,
   'CYCLE = ""'txt_gad_unit'"", 2, 0, ""'txt_gad_unit0'"", ""'txt_gad_unit1'""'

IF custombsh THEN DO
	GetBrushAttributes 'COLORS'
	bcolors = RESULT
	DO bdepth = 1 TO 8
		IF 2 ** bdepth = bcolors THEN
			BREAK
	END
	req = req ||,
        ' SEPARATOR ' ||,
        ' COLSLIDE = ""'txt_gad_colors'"", 1, 8, 'bdepth
END

Request '"'txt_title_format'" "'req'"'
IF RC = 0 THEN DO
	new_bwidth  = RESULT.1
	new_bheight = RESULT.2
	unit        = RESULT.3
	IF custombsh THEN
		new_bcolors = 2 ** RESULT.4

	IF unit = 1 THEN DO
		new_bwidth  = TRUNC(bwidth * new_bwidth / 100 + 0.5)
		new_bheight = TRUNC(bheight * new_bheight / 100 + 0.5)
	END

	IF new_bwidth ~= 0 | new_bheight ~= 0 THEN DO
		IF new_bwidth = 0 THEN
			new_bwidth = TRUNC(new_bheight * (bwidth / bheight) + 0.5)

		IF new_bwidth < 1 THEN
			new_bwidth = 1

		IF new_bheight = 0 THEN
			new_bheight = TRUNC(new_bwidth / (bwidth / bheight) + 0.5)

		IF new_bheight < 1 THEN
			new_bheight = 1

		IF custombsh THEN DO
			IF new_bwidth ~= bwidth | new_bheight ~= bheight | new_bcolors ~= bcolors THEN
				SetBrushAttributes 'WIDTH' new_bwidth 'HEIGHT' new_bheight 'COLORS' new_bcolors 'EXTENDPALETTE'
		END
		ELSE DO
			IF new_bwidth ~= bwidth | new_bheight ~= bheight THEN
				SetCurrentBrush WORD(currbsh,1) 'WIDTH' new_bwidth 'HEIGHT' new_bheight
		END
	END
END

UnlockGUI
