/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: CircleText.pprx 1.2 */

/** ENG
 This script draws a circular vector text.

 This is a "tool macro": the mouse can be used to define a circle; when
 the mouse button is released, a settings requester is displayed. The
 settings include: font, text string, text size, antialiasing, etc.

 If a single point (pixel) is selected instead of an area, the previous
 circle coordinates remain in use. Other parameters allow the user
 to adjust the appearance of the text.

 The text string specified in the settings requester may contain color
 control sequences, in the format "Esc[3#m" or "[#]", where # is a pen
 number (0 .. 256). The default (initial) color is the current foreground
 color.

 By specifying a Frame setting greater than 1, it is possible to
 create an animation sequence in which the circular text rotates
 (the greater the number of frames, the smoother the rotation).
*/

/** DEU
 Dieses Skript dient zur Ausrichtung eines Vektortexts an einer
 Kreislinie.

 Dies ist ein sog. "Tool-Makro", d. h. zunächst wird mit Hilfe der Maus
 der Kreis erstellt. Sobald die Maustaste losgelassen wird, öffnet
 sich ein Dialogfenster zur Festlegung von Einstellungen für Font,
 Textstring, Zeichengröße, Kantenglättung, usw.

 Wird anstelle eine Bereichs lediglich ein einzelner Punkt selektiert,
 bleiben die vorherigen Kreiskoordinaten erhalten. Andere Parameter
 ermöglichen dem Benutzer u.a. die Festlegung des Erscheinungsbildes
 für den Text.

 Hinweis: Der im Einstellungen-Dialogfenster festgelegte Textstring kann
 auch mit Steuerzeichen zur Aktivierung einer bestimmten Farbe versehen
 werden. Diese müssen im Format "Esc[3#m]" oder "[#]" vorliegen, wobei das
 Rautenzeichen # die Stiftnummer (0...256) angibt. Standardmäßig ist die
 aktuelle Vordergrundfarbe eingestellt.

 Durch die Angabe eines Wertes >1 unter "Einzelbilder" läßt sich
 eine Animation mit einem rotierenden Textkreis erzeugen. Dabei gilt:
 Je größer die Anzahl der Einzelbilder, desto flüssiger der Ablauf
 der Rotation.

*/

