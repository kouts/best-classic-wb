/* Personal Paint Amiga Rexx script - Copyright © 1995-1998 Cloanto Italia srl */

/* $VER: AnimText.pprx 1.3 */

/** ENG
  This script renders a text string using AnimFonts by Kara Computer
  Graphics. The resulting animation is played or placed in the current
  brush.

  One AnimFont is included with the Cloanto Personal Suite CD-ROM,
  while The Kara Collection CD-ROM contains five AnimFonts.
*/

/** DEU
  Dieses Skript erzeugt unter Verwendung der AnimFonts von Kara
  Computer Graphics (nicht in Personal Paint enthalten) eine Zeichenfolge.
  Die daraus resultierende Animation wird wahlweise abgespielt oder im
  aktuellen Brush abgelegt.

  Die CD-ROM "The Kara Collection" enthält fünf AnimFonts. Die CD-ROM
  "Personal Suite" enthält ein AnimFont. 
*/

/** ITA
  Questo script realizza una stringa di testo utilizzando AnimFonts di Kara
  Computer Graphics. L'animazione risultante viene mostrata oppure è inserita
  nel pennello corrente.

  I font animati "AnimFonts" sono compresi nel CD-ROM Cloanto The Kara
  Collection. Il CD-ROM Personal Suite contiene un font animato.
*/

absh_dir.1 = 'PPaint:AnimBrushes/AnimFonts'
data_dir.1 = 'PPaint:AnimBrushes/AnimFonts'
absh_dir.2 = 'KaraCD:PPaint/AnimBrushes/AnimFonts'
data_dir.2 = 'KaraCD:PPaint/AnimBrushes/AnimFonts'
absh_dir.3 = 'AnimBrushes/AnimFonts'
data_dir.3 = 'AnimBrushes/AnimFonts'
absh_dir.4 = 'PSuite:PPaint/AnimBrushes/AnimFonts'
data_dir.4 = 'PSuite:PPaint/AnimBrushes/AnimFonts'
absh_dir.5 = 'KaraCD:AnimFonts/AnimBrushes'
data_dir.5 = 'KaraCD:AnimFonts/AnimBrushes'
path_num   = 5

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
	txt_title_req     = 'AnimText-Einstellungen'
	txt_gad_lst       = 'Anim_Font:'
	txt_gad_str       = '_Text:'
	txt_string_str    = 'Text'
	txt_gad_cyc       = '_Darstellen:'
	txt_gad_cyc0      = 'Von Links nach Rechts'
	txt_gad_cyc1      = 'Gleichzeitig'
	txt_gad_num0      = 'Ab_stand:'
	txt_gad_num1      = 'Einzelbild-_Offset:'
	txt_gad_chk       = 'Anim-_Brush:'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	txt_err_noafonts  = 'AnimFonts konnten nicht_gefunden werden'
	txt_err_nodfile   = 'Fontdatei konnte nicht_gefunden werden'
	txt_err_noenv     = 'Andere Umgebung_kann nicht erstellt werden'
END
ELSE IF RESULT = 3 THEN DO	/* Français */
	txt_title_req     = "Réglages d'AnimText"
	txt_gad_lst       = 'Anim_Font :'
	txt_gad_str       = '_Texte :'
	txt_string_str    = 'Texte'
	txt_gad_cyc       = 'Apparitio_n :'
	txt_gad_cyc0      = 'De gauche à droite'
	txt_gad_cyc1      = 'Simultanément'
	txt_gad_num0      = 'E_spacement :'
	txt_gad_num1      = '_Retard :'
	txt_gad_chk       = '_Brosse animée :'
	txt_err_oldclient = 'Ce script nécessite une nouvelle_version de Personal Paint'
	txt_err_noafonts  = 'AnimFonts non trouvées'
	txt_err_nodfile   = 'Impossible de trouver_le fichier de données_de la police'
	txt_err_noenv     = "Impossible de créer_l'autre environnement"
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_req     = 'Parametri AnimText'
	txt_gad_lst       = 'Anim_Font:'
	txt_gad_str       = '_Testo:'
	txt_string_str    = 'Testo'
	txt_gad_cyc       = '_Scrittura:'
	txt_gad_cyc0      = 'Da sinistra a destra'
	txt_gad_cyc1      = 'Simultanea'
	txt_gad_num0      = '_Spaziatura:'
	txt_gad_num1      = 'Sp_ostamento:'
	txt_gad_chk       = 'Anim-_Brush:'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	txt_err_noafonts  = 'Impossibile trovare AnimFont'
	txt_err_nodfile   = 'Impossibile aprire_il file dati'
	txt_err_noenv     = 'Impossibile creare_ambiente alternativo'
