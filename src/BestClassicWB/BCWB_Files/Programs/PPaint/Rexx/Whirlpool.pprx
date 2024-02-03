/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: Whirlpool.pprx 1.2 */

/** ENG
 This script creates a text "whirlpool": a text string is rendered
 along an elliptical path, using a vector font in the current foreground
 color.

 This is a "tool macro": the mouse can be used to define an ellipse.
 When the mouse button is released, a settings requester is
 displayed. The settings include: font, text string, text size, start angle,
 antialiasing, etc.

 If a single point (pixel), rather than an area, is selected, a requester
 with the previously-used area coordinates is displayed: the parameters can
 be modified to fine-tune the appearance of the "whirlpool".

 The text string specified in the settings requester may contain color
 control sequences, in the format "Esc[3#m" or "[#]", where # is a pen
 number (0 .. 256). The default (initial) color is the current foreground
 color.
*/

/** DEU
 Mit diesem Skript läßt sich ein Text-"Whirlpool" erzeugen. Dazu wird
 eine Textzeichenkette dem Verlauf eines elliptischen Pfades angepaßt,
 wobei ein Vektorfont in der aktuellen Vordergrundfarbe verwendet wird.

 Dies ist ein sog. "Tool-Makro": Zunächst wird mit Hilfe der Maus
 die Ellipse erstellt. Sobald die Maustaste losgelassen wird, öffnet
 sich ein Dialogfenster zur Festlegung von Einstellungen für Font,
 Textstring, Zeichengröße, Startwinkel, Kantenglättung, usw.

 Wird anstelle eines Bereichs lediglich ein einzelner Punkt selektiert,
 so öffnet sich ein Dialogfenster mit den zuletzt verwendeten
 Bereichskoordinaten, welche sich dann zur Feinabstimmung des
 Erscheinungsbildes den Anforderungen entsprechend modifizieren lassen.

 Hinweis: Der im Dialogfenster "Einstellungen" festgelegte Textstring kann
 auch mit Steuerzeichen zur Aktivierung einer bestimmten Farbe versehen
 werden. Diese müssen im Format "Esc[3#m]" oder "[#]" vorliegen, wobei das
 Rautenzeichen # die Stiftnummer (0...256) angibt. Standardmäßig ist die
 aktuelle Vordergrundfarbe eingestellt.
*/

