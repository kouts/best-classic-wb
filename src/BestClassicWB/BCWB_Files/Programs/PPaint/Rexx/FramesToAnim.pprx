/* Personal Paint Amiga Rexx script - Copyright © 1995-1998 Cloanto Italia srl */

/* $VER: FramesToAnim.pprx 1.3 */

/** ENG
  This script converts a set of separate image-files into an animation.
  The files must contain at least one numerical character.
  The sequence of numerical characters is used as frame counter
  (e.g.: if "Frame 0001.gif" is selected, this script tries to load it,
  then "Frame 0002.gif", and so on).
*/

/** DEU
  Dieses Skript dient zur Umwandlung einer Reihe von Einzelbildern in eine
  Animation. Wenn der Stamm des Dateinamens eine oder mehrere
  aufeinanderfolgende Zahlen enthält, werden diese zur Speicherung der
  Einzelbildnummer verwendet. Beispiel:  "Animation_000.pic" wird zu
  "Animation_001.pic", "Animation_002.pic", usw. Die Nummer des ersten
  Einzelbilders läßt sich individuell festlegen.
*/

/** ITA
  Questo script crea un'animazione partendo da un insieme di file di
  immagini separate. I file devono contenere almeno un carattere numerico.
  La sequenza di caratteri numerici viene usata come contatore di fotogrammi
  (es.: selezionando "Frame 0001.gif", lo script legge questo file,
  quindi "Frame 0002.gif", e cosi' via).
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
	txt_req_sel       = 'Erstes Bild der Sequenz angeben'
	txt_err_badname   = 'Ungültiger Name'
	txt_err_abort     = 'Ladevorgang wurde abgebrochen'
	txt_err_load      = 'Fehler beim Laden: '
	txt_err_oldclient = 'Für dieses Skript_ist eine neuere Version_von Personal Paint erforderlich'
END
ELSE IF RESULT = 2 THEN DO	/* Italiano */
	txt_req_sel       = 'Selezionare primo fotogramma'
	txt_err_badname   = 'Nome fotogramma non valido'
	txt_err_abort     = 'Operazione annullata'
	txt_err_load      = 'Errore nella lettura: '
	txt_err_oldclient = 'Questa procedura richiede_una versione più recente_di Personal Paint'
END
ELSE DO				/* English */
	txt_req_sel       = 'Select First Frame of Sequence'
	txt_err_badname   = 'Invalid frame name'
	txt_err_abort     = 'User abort during load'
	txt_err_load      = 'Error during load: '
	txt_err_oldclient = 'This script requires a newer_version of Personal Paint'
END

Version 'REXX'
rexxversion = RESULT
IF rexxversion < 7 THEN DO
	RequestNotify 'PROMPT "'txt_err_oldclient'"'
	EXIT 10
END

IF rexxversion < 4 THEN DO
	FreeBrush
	IF RC ~= 0 THEN
		EXIT RC
	bshfname = 'T:pprx_bsh.'PRAGMA('ID')
	IF OPEN(bshfile, bshfname, 'W') THEN DO
		WRITECH(bshfile, '464F524D 0000002A 494C424D 424D4844 00000014 00010001 00000000 01020100 00001010 028001E0 424F4459 00000002 FF00'X)
		CALL CLOSE(bshfile)
		LoadBrush bshfname 'FORCE'
	END
END

LockGUI
RequestFile '"'txt_req_sel'"'
IF RC = 0 THEN DO
	errcode = 0
	ndigits = 0
	loadname = RESULT

	fnpos = MAX(LASTPOS('/', loadname), LASTPOS(':', loadname), 1)

	npos1 = VERIFY(loadname, '0123456789', 'M', fnpos)
	IF npos1 > 0 THEN DO
		ndigits = 1
		fnlen = LENGTH(loadname)
		DO npos = npos1 + 1 TO fnlen
			IF VERIFY(loadname, '0123456789', 'M', npos) = npos THEN
				ndigits = ndigits + 1
			ELSE
				LEAVE
		END
	END

	IF ndigits = 0 THEN DO
		errmess = txt_err_badname
		errcode = 1000
	END
	ELSE DO
		name1 = SUBSTR(loadname, 2, npos1 - 2)
		name2 = SUBSTR(loadname, npos1 + ndigits, fnlen - npos1 - ndigits)
		fnum = SUBSTR(loadname, npos1, ndigits)

		DO FOREVER
			AddFrames		/* add one frame */
			SetFramePosition 'NEXT'
			fname = name1 || RIGHT(fnum, ndigits, "0") || name2
			LoadImage '"'fname'" FORCE QUIET'
			IF RC ~= 0 THEN DO
				IF RC = 5 THEN
					errmess = txt_err_abort
				ELSE IF RC ~= 36 THEN
					errmess = txt_err_load || RC

				IF RC ~= 36 THEN errcode = RC

				DeleteFrames	/* delete current (unused) frame */
				OptimizeAnimation 'QUIET'
				LEAVE
			END
			fnum = fnum + 1
		END
	END
	IF errcode > 0 THEN
		RequestNotify 'PROMPT "'errmess'"'
END
UnlockGUI

IF rexxversion < 4 THEN DO
	FreeBrush 'FORCE'
	ADDRESS COMMAND 'Delete >NIL: 'bshfname
END