/** ITA
 Questo script disegna un testo vettoriale circolare.

 È una "macro per strumenti": si può usare il mouse per definire un cerchio;
 quando si rilascia il tasto del mouse, compare una finestra di dialogo per
 l'impostazione dei parametri. I parametri comprendono: font, stringa di
 testo, dimensioni del testo, smorzamento seghettature (antialiasing), ecc.

 Se si seleziona un punto singolo (pixel) anziché un'area, rimangono in uso
 le coordinate del cerchio precedente. Gli altri parametri permettono di
 adattare l'aspetto del testo.

 La stringa di testo specificata nella finestra di dialogo delle impostazioni
 può contenere sequenze di controllo per colori, nel formato "Esc[3#m" o "[#]",
 dove # è il numero di un colore (0 .. 256). Il colore predefinito (iniziale)
 è quello corrente di primo piano.

 Se si specifica per Fotogrammi un numero maggiore di 1, è possibile creare
 una sequenza animata in cui il testo circolare ruota (quanto maggiore è il
 numero di fotogrammi, tanto più fluida sarà la rotazione).
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
	txt_title_zone    = "Kreisdefinition"
	txt_gad_x0        = "Zentrum _X:"
	txt_gad_y0        = "Zentrum _Y:"
	txt_gad_radius    = "_Radius:"
	txt_title_set     = "Kreistext-Einstellungen"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Text:"
	txt_string_text   = "Dieser Text verläuft im Kreis. "
	txt_gad_height    = "_Höhe:"
	txt_gad_frames    = "_Einzelbilder:"
	txt_gad_sangle    = "A_nfangswinkel:"
	txt_gad_aalias    = "_Kantenglättung:"
	txt_gad_aalias0   = "Keine"
	txt_gad_aalias1   = "Schwach"
	txt_gad_aalias2   = "Mittel"
	txt_gad_aalias3   = "Stark"
	txt_err_nofonts   = "Vectorfonts nicht auffindbar"
	txt_err_procss    = "Fehler bei Bildbearbeitung: "
	txt_err_small     = "Kreis ist zu klein"
	txt_err_nomem     = "Zu wenig Speicher"
	txt_err_oldclient = "Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich"
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_zone    = "Definizione cerchio"
	txt_gad_x0        = "Centro _X:"
	txt_gad_y0        = "Centro _Y:"
	txt_gad_radius    = "_Raggio:"
	txt_title_set     = "Parametri testo"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Testo:"
	txt_string_text   = "Questo è un testo circolare. "
	txt_gad_height    = "Alte_zza:"
	txt_gad_frames    = "Fotogra_mmi:"
	txt_gad_sangle    = "Ang_olo iniziale:"
	txt_gad_aalias    = "Antialia_s:"
	txt_gad_aalias0   = "Nessuno"
	txt_gad_aalias1   = "Basso"
	txt_gad_aalias2   = "Medio"
	txt_gad_aalias3   = "Alto"
	txt_err_nofonts   = "Non vi sono font vettoriali"
	txt_err_procss    = "Errore elaborazione immagine: "
	txt_err_small     = "Il cerchio definito è troppo piccolo"
	txt_err_nomem     = "Memoria insufficiente"
	txt_err_oldclient = "Questa procedura richiede_una versione più recente_di Personal Paint"
END
ELSE DO				/* English */
	txt_title_zone    = "Circle Definition"
	txt_gad_x0        = "Center _X:"
	txt_gad_y0        = "Center _Y:"
	txt_gad_radius    = "_Radius:"
	txt_title_set     = "Circle Text Settings"
	txt_gad_font      = "_Font:"
	txt_gad_text      = "_Text:"
	txt_string_text   = "This is a circular text. "
	txt_gad_height    = "_Height:"
	txt_gad_frames    = "Fra_mes:"
	txt_gad_sangle    = "Start _Angle:"
	txt_gad_aalias    = "A_ntialias:"
	txt_gad_aalias0   = "None"
	txt_gad_aalias1   = "Low"
	txt_gad_aalias2   = "Medium"
	txt_gad_aalias3   = "High"
	txt_err_nofonts   = "Vector fonts not found"
	txt_err_procss    = "Image processing error: "
	txt_err_small     = "The circle is too small"
	txt_err_nomem     = "Not enough memory"
	txt_err_oldclient = "This script requires a newer_version of Personal Paint"
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

/* Circle Definition */

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
		GetDistance x0 y0 xp yp 'IMAGERATIO'
		radius = RESULT
		DrawCircle x0 y0 'RADIUSX' radius

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


IF radius < 2 THEN DO		/* simple click */
	lastpar  = LoadSet('LastParams', '0 0 100')
	PARSE VAR lastpar x0 y0 radius .
	Request '"'txt_title_zone'" ' ||,
			'"INTSTR = ""'txt_gad_x0'"", 0, 32000, 'x0' ' ||,
			 'INTSTR = ""'txt_gad_y0'"", 0, 32000, 'y0' ' ||,
			 'INTSTR = ""'txt_gad_radius'"", 1, 32000, 'radius' "'
	IF RC ~= 0 THEN
		EXIT RC
	x0 = RESULT.1
	y0 = RESULT.2
	radius = RESULT.3
END


fntnum  = LoadSet('Font', 0)
text    = LoadSet('Text', txt_string_text)
height  = LoadSet('Height', 50)
angle   = LoadSet('StartAngle', 0)
aalias  = LoadSet('Antialias', 0)
frames  = LoadSet('Frames', 0)
last_height  = height

req = '"LIST = ""'txt_gad_font'"", 'ftot', 'fntnum', 20, 7'
DO f = 1 TO ftot
	req = req || ', ""' || fontname.f || '""'