/** ITA
 Questo script crea un testo a "vortice": una stringa di testo è tracciata
 lungo un percorso ellittico, usando un font vettoriale col colore di primo
 piano corrente.

 È una "macro per strumenti": si può usare il mouse per definire una ellisse;
 quando si rilascia il tasto del mouse, compare una finestra di dialogo per
 l'impostazione dei parametri. I parametri comprendono: font, stringa di
 testo, dimensioni del testo, smorzamento seghettature (antialiasing), ecc.

 Se si seleziona un punto singolo (pixel) anziché un'area, compare una finestra
 di dialogo che mostra le coordinate dell'area precedente: tali parametri
 possono essere modificati per raffinare l'aspetto del "vortice".

 La stringa di testo specificata nella finestra di dialogo delle impostazioni
 può contenere sequenze di controllo per colori, nel formato "Esc[3#m" o "[#]",
 dove # è il numero di un colore (0 .. 256). Il colore predefinito (iniziale)
 è quello corrente di primo piano.
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
	txt_title_zone    = "Whirlpool-Bereich"
	txt_gad_x0        = "Zentrum _X:"
	txt_gad_y0        = "Zentrum _Y:"
	txt_gad_radiusx   = "_Radius X:"
	txt_gad_radiusy   = "Radiu_s Y:"
	txt_title_set     = "Whirlpool-Einstellungen"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Text:"
	txt_string_text   = "Dies ist Text für den Whirlpool-Effekt."
	txt_gad_sheight   = "_Höhe Anfang:"
	txt_gad_eheight   = "Höhe _Ende:"
	txt_gad_fall      = "_Gefälle %:"
	txt_gad_sangle    = "Winkel A_nfang:"
	txt_gad_aalias    = "_Kantenglättung:"
	txt_gad_aalias0   = "Keine"
	txt_gad_aalias1   = "Schwach"
	txt_gad_aalias2   = "Mittel"
	txt_gad_aalias3   = "Stark"
	txt_err_nofonts   = "Vektorfonts nicht auffindbar"
	txt_err_procss    = "Fehler bei Bildbearbeitung: "
	txt_err_small     = "Ausgewählter Bereich ist zu klein"
	txt_err_nomem     = "Zu wenig Speicher"
	txt_err_oldclient = "Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich"
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_zone    = "Zona spirale"
	txt_gad_x0        = "Centro _X:"
	txt_gad_y0        = "Centro _Y:"
	txt_gad_radiusx   = "_Raggio X:"
	txt_gad_radiusy   = "Raggi_o Y:"
	txt_title_set     = "Parametri spirale"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Testo:"
	txt_string_text   = "Questo è un testo a spirale."
	txt_gad_sheight   = "Altezza i_niziale:"
	txt_gad_eheight   = "Altezza fina_le:"
	txt_gad_fall      = "_Caduta %:"
	txt_gad_sangle    = "Ang_olo iniziale:"
	txt_gad_aalias    = "Antialia_s:"
	txt_gad_aalias0   = "Nessuno"
	txt_gad_aalias1   = "Basso"
	txt_gad_aalias2   = "Medio"
	txt_gad_aalias3   = "Alto"
	txt_err_nofonts   = "Non vi sono font vettoriali"
	txt_err_procss    = "Errore elaborazione immagine: "
	txt_err_nomem     = "Memoria insufficiente"
	txt_err_small     = "L'area definita è troppo piccola"
	txt_err_oldclient = "Questa procedura richiede_una versione più recente_di Personal Paint"
END
ELSE DO			/* English */
	txt_title_zone    = "Whirlpool Area"
	txt_gad_x0        = "Center _X:"
	txt_gad_y0        = "Center _Y:"
	txt_gad_radiusx   = "_Radius X:"
	txt_gad_radiusy   = "Radiu_s Y:"
	txt_title_set     = "Whirlpool Settings"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Text:"
	txt_string_text   = "This is a whirlpool text."
	txt_gad_sheight   = "_Start Height:"
	txt_gad_eheight   = "_End Height:"
	txt_gad_fall      = "Fa_ll %:"
	txt_gad_sangle    = "Start _Angle:"
	txt_gad_aalias    = "A_ntialias:"
	txt_gad_aalias0   = "None"
	txt_gad_aalias1   = "Low"
	txt_gad_aalias2   = "Medium"
	txt_gad_aalias3   = "High"
	txt_err_nofonts   = "Vector fonts not found"
	txt_err_procss    = "Image processing error: "
	txt_err_small     = "The selected area is too small"
	txt_err_nomem     = "Not enough memory"
	txt_err_oldclient = "This script requires a newer_version of Personal Paint"
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END


/* Ellipse Definition */

GetCurrentBrush
savebsh = RESULT
SetCurrentBrush 'RECTANGULAR WIDTH 1 HEIGHT 1'

prev_xp = x0
prev_yp = y0
drawn = 0

DO FOREVER
	GetMousePosition
	PARSE VAR RESULT xp yp .

	IF xp ~= prev_xp | yp ~= prev_yp | ~drawn THEN DO
		IF drawn THEN
			Undo
		radiusx = ABS(x0 - xp)
		radiusy = ABS(y0 - yp)
		DrawEllipse x0 y0 radiusx radiusy

		prev_xp = xp
		prev_yp = yp
		drawn = 1
	END
	ELSE WaitForEvent

	GetMouseButton
	IF RESULT ~= button THEN
		LEAVE
END

Undo
SetCurrentBrush savebsh


FreeBrush
IF RC ~= 0 THEN
	EXIT RC

/* Setting Requester */

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