END
ELSE DO				/* English */
	txt_title_req     = 'AnimText Settings'
	txt_gad_lst       = 'Anim_Font:'
	txt_gad_str       = '_Text:'
	txt_string_str    = 'Text'
	txt_gad_cyc       = '_Render:'
	txt_gad_cyc0      = 'Left to right'
	txt_gad_cyc1      = 'Simultaneously'
	txt_gad_num0      = '_Spacing:'
	txt_gad_num1      = 'F_rame Offset:'
	txt_gad_chk       = 'Anim-_Brush:'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
	txt_err_noafonts  = 'AnimFonts not found'
	txt_err_nodfile   = 'Font data file_cannot be found'
	txt_err_noenv     = 'Other environment_cannot be created'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

FreeBrush
IF RC ~= 0 THEN
	EXIT RC

/* Build the list of available AnimFonts */

tmpfname = 'T:pprx_temp.'PRAGMA('ID')
ftot = 0
CALL PRAGMA('Window', 'Null')

DO pnum = 1 to path_num
	sv_cd = PRAGMA('D')
	IF PRAGMA('D', absh_dir.pnum) = sv_cd THEN DO
		CALL PRAGMA('D', sv_cd)
		ADDRESS COMMAND 'List >'tmpfname' 'absh_dir.pnum' NOHEAD LFORMAT="%s" DIRS'
		IF RC = 0 THEN DO
			ADDRESS COMMAND 'Sort 'tmpfname tmpfname'.s'
			IF RC = 0 THEN DO
				ADDRESS COMMAND 'Delete >NIL: 'tmpfname
				tmpfname = tmpfname'.s'
			END
			IF OPEN('listfile', tmpfname, 'R') THEN DO
				DO FOREVER
					fline = READLN('listfile')
					IF EOF('listfile') THEN BREAK
					ftot = ftot + 1
					fontname.ftot = fline
				END
				CALL CLOSE('listfile')
			END
		END
		ADDRESS COMMAND 'Delete >NIL: 'tmpfname
		IF ftot ~= 0 THEN
			LEAVE
	END
END
CALL PRAGMA('Window', 'Workbench')

IF ftot = 0 THEN DO
	RequestNotify 'PROMPT "'txt_err_noafonts'"'
	EXIT 10
END


/* Build and show the settings requester */

font = LoadSet('Font', 0)
txt_string_str = LoadSet('Text', txt_string_str)
render  = LoadSet('Render', 0)
spacing = LoadSet('Spacing', 0)
offset  = LoadSet('Offset', 0)
getbsh  = LoadSet('Getbsh', 1)

req = '"LIST = ""'txt_gad_lst'"", 'ftot', 'font', 20, 5'  /* max 5 rows to fit into a 320x200 screen */
DO f = 1 TO ftot
	req = req || ', ""' || fontname.f || '""'
END

req = req ||,
	' STRING = ""'txt_gad_str'"", 256, ""'txt_string_str'"" ' ||,
	'CYCLE = ""'txt_gad_cyc'"", 2, 'render', ""'txt_gad_cyc0'"", ""'txt_gad_cyc1'"" ' ||,
	'INTSTR = ""'txt_gad_num0'"", -32768, 32767, 'spacing' ' ||,
	'INTSTR = ""'txt_gad_num1'"", -32768, 32767, 'offset' ' ||,
	'CHECK = ""'txt_gad_chk'"", 'getbsh' "'

