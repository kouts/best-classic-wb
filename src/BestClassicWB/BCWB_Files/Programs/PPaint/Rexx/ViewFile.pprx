/* Personal Paint Amiga Rexx script - Copyright © 1996, 1997 Cloanto Italia srl */

/* $VER: ViewFile.pprx 1.0 */

/** ENG
 This script shows how to create a simple text viewer. It displays the
 selected text file in a window.
*/

/** DEU
 Dieses Skript verdeutlicht die Erstellung eines einfachen
 Textanzeigeprogramms. Die ausgewählte Textdatei wird in einem Fenster
 angezeigt.
*/

/** ITA
 Questo script mostra come creare un semplice visualizzatore di testi.
 Esso mostra il file di testo selezionato all'interno di una finestra.
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
	txt_req_sel       = 'Textdatei auswählen'
	txt_req_file      = 'Dateiinhalt'
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_req_sel       = 'Selezionare file testo'
	txt_req_file      = 'Contenuto del file'
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO				/* English */
	txt_req_sel       = 'Select a text file'
	txt_req_file      = 'File Contents'
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

LockGUI
RequestFile '"'txt_req_sel'"'
IF RC = 0 THEN DO
	PARSE VALUE RESULT WITH '"' fname '"'
	IF OPEN('textfile', fname, 'R') THEN DO
		filetext = ''
		DO UNTIL EOF('textfile')
			filetext = filetext || READCH('textfile', 10000)
		END
		CALL CLOSE('textfile')
		pos = 1
		DO FOREVER
			pos = INDEX(filetext, '"', pos)
			IF pos = 0 THEN
				BREAK
			filetext = INSERT('"', filetext, pos)
			pos = pos + 2
		END
		RequestNotify '"'txt_req_file'" "'filetext'" SCROLL WRAPCHECK'
	END
END
UnlockGUI
