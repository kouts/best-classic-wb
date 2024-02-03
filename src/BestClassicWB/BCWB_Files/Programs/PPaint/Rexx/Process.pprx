/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: Process.pprx 2.1 */

/** ENG
  This script applies an image processing filter to all image files
  (pictures or brushes) in the selected directory. The original files
  are overwritten.
*/

/** DEU
  Dieses Skript automatisiert die Anwendung eines Bildverarbeitungsfilters
  auf alle Grafikdateien (Bilder oder Brushes) im ausgewählten Verzeichnis.
  Die ursprünglichen Dateien werden  dabei überschrieben.
*/

/** ITA
  Questo script applica un filtro di elaborazione immagine a tutti i file
  (immagini o pennelli) presenti nel cassetto selezionato. I file originali
  vengono sovrascritti.
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
	txt_req_selflt    = 'Filter auswählen'
	txt_req_seldir    = 'Verzeichnis auswählen'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO		/* Italiano */
	txt_req_selflt    = 'Selezionare filtro'
	txt_req_seldir    = 'Selezionare percorso'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO		/* English */
	txt_req_selflt    = 'Select a Filter'
	txt_req_seldir    = 'Select a Directory'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
rxver = RESULT
IF rxver < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END


filtname = 'Randomize Oblique'


LockGUI
IF rxver < 5 THEN
	FreeEnvironment 'QUERY'
ELSE
	RequestFilter '"'txt_req_selflt'" "'filtname'"'
IF RC = 0 THEN DO
	IF rxver >= 5 THEN
		PARSE VALUE RESULT WITH '"' filtname '"' dithertype .

	RequestPath '"'txt_req_seldir'"'
	IF RC = 0 THEN DO
		tmpfname = 'T:pprx_temp.'PRAGMA('ID')
		ADDRESS COMMAND 'List >'tmpfname' 'RESULT' NOHEAD PAT=~(#?.info) LFORMAT="*"%s%s*"" FILES'
		IF OPEN('listfile', tmpfname, 'R') THEN DO
			IF rxver < 5 THEN
				DeleteFrames 'ALL FORCE'
			DO FOREVER
				curfname = READLN('listfile')
				IF EOF('listfile') THEN BREAK
				IF rxver < 5 THEN DO
					LoadImage curfname 'FORCE QUIET'
					IF RC = 0 THEN DO
						LoadBrush curfname 'FORCE QUIET'
						IF RC = 0 THEN DO
							GetBrushAttributes 'WIDTH'
							xmax = RESULT - 1
							GetBrushAttributes 'HEIGHT'
							ymax = RESULT - 1
							GetBrushAttributes 'HANDLEX'
							hanx = RESULT
							GetBrushAttributes 'HANDLEY'
							hany = RESULT
							Process '"'filtname'"' 0 0 xmax ymax
							IF RC = 0 THEN DO
								DefineBrush 0 0 xmax ymax
								IF RC = 0 THEN DO
									SetBrushAttributes 'HANDLEX' hanx 'HANDLEY' hany
									SaveBrush curfname 'FORCE'
								END
							END
							ELSE IF RC = 5 THEN	/* user break */
								LEAVE
						END
					END
				END
				ELSE DO
					LoadBrush curfname 'FORCE QUIET'
					IF RC = 0 THEN DO
						Process 'BRUSH "'filtname'" 'dithertype
						IF RC = 0 THEN
							SaveBrush curfname 'FORCE'
						ELSE IF RC = 5 THEN	/* user break */
							LEAVE
					END
				END
			END
			FreeBrush 'FORCE'
			IF rxver < 5 THEN
				ClearImage
			CALL CLOSE('listfile')
		END
		ADDRESS COMMAND 'Delete >NIL: 'tmpfname
	END
END
UnlockGUI
