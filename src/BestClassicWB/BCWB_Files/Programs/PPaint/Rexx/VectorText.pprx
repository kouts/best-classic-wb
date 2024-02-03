/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: VectorText.pprx 1.1 */

/** ENG
 This script renders a vector text in the current environment.
 A requester allows the user to select several parameters, such as
 font, text string, angle, shear angle, bold level, antialiasing, etc.
 The text is drawn using the current foreground color.
*/

/** DEU
 Mit diesem Skript läßt sich ein Vektortext in der aktuellen
 Umgebung erzeugen. Das dazugehörige Dialogfenster enthält
 Einstellmöglichkeiten für verschiedene Parameter, wie Font,
 Textstring, Winkel, Neigungsgrad, Stärke, Kantenglättung,
 usw. Die Textdarstellung erfolgt in der aktuellen Vordergrundfarbe.
*/

/** ITA
 Questo script compone un testo vettoriale nell'ambiente corrente.
 Una finestra di dialogo permette di selezionare diversi parametri, come
 font, stringa di testo, angolo, inclinazione, spessore, smorzamento
 seghettature (antialiasing), ecc. Il testo viene scritto utilizzando
 l'attuale colore di primo piano.
*/

IF ARG(1, EXISTS) THEN
	PARSE ARG PPPORT x0 y0 rwidth rheight .
ELSE
	EXIT 0  /* macro execution only */

ADDRESS VALUE PPPORT
OPTIONS RESULTS
OPTIONS FAILAT 10000


Get 'LANG'
IF RESULT = 1 THEN DO		/* Deutsch */
	txt_title_req     = "Texteinstellungen"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Text:"
	txt_string_text   = "Text"
	txt_gad_angle     = "Wink_el:"
	txt_gad_shear     = "_Neigung:"
	txt_gad_boldx     = "Stärke _X:"
	txt_gad_boldy     = "Stärke _Y:"
	txt_gad_aalias    = "_Kantenglättung:"
	txt_gad_aalias0   = "Keine"
	txt_gad_aalias1   = "Schwach"
	txt_gad_aalias2   = "Mittel"
	txt_gad_aalias3   = "Stark"
	txt_gad_kratio    = "_Verhältnis erhalten:"
	txt_gad_kbline    = "_Grundlinie erhalten:"
	txt_err_oldclient = "Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich"
	txt_err_nofonts   = "Vektorfonts nicht auffindbar"
	txt_err_vtext     = "VektorText-Fehler: "
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_req     = "Parametri testo"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Testo:"
	txt_string_text   = "Testo"
	txt_gad_angle     = "Ang_olo:"
	txt_gad_shear     = "In_clinazione:"
	txt_gad_boldx     = "Grassetto _X:"
	txt_gad_boldy     = "Grassetto _Y:"
	txt_gad_aalias    = "Antialia_s:"
	txt_gad_aalias0   = "Nessuno"
	txt_gad_aalias1   = "Basso"
	txt_gad_aalias2   = "Medio"
	txt_gad_aalias3   = "Alto"
	txt_gad_kratio    = "Asp_etto:"
	txt_gad_kbline    = "Linea di _base:"
	txt_err_oldclient = "Questa procedura richiede_una versione più recente_di Personal Paint"
	txt_err_nofonts   = "Non vi sono font vettoriali"
	txt_err_vtext     = "Errore comando VectorText: "
END
ELSE DO				/* English */
	txt_title_req     = "Text Settings"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Text:"
	txt_string_text   = "Text"
	txt_gad_angle     = "_Angle:"
	txt_gad_shear     = "_Shear:"
	txt_gad_boldx     = "Bold _X:"
	txt_gad_boldy     = "Bold _Y:"
	txt_gad_aalias    = "A_ntialias:"
	txt_gad_aalias0   = "None"
	txt_gad_aalias1   = "Low"
	txt_gad_aalias2   = "Medium"
	txt_gad_aalias3   = "High"
	txt_gad_kratio    = "Keep _Ratio:"
	txt_gad_kbline    = "Keep _Baseline:"
	txt_err_oldclient = "This script requires a newer_version of Personal Paint"
	txt_err_nofonts   = "Vector fonts not found"
	txt_err_vtext     = "VectorText error: "
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END


def_font_path = "FONTS:"
max_text_size = 8000

font_path = LoadSet('PP_VectorPath', def_font_path, 1, 0)


ftot = 0
vftfname = 'ENV:PP_VectorFonts'
IF ~OPEN(fexists, vftfname) THEN DO
	ADDRESS COMMAND 'List >'vftfname' 'font_path' PAT=#?.otag NOHEAD LFORMAT="%s"'
	ADDRESS COMMAND 'Sort 'vftfname vftfname'.s'
	IF RC = 0 THEN DO
		ADDRESS COMMAND 'Delete >NIL: 'vftfname
		ADDRESS COMMAND 'Copy >NIL: 'vftfname'.s' vftfname
		ADDRESS COMMAND 'Delete >NIL: 'vftfname'.s'
	END
END
ELSE CALL CLOSE(fexists)

