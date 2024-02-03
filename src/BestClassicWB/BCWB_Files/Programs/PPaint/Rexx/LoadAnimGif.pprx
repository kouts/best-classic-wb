/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: LoadAnimGif.pprx 1.4 */

/** ENG
 This script loads a GIF animation, and then either displays it with the
 proper timing, or converts it into an IFF anim-brush (if the "Anim-Brush"
 option is selected).

 GIF animation features such as frame-by-frame timing, multiple palettes,
 control blocks, offsets and overlays are supported. Multiple transparencies
 are not supported.
*/

/** DEU
 Mit Hilfe dieses Skripts läßt sich eine GIF-Animation laden und dann
 entweder mit dem korrekten Timing anzeigen oder in einen IFF-Anim-Brush
 konvertieren (sofern die Option "Anim-Brush" aktiviert ist).

 Merkmale von GIF-Animationen, wie frameweises Timing, unterschiedliche
 Paletten, Control Blocks, Offsets und Overlays werden unterstützt.
 Unterschiedliche Transparenzwerte werden nicht unterstützt.
*/

/** ITA
 Questo script carica un'animazione GIF, e poi o la visualizza con
 un'adeguata temporizzazione, o la converte in un anim-brush IFF
 (se l'opzione "Anim-Brush" è selezionata).

 Sono riconosciute caratteristiche delle animazioni GIF come temporizzazione
 fotogramma per fotogramma, tavolozze multiple, blocchi di controllo, offset
 e sovrapposizioni. Non sono riconosciute trasparenze multiple.
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
	txt_title_req     = 'GIF-Anim-Brush laden'
	txt_gad_absh      = 'Anim-_Brush:'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
	txt_err_oldlib    = 'Für dieses Skript ist eine neuere Version_der GIF library erforderlich'
	txt_err_load      = 'Fehler beim Laden'
	txt_err_notagif   = 'Die ausgewählte Datei enthält keine GIF-Animation'
	txt_err_notsupp   = 'Das ausgewählte Animationsformat kann nicht geladen werden.'
	txt_err_scrfmt    = 'Bildschirmformat kann nicht benutzt werden'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_title_req     = 'Leggere Anim-brush GIF'
	txt_gad_absh      = 'Anim-_Brush:'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
	txt_err_oldlib    = 'Questa procedura richiede_una versione più recente_della libreria GIF'
	txt_err_load      = 'Errore nelle lettura del file'
	txt_err_notagif   = 'Il file selezionato_non contiene un''animazione GIF'
	txt_err_notsupp   = 'Il tipo di animazione non può essere letto'
	txt_err_scrfmt    = 'Il formato di schermo non può essere utilizzato'
END
ELSE DO				/* English */
	txt_title_req     = 'Load GIF Anim-Brush'
	txt_gad_absh      = 'Anim-_Brush:'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
	txt_err_oldlib    = 'This script requires a newer_version of the GIF library'
	txt_err_load      = 'Load error'
	txt_err_notagif   = 'The selected file_does not contain_a GIF animation'
	txt_err_notsupp   = 'The selected animation type_cannot be loaded'
	txt_err_scrfmt    = 'The screen format cannot be set'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