END

req = req ||,
     ' VSPACE = 2 ' ||,
      'STRING = ""'txt_gad_text'"", 'max_text_size', ""'text'"" ' ||,
      'INTSTR = ""'txt_gad_height'"", 1, 32000, 'height' ' ||,
      'INTSTR = ""'txt_gad_frames'"", 0, 32000, 'frames' ' ||,
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
	frames  = RESULT.4
	angle   = RESULT.5
	aalias  = RESULT.6

	CALL SaveSet('Font', fntnum - 1)		/* setting persistence */
	CALL SaveSet('Text', text)
	CALL SaveSet('Height', height)
	CALL SaveSet('StartAngle', angle)
	CALL SaveSet('Antialias', aalias)
	CALL SaveSet('Frames', frames)
	CALL SaveSet('LastParams', x0 y0 radius)

	IF radius < 1 THEN DO
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
	tchars = ''
	len = ParseText(text, pen)
	totsize = 0

	last_metrics = LoadSet('Metrics', '')
	last_tchars = LoadSet('TxChars', '')

	IF height == last_height & tchars == last_tchars THEN DO
		DO c = 1 TO len
			addx = WORD(last_metrics, c)
			totsize = totsize + addx
			size.c = addx
		END
	END
	ELSE DO
		metrics = ''
		DO c = 1 TO len
			nextc = c + 1
			VectorCharacter 'CHARACTER "'tchar.c || tchar.nextc'" FONTPATH "'font_path'" FONTNAME "'fontname.fntnum'" HEIGHT 'height
			IF RC = 0 THEN DO
				PARSE VAR RESULT addx .
				totsize = totsize + addx
				size.c = addx
				metrics = metrics addx
			END
			ELSE DO
				RequestNotify 'PROMPT "'txt_err_nomem'"'
				EXIT 0
			END
		END
		CALL SaveSet('Metrics', metrics)
		CALL SaveSet('TxChars', tchars)
	END
	last = len + 1
	size.last = 0

	GetImageAttributes 'DPIX'
	dpix = RESULT
	GetImageAttributes 'DPIY'
	imgratio = dpix / RESULT
	rx = radius
	ry = TRUNC(radius / imgratio + 0.5)

	IF frames < 1 THEN
		frames = 1
	IF frames > 1 THEN
		AddFrames 'FRAMES' frames
	start_angle = angle
	angle_step = 360000 % frames

	DO f = 1 TO frames
		angle = start_angle
		DO c = 1 TO len
			GetEllipsePoint x0 y0 rx ry angle
			PARSE VAR RESULT px py .

			nextc = c + 1
			VectorCharacter 'CHARACTER "'tchar.c || tchar.nextc'" FONTPATH "'font_path'" FONTNAME "'fontname.fntnum'" HEIGHT 'height' ANGLE 'angle' ANTIALIAS 'aalias
			IF RC = 0 THEN DO
				PARSE VAR RESULT . . handlex handley .

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

				angle = angle + TRUNC((size.c + size.nextc) / 2 / totsize * 360000 + 0.5)
				IF angle >= 360000 THEN
					angle = angle - 360000
			END
		END
		IF frames > 1 THEN DO
			start_angle = start_angle + angle_step
			IF start_angle >= 360000 THEN
				start_angle = start_angle - 360000
			SetFramePosition 'NEXT'
		END
	END
	SetPen 'FOREGROUND' savepen
	FreeBrush 'FORCE'
END
UnlockGUI

EXIT 0




ParseText: PROCEDURE EXPOSE tchar. tpen. tchars

	tstring = ARG(1)
	tpn = ARG(2)
	tlen = LENGTH(tstring)
	tchars = ''
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
			tchars = tchars || td
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

	IF OPEN('settingfile', 'ENV:PP_CircleTx_'sname, 'W') THEN DO
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
		set_fname = 'ENV:PP_CircleTx_'sname

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