IF radiusx < 2 & radiusy < 2 THEN DO		/* simple click */
	lastpar = LoadSet('LastParams', '0 0 100 100')
	PARSE VAR lastpar x0 y0 radiusx radiusy
	Request '"'txt_title_zone'" ' ||,
			'"INTSTR = ""'txt_gad_x0'"", 0, 32000, 'x0' ' ||,
			 'INTSTR = ""'txt_gad_y0'"", 0, 32000, 'y0' ' ||,
			 'INTSTR = ""'txt_gad_radiusx'"", 1, 32000, 'radiusx' ' ||,
			 'INTSTR = ""'txt_gad_radiusy'"", 1, 32000, 'radiusy' "'
	IF RC ~= 0 THEN
		EXIT RC
	x0 = RESULT.1
	y0 = RESULT.2
	radiusx = RESULT.3
	radiusy = RESULT.4
END


fntnum  = LoadSet('Font', 0)
text    = LoadSet('Text', txt_string_text)
height  = LoadSet('StartHeight', 50)
eheight = LoadSet('EndHeight', 20)
fallpc  = LoadSet('Fall', 100)
angle   = LoadSet('StartAngle', 0)
aalias  = LoadSet('Antialias', 0)

req = '"LIST = ""'txt_gad_font'"", 'ftot', 'fntnum', 20, 5'
DO f = 1 TO ftot
	req = req || ', ""' || fontname.f || '""'
END

req = req ||,
     ' VSPACE = 2 ' ||,
      'STRING = ""'txt_gad_text'"", 'max_text_size', ""'text'"" ' ||,
      'INTSTR = ""'txt_gad_sheight'"", 1, 32000, 'height' ' ||,
      'INTSTR = ""'txt_gad_eheight'"", 1, 32000, 'eheight' ' ||,
      'INTSTR = ""'txt_gad_fall'"", 0, 32000, 'fallpc' ' ||,
      'VSPACE = 2 ' ||,
      'SLIDE = ""'txt_gad_sangle'"", -360, 360, 'angle' ' ||,
      'VSPACE = 2 ' ||,
		'CYCLE = ""'txt_gad_aalias'"", 4, 'aalias', ""'txt_gad_aalias0'"", ""'txt_gad_aalias1'"", ""'txt_gad_aalias2'"", ""'txt_gad_aalias3'"" ' ||,
      'VSPACE = 2 "'

LockGUI
Request 'RESIZE COMPACT "'txt_title_set'" 'req
IF RC = 0 THEN DO
	fntnum  = RESULT.1 + 1
	text    = RESULT.2
	height  = RESULT.3
	eheight = RESULT.4
	fallpc  = RESULT.5
	angle   = RESULT.6
	aalias  = RESULT.7

	CALL SaveSet('Font', fntnum - 1)		/* setting persistence */
	CALL SaveSet('Text', text)
	CALL SaveSet('StartHeight', height)
	CALL SaveSet('EndHeight', eheight)
	CALL SaveSet('Fall', fallpc)
	CALL SaveSet('StartAngle', angle)
	CALL SaveSet('Antialias', aalias)
	CALL SaveSet('LastParams', x0 y0 radiusx radiusy)

	IF radiusx < 1 | radiusy < 1 THEN DO
		RequestNotify 'PROMPT "'txt_err_small'"'
		len = 0
	END

	angle = angle * 1000
	IF angle < 0 THEN
		angle = 360000 + angle
	IF angle >= 360000 THEN
		angle = angle - 360000

	GetPen 'FOREGROUND'
	pen = RESULT
	savepen = pen
	SIGNAL ON Break_C

	tchar. = ''
	tpen. = pen
	len = ParseText(text, pen)

	GetImageAttributes 'DPIX'
	dpix = RESULT
	GetImageAttributes 'DPIY'
	imgratio = dpix / RESULT

	rxdelta = (height * imgratio / 360000) * fallpc / 100
	rydelta = (height / 360000) * fallpc / 100
	hdelta = (height - eheight) / len

	DO c = 1 TO len
		rx = TRUNC(radiusx + 0.5)
		ry = TRUNC(radiusy + 0.5)
		GetEllipsePoint x0 y0 rx ry angle 'IMAGERATIO'
		PARSE VAR RESULT px py cangle .

		nextc = c + 1
		VectorCharacter 'CHARACTER "'tchar.c || tchar.nextc'" FONTPATH "'font_path'" FONTNAME "'fontname.fntnum'" HEIGHT 'TRUNC(height + 0.5)' ANGLE 'cangle' ANTIALIAS 'aalias
		IF RC = 0 THEN DO
			PARSE VAR RESULT addx addy handlex handley . . nextwidth
			GetBrushAttributes 'HANDLEX'
			hx = RESULT
			GetBrushAttributes 'HANDLEY'
			hy = RESULT
			SetBrushAttributes 'HANDLEX 'handlex' HANDLEY 'handley
			SetPaintMode 'COLOR'
			SetPen 'FOREGROUND' tpen.c

			IF aalias > 0 THEN DO
				Process 'IMAGE BRUSHMODE X0 'px' Y0 'py' FILTER "Brush Alpha Channel (Single)" NOFS'
				IF RC ~= 0 THEN DO
					IF RC ~= 5 THEN
						RequestNotify 'PROMPT "'txt_err_procss || RC'"'
					LEAVE
				END
			END
			ELSE PutBrush px py

			edgex = px - handlex + hx + addx
			edgey = py - handley + hy + addy
			dist = nextwidth % 2

			GetEllipseAngle x0 y0 rx ry edgex edgey dist angle 'IMAGERATIO INCREASING'
			IF RC ~= 0 THEN
				LEAVE
			new_angle = RESULT
			IF new_angle >= angle THEN
				angle_step = new_angle - angle
			ELSE
				angle_step = 360000 - angle + new_angle
			angle = new_angle

			radiusx = radiusx - (rxdelta * angle_step)
			radiusy = radiusy - (rydelta * angle_step)
			IF radiusx < 1 | radiusy < 1 THEN
				LEAVE
		END
		ELSE DO
			RequestNotify 'PROMPT "'txt_err_nomem'"'
			LEAVE
		END
		height = height - hdelta
	END
	SetPen 'FOREGROUND' savepen
	FreeBrush 'FORCE'
