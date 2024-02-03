/* Personal Paint Amiga Rexx script - Copyright © 1995-1997 Cloanto Italia srl */

/* $VER: AnimToFrames.pprx 1.3 */

/** ENG
  This script converts the current animation into separate frames, creating
  a file for each frame. A three-digit suffix after the user-specified
  file name indicates the position of each frame in the animation, starting
  from frame 1. For example, if the name "Animation" is selected, the first
  frame will be saved as "Animation.001". If the base name contains one or
  more consecutive "0" characters, they will be used and progressively
  replaced to store the frame number (e.g. "Animation_000.pic" becomes
  "Animation_001.pic", "Animation_002.pic", etc.).

*/

/** DEU
  Dieses Skript wandelt die aktuelle Animation in Einzelbilder um, wobei
  für jedes Bild eine eigene Datei erstellt wird. Die Position eines
  Bildes innerhalb der Gesamtanimation wird durch eine dreistellige
  Dateiendung wiedergegeben, beginnend mit Bild 1. Beispiel: Wird als
  Name "Animation" festgelegt, so erhält das als erstes gespeicherte
  Einzelbild den Dateinamen "Animation.001". Wenn der Stamm des
  Dateinamens eine oder mehrere aufeinanderfolgende Nullen "0" enthält,
  werden diese zur Speicherung der Einzelbildnummer verwendet. Beispiel:
  "Animation_000.pic" wird zu "Animation_001.pic", "Animation_002.pic", usw.
*/

/** ITA
  Questo script suddivide l'animazione attuale nei suoi singoli fotogrammi,
  creando un file per ciascun fotogramma. Un suffisso a tre cifre presente
  dopo il nome specificato dall'utente indica la posizione di ciascun
  fotogramma all'interno dell'animazione, iniziando dal fotogramma 1. Ad
  esempio, se si sceglie il nome "Animazione", il primo fotogramma sarà salvato
  come "Animazione.001". Se il nome di base del file contiene uno o più
  caratteri "0" consecutivi, essi saranno usati e progressivamente
  incrementati per immagazzinare il numero di fotogramma (ad esempio
  "Animation_000.pic" diventa "Animation_001.pic", "Animation_002.pic", ecc.).
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
	txt_req_load      = 'Animation auswählen'
	txt_req_sel       = 'Format und Namensstamm auswählen'
	txt_err_abort     = 'Speichervorgang wurde abgebrochen'
	txt_err_save      = 'Fehler beim Speichern: '
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_req_load      = 'Selezionare animazione'
	txt_req_sel       = 'Selezionare formato e nome'
	txt_err_abort     = 'Operazione annullata'
	txt_err_save      = 'Errore nella scrittura: '
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO				/* English */
	txt_req_load      = 'Select Animation'
	txt_req_sel       = 'Select Format and Root Name'
	txt_err_abort     = 'User abort during save'
	txt_err_save      = 'Error during save: '
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
IF RESULT < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

LockGUI
GetFrames
frames = RESULT
IF frames = 0 THEN DO
	RequestFile '"'txt_req_load'"'
	IF RC = 0 THEN DO
		LoadAnimation RESULT 'NEW'
		GetFrames
		frames = RESULT
	END
END
IF frames > 0 THEN DO
	RequestFile '"'txt_req_sel'" SAVEMODE LISTFORMATS FORCE'
	IF RC = 0 THEN DO
		savedata = RESULT
		endf = INDEX(savedata, '"', 2)
		filename = SUBSTR(savedata, 2, endf - 2)
		filedata = SUBSTR(savedata, endf + 1)

		npos1 = INDEX(filename, '0')
		IF npos1 > 0 THEN DO
			ndigits = 1
			fnlen = LENGTH(filename)
			DO npos = npos1 + 1 TO fnlen
				IF SUBSTR(filename, npos, 1) = '0' THEN
					ndigits = ndigits + 1
				ELSE
					LEAVE
			END
		END

		GetFramePosition
		savepos = RESULT
		errcode = 0
		SetFramePosition 1
		DO fnum = 1 TO frames
			IF npos1 > 0 THEN
				fname = LEFT(filename, npos1 - 1) || RIGHT(fnum, ndigits, "0") || SUBSTR(filename, npos)
			ELSE
				fname = filename || "." || RIGHT(fnum, 3, "0")

			SaveImage '"'fname'"'filedata 'FORCE QUIET'
			IF RC ~= 0 THEN DO
				IF RC = 5 THEN
					errmess = txt_err_abort
				ELSE
					errmess = txt_err_save || RC
				errcode = RC
				LEAVE
			END
			SetFramePosition 'NEXT'
		END
		SetFramePosition savepos

		IF errcode > 0 THEN
			RequestNotify 'PROMPT "'errmess'"'
	END
END
UnlockGUI