LockGUI
RequestFile '"'txt_title_req'"'
IF RC = 0 THEN DO
	gfile = RESULT
	getbsh = LoadSet('GetBsh', 1)

	Request '"'txt_title_req'" "CHECK = ""'txt_gad_absh'"", 'getbsh'"'
	IF RC = 0 THEN DO
		getbsh = RESULT.1
		CALL SaveSet('GetBsh', getbsh)
		frame = 1
		loop = -1
		delays = ''
		err_msg = ''
		setup = 1

		Get 'GCLIP'
		saveclip = RESULT
		Set '"GCLIP=0"'

		DO FOREVER
			LoadBrush gfile 'QUIET NOPROGRESS FORMAT "GIF" OPTIONS "FRAME='frame'"'
			IF RC = 0 THEN DO
				IF setup THEN DO
					setup = 0
					SwitchEnvironment
					FreeEnvironment 'QUERY'
					IF RC ~= 0 THEN
						LEAVE
					DeleteFrames 'ALL FORCE'
					SetPen 'BACKGROUND 0'
					ClearImage
					GetBrushAttributes 'COLORS'
					cnum = RESULT
					GetBrushAttributes 'WIDTH'
					brushw = RESULT
					GetBrushAttributes 'HEIGHT'
					brushh = RESULT
					IF SetScreenFormat(brushw, brushh, cnum, 1) ~= 0 THEN DO
						IF SetScreenFormat(brushw, brushh, cnum, 0) ~= 0 THEN DO
							err_msg = txt_err_scrfmt
							LEAVE
						END
					END
					GetBrushAttributes 'TRANSPARENCY'
					transp = RESULT
					GetBrushAttributes 'TRANSPARENTCOLOR'
					transpcol = RESULT
					SetPen 'BACKGROUND' transpcol
					ClearImage
					AddFrames
				END
				ELSE DO
					GetBrushAttributes 'TRANSPARENCY'
					transp2 = RESULT
					GetBrushAttributes 'TRANSPARENTCOLOR'
					transpcol2 = RESULT
					IF transp2 ~= transp | transpcol2 ~= transpcol THEN DO
						err_msg = txt_err_notsupp
						LEAVE
					END
				END
				UseBrushPalette
				SetPaintMode 'REPLACE'
				SetBrushAttributes 'HANDLEX 0 HANDLEY 0'
				PutBrush 0 0

				GetBrushInfo 'ANNOTATION'
				IF RC = 0 THEN DO
					PARSE VALUE RESULT WITH 'LOOP ' loop ' DELAY ' delay .
					IF DATATYPE(delay, 'W') THEN DO
						delays = delays delay
						ticks = TRUNC(delay / 100 * 60 + 0.5)
						SetFrameDelay ticks
					END
				END

				AddFrames
				SetFramePosition 'NEXT'
				frame = frame + 1
			END
			ELSE DO
				IF RC = 38 | (RC = 39 & frame <= 2) THEN
					err_msg = txt_err_notagif
				ELSE IF RC = 46 | RC = 47 THEN
					err_msg = txt_err_oldlib
				ELSE IF RC ~= 39 THEN
					err_msg = txt_err_load
				LEAVE
			END
		END

		annot = ''
		LoadBrush gfile 'QUIET NOPROGRESS'	/* reset to normal load (AUTO) */
		IF RC = 0 THEN DO
			GetBrushInfo 'ANNOTATION'
			IF RC = 0 THEN
				annot = RESULT
		END
		FreeBrush 'FORCE'
		DeleteFrames

		IF err_msg ~= '' THEN DO
			RequestNotify 'PROMPT "'err_msg'"'
			FreeEnvironment 'FORCE'
		END
		ELSE DO
			SetFramePosition 1
			IF RC = 0 THEN DO
				IF getbsh THEN DO
					Get 'TRANSP'
					sv_transp = RESULT

					IF transp = 1 THEN
						Set '"TRANSP=' transp '"'
					ELSE
						Set '"TRANSP=0"'
					GetFrames
					DefineBrush 0 0 brushw-1 brushh-1 RESULT
					IF RC = 0 THEN DO
						FreeEnvironment 'FORCE'
						SetBrushInfo 'ANNOTATION "LOOP' loop 'DELAY' delays'"'
						IF annot ~= '' THEN DO
							pos = 1
							DO FOREVER
								pos = INDEX(annot, '"', pos)
								IF pos = 0 THEN
									BREAK
								annot = INSERT('"', annot, pos)
								pos = pos + 2
							END
							SetBrushInfo 'COPYRIGHT "'annot'"'
						END
					END

					Set '"TRANSP=' sv_transp '"'
				END
				ELSE Play 'FORCE'
			END
		END
		Set '"GCLIP='saveclip'"'
	END
END
UnlockGUI

EXIT 0




SetScreenFormat: PROCEDURE

	width  = ARG(1)
	height = ARG(2)
	cnum   = ARG(3)

	IF ARG(4) ~= 0 THEN
		GetBestVideoMode width height cnum 'ANIMATION'
	ELSE
		GetBestVideoMode width height cnum

	IF RC = 0 THEN DO
		PARSE VAR RESULT scrd scrw scrh
		Set '"IMAGEW='width'" "IMAGEH='height'" "COLORS='cnum'" "DISPLAY='scrd'" "SCREENW='scrw'" "SCREENH='scrh'" "ASCROLL=0"'
	END

	RETURN RC




SaveSet: PROCEDURE
	sname = ARG(1)
	val = ARG(2)

	IF OPEN('settingfile', 'ENV:PP_LoadAnimGIF_'sname, 'W') THEN DO
		CALL WRITECH('settingfile', val)
		CALL CLOSE('settingfile')
	END

	RETURN




LoadSet: PROCEDURE
	sname = ARG(1)
	val = ARG(2)

	IF OPEN('settingfile', 'ENV:PP_LoadAnimGIF_'sname, 'R') THEN DO
		val = READCH('settingfile', 65535)
		CALL CLOSE('settingfile')
	END

	RETURN val