IF OPEN('listfile', vftfname) THEN DO
	DO FOREVER
		fline = READLN('listfile')
		IF EOF('listfile') THEN BREAK
		ftot = ftot + 1
		fontname.ftot = LEFT(fline, LENGTH(fline) - 5)
	END
	CALL CLOSE('listfile')
END

IF ftot = 0 THEN DO
	RequestNotify 'PROMPT "'txt_err_nofonts'"'
	EXIT 10
END


fntnum = LoadSet('Font', 0)
text   = LoadSet('Text', txt_string_text)
angle  = LoadSet('Angle', 0)
shear  = LoadSet('Shear', 0)
boldx  = LoadSet('BoldX', 0)
boldy  = LoadSet('BoldY', 0)
aalias = LoadSet('Antialias', 0)
kratio = LoadSet('KeepRatio', 0)
kbline = LoadSet('KeepBaseline', 0)

req = '"LIST = ""'txt_gad_font'"", 'ftot', 'fntnum', 20, 5'
DO f = 1 TO ftot
	req = req || ', ""' || fontname.f || '""'
END
req = req ||,
     ' VSPACE = 2 ' ||,
      'STRING = ""'txt_gad_text'"", 'max_text_size', ""'text'"" ' ||,
      'VSPACE = 2 ' ||,
      'SLIDE = ""'txt_gad_angle'"", -360, 360, 'angle' ' ||,
      'SLIDE = ""'txt_gad_shear'"", -45, 45, 'shear' ' ||,
      'SLIDE = ""'txt_gad_boldx'"", -8, 8, 'boldx' ' ||,
      'SLIDE = ""'txt_gad_boldy'"", -8, 8, 'boldy' ' ||,
      'VSPACE = 2 ' ||,
		'CYCLE = ""'txt_gad_aalias'"", 4, 'aalias', ""'txt_gad_aalias0'"", ""'txt_gad_aalias1'"", ""'txt_gad_aalias2'"", ""'txt_gad_aalias3'"" ' ||,
      'CHECK = ""'txt_gad_kratio'"", 'kratio' ' ||,
      'CHECK = ""'txt_gad_kbline'"", 'kbline' ' ||,
      'VSPACE = 2 "'

LockGUI
Request 'RESIZE COMPACT "'txt_title_req'" 'req
IF RC = 0 THEN DO
	fntnum = RESULT.1 + 1
	text   = RESULT.2
	angle  = RESULT.3
	shear  = RESULT.4
	boldx  = RESULT.5
	boldy  = RESULT.6
	aalias = RESULT.7
	kratio = RESULT.8
	kbline = RESULT.9

	CALL SaveSet('Font', fntnum - 1)		/* setting persistence */
	CALL SaveSet('Text', text)
	CALL SaveSet('Angle', angle)
	CALL SaveSet('Shear', shear)
	CALL SaveSet('BoldX', boldx)
	CALL SaveSet('BoldY', boldy)
	CALL SaveSet('Antialias', aalias)
	CALL SaveSet('KeepRatio', kratio)
	CALL SaveSet('KeepBaseline', kbline)

	options = 'DYNAMIC'
	IF kratio THEN
		options = options 'KEEPRATIO'
	IF kbline THEN
		options = options 'KEEPBASELINE'

	/* encode quotes */
	pos = 1
	DO FOREVER
		pos = INDEX(text, '"', pos)
		IF pos = 0 THEN
			BREAK
		text = INSERT('"', text, pos)
		pos = pos + 2
	END

	VectorText 'TEXT "'text'" FONTPATH "'font_path'" FONTNAME "'fontname.fntnum'" X0 'x0' Y0 'y0' X1 'x0 + rwidth - 1' Y1 'y0 + rheight - 1' ANGLE 'angle * 1000' SHEAR 'shear * 1000' BOLDX 'boldx * 1000' BOLDY 'boldy * 1000' ANTIALIAS 'aalias options
	IF RC > 5 THEN
		RequestNotify 'PROMPT "'txt_err_vtext || RC'"'
END
UnlockGUI

EXIT 0




SaveSet:
	sname = ARG(1)
	val = ARG(2)

	IF OPEN('settingfile', 'ENV:PP_VectorText_'sname, 'W') THEN DO
		CALL WRITECH('settingfile', val)
		CALL CLOSE('settingfile')
	END

	RETURN




LoadSet:
	sname = ARG(1)
	def_val = ARG(2)
	IF ARG() > 2 THEN
		global_set = ARG(3)
	ELSE
		global_set = 0
	IF ARG() > 3 THEN
		request_quote = ARG(4)
	ELSE
		request_quote = 1

	val = def_val
	IF global_set THEN
		set_fname = 'ENV:'sname
	ELSE
		set_fname = 'ENV:PP_VectorText_'sname

	IF OPEN('settingfile', set_fname, 'R') THEN DO
		val = READCH('settingfile', 65535)
		CALL CLOSE('settingfile')
	END

	IF request_quote THEN DO
		/* encode quotes for the Request command ('"' -> '\""') */
		qpos_start = 1
		DO FOREVER
			qpos = INDEX(val, '"', qpos_start)
			IF qpos = 0 THEN BREAK
			val = INSERT('\"', val, qpos-1)
			qpos_start = qpos + 3
		END
	END

	RETURN val