END
UnlockGUI

EXIT 0




ParseText: PROCEDURE EXPOSE tchar. tpen.

	tstring = ARG(1)
	tpn = ARG(2)
	tlen = LENGTH(tstring)
	tpos = 1
	tnum = 0

	DO UNTIL tpos > tlen
		td = SUBSTR(tstring, tpos, 1)
		tnewpen = ''
		IF td = '[' THEN DO	/* [###] */
			tnewpos = tpos + 1
			IF SUBSTR(tstring, tnewpos, 1) = '[' THEN
				tpos = tpos + 1
			ELSE DO
				DO FOREVER
					tc = SUBSTR(tstring, tnewpos, 1)
					IF tc < '0' | tc > '9' THEN
						LEAVE
					tnewpen = tnewpen || tc
					tnewpos = tnewpos + 1
				END
			END
		END
		ELSE IF C2D(td) = 27 THEN DO	/* Esc[3###m */
			IF SUBSTR(tstring, tpos+1, 2) == '[3' THEN DO
				tnewpos = tpos + 3
				DO FOREVER
					tc = SUBSTR(tstring, tnewpos, 1)
					IF tc < '0' | tc > '9' THEN
						LEAVE
					tnewpen = tnewpen || tc
					tnewpos = tnewpos + 1
				END
			END
		END
		ELSE IF td = '"' THEN
			td = '""'

		IF tnewpen == '' THEN DO
			tnum = tnum + 1
			tchar.tnum = td
			tpen.tnum = tpn
			tpos = tpos + 1
		END
		ELSE DO
			tpn = tnewpen
			tpos = tnewpos + 1
		END
	END

	RETURN tnum




SaveSet: PROCEDURE

	sname = ARG(1)
	val = ARG(2)

	IF OPEN('settingfile', 'ENV:PP_Whirlpool_'sname, 'W') THEN DO
		CALL WRITECH('settingfile', val)
		CALL CLOSE('settingfile')
	END

	RETURN




LoadSet: PROCEDURE

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
		set_fname = 'ENV:PP_Whirlpool_'sname

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




Break_C:

	SetPen 'FOREGROUND' savepen
	FreeBrush 'FORCE'
	UnlockGUI

	RETURN