Request 'RESIZE "'txt_title_req'"' req
IF RC = 0 THEN DO
	font    = RESULT.1
	text    = RESULT.2
	render  = RESULT.3
	spacing = RESULT.4
	offset  = RESULT.5
	getbsh  = RESULT.6

	CALL SaveSet('Font', font)		/* setting persistence */
	CALL SaveSet('Text', text)
	CALL SaveSet('Render', render)
	CALL SaveSet('Spacing', spacing)
	CALL SaveSet('Offset', offset)
	CALL SaveSet('Getbsh', getbsh)
END
ELSE EXIT 0

font = font + 1
abshpath = absh_dir.pnum'/'fontname.font'/'
dataname = data_dir.pnum'/'fontname.font'.data'

len = LENGTH(text)
fontdata. = 'undef'



/* Read data file */

IF OPEN('datafile', dataname, 'R') THEN DO
	READLN('datafile')
	skip_first = READLN('datafile')
	frm_offset = READLN('datafile')
	DO FOREVER
		fline = READLN('datafile')
		IF EOF('datafile') THEN BREAK
		PARSE VAR fline chr nm spc hdx
		fontdata.name.chr  = nm
		fontdata.space.chr = spc
		fontdata.handx.chr = hdx
	END
	CALL CLOSE('datafile')
END
ELSE DO
	RequestNotify 'PROMPT "'txt_err_nodfile'"'
	EXIT 10
END



/* Render the text */

LockGUI

Get 'IMAGEW'
img_width = RESULT
Get 'DISPLAY'
img_disp = RESULT

SwitchEnvironment
FreeEnvironment 'QUERY'
IF RC ~= 0 THEN DO
	UnlockGUI
	EXIT RC
END

Get 'GCLIP'
saveclip = RESULT
Set '"GCLIP=0"'

DeleteFrames 'ALL FORCE'
ClearImage
SetPaintMode 'MATTE'
xmax = 0
ymax = 0
error = 0
IF render = 0 THEN DO	/* Left to right */
	xpos = 0
	ypos = 0
	first = 1
	DO c = 1 TO len
		chr = UseChar(SUBSTR(text, c, 1))
		IF chr = 32 | chr = 60 | chr = 62 THEN DO
			IF fontdata.space.chr ~= 'undef' THEN
				xpos = xpos + fontdata.space.chr + spacing
		END
		ELSE DO
			LoadAnimBrush '"'abshpath || fontdata.name.chr'"' FORCE QUIET NOPROGRESS
			IF RC = 0 THEN DO
				GetBrushAttributes 'FRAMES'
				frm = RESULT
				IF skip_first THEN
					frm = frm - 1

				IF first THEN DO
					first = 0
					error = SetupEnv(img_width, img_disp)
					IF error ~= 0 THEN
						LEAVE c
					UseBrushPalette
					IF fontdata.handx.chr > 0 THEN
						xpos = fontdata.handx.chr

					AddFrames frm
				END
				ELSE DO
					GetFrames
					tot = RESULT
					pos = tot + frm_offset + offset
					add = frm - (tot - pos)
					IF add > 0 THEN
						AddFrames add 'AFTER' tot
					SetFramePosition pos + 1
				END

				SetBrushAttributes 'FRAMEPOSITION 2 HANDLEX' fontdata.handx.chr 'HANDLEY 0'
				DO f = 1 TO frm
					PutBrush xpos ypos
					SetFramePosition 'NEXT'
				END

				GetBrushAttributes 'WIDTH'
				x1 = xpos - fontdata.handx.chr + RESULT - 1
				IF x1 > xmax THEN
					xmax = x1
				GetBrushAttributes 'HEIGHT'
				y1 = ypos + RESULT - 1
				IF y1 > ymax THEN
					ymax = y1
				xpos = xpos + fontdata.space.chr + spacing
			END
		END
	END
END
ELSE DO	/* Simultaneously */
	max_frm = 0
	DO c = 1 TO len
		chr = UseChar(SUBSTR(text, c, 1))
		IF chr ~= 32 & chr ~= 60 & chr ~= 62 THEN DO
			LoadAnimBrush '"'abshpath || fontdata.name.chr'" FORCE QUIET NOPROGRESS'
			IF RC = 0 THEN DO
				GetBrushAttributes 'FRAMES'
				frm = RESULT
				IF frm > max_frm THEN
					max_frm = frm
			END
		END
	END
	error = SetupEnv(img_width, img_disp)
	IF error = 0 THEN DO
		IF skip_first THEN
			max_frm = max_frm - 1
		UseBrushPalette
		AddFrames max_frm

		DO f = 1 TO max_frm
			xpos = 0
			ypos = 0
			first = 1
			DO c = 1 TO len
				chr = UseChar(SUBSTR(text, c, 1))
				IF chr = 32 | chr = 60 | chr = 62 THEN DO
					IF fontdata.space.chr ~= 'undef' THEN
						xpos = xpos + fontdata.space.chr + spacing
				END
				ELSE DO
					LoadAnimBrush '"'abshpath || fontdata.name.chr'" FORCE QUIET NOPROGRESS'
					IF RC = 0 THEN DO
						GetBrushAttributes 'FRAMES'
						frm = RESULT

						IF first THEN DO
							first = 0
							IF fontdata.handx.chr > 0 THEN
								xpos = fontdata.handx.chr
						END
						fpos = f + 1
						IF fpos > frm THEN DO
							IF skip_first THEN
								fpos = frm
							ELSE
								fpos = 1
						END
						SetBrushAttributes 'FRAMEPOSITION' fpos 'HANDLEX' fontdata.handx.chr 'HANDLEY 0'
						PutBrush xpos ypos

						IF f = 1 THEN DO
							GetBrushAttributes 'WIDTH'
							x1 = xpos - fontdata.handx.chr + RESULT - 1
							IF x1 > xmax THEN
								xmax = x1
							GetBrushAttributes 'HEIGHT'
							y1 = ypos + RESULT - 1
							IF y1 > ymax THEN
								ymax = y1
						END
						xpos = xpos + fontdata.space.chr + spacing
					END
				END
			END
			SetFramePosition 'NEXT'
		END
	END
END

IF error = 0 THEN DO
	SetFramePosition 1
	IF getbsh THEN DO
		GetFrames
		frm = RESULT
		DefineBrush 0 0 xmax ymax frm
		IF RC = 0 THEN
			FreeEnvironment 'FORCE'
	END
	ELSE DO
		FreeBrush 'FORCE'
		Play 'FORCE'
	END
END
ELSE
	RequestNotify 'PROMPT "'txt_err_noenv'"'

Set '"GCLIP='saveclip'"'
UnlockGUI
EXIT 0




UseChar:
	ch = ARG(1)

	code = C2D(ch)

	IF fontdata.space.code = 'undef' THEN DO
		IF ch >= 'A' & ch <= 'Z' THEN
			code = code + 32
		ELSE IF ch >= 'a' & ch <= 'z' THEN
			code = code - 32

		IF fontdata.space.code = 'undef' THEN
			code = 32
	END

	RETURN code




SetupEnv:
	imgw = ARG(1)
	imgd = ARG(2)

	GetBrushAttributes 'COLORS'
	cnum = RESULT
	GetBrushAttributes 'HEIGHT'
	imgh = RESULT

	Set '"IMAGEW='imgw'" "IMAGEH='imgh'" "COLORS='cnum'" "DISPLAY='imgd'" "SCREENW=-1" "SCREENH='imgh'" "ASCROLL=0"'

	RETURN RC




SaveSet:
	sname = ARG(1)
	val = ARG(2)

	IF OPEN('settingfile', 'ENV:PP_AnimText_'sname, 'W') THEN DO
		CALL WRITECH('settingfile', val)
		CALL CLOSE('settingfile')
	END

	RETURN




LoadSet:
	sname = ARG(1)
	def_val = ARG(2)

	val = def_val
	IF OPEN('settingfile', 'ENV:PP_AnimText_'sname, 'R') THEN DO
		val = READCH('settingfile', 65535)
		CALL CLOSE('settingfile')
	END

	/* encode quotes for the Request command ('"' -> '\""') */
	qpos_start = 1
	DO FOREVER
		qpos = INDEX(val, '"', qpos_start)
		IF qpos = 0 THEN BREAK
		val = INSERT('\"', val, qpos-1)
		qpos_start = qpos + 3
	END

	RETURN val
